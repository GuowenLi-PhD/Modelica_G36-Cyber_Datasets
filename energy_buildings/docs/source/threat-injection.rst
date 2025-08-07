.. _SetThreatInjection:

Threat and Threat Injection
============================

This chapter introduces a python libarary *pythreat* that defines a threat and its injection type. 
The threats in this report include passive threats and active threats.
A passive threat refers to one that is not injected by human beings such as outdoor air damper stuck. 
An active threat refers to any incident that is deliberately created with human actively engaged such as cyber-attacks.
The injection of such threats to a system refers to how the threats should be numerically injected to the system 
in order to be effective.
This library has the following structure 
and details about the definition of threats and threat injection can be found in :numref:`sec_threat_definition` and :numref:`sec_threat_injection` respectively.

::

	ThreatInjection         // Test case directory name
	|--start_time           // Start time of injection 
	|--end_time             // End time of injection
	|--step                 // Time step of injected signal
	|--injection            // Injection type for Modelica models
	|--threat               // Instance of Threat object
	|  |--active            // Resources directory with test case data
	|  |--start_threat      // Modelica model file
	|  |--end_threat        // BOPTEST ready FMU
	|  |--temporal          // Instance of Temporal object
	|  |  |--signal_type    // Instance of Signal object
	|  |  |  |--name        // Name of overwritten signal 
	|  |  |  |--min         // Minimum value of overwritten signal
	|  |  |  |--max         // Maximum value of overwritten signal
	|  |  |  |--unit        // Unit of overwritten signal  
	|  |  |--attacker       // Name of attacker model

.. _sec_threat_definition:

Threat Definition
------------------
A threat is defined as a Python class, which contains the following attributes:

:active:
    Flag of threat status. If a threat is active, then the signals required to exchange data with external entities
    are exposed in the wrapper model.
    If a threat is inactive, then the signals of the threat are not exposed in the wrapper model.

:start_threat:
    Starting time of a threat. If a threat is active, then it is injected to the wrapper model at this starting time.
:end_threat:
    Ending time of a threat. If a threat is active, then it is injected to the wrapper model till this ending time.
:temporal:
    Temporal pattern of a threat. This attribute defintes how a threat evolves over time. 
    Multiple basic models are provided in the library, including *constant*, *additive*, *random*, etc..
:injection:    
    Injection type. This attribute defines how a threat is injected a Modelica model. 
    Two types of injection types are available: :code:`'p'` is for time-invariant parameter type injection 
    and :code:`'v'` is for time-variant variable type injection.

Threat Temporal Pattern
^^^^^^^^^^^^^^^^^^^^^^^^
The attribute :code:`temporal` defines the trajectory of the threatend signal. 
It could be used to simulate a passive threat, for exapmple, fouling cooling coils,
and represent an attack behavior that changes control settings or measurements
of a targeted system.

The :code:`temporal` is implemented as a Python class, and any instantiations of such a class 
can be used to define a specif temporal pattern and be used for a threat definition.
The class :code:`temporal` itself contains the following attributes:

:signal_type:
    The type of signal to be overwritten. 
    This is an instance of a Python :code:`Signal` class. 
:attacker:
    Name of an attacker. This attritbute defines the temporal patterns of a signal under threat.

Signal Type
************

The signal type is defined as a Python class :code:`Signal`. To describe the signal, the following
attributes must be defined during instantiation.

:name:
    Name of the signal under threat. 
    This has to conform to the variable names as defined in the Modelica/FMU wrapper model.
    The name is used to locate the exposed signal that is ready to be overwritten.
:min:
    Minimum allowable value. The minimum allowable value for the overwritten signal is defined
    when using the Modelica *Overwrite* package in the Modelica template. 
    The definition is atumatically used here through the previous library :code:`parsing`.
:max:
    Maximum allowable value. The maximum allowable value for the overwritten signal is defined
    when using the Modelica *Overwrite* package in the Modelica template. 
    The definition is atumatically used here through the previous library :code:`parsing`. 
:unit:
    Signal unit. The physical unit for the overwritten signal is defined
    when using the Modelica *Overwrite* package in the Modelica template. 
    The definition is atumatically used here through the previous library :code:`parsing`. 

.. _subsec_attacker:

Attacker
********

The following basic attacker models are considered in this library. 
Users can also customize their models and integrate them here. 
In the following equations, :math:`\hat y` is the corrupted property value, 
:math:`y` is the original value, 
:math:`\Lambda` is the attack period, 
the subscripts :math:`min` and :math:`max` represent the minimum and maximum value of a signal, respectively.
The minimum and maximum values are needed to mimic the fact that a typical building automation system
would generate warnings and self-correct the values when deviations from bounded range are detected.

:Min: 
    The property value is overwritten to its minimum allowable value during the threat.

.. math:: \hat y(t) = \left\{\begin{matrix}
                    y(t),& t \notin \Lambda\\ 
                    y_{min}, & t \in \Lambda
                    \end{matrix}\right.

:Max: 
    The property value is overwritten to its maximum allowable value during the threat.

.. math:: \hat y(t) = \left\{\begin{matrix}
                    y(t),& t \notin \Lambda \\ 
                    y_{max}, & t \in \Lambda 
                    \end{matrix}\right.

:Constant: 
    The property value is overwritten to a user-defined constant value :math:`k` during the threat.

.. math:: \hat y(t) = \left\{\begin{matrix}
                    y(t),& t \notin \Lambda \\ 
                    k, & t \in \Lambda \ and \ k \in [y_{min}, y_{max}]\\
                    y_{min}, & t \in \Lambda \ and \ k < y_{min} \\
                    y_{max}, & t \in \Lambda \ and \ k > y_{max}                    
                    \end{matrix}\right.

:Scaling: 
    A scaling threat involves modifying the true signals to higher or lower values 
    depending on the scaling factor :math:`\alpha`.

.. math:: \hat y(t) = \left\{\begin{matrix}
                    y(t),& t \notin \Lambda \\ 
                    \alpha y(t), & t \in \Lambda \ and \ \alpha y(t) \in [y_{min}, y_{max}]\\
                    y_{min}, & t \in \Lambda \ and \ \alpha y(t) < y_{min} \\
                    y_{max}, & t \in \Lambda \ and \ \alpha y(t) > y_{max}                    
                    \end{matrix}\right.

:Additive: 
    An additive threat involves adding an additional term :math:`\alpha` to 
    the original property value. 

.. math:: \hat y(t) = \left\{\begin{matrix}
                    y(t),& t \notin \Lambda \\ 
                    y(t) + \alpha, & t \in \Lambda \ and \  y(t)+\alpha \in [y_{min}, y_{max}]\\
                    y_{min}, & t \in \Lambda \ and \  y(t)+\alpha < y_{min} \\
                    y_{max}, & t \in \Lambda \ and \  y(t)+\alpha > y_{max}                    
                    \end{matrix}\right.

:Ramping: 
    Ramping threats involve gradual modification of true values by the addition of :math:`\alpha t`, 
    a ramping function that gradually increases or decreases over time.

.. math:: \hat y(t) = \left\{\begin{matrix}
                    y(t),& t \notin \Lambda \\ 
                    y(t) + \alpha t, & t \in \Lambda \ and \  y(t) + \alpha t \in [y_{min}, y_{max}]\\
                    y_{min}, & t \in \Lambda \ and \  y(t)+\alpha t < y_{min} \\
                    y_{max}, & t \in \Lambda \ and \  y(t)+\alpha t > y_{max}                    
                    \end{matrix}\right.

:Pulse: 
    A pulse threat involves modifying true values through 
    a pulse wave function :math:`f(y(t))= A(H(y(t)-a)-H(y(t)-b))`, 
    where :math:`A` is the amplitude of the pulse, :math:`H` is the Heaviside step function, 
    :math:`a` and :math:`b` are the user-specified parameters.

.. math:: \hat y(t) = \left\{\begin{matrix}
                    y(t),& t \notin \Lambda \\ 
                    f(y(t)), & t \in \Lambda \ and \  f(y(t)) \in [y_{min}, y_{max}]\\
                    y_{min}, & t \in \Lambda \ and \  f(y(t)) t < y_{min} \\
                    y_{max}, & t \in \Lambda \ and \  f(y(t)) > y_{max}                    
                    \end{matrix}\right.

:Random: 
    This threat involves the addition of the returned values from 
    a uniform random function to the true values.

.. math:: \hat y(t) = \left\{\begin{matrix}
                    y(t),& t \notin \Lambda \\ 
                    y(t) + rand(a,b), & t \in \Lambda \ and \  y(t) + rand(a,b) \in [y_{min}, y_{max}]\\
                    y_{min}, & t \in \Lambda \ and \  y(t)+rand(a,b) < y_{min} \\
                    y_{max}, & t \in \Lambda \ and \  y(t)+rand(a,b) > y_{max}                    
                    \end{matrix}\right.

:External: 
    This model is used to when other customized forms of temproal patterns :math: `y_{ext}(t)` are needed.

.. math:: \hat y(t) = \left\{\begin{matrix}
                    y(t),& t \notin \Lambda \\ 
                    y_{ext}(t), & t \in \Lambda y_{ext}(t) \in [y_{min}, y_{max}]\\
                    y_{min}, & t \in \Lambda \ and \  y_{ext}(t) < y_{min} \\
                    y_{max}, & t \in \Lambda \ and \  y_{ext}(t) > y_{max}                    
                    \end{matrix}\right.

A DoS attack targeted at a control system is aimed at 
either making the sensor measurements unavailable to the control center 
or the control signal unavailable to the physical system in time.  
The unavailability takes the format of signal blocking and signal delaying. 

:Blocking: 
    In signal blocking, the downstream receiver cannot receive any signals 
    in this situation and will have to use values from the previous time step

.. math:: \hat y(t) = \left\{\begin{matrix}
                    y(t),& t \notin \Lambda\\ 
                    y(t-1), & t \in \Lambda
                    \end{matrix}\right.

:Delaying: 
    In signal delaying the transmitted signal is delayed to the receivers 
    because of, e.g., extra computation time under flooding traffic. 
    The mathematical model is expressed as follows, where :math:`\Delta t` is the delayed time.

.. math:: \hat y(t) = \left\{\begin{matrix}
                    y(t),& t \notin \Lambda\\ 
                    y(t-\Delta t), & t \in \Lambda
                    \end{matrix}\right.

.. _sec_threat_injection:

Threat Injection
-----------------

A python class :code:`ThreatInjection` is used to generate threatened signal and overwrite the original signal.
A list of attributes are provided as follows.

:threat: 
    An instance of Threat class. This defines the threat that is to be injected to the baseline system.
:start_time:
    Starting time of injection.  
:end_time:
    Ending time of injection. 
:step:
    Time step of injected signal. This is used for generating a time-series signal during the injection time.
    The defaulted value is 120 seconds.
:injection:
    Injection type. This attribute defines how a threat is injected a Modelica model. 
    Two types of injection types are available: :code:`'p'` is for time-invariant parameter type injection 
    and :code:`'v'` is for time-variant variable type injection.

The threats as defined in the previous section can be injected into a Modelica model by two ways 
depending on how the threatened signals are defined in the model. 
These two injection methods are variable injection (:code:`'v'`) and parameter injection (:code:`'p'`). 
The injection type is defined based on Modelica syntax. Modelica parameters and variables are handled differently 
after compilation.
The Modelica parameters are typically defined at the top-level of a model, and unchangeable after compilation,
while Modelica variable is at low-level and time-variant, and could be changed over time.
This project provides a holistic platform that enables the changes of Modelica parameters and variables during simulation
as defined in :numref:`SetSimulationManager`.
Here some detailed explanation about parameter- and variable-type injections are listed.

:Time-invariant Parameter Injection: 
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

:Time-variant Variable Injection:
    Time-variant Variable in Modelica refers to a kind of Modelica object that can change its value over time during a simulation. 
    An example is the output of a controller, which is adaptively updated over time to respond to external disturbances. 
    Time-variant Variable Injection means threats are injected to time-variant variables by overwriting its value during a simulation. 
    This type of injection applies to the majority of HVAC equipment and system faults such as stuck actuators, sensor noises, etc.


The class :code:`ThreatInjection` also provides some critical methods to generate threatened signals 
every time step for simulation experiment.



Example and Usage
------------------
 
Here two examples that use the :code:`pythreat` library are shown to define and inject a parameter and a variable threat 
based on previous Modelica template.

Instances of the :code:`Threat` class can be defined as below. First, a threat-injection ready wrapper FMU model is loaded.
Second, the wrapper is parsed to get exposed overwritten signals and their attributes.
Third, we need manually construct different threats based on the exposed signal names.
Two threats are defined in this example. 
One is a variable-type injection (:code:`thr1`) of chilled water suply temperaure setpoint,
and the other is a parameter-type injection (:code:`thr2`) of global zone temperature setpoint during cooling.

::

    # import pyfmi for loading fmu
    from pyfmi import load_fmu
    # import pythreat
    from threat import Threat
    from temporal import Temporal
    from temporal import Signal

    # 1. load threat-injection ready wrapper fmu model
    # load wrapper fmu
    wrapper = load_fmu(fmu_path)

    # 2. parse overwritten signal and get signal attributes
    # get wrapper overwritten inputs and parameters
    inputs  = wrapper.get_model_variables(causality = 2).keys()
    parameters  = wrapper.get_model_variables(causality = 0).keys()

    # get fmu inputs, distinguish signal and activate
    input_names = [name for name in inputs if name.endswith("_u")]
    parameter_names = [name for name in parameters if name.endswith("_p")]

    # get input and parameter properties
    oveSig={}
    for name in input_names+parameter_names:
        unit = wrapper.get_variable_unit(name)
        mini = wrapper.get_variable_min(name)
        maxi = wrapper.get_variable_max(name)
        oveSig[name] = Signal(name,mini, maxi, unit)

    # 3. construct manually the threats based on exposed signal from wrapper.
    # define a variable-type threat: threaten chilled water temperature setpoint
    thr1_name = 'oveTSetChiWatSup_u'
    thr1 = Threat(active = True, 
                start_threat = 207*24*3600.+12*3600,
                end_threat= 207*24*3600.+12*3600 + 3*3600,
                temporal = Temporal(oveSig[thr1_name],'max'),
                injection = 'v')

    # define a parameter-type threat: threaten global zone temperature setpoint when cooling is on
    thr2_name = 'oveTCooOn_p'
    thr2 = Threat(active = True, 
                start_threat = 207*24*3600.+13*3600,
                end_threat= 207*24*3600.+13*3600 + 2*3600,
                temporal = Temporal(oveSig[thr2_name],'constant',k=273.15+26),
                injection = 'p')


The defined threats can then be used by :code:`ThreatInjection` class to generate a time-series for each threateded signal.
The following codes as a continuing part show how the threat injection can be defined for the above two threats.
The experiment is run from day 207 to day 208 with a time step of 1 hour.
Inside each time step, the threats are injected according to their threat starting time as defined 
in :code:`start_threat`. 
The generated signal for each threat is a time-series equally sampled at an interval of :code:`injection_step`.
The generated signal for each threat (the element in the list :code:`input_object_lis`) is a tuple,
containing a list of two names, and their corresponding values at each injection time stamp.
The two names are the exposed inputs in the wrapper model for a signal: :code:`<block_instance>_u` and :code:`<block_instance>_activate`.
These input objects can be used in the *simulation_manager* to perform simulation under threat.
Details can be found in the next chapter.

::
    
    from threat import ThreatInjection

    # Experiment setup
    ts = 207*24*3600.
    te = 208*24*3600.
    dt = 3600.
    inj_step = 120.

    # A list of active threats
    thr_lis = [thr1, thr2]
    
    # Main loop
    t = ts
    while t<te:
        ts = t
        te = ts + dt
        # Inject threat for current step
        # Initialize input object list
        input_object_lis=[]
        for thr in thr_lis:
            thr_inj = ThreatInjection(threat=thr,
                                start_time=ts, 
                                end_time=te,
                                step=inj_step) 
            # update input object list for current step
            input_object_lis += [thr_inj.overwrite()]

        # Update clock
        t = te