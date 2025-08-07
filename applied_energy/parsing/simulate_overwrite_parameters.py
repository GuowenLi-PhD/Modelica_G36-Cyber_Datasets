# -*- coding: utf-8 -*-
"""
This module compiles the defined test case model into an FMU using the
overwrite block parser.

The following libraries must be on the MODELICAPATH:

- Modelica IBPSA
- Modelica Buildings

"""
# import numerical package
import numpy as np
import matplotlib
matplotlib.use('agg')
import matplotlib.pyplot as plt
# import fmu package
from pyfmi import load_fmu
# import buildingspy
#from buildingspy.io.outputfile import Reader
#import fncs

# load pickle to save results - cannot be picked FMU2ME object
# import pickle
import os
# import parser
from parsing import parser

# simulate setup
time_stop = 3600*24*2. # 2 days
startTime = 0
endTime = startTime + time_stop
dt = 3600.
nstep = time_stop/dt

## load fmu - cs
library=[]
model = 'SimpleRC_Parameter'
name = parser.export_fmu(model,library,simulator='dymola')
fmu = load_fmu(name,log_level=7)
options = fmu.simulate_options()
options['ncp'] = 500.

# initialize output
TZone = []
PHeat = []
setZone = []
ResHeat = []
tim = []

# input: None

# simulate fmu
#res = fmu.simulate(start_time=startTime, final_time=endTime,input = input_object, options=options)

# simulate fmu using do_step to see if states are stored in fmu
initialize = True

for i in range(int(nstep)):
    ts = i*dt
    options['initialize'] = initialize    
    # set time varying parameters
    if i <= 36:
        a_ove = 0.02
    else:
        a_ove = 2

    fmu.set('oveParR_p', a_ove)
    
    # has to use 3600. instead of 3600, because the former will produce a float number to avoid integrator errors in jmodelica. 
    res_step = fmu.simulate(start_time=ts, final_time=ts+dt, options=options)
    initialize = False

    TZone.extend(res_step['mod.TZone.y'])
    PHeat.extend(res_step['mod.PHeat.y'])
    ResHeat.extend(res_step['mod.res.port_b.Q_flow'])
    setZone.extend(res_step['mod.setZone.y'])
    tim.extend(res_step['time'])

print 'Finish simulation'

# post-process
# plot 
plt.figure()
plt.subplot(211)
plt.plot(tim,np.array(TZone)-273.15,label='TZone')
plt.plot(tim,np.array(setZone)-273.15,label='Zone Setpoint')
plt.xticks(np.arange(startTime,endTime+1,4*dt),[])
plt.legend()
plt.subplot(212)
plt.plot(tim,PHeat,label='PHeat')
plt.plot(tim,ResHeat,label='QHeatResist')
plt.legend()
plt.xticks(np.arange(startTime,endTime+1,4*dt),np.arange(0,49,4))
plt.savefig('result.pdf')
plt.close()	



