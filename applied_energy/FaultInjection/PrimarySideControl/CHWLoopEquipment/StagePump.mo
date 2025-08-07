within FaultInjection.PrimarySideControl.CHWLoopEquipment;
model StagePump "Staging control for CHW pumps"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate of the CHW pump";
  parameter Integer numPum=2 "Design number of pumps";
  parameter Real staUpThr = 0.85 "Staging up threshold";
  parameter Real staDowThr = 0.45 "Staging down threshold";
  parameter Modelica.SIunits.Time waiTimStaUp=300
    "Time duration of for staging up";
  parameter Modelica.SIunits.Time waiTimStaDow=300
    "Time duration of for staging down";
  parameter Modelica.SIunits.Time shoCycTim=1200
    "Time duration to avoid short cycling of equipment";
  Modelica.Blocks.Interfaces.RealInput masFloPum
    "Average mass flowrate of the active CHW pump"
    annotation (Placement(transformation(extent={{-140,
            -60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,
            -20}})));

  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  Modelica.Blocks.Sources.BooleanExpression unOcc(y=uOpeMod
         == Integer(WSEControlLogics.Controls.WSEControls.Type.OperationModes.Unoccupied))
    "Unoccupied or FreeCooling mode"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(k=0) "Zero"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{10,10},{30,30}})));
  BaseClasses.SequenceSignal seqSig(n=numPum)
    "Simple model that is used to determine the on and off sequence of equipment"
    annotation (Placement(transformation(extent={{50,10},{70,30}})));
  BaseClasses.Stage sta(
    shoCycTim=shoCycTim,
    waiTimStaUp=waiTimStaUp,
    waiTimStaDow=waiTimStaDow,
    staUpThr=staUpThr*m_flow_nominal,
    staDowThr=staDowThr*m_flow_nominal)
    annotation (Placement(transformation(extent={{-20,-54},{0,-34}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    annotation (Placement(transformation(extent={{12,-54},{32,-34}})));
  Modelica.Blocks.Interfaces.RealOutput y[numPum]
    "On and off signal of pumps"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yPum
    "Number of active pumps"
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
        iconTransformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.IntegerInput uOpeMod
    "Cooling mode in WSEControls.Type.OperationaModes" annotation (Placement(
        transformation(extent={{-140,20},{-100,60}}),  iconTransformation(
          extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
equation
  connect(zer.y,swi1. u1) annotation (Line(points={{-39,50},{-30,50},{-30,28},{
          -22,28}},color={0,0,127}));
  connect(unOcc.y,swi1. u2)
    annotation (Line(points={{-69,20},{-22,20}}, color={255,0,255}));
  connect(swi1.y,reaToInt. u)
    annotation (Line(points={{1,20},{8,20}}, color={0,0,127}));
  connect(reaToInt.y,seqSig. u)
    annotation (Line(points={{31,20},{48,20}}, color={255,127,0}));
  connect(reaToInt.y,yPum)  annotation (Line(points={{31,20},{40,20},{40,40},{110,
          40}}, color={255,127,0}));
  connect(seqSig.y,y)  annotation (Line(points={{71,20},{80,20},{80,-40},{110,-40}},
        color={0,0,127}));
  connect(sta.ySta,intToRea1. u)
    annotation (Line(points={{1,-44},{10,-44}},    color={255,127,0}));
  connect(masFloPum, sta.u) annotation (Line(
        points={{-120,-40},{-22,-40}},
                 color={0,0,127}));
  connect(unOcc.y, not2.u) annotation (Line(points={{-69,20},{-66,20},{-66,-20},
          {-62,-20}}, color={255,0,255}));
  connect(not2.y, sta.on) annotation (Line(points={{-39,-20},{-30,-20},{-30,-48},
          {-22,-48}}, color={255,0,255}));
  connect(intToRea1.y, swi1.u3) annotation (Line(points={{33,-44},{40,-44},{40,
          0},{-30,0},{-30,12},{-22,12}}, color={0,0,127}));
  annotation (defaultComponentName="staPum",
  Documentation(info="<html>
<p>This model describes a chilled water pump staging control. </p>
<ul>
<li>In unoccupied and free cooling mode, the chillers are off. </li>
<li>In pre-partial, partial and full mechanical cooling mode, the chilled water pumps are staged based on measured flowrate. At the beginning, the number of pumps stay unchanged from previous operating mode. </li>
</ul>
<h4>Flowrate-based Stage Control </h4>
<p>The CHW pumps are staged up when </p>
<ol>
<li>Current stage has been active for at least 15 minutes (<i><span style=\"font-size: 10pt;\">△</span>t<sub>stage,on</sub> &gt; 15 min) </i>and </li>
<li>The measured flowrate is larger than 85&percnt; of the total nominal flowrate of the active pumps for 2 minutes <i>(m<sub>CHWP</sub> &gt; 85&percnt; &middot; m<sub>CHWP,nominal</sub> for 2 min)</i>.</li>
</ol>
<p>The CHW pumps are staged down when</p>
<ol>
<li>Current stage has been active for at least 15 minutes (<i><span style=\"font-size: 10pt;\">△</span>t<sub>stage,on</sub> &gt; 15 min) </i>and</li>
<li>The measured flowrate is less than 45&percnt; of the total nominal flowrate of the active pumps for 15 minutes <i>(m<sub>CHWP</sub> &lt; 45&percnt; &middot; m<sub>CHWP,nominal </sub>for 15 min)</i>.</li>
</ol>
<p>This control logic is provided by Jeff Stein via email communication.</p>
</html>", revisions="<html>
<ul>
<li>June 14, 2018, by Xing Lu:<br>First implementation. </li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    __Dymola_Commands);
end StagePump;
