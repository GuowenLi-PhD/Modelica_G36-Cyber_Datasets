within FaultInjection.Equipment.ConnectorFaults.Examples;
model LeakingEqualPercentageValve "Test leakage"
  extends Modelica.Icons.Example;
    package Medium = Buildings.Media.Water;
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    m_flow=1,
    T=295.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(redeclare package Medium = Medium,
      nPorts=1)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  VariableFaults.FaultTemperatureSensor senTem(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    faultMode=faultMode)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
 parameter Utilities.InsertionTypes.Generic.faultMode
                             faultMode(startTime=100, endTime=200)
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Modelica.Blocks.Sources.Ramp leaFlo(
    height=-0.6, duration=360)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Noise.NormalNoise noi(
    samplePeriod=0.5,
    mu=0,
    sigma=0.1) "Noise"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Modelica.Blocks.Sources.Ramp y(
    height=1,
    offset=0,
    duration=360)
              "Control signal"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  .FaultInjection.Equipment.ConnectorFaults.LeakingEqualPercentageValve
    twoWayVav(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=1000,
    faultMode=faultMode)
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  inner Modelica.Blocks.Noise.GlobalSeed globalSeed
    annotation (Placement(transformation(extent={{-24,-66},{-4,-46}})));
equation
  connect(senTem.port_b,sin. ports[1])
    annotation (Line(points={{40,0},{60,0}}, color={0,127,255}));
  connect(noi.y, senTem.uFau_in) annotation (Line(points={{-39,60},{10,60},{10,8},
          {18,8}}, color={0,0,127}));
  connect(twoWayVav.port_b, senTem.port_a)
    annotation (Line(points={{-10,0},{20,0}}, color={0,127,255}));
  connect(twoWayVav.port_a, sou.ports[1])
    annotation (Line(points={{-30,0},{-60,0}}, color={0,127,255}));
  connect(y.y, twoWayVav.y1)
    annotation (Line(points={{-39,30},{-20,30},{-20,12}}, color={0,0,127}));
  connect(leaFlo.y, twoWayVav.m_flow_leakage) annotation (Line(points={{-59,-30},
          {-46,-30},{-46,6},{-32,6}}, color={0,0,127}));
  annotation (experiment(StopTime=360));
end LeakingEqualPercentageValve;
