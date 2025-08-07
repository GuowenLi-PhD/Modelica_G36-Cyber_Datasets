within ;
package template "Modelica template for overwrting signals"

  model BaselineSystem "System example for fault injection"
    extends Modelica.Icons.Example;
    extends template.BaseClasses.PartialHotWaterside(
      final Q_flow_boi_nominal=designHeatLoad,
      minFloBypHW(k=0.1),
      pumSpeHW(reset=Buildings.Types.Reset.Parameter, y_reset=0),
      boiTSup(
        y_start=0,
        reset=Buildings.Types.Reset.Parameter,
        y_reset=0),
      boi(show_T=false),
      triResHW(TMin=313.15, TMax=321.15));
    extends template.BaseClasses.PartialAirside(
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
        sysReq(gai1(k=0.7), gai2(k=0.9))),
      flo(
        cor(T_start=273.15 + 24),
        sou(T_start=273.15 + 24),
        eas(T_start=273.15 + 24),
        wes(T_start=273.15 + 24),
        nor(T_start=273.15 + 24)),
      TCooOn=oveTCooOn.p);
    extends template.BaseClasses.PartialWaterside(
      redeclare
        FaultInjection.Experimental.SystemLevelFaults.BaseClasses.IntegratedPrimaryLoadSide
        chiWSE(
        use_inputFilter=true,
        T2_start=283.15,
        addPowerToMedium=false,
        perPum=perPumPri),
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
      pumSpe(yMin=0.2),
      TCHWSup(T_start=283.15));

    extends template.BaseClasses.EnergyMeter(
      eleCoiVAV(y=cor.terHea.Q1_flow + nor.terHea.Q1_flow + wes.terHea.Q1_flow
             + eas.terHea.Q1_flow + sou.terHea.Q1_flow),
      eleSupFan(y=fanSup.P),
      eleChi(y=chiWSE.powChi[1]),
      eleCHWP(y=chiWSE.powPum[1]),
      eleCWP(y=pumCW.P),
      eleHWP(y=pumHW.P),
      eleCT(y=cooTow.PFan),
      gasBoi(y=boi.QFue_flow));

   extends template.BaseClasses.RunTime;

    parameter Buildings.Fluid.Movers.Data.Generic[numChi] perPumPri(
      each pressure=Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
            V_flow=m2_flow_chi_nominal/1000*{0.2,0.6,1.0,1.2},
            dp=(dp2_chi_nominal+dp2_wse_nominal+139700+36000)*{1.5,1.3,1.0,0.6}))
      "Performance data for primary pumps";

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
    FaultInjection.Experimental.SystemLevelFaults.Controls.ChillerPlantEnableDisable
      chiPlaEnaDis(yFanSpeMin=0.15,
                   plaReqTim=30*60)
      annotation (Placement(transformation(extent={{1100,-120},{1120,-100}})));
    Modelica.Blocks.Math.BooleanToReal booToRea
      annotation (Placement(transformation(extent={{1168,-126},{1188,-106}})));
    FaultInjection.Experimental.SystemLevelFaults.Controls.BoilerPlantEnableDisable
      boiPlaEnaDis(
      yFanSpeMin=0.15,
      plaReqTim=30*60,
      TOutPla=291.15)
      annotation (Placement(transformation(extent={{-278,-170},{-258,-150}})));
    Modelica.Blocks.Math.BooleanToReal booToReaHW
      annotation (Placement(transformation(extent={{-218,-170},{-198,-150}})));
    FaultInjection.Experimental.SystemLevelFaults.Controls.PlantRequest plaReqBoi
      annotation (Placement(transformation(extent={{-320,-170},{-300,-150}})));
    Buildings.Controls.OBC.CDL.Continuous.Product proHWVal
      annotation (Placement(transformation(extent={{40,-190},{60,-170}})));
    Buildings.Controls.OBC.CDL.Continuous.Product proCHWVal
      annotation (Placement(transformation(extent={{468,-118},{488,-98}})));

    FaultInjection.Experimental.SystemLevelFaults.Controls.MinimumFlowBypassValve
      minFloBypCHW(m_flow_minimum=0.5, k=0.1)
      "Chilled water loop minimum bypass valve control"
      annotation (Placement(transformation(extent={{1040,-160},{1060,-140}})));
    Modelica.Blocks.Sources.RealExpression yVal7(y=if cooModCon.y == Integer(
          FaultInjection.Experimental.SystemLevelFaults.Types.CoolingModes.FreeCooling)
           then 0 else minFloBypCHW.y) "On/off signal for valve 7"
      annotation (Placement(transformation(extent={{1060,-230},{1040,-210}})));

    Modelica.Blocks.Math.BooleanToReal booToReaSupFan
      annotation (Placement(transformation(extent={{1220,642},{1240,662}})));
    Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold=
         0.01)
      annotation (Placement(transformation(extent={{1220,688},{1240,708}})));
    Modelica.Blocks.Math.BooleanToReal booToReaCT
      annotation (Placement(transformation(extent={{1254,688},{1274,708}})));

    FaultInjection.Utilities.Overwrite.OverwriteParameter oveTCooOn(
      p_min=291.15,
      p_max=303.15,
      unit="K",
      p=297.15,
      description=
          "Zone temperature setpoint during cooling on")
      "Overwrite parameter TCooOn"
      annotation (Placement(transformation(extent={{58,334},{78,354}})));
    FaultInjection.Utilities.Overwrite.OverwriteVariable oveChiOn(
      u(unit="1",min=0,max=1),
      description="Chiller on signal")
      "Overwrite chiller on/off signal"
      annotation (Placement(transformation(extent={{1326,-118},{1346,-98}})));
    FaultInjection.Utilities.Overwrite.OverwriteVariable oveSupFanSpe(u(
        unit="1",
        min=0,
        max=1), description="Supply air fan speed")
      annotation (Placement(transformation(extent={{460,608},{480,628}})));
  equation

    connect(chiWSE.TCHWSupWSE,cooModCon. TCHWSupWSE)
      annotation (Line(
        points={{673,-212},{666,-212},{666,-76},{1016,-76},{1016,-260.444},{
            1026,-260.444}},
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
        points={{1049,-254.889},{1072,-254.889},{1072,-66},{1270,-66},{1270,
            -122},{1284,-122}},
        color={255,127,0}));
    connect(cooModCon.y,intToBoo.u)
      annotation (Line(
        points={{1049,-254.889},{1072,-254.889},{1072,-66},{1270,-66},{1270,
            -154},{1284,-154}},
        color={255,127,0}));
    connect(cooModCon.y, cooTowSpeCon.cooMod) annotation (Line(points={{1049,
            -254.889},{1072,-254.889},{1072,-66},{1270,-66},{1270,-93.5556},{
            1284,-93.5556}},                           color={255,127,0}));
    connect(cooModCon.y, CWPumCon.cooMod) annotation (Line(points={{1049,
            -254.889},{1072,-254.889},{1072,-66},{1270,-66},{1270,-201},{1282,
            -201}},                         color={255,127,0}));
    connect(yVal5.y, chiWSE.yVal5) annotation (Line(points={{1039,-182},{864,-182},
            {864,-211},{695.6,-211}},
                                color={0,0,127}));
    connect(yVal6.y, chiWSE.yVal6) annotation (Line(points={{1039,-198},{866,-198},
            {866,-207.8},{695.6,-207.8}}, color={0,0,127}));
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
        points={{-320,180},{-320,22},{436,22},{436,-60},{1008,-60},{1008,
            -253.778},{1026,-253.778}},
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
    connect(TCWSup.T, cooTowSpeCon.TCWSup) annotation (Line(points={{828,-305},
            {828,-64},{1274,-64},{1274,-100.667},{1284,-100.667}},
          color={0,0,127}));
    connect(TCHWSup.T, cooTowSpeCon.TCHWSup) annotation (Line(points={{768,-117},
            {768,-64},{1272,-64},{1272,-104.222},{1284,-104.222}},
                              color={0,0,127}));
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
            -249},{1218,-249},{1218,-250},{1232,-250},{1232,-70},{1018,-70},{
            1018,-250.222},{1026,-250.222}},
                                      color={0,0,127}));
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
    connect(cooTowSpeCon.y, cooTow.y) annotation (Line(points={{1307,-97.1111},
            {1402,-97.1111},{1402,-344},{722,-344},{722,-308},{736,-308}},
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
    connect(boiPlaEnaDis.yPla, minFloBypHW.yPla) annotation (Line(points={{-257,
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
    connect(TOut.y, boiPlaEnaDis.TOut) annotation (Line(points={{-279,180},{-260,
            180},{-260,-68},{-252,-68},{-252,-118},{-288,-118},{-288,-155.4},{
            -280,-155.4}},
          color={0,0,127}));
    connect(conAHU.ySupFan, boiPlaEnaDis.ySupFan) annotation (Line(points={{424,
            629.333},{436,629.333},{436,652},{-258,652},{-258,-116},{-292,-116},
            {-292,-160},{-280,-160}},
                          color={255,0,255}));
    connect(swiFreSta.y, proHWVal.u1) annotation (Line(points={{42,-130},{48,-130},
            {48,-156},{22,-156},{22,-174},{38,-174}}, color={0,0,127}));
    connect(proHWVal.y, HWVal.y)
      annotation (Line(points={{62,-180},{86,-180}}, color={0,0,127}));
    connect(booToReaHW.y, proHWVal.u2) annotation (Line(points={{-197,-160},{-94,-160},
            {-94,-186},{38,-186}}, color={0,0,127}));
    connect(proCHWVal.y, watVal.y)
      annotation (Line(points={{490,-108},{526,-108}}, color={0,0,127}));
    connect(booToRea.y, proCHWVal.u2) annotation (Line(points={{1189,-116},{1228,-116},
            {1228,-74},{436,-74},{436,-114},{466,-114}}, color={0,0,127}));
    connect(plaReqChi.uPlaVal, conAHU.yCoo) annotation (Line(points={{1042,-110},{
            1016,-110},{1016,-72},{388,-72},{388,44},{448,44},{448,544},{424,544}},
          color={0,0,127}));
    connect(conAHU.yCoo, proCHWVal.u1) annotation (Line(points={{424,544},{450,544},
            {450,-102},{466,-102}}, color={0,0,127}));
    connect(fanSup.y_actual, chiPlaEnaDis.yFanSpe) annotation (Line(points={{321,
            -33},{382,-33},{382,-68},{1080,-68},{1080,-117},{1099,-117}}, color={
            0,0,127}));
    connect(fanSup.y_actual, boiPlaEnaDis.yFanSpe) annotation (Line(points={{321,
            -33},{384,-33},{384,28},{16,28},{16,-66},{-256,-66},{-256,-124},{-294,
            -124},{-294,-167},{-279,-167}}, color={0,0,127}));
    connect(minFloBypCHW.m_flow, chiWSE.mCHW_flow) annotation (Line(points={{1038,
            -147},{1012,-147},{1012,-178},{668,-178},{668,-206},{673,-206}},
          color={0,0,127}));
    connect(chiPlaEnaDis.yPla, minFloBypCHW.yPla) annotation (Line(points={{1121,
            -110},{1142,-110},{1142,-128},{1024,-128},{1024,-153},{1038,-153}},
          color={255,0,255}));
    connect(yVal7.y, chiWSE.yVal7) annotation (Line(points={{1039,-220},{862,-220},
            {862,-200.4},{695.6,-200.4}}, color={0,0,127}));

    connect(booToReaHW.y, boiRunTim.u) annotation (Line(points={{-197,-160},{-188,
            -160},{-188,676},{1322,676},{1322,610},{1338,610}}, color={0,0,127}));
    connect(conAHU.ySupFan, booToReaSupFan.u) annotation (Line(points={{424,
            629.333},{1076,629.333},{1076,652},{1218,652}}, color={255,0,255}));
    connect(booToReaSupFan.y, supFanRunTim.u) annotation (Line(points={{1241,652},
            {1318,652},{1318,580},{1338,580}}, color={0,0,127}));
    connect(gai.y, CWPRunTim.u) annotation (Line(points={{1347,-206},{1400,-206},
            {1400,460},{1380,460},{1380,610},{1398,610}}, color={0,0,127}));
    connect(proCHWP.u1, CHWPRunTim.u) annotation (Line(points={{1374,-244},{1368,
            -244},{1368,-64},{1400,-64},{1400,460},{1380,460},{1380,640},{1398,
            640}}, color={0,0,127}));
    connect(proPumHW.u1, HWPRunTim.u) annotation (Line(points={{-34,-308},{-42,
            -308},{-42,-206},{-48,-206},{-48,678},{1382,678},{1382,580},{1398,580}},
          color={0,0,127}));
    connect(greaterEqualThreshold.y, booToReaCT.u)
      annotation (Line(points={{1241,698},{1252,698}}, color={255,0,255}));
    connect(booToReaCT.y, cooTowRunTim.u) annotation (Line(points={{1275,698},{
            1316,698},{1316,550},{1338,550}}, color={0,0,127}));
    connect(cooTowSpeCon.y, greaterEqualThreshold.u) annotation (Line(points={{1307,
            -97.1111},{1400,-97.1111},{1400,460},{1378,460},{1378,680},{1200,
            680},{1200,698},{1218,698}}, color={0,0,127}));
    connect(oveTSetChiWatSup.y, chiWSE.TSet) annotation (Line(points={{1221,-300},
            {1240,-300},{1240,-354},{774,-354},{774,-218.8},{695.6,-218.8}},
          color={0,0,127}));
    connect(oveTSetChiWatSup.y, cooTowSpeCon.TCHWSupSet) annotation (Line(points={{1221,
            -300},{1240,-300},{1240,-97.1111},{1284,-97.1111}},        color={0,0,
            127}));
    connect(chiStaCon.y, oveChiOn.u) annotation (Line(points={{1307,-128},{1314,-128},
            {1314,-108},{1324,-108}}, color={0,0,127}));
    connect(oveChiOn.y, chiRunTim.u) annotation (Line(points={{1347,-108},{1398,-108},
            {1398,458},{1324,458},{1324,640},{1338,640}}, color={0,0,127}));
    connect(oveChiOn.y, chiOn.u) annotation (Line(points={{1347,-108},{1360,-108},
            {1360,-120},{1316,-120},{1316,-128},{1324,-128}}, color={0,0,127}));
    connect(conAHU.ySupFanSpe, oveSupFanSpe.u) annotation (Line(points={{424,
            618.667},{441,618.667},{441,618},{458,618}}, color={0,0,127}));
    connect(oveSupFanSpe.y, fanSup.y) annotation (Line(points={{481,618},{502,
            618},{502,458},{456,458},{456,48},{310,48},{310,-28}}, color={0,0,
            127}));
    annotation (
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-400,-400},{1440,
              750}})),
      experiment(
        StartTime=17625600,
        StopTime=18230400,
        Tolerance=1e-06,
        __Dymola_Algorithm="Cvode"));
  end BaselineSystem;

  package BaseClasses
    "Base classes for system-level modeling and fault injection"

    partial model PartialWaterside
      "Partial model that implements water-side cooling system"
      package MediumA = Buildings.Media.Air "Medium model for air";
      package MediumW = Buildings.Media.Water "Medium model for water";

      // Chiller parameters
      parameter Integer numChi=1 "Number of chillers";
      parameter Modelica.SIunits.MassFlowRate m1_flow_chi_nominal= -QEva_nominal*(1+1/COP_nominal)/4200/6.5
        "Nominal mass flow rate at condenser water in the chillers";
      parameter Modelica.SIunits.MassFlowRate m2_flow_chi_nominal= QEva_nominal/4200/(5.56-11.56)
        "Nominal mass flow rate at evaporator water in the chillers";
      parameter Modelica.SIunits.PressureDifference dp1_chi_nominal = 46.2*1000
        "Nominal pressure";
      parameter Modelica.SIunits.PressureDifference dp2_chi_nominal = 44.8*1000
        "Nominal pressure";
        parameter Modelica.SIunits.Power QEva_nominal
        "Nominal cooling capaciaty(Negative means cooling)";
     // WSE parameters
      parameter Modelica.SIunits.MassFlowRate m1_flow_wse_nominal= m1_flow_chi_nominal
        "Nominal mass flow rate at condenser water in the chillers";
      parameter Modelica.SIunits.MassFlowRate m2_flow_wse_nominal= m2_flow_chi_nominal
        "Nominal mass flow rate at condenser water in the chillers";
      parameter Modelica.SIunits.PressureDifference dp1_wse_nominal = 33.1*1000
        "Nominal pressure";
      parameter Modelica.SIunits.PressureDifference dp2_wse_nominal = 34.5*1000
        "Nominal pressure";
      parameter Real COP_nominal=5.9 "COP";
      parameter FaultInjection.Experimental.SystemLevelFaults.Data.Chiller[numChi] perChi(
        each QEva_flow_nominal=QEva_nominal,
        each COP_nominal=COP_nominal,
        each mEva_flow_nominal=m2_flow_chi_nominal,
        each mCon_flow_nominal=m1_flow_chi_nominal);

      parameter Buildings.Fluid.Movers.Data.Generic perPumCW(
        each pressure=
              Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
              V_flow=m1_flow_chi_nominal/1000*{0.2,0.6,1.0,1.2},
              dp=(dp1_chi_nominal+133500+30000+6000)*{1.2,1.1,1.0,0.6}))
        "Performance data for condenser water pumps";

      // Set point
      parameter Modelica.SIunits.Temperature TCHWSet = 273.15 + 6
        "Chilled water temperature setpoint";
      parameter Modelica.SIunits.Pressure dpSetPoi = 36000
        "Differential pressure setpoint at cooling coil";

      FaultInjection.Experimental.SystemLevelFaults.Controls.ChillerStage chiStaCon(tWai=0)
        "Chiller staging control" annotation (Placement(transformation(extent={
                {1286,-138},{1306,-118}})));
      Modelica.Blocks.Math.RealToBoolean chiOn "Real value to boolean value"
        annotation (Placement(transformation(extent={{1326,-138},{1346,-118}})));
      Modelica.Blocks.Math.IntegerToBoolean intToBoo(threshold=Integer(FaultInjection.Experimental.SystemLevelFaults.Types.CoolingModes.FullMechanical))
        "Inverse on/off signal for the WSE"
        annotation (Placement(transformation(extent={{1286,-164},{1306,-144}})));
      Modelica.Blocks.Logical.Not wseOn "True: WSE is on; False: WSE is off "
        annotation (Placement(transformation(extent={{1326,-164},{1346,-144}})));
      FaultInjection.Experimental.SystemLevelFaults.Controls.ConstantSpeedPumpStage
        CWPumCon(tWai=0) "Condenser water pump controller" annotation (
          Placement(transformation(extent={{1284,-216},{1304,-196}})));
      Modelica.Blocks.Sources.IntegerExpression chiNumOn(y=integer(chiStaCon.y))
        "The number of running chillers"
        annotation (Placement(transformation(extent={{1196,-222},{1218,-200}})));
      Modelica.Blocks.Math.Gain gai(each k=1)                   "Gain effect"
        annotation (Placement(transformation(extent={{1326,-216},{1346,-196}})));
      FaultInjection.Experimental.SystemLevelFaults.Controls.CoolingTowerSpeed cooTowSpeCon(
        controllerType=Modelica.Blocks.Types.SimpleController.PI,
        yMin=0,
        Ti=60,
        k=0.1) "Cooling tower speed control"
        annotation (Placement(transformation(extent={{1286,-106},{1306,-90}})));
      Modelica.Blocks.Sources.RealExpression TCWSupSet(y=min(29.44 + 273.15, max(273.15
             + 15.56, cooTow.TAir + 3)))
        "Condenser water supply temperature setpoint"
        annotation (Placement(transformation(extent={{1196,-100},{1216,-80}})));
      replaceable Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialChillerWSE chiWSE(
        redeclare replaceable package Medium1 = MediumW,
        redeclare replaceable package Medium2 = MediumW,
        numChi=numChi,
        m1_flow_chi_nominal=m1_flow_chi_nominal,
        m2_flow_chi_nominal=m2_flow_chi_nominal,
        m1_flow_wse_nominal=m1_flow_wse_nominal,
        m2_flow_wse_nominal=m2_flow_wse_nominal,
        dp1_chi_nominal=dp1_chi_nominal,
        dp1_wse_nominal=dp1_wse_nominal,
        dp2_chi_nominal=dp2_chi_nominal,
        dp2_wse_nominal=dp2_wse_nominal,
        perChi = perChi,
        use_inputFilter=false,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        use_controller=false)
        "Chillers and waterside economizer"
        annotation (Placement(transformation(extent={{694,-198},{674,-218}})));
      Buildings.Fluid.Sources.Boundary_pT expVesCW(redeclare replaceable
          package Medium =
                   MediumW, nPorts=1)
        "Expansion tank"
        annotation (Placement(transformation(extent={{-9,-9.5},{9,9.5}},
            rotation=180,
            origin={969,-299.5})));
      Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel   cooTow(
        redeclare each replaceable package Medium = MediumW,
        ratWatAir_nominal=1.5,
        each TAirInWB_nominal(displayUnit="degC") = 273.15 + 25.55,
        each energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
        each dp_nominal=30000,
        each m_flow_nominal=m1_flow_chi_nominal,
        TWatIn_nominal=273.15 + 35,
        TWatOut_nominal=((273.15 + 35) - 273.15 - 5.56) + 273.15,
        each PFan_nominal=4300)  "Cooling tower" annotation (Placement(
            transformation(extent={{-10,-10},{10,10}}, origin={748,-316})));
      Buildings.Fluid.Sensors.TemperatureTwoPort TCHWSup(redeclare replaceable
          package Medium = MediumW, m_flow_nominal=numChi*m2_flow_chi_nominal)
        "Chilled water supply temperature"
        annotation (Placement(transformation(extent={{778,-138},{758,-118}})));
      Buildings.Fluid.Sensors.TemperatureTwoPort TCWSup(redeclare replaceable
          package Medium = MediumW, m_flow_nominal=numChi*m1_flow_chi_nominal)
        "Condenser water supply temperature"
        annotation (Placement(transformation(extent={{818,-326},{838,-306}})));
      Buildings.Fluid.Sensors.TemperatureTwoPort TCWRet(redeclare replaceable
          package Medium = MediumW, m_flow_nominal=numChi*m1_flow_chi_nominal)
        "Condenser water return temperature"
        annotation (Placement(transformation(extent={{534,-326},{554,-306}})));
      Buildings.Fluid.Movers.SpeedControlled_y     pumCW(
        redeclare each replaceable package Medium = MediumW,
        addPowerToMedium=false,
        per=perPumCW,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
                                    "Condenser water pump" annotation (Placement(
            transformation(
            extent={{10,10},{-10,-10}},
            rotation=-90,
            origin={910,-288})));
      Buildings.Fluid.Sensors.TemperatureTwoPort TCHWRet(redeclare replaceable
          package Medium = MediumW, m_flow_nominal=numChi*m2_flow_chi_nominal)
        "Chilled water return temperature"
        annotation (Placement(transformation(extent={{618,-198},{598,-178}})));
      Buildings.Fluid.Sources.Boundary_pT expVesChi(redeclare replaceable
          package Medium =
                   MediumW, nPorts=1)
        "Expansion tank"
        annotation (Placement(transformation(extent={{10,-10},{-10,10}},
            rotation=180,
            origin={512,-179})));
      Buildings.Fluid.Sensors.RelativePressure senRelPre(redeclare replaceable
          package Medium = MediumW)
        "Differential pressure"
        annotation (Placement(transformation(extent={{578,-130},{558,-150}})));
      Buildings.Fluid.Actuators.Valves.TwoWayLinear val(
        redeclare each package Medium = MediumW,
        m_flow_nominal=m1_flow_chi_nominal,
        dpValve_nominal=6000,
        dpFixed_nominal=133500) "Shutoff valves"
        annotation (Placement(transformation(extent={{636,-326},{656,-306}})));
      Buildings.Controls.Continuous.LimPID pumSpe(
        controllerType=Modelica.Blocks.Types.SimpleController.PI,
        Ti=40,
        yMin=0.2,
        k=0.1,
        reset=Buildings.Types.Reset.Parameter,
        y_reset=0)
               "Pump speed controller"
        annotation (Placement(transformation(extent={{1340,-258},{1360,-238}})));
      Modelica.Blocks.Math.Gain dpGai(k=1/dpSetPoi) "Gain effect"
        annotation (Placement(transformation(extent={{1256,-292},{1276,-272}})));
      Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage     watVal
        "Two-way valve"
         annotation (
          Placement(transformation(
            extent={{-10,10},{10,-10}},
            rotation=270,
            origin={538,-108})));
      Buildings.Fluid.FixedResistances.PressureDrop resCHW(
        m_flow_nominal=m2_flow_chi_nominal,
        redeclare package Medium = MediumW,
        dp_nominal=150000) "Resistance in chilled water loop"
        annotation (Placement(transformation(extent={{630,-198},{650,-178}})));
      FaultInjection.Experimental.SystemLevelFaults.Controls.TemperatureDifferentialPressureReset
        temDifPreRes(
        dpMin(displayUnit="Pa"),
        dpMax(displayUnit="Pa"),
        TMin(displayUnit="K"),
        TMax(displayUnit="K")) annotation (Placement(transformation(extent={{
                1196,-254},{1216,-234}})));
      Modelica.Blocks.Math.Gain dpSetGai(k=1/dpSetPoi) "Gain effect"
        annotation (Placement(transformation(extent={{1256,-258},{1276,-238}})));
      FaultInjection.Utilities.Overwrite.OverwriteVariable oveTSetChiWatSup(u(
          unit="K",
          min=273.15 + 0.5,
          max=273.15 + 30), description=
            "Chilled water supply temperature setpoint") annotation (Placement(
            transformation(extent={{1200,-310},{1220,-290}})));
    equation

      connect(intToBoo.y,wseOn. u)
        annotation (Line(
          points={{1307,-154},{1324,-154}},
          color={255,0,255}));
      connect(TCWSupSet.y,cooTowSpeCon. TCWSupSet)
        annotation (Line(
          points={{1217,-90},{1284,-90}},
          color={0,0,127}));
      connect(chiNumOn.y,CWPumCon. numOnChi)
        annotation (Line(
          points={{1219.1,-211},{1282,-211}},
          color={255,127,0}));
      connect(dpGai.y, pumSpe.u_m) annotation (Line(points={{1277,-282},{1350,-282},
              {1350,-260}},                     color={0,0,127}));

      connect(val.port_b,cooTow. port_a)
        annotation (Line(points={{656,-316},{738,-316}}, color={0,0,255},
          thickness=0.5));
      connect(TCWSup.port_b, expVesCW.ports[1]) annotation (Line(points={{838,-316},
              {938,-316},{938,-299.5},{960,-299.5}}, color={0,0,255},
          thickness=0.5));
      connect(senRelPre.p_rel, dpGai.u) annotation (Line(points={{568,-131},{568,
              -18},{1182,-18},{1182,-282},{1254,-282}},
                                                     color={0,0,127}));
      connect(CWPumCon.y[1], gai.u) annotation (Line(points={{1305,-206.5},{1306,
              -206.5},{1306,-206},{1324,-206}},
                                        color={0,0,127}));
      connect(chiWSE.port_a1, pumCW.port_b) annotation (Line(points={{694,-214},{
              708,-214},{708,-228},{910,-228},{910,-278}},
                                     color={0,0,255},
          thickness=0.5));
      connect(TCWSup.port_b, pumCW.port_a) annotation (Line(points={{838,-316},{910,
              -316},{910,-298}}, color={0,0,255},
          thickness=0.5));
      connect(cooTow.port_b, TCWSup.port_a)
        annotation (Line(points={{758,-316},{818,-316}}, color={0,0,255},
          thickness=0.5));
      connect(TCWRet.port_b, val.port_a)
        annotation (Line(points={{554,-316},{636,-316}}, color={0,0,255},
          thickness=0.5));
      connect(dpSetGai.y, pumSpe.u_s)
        annotation (Line(points={{1277,-248},{1338,-248}}, color={0,0,127}));
      connect(temDifPreRes.dpSet, dpSetGai.u) annotation (Line(points={{1217,-239},
              {1236.5,-239},{1236.5,-248},{1254,-248}}, color={0,0,127}));
      connect(chiWSE.port_b2,TCHWSup. port_a)
        annotation (Line(
          points={{694,-202},{718,-202},{718,-188},{906,-188},{906,-128},{778,-128}},
          color={28,108,200},
          thickness=0.5));
      connect(senRelPre.port_b, TCHWRet.port_b) annotation (Line(points={{558,-140},
              {538,-140},{538,-188},{598,-188}}, color={28,108,200},
          thickness=0.5));
      connect(TCWRet.port_a,chiWSE. port_b1) annotation (Line(points={{534,-316},{
              502,-316},{502,-228},{664,-228},{664,-214},{674,-214}},
                                            color={0,0,255},
          thickness=0.5));
      connect(watVal.port_b, TCHWRet.port_b) annotation (Line(points={{538,-118},{
              538,-188},{598,-188}}, color={28,108,200},
          thickness=0.5));
      connect(expVesChi.ports[1], TCHWRet.port_b) annotation (Line(points={{522,
              -179},{538,-179},{538,-188},{598,-188}}, color={28,108,200},
          thickness=0.5));
      connect(senRelPre.port_a, TCHWSup.port_b) annotation (Line(points={{578,-140},
              {594,-140},{594,-128},{758,-128}}, color={28,108,200},
          thickness=0.5));
      connect(TCHWRet.port_a, resCHW.port_a)
        annotation (Line(points={{618,-188},{630,-188}}, color={28,108,200},
          thickness=0.5));
      connect(resCHW.port_b, chiWSE.port_a2) annotation (Line(points={{650,-188},{
              662,-188},{662,-202},{674,-202}}, color={28,108,200},
          thickness=0.5));
      connect(temDifPreRes.TSet, oveTSetChiWatSup.u) annotation (Line(points={{1217,
              -249},{1230,-249},{1230,-276},{1186,-276},{1186,-300},{1198,-300}},
            color={0,0,127}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-400,
                -500},{650,20}})), Documentation(info="<html>
<p>
This is a partial model that describes the chilled water cooling system in a data center. The sizing data
are collected from the reference.
</p>
<h4>Reference </h4>
<ul>
<li>
Taylor, S. T. (2014). How to design &amp; control waterside economizers. ASHRAE Journal, 56(6), 30-36.
</li>
</ul>
</html>",     revisions="<html>
<ul>
<li>
January 12, 2019, by Michael Wetter:<br/>
Removed wrong <code>each</code>.
</li>
<li>
December 1, 2017, by Yangyang Fu:<br/>
Used scaled differential pressure to control the speed of pumps. This can avoid retuning gains
in PID when changing the differential pressure setpoint.
</li>
<li>
September 2, 2017, by Michael Wetter:<br/>
Changed expansion vessel to use the more efficient implementation.
</li>
<li>
July 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
    end PartialWaterside;

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
      Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage HWVal(
        redeclare package Medium = MediumW,
        m_flow_nominal=m_flow_boi_nominal,
        dpValve_nominal=6000) "Two-way valve"
        annotation (Placement(transformation(
            extent={{-10,10},{10,-10}},
            rotation=270,
            origin={98,-180})));
      Buildings.Fluid.Sources.Boundary_pT expVesBoi(redeclare replaceable
          package Medium =
                   MediumW,
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
      Buildings.Fluid.FixedResistances.PressureDrop resHW(
        m_flow_nominal=m_flow_boi_nominal,
        redeclare package Medium = MediumW,
        dp_nominal=85000)  "Resistance in hot water loop" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=-90,
            origin={350,-260})));
      Buildings.Fluid.Boilers.BoilerPolynomial boi(
        redeclare package Medium = MediumW,
        m_flow_nominal=m_flow_boi_nominal,
        dp_nominal=60000,
        Q_flow_nominal=Q_flow_boi_nominal,
        T_nominal=318.15,
        fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue())
        annotation (Placement(transformation(extent={{130,-330},{150,-310}})));
      Buildings.Fluid.Actuators.Valves.TwoWayLinear boiIsoVal(
        redeclare each package Medium = MediumW,
        m_flow_nominal=m_flow_boi_nominal,
        dpValve_nominal=6000) "Boiler Isolation Valve"
        annotation (Placement(transformation(extent={{282,-330},{302,-310}})));
      Buildings.Fluid.Movers.SpeedControlled_y pumHW(
        redeclare package Medium = MediumW,
        per=perPumHW,
        addPowerToMedium=false)
        annotation (Placement(transformation(extent={{198,-330},{218,-310}})));
      Buildings.Fluid.Sensors.TemperatureTwoPort THWSup(redeclare replaceable
          package Medium = MediumW, m_flow_nominal=m_flow_boi_nominal)
        "Hot water supply temperature" annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=90,
            origin={350,-224})));
      Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valBypBoi(
        redeclare package Medium = MediumW,
        m_flow_nominal=m_flow_boi_nominal,
        dpValve_nominal=6000,
        y_start=0,
        use_inputFilter=false,
        from_dp=true) "Bypass valve for boiler." annotation (Placement(
            transformation(extent={{-10,-10},{10,10}}, origin={230,-252})));
      Buildings.Fluid.Sensors.RelativePressure senRelPreHW(redeclare
          replaceable package Medium =
                           MediumW) "Differential pressure"
        annotation (Placement(transformation(extent={{208,-196},{188,-216}})));
      parameter Buildings.Fluid.Movers.Data.Generic perPumHW(
              pressure=Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
              V_flow=m_flow_boi_nominal/1000*{0.2,0.6,1.0,1.2},
              dp=(85000+60000+6000+6000)*{1.5,1.3,1.0,0.6}))
        "Performance data for primary pumps";
      Modelica.Blocks.Math.Gain dpSetGaiHW(k=1/dpSetPoiHW) "Gain effect"
        annotation (Placement(transformation(extent={{-120,-310},{-100,-290}})));
      Modelica.Blocks.Math.Gain dpGaiHW(k=1/dpSetPoiHW) "Gain effect"
        annotation (Placement(transformation(extent={{-120,-350},{-100,-330}})));
      Buildings.Controls.Continuous.LimPID pumSpeHW(
        controllerType=Modelica.Blocks.Types.SimpleController.PI,
        Ti=40,
        yMin=0.2,
        k=0.1) "Pump speed controller"
        annotation (Placement(transformation(extent={{-70,-330},{-50,-310}})));
      Buildings.Controls.OBC.CDL.Continuous.Product proPumHW
        annotation (Placement(transformation(extent={{-32,-324},{-12,-304}})));
      FaultInjection.Experimental.SystemLevelFaults.Controls.MinimumFlowBypassValve
        minFloBypHW(controllerType=Modelica.Blocks.Types.SimpleController.PI)
        "Hot water loop minimum bypass valve control"
        annotation (Placement(transformation(extent={{-74,-258},{-54,-238}})));
      Buildings.Fluid.Sensors.MassFlowRate   senHWFlo(redeclare package Medium =
            MediumW)
        "Sensor for hot water flow rate" annotation (Placement(transformation(
            extent={{-10,10},{10,-10}},
            rotation=-90,
            origin={98,-278})));
      Buildings.Controls.Continuous.LimPID boiTSup(
        Td=1,
        k=0.5,
        controllerType=Modelica.Blocks.Types.SimpleController.PI,
        Ti=100) "Boiler supply water temperature"
        annotation (Placement(transformation(extent={{-74,-288},{-54,-268}})));
      Buildings.Controls.OBC.CDL.Continuous.Product proBoi
        annotation (Placement(transformation(extent={{-32,-282},{-12,-262}})));
      FaultInjection.Experimental.SystemLevelFaults.Controls.TrimResponse triResHW(
        uTri=0.9,
        dpMin(displayUnit="kPa") = 0.5*dpSetPoiHW,
        dpMax(displayUnit="kPa") = dpSetPoiHW) annotation (Placement(
            transformation(extent={{-156,-236},{-136,-216}})));
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
      connect(THWRet.port_a, senRelPreHW.port_b)
        annotation (Line(points={{98,-216},{98,-206},{188,-206}},
                                                      color={238,46,47},
          thickness=0.5));
      connect(senRelPreHW.port_a, THWSup.port_a)
        annotation (Line(points={{208,-206},{350,-206},{350,-214}},
                                                       color={238,46,47},
          thickness=0.5));
      connect(dpSetGaiHW.y, pumSpeHW.u_s)
        annotation (Line(points={{-99,-300},{-86,-300},{-86,-320},{-72,-320}},
                                                           color={0,0,127}));
      connect(dpGaiHW.y, pumSpeHW.u_m) annotation (Line(points={{-99,-340},{-60,
              -340},{-60,-332}},
                            color={0,0,127}));
      connect(senRelPreHW.p_rel, dpGaiHW.u) annotation (Line(points={{198,-197},{
              198,-68},{-182,-68},{-182,-340},{-122,-340}},
                                                      color={0,0,127}));
      connect(pumSpeHW.y, proPumHW.u2)
        annotation (Line(points={{-49,-320},{-34,-320}}, color={0,0,127}));
      connect(proPumHW.y, pumHW.y) annotation (Line(points={{-10,-314},{10,-314},{
              10,-360},{180,-360},{180,-300},{208,-300},{208,-308}},
                                               color={0,0,127}));
      connect(THWSup.port_b, resHW.port_a)
        annotation (Line(points={{350,-234},{350,-250}},
                                                       color={238,46,47},
          thickness=1));
      connect(resHW.port_b, boiIsoVal.port_b) annotation (Line(points={{350,-270},{
              350,-320},{302,-320}},       color={238,46,47},
          thickness=0.5));
      connect(expVesBoi.ports[1], boi.port_a) annotation (Line(points={{68,-319},{
              100,-319},{100,-320},{130,-320}},
                                          color={238,46,47},
          thickness=0.5));
      connect(boiTSup.u_m, boi.T) annotation (Line(points={{-64,-290},{-64,-296},{
              -98,-296},{-98,-64},{160,-64},{160,-312},{151,-312}},
                                             color={0,0,127}));
      connect(senHWFlo.m_flow, minFloBypHW.m_flow) annotation (Line(points={{87,-278},
              {72,-278},{72,-70},{-96,-70},{-96,-245},{-76,-245}},     color={0,0,127}));
      connect(valBypBoi.port_a, senHWFlo.port_a) annotation (Line(points={{220,-252},
              {98,-252},{98,-268}}, color={238,46,47},
          thickness=0.5));
      connect(THWRet.port_b, senHWFlo.port_a)
        annotation (Line(points={{98,-236},{98,-268}}, color={238,46,47},
          thickness=0.5));
      connect(senHWFlo.port_b, boi.port_a) annotation (Line(points={{98,-288},{98,
              -320},{130,-320}}, color={238,46,47},
          thickness=0.5));
      connect(valBypBoi.port_b, resHW.port_b) annotation (Line(points={{240,-252},{
              320,-252},{320,-290},{350,-290},{350,-270}}, color={238,46,47},
          thickness=0.5));
      connect(boiTSup.y, proBoi.u2)
        annotation (Line(points={{-53,-278},{-34,-278}}, color={0,0,127}));
      connect(proBoi.y, boi.y) annotation (Line(points={{-10,-272},{12,-272},{12,
              -358},{120,-358},{120,-312},{128,-312}},
                                 color={0,0,127}));
      connect(triResHW.dpSet, dpSetGaiHW.u) annotation (Line(points={{-135,-221},{
              -128,-221},{-128,-300},{-122,-300}}, color={0,0,127}));
      connect(triResHW.TSet, boiTSup.u_s) annotation (Line(points={{-135,-231},{
              -100,-231},{-100,-278},{-76,-278}},
                                            color={0,0,127}));
      connect(HWVal.y_actual, triResHW.u) annotation (Line(points={{91,-185},{91,
              -200},{70,-200},{70,-66},{-180,-66},{-180,-226},{-158,-226}},
                                                          color={0,0,127}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,
                -380},{350,-60}})),                                  Diagram(
            coordinateSystem(preserveAspectRatio=false, extent={{-200,-380},{350,
                -60}})));
    end PartialHotWaterside;

    partial model PartialPhysicalAirside
      "Partial model of variable air volume flow system with terminal reheat and five 
  thermal zones: this is a copy of Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop"

      package MediumA = Buildings.Media.Air "Medium model for air";
      package MediumW = Buildings.Media.Water "Medium model for water";

      constant Integer numZon=5 "Total number of served VAV boxes";

      parameter Modelica.SIunits.Volume VRooCor=AFloCor*flo.hRoo
        "Room volume corridor";
      parameter Modelica.SIunits.Volume VRooSou=AFloSou*flo.hRoo
        "Room volume south";
      parameter Modelica.SIunits.Volume VRooNor=AFloNor*flo.hRoo
        "Room volume north";
      parameter Modelica.SIunits.Volume VRooEas=AFloEas*flo.hRoo "Room volume east";
      parameter Modelica.SIunits.Volume VRooWes=AFloWes*flo.hRoo "Room volume west";

      parameter Modelica.SIunits.Area AFloCor=flo.cor.AFlo "Floor area corridor";
      parameter Modelica.SIunits.Area AFloSou=flo.sou.AFlo "Floor area south";
      parameter Modelica.SIunits.Area AFloNor=flo.nor.AFlo "Floor area north";
      parameter Modelica.SIunits.Area AFloEas=flo.eas.AFlo "Floor area east";
      parameter Modelica.SIunits.Area AFloWes=flo.wes.AFlo "Floor area west";

      parameter Modelica.SIunits.Area AFlo[numZon]={flo.cor.AFlo,flo.sou.AFlo,flo.eas.AFlo,
          flo.nor.AFlo,flo.wes.AFlo} "Floor area of each zone";
      final parameter Modelica.SIunits.Area ATot=sum(AFlo) "Total floor area";

      constant Real conv=1.2/3600 "Conversion factor for nominal mass flow rate";
      parameter Modelica.SIunits.MassFlowRate mCor_flow_nominal=6*VRooCor*conv
        "Design mass flow rate core";
      parameter Modelica.SIunits.MassFlowRate mSou_flow_nominal=6*VRooSou*conv
        "Design mass flow rate perimeter 1";
      parameter Modelica.SIunits.MassFlowRate mEas_flow_nominal=9*VRooEas*conv
        "Design mass flow rate perimeter 2";
      parameter Modelica.SIunits.MassFlowRate mNor_flow_nominal=6*VRooNor*conv
        "Design mass flow rate perimeter 3";
      parameter Modelica.SIunits.MassFlowRate mWes_flow_nominal=7*VRooWes*conv
        "Design mass flow rate perimeter 4";
      parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.7*(mCor_flow_nominal
           + mSou_flow_nominal + mEas_flow_nominal + mNor_flow_nominal +
          mWes_flow_nominal) "Nominal mass flow rate";
      parameter Modelica.SIunits.Angle lat=41.98*3.14159/180 "Latitude";

      parameter Modelica.SIunits.Temperature THeaOn=293.15
        "Heating setpoint during on";
      parameter Modelica.SIunits.Temperature THeaOff=285.15
        "Heating setpoint during off";
      parameter Modelica.SIunits.Temperature TCooOn=297.15
        "Cooling setpoint during on";
      parameter Modelica.SIunits.Temperature TCooOff=303.15
        "Cooling setpoint during off";
      parameter Modelica.SIunits.PressureDifference dpBuiStaSet(min=0) = 12
        "Building static pressure";
      parameter Real yFanMin = 0.1 "Minimum fan speed";

    //  parameter Modelica.SIunits.HeatFlowRate QHeaCoi_nominal= 2.5*yFanMin*m_flow_nominal*1000*(20 - 4)
    //    "Nominal capacity of heating coil";

      parameter Boolean allowFlowReversal=true
        "= false to simplify equations, assuming, but not enforcing, no flow reversal"
        annotation (Evaluate=true);

      parameter Boolean use_windPressure=true "Set to true to enable wind pressure";

      parameter Boolean sampleModel=true
        "Set to true to time-sample the model, which can give shorter simulation time if there is already time sampling in the system model"
        annotation (Evaluate=true, Dialog(tab=
              "Experimental (may be changed in future releases)"));

      // sizing parameter
      parameter Modelica.SIunits.HeatFlowRate designCoolLoad = -m_flow_nominal*1000*15 "Design cooling load";
      parameter Modelica.SIunits.HeatFlowRate designHeatLoad = 0.6*m_flow_nominal*1006*(18 - 8) "Design heating load";

      Buildings.Fluid.Sources.Outside amb(redeclare package Medium = MediumA,
          nPorts=3) "Ambient conditions"
        annotation (Placement(transformation(extent={{-136,-56},{-114,-34}})));
    //  Buildings.Fluid.HeatExchangers.DryCoilCounterFlow heaCoi(
    //    redeclare package Medium1 = MediumW,
    //    redeclare package Medium2 = MediumA,
    //    UA_nominal = QHeaCoi_nominal/Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
    //      T_a1=45,
    //      T_b1=35,
    //      T_a2=3,
    //      T_b2=20),
    //    m2_flow_nominal=m_flow_nominal,
    //    allowFlowReversal1=false,
    //    allowFlowReversal2=allowFlowReversal,
    //    dp1_nominal=0,
    //    dp2_nominal=200 + 200 + 100 + 40,
    //    m1_flow_nominal=QHeaCoi_nominal/4200/10,
    //    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    //    "Heating coil"
    //    annotation (Placement(transformation(extent={{118,-36},{98,-56}})));

      Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU heaCoi(
        redeclare package Medium1 = MediumW,
        redeclare package Medium2 = MediumA,
        m1_flow_nominal=designHeatLoad/4200/5,
        m2_flow_nominal=0.6*m_flow_nominal,
        configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
        Q_flow_nominal=designHeatLoad,
        dp1_nominal=0,
        dp2_nominal=200 + 200 + 100 + 40,
        allowFlowReversal1=false,
        allowFlowReversal2=allowFlowReversal,
        T_a1_nominal=318.15,
        T_a2_nominal=281.65) "Heating coil"
        annotation (Placement(transformation(extent={{118,-36},{98,-56}})));

      Buildings.Fluid.HeatExchangers.WetCoilCounterFlow cooCoi(
        UA_nominal=-designCoolLoad/
            Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
            T_a1=26.2,
            T_b1=12.8,
            T_a2=6,
            T_b2=12),
        redeclare package Medium1 = MediumW,
        redeclare package Medium2 = MediumA,
        m1_flow_nominal=-designCoolLoad/4200/6,
        m2_flow_nominal=m_flow_nominal,
        dp2_nominal=0,
        dp1_nominal=30000,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        allowFlowReversal1=false,
        allowFlowReversal2=allowFlowReversal) "Cooling coil"
        annotation (Placement(transformation(extent={{210,-36},{190,-56}})));
      Buildings.Fluid.FixedResistances.PressureDrop dpRetDuc(
        m_flow_nominal=m_flow_nominal,
        redeclare package Medium = MediumA,
        allowFlowReversal=allowFlowReversal,
        dp_nominal=490)
                       "Pressure drop for return duct"
        annotation (Placement(transformation(extent={{400,130},{380,150}})));
      Buildings.Fluid.Movers.SpeedControlled_y fanSup(
        redeclare package Medium = MediumA,
        per(pressure(V_flow=m_flow_nominal/1.2*{0.2,0.6,1.0,1.2}, dp=(1030 + 220 +
                10 + 20 + dpBuiStaSet)*{1.2,1.1,1.0,0.6})),
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        addPowerToMedium=false) "Supply air fan"
        annotation (Placement(transformation(extent={{300,-50},{320,-30}})));

      Buildings.Fluid.Sensors.VolumeFlowRate senSupFlo(redeclare package Medium =
            MediumA, m_flow_nominal=m_flow_nominal)
        "Sensor for supply fan flow rate"
        annotation (Placement(transformation(extent={{400,-50},{420,-30}})));

      Buildings.Fluid.Sensors.VolumeFlowRate senRetFlo(redeclare package Medium =
            MediumA, m_flow_nominal=m_flow_nominal)
        "Sensor for return fan flow rate"
        annotation (Placement(transformation(extent={{360,130},{340,150}})));

      Modelica.Blocks.Routing.RealPassThrough TOut(y(
          final quantity="ThermodynamicTemperature",
          final unit="K",
          displayUnit="degC",
          min=0))
        annotation (Placement(transformation(extent={{-300,170},{-280,190}})));
      Buildings.Fluid.Sensors.TemperatureTwoPort TSup(
        redeclare package Medium = MediumA,
        m_flow_nominal=m_flow_nominal,
        allowFlowReversal=allowFlowReversal)
        annotation (Placement(transformation(extent={{330,-50},{350,-30}})));
      Buildings.Fluid.Sensors.RelativePressure dpDisSupFan(redeclare package
          Medium =
            MediumA) "Supply fan static discharge pressure" annotation (Placement(
            transformation(
            extent={{-10,10},{10,-10}},
            rotation=90,
            origin={320,0})));
      Buildings.Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{6,19})
        "Occupancy schedule"
        annotation (Placement(transformation(extent={{-318,-80},{-298,-60}})));
      Buildings.Utilities.Math.Min min(nin=5) "Computes lowest room temperature"
        annotation (Placement(transformation(extent={{1200,440},{1220,460}})));
      Buildings.Utilities.Math.Average ave(nin=5)
        "Compute average of room temperatures"
        annotation (Placement(transformation(extent={{1200,410},{1220,430}})));
      Buildings.Fluid.Sensors.TemperatureTwoPort TRet(
        redeclare package Medium = MediumA,
        m_flow_nominal=m_flow_nominal,
        allowFlowReversal=allowFlowReversal) "Return air temperature sensor"
        annotation (Placement(transformation(extent={{110,130},{90,150}})));
      Buildings.Fluid.Sensors.TemperatureTwoPort TMix(
        redeclare package Medium = MediumA,
        m_flow_nominal=m_flow_nominal,
        allowFlowReversal=allowFlowReversal) "Mixed air temperature sensor"
        annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
      Buildings.Fluid.Sensors.VolumeFlowRate VOut1(redeclare package Medium =
            MediumA, m_flow_nominal=m_flow_nominal) "Outside air volume flow rate"
        annotation (Placement(transformation(extent={{-72,-44},{-50,-22}})));

      FaultInjection.Experimental.VAVReheat.ThermalZones.VAVBranch cor(
        redeclare package MediumA = MediumA,
        redeclare package MediumW = MediumW,
        m_flow_nominal=mCor_flow_nominal,
        VRoo=VRooCor,
        allowFlowReversal=allowFlowReversal)
        "Zone for core of buildings (azimuth will be neglected)"
        annotation (Placement(transformation(extent={{570,22},{610,62}})));
      FaultInjection.Experimental.VAVReheat.ThermalZones.VAVBranch sou(
        redeclare package MediumA = MediumA,
        redeclare package MediumW = MediumW,
        m_flow_nominal=mSou_flow_nominal,
        VRoo=VRooSou,
        allowFlowReversal=allowFlowReversal) "South-facing thermal zone"
        annotation (Placement(transformation(extent={{750,20},{790,60}})));
      FaultInjection.Experimental.VAVReheat.ThermalZones.VAVBranch eas(
        redeclare package MediumA = MediumA,
        redeclare package MediumW = MediumW,
        m_flow_nominal=mEas_flow_nominal,
        VRoo=VRooEas,
        allowFlowReversal=allowFlowReversal) "East-facing thermal zone"
        annotation (Placement(transformation(extent={{930,20},{970,60}})));
      FaultInjection.Experimental.VAVReheat.ThermalZones.VAVBranch nor(
        redeclare package MediumA = MediumA,
        redeclare package MediumW = MediumW,
        m_flow_nominal=mNor_flow_nominal,
        VRoo=VRooNor,
        allowFlowReversal=allowFlowReversal) "North-facing thermal zone"
        annotation (Placement(transformation(extent={{1090,20},{1130,60}})));
      FaultInjection.Experimental.VAVReheat.ThermalZones.VAVBranch wes(
        redeclare package MediumA = MediumA,
        redeclare package MediumW = MediumW,
        m_flow_nominal=mWes_flow_nominal,
        VRoo=VRooWes,
        allowFlowReversal=allowFlowReversal) "West-facing thermal zone"
        annotation (Placement(transformation(extent={{1290,20},{1330,60}})));
      Buildings.Fluid.FixedResistances.Junction splRetRoo1(
        redeclare package Medium = MediumA,
        m_flow_nominal={m_flow_nominal,m_flow_nominal - mCor_flow_nominal,
            mCor_flow_nominal},
        from_dp=false,
        linearized=true,
        energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
        dp_nominal(each displayUnit="Pa") = {0,0,0},
        portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
             else Modelica.Fluid.Types.PortFlowDirection.Leaving,
        portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
             else Modelica.Fluid.Types.PortFlowDirection.Entering,
        portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
             else Modelica.Fluid.Types.PortFlowDirection.Entering)
        "Splitter for room return"
        annotation (Placement(transformation(extent={{630,10},{650,-10}})));
      Buildings.Fluid.FixedResistances.Junction splRetSou(
        redeclare package Medium = MediumA,
        m_flow_nominal={mSou_flow_nominal + mEas_flow_nominal + mNor_flow_nominal
             + mWes_flow_nominal,mEas_flow_nominal + mNor_flow_nominal +
            mWes_flow_nominal,mSou_flow_nominal},
        from_dp=false,
        linearized=true,
        energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
        dp_nominal(each displayUnit="Pa") = {0,0,0},
        portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
             else Modelica.Fluid.Types.PortFlowDirection.Leaving,
        portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
             else Modelica.Fluid.Types.PortFlowDirection.Entering,
        portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
             else Modelica.Fluid.Types.PortFlowDirection.Entering)
        "Splitter for room return"
        annotation (Placement(transformation(extent={{812,10},{832,-10}})));
      Buildings.Fluid.FixedResistances.Junction splRetEas(
        redeclare package Medium = MediumA,
        m_flow_nominal={mEas_flow_nominal + mNor_flow_nominal + mWes_flow_nominal,
            mNor_flow_nominal + mWes_flow_nominal,mEas_flow_nominal},
        from_dp=false,
        linearized=true,
        energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
        dp_nominal(each displayUnit="Pa") = {0,0,0},
        portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
             else Modelica.Fluid.Types.PortFlowDirection.Leaving,
        portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
             else Modelica.Fluid.Types.PortFlowDirection.Entering,
        portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
             else Modelica.Fluid.Types.PortFlowDirection.Entering)
        "Splitter for room return"
        annotation (Placement(transformation(extent={{992,10},{1012,-10}})));
      Buildings.Fluid.FixedResistances.Junction splRetNor(
        redeclare package Medium = MediumA,
        m_flow_nominal={mNor_flow_nominal + mWes_flow_nominal,mWes_flow_nominal,
            mNor_flow_nominal},
        from_dp=false,
        linearized=true,
        energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
        dp_nominal(each displayUnit="Pa") = {0,0,0},
        portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
             else Modelica.Fluid.Types.PortFlowDirection.Leaving,
        portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
             else Modelica.Fluid.Types.PortFlowDirection.Entering,
        portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
             else Modelica.Fluid.Types.PortFlowDirection.Entering)
        "Splitter for room return"
        annotation (Placement(transformation(extent={{1142,10},{1162,-10}})));
      Buildings.Fluid.FixedResistances.Junction splSupRoo1(
        redeclare package Medium = MediumA,
        m_flow_nominal={m_flow_nominal,m_flow_nominal - mCor_flow_nominal,
            mCor_flow_nominal},
        from_dp=true,
        linearized=true,
        energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
        dp_nominal(each displayUnit="Pa") = {0,0,0},
        portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
             else Modelica.Fluid.Types.PortFlowDirection.Entering,
        portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
             else Modelica.Fluid.Types.PortFlowDirection.Leaving,
        portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
             else Modelica.Fluid.Types.PortFlowDirection.Leaving)
        "Splitter for room supply"
        annotation (Placement(transformation(extent={{570,-30},{590,-50}})));
      Buildings.Fluid.FixedResistances.Junction splSupSou(
        redeclare package Medium = MediumA,
        m_flow_nominal={mSou_flow_nominal + mEas_flow_nominal + mNor_flow_nominal
             + mWes_flow_nominal,mEas_flow_nominal + mNor_flow_nominal +
            mWes_flow_nominal,mSou_flow_nominal},
        from_dp=true,
        linearized=true,
        energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
        dp_nominal(each displayUnit="Pa") = {0,0,0},
        portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
             else Modelica.Fluid.Types.PortFlowDirection.Entering,
        portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
             else Modelica.Fluid.Types.PortFlowDirection.Leaving,
        portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
             else Modelica.Fluid.Types.PortFlowDirection.Leaving)
        "Splitter for room supply"
        annotation (Placement(transformation(extent={{750,-30},{770,-50}})));
      Buildings.Fluid.FixedResistances.Junction splSupEas(
        redeclare package Medium = MediumA,
        m_flow_nominal={mEas_flow_nominal + mNor_flow_nominal + mWes_flow_nominal,
            mNor_flow_nominal + mWes_flow_nominal,mEas_flow_nominal},
        from_dp=true,
        linearized=true,
        energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
        dp_nominal(each displayUnit="Pa") = {0,0,0},
        portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
             else Modelica.Fluid.Types.PortFlowDirection.Entering,
        portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
             else Modelica.Fluid.Types.PortFlowDirection.Leaving,
        portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
             else Modelica.Fluid.Types.PortFlowDirection.Leaving)
        "Splitter for room supply"
        annotation (Placement(transformation(extent={{930,-30},{950,-50}})));
      Buildings.Fluid.FixedResistances.Junction splSupNor(
        redeclare package Medium = MediumA,
        m_flow_nominal={mNor_flow_nominal + mWes_flow_nominal,mWes_flow_nominal,
            mNor_flow_nominal},
        from_dp=true,
        linearized=true,
        energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
        dp_nominal(each displayUnit="Pa") = {0,0,0},
        portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
             else Modelica.Fluid.Types.PortFlowDirection.Entering,
        portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
             else Modelica.Fluid.Types.PortFlowDirection.Leaving,
        portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
             else Modelica.Fluid.Types.PortFlowDirection.Leaving)
        "Splitter for room supply"
        annotation (Placement(transformation(extent={{1090,-30},{1110,-50}})));
      Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
            Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
        annotation (Placement(transformation(extent={{-360,170},{-340,190}})));
      Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather Data Bus"
        annotation (Placement(transformation(extent={{-330,170},{-310,190}}),
            iconTransformation(extent={{-360,170},{-340,190}})));
      FaultInjection.Experimental.VAVReheat.ThermalZones.Floor flo(
        redeclare final package Medium = MediumA,
        final lat=lat,
        final use_windPressure=use_windPressure,
        final sampleModel=sampleModel)
        "Model of a floor of the building that is served by this VAV system"
        annotation (Placement(transformation(extent={{772,396},{1100,616}})));
      Modelica.Blocks.Routing.DeMultiplex5 TRooAir(u(each unit="K", each
            displayUnit="degC")) "Demultiplex for room air temperature"
        annotation (Placement(transformation(extent={{490,160},{510,180}})));

      Buildings.Fluid.Sensors.TemperatureTwoPort TSupCor(
        redeclare package Medium = MediumA,
        initType=Modelica.Blocks.Types.Init.InitialState,
        m_flow_nominal=mCor_flow_nominal,
        allowFlowReversal=allowFlowReversal) "Discharge air temperature"
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={580,92})));
      Buildings.Fluid.Sensors.TemperatureTwoPort TSupSou(
        redeclare package Medium = MediumA,
        initType=Modelica.Blocks.Types.Init.InitialState,
        m_flow_nominal=mSou_flow_nominal,
        allowFlowReversal=allowFlowReversal) "Discharge air temperature"
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={760,92})));
      Buildings.Fluid.Sensors.TemperatureTwoPort TSupEas(
        redeclare package Medium = MediumA,
        initType=Modelica.Blocks.Types.Init.InitialState,
        m_flow_nominal=mEas_flow_nominal,
        allowFlowReversal=allowFlowReversal) "Discharge air temperature"
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={940,90})));
      Buildings.Fluid.Sensors.TemperatureTwoPort TSupNor(
        redeclare package Medium = MediumA,
        initType=Modelica.Blocks.Types.Init.InitialState,
        m_flow_nominal=mNor_flow_nominal,
        allowFlowReversal=allowFlowReversal) "Discharge air temperature"
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={1100,94})));
      Buildings.Fluid.Sensors.TemperatureTwoPort TSupWes(
        redeclare package Medium = MediumA,
        initType=Modelica.Blocks.Types.Init.InitialState,
        m_flow_nominal=mWes_flow_nominal,
        allowFlowReversal=allowFlowReversal) "Discharge air temperature"
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={1300,90})));
      Buildings.Fluid.Sensors.VolumeFlowRate VSupCor_flow(
        redeclare package Medium = MediumA,
        initType=Modelica.Blocks.Types.Init.InitialState,
        m_flow_nominal=mCor_flow_nominal,
        allowFlowReversal=allowFlowReversal) "Discharge air flow rate" annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={580,130})));
      Buildings.Fluid.Sensors.VolumeFlowRate VSupSou_flow(
        redeclare package Medium = MediumA,
        initType=Modelica.Blocks.Types.Init.InitialState,
        m_flow_nominal=mSou_flow_nominal,
        allowFlowReversal=allowFlowReversal) "Discharge air flow rate" annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={760,130})));
      Buildings.Fluid.Sensors.VolumeFlowRate VSupEas_flow(
        redeclare package Medium = MediumA,
        initType=Modelica.Blocks.Types.Init.InitialState,
        m_flow_nominal=mEas_flow_nominal,
        allowFlowReversal=allowFlowReversal) "Discharge air flow rate" annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={940,128})));
      Buildings.Fluid.Sensors.VolumeFlowRate VSupNor_flow(
        redeclare package Medium = MediumA,
        initType=Modelica.Blocks.Types.Init.InitialState,
        m_flow_nominal=mNor_flow_nominal,
        allowFlowReversal=allowFlowReversal) "Discharge air flow rate" annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={1100,132})));
      Buildings.Fluid.Sensors.VolumeFlowRate VSupWes_flow(
        redeclare package Medium = MediumA,
        initType=Modelica.Blocks.Types.Init.InitialState,
        m_flow_nominal=mWes_flow_nominal,
        allowFlowReversal=allowFlowReversal) "Discharge air flow rate" annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={1300,128})));
      FaultInjection.Experimental.VAVReheat.BaseClasses.MixingBox eco(
        redeclare package Medium = MediumA,
        mOut_flow_nominal=m_flow_nominal,
        dpOut_nominal=10,
        mRec_flow_nominal=m_flow_nominal,
        dpRec_nominal=10,
        mExh_flow_nominal=m_flow_nominal,
        dpExh_nominal=10,
        from_dp=false) "Economizer" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-10,-46})));

      Results res(
        final A=ATot,
        PFan=fanSup.P + 0,
        PHea=heaCoi.Q2_flow + cor.terHea.Q1_flow + nor.terHea.Q1_flow + wes.terHea.Q1_flow
             + eas.terHea.Q1_flow + sou.terHea.Q1_flow,
        PCooSen=cooCoi.QSen2_flow,
        PCooLat=cooCoi.QLat2_flow) "Results of the simulation";
      /*fanRet*/

    protected
      model Results "Model to store the results of the simulation"
        parameter Modelica.SIunits.Area A "Floor area";
        input Modelica.SIunits.Power PFan "Fan energy";
        input Modelica.SIunits.Power PHea "Heating energy";
        input Modelica.SIunits.Power PCooSen "Sensible cooling energy";
        input Modelica.SIunits.Power PCooLat "Latent cooling energy";

        Real EFan(
          unit="J/m2",
          start=0,
          nominal=1E5,
          fixed=true) "Fan energy";
        Real EHea(
          unit="J/m2",
          start=0,
          nominal=1E5,
          fixed=true) "Heating energy";
        Real ECooSen(
          unit="J/m2",
          start=0,
          nominal=1E5,
          fixed=true) "Sensible cooling energy";
        Real ECooLat(
          unit="J/m2",
          start=0,
          nominal=1E5,
          fixed=true) "Latent cooling energy";
        Real ECoo(unit="J/m2") "Total cooling energy";
      equation

        A*der(EFan) = PFan;
        A*der(EHea) = PHea;
        A*der(ECooSen) = PCooSen;
        A*der(ECooLat) = PCooLat;
        ECoo = ECooSen + ECooLat;

      end Results;
    public
      Buildings.Controls.OBC.CDL.Logical.OnOffController freSta(bandwidth=1)
        "Freeze stat for heating coil"
        annotation (Placement(transformation(extent={{0,-102},{20,-82}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant freStaTSetPoi(k=273.15
             + 3) "Freeze stat set point for heating coil"
        annotation (Placement(transformation(extent={{-40,-96},{-20,-76}})));

    equation
      connect(fanSup.port_b, dpDisSupFan.port_a) annotation (Line(
          points={{320,-40},{320,-10}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dot));
      connect(TSup.port_a, fanSup.port_b) annotation (Line(
          points={{330,-40},{320,-40}},
          color={0,127,255},
          smooth=Smooth.None,
          thickness=0.5));
      connect(amb.ports[1], VOut1.port_a) annotation (Line(
          points={{-114,-42.0667},{-94,-42.0667},{-94,-33},{-72,-33}},
          color={170,213,255},
          thickness=0.5));
      connect(splRetRoo1.port_1, dpRetDuc.port_a) annotation (Line(
          points={{630,0},{430,0},{430,140},{400,140}},
          color={170,213,255},
          thickness=0.5));
      connect(splRetNor.port_1, splRetEas.port_2) annotation (Line(
          points={{1142,0},{1110,0},{1110,0},{1078,0},{1078,0},{1012,0}},
          color={170,213,255},
          thickness=0.5));
      connect(splRetEas.port_1, splRetSou.port_2) annotation (Line(
          points={{992,0},{952,0},{952,0},{912,0},{912,0},{832,0}},
          color={170,213,255},
          thickness=0.5));
      connect(splRetSou.port_1, splRetRoo1.port_2) annotation (Line(
          points={{812,0},{650,0}},
          color={170,213,255},
          thickness=0.5));
      connect(splSupRoo1.port_3, cor.port_a) annotation (Line(
          points={{580,-30},{580,22}},
          color={170,213,255},
          thickness=0.5));
      connect(splSupRoo1.port_2, splSupSou.port_1) annotation (Line(
          points={{590,-40},{750,-40}},
          color={170,213,255},
          thickness=0.5));
      connect(splSupSou.port_3, sou.port_a) annotation (Line(
          points={{760,-30},{760,20}},
          color={170,213,255},
          thickness=0.5));
      connect(splSupSou.port_2, splSupEas.port_1) annotation (Line(
          points={{770,-40},{930,-40}},
          color={170,213,255},
          thickness=0.5));
      connect(splSupEas.port_3, eas.port_a) annotation (Line(
          points={{940,-30},{940,20}},
          color={170,213,255},
          thickness=0.5));
      connect(splSupEas.port_2, splSupNor.port_1) annotation (Line(
          points={{950,-40},{1090,-40}},
          color={170,213,255},
          thickness=0.5));
      connect(splSupNor.port_3, nor.port_a) annotation (Line(
          points={{1100,-30},{1100,20}},
          color={170,213,255},
          thickness=0.5));
      connect(splSupNor.port_2, wes.port_a) annotation (Line(
          points={{1110,-40},{1300,-40},{1300,20}},
          color={170,213,255},
          thickness=0.5));
      connect(weaDat.weaBus, weaBus) annotation (Line(
          points={{-340,180},{-320,180}},
          color={255,204,51},
          thickness=0.5,
          smooth=Smooth.None));
      connect(weaBus.TDryBul, TOut.u) annotation (Line(
          points={{-320,180},{-302,180}},
          color={255,204,51},
          thickness=0.5,
          smooth=Smooth.None));
      connect(amb.weaBus, weaBus) annotation (Line(
          points={{-136,-44.78},{-320,-44.78},{-320,180}},
          color={255,204,51},
          thickness=0.5,
          smooth=Smooth.None));
      connect(splRetRoo1.port_3, flo.portsCor[2]) annotation (Line(
          points={{640,10},{640,364},{874,364},{874,472},{898,472},{898,449.533},{
              924.286,449.533}},
          color={170,213,255},
          thickness=0.5));
      connect(splRetSou.port_3, flo.portsSou[2]) annotation (Line(
          points={{822,10},{822,350},{900,350},{900,420.2},{924.286,420.2}},
          color={170,213,255},
          thickness=0.5));
      connect(splRetEas.port_3, flo.portsEas[2]) annotation (Line(
          points={{1002,10},{1002,368},{1067.2,368},{1067.2,445.867}},
          color={170,213,255},
          thickness=0.5));
      connect(splRetNor.port_3, flo.portsNor[2]) annotation (Line(
          points={{1152,10},{1152,446},{924.286,446},{924.286,478.867}},
          color={170,213,255},
          thickness=0.5));
      connect(splRetNor.port_2, flo.portsWes[2]) annotation (Line(
          points={{1162,0},{1342,0},{1342,394},{854,394},{854,449.533}},
          color={170,213,255},
          thickness=0.5));
      connect(weaBus, flo.weaBus) annotation (Line(
          points={{-320,180},{-320,506},{988.714,506}},
          color={255,204,51},
          thickness=0.5,
          smooth=Smooth.None));
      connect(flo.TRooAir, min.u) annotation (Line(
          points={{1094.14,491.333},{1164.7,491.333},{1164.7,450},{1198,450}},
          color={0,0,127},
          smooth=Smooth.None,
          pattern=LinePattern.Dash));
      connect(flo.TRooAir, ave.u) annotation (Line(
          points={{1094.14,491.333},{1166,491.333},{1166,420},{1198,420}},
          color={0,0,127},
          smooth=Smooth.None,
          pattern=LinePattern.Dash));
      connect(TRooAir.u, flo.TRooAir) annotation (Line(
          points={{488,170},{480,170},{480,538},{1164,538},{1164,491.333},{1094.14,
              491.333}},
          color={0,0,127},
          smooth=Smooth.None,
          pattern=LinePattern.Dash));

      connect(cooCoi.port_b2, fanSup.port_a) annotation (Line(
          points={{210,-40},{300,-40}},
          color={170,213,255},
          thickness=0.5));
      connect(cor.port_b, TSupCor.port_a) annotation (Line(
          points={{580,62},{580,82}},
          color={170,213,255},
          thickness=0.5));

      connect(sou.port_b, TSupSou.port_a) annotation (Line(
          points={{760,60},{760,82}},
          color={170,213,255},
          thickness=0.5));
      connect(eas.port_b, TSupEas.port_a) annotation (Line(
          points={{940,60},{940,80}},
          color={170,213,255},
          thickness=0.5));
      connect(nor.port_b, TSupNor.port_a) annotation (Line(
          points={{1100,60},{1100,84}},
          color={170,213,255},
          thickness=0.5));
      connect(wes.port_b, TSupWes.port_a) annotation (Line(
          points={{1300,60},{1300,80}},
          color={170,213,255},
          thickness=0.5));

      connect(TSupCor.port_b, VSupCor_flow.port_a) annotation (Line(
          points={{580,102},{580,120}},
          color={170,213,255},
          thickness=0.5));
      connect(TSupSou.port_b, VSupSou_flow.port_a) annotation (Line(
          points={{760,102},{760,120}},
          color={170,213,255},
          thickness=0.5));
      connect(TSupEas.port_b, VSupEas_flow.port_a) annotation (Line(
          points={{940,100},{940,100},{940,118}},
          color={170,213,255},
          thickness=0.5));
      connect(TSupNor.port_b, VSupNor_flow.port_a) annotation (Line(
          points={{1100,104},{1100,122}},
          color={170,213,255},
          thickness=0.5));
      connect(TSupWes.port_b, VSupWes_flow.port_a) annotation (Line(
          points={{1300,100},{1300,118}},
          color={170,213,255},
          thickness=0.5));
      connect(VSupCor_flow.port_b, flo.portsCor[1]) annotation (Line(
          points={{580,140},{580,372},{866,372},{866,480},{912.571,480},{912.571,
              449.533}},
          color={170,213,255},
          thickness=0.5));

      connect(VSupSou_flow.port_b, flo.portsSou[1]) annotation (Line(
          points={{760,140},{760,356},{912.571,356},{912.571,420.2}},
          color={170,213,255},
          thickness=0.5));
      connect(VSupEas_flow.port_b, flo.portsEas[1]) annotation (Line(
          points={{940,138},{940,376},{1055.49,376},{1055.49,445.867}},
          color={170,213,255},
          thickness=0.5));
      connect(VSupNor_flow.port_b, flo.portsNor[1]) annotation (Line(
          points={{1100,142},{1100,498},{912.571,498},{912.571,478.867}},
          color={170,213,255},
          thickness=0.5));
      connect(VSupWes_flow.port_b, flo.portsWes[1]) annotation (Line(
          points={{1300,138},{1300,384},{842.286,384},{842.286,449.533}},
          color={170,213,255},
          thickness=0.5));
      connect(VOut1.port_b, eco.port_Out) annotation (Line(
          points={{-50,-33},{-42,-33},{-42,-40},{-20,-40}},
          color={170,213,255},
          thickness=0.5));
      connect(eco.port_Sup, TMix.port_a) annotation (Line(
          points={{0,-40},{30,-40}},
          color={170,213,255},
          thickness=0.5));
      connect(eco.port_Exh, amb.ports[2]) annotation (Line(
          points={{-20,-52},{-96,-52},{-96,-45},{-114,-45}},
          color={170,213,255},
          thickness=0.5));
      connect(eco.port_Ret, TRet.port_b) annotation (Line(
          points={{0,-52},{10,-52},{10,140},{90,140}},
          color={170,213,255},
          thickness=0.5));
      connect(senRetFlo.port_a, dpRetDuc.port_b)
        annotation (Line(points={{360,140},{380,140}}, color={170,213,255},
          thickness=0.5));
      connect(TSup.port_b, senSupFlo.port_a)
        annotation (Line(points={{350,-40},{400,-40}}, color={170,213,255},
          thickness=0.5));
      connect(senSupFlo.port_b, splSupRoo1.port_1)
        annotation (Line(points={{420,-40},{570,-40}}, color={170,213,255},
          thickness=0.5));
      connect(dpDisSupFan.port_b, amb.ports[3]) annotation (Line(
          points={{320,10},{320,14},{-88,14},{-88,-47.9333},{-114,-47.9333}},
          color={0,0,0},
          pattern=LinePattern.Dot));
      connect(senRetFlo.port_b, TRet.port_a) annotation (Line(points={{340,140},{
              226,140},{110,140}}, color={170,213,255},
          thickness=0.5));
      connect(freStaTSetPoi.y, freSta.reference)
        annotation (Line(points={{-18,-86},{-2,-86}}, color={0,0,127}));
      connect(freSta.u, TMix.T) annotation (Line(points={{-2,-98},{-10,-98},{-10,-70},
              {20,-70},{20,-20},{40,-20},{40,-29}}, color={0,0,127}));
      connect(TMix.port_b, heaCoi.port_a2) annotation (Line(
          points={{50,-40},{98,-40}},
          color={170,213,255},
          thickness=0.5));
      connect(heaCoi.port_b2, cooCoi.port_a2) annotation (Line(
          points={{118,-40},{190,-40}},
          color={170,213,255},
          thickness=0.5));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-380,
                -400},{1420,600}})), Documentation(info="<html>
<p>
This model consist of an HVAC system, a building envelope model and a model
for air flow through building leakage and through open doors.
</p>
<p>
The HVAC system is a variable air volume (VAV) flow system with economizer
and a heating and cooling coil in the air handler unit. There is also a
reheat coil and an air damper in each of the five zone inlet branches.
The figure below shows the schematic diagram of the HVAC system
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/vavSchematics.png\" border=\"1\"/>
</p>
<p>
Most of the HVAC control in this model is open loop.
Two models that extend this model, namely
<a href=\"modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a>
and
<a href=\"modelica://Buildings.Examples.VAVReheat.Guideline36\">
Buildings.Examples.VAVReheat.Guideline36</a>
add closed loop control. See these models for a description of
the control sequence.
</p>
<p>
To model the heat transfer through the building envelope,
a model of five interconnected rooms is used.
The five room model is representative of one floor of the
new construction medium office building for Chicago, IL,
as described in the set of DOE Commercial Building Benchmarks
(Deru et al, 2009). There are four perimeter zones and one core zone.
The envelope thermal properties meet ASHRAE Standard 90.1-2004.
The thermal room model computes transient heat conduction through
walls, floors and ceilings and long-wave radiative heat exchange between
surfaces. The convective heat transfer coefficient is computed based
on the temperature difference between the surface and the room air.
There is also a layer-by-layer short-wave radiation,
long-wave radiation, convection and conduction heat transfer model for the
windows. The model is similar to the
Window 5 model and described in TARCOG 2006.
</p>
<p>
Each thermal zone can have air flow from the HVAC system, through leakages of the building envelope (except for the core zone) and through bi-directional air exchange through open doors that connect adjacent zones. The bi-directional air exchange is modeled based on the differences in static pressure between adjacent rooms at a reference height plus the difference in static pressure across the door height as a function of the difference in air density.
Infiltration is a function of the
flow imbalance of the HVAC system.
</p>
<h4>References</h4>
<p>
Deru M., K. Field, D. Studer, K. Benne, B. Griffith, P. Torcellini,
 M. Halverson, D. Winiarski, B. Liu, M. Rosenberg, J. Huang, M. Yazdanian, and D. Crawley.
<i>DOE commercial building research benchmarks for commercial buildings</i>.
Technical report, U.S. Department of Energy, Energy Efficiency and
Renewable Energy, Office of Building Technologies, Washington, DC, 2009.
</p>
<p>
TARCOG 2006: Carli, Inc., TARCOG: Mathematical models for calculation
of thermal performance of glazing systems with our without
shading devices, Technical Report, Oct. 17, 2006.
</p>
</html>",     revisions="<html>
<ul>
<li>
September 26, 2017, by Michael Wetter:<br/>
Separated physical model from control to facilitate implementation of alternate control
sequences.
</li>
<li>
May 19, 2016, by Michael Wetter:<br/>
Changed chilled water supply temperature to <i>6&deg;C</i>.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/509\">#509</a>.
</li>
<li>
April 26, 2016, by Michael Wetter:<br/>
Changed controller for freeze protection as the old implementation closed
the outdoor air damper during summer.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/511\">#511</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
September 24, 2015 by Michael Wetter:<br/>
Set default temperature for medium to avoid conflicting
start values for alias variables of the temperature
of the building and the ambient air.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">issue 426</a>.
</li>
</ul>
</html>"));
    end PartialPhysicalAirside;

    partial model PartialAirside
      "Variable air volume flow system with terminal reheat and five thermal zones"
      extends template.BaseClasses.PartialPhysicalAirside(heaCoi(dp1_nominal=
              30000));

      parameter Modelica.SIunits.VolumeFlowRate VPriSysMax_flow=m_flow_nominal/1.2
        "Maximum expected system primary airflow rate at design stage";
      parameter Modelica.SIunits.VolumeFlowRate minZonPriFlo[numZon]={
          mCor_flow_nominal,mSou_flow_nominal,mEas_flow_nominal,mNor_flow_nominal,
          mWes_flow_nominal}/1.2 "Minimum expected zone primary flow rate";
      parameter Modelica.SIunits.Time samplePeriod=120
        "Sample period of component, set to the same value as the trim and respond that process yPreSetReq";
      parameter Modelica.SIunits.PressureDifference dpDisRetMax=40
        "Maximum return fan discharge static pressure setpoint";

      Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller conVAVCor(
        V_flow_nominal=mCor_flow_nominal/1.2,
        AFlo=AFloCor,
        final samplePeriod=samplePeriod) "Controller for terminal unit corridor"
        annotation (Placement(transformation(extent={{530,32},{550,52}})));
      Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller conVAVSou(
        V_flow_nominal=mSou_flow_nominal/1.2,
        AFlo=AFloSou,
        final samplePeriod=samplePeriod) "Controller for terminal unit south"
        annotation (Placement(transformation(extent={{700,30},{720,50}})));
      Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller conVAVEas(
        V_flow_nominal=mEas_flow_nominal/1.2,
        AFlo=AFloEas,
        final samplePeriod=samplePeriod) "Controller for terminal unit east"
        annotation (Placement(transformation(extent={{880,30},{900,50}})));
      Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller conVAVNor(
        V_flow_nominal=mNor_flow_nominal/1.2,
        AFlo=AFloNor,
        final samplePeriod=samplePeriod) "Controller for terminal unit north"
        annotation (Placement(transformation(extent={{1040,30},{1060,50}})));
      Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller conVAVWes(
        V_flow_nominal=mWes_flow_nominal/1.2,
        AFlo=AFloWes,
        final samplePeriod=samplePeriod) "Controller for terminal unit west"
        annotation (Placement(transformation(extent={{1240,28},{1260,48}})));
      Modelica.Blocks.Routing.Multiplex5 TDis "Discharge air temperatures"
        annotation (Placement(transformation(extent={{220,270},{240,290}})));
      Modelica.Blocks.Routing.Multiplex5 VDis_flow
        "Air flow rate at the terminal boxes"
        annotation (Placement(transformation(extent={{220,230},{240,250}})));
      Buildings.Controls.OBC.CDL.Integers.MultiSum TZonResReq(nin=5)
        "Number of zone temperature requests"
        annotation (Placement(transformation(extent={{300,360},{320,380}})));
      Buildings.Controls.OBC.CDL.Integers.MultiSum PZonResReq(nin=5)
        "Number of zone pressure requests"
        annotation (Placement(transformation(extent={{300,330},{320,350}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yOutDam(k=1)
        "Outdoor air damper control signal"
        annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
      Buildings.Controls.OBC.CDL.Logical.Switch swiFreSta "Switch for freeze stat"
        annotation (Placement(transformation(extent={{20,-140},{40,-120}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yFreHeaCoi(final k=0.3)
        "Flow rate signal for heating coil when freeze stat is on"
        annotation (Placement(transformation(extent={{-80,-132},{-60,-112}})));
      Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints TZonSet[
        numZon](
        final TZonHeaOn=fill(THeaOn, numZon),
        final TZonHeaOff=fill(THeaOff, numZon),
        final TZonCooOn=fill(TCooOn, numZon),
        final TZonCooOff=fill(TCooOff, numZon)) "Zone setpoint temperature"
        annotation (Placement(transformation(extent={{60,300},{80,320}})));
      Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
        final nout=numZon)
        "Replicate boolean input"
        annotation (Placement(transformation(extent={{-120,280},{-100,300}})));
      Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(
        final nout=numZon)
        "Replicate real input"
        annotation (Placement(transformation(extent={{-120,320},{-100,340}})));
      Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU(
        final pMaxSet=410,
        final yFanMin=yFanMin,
        final VPriSysMax_flow=VPriSysMax_flow,
        final peaSysPop=1.2*sum({0.05*AFlo[i] for i in 1:numZon})) "AHU controller"
        annotation (Placement(transformation(extent={{340,512},{420,640}})));
      Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone
        zonOutAirSet[numZon](
        final AFlo=AFlo,
        final have_occSen=fill(false, numZon),
        final have_winSen=fill(false, numZon),
        final desZonPop={0.05*AFlo[i] for i in 1:numZon},
        final minZonPriFlo=minZonPriFlo)
        "Zone level calculation of the minimum outdoor airflow setpoint"
        annotation (Placement(transformation(extent={{220,580},{240,600}})));
      Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone
        zonToSys(final numZon=numZon) "Sum up zone calculation output"
        annotation (Placement(transformation(extent={{280,570},{300,590}})));
      Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep1(final nout=numZon)
        "Replicate design uncorrected minimum outdoor airflow setpoint"
        annotation (Placement(transformation(extent={{460,580},{480,600}})));
      Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep1(final nout=numZon)
        "Replicate signal whether the outdoor airflow is required"
        annotation (Placement(transformation(extent={{460,550},{480,570}})));

      Modelica.Blocks.Logical.And andFreSta
        annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));
      FaultInjection.Utilities.Overwrite.OverwriteVariable oveTZonResReq(u(
          unit="1",
          min=0,
          max=15), description="Zone temperature reset request numbers")
        annotation (Placement(transformation(extent={{360,390},{380,410}})));
      Modelica.Blocks.Math.IntegerToReal int2ReaTZonResReq
        annotation (Placement(transformation(extent={{332,390},{352,410}})));
      Modelica.Blocks.Math.RealToInteger rea2IntTZonResReq
        annotation (Placement(transformation(extent={{390,390},{410,410}})));
    equation
      connect(fanSup.port_b, dpDisSupFan.port_a) annotation (Line(
          points={{320,-40},{320,0},{320,-10},{320,-10}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dot));
      connect(conVAVCor.TZon, TRooAir.y5[1]) annotation (Line(
          points={{528,42},{520,42},{520,162},{511,162}},
          color={0,0,127},
          pattern=LinePattern.Dash));
      connect(conVAVSou.TZon, TRooAir.y1[1]) annotation (Line(
          points={{698,40},{690,40},{690,40},{680,40},{680,178},{511,178}},
          color={0,0,127},
          pattern=LinePattern.Dash));
      connect(TRooAir.y2[1], conVAVEas.TZon) annotation (Line(
          points={{511,174},{868,174},{868,40},{878,40}},
          color={0,0,127},
          pattern=LinePattern.Dash));
      connect(TRooAir.y3[1], conVAVNor.TZon) annotation (Line(
          points={{511,170},{1028,170},{1028,40},{1038,40}},
          color={0,0,127},
          pattern=LinePattern.Dash));
      connect(TRooAir.y4[1], conVAVWes.TZon) annotation (Line(
          points={{511,166},{1220,166},{1220,38},{1238,38}},
          color={0,0,127},
          pattern=LinePattern.Dash));
      connect(conVAVCor.TDis, TSupCor.T) annotation (Line(points={{528,36},{522,36},
              {522,40},{514,40},{514,92},{569,92}}, color={0,0,127}));
      connect(TSupSou.T, conVAVSou.TDis) annotation (Line(points={{749,92},{688,92},
              {688,34},{698,34}}, color={0,0,127}));
      connect(TSupEas.T, conVAVEas.TDis) annotation (Line(points={{929,90},{872,90},
              {872,34},{878,34}}, color={0,0,127}));
      connect(TSupNor.T, conVAVNor.TDis) annotation (Line(points={{1089,94},{1032,
              94},{1032,34},{1038,34}}, color={0,0,127}));
      connect(TSupWes.T, conVAVWes.TDis) annotation (Line(points={{1289,90},{1228,
              90},{1228,32},{1238,32}}, color={0,0,127}));
      connect(cor.yVAV, conVAVCor.yDam) annotation (Line(points={{566,50},{556,50},{
              556,48},{552,48}}, color={0,0,127}));
      connect(cor.yVal, conVAVCor.yVal) annotation (Line(points={{566,34},{560,34},{
              560,43},{552,43}}, color={0,0,127}));
      connect(conVAVSou.yDam, sou.yVAV) annotation (Line(points={{722,46},{730,46},{
              730,48},{746,48}}, color={0,0,127}));
      connect(conVAVSou.yVal, sou.yVal) annotation (Line(points={{722,41},{732.5,41},
              {732.5,32},{746,32}}, color={0,0,127}));
      connect(conVAVEas.yVal, eas.yVal) annotation (Line(points={{902,41},{912.5,41},
              {912.5,32},{926,32}}, color={0,0,127}));
      connect(conVAVEas.yDam, eas.yVAV) annotation (Line(points={{902,46},{910,46},{
              910,48},{926,48}}, color={0,0,127}));
      connect(conVAVNor.yDam, nor.yVAV) annotation (Line(points={{1062,46},{1072.5,46},
              {1072.5,48},{1086,48}},     color={0,0,127}));
      connect(conVAVNor.yVal, nor.yVal) annotation (Line(points={{1062,41},{1072.5,41},
              {1072.5,32},{1086,32}},     color={0,0,127}));
      connect(conVAVWes.yVal, wes.yVal) annotation (Line(points={{1262,39},{1272.5,39},
              {1272.5,32},{1286,32}},     color={0,0,127}));
      connect(wes.yVAV, conVAVWes.yDam) annotation (Line(points={{1286,48},{1274,48},
              {1274,44},{1262,44}}, color={0,0,127}));
      connect(conVAVCor.yZonTemResReq, TZonResReq.u[1]) annotation (Line(points={{552,38},
              {554,38},{554,220},{280,220},{280,375.6},{298,375.6}},         color=
              {255,127,0}));
      connect(conVAVSou.yZonTemResReq, TZonResReq.u[2]) annotation (Line(points={{722,36},
              {726,36},{726,220},{280,220},{280,372.8},{298,372.8}},         color=
              {255,127,0}));
      connect(conVAVEas.yZonTemResReq, TZonResReq.u[3]) annotation (Line(points={{902,36},
              {904,36},{904,220},{280,220},{280,370},{298,370}},         color={255,
              127,0}));
      connect(conVAVNor.yZonTemResReq, TZonResReq.u[4]) annotation (Line(points={{1062,36},
              {1064,36},{1064,220},{280,220},{280,367.2},{298,367.2}},
            color={255,127,0}));
      connect(conVAVWes.yZonTemResReq, TZonResReq.u[5]) annotation (Line(points={{1262,34},
              {1266,34},{1266,220},{280,220},{280,364.4},{298,364.4}},
            color={255,127,0}));
      connect(conVAVCor.yZonPreResReq, PZonResReq.u[1]) annotation (Line(points={{552,34},
              {558,34},{558,214},{288,214},{288,345.6},{298,345.6}},         color=
              {255,127,0}));
      connect(conVAVSou.yZonPreResReq, PZonResReq.u[2]) annotation (Line(points={{722,32},
              {728,32},{728,214},{288,214},{288,342.8},{298,342.8}},         color=
              {255,127,0}));
      connect(conVAVEas.yZonPreResReq, PZonResReq.u[3]) annotation (Line(points={{902,32},
              {906,32},{906,214},{288,214},{288,340},{298,340}},         color={255,
              127,0}));
      connect(conVAVNor.yZonPreResReq, PZonResReq.u[4]) annotation (Line(points={{1062,32},
              {1066,32},{1066,214},{288,214},{288,337.2},{298,337.2}},
            color={255,127,0}));
      connect(conVAVWes.yZonPreResReq, PZonResReq.u[5]) annotation (Line(points={{1262,30},
              {1268,30},{1268,214},{288,214},{288,334.4},{298,334.4}},
            color={255,127,0}));
      connect(VSupCor_flow.V_flow, VDis_flow.u1[1]) annotation (Line(points={{569,130},
              {472,130},{472,206},{180,206},{180,250},{218,250}},      color={0,0,
              127}));
      connect(VSupSou_flow.V_flow, VDis_flow.u2[1]) annotation (Line(points={{749,130},
              {742,130},{742,206},{180,206},{180,245},{218,245}},      color={0,0,
              127}));
      connect(VSupEas_flow.V_flow, VDis_flow.u3[1]) annotation (Line(points={{929,128},
              {914,128},{914,206},{180,206},{180,240},{218,240}},      color={0,0,
              127}));
      connect(VSupNor_flow.V_flow, VDis_flow.u4[1]) annotation (Line(points={{1089,132},
              {1080,132},{1080,206},{180,206},{180,235},{218,235}},      color={0,0,
              127}));
      connect(VSupWes_flow.V_flow, VDis_flow.u5[1]) annotation (Line(points={{1289,128},
              {1284,128},{1284,206},{180,206},{180,230},{218,230}},      color={0,0,
              127}));
      connect(TSupCor.T, TDis.u1[1]) annotation (Line(points={{569,92},{466,92},{466,
              210},{176,210},{176,290},{218,290}},     color={0,0,127}));
      connect(TSupSou.T, TDis.u2[1]) annotation (Line(points={{749,92},{688,92},{688,
              210},{176,210},{176,285},{218,285}},                       color={0,0,
              127}));
      connect(TSupEas.T, TDis.u3[1]) annotation (Line(points={{929,90},{872,90},{872,
              210},{176,210},{176,280},{218,280}},     color={0,0,127}));
      connect(TSupNor.T, TDis.u4[1]) annotation (Line(points={{1089,94},{1032,94},{1032,
              210},{176,210},{176,275},{218,275}},      color={0,0,127}));
      connect(TSupWes.T, TDis.u5[1]) annotation (Line(points={{1289,90},{1228,90},{1228,
              210},{176,210},{176,270},{218,270}},      color={0,0,127}));
      connect(conVAVCor.VDis_flow, VSupCor_flow.V_flow) annotation (Line(points={{528,40},
              {522,40},{522,130},{569,130}}, color={0,0,127}));
      connect(VSupSou_flow.V_flow, conVAVSou.VDis_flow) annotation (Line(points={{749,130},
              {690,130},{690,38},{698,38}},      color={0,0,127}));
      connect(VSupEas_flow.V_flow, conVAVEas.VDis_flow) annotation (Line(points={{929,128},
              {874,128},{874,38},{878,38}},      color={0,0,127}));
      connect(VSupNor_flow.V_flow, conVAVNor.VDis_flow) annotation (Line(points={{1089,
              132},{1034,132},{1034,38},{1038,38}}, color={0,0,127}));
      connect(VSupWes_flow.V_flow, conVAVWes.VDis_flow) annotation (Line(points={{1289,
              128},{1230,128},{1230,36},{1238,36}}, color={0,0,127}));
      connect(TSup.T, conVAVCor.TSupAHU) annotation (Line(points={{340,-29},{340,
              -20},{514,-20},{514,34},{528,34}},
                                            color={0,0,127}));
      connect(TSup.T, conVAVSou.TSupAHU) annotation (Line(points={{340,-29},{340,
              -20},{686,-20},{686,32},{698,32}},
                                            color={0,0,127}));
      connect(TSup.T, conVAVEas.TSupAHU) annotation (Line(points={{340,-29},{340,
              -20},{864,-20},{864,32},{878,32}},
                                            color={0,0,127}));
      connect(TSup.T, conVAVNor.TSupAHU) annotation (Line(points={{340,-29},{340,
              -20},{1028,-20},{1028,32},{1038,32}},
                                               color={0,0,127}));
      connect(TSup.T, conVAVWes.TSupAHU) annotation (Line(points={{340,-29},{340,
              -20},{1224,-20},{1224,30},{1238,30}},
                                               color={0,0,127}));
      connect(yOutDam.y, eco.yExh)
        annotation (Line(points={{-18,-10},{-3,-10},{-3,-34}}, color={0,0,127}));
      connect(yFreHeaCoi.y, swiFreSta.u1) annotation (Line(points={{-58,-122},{18,
              -122}},               color={0,0,127}));
      connect(TZonSet[1].yOpeMod, conVAVCor.uOpeMod) annotation (Line(points={{82,303},
              {130,303},{130,180},{420,180},{420,14},{520,14},{520,32},{528,32}},
            color={255,127,0}));
      connect(occSch.occupied, booRep.u) annotation (Line(points={{-297,-76},{-160,
              -76},{-160,290},{-122,290}},  color={255,0,255}));
      connect(occSch.tNexOcc, reaRep.u) annotation (Line(points={{-297,-64},{-180,
              -64},{-180,330},{-122,330}},
                                      color={0,0,127}));
      connect(reaRep.y, TZonSet.tNexOcc) annotation (Line(points={{-98,330},{-20,330},
              {-20,319},{58,319}}, color={0,0,127}));
      connect(booRep.y, TZonSet.uOcc) annotation (Line(points={{-98,290},{-20,290},{
              -20,316.025},{58,316.025}}, color={255,0,255}));
      connect(TZonSet[1].TZonHeaSet, conVAVCor.TZonHeaSet) annotation (Line(points={{82,310},
              {524,310},{524,52},{528,52}},          color={0,0,127}));
      connect(TZonSet[1].TZonCooSet, conVAVCor.TZonCooSet) annotation (Line(points={{82,317},
              {524,317},{524,50},{528,50}},          color={0,0,127}));
      connect(TZonSet[2].TZonHeaSet, conVAVSou.TZonHeaSet) annotation (Line(points={{82,310},
              {694,310},{694,50},{698,50}},          color={0,0,127}));
      connect(TZonSet[2].TZonCooSet, conVAVSou.TZonCooSet) annotation (Line(points={{82,317},
              {694,317},{694,48},{698,48}},          color={0,0,127}));
      connect(TZonSet[3].TZonHeaSet, conVAVEas.TZonHeaSet) annotation (Line(points={{82,310},
              {860,310},{860,50},{878,50}},          color={0,0,127}));
      connect(TZonSet[3].TZonCooSet, conVAVEas.TZonCooSet) annotation (Line(points={{82,317},
              {860,317},{860,48},{878,48}},          color={0,0,127}));
      connect(TZonSet[4].TZonCooSet, conVAVNor.TZonCooSet) annotation (Line(points={{82,317},
              {1020,317},{1020,48},{1038,48}},          color={0,0,127}));
      connect(TZonSet[4].TZonHeaSet, conVAVNor.TZonHeaSet) annotation (Line(points={{82,310},
              {1020,310},{1020,50},{1038,50}},          color={0,0,127}));
      connect(TZonSet[5].TZonCooSet, conVAVWes.TZonCooSet) annotation (Line(points={{82,317},
              {1200,317},{1200,46},{1238,46}},          color={0,0,127}));
      connect(TZonSet[5].TZonHeaSet, conVAVWes.TZonHeaSet) annotation (Line(points={{82,310},
              {1200,310},{1200,48},{1238,48}},          color={0,0,127}));
      connect(TZonSet[1].yOpeMod, conVAVSou.uOpeMod) annotation (Line(points={{82,303},
              {130,303},{130,180},{420,180},{420,14},{680,14},{680,30},{698,30}},
            color={255,127,0}));
      connect(TZonSet[1].yOpeMod, conVAVEas.uOpeMod) annotation (Line(points={{82,303},
              {130,303},{130,180},{420,180},{420,14},{860,14},{860,30},{878,30}},
            color={255,127,0}));
      connect(TZonSet[1].yOpeMod, conVAVNor.uOpeMod) annotation (Line(points={{82,303},
              {130,303},{130,180},{420,180},{420,14},{1020,14},{1020,30},{1038,30}},
            color={255,127,0}));
      connect(TZonSet[1].yOpeMod, conVAVWes.uOpeMod) annotation (Line(points={{82,303},
              {130,303},{130,180},{420,180},{420,14},{1220,14},{1220,28},{1238,28}},
            color={255,127,0}));
      connect(zonToSys.ySumDesZonPop, conAHU.sumDesZonPop) annotation (Line(points={{302,589},
              {308,589},{308,609.778},{336,609.778}},           color={0,0,127}));
      connect(zonToSys.VSumDesPopBreZon_flow, conAHU.VSumDesPopBreZon_flow)
        annotation (Line(points={{302,586},{310,586},{310,604.444},{336,604.444}},
            color={0,0,127}));
      connect(zonToSys.VSumDesAreBreZon_flow, conAHU.VSumDesAreBreZon_flow)
        annotation (Line(points={{302,583},{312,583},{312,599.111},{336,599.111}},
            color={0,0,127}));
      connect(zonToSys.yDesSysVenEff, conAHU.uDesSysVenEff) annotation (Line(points={{302,580},
              {314,580},{314,593.778},{336,593.778}},           color={0,0,127}));
      connect(zonToSys.VSumUncOutAir_flow, conAHU.VSumUncOutAir_flow) annotation (
          Line(points={{302,577},{316,577},{316,588.444},{336,588.444}}, color={0,0,
              127}));
      connect(zonToSys.VSumSysPriAir_flow, conAHU.VSumSysPriAir_flow) annotation (
          Line(points={{302,571},{318,571},{318,583.111},{336,583.111}}, color={0,0,
              127}));
      connect(zonToSys.uOutAirFra_max, conAHU.uOutAirFra_max) annotation (Line(
            points={{302,574},{320,574},{320,577.778},{336,577.778}}, color={0,0,127}));
      connect(zonOutAirSet.yDesZonPeaOcc, zonToSys.uDesZonPeaOcc) annotation (Line(
            points={{242,599},{270,599},{270,588},{278,588}},     color={0,0,127}));
      connect(zonOutAirSet.VDesPopBreZon_flow, zonToSys.VDesPopBreZon_flow)
        annotation (Line(points={{242,596},{268,596},{268,586},{278,586}},
                                                         color={0,0,127}));
      connect(zonOutAirSet.VDesAreBreZon_flow, zonToSys.VDesAreBreZon_flow)
        annotation (Line(points={{242,593},{266,593},{266,584},{278,584}},
            color={0,0,127}));
      connect(zonOutAirSet.yDesPriOutAirFra, zonToSys.uDesPriOutAirFra) annotation (
         Line(points={{242,590},{264,590},{264,578},{278,578}},     color={0,0,127}));
      connect(zonOutAirSet.VUncOutAir_flow, zonToSys.VUncOutAir_flow) annotation (
          Line(points={{242,587},{262,587},{262,576},{278,576}},     color={0,0,127}));
      connect(zonOutAirSet.yPriOutAirFra, zonToSys.uPriOutAirFra)
        annotation (Line(points={{242,584},{260,584},{260,574},{278,574}},
                                                         color={0,0,127}));
      connect(zonOutAirSet.VPriAir_flow, zonToSys.VPriAir_flow) annotation (Line(
            points={{242,581},{258,581},{258,572},{278,572}},     color={0,0,127}));
      connect(conAHU.yAveOutAirFraPlu, zonToSys.yAveOutAirFraPlu) annotation (Line(
            points={{424,586.667},{440,586.667},{440,468},{270,468},{270,582},{
              278,582}},
            color={0,0,127}));
      connect(conAHU.VDesUncOutAir_flow, reaRep1.u) annotation (Line(points={{424,
              597.333},{440,597.333},{440,590},{458,590}},
                                                  color={0,0,127}));
      connect(reaRep1.y, zonOutAirSet.VUncOut_flow_nominal) annotation (Line(points={{482,590},
              {490,590},{490,464},{210,464},{210,581},{218,581}},          color={0,
              0,127}));
      connect(conAHU.yReqOutAir, booRep1.u) annotation (Line(points={{424,
              565.333},{444,565.333},{444,560},{458,560}},
                                                 color={255,0,255}));
      connect(booRep1.y, zonOutAirSet.uReqOutAir) annotation (Line(points={{482,560},
              {496,560},{496,460},{206,460},{206,593},{218,593}}, color={255,0,255}));
      connect(TDis.y, zonOutAirSet.TDis) annotation (Line(points={{241,280},{252,280},
              {252,340},{200,340},{200,587},{218,587}}, color={0,0,127}));
      connect(VDis_flow.y, zonOutAirSet.VDis_flow) annotation (Line(points={{241,240},
              {260,240},{260,346},{194,346},{194,584},{218,584}}, color={0,0,127}));
      connect(TZonSet[1].yOpeMod, conAHU.uOpeMod) annotation (Line(points={{82,303},
              {140,303},{140,531.556},{336,531.556}}, color={255,127,0}));
      connect(PZonResReq.y, conAHU.uZonPreResReq) annotation (Line(points={{322,340},
              {326,340},{326,520.889},{336,520.889}}, color={255,127,0}));
      connect(TZonSet[1].TZonHeaSet, conAHU.TZonHeaSet) annotation (Line(points={{82,310},
              {110,310},{110,636.444},{336,636.444}},      color={0,0,127}));
      connect(TZonSet[1].TZonCooSet, conAHU.TZonCooSet) annotation (Line(points={{82,317},
              {120,317},{120,631.111},{336,631.111}},      color={0,0,127}));
      connect(TOut.y, conAHU.TOut) annotation (Line(points={{-279,180},{-260,
              180},{-260,625.778},{336,625.778}},
                                       color={0,0,127}));
      connect(dpDisSupFan.p_rel, conAHU.ducStaPre) annotation (Line(points={{311,0},
              {160,0},{160,620.444},{336,620.444}}, color={0,0,127}));
      connect(TSup.T, conAHU.TSup) annotation (Line(points={{340,-29},{340,-20},
              {152,-20},{152,567.111},{336,567.111}},
                                                 color={0,0,127}));
      connect(TRet.T, conAHU.TOutCut) annotation (Line(points={{100,151},{100,
              561.778},{336,561.778}},
                              color={0,0,127}));
      connect(VOut1.V_flow, conAHU.VOut_flow) annotation (Line(points={{-61,
              -20.9},{-61,545.778},{336,545.778}},
                                           color={0,0,127}));
      connect(TMix.T, conAHU.TMix) annotation (Line(points={{40,-29},{40,
              538.667},{336,538.667}},
                         color={0,0,127}));
      connect(conAHU.yOutDamPos, eco.yOut) annotation (Line(points={{424,
              522.667},{448,522.667},{448,36},{-10,36},{-10,-34}},
                                                     color={0,0,127}));
      connect(conAHU.yRetDamPos, eco.yRet) annotation (Line(points={{424,
              533.333},{442,533.333},{442,40},{-16.8,40},{-16.8,-34}},
                                                         color={0,0,127}));
      connect(conAHU.yHea, swiFreSta.u3) annotation (Line(points={{424,554.667},
              {452,554.667},{452,32},{22,32},{22,-108},{10,-108},{10,-138},{18,
              -138}},                                             color={0,0,127}));
      connect(cor.y_actual,conVAVCor.yDam_actual)  annotation (Line(points={{612,58},
              {620,58},{620,74},{518,74},{518,38},{528,38}}, color={0,0,127}));
      connect(sou.y_actual,conVAVSou.yDam_actual)  annotation (Line(points={{792,56},
              {800,56},{800,76},{684,76},{684,36},{698,36}}, color={0,0,127}));
      connect(eas.y_actual,conVAVEas.yDam_actual)  annotation (Line(points={{972,56},
              {980,56},{980,74},{864,74},{864,36},{878,36}}, color={0,0,127}));
      connect(nor.y_actual,conVAVNor.yDam_actual)  annotation (Line(points={{1132,
              56},{1140,56},{1140,74},{1024,74},{1024,36},{1038,36}}, color={0,0,
              127}));
      connect(wes.y_actual,conVAVWes.yDam_actual)  annotation (Line(points={{1332,
              56},{1340,56},{1340,74},{1224,74},{1224,34},{1238,34}}, color={0,0,
              127}));
      connect(andFreSta.y, swiFreSta.u2)
        annotation (Line(points={{1,-130},{18,-130}},  color={255,0,255}));
      connect(freSta.y, andFreSta.u1) annotation (Line(points={{22,-92},{28,-92},{
              28,-112},{-40,-112},{-40,-130},{-22,-130}},
                                                     color={255,0,255}));
      connect(oveTZonResReq.u, int2ReaTZonResReq.y)
        annotation (Line(points={{358,400},{353,400}}, color={0,0,127}));
      connect(TZonResReq.y, int2ReaTZonResReq.u) annotation (Line(points={{322,370},
              {324,370},{324,400},{330,400}}, color={255,127,0}));
      connect(oveTZonResReq.y, rea2IntTZonResReq.u)
        annotation (Line(points={{381,400},{388,400}}, color={0,0,127}));
      connect(rea2IntTZonResReq.y, conAHU.uZonTemResReq) annotation (Line(points={{411,400},
              {424,400},{424,482},{324,482},{324,526.222},{336,526.222}},
            color={255,127,0}));
      connect(zonOutAirSet.TZon, flo.TRooAir) annotation (Line(points={{218,590},
              {208,590},{208,660},{1164,660},{1164,491.333},{1094.14,491.333}},
            color={0,0,127}));
      connect(flo.TRooAir, TZonSet.TZon) annotation (Line(points={{1094.14,
              491.333},{1164,491.333},{1164,660},{44,660},{44,313},{58,313}},
                                                                     color={0,0,127}));
      annotation (
        Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-380,-320},{1400,
                680}})),
        Documentation(info="<html>
<p>
This model consist of an HVAC system, a building envelope model and a model
for air flow through building leakage and through open doors.
</p>
<p>
The HVAC system is a variable air volume (VAV) flow system with economizer
and a heating and cooling coil in the air handler unit. There is also a
reheat coil and an air damper in each of the five zone inlet branches.
</p>
<p>
See the model
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop\">
Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop</a>
for a description of the HVAC system and the building envelope.
</p>
<p>
The control is based on ASHRAE Guideline 36, and implemented
using the sequences from the library
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1\">
Buildings.Controls.OBC.ASHRAE.G36_PR1</a> for
multi-zone VAV systems with economizer. The schematic diagram of the HVAC and control
sequence is shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/vavControlSchematics.png\" border=\"1\"/>
</p>
<p>
A similar model but with a different control sequence can be found in
<a href=\"modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a>.
Note that this model, because of the frequent time sampling,
has longer computing time than
<a href=\"modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a>.
The reason is that the time integrator cannot make large steps
because it needs to set a time step each time the control samples
its input.
</p>
</html>",     revisions="<html>
<ul>
<li>
April 20, 2020, by Jianjun Hu:<br/>
Exported actual VAV damper position as the measured input data for terminal controller.<br/>
This is
for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1873\">issue #1873</a>
</li>
<li>
March 20, 2020, by Jianjun Hu:<br/>
Replaced the AHU controller with reimplemented one. The new controller separates the
zone level calculation from the system level calculation and does not include
vector-valued calculations.<br/>
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1829\">#1829</a>.
</li>
<li>
March 09, 2020, by Jianjun Hu:<br/>
Replaced the block that calculates operation mode and zone temperature setpoint,
with the new one that does not include vector-valued calculations.<br/>
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1709\">#1709</a>.
</li>
<li>
May 19, 2016, by Michael Wetter:<br/>
Changed chilled water supply temperature to <i>6&deg;C</i>.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/509\">#509</a>.
</li>
<li>
April 26, 2016, by Michael Wetter:<br/>
Changed controller for freeze protection as the old implementation closed
the outdoor air damper during summer.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/511\">#511</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
September 24, 2015 by Michael Wetter:<br/>
Set default temperature for medium to avoid conflicting
start values for alias variables of the temperature
of the building and the ambient air.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">issue 426</a>.
</li>
</ul>
</html>"),
        __Dymola_Commands(file=
              "modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVReheat/Guideline36.mos"
            "Simulate and plot"),
        experiment(StopTime=172800, Tolerance=1e-06),
        Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
    end PartialAirside;

    partial model EnergyMeter "System example for fault injection"

     Modelica.Blocks.Sources.RealExpression eleSupFan(y=fanSup.P) "Pow of fan"
        annotation (Placement(transformation(extent={{1220,580},{1240,600}})));
      Modelica.Blocks.Sources.RealExpression eleChi(y=chiWSE.powChi[1])
        "Power of chiller"
        annotation (Placement(transformation(extent={{1220,560},{1240,580}})));
      Modelica.Blocks.Sources.RealExpression eleCHWP(y=chiWSE.powPum[1])
        "Power of chilled water pump"
        annotation (Placement(transformation(extent={{1220,540},{1240,560}})));
      Modelica.Blocks.Sources.RealExpression eleCWP(y=pumCW.P) "Power of CWP"
        annotation (Placement(transformation(extent={{1220,520},{1240,540}})));
      Modelica.Blocks.Sources.RealExpression eleCT(y=cooTow.PFan)
        "Power of cooling tower"
        annotation (Placement(transformation(extent={{1220,500},{1240,520}})));
      Modelica.Blocks.Sources.RealExpression eleHWP(y=pumHW.P)
        "Power of hot water pump"
        annotation (Placement(transformation(extent={{1220,480},{1240,500}})));
      Modelica.Blocks.Sources.RealExpression eleCoiVAV(y=cor.terHea.Q1_flow + nor.terHea.Q1_flow
             + wes.terHea.Q1_flow + eas.terHea.Q1_flow + sou.terHea.Q1_flow)
        "Power of VAV terminal reheat coil"
        annotation (Placement(transformation(extent={{1220,602},{1240,622}})));
      Modelica.Blocks.Sources.RealExpression gasBoi(y=boi.QFue_flow)
        "Gas consumption of gas boiler"
        annotation (Placement(transformation(extent={{1220,452},{1240,472}})));
      Modelica.Blocks.Math.MultiSum eleTot(nu=7) "Electricity in total"
        annotation (Placement(transformation(extent={{1284,606},{1296,618}})));

    equation
      connect(eleCoiVAV.y, eleTot.u[1]) annotation (Line(points={{1241,612},{1262,
              612},{1262,615.6},{1284,615.6}}, color={0,0,127}));
      connect(eleSupFan.y, eleTot.u[2]) annotation (Line(points={{1241,590},{1262.5,
              590},{1262.5,614.4},{1284,614.4}}, color={0,0,127}));
      connect(eleChi.y, eleTot.u[3]) annotation (Line(points={{1241,570},{1264,570},
              {1264,613.2},{1284,613.2}}, color={0,0,127}));
      connect(eleCHWP.y, eleTot.u[4]) annotation (Line(points={{1241,550},{1266,550},
              {1266,612},{1284,612}}, color={0,0,127}));
      connect(eleCWP.y, eleTot.u[5]) annotation (Line(points={{1241,530},{1268,530},
              {1268,610.8},{1284,610.8}}, color={0,0,127}));
      connect(eleCT.y, eleTot.u[6]) annotation (Line(points={{1241,510},{1270,510},
              {1270,609.6},{1284,609.6}}, color={0,0,127}));
      connect(eleHWP.y, eleTot.u[7]) annotation (Line(points={{1241,490},{1272,490},
              {1272,608.4},{1284,608.4}}, color={0,0,127}));
      annotation (Diagram(coordinateSystem(extent={{-100,-100},{1580,700}})), Icon(
            coordinateSystem(extent={{-100,-100},{1580,700}})));
    end EnergyMeter;

    partial model RunTime "Equipment run time"

      Modelica.Blocks.Continuous.Integrator  chiRunTim "Chiller run time"
        annotation (Placement(transformation(extent={{1340,630},{1360,650}})));

      Modelica.Blocks.Continuous.Integrator boiRunTim "Boiler run time"
        annotation (Placement(transformation(extent={{1340,600},{1360,620}})));
      Modelica.Blocks.Continuous.Integrator supFanRunTim "Supply fan run time"
        annotation (Placement(transformation(extent={{1340,570},{1360,590}})));
      Modelica.Blocks.Continuous.Integrator cooTowRunTim "Cooling tower run time"
        annotation (Placement(transformation(extent={{1340,540},{1360,560}})));
      Modelica.Blocks.Continuous.Integrator  CHWPRunTim "CHWP run time"
        annotation (Placement(transformation(extent={{1400,630},{1420,650}})));
      Modelica.Blocks.Continuous.Integrator CWPRunTim "CWP run time"
        annotation (Placement(transformation(extent={{1400,600},{1420,620}})));
      Modelica.Blocks.Continuous.Integrator HWPRunTim "HWP run time"
        annotation (Placement(transformation(extent={{1400,570},{1420,590}})));
      annotation (Diagram(coordinateSystem(extent={{-100,-100},{1580,700}})), Icon(
            coordinateSystem(extent={{-100,-100},{1580,700}})));
    end RunTime;
  end BaseClasses;
  annotation (uses(
      Modelica(version="3.2.3"),
      FaultInjection(version="1.0.0"),
      Buildings(version="7.0.0")));
end template;
