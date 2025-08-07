within FaultInjection.Equipment.VariableFaults;
model FaultTemperatureSensorHeatPort "Temperature fault sensor with heat port"

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Utilities.InsertionTypes.Variables.SignalCorruption.Additive bias(faultMode=
        faultMode, use_uFau_in=use_uFau_in) "Bias"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

 parameter Utilities.InsertionTypes.Generic.faultMode faultMode
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Modelica.Blocks.Interfaces.RealInput uFau_in if use_uFau_in "Prescribed signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  parameter Boolean use_uFau_in = true "Get the faulty signal from the input connector"
    annotation(Evaluate=true, HideResult=true, Dialog(group="Conditional inputs"));

  Modelica.Blocks.Interfaces.RealOutput T(unit="K")
    "Absolute temperature as output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a
                        port annotation (Placement(transformation(extent={{
            -110,-10},{-90,10}}), iconTransformation(extent={{-120,-10},{-100,
            10}})));
equation
  connect(temSen.T, bias.u) annotation (Line(points={{10,0},{10,28},{-60,28},{-60,
          50},{-42,50}}, color={0,0,127}));
  connect(bias.uFau_in, uFau_in) annotation (Line(points={{-42,56},{-60,56},{-60,
          80},{-120,80}}, color={0,0,127}));
  connect(temSen.port, port)
    annotation (Line(points={{-10,0},{-100,0}}, color={191,0,0}));
  connect(T, bias.y) annotation (Line(points={{110,0},{40,0},{40,50},{-19,50}},
        color={0,0,127}));
  annotation (defaultComponentName="senTem",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(
          extent={{-22,-98},{18,-60}},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-14,40},{10,-68}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{10,0},{100,0}},color={0,0,255}),
        Line(points={{-100,0},{-14,0}},color={191,0,0}),
        Polygon(
          points={{-14,40},{-14,80},{-12,86},{-8,88},{-2,90},{4,88},{8,86},{10,
              80},{10,40},{-14,40}},
          lineThickness=0.5),
        Line(
          points={{-14,40},{-14,-64}},
          thickness=0.5),
        Line(
          points={{10,40},{10,-64}},
          thickness=0.5),
        Line(points={{-42,-20},{-14,-20}}),
        Line(points={{-42,20},{-14,20}}),
        Line(points={{-42,60},{-14,60}}),
        Text(
          extent={{124,-20},{24,-120}},
          textString="K"),
        Text(
          extent={{-152,130},{148,90}},
          textString="%name",
          lineColor={0,0,255}),
        Line(
          points={{-56,66},{54,-68}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{-54,-66},{52,64}},
          color={238,46,47},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end FaultTemperatureSensorHeatPort;
