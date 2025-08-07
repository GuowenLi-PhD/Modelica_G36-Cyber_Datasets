within FaultInjection.Experimental.Regulation;
model System "System example for fault injection"
  extends Modelica.Icons.Example;
  extends
    FaultInjection.Experimental.Regulation.BaseClasses.PartialHotWaterside(
    final Q_flow_boi_nominal=designHeatLoad,
    minFloBypHW(k=0.1, Ti=600),
    pumSpeHW(reset=Buildings.Types.Reset.Parameter, y_reset=0),
    boiTSup(
      y_start=0,
      reset=Buildings.Types.Reset.Parameter,
      y_reset=0),
    boi(show_T=false),
    triResHW(TMin=313.15, TMax=321.15));
  extends FaultInjection.Experimental.Regulation.BaseClasses.PartialAirside(
    fanSup(show_T=false),
    conAHU(
      pNumIgnReq=1,
      TSupSetMin=284.95,
      numIgnReqSupTem=1,
      kTSup=0.5,
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
      sysReq(gai1(k=0.7), gai2(k=0.9))));
  extends FaultInjection.Experimental.Regulation.BaseClasses.PartialWaterside(
    redeclare
      Buildings.Applications.DataCenters.ChillerCooled.Equipment.IntegratedPrimaryLoadSide
      chiWSE(addPowerToMedium=false, perPum=perPumPri),
    watVal(
      redeclare package Medium = MediumW,
      m_flow_nominal=m1_flow_chi_nominal,
      dpValve_nominal=6000,
      riseTime=60),
    final QEva_nominal=designCoolLoad,
    pumCW(use_inputFilter=true),
    resCHW(dp_nominal=139700),
    temDifPreRes(
      samplePeriod(displayUnit="s"),
      uTri=0.9,
      dpMin=0.5*dpSetPoi,
      dpMax=dpSetPoi,
      TMin(displayUnit="degC") = 278.15,
      TMax(displayUnit="degC") = 283.15),
    pumSpe(yMin=0.2));

  parameter Buildings.Fluid.Movers.Data.Generic[numChi] perPumPri(
    each pressure=Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
          V_flow=m2_flow_chi_nominal/1000*{0.2,0.6,1.0,1.2},
          dp=(dp2_chi_nominal+dp2_wse_nominal+139700+36000)*{1.5,1.3,1.0,0.6}))
    "Performance data for primary pumps";

  Controls.CoolingMode
    cooModCon(
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
        FaultInjection.Experimental.Regulation.Types.CoolingModes.FullMechanical)
         then 1 else 0)
    "On/off signal for valve 5"
    annotation (Placement(transformation(extent={{1062,-192},{1042,-172}})));
  Modelica.Blocks.Sources.RealExpression yVal6(y=if cooModCon.y == Integer(
        FaultInjection.Experimental.Regulation.Types.CoolingModes.FreeCooling)
         then 1 else 0)
    "On/off signal for valve 6"
    annotation (Placement(transformation(extent={{1062,-208},{1042,-188}})));
  Buildings.Controls.OBC.CDL.Continuous.Product proCHWP
    annotation (Placement(transformation(extent={{1376,-260},{1396,-240}})));

  Controls.PlantRequest plaReqChi
    annotation (Placement(transformation(extent={{1044,-120},{1064,-100}})));
  Controls.ChillerPlantEnableDisable chiPlaEnaDis(plaReqTim=30*60)
    annotation (Placement(transformation(extent={{1100,-120},{1120,-100}})));
  Modelica.Blocks.Math.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{1168,-126},{1188,-106}})));
  Controls.BoilerPlantEnableDisable boiPlaEnaDis(plaReqTim=10*60, TOutPla=
        291.15)
    annotation (Placement(transformation(extent={{-278,-170},{-258,-150}})));
  Modelica.Blocks.Math.BooleanToReal booToReaHW
    annotation (Placement(transformation(extent={{-218,-170},{-198,-150}})));
  Controls.PlantRequest plaReqBoi
    annotation (Placement(transformation(extent={{-320,-170},{-300,-150}})));
  Modelica.Blocks.Sources.RealExpression rea(y=fanSup.P + chiWSE.powChi[1] +
        chiWSE.powPum[1] + cooTow.PFan + pumCW.P)
    annotation (Placement(transformation(extent={{1360,-2},{1380,18}})));
  Modelica.Blocks.Interfaces.RealOutput PSys "Value of Real output"
    annotation (Placement(transformation(extent={{1392,-2},{1412,18}})));
  Modelica.Blocks.Interfaces.RealOutput TZonAir[5] "Room air temperatures"
    annotation (Placement(transformation(extent={{1430,480},{1450,500}})));
equation

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
  connect(yVal5.y, chiWSE.yVal5) annotation (Line(points={{1041,-182},{864,-182},
          {864,-211},{695.6,-211}},
                              color={0,0,127}));
  connect(yVal6.y, chiWSE.yVal6) annotation (Line(points={{1041,-198},{862,-198},
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
  connect(proCHWP.y, chiWSE.yPum[1]) annotation (Line(points={{1398,-250},{1404,
          -250},{1404,-340},{704,-340},{704,-203.6},{695.6,-203.6}},
                                        color={0,0,127}));
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
  connect(conAHU.yCoo, watVal.y) annotation (Line(points={{424,544},{430,544},{430,
          -108},{526,-108}},                     color={0,0,127}));
  connect(pumSpe.y, proCHWP.u2) annotation (Line(points={{1361,-248},{1366,-248},
          {1366,-256},{1374,-256}},
                                 color={0,0,127}));
  connect(watVal.y_actual, temDifPreRes.u) annotation (Line(points={{531,-113},{
          530,-113},{530,-122},{518,-122},{518,-72},{964,-72},{964,-244},{1194,-244}},
                                                          color={0,0,127}));
  connect(cooModCon.y, temDifPreRes.uOpeMod) annotation (Line(points={{1049,
          -254.889},{1072,-254.889},{1072,-238},{1194,-238}},
        color={255,127,0}));
  connect(temDifPreRes.TSet, cooModCon.TCHWSupSet) annotation (Line(points={{1217,
          -249},{1218,-249},{1218,-250},{1232,-250},{1232,-70},{1018,-70},{1018,
          -250.222},{1026,-250.222}},
                                    color={0,0,127}));
  connect(temDifPreRes.TSet, chiWSE.TSet) annotation (Line(points={{1217,-249},{
          1218,-249},{1218,-250},{1232,-250},{1232,-338},{704,-338},{704,-218.8},
          {695.6,-218.8}},         color={0,0,127}));
  connect(temDifPreRes.TSet, cooTowSpeCon.TCHWSupSet) annotation (Line(points={{1217,
          -249},{1218,-249},{1218,-250},{1232,-250},{1232,-70},{1268,-70},{1268,
          -97.1111},{1284,-97.1111}},             color={0,0,127}));
  connect(TOut.y, chiPlaEnaDis.TOut) annotation (Line(points={{-279,180},{1078,180},
          {1078,-106},{1098,-106}},      color={0,0,127}));
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
  connect(chiOn.y, chiWSE.on[1]) annotation (Line(points={{1347,-128},{1408,-128},
          {1408,-338},{868,-338},{868,-215.6},{695.6,-215.6}},
                                                            color={255,0,255}));
  connect(chiPlaEnaDis.yPla, booToRea.u)
    annotation (Line(points={{1121,-110},{1142,-110},{1142,-116},{1166,-116}},
                                                       color={255,0,255}));
  connect(booToRea.y, proCHWP.u1) annotation (Line(points={{1189,-116},{1246,-116},
          {1246,-64},{1368,-64},{1368,-244},{1374,-244}},
                  color={0,0,127}));
  connect(booToRea.y, val.y) annotation (Line(points={{1189,-116},{1246,-116},{1246,
          -174},{1420,-174},{1420,-342},{620,-342},{620,-296},{646,-296},{646,-304}},
                                                                  color={0,0,
          127}));
  connect(conAHU.ySupFan, andFreSta.u2) annotation (Line(points={{424,629.333},
          {436,629.333},{436,652},{-50,652},{-50,-138},{-22,-138}},
                      color={255,0,255}));
  connect(heaCoi.port_b1, HWVal.port_a)
    annotation (Line(points={{98,-52},{98,-170},{98,-170}},color={238,46,47},
      thickness=0.5));
  connect(swiFreSta.y, HWVal.y) annotation (Line(points={{42,-130},{58,-130},{58,
          -180},{86,-180}},                        color={0,0,127}));
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
  connect(boiPlaEnaDis.yPla, pumSpeHW.trigger) annotation (Line(points={{-257,-160},
          {-240,-160},{-240,-82},{-92,-82},{-92,-338},{-68,-338},{-68,-332}},
                                                                color={255,0,
          255}));
  connect(boiPlaEnaDis.yPla, minFloBypHW.yPlaBoi) annotation (Line(points={{-257,
          -160},{-240,-160},{-240,-80},{-92,-80},{-92,-251},{-76,-251}},
                                                          color={255,0,255}));
  connect(cooModCon.yPla, pumSpe.trigger) annotation (Line(points={{1026,
          -247.333},{1022,-247.333},{1022,-336},{1342,-336},{1342,-260}}, color=
         {255,0,255}));
  connect(THWSup.port_a, heaCoi.port_a1) annotation (Line(points={{350,-214},{350,
          -140},{142,-140},{142,-52},{118,-52}},     color={238,46,47},
      thickness=0.5));
  connect(wseOn.y, chiWSE.on[2]) annotation (Line(points={{1347,-154},{1408,-154},
          {1408,-338},{866,-338},{866,-215.6},{695.6,-215.6}},
                                                            color={255,0,255}));
  connect(boiPlaEnaDis.yPla, boiTSup.trigger) annotation (Line(points={{-257,-160},
          {-238,-160},{-238,-78},{-92,-78},{-92,-292},{-72,-292},{-72,-290}},
                                                                color={255,0,
          255}));
  connect(plaReqChi.yPlaReq, chiPlaEnaDis.yPlaReq) annotation (Line(points={{1065,
          -110},{1072,-110},{1072,-114},{1098,-114}},      color={255,127,0}));
  connect(watVal.y_actual, plaReqChi.uPlaVal) annotation (Line(points={{531,-113},
          {531,-122},{518,-122},{518,-70},{962,-70},{962,-110},{1042,-110}},
                                                           color={0,0,127}));
  connect(swiFreSta.y, plaReqBoi.uPlaVal) annotation (Line(points={{42,-130},{58,
          -130},{58,-70},{-250,-70},{-250,-120},{-340,-120},{-340,-160},{-322,-160}},
                                                                   color={0,0,
          127}));
  connect(minFloBypHW.y, valBypBoi.y) annotation (Line(points={{-53,-248},{-44,-248},
          {-44,-358},{178,-358},{178,-230},{230,-230},{230,-240}},
                                                   color={0,0,127}));
  connect(plaReqBoi.yPlaReq, boiPlaEnaDis.yPlaReq) annotation (Line(points={{-299,
          -160},{-290,-160},{-290,-164},{-280,-164}},      color={255,127,0}));
  connect(boiPlaEnaDis.yPla, triResHW.uDevSta) annotation (Line(points={{-257,-160},
          {-240,-160},{-240,-80},{-182,-80},{-182,-221},{-160,-221}},
                                                      color={255,0,255}));
  connect(TOut.y, boiPlaEnaDis.TOut) annotation (Line(points={{-279,180},{-260,180},
          {-260,-68},{-252,-68},{-252,-118},{-288,-118},{-288,-156},{-280,-156}},
        color={0,0,127}));
  connect(conAHU.ySupFan, boiPlaEnaDis.ySupFan) annotation (Line(points={{424,
          629.333},{436,629.333},{436,652},{-258,652},{-258,-116},{-292,-116},{
          -292,-160},{-280,-160}},
                        color={255,0,255}));
  connect(rea.y, PSys)
    annotation (Line(points={{1381,8},{1402,8}}, color={0,0,127}));
  connect(flo.TRooAir, TZonAir) annotation (Line(points={{1094.14,491.333},{
          1440,491.333},{1440,490}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-400,-400},{1440,
            750}})),
    experiment(
      StartTime=17625600,
      StopTime=18230400,
      __Dymola_Algorithm="Cvode"));
end System;
