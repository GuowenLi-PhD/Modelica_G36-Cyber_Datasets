within FaultInjection.Equipment.BaseClasses.MotorDevice.Examples;
model SimpleElectricPump
  import FaultInjection;

  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 0.06*1000;
  parameter Modelica.SIunits.Pressure dp_nominal = 21*188.5/(m_flow_nominal/1000);

  parameter Modelica.SIunits.Resistance R_s=0.641 "Electric resistance of stator";
  parameter Modelica.SIunits.Resistance R_r=0.332 "Electric resistance of rotor";
  parameter Modelica.SIunits.Reactance X_s=1.106 "Complex component of the impedance of stator";
  parameter Modelica.SIunits.Reactance X_r=0.464 "Complex component of the impedance of rotor";
  parameter Modelica.SIunits.Reactance X_m=26.3 "Complex component of the magnetizing reactance";

  parameter Buildings.Fluid.Movers.Data.Generic per(
      motorEfficiency(V_flow={0}, eta={1}),
    speed_rpm_nominal=1800,
    pressure(V_flow=m_flow_nominal/1000*{0,0.41,0.54,0.66,0.77,0.89,1,1.12,1.19},
        dp=dp_nominal*{1.461,1.455,1.407,1.329,1.234,1.126,1.0,0.85,0.731}))
                            "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{40,80},{60,100}})));

  FaultInjection.Equipment.BaseClasses.MotorDevice.SimpleElectricPump pum1(
    redeclare package Medium = Medium,
    per=per,
    R_s=R_s,
    R_r=R_r,
    X_s=X_s,
    X_r=X_r,
    X_m=X_m)
    annotation (Placement(transformation(extent={{10,40},{30,60}})));
  Modelica.Blocks.Sources.Step VrmsUp(
    startTime=400,
    height=10,
    offset=100)
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Sources.Step VrmsDow(
    startTime=400,
    height=-12,
    offset=120)
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  FaultInjection.Equipment.BaseClasses.MotorDevice.SimpleElectricPump pum2(
    redeclare package Medium = Medium,
    per=per,
    R_s=R_s,
    R_r=R_r,
    X_s=X_s,
    X_r=X_r,
    X_m=X_m)
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
  Modelica.Blocks.Sources.Constant f(k=60)
    annotation (Placement(transformation(extent={{-80,-2},{-60,18}})));
  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1.2*dp_nominal)
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
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1.2*dp_nominal)
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Fluid.Sources.Boundary_pT bou3(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{-92,-50},{-72,-30}})));
equation
  connect(VrmsUp.y, pum1.V_rms) annotation (Line(points={{-59,90},{0,90},{0,62},
          {20.4,62}},    color={0,0,127}));
  connect(VrmsDow.y, pum2.V_rms) annotation (Line(points={{-59,-90},{0,-90},{0,
          -28},{20.4,-28}},    color={0,0,127}));
  connect(f.y, pum1.f_in) annotation (Line(points={{-59,8},{-12,8},{-12,62},{
          11.2,62}},
        color={0,0,127}));
  connect(f.y, pum2.f_in) annotation (Line(points={{-59,8},{-12,8},{-12,-28},{
          11.2,-28}},
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
    experiment(StopTime=800),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Examples/SimpleElectricPump.mos"
        "Simulate and Plot"));
end SimpleElectricPump;
