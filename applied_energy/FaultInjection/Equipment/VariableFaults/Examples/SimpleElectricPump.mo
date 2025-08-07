within FaultInjection.Equipment.VariableFaults.Examples;
model SimpleElectricPump
  "Validate the simple electric pump model with various frquency"
  import FaultInjection.Equipment.BaseClasses.MotorDevice;
  import FaultInjection;
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 0.06*1000;
  parameter Modelica.SIunits.Pressure dp_nominal = 25*188.5/(m_flow_nominal/1000);
  parameter Modelica.SIunits.Inertia JLoad=5 "Moment of inertia";
  parameter Modelica.SIunits.Inertia JMotor=10 "Moment of inertia";

  //# ZIP
  parameter Real az=0.01175425
    "Fraction of constant impededance load in active power";
  parameter Real ai=0.00274616 "Fraction of constant current load in active power";
  parameter Real ap=0.9854996 "Fraction of constant power load in active power";
  parameter Real rz=1.05148009
    "Fraction of constant impededance load in reactive power";
  parameter Real ri=-0.16540235 "Fraction of constant current load in reactive power";
  parameter Real rp=0.11392224 "Fraction of constant power load in reactive power";
  FaultInjection.Equipment.BaseClasses.MotorDevice.SimpleElectricPump pum1(
    redeclare package Medium = Medium,
    per=per,
    JMotor=JMotor,
    JLoad=JLoad,
    pole=pole) annotation (Placement(transformation(extent={{10,60},{30,80}})));
  Modelica.Blocks.Sources.Constant dpSet1(k=20000)
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1/2*dp_nominal - 12000)
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Fluid.Sources.Boundary_pT expCol1(redeclare package Medium = Medium,
      nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,118})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex1(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=m_flow_nominal,
    m2_flow_nominal=m_flow_nominal,
    dp1_nominal=5000,
    dp2_nominal=1/4*dp_nominal)
    annotation (Placement(transformation(extent={{-10,-24},{10,-44}})));

  Buildings.Fluid.Sensors.RelativePressure senRelPre1(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{20,10},{0,-10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem1(redeclare package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-30,-38},{-50,-18}})));
  Buildings.Fluid.HeatExchangers.SensibleCooler_T coo2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1/4*dp_nominal)
                    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={66,30})));
  Modelica.Blocks.Sources.Constant temSet1(k=273.15 + 7)
    annotation (Placement(transformation(extent={{100,40},{80,60}})));
  Modelica.Blocks.Sources.Step TSou1(
    startTime=1000,
    height=4,
    offset=273.15 + 24)
    annotation (Placement(transformation(extent={{-136,-74},{-116,-54}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHot1(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,-60})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    use_inputFilter=false,
    dpValve_nominal=6000)
    annotation (Placement(transformation(extent={{40,-38},{20,-18}})));
  Buildings.Controls.Continuous.LimPID conPID1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=60,
    reverseAction=true,
    yMin=0.1)
    annotation (Placement(transformation(extent={{110,-40},{90,-20}})));
  Modelica.Blocks.Sources.Constant temSetHot1(k=273.15 + 16)
    annotation (Placement(transformation(extent={{160,-40},{140,-20}})));
  Buildings.Fluid.Sources.MassFlowSource_T souHot1(
    redeclare package Medium = Medium,
    m_flow=m_flow_nominal,
    nPorts=1,
    use_T_in=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,-60})));
  Buildings.Fluid.Sources.Boundary_pT sinHot1(redeclare package Medium = Medium,
      nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={92,-80})));
  Buildings.Controls.Continuous.LimPID preCon1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMax=60,
    yMin=20,
    Ti=30,
    k=0.05)  annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  parameter Buildings.Fluid.Movers.Data.Generic per(
    pressure(V_flow=m_flow_nominal/1000*{0,0.41,0.54,0.66,0.77,0.89,1,1.12,1.19},
        dp=dp_nominal*{1.461,1.455,1.407,1.329,1.234,1.126,1.0,0.85,0.731}),
    motorEfficiency(V_flow={0}, eta={1}),
    speed_rpm_nominal=1800)
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{138,116},{158,136}})));
  parameter Integer pole=4 "Number of pole pairs";
  FaultInjection.Utilities.FaultEvolution.Trapezoid trapezoid(faultMode=
        faultMode)
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
 parameter FaultInjection.Utilities.InsertionTypes.Generic.faultMode
                             faultMode(startTime=1700, endTime=1800)
    annotation (Placement(transformation(extent={{100,116},{120,136}})));
equation
  connect(pum1.port_a,res1. port_b)
    annotation (Line(points={{10,70},{-20,70}}, color={0,127,255}));
  connect(expCol1.ports[1],pum1. port_a) annotation (Line(points={{-1.77636e-15,
          108},{-1.77636e-15,70},{10,70}}, color={0,127,255}));
  connect(hex1.port_b2,senTem1. port_a)
    annotation (Line(points={{-10,-28},{-30,-28}}, color={0,127,255}));
  connect(senTem1.port_b,res1. port_a) annotation (Line(points={{-50,-28},{-52,-28},
          {-52,70},{-40,70}}, color={0,127,255}));
  connect(pum1.port_b, coo2.port_a)
    annotation (Line(points={{30,70},{66,70},{66,40}}, color={0,127,255}));
  connect(temSet1.y, coo2.TSet)
    annotation (Line(points={{79,50},{58,50},{58,42}}, color={0,0,127}));
  connect(hex1.port_b1,senTemHot1. port_a)
    annotation (Line(points={{10,-40},{60,-40},{60,-50}}, color={0,127,255}));
  connect(coo2.port_b,val1. port_a)
    annotation (Line(points={{66,20},{66,-28},{40,-28}}, color={0,127,255}));
  connect(val1.port_b,hex1. port_a2)
    annotation (Line(points={{20,-28},{10,-28}}, color={0,127,255}));
  connect(senTemHot1.T,conPID1. u_m)
    annotation (Line(points={{71,-60},{100,-60},{100,-42}}, color={0,0,127}));
  connect(temSetHot1.y,conPID1. u_s)
    annotation (Line(points={{139,-30},{112,-30}}, color={0,0,127}));
  connect(conPID1.y,val1. y) annotation (Line(points={{89,-30},{80,-30},{80,-8},
          {30,-8},{30,-16}}, color={0,0,127}));
  connect(senTemHot1.port_b,sinHot1. ports[1])
    annotation (Line(points={{60,-70},{60,-80},{82,-80}}, color={0,127,255}));
  connect(souHot1.ports[1],hex1. port_a1) annotation (Line(points={{-40,-60},{-20,
          -60},{-20,-40},{-10,-40}}, color={0,127,255}));
  connect(TSou1.y,souHot1. T_in)
    annotation (Line(points={{-115,-64},{-62,-64}},color={0,0,127}));
  connect(dpSet1.y,preCon1. u_s)
    annotation (Line(points={{-99,40},{-82,40}}, color={0,0,127}));
  connect(senRelPre1.p_rel,preCon1. u_m) annotation (Line(points={{10,9},{10,14},
          {-70,14},{-70,28}}, color={0,0,127}));
  connect(senRelPre1.port_b,hex1. port_b2) annotation (Line(points={{0,0},{-20,0},
          {-20,-28},{-10,-28}}, color={0,127,255}));
  connect(senRelPre1.port_a,val1. port_a) annotation (Line(points={{20,0},{50,0},
          {50,-28},{40,-28}}, color={0,127,255}));
  connect(preCon1.y,pum1. f_in) annotation (Line(points={{-59,40},{-6,40},{-6,88},
          {12,88},{12,82},{11.2,82}}, color={0,0,127}));
  connect(trapezoid.y, pum1.V_rms) annotation (Line(points={{-79,90},{20.4,
          90},{20.4,82}}, color={0,0,127}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{
            180,140}})),
    experiment(StopTime=2000),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Examples/SimpleElectricPumpClosedLoop.mos"
        "Simulate and Plot"));
end SimpleElectricPump;
