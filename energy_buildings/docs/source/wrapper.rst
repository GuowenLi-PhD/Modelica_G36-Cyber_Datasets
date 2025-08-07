.. _SetEmulationModel:

Threat-free FMU Wrapper
========================
This section describes the automatic construction of a wrapper model based on the given 
Modelica template. 
Two types of signals can exchange data with external entities as defined in the Modelica template: 
Modelica varaibles that represent control inputs and system measurements, 
and Modelica parameters that represent the system high-level configuration settings.
With the utilization of the *Overwrite* package as mentioned in :numref:`SetModelicaTemplate`, 
the FMU model of the Modelica template can be automatically parsed using a python library *parsing* to 
locate the instances of *OverwriteVariable* and/or *OverwriteParameter*. 
These instances are then used to create a Modelica/FMU wrapper 
for threat injection and simulation in a python envrionment.

A *parsing* library is developed in Python and contains the following main functions:

(1) Translate the Modelica template into a FMU template. 
    The python package *pydymola* that inherits *buildingspy* is developed to generate Dymola FMU, 
    and the python library *pyjmodelica* that was developed by Modelon is used here to generate jModelica FMU.
(2) Locate the exchanged signals in the FMU template. 
    The python package *parser* parses the FMU documentation, 
    and locates the exchanged signals by searching the keywords 
    :code:`mtiOverwriteVariable` and :code:`mtiOverwriteParameter` as defined in the *Overwrite* Modelica package.
    All the instances of :code:`OverwriteVariable` and :code:`OverwriteParameter` are located in this step. 
(3) Write a Modelica wrapper by propogating exchanged signals to the top-level.
    The python package *parser* automatically writes a Modelica wrapper model using the information of 
    located instances. First, a Modelica wrapper model named *wrapper.mo* is created 
    by instantiating an instance of the original Modelica template. 
    Second, two inputs for each instance of :code:`OverwriteVariable` are added to the wrapper.
    The inputs are named :code:`<block_instance>_u` and :code:`<block_instance>_activate`. 
    The unit, description, minimum and maximum value, start value and other signal attributes are 
    read and assiged to each :code:`<block_instance>_u`.
    Third, one parameter for each instance of :code:`OverwriteParameter` is added to the wrapper.
    The parameter is named as :code:`<block_instance_p>`. 
    The unit, description, minimum and maximum value, start value and other signal attributes are 
    read and assiged to each :code:`<block_instance>_p`.
    Forth, connect :code:`<block_instance>_u` to :code:`<block.instance>.u` 
    and :code:`<block_instance>_activate` to :code:`<block.instance>.activate`.
    Fifth, connect :code:`<block_instance>_p` to :code:`<block.instance>.p`. 
(4) Translates the Modelica wrapper model into a FMU wrapper model. 
    The FMU wrapper is named *wrapper.fmu*.

An external interface may use the inputs and parameters in the wrapper model 
to send corrupted signals to specific overwrite blocks, 
activation signals (activate) to enable and disable signal overwriting.  
By default, the activation of the signal overwrite block is set to :code:`False`.  
In this way, external interfaces need to only define control signals 
for those that are being overwritten.

:numref:`fig-wrapper` shows a generated Modelica wrapper for the Modelica template as illustrated in :numref:`fig-template`.
The template contains one instance of :code:`OverwriteVariable` named :code:`oveTSetChiWatSup` 
to overwrite the normal chilled water temperature setpoint, 
and instance of :code:`OverwriteParameter` named :code:`oveTCooOn` to overwrite the global
zone temperature setpoint when cooling is on.
The generated wrapper instantiates the original Modelica template to represent an HVAC and control system
under normal operations.
Two inputs :code:`oveTSetChiWatSup_u` and :code:`oveTSetChiWatSup_activate` are added 
to receive external chilled water supply temperature setpoints and the activation status of overwriting.
One parameter :code:`oveTCooOn_p` is added to the wrapper to receive external cooling setpoints for zones.

.. _fig-wrapper: 
.. figure:: /figures/3-ModelicaWrapper.pdf
    :width: 400pt
    :align: center

    An example of auto-generated Modelica wrapper



