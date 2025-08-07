within FaultInjection.PrimarySideControl.CHWLoopEquipment;
model StageEconomizer "Stage up or down the waterside economizer"
  Modelica.Blocks.Interfaces.IntegerInput uOpeMod
    "Cooling mode in WSEControls.Type.OperationaModes" annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}), iconTransformation(
          extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Sources.BooleanExpression unOccFulMec(y=uOpeMod == Integer(
        WSEControlLogics.Controls.WSEControls.Type.OperationModes.Unoccupied)
         or uOpeMod == Integer(WSEControlLogics.Controls.WSEControls.Type.OperationModes.FullMechanical))
    "Unoccupied or Full mechanical cooling mode"
    annotation (Placement(transformation(extent={{-92,-10},{-72,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Switch"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(k=0) "Zero"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uni(k=1) "One"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "on/off signal for the waterside economizer"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(unOccFulMec.y, swi.u2)
    annotation (Line(points={{-71,0},{-12,0}}, color={255,0,255}));
  connect(zer.y, swi.u1) annotation (Line(points={{-39,50},{-32,50},{-32,8},{-12,
          8}}, color={0,0,127}));
  connect(uni.y, swi.u3) annotation (Line(points={{-39,-50},{-32,-50},{-32,-8},{
          -12,-8}}, color={0,0,127}));
  connect(swi.y, y) annotation (Line(points={{11,0},{110,0}}, color={0,0,127}));
  annotation (defaultComponentName="staEco",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255})}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end StageEconomizer;
