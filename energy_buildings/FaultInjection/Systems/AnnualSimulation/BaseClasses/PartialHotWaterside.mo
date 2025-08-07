within FaultInjection.Systems.AnnualSimulation.BaseClasses;
partial model PartialHotWaterside
  "Partial model that implements hot water-side system"
  package MediumA = Buildings.Media.Air "Medium model for air";
  package MediumW = Buildings.Media.Water "Medium model for water";

  // Boiler parameters
  parameter Modelica.SIunits.MassFlowRate m_flow_boi_nominal= Q_flow_boi_nominal/4200/5
    "Nominal water mass flow rate at boiler";
  parameter Modelica.SIunits.Power Q_flow_boi_nominal
    "Nominal heating capaciaty(Positive means heating)";
  parameter Modelica.SIunits.Pressure dpSetPoiHW = 36000
    "Differential pressure setpoint at heating coil";
  FaultInjection.Equipment.VariableFaults.StuckValve HWVal(
    redeclare package Medium = MediumW,
    m_flow_nominal=m_flow_boi_nominal,
    faultMode=faultHeaVavStu,
    dpValve_nominal=6000,
    dpFixed_nominal=0)    "Two-way valve"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={98,-180})));
  Buildings.Fluid.Sources.Boundary_pT expVesBoi(redeclare replaceable package
      Medium = MediumW,
    T=318.15,           nPorts=1)
    "Expansion tank"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={58,-319})));
  Buildings.Fluid.Sensors.TemperatureTwoPort THWRet(redeclare replaceable
      package Medium = MediumW, m_flow_nominal=m_flow_boi_nominal)
    "Boiler plant water return temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={98,-226})));
  Buildings.Fluid.FixedResistances.Pipe resHW(
    m_flow_nominal=m_flow_boi_nominal,
    redeclare package Medium = MediumW,
    dp_nominal=100000,
    thicknessIns=0.01,
    lambdaIns=0.04,
    length=0,
    v_nominal=1)
              "Resistance in hot water loop" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={350,-228})));
  FaultInjection.Equipment.ParameterFaults.FoulingBoilerPolynomial boi(
    redeclare package Medium = MediumW,
    m_flow_nominal=m_flow_boi_nominal,
    dp_nominal=60000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=Q_flow_boi_nominal,
    T_nominal=323.15,
    effCur=FaultInjection.Equipment.ParameterFaults.BaseClasses.EfficiencyCurves.BiQuadratic,
    a={0.89,0.014963852,-0.02599835,0.0,-1.40464E-6,-0.00153624},
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue())
    annotation (Placement(transformation(extent={{130,-330},{150,-310}})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear boiIsoVal(
    redeclare each package Medium = MediumW,
    m_flow_nominal=m_flow_boi_nominal,
    dpValve_nominal=6000) "Boiler Isolation Valve"
    annotation (Placement(transformation(extent={{282,-330},{302,-310}})));
  Buildings.Fluid.Movers.SpeedControlled_y pumHW(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    per=perPumHW,
    addPowerToMedium=false)
    annotation (Placement(transformation(extent={{198,-330},{218,-310}})));
  FaultInjection.Equipment.VariableFaults.FaultTemperatureSensor THWSup(
    redeclare replaceable package Medium = MediumW,
    m_flow_nominal=m_flow_boi_nominal,
    faultMode=faultTHWSup)
    "Hot water supply temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={350,-294})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valBypBoi(
    redeclare package Medium = MediumW,
    m_flow_nominal=m_flow_boi_nominal,
    dpValve_nominal=6000,
    y_start=0,
    use_inputFilter=false,
    from_dp=true) "Bypass valve for boiler"  annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={230,-252})));
  FaultInjection.Equipment.VariableFaults.FaultRelativePressureSensor senRelPreHW(redeclare
      replaceable package Medium = MediumW, faultMode=faultRelPreHW)
    "Differential pressure fault sensor in the HW loop"
    annotation (Placement(transformation(extent={{208,-196},{188,-216}})));
  parameter Buildings.Fluid.Movers.Data.Generic perPumHW(
          pressure=Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
          V_flow=m_flow_boi_nominal/1000*pumHWVFloArr,
          dp=(100000+60000+6000+6000)*pumHWPreArr),
          motorEfficiency=Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters(
          V_flow={0},eta=pumHWetaArr))
    "Performance data for hot water primary pump";
  parameter Real pumHWPreArr [4]= {1.5,1.3,1.0,0.6}
    "Pressure performance data for hot water primary pump";
  parameter Real pumHWetaArr [1]= {0.7}
    "Efficiency for hot water primary pump";
  parameter Real pumHWVFloArr [4]= {0.2,0.6,1.0,1.2}
    "Flow rate performance data for hot water primary pump";
  Modelica.Blocks.Math.Gain dpSetGaiHW(k=1/dpSetPoiHW) "Gain effect"
    annotation (Placement(transformation(extent={{-100,-330},{-80,-310}})));
  Modelica.Blocks.Math.Gain dpGaiHW(k=1/dpSetPoiHW) "Gain effect"
    annotation (Placement(transformation(extent={{-100,-360},{-80,-340}})));
  Buildings.Controls.Continuous.LimPID pumSpeHW(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=40,
    yMin=0.2,
    k=0.1) "Pump speed controller"
    annotation (Placement(transformation(extent={{-70,-330},{-50,-310}})));
  Buildings.Controls.OBC.CDL.Continuous.Product proPumHW
    annotation (Placement(transformation(extent={{-32,-324},{-12,-304}})));
  Experimental.SystemLevelFaults.Controls.MinimumFlowBypassValve minFloBypHW(
      controllerType=Modelica.Blocks.Types.SimpleController.PI)
    "Hot water loop minimum bypass valve control"
    annotation (Placement(transformation(extent={{-74,-258},{-54,-238}})));
  Buildings.Fluid.Sensors.MassFlowRate senHWFlo(redeclare package Medium =
        MediumW)
    "Sensor for hot water flow rate" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={98,-278})));
  Buildings.Controls.Continuous.LimPID boiTSup(
    Td=1,
    k=0.5,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=100,
    yMin=0.05)
            "Boiler supply water temperature"
    annotation (Placement(transformation(extent={{-74,-288},{-54,-268}})));
  Buildings.Controls.OBC.CDL.Continuous.Product proBoi
    annotation (Placement(transformation(extent={{-32,-282},{-12,-262}})));
  Experimental.SystemLevelFaults.Controls.TrimResponse triResHW(
    uTri=0.9,
    dpMin(displayUnit="kPa") = 0.5*dpSetPoiHW,
    dpMax(displayUnit="kPa") = dpSetPoiHW)
    annotation (Placement(transformation(extent={{-180,-234},{-160,-214}})));
  parameter Utilities.InsertionTypes.Generic.faultMode faultHeaVavStu
    "Heating coil valve stuck fault"
    annotation (Placement(transformation(extent={{108,-164},{128,-144}})));
  parameter Utilities.InsertionTypes.Generic.faultMode faultTHWSup
    "Hot water supply temperature sensor fault"
    annotation (Placement(transformation(extent={{320,-196},{340,-176}})));
  parameter Utilities.InsertionTypes.Generic.faultMode faultRelPreHW
    "Hot water loop differential pressure sensor fault"
    annotation (Placement(transformation(extent={{220,-196},{240,-176}})));
  Utilities.InsertionTypes.Variables.SignalCorruption.Max maxHWDifPre(
      faultMode=faultHWDifPre)
    annotation (Placement(transformation(extent={{-140,-218},{-120,-198}})));
  parameter Utilities.InsertionTypes.Generic.faultMode faultHWDifPre(minimum=
        0.5*dpSetPoiHW, maximum=dpSetPoiHW)
    "Hot water differential pressure faulty setpoint"
    annotation (Placement(transformation(extent={{-140,-186},{-120,-166}})));
  Utilities.InsertionTypes.Variables.SignalCorruption.Min minHWTSupSet(
      faultMode=faultHWTSupSet)
    annotation (Placement(transformation(extent={{-140,-260},{-120,-240}})));
  parameter Utilities.InsertionTypes.Generic.faultMode faultHWTSupSet(minimum=
        32 + 273.15, maximum=45 + 273.15)
    "Hot water supply temperature faulty setpoint"
    annotation (Placement(transformation(extent={{-140,-290},{-120,-270}})));
  Utilities.InsertionTypes.Variables.SignalDelay.RealFixedDelay yPumHWDel(
      delayTime=1, faultMode=faultyPumHWDel)
    "Hot water pump  input signal delay"
    annotation (Placement(transformation(extent={{0,-324},{20,-304}})));
  parameter Utilities.InsertionTypes.Generic.faultMode faultyPumHWDel
    "Hot water pump input signal delay fault"
    annotation (Placement(transformation(extent={{0,-354},{20,-334}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TEnvHea(T=288.15)
    "Environment temperature"
    annotation (Placement(transformation(extent={{304,-238},{324,-218}})));
equation
  connect(HWVal.port_b, THWRet.port_a)
    annotation (Line(points={{98,-190},{98,-216}},
                                                 color={238,46,47},
      thickness=0.5));
  connect(boi.port_b, pumHW.port_a)
    annotation (Line(points={{150,-320},{198,-320}},color={238,46,47},
      thickness=0.5));
  connect(pumHW.port_b, boiIsoVal.port_a)
    annotation (Line(points={{218,-320},{282,-320}}, color={238,46,47},
      thickness=0.5));
  connect(THWRet.port_a, senRelPreHW.port_b) annotation (Line(
      points={{98,-216},{98,-206},{188,-206}},
      color={238,46,47},
      thickness=0.5));
  connect(dpSetGaiHW.y, pumSpeHW.u_s)
    annotation (Line(points={{-79,-320},{-72,-320}},   color={0,0,127}));
  connect(dpGaiHW.y, pumSpeHW.u_m) annotation (Line(points={{-79,-350},{-60,
          -350},{-60,-332}},
                        color={0,0,127}));
  connect(senRelPreHW.p_rel, dpGaiHW.u) annotation (Line(points={{198,-195},{
          198,-68},{-192,-68},{-192,-350},{-102,-350}},
                                                    color={0,0,127}));
  connect(pumSpeHW.y, proPumHW.u2)
    annotation (Line(points={{-49,-320},{-34,-320}}, color={0,0,127}));
  connect(expVesBoi.ports[1], boi.port_a) annotation (Line(points={{68,-319},{
          100,-319},{100,-320},{130,-320}},
                                      color={238,46,47},
      thickness=0.5));
  connect(senHWFlo.m_flow, minFloBypHW.m_flow) annotation (Line(points={{87,-278},
          {72,-278},{72,-70},{-96,-70},{-96,-245},{-76,-245}}, color={0,0,127}));
  connect(valBypBoi.port_a, senHWFlo.port_a) annotation (Line(points={{220,-252},
          {98,-252},{98,-268}}, color={238,46,47},
      thickness=0.5));
  connect(THWRet.port_b, senHWFlo.port_a)
    annotation (Line(points={{98,-236},{98,-268}}, color={238,46,47},
      thickness=0.5));
  connect(senHWFlo.port_b, boi.port_a) annotation (Line(points={{98,-288},{98,
          -320},{130,-320}}, color={238,46,47},
      thickness=0.5));
  connect(boiTSup.y, proBoi.u2)
    annotation (Line(points={{-53,-278},{-34,-278}}, color={0,0,127}));
  connect(proBoi.y, boi.y) annotation (Line(points={{-10,-272},{0,-272},{0,
          -292},{120,-292},{120,-312},{128,-312}},
                             color={0,0,127}));
  connect(HWVal.y_actual, triResHW.u) annotation (Line(points={{90.8,-185},{
          90.8,-200},{76,-200},{76,-66},{-190,-66},{-190,-224},{-182,-224}},
                                                      color={0,0,127}));
  connect(valBypBoi.port_b, resHW.port_a) annotation (Line(
      points={{240,-252},{350,-252},{350,-238}},
      color={238,46,47},
      thickness=0.5));
  connect(triResHW.dpSet, maxHWDifPre.u) annotation (Line(points={{-159,-219},
          {-150,-219},{-150,-208},{-142,-208}}, color={238,46,47}));
  connect(maxHWDifPre.y, dpSetGaiHW.u) annotation (Line(points={{-119,-208},{
          -110,-208},{-110,-320},{-102,-320}}, color={235,0,0}));
  connect(minHWTSupSet.y, boiTSup.u_s) annotation (Line(points={{-119,-250},{
          -102,-250},{-102,-278},{-76,-278}}, color={235,0,0}));
  connect(minHWTSupSet.u, triResHW.TSet) annotation (Line(points={{-142,-250},
          {-150,-250},{-150,-229},{-159,-229}}, color={235,0,0}));
  connect(yPumHWDel.u, proPumHW.y)
    annotation (Line(points={{-2,-314},{-10,-314}}, color={235,0,0}));
  connect(yPumHWDel.y, pumHW.y) annotation (Line(points={{21,-314},{40,-314},
          {40,-342},{180,-342},{180,-300},{208,-300},{208,-308}}, color={235,
          0,0}));
  connect(THWSup.T, boiTSup.u_m) annotation (Line(points={{339,-294},{-64,
          -294},{-64,-290}},                       color={0,0,127}));
  connect(THWSup.port_a, resHW.port_a) annotation (Line(
      points={{350,-284},{350,-238}},
      color={238,46,47},
      thickness=0.5));
  connect(boiIsoVal.port_b, THWSup.port_b) annotation (Line(
      points={{302,-320},{350,-320},{350,-304}},
      color={238,46,47},
      thickness=0.5));
  connect(resHW.port_b, senRelPreHW.port_a) annotation (Line(
      points={{350,-218},{350,-206},{208,-206}},
      color={238,46,47},
      thickness=0.5));
  connect(TEnvHea.port, resHW.heatPort)
    annotation (Line(points={{324,-228},{345,-228}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -380},{350,-60}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-380},{350,
            -60}})));
end PartialHotWaterside;
