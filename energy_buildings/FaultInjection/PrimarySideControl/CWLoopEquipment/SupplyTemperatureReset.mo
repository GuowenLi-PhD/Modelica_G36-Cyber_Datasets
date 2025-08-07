within FaultInjection.PrimarySideControl.CWLoopEquipment;
model SupplyTemperatureReset
  "Cooling tower supply temperature setpoint reset"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.ThermodynamicTemperature TSetMinFulMec = 273.15 + 12.78
  "Minimum cooling tower supply temperature setpoint for full mechanical cooling";
  parameter Modelica.SIunits.ThermodynamicTemperature TSetMaxFulMec = 273.15 + 35
  "Maximum cooling tower supply temperature setpoint for full mechanical cooling";
  parameter Modelica.SIunits.ThermodynamicTemperature TSetParMec = 273.15 + 10
  "Cooling tower supply temperature setpoint for partial mechanical cooling";
  Modelica.Blocks.Interfaces.IntegerInput uOpeMod
    "Cooling mode signal, integer value of WSEControlLogics.Controls.WSEControls.Type.OperationModes"
    annotation (
      Placement(transformation(extent={{-140,30},{-100,70}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Modelica.Blocks.Interfaces.RealOutput TSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Temperature setpoint" annotation (
     Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(
          extent={{100,-10},{120,10}})));

  Modelica.Blocks.Sources.BooleanExpression fmcMod(y=uOpeMod == Integer(
        WSEControlLogics.Controls.WSEControls.Type.OperationModes.FullMechanical))
    "Full mechanical cooling mode"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));

  Modelica.Blocks.Interfaces.RealInput TWetBul(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Outdoor air wet bulb emperature" annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}),iconTransformation(extent={{-140,
            -20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput TAppCooTow(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Approach temperature in cooling towers" annotation (
      Placement(transformation(extent={{-140,-70},{-100,-30}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1 "Addition"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(k(unit="K")=
      TSetParMec)
    annotation (Placement(transformation(extent={{0,-68},{20,-48}})));

protected
  Modelica.Blocks.Logical.Switch swi1
    "The switch based on whether it is in FMC"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

public
  Modelica.Blocks.Math.Min min
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Modelica.Blocks.Math.Max max
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(k(unit="K")=
      TSetMinFulMec)
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(k(unit="K")=
      TSetMaxFulMec)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
equation
  connect(fmcMod.y, swi1.u2)
    annotation (Line(points={{21,-20},{38,-20},{38,0},{58,0}},
                                              color={255,0,255}));
  connect(swi1.y, TSet)
    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  connect(TWetBul, add1.u1) annotation (Line(points={{-120,0},{-94,0},{-94,6},{-82,
          6}},       color={0,0,127}));
  connect(TAppCooTow, add1.u2) annotation (Line(points={{-120,-50},{-90,-50},{-90,
          -6},{-82,-6}},
                     color={0,0,127}));
  connect(con1.y, swi1.u3) annotation (Line(points={{21,-58},{40,-58},{40,-8},{
          58,-8}},
                color={0,0,127}));
  connect(con3.y, min.u1) annotation (Line(points={{-59,70},{-52,70},{-52,46},{-42,
          46}}, color={0,0,127}));
  connect(add1.y, min.u2) annotation (Line(points={{-59,0},{-52,0},{-52,34},{-42,
          34}}, color={0,0,127}));
  connect(min.y, max.u1) annotation (Line(points={{-19,40},{-12,40},{-12,16},{-2,
          16}}, color={0,0,127}));
  connect(con2.y, max.u2) annotation (Line(points={{-19,-20},{-12,-20},{-12,4},{
          -2,4}}, color={0,0,127}));
  connect(max.y, swi1.u1)
    annotation (Line(points={{21,10},{40,10},{40,8},{58,8}}, color={0,0,127}));
 annotation (defaultComponentName="temRes", Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This model describes a cooling tower supply temperature reset for a chilled water system with integrated waterside economizers.</p>
<ul>
<li>When in unoccupied mode, the condenser supply temperature is free floated, and keep unchanged from previous mode</li>
<li>When in free cooling, the condenser water supply temperature is free floated, and keep unchanged from previous mode</li>
<li>When in pre-partial, and partial mechanical cooling, the condenser water supply temperature is reset to a predefined value <code>TSetParMec</code>.This could be changed
based on advanced control algorithm.</li>
<li>When in full mechanical cooling mode, the condenser water supply temperature is reset according to the environment.
 <i>T<sub>sup,CW,set</sub> = T<sub>wb,OA</sub> + T<sub>app,pre</sub></i>. T<sub>sup,CW,set</sub> means the supply condenser water temperature setpoint, T<sub>wb,OA</sub>
is the outdoor air wet bulb temperature, and T<sub>app,pre</sub> is the predicted approach temperature, which could be a fixed or various value.</li>
</ul>
</html>"));
end SupplyTemperatureReset;
