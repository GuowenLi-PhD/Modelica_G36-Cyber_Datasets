import numpy as np

import pandas as pd

import os

import scipy.interpolate as interpolate

import csv

from buildingspy.io.outputfile import Reader

#Yangyang's paper in ENB: https://doi.org/10.1016/j.enbuild.2021.111263

#Pathes and files

#baseline model path
scePath0 = 'C:/Users/guowenli/Desktop/PhD_Papers/J7_DU_public_fault_attack_datasets/github_YF/energy_buildings/testcases/1-attack-evaluation/case0'
#cyber-attack 1 (day207)
scePath1 = 'C:/Users/guowenli/Desktop/PhD_Papers/J7_DU_public_fault_attack_datasets/github_YF/energy_buildings/testcases/1-attack-evaluation/case1'
#cyber-attack 2 (day207)
scePath2 = 'C:/Users/guowenli/Desktop/PhD_Papers/J7_DU_public_fault_attack_datasets/github_YF/energy_buildings/testcases/1-attack-evaluation/case2'
#cyber-attack 3 (day207)
scePath3 = 'C:/Users/guowenli/Desktop/PhD_Papers/J7_DU_public_fault_attack_datasets/github_YF/energy_buildings/testcases/1-attack-evaluation/case3'
#cyber-attack 4 (day207)
scePath4 = 'C:/Users/guowenli/Desktop/PhD_Papers/J7_DU_public_fault_attack_datasets/github_YF/energy_buildings/testcases/1-attack-evaluation/case4'

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

sceName_list = ['wrapped_result',]

if scePath == scePath0:    
    sceName_new = ['baseline_dataset',]
elif scePath == scePath1:
    sceName_new = ['cyber_attack1_dataset',]
elif scePath == scePath2:
    sceName_new = ['cyber_attack2_dataset',]
elif scePath == scePath3:
    sceName_new = ['cyber_attack3_dataset',]
elif scePath == scePath4:
    sceName_new = ['cyber_attack4_dataset',]

#Scenario loop
for m in range(len(sceName_list)):

    #Read simulation result mat file

    os.chdir(scePath)

    try: 
        if scePath == scePath3 or scePath == scePath4:
            simResult = pd.read_csv('results.csv', encoding='utf-8')
        else:
            simResFile = sceName_list[m]+'.mat'
            print("\nsimResFile:",simResFile)

            simResult = Reader(simResFile,'dymola')

        #Create output csv file and write time intervals in the first row
        csvFile_5min = sceName_new[m]+'_day207.csv'
        
        #Initialization total energy consumption
        ele = np.zeros(len(t_new))

        with open(csvFile_5min, mode='w',newline='') as csv_file:

            writer = csv.writer(csv_file)

            writer.writerow(t_list)

            #Resample simulation results and write them to output csv file
            for i in range(len(varName_raw.index)):

                varName = str('mod.') + varName_raw.loc[i,colName]

                des = des_raw.loc[i,colDes]

                unit = unit_raw.loc[i,colUnit]

                if scePath == scePath3 or scePath == scePath4:
                    t_old = simResult['time'].values
                    x_old = simResult[varName].values
                else:
                    t_old, x_old = simResult.values(varName)

                intp = interpolate.interp1d(t_old, x_old, kind='linear')

                if varName == 'mod.boi.mFue_flow':

                    x_new = np.round(intp(t_new), 6)

                else:

                    x_new = np.round(intp(t_new), 2)

                #Reverse sign for specific variables

                if varName in varNameRev_list:

                    x_new = -x_new
                    
                #Change negative pressure value to 0

                if varName.endswith('conAHU.ducStaPre') or varName.endswith('cooCoi.Q1_flow'):

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
            df = pd.read_csv(file, header=None, encoding='utf-8') #  encoding='cp1252'

        # Transpose and save it correctly
        df_transposed = df.T

        with open(csvFile_5min, 'w') as file:
            df_transposed.to_csv(file, header=False, index=False)

        print("Dataset successfully post-processed:",csvFile_5min)

    except Exception as e:
        print("The error is: ",e)

        

                



