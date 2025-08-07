# -*- coding: utf-8 -*-
"""
This script simulate Dymola FMU in a python environment using pyfmi.

The example to demonstrate the calculation of hourly demand flexibility using model pertubation method. 
The pertubated variable is the zone temperature setpoint.

Author: Yangyang Fu
Email: yangyang.fu@tamu.edu
Revisions:
    10/05/2020: first implementation

"""
# import numerical package
import numpy as np
import matplotlib
matplotlib.use('agg')
import matplotlib.pyplot as plt
# import fmu package
from pyfmi import load_fmu
import json
import pandas as pd

# simulate setup
time_duration = 24*3600. # 1 days
startTime = 207*24*3600. # start from day 207
endTime = startTime + time_duration # end time
dt = 3600. # time step

## load fmu - cs
name = "BaselineSystem1.fmu"
fmu = load_fmu(name)
options = fmu.simulate_options()
options['ncp'] = 500.

# initialize output
TCooOn = []
TCooOn_again = []
TZonCor = []
TZonCor_again = []
tim = []
tim_again = []

# input: None

# simulate fmu
initialize = True
ts = startTime
istep = 0
states = []

while ts < endTime:
    ## 1. Initialize model
    # initialize the model at the very beginning
    options['initialize'] = initialize   

    # get system states at current time:
    states = fmu.get_fmu_state()

    ## 2. Update model inputs: NONE
    
    ## 3. Update simulation settings
    # step end time
    te = ts + dt

    ## 4. Pertubate model during simulation
    ##### ============================================================================
    #####                start to calculate hourly demand flexibility ===============
    ##### =============================================================================


    # b) upward demand flexibility: reset zone temperature to 22C
    # set model state at the start of time step ts 
    
    fmu.set_fmu_state(states)

    # pertubate zone temperature setpoint during cooling on
    if istep>=12 and istep<=13:
        fmu.set('TCooOn', 273.15+22)
    else:
        fmu.set('TCooOn', 273.15+24)
    # perform simulation 
    res_step_upw = fmu.simulate(start_time=ts, final_time=te, options=options)

    print fmu.time

    ## update next step
    # no initialization is needed for the reset of simulation
    initialize = False
    # update clock
    ts = te
    istep += 1

    ## save results for plotting
    TCooOn_again.extend(res_step_upw['TCooOn'])
    TZonCor_again.extend(res_step_upw['conVAVCor.TZon'])    
    tim_again.extend(res_step_upw['time'])  

print 'Finish simulation'

# post-process
# plot 
fig = plt.figure()
fig.add_subplot(111)
plt.plot(np.array(tim_again),np.array(TCooOn_again)-273.15,'k-', linewidth=1) # kW
plt.plot(np.array(tim_again),np.array(TZonCor_again)-273.15,'k--', linewidth=1) # kW
plt.xticks(np.arange(startTime,endTime,dt),np.arange(25))
plt.savefig('result_change_parameter.pdf')
plt.close()	
