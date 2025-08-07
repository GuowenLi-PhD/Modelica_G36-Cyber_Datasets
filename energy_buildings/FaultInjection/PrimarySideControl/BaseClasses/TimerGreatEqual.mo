within FaultInjection.PrimarySideControl.BaseClasses;
model TimerGreatEqual
  "Timer calculating the time when A is greater than or equal than B"

  parameter Real threshold=0 "Comparison with respect to threshold";

  Modelica.Blocks.Interfaces.RealInput u "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y(
    final quantity="Time",
    final unit="s")
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Logical.GreaterEqualThreshold greEqu(
     threshold = threshold)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

  Timer tim "Timer"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

equation
  connect(greEqu.y, tim.u)
    annotation (Line(points={{-29,0},{18,0}}, color={255,0,255}));
  connect(greEqu.u, u)
    annotation (Line(points={{-52,0},{-120,0}}, color={0,0,127}));
  connect(tim.y,y)  annotation (Line(points={{41,0},{110,0}}, color={0,0,127}));
  annotation (defaultComponentName="greEqu",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=5.0,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
                                   Text(
          extent={{-90,-40},{60,40}},
          lineColor={0,0,0},
          textString=">="),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
                                        Text(
        extent={{-150,152},{150,112}},
        textString="%name",
        lineColor={0,0,255})}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This model represents a timer that starts to calculate the time when the input is greater than or equal to a certain threshold. It will return to zero when the condition does not satisfy.</p>
</html>"));
end TimerGreatEqual;
