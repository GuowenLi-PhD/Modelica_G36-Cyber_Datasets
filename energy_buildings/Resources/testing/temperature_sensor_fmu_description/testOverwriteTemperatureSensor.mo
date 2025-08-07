within ;
model testOverwriteTemperatureSensor
  package Medium = Buildings.Media.Water;

  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWRet(redeclare replaceable
      package Medium = Medium, m_flow_nominal=5)
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  FaultInjection.Utilities.Overwrite.OverwriteVariable oveTCHWRet(
    description="Chilled water return temperature",
      u(
      unit="K",
      min=273.15 + 0.5,
      max=273.15 + 60)) "Overwrite chilled water return temperature"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101325 + 10000,
    T=303.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101325,
    nPorts=1) annotation (Placement(transformation(extent={{80,10},{60,-10}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=5,
    dp_nominal=10000)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Fluid.Sensors.Temperature TCHWRet2(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{0,0},{20,20}})));
  FaultInjection.Utilities.Overwrite.OverwriteVariable oveTCHWRet2(description=
        "Chilled water return temperature", u(
      unit="K",
      min=273.15 + 0.5,
      max=273.15 + 60)) "Overwrite chilled water return temperature"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  FaultInjection.Utilities.Overwrite.OverwriteVariable oveTCHWRet3(description=
        "Chilled water return temperature", u(
      unit="K",
      min=273.15 + 0.5,
      max=273.15 + 60)) "Overwrite chilled water return temperature"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort TCHWRet3(redeclare package Medium
      = Medium)
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
equation
  connect(TCHWRet.T, oveTCHWRet.u)
    annotation (Line(points={{30,11},{30,30},{38,30}}, color={0,0,127}));
  connect(TCHWRet.port_b, sin.ports[1])
    annotation (Line(points={{40,0},{60,0}}, color={0,127,255}));
  connect(res.port_a, bou.ports[1])
    annotation (Line(points={{-50,0},{-60,0}}, color={0,127,255}));
  connect(TCHWRet.port_a, TCHWRet2.port)
    annotation (Line(points={{20,0},{10,0}}, color={0,127,255}));
  connect(TCHWRet2.T, oveTCHWRet2.u) annotation (Line(points={{17,10},{20,10},{
          20,60},{38,60}}, color={0,0,127}));
  connect(res.port_b, TCHWRet3.port_a)
    annotation (Line(points={{-30,0},{-20,0}}, color={0,127,255}));
  connect(TCHWRet3.port_b, TCHWRet2.port)
    annotation (Line(points={{0,0},{10,0}}, color={0,127,255}));
  connect(TCHWRet3.T, oveTCHWRet3.u) annotation (Line(points={{-10,11},{-10,16},
          {4,16},{4,-50},{38,-50}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    uses(Buildings(version="7.0.0"), FaultInjection(version="1.0.0"),
      Modelica(version="3.2.3")),
    experiment(StopTime=3600, __Dymola_Algorithm="Dassl"));
end testOverwriteTemperatureSensor;
