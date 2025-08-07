# -*- coding: utf-8 -*-
"""
Created on Tue Dec  8 22:07:12 2020

@author: Xing Lu
"""
import numpy as np
import matplotlib.pyplot as plt
from buildingspy.simulate.Simulator import Simulator
from buildingspy.io.outputfile import Reader
import pandas as pd
import os, shutil
import scipy.interpolate as interpolate
import ast

def simulateCase(s):
    """ Set common parameters and run a simulation.

	:param s: A simulator object.

	"""
    s.showGUI(show=True)
    s.setStartTime(startTime)
    s.setStopTime(stopTime)
    s.setSolver(solver)
    s.setTolerance(tolerance)
    s.setOutputDirectory(resultsPath)
    s.setResultFile(resultFile)
    #s.setNumberOfIntervals(numInterval)
    #s.exitSimulator(exitAfterSimulation=False)
    s.simulate()
    
def interp(t_old,x_old,t_new,columns):
	intp = interpolate.interp1d(t_old, x_old, kind='linear')
	x_new = intp(t_new)
	x_new = pd.DataFrame(x_new, index=t_new, columns=columns)
	return x_new    
    
packagePath="F:/modelica-fault-library/FaultInjection"
resultsPath="G:/PFIFaultSimulation/results"
storePath="G:/PFIFaultSimulationResults/"
os.chdir(packagePath)


## Set simulation parameters
startTime = 17625600
stopTime = 18230400
solver = "Cvode"
tolerance = 0.0001
model = "FaultInjection.Systems.PhysicalFault.BaselineSystem"


os.chdir("G:/PFIFaultSimulation/CoolingSeason")
scenarios = pd.read_csv('scenario.csv',usecols=['scenarios','faultparameters'])

#Loop to simulate scenario i
for i in range(len(scenarios.index)):
    #Fault parameters in scenario i
    fault_parameters=scenarios.loc[i,'faultparameters']
    fault_parameters_list=fault_parameters.split('\n')
    scenario_name=scenarios.loc[i,'scenarios']
    
    s = Simulator(model, 'dymola',packagePath)
    #Loop fault parameter j to be changed in scenario i
    for j in range(len(fault_parameters_list)):
        s.addParameters(ast.literal_eval(fault_parameters_list[j]))
    resultFile=scenario_name
    simulateCase(s)
    #Move resultFile from resultPath to storePath that is located outside the package
    os.chdir(resultsPath)
    shutil.move(resultFile+".mat", storePath)
    print (scenario_name+" done")
    

'''
#Read results
os.chdir(resultsPath)
res_base=Reader(scenario_name+'.mat','dymola')
t_fault,TCHWSup_fault = res_base.values('TCHWSup.T')
t_base,TCHWSup_base = res_base.values('TCHWSup.senTem.T')

#Resample to 1 mins
t_new = np.arange(startTime, stopTime+1, 60)
TCHWSup_base_1min = interp(t_base, TCHWSup_base, t_new, ['TCHWSup_base'])

t_new = np.arange(startTime, stopTime+1, 60)
TCHWSup_fault_1min = interp(t_fault, TCHWSup_fault, t_new, ['TCHWSup_fault'])


#Plot
plt.plot(TCHWSup_base_1min.index,TCHWSup_base_1min.iloc[:,0])
plt.plot(TCHWSup_fault_1min.index,TCHWSup_fault_1min.iloc[:,0])
'''