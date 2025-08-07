.. _SetModelicaTemplate:

Modelica Template
=================
Modelica is an open-source object-oriented modeling language [37], 
and has emerged as a dynamic modeling tool for building energy and control systems [38]. 
Currently, Modelica Buildings library developed by the U.S. DOE LBNL has been widely used for the design and control of building energy system [38]. 
However, Modelica Buildings library is designed to evaluate fault-free energy and control system. 
Efforts are stilled needed to expand this library for fault modeling.
This section introduces a Modelica package- **Overwrite** - 
to provide the flexibility in terms of creating a template for the modeling of different types of energy and control system threats. 


Modelica Overwrite Blocks
--------------------------
Two basic models are introduced in this section to overwrite a Modelica variable and a Modelica parameter during simulation from external sources. 
These two models are named *OverwriteVariable*, and *OverwriteParameter*, respectively.
The detailed implementations are explained as follows.

OverwriteVariable
^^^^^^^^^^^^^^^^^^
This model passes an external signal instead of original input signal when the overwritting action is activated. 
A similar implementation in Modelica designed for the BOPTEST project is used here.
This model is typically used by the BOPTEST framework
to identify and activate control signals that can be overwritten by test
controllers. It is used in combination with a dedicated parser to perform
this task as shown in :ref:`SetEmulationModel`.
The input *u* is the signal to be overwritten. The output
*y* will be equal to the input signal if the *activate*
flag is *false* and will be equal to the external input signal *uExt*
if the flag is *true*.
The protected parameter *mtiOverwriteVariable* is a parameter used for automatically parsing the template model
to generate a wrapper FMU model. 
This parameter is not used for calculation during simulation. 
More details can be found in :ref:`SetEmulationModel`.

::
    
    block OverwriteVariable
        extends Modelica.Blocks.Interfaces.SISO;
        parameter String description 
            "Description of the signal being overwritten";
        Modelica.Blocks.Logical.Switch swi
            "Switch between external signal and direct feedthrough signal";
        Modelica.Blocks.Sources.RealExpression uExt 
            "External input signal";
        Modelica.Blocks.Sources.BooleanExpression activate
            "Block to activate use of external signal";
    protected
        final parameter Boolean mtiOverwriteVariable = true
            "Protected parameter, used by tools to search for overwrite block in models";

        equation
            connect(activate.y, swi.u2);
            connect(swi.u3, u);
            connect(uExt.y, swi.u1);
            connect(swi.y, y);
    end OverwriteVariable;


OverwriteParameter
^^^^^^^^^^^^^^^^^^
This model is used when there is at least one 
Modelica parameter to be overwritten during a simulation.
The parameter *p* in this model intends to be overwritten by 
the external threat injection library between time steps, 
and has no physical meaning until being assigned to a threatened parameter of a 
model. For instance, a typical paraemter of the cooling coil model is known as nominal UA.
The nominal UA should not change within a simulation experiemnt when there is no fouling.
However, when the cooling coil is gradually fouled,
the heat resistance increases as well, and thus the nominal UA 
decreases over time. 
To model this effect, *OverwriteParameter* can be used at the top level of the
Modelica model by assigning *p* to the nominal UA of the cooling coil model. 
In this way, any changes on *p* will be directly propogated to the nominal UA.
The protected parameter *mtiOverwriteParameter* is used only for automatically parsing 
the template model
to generate a wrapper FMU model, not for calculation during simulation. 
More details can be found in :ref:`SetEmulationModel`.

::

    record OverwriteParameter
        extends Modelica.Icons.Record;
        parameter Real p 
            "Parameter passed to simulation";
        parameter String description = " "
            "Description that decribes the overwritten parameter";
    protected
        final parameter Boolean mtiOverwriteParameter=true
            "Protected parameter, only used by the parser to search for overwrite block in models";

    end OverwriteParameter;


Modelica Template
-------------------



