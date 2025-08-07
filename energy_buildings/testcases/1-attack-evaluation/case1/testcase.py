"""
This is testing script for auto-modeling and simulation of threats in python fmu.

Author: Yangyang Fu
Email: yangyang.fu@tamu.edu
Revisions:
    12/15/2020: Added script
"""
import sys
import os
## change the working folder to be the python script folder
cwd = os.path.dirname(os.path.abspath(__file__))
pdir = os.path.dirname(cwd)
# ppdir = os.path.dirname(pdir)
# pppdir = os.path.dirname(ppdir)
os.chdir(cwd)
print("Current working directory:", os.getcwd())
# Add the parent directory of 'pysimulate' and 'pythreat' to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../../')))
print(sys.path)

# import parser
from pysimulate.simulation_manager import cases

# import pythreat
from pythreat.threat import ThreatInjection
from pythreat.threat import Threat
from pythreat.temporal import Temporal

# import others
import numpy as np
import pandas as pd
import matplotlib
#matplotlib.use('agg')
import matplotlib.pyplot as plt


### Specify Modelica template model
## ===============================================================
# write a modelica template model
model = "template.BaselineSystem"
# the faultinjection library is already in MODELICAPATH, 
# otherwise put libray path here.
model_path = [pdir+'\\model']

### Initialize a simulation case
## =============================================================
##
case = cases(template = model,
            template_path = model_path,
            simulator = 'dymola',)

### Experiment setup
## ============================================================
exp_start = 207*24*3600
exp_period = 24*3600
exp_end = exp_start + exp_period
exp_step = 24*3600.
inj_step = 2*60.

case.start_time = exp_start
case.final_time = exp_end
case.step = exp_step
case.injection_step = inj_step

### KPI calculation
## =============================================================
case.calculate_kpi = False#True
case.measurement_names = []
case.kpi_step = 3600

### Generate a wrapper FMU or specify the location of wrapper fmu
## ==============================================================
#case.generate_wrapper()
# or load existing wrapper fmu
case.wrapper_fmu_path =model_path[0]+'\\wrapped.fmu'
case.load_fmu()

### Parse FMU overwritten signals
## ==============================================================
oveSig, staSig = case.parse_signal()

### Construct injected threats
## ==============================================================
v1_name = 'oveSupFanSpe_u'
thr1 = Threat(active = True, 
            start_threat = 207*24*3600.+6*3600,
            end_threat= 207*24*3600.+19*3600,
            temporal = Temporal(oveSig[v1_name],'max'),
            injection = 'v')
v2_name = 'oveChiOn_u'            
thr2 = Threat(active = False, 
            start_threat = 207*24*3600.+12*3600,
            end_threat= 207*24*3600.+12*3600 + 3*3600,
            temporal = Temporal(oveSig[v2_name],'square',amplitude=1.,period=1800,offset=0),
            injection = 'v')

v3_name = 'oveTSetChiWatSup_u'
thr3 = Threat(active = False, 
            start_threat = 207*24*3600.+10*3600,
            end_threat= 207*24*3600.+10*3600 + 3*3600,
            temporal = Temporal(oveSig[v3_name],'block'),
            injection = 'v')

# parameter threat
p1_name = 'oveTCooOn_p'
thr4 = Threat(active = False, 
            start_threat = 207*24*3600.+13*3600,
            end_threat= 207*24*3600.+13*3600 + 2*3600,
            temporal = Temporal(oveSig[p1_name],'constant',k=273.15+22),
            injection = 'p')

thr_lis = [thr1,thr2,thr3,thr4]

case.threat_list = thr_lis
### FMU simulation options
## ================================================================
#
options = case.wrapper.simulate_options()
options['ncp'] = 500
#options['initialize'] = False

case.fmu_options=options

#initialize outputs
time = []
TZonResReq = []
TSupAir = []
TZoneCor= []
TZoneSetCor = []

### Start simulation 
## ==================================================================
case.simulate()
results = case.result

### get kpis 
kpis = case.kpis
dfs = case.dfs
kpis_cost = case.kpis_cost

kpis.to_csv('kpis.csv')
dfs.to_csv('dfs.csv')
kpis_cost.to_csv('kpis_cost.csv')

# save results to csv
results_dic = {}
meas_list = results[0].keys()

for meas in meas_list:
    result=[]
    for res in results:
        result += list(res[meas])
    results_dic[meas] = result

result_dic_to_df = pd.DataFrame(results_dic,index=results_dic['time'])
result_dic_to_df.to_csv('results.csv')

