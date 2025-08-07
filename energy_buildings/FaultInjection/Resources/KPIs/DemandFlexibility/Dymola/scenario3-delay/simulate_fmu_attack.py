# -*- coding: utf-8 -*-
"""
This script simulate Dymola FMU in a python environment using pyfmi.

The example to demonstrate the calculation of hourly demand flexibility using model pertubation method. 
The pertubated variable is the zone temperature setpoint.

Author: Yangyang Fu
Email: yangyang.fu@tamu.edu
Revisions:
    10/05/2020: first implementation
    10/14/2020: reset fmu time after first simulation during perbutation
"""
# import numerical package
import numpy as np
import matplotlib
matplotlib.use('agg')
import matplotlib.pyplot as plt
# import fmu package
from pyfmi import load_fmu
# load pandas
import pandas as pd

# simulate setup
time_duration = 24*3600. # 1 days
startTime = 207*24*3600. # start from day 207
endTime = startTime + time_duration # end time
dt = 3600. # time step

## load fmu - cs
name = "SignalDelaying.fmu"
fmu = load_fmu(name)
options = fmu.simulate_options()
options['ncp'] = 500

# initialize output
powTot_dow = []
tim_dow = []

powTot_upw = []
tim_upw = []

powTot_bas = []
tim_bas = []
# input: None

# simulate fmu
initialize = True
ts = startTime

# main loop
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

    # a) downward demand flexibility: reset zone temperature to 26C
    # set model state at the start of time step ts 
    fmu.set_fmu_state(states)

    # pertubate zone temperature setpoint during cooling on
    fmu.set('TCooOn', 273.15+26)
    
    # perform simulation 
    res_step_dow = fmu.simulate(start_time=ts, final_time=te, options=options)

    # b) upward demand flexibility: reset zone temperature to 22C
    # set model state at the start of time step ts
    fmu.time = ts # reset fmu built-in time clock to avoid warnings and results with inconsistent start time.
    fmu.set_fmu_state(states)

    # pertubate zone temperature setpoint during cooling on
    fmu.set('TCooOn', 273.15+22)
    
    # perform simulation 
    res_step_upw = fmu.simulate(start_time=ts, final_time=te, options=options)

    # c) baseline power: zone temperature setpoint is 24C
    # set model state at the start of time step ts 
    fmu.time = ts # reset fmu built-in time clock to avoid warnings and results with inconsistent start time.    
    fmu.set_fmu_state(states)

    # pertubate zone temperature setpoint during cooling on
    fmu.set('TCooOn', 273.15+24)
    
    # perform simulation 
    res_step_bas = fmu.simulate(start_time=ts, final_time=te, options=options)

    ## update next step
    # no initialization is needed for the reset of simulation
    initialize = False
    # update clock
    ts = te

    ## save results for plotting
    # downward power 
    powTot_dow.extend(res_step_dow['eleTot.y'])
    tim_dow.extend(res_step_dow['time'])

    # upward power
    powTot_upw.extend(res_step_upw['eleTot.y'])
    tim_upw.extend(res_step_upw['time'])

    # baseline power
    powTot_bas.extend(res_step_bas['eleTot.y'])
    tim_bas.extend(res_step_bas['time'])    

print 'Finish simulation'

# post-process
# plot 
fig = plt.figure()
fig.add_subplot(111)
plt.plot(np.array(tim_bas),np.array(powTot_bas)/1000,'k-',linewidth=1) # kW
plt.plot(np.array(tim_dow),np.array(powTot_dow)/1000,'b-.', linewidth=1) # kW
plt.plot(np.array(tim_upw),np.array(powTot_upw)/1000,'g-.',linewidth=1) # kW

plt.savefig('power_attack.pdf')
plt.close()	

# save raw simulation data for future post-processing
results=pd.DataFrame({'time_base':np.array(tim_bas),
                     'power_base':np.array(powTot_bas),
                     'time_down':np.array(tim_dow),
                     'power_down':np.array(powTot_dow),
                     'time_up':np.array(tim_upw),
                     'power_up':np.array(powTot_upw)})
# dump as a json file
results.to_csv('power_attack_pert.csv')