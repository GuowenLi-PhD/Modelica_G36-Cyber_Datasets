"""
This is testing script for auto-modeling and simulation of threats in python fmu.

Author: Yangyang Fu
Email: yangyang.fu@tamu.edu
Revisions:
    11/18/2020: Added script outline
"""

# import pydymola for dymola fmu generation
#from pydymola.pydymola import dymola

# import parser
from parsing import parser

# import pyfmi for loading fmu
from pyfmi import load_fmu

# import pythreat
from threat import ThreatInjection
from threat import Threat
from temporal import Temporal
from temporal import Signal
# import others
import numpy as np
import pandas as pd
import matplotlib
matplotlib.use('agg')
import matplotlib.pyplot as plt


# 1. write a modelica template model
model = "FaultInjection.SystemIBPSA.CyberAttack.BaselineSystem"
# the faultinjection library is already in MODELICAPATH, 
# otherwise put libray path here.
model_path = [] 
# 2. generate fmu wrapper
#fmu_path= parser.export_fmu(model, file_name = model_path,simulator='dymola')
fmu_path='wrapped.fmu'
# 3. list of input signals to be overwritten - to-be-improved
# This could be automatically parsed using fmu
wrapper = load_fmu(fmu_path)
inputs  = wrapper.get_model_variables(causality = 2).keys()
parameters  = wrapper.get_model_variables(causality = 0).keys()

# Get fmu inputs, distinguish signal and activate
input_names = [name for name in inputs if name.endswith("_u")]
parameter_names = [name for name in parameters if name.endswith("_p")]

# Get input properties
oveSig={}
params_start = {}
for name in input_names+parameter_names:
    unit = wrapper.get_variable_unit(name)
    mini = wrapper.get_variable_min(name)
    maxi = wrapper.get_variable_max(name)
    oveSig[name] = Signal(name,mini, maxi, unit)
    #parameter start value
    params_start[name] = wrapper.get_variable_start(name)

## 4. we have to manually construct threats based on wrapped fmu model
v_name = 'oveTZonResReq_u'
thr = Threat(active = False, 
            start_threat = 207*24*3600.+12*3600,
            end_threat= 207*24*3600.+12*3600 + 3*3600,
            temporal = Temporal(oveSig[v_name],'max'),
            injection = 'v')
v2_name = 'oveTSetChiWatSup_u'
thr2 = Threat(active = True, 
            start_threat = 207*24*3600.+12*3600,
            end_threat= 207*24*3600.+12*3600 + 3*3600,
            temporal = Temporal(oveSig[v2_name],'max'),
            injection = 'v')

# parameter threat
p_name = 'oveTCooOn_p'
thr3 = Threat(active = True, 
            start_threat = 207*24*3600.+13*3600,
            end_threat= 207*24*3600.+13*3600 + 2*3600,
            temporal = Temporal(oveSig[p_name],'constant',k=273.15+26),
            injection = 'p')

## 5. generate threats input objects 
# 5.0 check if any threat is activated
exp_start = 207*24*3600
exp_period = 24*3600
exp_end = exp_start + exp_period
exp_step = 24*3600.

inj_step = 2*60.

thr_lis = [thr,thr2,thr3]
nlen = len(thr_lis)

# initialize clock
ts = exp_start

#initlialize fmu settings
options = wrapper.simulate_options()
options['initialize'] = True
options['ncp'] = 500.

#initialize outputs
time = []
TZonResReq = []
TSupAir = []
TZone_cor = []
TZoneSet_cor = []

# some functions
def separate_threats(threat_list):
    threat_list_v = []
    threat_list_p = []
    
    for thr in threat_list:
        if thr.injection == 'v':
            threat_list_v.append(thr)
        elif thr.injection == 'p':
            threat_list_p.append(thr)
        else:
            raise ValueError('Unknown injection type: '+thr.injection)

    return threat_list_v, threat_list_p


def stack_input_objects(threat_list,ts,te,inj_step):
    names = []
    values = []
    if threat_list:
        for i, thr in zip(range(len(threat_list)),threat_list):
            thr_inj = ThreatInjection(threat=thr,
                                    start_time=ts, 
                                    end_time=te,
                                    step=inj_step) 
            input_object = thr_inj.overwrite()
            # stack all variable-injection threat for inputs
            names += input_object[0]
            if i<1:
                values = input_object[1]
            else:
                values = np.hstack((values,input_object[1][:,1:]))

        input_objects = (names, values)       
    else:
        input_objects = None

    return input_objects

def divide_simulations(input_objects_p):
    """
    A method that divides a simulation into smaller time-step simulation based on the needs of 
    Modelica parameter changes

    :param:
        input_object_p: input objects for parameter type threat injection. Output from `stack_input_objects`.

    :return:
        DataFrame. A dataframe containing the start time and ending time of each smaller-step simulation as indexes, and 
                values and overwrite status for each parameter.
    """
    input_sig_df_t = pd.DataFrame()
    if input_objects_p:
        names = input_objects_p[0]
        values = input_objects_p[1]
        timeindexes = values[:,0]
        
        # construct a data frame
        input_df = pd.DataFrame(values[:,1:],index=timeindexes, columns=names)
        #print input_df

        # get activation schedule matrix
        name_act = []
        name_sig = []
        for name in names:
            if '_activate' in name: # find activate schedule
                # append them into a single 
                name_act.append(name)
            else:
                name_sig.append(name)
        input_act_df = input_df[name_act]
        #print input_act_df

        # maybe a hash table for exacting smaller simulation periods
        t = [timeindexes[0]]
        for i,it in zip(range(len(timeindexes)),timeindexes):
            if it not in t:
                # check if the activation matrix is the same as previous step
                if not np.array_equal(input_act_df.iloc[[i-1]].values,input_act_df.iloc[[i]].values):
                    t.append(it)
            # add the stop time to the end no matter what
            if i==len(timeindexes)-1 and it not in t:
                t.append(it)

        # get the parameter value and overwrite activation status at each smaller simulation
        input_sig_df_t = input_df.loc[t]        
    else: 
        pass
    
    return input_sig_df_t 

def extract_active_threats(threat_list):
    active_threats = []
    for thr in threat_list:
        if thr.active:
            active_threats.append(thr)
    return active_threats

# analyze only active threats
act_thr_list = extract_active_threats(thr_lis)
thr_lis_v, thr_lis_p = separate_threats(act_thr_list)
print thr_lis_v
print thr_lis_p
# main loop
while ts < exp_end:
    te = ts + exp_step

    # Get input objects for variable overwriting
    input_objects_v = stack_input_objects(thr_lis_v,ts,te,inj_step)
    print input_objects_v

    input_objects_p = stack_input_objects(thr_lis_p,ts,te,inj_step)
    print input_objects_p

    # need divide the simulation into smaller time steps 
    # due to the needs of parameter changes in current time step
    if input_objects_p:
        t_para=divide_simulations(input_objects_p)
        print t_para

        smaller_steps = t_para.index
        column_names = t_para.columns
        for step in enumerate(smaller_steps[:-1]):
            ts_small = step[1]
            te_small = smaller_steps[step[0]+1]
            # perform simulation for current time step
            for name in column_names:
                if name.endswith('_p'):
                    p_value = t_para.loc[ts_small][name]
                    p_value_start = params_start[name]
                    ove_name = name.split('_p')[0]+'_activate'
                    ove_status = t_para.loc[ts_small][ove_name]
                    if ove_status:
                        wrapper.set(name,p_value)
                    else:
                        wrapper.set(name,p_value_start)

            res_small = wrapper.simulate(ts_small,te_small, options=options, input=input_objects_v)

            time_ts = res_small['time']
            TZonResReq_ts = res_small['mod.conAHU.uZonTemResReq']
            TSupAir_ts = res_small['mod.TSup.T']
            TZone_cor_ts = res_small['mod.conVAVCor.TZon']
            TZoneSet_cor_ts = res_small['mod.conVAVCor.TZonCooSet']

            time += list(time_ts)
            TZonResReq += list(TZonResReq_ts)
            TSupAir += list(TSupAir_ts)
            TZone_cor += list(TZone_cor_ts)
            TZoneSet_cor += list(TZoneSet_cor_ts)

            options['initialize'] = False
    else:
        res = wrapper.simulate(ts,te, options=options, input=input_objects_v)

        # get some outputs
        time_ts = res['time']
        TZonResReq_ts = res['mod.conAHU.uZonTemResReq']
        TSupAir_ts = res['mod.TSup.T']
        TZone_cor_ts = res['mod.conVAVCor.TZon']
        TZoneSet_cor_ts = res['mod.conVAVCor.TZonCooSet']

        time += list(time_ts)
        TZonResReq += list(TZonResReq_ts)
        TSupAir += list(TSupAir_ts)
        TZone_cor += list(TZone_cor_ts)
        TZoneSet_cor += list(TZoneSet_cor_ts)
        
    # update fmu settings
    options['initialize'] = False
    #  update clock
    ts += exp_step

fig=plt.figure(figsize=(12,9))
fig.add_subplot(311)
plt.plot(time, TZonResReq)
plt.ylabel('Zone Temperature\nReset Requests')
plt.ylim([-1,21])
plt.xticks(np.arange(exp_start,exp_end,4*3600),[])

fig.add_subplot(312)
plt.plot(time,np.array(TZone_cor)-273.15,label='measurement') 
plt.plot(time,np.array(TZoneSet_cor)-273.15,label='setpoint') 
plt.ylabel('TZone [C]')
plt.ylim([10,32])
plt.xticks(np.arange(exp_start,exp_end,4*3600),[])

fig.add_subplot(313)
plt.plot(time,np.array(TSupAir)-273.15) 
plt.ylabel('TSA [C]')
plt.ylim([10,32])
plt.xticks(np.arange(exp_start,exp_end,4*3600),np.arange(0,25,4))

plt.savefig("testcase.pdf")
plt.savefig("testcase.png")