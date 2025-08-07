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
# dymola result reader
from buildingspy.io.outputfile import Reader


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


# simulate time setup
time_duration = 24*3600. # 1 days
startTime = 207*24*3600. # start from day 207
endTime = startTime + time_duration # end time
dt = 3600. # time step

res_base=Reader('BaselineSystemDymola.mat','dymola')
res_attack=Reader('SignalCorruptionDymola.mat','dymola')

## get output variables 
# base system

t_base, chiOn_base = res_base.values('chiOnAtt.u')

t_base,TZonCor_base = res_base.values('flo.TRooAir[5]')
t_base,yDamVAVCor_base = res_base.values('conVAVCor.yDam')
t_base,VDisFloVAVCor_base = res_base.values('conVAVCor.VDis_flow')
t_base,speSupFan_base = res_base.values('fanSup.y')
t_base,TCHW_base = res_base.values('TCHWSup.T')
t_base,TCHWSet_base = res_base.values('temDifPreRes.TSet')
t_base,yValCooCoi_base = res_base.values('watVal.y')
t_base,TSupAir_base = res_base.values('TSup.T')
t_base,TSupAirSet_base = res_base.values('conAHU.TSupSet')
t_base,TMixAir_base = res_base.values("TMix.T")
t_base,qCooCoi_base = res_base.values("cooCoi.Q1_flow")

t_base,eleCoiVAV_base = res_base.values('eleCoiVAV.y')
t_base,eleSupFan_base = res_base.values('eleSupFan.y')
t_base,eleChi_base = res_base.values('eleChi.y')
t_base,eleCHWP_base = res_base.values('eleCHWP.y')
t_base,eleCWP_base = res_base.values('eleCWP.y')
t_base,eleCT_base = res_base.values('eleCT.y')
t_base,eleHWP_base = res_base.values('eleHWP.y')
t_base,gasBoi_bas = res_base.values('gasBoi.y')

t_base,eleTot_base = res_base.values('eleTot.y')

# attacked system
t_attack,chiOn_orig_attack = res_attack.values('chiOnAtt.u')
t_attack,chiOn_corr_attack = res_attack.values('chiOnAtt.y')

t_attack,TZonCor_attack = res_attack.values('flo.TRooAir[5]')
t_attack,yDamVAVCor_attack = res_attack.values('conVAVCor.yDam')
t_attack,VDisFloVAVCor_attack = res_attack.values('conVAVCor.VDis_flow')
t_attack,speSupFan_attack = res_attack.values('fanSup.y')
t_attack,TCHW_attack = res_attack.values('TCHWSup.T')
t_attack,TCHWSet_attack = res_attack.values('temDifPreRes.TSet')
t_attack,yValCooCoi_attack = res_attack.values('watVal.y')
t_attack,TSupAir_attack = res_attack.values('TSup.T')
t_attack,TSupAirSet_attack = res_attack.values('conAHU.TSupSet')
t_attack,TMixAir_attack = res_attack.values("TMix.T")
t_attack,qCooCoi_attack = res_attack.values("cooCoi.Q1_flow")

t_attack,eleCoiVAV_attack = res_attack.values('eleCoiVAV.y')
t_attack,eleSupFan_attack = res_attack.values('eleSupFan.y')
t_attack,eleChi_attack = res_attack.values('eleChi.y')
t_attack,eleCHWP_attack = res_attack.values('eleCHWP.y')
t_attack,eleCWP_attack = res_attack.values('eleCWP.y')
t_attack,eleCT_attack = res_attack.values('eleCT.y')
t_attack,eleHWP_attack = res_attack.values('eleHWP.y')
t_attack,gasBoi_attack = res_attack.values('gasBoi.y')

t_attack,eleTot_attack = res_attack.values('eleTot.y')



# plots
# plots
fig = plt.figure(figsize=(12,12))
fig.add_subplot(521)
plt.plot(np.array(t_base),np.array(chiOn_base),'b--',markevery=0.1,marker="o",markersize=3,linewidth=1) #
plt.plot(np.array(t_attack),np.array(chiOn_corr_attack),'r-', linewidth=1) # 
#plt.plot(np.array(t_attack),np.array(chiOn_orig_attack),'g:', linewidth=1) # 
plt.ylabel('Chiller On')
plt.ylim([-0.5,2])
plt.legend(['Baseline ','Attack'],loc=1)
plt.xticks(np.arange(startTime,endTime,4*3600),[])

fig.add_subplot(522)
plt.plot(np.array(t_base),np.array(TSupAirSet_base)-273.15,'b--',markevery=0.1,marker="o",markersize=3,linewidth=1) 
plt.plot(np.array(t_attack),np.array(TSupAirSet_attack)-273.15,'r-', linewidth=1) #
plt.ylabel('TSA Set [C]')
plt.ylim([10,30])
plt.legend(['Baseline','Attack'])
plt.xticks(np.arange(startTime,endTime,4*3600),[])

fig.add_subplot(523)
plt.plot(np.array(t_base),np.array(TSupAir_base)-273.15,'b--',markevery=0.1,marker="o",markersize=3,linewidth=1) 
plt.plot(np.array(t_attack),np.array(TSupAir_attack)-273.15,'r-', linewidth=1) #
plt.ylabel('TSA [C]')
plt.ylim([10,30])
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
plt.ylim([-0.1,3.1])
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
plt.ylim([4,16])
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

# zone temperature notmet hours
startOCC = 6*3600
endOCC = 19*3600
TCor_base = interp(t_base, TZonCor_base, t_new,['TCor'])
TCorNotmet_base = TCor_base[np.logical_and(TCor_base.index>=(startOCC+startTime),TCor_base.index<=(endOCC+startTime))]

TCorNotmet_base = np.logical_or(TCorNotmet_base<273.15+23,TCorNotmet_base>273.15+25)

TCorNotmet_base = TCorNotmet_base.sum().values[0]/60 # to hours
# equipment running time
chiRunTime_base = res_base.values('chiRunTim.y')[-1][-1]/3600 # to hours
boiRunTime_base = res_base.values('boiRunTim.y')[-1][-1]/3600 
supFanRunTime_base = res_base.values('supFanRunTim.y')[-1][-1]/3600 
cooTowRunTime_base = res_base.values('cooTowRunTim.y')[-1][-1]/3600 
CHWPRunTime_base = res_base.values('CHWPRunTim.y')[-1][-1]/3600 
CWPRunTime_base = res_base.values('CWPRunTim.y')[-1][-1]/3600 
HWPRunTime_base = res_base.values('HWPRunTim.y')[-1][-1]/3600 

# equipment switch time
chiSwiTime_base = res_base.values('swiTimChi.y')[-1][-1] # to hours
boiSwiTime_base = res_base.values('swiTimBoi.y')[-1][-1]
supFanSwiTime_base = res_base.values('swiTimFan.y')[-1][-1]
cooTowSwiTime_base = res_base.values('swiTimCooTow.y')[-1][-1]
CHWPSwiTime_base = res_base.values('swiTimCHWP.y')[-1][-1]
CWPSwiTime_base = res_base.values('swiTimCWP.y')[-1][-1]
HWPSwiTime_base = res_base.values('swiTimHWP.y')[-1][-1]

## attacked system
# Energy Efficiency
eneEffTot_attack = integral(t_attack, eleTot_attack)/3600000 # to kWh
# 15 min demand
t_new = np.arange(startTime, endTime+1, 60)
powPro_attack = interp(t_attack, eleTot_attack, t_new, ['power'])
powDem_attack = powPro_attack['power'].groupby(powPro_attack.index//(15*60)).mean().max()/1000 # to kW

# zone temperature notmet hours
startOCC = 6*3600
endOCC = 19*3600
TCor_attack = interp(t_attack, TZonCor_attack, t_new,['TCor'])
TCorNotmet_attack = TCor_attack[np.logical_and(TCor_attack.index>=(startOCC+startTime), TCor_attack.index<=(endOCC+startTime))]

TCorNotmet_attack = np.logical_or(TCorNotmet_attack<273.15+23, TCorNotmet_attack>273.15+25)

TCorNotmet_attack = TCorNotmet_attack.sum().values[0]/60 # to hours
# equipment running time
chiRunTime_attack = res_attack.values('chiRunTim.y')[-1][-1]/3600 # to hours
boiRunTime_attack = res_attack.values('boiRunTim.y')[-1][-1]/3600 
supFanRunTime_attack = res_attack.values('supFanRunTim.y')[-1][-1]/3600 
cooTowRunTime_attack = res_attack.values('cooTowRunTim.y')[-1][-1]/3600 
CHWPRunTime_attack = res_attack.values('CHWPRunTim.y')[-1][-1]/3600 
CWPRunTime_attack = res_attack.values('CWPRunTim.y')[-1][-1]/3600 
HWPRunTime_attack = res_attack.values('HWPRunTim.y')[-1][-1]/3600 

# equipment switching time
chiSwiTime_attack = res_attack.values('swiTimChi.y')[-1][-1]
boiSwiTime_attack = res_attack.values('swiTimBoi.y')[-1][-1] 
supFanSwiTime_attack = res_attack.values('swiTimFan.y')[-1][-1] 
cooTowSwiTime_attack = res_attack.values('swiTimCooTow.y')[-1][-1] 
CHWPSwiTime_attack = res_attack.values('swiTimCHWP.y')[-1][-1] 
CWPSwiTime_attack = res_attack.values('swiTimCWP.y')[-1][-1] 
HWPSwiTime_attack = res_attack.values('swiTimHWP.y')[-1][-1] 

## save the results to a csv
column_order = ["eneEff (kWh)","powDem (kW)","TNotMet_Core (h)", 
            "ChiRunTim (h)","BoiRunTim (h)","SupFanRunTim (h)","CooTowRunTim (h)",
            "CHWPRunTim (h)","CWPRunTim (h)","HWPRunTim (h)","ChiSwiTim","BoiSwiTim","SupFanSwiTim","CooTowSwiTim",
             "CHWPSwiTim","CWPSwiTim","HWPSwiTim"]
             
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
                    "HWPRunTim (h)":[HWPRunTime_base, HWPRunTime_attack],
                    "ChiSwiTim": [chiSwiTime_base,chiSwiTime_attack],
                    "BoiSwiTim": [boiSwiTime_base,boiSwiTime_attack],
                    "SupFanSwiTim": [supFanSwiTime_base,supFanSwiTime_attack],
                    "CooTowSwiTim": [cooTowSwiTime_base,cooTowSwiTime_attack],
                    "CHWPSwiTim": [CHWPSwiTime_base,CHWPSwiTime_attack],
                    "CWPSwiTim": [CWPSwiTime_base,CWPSwiTime_attack],
                    "HWPSwiTim": [HWPSwiTime_base,HWPSwiTime_attack]
                    }, index=['baseline','attack'])
kpi = kpi[column_order].T.to_csv('kpi.csv')