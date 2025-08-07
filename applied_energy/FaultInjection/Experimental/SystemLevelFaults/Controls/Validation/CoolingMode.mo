within FaultInjection.Experimental.SystemLevelFaults.Controls.Validation;
model CoolingMode
  "Test the model ChillerWSE.Examples.BaseClasses.CoolingModeController"
  extends Modelica.Icons.Example;

  FaultInjection.Experimental.SystemLevelFaults.Controls.CoolingMode
  cooModCon(
    deaBan1=1,
    deaBan2=1,
    tWai=30,
    deaBan3=1,
    deaBan4=1)
    "Cooling mode controller used in integrared waterside economizer chilled water system"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Pulse TCHWLeaWSE(
    period=300,
    amplitude=15,
    offset=273.15 + 5) "WSE chilled water supply temperature"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Modelica.Blocks.Sources.Constant TWetBub(k=273.15 + 5) "Wet bulb temperature"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Sources.Constant TAppTow(k=5) "Cooling tower approach"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.Constant TCHWEntWSE(k=273.15 + 12)
    "Chilled water return temperature in waterside economizer"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Modelica.Blocks.Sources.Constant TCHWLeaSet(k=273.15 + 10)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.BooleanPulse yPla(
    width=80,
    period(displayUnit="min") = 300,
    startTime(displayUnit="min") = 60)
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
equation
  connect(TCHWLeaSet.y, cooModCon.TCHWSupSet) annotation (Line(points={{-39,50},
          {-24,50},{-24,5.77778},{-12,5.77778}},
                                     color={0,0,127}));
  connect(TWetBub.y, cooModCon.TWetBul)
    annotation (Line(points={{-39,20},{-26,20},{-26,2.22222},{-12,2.22222}},
                            color={0,0,127}));
  connect(TAppTow.y, cooModCon.TApp) annotation (Line(points={{-39,-10},{-28,
          -10},{-28,-1.11111},{-12,-1.11111}},
                            color={0,0,127}));
  connect(TCHWLeaWSE.y, cooModCon.TCHWSupWSE) annotation (Line(points={{-39,-40},
          {-28,-40},{-28,-4.44444},{-12,-4.44444}},
                                        color={0,0,127}));
  connect(TCHWEntWSE.y, cooModCon.TCHWRetWSE) annotation (Line(points={{-39,-80},
          {-26,-80},{-26,-7.77778},{-12,-7.77778}},
                                        color={0,0,127}));
  connect(yPla.y, cooModCon.yPla) annotation (Line(points={{-39,80},{-22,80},{
          -22,8.66667},{-12,8.66667}}, color={255,0,255}));
  annotation (
    Documentation(info="<html>
<p>
This model tests the cooling mode controller implemented in
<a href=\"modelica://FaultInjection.Experimental.SystemLevelFaults.Controls.CoolingMode\">
FaultInjection.Experimental.SystemLevelFaults.Controls.CoolingMode</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 25, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(
      StartTime=0,
      StopTime=600,
      Tolerance=1e-06),
    __Dymola_Commands(file=
          "Resources/Scripts/dymola/FaultInjection/Experimental/SystemLevelFaults/Controls/Validation/CoolingMode.mos"
        "Simulate and Plot"));
end CoolingMode;
