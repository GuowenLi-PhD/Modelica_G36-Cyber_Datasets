within FaultInjection.Equipment.BaseClasses.MotorDevice.CaseStudy;
model CompareLoadIncrease
  "Validate the simple electric pump model with various frquency"

  import Modelica.Constants.pi;
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 0.06*1000;
  parameter Modelica.SIunits.Pressure dp_nominal = 25*188.5/(m_flow_nominal/1000);
  parameter Real p_nominal = (m_flow_nominal/1000)*dp_nominal/0.65;
  parameter Integer pole=4 "Number of pole pairs";

  // proposed pump

  parameter Buildings.Fluid.Movers.Data.Generic per3(
    pressure(V_flow=m_flow_nominal/1000*{0,0.41,0.54,0.66,0.77,0.89,1,1.12,1.19},
        dp=dp_nominal*{1.461,1.455,1.407,1.329,1.234,1.126,1.0,0.85,0.731}),
    speed_rpm_nominal=1800,
    motorEfficiency(V_flow={0.03529,0.04285}, eta={0.8287,0.8691}))
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{-120,-358},{-100,-338}})));

  MotorDevice.DoubleCagePump pum1(
    redeclare package Medium = Medium,
    per=per,
    pole=pole,
    Pbase=p_nominal,
    Kfric=0.01)
    annotation (Placement(transformation(extent={{10,60},{30,80}})));
  Modelica.Blocks.Sources.Constant dpSet1(k=50000)
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
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
  Modelica.Blocks.Sources.Step TSou1(
    height=4,
    offset=273.15 + 24,
    startTime=800)
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
    dpValve_nominal=1000,
    use_inputFilter=false)
    annotation (Placement(transformation(extent={{40,-38},{20,-18}})));
  Buildings.Controls.Continuous.LimPID conPID1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    reverseAction=true,
    yMin=0.1,
    k=0.5,
    Ti=120)
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
    use_inputFilter=false)
    annotation (Placement(transformation(extent={{18,-192},{38,-172}})));
  Modelica.Blocks.Sources.Constant
                               dpSet3(k=50000)
    annotation (Placement(transformation(extent={{-112,-222},{-92,-202}})));
  Buildings.Fluid.FixedResistances.PressureDrop res3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1/2*dp_nominal)
    annotation (Placement(transformation(extent={{-32,-192},{-12,-172}})));
  Buildings.Fluid.Sources.Boundary_pT expCol3(redeclare package Medium = Medium,
      nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={8,-134})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex3(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=m_flow_nominal,
    m2_flow_nominal=m_flow_nominal,
    dp1_nominal=5000,
    dp2_nominal=1/4*dp_nominal)
    annotation (Placement(transformation(extent={{-2,-276},{18,-296}})));
  Buildings.Fluid.Sensors.RelativePressure senRelPre3(redeclare package
      Medium =
        Medium) annotation (Placement(transformation(extent={{28,-242},{8,-262}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem3(redeclare package
      Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-22,-290},{-42,-270}})));
  Buildings.Fluid.HeatExchangers.SensibleCooler_T coo3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1/4*dp_nominal)
                    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={74,-222})));
  Modelica.Blocks.Sources.Constant temSet3(k=273.15 + 7)
    annotation (Placement(transformation(extent={{108,-212},{88,-192}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHot3(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal)
                                               annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={68,-312})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=1000,
    use_inputFilter=false)
    annotation (Placement(transformation(extent={{48,-290},{28,-270}})));
  Buildings.Controls.Continuous.LimPID conPID3(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    reverseAction=true,
    yMin=0.1,
    k=0.5,
    Ti=120)
    annotation (Placement(transformation(extent={{118,-292},{98,-272}})));
  Modelica.Blocks.Sources.Constant temSetHot3(k=273.15 + 16)
    annotation (Placement(transformation(extent={{168,-292},{148,-272}})));
  Buildings.Fluid.Sources.MassFlowSource_T souHot3(
    redeclare package Medium = Medium,
    m_flow=m_flow_nominal,
    nPorts=1,
    use_T_in=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-42,-312})));
  Buildings.Fluid.Sources.Boundary_pT sinHot3(redeclare package Medium = Medium,
      nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={100,-332})));
  Buildings.Controls.Continuous.LimPID preCon3(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMax=1800,
    yMin=600,
    Ti=60,
    k=0.1)   annotation (Placement(transformation(extent={{-72,-222},{-52,-202}})));
  parameter Buildings.Fluid.Movers.Data.Generic per(
    pressure(V_flow=m_flow_nominal/1000*{0,0.41,0.54,0.66,0.77,0.89,1,1.12,1.19},
        dp=dp_nominal*{1.461,1.455,1.407,1.329,1.234,1.126,1.0,0.85,0.731}),
    motorEfficiency(V_flow={0}, eta={1}),
    speed_rpm_nominal=1800)
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{138,116},{158,136}})));

  Modelica.Blocks.Sources.Step TSou3(
    height=4,
    offset=273.15 + 24,
    startTime=800)
    annotation (Placement(transformation(extent={{-138,-326},{-118,-306}})));
  Modelica.Blocks.Sources.Step volDow(
    offset=1,
    height=0,
    startTime=800)
                 "Voltage ramp down"
    annotation (Placement(transformation(extent={{-280,120},{-260,140}})));
  Modelica.Blocks.Sources.Ramp volUp(
    duration=0.01,
    offset=0,
    height=0,
    startTime=5.31)
              "Voltage ramp up"
    annotation (Placement(transformation(extent={{-280,80},{-260,100}})));
  Modelica.Blocks.Math.Add vol
    annotation (Placement(transformation(extent={{-210,100},{-190,120}})));
  Modelica.ComplexBlocks.Sources.ComplexConstant a(k(re=cos(0), im=sin(0)))
    annotation (Placement(transformation(extent={{-260,40},{-240,60}})));
  Modelica.ComplexBlocks.Sources.ComplexConstant b(k(re=cos(-2/3*pi), im=sin(-2/
          3*pi)))
    annotation (Placement(transformation(extent={{-260,0},{-240,20}})));
  Modelica.ComplexBlocks.Sources.ComplexConstant c(k(re=cos(2/3*pi), im=sin(2/3*
          pi)))
    annotation (Placement(transformation(extent={{-260,-40},{-240,-20}})));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal1
    annotation (Placement(transformation(extent={{-220,40},{-200,60}})));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal2
    annotation (Placement(transformation(extent={{-220,0},{-200,20}})));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal3
    annotation (Placement(transformation(extent={{-220,-40},{-200,-20}})));
  Modelica.Blocks.Math.Product pro1[2]
    annotation (Placement(transformation(extent={{-180,40},{-160,60}})));
  Modelica.Blocks.Math.Product pro2[2]
    annotation (Placement(transformation(extent={{-180,0},{-160,20}})));
  Modelica.Blocks.Math.Product pro3[2]
    annotation (Placement(transformation(extent={{-180,-40},{-160,-20}})));
  Modelica.Blocks.Math.Gain gain(k=1)
    annotation (Placement(transformation(extent={{-244,120},{-224,140}})));
  Modelica.Blocks.Math.Gain gain1(k=1)
    annotation (Placement(transformation(extent={{-244,80},{-224,100}})));
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
          {12,88},{12,82},{12,82}},   color={0,0,127}));
  connect(pum3.port_a,res3. port_b)
    annotation (Line(points={{18,-182},{-12,-182}}, color={0,127,255}));
  connect(expCol3.ports[1],pum3. port_a)
    annotation (Line(points={{8,-144},{8,-182},{18,-182}}, color={0,127,255}));
  connect(hex3.port_b2,senTem3. port_a)
    annotation (Line(points={{-2,-280},{-22,-280}}, color={0,127,255}));
  connect(senTem3.port_b,res3. port_a) annotation (Line(points={{-42,-280},{-44,
          -280},{-44,-182},{-32,-182}}, color={0,127,255}));
  connect(pum3.port_b,coo3. port_a) annotation (Line(points={{38,-182},{74,-182},
          {74,-212}}, color={0,127,255}));
  connect(temSet3.y,coo3. TSet)
    annotation (Line(points={{87,-202},{66,-202},{66,-210}}, color={0,0,127}));
  connect(hex3.port_b1,senTemHot3. port_a) annotation (Line(points={{18,-292},{68,
          -292},{68,-302}}, color={0,127,255}));
  connect(coo3.port_b,val3. port_a) annotation (Line(points={{74,-232},{74,-280},
          {48,-280}}, color={0,127,255}));
  connect(val3.port_b,hex3. port_a2)
    annotation (Line(points={{28,-280},{18,-280}}, color={0,127,255}));
  connect(senTemHot3.T,conPID3. u_m) annotation (Line(points={{79,-312},{108,-312},
          {108,-294}}, color={0,0,127}));
  connect(temSetHot3.y,conPID3. u_s)
    annotation (Line(points={{147,-282},{120,-282}}, color={0,0,127}));
  connect(conPID3.y,val3. y) annotation (Line(points={{97,-282},{88,-282},{88,-260},
          {38,-260},{38,-268}}, color={0,0,127}));
  connect(senTemHot3.port_b,sinHot3. ports[1]) annotation (Line(points={{68,-322},
          {68,-332},{90,-332}}, color={0,127,255}));
  connect(souHot3.ports[1],hex3. port_a1) annotation (Line(points={{-32,-312},{-12,
          -312},{-12,-292},{-2,-292}}, color={0,127,255}));
  connect(dpSet3.y,preCon3. u_s)
    annotation (Line(points={{-91,-212},{-74,-212}}, color={0,0,127}));
  connect(senRelPre3.p_rel,preCon3. u_m) annotation (Line(points={{18,-243},{18,
          -238},{-62,-238},{-62,-224}}, color={0,0,127}));
  connect(senRelPre3.port_b,hex3. port_b2) annotation (Line(points={{8,-252},{-12,
          -252},{-12,-280},{-2,-280}}, color={0,127,255}));
  connect(senRelPre3.port_a,val3. port_a) annotation (Line(points={{28,-252},{58,
          -252},{58,-280},{48,-280}}, color={0,127,255}));
  connect(preCon3.y,pum3. Nrpm) annotation (Line(points={{-51,-212},{0,-212},{0,
          -162},{28,-162},{28,-170}}, color={0,0,127}));
  connect(TSou3.y, souHot3.T_in)
    annotation (Line(points={{-117,-316},{-54,-316}}, color={0,0,127}));
  connect(a.y,complexToReal1. u)
    annotation (Line(points={{-239,50},{-222,50}},
                                                 color={85,170,255}));
  connect(b.y,complexToReal2. u)
    annotation (Line(points={{-239,10},{-222,10}}, color={85,170,255}));
  connect(c.y,complexToReal3. u)
    annotation (Line(points={{-239,-30},{-222,-30}},
                                                   color={85,170,255}));
  connect(complexToReal1.re,pro1 [1].u2) annotation (Line(points={{-198,56},{-190,
          56},{-190,44},{-182,44}},
                               color={0,0,127}));
  connect(vol.y,pro1 [1].u1) annotation (Line(points={{-189,110},{-186,110},{-186,
          56},{-182,56}},
                   color={0,0,127}));
  connect(complexToReal1.im,pro1 [2].u2)
    annotation (Line(points={{-198,44},{-182,44}},
                                              color={0,0,127}));
  connect(vol.y,pro1 [2].u1) annotation (Line(points={{-189,110},{-186,110},{-186,
          56},{-182,56}},
                   color={0,0,127}));
  connect(vol.y,pro2 [1].u1) annotation (Line(points={{-189,110},{-186,110},{-186,
          16},{-182,16}},
                     color={0,0,127}));
  connect(vol.y,pro2 [2].u1) annotation (Line(points={{-189,110},{-186,110},{-186,
          16},{-182,16}},
                     color={0,0,127}));
  connect(complexToReal2.re,pro2 [1].u2) annotation (Line(points={{-198,16},{-192,
          16},{-192,4},{-182,4}},   color={0,0,127}));
  connect(complexToReal2.im,pro2 [2].u2)
    annotation (Line(points={{-198,4},{-182,4}},  color={0,0,127}));
  connect(vol.y,pro3 [1].u1) annotation (Line(points={{-189,110},{-186,110},{-186,
          -24},{-182,-24}},
                     color={0,0,127}));
  connect(complexToReal3.re,pro3 [1].u2) annotation (Line(points={{-198,-24},{-192,
          -24},{-192,-36},{-182,-36}},
                                    color={0,0,127}));
  connect(complexToReal3.im,pro3 [2].u2)
    annotation (Line(points={{-198,-36},{-182,-36}},
                                                  color={0,0,127}));
  connect(vol.y,pro3 [2].u1) annotation (Line(points={{-189,110},{-186,110},{-186,
          -24},{-182,-24}},
                     color={0,0,127}));
  connect(volDow.y,gain. u)
    annotation (Line(points={{-259,130},{-246,130}},
                                                   color={0,0,127}));
  connect(gain.y,vol. u1) annotation (Line(points={{-223,130},{-220,130},{-220,116},
          {-212,116}},color={0,0,127}));
  connect(volUp.y,gain1. u)
    annotation (Line(points={{-259,90},{-246,90}}, color={0,0,127}));
  connect(gain1.y,vol. u2) annotation (Line(points={{-223,90},{-220,90},{-220,104},
          {-212,104}},color={0,0,127}));
  connect(pro1.y, pum1.Vas[1, :]) annotation (Line(points={{-159,50},{
          -136,50},{-136,100},{-8,100},{-8,76},{8,76}},
                                              color={0,0,127}));
  connect(pro2.y, pum1.Vbs[1, :]) annotation (Line(points={{-159,10},{
          -134,10},{-134,98},{-10,98},{-10,72},{8,72}},
                                              color={0,0,127}));
  connect(pro3.y, pum1.Vcs[1, :]) annotation (Line(points={{-159,-30},{
          -132,-30},{-132,96},{-12,96},{-12,68},{8,68}},
                                               color={0,0,127}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-380},{180,140}}),
        graphics={
        Rectangle(extent={{-140,140},{180,-90}}, lineColor={0,0,0}),
        Text(
          extent={{74,112},{160,92}},
          lineColor={0,0,0},
          textString="Proposed Pump"),
        Rectangle(extent={{-140,-120},{180,-362}},lineColor={0,0,0}),
        Text(
          extent={{80,-132},{166,-152}},
          lineColor={0,0,0},
          textString="Conventional Pump")}),
    experiment(StopTime=1200, __Dymola_NumberOfIntervals=400000),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Examples/SimpleElectricPumpClosedLoop.mos"
        "Simulate and Plot"));
end CompareLoadIncrease;
