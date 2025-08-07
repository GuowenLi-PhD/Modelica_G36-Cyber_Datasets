# -*- coding: utf-8 -*-
"""
This module compiles the defined test case model into an FMU using the
overwrite block parser.

The following libraries must be on the MODELICAPATH:

- Modelica IBPSA
- Modelica Buildings

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
startTime = 0
dt = 60.

## load fmu - cs
library=[]
model = 'ode'
#name = parser.translate_fmu(model,library, 'ode',simulator='dymola')
name='ode.fmu'
fmu = load_fmu(name,log_level=7)
options = fmu.simulate_options()
options['ncp'] = 600.

# initialize output
x = []
tim = []

# input: None

# simulate fmu
#res = fmu.simulate(start_time=startTime, final_time=endTime,input = input_object, options=options)

# simulate fmu using do_step to see if states are stored in fmu
initialize = True
a_ove_activate = False

for i in range(3):
    ts = i*dt
    options['initialize'] = initialize  

    # set time varying parameters
    a_ove = [1,5,7]

    #fmu.set(['a_ove','a_ove_activate'], [a_ove, a_ove_activate])
    fmu.set('a',a_ove[i])
    
    # has to use 3600. instead of 3600, because the former will produce a float number to avoid integrator errors in jmodelica. 
    res_step = fmu.simulate(start_time=ts, final_time=ts+dt, options=options)
    initialize = False
    a_ove_activate = True

    print (len(res_step['x']))
    print (res_step['x'])
    print (res_step['time'])
    print (res_step.final('a'))

    x.extend(res_step['x'])
    tim.extend(res_step['time'])


print ('Finish simulation')

# post-process
# plot 
fig = plt.figure()
fig.add_subplot(111)
plt.plot(np.array(tim),np.array(x))
plt.savefig('result_ode.pdf')
plt.close()	



