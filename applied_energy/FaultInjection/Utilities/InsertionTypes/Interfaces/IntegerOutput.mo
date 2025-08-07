within FaultInjection.Utilities.InsertionTypes.Interfaces;
connector IntegerOutput = output Integer "'output Integerl' as connector"
   annotation (
  defaultComponentName="y",
  Icon(
    coordinateSystem(preserveAspectRatio=true,
      extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
    Polygon(
      lineColor={238,46,47},
      fillColor={255,213,170},
      fillPattern=FillPattern.Solid,
      points={{-100.0,100.0},{100.0,0.0},{-100.0,-100.0}})}),
  Diagram(
    coordinateSystem(preserveAspectRatio=true,
      extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
    Polygon(
      lineColor={235,0,0},
      fillColor={255,213,170},
      fillPattern=FillPattern.Solid,
      points={{-100.0,50.0},{0.0,0.0},{-100.0,-50.0}},
        lineThickness=1),
    Text(
      lineColor={235,0,0},
      extent={{30.0,60.0},{30.0,110.0}},
      textString="%name")}),
  Documentation(info="<html>
<p>
Connector with one output signal of type Real.
</p>
</html>"));
