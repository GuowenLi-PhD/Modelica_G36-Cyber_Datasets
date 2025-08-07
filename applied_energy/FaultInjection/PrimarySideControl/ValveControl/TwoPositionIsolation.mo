within FaultInjection.PrimarySideControl.ValveControl;
model TwoPositionIsolation
  "Control of two position isolation valves: on/off"
   extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Math.BooleanToReal booToRea "Boolean to real"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput ope "Open"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y "Position signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(booToRea.u, ope)
    annotation (Line(points={{-12,0},{-120,0}}, color={255,0,255}));
  connect(booToRea.y, y)
    annotation (Line(points={{11,0},{110,0}}, color={0,0,127}));
  annotation (defaultComponentName="twoPosIso",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>The two position isolation valve is on/off when the equipent is enabled/disabled.</p>
</html>"));
end TwoPositionIsolation;
