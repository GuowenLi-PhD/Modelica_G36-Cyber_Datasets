import numpy as np

import pandas as pd

import os

import scipy.interpolate as interpolate

import csv

from buildingspy.io.outputfile import Reader

# Yangyang's paper in Applied Energy: https://doi.org/10.1016/j.apenergy.2021.117639

#Pathes and files

#cyber-attack 1 (shoulder season)
scePath1 = 'C:/Users/guowenli/Desktop/PhD_Papers/J7_DU_public_fault_attack_datasets/github_YF/applied_energy/Resources/Results_M1/cyber_attack_1/shoulder_season'
#cyber-attack 2 (cooling season)
scePath2 = 'C:/Users/guowenli/Desktop/PhD_Papers/J7_DU_public_fault_attack_datasets/github_YF/applied_energy/Resources/Results_M1/cyber_attack_2/cooling_season'
#cyber-attack 3 (cooling season)
scePath3 = 'C:/Users/guowenli/Desktop/PhD_Papers/J7_DU_public_fault_attack_datasets/github_YF/applied_energy/Resources/Results_M1/cyber_attack_3/cooling_season'
#cyber-attack 4 (cooling season)
scePath4 = 'C:/Users/guowenli/Desktop/PhD_Papers/J7_DU_public_fault_attack_datasets/github_YF/applied_energy/Resources/Results_M1/cyber_attack_4/cooling_season'

scePath = scePath4

colSce = 'scenarios'

resultPath = ' '

colName = 'Dymola Model Output Variable Expressions'

varFile = 'C:/Users/guowenli/Desktop/PhD_Papers/J7_DU_public_fault_attack_datasets/github_YF/Datapoint_modified_RBC.xlsx'

colDes = 'Description'

colUnit = 'Unit'

signRevFile = 'C:/Users/guowenli/Desktop/PhD_Papers/J7_DU_public_fault_attack_datasets/github_YF/Datapoint_signRevVar.csv'

dataExtPath = ' '

#--------------------------------------------------------------------------



#Simulation time

if scePath == scePath1:
    #1-day in shoulder season
    startTime = 83*24*3600. 
    stopTime = 84*24*3600.
else:
    #1-day in cooling season
    startTime = 207*24*3600.
    stopTime = 208*24*60*60



#Resample time at 5 min intervals

t_new = np.arange(startTime, stopTime+1, 60*5)

t_list = t_new.tolist()

t_list.insert(0,'time(s)')



#Read variable names from csv file and switch into list

#os.chdir(varPath)

varName_raw = pd.read_excel(varFile,usecols=[colName])
varName_raw = varName_raw.dropna().reset_index(drop=True)

des_raw = pd.read_excel(varFile,usecols=[colDes])
des_raw = des_raw.dropna().reset_index(drop=True)

unit_raw = pd.read_excel(varFile,usecols=[colUnit])
unit_raw = unit_raw.dropna().reset_index(drop=True)



#Read variables that need to be reversed

varNameRev_raw = pd.read_csv(signRevFile,usecols=[colName])

varNameRev_list = varNameRev_raw[colName].tolist()



#Read scenario names

os.chdir(scePath)
if scePath == scePath1:
    sceName_list = ['FaultInjection_Systems_CyberAttack_ShoulderSeason_BaselineSystem_result',
                    'FaultInjection_Systems_CyberAttack_ShoulderSeason_Scenario1_0SignalCorruption_result',]
elif scePath == scePath2:
    sceName_list = ['BaselineSystem_result',
                'SignalCorruption_0ChillerOn_result',]
elif scePath == scePath3:
    sceName_list = ['BaselineSystem_result',
                'SignalBlocking_result',]
elif scePath == scePath4:
    sceName_list = ['BaselineSystem_result',
                'SignalDelaying_result',]
    
sceName_new = ['baseline_dataset',
               'cyber_attack_dataset',]

#Scenario loop
for m in range(len(sceName_list)):

    #Read simulation result mat file

    os.chdir(scePath)

    try: 
        simResFile = sceName_list[m]+'.mat'
        print("\nsimResFile:",simResFile)

        simResult = Reader(simResFile,'dymola')

        #Create output csv file and write time intervals in the first row

        #os.chdir(scePath)

        csvFile_5min = sceName_new[m]+'_1day.csv'
        
        #Initialization total energy consumption
        ele = np.zeros(len(t_new))

        with open(csvFile_5min, mode='w',newline='') as csv_file:

            writer = csv.writer(csv_file)

            writer.writerow(t_list)

            #Resample simulation results and write them to output csv file
            for i in range(len(varName_raw.index)):

                varName = varName_raw.loc[i,colName]

                des = des_raw.loc[i,colDes]

                unit = unit_raw.loc[i,colUnit]

                t_old, x_old = simResult.values(varName)

                intp = interpolate.interp1d(t_old, x_old, kind='linear')

                if varName == 'boi.mFue_flow':

                    x_new = np.round(intp(t_new), 6)

                else:

                    x_new = np.round(intp(t_new), 2)

                #Reverse sign for specific variables

                if varName in varNameRev_list:

                    x_new = -x_new
                    
                #Change negative pressure value to 0

                if varName == 'conAHU.ducStaPre' or varName == 'cooCoi.Q1_flow':

                    for k in range(len(x_new)):

                        if x_new[k] < 0:

                            x_new[k] = 0

                #Change -0 to 0

                for j in range(len(x_new)):

                    if x_new[j] == -0:

                        x_new[j] = 0
                             
                # # add up to get total electricity and gas consumption
                # if varName == "boi.QFue_flow":

                #     gas = x_new

                # else:

                #     ele = ele + x_new

                

                # ele_list = ele.tolist()

                # gas_list = gas.tolist()

                # ele_list.insert(0,'Overall Electric Power Consumption of the HVAC System(W)')

                # gas_list.insert(0,'Gas Consumption(W)') 

                x_list = x_new.tolist()

                x_list.insert(0,des + '(' + unit + ')')

                writer.writerow(x_list)

        # Using a context manager to ensure safe file reading
        with open(csvFile_5min, 'r') as file:
            df = pd.read_csv(file, header=None, encoding='cp1252')

        # Transpose and save it correctly
        df_transposed = df.T

        with open(csvFile_5min, 'w') as file:
            df_transposed.to_csv(file, header=False, index=False)

        print("Dataset successfully post-processed:",csvFile_5min)

    except Exception as e:
        print("The error is: ",e)

        

                



