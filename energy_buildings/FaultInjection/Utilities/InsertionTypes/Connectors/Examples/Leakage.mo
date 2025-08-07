within FaultInjection.Utilities.InsertionTypes.Connectors.Examples;
model Leakage "Test leakage"
  extends Modelica.Icons.Example;
    package Medium = Buildings.Media.Water;
  FaultInjection.Utilities.InsertionTypes.Connectors.Leakage lea(redeclare
      package Medium = Medium, faultMode=faultMode)
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    m_flow=1,
    T=295.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(redeclare package Medium = Medium,
      nPorts=1)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Equipment.VariableFaults.FaultTemperatureSensor senTem(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    faultMode=faultMode)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.Constant leaFlo(k=-0.4) "Leakage flow"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
 parameter Generic.faultMode faultMode(startTime=100, endTime=200)
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
equation
  connect(sou.ports[1],res. port_a)
    annotation (Line(points={{-60,0},{-20,0}}, color={0,127,255}));
  connect(res.port_b,senTem. port_a)
    annotation (Line(points={{0,0},{20,0}}, color={0,127,255}));
  connect(senTem.port_b,sin. ports[1])
    annotation (Line(points={{40,0},{60,0}}, color={0,127,255}));
  connect(lea.port, res.port_b)
    annotation (Line(points={{0,30},{10,30},{10,0},{0,0}}, color={0,127,255}));
  connect(leaFlo.y, lea.m_flow_leakage) annotation (Line(points={{-59,50},{-42,50},
          {-42,30},{-22,30}}, color={0,0,127}));
  annotation (experiment(StopTime=300));
end Leakage;
