within FaultInjection.Utilities.InsertionTypes.Variables.SignalDelay;
model RealVariableDelay "Trigger variable delay event"

  extends FaultInjection.Utilities.InsertionTypes.Interfaces.FaultInterfaceReal;
  parameter Real delayMax(min=0, start=1) "maximum delay time";

  parameter Generic.faultMode faultMode
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Modelica.Blocks.Interfaces.RealInput delayTime         annotation (Placement(
        transformation(extent={{-140,40},{-100,80}})));

  Modelica.Blocks.Sources.BooleanTable booTab(final startValue=false, table={
        faultMode.startTime,faultMode.endTime})     "Boolean table"
    annotation (Placement(transformation(extent={{-80,52},{-60,72}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Sources.BooleanExpression active(y=faultMode.active)
    "Fault is injected"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

equation
  if and1.y then
    y = delay(u, delayTime, delayMax);
  else
    y = u;
  end if;

  connect(booTab.y,and1. u2)
    annotation (Line(points={{-59,62},{-42,62}}, color={255,0,255}));
  connect(active.y,and1. u1) annotation (Line(points={{-59,90},{-52,90},{-52,70},
          {-42,70}}, color={255,0,255}));
  annotation (defaultComponentName="triVarDel",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p> This model simulates a DOS attack that inject fixed delay time of the passing signal <code>u</code>. The signal is considered as continuous.
</p>

<h4>
Note
</h4>

</html>",
      revisions="<html>
<ul>
<li>
August 20, 2020, by Yangyang Fu:<br/>
First implementation
</li>
</ul>
</html>"));
end RealVariableDelay;
