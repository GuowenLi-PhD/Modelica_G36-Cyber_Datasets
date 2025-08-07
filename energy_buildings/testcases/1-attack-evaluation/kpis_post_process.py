"""Script that post-process the KPIs from different cases
"""
import os
import pandas as pd

cwd = os.path.dirname(os.path.realpath(__file__))
kpis_file = 'kpis.csv'
dfs_file = 'dfs.csv'
ncase=16

ener_tot = pd.DataFrame(index=['ener_tot'])
pow_peak = pd.DataFrame(index=['pow_peak'])
tdis_tot = pd.DataFrame(index=['tdis_tot'])
timdis_tot = pd.DataFrame(index=['timdis_tot'])

dfs_up = pd.DataFrame()
dfs_down = pd.DataFrame()
for i in range(ncase):
    case = 'case'+str(i)
    case_dir = cwd+'/'+case+'/'
    
    # get some kpis
    kpis = pd.read_csv(case_dir+kpis_file)
    ener_tot[case]  = kpis.sum()['ener_tot']
    pow_peak[case] = kpis.sum()['pow_peak']
    tdis_tot[case] = kpis.sum()['tdis_tot']
    timdis_tot[case] = kpis.sum()['timdis_tot']

    # get demand flexibility
    df = pd.read_csv(case_dir+dfs_file,index_col=[0])
    dfs_up.reindex(df.index)
    dfs_up[case] = df['up'].values
    dfs_down.reindex(df.index)
    dfs_down[case] = df['down'].values

# export to csv
ener_tot.to_csv('energy_total.csv')
pow_peak.to_csv('power_peak.csv')
tdis_tot.to_csv('tdiscomfort.csv')
timdis_tot.to_csv('unmet_hours.csv')

dfs_up.to_csv('df_up.csv')
dfs_down.to_csv('df_down.csv')
