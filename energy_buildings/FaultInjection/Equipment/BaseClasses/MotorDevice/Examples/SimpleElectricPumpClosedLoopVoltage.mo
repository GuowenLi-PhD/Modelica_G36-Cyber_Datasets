within FaultInjection.Equipment.BaseClasses.MotorDevice.Examples;
model SimpleElectricPumpClosedLoopVoltage
  "Validate the simple electric pump model with various frquency"
  import FaultInjection.Equipment.BaseClasses.MotorDevice;
  import FaultInjection;
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 0.06*1000;
  parameter Modelica.SIunits.Pressure dp_nominal = 25*188.5/(m_flow_nominal/1000);

  FaultInjection.Equipment.BaseClasses.MotorDevice.SimpleElectricPump pum2(
      redeclare package Medium = Medium, per=per)
    annotation (Placement(transformation(extent={{10,60},{30,80}})));
  Modelica.Blocks.Sources.Constant dpSet2(k=20000)
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Modelica.Blocks.Sources.Step     Vrms2(
    height=10,
    offset=110,
    startTime=1000)
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Fluid.FixedResistances.PressureDrop res2(
    redeclare package Medium = Medium,
    dp_nominal=2000,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Fluid.Sources.Boundary_pT expCol2(redeclare package Medium = Medium,
      nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,118})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex2(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=m_flow_nominal,
    m2_flow_nominal=m_flow_nominal,
    dp1_nominal=5000,
    dp2_nominal=5000)
    annotation (Placement(transformation(extent={{-10,-24},{10,-44}})));

  Buildings.Fluid.Sensors.RelativePressure senRelPre2(redeclare package
      Medium =
        Medium) annotation (Placement(transformation(extent={{20,10},{0,-10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem2(redeclare package
      Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-30,-38},{-50,-18}})));
  Buildings.Fluid.HeatExchangers.SensibleCooler_T coo2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=500) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={66,30})));
  Modelica.Blocks.Sources.Constant temSet(k=273.15 + 7)
    annotation (Placement(transformation(extent={{100,40},{80,60}})));
  Modelica.Blocks.Sources.Step TSou2(
    height=2,
    offset=273.15 + 18,
    startTime=0)
    annotation (Placement(transformation(extent={{-100,-74},{-80,-54}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHot2(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,-60})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=1000,
    use_inputFilter=false)
    annotation (Placement(transformation(extent={{40,-38},{20,-18}})));
  Buildings.Controls.Continuous.LimPID conPID2(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=60,
    reverseAction=true)
    annotation (Placement(transformation(extent={{110,-40},{90,-20}})));
  Modelica.Blocks.Sources.Constant temSetHot2(k=273.15 + 16)
    annotation (Placement(transformation(extent={{160,-40},{140,-20}})));
  Buildings.Fluid.Sources.MassFlowSource_T souHot2(
    redeclare package Medium = Medium,
    m_flow=m_flow_nominal,
    nPorts=1,
    use_T_in=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,-60})));
  Buildings.Fluid.Sources.Boundary_pT sinHot2(redeclare package Medium = Medium,
      nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={92,-80})));
  Buildings.Controls.Continuous.LimPID preCon2(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=60,
    yMax=60,
    y_start=0,
    yMin=20) annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  MotorDevice.LoadDevice.SpeedControlled_Nrpm
                                 pum1(
    redeclare package Medium = Medium,
    per = per,
    use_inputFilter=false)
    annotation (Placement(transformation(extent={{18,-170},{38,-150}})));
  Modelica.Blocks.Sources.Constant
                               dpSet1(k=20000)
    annotation (Placement(transformation(extent={{-112,-200},{-92,-180}})));
  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium,
    dp_nominal=2000,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-32,-170},{-12,-150}})));
  Buildings.Fluid.Sources.Boundary_pT expCol1(redeclare package Medium = Medium,
      nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={8,-112})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex1(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=m_flow_nominal,
    m2_flow_nominal=m_flow_nominal,
    dp1_nominal=5000,
    dp2_nominal=5000)
    annotation (Placement(transformation(extent={{-2,-254},{18,-274}})));
  Buildings.Fluid.Sensors.RelativePressure senRelPre1(redeclare package
      Medium =
        Medium) annotation (Placement(transformation(extent={{28,-220},{8,-240}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem1(redeclare package
      Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-22,-268},{-42,-248}})));
  Buildings.Fluid.HeatExchangers.SensibleCooler_T coo1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=500) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={74,-200})));
  Modelica.Blocks.Sources.Constant temSet1(k=273.15 + 7)
    annotation (Placement(transformation(extent={{108,-190},{88,-170}})));
  Modelica.Blocks.Sources.Step TSou1(
    height=2,
    offset=273.15 + 18,
    startTime=0)
    annotation (Placement(transformation(extent={{-92,-304},{-72,-284}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHot1(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal)
                                               annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={68,-290})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=1000,
    use_inputFilter=false)
    annotation (Placement(transformation(extent={{48,-268},{28,-248}})));
  Buildings.Controls.Continuous.LimPID conPID1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=60,
    reverseAction=true)
    annotation (Placement(transformation(extent={{118,-270},{98,-250}})));
  Modelica.Blocks.Sources.Constant temSetHot1(k=273.15 + 16)
    annotation (Placement(transformation(extent={{168,-270},{148,-250}})));
  Buildings.Fluid.Sources.MassFlowSource_T souHot1(
    redeclare package Medium = Medium,
    m_flow=m_flow_nominal,
    nPorts=1,
    use_T_in=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-42,-290})));
  Buildings.Fluid.Sources.Boundary_pT sinHot1(redeclare package Medium = Medium,
      nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={100,-310})));
  Buildings.Controls.Continuous.LimPID preCon1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=60,
    yMax=3600,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    yMin=0,
    y_start=0)
             annotation (Placement(transformation(extent={{-72,-200},{-52,-180}})));
  parameter Buildings.Fluid.Movers.Data.Generic per(
    pressure(V_flow=m_flow_nominal/1000*{0,0.41,0.54,0.66,0.77,0.89,1,1.12,1.19},
        dp=dp_nominal*{1.461,1.455,1.407,1.329,1.234,1.126,1.0,0.85,0.731}),
    motorEfficiency(V_flow={0}, eta={1}),
    speed_rpm_nominal=1800)
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{138,116},{158,136}})));
equation
  connect(pum2.port_a, res2.port_b)
    annotation (Line(points={{10,70},{-20,70}}, color={0,127,255}));
  connect(expCol2.ports[1], pum2.port_a) annotation (Line(points={{-1.77636e-15,
          108},{-1.77636e-15,70},{10,70}}, color={0,127,255}));
  connect(hex2.port_b2, senTem2.port_a)
    annotation (Line(points={{-10,-28},{-30,-28}}, color={0,127,255}));
  connect(senTem2.port_b, res2.port_a) annotation (Line(points={{-50,-28},{-52,-28},
          {-52,70},{-40,70}}, color={0,127,255}));
  connect(pum2.port_b, coo2.port_a)
    annotation (Line(points={{30,70},{66,70},{66,40}}, color={0,127,255}));
  connect(temSet.y, coo2.TSet)
    annotation (Line(points={{79,50},{58,50},{58,42}}, color={0,0,127}));
  connect(hex2.port_b1, senTemHot2.port_a)
    annotation (Line(points={{10,-40},{60,-40},{60,-50}}, color={0,127,255}));
  connect(coo2.port_b, val2.port_a)
    annotation (Line(points={{66,20},{66,-28},{40,-28}}, color={0,127,255}));
  connect(val2.port_b, hex2.port_a2)
    annotation (Line(points={{20,-28},{10,-28}}, color={0,127,255}));
  connect(senTemHot2.T, conPID2.u_m)
    annotation (Line(points={{71,-60},{100,-60},{100,-42}}, color={0,0,127}));
  connect(temSetHot2.y, conPID2.u_s)
    annotation (Line(points={{139,-30},{112,-30}}, color={0,0,127}));
  connect(conPID2.y, val2.y) annotation (Line(points={{89,-30},{80,-30},{80,-8},
          {30,-8},{30,-16}}, color={0,0,127}));
  connect(senTemHot2.port_b, sinHot2.ports[1])
    annotation (Line(points={{60,-70},{60,-80},{82,-80}}, color={0,127,255}));
  connect(souHot2.ports[1], hex2.port_a1) annotation (Line(points={{-40,-60},{-20,
          -60},{-20,-40},{-10,-40}}, color={0,127,255}));
  connect(TSou2.y, souHot2.T_in)
    annotation (Line(points={{-79,-64},{-62,-64}}, color={0,0,127}));
  connect(dpSet2.y, preCon2.u_s)
    annotation (Line(points={{-99,40},{-82,40}}, color={0,0,127}));
  connect(senRelPre2.p_rel, preCon2.u_m) annotation (Line(points={{10,9},{10,14},
          {-70,14},{-70,28}}, color={0,0,127}));
  connect(senRelPre2.port_b, hex2.port_b2) annotation (Line(points={{0,0},{-20,0},
          {-20,-28},{-10,-28}}, color={0,127,255}));
  connect(senRelPre2.port_a, val2.port_a) annotation (Line(points={{20,0},{50,0},
          {50,-28},{40,-28}}, color={0,127,255}));
  connect(Vrms2.y, pum2.V_rms) annotation (Line(points={{-79,90},{20,90},{20,82},
          {20.4,82}}, color={0,0,127}));
  connect(preCon2.y, pum2.f_in) annotation (Line(points={{-59,40},{-6,40},{-6,88},
          {12,88},{12,82},{11.2,82}}, color={0,0,127}));
  connect(pum1.port_a, res1.port_b)
    annotation (Line(points={{18,-160},{-12,-160}}, color={0,127,255}));
  connect(expCol1.ports[1], pum1.port_a)
    annotation (Line(points={{8,-122},{8,-160},{18,-160}}, color={0,127,255}));
  connect(hex1.port_b2, senTem1.port_a)
    annotation (Line(points={{-2,-258},{-22,-258}}, color={0,127,255}));
  connect(senTem1.port_b, res1.port_a) annotation (Line(points={{-42,-258},{-44,
          -258},{-44,-160},{-32,-160}}, color={0,127,255}));
  connect(pum1.port_b, coo1.port_a) annotation (Line(points={{38,-160},{74,-160},
          {74,-190}}, color={0,127,255}));
  connect(temSet1.y, coo1.TSet)
    annotation (Line(points={{87,-180},{66,-180},{66,-188}}, color={0,0,127}));
  connect(hex1.port_b1, senTemHot1.port_a) annotation (Line(points={{18,-270},{68,
          -270},{68,-280}}, color={0,127,255}));
  connect(coo1.port_b, val1.port_a) annotation (Line(points={{74,-210},{74,-258},
          {48,-258}}, color={0,127,255}));
  connect(val1.port_b, hex1.port_a2)
    annotation (Line(points={{28,-258},{18,-258}}, color={0,127,255}));
  connect(senTemHot1.T, conPID1.u_m) annotation (Line(points={{79,-290},{108,-290},
          {108,-272}}, color={0,0,127}));
  connect(temSetHot1.y, conPID1.u_s)
    annotation (Line(points={{147,-260},{120,-260}}, color={0,0,127}));
  connect(conPID1.y, val1.y) annotation (Line(points={{97,-260},{88,-260},{88,-238},
          {38,-238},{38,-246}}, color={0,0,127}));
  connect(senTemHot1.port_b, sinHot1.ports[1]) annotation (Line(points={{68,-300},
          {68,-310},{90,-310}}, color={0,127,255}));
  connect(souHot1.ports[1], hex1.port_a1) annotation (Line(points={{-32,-290},{-12,
          -290},{-12,-270},{-2,-270}}, color={0,127,255}));
  connect(TSou1.y, souHot1.T_in)
    annotation (Line(points={{-71,-294},{-54,-294}}, color={0,0,127}));
  connect(dpSet1.y, preCon1.u_s)
    annotation (Line(points={{-91,-190},{-74,-190}}, color={0,0,127}));
  connect(senRelPre1.p_rel, preCon1.u_m) annotation (Line(points={{18,-221},{18,
          -216},{-62,-216},{-62,-202}}, color={0,0,127}));
  connect(senRelPre1.port_b, hex1.port_b2) annotation (Line(points={{8,-230},{-12,
          -230},{-12,-258},{-2,-258}}, color={0,127,255}));
  connect(senRelPre1.port_a, val1.port_a) annotation (Line(points={{28,-230},{58,
          -230},{58,-258},{48,-258}}, color={0,127,255}));
  connect(preCon1.y, pum1.Nrpm) annotation (Line(points={{-51,-190},{0,-190},{0,
          -140},{28,-140},{28,-148}}, color={0,0,127}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-340},{180,140}}),
        graphics={
        Rectangle(extent={{-140,140},{180,-90}}, lineColor={0,0,0}),
        Text(
          extent={{74,112},{160,92}},
          lineColor={0,0,0},
          textString="Proposed Pump"),
        Rectangle(extent={{-140,-98},{180,-340}}, lineColor={0,0,0}),
        Text(
          extent={{80,-110},{166,-130}},
          lineColor={0,0,0},
          textString="Conventional Pump")}),
    experiment(StopTime=1000),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Examples/SimpleElectricPumpClosedLoop.mos"
        "Simulate and Plot"));
end SimpleElectricPumpClosedLoopVoltage;
