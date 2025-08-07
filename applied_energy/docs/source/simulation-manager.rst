.. _SetSimulationManager:

Simulation Manager
==================

Simulation manager defines a python class *cases* for different simulation scenarios. 
This library aims to provide the capability of simulating a Modelica FMU model with external inputs from
the Python environment.  
The simulation advances one experiment step until reaches the end of experiment. 
With each experiment step, the simulation manager decides if current step should be divided into multiple smaller steps
based on the needs of changing Modelica parameters during simulation, 
such as injecting a parameter-type threat in the mid of current experiment step.
The simulation results of key measurements are saved for post-processing.

A simulation case should have the following attributes:

:template:
    Modelica template that is designed to expose overwritten Modelica parameters and variables.
:template_path:
    Path of Modelica template.
:measurement_list:
    List of key measurements in the Modelica template for KPI calculations. If an empty list is assigned,
    all variables will be saved. If not empty, only the values of key measurements are stored during simulation.
:threat_list:
    List of injected threat objects, instantiated from *pythreat* library.
:start_time:
    Simulation experiment start time in seconds.
:end_time:
    Simulation experiment end time in seconds.
:step:
    Simulation experiment step in seconds, which defines the co-simulation FMU communication interval.
:simulator:
    Modelica compiler. 
:injection_step:
    Threat injection interval in seconds, which defines how frequently a threat signal is generated.
:fmu_options:
    Simulation options for FMU model.


Smaller steps are required if during the current experiment step the Modelica parameter should be changed.
The following figure illustrates the scheme of dividing one experiment step into smaller steps.

