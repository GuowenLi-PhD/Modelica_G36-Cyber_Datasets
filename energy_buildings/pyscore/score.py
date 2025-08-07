# -*- coding: utf-8 -*-
"""
Author: Yangyang Fu
Email: yangyang.fu@tamu.edu
"""
import pandas as pd
from collections import OrderedDict

class KPICost:
    def __init__(self, dT_max, dt, P_max, KPIs_step):
        self.dT_max = dT_max
        self.dt = dt 
        self.P_max = P_max 
        self.KPIs_step = KPIs_step # a data frame for all calculated KPIs (time, kpi1, kpi2)

    def get_KPICost(self):
        cost=OrderedDict()
        cost['tdis_tot'] = self.total_discomfort_cost()
        cost['ener_tot'] = self.energy_use_cost()
        cost['pow_peak'] = self.peak_demand_cost()
        cost['df_down'], cost['df_up'] = self.demand_flexibility_cost()
        
        return cost

    def total_discomfort_cost(self):
        tdis_tot = self.KPIs_step['tdis_tot']
        tdis_tot_max = self.dT_max*self.dt/3600.
        
        return tdis_tot/tdis_tot_max 

    def energy_use_cost(self):
        ener_tot = self.KPIs_step['ener_tot'] # kWh
        ener_tot_max = self.P_max*self.dt*2.77777778E-7 # kWh

        return ener_tot/ener_tot_max

    def peak_demand_cost(self):
        peak = self.KPIs_step['pow_peak']*1000 # W
        peak_max =self.P_max

        return peak/peak_max
    
    def demand_flexibility_cost(self):
        df_down = self.KPIs_step['down']*1000 #W
        df_up = self.KPIs_step['up']*1000 #W
        df_max = self.P_max

        return (df_max-df_down)/df_max, (df_max-df_up)/df_max

