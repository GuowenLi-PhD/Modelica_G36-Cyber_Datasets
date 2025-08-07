within FaultInjection.Utilities.InsertionTypes.Interfaces;
connector IntegerInput = input Integer "'input Integerl' as connector"
  annotation (
  defaultComponentName="u",
  Icon(graphics={
    Polygon(
      lineColor={238,46,47},
      fillColor={244,125,35},
      fillPattern=FillPattern.Solid,
      points={{-100.0,100.0},{100.0,0.0},{-100.0,-100.0}})},
    coordinateSystem(extent={{-100.0,-100.0},{100.0,100.0}},
      preserveAspectRatio=true,
      initialScale=0.2)),
  Diagram(
    coordinateSystem(preserveAspectRatio=true,
      initialScale=0.2,
      extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
    Polygon(
      lineColor={238,46,47},
      fillColor={244,125,35},
      fillPattern=FillPattern.Solid,
      points={{0.0,50.0},{100.0,0.0},{0.0,-50.0},{0.0,50.0}}),
    Text(
      lineColor={235,0,0},
      extent={{-10.0,60.0},{-10.0,85.0}},
      textString="%name")}),
  Documentation(info="<html>
<p>
Connector with one input signal of type Real.
</p>
</html>"));
