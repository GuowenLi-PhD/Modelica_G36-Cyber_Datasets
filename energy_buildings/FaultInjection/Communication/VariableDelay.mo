within FaultInjection.Communication;
block VariableDelay "Delay block with variable DelayTime"
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Real delayMax(min=0, start=1) "maximum delay time";

  Modelica.Blocks.Interfaces.RealInput delayTime         annotation (Placement(
        transformation(extent={{-140,-80},{-100,-40}})));
equation
  y = delay(u, delayTime, delayMax);
  annotation (
    Documentation(info="<html>
<p>
The Input signal is delayed by a given time instant, or more precisely:
</p>
<pre>
   y = u(time - delayTime) for time &gt; time.start + delayTime
     = u(time.start)       for time &le; time.start + delayTime
</pre>
<p>
where delayTime is an additional input signal which must follow
the following relationship:
</p>
<pre>  0 &le; delayTime &le; delayMax
</pre>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100.0,-100.0},{100.0,100.0}}), graphics={
    Text(extent={{-100.0,-148.0},{100.0,-108.0}},
      textString="delayMax=%delayMax"),
    Line(points={{-92.0,0.0},{-80.7,34.2},{-73.5,53.1},{-67.1,66.4},{-61.4,74.6},{-55.8,79.1},{-50.2,79.8},{-44.6,76.6},{-38.9,69.7},{-33.3,59.4},{-26.9,44.1},{-18.83,21.2},{-1.9,-30.8},{5.3,-50.2},{11.7,-64.2},{17.3,-73.1},{23.0,-78.4},{28.6,-80.0},{34.2,-77.6},{39.9,-71.5},{45.5,-61.9},{51.9,-47.2},{60.0,-24.8},{68.0,0.0}},
      color={0,0,127},
      smooth=Smooth.Bezier),
    Line(points={{-64.0,0.0},{-52.7,34.2},{-45.5,53.1},{-39.1,66.4},{-33.4,74.6},{-27.8,79.1},{-22.2,79.8},{-16.6,76.6},{-10.9,69.7},{-5.3,59.4},{1.1,44.1},{9.17,21.2},{26.1,-30.8},{33.3,-50.2},{39.7,-64.2},{45.3,-73.1},{51.0,-78.4},{56.6,-80.0},{62.2,-77.6},{67.9,-71.5},{73.5,-61.9},{79.9,-47.2},{88.0,-24.8},{96.0,0.0}},
      smooth=Smooth.Bezier),
    Polygon(fillPattern=FillPattern.Solid,
      lineColor={0,0,127},
      fillColor={0,0,127},
      points={{6.0,4.0},{-14.0,-2.0},{-6.0,-12.0},{6.0,4.0}}),
    Line(color={0,0,127},
      points={{-100.0,-60.0},{-76.0,-60.0},{-8.0,-6.0}})}),
  Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
    Rectangle(
      extent={{-100,-100},{100,100}},
      lineColor={0,0,255},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Polygon(
      points={{-80,96},{-86,80},{-74,80},{-80,96}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Text(
      extent={{-69,98},{-40,78}},
      lineColor={0,0,255},
      textString="output"),
    Line(points={{-64,0},{-52.7,34.2},{-45.5,53.1},{-39.1,66.4},{-33.4,
          74.6},{-27.8,79.1},{-22.2,79.8},{-16.6,76.6},{-10.9,69.7},{-5.3,
          59.4},{1.1,44.1},{9.17,21.2},{26.1,-30.8},{33.3,-50.2},{39.7,-64.2},
          {45.3,-73.1},{51,-78.4},{56.6,-80},{62.2,-77.6},{67.9,-71.5},{
          73.5,-61.9},{79.9,-47.2},{88,-24.8},{96,0}}, smooth=Smooth.Bezier),
    Line(points={{-80,0},{-68.7,34.2},{-61.5,53.1},{-55.1,66.4},{-49.4,
          74.6},{-43.8,79.1},{-38.2,79.8},{-32.6,76.6},{-26.9,69.7},{-21.3,
          59.4},{-14.9,44.1},{-6.83,21.2},{10.1,-30.8},{17.3,-50.2},{23.7,
          -64.2},{29.3,-73.1},{35,-78.4},{40.6,-80},{46.2,-77.6},{51.9,-71.5},
          {57.5,-61.9},{63.9,-47.2},{72,-24.8},{80,0}}, color={0,0,127},
          smooth=Smooth.Bezier),
    Line(points={{-100,0},{84,0}}, color={192,192,192}),
    Polygon(
      points={{100,0},{84,6},{84,-6},{100,0}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Text(
      extent={{67,22},{96,6}},
      lineColor={160,160,164},
      textString="time"),
    Text(
      extent={{-58,-42},{-58,-32}},
      textString="delayTime",
      lineColor={0,0,255}),
    Line(points={{-80,-88},{-80,86}}, color={192,192,192}),
    Text(
      extent={{-24,98},{-2,78}},
      lineColor={0,0,0},
      textString="input"),
    Polygon(
      points={{-80,-26},{-88,-24},{-88,-28},{-80,-26}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Polygon(
      points={{-56,-24},{-64,-26},{-56,-28},{-56,-24}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-64,-26},{-50,-26}}, color={192,192,192}),
    Line(points={{-94,-26},{-80,-26}}, color={192,192,192}),
    Line(
      points={{-100,-60},{-70,-60},{-64,-44}},
      arrow={Arrow.None,Arrow.Filled},
      color={0,0,127}),
    Line(points={{-64,-30},{-64,0}}, color={192,192,192})}));
end VariableDelay;
