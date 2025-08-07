within FaultInjection.Equipment.VariableFaults;
model StuckDamper "Stuck Damper"
    extends Buildings.Fluid.Interfaces.PartialTwoPort;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate, used for regularization near zero flow";
  parameter Modelica.SIunits.Time tau=1
    "Time constant at nominal flow rate (use tau=0 for steady-state sensor, but see user guide for potential problems)";
      parameter Modelica.Blocks.Types.Init initType = Modelica.Blocks.Types.Init.InitialState
    "Type of initialization (InitialState and InitialOutput are identical)"
  annotation(Evaluate=true, Dialog(group="Initialization"));

  parameter Modelica.SIunits.Temperature T_start=Medium.T_default
    "Initial or guess value of output (= state)";
  Utilities.InsertionTypes.Variables.SignalCorruption.External
                                          sig(faultMode=faultMode) "Signal"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

 parameter Utilities.InsertionTypes.Generic.faultMode faultMode
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Buildings.Fluid.Actuators.Dampers.PressureIndependent preInd(
  redeclare package Medium = Medium, dpDamper_nominal=dpDamper_nominal,
  m_flow_nominal=m_flow_nominal,
    dpFixed_nominal=dpFixed_nominal,
    use_deltaM=use_deltaM,
    deltaM=deltaM)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Utilities.FaultEvolution.Constant const(k=yStu)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Interfaces.RealInput y "Connector of Real input signal"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,118})));
  parameter Real yStu=0.5 "Damper stuck postition";
  parameter Modelica.SIunits.PressureDifference dpDamper_nominal(
    displayUnit="Pa")
    "Damper nominal pressure drop";
  Modelica.Blocks.Interfaces.RealOutput y_actual "Actual damper position"
    annotation (Placement(transformation(extent={{48,60},{68,80}}),
        iconTransformation(extent={{48,64},{60,76}})));

  parameter Boolean use_deltaM=true
    "Set to true to use deltaM for turbulent transition, else ReC is used";
  parameter Real deltaM=0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs";
  parameter Modelica.SIunits.PressureDifference dpFixed_nominal=0
    "Pressure drop of duct and resistances other than the damper in series, at nominal mass flow rate";

equation
  connect(preInd.port_a, port_a)
    annotation (Line(points={{-10,0},{-100,0}}, color={0,127,255}));
  connect(preInd.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(sig.y, preInd.y)
    annotation (Line(points={{-19,50},{0,50},{0,12}}, color={0,0,127}));
  connect(sig.u, y) annotation (Line(points={{-42,50},{-48,50},{-48,88},{0,88},
          {0,118}}, color={0,0,127}));
  connect(preInd.y_actual, y_actual)
    annotation (Line(points={{5,7},{20,7},{20,70},{58,70}}, color={0,0,127}));
  connect(const.y, sig.uFau) annotation (Line(points={{-59,70},{-52,70},{-52,56},
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
        Line(
          points={{-52,-68},{54,62}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{-54,64},{56,-70}},
          color={238,46,47},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StuckDamper;
