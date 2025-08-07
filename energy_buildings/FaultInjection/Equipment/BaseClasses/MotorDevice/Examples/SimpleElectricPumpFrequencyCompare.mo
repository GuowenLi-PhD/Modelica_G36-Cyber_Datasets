within FaultInjection.Equipment.BaseClasses.MotorDevice.Examples;
model SimpleElectricPumpFrequencyCompare
  "Validate the simple electric pump model with various frquency"
  import FaultInjection.Equipment.BaseClasses.MotorDevice;
  import FaultInjection;
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 0.06*1000;
  parameter Modelica.SIunits.Pressure dp_nominal = 25*188.5/(m_flow_nominal/1000);

  MotorDevice.LoadDevice.SpeedControlled_Nrpm pum2(
    redeclare package Medium = Medium,
    per = per)
    annotation (Placement(transformation(extent={{12,-38},{32,-18}})));
  Buildings.Fluid.FixedResistances.PressureDrop res2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{-38,-38},{-18,-18}})));
  Buildings.Fluid.Sources.Boundary_pT bou3(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{-88,-38},{-68,-18}})));
  Buildings.Fluid.Sources.Boundary_pT bou4(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{92,-38},{72,-18}})));
  FaultInjection.Equipment.BaseClasses.MotorDevice.SimpleElectricPump pum1(
      redeclare package Medium = Medium, per=per)
    annotation (Placement(transformation(extent={{10,40},{30,60}})));
  Modelica.Blocks.Sources.Step freUp(
    height=5,
    offset=50,
    startTime=200)
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
  Modelica.Blocks.Sources.Constant Vrms(k=110)
    annotation (Placement(transformation(extent={{-80,4},{-60,24}})));
  Modelica.Blocks.Sources.RealExpression spe(y=2898.32)
    annotation (Placement(transformation(extent={{-78,-70},{-58,-50}})));
  parameter Buildings.Fluid.Movers.Data.Generic per(
    pressure(V_flow=m_flow_nominal/1000*{0,0.41,0.54,0.66,0.77,0.89,1,1.12,1.19},
        dp=dp_nominal*{1.461,1.455,1.407,1.329,1.234,1.126,1.0,0.85,0.731}),
    motorEfficiency(V_flow={0}, eta={1}),
    speed_rpm_nominal=1800)
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{40,84},{60,104}})));
equation
  connect(pum2.port_b, bou4.ports[1])
    annotation (Line(points={{32,-28},{72,-28}}, color={0,127,255}));
  connect(pum2.port_a, res2.port_b)
    annotation (Line(points={{12,-28},{-18,-28}}, color={0,127,255}));
  connect(res2.port_a, bou3.ports[1])
    annotation (Line(points={{-38,-28},{-68,-28}}, color={0,127,255}));
  connect(pum1.port_b,bou2. ports[1])
    annotation (Line(points={{30,50},{70,50}}, color={0,127,255}));
  connect(pum1.port_a,res1. port_b)
    annotation (Line(points={{10,50},{-20,50}}, color={0,127,255}));
  connect(res1.port_a,bou1. ports[1])
    annotation (Line(points={{-40,50},{-70,50}}, color={0,127,255}));
  connect(Vrms.y, pum1.V_rms) annotation (Line(points={{-59,14},{-8,14},{-8,70},
          {20.4,70},{20.4,62}}, color={0,0,127}));
  connect(freUp.y, pum1.f_in)
    annotation (Line(points={{-59,90},{11.2,90},{11.2,62}}, color={0,0,127}));
  connect(spe.y, pum2.Nrpm) annotation (Line(points={{-57,-60},{-8,-60},{-8,-4},
          {22,-4},{22,-16}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=400),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Examples/SimpleElectricPumpFrequencyCompare.mos"
        "Simulate and Plot"));
end SimpleElectricPumpFrequencyCompare;
