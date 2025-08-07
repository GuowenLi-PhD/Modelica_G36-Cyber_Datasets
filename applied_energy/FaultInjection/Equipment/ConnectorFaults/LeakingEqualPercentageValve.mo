within FaultInjection.Equipment.ConnectorFaults;
model LeakingEqualPercentageValve "Two way valves with leakage"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Advanced"));

  parameter Modelica.SIunits.PressureDifference dp_nominal(displayUnit="Pa")
    "Pressure drop at nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  parameter Real deltaM(min=1E-6) = 0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
       annotation(Evaluate=true,
                  Dialog(group = "Transition to laminar",
                         enable = not linearized));

 parameter Utilities.InsertionTypes.Generic.faultMode faultMode
    annotation (Placement(transformation(extent={{40,78},{60,98}})));

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valEqu(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal,
    show_T=show_T,
    from_dp=from_dp,
    linearized=linearized,
    deltaM=deltaM,
    dpValve_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Utilities.InsertionTypes.Connectors.Leakage lea(
    redeclare package Medium = Medium, faultMode=faultMode)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Interfaces.RealInput m_flow_leakage
    "Prescribed leakage mass flow rate: must be negative"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput y_actual "Actual valve position"
    annotation (Placement(transformation(extent={{40,60},{60,80}}),
        iconTransformation(extent={{40,60},{60,80}})));
  Modelica.Blocks.Interfaces.RealInput y1
    "Actuator position (0: closed, 1: open)" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120})));

equation
  connect(port_a, valEqu.port_a)
    annotation (Line(points={{-100,0},{-60,0}}, color={0,127,255}));
  connect(valEqu.port_b, port_b)
    annotation (Line(points={{-40,0},{100,0}}, color={0,127,255}));
  connect(lea.m_flow_leakage, m_flow_leakage) annotation (Line(points={{-62,30},
          {-80,30},{-80,60},{-120,60}}, color={0,0,127}));
  connect(valEqu.y_actual, y_actual) annotation (Line(points={{-45,7},{38,7},{38,
          70},{50,70}}, color={0,0,127}));
  connect(valEqu.y, y1) annotation (Line(points={{-50,12},{-50,20},{0,20},{0,120}},
        color={0,0,127}));
  connect(lea.port, valEqu.port_b) annotation (Line(points={{-40,30},{-20,30},{
          -20,0},{-40,0}}, color={0,127,255}));
  annotation (defaultComponentName="twoWayVav",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(extent={{-100,80},{100,-100}}, lineColor={238,46,47}),
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
          closure=EllipseClosure.Chord),
        Rectangle(
          extent={{-100,40},{100,-42}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,22},{100,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Line(
          points={{0,40},{0,100}}),
        Rectangle(
          visible=use_inputFilter,
          extent={{-32,40},{32,100}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          visible=use_inputFilter,
          extent={{-32,100},{32,40}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          visible=use_inputFilter,
          extent={{-20,92},{20,48}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="M",
          textStyle={TextStyle.Bold}),
        Polygon(
          points={{2,-2},{-76,60},{-76,-60},{2,-2}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-50,40},{0,-2},{54,40},{54,40},{-50,40}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-52,-42},{0,-4},{60,40},{60,-42},{-52,-42}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-2},{82,60},{82,-60},{0,-2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,40},{0,-4}}),
        Polygon(
          points={{2,-2},{-76,60},{-76,-60},{2,-2}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-50,40},{0,-2},{54,40},{54,40},{-50,40}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-52,-42},{0,-4},{60,40},{60,-42},{-52,-42}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-2},{82,60},{82,-60},{0,-2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,40},{0,-4}}), Text(
          extent={{-74,20},{-36,-24}},
          lineColor={255,255,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="%%"),
        Line(
          points={{0,70},{40,70}})}),                            Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end LeakingEqualPercentageValve;
