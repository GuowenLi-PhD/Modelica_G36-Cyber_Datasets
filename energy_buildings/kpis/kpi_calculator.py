'''
Created on Dec 2020

This module contains the KPI_Calculator class with methods for processing 
the results of fault simulations and generating the corresponding key 
performance indicators.

'''
import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from scipy.integrate import trapz
from flask._compat import iteritems
from collections import OrderedDict
import scipy.interpolate as interpolate
import os
import json
import math
import sys
from buildingspy.io.outputfile import Reader

class KPI_Calculator(object):
    '''This class calculates the KPIs as a post-process
    ''' 

    def __init__(self, data_buff):
        '''Initialize the KPI_Calculator class. 
        
        Parameters
        ----------
        data_buff: the output object after the BuildingSpy reads the result .mat file.
        For example, data_buff=Reader('Baseline.mat','dymola')
        '''
        
        # Naming convention from the signal exchange package of IBPSA
        #Add EquipmentEfficiency, EquimentOnOff, Ventilation,ControlOutput,ControlSetpoint
        self.sources = ['AirZoneTemperature',
                        'RadiativeZoneTemperature',
                        'OperativeZoneTemperature',
                        'RelativeHumidity',
                        'CO2Concentration',
                        'ElectricPower',
                        'DistrictHeatingPower',
                        'GasPower',
                        'BiomassPower',
                        'SolarThermalPower', 
                        'FreshWaterFlowRate',
                        'EquipmentOnOff',
                        'EquipmentEfficiency',
                        'ControlOutput',
                        'ControlSetpoint']
        
        # initialize the data buffer
        self.data_buff=data_buff
        
        # JSON file 
        with open("kpis.json", "r") as json_data:
            self.kpi_json = json.loads(json_data.read())

        
        #Occupancy start hour and end hour
        self.start_Occ = 7
        self.end_Occ = 18
    
    def get_core_kpis(self, price_scenario='Constant'):
        '''Return the core KPIs of a test case.
        
        Parameters
        ----------
        price_scenario : str, optional
            Price scenario for cost kpi calculation.  
            'Constant' or 'Dynamic' or 'HighlyDynamic'.
            Default is 'Constant'.
            
        Returns 
        -------
        ckpi = dict
            Dictionary with the core KPIs, i.e., the KPIs
            that are considered essential for the comparison between
            two test cases
            
        '''
        ckpi = OrderedDict()

        # Postprocessing KPIs
        ckpi['timdis_tot']=self.get_unmet_hour()
        ckpi['tdis_tot'] = self.get_thermal_discomfort()
        ckpi['dT_max_dict']=self.get_max_temperature_deviation()
        ckpi['idis_tot'] = self.get_iaq_discomfort()
        ckpi['ener_tot'] = self.get_energy(plot=True)
        ckpi['cost_tot'] = self.get_cost(scenario=price_scenario)
        #ckpi['emis_tot'] = self.get_emissions()        
        ckpi['pow_dvf'] = self.get_diversity_factor()
        ckpi['pow_lf'] = self.get_load_factors()
        ckpi['pow_peak'] = self.get_power_peaks()
        ckpi['timequ_ope']=self.get_equiment_operation_time()
        ckpi['oar_hou']=self.get_oar_hourly()        
        ckpi['cqfs_TSup']=self.get_control_quality_factors()   

        return ckpi

    def interp(self, t_old,x_old,t_new,columns):
        #Return the interpolated dataframe
        
    	intp = interpolate.interp1d(t_old, x_old, kind='linear')
    	x_new = intp(t_new)
    	x_new = pd.DataFrame(x_new, index=t_new, columns=columns)
    	return x_new

    def filter_Occ(self, index, narray):
        '''Return the array after filtering out the non-operation data
        
        Parameters
        ----------
        index: Original time array
        array: Original array of the variable 
        Returns 
        -------
        array_Occ: Filtered array of the variable
        '''
        index_Occ_remainder=np.array(index)/3600%24
        array_Occ=narray[np.logical_and(index_Occ_remainder>=self.start_Occ, \
                                       index_Occ_remainder<=self.end_Occ)]
        return array_Occ
        
    def get_thermal_discomfort(self,  plot=False):
        '''The thermal discomfort is the integral of the deviation 
        of the temperature with respect to the predefined comfort 
        setpoint. Its units are of K*h.
        
        Parameters
        ----------
        plot: boolean, optional
            True to show a donut plot with the thermal discomfort metrics.
            Default is False.
            
        Returns
        -------
        tdis_tot: float
            total thermal discomfort accounted in this test case

        '''
        
        index=self.data_buff.values('TSup.T')[0]
        
        tdis_tot = 0
        tdis_dict = OrderedDict()
        
        for source in self.kpi_json.keys():
            if source.startswith('AirZoneTemperature') or \
               source.startswith('OperativeZoneTemperature'):
                # This is a potential source of thermal discomfort
                zone_id = source.split('[')[1][:-1]
                
                for signal in self.kpi_json[source]:
                    # Load temperature set points from test case data
                    LowerSetp = 23 + 273.15
                    UpperSetp = 25 + 273.15                 
                    data = np.array(self.data_buff.values(signal)[1])
                    dT_lower = LowerSetp - data
                    dT_lower[dT_lower<0]=0
                    dT_upper = data - UpperSetp
                    dT_upper[dT_upper<0]=0
                    
                    # Filter the temperature deviation dataframe to the occupancy hour
                    index_Occ=self.filter_Occ(index, np.array(index))
                    dT_lower_Occ=self.filter_Occ(index, dT_lower)
                    dT_upper_Occ=self.filter_Occ(index, dT_upper)
                    # Set the border value on the occupancy hour value to zero 
                    dT_lower_Occ[(index_Occ/3600%24==self.start_Occ) | (index_Occ/3600%24==self.end_Occ)]=0
                    dT_upper_Occ[(index_Occ/3600%24==self.start_Occ) | (index_Occ/3600%24==self.end_Occ)]=0
                    
                    tdis_dict[signal[:-1]+'dTlower_y'] = \
                        trapz(dT_lower_Occ,index_Occ)/3600.
                    tdis_dict[signal[:-1]+'dTupper_y'] = \
                        trapz(dT_upper_Occ,index_Occ)/3600.
                    tdis_tot = tdis_tot + \
                              tdis_dict[signal[:-1]+'dTlower_y'] + \
                              tdis_dict[signal[:-1]+'dTupper_y']
        
        self.tdis_tot  = tdis_tot
        self.tdis_dict = tdis_dict
            
        if plot:
            self.tdis_tree = self.get_dict_tree(tdis_dict)
            self.plot_nested_pie(self.tdis_tree, metric='discomfort',
                                 units='Kh', breakdonut=False)
        
        return tdis_tot


    def get_max_temperature_deviation(self):
        '''The maximum deviation of temperature unmet in the operating hours 
       is maximum absolute value of the lower bound temperature deviation and
       the upper bound temperature deviation.Its units is of K. The occur time is in the unit of s.
        
        Parameters
        ----------
        plot: boolean, optional
            True to show a donut plot with the thermal discomfort metrics.
            Default is False.
            
        Returns
        -------
        dT_max_dict: dictionary 
            dictionary of the maximum deviation of temperature unmet for different signals
            each item is a tuple:(maximum temperature deviation, occur time)
        '''
        
        index=self.data_buff.values('TSup.T')[0]
        
        
        dT_max_dict = OrderedDict()
        

        for source in self.kpi_json.keys():
            if source.startswith('AirZoneTemperature') or \
               source.startswith('OperativeZoneTemperature'):
                # This is a potential source of thermal discomfort
                zone_id = source.split('[')[1][:-1]
                
                for signal in self.kpi_json[source]:
                    # Load temperature set points from test case data
                    LowerSetp = 23 + 273.15
                    UpperSetp = 25 + 273.15                 
                    data = np.array(self.data_buff.values(signal)[1])
                    dT_lower = LowerSetp - data
                    dT_lower[dT_lower<0]=0
                    dT_upper = data - UpperSetp
                    dT_upper[dT_upper<0]=0

                    # Filter the temperature deviation dataframe to the occupancy hour
                    index_Occ=self.filter_Occ(index, np.array(index))
                    dT_lower_Occ=self.filter_Occ(index, dT_lower)
                    dT_upper_Occ=self.filter_Occ(index, dT_upper)
                    # Set the border value on the occupancy hour value to zero 
                    dT_lower_Occ[(index_Occ/3600%24==self.start_Occ) | (index_Occ/3600%24==self.end_Occ)]=0
                    dT_upper_Occ[(index_Occ/3600%24==self.start_Occ) | (index_Occ/3600%24==self.end_Occ)]=0
                    
                    #Calculate the maximum lower bound temperature deviation and occur time
                    dT_lower_max=max(dT_lower_Occ)
                    tim_lower_max=index_Occ[dT_lower_Occ==max(dT_lower_Occ)].tolist()
                    #Calculate the maximum upper bound temperature deviation and occur time
                    dT_upper_max=max(dT_upper_Occ)
                    tim_upper_max=index_Occ[dT_upper_Occ==max(dT_upper_Occ)].tolist()
                    #Calculate the overall maximum temperature deviation and occur time
                    dT_max=max(dT_lower_max,dT_upper_max)
                    tim_dT_max=tim_lower_max if dT_lower_max>dT_upper_max else tim_upper_max
                    #Tuple of (maximum temperature deviation, occur time)
                    dT_max_dict[signal[:-1]+'[dT_max,tim_dT_max]']=(dT_max,list(set(tim_dT_max)))
                    
        self.dT_max_dict = dT_max_dict
            
        return dT_max_dict    

    
    
    def get_unmet_hour(self, plot=False):
        '''The unmet hours are the sum of the operating hours 
        of which the temperature is outside the predefined comfort 
        setpoint. Its units are of h. This function can also give unmet fraction,
        that is the ratio of the unmet hours and the total operating hours
        
        Parameters
        ----------
        plot: boolean, optional
            True to show a donut plot with the thermal discomfort metrics.
            Default is False.
            
        Returns
        -------
        tim_unmet_tot: float
            total unmet hour accounted in this test case

        '''
        
        index=self.data_buff.values('TSup.T')[0]
        
        tim_unmet_tot = 0
        tim_unmet_dict = OrderedDict()
        

        for source in self.kpi_json.keys():
            if source.startswith('AirZoneTemperature') or \
               source.startswith('OperativeZoneTemperature'):
                # This is a potential source of thermal discomfort
                zone_id = source.split('[')[1][:-1]
                
                for signal in self.kpi_json[source]:
                    # Load temperature set points from test case data
                    LowerSetp = 23 + 273.15
                    UpperSetp = 25 +273.15                  
                    data = np.array(self.data_buff.values(signal)[1])
                    dT_lower = LowerSetp - data
                    dT_upper = data - UpperSetp

                    
                    # Filter the temperature deviation dataframe to the occupancy hour
                    index_Occ=self.filter_Occ(index, np.array(index))
                    dT_lower_Occ=self.filter_Occ(index, dT_lower)
                    dT_upper_Occ=self.filter_Occ(index, dT_upper)
                        
                    #Resample to 1-minute data
                    index_Occ_new=np.arange(index_Occ[0], index_Occ[-1]+1, 60)
                    index_Occ_new=self.filter_Occ(index_Occ_new, index_Occ_new)
                    df_dT_lower_Occ = self.interp(index_Occ, dT_lower_Occ, index_Occ_new,['dT_lower_Occ'])
                    df_dT_upper_Occ = self.interp(index_Occ, dT_upper_Occ, index_Occ_new,['dT_upper_Occ'])
                    
                    #Calculate the unmet hour for the outer-lower and outer-upper bounds
                    tim_unmet_dict[signal[:-1]+'timlower_y'] = \
                        float(df_dT_lower_Occ[df_dT_lower_Occ['dT_lower_Occ']>0].count())/60.
                    tim_unmet_dict[signal[:-1]+'timupper_y'] = \
                        float(df_dT_upper_Occ[df_dT_upper_Occ['dT_upper_Occ']>0].count())/60.
                    tim_Occ_tot =len(index_Occ_new)/60*len(self.kpi_json[source])
                    tim_unmet_tot = tim_unmet_tot + \
                              tim_unmet_dict[signal[:-1]+'timlower_y'] + \
                              tim_unmet_dict[signal[:-1]+'timupper_y']
                              
        self.tim_Occ_tot=tim_Occ_tot                     
        self.tim_unmet_tot  = tim_unmet_tot
        self.unmet_fraction=round(tim_unmet_tot/tim_Occ_tot,3)
        self.tim_unmet_dict = tim_unmet_dict
            
        if plot:
            self.tim_unmet_tree = self.get_dict_tree(tim_unmet_dict)
            self.plot_nested_pie(self.tim_unmet_tree, metric='discomfort',
                                 units='hour', breakdonut=False)
        
        return tim_unmet_tot    
    
        
    def get_iaq_discomfort(self, plot=False):
        '''The IAQ discomfort is the integral of the deviation 
        of the CO2 concentration with respect to the predefined comfort 
        setpoint. Its units are of ppm*h.
        
        Parameters
        ----------
        plot: boolean, optional
            True to show a donut plot with the iaq discomfort metrics.
            Default is False.
            
        Returns
        -------
        idis_tot: float
            total IAQ discomfort accounted in this test case

        '''
            
        index=self.data_buff.values('TSup.T')[0]
        
        idis_tot = 0
        idis_dict = OrderedDict()
        
        for source in self.kpi_json.keys():
            if source.startswith('CO2Concentration'):
                # This is a potential source of iaq discomfort
                zone_id = source.replace('CO2Concentration[','')[:-1]
                
                for signal in self.kpi_json[source]:
                    # Load CO2 set points from test case data
                    UpperSetp = 1000                   
                    data = np.array(self.data_buff.values(signal)[1])
                    dI_upper = data - UpperSetp
                    dI_upper[dI_upper<0]=0
                    idis_dict[signal[:-1]+'dIupper_y'] = \
                        trapz(dI_upper,self.data_buff.values('TSup.T')[0])/3600.
                    idis_tot = idis_tot + \
                              idis_dict[signal[:-1]+'dIupper_y']
        
        self.idis_tot  = idis_tot
        self.idis_dict = idis_dict
            
        if plot:
            self.idis_tree = self.get_dict_tree(idis_dict)
            self.plot_nested_pie(self.idis_tree, metric='IAQ discomfort',
                                 units='ppmh', breakdonut=False)
        
        return idis_tot
    
    def get_energy(self,plot=False, plot_by_source=False):
        '''This method returns the measure of the total building 
        energy use in kW*h when accounting for the sum of all 
        energy vectors present in the test case. 
        
        Parameters
        ----------
        plot: boolean, optional
            True to show a donut plot with the energy use 
            grouped by elements.
            Default is False.
        plot_by_source: boolean, optional
            True to show a donut plot with the energy use 
            grouped by sources.
            Default is False.
               
        Returns
        -------
        ener_tot: float
            total energy use
            
        '''

            
        ener_tot = 0
        # Dictionary to store energy usage by element
        ener_dict = OrderedDict()
        # Dictionary to store energy usage by source 
        ener_dict_by_source = OrderedDict()
        
        # Calculate total energy from power 
        # [returns KWh - assumes power measured in Watts]
        for source in self.sources:
            if 'Power' in source  and \
            source in self.kpi_json.keys():            
                for signal in self.kpi_json[source]:
                    pow_data = np.array(self.data_buff.values(signal)[1])
                    ener_dict[signal+'_y'] = \
                        trapz(pow_data,
                              self.data_buff.values('TSup.T')[0])*2.77778e-7 # Convert to kWh
                    ener_dict_by_source[source+'_'+signal+'_y'] = \
                        ener_dict[signal+'_y']
                    ener_tot = ener_tot + ener_dict[signal+'_y']
                    
        # Assign to case       
        self.ener_tot            = ener_tot
        self.ener_dict           = ener_dict
        self.ener_dict_by_source = ener_dict_by_source
           
        if plot:
            self.ener_tree = self.get_dict_tree(ener_dict) 
            self.plot_nested_pie(self.ener_tree, metric='energy use',
                                 units='kWh')
        if plot_by_source:
            self.ener_tree_by_source = self.get_dict_tree(ener_dict_by_source) 
            self.plot_nested_pie(self.ener_tree_by_source, 
                                 metric='energy use by source', units='kWh')
        
        return ener_tot
    
    def get_cost(self, scenario='Constant', plot=False,
                 plot_by_source=False):
        '''This method returns the measure of the total building operational
        energy cost in euros when accounting for the sum of all energy
        vectors present in the test case as well as other sources of cost
        like water. 
        
        Parameters
        ----------
        scenario: string, optional
            There are three different scenarios considered for electricity:
            1. 'Constant': completely constant price
            2. 'Dynamic': day/night tariff
            3. 'HighlyDynamic': spot price changing every 15 minutes.
            Default is 'Constant'.
        plot: boolean, optional
            True to show a donut plot with the operational cost 
            grouped by elements.
            Default is False.
        plot_by_source: boolean, optional
            True to show a donut plot with the operational cost 
            grouped by sources.
            Default is False.
            
        Notes
        -----
        It is assumed that power is measured in Watts and water usage in m3
            
        '''
            
        cost_tot = 0
        # Dictionary to store operational cost by element
        cost_dict = OrderedDict()
        # Dictionary to store operational cost by source 
        cost_dict_by_source = OrderedDict()
        # Define time index
        index=self.data_buff.values('TSup.T')[0]
        
        for source in self.sources:
            
            # Calculate the operational cost from electricity in this scenario
            if 'ElectricPower' in source  and \
            source in self.kpi_json.keys(): 
                # This can be further improved
                electricity_price_data = 0.2 
                for signal in self.kpi_json[source]:
                    pow_data = np.array(self.data_buff.values(signal)[1])
                    cost_dict[signal] = \
                        trapz(np.multiply(electricity_price_data,pow_data),
                              self.data_buff.values('TSup.T')[0])*2.77778e-7 # Convert to kWh
                    cost_dict_by_source[source+'_'+signal] = \
                        cost_dict[signal]
                    cost_tot = cost_tot + cost_dict[signal]
                    
            # Calculate the operational cost from other power sources        
            elif 'Power' in source  and \
            source in self.kpi_json.keys(): 
                # Load the source price data
                source_price_data = 0.07         
                for signal in self.kpi_json[source]:
                    pow_data = np.array(self.data_buff.values(signal)[1])
                    cost_dict[signal] = \
                        trapz(np.multiply(source_price_data,pow_data),
                              self.data_buff.values('TSup.T')[0])*2.77778e-7 # Convert to kWh
                    cost_dict_by_source[source+'_'+signal] = \
                        cost_dict[signal]
                    cost_tot = cost_tot + cost_dict[signal]       
                    
            # Calculate the operational cost from other sources        
            elif 'FreshWater' in source  and \
            source in self.kpi_json.keys(): 
                # load the source price data
                source_price_data = \
                np.array(self.data_manager.get_data(index=index)\
                         ['Price'+source])            
                for signal in self.kpi_json[source]:
                    pow_data = np.array(self.data_buff.values(signal)[1])
                    cost_dict[signal] = \
                        trapz(np.multiply(source_price_data,pow_data),
                              self.data_buff.values('TSup.T')[0])
                    cost_dict_by_source[source+'_'+signal] = \
                        cost_dict[signal]
                    cost_tot = cost_tot + cost_dict[signal]                      
                    
        # Assign to case       
        self.cost_tot            = cost_tot
        self.cost_dict           = cost_dict
        self.cost_dict_by_source = cost_dict_by_source
        
        if plot:
            self.cost_tree = self.get_dict_tree(cost_dict) 
            self.plot_nested_pie(self.cost_tree, metric='cost',
                                 units='euros')
        if plot_by_source:
            self.cost_tree_by_source = self.get_dict_tree(cost_dict_by_source) 
            self.plot_nested_pie(self.cost_tree_by_source, 
                                 metric='cost by source', units='euros')
         
        return cost_tot

    def get_emissions(self, plot=False, plot_by_source=False):
        '''This method returns the measure of the total building 
        emissions in kgCO2 when accounting for the sum of all 
        energy vectors present in the test case. 
        
        Parameters
        ----------
        plot: boolean, optional
            True if it it is desired to make plots related with
            the emission metric.
            Default is False.
        plot_by_source: boolean, optional
            True to show a donut plot with the operational cost 
            grouped by sources.
            Default is False.
            
        Notes
        -----
        It is assumed that power is measured in Watts 
            
        '''

        emis_tot = 0
        # Dictionary to store emissions by element
        emis_dict = OrderedDict()
        # Dictionary to store emissions by source 
        emis_dict_by_source = OrderedDict()
        # Define time index
        index=self.data_buff.values('TSup.T')[0]
        
        for source in self.sources:
            
            # Calculate the operational emissions from power sources        
            if 'Power' in source  and \
            source in self.kpi_json.keys(): 
                source_emissions_data = \
                np.array(self.data_manager.get_data(index=index)\
                         ['Emissions'+source])            
                for signal in self.kpi_json[source]:
                    pow_data = np.array(self.data_buff.values(signal)[1])
                    emis_dict[signal] = \
                        trapz(np.multiply(source_emissions_data,pow_data),
                              self.data_buff.values('TSup.T')[0])*2.77778e-7 # Convert to kWh
                    emis_dict_by_source[source+'_'+signal] = \
                        emis_dict[signal]
                    emis_tot = emis_tot + emis_dict[signal]                           
                    
        # Assign to case       
        self.emis_tot            = emis_tot
        self.emis_dict           = emis_dict
        self.emis_dict_by_source = emis_dict_by_source
        
        if plot:
            self.emis_tree = self.get_dict_tree(emis_dict) 
            self.plot_nested_pie(self.emis_tree, metric='emissions',
                                 units='kgCO2')
        if plot_by_source:
            self.emis_tree_by_source = self.get_dict_tree(emis_dict_by_source) 
            self.plot_nested_pie(self.emis_tree_by_source, 
                                 metric='emissions by source', units='kgCO2')
         
        return emis_tot



    def get_load_factors(self):
        '''Calculate the load factor for every power signal
        
        '''

            
        ldfs_dict = OrderedDict()
        
        for signal in self.kpi_json['ElectricPower']:
            pow_data = np.array(self.data_buff.values(signal)[1])
            max_pow = pow_data.max()
            #Positive data only
            pow_data=pow_data[pow_data>0]
            avg_pow = pow_data.mean()
            
            try:
                ldfs_dict[signal]=avg_pow/max_pow
            except ZeroDivisionError as err:
                print("Error: {0}".format(err))
                return
        
        self.ldfs_dict = ldfs_dict
    
        return ldfs_dict
    
    def get_diversity_factor(self):
        '''Calculate the diversity factor 
        
        '''
            
        ppks = OrderedDict()
        power_data_tot=0
        
        for signal in self.kpi_json['ElectricPower']:
            pow_data = np.array(self.data_buff.values(signal)[1])
            max_pow = pow_data.max()
            ppks[signal]=max_pow
            power_data_tot=power_data_tot+pow_data
        
        max_pow_tot=power_data_tot.max()
        max_pow=sum(ppks.values())
        try:
            dvf=max_pow/max_pow_tot
        except ZeroDivisionError as err:
            print("Error: {0}".format(err))
            return
        
        self.dvf = dvf
    
        return dvf
    
    
    def get_power_peaks(self):
        '''Calculate the power peak for all the equipment
        
        '''
            
        power_data_tot=0
        
        for signal in self.kpi_json['ElectricPower']:
            pow_data = np.array(self.data_buff.values(signal)[1])
            power_data_tot=power_data_tot+pow_data
            
        max_pow_tot=power_data_tot.max()
        
        self.max_pow_tot = max_pow_tot
            
        return max_pow_tot
    
    def get_equiment_operation_time(self, plot=False):
        
        #Calculate the equiment operation time for each equipment. Its unit is h.
        
            
        tim_equ_ope_dict = OrderedDict()
        
        for signal in self.kpi_json['EquipmentOnOff']:
            equ_onoff_data = np.array(np.ceil(self.data_buff.values(signal)[1]))
            tim_equ_ope_dict[signal+'_y'] = \
                trapz(equ_onoff_data,self.data_buff.values('TSup.T')[0])/3600.
        
        # Assign to case 
        self.tim_equ_ope_dict = tim_equ_ope_dict
              
        if plot:
            self.tim_equ_tree = self.get_dict_tree(tim_equ_ope_dict) 
            self.plot_nested_pie(self.tim_equ_tree, metric='equipment operation time',
                                 units='hour')
    
        return tim_equ_ope_dict

    def get_maximum_capacity_percentage(self):
        #Calculate the maximum capacity percentage for each equipment. 
        #Read capacity for each equipment from test resourcedataset. 
            
        # Define time index
        index=self.data_buff.values('TSup.T')[0]            
        cap_per_dict = OrderedDict()
        
        for signal in self.kpi_json['ElectricPower']:        
        # Load equipment capacities from test case data
            capcity_data = np.array(self.data_manager.get_data(index=index) \
                 ['Capcity_'+signal[-5:-2]])
            pow_data = np.array(self.data_buff.values(signal)[1])
            try:
                cap_per=pow_data/capcity_data
            except ZeroDivisionError as err:
                print("Error: {0}".format(err))
                return            
            cap_per_dict[signal]=cap_per.max()
            
        self.cap_per_dict = cap_per_dict
    
        return cap_per_dict                                    

    def get_average_capacity_percentage(self):
        #Calculate the average capacity percentage for each equipment. 
        #Read capacity for each equipment from test resourcedataset. 

            
        # Define time index
        index=self.data_buff.values('TSup.T')[0]            
        cap_per_dict = OrderedDict()
        
        for signal in self.kpi_json['ElectricPower']:        
        # Load equipment capacities from test case data
            capcity_data = np.array(self.data_manager.get_data(index=index) \
                 ['Capcity_'+signal[-5:-2]])
            pow_data = np.array(self.data_buff.values(signal)[1])
            try:
                cap_per=pow_data/capcity_data
            except ZeroDivisionError as err:
                print("Error: {0}".format(err))
                return            
            cap_per_dict[signal]=cap_per.mean()
            
        self.cap_per_dict = cap_per_dict
    
        return cap_per_dict

    def get_average_efficiency_percentage(self):
        #Calculate the average efficiency for each equipment.  
        
                     
        eff_dict = OrderedDict()
        
        for signal in self.kpi_json['EquipmentEfficiency']:        
        # Load equipment capacities from test case data
            eff_data = np.array(self.data_buff.values(signal)[1])
            eff_dict[signal]=eff_data.mean()
            
        self.eff_dict = eff_dict
    
        return eff_dict
              
    def get_oar_hourly(self):
        '''The average hourly OAR is the mean of the outdoor air ratio, which is 
        the actual outdoor air volumn and required outdoor air volumn
    
            
        Returns
        -------
        oar_tot: float
            average hourly OAR in this test case

        '''
        
        index=self.data_buff.values('TSup.T')[0]
        
        oar_tot = 0
        
        #tolerance
        tolerance = 0.001
        
        # 'vot' and 'voa' are two signals for the required OA and actual OA volume 
        vot = np.array(self.data_buff.values('conAHU.eco.VOutMinSet_flow_normalized')[1])
        voa = np.array(self.data_buff.values('conAHU.eco.VOut_flow_normalized')[1])

        # Filter the data to the occupancy hour
        index_Occ=self.filter_Occ(index, np.array(index))
        vot_Occ=self.filter_Occ(index, vot)
        voa_Occ=self.filter_Occ(index, voa)
        vot_Occ[np.isclose(vot_Occ, 0, atol=tolerance)]=0
        voa_Occ[np.isclose(voa_Occ, 0, atol=tolerance)]=0
        
        #Resample to 1-minute data
        index_Occ_new=np.arange(index_Occ[0], index_Occ[-1]+1, 60)
        index_Occ_new=self.filter_Occ(index_Occ_new, index_Occ_new)
        df_vot_Occ = self.interp(index_Occ, vot_Occ, index_Occ_new,['vot_Occ'])
        df_voa_Occ = self.interp(index_Occ, voa_Occ, index_Occ_new,['voa_Occ'])
        df_voa_Occ[abs(df_voa_Occ.iloc[:,0])<tolerance]=0
        df_vot_Occ[abs(df_vot_Occ.iloc[:,0])<tolerance]=0
        #Calculate the OAR
        oar_tot = df_voa_Occ['voa_Occ']/df_vot_Occ['vot_Occ']
        #Drop the value where the vot is 0
        oar_tot.replace([np.inf, -np.inf], np.nan, inplace=True)
        oar_tot.dropna(inplace=True) 
        #Calculate the mean OAR        
        oar_tot = oar_tot[oar_tot>=1].count()/len(oar_tot)
                              
        self.oar_tot=oar_tot                     
        
        return oar_tot

    def get_control_quality_factors(self):
        # Get the control output and the reference value. 
        # Here we use the supply air temperature loop as an example.
        index=self.data_buff.values('TSup.T')[0]
        
        CQF_EWMA_weighted_list=[]
        CQF_Harris_weighted_list=[]
        
        for signal,setpoint in zip(self.kpi_json['ControlOutput'],self.kpi_json['ControlSetpoint']):
            if signal.split(".")[-1].startswith('T'):
                ControType='Temp'
                con = np.array(self.data_buff.values(signal)[1])-273.15
                conSet = np.array(self.data_buff.values(setpoint)[1])-273.15  
            
            #else:
            #    ControType='FlowRate'
            #    con = np.array(self.data_buff.values(signal)[1])
            #    conSet = np.array(self.data_buff.values(setpoint)[1])
            
            # Filter the data to the occupancy hour
            index_Occ=self.filter_Occ(index, np.array(index))
            con=self.filter_Occ(index, np.array(con))
            conSet=self.filter_Occ(index, np.array(conSet))
            
            #Resample to 1-minute data
            index_Occ_new=np.arange(index_Occ[0], index_Occ[-1]+1, 60)
            index_Occ_new=self.filter_Occ(index_Occ_new, index_Occ_new)
            df_con = self.interp(index_Occ, con, index_Occ_new,[signal])
            df_conSet = self.interp(index_Occ, conSet, index_Occ_new,[setpoint])
            df_con.dropna(inplace=True) 
            df_conSet.dropna(inplace=True) 
            #plt.plot(np.array(df_con[signal]))
            #plt.plot(np.array(df_conSet[setpoint]))
            y=np.array(df_con[signal]) #Reference
            r=np.array(df_conSet[setpoint]) #Control Output 
            t=np.arange(1,len(y)+1,1)
            N=len(t)
            Dwin=20 # Windows size
            
            
            #EWMA Index
            CQF_EWMA=np.zeros(N-Dwin)
            lamda=0.8
            absErr=self.calculate_EWMA(y,r,lamda,Dwin)
            
            #Harris Index
            if ControType == 'Temp':
                noiseVar2=0.1
            elif ControType == 'FlowPercent':
                noiseVar2=1
            elif ControType == 'AirPressure':
                noiseVar2=0.01
            elif ControType == 'WaterPressure':
                noiseVar2=0.1
            elif ControType == 'Humid':
                noiseVar2=10;
            elif ControType == 'FlowRate':
                noiseVar2=100;
                
            rHarris=np.zeros(N-Dwin)
            CQF_Harris=np.zeros(N-Dwin)
            
            y_window=np.empty(Dwin)
            r_window=np.empty(Dwin)
            H_init=[]
            
            for i in range(N-Dwin):
                lo=i
                hi=lo+Dwin
                y_window[:Dwin]=y[lo:hi]
                r_window[:Dwin]=r[lo:hi]
                WinVar=np.sum((y_window-r_window)**2)/Dwin
                rlsPhi= self.phi_arma_rls(y_window,2,1)
                rlsHarris=self.calculate_Harris(y_window,r_window,Dwin,rlsPhi,noiseVar2,WinVar)
                rHarris[i]=rlsHarris
            
            #Reverse Index
            rev=self.ReverseIndex(y,r,lamda,Dwin,noiseVar2)
            
            for i in range(N-Dwin):
                if rev[i]==1:
                    CQF_EWMA[i]=1
                    CQF_Harris[i]=1
                else:
                    CQF_EWMA[i]=absErr[i+Dwin]
                    CQF_Harris[i]=rHarris[i]                      
            
            #CQF-EWMA Plot    
            plt.figure()
            t_absErr=t[Dwin:N]
            plt.scatter(t_absErr,CQF_EWMA,s=1)
            plt.ylabel('CQF-EWMA')
            plt.xlabel('Time/min')
            plt.ylim([-0.05,1.05])
            
            #CQF-Harris Plot    
            plt.figure()
            t_harris=t[Dwin:N]
            plt.scatter(t_harris,CQF_Harris,s=1,color='r')
            plt.ylabel('CQF-Harris')
            plt.xlabel('Time/min')
            plt.ylim([-0.05,1.05])
            
            #Setpoint-Control Output
            plt.figure()
            plt.plot(t,y,color='b') 
            plt.plot(t,r,color='r')
            plt.ylabel('Temp/F')
            plt.xlabel('Time/min')
            plt.ylim([5,20])     
            
            
            #CQF-EWMA Weighted Scale
            CQF_EWMA_scale=np.empty(len(CQF_EWMA))
            for i in range(len(CQF_EWMA)):
                if 0 <= CQF_EWMA[i] <0.1472:
                    CQF_EWMA_scale[i]=5
                elif  0.1472 <= CQF_EWMA[i] <0.4372:
                    CQF_EWMA_scale[i]=4
                elif  0.4372 <= CQF_EWMA[i] <0.7214:
                    CQF_EWMA_scale[i]=3
                elif  0.7214 <= CQF_EWMA[i] <1:
                    CQF_EWMA_scale[i]=2
                else:
                    CQF_EWMA_scale[i]=1
            elements, CQF_EWMA_counts = np.unique(CQF_EWMA_scale, return_counts=True)
            CQF_EWMA_weighted=sum(elements*CQF_EWMA_counts)/sum(CQF_EWMA_counts)
            
            #Harris Weighted Scale
            CQF_Harris_scale=np.empty(len(CQF_Harris))
            for i in range(len(CQF_Harris)):
                if 0 <= CQF_Harris[i] <0.5:
                    CQF_Harris_scale[i]=5
                elif  0.5 <= CQF_Harris[i] <0.67:
                    CQF_Harris_scale[i]=4
                elif  0.67 <= CQF_Harris[i] <0.75:
                    CQF_Harris_scale[i]=3
                elif  0.75 <= CQF_Harris[i] <0.8:
                    CQF_Harris_scale[i]=2
                else:
                    CQF_Harris_scale[i]=1
            elements, CQF_Harris_counts = np.unique(CQF_Harris_scale, return_counts=True)
            CQF_Harris_weighted=sum(elements*CQF_Harris_counts)/sum(CQF_Harris_counts)
            
            #print ('EWMA Weighted Index:'+str(CQF_EWMA_weighted))
            #print ('Harris Weighted Index:'+str(CQF_Harris_weighted))
            CQF_Harris_weighted_list.append(CQF_Harris_weighted)
            CQF_EWMA_weighted_list.append(CQF_EWMA_weighted)
        
        return [CQF_EWMA_weighted_list,CQF_Harris_weighted_list]



    def calculate_EWMA(self,y,r,lamda,Dwin):
        FF=1-math.exp(-0.07)
        co=1/FF
        n=len(y)
        yEwma=np.zeros(n)
        errRatio=np.zeros(n)
        for i in range(1,n,1):
            yEwma[i]=lamda*yEwma[i-1]+(1-lamda)*y[i]
            factor=abs(yEwma[i]-r[i])/r[i]
            if factor<=0.07:
                errRatio[i]=(1-math.exp(-factor))*co
            else:
                errRatio[i]=1
        return errRatio
    
    
    
    def phi_arma_rls(self,y_window,p,q):
        #p is the order of AR
        #q is the order of MA
        #this is recursive least square method for ARMA(p,q) fitting
        #only two type of fitting: arma(2,2) and arma(2,1) are applied
        #y(t)=a1*y(t-1)+a2*y(t-2)+w(t)+b1*w(t-1)+b2*w(t-2)
        p=2
        q=1
        n=len(y_window)
        m=p+q
        if n<=m:
            print('y length must be bigger than sum(p+q)')
            sys.exit()
        P0=10**3
        P_init=np.eye(m)*P0
        theta=np.zeros((m,1))
        theta_init=np.ones((m,1))/P0
        
        w=np.zeros(n)
        if m==4:
            w[1]=1/P0  #w(t-1)
            w[0]=1/P0  #w(t-2)
            H_init=np.array([y_window[1],y_window[0],w[1],w[0]])
            
        if m==3:
            w[1]=1/P0 #w(t-1)
            H_init=np.array([y_window[1],y_window[0],w[1]])
            
        P_old=P_init
        theta_old=theta_init
        H_old=H_init
        H=np.zeros(m)
        P=np.eye(m)
        for i in range(2,n):
            if m==4:
                H=np.array([y_window[i-1],y_window[i-2],w[i-1],w[i-2]])
            if m==3:
                H=np.array([y_window[i-1],y_window[i-2],w[i-1]])
            P=P_old-(P_old*np.matrix(H).T*np.matrix(H)*P_old)/(1+np.matrix(H)*P_old*np.matrix(H).T)
            theta=theta_old+P*np.matrix(H).T*(y_window[i]-np.matrix(H)*theta_old)
            w[i]=y_window[i]-H*theta
            P_old=P
            theta_old=theta
        
        coeffs=np.zeros(m)
        for i in range(m):
            coeffs[i]=theta[i]
        phi=coeffs[0]+coeffs[p]
        distVar=np.var(w)
        return phi
    
    def calculate_Harris(self,y,r,Dwin,phi,noiseVar,VarWind):
        MinVar=(1+phi**2)*noiseVar
        if VarWind<MinVar:
            rHarris=0.0
        else:
            rHarris=1-MinVar/VarWind
        return rHarris
    
    def ReverseIndex(self,y,r,lamda,Dwin,noiseVar):
        n=len(y)
        IndexRev=np.zeros(n)
        yEwma=np.zeros(n)
        y_var=np.zeros(n)
        
        for i in range(2,n):
            yEwma[i]=lamda*yEwma[i-1]+(1-lamda)*y[i] #y_bar
            indicator1=(yEwma[i]-yEwma[i-1])*(yEwma[i-1]-yEwma[i-2])
            indicator2=abs(yEwma[i]-r[i]);
            y_var[i]=lamda*y_var[i-1]+(1-lamda)*(y[i]-yEwma[i])**2;
            hystlimit=r[i]*0.02;
            if(indicator1<0 and indicator2>hystlimit and y_var[i]>noiseVar):
               IndexRev[i]=1 #dithering happens
            else:
               IndexRev[i]=0 #dithering no happen
        return IndexRev
                            
    def get_dict_tree(self, dict_flat, sep='_',
                      remove_null=True, merge_branches=True):
        '''This method creates a dictionary tree from a 
        flat dictionary. A dictionary tree is a nested
        dictionary where each element contains other
        dictionaries which keys are the following 
        names of the strings in the keys of the 
        original dictionary and that are separated
        from each other with a 'sep' string case that
        can be specified.
        
        Parameters
        ----------
        dict_flat: dict
            dictionary containing only one layer of
            complexity. This means that the values of
            the dictionary do not contain any other
            dictionaries.
        sep: string, optioanl
            string that indicates different layers in 
            the keys of the original dictionary.
            Default is '_'.
        remove_null: Boolean, optional
            True if we don't want to include the null
            elements in the dictionary tree. These null
            elements create problems when plotting the 
            nested pie chart.
            Default is True.
        merge_branches: Boolean, optional
            Merge the branches where a key has only one value.
            This resolves the problem of getting a plain 
            dictionary with any key containing the 'sep'.
            Default is True.
            
        Returns
        -------
        dict_tree: dict
            nested dictionary with the different layers
            of complexity indicated by the 'sep' string
            in the keys of the original dictionary
            
        '''
        
        # Initialize the dictionary tree
        dict_tree = OrderedDict()
        # Remove the null elements from the flat dictionary
        if remove_null:
            dict_flat = self.remove_null_elements(dict_flat)
        # Each element of the flat dictionary is a branch of the tree
        for element in dict_flat.keys():
            # Create an auxiliary variable to go through the branches of the tree
            actual_layer = dict_tree
            # Read every component in the branch except the last '_y' term
            components = element.split(sep)[:-1]
            # Grow the branch with a new dictionary if not the last component
            for component in components[:-1]:
                # Check if this component is already in this layer
                if component not in actual_layer.keys():
                    # Create a dictionary in this layer to keep growing the branch
                    actual_layer[component]=OrderedDict()
                # Shift the actual layer by one component
                actual_layer = actual_layer[component]
            # If last component, assign the flat dictionary value
            actual_layer[components[-1]] = dict_flat[element]
        
        if merge_branches:
            dict_tree = self.merge_branches(dict_tree,sep=sep)
        
        return dict_tree
    
    def merge_branches(self, dictionary, sep='_'):
        '''Merge the branches where a key has only one value.
        This resolves the problem of getting a plain dictionary
        with any key containing the 'sep' element.
        
        Parameters
        ----------
        dictionary: dict
            dictionary for which we want to merge branches
        sep: string, optional
            string used to merge the key and the value of the
            elements of a dictionary in different layers.
            Default is '_'.
            
        Returns
        -------
        new_dict: dict
            a new dictionary with the branches merged

        '''
        
        for k,v in iteritems(dictionary):
            if isinstance(v, dict):
                if len(dictionary.keys())==1:
                    for vkey in v.keys():
                        dictionary[k+sep+vkey] = v[vkey]
                    dictionary.pop(k)
                 
                self.merge_branches(v)
                
        return dictionary 
    
    def sum_dict(self, dictionary):
        '''This method returns the sum of all values within a 
        nested dictionary that can contain float numbers 
        and/or other dictionaries containing the same type 
        of elements. It works in a recursive way.
        
        Parameters
        ----------
        dictionary: dict or float
            dictionary containing other dictionaries and/or
            float numbers. If it's a float it will return
            its value directly
            
        Returns
        -------    
        val: float
            value of the sum of all values within the 
            nested dictionary

        '''
        
        # Initialize the sum
        val=0.
        # If dictionary is a float we have arrived to an
        # end point and we want to return its value
        if isinstance(dictionary, float):
            
            return dictionary
        
        # If dictionary is still a dictionary we should 
        # keep searching for an end point with a float
        elif isinstance(dictionary, dict):
            for k in dictionary.keys():
                # Sum the values within this dictionary
                val += self.sum_dict(dictionary=dictionary[k])
                
            return val
    
    def count_elements(self, dictionary):
        '''This methods counts the number of end points in 
        a nested dictionary. An end point is considered
        to be a float number instead of a new dictionary
        layer.
        
        Parameters
        ----------
        dictionary: dict
            dictionary for which we want to count the 
            
        Returns
        -------
        n: integer
            number of total end points within the nested
            dictionary

        '''
        
        # Initialize the counter
        n=0
        # If dictionary is a float we have arrived to an
        # end point and we want to sum one element
        if isinstance(dictionary, float):
            
            return 1
        
        # If dictionary is still a dictionary we should 
        # keep searching for an end point 
        elif isinstance(dictionary, dict):
            for k in dictionary.keys():
                # Count the elements within this dictionary
                try:
                    n += self.count_elements(dictionary=dictionary[k])
                except:
                    pass
                
            return n
        
    def remove_null_elements(self, dictionary):
        '''This methods removes the null elements of a 
        plain dictionary
        
        Parameters
        ----------
        dictionary: dict
            dictionary for which we want to remove the null elements 
            
        Returns
        -------
        new_dict: dict
            a new dictionary without the null elements

        '''
        
        new_dict = OrderedDict()
        
        for k,v in iteritems(dictionary):
            if v!=0.: 
                new_dict[k] = dictionary[k]
        
        return new_dict
        
    def parse_color_indexes(self, dictionary, min_index=0, max_index=260):
        '''This method parses the color indexes for a nested pie chart
        and according to the number of elements within the dictionary
        that is going to be plotted. It will provide an equally 
        distributed range of color indexes between a minimum value
        and a maximum value. These indexes can then be used for a 
        matplotlib color map in order to provide an smooth color 
        variation within the chromatic circle. Notice that with 
        min_index and max_index it can be customized the color range
        to be used in the chart. These indexes must lay between the 
        minimum and maximum indexes of the color map used.
        
        Parameters
        ----------
        dictionary: dict
            dictionary for which the pie chart is going to be 
            plotted
        min_index: integer, optional
            minimum value of the index that is going to be used.
            Default is 0.
        max_index: integer, optional
            maximum value of the index that is going to be used.
            Default is 260.
        
        '''
        
        n = self.count_elements(dictionary)
        
        return np.linspace(min_index, max_index, n+1).astype(int)
        
    def plot_nested_pie(self, dictionary, ax=None, radius=1., delta=0.2,
                        dontlabel=None, breakdonut=True, 
                        metric = 'energy use', units = 'kW*h'):
        '''This method appends a pie plot from a nested dictionary
        to an axes of matplotlib object. If all the elements
        of the dictionary are float values it will make a simple
        pie plot with those values. If there are other nested
        dictionaries it will continue plotting them in a nested
        pie plot.
         
        Parameters
        ----------
        dictionary: dict
            dictionary containing other dictionaries and/or
            float numbers for which the pie plot is going to be
            created.
        ax: matplotlib axes object, optional
            axes object where the plot is going to be appended.
            Default is None.
        radius: float, optional
            radius of the outer layer of the pie plot.
            Default is 1.
        delta: float, optional
            desired difference between the radius of two 
            consecutive pie plot layers.
            Default is 0.2.
        dontlabel: list, optional
            list of items to not be labeled for more clarity.
            Default is None.
        breakdonut: boolean, optional
            if true it will not show the non labeled slices.
            Default is True.
        metric: string, optional
            indicates the metric that is being plotted. Notice that
            this is only used for the title of the plot.
            Default is 'energy use'.
        units: string, optional
            indicates the units used for the metric. Notice that
            this is only used for the title of the plot.
            Default is 'kW*h'.
            
        '''
        
        # Initialize the pie plot if not initialized yet
        if ax is None:
            _, ax = plt.subplots()
        if dontlabel is None:
            dontlabel = []
        # Get the color map to be used in this pie
        cmap = plt.get_cmap('rainbow')
        labels=[]
        # Parse the color indexes to be used in this pie
        color_indexes  = self.parse_color_indexes(dictionary)
        # Initialize the color indexes to be used in this layer
        cindexes_layer = [0]
        # Initialize the list of values to plot in this layer
        vals = []
        # Initialize a new dictionary for the next inner layer
        new_dict = OrderedDict()
        # Initialize the shifts for the required indices
        shift = np.zeros(len(dictionary.keys()))
        # Initialize a counter for the loop
        i=0
        # Go through every component in this layer
        for k_outer,v_outer in iteritems(dictionary):
            # Calculate the slice size of this component 
            vals.append(self.sum_dict(v_outer))
            # Append the new label if not end point (if not in dontlabel)
            last_key = k_outer.split('__')[-1]
            label = last_key if not any(k_outer.startswith(dntlbl) \
                                        for dntlbl in dontlabel) else ''
            labels.append(label)
            # Check if this component has nested dictionaries
            if isinstance(v_outer, dict):
                # If it has, add them to the new dictionary
                for k_inner,v_inner in iteritems(v_outer):
                    # Give a unique nested key name to it
                    new_dict[k_outer+'__'+k_inner] = v_inner
            # Check if this component is already a float end point 
            elif isinstance(v_outer, float):
                # If it is, add it to the new dictionary
                new_dict[k_outer] = v_outer
            # Count the number of elements in this component
            n = self.count_elements(v_outer)
            # Append the index of this component according to its
            # number of components in order to follow a progressive
            # chromatic circle
            cindexes_layer.append(cindexes_layer[-1]+n)
            # Make a shift if this is not an end point to do not use
            # the same color as the underlying end points. Make this
            # shift something characteristic of this layer by making
            # use of its radius 
            shift[i] = 0 if n==1 else 60*radius
            # Do not label this slice in the next layer if this was
            # already an end point or a null slice
            if n==1: 
                dontlabel.append(k_outer) 
            # Increase counter
            i+=1
        
        # Assign the colors to every component in this layer
        colors = cmap((color_indexes[[cindexes_layer[:-1]]] + \
                       shift).astype(int))
        
        # If breakdonut=True show a blank in the unlabeled items
        if breakdonut:
            for j,l in enumerate(labels):
                if l is '': colors[j]=[0., 0., 0., 0.]   
                
        # Append the obtained slice values of this layer to the axes
        ax.pie(np.array(vals), radius=radius, labels=labels, 
               labeldistance=radius, colors=colors,
               wedgeprops=dict(width=0.2, edgecolor='w', linewidth=0.3))
        
        # Keep nesting if there is still any dictionary between the values
        if not all(isinstance(v, float) for v in dictionary.values()):
            self.plot_nested_pie(new_dict, ax, radius=radius-delta,
                                 dontlabel=dontlabel, metric=metric, 
                                 units=units)
            
        # Don't continue nesting if all components were float end points 
        else:
            plt.title('Total {metric} = {value:.2f} {units}'.format(\
                metric=metric, value=self.sum_dict(dictionary), units=units))
            # Equal aspect ratio ensures that pie is drawn as a circle
            ax.axis('equal')
            plt.show()
            
if __name__ == "__main__":
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    baseline=Reader('Baseline_fixed_interval_1min.mat','dymola')
    #CoilValveStuck65=Reader('CoilValveStuck65%_fixed_interval_1min.mat','dymola')
    #CoilValveStuck100=Reader('CoilValveStuck100%_fixed_interval_1min.mat','dymola')
    kpical = KPI_Calculator(baseline)
    ckpi=kpical.get_core_kpis()
    
    
    '''Nested pie chart example
    ene_dict = {'Heating_damper_y':50.,
                'Heating_HP_pump_y':160.,
                'Heating_pump_y':25.,
                'Cooling_fan_y':80.,
                'Heating_HP_fan_y':30.,
                'Heating_HP_prueba_y':0.,
                'Cooling_pump_y':80.,
                'Lighting_floor_1_zone1_lamp1_y':15.,
                'Lighting_floor_1_zone1_lamp2_y':23.,
                'Lighting_floor_1_zone2_y':87.,
                'Lighting_floor_2_y':37.}  
    
    cal = KPI_Calculator(data_buff=None)
    ene_tree = cal.get_dict_tree(ene_dict)
    cal.plot_nested_pie(ene_tree)
    '''
