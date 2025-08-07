.. _SetArchitecture:

Architecture
============
The software architecture of this framework is illustrated in :numref:`fig-architecture`.
A threat-free template model based on a normal threat-free Modelica model is first created in a Modelica envrionment using a developed Modelica *Overwrite* package.
The template model is then parsed and used to auto-generate a standalone FMU wrapper model (*wrapper.mo*), which is structured for threat injection.
Meanwhile, different types of threats are defined in a developed Python library (*pyThreat*).
These defined threats are then injected into the FMU wrapper model by utlizing the existing *pyFMI* library and a developed *pyThreat* library.
The threat-injected model is simulated in a simulation manager developed as the Python *pySimulate* library.

.. _fig-architecture: 
.. figure:: /figures/1-MTI.pdf
    :width: 400pt
    :align: center

    Schematic of threat injection framework


The summary of each module as in :numref:`fig-architecture` is listed as below:

:Threat-free Modelica Template: 
    This module defines a threat-free Modelica model based on a normal Modelica system or component model by using the developed Modelica overwrite package.
    The Modelica template model defines the status and the location of a set of threat injection actions.
    For example, if a chiller is to be macilously controlled off during a peak-load period, the on/off control signal received by the chiller should be overwritten by external programs (such as Python in this framework).
    The *Overwrite* package should be used here to make the injection of chiller on/off signal ready.

:Threat-free FMU Wrapper:
    The Modelica template is then parsed to autogenerate a FMU wrapper model, which wraps the template model by an extra input layer that defines all the possible threat locations (Modelica input connectors).
    That is, the wrapper model exposes all the threat injection locations defined by the instances of *Overwrite* package in the template model.
    These injection locations (Modelica input connectors) can then be used to receive external threats.

:Threat:
    Threats are defined in a Python environment using the *pyThreat* library.
    A threat is constructed by assigning key attributes such as start time, end time, injection location and type, temporal pattern etc.

:Simulation Manager:
    Simulation manager defines a simulation case by integrating Python threats with the FMU wrapper, and performs numerical simulation.
    The simulation results are processed by outputing real-time KPIs.
     

