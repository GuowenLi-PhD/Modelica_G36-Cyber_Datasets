within FaultInjection.Experimental.SystemLevelFaults.Controls;
model ChillerPlantEnableDisable
  "Chilled water plant enable disable control sequence"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer numIgn=0 "Number of ignored plant requests";

  parameter Real yFanSpeMin(min=0.1, max=1, unit="1") = 0.15
    "Lowest allowed fan speed if fan is on";

  parameter Modelica.SIunits.Time shoCycTim=15*60 "Time duration to avoid short cycling of equipment";

  parameter Modelica.SIunits.Time plaReqTim=3*60 "Time duration of plant requests";

  parameter Modelica.SIunits.Time tWai=60 "Waiting time";

  parameter Modelica.SIunits.Temperature TOutPla = 13+273.15
    "The outdoor air lockout temperature below/over which the chiller/boiler plant is prevented from operating.
    It is typically 13°C for chiller plants serving systems with airside economizers. 
    For boiler plant, it is normally 18°C";

  Modelica.StateGraph.Transition con1(
    condition=yPlaReq > numIgn and TOut > TOutPla and ySupFan and offTim.y >=
        shoCycTim,
    enableTimer=true,
    waitTime=tWai)
    "Fire condition 1: plant off to on"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,32})));
  Modelica.StateGraph.StepWithSignal On(nIn=1, nOut=1) "Plant is commanded on"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-50,0})));
  Modelica.StateGraph.InitialStepWithSignal
                                  off(nIn=1) "Plant is off"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-50,60})));
  Modelica.StateGraph.Transition con2(
    condition=(lesEqu.y >= plaReqTim and onTim.y >= shoCycTim and lesEqu1.y >=
        plaReqTim) or ((TOut < TOutPla - 1 or not ySupFan) and onTim.y >=
        shoCycTim),
    enableTimer=true,
    waitTime=0)
    "Fire condition 2: plant on to off"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-18,34})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(final unit="K", final
      quantity="ThermodynamicTemperature")     "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,26},{-100,66}}),
        iconTransformation(extent={{-140,26},{-100,66}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput ySupFan
    "Supply fan on status"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput yPlaReq "Plant request"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Logical.Timer offTim
    "Timer for the state where equipment is off"
    annotation (Placement(transformation(extent={{-8,50},{12,70}})));
  Modelica.Blocks.Logical.Timer onTim
    "Timer for the state where equipment is on"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  .FaultInjection.Experimental.SystemLevelFaults.Controls.BaseClasses.TimeLessEqual
    lesEqu(threshold=numIgn)
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));

  Modelica.Blocks.Interfaces.BooleanOutput yPla
    "On/off signal for the plant - 0: off; 1: on"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput yFanSpe(unit="1")
    "Constant normalized rotational speed" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-40}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-70})));
  BaseClasses.TimeLessEqualRea lesEqu1(threshold=yFanSpeMin)
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
equation
  connect(off.outPort[1], con1.inPort)
    annotation (Line(
      points={{-50,49.5},{-50,36}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con1.outPort, On.inPort[1]) annotation (Line(
      points={{-50,30.5},{-50,16},{-50,16},{-50,11}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con2.outPort, off.inPort[1])
    annotation (Line(
      points={{-18,35.5},{-18,80},{-50,80},{-50,71}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(off.active, offTim.u)
    annotation (Line(points={{-39,60},{-10,60}}, color={255,0,255}));
  connect(On.active, onTim.u) annotation (Line(points={{-39,0},{-30,0},{-30,-30},
          {-12,-30}}, color={255,0,255}));
  connect(yPlaReq, lesEqu.u1)
    annotation (Line(points={{-120,70},{-92,70}}, color={255,127,0}));
  connect(On.active, yPla) annotation (Line(points={{-39,-1.9984e-15},{8,
          -1.9984e-15},{8,0},{110,0}},   color={255,0,255}));
  connect(On.outPort[1], con2.inPort) annotation (Line(
      points={{-50,-10.5},{-50,-20},{-18,-20},{-18,30}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(yFanSpe, lesEqu1.u1)
    annotation (Line(points={{-120,-40},{-92,-40}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>This is a chilled plant enable disable control that works as follows: </p>
<p>Enable the plant in the lowest stage when the plant has been disabled for at least 15 minutes and: </p>
<ol>
<li>Number of Chiller Plant Requests &gt; I (I = Ignores shall default to 0, adjustable), and </li>
<li>OAT&gt;CH-LOT, and </li>
<li>The chiller plant enable schedule is active. </li>
</ol>
<p>Disable the plant when it has been enabled for at least 15 minutes and: </p>
<ol>
<li>Number of Chiller Plant Requests <span style=\"font-family: TimesNewRomanPSMT;\">&le; </span>I for 3 minutes, or </li>
<li>OAT&lt;CH-LOT<span style=\"font-family: TimesNewRomanPSMT;\">-</span>1&deg;F, or </li>
<li>The chiller plant enable schedule is inactive. </li>
</ol>
</html>", revisions="<html>
<ul>
<li>Aug 30, 2020, by Xing Lu:<br>First implementation. </li>
</ul>
</html>"));
end ChillerPlantEnableDisable;
