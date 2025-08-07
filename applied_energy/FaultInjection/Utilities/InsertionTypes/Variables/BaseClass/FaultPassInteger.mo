within FaultInjection.Utilities.InsertionTypes.Variables.BaseClass;
model FaultPassInteger
  "Block that passes Integer faulty signal when triggerred"
  extends FaultInjection.Utilities.InsertionTypes.Interfaces.FaultInterfaceInteger;

  parameter Boolean use_u_f_in = false "Get the faulty signal from the input connector"
    annotation(Evaluate=true, HideResult=true, Dialog(group="Conditional inputs"));
  parameter Integer u_f= 0  "Fault signal"
    annotation(Dialog(enable = not use_u_f_in,group="Fixed inputs"));

  FaultInjection.Utilities.InsertionTypes.Interfaces.IntegerInput  u_f_in if  use_u_f_in
    "Prescribed faulty signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Modelica.Blocks.Interfaces.BooleanInput trigger "Trigger fault"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
protected
    FaultInjection.Utilities.InsertionTypes.Interfaces.IntegerInput u_f_in_internal
    "Needed to connect to conditional connector";

equation

  connect(u_f_in, u_f_in_internal);
  if not use_u_f_in then
    u_f_in_internal = u_f;
  end if;

  connect(u_f_in_internal,intSwi.u1);
  connect(u, intSwi.u3) annotation (Line(points={{-120,0},{-60,0},{-60,-8},{-12,
          -8}}, color={238,46,47}));
  connect(intSwi.y, y)
    annotation (Line(points={{12,0},{110,0}}, color={255,127,0}));
  connect(trigger, intSwi.u2) annotation (Line(points={{-120,40},{-40,40},{-40,0},
          {-12,0}}, color={255,0,255}));
  annotation (defaultComponentName="fauPas",
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
end FaultPassInteger;
