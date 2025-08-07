within FaultInjection.Equipment.BaseClasses.MotorDevice.Examples;
model ZIPPump "Example that illustrates the use of ZIPPump model"
  import FaultInjection.Equipment.BaseClasses.MotorDevice;
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;
  parameter Modelica.SIunits.Torque tauMot = 0.05
    "Constant torque (if negative, torque is acting as load in positive direction of rotation)";
  parameter Modelica.SIunits.Inertia JLoad = 0.01 "Moment of inertia";

  MotorDevice.ZIPPump                           pum1(
    JLoad=0.03,
    redeclare package Medium = Medium,
    redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to4 per(
        use_powerCharacteristic=false, motorEfficiency(eta={1}, V_flow={0})),
    P_nominal=26.4647,
    Q_nominal=13.5)
                annotation (Placement(transformation(extent={{10,40},{30,60}})));
  Modelica.Blocks.Sources.Step VrmsUp(
    offset=110,
    height=11,
    startTime=1200)
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Sources.Step VrmsDow(
    offset=110,
    height=-11,
    startTime=1200)
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  MotorDevice.ZIPPump                           pum2(
    JLoad=0.03,
    redeclare package Medium = Medium,
    redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to4 per(
        use_powerCharacteristic=false, motorEfficiency(V_flow={0}, eta={1})),
    P_nominal=26.4647,
    Q_nominal=13.5)
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
  Modelica.Blocks.Sources.Constant f(k=50)
    annotation (Placement(transformation(extent={{-80,-2},{-60,18}})));
  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium,
    m_flow_nominal=1.2,
    dp_nominal=2000)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Fluid.Sources.Boundary_pT bou1(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
  Buildings.Fluid.Sources.Boundary_pT bou2(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{90,40},{70,60}})));
  Buildings.Fluid.Sources.Boundary_pT bou4(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{90,-50},{70,-30}})));
  Buildings.Fluid.FixedResistances.PressureDrop res2(
    redeclare package Medium = Medium,
    m_flow_nominal=1.2,
    dp_nominal=2000)
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Fluid.Sources.Boundary_pT bou3(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{-92,-50},{-72,-30}})));
equation
  connect(VrmsUp.y, pum1.V_rms) annotation (Line(points={{-59,90},{0,90},{0,62},
          {20,62}},      color={0,0,127}));
  connect(VrmsDow.y, pum2.V_rms) annotation (Line(points={{-59,-90},{0,-90},{0,
          -28},{20,-28}},      color={0,0,127}));
  connect(f.y, pum1.f_in) annotation (Line(points={{-59,8},{-12,8},{-12,62},{11,
          62}},
        color={0,0,127}));
  connect(f.y, pum2.f_in) annotation (Line(points={{-59,8},{-12,8},{-12,-28},{
          11,-28}},
                 color={0,0,127}));
  connect(res2.port_b, pum2.port_a)
    annotation (Line(points={{-20,-40},{10,-40}}, color={0,127,255}));
  connect(bou3.ports[1], res2.port_a)
    annotation (Line(points={{-72,-40},{-40,-40}}, color={0,127,255}));
  connect(pum2.port_b, bou4.ports[1])
    annotation (Line(points={{30,-40},{70,-40}}, color={0,127,255}));
  connect(pum1.port_b, bou2.ports[1])
    annotation (Line(points={{30,50},{70,50}}, color={0,127,255}));
  connect(pum1.port_a, res1.port_b)
    annotation (Line(points={{10,50},{-20,50}}, color={0,127,255}));
  connect(res1.port_a, bou1.ports[1])
    annotation (Line(points={{-40,50},{-70,50}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=2400),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Examples/ZIPPump.mos"
        "Simulate and Plot"));
end ZIPPump;
