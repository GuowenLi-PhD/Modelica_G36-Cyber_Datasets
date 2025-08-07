within FaultInjection.PrimarySideControl.CWLoopEquipment;
model StageCell "Cooling tower cell stage number control"
  extends Modelica.Blocks.Icons.Block;
  parameter Integer numCooTow = 2 "Design number of cooling towers";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 50
    "Nominal mass flow rate of one cooling tower";
  parameter Real staUpThr = 1.25 "Staging up threshold";
  parameter Real staDowThr = 0.55 "Staging down threshold";
  parameter Modelica.SIunits.Time waiTimStaUp=900
    "Time duration of for staging up";
  parameter Modelica.SIunits.Time waiTimStaDow=300
    "Time duration of for staging down";
  parameter Modelica.SIunits.Time shoCycTim=1200
    "Time duration to avoid short cycling of equipment";

  Modelica.Blocks.Interfaces.RealInput aveMasFlo
    "Average mass flowrate of condenser water in active cooling towers"
    annotation (Placement(
        transformation(extent={{-140,-62},{-100,-22}}),iconTransformation(
          extent={{-140,-62},{-100,-22}})));
  Modelica.Blocks.Interfaces.IntegerOutput yNumCel
    "Stage number of next time step" annotation (Placement(transformation(
          extent={{100,30},{120,50}}), iconTransformation(extent={{100,30},{120,
            50}})));

  Modelica.Blocks.Interfaces.IntegerInput minNumCel
    "Minimum number of active tower cells determined by minimum cell controller"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  BaseClasses.SequenceSignal seqSig(n=numCooTow)
    "Simple model that is used to determine the on and off sequence of equipment"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Interfaces.RealOutput y[numCooTow]
    "On and off signal of cooling tower cell"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  BaseClasses.Stage sta(
    staUpThr=staUpThr*m_flow_nominal,
    staDowThr=staDowThr*m_flow_nominal,
    waiTimStaUp=waiTimStaUp,
    waiTimStaDow=waiTimStaDow,
    shoCycTim=shoCycTim) "Stage controller"
    annotation (Placement(transformation(extent={{-40,-56},{-20,-36}})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt "Max"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

  Modelica.Blocks.Interfaces.IntegerInput uOpeMod
    "Cooling mode in WSEControls.Type.OperationaModes" annotation (Placement(
        transformation(extent={{-140,20},{-100,60}}),  iconTransformation(
          extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    annotation (Placement(transformation(extent={{22,-50},{42,-30}})));
  Modelica.Blocks.Sources.BooleanExpression unOcc(y=uOpeMod == Integer(
        WSEControlLogics.Controls.WSEControls.Type.OperationModes.Unoccupied))
    "Unoccupied mode"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(k=0) "Zero"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{-74,-72},{-54,-52}})));
equation
  connect(seqSig.y, y)
    annotation (Line(points={{81,0},{90,0},{90,-40},{110,-40}},
                                              color={0,0,127}));
  connect(aveMasFlo, sta.u) annotation (Line(points={{-120,-42},{-42,-42}},
                    color={0,0,127}));
  connect(unOcc.y, swi1.u2)
    annotation (Line(points={{-59,0},{-12,0}}, color={255,0,255}));
  connect(minNumCel, maxInt.u1) annotation (Line(points={{-120,0},{-92,0},{-92,
          -20},{-20,-20},{-20,-34},{-12,-34}},
                               color={255,127,0}));
  connect(intToRea1.y, swi1.u3) annotation (Line(points={{43,-40},{50,-40},{50,
          -16},{-40,-16},{-40,-8},{-12,-8}}, color={0,0,127}));
  connect(zer.y, swi1.u1) annotation (Line(points={{-29,30},{-20,30},{-20,8},{
          -12,8}}, color={0,0,127}));
  connect(seqSig.u, reaToInt.y)
    annotation (Line(points={{58,0},{41,0}}, color={255,127,0}));
  connect(swi1.y, reaToInt.u)
    annotation (Line(points={{11,0},{18,0}}, color={0,0,127}));
  connect(reaToInt.y, yNumCel) annotation (Line(points={{41,0},{50,0},{50,40},{
          110,40}}, color={255,127,0}));
  connect(sta.ySta, maxInt.u2) annotation (Line(points={{-19,-46},{-12,-46}},
                               color={255,127,0}));
  connect(maxInt.y, intToRea1.u) annotation (Line(points={{11,-40},{20,-40}},
                         color={255,127,0}));
  connect(unOcc.y, not2.u) annotation (Line(points={{-59,0},{-50,0},{-50,-18},{
          -80,-18},{-80,-62},{-76,-62}}, color={255,0,255}));
  connect(not2.y, sta.on) annotation (Line(points={{-53,-62},{-48,-62},{-48,-50},
          {-42,-50}}, color={255,0,255}));
  annotation (defaultComponentName = "staCel",
    Documentation(info="<html>
<p>The cooling tower cell staging control is based on the water flowrate going through the cooling tower under the operation mode except the unoccuiped mode.  In the unoccupied mode, all the cells are staged off.</p>
<ul>
<li>One additional cell stages on if average flowrate through active cells is greater than a stage-up threshold <code>staUpThr*m_flow_nominal</code> for 15 minutes. </li>
<li>One additional cell stages off if average flowrate through active cells is lower than a stage-down threshold <code>staDowThr*m_flow_nominal</code> for 5 minutes. </li>
</ul>
</html>", revisions=""),
    Diagram(coordinateSystem(extent={{-100,-80},{100,80}})),
    __Dymola_Commands);
end StageCell;
