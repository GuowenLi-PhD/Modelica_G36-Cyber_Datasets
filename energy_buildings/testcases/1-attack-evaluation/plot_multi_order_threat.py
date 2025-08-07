"""Script that post-process the KPIs from different cases
"""
import os
import numpy as np
import pandas as pd
import matplotlib
#matplotlib.use('agg')
import matplotlib.pyplot as plt

cwd = os.path.dirname(os.path.realpath(__file__))
result_file = 'results.csv'

submeters=[ 'mod.eleCoiVAV.y',
            'mod.eleSupFan.y',
            'mod.eleChi.y',
            'mod.eleCHWP.y',
            'mod.eleCWP.y',
            'mod.eleCT.y',
            'mod.eleHWP.y']

case_no = [0,1,2,3,4,15]
pow_tot = {}
for no in case_no:
    case = 'case'+str(no)
    case_dir = cwd+'/'+case+'/'

    results = pd.read_csv(case_dir+result_file,index_col=[0])
    pows = results[submeters].sum(axis=1)
    pow_tot[case] = (pows.index,pows.values)

# add figure
xticks = np.arange(int(pow_tot['case0'][0][0]),int(pow_tot['case0'][0][-1])+1, 3600*4)
xticks_label = np.arange(0,24,4)

plt.figure(figsize=[12,6])
plt.plot(pow_tot['case0'][0],pow_tot['case0'][1]/1000, 'b--',label='Baseline',lw=1)
plt.plot(pow_tot['case1'][0],pow_tot['case1'][1]/1000, 'k-.',label='Case 1',lw=1)
plt.plot(pow_tot['case2'][0],pow_tot['case2'][1]/1000, 'm-.',label='Case 2',lw=1)
plt.plot(pow_tot['case3'][0],pow_tot['case3'][1]/1000, 'c-.',label='Case 3',lw=1)
plt.plot(pow_tot['case4'][0],pow_tot['case4'][1]/1000, 'y-.',label='Case 4',lw=1)
plt.plot(pow_tot['case15'][0],pow_tot['case15'][1]/1000, 'r-',label='Case 15',lw=1)
plt.ylabel('Power [kW]',fontsize=16)
plt.xlabel('Time [h]',fontsize=16)
plt.xticks(xticks,xticks_label,fontsize=14)
plt.yticks(fontsize=14)
plt.grid(linestyle='--')
plt.legend()

plt.savefig('multi_order_power.pdf')

