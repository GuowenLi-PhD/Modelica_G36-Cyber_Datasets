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
# import others
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
                fmu_options = None):
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
        self.fmu_options = fmu_options

        self.wrapper_fmu_path = ''
        self.result = []

        self.wrapper = None
        
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
                                simulator=self.simulator)
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
                ori_sig_name ='mod.'+name.split('_u')[0]+'.y'

                # read the value from simulation results
                if self.result:
                    sig_prev_value = self.result[-1].final(ori_sig_name)
                else: # this should be improved by accessing initialization results for the very first step
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
                b_value_prev = self._signal_previous[name].values()[0]
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
                        if ove_status:
                            self.wrapper.set(name,p_value)
                        else:
                            self.wrapper.set(name,p_value_start)
                    # else if block is detected as variable injection
                # get variable-type threats inputs under block attack
                input_objects_b = self.get_blocked_signal_input_objects(t_para,names_blocked,ts_small,te_small)

                # slice variable input objects for smaller steps
                input_objects_v_small=self.extract_input_objects(input_objects_v,ts_small,te_small)

                # combine for total variable injection
                input_objects_vb = self.combine_input_objects([input_objects_v_small,input_objects_b])

                res_small = self.wrapper.simulate(ts_small,te_small, options=options, input=input_objects_vb)
                self.result += [res_small]

                # need get a blocked signal from last time step calculation
                self.get_signal_prev(names_blocked)

                # update initialization
                options['initialize'] = False
        else:
            res = self.wrapper.simulate(start_step, end_step, options=options, input=input_objects_v)
            self.result += [res]

    def simulate(self):
        """
        Simulate over an experiment

        """
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
        
        # reset states before main loop
        self.wrapper.reset()

        # fmu options
        options = self.fmu_options
        options['initialize'] = True

        # initialize model before simulation
        while ts < self.final_time:
            print ("====================================================\n")
            print ("========= Simulation starts at "+str(ts)+" =========\n")

            te = min(ts+exp_step, self.final_time)
            # do step
            self.do_step(threat_list = [thr_lis_v, thr_lis_b, thr_lis_p],
                        start_step = ts,
                        end_step = te,
                        options = options)   

            # update fmu settings if any
            options['initialize'] = False
            #  update clock
            ts += exp_step
        # maybe add some error handling functions here

    def baseline(self):
        # reset fmu to initial states
        self.wrapper_baseline = load_fmu(self.wrapper_fmu_path)
        # no need to pass any inputs for baseline fmu
        # main loop
        ts = self.start_time
        te = self.final_time
        # fmu options
        options = self.fmu_options
        options['initialize'] = True
        res = self.wrapper_baseline.simulate(ts, te, options=options)
        self.result_baseline = [res]
