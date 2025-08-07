within FaultInjection.Equipment.BaseClasses.MotorDevice.CaseStudy;
model ComparePumpVoltageClosedLoop
  "Validate the simple electric pump model with various frquency"
  import FaultInjection.Equipment.BaseClasses.MotorDevice;
  import FaultInjection;
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 0.06*1000;
  parameter Modelica.SIunits.Pressure dp_nominal = 21*188.5/(m_flow_nominal/1000);
  parameter Integer pole=4 "Number of pole pairs";
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
    motorEfficiency(V_flow={0.04847,0.0567}, eta={0.865,0.84}))
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{-120,-578},{-100,-558}})));

  FaultInjection.Equipment.BaseClasses.MotorDevice.SimpleElectricPump pum1(
    redeclare package Medium = Medium,
    per=per,
    JMotor=JMotor,
    JLoad=JLoad,
    pole=pole,
    R_s=R_s,
    R_r=R_r,
    X_s=X_s,
    X_r=X_r,
    X_m=X_m)
    annotation (Placement(transformation(extent={{10,60},{30,80}})));
  Modelica.Blocks.Sources.Constant dpSet1(k=50000)
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Modelica.Blocks.Sources.Step     Vrms1(
    height=-12,
    offset=120,
    startTime=1000)
    annotation (Placement(transformation(extent={{-140,82},{-120,102}})));
  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1/2*dp_nominal)
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
    dp_nominal=1/4*dp_nominal)
                    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={66,30})));
  Modelica.Blocks.Sources.Constant temSet1(k=273.15 + 7)
    annotation (Placement(transformation(extent={{100,40},{80,60}})));
  Modelica.Blocks.Sources.Constant
                               TSou1(k=273.15 + 28)
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
    dpValve_nominal=1000)
    annotation (Placement(transformation(extent={{40,-38},{20,-18}})));
  Buildings.Controls.Continuous.LimPID conPID1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    reverseAction=true,
    yMin=0.1,
    Ti=120,
    k=0.5)
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
    k=0.1,
    Ti=60)   annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  MotorDevice.LoadDevice.SpeedControlled_Nrpm pum3(
    redeclare package Medium = Medium,
    per=per3,
    riseTime=45,
    use_inputFilter=false)
    annotation (Placement(transformation(extent={{18,-412},{38,-392}})));
  Modelica.Blocks.Sources.Constant
                               dpSet3(k=50000)
    annotation (Placement(transformation(extent={{-112,-442},{-92,-422}})));
  Buildings.Fluid.FixedResistances.PressureDrop res3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1/2*dp_nominal)
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
    dp2_nominal=1/4*dp_nominal)
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
    dp_nominal=1/4*dp_nominal)
                    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={74,-442})));
  Modelica.Blocks.Sources.Constant temSet3(k=273.15 + 7)
    annotation (Placement(transformation(extent={{108,-432},{88,-412}})));
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
    dpValve_nominal=1000)
    annotation (Placement(transformation(extent={{48,-510},{28,-490}})));
  Buildings.Controls.Continuous.LimPID conPID3(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    reverseAction=true,
    yMin=0.1,
    k=0.5,
    Ti=120)
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
    yMax=1800,
    yMin=600,
    k=0.1,
    Ti=60)   annotation (Placement(transformation(extent={{-72,-442},{-52,-422}})));
  parameter Buildings.Fluid.Movers.Data.Generic per(
    pressure(V_flow=m_flow_nominal/1000*{0,0.41,0.54,0.66,0.77,0.89,1,1.12,1.19},
        dp=dp_nominal*{1.461,1.455,1.407,1.329,1.234,1.126,1.0,0.85,0.731}),
    motorEfficiency(V_flow={0}, eta={1}),
    speed_rpm_nominal=1800)
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{138,116},{158,136}})));
  MotorDevice.ZIPPump pum2(
    redeclare package Medium = Medium,
    per=per,
    JMotor=JMotor,
    JLoad=JLoad,
    az=az,
    ai=ai,
    ap=ap,
    rz=rz,
    ri=ri,
    rp=rp,
    pole=pole,
    af=af,
    rf=rf,
    P_nominal=P_nominal,
    Q_nominal=Q_nominal)
    annotation (Placement(transformation(extent={{10,-180},{30,-160}})));
  Modelica.Blocks.Sources.Constant dpSet2(k=50000)
    annotation (Placement(transformation(extent={{-120,-210},{-100,-190}})));
  Buildings.Fluid.FixedResistances.PressureDrop res2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1/2*dp_nominal)
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
    dp2_nominal=1/4*dp_nominal)
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
    dp_nominal=1/4*dp_nominal)
                    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={66,-210})));
  Modelica.Blocks.Sources.Constant temSet2(k=273.15 + 7)
    annotation (Placement(transformation(extent={{100,-200},{80,-180}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHot2(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,-300})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=1000)
    annotation (Placement(transformation(extent={{40,-278},{20,-258}})));
  Buildings.Controls.Continuous.LimPID conPID2(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    reverseAction=true,
    yMin=0.1,
    Ti=120,
    k=0.5)
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
    yMax=60,
    yMin=20,
    k=0.1,
    Ti=60)   annotation (Placement(transformation(extent={{-80,-210},{-60,-190}})));

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
  connect(Vrms1.y,pum1. V_rms) annotation (Line(points={{-119,92},{20,92},{20,
          82},{20.4,82}},
                      color={0,0,127}));
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
  connect(preCon2.y,pum2. f_in) annotation (Line(points={{-59,-200},{-6,-200},{-6,
          -152},{12,-152},{12,-158},{11,-158}},
                                      color={0,0,127}));
  connect(Vrms1.y, pum2.V_rms) annotation (Line(points={{-119,92},{-90,92},{-90,
          -140},{20,-140},{20,-158}}, color={0,0,127}));
  connect(TSou1.y, souHot2.T_in) annotation (Line(points={{-115,-64},{-104,-64},
          {-104,-116},{-134,-116},{-134,-304},{-62,-304}}, color={0,0,127}));
  connect(TSou1.y, souHot3.T_in) annotation (Line(points={{-115,-64},{-106,-64},
          {-106,-114},{-136,-114},{-136,-536},{-54,-536}}, color={0,0,127}));
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
    experiment(StopTime=2000),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Examples/SimpleElectricPumpClosedLoop.mos"
        "Simulate and Plot"));
end ComparePumpVoltageClosedLoop;
