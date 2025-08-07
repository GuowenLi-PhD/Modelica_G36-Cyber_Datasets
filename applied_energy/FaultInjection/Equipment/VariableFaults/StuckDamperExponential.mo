within FaultInjection.Equipment.VariableFaults;
model StuckDamperExponential "Stuck Damper"
        extends Buildings.Fluid.Interfaces.PartialTwoPort;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate, used for regularization near zero flow"
    annotation (Dialog(group="Nominal condition"));
  Utilities.InsertionTypes.Variables.SignalCorruption.External
                                                           sig(faultMode=faultMode) "Signal"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  parameter Utilities.InsertionTypes.Generic.faultMode faultMode
    annotation (Dialog(group="Fault Parameters"),Placement(transformation(extent={{40,80},{60,100}})));
  FaultInjection.Equipment.VariableFaults.BaseClasses.Exponential exp(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal,
    show_T=show_T,
    from_dp=from_dp,
    linearized=linearized,
    use_inputFilter=use_inputFilter,
    riseTime=riseTime,
    order=order,
    init=init,
    y_start=y_start,
    dpDamper_nominal=dpDamper_nominal,
    dpFixed_nominal=dpFixed_nominal,
    use_deltaM=use_deltaM,
    deltaM=deltaM,
    a=a,
    b=b,
    yL=yL,
    yU=yU,
    k1=k1,
    l=l,
    use_constant_density=use_constant_density)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  FaultInjection.Utilities.FaultEvolution.Constant const(k=yStu)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Interfaces.RealInput y "Connector of Real input signal"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,118})));
  parameter Real yStu=0.5 "Damper stuck postition"
    annotation (Dialog(group="Fault Parameters"));
  parameter Modelica.SIunits.PressureDifference dpDamper_nominal(
    displayUnit="Pa") "Pressure drop at nominal mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  Modelica.Blocks.Interfaces.RealOutput y_actual "Actual damper position"
    annotation (Placement(transformation(extent={{48,60},{68,80}}),
        iconTransformation(extent={{48,64},{60,76}})));

  parameter Boolean use_deltaM=true
    "Set to true to use deltaM for turbulent transition, else ReC is used";
  parameter Real deltaM=0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
        annotation(Dialog(enable=use_deltaM));
  parameter Modelica.SIunits.PressureDifference dpFixed_nominal(
    displayUnit="Pa")
    "Pressure drop of duct and resistances other than the damper in series, at nominal mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean show_T=false
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));
  parameter Boolean from_dp=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"    annotation (Dialog(tab="Advanced"));
  parameter Boolean linearized=false
    "= true, use linear relation between m_flow and dp for any flow rate"     annotation (Dialog(tab="Advanced"));
  parameter Boolean use_constant_density=true
    "Set to true to use constant density for flow friction"     annotation (Dialog(tab="Advanced"));
  parameter Boolean use_inputFilter=true
    "= true, if opening is filtered with a 2nd order CriticalDamping filter"
    annotation (Dialog(tab="Dynamics", group="Filtered opening"));
  parameter Modelica.SIunits.Time riseTime=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation (Dialog(tab="Dynamics", group="Filtered opening"));
  parameter Integer order=2 "Order of filter"
    annotation (Dialog(tab="Dynamics", group="Filtered opening"));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation (Dialog(tab="Dynamics", group="Filtered opening"));
  parameter Real y_start=1 "Initial value of output"
    annotation (Dialog(tab="Dynamics", group="Filtered opening"));
  parameter Real a=-1.51 "Coefficient a for damper characteristics"
    annotation (Dialog(tab="Damper coefficients"));
  parameter Real b=0.105*90 "Coefficient b for damper characteristics"
    annotation (Dialog(tab="Damper coefficients"));
  parameter Real yL=15/90 "Lower value for damper curve"
    annotation (Dialog(tab="Damper coefficients"));
  parameter Real yU=55/90 "Upper value for damper curve"
    annotation (Dialog(tab="Damper coefficients"));
  parameter Real k1=0.45
    "Loss coefficient for y=1 (pressure drop divided by dynamic pressure)"
    annotation (Dialog(tab="Damper coefficients"));
  parameter Real l=0.0001
    "Damper leakage, ratio of flow coefficients k(y=0)/k(y=1)"
    annotation (Dialog(tab="Damper coefficients"));

equation
  connect(exp.port_a, port_a)
    annotation (Line(points={{-10,0},{-100,0}}, color={0,127,255}));
  connect(exp.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(sig.y, exp.y)
    annotation (Line(points={{-19,50},{0,50},{0,12}}, color={0,0,127}));
  connect(sig.u, y) annotation (Line(points={{-42,50},{-48,50},{-48,88},{0,88},
          {0,118}}, color={0,0,127}));
  connect(exp.y_actual, y_actual)
    annotation (Line(points={{5,7},{20,7},{20,70},{58,70}}, color={0,0,127}));
  connect(const.y, sig.uFau) annotation (Line(points={{-59,70},{-54,70},{-54,56},
          {-42,56}}, color={0,0,127}));
  annotation (defaultComponentName="stuDam",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{12,70},{52,70}}),
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
          points={{-26,4},{22,46},{22,34},{-26,-8},{-26,4}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid), Polygon(
          points={{-22,-40},{26,2},{26,-10},{-22,-52},{-22,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-52,-68},{54,62}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{-54,64},{56,-70}},
          color={238,46,47},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StuckDamperExponential;
