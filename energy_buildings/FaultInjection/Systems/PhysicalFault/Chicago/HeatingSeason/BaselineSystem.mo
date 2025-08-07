within FaultInjection.Systems.PhysicalFault.Chicago.HeatingSeason;
model BaselineSystem "System example for fault injection"
  extends Modelica.Icons.Example;
  extends
    FaultInjection.Systems.PhysicalFault.Chicago.HeatingSeason.BaseClasses.PartialHotWaterside(
    final Q_flow_boi_nominal=designHeatLoad,
    pumSpeHW(
      k=0.5,
      reset=Buildings.Types.Reset.Parameter,
      y_reset=0),
    boiTSup(
      k=0.01,
      Ti=300,
      yMin=0,
      y_start=0,
      reset=Buildings.Types.Reset.Parameter,
      y_reset=0),
    boi(show_T=false),
    triResHW(
      samplePeriod=300,
      TMin=313.15,
      TMax=321.15),
    faultHeaVavStu(startTime=259200, endTime=864000),
    THWSup(use_uFau_in=false, bias(k=-2)),
    senRelPreHW(use_uFau_in=false, bias(k=36000*0.1)),
    faultRelPreHW(startTime=259200, endTime=864000),
    faultTHWSup(startTime=259200, endTime=864000),
    faultHWDifPre(startTime=259200, endTime=864000),
    faultHWTSupSet(startTime=259200, endTime=864000),
    faultyPumHWDel(startTime=259200, endTime=864000),
    minFloBypHW(k=0.1),
    resHW(diameter=0.05, length=25));
  extends
    FaultInjection.Systems.PhysicalFault.Chicago.HeatingSeason.BaseClasses.PartialAirside(
    faultTSupEas(startTime=259200, endTime=864000),
    faultVSupEas_flow(startTime=259200, endTime=864000),
    faultSupDucLea(startTime=259200, endTime=864000),
    fanSup(show_T=false),
    conAHU(
      kMinOut=0.01,
      pNumIgnReq=1,
      TSupSetMin=284.95,
      numIgnReqSupTem=1,
      kTSup=0.1,
      TiTSup=120),
    conVAVWes(
      VDisSetMin_flow=0.05*conVAVWes.V_flow_nominal,
      VDisConMin_flow=0.05*conVAVWes.V_flow_nominal,
      errTZonCoo_1=0.8,
      errTZonCoo_2=0.4,
      sysReq(gai1(k=0.7), gai2(k=0.9))),
    conVAVCor(
      VDisSetMin_flow=0.05*conVAVCor.V_flow_nominal,
      VDisConMin_flow=0.05*conVAVCor.V_flow_nominal,
      errTZonCoo_1=0.8,
      errTZonCoo_2=0.4,
      sysReq(gai1(k=0.7), gai2(k=0.9))),
    conVAVSou(
      VDisSetMin_flow=0.05*conVAVSou.V_flow_nominal,
      VDisConMin_flow=0.05*conVAVSou.V_flow_nominal,
      errTZonCoo_1=0.8,
      errTZonCoo_2=0.4,
      sysReq(gai1(k=0.7), gai2(k=0.9))),
    conVAVEas(
      VDisSetMin_flow=0.05*conVAVEas.V_flow_nominal,
      VDisConMin_flow=0.05*conVAVEas.V_flow_nominal,
      errTZonCoo_1=0.8,
      errTZonCoo_2=0.4,
      sysReq(gai1(k=0.7), gai2(k=0.9))),
    conVAVNor(
      VDisSetMin_flow=0.05*conVAVNor.V_flow_nominal,
      VDisConMin_flow=0.05*conVAVNor.V_flow_nominal,
      errTZonCoo_1=0.8,
      errTZonCoo_2=0.4,
      sysReq(gai1(k=0.7), gai2(k=0.9))),
    flo(
      gai(K=5*[0.4; 0.4; 0.2]),
      temAirEas(bias(k=1.2)),
      faulttemAirEas=faulttemAirEas,
      faulttemAirSou=faulttemAirSou),
    faultOADamStu(startTime=259200, endTime=864000),
    faultVOut(startTime=259200, endTime=864000),
    VOut1(use_uFau_in=false, sca(k=1.1)),
    faultTMix(startTime=259200, endTime=864000),
    faultTRet(startTime=259200, endTime=864000),
    faultTSup(startTime=259200, endTime=864000),
    TMix(use_uFau_in=false, bias(k=1)),
    TRet(use_uFau_in=false, bias(k=1)),
    TSup(use_uFau_in=false, bias(k=1)),
    VSupEas_flow(use_uFau_in=false, sca(k=1.1)),
    TSupEas(use_uFau_in=false, bias(k=1)),
    faultdpDisSupFan(startTime=259200, endTime=864000),
    dpDisSupFan(bias(k=15)),
    faultSupFanSpeDel(startTime=259200, endTime=864000),
    faultyCooDel(startTime=259200, endTime=864000),
    faultyHeaDel(startTime=259200, endTime=864000));
  extends FaultInjection.Experimental.SystemLevelFaults.BaseClasses.EnergyMeter(
    eleCoiVAV(y=cor.terHea.Q1_flow + nor.terHea.Q1_flow + wes.terHea.Q1_flow +
          eas.terHea.Q1_flow + sou.terHea.Q1_flow),
    eleSupFan(y=fanSup.P),
    eleChi(y=chiWSE.powChi[1]),
    eleCHWP(y=chiWSE.powPum[1]),
    eleCWP(y=pumCW.P),
    eleHWP(y=pumHW.P),
    eleCT(y=cooTow.PFan),
    gasBoi(y=boi.QFue_flow));
  extends
    FaultInjection.Systems.PhysicalFault.Chicago.HeatingSeason.BaseClasses.PartialWaterside(
    resCHW(dp_nominal=139700, diameter=0.065,
      length=25),
    faultRelPre(startTime=17625600, endTime=18230400),
    faultTCHWSup(startTime=17625600, endTime=18230400),
    redeclare
      FaultInjection.Experimental.SystemLevelFaults.BaseClasses.IntegratedPrimaryLoadSideChillerFault
      chiWSE(
      use_inputFilter=true,
      addPowerToMedium=false,
      perPum=perPumPri),
    watVal(
      redeclare package Medium = MediumW,
      m_flow_nominal=m2_flow_chi_nominal,
      dpValve_nominal=6000,
      riseTime=60),
    QEva_nominal=designCoolLoad,
    pumCW(use_inputFilter=true),
    temDifPreRes(
      samplePeriod(displayUnit="s"),
      uTri=0.9,
      dpMin=0.5*dpSetPoi,
      dpMax=dpSetPoi,
      TMin(displayUnit="degC") = 278.15,
      TMax(displayUnit="degC") = 283.15),
    pumSpe(yMin=0.2),
    faultCoiVavStu(startTime=17625600, endTime=18230400),
    TCHWSup(
      faultMode=faultTHWSup,
      use_uFau_in=false,
      bias(k=-2)),
    faultTCWSup(startTime=17625600, endTime=18230400),
    TCWSup(use_uFau_in=false, bias(k=1)),
    senRelPre(use_uFau_in=false, bias(k=36000*0.1)),
    faultCHWDifPre(startTime=17625600, endTime=18230400),
    faultCHWTSupSet(startTime=17625600, endTime=18230400),
    chiFauMod(each startTime=17625600, each endTime=18230400),
    del(tau=1));

  parameter Buildings.Fluid.Movers.Data.Generic[numChi] perPumPri(
    each pressure=Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
          V_flow=m2_flow_chi_nominal/1000*pumChiVFloArr,
          dp=(dp2_chi_nominal+dp2_wse_nominal+139700+36000)*pumChiPreArr),
    each motorEfficiency=Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters(
          V_flow={0},eta=pumChietaArr))
    "Performance data for primary pumps";
  parameter Real pumChiPreArr [4]= {1.5,1.3,1.0,0.6}
    "Pressure performance data for chilled water primary pumps";
  parameter Real pumChietaArr [1]= {0.7}
    "Efficiency for chilled water primary pumps";
  parameter Real pumChiVFloArr [4]= {0.2,0.6,1.0,1.2}
    "Flow rate performance data for chilled water primary pumps";
  FaultInjection.Experimental.SystemLevelFaults.Controls.CoolingMode cooModCon(
    tWai=1200,
    deaBan1=1.1,
    deaBan2=0.5,
    deaBan3=1.1,
    deaBan4=0.5) "Cooling mode controller"
    annotation (Placement(transformation(extent={{1028,-266},{1048,-246}})));
  Modelica.Blocks.Sources.RealExpression towTApp(y=cooTow.TWatOut_nominal -
        cooTow.TAirInWB_nominal)
    "Cooling tower approach temperature"
    annotation (Placement(transformation(extent={{988,-300},{1008,-280}})));
  Modelica.Blocks.Sources.RealExpression yVal5(y=if cooModCon.y == Integer(
        FaultInjection.Experimental.SystemLevelFaults.Types.CoolingModes.FullMechanical)
         then 1 else 0)
    "On/off signal for valve 5"
    annotation (Placement(transformation(extent={{1060,-192},{1040,-172}})));
  Modelica.Blocks.Sources.RealExpression yVal6(y=if cooModCon.y == Integer(
        FaultInjection.Experimental.SystemLevelFaults.Types.CoolingModes.FreeCooling)
         then 1 else 0)
    "On/off signal for valve 6"
    annotation (Placement(transformation(extent={{1060,-208},{1040,-188}})));
  Buildings.Controls.OBC.CDL.Continuous.Product proCHWP
    annotation (Placement(transformation(extent={{1376,-260},{1396,-240}})));

  FaultInjection.Experimental.SystemLevelFaults.Controls.PlantRequest plaReqChi
    annotation (Placement(transformation(extent={{1044,-120},{1064,-100}})));
  FaultInjection.Experimental.SystemLevelFaults.Controls.ChillerPlantEnableDisable chiPlaEnaDis(
      yFanSpeMin=0.15, plaReqTim=30*60)
    annotation (Placement(transformation(extent={{1100,-120},{1120,-100}})));
  Modelica.Blocks.Math.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{1168,-126},{1188,-106}})));
  FaultInjection.Experimental.SystemLevelFaults.Controls.BoilerPlantEnableDisable boiPlaEnaDis(
    yFanSpeMin=0.15,
    plaReqTim=30*60,
    TOutPla=291.15)
    annotation (Placement(transformation(extent={{-278,-170},{-258,-150}})));
  Modelica.Blocks.Math.BooleanToReal booToReaHW
    annotation (Placement(transformation(extent={{-218,-170},{-198,-150}})));
  FaultInjection.Experimental.SystemLevelFaults.Controls.PlantRequest plaReqBoi
    annotation (Placement(transformation(extent={{-320,-170},{-300,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Product proHWVal
    annotation (Placement(transformation(extent={{36,-216},{56,-196}})));
  Buildings.Controls.OBC.CDL.Continuous.Product proCHWVal
    annotation (Placement(transformation(extent={{412,-214},{432,-194}})));
  FaultInjection.Experimental.SystemLevelFaults.Controls.MinimumFlowBypassValve
    minFloBypCHW(m_flow_minimum=0.5, k=0.1)
    "Chilled water loop minimum bypass valve control"
    annotation (Placement(transformation(extent={{1040,-160},{1060,-140}})));
  Modelica.Blocks.Sources.RealExpression yVal7(y=if cooModCon.y == Integer(
        FaultInjection.Experimental.SystemLevelFaults.Types.CoolingModes.FreeCooling)
         then 0 else minFloBypCHW.y) "On/off signal for valve 7"
    annotation (Placement(transformation(extent={{1060,-230},{1040,-210}})));
  parameter Utilities.InsertionTypes.Generic.faultMode faulttemAirEas(startTime=
       259200, endTime=864000) "East zone air temperature sensor fault"
    annotation (Placement(transformation(extent={{1100,506},{1120,526}})));
  Utilities.InsertionTypes.Variables.SignalDelay.RealFixedDelay yPumDel(
      delayTime=1, faultMode=faultyPumDel)
    "Chilled water pump  input signal delay"
    annotation (Placement(transformation(extent={{1414,-256},{1434,-236}})));
  parameter Utilities.InsertionTypes.Generic.faultMode faultyPumDel(startTime=
        17625600, endTime=18230400)
    "Chilled water pump input signal delay fault"
    annotation (Placement(transformation(extent={{1414,-214},{1434,-194}})));
  parameter Utilities.InsertionTypes.Generic.faultMode faulttemAirSou(startTime=
       259200, endTime=864000) "South zone air temperature sensor fault"
    annotation (Placement(transformation(extent={{1100,544},{1120,564}})));
equation

  connect(fanSup.y_actual, chiPlaEnaDis.yFanSpe) annotation (Line(points={{321,
          -33},{332,-33},{332,-22},{1080,-22},{1080,-117},{1099,-117}}, color={
          0,0,127}));
  connect(chiWSE.TCHWSupWSE,cooModCon. TCHWSupWSE)
    annotation (Line(
      points={{673,-212},{666,-212},{666,-76},{1016,-76},{1016,-260.444},{1026,
          -260.444}},
      color={0,0,127}));
  connect(towTApp.y,cooModCon. TApp)
    annotation (Line(
      points={{1009,-290},{1018,-290},{1018,-257.111},{1026,-257.111}},
      color={0,0,127}));
  connect(cooModCon.TCHWRetWSE, TCHWRet.T)
    annotation (Line(
      points={{1026,-263.778},{1014,-263.778},{1014,-66},{608,-66},{608,-177}},
    color={0,0,127}));
  connect(cooModCon.y, chiStaCon.cooMod)
    annotation (Line(
      points={{1049,-254.889},{1072,-254.889},{1072,-66},{1270,-66},{1270,-122},
          {1284,-122}},
      color={255,127,0}));
  connect(cooModCon.y,intToBoo.u)
    annotation (Line(
      points={{1049,-254.889},{1072,-254.889},{1072,-66},{1270,-66},{1270,-154},
          {1284,-154}},
      color={255,127,0}));
  connect(cooModCon.y, cooTowSpeCon.cooMod) annotation (Line(points={{1049,
          -254.889},{1072,-254.889},{1072,-66},{1270,-66},{1270,-93.5556},{1284,
          -93.5556}},                                color={255,127,0}));
  connect(cooModCon.y, CWPumCon.cooMod) annotation (Line(points={{1049,-254.889},
          {1072,-254.889},{1072,-66},{1270,-66},{1270,-201},{1282,-201}},
                                          color={255,127,0}));
  connect(yVal5.y, chiWSE.yVal5) annotation (Line(points={{1039,-182},{864,-182},
          {864,-211},{695.6,-211}},
                              color={0,0,127}));
  connect(yVal6.y, chiWSE.yVal6) annotation (Line(points={{1039,-198},{862,-198},
          {862,-207.8},{695.6,-207.8}},
                                  color={0,0,127}));
  connect(watVal.port_a, cooCoi.port_b1) annotation (Line(points={{538,-98},{538,
          -86},{182,-86},{182,-52},{190,-52}},
                           color={0,127,255},
      thickness=0.5));
  connect(cooCoi.port_a1, TCHWSup.port_b) annotation (Line(points={{210,-52},{220,
          -52},{220,-78},{642,-78},{642,-128},{758,-128}},
                                       color={0,127,255},
      thickness=0.5));
  connect(weaBus.TWetBul, cooModCon.TWetBul) annotation (Line(
      points={{-320,180},{-320,22},{436,22},{436,-60},{1008,-60},{1008,-253.778},
          {1026,-253.778}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.TWetBul, cooTow.TAir) annotation (Line(
      points={{-320,180},{-320,24},{434,24},{434,-60},{724,-60},{724,-312},{736,
          -312}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TCWSup.T, cooTowSpeCon.TCWSup) annotation (Line(points={{828,-305},{
          828,-64},{1274,-64},{1274,-100.667},{1284,-100.667}},
        color={0,0,127}));
  connect(TCHWSup.T, cooTowSpeCon.TCHWSup) annotation (Line(points={{768,-117},
          {768,-64},{1272,-64},{1272,-104.222},{1284,-104.222}},
                            color={0,0,127}));
  connect(pumSpe.y, proCHWP.u2) annotation (Line(points={{1361,-248},{1366,-248},
          {1366,-256},{1374,-256}},
                                 color={0,0,127}));
  connect(cooModCon.y, temDifPreRes.uOpeMod) annotation (Line(points={{1049,
          -254.889},{1072,-254.889},{1072,-236},{1190,-236}},
        color={255,127,0}));
  connect(TOut.y, chiPlaEnaDis.TOut) annotation (Line(points={{-279,180},{1078,
          180},{1078,-105.4},{1098,-105.4}},
                                         color={0,0,127}));
  connect(chiPlaEnaDis.ySupFan, conAHU.ySupFan) annotation (Line(points={{1098,
          -110},{1076,-110},{1076,629.333},{424,629.333}},             color={
          255,0,255}));
  connect(cooModCon.yPla, chiPlaEnaDis.yPla) annotation (Line(points={{1026,
          -247.333},{1022,-247.333},{1022,-70},{1142,-70},{1142,-110},{1121,
          -110}}, color={255,0,255}));
  connect(gai.y, pumCW.y) annotation (Line(points={{1347,-206},{1400,-206},{1400,
          -342},{880,-342},{880,-288},{898,-288}}, color={0,0,127}));
  connect(cooTowSpeCon.y, cooTow.y) annotation (Line(points={{1307,-97.1111},{
          1402,-97.1111},{1402,-344},{722,-344},{722,-308},{736,-308}},
                                                                      color={0,
          0,127}));
  connect(chiOn.y, chiWSE.on[1]) annotation (Line(points={{1347,-128},{1404,
          -128},{1404,-338},{868,-338},{868,-215.6},{695.6,-215.6}},
                                                            color={255,0,255}));
  connect(chiPlaEnaDis.yPla, booToRea.u)
    annotation (Line(points={{1121,-110},{1142,-110},{1142,-116},{1166,-116}},
                                                       color={255,0,255}));
  connect(booToRea.y, proCHWP.u1) annotation (Line(points={{1189,-116},{1246,-116},
          {1246,-64},{1368,-64},{1368,-244},{1374,-244}},
                  color={0,0,127}));
  connect(booToRea.y, val.y) annotation (Line(points={{1189,-116},{1246,-116},{
          1246,-174},{1408,-174},{1408,-342},{620,-342},{620,-296},{646,-296},{
          646,-304}},                                             color={0,0,
          127}));
  connect(conAHU.ySupFan, andFreSta.u2) annotation (Line(points={{424,629.333},
          {436,629.333},{436,652},{-50,652},{-50,-138},{-22,-138}},
                      color={255,0,255}));
  connect(heaCoi.port_b1, HWVal.port_a)
    annotation (Line(points={{98,-52},{98,-170},{98,-170}},color={238,46,47},
      thickness=0.5));
  connect(boiPlaEnaDis.yPla, booToReaHW.u)
    annotation (Line(points={{-257,-160},{-220,-160}}, color={255,0,255}));
  connect(booToReaHW.y, boiIsoVal.y) annotation (Line(points={{-197,-160},{-182,
          -160},{-182,-360},{242,-360},{242,-300},{292,-300},{292,-308}},
                             color={0,0,127}));
  connect(booToReaHW.y, proPumHW.u1) annotation (Line(points={{-197,-160},{-178,
          -160},{-178,-72},{-98,-72},{-98,-210},{-42,-210},{-42,-308},{-34,-308}},
                                        color={0,0,127}));
  connect(booToReaHW.y, proBoi.u1) annotation (Line(points={{-197,-160},{-184,-160},
          {-184,-82},{-96,-82},{-96,-208},{-40,-208},{-40,-266},{-34,-266}},
                                        color={0,0,127}));
  connect(boiPlaEnaDis.yPla, pumSpeHW.trigger) annotation (Line(points={{-257,
          -160},{-240,-160},{-240,-82},{-92,-82},{-92,-338},{-68,-338},{-68,
          -332}},                                               color={255,0,
          255}));
  connect(boiPlaEnaDis.yPla, minFloBypHW.yPla) annotation (Line(points={{-257,
          -160},{-240,-160},{-240,-80},{-92,-80},{-92,-251},{-76,-251}},
                                                          color={255,0,255}));
  connect(cooModCon.yPla, pumSpe.trigger) annotation (Line(points={{1026,
          -247.333},{1022,-247.333},{1022,-336},{1342,-336},{1342,-260}}, color=
         {255,0,255}));
  connect(wseOn.y, chiWSE.on[2]) annotation (Line(points={{1347,-154},{1406,
          -154},{1406,-338},{866,-338},{866,-215.6},{695.6,-215.6}},
                                                            color={255,0,255}));
  connect(boiPlaEnaDis.yPla, boiTSup.trigger) annotation (Line(points={{-257,
          -160},{-238,-160},{-238,-78},{-92,-78},{-92,-292},{-72,-292},{-72,
          -290}},                                               color={255,0,
          255}));
  connect(plaReqChi.yPlaReq, chiPlaEnaDis.yPlaReq) annotation (Line(points={{1065,
          -110},{1072,-110},{1072,-114},{1098,-114}},      color={255,127,0}));
  connect(swiFreSta.y, plaReqBoi.uPlaVal) annotation (Line(points={{42,-130},{58,
          -130},{58,-70},{-250,-70},{-250,-120},{-340,-120},{-340,-160},{-322,-160}},
                                                                   color={0,0,
          127}));
  connect(minFloBypHW.y, valBypBoi.y) annotation (Line(points={{-53,-248},{-44,-248},
          {-44,-358},{178,-358},{178,-230},{230,-230},{230,-240}},
                                                   color={0,0,127}));
  connect(plaReqBoi.yPlaReq, boiPlaEnaDis.yPlaReq) annotation (Line(points={{-299,
          -160},{-290,-160},{-290,-164},{-280,-164}},      color={255,127,0}));
  connect(boiPlaEnaDis.yPla, triResHW.uDevSta) annotation (Line(points={{-257,
          -160},{-242,-160},{-242,-84},{-188,-84},{-188,-220},{-184,-220},{-184,
          -219}},                                     color={255,0,255}));
  connect(TOut.y, boiPlaEnaDis.TOut) annotation (Line(points={{-279,180},{-260,
          180},{-260,-68},{-252,-68},{-252,-118},{-288,-118},{-288,-155.4},{
          -280,-155.4}},
        color={0,0,127}));
  connect(conAHU.ySupFan, boiPlaEnaDis.ySupFan) annotation (Line(points={{424,
          629.333},{436,629.333},{436,652},{-258,652},{-258,-116},{-292,-116},{
          -292,-160},{-280,-160}},
                        color={255,0,255}));
  connect(booToReaHW.y, proHWVal.u2) annotation (Line(points={{-197,-160},{-2,
          -160},{-2,-212},{34,-212}}, color={0,0,127}));
  connect(proHWVal.y, HWVal.y) annotation (Line(points={{58,-206},{68,-206},{
          68,-180},{86.2,-180}},
                            color={0,0,127}));
  connect(proHWVal.u1, swiFreSta.y) annotation (Line(points={{34,-200},{24,-200},
          {24,-150},{56,-150},{56,-130},{42,-130}}, color={0,0,127}));
  connect(proCHWVal.y, watVal.y) annotation (Line(points={{434,-204},{488,-204},
          {488,-108},{526.2,-108}}, color={0,0,127}));
  connect(booToRea.y, proCHWVal.u2) annotation (Line(points={{1189,-116},{1226,
          -116},{1226,-68},{380,-68},{380,-210},{410,-210}}, color={0,0,127}));
  connect(watVal.y_actual, temDifPreRes.u) annotation (Line(points={{530.8,-113},
          {530.8,-232},{874,-232},{874,-336},{1170,-336},{1170,-242},{1190,-242}},
        color={0,0,127}));
  connect(fanSup.y_actual, boiPlaEnaDis.yFanSpe) annotation (Line(points={{321,-33},
          {324,-33},{324,-16},{158,-16},{158,28},{20,28},{20,-62},{-254,-62},{
          -254,-112},{-294,-112},{-294,-167},{-279,-167}},       color={0,0,127}));
  connect(minFloBypCHW.m_flow, chiWSE.mCHW_flow) annotation (Line(points={{1038,
          -147},{1012,-147},{1012,-178},{668,-178},{668,-206},{673,-206}},
        color={0,0,127}));
  connect(chiPlaEnaDis.yPla, minFloBypCHW.yPla) annotation (Line(points={{1121,
          -110},{1142,-110},{1142,-128},{1024,-128},{1024,-153},{1038,-153}},
        color={255,0,255}));
  connect(yVal7.y, chiWSE.yVal7) annotation (Line(points={{1039,-220},{862,-220},
          {862,-200.4},{695.6,-200.4}}, color={0,0,127}));
  connect(maxCHWTSupSet.y, cooTowSpeCon.TCHWSupSet) annotation (Line(points={{1261,
          -270},{1268,-270},{1268,-97.1111},{1284,-97.1111}},      color={235,0,
          0}));
  connect(maxCHWTSupSet.y, chiWSE.TSet) annotation (Line(points={{1261,-270},{
          1268,-270},{1268,-340},{702,-340},{702,-218.8},{695.6,-218.8}}, color=
         {235,0,0}));
  connect(maxCHWTSupSet.y, cooModCon.TCHWSupSet) annotation (Line(points={{1261,
          -270},{1266,-270},{1266,-334},{1020,-334},{1020,-250.222},{1026,
          -250.222}}, color={235,0,0}));
  connect(yCooDel.y, proCHWVal.u1) annotation (Line(points={{481,482},{492,482},
          {492,462},{440,462},{440,36},{382,36},{382,-198},{410,-198}}, color={
          235,0,0}));
  connect(yCooDel.y, plaReqChi.uPlaVal) annotation (Line(points={{481,482},{488,
          482},{488,466},{448,466},{448,30},{384,30},{384,-72},{998,-72},{998,
          -110},{1042,-110}}, color={235,0,0}));
  connect(proCHWP.y, yPumDel.u) annotation (Line(points={{1398,-250},{1406,-250},
          {1406,-246},{1412,-246}}, color={0,0,127}));
  connect(yPumDel.y, chiWSE.yPum[1]) annotation (Line(points={{1435,-246},{1436,
          -246},{1436,-344},{704,-344},{704,-203.6},{695.6,-203.6}}, color={235,
          0,0}));
  connect(heaCoi.port_a1, resHW.port_b) annotation (Line(
      points={{118,-52},{140,-52},{140,-140},{350,-140},{350,-218},{350,-218}},
      color={238,46,47},
      thickness=0.5));

   annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-400,-400},{1440,
            750}})),
experiment(
      StartTime=259200,
      StopTime=864000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://FaultInjection/Resources/Scripts/dymola/Systems/PhysicalFault/Chicago/HeatingSeason/BaselineSystem.mos"
        "Simulate and Plot"));
end BaselineSystem;
