within FaultInjection.PrimarySideControl.BaseClasses;
model PartialBypassControl "Partial model for bypass control"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.Pressure dpSetDes "Differential pressure setpoint at design condition ";

  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.PID
    "Type of controller";
  parameter Real k=1 "Gain of controller";
  parameter Modelica.SIunits.Time Ti=0.5 "Time constant of Integrator block";
  parameter Modelica.SIunits.Time Td=0.1 "Time constant of Derivative block";
  parameter Real yMax=1 "Upper limit of output";
  parameter Real yMin=0 "Lower limit of output";
  parameter Boolean reverseAction=false
    "Set to true for throttling the water flow rate through a cooling coil controller";

  Modelica.Blocks.Sources.BooleanExpression unOcc(y=uOpeMod == Integer(
        WSEControlLogics.Controls.WSEControls.Type.OperationModes.Unoccupied))
    "Unoccupied mode"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Modelica.Blocks.Sources.Constant off(k=0) "Turn off"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Sources.BooleanExpression freCoo(y=uOpeMod == Integer(
        WSEControlLogics.Controls.WSEControls.Type.OperationModes.FreeCooling))
    "Free cooling"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Modelica.Blocks.Sources.Constant fulOpe(k=1) "Fully opened"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.BooleanExpression preParMec(y=uOpeMod == Integer(
        WSEControlLogics.Controls.WSEControls.Type.OperationModes.PrePartialMechanical))
    "Prepartial mechanical cooling mode"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Modelica.Blocks.Sources.BooleanExpression parMec(y=uOpeMod == Integer(
        WSEControlLogics.Controls.WSEControls.Type.OperationModes.PartialMechanical))
    "Partial mechanical cooling mode"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(k=1/dpSetDes)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai2(k=1/dpSetDes)
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.Continuous.LimPID con(
    controllerType=controllerType,
    k=k,
    Ti=Ti,
    Td=Td,
    yMax=yMax,
    yMin=yMin,
    reverseAction=reverseAction) "PID controller"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Sources.BooleanExpression fulMec(y=uOpeMod == Integer(
        WSEControlLogics.Controls.WSEControls.Type.OperationModes.FullMechanical))
    "Full mechanical cooling mode"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
protected
  Modelica.Blocks.Logical.Switch swi5
    "The switch based on whether it is in FMC mode"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  Modelica.Blocks.Logical.Switch swi4
    "The switch based on whether it is in FMC mode"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Modelica.Blocks.Logical.Switch swi3
    "The switch based on whether it is in FMC mode"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Modelica.Blocks.Logical.Switch swi2
    "The switch based on whether it is in FMC mode"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Modelica.Blocks.Logical.Switch swi1
    "The switch based on whether it is in FMC mode"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
public
  Modelica.Blocks.Interfaces.IntegerInput uOpeMod
    "Operation mode in WSEControlLogics.Controls.WSEControls.Type.OperationModes"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput dpSet(quantity="Pressure", unit="Pa")
    "Differential pressure setpoint"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput dpMea(quantity="Pressure", unit="Pa")
    "Differential pressure measurement"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(unOcc.y,swi1. u2)
    annotation (Line(points={{21,60},{38,60}}, color={255,0,255}));
  connect(freCoo.y,swi2. u2)
    annotation (Line(points={{21,20},{38,20}}, color={255,0,255}));
  connect(preParMec.y,swi3. u2)
    annotation (Line(points={{21,-20},{38,-20}}, color={255,0,255}));
  connect(swi2.y,swi1. u3) annotation (Line(points={{61,20},{70,20},{70,40},{30,
          40},{30,52},{38,52}}, color={0,0,127}));
  connect(swi3.y,swi2. u3) annotation (Line(points={{61,-20},{70,-20},{70,0},{30,
          0},{30,12},{38,12}}, color={0,0,127}));
  connect(parMec.y,swi4. u2)
    annotation (Line(points={{21,-60},{38,-60}}, color={255,0,255}));
  connect(dpSet,gai1. u)
    annotation (Line(points={{-120,0},{-82,0}},     color={0,0,127}));
  connect(dpMea,gai2. u) annotation (Line(points={{-120,-60},{-82,-60}},
                      color={0,0,127}));
  connect(gai1.y,con. u_s) annotation (Line(points={{-59,0},{-42,0}},
                      color={0,0,127}));
  connect(gai2.y,con. u_m)
    annotation (Line(points={{-59,-60},{-30,-60},{-30,-12}}, color={0,0,127}));
  connect(fulMec.y,swi5. u2)
    annotation (Line(points={{21,-100},{38,-100}}, color={255,0,255}));
  connect(swi4.y,swi3. u3) annotation (Line(points={{61,-60},{70,-60},{70,-40},{
          30,-40},{30,-28},{38,-28}}, color={0,0,127}));
  connect(swi5.y,swi4. u3) annotation (Line(points={{61,-100},{70,-100},{70,-80},
          {30,-80},{30,-68},{38,-68}}, color={0,0,127}));
  connect(swi1.y,y)  annotation (Line(points={{61,60},{80,60},{80,0},{110,0}},
        color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-120},{100,100}})));
end PartialBypassControl;
