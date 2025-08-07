within FaultInjection.Equipment.BaseClasses.MotorDevice.CaseStudy;
model ComparePumpVoltageOpen
  "Compare the difference of three pump model with step changing frquency in an open loop"
  import FaultInjection;
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 0.06*1000;
  parameter Modelica.SIunits.Pressure dp_nominal = 21*188.5/(m_flow_nominal/1000);
  parameter Modelica.SIunits.Frequency f_nominal=60;
  parameter Integer pole=4 "Number of pole pairs";
  parameter Integer n=3 "Number of phases";
  parameter Modelica.SIunits.Inertia JLoad=5 "Moment of inertia";
  parameter Modelica.SIunits.Inertia JMotor=5 "Moment of inertia";

  // proposed pump

  parameter Modelica.SIunits.Resistance R_s=0.641 "Electric resistance of stator";
  parameter Modelica.SIunits.Resistance R_r=0.332 "Electric resistance of rotor";
  parameter Modelica.SIunits.Reactance X_s=1.106 "Complex component of the impedance of stator";
  parameter Modelica.SIunits.Reactance X_r=0.464 "Complex component of the impedance of rotor";
  parameter Modelica.SIunits.Reactance X_m=26.3 "Complex component of the magnetizing reactance";

  //# ZIP
  parameter Real az=-0.15696595
    "Fraction of constant impededance load in active power";
  parameter Real ai=0.36114628 "Fraction of constant current load in active power";
  parameter Real ap=0.79582107 "Fraction of constant power load in active power";
  parameter Real rz=2.86326969
    "Fraction of constant impededance load in reactive power";
  parameter Real ri=-5.57652942 "Fraction of constant current load in reactive power";
  parameter Real rp=3.71325969 "Fraction of constant power load in reactive power";
  parameter Real af=0.0417 "Dependency on frequence";
  parameter Real rf=0.03 "Dependency on frequence";

  parameter Modelica.SIunits.Power P_nominal=5642.85;
  parameter Modelica.SIunits.ReactivePower Q_nominal=2569.21;

  parameter Buildings.Fluid.Movers.Data.Generic per3(
    pressure(V_flow=m_flow_nominal/1000*{0,0.41,0.54,0.66,0.77,0.89,1,1.12,1.19},
        dp=dp_nominal*{1.461,1.455,1.407,1.329,1.234,1.126,1.0,0.85,0.731}),
    speed_rpm_nominal=1800,
    motorEfficiency(V_flow={0.04847,0.0567}, eta={0.74,0.83}))
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{-100,-98},{-80,-78}})));
  MotorDevice.ZIPPump pum2(
    redeclare package Medium = Medium,
    per=per,
    f_nominal=f_nominal,
    pole=pole,
    n=n,
    JMotor=JMotor,
    JLoad=JLoad,
    az=az,
    ai=ai,
    ap=ap,
    rz=rz,
    ri=ri,
    rp=rp,
    af=af,
    rf=rf,
    P_nominal=P_nominal,
    Q_nominal=Q_nominal)
    annotation (Placement(transformation(extent={{12,-10},{32,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop res2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou3(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou4(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{92,-10},{72,10}})));
  FaultInjection.Equipment.BaseClasses.MotorDevice.SimpleElectricPump pum1(
    redeclare package Medium = Medium,
    per=per,
    f_base=f_nominal,
    pole=pole,
    n=n,
    JMotor=JMotor,
    JLoad=JLoad,
    R_s=R_s,
    R_r=R_r,
    X_s=X_s,
    X_r=X_r,
    X_m=X_m) annotation (Placement(transformation(extent={{8,40},{28,60}})));
  Modelica.Blocks.Sources.Constant
                               freUp(k=60)
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Fluid.Sources.Boundary_pT bou1(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
  Buildings.Fluid.Sources.Boundary_pT bou2(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{90,40},{70,60}})));
  Modelica.Blocks.Sources.Step     Vrms(
    height=-12,
    offset=120,
    startTime=100)
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  parameter Buildings.Fluid.Movers.Data.Generic per(
    pressure(V_flow=m_flow_nominal/1000*{0,0.41,0.54,0.66,0.77,0.89,1,1.12,1.19},
        dp=dp_nominal*{1.461,1.455,1.407,1.329,1.234,1.126,1.0,0.85,0.731}),
    motorEfficiency(V_flow={0}, eta={1}),
    speed_rpm_nominal=1800)
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{40,84},{60,104}})));
  MotorDevice.LoadDevice.SpeedControlled_Nrpm pum3(
    redeclare package Medium = Medium,
    per=per3,
    riseTime=45)
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));
  Buildings.Fluid.FixedResistances.PressureDrop res3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Fluid.Sources.Boundary_pT bou5(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Buildings.Fluid.Sources.Boundary_pT bou6(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{90,-70},{70,-50}})));
  Modelica.Blocks.Sources.RealExpression spe(y=1716)
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

equation
  connect(pum2.port_b, bou4.ports[1])
    annotation (Line(points={{32,0},{72,0}},     color={0,127,255}));
  connect(pum2.port_a, res2.port_b)
    annotation (Line(points={{12,0},{-20,0}},     color={0,127,255}));
  connect(res2.port_a, bou3.ports[1])
    annotation (Line(points={{-40,0},{-68,0}},     color={0,127,255}));
  connect(pum1.port_b,bou2. ports[1])
    annotation (Line(points={{28,50},{70,50}}, color={0,127,255}));
  connect(pum1.port_a,res1. port_b)
    annotation (Line(points={{8,50},{-20,50}},  color={0,127,255}));
  connect(res1.port_a,bou1. ports[1])
    annotation (Line(points={{-40,50},{-70,50}}, color={0,127,255}));
  connect(Vrms.y, pum1.V_rms) annotation (Line(points={{-19,70},{18.4,70},{18.4,
          62}},                 color={0,0,127}));
  connect(freUp.y, pum1.f_in)
    annotation (Line(points={{-59,90},{9.2,90},{9.2,62}},   color={0,0,127}));
  connect(pum3.port_b,bou6. ports[1])
    annotation (Line(points={{30,-60},{70,-60}}, color={0,127,255}));
  connect(pum3.port_a,res3. port_b)
    annotation (Line(points={{10,-60},{-20,-60}}, color={0,127,255}));
  connect(res3.port_a,bou5. ports[1])
    annotation (Line(points={{-40,-60},{-70,-60}}, color={0,127,255}));
  connect(spe.y, pum3.Nrpm)
    annotation (Line(points={{-39,-40},{20,-40},{20,-48}}, color={0,0,127}));
  connect(Vrms.y, pum2.V_rms) annotation (Line(points={{-19,70},{0,70},{0,22},{22,
          22},{22,12}}, color={0,0,127}));
  connect(freUp.y, pum2.f_in) annotation (Line(points={{-59,90},{-2,90},{-2,20},
          {13,20},{13,12}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=200),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Examples/SimpleElectricPumpFrequencyCompare.mos"
        "Simulate and Plot"));
end ComparePumpVoltageOpen;
