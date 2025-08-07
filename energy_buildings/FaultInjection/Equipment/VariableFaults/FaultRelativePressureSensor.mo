within FaultInjection.Equipment.VariableFaults;
model FaultRelativePressureSensor
  "Relative pressure sensor with faults"
    extends Buildings.Fluid.Interfaces.PartialTwoPort;
  FaultInjection.Utilities.InsertionTypes.Variables.SignalCorruption.Additive
  bias(faultMode=faultMode, use_uFau_in=use_uFau_in) "Bias"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

 parameter Utilities.InsertionTypes.Generic.faultMode faultMode
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Modelica.Blocks.Interfaces.RealInput uFau_in if  use_uFau_in "Prescribed signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealOutput p_rel(final quantity="PressureDifference",
                                              final unit="Pa",
                                              displayUnit="Pa")
    "Relative pressure of port_a minus port_b" annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,110}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-110})));
  Buildings.Fluid.Sensors.RelativePressure senRelPre(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}})));
  parameter Boolean use_uFau_in = true "Get the faulty signal from the input connector"
    annotation(Evaluate=true, HideResult=true, Dialog(group="Conditional inputs"));

equation
  connect(bias.uFau_in, uFau_in) annotation (Line(points={{-42,56},{-60,56},{
          -60,80},{-120,80}},
                          color={0,0,127}));
  connect(bias.y, p_rel)
    annotation (Line(points={{-19,50},{0,50},{0,110}}, color={0,0,127}));
  connect(senRelPre.port_a, port_a)
    annotation (Line(points={{-10,0},{-100,0}}, color={0,127,255}));
  connect(senRelPre.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(senRelPre.p_rel, bias.u) annotation (Line(points={{0,9},{0,20},{-60,20},
          {-60,50},{-42,50}},      color={0,0,127}));
  annotation (
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          fillColor={245,245,245},
          fillPattern=FillPattern.Solid,
          extent={{-70.0,-60.0},{70.0,20.0}}),
        Polygon(
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{0.0,-40.0},{-10.0,-16.0},{10.0,-16.0},{0.0,-40.0}}),
        Line(points={{0.0,0.0},{0.0,-16.0}}),
        Line(points={{-70.0,0.0},{0.0,0.0}}),
        Line(points={{-50.0,-40.0},{-50.0,-60.0}}),
        Line(points={{-30.0,-40.0},{-30.0,-60.0}}),
        Line(points={{-10.0,-40.0},{-10.0,-60.0}}),
        Line(points={{10.0,-40.0},{10.0,-60.0}}),
        Line(points={{30.0,-40.0},{30.0,-60.0}}),
        Line(points={{50.0,-40.0},{50.0,-60.0}}),
        Line(points={{-100,0},{-70,0}}, color={0,127,255}),
        Line(points={{70,0},{100,0}}, color={0,127,255}),
        Line(points={{0,-60},{0,-100}},color={0,0,127}),
        Line(
          points={{32,3},{-58,3}},
          color={0,128,255}),
        Polygon(
          points={{22,18},{62,3},{22,-12},{22,18}},
          lineColor={0,128,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-54,-98},{52,32}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{-56,34},{54,-100}},
          color={238,46,47},
          thickness=1)}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end FaultRelativePressureSensor;
