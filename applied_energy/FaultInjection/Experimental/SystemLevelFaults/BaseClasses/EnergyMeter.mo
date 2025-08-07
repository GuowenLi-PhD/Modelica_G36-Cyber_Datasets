within FaultInjection.Experimental.SystemLevelFaults.BaseClasses;
partial model EnergyMeter "System example for fault injection"

 Modelica.Blocks.Sources.RealExpression eleSupFan(y=fanSup.P) "Pow of fan"
    annotation (Placement(transformation(extent={{1280,578},{1300,598}})));
  Modelica.Blocks.Sources.RealExpression eleChi(y=chiWSE.powChi[1])
    "Power of chiller"
    annotation (Placement(transformation(extent={{1280,558},{1300,578}})));
  Modelica.Blocks.Sources.RealExpression eleCHWP(y=chiWSE.powPum[1])
    "Power of chilled water pump"
    annotation (Placement(transformation(extent={{1280,538},{1300,558}})));
  Modelica.Blocks.Sources.RealExpression eleCWP(y=pumCW.P) "Power of CWP"
    annotation (Placement(transformation(extent={{1280,518},{1300,538}})));
  Modelica.Blocks.Sources.RealExpression eleCT(y=cooTow.PFan)
    "Power of cooling tower"
    annotation (Placement(transformation(extent={{1280,498},{1300,518}})));
  Modelica.Blocks.Sources.RealExpression eleHWP(y=pumHW.P)
    "Power of hot water pump"
    annotation (Placement(transformation(extent={{1280,478},{1300,498}})));
  Modelica.Blocks.Sources.RealExpression eleCoiVAV(y=cor.terHea.Q1_flow + nor.terHea.Q1_flow
         + wes.terHea.Q1_flow + eas.terHea.Q1_flow + sou.terHea.Q1_flow)
    "Power of VAV terminal reheat coil"
    annotation (Placement(transformation(extent={{1280,600},{1300,620}})));
  Modelica.Blocks.Sources.RealExpression gasBoi(y=boi.QFue_flow)
    "Gas consumption of gas boiler"
    annotation (Placement(transformation(extent={{1280,450},{1300,470}})));
  Modelica.Blocks.Math.MultiSum eleTot(nu=7) "Electricity in total"
    annotation (Placement(transformation(extent={{1344,604},{1356,616}})));

equation
  connect(eleCoiVAV.y, eleTot.u[1]) annotation (Line(points={{1301,610},{1322,
          610},{1322,613.6},{1344,613.6}}, color={0,0,127}));
  connect(eleSupFan.y, eleTot.u[2]) annotation (Line(points={{1301,588},{1322.5,
          588},{1322.5,612.4},{1344,612.4}}, color={0,0,127}));
  connect(eleChi.y, eleTot.u[3]) annotation (Line(points={{1301,568},{1324,568},
          {1324,611.2},{1344,611.2}}, color={0,0,127}));
  connect(eleCHWP.y, eleTot.u[4]) annotation (Line(points={{1301,548},{1326,548},
          {1326,610},{1344,610}}, color={0,0,127}));
  connect(eleCWP.y, eleTot.u[5]) annotation (Line(points={{1301,528},{1328,528},
          {1328,608.8},{1344,608.8}}, color={0,0,127}));
  connect(eleCT.y, eleTot.u[6]) annotation (Line(points={{1301,508},{1330,508},
          {1330,607.6},{1344,607.6}}, color={0,0,127}));
  connect(eleHWP.y, eleTot.u[7]) annotation (Line(points={{1301,488},{1332,488},
          {1332,606.4},{1344,606.4}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{1580,700}})), Icon(
        coordinateSystem(extent={{-100,-100},{1580,700}})));
end EnergyMeter;
