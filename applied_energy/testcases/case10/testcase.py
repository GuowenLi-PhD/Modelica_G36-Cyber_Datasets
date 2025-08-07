"""
This is testing script for auto-modeling and simulation of threats in python fmu.

Author: Yangyang Fu
Email: yangyang.fu@tamu.edu
Revisions:
    12/15/2020: Added script
"""

# import parser
from pysimulate.simulation_manager import cases

# import pythreat
from pythreat.threat import ThreatInjection
from pythreat.threat import Threat
from pythreat.temporal import Temporal

# import others
import numpy as np
import matplotlib
matplotlib.use('agg')
import matplotlib.pyplot as plt
import os

### Specify Modelica template model
## ===============================================================
# write a modelica template model
model = "template.BaselineSystem"
# the faultinjection library is already in MODELICAPATH, 
# otherwise put libray path here.
model_path = []

### Initialize a simulation case
## =============================================================
##
case = cases(template = model,
            template_path = model_path,
            simulator = 'dymola')

### Experiment setup
## ============================================================
exp_start = 207*24*3600
exp_period = 24*3600
exp_end = exp_start + exp_period
exp_step = 24*3600.
inj_step = 2*60.

case.start_time = exp_start
case.final_time = exp_end
case.step = exp_step
case.injection_step = inj_step

### Generate a wrapper FMU or specify the location of wrapper fmu
## ==============================================================
#case.generate_wrapper()
# or load existing wrapper fmu
case.wrapper_fmu_path ='wrapped.fmu'
case.load_fmu()

### Parse FMU overwritten signals
## ==============================================================
oveSig, staSig = case.parse_signal()

### Construct injected threats
## ==============================================================
v1_name = 'oveTZonResReq_u'
thr1 = Threat(active = False, 
            start_threat = 207*24*3600.+12*3600,
            end_threat= 207*24*3600.+12*3600 + 3*3600,
            temporal = Temporal(oveSig[v1_name],'max'),
            injection = 'v')
v2_name = 'oveChiOn_u'            
thr2 = Threat(active = False, 
            start_threat = 207*24*3600.+12*3600,
            end_threat= 207*24*3600.+12*3600 + 3*3600,
            temporal = Temporal(oveSig[v2_name],'square',amplitude=1.,period=1800,offset=0),
            injection = 'v')

v3_name = 'oveTSetChiWatSup_u'
thr3 = Threat(active = True, 
            start_threat = 207*24*3600.+10*3600,
            end_threat= 207*24*3600.+10*3600 + 3*3600,
            temporal = Temporal(oveSig[v3_name],'block'),
            injection = 'v')

# parameter threat
p1_name = 'oveTCooOn_p'
thr4 = Threat(active = True, 
            start_threat = 207*24*3600.+13*3600,
            end_threat= 207*24*3600.+13*3600 + 2*3600,
            temporal = Temporal(oveSig[p1_name],'constant',k=273.15+22),
            injection = 'p')

thr_lis = [thr1,thr2,thr3,thr4]

case.threat_list = thr_lis
### FMU simulation options
## ================================================================
#
options = case.wrapper.simulate_options()
options['ncp'] = 500.

case.fmu_options=options

#initialize outputs
time = []
TZonResReq = []
TSupAir = []
TZoneCor= []
TZoneSetCor = []

### Start simulation 
## ==================================================================
case.simulate()
results = case.result

### Simulate baseline
## ===================================================================
case.baseline()
results_base = case.result_baseline

### Get some measurements and plots
## ===================================================================
meas_list = ['time',
            'mod.conAHU.uZonTemResReq',
            'mod.TSup.T',
            'mod.conVAVCor.TZon',
            'mod.conVAVCor.TZonCooSet',
            'mod.conAHU.TSupSet',
            'mod.conVAVCor.yDam',
            'mod.conVAVCor.VDis_flow',
            'mod.fanSup.y',
            'mod.watVal.y',
            'mod.chiWSE.TSet',
            'mod.TCHWSup.T',
            'mod.eleCoiVAV.y',
            'mod.eleSupFan.y',
            'mod.eleChi.y',
            'mod.eleCHWP.y',
            'mod.eleCWP.y',
            'mod.eleCT.y',
            'mod.eleHWP.y',
            'mod.eleTot.y'
            ]
# get results from threat-injected system
measurement = {}
for meas in meas_list:
    result = []
    for res in results:
        result += list(res[meas])
    measurement[meas] = result

time = measurement['time']
TZonResReq = measurement['mod.conAHU.uZonTemResReq']
TSupAir = measurement['mod.TSup.T']
TZonCor = measurement['mod.conVAVCor.TZon']
TZonSetCor = measurement['mod.conVAVCor.TZonCooSet']
TSupAirSet = measurement['mod.conAHU.TSupSet']
yDamVAVCor= measurement['mod.conVAVCor.yDam']
VDisFloVAVCor = measurement['mod.conVAVCor.VDis_flow']
speSupFan = measurement['mod.fanSup.y']
yValCooCoi = measurement['mod.watVal.y']
TCHWSet = measurement['mod.chiWSE.TSet']
TCHW = measurement['mod.TCHWSup.T']

eleCoiVAV = measurement['mod.eleCoiVAV.y']
eleSupFan = measurement['mod.eleSupFan.y']
eleChi = measurement['mod.eleChi.y']
eleCHWP = measurement['mod.eleCHWP.y']
eleCWP = measurement['mod.eleCWP.y']
eleCT = measurement['mod.eleCT.y']
eleHWP = measurement['mod.eleHWP.y']
eleTot = measurement['mod.eleTot.y']

# get baseline results
measurement_base = {}
for meas in meas_list:
    result = []
    for res in results_base:
        result += list(res[meas])
    measurement_base[meas] = result

time_base = measurement_base['time']
TZonResReq_base = measurement_base['mod.conAHU.uZonTemResReq']
TSupAir_base = measurement_base['mod.TSup.T']
TZonCor_base = measurement_base['mod.conVAVCor.TZon']
TZonSetCor_base = measurement_base['mod.conVAVCor.TZonCooSet']
TSupAirSet_base = measurement_base['mod.conAHU.TSupSet']
yDamVAVCor_base = measurement_base['mod.conVAVCor.yDam']
VDisFloVAVCor_base = measurement_base['mod.conVAVCor.VDis_flow']
speSupFan_base = measurement_base['mod.fanSup.y']
yValCooCoi_base = measurement_base['mod.watVal.y']
TCHWSet_base = measurement_base['mod.chiWSE.TSet']
TCHW_base = measurement_base['mod.TCHWSup.T']

eleCoiVAV_base = measurement_base['mod.eleCoiVAV.y']
eleSupFan_base = measurement_base['mod.eleSupFan.y']
eleChi_base = measurement_base['mod.eleChi.y']
eleCHWP_base = measurement_base['mod.eleCHWP.y']
eleCWP_base = measurement_base['mod.eleCWP.y']
eleCT_base = measurement_base['mod.eleCT.y']
eleHWP_base = measurement_base['mod.eleHWP.y']
eleTot_base = measurement_base['mod.eleTot.y']

# plots
folder = "results"
if not os.path.exists(folder):
    os.mkdir(folder)

fig = plt.figure(figsize=(12,12))
fig.add_subplot(521)
plt.plot(np.array(time_base), np.array(TZonResReq_base), 'b-', linewidth=1)
plt.plot(np.array(time),np.array(TZonResReq),'r-', linewidth=1) # 
plt.ylabel('Zone Temperature\nReset Requests')
plt.ylim([-1,16])
plt.legend(['Baseline','Attack'])
plt.xticks(np.arange(exp_start,exp_end,4*3600),[])

fig.add_subplot(522)
plt.plot(np.array(time_base), np.array(TSupAirSet_base)-273.15, 'b-', linewidth=1)
plt.plot(np.array(time),np.array(TSupAirSet)-273.15,'r-', linewidth=1) # 
plt.ylabel('TSA Set [C]')
plt.ylim([10,25])
plt.legend(['Baseline', 'Attack'])
plt.xticks(np.arange(exp_start,exp_end,4*3600),[])

fig.add_subplot(523)
plt.plot(np.array(time_base), np.array(TSupAir_base)-273.15, 'b-', linewidth=1)
plt.plot(np.array(time),np.array(TSupAir)-273.15,'r-', linewidth=1) #
plt.ylabel('TSA [C]')
plt.ylim([10,25])
plt.legend(['Baseline', 'Attack'])
plt.xticks(np.arange(exp_start,exp_end,4*3600),[])

fig.add_subplot(524)
plt.plot(np.array(time_base), np.array(TZonCor_base)-273.15, 'b-', linewidth=1)
plt.plot(np.array(time_base), np.array(TZonSetCor_base)-273.15, 'b--', linewidth=1)
plt.plot(np.array(time),np.array(TZonCor)-273.15,'r-', linewidth=1) # 
plt.plot(np.array(time),np.array(TZonSetCor)-273.15,'r--', linewidth=1) # 
plt.ylabel('Zone Temperature [C]')
plt.ylim([20,30])
plt.legend(['Baseline', 'Baseline Setpoint','Attacked', 'Attacked Setpoint'])
plt.xticks(np.arange(exp_start,exp_end,4*3600),[])

fig.add_subplot(525)
plt.plot(np.array(time_base), np.array(yDamVAVCor_base), 'b-', linewidth=1)
plt.plot(np.array(time),np.array(yDamVAVCor),'r-', linewidth=1) #
plt.ylabel('Core Zone VAV Damper')
plt.ylim([-0.1,1.1])
plt.legend(['Baseline','Attack'])
plt.xticks(np.arange(exp_start,exp_end,4*3600),[])

fig.add_subplot(526)
plt.plot(np.array(time_base), np.array(VDisFloVAVCor_base), 'b-', linewidth=1)
plt.plot(np.array(time),np.array(VDisFloVAVCor),'r-', linewidth=1) #
plt.ylabel('Core Zone Air Flow [m3/s]')
plt.ylim([-0.1,2.1])
plt.legend(['Baseline', 'Attack'])
plt.xticks(np.arange(exp_start,exp_end,4*3600),[])

fig.add_subplot(527)
plt.plot(np.array(time_base), np.array(speSupFan_base), 'b-', linewidth=1)
plt.plot(np.array(time),np.array(speSupFan),'r-', linewidth=1) #
plt.ylabel('Supply Fan Speed')
plt.ylim([-0.1,1.1])
plt.legend(['Baseline', 'Attack'])
plt.xticks(np.arange(exp_start,exp_end,4*3600),[])

fig.add_subplot(528)
plt.plot(np.array(time_base), np.array(yValCooCoi_base), 'b-', linewidth=1)
plt.plot(np.array(time),np.array(yValCooCoi),'r-', linewidth=1) #
plt.ylabel('Cooling Coil Valve')
plt.ylim([-0.1,1.1])
plt.legend(['Baseline', 'Attack'])
plt.xticks(np.arange(exp_start,exp_end,4*3600),[])

fig.add_subplot(529)
plt.plot(np.array(time_base), np.array(TCHWSet_base)-273.15, 'b-', linewidth=1)
plt.plot(np.array(time),np.array(TCHWSet)-273.15,'r-', linewidth=1) # 
plt.ylabel('TCHWS Set [C]')
plt.ylim([4,16])
plt.legend(['Baseline', 'Attack'])
plt.xticks(np.arange(exp_start,exp_end,4*3600),np.arange(0,25,4))
plt.xlabel('Hours')

fig.add_subplot(5,2,10)
plt.plot(np.array(time_base), np.array(TCHW_base)-273.15, 'b-', linewidth=1)
plt.plot(np.array(time),np.array(TCHW)-273.15,'r-', linewidth=1) #
plt.ylabel('TCHWS [C]')
plt.ylim([4,15])
plt.legend(['Baseline', 'Attack'])
plt.xticks(np.arange(exp_start,exp_end,4*3600),np.arange(0,25,4))
plt.xlabel('Hours')

plt.savefig("./results/states.svg")
plt.savefig("./results/states.pdf")
plt.savefig("./results/states.png")

# plot fo power
fig = plt.figure(figsize=(12,12))
fig.add_subplot(421)
plt.plot(np.array(time_base), np.array(eleCoiVAV_base)/1000, 'b-', linewidth=1)
plt.plot(np.array(time),np.array(eleCoiVAV)/1000,'r-', linewidth=1) # 
plt.ylabel('Reheat VAV [kW]')
#plt.ylim([20,30])
plt.legend(['Baseline', 'Attack'])
plt.xticks(np.arange(exp_start,exp_end,4*3600),[])

fig.add_subplot(422)
plt.plot(np.array(time_base), np.array(eleSupFan_base)/1000, 'b-', linewidth=1)
plt.plot(np.array(time),np.array(eleSupFan)/1000,'r-', linewidth=1) #
plt.ylabel('Supply Fan [kW]')
#plt.ylim([0,1])
plt.legend(['Baseline', 'Attack'])
plt.xticks(np.arange(exp_start,exp_end,4*3600),[])

fig.add_subplot(423)
plt.plot(np.array(time_base), np.array(eleChi_base)/1000, 'b-', linewidth=1)
plt.plot(np.array(time),np.array(eleChi)/1000,'r-', linewidth=1) #
plt.ylabel('Chiller [kW]')
#plt.ylim([0,2])
plt.legend(['Baseline', 'Attack'])
plt.xticks(np.arange(exp_start,exp_end,4*3600),[])

fig.add_subplot(424)
plt.plot(np.array(time_base), np.array(eleCHWP_base)/1000, 'b-', linewidth=1)
plt.plot(np.array(time),np.array(eleCHWP)/1000,'r-', linewidth=1) #
plt.ylabel('Chilled Water Pump [kW]')
#plt.ylim([0,1])
plt.legend(['Baseline', 'Attack'])
plt.xticks(np.arange(exp_start,exp_end,4*3600),[])

fig.add_subplot(425)
plt.plot(np.array(time_base), np.array(eleCWP_base)/1000, 'b-', linewidth=1)
plt.plot(np.array(time),np.array(eleCWP)/1000,'r-', linewidth=1) #
plt.ylabel('Condenser Water Pump [kW]')
#plt.ylim([4,12])
plt.legend(['Baseline', 'Attack'])
plt.xticks(np.arange(exp_start,exp_end,4*3600),[])

fig.add_subplot(426)
plt.plot(np.array(time_base), np.array(eleCT_base)/1000, 'b-', linewidth=1)
plt.plot(np.array(time),np.array(eleCT)/1000,'r-', linewidth=1) #
plt.ylabel('Cooling Tower [kW]')
#plt.ylim([0,1.1])
plt.legend(['Baseline', 'Attack'])
plt.xticks(np.arange(exp_start,exp_end,4*3600),[])

fig.add_subplot(427)
plt.plot(np.array(time_base), np.array(eleHWP_base)/1000, 'b-', linewidth=1)
plt.plot(np.array(time),np.array(eleHWP)/1000,'r-', linewidth=1) #
plt.ylabel('Hot Water Pump [kW]')
#plt.ylim([10,20])
plt.legend(['Baseline', 'Attack'])
plt.xticks(np.arange(exp_start,exp_end,4*3600),np.arange(0,25,4))
plt.xlabel('Hours')

fig.add_subplot(428)
plt.plot(np.array(time_base), np.array(eleTot_base)/1000, 'b-', linewidth=1)
plt.plot(np.array(time),np.array(eleTot)/1000,'r-', linewidth=1) #
plt.ylabel('Total Power [kW]')
#plt.ylim([0,100])
plt.legend(['Baseline', 'Attack'])
plt.xticks(np.arange(exp_start,exp_end,4*3600),np.arange(0,25,4))
plt.xlabel('Hours')

plt.savefig("./results/power.svg")
plt.savefig("./results/power.pdf")
plt.savefig("./results/power.png")
