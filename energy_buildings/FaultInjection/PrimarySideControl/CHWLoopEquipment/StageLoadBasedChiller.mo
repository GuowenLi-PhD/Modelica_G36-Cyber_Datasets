within FaultInjection.PrimarySideControl.CHWLoopEquipment;
model StageLoadBasedChiller
  "Chiller staging control based on cooling load"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.Power QEva_nominal
    "Nominal cooling capaciaty(Negative means cooling)";
  parameter Integer numChi=2 "Design number of chillers";
  parameter Real staUpThr=0.8 "Staging up threshold";
  parameter Real staDowThr=0.25 "Staging down threshold";
  parameter Modelica.SIunits.Time waiTimStaUp=300
    "Time duration of for staging up";
  parameter Modelica.SIunits.Time waiTimStaDow=300
    "Time duration of for staging down";
  parameter Modelica.SIunits.Time shoCycTim=1200
    "Time duration to avoid short cycling of equipment";
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  Modelica.Blocks.Interfaces.RealInput QTot(unit="W")
    "Total cooling load in the chillers, negative"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));

  Modelica.Blocks.Sources.BooleanExpression unOccFre(y=uOpeMod == Integer(
        WSEControlLogics.Controls.WSEControls.Type.OperationModes.Unoccupied)
         or uOpeMod == Integer(WSEControlLogics.Controls.WSEControls.Type.OperationModes.FreeCooling))
    "Unoccupied or FreeCooling mode"
    annotation (Placement(transformation(extent={{-92,10},{-72,30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(k=0) "Zero"
    annotation (Placement(transformation(extent={{-62,40},{-42,60}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{10,10},{30,30}})));
  BaseClasses.SequenceSignal seqSig(n=numChi)
    "Simple model that is used to determine the on and off sequence of equipment"
    annotation (Placement(transformation(extent={{50,10},{70,30}})));
  BaseClasses.Stage sta(
    shoCycTim=shoCycTim,
    waiTimStaUp=waiTimStaUp,
    waiTimStaDow=waiTimStaDow,
    staUpThr=staUpThr*(-QEva_nominal),
    staDowThr=staDowThr*(-QEva_nominal))
    annotation (Placement(transformation(extent={{-20,-54},{0,-34}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    annotation (Placement(transformation(extent={{12,-54},{32,-34}})));
  Modelica.Blocks.Interfaces.RealOutput y[numChi]
    "On and off signal of chiller"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChi
    "Number of active chillers"
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
        iconTransformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.IntegerInput uOpeMod
    "Cooling mode in WSEControls.Type.OperationaModes" annotation (Placement(
        transformation(extent={{-140,20},{-100,60}}),  iconTransformation(
          extent={{-140,20},{-100,60}})));

  Modelica.Blocks.Math.Gain gain(k=-1)
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
equation
  connect(zer.y,swi1. u1) annotation (Line(points={{-41,50},{-30,50},{-30,28},{-22,
          28}},    color={0,0,127}));
  connect(unOccFre.y, swi1.u2)
    annotation (Line(points={{-71,20},{-22,20}}, color={255,0,255}));
  connect(swi1.y,reaToInt. u)
    annotation (Line(points={{1,20},{8,20}}, color={0,0,127}));
  connect(reaToInt.y,seqSig. u)
    annotation (Line(points={{31,20},{48,20}}, color={255,127,0}));
  connect(reaToInt.y,yChi)  annotation (Line(points={{31,20},{40,20},{40,40},{110,
          40}}, color={255,127,0}));
  connect(seqSig.y,y)  annotation (Line(points={{71,20},{80,20},{80,-40},{110,-40}},
        color={0,0,127}));
  connect(sta.ySta,intToRea1. u)
    annotation (Line(points={{1,-44},{10,-44}},    color={255,127,0}));
  connect(gain.y, sta.u) annotation (Line(points={{-59,-40},{-22,-40}},
                                color={0,0,127}));
  connect(QTot, gain.u) annotation (Line(points={{-120,-40},{-82,-40}},
        color={0,0,127}));
  connect(unOccFre.y, not2.u) annotation (Line(points={{-71,20},{-66,20},{-66,
          -10},{-62,-10}}, color={255,0,255}));
  connect(not2.y, sta.on) annotation (Line(points={{-39,-10},{-32,-10},{-32,-48},
          {-22,-48}}, color={255,0,255}));
  connect(intToRea1.y, swi1.u3) annotation (Line(points={{33,-44},{40,-44},{40,
          0},{-30,0},{-30,12},{-22,12}}, color={0,0,127}));
 annotation (
    defaultComponentName="staLoaChi",
    Documentation(info="<html>

<p>This model describes a chiller staging control based on the part load ratio (PLR) or cooling load Q.</p>
<ul>
<li>
In unoccupied and free cooling mode, the chillers are off.
</li>

<li>
In pre-partial, partial and full mechanical cooling mode, the chillers are staged based on part load ratio or cooling load in chillers. At the beginning, the number of chillers stay unchanged
from previous operating mode.
</li>

</ul>

<h4>PLR or Q-based Stage Control </h4>

<p>Chillers are staged up when</p>
<ol>
<li>Current stage has been activated for at least <i>30</i> minutes (<i><span style=\"font-size: 10pt;\">△</span>t<sub>stage,on</sub> &gt; 30 min) </i>and</li>
<li>PLR for any active chiller is greater than <i>80</i>&percnt; for <i>10</i> minutes <i>(PLR<sub>chiller</sub> &gt; 80&percnt; for 10 min).</i></li>
</ol>
<p>Chillers are staged down when</p>
<ol>
<li>Current stage has been activated for at least <i>30</i> minutes <i>(<span style=\"font-size: 10pt;\">△</span>t<sub>stage,on</sub> &gt; 30 min)</i> and</li>
<li>PLR for any active chiller is less than 25&percnt; for 15 minutes <i>(PLR<sub>chiller</sub> &lt; 25&percnt; for 15 min)</i>.</li>
</ol>
<p>It is noted that the time duration and the percentage can be adjusted according to different projects.</p>
<p>This control logic is provided by Jeff Stein via email communication.</p>
</html>", revisions="<html>
<ul>
<li>August 16, 2018, by Yangyang Fu:<br> 
Improve documentation. 
</li>
<li>June 12, 2018, by Xing Lu:<br>
First implementation. 
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    __Dymola_Commands);
end StageLoadBasedChiller;
