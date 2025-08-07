'''This module contains the calculation of real time demand flexibility at real-time.

Author: Yangyang Fu
Email: yangyang.fu@tamu.edu
'''
import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from scipy.integrate import trapz
#from flask._compat import iteritems
# Define a compatibility function for iteritems
def iteritems(d):
    return d.items()
from collections import OrderedDict
import scipy.interpolate as interpolate
import os
import json
import math
import sys
from buildingspy.io.outputfile import Reader
from kpis.kpi_fmu import KPI_Calculator

class DF_Calculator(KPI_Calculator):
    '''This class calculates the demand flexibility as a post-process
    ''' 
    def __init__(self,data_buff=[]):

        super(DF_Calculator,self).__init__(kpi_names=[], 
        measurement_names=[], 
        data_buff=data_buff, 
        start_occ=6, 
        end_occ=19)
    
    def get_average_total_electric_power(self):
        """Get average total power

        """
        index=self.data_buff['time']
                    
        elec_ave = 0
        dt = index[-1] - index[0]
        # Calculate total energy from power 
        # [returns KWh - assumes power measured in Watts]
        pow_data = np.zeros(np.array(index).shape)
        for signal in self.kpi_json['ElectricPower']:
            pow_data += np.array(self.data_buff[signal])

        elec_ave = trapz(pow_data,
                    index)*2.77778e-7/(dt/3600.) # Convert to kWh
        # Assign to case       
        self.elec_ave            = elec_ave
        return elec_ave                           

    
            
if __name__ == "__main__":
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    #baseline=Reader('Baseline_fixed_interval_1min.mat','dymola')
    #CoilValveStuck65=Reader('CoilValveStuck65%_fixed_interval_1min.mat','dymola')
    #CoilValveStuck100=Reader('CoilValveStuck100%_fixed_interval_1min.mat','dymola')
    kpical = DF_Calculator(data_buff=[])

    print (kpical.kpi_json)
    print (kpical.filter)


