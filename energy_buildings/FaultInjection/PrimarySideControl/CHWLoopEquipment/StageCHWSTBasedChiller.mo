within FaultInjection.PrimarySideControl.CHWLoopEquipment;
model StageCHWSTBasedChiller "Chiller staging control based on CHWST"
  extends Modelica.Blocks.Icons.Block;
  parameter Integer numChi = 2 "Design number of chillers";
  parameter Modelica.SIunits.Temperature criPoiTem = 279.15
    "Critical point of temperature for switching one chiller on or off";
  parameter Modelica.SIunits.TemperatureDifference dTUpThr=1 "Temperature difference for staging on a chiller";
  parameter Modelica.SIunits.TemperatureDifference dTDowThr=1 "Temperature difference for staging off a chiller";
  parameter Modelica.SIunits.Time waiTimStaUp=300
    "Time duration of for staging up";
  parameter Modelica.SIunits.Time waiTimStaDow=300
    "Time duration of for staging down";
  parameter Modelica.SIunits.Time shoCycTim= 1200
    "Time duration to avoid short cycling of equipment";

  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  Modelica.Blocks.Interfaces.RealInput TCHWSup(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Temperature of leaving chilled water "
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.IntegerInput uOpeMod
    "Cooling mode in WSEControls.Type.OperationaModes" annotation (Placement(
        transformation(extent={{-140,40},{-100,80}}),  iconTransformation(
          extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Sources.BooleanExpression unOccFre(y=uOpeMod == Integer(
        WSEControlLogics.Controls.WSEControls.Type.OperationModes.Unoccupied)
         or uOpeMod == Integer(WSEControlLogics.Controls.WSEControls.Type.OperationModes.FreeCooling))
    "Unoccupied or FreeCooling mode"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(k=0) "Zero"
    annotation (Placement(transformation(extent={{-62,40},{-42,60}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{10,10},{30,30}})));
  BaseClasses.SequenceSignal seqSig(n=numChi)
    "Simple model that is used to determine the on and off sequence of equipment"
    annotation (Placement(transformation(extent={{50,10},{70,30}})));
  Modelica.Blocks.Interfaces.RealOutput y[numChi]
    "On and off signal of chiller"
    annotation (Placement(transformation(extent={{100,-50},
            {120,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChi
    "Number of active chillers"
    annotation (Placement(transformation(extent={{100,30},
            {120,50}}),
        iconTransformation(extent={{100,30},{120,50}})));
  FaultInjection.PrimarySideControl.BaseClasses.Stage sta(
    staUpThr=criPoiTem + dTUpThr,
    staDowThr=criPoiTem - dTDowThr,
    waiTimStaUp=waiTimStaUp,
    waiTimStaDow=waiTimStaDow,
    shoCycTim=shoCycTim)
    annotation (Placement(transformation(extent={{-20,-54},{0,-34}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    annotation (Placement(transformation(extent={{10,-54},{30,-34}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
equation
  connect(zer.y,swi1. u1) annotation (Line(points={{-41,50},{-30,50},{-30,28},{-22,
          28}},    color={0,0,127}));
  connect(unOccFre.y, swi1.u2)
    annotation (Line(points={{-69,20},{-22,20}}, color={255,0,255}));
  connect(swi1.y, reaToInt.u)
    annotation (Line(points={{1,20},{8,20}}, color={0,0,127}));
  connect(reaToInt.y, seqSig.u)
    annotation (Line(points={{31,20},{48,20}}, color={255,127,0}));
  connect(reaToInt.y, yChi) annotation (Line(points={{31,20},
          {40,20},{40,40},{110,40}},
                color={255,127,0}));
  connect(seqSig.y, y) annotation (Line(points={{71,20},
          {80,20},{80,-40},{110,-40}},
        color={0,0,127}));
  connect(TCHWSup, sta.u)
    annotation (Line(points={{-120,0},{-72,0},{-72,-40},{-22,-40}},
                                                    color={0,0,127}));
  connect(sta.ySta, intToRea1.u)
    annotation (Line(points={{1,-44},{8,-44}},     color={255,127,0}));
  connect(intToRea1.y, swi1.u3) annotation (Line(points={{31,-44},{40,-44},{40,
          0},{-30,0},{-30,12},{-22,12}}, color={0,0,127}));
  connect(unOccFre.y, not2.u) annotation (Line(points={{-69,20},{-66,20},{-66,
          -20},{-62,-20}}, color={255,0,255}));
  connect(not2.y, sta.on) annotation (Line(points={{-39,-20},{-30,-20},{-30,-48},
          {-22,-48}}, color={255,0,255}));
      annotation (
    defaultComponentName="staTemChi",
    Documentation(info="<html>
<p>This model describes a chiller staging control based on the chilled water supply temperature (CHWST).</p>
<ul>
<li>
In unoccupied and free cooling mode, the chillers are off.
</li>

<li>
In pre-partial, partial and full mechanical cooling mode, the chillers are staged based on part load ratio or cooling load in chillers. At the beginning, the number of chillers stay unchanged
from previous operating mode.
</li>

</ul>

<h4>CHWST-based Stage Control </h4>

<p>Chillers are staged up when</p>
<ol>
<li>Current stage has been activated for at least 30 minutes <i>(<span style=\"font-size: 10pt;\">△</span>t<sub>stage,on</sub> &gt; 30 min)</i> and</li>
<li>CHWST exceeds active setpoint by at least 3<sup>&deg;</sup>F for 5 minutes <i>(T<sub>sup,CHW,chiller </sub>&gt; T<sub>sup,CHW,set </sub>+ 3&deg;F for 5 min)</i>.</li>
</ol>
<p>Chillers are staged down when</p>
<ol>
<li>Current stage has been activated for at least 30 minutes <i>(<span style=\"font-size: 10pt;\">△</span>t<sub>stage,on</sub> &gt; 30 min)</i> and</li>
<li>CHWST is below active setpoint by at least 3&deg;F for 5 minutes <i>(T<sub>sup,CHW,chiller</sub> &lt; T<sub>sup,CHW,set</sub> - 3&deg;F for 5 min)</i>.</li>
</ol>
<p>It is noted that the time duration and the temperature deadband can be adjusted according to different projects.</p>
<p>This control logic is provided by Jeff Stein via email communication.</p>
</html>", revisions="<html>
<ul>
<li>August 16, 2018, by Yangyang Fu:<br> 
Improve documentation. 
</li>
<li>June 12, 2018, by Xing Lu:<br>First implementation. </li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end StageCHWSTBasedChiller;
