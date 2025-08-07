within FaultInjection.Equipment.BaseClasses.MotorDevice.CaseStudy;
model MaxPowerFrequency
  "Case study on the relationship between the maximum power and frequency for motorized model"
  import FaultInjection;
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 10;
  parameter Modelica.SIunits.Pressure dp_nominal = 200000;

  FaultInjection.Equipment.BaseClasses.MotorDevice.SimpleElectricPump pum1(
      redeclare package Medium = Medium, per=per)
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Modelica.Blocks.Sources.Step freUp(
    offset=0,
    startTime=10,
    height=60)
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou1(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou2(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));
  Modelica.Blocks.Sources.Constant Vrms(k=110)
    annotation (Placement(transformation(extent={{-80,-46},{-60,-26}})));
  parameter Buildings.Fluid.Movers.Data.Generic per(
    pressure(V_flow=m_flow_nominal/1000*{0,0.41,0.54,0.66,0.77,0.89,1,1.12,1.19},
        dp=dp_nominal*{1.461,1.455,1.407,1.329,1.234,1.126,1.0,0.85,0.731}),
    motorEfficiency(V_flow={0}, eta={1}),
    speed_rpm_nominal=1800)
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{40,34},{60,54}})));
equation
  connect(pum1.port_b,bou2. ports[1])
    annotation (Line(points={{30,0},{70,0}},   color={0,127,255}));
  connect(pum1.port_a,res1. port_b)
    annotation (Line(points={{10,0},{-20,0}},   color={0,127,255}));
  connect(res1.port_a,bou1. ports[1])
    annotation (Line(points={{-40,0},{-70,0}},   color={0,127,255}));
  connect(Vrms.y, pum1.V_rms) annotation (Line(points={{-59,-36},{-8,-36},{-8,
          20},{20.4,20},{20.4,12}},
                                color={0,0,127}));
  connect(freUp.y, pum1.f_in)
    annotation (Line(points={{-59,40},{11.2,40},{11.2,12}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=50),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/CaseStudy/MaxPowerFrequency.mos"
        "Simulate and Plot"));
end MaxPowerFrequency;
