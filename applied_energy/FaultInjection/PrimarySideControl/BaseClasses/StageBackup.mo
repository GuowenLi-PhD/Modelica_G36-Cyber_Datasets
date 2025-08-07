within FaultInjection.PrimarySideControl.BaseClasses;
model StageBackup
  "General stage control model as a back model which needs to be improved and tested"
  extends Modelica.Blocks.Icons.Block;
  parameter Integer numSta "Design number of equipment that can be staged";
  parameter Real staUpThr = 1.25 "Staging up threshold";
  parameter Real staDowThr = 0.55 "Staging down threshold";

  parameter Modelica.SIunits.Time waiTimStaUp = 900 "Time duration of TFlo1 condition for staging on one tower cell";
  parameter Modelica.SIunits.Time waiTimStaDow = 300 "Time duration of TFlo2 condition for staging off one tower cell";

  Modelica.Blocks.Interfaces.RealInput u "Measured signal" annotation (
      Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.IntegerOutput ySta
    "Stage number of next time step" annotation (Placement(transformation(
          extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,
            10}})));

  Modelica.Blocks.Interfaces.IntegerInput minSta "Minimum number of stages"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.IntegerInput uSta "Number of active stages"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  BaseClasses.TimerGreatEqual timGreEqu(threshold=staUpThr)
                                        "Timer"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  BaseClasses.TimeLessEqual timLesEqu(threshold=staDowThr)
                                      "Timer"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold staUpAct(threshold=
       waiTimStaUp)
    "Stageup activated"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold staDowAct(threshold=
       waiTimStaDow)
    "Stage down activated"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
protected
  Modelica.Blocks.Logical.Switch swi1
    "The switch based on whether it is in FMC mode"
    annotation (Placement(transformation(extent={{20,12},{40,32}})));
public
  Buildings.Controls.OBC.CDL.Continuous.Add add1
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.Constant uni(k=1) "One"
    annotation (Placement(transformation(extent={{-80,14},{-60,34}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(k2=-1)
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
protected
  Modelica.Blocks.Logical.Switch swi2
    "The switch based on whether it is in FMC mode"
    annotation (Placement(transformation(extent={{8,-38},{28,-18}})));
public
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{-80,-108},{-60,-88}})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt
    annotation (Placement(transformation(extent={{-40,-114},{-20,-94}})));
  Buildings.Controls.OBC.CDL.Integers.Min minInt
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(k=numSta)
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
equation
  connect(uSta, intToRea.u) annotation (Line(points={{-120,0},{-90,0},{-90,60},{
          -82,60}}, color={255,127,0}));
  connect(timGreEqu.y, staUpAct.u)
    annotation (Line(points={{1,80},{38,80}},  color={0,0,127}));
  connect(timLesEqu.y, staDowAct.u)
    annotation (Line(points={{-19,-60},{18,-60}},color={0,0,127}));
  connect(intToRea.y, add1.u1) annotation (Line(points={{-59,60},{-54,60},{-54,36},
          {-42,36}}, color={0,0,127}));
  connect(uni.y, add1.u2)
    annotation (Line(points={{-59,24},{-42,24}}, color={0,0,127}));
  connect(add1.y, swi1.u1)
    annotation (Line(points={{-19,30},{18,30}}, color={0,0,127}));
  connect(staUpAct.y, swi1.u2) annotation (Line(points={{61,80},{80,80},{80,54},
          {0,54},{0,22},{18,22}}, color={255,0,255}));
  connect(intToRea.y, swi1.u3) annotation (Line(points={{-59,60},{-52,60},{-52,14},
          {18,14}}, color={0,0,127}));
  connect(intToRea.y, add2.u1) annotation (Line(points={{-59,60},{-50,60},{-50,-14},
          {-42,-14}}, color={0,0,127}));
  connect(staDowAct.y, swi2.u2) annotation (Line(points={{41,-60},{50,-60},{50,-44},
          {-6,-44},{-6,-28},{6,-28}},color={255,0,255}));
  connect(add2.y, swi2.u1)
    annotation (Line(points={{-19,-20},{6,-20}},  color={0,0,127}));
  connect(uni.y, add2.u2) annotation (Line(points={{-59,24},{-54,24},{-54,-26},{
          -42,-26}}, color={0,0,127}));
  connect(swi1.y, swi2.u3) annotation (Line(points={{41,22},{50,22},{50,0},{-10,
          0},{-10,-36},{6,-36}},   color={0,0,127}));
  connect(swi2.y, reaToInt.u) annotation (Line(points={{29,-28},{60,-28},{60,-80},
          {-92,-80},{-92,-98},{-82,-98}},    color={0,0,127}));
  connect(minSta, maxInt.u2) annotation (Line(points={{-120,-80},{-94,-80},{-94,
          -110},{-42,-110}}, color={255,127,0}));
  connect(reaToInt.y, maxInt.u1)
    annotation (Line(points={{-59,-98},{-42,-98}},color={255,127,0}));
  connect(maxInt.y, minInt.u1) annotation (Line(points={{-19,-104},{-10,-104},{-10,
          -114},{18,-114}}, color={255,127,0}));
  connect(conInt.y, minInt.u2) annotation (Line(points={{-19,-130},{-10,-130},{-10,
          -126},{18,-126}}, color={255,127,0}));
  connect(minInt.y, ySta) annotation (Line(points={{41,-120},{80,-120},{80,0},{110,
          0}}, color={255,127,0}));
  connect(u, timGreEqu.u)
    annotation (Line(points={{-120,80},{-22,80}}, color={0,0,127}));
  connect(u, timLesEqu.u) annotation (Line(points={{-120,80},{-48,80},{-48,-60},
          {-42,-60}}, color={0,0,127}));
  annotation (defaultComponentName = "sta",
    Documentation(info="<html>
<p>
The cooling tower cell staging control is based on the water flowrate going through the cooling tower.
</p>
<ul>
<li>
One additional cell stages on if average flowrate through active cells is greater than a stage-up threshold <code>staUpThr*m_flow_nominal</code> for 15 minutes.
</li>
<li>
One additional cell stages off if average flowrate through active cells is lower than a stage-down threshold <code>staDowThr*m_flow_nominal</code> for 5 minutes.
</li>
</ul>
</html>", revisions=""),
    Diagram(coordinateSystem(extent={{-100,-140},{100,100}})),
    __Dymola_Commands);
end StageBackup;
