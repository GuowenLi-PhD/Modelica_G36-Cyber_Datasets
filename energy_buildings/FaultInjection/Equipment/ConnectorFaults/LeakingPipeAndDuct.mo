within FaultInjection.Equipment.ConnectorFaults;
model LeakingPipeAndDuct "Pipe and duct with leakage"
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

  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal,
    show_T=show_T,
    from_dp=from_dp,
    dp_nominal=dp_nominal,
    linearized=linearized,
    deltaM=deltaM)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  parameter Real deltaM(min=1E-6) = 0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
       annotation(Evaluate=true,
                  Dialog(group = "Transition to laminar",
                         enable = not linearized));

 parameter Utilities.InsertionTypes.Generic.faultMode faultMode
    annotation (Placement(transformation(extent={{-2,80},{18,100}})));

  Utilities.InsertionTypes.Connectors.Leakage lea(
    redeclare package Medium = Medium, faultMode=faultMode)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Interfaces.RealInput m_flow_leakage
    "Prescribed leakage mass flow rate: must be negative"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

equation
  connect(port_a, res.port_a)
    annotation (Line(points={{-100,0},{-60,0}}, color={0,127,255}));
  connect(lea.port, res.port_b) annotation (Line(points={{-40,30},{-20,30},{-20,
          0},{-40,0}}, color={0,127,255}));
  connect(res.port_b, port_b)
    annotation (Line(points={{-40,0},{100,0}}, color={0,127,255}));
  connect(lea.m_flow_leakage, m_flow_leakage) annotation (Line(points={{-62,30},
          {-80,30},{-80,60},{-120,60}}, color={0,0,127}));
  annotation (defaultComponentName="preDro",
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
          fillColor={0,127,255})}),                              Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end LeakingPipeAndDuct;
