within FaultInjection.Equipment.VariableFaults.Examples;
model FaultFlowSensor
  import FaultInjection;
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;

  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    m_flow=1,
    nPorts=1,
    T=295.15)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium, nPorts=1)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
 parameter Utilities.InsertionTypes.Generic.faultMode
                             faultMode(startTime=100, endTime=200)
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  FaultInjection.Equipment.VariableFaults.FaultFlowSensor senVol(
    redeclare package Medium = Medium,
    faultMode=faultMode,
    m_flow_nominal=1.5)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Noise.NormalNoise noi(
    samplePeriod=0.5,
    mu=0,
    sigma=0.1) "Noise"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  inner Modelica.Blocks.Noise.GlobalSeed globalSeed
    annotation (Placement(transformation(extent={{-34,-54},{-14,-34}})));
equation
  connect(senVol.port_b, sin.ports[1])
    annotation (Line(points={{40,0},{60,0}}, color={0,127,255}));
  connect(senVol.port_a, sou.ports[1])
    annotation (Line(points={{20,0},{-60,0}}, color={0,127,255}));
  connect(noi.y, senVol.uFau_in)
    annotation (Line(points={{-19,40},{0,40},{0,8},{18,8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=500));
end FaultFlowSensor;
