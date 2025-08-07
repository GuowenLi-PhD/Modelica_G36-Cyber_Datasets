within FaultInjection.PrimarySideControl.CWLoopEquipment;
model StagePump "CW pump stage control"
  extends Modelica.Blocks.Icons.Block;
  parameter Integer numPum "Design number of pumps";
  parameter Integer numChi "Design number of chillers";
  parameter Real staUpThr=0.8 "Staging up threshold";
  parameter Real staDowThr=0.45 "Staging down threshold";
  parameter Modelica.SIunits.Time waiTimStaUp=300
    "Time duration of for staging up";
  parameter Modelica.SIunits.Time waiTimStaDow=600
    "Time duration of for staging down";
  parameter Modelica.SIunits.Time shoCycTim=1200
    "Time duration to avoid short cycling of equipment";
  Modelica.Blocks.Interfaces.RealInput uSpeTow "Speed of cooling tower fans"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealOutput y[numPum] "Pump on/off signal"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
        iconTransformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.IntegerInput uOpeMod
    "Cooling mode in WSEControls.Type.OperationaModes" annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}), iconTransformation(
          extent={{-140,-20},{-100,20}})));
  BaseClasses.Stage sta(
    staUpThr=staUpThr,
    staDowThr=staDowThr,
    waiTimStaUp=waiTimStaUp,
    waiTimStaDow=waiTimStaDow,
    shoCycTim=shoCycTim) "Stage controller"
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{30,80},{50,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(k=0) "Zero"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  Modelica.Blocks.Sources.BooleanExpression unOcc(y=uOpeMod == Integer(
        WSEControlLogics.Controls.WSEControls.Type.OperationModes.Unoccupied))
    "Unoccupied mode"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    annotation (Placement(transformation(extent={{30,0},{50,20}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Modelica.Blocks.Sources.BooleanExpression freCoo(y=uOpeMod == Integer(
        WSEControlLogics.Controls.WSEControls.Type.OperationModes.FreeCooling))
    "Free cooling mode"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3
    annotation (Placement(transformation(extent={{40,-82},{60,-62}})));
  Modelica.Blocks.Interfaces.IntegerInput
                                       numActChi "Number of active chillers"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea2
    annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));
  Modelica.Blocks.Sources.BooleanExpression parMec(
    y=
    uOpeMod == Integer(WSEControlLogics.Controls.WSEControls.Type.OperationModes.PartialMechanical)
    or
    uOpeMod == Integer(WSEControlLogics.Controls.WSEControls.Type.OperationModes.PrePartialMechanical))
    "Partial mechanical cooling mode"
    annotation (Placement(transformation(extent={{-20,-82},{0,-62}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold intGreEquThr(threshold=
       numChi)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi4
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant allOn(k=numPum)
    "All on" annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant parOn(k=max(1, numPum
         - 1))
    "Fixed number of the equipment are staged on"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  BaseClasses.SequenceSignal seqSig(n=numPum)
    "Simple model that is used to determine the on and off sequence of equipment"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{60,80},{80,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yPum
    "Number of active pumps"
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
        iconTransformation(extent={{100,30},{120,50}})));

  Modelica.Blocks.Math.Max max2
    annotation (Placement(transformation(extent={{-4,36},{16,56}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(k=1) "One"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
equation
  connect(zer.y, swi1.u1) annotation (Line(points={{1,110},{10,110},{10,98},{28,
          98}},
        color={0,0,127}));
  connect(unOcc.y, swi1.u2)
    annotation (Line(points={{-59,100},{-26,100},{-26,90},{28,90}},
                                                color={255,0,255}));
  connect(sta.ySta, intToRea1.u)
    annotation (Line(points={{-49,40},{-42,40}}, color={255,127,0}));
  connect(freCoo.y, swi2.u2)
    annotation (Line(points={{-19,10},{-8,10},{-8,10},{4,10},{4,10},{28,10}},
                                                color={255,0,255}));
  connect(swi2.y, swi1.u3) annotation (Line(points={{51,10},{56,10},{56,70},{20,
          70},{20,82},{28,82}}, color={0,0,127}));
  connect(numActChi,intToRea2. u)
    annotation (Line(points={{-120,-80},{-90,-80},{-90,-130},{-62,-130}},
                                                    color={255,127,0}));
  connect(intToRea2.y, swi3.u3) annotation (Line(points={{-39,-130},{20,-130},{20,
          -80},{38,-80}},
                     color={0,0,127}));
  connect(parMec.y, swi3.u2)
    annotation (Line(points={{1,-72},{38,-72}}, color={255,0,255}));
  connect(numActChi, intGreEquThr.u) annotation (Line(points={{-120,-80},{-90,-80},
          {-90,-50},{-62,-50}}, color={255,127,0}));
  connect(intGreEquThr.y, swi4.u2)
    annotation (Line(points={{-39,-50},{-22,-50}}, color={255,0,255}));
  connect(allOn.y, swi4.u1) annotation (Line(points={{-39,-10},{-30,-10},{-30,-42},
          {-22,-42}}, color={0,0,127}));
  connect(swi4.y, swi3.u1) annotation (Line(points={{1,-50},{20,-50},{20,-64},{38,
          -64}}, color={0,0,127}));
  connect(parOn.y, swi4.u3) annotation (Line(points={{-39,-90},{-30,-90},{-30,-58},
          {-22,-58}}, color={0,0,127}));
  connect(swi3.y, swi2.u3) annotation (Line(points={{61,-72},{70,-72},{70,-20},
          {10,-20},{10,2},{28,2}},  color={0,0,127}));
  connect(swi1.y, reaToInt.u)
    annotation (Line(points={{51,90},{58,90}}, color={0,0,127}));
  connect(reaToInt.y, seqSig.u) annotation (Line(points={{81,90},{90,90},{90,20},
          {60,20},{60,0},{68,0}}, color={255,127,0}));
  connect(seqSig.y, y) annotation (Line(points={{91,0},{94,0},{94,-40},{110,-40}},
        color={0,0,127}));
  connect(uSpeTow, sta.u) annotation (Line(points={{-120,80},{-96,80},{-96,44},
          {-72,44}},color={0,0,127}));
  connect(reaToInt.y, yPum)
    annotation (Line(points={{81,90},{90,90},{90,40},{110,40}},
                                                color={255,127,0}));
  connect(max2.y, swi2.u1) annotation (Line(points={{17,46},{20,46},{20,18},{28,
          18}}, color={0,0,127}));
  connect(one.y, max2.u1) annotation (Line(points={{-19,70},{-12,70},{-12,52},{
          -6,52}}, color={0,0,127}));
  connect(intToRea1.y, max2.u2)
    annotation (Line(points={{-19,40},{-6,40}}, color={0,0,127}));
  connect(unOcc.y, not2.u) annotation (Line(points={{-59,100},{-54,100},{-54,88},
          {-88,88},{-88,70},{-82,70}}, color={255,0,255}));
  connect(not2.y, sta.on) annotation (Line(points={{-59,70},{-54,70},{-54,56},{
          -88,56},{-88,36},{-72,36}}, color={255,0,255}));
  annotation (defaultComponentName = "staPum", Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{100,
            120}})),
    Documentation(info="<html>
<p>The condenser water pump stage control have different logics according to operation mode. Here assume the number of condenser pumps <code>numConPum</code> and 
that of the chillers <code>numChi</code>are identical.
</p>
<ul>
<li>
When in unoccupied mode, the condenser pump should be turned off.
</li>
<li>
When in free cooling mode, the number of operating condenser water pumps is staged based on the cooling tower fan speed signal. When the fan speed signal exceeds 80% for 5 minutes, then stage
up one condenser pump. When the fan speed signal is below 45% for 10 minutes, then stage down one condenser pump.
</li>
<li>
When in pre-partial and partial mechanical cooling mode, if not all chillers are active, the number of active condenser water pumps should be <code>numConPum-1</code>, else all the 
condenser pumps are commanded to run.
</li>
<li>
When in full mechanical cooling mode, the number of active condenser water pumps should be equal to the number of active chillers.
</li>
</ul>
</html>"));
end StagePump;
