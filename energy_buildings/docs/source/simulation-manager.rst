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

Simulation Attributes
---------------------

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


Simulation Methods
------------------

simulate()
^^^^^^^^^^^

With defined attributes for each specific case, the simulation can be lauched by using a developed method *simulate*. 
This method contains the following sequential procedures:

:step 1: 
    parse the wrapper fmu model and check if the names of threatened variables are correctly exposed in the wrapper model. Raise errors if not.

:step 2: 
    parse the threat list to extract active threats, and divide them into variable-type and parameter-type threats. 

:step 3: 
    perform simulations for each time step from experiment start time to experiment end time using the *do_step* method.


do_step()
^^^^^^^^^^
This method is to perform step-wise co-simulation between the FMU wrapper model and the threat injection model as defined in Python.
Smaller steps are required if during the current co-simulation step any parameter-type threats and variable-type threat are injected.
Current co-simulation step is then divided into smaller steps as illustrated in :numref:`fig-smallstep`.
At the step :math:`n-1` (:math:`t_{n-1}` - :math:`t_n`), two threats (:math:`th_1` and :math:`th_2`) are injected. 
The threat :math:`th_1` ends within the current step, while the threat :math:`th_2` does not end in the current step.
To be able to change the settings of FMU parameters and inputs for each threat, the start and end time of each threat is used to divide current co-simulation time step into smaller steps (e.g., :math:`\Delta t_1, \Delta t_2, \Delta t_3, \Delta t_4, \Delta t_5`.)

.. _fig-smallstep: 
.. figure:: /figures/small-step.pdf
    :width: 400pt
    :align: center

    Illustration of dividing a communication step into smaller steps

In each small step, the values of threatened variables or parameters are accordingly updated.


baseline()
^^^^^^^^^^
This method is to calculate the baseline reponse of such a system without any threats injected. 
Before the baseline calculation starts, the wrapper FMU states should be reset.
The calculation starts from the experiment start time to the experiment end time.


