within FaultInjection.PrimarySideControl.CWLoopEquipment;
model SpeedFan "Cooling tower fan speed control"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Blocks.Types.SimpleController controllerType=
    Modelica.Blocks.Types.SimpleController.PID
    "Type of controller"
    annotation(Dialog(tab="Controller"));
  parameter Real k = 1
    "Gain of controller"
    annotation(Dialog(tab="Controller"));
  parameter Modelica.SIunits.Time Ti=0.5
    "Time constant of integrator block"
     annotation (Dialog(enable=
          (controllerType == Modelica.Blocks.Types.SimpleController.PI or
          controllerType == Modelica.Blocks.Types.SimpleController.PID),tab="Controller"));
  parameter Modelica.SIunits.Time Td(min=0)=0.1
    "Time constant of derivative block"
     annotation (Dialog(enable=
          (controllerType == Modelica.Blocks.Types.SimpleController.PD or
          controllerType == Modelica.Blocks.Types.SimpleController.PID),tab="Controller"));
  parameter Real yMax(start=1)=1
   "Upper limit of output"
    annotation(Dialog(tab="Controller"));
  parameter Real yMin=0.2
   "Lower limit of output"
    annotation(Dialog(tab="Controller"));
  parameter Boolean reverseAction = true
    "Set to true for throttling the water flow rate through a cooling coil controller"
    annotation(Dialog(tab="Controller"));
  parameter Boolean pre_y_start=false "Value of pre(y) at initial time"
    annotation(Dialog(tab="Controller"));

  Modelica.Blocks.Interfaces.RealInput TCHWSupSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput TCWSupSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Modelica.Blocks.Interfaces.RealInput TCHWSup(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Chilled water supply temperature " annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        origin={-120,-20}), iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.Continuous.LimPID conPID(
    controllerType=controllerType,
    k=k,
    Ti=Ti,
    Td=Td,
    yMax=yMax,
    yMin=yMin,
    reverseAction=reverseAction,
    initType=Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState,
    y_reset=1) "PID controller to maintain the CW/CHW supply temperature"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Interfaces.RealInput TCWSup(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Condenser water supply temperature " annotation (
      Placement(transformation(
        extent={{20,20},{-20,-20}},
        rotation=180,
        origin={-120,-60}), iconTransformation(
        extent={{20,20},{-20,-20}},
        rotation=180,
        origin={-120,-60})));

  Modelica.Blocks.Sources.Constant off(k=0) "Turn off"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.Blocks.Sources.BooleanExpression unOcc(y=uOpeMod == Integer(
        WSEControlLogics.Controls.WSEControls.Type.OperationModes.Unoccupied))
    "Unoccupied mode"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.BooleanExpression freCoo(y=uOpeMod == Integer(
        WSEControlLogics.Controls.WSEControls.Type.OperationModes.FreeCooling))
    "Free cooling"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Modelica.Blocks.Interfaces.IntegerInput uOpeMod "Cooling mode" annotation (
      Placement(transformation(extent={{-140,80},{-100,120}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Modelica.Blocks.Interfaces.RealInput uFanMax "Maximum fan speed"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Modelica.Blocks.Interfaces.RealOutput y "Cooling tower fan speed"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Math.Min min "Minum value"
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));

protected
  Modelica.Blocks.Logical.Switch swi1
    "The switch based on whether it is in FMC mode"
    annotation (Placement(transformation(extent={{-38,50},{-18,70}})));
  Modelica.Blocks.Logical.Switch swi2
    "The switch based on whether it is in the FMC mode"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={-30,-52})));
  Modelica.Blocks.Logical.Switch swi3
    "The switch based on whether it is in PMC mode"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={50,0})));

  Modelica.Blocks.Logical.Switch swi4
    "The switch based on whether it is in PMC mode"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={50,70})));
public
  Buildings.Controls.OBC.CDL.Logical.OnOffController onOffCon(
                   final pre_y_start=pre_y_start, final bandwidth=0.5)
                                   "Electric heater on-off controller"
    annotation (Placement(transformation(extent={{-20,94},{0,114}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant froTem(k=273.15)
    "Frozen temperature"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
equation
  connect(swi1.y, conPID.u_s)
    annotation (Line(points={{-17,60},{-10,60},{-10,-30},{-2,-30}},
                 color={0,0,127}));
  connect(swi2.y, conPID.u_m)
    annotation (Line(points={{-19,-52},{10,-52},{10,-42}}, color={0,0,127}));
  connect(unOcc.y, swi3.u2)
    annotation (Line(points={{21,0},{38,0}}, color={255,0,255}));
  connect(off.y, swi3.u1)
    annotation (Line(points={{21,30},{30,30},{30,8},{38,8}}, color={0,0,127}));
  connect(conPID.y, swi3.u3)
    annotation (Line(points={{21,-30},{30,-30},{30,-8},{38,-8}},
                    color={0,0,127}));
  connect(swi3.y, min.u1)
    annotation (Line(points={{61,0},{66,0},{66,6},{70,6}}, color={0,0,127}));
  connect(min.u2,uFanMax)  annotation (Line(points={{70,-6},{64,-6},{64,-100},{-120,
          -100}}, color={0,0,127}));
  connect(TCHWSupSet, swi1.u1) annotation (Line(points={{-120,60},{-94,60},{-94,
          80},{-50,80},{-50,68},{-40,68}},
                         color={0,0,127}));
  connect(TCWSupSet, swi1.u3) annotation (Line(points={{-120,20},{-50,20},{-50,52},
          {-40,52}}, color={0,0,127}));
  connect(TCHWSup, swi2.u1) annotation (Line(points={{-120,-20},{-50,-20},{-50,-44},
          {-42,-44}}, color={0,0,127}));
  connect(TCWSup, swi2.u3)
    annotation (Line(points={{-120,-60},{-42,-60}}, color={0,0,127}));
  connect(freCoo.y, swi1.u2)
    annotation (Line(points={{-69,60},{-40,60}}, color={255,0,255}));
  connect(freCoo.y, swi2.u2) annotation (Line(points={{-69,60},{-60,60},{-60,-52},
          {-42,-52}}, color={255,0,255}));
  connect(off.y, swi4.u1) annotation (Line(points={{21,30},{30,30},{30,78},{38,
          78}}, color={0,0,127}));
  connect(min.y, swi4.u3) annotation (Line(points={{93,0},{96,0},{96,46},{32,46},
          {32,62},{38,62}}, color={0,0,127}));
  connect(swi4.y, y) annotation (Line(points={{61,70},{98,70},{98,0},{110,0}},
        color={0,0,127}));
  connect(froTem.y, onOffCon.reference)
    annotation (Line(points={{-59,110},{-22,110}}, color={0,0,127}));
  connect(TCWSup, onOffCon.u) annotation (Line(points={{-120,-60},{-94,-60},{-94,
          82},{-50,82},{-50,98},{-22,98}}, color={0,0,127}));
  connect(onOffCon.y, swi4.u2) annotation (Line(points={{1,104},{26,104},{26,70},
          {38,70}}, color={255,0,255}));
  annotation (defaultComponentName = "speFan",
  Documentation(info="<html>
<p>
Cooling tower fan speed is controlled in different ways when operation mode changes.
</p>
<ul>
<li>
For unoccupied operation mode, the fan is turned off.
</li>
<li>
For free cooling mode, the fan speed is controlled to maintain a predefined chilled water supply temperature at the downstream of the economizer, 
and not exceed the predefined maximum fan
speed. 
</li>
<li>
For pre-partial, partial and full mechanical cooling, the fan speed is controlled to maintain the supply condenser water at its setpoint. 
</li>
</ul>
</html>", revisions=""),
    Diagram(coordinateSystem(extent={{-100,-120},{100,120}})));
end SpeedFan;
