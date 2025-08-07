within FaultInjection.Utilities.InsertionTypes.Variables.BaseClass;
partial model PartialFaultInjectionReal
  "Partial model for fault injection"
  extends
  FaultInjection.Utilities.InsertionTypes.Interfaces.FaultInterfaceReal;

  parameter Generic.faultMode faultMode
    annotation (Placement(transformation(extent={{60,80},{80,100}})));

  FaultInjection.Utilities.InsertionTypes.Variables.BaseClass.FaultPassReal fauPas(
    use_u_f_in=true)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.BooleanTable booTab(
    final startValue=false,
    table= {faultMode.startTime,faultMode.endTime}) "Boolean table"
    annotation (Placement(transformation(extent={{-80,52},{-60,72}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Sources.BooleanExpression active(y=faultMode.active)
    "Fault is injected"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
equation
  connect(u, fauPas.u)
    annotation (Line(points={{-120,0},{38,0}},  color={0,0,127}));
  connect(fauPas.y, y)
    annotation (Line(points={{61,0},{110,0}}, color={0,0,127}));
  connect(booTab.y, and1.u2)
    annotation (Line(points={{-59,62},{-42,62}}, color={255,0,255}));
  connect(active.y, and1.u1) annotation (Line(points={{-59,90},{-52,90},{-52,70},
          {-42,70}}, color={255,0,255}));
  connect(and1.y, fauPas.trigger) annotation (Line(points={{-19,70},{20,70},{20,
          4},{38,4}},                color={255,0,255}));

  annotation (
    Documentation(info="<html>

</html>",
      revisions="<html>
<ul>
<li>
August 31, 2020, by Yangyang Fu:<br/>
First implementation
</li>
</ul>
</html>"));
end PartialFaultInjectionReal;
