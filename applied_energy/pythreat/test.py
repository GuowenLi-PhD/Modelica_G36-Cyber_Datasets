from pythreat.threat import Threat
from pythreat.threat import ThreatInjection
from pythreat.temporal import Signal
from pythreat.temporal import Temporal

import numpy as np
import scipy.signal as SG
import matplotlib
matplotlib.use('agg')
import matplotlib.pyplot as plt

# test square attack
v1_name = 'oveChiOn_u'
sig1 = Signal(name=v1_name,
            y_min=0,
            y_max=1,
            unit="1")

thr1 = Threat(active = True, 
            start_threat = 207*24*3600.+12*3600,
            end_threat= 207*24*3600.+12*3600 + 3*3600,
            temporal = Temporal(sig1,'square',amplitude=1.,period=1800,offset=0),
            injection = 'v')

thr_inj1 = ThreatInjection(threat=thr1,
                        start_time=207*24*3600., 
                        end_time=208*24*3600.,
                        step=120) 
input_object = thr_inj1.overwrite()

t = input_object[1][:,0]
val = input_object[1][:,1]

fig=plt.figure()
plt.plot(t,val)
plt.savefig('test.pdf')
