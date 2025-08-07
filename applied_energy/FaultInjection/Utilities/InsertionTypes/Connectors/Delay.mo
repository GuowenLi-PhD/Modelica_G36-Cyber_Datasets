within FaultInjection.Utilities.InsertionTypes.Connectors;
model Delay "Signal Delay"

  Modelica.Blocks.Interfaces.RealInput u "Control Signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
 parameter Generic.faultMode faultMode
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Modelica.Blocks.Sources.BooleanTable fauInj(final startValue=false, table={
        faultMode.startTime,faultMode.endTime}) "Fault injected: true or false"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Modelica.Blocks.Logical.Switch swi
    annotation (Placement(transformation(extent={{4,-10},{24,10}})));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay(delayTime=delayTime)
    annotation (Placement(transformation(extent={{-60,-58},{-40,-38}})));
  parameter Modelica.SIunits.Time delayTime=2
    "Delay time of output with respect to input signal";
  Modelica.Blocks.Interfaces.RealOutput y1 "Output Signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  connect(fauInj.y, swi.u2) annotation (Line(points={{-39,40},{-30,40},{-30,0},{
          2,0}},     color={255,0,255}));
  connect(u, swi.u3) annotation (Line(points={{-120,0},{-58,0},{-58,-8},{2,-8}},
        color={0,0,127}));
  connect(swi.y, y1)
    annotation (Line(points={{25,0},{110,0}}, color={0,0,127}));
  connect(fixedDelay.y, swi.u1) annotation (Line(points={{-39,-48},{-16,-48},{-16,
          8},{2,8}}, color={0,0,127}));
  connect(u, fixedDelay.u) annotation (Line(points={{-120,0},{-82,0},{-82,-48},{
          -62,-48}}, color={0,0,127}));
  annotation (defaultComponentName="del",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Text(
        extent={{-150,150},{150,110}},
        lineColor={238,46,47},
          textString="%name"),
    Line(
      points={{-92.0,0.0},{-80.7,34.2},{-73.5,53.1},{-67.1,66.4},{-61.4,74.6},{-55.8,79.1},{-50.2,79.8},{-44.6,76.6},{-38.9,69.7},{-33.3,59.4},{-26.9,44.1},{-18.83,21.2},{-1.9,-30.8},{5.3,-50.2},{11.7,-64.2},{17.3,-73.1},{23.0,-78.4},{28.6,-80.0},{34.2,-77.6},{39.9,-71.5},{45.5,-61.9},{51.9,-47.2},{60.0,-24.8},{68.0,0.0}},
      color={0,0,127},
      smooth=Smooth.Bezier),
    Line(
      points={{-62.0,0.0},{-50.7,34.2},{-43.5,53.1},{-37.1,66.4},{-31.4,74.6},{-25.8,79.1},{-20.2,79.8},{-14.6,76.6},{-8.9,69.7},{-3.3,59.4},{3.1,44.1},{11.17,21.2},{28.1,-30.8},{35.3,-50.2},{41.7,-64.2},{47.3,-73.1},{53.0,-78.4},{58.6,-80.0},{64.2,-77.6},{69.9,-71.5},{75.5,-61.9},{81.9,-47.2},{90.0,-24.8},{98.0,0.0}},
      color={160,160,164},
      smooth=Smooth.Bezier)}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Delay;
