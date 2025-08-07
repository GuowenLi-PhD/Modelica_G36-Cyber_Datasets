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
# import parser
from parsing import parser
# load pickle to save results - cannot be picked FMU2ME object
# import pickle
import os


# simulate setup
time_stop = 3600*24. # 120s
startTime = 0
endTime = startTime + time_stop
dt = 3600.

## load fmu - cs
library=[]
model = 'ae'
#name = parser.translate_fmu(model,library, 'ae',simulator='dymola')
name='ae.fmu'
fmu = load_fmu(name,log_level=7)
options = fmu.simulate_options()
#options['ncp'] = 600.

# initialize output
x = []
tim = []

# input: None

# simulate fmu
#res = fmu.simulate(start_time=startTime, final_time=endTime,input = input_object, options=options)


initialize = True
a_ove_activate = False

ts = startTime
i = 0
while ts < endTime:
    print i
    options['initialize'] = initialize  

    te = ts + dt
    # set time varying parameters
    if i>=1. and i<=2.:
        a_ove = i
    else:
        a_ove = 5.
    
    #fmu.set(['a_ove','a_ove_activate'], [a_ove, a_ove_activate])
    fmu.set('a',a_ove)
    
    res_step = fmu.simulate(start_time=ts, final_time=te, options=options)
    initialize = False
    a_ove_activate = True

    #print len(res_step['x'])
    #print res_step['x']
    print res_step.final('time')
    print res_step.final('a')

    x.extend(res_step['x'])
    tim.extend(res_step['time'])

    # 
    ts = te
    i += 1

print 'Finish simulation'

# post-process
# plot 
fig = plt.figure()
fig.add_subplot(111)
plt.plot(np.array(tim),np.array(x))
plt.xticks(np.arange(startTime,endTime,dt),np.arange(24))
plt.savefig('result_ae.pdf')
plt.close()	



