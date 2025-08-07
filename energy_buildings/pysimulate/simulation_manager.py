"""
Implements a simulation manager for threat injection into a Modelica model

The steps are
1) generate a fmu wrapper, and get the names of the inputs/parameters to-be-overwritten. 
2) preprocess threat list
    2.1) use active threats only
    2.2) separate parameter-type and variable-type threats
3) main dostep loop
    3.1) generate corrupted signal
    3.2) update wrapper fmu settings
    3.3) do simulations 
    3.4) save results
"""
# import from future to make Python2 behave like Python3
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals
from future import standard_library
standard_library.install_aliases()
from builtins import *
from io import open
# end of from future import

# import parser
from parsing import parser
# import pyfmi for loading fmu
from pyfmi import load_fmu
# import pythreat
from pythreat.threat import ThreatInjection
from pythreat.threat import Threat
from pythreat.temporal import Temporal
from pythreat.temporal import Signal
# import kpi calculator
from kpis.kpi_fmu import KPI_Calculator 
from kpis.kpi_demand_flexibility import DF_Calculator 
from kpis.data_processor import interpolate_dataframe
# import kpi cost calculator
from pyscore.score import KPICost
# import others
from collections import OrderedDict
import numpy as np
import pandas as pd

class cases(object):
    """
    Class that defines a simulation case

    """
    def __init__(self,template,
                template_path,
                measurement_list=[],
                threat_list=[],
                start_time=0.,
                final_time=3600.,
                step=1800.,
                simulator = 'dymola',
                injection_step = 120.,
                calculate_kpi = True,
                fmu_options = None,
                kpi_names = [],
                measurement_names = [],
                kpi_step = 1800.,
                dT_max = 4.,
                P_max = 40000):
        """
        Initialize a case object

        :param template: name of Modelica template
        :type template: str
        :param template_path: path of Modelica template
        :type template_path: str
        :param measurement_list: names of key measurements, defaults to []
        :type measurement_list: list, optional
        :param threat_list: list of Threat objects, defaults to []
        :type threat_list: list, optional
        :param start_time: experiment start time, defaults to 0
        :type start_time: float, optional
        :param final_time: experiment end time, defaults to 3600.
        :type final_time: float, optional
        :param step: experiment time step, defaults to 1800.
        :type step: float, optional
        :param simulator: Modelica simulator, defaults to 'dymola'
        :type simulator: str, optional
        :param injection_step: threat signal injection time step, defaults to 120.
        :type injection_step: float, optional
        :param fmu_options: fmi simulation options, defaults to None
        :type fmu_options: fmi options, optional
        """
        self.model = template
        self.model_path = template_path
        self.threat_list = threat_list
        self.measurement_list = measurement_list
        self.start_time = start_time
        self.final_time = final_time
        self.step = step
        self.simulator = simulator
        self.injection_step = 120.
        self.calculate_kpi = calculate_kpi
        self.fmu_options = fmu_options
        self.kpi_step = kpi_step
        self.kpi_calculator = KPI_Calculator(kpi_names = kpi_names,
                                            measurement_names = measurement_names)
        self.df_calculator = DF_Calculator()
        self.kpi_cost_calculator = KPICost(dT_max=dT_max,
                                        dt = self.kpi_step,
                                        P_max = P_max,
                                        KPIs_step = pd.DataFrame())
        self.wrapper_fmu_path = ''
        self.result = []

        self.wrapper = None
        # kpis 
        self.kpis = pd.DataFrame()
        # demand flexibility
        self.dfs = pd.DataFrame()
        # kpi cost
        self.kpis_cost = pd.DataFrame()

        # error handling
        if not fmu_options:
            Warning('No fmu simulation options is specified. Default settings will be used.')
    
    def load_fmu(self):
        """
        Load fmu from pyfmi

        :return: fmu instance
        :rtype: fmu object
        """

        self.wrapper = load_fmu(self.wrapper_fmu_path)
        return self.wrapper

    def generate_wrapper(self):
        """
        Generate a Modelica wrapper model and translate into fmu

        :return: fmu 
        :rtype: fmu object
        """        

        print("\n========================================================")
        print(" Gnerating a Modelica and FMU wrapper model")
        
        fmu_path = parser.export_fmu(self.model, 
                                file_name = self.model_path,
                                simulator=self.simulator,
                                output_directory = self.model_path[0])
        self.wrapper_fmu_path = fmu_path
        fmu = self.load_fmu()

        print("\n=========================================================")
        print(" Modelica and FMU wrapper models are successfully generated.")
        print("=========================================================\n")

        return fmu

    def parse_signal(self):
        """
        Parse overwritten signal

        :return: instances of Signal object, start values of instances of Signal object
        :rtype: Tuple, (dict, dict)
        """
        # parse fmu to get parameters and variables to be overwritten
        inputs  = self.wrapper.get_model_variables(causality = 2).keys()
        parameters  = self.wrapper.get_model_variables(causality = 0).keys()

        # Get fmu inputs, distinguish signal and activate
        input_names = [name for name in inputs if name.endswith("_u")]
        parameter_names = [name for name in parameters if name.endswith("_p")]
        # Get input properties
        self._overwrite_signal={} # overwritten signal
        self._start_signal = {} # start value of written signal if any

        for name in input_names+parameter_names:
            unit = self.wrapper.get_variable_unit(name)
            mini = self.wrapper.get_variable_min(name)
            maxi = self.wrapper.get_variable_max(name)
            self._overwrite_signal[name] = Signal(name,mini, maxi, unit)
            self._start_signal[name] = self.wrapper.get_variable_start(name)

        return self._overwrite_signal, self._start_signal

    def extract_active_threats(self):
        """
        Extract threats that are active from a list of threats

        :return: a list of active threats
        :rtype: List
        """
        self.active_threats = []
        for thr in self.threat_list:
            if thr.active:
                self.active_threats.append(thr)
        return self.active_threats

    def separate_threats(self,threat_list=[]):
        """
        Separate threats into variable-type and parameter-type

        :param threat_list: a list of threats, defaults to []
        :type threat_list: list, optional
        :raises ValueError: Unknown injection type
        :return: list of varibale-type threats and list of parameter-type threats
        :rtype: Tuple, (list, list)
        """

        threat_list_v = []
        threat_list_b = []        
        threat_list_p = []
        
        for thr in threat_list:
            if thr.injection == 'v':
                if thr.temporal.attacker.upper() == 'BLOCK':
                    threat_list_b.append(thr)
                else:
                    threat_list_v.append(thr)

            elif thr.injection == 'p':
                threat_list_p.append(thr)
            else:
                raise ValueError('Unknown injection type: '+thr.injection)

        return threat_list_v, threat_list_b, threat_list_p
    
    def stack_input_objects(self,threat_list,ts,te):
        """
        Stack input objects

        :param threat_list: a list of threats
        :type threat_list: list
        :param ts: step start time
        :type ts: float
        :param te: step end time
        :type te: float
        :return: fmu input objects
        :rtype: Tuple
        """

        names = []
        values = []
        if threat_list:
            for i, thr in zip(range(len(threat_list)),threat_list):
                thr_inj = ThreatInjection(threat=thr,
                                        start_time=ts, 
                                        end_time=te,
                                        step=self.injection_step) 
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

    def divide_simulations(self,input_objects_p):
        """
        A method that divides a simulation into smaller time-step simulation based on the needs of 
        Modelica parameter changes and the needs of accessing blocked signal from last time step.

        :param input_objects_p: input objects for parameter type threat injection. 
                    Output from `stack_input_objects`.
        :type input_objects_p: fmu input object
        :return: A dataframe containing the start time and ending time of each smaller-step simulation as indexes, and 
                    values and overwrite status for each parameter.
        :rtype: pandas DataFrame
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
            input_sig_df = input_df[name_sig]
            #print input_act_df

            # maybe a hash table for extracting smaller simulation periods
            t = [timeindexes[0]]
            for i,it in zip(range(len(timeindexes)),timeindexes):
                if it not in t:
                    # check if the activation matrix is the same as previous step - detect parameter overwritting
                    # check if the signal matrix is the same as previous step - in case parameter changes during injection
                    if not np.array_equal(input_act_df.iloc[[i-1]].values,input_act_df.iloc[[i]].values) or not np.array_equal(input_sig_df.iloc[[i-1]].values,input_sig_df.iloc[[i]].values):
                        t.append(it)
                # add the stop time to the end no matter what
                if i==len(timeindexes)-1 and it not in t:
                    t.append(it)

            # get the parameter value and overwrite activation status at each smaller simulation
            input_sig_df_t = input_df.loc[t]        
        else: 
            pass
        
        return input_sig_df_t 

    def combine_input_objects(self, input_objects_list):
        names = []
        values = []
        # remove None type
        lis = list(filter(None,input_objects_list))

        if lis:
            for i, obj in zip(range(len(lis)),lis):
                names += obj[0]
                if i<1:
                    values = obj[1]
                else:
                    # need check if the size is equal
                    values = np.hstack((values,obj[1][:,1:]))
            input_objects = (names, values)
        else:
            input_objects = None

        return input_objects

    def extract_input_objects(self,input_objects,ts,te):
        """Extract a specific period of a long fmi input object

        :param input_objects: fmi input objects, (names,values). 
        :type input_objects: [type]
        :param ts: [description]
        :type ts: [type]
        :param te: [description]
        :type te: [type]
        """
        if input_objects:
            # need firt check if [ts,te] is in the period

            # get a dataframe with time array as the index
            values_pd = pd.DataFrame(input_objects[1][:,1:],index=input_objects[1][:,0])
            # slice the values for current small step
            input_objects_small = (input_objects[0],values_pd.loc[ts:te,:].reset_index().values)
        else:
            input_objects_small = None

        return input_objects_small

    def get_signal_prev(self,names):
        
        sig_prev = {}
        for name in names:
            if name.endswith('_u'):
                # get orignal signal name
                ori_sig_name ='mod.'+name.split('_u')[0].replace('_','.')+'.y'

                # read the value from simulation results
                if hasattr(self, 'result_step'):
                    if self.result_step:
                        sig_prev_value = self.result_step[-1].final(ori_sig_name)
                    else: # this should be improved by accessing initialization results for the very first step
                        sig_prev_value = 0
                else:
                    sig_prev_value = 0
                # save as a nested dictionary
                sig_prev[name]={ori_sig_name:sig_prev_value}

        self._signal_previous = sig_prev

        return sig_prev

    def get_blocked_signal_input_objects(self,t_para,names,ts,te):

        names_blocked = []
        values=np.array([])

        for name in names:
            if name.endswith('_u'):
                #b_value = t_para.loc[ts_small][name]
                b_value_prev = list(self._signal_previous[name].values())[0]
                ove_name = name.split('_u')[0]+'_activate'
                ove_status = t_para.loc[ts][ove_name]
                # generate a new input object for block signal at current small time step
                tarray = np.arange(ts,te,self.injection_step)
                if te not in tarray:
                    tarray = np.append(tarray,te)
                b_array = b_value_prev*np.ones(tarray.size)
                #b_array[-1] = t_para.loc[te][name]
                ove_status_array = np.array([ove_status]*tarray.size)
                #ove_status_array[-1] = t_para.loc[te][ove_name]

                # append all block signal into one input_objects
                names_blocked += [name,ove_name]
                if not values.size:
                    values = np.array([b_array,ove_status_array]).transpose()
                else:
                    values = np.hstack((values,np.array([b_array,ove_status_array]).transpose()))

        # After collecting all the inputs being blocked, generate a fmi input object
        if not values.size: # there are no signals to be blocked
            input_objects_b = None
        else:
            # add time index to values to conform to the format of fmi input objects
            input_objects_b = (names_blocked, np.hstack((np.array([tarray]).transpose(),values)))

        return input_objects_b

    def do_step(self,threat_list,start_step, end_step,options):
        """
        Advance simulation by one step

        :param threat_list: list of threats
        :type threat_list: list
        :param start_step: step start time
        :type start_step: float
        :param end_step: step end time
        :type end_step: float
        :param options: fmu simulation options
        :type options: fmu simulation options
        """
        # Get input objects for variable overwriting
        thr_lis_v, thr_lis_b, thr_lis_p = threat_list
 
        input_objects_v = self.stack_input_objects(thr_lis_v,start_step,end_step)
        input_objects_b = self.stack_input_objects(thr_lis_b,start_step,end_step)        
        input_objects_p = self.stack_input_objects(thr_lis_p,start_step,end_step)
 
        input_objects_pb = self.combine_input_objects([input_objects_p,input_objects_b])

        # get blocked signal names
        names_blocked =  input_objects_b[0] if input_objects_b else []

        # get blocked signal from previous time step
        self.get_signal_prev(names_blocked)

        # initialize outputs
        self.result_step = []

        if input_objects_pb:
            # get smaller steps for parameter changes and blocked signal
            t_para=self.divide_simulations(input_objects_pb)
            smaller_steps = t_para.index
            column_names = t_para.columns
            # main loop inside current step using smaller steps
            for step in enumerate(smaller_steps[:-1]):
                ts_small = step[1]
                te_small = min(smaller_steps[step[0]+1],end_step)
                # perform simulation for current time step
                # inject parameter-type threats
                for name in column_names:
                    # if parameter injection is detected
                    if name.endswith('_p'):
                        p_value = t_para.loc[ts_small][name]
                        p_value_start = self._start_signal[name]
                        ove_name = name.split('_p')[0]+'_activate'
                        ove_status = t_para.loc[ts_small][ove_name]
                        if ove_status: # if overwrite fault is activated
                            self.wrapper.set(name,p_value)
                        else: # if overwrite parameter is not activated
                            ## need add the following code to 
                            ## avoid unchangeable Modelica parameter for demand flexibility calculation                            
                            if not self.calculate_kpi:
                                self.wrapper.set(name,p_value_start)
                    # else if block is detected as variable injection
                # get variable-type threats inputs under block attack
                input_objects_b = self.get_blocked_signal_input_objects(t_para,names_blocked,ts_small,te_small)

                # slice variable input objects for smaller steps
                input_objects_v_small=self.extract_input_objects(input_objects_v,ts_small,te_small)

                # combine for total variable injection
                input_objects_vb = self.combine_input_objects([input_objects_v_small,input_objects_b])
                res_small = self.wrapper.simulate(ts_small,te_small, options=options, input=input_objects_vb)
                #print (res_small['mod.oveTCooOn.p'])
                self.result_step += [res_small]
                # need get a blocked signal from last time step calculation
                self.get_signal_prev(names_blocked)

                # update initialization
                options['initialize'] = False
        else:
            res = self.wrapper.simulate(start_step, end_step, options=options, input=input_objects_v)
            self.result_step = [res]

    def simulate(self):
        """
        Simulate over an experiment

        """
        # Initialize outputs
        if self.calculate_kpi:
            self.result_down = []
            self.result_up = []

        # parse overwritten signals
        #self.parse_signal()

        # check if threatened signals correctly inputted by users.

        # parse threat list
        self.extract_active_threats()
        active_threats = self.extract_active_threats()
        thr_lis_v, thr_lis_b, thr_lis_p = self.separate_threats(active_threats)

        # main loop
        ts = self.start_time
        exp_step = self.step
        kpi_step = self.kpi_step
        # set step
        step = kpi_step if self.calculate_kpi else exp_step

        # reset states before main loop
        self.wrapper.reset()

        # fmu options
        options = self.fmu_options
        options['initialize'] = True
        # add output variable filter
        #options['filter'] = self.kpi_calculator.filter

        # get the start value of zone temperture setpoint for demand flexibility use
        TCooOn_start = self.wrapper.get_variable_start('oveTCooOn_p')
        i = 0
        # initialize model before simulation
        while ts < self.final_time:
            print ("====================================================\n")
            print ("========= Simulation starts at "+str(ts)+" =========\n")
            
            # set step end time
            te = min(ts+step, self.final_time)
            # get system states
            states = self.wrapper.get_fmu_state()

            #############################################################
            #### The following codes are for demand flexibility calculation
            #### This part is HARD-CODED by using zone temperature reset as 
            #### the strategy for procuring demand flexibility.
            ##########################################################
            if self.calculate_kpi:
                # downward
                # initialize at the first step
                if i<1:
                    options['initialize'] = True
                # run downwrad simulation
                self.wrapper.set_fmu_state(states)
                self.wrapper.set('oveTCooOn_p',273.15+26)
                self.do_step(threat_list = [thr_lis_v, thr_lis_b, thr_lis_p],
                        start_step = ts,
                        end_step = te,
                        options = options)   
                self.result_down_step = self.result_step         
                # upward
                # initialize at the first step
                if i<1:
                    options['initialize'] = True
                # run upwrad simulation
                self.wrapper.time = ts
                self.wrapper.set_fmu_state(states)
                self.wrapper.set('oveTCooOn_p',273.15+22)
                self.do_step(threat_list = [thr_lis_v, thr_lis_b, thr_lis_p],
                        start_step = ts,
                        end_step = te,
                        options = options)  
                self.result_up_step = self.result_step  

            #################################################### 
            # baseline without demand flexibility calculation
            ########################################################
            # initialize at the first step
            if i<1:
                options['initialize'] = True            
            self.wrapper.time = ts
            self.wrapper.set_fmu_state(states)   
            self.wrapper.set('oveTCooOn_p',TCooOn_start) # this required especially for df calculation     
            self.do_step(threat_list = [thr_lis_v, thr_lis_b, thr_lis_p],
                        start_step = ts,
                        end_step = te,
                        options = options)   
            self.result += self.result_step

            # update fmu settings if any
            options['initialize'] = False
            #  update clock
            ts += step

            ### get kpis
            ###=========================================================
            if self.calculate_kpi:
                # get core kpis
                data_buff = self.transform_data_buff(self.result_step)
                self.kpis_step = self.get_kpis(ts,data_buff)
                self.kpis = self.kpis.append(self.kpis_step)
                print ("\n==================================================")
                print ("========== KPIs at step "+str(ts)+ ": =======")
                # Set the maximum number of columns to display to None (i.e., display all columns)
                pd.set_option('display.max_columns', None)
                print (self.kpis_step)
            
                # get demand flexibility
                # need get total electricity power
                power_up = self.transform_data_buff(self.result_up_step)
                power_down = self.transform_data_buff(self.result_down_step)
                power_base = self.transform_data_buff(self.result_step)
                self.get_demand_flexibility(ts, power_up, power_down, power_base)
                self.dfs = self.dfs.append(self.df_step)
                print ("\n==================================================")
                print ("========== DF at step "+str(ts)+ ": =======")
                print (self.df_step)
            
                # calculate kpi costs
                # update kpi_step if any changes
                self.kpi_cost_calculator.dt = self.kpi_step
                kpi_cost_data = self.kpis_step
                for col in self.df_step.columns:
                    kpi_cost_data[col] = self.df_step[col]

                kpis_cost_step = self.get_kpis_cost(kpi_cost_data)
                self.kpis_cost = self.kpis_cost.append(kpis_cost_step)
                print ("\n==================================================")
                print ("========== KPI Costs at step "+str(ts)+ ": =======")
                print (kpis_cost_step)

            i += 1
        # maybe add some error handling functions here

    def get_average_total_elec(self,data_buff):
        """Get average electric power at each time step

        :param data_buff: [description]
        :type data_buff: [type]
        :return: [description]
        :rtype: [type]
        """
        self.df_calculator.data_buff = data_buff
        return self.df_calculator.get_average_total_electric_power()   
    
    def get_demand_flexibility(self, time, power_up, power_down, power_base):
        """This method gets the demand flexibility based on given fmu simulation results

        :param time: [description]
        :type time: [type]
        :param power_up: [description]
        :type power_up: [type]
        :param power_down: [description]
        :type power_down: [type]
        :param power_base: [description]
        :type power_base: [type]
        :return: [description]
        :rtype: [type]
        """
        # get average power demand for current time step
        power=pd.DataFrame()
        power['ave_down']= [self.get_average_total_elec(power_down)]
        power['ave_up']= [self.get_average_total_elec(power_up)]
        power['ave_bas'] = [self.get_average_total_elec(power_base)]

        # get the downward and upward differences
        power['up'] = power['ave_up'] - power['ave_bas']
        power['down'] = power['ave_bas'] - power['ave_down']
        power.index=[time]
        self.df_step = power[['up','down']]

        return self.df_step
 
    def transform_data_buff(self,res_lis):
        # Not correct if current kpi step is divided into multiple smaller steps
        # Merge fmu results
        result={}
        for key in res_lis[0].keys():
            result[key]=[]

        if len(res_lis)>1: # smaller steps are generated
            for res in res_lis:
                for key in res.keys():
                    result[key] += list(res[key])
        else:
            result = res_lis[0]
        return result

    def get_kpis(self,time,data_buff):
        """Get predefined kpis
        """
        # data buff
        self.kpi_calculator.data_buff = data_buff
        ckpi = self.kpi_calculator.get_core_kpis()
        
        return self.convert_dict_to_df(ckpi,[time])

    def get_kpis_cost(self,kpis_step):
        """Get predefined cost for kpis
        """
        # data buff
        self.kpi_cost_calculator.KPIs_step = kpis_step
        time = kpis_step.index[-1]
        kpis_cost = self.kpi_cost_calculator.get_KPICost()
        
        return self.convert_dict_to_df(kpis_cost,[time])

    def convert_dict_to_df(self,ordered_dict,index):
        """Convert ordered dictionary to data frame
        """
        new_dic = {}
        for key in ordered_dict.keys():
            if isinstance(ordered_dict[key],dict):
                for subkey in ordered_dict[key].keys():
                    new_key = key+'_'+subkey
                    new_dic[new_key] = ordered_dict[key][subkey]
            else:
                new_dic[key] = ordered_dict[key]
        return pd.DataFrame(new_dic,index=index)



