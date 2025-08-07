within FaultInjection.Equipment.BaseClasses.MotorDevice.Examples;
model SimpleElectricPumpClosedLoop
  "Validate the simple electric pump model with various frquency"
  import FaultInjection.Equipment.BaseClasses.MotorDevice;
  import FaultInjection;
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 0.06*1000;
  parameter Modelica.SIunits.Pressure dp_nominal = 25*188.5/(m_flow_nominal/1000);

  FaultInjection.Equipment.BaseClasses.MotorDevice.SimpleElectricPump pum1(
      redeclare package Medium = Medium, per=per)
    annotation (Placement(transformation(extent={{10,60},{30,80}})));
  Modelica.Blocks.Sources.Constant dpSet1(k=20000)
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Modelica.Blocks.Sources.Constant Vrms1(k=110)
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium,
    dp_nominal=2000,
    m_flow_nominal=m_flow_nominal)
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
    dp2_nominal=5000)
    annotation (Placement(transformation(extent={{-10,-24},{10,-44}})));

  Buildings.Fluid.Sensors.RelativePressure senRelPre1(redeclare package
      Medium =
        Medium) annotation (Placement(transformation(extent={{20,10},{0,-10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem1(redeclare package
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
  Modelica.Blocks.Sources.Constant temSet1(k=273.15 + 7)
    annotation (Placement(transformation(extent={{100,40},{80,60}})));
  Modelica.Blocks.Sources.Step TSou1(
    height=2,
    offset=273.15 + 18,
    startTime=1000)
    annotation (Placement(transformation(extent={{-100,-74},{-80,-54}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHot1(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,-60})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=1000,
    use_inputFilter=false)
    annotation (Placement(transformation(extent={{40,-38},{20,-18}})));
  Buildings.Controls.Continuous.LimPID conPID1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=60,
    reverseAction=true)
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
    Ti=60,
    yMax=60,
    yMin=20) annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  MotorDevice.LoadDevice.SpeedControlled_Nrpm pum3(
    redeclare package Medium = Medium,
    per=per,
    use_inputFilter=false)
    annotation (Placement(transformation(extent={{18,-412},{38,-392}})));
  Modelica.Blocks.Sources.Constant
                               dpSet3(k=20000)
    annotation (Placement(transformation(extent={{-112,-442},{-92,-422}})));
  Buildings.Fluid.FixedResistances.PressureDrop res3(
    redeclare package Medium = Medium,
    dp_nominal=2000,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-32,-412},{-12,-392}})));
  Buildings.Fluid.Sources.Boundary_pT expCol3(redeclare package Medium = Medium,
      nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={8,-354})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex3(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=m_flow_nominal,
    m2_flow_nominal=m_flow_nominal,
    dp1_nominal=5000,
    dp2_nominal=5000)
    annotation (Placement(transformation(extent={{-2,-496},{18,-516}})));
  Buildings.Fluid.Sensors.RelativePressure senRelPre3(redeclare package
      Medium =
        Medium) annotation (Placement(transformation(extent={{28,-462},{8,-482}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem3(redeclare package
      Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-22,-510},{-42,-490}})));
  Buildings.Fluid.HeatExchangers.SensibleCooler_T coo3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=500) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={74,-442})));
  Modelica.Blocks.Sources.Constant temSet3(k=273.15 + 7)
    annotation (Placement(transformation(extent={{108,-432},{88,-412}})));
  Modelica.Blocks.Sources.Step TSou3(
    height=2,
    offset=273.15 + 18,
    startTime=1000)
    annotation (Placement(transformation(extent={{-92,-546},{-72,-526}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHot3(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal)
                                               annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={68,-532})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=1000,
    use_inputFilter=false)
    annotation (Placement(transformation(extent={{48,-510},{28,-490}})));
  Buildings.Controls.Continuous.LimPID conPID3(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=60,
    reverseAction=true)
    annotation (Placement(transformation(extent={{118,-512},{98,-492}})));
  Modelica.Blocks.Sources.Constant temSetHot3(k=273.15 + 16)
    annotation (Placement(transformation(extent={{168,-512},{148,-492}})));
  Buildings.Fluid.Sources.MassFlowSource_T souHot3(
    redeclare package Medium = Medium,
    m_flow=m_flow_nominal,
    nPorts=1,
    use_T_in=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-42,-532})));
  Buildings.Fluid.Sources.Boundary_pT sinHot3(redeclare package Medium = Medium,
      nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={100,-552})));
  Buildings.Controls.Continuous.LimPID preCon3(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMax=3600,
    y_start=0,
    Ti=120,
    k=0.5,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    yMin=0)  annotation (Placement(transformation(extent={{-72,-442},{-52,-422}})));
  parameter Buildings.Fluid.Movers.Data.Generic per(
    pressure(V_flow=m_flow_nominal/1000*{0,0.41,0.54,0.66,0.77,0.89,1,1.12,1.19},
        dp=dp_nominal*{1.461,1.455,1.407,1.329,1.234,1.126,1.0,0.85,0.731}),
    motorEfficiency(V_flow={0}, eta={1}),
    speed_rpm_nominal=1800)
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{138,116},{158,136}})));
  MotorDevice.ZIPPump pum2(redeclare package Medium = Medium, per=
        per)
    annotation (Placement(transformation(extent={{10,-180},{30,-160}})));
  Modelica.Blocks.Sources.Constant dpSet2(k=20000)
    annotation (Placement(transformation(extent={{-120,-210},{-100,-190}})));
  Modelica.Blocks.Sources.Constant Vrms2(k=110)
    annotation (Placement(transformation(extent={{-100,-160},{-80,-140}})));
  Buildings.Fluid.FixedResistances.PressureDrop res2(
    redeclare package Medium = Medium,
    dp_nominal=2000,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-40,-180},{-20,-160}})));
  Buildings.Fluid.Sources.Boundary_pT expCol2(redeclare package Medium = Medium,
      nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-122})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex2(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=m_flow_nominal,
    m2_flow_nominal=m_flow_nominal,
    dp1_nominal=5000,
    dp2_nominal=5000)
    annotation (Placement(transformation(extent={{-10,-264},{10,-284}})));
  Buildings.Fluid.Sensors.RelativePressure senRelPre2(redeclare package
      Medium =
        Medium) annotation (Placement(transformation(extent={{20,-230},{0,-250}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem2(redeclare package
      Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-30,-278},{-50,-258}})));
  Buildings.Fluid.HeatExchangers.SensibleCooler_T coo1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=500) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={66,-210})));
  Modelica.Blocks.Sources.Constant temSet2(k=273.15 + 7)
    annotation (Placement(transformation(extent={{100,-200},{80,-180}})));
  Modelica.Blocks.Sources.Step TSou2(
    height=2,
    offset=273.15 + 18,
    startTime=1000)
    annotation (Placement(transformation(extent={{-100,-314},{-80,-294}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHot2(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,-300})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=1000,
    use_inputFilter=false)
    annotation (Placement(transformation(extent={{40,-278},{20,-258}})));
  Buildings.Controls.Continuous.LimPID conPID2(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=60,
    reverseAction=true)
    annotation (Placement(transformation(extent={{110,-280},{90,-260}})));
  Modelica.Blocks.Sources.Constant temSetHot2(k=273.15 + 16)
    annotation (Placement(transformation(extent={{160,-280},{140,-260}})));
  Buildings.Fluid.Sources.MassFlowSource_T souHot2(
    redeclare package Medium = Medium,
    m_flow=m_flow_nominal,
    nPorts=1,
    use_T_in=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,-300})));
  Buildings.Fluid.Sources.Boundary_pT sinHot2(redeclare package Medium = Medium,
      nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={92,-320})));
  Buildings.Controls.Continuous.LimPID preCon2(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=60,
    yMax=60,
    yMin=20) annotation (Placement(transformation(extent={{-80,-210},{-60,-190}})));
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
    annotation (Line(points={{-79,-64},{-62,-64}}, color={0,0,127}));
  connect(dpSet1.y,preCon1. u_s)
    annotation (Line(points={{-99,40},{-82,40}}, color={0,0,127}));
  connect(senRelPre1.p_rel,preCon1. u_m) annotation (Line(points={{10,9},{10,14},
          {-70,14},{-70,28}}, color={0,0,127}));
  connect(senRelPre1.port_b,hex1. port_b2) annotation (Line(points={{0,0},{-20,0},
          {-20,-28},{-10,-28}}, color={0,127,255}));
  connect(senRelPre1.port_a,val1. port_a) annotation (Line(points={{20,0},{50,0},
          {50,-28},{40,-28}}, color={0,127,255}));
  connect(Vrms1.y,pum1. V_rms) annotation (Line(points={{-79,90},{20,90},{20,82},
          {20.4,82}}, color={0,0,127}));
  connect(preCon1.y,pum1. f_in) annotation (Line(points={{-59,40},{-6,40},{-6,88},
          {12,88},{12,82},{11.2,82}}, color={0,0,127}));
  connect(pum3.port_a,res3. port_b)
    annotation (Line(points={{18,-402},{-12,-402}}, color={0,127,255}));
  connect(expCol3.ports[1],pum3. port_a)
    annotation (Line(points={{8,-364},{8,-402},{18,-402}}, color={0,127,255}));
  connect(hex3.port_b2,senTem3. port_a)
    annotation (Line(points={{-2,-500},{-22,-500}}, color={0,127,255}));
  connect(senTem3.port_b,res3. port_a) annotation (Line(points={{-42,-500},{-44,
          -500},{-44,-402},{-32,-402}}, color={0,127,255}));
  connect(pum3.port_b,coo3. port_a) annotation (Line(points={{38,-402},{74,-402},
          {74,-432}}, color={0,127,255}));
  connect(temSet3.y,coo3. TSet)
    annotation (Line(points={{87,-422},{66,-422},{66,-430}}, color={0,0,127}));
  connect(hex3.port_b1,senTemHot3. port_a) annotation (Line(points={{18,-512},{68,
          -512},{68,-522}}, color={0,127,255}));
  connect(coo3.port_b,val3. port_a) annotation (Line(points={{74,-452},{74,-500},
          {48,-500}}, color={0,127,255}));
  connect(val3.port_b,hex3. port_a2)
    annotation (Line(points={{28,-500},{18,-500}}, color={0,127,255}));
  connect(senTemHot3.T,conPID3. u_m) annotation (Line(points={{79,-532},{108,-532},
          {108,-514}}, color={0,0,127}));
  connect(temSetHot3.y,conPID3. u_s)
    annotation (Line(points={{147,-502},{120,-502}}, color={0,0,127}));
  connect(conPID3.y,val3. y) annotation (Line(points={{97,-502},{88,-502},{88,-480},
          {38,-480},{38,-488}}, color={0,0,127}));
  connect(senTemHot3.port_b,sinHot3. ports[1]) annotation (Line(points={{68,-542},
          {68,-552},{90,-552}}, color={0,127,255}));
  connect(souHot3.ports[1],hex3. port_a1) annotation (Line(points={{-32,-532},{-12,
          -532},{-12,-512},{-2,-512}}, color={0,127,255}));
  connect(TSou3.y,souHot3. T_in)
    annotation (Line(points={{-71,-536},{-54,-536}}, color={0,0,127}));
  connect(dpSet3.y,preCon3. u_s)
    annotation (Line(points={{-91,-432},{-74,-432}}, color={0,0,127}));
  connect(senRelPre3.p_rel,preCon3. u_m) annotation (Line(points={{18,-463},{18,
          -458},{-62,-458},{-62,-444}}, color={0,0,127}));
  connect(senRelPre3.port_b,hex3. port_b2) annotation (Line(points={{8,-472},{-12,
          -472},{-12,-500},{-2,-500}}, color={0,127,255}));
  connect(senRelPre3.port_a,val3. port_a) annotation (Line(points={{28,-472},{58,
          -472},{58,-500},{48,-500}}, color={0,127,255}));
  connect(preCon3.y,pum3. Nrpm) annotation (Line(points={{-51,-432},{0,-432},{0,
          -382},{28,-382},{28,-390}}, color={0,0,127}));
  connect(pum2.port_a,res2. port_b)
    annotation (Line(points={{10,-170},{-20,-170}},
                                                color={0,127,255}));
  connect(expCol2.ports[1],pum2. port_a) annotation (Line(points={{0,-132},{0,-170},
          {10,-170}},                      color={0,127,255}));
  connect(hex2.port_b2,senTem2. port_a)
    annotation (Line(points={{-10,-268},{-30,-268}},
                                                   color={0,127,255}));
  connect(senTem2.port_b,res2. port_a) annotation (Line(points={{-50,-268},{-52,
          -268},{-52,-170},{-40,-170}},
                              color={0,127,255}));
  connect(pum2.port_b,coo1. port_a)
    annotation (Line(points={{30,-170},{66,-170},{66,-200}},
                                                       color={0,127,255}));
  connect(temSet2.y, coo1.TSet)
    annotation (Line(points={{79,-190},{58,-190},{58,-198}}, color={0,0,127}));
  connect(hex2.port_b1,senTemHot2. port_a)
    annotation (Line(points={{10,-280},{60,-280},{60,-290}},
                                                          color={0,127,255}));
  connect(coo1.port_b,val2. port_a)
    annotation (Line(points={{66,-220},{66,-268},{40,-268}},
                                                         color={0,127,255}));
  connect(val2.port_b,hex2. port_a2)
    annotation (Line(points={{20,-268},{10,-268}},
                                                 color={0,127,255}));
  connect(senTemHot2.T,conPID2. u_m)
    annotation (Line(points={{71,-300},{100,-300},{100,-282}},
                                                            color={0,0,127}));
  connect(temSetHot2.y,conPID2. u_s)
    annotation (Line(points={{139,-270},{112,-270}},
                                                   color={0,0,127}));
  connect(conPID2.y,val2. y) annotation (Line(points={{89,-270},{80,-270},{80,-248},
          {30,-248},{30,-256}},
                             color={0,0,127}));
  connect(senTemHot2.port_b,sinHot2. ports[1])
    annotation (Line(points={{60,-310},{60,-320},{82,-320}},
                                                          color={0,127,255}));
  connect(souHot2.ports[1],hex2. port_a1) annotation (Line(points={{-40,-300},{-20,
          -300},{-20,-280},{-10,-280}},
                                     color={0,127,255}));
  connect(TSou2.y,souHot2. T_in)
    annotation (Line(points={{-79,-304},{-62,-304}},
                                                   color={0,0,127}));
  connect(dpSet2.y,preCon2. u_s)
    annotation (Line(points={{-99,-200},{-82,-200}},
                                                 color={0,0,127}));
  connect(senRelPre2.p_rel,preCon2. u_m) annotation (Line(points={{10,-231},{10,
          -226},{-70,-226},{-70,-212}},
                              color={0,0,127}));
  connect(senRelPre2.port_b,hex2. port_b2) annotation (Line(points={{0,-240},{-20,
          -240},{-20,-268},{-10,-268}},
                                color={0,127,255}));
  connect(senRelPre2.port_a,val2. port_a) annotation (Line(points={{20,-240},{50,
          -240},{50,-268},{40,-268}},
                              color={0,127,255}));
  connect(Vrms2.y,pum2. V_rms) annotation (Line(points={{-79,-150},{20,-150},{20,
          -158},{20,-158}},
                      color={0,0,127}));
  connect(preCon2.y,pum2. f_in) annotation (Line(points={{-59,-200},{-6,-200},{-6,
          -152},{12,-152},{12,-158},{11,-158}},
                                      color={0,0,127}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-600},{180,140}}),
        graphics={
        Rectangle(extent={{-140,140},{180,-90}}, lineColor={0,0,0}),
        Text(
          extent={{74,112},{160,92}},
          lineColor={0,0,0},
          textString="Proposed Pump"),
        Rectangle(extent={{-140,-340},{180,-582}},lineColor={0,0,0}),
        Text(
          extent={{80,-352},{166,-372}},
          lineColor={0,0,0},
          textString="Conventional Pump"),
        Rectangle(extent={{-140,-100},{180,-330}},
                                                 lineColor={0,0,0}),
        Text(
          extent={{98,-122},{178,-136}},
          lineColor={0,0,0},
          textString="ZIP Pump")}),
    experiment(StopTime=1000),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Examples/SimpleElectricPumpClosedLoop.mos"
        "Simulate and Plot"));
end SimpleElectricPumpClosedLoop;
