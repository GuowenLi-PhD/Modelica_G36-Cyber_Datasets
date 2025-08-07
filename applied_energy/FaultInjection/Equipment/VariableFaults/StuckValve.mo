within FaultInjection.Equipment.VariableFaults;
model StuckValve "Stuck Valve"
    extends Buildings.Fluid.Interfaces.PartialTwoPort;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate, used for regularization near zero flow";
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valEqu(
  redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal,
    show_T=show_T,
    from_dp=from_dp,
    linearized=linearized,
    deltaM=deltaM,
    dpValve_nominal=dpValve_nominal,
    rhoStd=rhoStd,
    use_inputFilter=use_inputFilter,
    riseTime=riseTime,
    order=order,
    init=init,
    y_start=y_start,
    dpFixed_nominal=dpFixed_nominal,
    l=l,
    kFixed=kFixed,
    R=R,
    delta0=delta0)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Utilities.InsertionTypes.Variables.SignalCorruption.External
                                            sig(faultMode=faultMode) "Signal"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

 parameter Utilities.InsertionTypes.Generic.faultMode faultMode
    annotation (Dialog(group="Fault Parameters"),Placement(transformation(extent={{40,80},{60,100}})));
  Utilities.FaultEvolution.Constant const(k=yStu)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Interfaces.RealInput y "Connector of Real input signal"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,118})));
  parameter Real yStu=0.5 "Cooling valve stuck postition"
    annotation (Dialog(group="Fault Parameters"));
  parameter Modelica.SIunits.PressureDifference dpValve_nominal(
    displayUnit="Pa")
    "Nominal pressure drop of fully open valve, used if CvData=Buildings.Fluid.Types.CvTypes.OpPoint";
  Modelica.Blocks.Interfaces.RealOutput y_actual "Actual valve position"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,40}), iconTransformation(extent={{44,66},{56,78}})));

  parameter Modelica.SIunits.PressureDifference dpFixed_nominal(
    displayUnit="Pa")
    "Pressure drop of pipe and other resistances that are in series";
  parameter Real l=0.0001 "Valve leakage, l=Kv(y=0)/Kv(y=1)";
  parameter Real kFixed=if valEqu.dpFixed_nominal > Modelica.Constants.eps
       then valEqu.m_flow_nominal/sqrt(valEqu.dpFixed_nominal) else 0
    "Flow coefficient of fixed resistance that may be in series with valve, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2).";
  parameter Real R=50 "Rangeability, R=50...100 typically";
  parameter Real delta0=0.01
    "Range of significant deviation from equal percentage law";
  parameter Real deltaM=0.02
    "Fraction of nominal flow rate where linearization starts, if y=1"
    annotation (Dialog(group="Pressure-flow linearization"));
  parameter Boolean show_T=false
    "= true, if actual temperature at port is computed"
    annotation (Dialog(tab="Advanced", group="Diagnostics"));
  parameter Boolean from_dp=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Advanced", group="Diagnostics"));
  parameter Boolean linearized=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (Dialog(tab="Advanced", group="Diagnostics"));
  parameter Modelica.SIunits.Density rhoStd=Medium.density_pTX(
      101325,
      273.15 + 4,
      Medium.X_default)
    "Inlet density for which valve coefficients are defined"
    annotation (Dialog(tab="Advanced", group="Nominal condition"));
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

equation
  connect(valEqu.port_a, port_a)
    annotation (Line(points={{-10,0},{-100,0}}, color={0,127,255}));
  connect(valEqu.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(sig.y,valEqu. y)
    annotation (Line(points={{-19,50},{0,50},{0,12}}, color={0,0,127}));
  connect(sig.u, y) annotation (Line(points={{-42,50},{-48,50},{-48,88},{0,88},{
          0,118}}, color={0,0,127}));
  connect(valEqu.y_actual, y_actual)
    annotation (Line(points={{5,7},{20,7},{20,40},{50,40}}, color={0,0,127}));
  connect(const.y, sig.uFau) annotation (Line(points={{-59,70},{-52,70},{-52,56},
          {-42,56}}, color={0,0,127}));
  annotation (defaultComponentName="stuDam",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{4,72},{44,72}}),
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
                  Line(
         points={{0,100},{0,-24}}),
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
        Text(
          visible=use_inputFilter,
          extent={{-20,92},{20,48}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="M",
          textStyle={TextStyle.Bold}),   Rectangle(
      extent={{-58,40},{64,-42}},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None),
    Polygon(
      points={{0,-4},{-76,56},{-76,-64},{0,-4}},
      lineColor={0,0,0},
      fillColor=DynamicSelect({0,0,0}, y*{255,255,255}),
      fillPattern=FillPattern.Solid),
    Polygon(
      points={{0,-4},{76,56},{76,-64},{0,-4}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
        Line(
          points={{-54,-68},{52,62}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{-56,64},{54,-70}},
          color={238,46,47},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StuckValve;
