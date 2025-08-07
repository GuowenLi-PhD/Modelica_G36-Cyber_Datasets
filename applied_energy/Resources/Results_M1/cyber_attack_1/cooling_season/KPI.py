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

# Get the directory containing the current Python script
import os
script_directory = os.path.dirname(os.path.abspath(__file__))
# Change the working directory to the directory containing the current Python script
os.chdir(script_directory)
print("Current working directory:", os.getcwd())

def integral(t,v):
        val = 0.0
        for i in range(len(t) - 1):
            val = val + (t[i + 1] - t[i]) * (v[i + 1] + v[i]) / 2.0
        return val

def interp(t_old,x_old,t_new,columns):
	intp = interpolate.interp1d(t_old, x_old, kind='linear')
	x_new = intp(t_new)
	x_new = pd.DataFrame(x_new, index=t_new, columns=columns)
	return x_new

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
TZonResReq__base = res_base['TZonResReq.y']

TZonCor_base = res_base['flo.TRooAir[5]']
yDamVAVCor_base = res_base['conVAVCor.yDam']
VDisFloVAVCor_base = res_base['conVAVCor.VDis_flow']
speSupFan_base = res_base['fanSup.y']
TCHW_base = res_base['TCHWSup.T']
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
TZonResReq_orig_attack = res_attack['TZonResReq.y']
TZonResReq_corr_attack = res_attack['conAHU.uZonTemResReq']

TZonCor_attack = res_attack['flo.TRooAir[5]']
yDamVAVCor_attack = res_attack['conVAVCor.yDam']
VDisFloVAVCor_attack = res_attack['conVAVCor.VDis_flow']
speSupFan_attack = res_attack['fanSup.y']
TCHW_attack = res_attack['TCHWSup.T']
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
fig.add_subplot(521)
plt.plot(np.array(t_base),np.array(TZonResReq__base),'b--',markevery=0.1,marker="o",markersize=3,linewidth=1) #
plt.plot(np.array(t_attack),np.array(TZonResReq_corr_attack),'r-', linewidth=1) # 
plt.plot(np.array(t_attack),np.array(TZonResReq_orig_attack),'g:', linewidth=1) # 
plt.ylabel('Zone Temperature\nReset Requests')
plt.ylim([-1,16])
plt.legend(['Baseline ','Attack_Launched','Attack_Original'])
plt.xticks(np.arange(startTime,endTime,4*3600),[])

fig.add_subplot(522)
plt.plot(np.array(t_base),np.array(TSupAirSet_base)-273.15,'b--',markevery=0.1,marker="o",markersize=3,linewidth=1) 
plt.plot(np.array(t_attack),np.array(TSupAirSet_attack)-273.15,'r-', linewidth=1) #
plt.ylabel('TSA Set [C]')
plt.ylim([10,25])
plt.legend(['Baseline','Attack'])
plt.xticks(np.arange(startTime,endTime,4*3600),[])

fig.add_subplot(523)
plt.plot(np.array(t_base),np.array(TSupAir_base)-273.15,'b--',markevery=0.1,marker="o",markersize=3,linewidth=1) 
plt.plot(np.array(t_attack),np.array(TSupAir_attack)-273.15,'r-', linewidth=1) #
plt.ylabel('TSA [C]')
plt.ylim([10,25])
plt.legend(['Baseline','Attack'])
plt.xticks(np.arange(startTime,endTime,4*3600),[])

fig.add_subplot(524)
plt.plot(np.array(t_base),np.array(TZonCor_base)-273.15,'b--',markevery=0.1,marker="o",markersize=3,linewidth=1) #
plt.plot(np.array(t_attack),np.array(TZonCor_attack)-273.15,'r-', linewidth=1) # 
plt.ylabel('Core Zone\nTemperature [C]')
plt.ylim([20,30])
plt.legend(['Baseline','Attack'])
plt.xticks(np.arange(startTime,endTime,4*3600),[])

fig.add_subplot(525)
plt.plot(np.array(t_base),np.array(yDamVAVCor_base),'b--',markevery=0.1,marker="o",markersize=3,linewidth=1) 
plt.plot(np.array(t_attack),np.array(yDamVAVCor_attack),'r-', linewidth=1) #
plt.ylabel('Core Zone VAV Damper')
plt.ylim([-0.1,1.1])
plt.legend(['Baseline','Attack'])
plt.xticks(np.arange(startTime,endTime,4*3600),[])

fig.add_subplot(526)
plt.plot(np.array(t_base),np.array(VDisFloVAVCor_base),'b--',markevery=0.1,marker="o",markersize=3,linewidth=1) 
plt.plot(np.array(t_attack),np.array(VDisFloVAVCor_attack),'r-', linewidth=1) #
plt.ylabel('Core Zone Air Flow [m3/s]')
plt.ylim([-0.1,2.1])
plt.legend(['Baseline','Attack'])
plt.xticks(np.arange(startTime,endTime,4*3600),[])

fig.add_subplot(527)
plt.plot(np.array(t_base),np.array(speSupFan_base),'b--',markevery=0.1,marker="o",markersize=3,linewidth=1) 
plt.plot(np.array(t_attack),np.array(speSupFan_attack),'r-', linewidth=1) #
plt.ylabel('Supply Fan Speed')
plt.ylim([-0.1,1.1])
plt.legend(['Baseline','Attack'])
plt.xticks(np.arange(startTime,endTime,4*3600),[])

fig.add_subplot(528)
plt.plot(np.array(t_base),np.array(yValCooCoi_base),'b--',markevery=0.1,marker="o",markersize=3,linewidth=1) 
plt.plot(np.array(t_attack),np.array(yValCooCoi_attack),'r-', linewidth=1) #
plt.ylabel('Cooling Coil Valve')
plt.ylim([-0.1,1.1])
plt.legend(['Baseline','Attack'])
plt.xticks(np.arange(startTime,endTime,4*3600),[])

fig.add_subplot(529)
plt.plot(np.array(t_base),np.array(TCHWSet_base)-273.15,'b--',markevery=0.1,marker="o",markersize=3,linewidth=1) #
plt.plot(np.array(t_attack),np.array(TCHWSet_attack)-273.15,'r-', linewidth=1) # 
plt.ylabel('TCHWS Set [C]')
plt.ylim([4,16])
plt.legend(['Baseline ','Attack'])
plt.xticks(np.arange(startTime,endTime,4*3600),np.arange(0,25,4))
plt.xlabel('Hours')

fig.add_subplot(5,2,10)
plt.plot(np.array(t_base),np.array(TCHW_base)-273.15,'b--',markevery=0.1,marker="o",markersize=3,linewidth=1) 
plt.plot(np.array(t_attack),np.array(TCHW_attack)-273.15,'r-', linewidth=1) #
plt.ylabel('TCHWS [C]')
plt.ylim([4,15])
plt.legend(['Baseline','Attack'])
plt.xticks(np.arange(startTime,endTime,4*3600),np.arange(0,25,4))
plt.xlabel('Hours')


plt.savefig("states.svg")
plt.savefig("states.pdf")
plt.savefig("states.png")

# plot fo power
fig = plt.figure(figsize=(12,12))
fig.add_subplot(421)
plt.plot(np.array(t_base),np.array(eleCoiVAV_base)/1000,'b--',markevery=0.1,marker="o",markersize=3,linewidth=1) #
plt.plot(np.array(t_attack),np.array(eleCoiVAV_attack)/1000,'r-', linewidth=1) # 
plt.ylabel('Reheat VAV [kW]')
#plt.ylim([20,30])
plt.legend(['Baseline','Attack'])
plt.xticks(np.arange(startTime,endTime,4*3600),[])

fig.add_subplot(422)
plt.plot(np.array(t_base),np.array(eleSupFan_base)/1000,'b--',markevery=0.1,marker="o",markersize=3,linewidth=1) 
plt.plot(np.array(t_attack),np.array(eleSupFan_attack)/1000,'r-', linewidth=1) #
plt.ylabel('Supply Fan [kW]')
#plt.ylim([0,1])
plt.legend(['Baseline','Attack'])
plt.xticks(np.arange(startTime,endTime,4*3600),[])

fig.add_subplot(423)
plt.plot(np.array(t_base),np.array(eleChi_base)/1000,'b--',markevery=0.1,marker="o",markersize=3,linewidth=1) 
plt.plot(np.array(t_attack),np.array(eleChi_attack)/1000,'r-', linewidth=1) #
plt.ylabel('Chiller [kW]')
#plt.ylim([0,2])
plt.legend(['Baseline','Attack'])
plt.xticks(np.arange(startTime,endTime,4*3600),[])

fig.add_subplot(424)
plt.plot(np.array(t_base),np.array(eleCHWP_base)/1000,'b--',markevery=0.1,marker="o",markersize=3,linewidth=1) 
plt.plot(np.array(t_attack),np.array(eleCHWP_attack)/1000,'r-', linewidth=1) #
plt.ylabel('Chilled Water Pump [kW]')
#plt.ylim([0,1])
plt.legend(['Baseline','Attack'])
plt.xticks(np.arange(startTime,endTime,4*3600),[])

fig.add_subplot(425)
plt.plot(np.array(t_base),np.array(eleCWP_base)/1000,'b--',markevery=0.1,marker="o",markersize=3,linewidth=1) 
plt.plot(np.array(t_attack),np.array(eleCWP_attack)/1000,'r-', linewidth=1) #
plt.ylabel('Condenser Water Pump [kW]')
#plt.ylim([4,12])
plt.legend(['Baseline','Attack'])
plt.xticks(np.arange(startTime,endTime,4*3600),[])

fig.add_subplot(426)
plt.plot(np.array(t_base),np.array(eleCT_base)/1000,'b--',markevery=0.1,marker="o",markersize=3,linewidth=1) 
plt.plot(np.array(t_attack),np.array(eleCT_attack)/1000,'r-', linewidth=1) #
plt.ylabel('Cooling Tower [kW]')
#plt.ylim([0,1.1])
plt.legend(['Baseline','Attack'])
plt.xticks(np.arange(startTime,endTime,4*3600),[])

fig.add_subplot(427)
plt.plot(np.array(t_base),np.array(eleHWP_base)/1000,'b--',markevery=0.1,marker="o",markersize=3,linewidth=1) 
plt.plot(np.array(t_attack),np.array(eleHWP_attack)/1000,'r-', linewidth=1) #
plt.ylabel('Hot Water Pump [kW]')
#plt.ylim([10,20])
plt.legend(['Baseline','Attack'])
plt.xticks(np.arange(startTime,endTime,4*3600),np.arange(0,25,4))
plt.xlabel('Hours')

fig.add_subplot(428)
plt.plot(np.array(t_base),np.array(eleTot_base)/1000,'b--',markevery=0.1,marker="o",markersize=3,linewidth=1) 
plt.plot(np.array(t_attack),np.array(eleTot_attack)/1000,'r-', linewidth=1) #
plt.ylabel('Total Power [kW]')
#plt.ylim([0,100])
plt.legend(['Baseline','Attack'])
plt.xticks(np.arange(startTime,endTime,4*3600),np.arange(0,25,4))
plt.xlabel('Hours')

plt.savefig("power.svg")
plt.savefig("power.pdf")
plt.savefig("power.png")

#### post-processing for KPIs
## baseline system
# Energy Efficiency
eneEffTot_base = integral(t_base, eleTot_base)/3600000
# 15 min demand
t_new = np.arange(startTime, endTime+1, 60)
powPro_base = interp(t_base, eleTot_base, t_new, ['power'])
powDem_base = powPro_base['power'].groupby(powPro_base.index//(15*60)).mean().max()/1000
#print powDem_base
# zone temperature notmet hours
startOCC = 6*3600
endOCC = 19*3600
TCor_base = interp(t_base, TZonCor_base, t_new,['TCor'])
TCorNotmet_base = TCor_base[np.logical_and(TCor_base.index>=(startOCC+startTime),TCor_base.index<=(endOCC+startTime))]
#print TCorNotmet_base
TCorNotmet_base = np.logical_or(TCorNotmet_base<273.15+23,TCorNotmet_base>273.15+25)
#print TCorNotmet_base
TCorNotmet_base = TCorNotmet_base.sum().values[0]/60 # to hours
# equipment running time
chiRunTime_base = res_base['chiRunTim.y'][-1]/3600 # to hours
boiRunTime_base = res_base['boiRunTim.y'][-1]/3600 
supFanRunTime_base = res_base['supFanRunTim.y'][-1]/3600 
cooTowRunTime_base = res_base['cooTowRunTim.y'][-1]/3600 
CHWPRunTime_base = res_base['CHWPRunTim.y'][-1]/3600 
CWPRunTime_base = res_base['CWPRunTim.y'][-1]/3600 
HWPRunTime_base = res_base['HWPRunTim.y'][-1]/3600 

## attacked system
# Energy Efficiency
eneEffTot_attack = integral(t_attack, eleTot_attack)/3600000 # to kWh
# 15 min demand
t_new = np.arange(startTime, endTime+1, 60)
powPro_attack = interp(t_attack, eleTot_attack, t_new, ['power'])
powDem_attack = powPro_attack['power'].groupby(powPro_attack.index//(15*60)).mean().max()/1000 # to kW
#print powDem_attack
# zone temperature notmet hours
startOCC = 6*3600
endOCC = 19*3600
TCor_attack = interp(t_attack, TZonCor_attack, t_new,['TCor'])
TCorNotmet_attack = TCor_attack[np.logical_and(TCor_attack.index>=(startOCC+startTime), TCor_attack.index<=(endOCC+startTime))]
#print TCorNotmet_attack
TCorNotmet_attack = np.logical_or(TCorNotmet_attack<273.15+23, TCorNotmet_attack>273.15+25)
#print TCorNotmet_attack
TCorNotmet_attack = TCorNotmet_attack.sum().values[0]/60 # to hours
# equipment running time
chiRunTime_attack = res_attack['chiRunTim.y'][-1]/3600 # to hours
boiRunTime_attack = res_attack['boiRunTim.y'][-1]/3600 
supFanRunTime_attack = res_attack['supFanRunTim.y'][-1]/3600 
cooTowRunTime_attack = res_attack['cooTowRunTim.y'][-1]/3600 
CHWPRunTime_attack = res_attack['CHWPRunTim.y'][-1]/3600 
CWPRunTime_attack = res_attack['CWPRunTim.y'][-1]/3600 
HWPRunTime_attack = res_attack['HWPRunTim.y'][-1]/3600 

## save the results to a csv
column_order = ["eneEff (kWh)","powDem (kW)","TNotMet_Core (h)", 
            "ChiRunTim (h)","BoiRunTim (h)","SupFanRunTim (h)","CooTowRunTim (h)",
            "CHWPRunTim (h)","CWPRunTim (h)","HWPRunTim (h)"]
kpi = pd.DataFrame()
kpi = pd.DataFrame({"eneEff (kWh)": [eneEffTot_base, eneEffTot_attack],
                    "powDem (kW)": [powDem_base, powDem_attack],
                    "TNotMet_Core (h)":[TCorNotmet_base,TCorNotmet_attack],
                    "ChiRunTim (h)":[chiRunTime_base, chiRunTime_attack],
                    "BoiRunTim (h)":[boiRunTime_base, boiRunTime_attack],
                    "SupFanRunTim (h)":[supFanRunTime_base, supFanRunTime_attack],
                    "CooTowRunTim (h)":[cooTowRunTime_base, cooTowRunTime_attack],
                    "CHWPRunTim (h)":[CHWPRunTime_base,CHWPRunTime_attack],
                    "CWPRunTim (h)":[CWPRunTime_base, CWPRunTime_attack],
                    "HWPRunTim (h)":[HWPRunTime_base, HWPRunTime_attack]}, index=['baseline','attack'])
kpi = kpi[column_order].T.to_csv('kpi.csv')