within FaultInjection.Utilities.InsertionTypes.Interfaces;
partial block FaultInterfaceInteger
  "Fault injection interface for integer inputs and outputs"

  FaultInjection.Utilities.InsertionTypes.Interfaces.IntegerInput
            u "Connector of Integer input signal" annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}})));
  FaultInjection.Utilities.InsertionTypes.Interfaces.IntegerOutput
             y "Connector of Integer output signal" annotation (Placement(
        transformation(extent={{100,-10},{120,10}})));

  annotation (defaultComponentName="fauSig",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={238,46,47},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(points={{100,0},{42,0}}, color={0,0,127}),
        Line(points={{42,0},{-20,60}},
        color={0,0,127}),
        Line(points={{42,0},{-20,0}},
        color = DynamicSelect({235,235,235}, if activate.y then {235,235,235}
                    else {0,0,0})),
        Line(points={{-100,0},{-20,0}}, color={0,0,127}),
        Line(points={{-62,60},{-20,60}},  color={0,0,127}),
        Polygon(
          points={{-58,70},{-28,60},{-58,50},{-58,70}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-22,62},{-18,58}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-22,2},{-18,-2}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{40,2},{44,-2}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Line(points={{-16,0},{16,0}},     color={0,0,127},
          origin={-62,60},
          rotation=90),
        Line(points={{-16,0},{16,0}},     color={0,0,127},
          origin={-66,60},
          rotation=90),
        Line(points={{-16,0},{16,0}},     color={0,0,127},
          origin={-70,60},
          rotation=90),
        Ellipse(
          extent={{-77,67},{-91,53}},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({235,235,235}, if activate.y then {0,255,0}
                    else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if activate.y then {0,255,0}
                    else {235,235,235})),
                                        Text(
        extent={{-150,150},{150,110}},
        lineColor={238,46,47},
          textString="%name")}),            Diagram(coordinateSystem(
          preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This model injects obsolute signal to an Modelica variable that serves as model inputs or outputs.</p>
</html>", revisions="<html>
<ul>
<li>
May 15, 2020, by Yangyang Fu:<br/>
First implementation
</li>
</ul>
</html>"));
end FaultInterfaceInteger;
