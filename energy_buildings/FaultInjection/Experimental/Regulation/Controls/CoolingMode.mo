within FaultInjection.Experimental.Regulation.Controls;
model CoolingMode
  "Mode controller for integrated waterside economizer and chiller"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.SIunits.Time tWai "Waiting time";
  parameter Modelica.SIunits.TemperatureDifference deaBan1
    "Dead band width 1 for switching chiller on ";
  parameter Modelica.SIunits.TemperatureDifference deaBan2
    "Dead band width 2 for switching waterside economizer off";
  parameter Modelica.SIunits.TemperatureDifference deaBan3
    "Dead band width 3 for switching waterside economizer on ";
  parameter Modelica.SIunits.TemperatureDifference deaBan4
    "Dead band width 4 for switching chiller off";

  Modelica.Blocks.Interfaces.RealInput TCHWRetWSE(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Temperature of entering chilled water that flows to waterside economizer "
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput TCHWSupWSE(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Temperature of leaving chilled water that flows out from waterside economizer"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealInput TCHWSupSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Supply chilled water temperature setpoint "
    annotation (Placement(transformation(extent={{-140,22},{-100,62}}),
        iconTransformation(extent={{-140,22},{-100,62}})));
  Modelica.Blocks.Interfaces.RealInput TApp(
    final quantity="TemperatureDifference",
    final unit="K",
    displayUnit="degC") "Approach temperature in the cooling tower"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Interfaces.IntegerOutput y
    "Cooling mode signal, integer value of Buildings.Applications.DataCenters.Types.CoolingMode"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.StateGraph.Transition con4(
    enableTimer=true,
    waitTime=tWai,
    condition=TCHWSupWSE > TCHWSupSet + deaBan1 and yPla)
    "Fire condition 4: free cooling to partially mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,28})));
  Modelica.StateGraph.StepWithSignal parMecCoo(nIn=2, nOut=3)
    "Partial mechanical cooling mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-10,-2})));
  Modelica.StateGraph.StepWithSignal        freCoo(nIn=1, nOut=2)
    "Free cooling mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-10,58})));
  Modelica.StateGraph.StepWithSignal fulMecCoo(nIn=2,
                                               nOut=2)
                                               "Fully mechanical cooling mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-10,-44})));
  Modelica.StateGraph.Transition con5(
    enableTimer=true,
    waitTime=tWai,
    condition=TCHWRetWSE < TCHWSupWSE + deaBan2 and yPla)
    "Fire condition 5: partially mechanical cooling to fully mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,-24})));
  Modelica.StateGraph.Transition con2(
    enableTimer=true,
    waitTime=tWai,
    condition=TCHWRetWSE > TWetBul + TApp + deaBan3)
    "Fire condition 2: fully mechanical cooling to partially mechanical cooling"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={30,-20})));
  Modelica.StateGraph.Transition con3(
    enableTimer=true,
    waitTime=tWai,
    condition=TCHWSupWSE <= TCHWSupSet + deaBan4)
    "Fire condition 3: partially mechanical cooling to free cooling"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={20,34})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Interfaces.RealInput TWetBul(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Wet bulb temperature of outdoor air"
    annotation (Placement(transformation(extent={{-140,-10},{-100,30}})));

  Modelica.Blocks.MathInteger.MultiSwitch swi(
    y_default=0,
    expr={Integer(FaultInjection.Experimental.Regulation.Types.CoolingModes.FreeCooling),
        Integer(FaultInjection.Experimental.Regulation.Types.CoolingModes.PartialMechanical),
        Integer(FaultInjection.Experimental.Regulation.Types.CoolingModes.FullMechanical),
        Integer(FaultInjection.Experimental.Regulation.Types.CoolingModes.Off)},
    nu=4)
    "Switch boolean signals to real signal"
    annotation (Placement(transformation(extent={{68,-6},{92,6}})));

  Modelica.Blocks.Interfaces.BooleanInput            yPla "Plant on/off signal"
    annotation (Placement(transformation(extent={{-140,48},{-100,88}}),
        iconTransformation(extent={{-140,48},{-100,88}})));
  Modelica.StateGraph.InitialStepWithSignal off(nIn=3) "Off" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-10,-80})));
  Modelica.StateGraph.Transition con8(
    enableTimer=true,
    waitTime=0,
    condition=not yPla) "Fire condition 8: fully mechanical cooling to off"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,-60})));
  Modelica.StateGraph.Transition con7(
    enableTimer=true,
    waitTime=0,
    condition=not yPla) "Fire condition 7: partially mechanical cooling to off"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={70,-34})));
  Modelica.StateGraph.Transition con1(
    enableTimer=true,
    waitTime=0,
    condition=yPla) "Fire condition 1: off to free cooling"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={40,-80})));
  Modelica.StateGraph.Transition con6(
    enableTimer=true,
    waitTime=0,
    condition=not yPla) "Fire condition 6: free cooling to off"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,20})));
equation
  connect(freCoo.outPort[1], con4.inPort) annotation (Line(
      points={{-10.25,47.5},{-10.25,32},{-10,32}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con4.outPort, parMecCoo.inPort[1]) annotation (Line(
      points={{-10,26.5},{-10,18},{-10.5,18},{-10.5,9}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con5.inPort, parMecCoo.outPort[1])
    annotation (Line(
      points={{-10,-20},{-10.3333,-20},{-10.3333,-12.5}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con5.outPort, fulMecCoo.inPort[1])
    annotation (Line(
      points={{-10,-25.5},{-10,-30},{-10,-33},{-10.5,-33}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(fulMecCoo.outPort[1],con2. inPort)
    annotation (Line(
      points={{-10.25,-54.5},{-10.25,-58},{30,-58},{30,-24}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con2.outPort, parMecCoo.inPort[2])
    annotation (Line(
      points={{30,-18.5},{30,16},{-9.5,16},{-9.5,9}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con3.inPort, parMecCoo.outPort[2]) annotation (Line(
      points={{20,30},{20,-16},{-10,-16},{-10,-12.5}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(swi.y, y)
    annotation (Line(points={{92.6,0},{110,0}}, color={255,127,0}));
  connect(parMecCoo.outPort[3],con7. inPort) annotation (Line(
      points={{-9.66667,-12.5},{-9.66667,-14},{70,-14},{70,-30}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con7.outPort, off.inPort[2]) annotation (Line(
      points={{70,-35.5},{70,-64},{-10,-64},{-10,-69}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con8.outPort, off.inPort[3]) annotation (Line(
      points={{80,-61.5},{80,-66},{-10,-66},{-10,-69},{-9.33333,-69}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(freCoo.outPort[2], con6.inPort) annotation (Line(
      points={{-9.75,47.5},{-9.75,42},{60,42},{60,24}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con6.outPort, off.inPort[1]) annotation (Line(
      points={{60,18.5},{60,-62},{-10.6667,-62},{-10.6667,-69}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(fulMecCoo.outPort[2], con8.inPort) annotation (Line(
      points={{-9.75,-54.5},{-9.75,-56},{80,-56}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(off.outPort[1], con1.inPort) annotation (Line(
      points={{-10,-90.5},{-10,-96},{40,-96},{40,-84}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con1.outPort, fulMecCoo.inPort[2]) annotation (Line(
      points={{40,-78.5},{40,-28},{-9.5,-28},{-9.5,-33}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(freCoo.active, swi.u[1]) annotation (Line(points={{1,58},{42,58},{42,
          1.35},{68,1.35}}, color={255,0,255}));
  connect(parMecCoo.active, swi.u[2]) annotation (Line(points={{1,-2},{46,-2},{
          46,0.45},{68,0.45}}, color={255,0,255}));
  connect(fulMecCoo.active, swi.u[3]) annotation (Line(points={{1,-44},{48,-44},
          {48,-0.45},{68,-0.45}}, color={255,0,255}));
  connect(off.active, swi.u[4]) annotation (Line(points={{1,-80},{20,-80},{20,
          -46},{50,-46},{50,-1.2},{68,-1.2},{68,-1.35}}, color={255,0,255}));
  connect(con3.outPort, freCoo.inPort[1]) annotation (Line(
      points={{20,35.5},{20,76},{-10,76},{-10,69}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  annotation (    Documentation(info="<html>
<p>Controller that outputs if the chilled water system is in off mode,  Free Cooling (FC) mode, Partially Mechanical Cooling (PMC) mode or Fully Mechanical Cooling (FMC) mode. </p>
<p>The waterside economizer is enabled when </p>
<ol>
<li>The waterside economizer has been disabled for at least 20 minutes, and </li>
<li><i>T<sub>CHWR</sub> &gt; T<sub>WetBul</sub> + T<sub>TowApp</sub> + deaBan1 </i></li>
</ol>
<p>The waterside economizer is disabled when </p>
<ol>
<li>The waterside economizer has been enabled for at least 20 minutes, and </li>
<li><i>T<sub>WSE_CHWST</sub> &gt; T<sub>WSE_CHWRT</sub> - deaBan2 </i></li>
</ol>
<p>The chiller is enabled when </p>
<ol>
<li>The chiller has been disabled for at leat 20 minutes, and </li>
<li><i>T<sub>WSE_CHWST</sub> &gt; T<sub>CHWSTSet</sub> + deaBan3 </i></li>
</ol>
<p>The chiller is disabled when </p>
<ol>
<li>The chiller has been enabled for at leat 20 minutes, and </li>
<li><i>T<sub>WSE_CHWST</sub> &le; T<sub>CHWSTSet</sub> + deaBan4 </i></li>
</ol>
<p>where <i>T<sub>WSE_CHWST</i></sub> is the chilled water supply temperature for the WSE, <i>T<sub>WetBul</i></sub> is the wet bulb temperature, <i>T<sub>TowApp</i></sub> is the cooling tower approach, <i>T<sub>WSE_CHWRT</i></sub> is the chilled water return temperature for the WSE, and <i>T<sub>CHWSTSet</i></sub> is the chilled water supply temperature setpoint for the system. <i>deaBan 1-4</i> are deadbands for each switching point. </p>
<h4>References</h4>
<ul>
<li>Stein, Jeff. Waterside Economizing in Data Centers: Design and Control Considerations. ASHRAE Transactions 115.2 (2009). </li>
</ul>
</html>",        revisions="<html>
<ul>
<li>
July 24, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-100},{100,80}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,80}})));
end CoolingMode;
