# -*- coding: utf-8 -*-
"""
This script post-processes the raw simulation results saved in json files, calculate demand flexibility for different cases and compare the demand flexibility difference.


Author: Yangyang Fu
Email: yangyang.fu@tamu.edu
Revisions: 
    10/14/2020: first implementation
"""
# import numerical package
import numpy as np
import matplotlib
matplotlib.use('agg')
import matplotlib.pyplot as plt

# dump results as json
import json
# load pandas
import pandas as pd

import scipy.interpolate as interpolate

# simulate setup
time_duration = 24*3600. # 1 days
startTime = 207*24*3600. # start from day 207
endTime = startTime + time_duration # end time
dt = 3600. # time step

## load json results
pow_bas = pd.read_csv('power_base_pert.csv')
pow_att = pd.read_csv('power_attack_pert.csv')

# read individual power profile
# interpolate at an interval of 1 min
dtp = 60
t_new = np.arange(startTime,endTime+1,dtp)

# read pertubated power in base systems
bas_bas = pow_bas[['time_base','power_base']].dropna()
upw_bas = pow_bas[['time_up','power_up']].dropna()
dow_bas = pow_bas[['time_down','power_down']].dropna()

def interp(t_old,x_old,t_new,columns):
	intp = interpolate.interp1d(t_old, x_old, kind='linear')
	x_new = intp(t_new)
	x_new = pd.DataFrame(x_new, index=t_new, columns=columns)
	return x_new

bas_bas_interp = interp(t_old=bas_bas['time_base'].values,x_old=bas_bas['power_base'].values,t_new=t_new, columns=['power_base'])
upw_bas_interp = interp(t_old=upw_bas['time_up'].values,x_old=upw_bas['power_up'].values,t_new=t_new, columns=['power_up'])
dow_bas_interp = interp(t_old=dow_bas['time_down'].values,x_old=dow_bas['power_down'].values, t_new=t_new, columns=['power_down'])

flex_up_bas = pd.DataFrame()
flex_up_bas['up']=upw_bas_interp['power_up'] - bas_bas_interp['power_base']
flex_down_bas = pd.DataFrame()
flex_down_bas['down'] = bas_bas_interp['power_base'] - dow_bas_interp['power_down']

# resample the 1 min flexibility into 60 minutes by using the average
flex_up_bas_60 = flex_up_bas['up'].groupby(flex_up_bas.index // (60*dtp) ).mean()
flex_down_bas_60 = flex_down_bas['down'].groupby(flex_down_bas.index // (60*dtp)).mean()
flex_bas = pd.concat([flex_up_bas_60, flex_down_bas_60], axis=1)
print flex_bas

flex_bas.to_csv('flex_bas.csv')
## ------------------------------------------------------------------
## read raw power data from faulty system
## --------------------------------------------------------------------
# read pertubated power in base systems
bas_att = pow_att[['time_base','power_base']].dropna()
upw_att = pow_att[['time_up','power_up']].dropna()
dow_att = pow_att[['time_down','power_down']].dropna()

# interpolate to equal time distance; 1 minute
bas_att_interp = interp(t_old=bas_att['time_base'].values,x_old=bas_att['power_base'].values,t_new=t_new, columns=['power_base'])
upw_att_interp = interp(t_old=upw_att['time_up'].values,x_old=upw_att['power_up'].values,t_new=t_new, columns=['power_up'])
dow_att_interp = interp(t_old=dow_att['time_down'].values,x_old=dow_att['power_down'].values, t_new=t_new, columns=['power_down'])

flex_up_att = pd.DataFrame()
flex_up_att['up']=upw_att_interp['power_up'] - bas_att_interp['power_base']
flex_down_att = pd.DataFrame()
flex_down_att['down'] = bas_att_interp['power_base'] - dow_att_interp['power_down']

# resample the 1 min flexibility into 60 minutes by using the average
flex_up_att_60 = flex_up_att['up'].groupby(flex_up_att.index // (60*dtp) ).mean()
flex_down_att_60 = flex_down_att['down'].groupby(flex_down_att.index // (60*dtp)).mean()
flex_att = pd.concat([flex_up_att_60, flex_down_att_60],axis=1)
print flex_att

flex_att.to_csv('flex_att.csv')

##-------------------------------------------------------------------
##  how to plot the differences
##----------------------------------------------------------------

fig = plt.figure(figsize=(6,4))
fig.add_subplot(211)
plt.step(flex_bas.index,flex_bas['up']/1000,'b-',where='post', linewidth=1) #
plt.step(flex_att.index,flex_att['up']/1000,'r-',where='post', linewidth=1) # 
plt.ylabel('Upward \nFlexibility [kW]')
plt.legend(['Baseline ','Attack'])
plt.ylim([-1,20])
plt.xticks(np.arange(startTime/3600,endTime/3600,4),[])

fig.add_subplot(212)
plt.step(flex_bas.index,flex_bas['down']/1000,'b-', where='post', linewidth=1) 
plt.step(flex_att.index,flex_att['down']/1000,'r-', where='post', linewidth=1) #
plt.ylabel('Downward\nFlexibility [kW]')
plt.legend(['Baseline','Attack'])
plt.ylim([-1,20])
plt.xticks(np.arange(startTime/3600,endTime/3600+1,4),np.arange(0,25,4))
plt.xlabel('Hour')

plt.savefig('df.pdf')
plt.savefig('df.svg')
plt.savefig('df.png')
