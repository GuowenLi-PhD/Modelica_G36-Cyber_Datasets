# import numerical package
import numpy as np
import matplotlib
matplotlib.use('agg')
import matplotlib.pyplot as plt

from pyfmi import load_fmu

# dump results as json
import json
# load pandas
import pandas as pd

import scipy.interpolate as interpolate

fmu_base = load_fmu("BaselineSystem.fmu")
fmu_attack = load_fmu("SignalCorruption.fmu")

# simulate time setup
time_duration = 24*3600. # 1 days
startTime = 207*24*3600. # start from day 207
endTime = startTime + time_duration # end time
dt = 3600. # time step

# fmu settings
options = fmu_base.simulate_options()
initialize = True
options['initialize'] = initialize

# simulate
res_base = fmu_base.simulate(start_time=startTime, final_time=endTime, options=options)
res_attack = fmu_attack.simulate(start_time=startTime, final_time=endTime, options=options)

## get output variables 
# base system
t_base = res_base['time']
TZonCor_base = res_base['flo.TRooAir[5]']
yDamVAVCor_base = res_base['conVAVCor.yDam']
VDisFloVAVCor_base = res_base['conVAVCor.VDis_flow']
speSupFan_base = res_base['fanSup.y']
TCHWSet_base = res_base['temDifPreRes.TSet']
yValCooCoi_base = res_base['watVal.y']
TSupAir_base = res_base['TSup.T']
TSupAirSet_base = res_base['conAHU.TSupSet']
TMixAir_base = res_base["TMix.T"]
qCooCoi_base = res_base["cooCoi.Q1_flow"]

eleCoiVAV_base = res_base['eleCoiVAV.y']
eleSupFan_base = res_base['eleSupFan.y']
eleChi_base = res_base['eleChi.y']
eleCHWP_base = res_base['eleCHWP.y']
eleCWP_base = res_base['eleCWP.y']
eleCT_base = res_base['eleCT.y']
eleHWP_base = res_base['eleHWP.y']
gasBoi_bas = res_base['gasBoi.y']

eleTot_base = res_base['eleTot.y']


# attacked system

t_attack = res_attack['time']
TZonCor_attack = res_attack['flo.TRooAir[5]']
yDamVAVCor_attack = res_attack['conVAVCor.yDam']
VDisFloVAVCor_attack = res_attack['conVAVCor.VDis_flow']
speSupFan_attack = res_attack['fanSup.y']
TCHWSet_attack = res_attack['temDifPreRes.TSet']
yValCooCoi_attack = res_attack['watVal.y']
TSupAir_attack = res_attack['TSup.T']
TSupAirSet_attack = res_attack['conAHU.TSupSet']
TMixAir_attack = res_attack["TMix.T"]
qCooCoi_attack = res_attack["cooCoi.Q1_flow"]

eleCoiVAV_attack = res_attack['eleCoiVAV.y']
eleSupFan_attack = res_attack['eleSupFan.y']
eleChi_attack = res_attack['eleChi.y']
eleCHWP_attack = res_attack['eleCHWP.y']
eleCWP_attack = res_attack['eleCWP.y']
eleCT_attack = res_attack['eleCT.y']
eleHWP_attack = res_attack['eleHWP.y']
gasBoi_attack = res_attack['gasBoi.y']

eleTot_attack = res_attack['eleTot.y']


# plots
fig = plt.figure(figsize=(12,12))
fig.add_subplot(421)
plt.plot(np.array(t_base),np.array(TZonCor_base)-273.15,'b:',linewidth=1) #
plt.plot(np.array(t_attack),np.array(TZonCor_attack)-273.15,'r-', linewidth=1) # 
plt.ylabel('Core Zone Temperature [C]')
plt.ylim([20,30])
plt.xlabel([])

fig.add_subplot(422)
plt.plot(np.array(t_base),np.array(yDamVAVCor_base),'b:',linewidth=1) 
plt.plot(np.array(t_attack),np.array(yDamVAVCor_attack),'r-', linewidth=1) #
plt.ylabel('Core Zone VAV Damper')
plt.ylim([0,1])
plt.xlabel([])

fig.add_subplot(423)
plt.plot(np.array(t_base),np.array(VDisFloVAVCor_base),'b:',linewidth=1) 
plt.plot(np.array(t_attack),np.array(VDisFloVAVCor_attack),'r-', linewidth=1) #
plt.ylabel('Core Zone Air Flow')
#plt.ylim([0,1])
plt.xlabel([])

fig.add_subplot(424)
plt.plot(np.array(t_base),np.array(speSupFan_base),'b:',linewidth=1) 
plt.plot(np.array(t_attack),np.array(speSupFan_attack),'r-', linewidth=1) #
plt.ylabel('Supply Fan Speed')
plt.ylim([0,1])
plt.xlabel([])

fig.add_subplot(425)
plt.plot(np.array(t_base),np.array(TCHWSet_base)-273.15,'b:',linewidth=1) 
plt.plot(np.array(t_attack),np.array(TCHWSet_attack)-273.15,'r-', linewidth=1) #
plt.ylabel('TCHW Set [C]')
plt.ylim([4,12])
plt.xlabel([])

fig.add_subplot(426)
plt.plot(np.array(t_base),np.array(yValCooCoi_base),'b:',linewidth=1) 
plt.plot(np.array(t_attack),np.array(yValCooCoi_attack),'r-', linewidth=1) #
plt.ylabel('Cooling Coil Valve')
plt.ylim([0,1])
plt.xlabel([])

fig.add_subplot(427)
plt.plot(np.array(t_base),np.array(TSupAir_base)-273.15,'b:',linewidth=1) 
plt.plot(np.array(t_attack),np.array(TSupAir_attack)-273.15,'r-', linewidth=1) #
plt.ylabel('TSA Set [C]')
plt.ylim([10,20])
plt.xlabel([])

fig.add_subplot(428)
plt.plot(np.array(t_base),np.array(qCooCoi_base)/1000,'b:',linewidth=1) 
plt.plot(np.array(t_attack),np.array(qCooCoi_attack)/1000,'r-', linewidth=1) #
plt.ylabel('Heat Flow in Cooling Coil [kW]')
#plt.ylim([10,20])
plt.xlabel([])

plt.savefig("result.svg")
plt.savefig("result.pdf")
plt.savefig("result.png")