within FaultInjection.PrimarySideControl.BaseClasses;
model Stage "General stage control model"
  extends Modelica.Blocks.Icons.Block;

  parameter Real staUpThr = 1.25 "Staging up threshold";
  parameter Real staDowThr = 0.55 "Staging down threshold";

  parameter Modelica.SIunits.Time waiTimStaUp=300
    "Time duration of for staging up";
  parameter Modelica.SIunits.Time waiTimStaDow=600
    "Time duration of for staging down";
  parameter Modelica.SIunits.Time shoCycTim=1200
    "Time duration to avoid short cycling of equipment";

  Modelica.Blocks.Interfaces.RealInput u "Measured signal" annotation (
      Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.IntegerOutput ySta(start=0)
    "Stage number of next time step" annotation (Placement(transformation(
          extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,
            10}})));

  Modelica.StateGraph.InitialStepWithSignal off "All off" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-22,50})));
  Modelica.StateGraph.StepWithSignal oneOn(nIn=2, nOut=2)
    "One equipment is staged" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-22,-10})));
  Modelica.StateGraph.StepWithSignal twoOn "Two equipment are staged"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-22,-90})));
  Modelica.StateGraph.Transition tra1(
    condition=(timGreEqu.y >= waiTimStaUp and offTim.y >= shoCycTim) or on)
     "Transition 1" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-52,20})));
  Modelica.StateGraph.Transition tra2(
    condition=timGreEqu.y >= waiTimStaUp and oneOnTim.y >= shoCycTim)
    "Transition 1"
     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-42,-50})));
  FaultInjection.PrimarySideControl.BaseClasses.TimerGreatEqual timGreEqu(threshold=
       staUpThr) "Timer"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  FaultInjection.PrimarySideControl.BaseClasses.TimeLessEqual timLesEqu(threshold=
       staDowThr) "Timer"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.StateGraph.Transition tra3(condition=(timLesEqu.y >= waiTimStaDow
         and twoOnTim.y >= shoCycTim) or not on)
   "Transition 1" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-2,-50})));
  Modelica.StateGraph.Transition tra4(
    enableTimer=false, condition=(
        timLesEqu.y >= waiTimStaDow and oneOnTim.y >= shoCycTim) or not on)
   "Transition 1" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={0,20})));
  FaultInjection.PrimarySideControl.BaseClasses.Timer offTim
    "Timer for the state where equipment is off"
    annotation (Placement(transformation(extent={{18,40},{38,60}})));
  FaultInjection.PrimarySideControl.BaseClasses.Timer oneOnTim
    "Timer for the state where only one equipment is on"
    annotation (Placement(transformation(extent={{18,-20},{38,0}})));
  FaultInjection.PrimarySideControl.BaseClasses.Timer twoOnTim
    "Timer for the state where two equipment are on"
    annotation (Placement(transformation(extent={{18,-100},{38,-80}})));
  Modelica.Blocks.MathInteger.MultiSwitch mulSwi(expr={0,1,2}, nu=3)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Interfaces.BooleanInput on
    "Set to true to enable equipment, or false to disable equipment"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
equation
  connect(u, timGreEqu.u)
    annotation (Line(points={{-120,40},{-92,40},{-92,80},{-82,80}},
                                                  color={0,0,127}));
  connect(u, timLesEqu.u) annotation (Line(points={{-120,40},{-92,40},{-92,50},
          {-82,50}},color={0,0,127}));
  connect(off.active, offTim.u) annotation (Line(points={{-11,50},{16,50}},
                        color={255,0,255}));
  connect(oneOn.active, oneOnTim.u)
    annotation (Line(points={{-11,-10},{16,-10}},
                                               color={255,0,255}));
  connect(twoOn.active, twoOnTim.u)
    annotation (Line(points={{-11,-90},{16,-90}},color={255,0,255}));
  connect(off.outPort[1], tra1.inPort) annotation (Line(points={{-22,39.5},{-22,
          34},{-52,34},{-52,24}},
                              color={0,0,0}));
  connect(tra1.outPort, oneOn.inPort[1]) annotation (Line(points={{-52,18.5},{-52,
          8},{-22.5,8},{-22.5,1}},  color={0,0,0}));
  connect(oneOn.outPort[1], tra2.inPort) annotation (Line(points={{-22.25,-20.5},
          {-22.25,-30},{-42,-30},{-42,-46}},
                                           color={0,0,0}));
  connect(tra2.outPort, twoOn.inPort[1]) annotation (Line(points={{-42,-51.5},{-42,
          -68},{-22,-68},{-22,-79}},
                                 color={0,0,0}));
  connect(twoOn.outPort[1], tra3.inPort) annotation (Line(points={{-22,-100.5},{
          -22,-112},{-2,-112},{-2,-54}},
                              color={0,0,0}));
  connect(tra3.outPort, oneOn.inPort[2]) annotation (Line(points={{-2,-48.5},{-2,
          8},{-21.5,8},{-21.5,1}},color={0,0,0}));
  connect(oneOn.outPort[2], tra4.inPort) annotation (Line(points={{-21.75,-20.5},
          {-21.75,-30},{0,-30},{0,16}},
                                  color={0,0,0}));
  connect(tra4.outPort, off.inPort[1])
    annotation (Line(points={{0,21.5},{0,66},{-22,66},{-22,61}},
                                                               color={0,0,0}));
  connect(mulSwi.y, ySta)
    annotation (Line(points={{80.5,0},{110,0}}, color={255,127,0}));
  connect(off.active, mulSwi.u[1]) annotation (Line(points={{-11,50},{8,50},{8,
          70},{54,70},{54,2},{60,2}}, color={255,0,255}));
  connect(oneOn.active, mulSwi.u[2]) annotation (Line(points={{-11,-10},{10,-10},
          {10,-28},{54,-28},{54,0},{60,0}}, color={255,0,255}));
  connect(twoOn.active, mulSwi.u[3]) annotation (Line(points={{-11,-90},{10,-90},
          {10,-110},{56,-110},{56,-2},{60,-2}}, color={255,0,255}));
  annotation (defaultComponentName = "sta",
    Documentation(info="<html>
<p>
General stage control for two equipment using state-graph package in Modelica.
</p>
<ul>
<li>
One additional equipment stages on if measured signal is greater than a stage-up threshold <code>staUpThr</code> for a predefined time period 
<code>waiTimStaUp</code>, and the elapsed time since the staged equipment was off is greater than <code>shoCycTim</code> to avoid short cycling.
</li>
<li>
One additional equipment stages off if measured signal is less than a stage-down threshold <code>staUpThr</code> for a predefined time period 
<code>waiTimStaDow</code>, and the elapsed time since the staged equipment was on is greater than <code>shoCycTim</code> to avoid short cycling.
</li>
</ul>
</html>", revisions=""),
    Diagram(coordinateSystem(extent={{-100,-140},{100,100}})),
    __Dymola_Commands);
end Stage;
