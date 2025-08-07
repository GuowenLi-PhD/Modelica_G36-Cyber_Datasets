.. _SetThreatInjection:

Threat Injection
================

The threats as defined in the previous section can be injected into a Modelica model by two ways 
depending on how the threatened variables are defined in the model. 
These three injection methods are variable injection, parameter injection and connector injection. 
Details are provided as below. 

Time-variant Variable Injection
    Time-variant Variable in Modelica refers to a kind of Modelica object that can change its value over time during a simulation. 
    An example is the output of a controller, which is adaptively updated over time to respond to external disturbances. 
    Time-variant Variable Injection means threats are injected to time-variant variables by overwriting its value during a simulation. 
    This type of injection applies to the majority of HVAC equipment and system faults such as stuck actuators, sensor noises, etc.

Time-invariant Parameter Injection 
    Time-invariant variable in Modelica is known as constant that never changes but can be substituted by its value. 
    An example is the gravitational acceleration constant `g` on the Earth that is 9.8 m/s^2. 
    A special type of time-invariant variables is simulation parameter. 
    Values of these simulation parameter constants are assigned only at the start of the simulation and kept as the constant during simulation. 
    For example, the nominal capacity of a chiller is a simulation parameter, and it will not change during a simulation. 
    Time-invariant Parameter Injection means a threat is injected to a time-invariant parameter by overwriting its value during simulations if possible. 
    This type of fault injection applies to scenarios such as fouling cooling coils with a degraded nominal UA, or degraded fan efficiency curves. 
    However, the value of a simulation parameter cannot be changed as defined in Modelica during a simulation. 
    One way to work around this is to split a simulation into a group of consequential simulations with a shorter duration. 
    For example, a one-day simulation can be split into 24 one-hour consequential simulations. 
    And for each short-simulation, the parameter can be assigned to different values.


Time-variant Variable Injection
-------------------------------



Time-invariant Parameter Injection
------------------------------------
