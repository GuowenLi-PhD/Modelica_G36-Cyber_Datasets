within FaultInjection.PrimarySideControl.CWLoopEquipment;
model MaximumSpeedFan
  "The maximum fan speed in cooling towers are reset based on the operation mode"
    extends Modelica.Blocks.Icons.Block;
  parameter Real lowMax = 0.9 "Low value of maximum speed";
  parameter Real pmcMax = 0.95 "Maximum speed in PMC mode";
  parameter Integer numPum = 2 "Number of design pumps in condenser water loop";

  Modelica.Blocks.Interfaces.IntegerInput uOpeMod
    "Cooling mode in WSEControls.Type.OperationaModes" annotation (Placement(
        transformation(extent={{-140,-60},{-100,-20}}),iconTransformation(
          extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.IntegerInput
                                       numActPum
    "Number of active pumps in condenser water loop"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold intGreEquThr(
      threshold=numPum)
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant lowMaxSpe(k=lowMax)
    "Low maximum speed"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uni(k=1)
    "full maximum speed"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Modelica.Blocks.Sources.BooleanExpression FreOrFul(y=uOpeMod == Integer(
        WSEControlLogics.Controls.WSEControls.Type.OperationModes.FreeCooling)
         or uOpeMod == Integer(WSEControlLogics.Controls.WSEControls.Type.OperationModes.FullMechanical))
    "Free cooling or full mechanical cooling"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant pmcMaxSpe(k=pmcMax)
    "Maximum speed for pmc and ppmc mode"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.BooleanExpression Pmc(y=uOpeMod == Integer(
        WSEControlLogics.Controls.WSEControls.Type.OperationModes.PartialMechanical))
    "Partial mechanical cooling"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
equation
  connect(intGreEquThr.y, swi1.u2)
    annotation (Line(points={{-59,20},{-22,20}},   color={255,0,255}));
  connect(numActPum, intGreEquThr.u)
    annotation (Line(points={{-120,40},{-90,40},{-90,20},{-82,20}},
                                                    color={255,127,0}));
  connect(uni.y, swi1.u1) annotation (Line(points={{-59,60},{-40,60},{-40,28},{
          -22,28}},
                 color={0,0,127}));
  connect(lowMaxSpe.y, swi1.u3) annotation (Line(points={{-59,-20},{-40,-20},{
          -40,12},{-22,12}},
                           color={0,0,127}));
  connect(swi1.y, swi3.u1) annotation (Line(points={{1,20},{20,20},{20,-32},{38,
          -32}}, color={0,0,127}));
  connect(FreOrFul.y, swi3.u2)
    annotation (Line(points={{1,-40},{38,-40}}, color={255,0,255}));
  connect(swi3.y, y) annotation (Line(points={{61,-40},{80,-40},{80,0},{110,0}},
        color={0,0,127}));
  connect(pmcMaxSpe.y, swi2.u1) annotation (Line(points={{-59,-50},{-40,-50},{-40,
          -62},{-22,-62}}, color={0,0,127}));
  connect(swi2.y, swi3.u3) annotation (Line(points={{1,-70},{20,-70},{20,-48},{38,
          -48}}, color={0,0,127}));
  connect(uni.y, swi2.u3) annotation (Line(points={{-59,60},{-40,60},{-40,-78},{
          -22,-78}}, color={0,0,127}));
  connect(Pmc.y, swi2.u2)
    annotation (Line(points={{-59,-70},{-22,-70}}, color={255,0,255}));
  annotation (defaultComponentName = "maxSpeFan",
    Documentation(info="<html>
<p>
The maximum fan speed in cooling towers is reset based on cooling modes and operation status.
</p>
<ul>
<li>
When in unoccupied mode, the maximum speed is not reset.
</li>
<li>
When in free cooling mode, if all condenser pumps are enabled, the maximum fan speed is reset to full speed 100%; Otherwise the maximum fan speed is reset to a lower speed, e.g. 90%.
</li>
<li>
When in pre-partial and partial mechanical cooling mode, the maximum fan speed is set to a high speed e.g. 95%.
</li>
<li>
When in full mechanical cooling mode, if all the condenser water pumps are active, the maximum fan speed is reset to full speed 100%; Otherwise it is reset to a lower speed, e.g. 90%.
</li>
</ul>
</html>"));
end MaximumSpeedFan;
