within FaultInjection.Equipment.VariableFaults.Examples;
model FaultTemperatureSensor
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;

  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    m_flow=1,
    T=295.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=1)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  FaultInjection.Equipment.VariableFaults.FaultTemperatureSensor senTem(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    faultMode=faultMode)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
 parameter Utilities.InsertionTypes.Generic.faultMode
                             faultMode
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Modelica.Blocks.Noise.NormalNoise noi(
    samplePeriod=0.5,
    mu=0,
    sigma=0.1) "Noise"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  inner Modelica.Blocks.Noise.GlobalSeed globalSeed
    annotation (Placement(transformation(extent={{-62,-66},{-42,-46}})));
equation
  connect(sou.ports[1],res. port_a)
    annotation (Line(points={{-60,0},{-20,0}}, color={0,127,255}));
  connect(res.port_b, senTem.port_a)
    annotation (Line(points={{0,0},{20,0}}, color={0,127,255}));
  connect(senTem.port_b, sin.ports[1])
    annotation (Line(points={{40,0},{60,0}}, color={0,127,255}));
  connect(noi.y, senTem.uFau_in)
    annotation (Line(points={{-19,50},{0,50},{0,8},{18,8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=7200));
end FaultTemperatureSensor;
