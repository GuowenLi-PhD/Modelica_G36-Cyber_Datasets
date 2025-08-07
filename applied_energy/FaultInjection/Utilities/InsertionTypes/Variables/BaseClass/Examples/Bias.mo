within FaultInjection.Utilities.InsertionTypes.Variables.BaseClass.Examples;
model Bias "Example to inject bias to signal"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;

    parameter Modelica.SIunits.Time startTime=1800
    "Output = offset for time < startTime";

  FaultInjection.Utilities.InsertionTypes.Variables.BaseClass.Bias fauBia(
      use_uFau_in=true)
    annotation (Placement(transformation(extent={{50,30},{70,50}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    m_flow=1,
    T=295.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(redeclare package Medium =
        Medium,                           nPorts=1)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium =
               Medium, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{16,-10},{36,10}})));
  Modelica.Blocks.Sources.BooleanStep booSte(startTime=startTime)
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.Sine fau(
    amplitude=2,
    freqHz=1/1800,
    startTime=startTime)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

equation
  connect(sou.ports[1], res.port_a)
    annotation (Line(points={{-60,0},{-12,0}}, color={0,127,255}));
  connect(res.port_b, senTem.port_a)
    annotation (Line(points={{8,0},{16,0}}, color={0,127,255}));
  connect(senTem.port_b, sin.ports[1])
    annotation (Line(points={{36,0},{60,0}}, color={0,127,255}));
  connect(senTem.T,fauBia. u)
    annotation (Line(points={{26,11},{26,40},{48,40}}, color={0,0,127}));
  connect(booSte.y,fauBia. triFau) annotation (Line(points={{-59,40},{26,40},{26,
          44},{48,44}}, color={255,0,255}));
  connect(fau.y,fauBia. uFau_in) annotation (Line(points={{-59,70},{26,70},{26,48},
          {48,48}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=5400));
end Bias;
