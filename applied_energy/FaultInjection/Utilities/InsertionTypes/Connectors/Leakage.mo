within FaultInjection.Utilities.InsertionTypes.Connectors;
model Leakage "Leakage faults of equipment"
     replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    m_flow=1,
    nPorts=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,0})));
  Modelica.Fluid.Interfaces.FluidPort_a port(redeclare package Medium = Medium)
                                             annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={100,0})));

  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={70,0})));
  Modelica.Blocks.Interfaces.RealInput m_flow_leakage
    "Prescribed leakage mass flow rate: must be negative"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
 parameter Generic.faultMode faultMode
    annotation (Placement(transformation(extent={{60,78},{80,98}})));
  Modelica.Blocks.Sources.BooleanTable fauInj(final startValue=false, table={
        faultMode.startTime,faultMode.endTime}) "Fault injected: true or false"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Sources.Constant zer(k=0)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Logical.Switch swi
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

  Modelica.Blocks.Sources.BooleanExpression active(y=faultMode.active)
    "Fault is injected"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{-20,58},{0,78}})));
equation
  connect(sou.ports[1], res.port_a) annotation (Line(points={{20,0},{60,0},{60,1.77636e-15}},
                                                              color={0,127,255}));
  connect(res.port_b, port) annotation (Line(points={{80,-8.88178e-16},{100,-8.88178e-16},
          {100,0}},  color={0,127,255}));
  connect(m_flow_leakage, swi.u1) annotation (Line(points={{-120,0},{-52,0},{-52,
          18},{-42,18}}, color={0,0,127}));
  connect(zer.y, swi.u3) annotation (Line(points={{-59,-30},{-50,-30},{-50,2},{-42,
          2}}, color={0,0,127}));
  connect(swi.y, sou.m_flow_in) annotation (Line(points={{-19,10},{-10,10},{-10,
          8},{-2,8}}, color={0,0,127}));
  connect(fauInj.y, and1.u1) annotation (Line(points={{-59,90},{-40,90},{-40,68},
          {-22,68}}, color={255,0,255}));
  connect(active.y, and1.u2)
    annotation (Line(points={{-59,60},{-22,60}}, color={255,0,255}));
  connect(and1.y, swi.u2) annotation (Line(points={{1,68},{14,68},{14,42},{-60,
          42},{-60,10},{-42,10}}, color={255,0,255}));
  annotation (defaultComponentName="lea",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,40},{100,-26}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-40,-12},{-50,-34}},
          lineColor={238,46,47},
          closure=EllipseClosure.Chord),
        Ellipse(
          extent={{-14,-32},{-24,-54}},
          lineColor={238,46,47},
          closure=EllipseClosure.Chord),
        Ellipse(
          extent={{18,-46},{8,-68}},
          lineColor={238,46,47},
          closure=EllipseClosure.Chord),
        Ellipse(
          extent={{-14,-68},{-24,-90}},
          lineColor={238,46,47},
          closure=EllipseClosure.Chord),
        Ellipse(
          extent={{-36,-48},{-46,-70}},
          lineColor={238,46,47},
          closure=EllipseClosure.Chord),Text(
        extent={{-150,150},{150,110}},
        lineColor={238,46,47},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Leakage;
