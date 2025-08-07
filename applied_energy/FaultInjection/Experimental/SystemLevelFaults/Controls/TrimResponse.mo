within FaultInjection.Experimental.SystemLevelFaults.Controls;
model TrimResponse "Trim and response"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.Time samplePeriod=120 "Sample period of component";
  parameter Real uTri=0 "Value to triggering the request for actuator";
  parameter Real yEqu0=0 "y setpoint when equipment starts";
  parameter Real yDec=-0.03 "y decrement (must be negative)";
  parameter Real yInc=0.03 "y increment (must be positive)";
  parameter Real x1=0.5 "First interval [x0, x1] and second interval (x1, x2]"
  annotation(Dialog(tab="Pressure and temperature reset points"));
  parameter Modelica.SIunits.Pressure dpMin = 100 "dpmin"
  annotation(Dialog(tab="Pressure and temperature reset points"));
  parameter Modelica.SIunits.Pressure dpMax =  300 "dpmax"
  annotation(Dialog(tab="Pressure and temperature reset points"));
  parameter Modelica.SIunits.ThermodynamicTemperature TMin=273.15+32 "Tchi,min"
  annotation(Dialog(tab="Pressure and temperature reset points"));
  parameter Modelica.SIunits.ThermodynamicTemperature TMax = 273.15+45 "Tchi,max"
  annotation(Dialog(tab="Pressure and temperature reset points"));
  parameter Modelica.SIunits.Time startTime=0 "First sample time instant";

  Modelica.Blocks.Interfaces.RealInput u
    "Input signall, such as dT, or valve position"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  PrimarySideControl.BaseClasses.LinearPiecewiseTwo linPieTwo(
    x0=0,
    x1=x1,
    x2=1,
    y10=dpMin,
    y11=dpMax,
    y20=TMin,
    y21=TMax) "Calculation of two piecewise linear functions"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Modelica.Blocks.Interfaces.RealOutput dpSet(
    final quantity="Pressure",
    final unit = "Pa") "DP setpoint"
    annotation (Placement(transformation(extent={{100,40},{120,60}}),
        iconTransformation(extent={{100,40},{120,60}})));
  Modelica.Blocks.Interfaces.RealOutput TSet(
    final quantity="ThermodynamicTemperature",
    final unit="K")
    "CHWST"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}}),
        iconTransformation(extent={{100,-60},{120,-40}})));
  PrimarySideControl.BaseClasses.TrimAndRespond triAndRes(
    samplePeriod=samplePeriod,
    startTime=startTime,
    uTri=uTri,
    yEqu0=yEqu0,
    yDec=yDec,
    yInc=yInc)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDevSta
    "On/Off status of the associated device"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
        iconTransformation(extent={{-180,10},{-100,90}})));
  Modelica.Blocks.Sources.RealExpression dpSetIni(y=dpMin)
    "Initial dp setpoint"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Modelica.Blocks.Sources.RealExpression TSetIni(y=TMin)
    "Initial temperature setpoint"
    annotation (Placement(transformation(extent={{-20,-88},{0,-68}})));
  Modelica.Blocks.Logical.Switch swi2 "Switch"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Modelica.Blocks.Logical.Switch swi1 "Switch"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
equation

  connect(triAndRes.y, linPieTwo.u)
    annotation (Line(points={{-19,0},{18,0}}, color={0,0,127}));
  connect(u, triAndRes.u)
    annotation (Line(points={{-120,0},{-42,0}}, color={0,0,127}));
  connect(uDevSta, swi1.u2) annotation (Line(points={{-120,70},{0,70},{0,80},{
          58,80}}, color={255,0,255}));
  connect(swi1.y, dpSet) annotation (Line(points={{81,80},{92,80},{92,50},{110,
          50}}, color={0,0,127}));
  connect(linPieTwo.y[1], swi1.u1) annotation (Line(points={{41,-0.5},{48,-0.5},
          {48,88},{58,88}}, color={0,0,127}));
  connect(dpSetIni.y, swi1.u3) annotation (Line(points={{1,90},{46,90},{46,72},
          {58,72}}, color={0,0,127}));
  connect(uDevSta, swi2.u2) annotation (Line(points={{-120,70},{0,70},{0,-70},{
          58,-70}}, color={255,0,255}));
  connect(TSetIni.y, swi2.u3)
    annotation (Line(points={{1,-78},{58,-78}}, color={0,0,127}));
  connect(linPieTwo.y[2], swi2.u1) annotation (Line(points={{41,0.5},{48,0.5},{
          48,-62},{58,-62}}, color={0,0,127}));
  connect(swi2.y, TSet) annotation (Line(points={{81,-70},{88,-70},{88,-50},{
          110,-50}}, color={0,0,127}));
  annotation (defaultComponentName="triRes",
    Documentation(info="<html>
<p>This model describes a chilled water supply temperature setpoint and differential pressure setpoint reset control. In this logic, it is to first increase the different pressure, <i>&Delta;p</i>, of the chilled water loop to increase the mass flow rate. If <i>&Delta;p</i> reaches the maximum value and further cooling is still needed, the chiller remperature setpoint, <i>T<sub>chi,set</i></sub>, is reduced. If there is too much cooling, the <i>T<sub>chi,set</i></sub> and <i>&Delta;p</i> will be changed in the reverse direction. </p>
<p>The model implements a discrete time trim and respond logic as follows: </p>
<ul>
<li>A cooling request is triggered if the input signal, <i>y</i>, is larger than 0. <i>y</i> is the difference between the actual and set temperature of the suppuly air to the data center room.</li>
<li>The request is sampled every 2 minutes. If there is a cooling request, the control signal <i>u</i> is increased by <i>0.03</i>, where <i>0 &le; u &le; 1</i>. If there is no cooling request, <i>u</i> is decreased by <i>0.03</i>. </li>
</ul>
<p>The control signal <i>u</i> is converted to setpoints for <i>&Delta;p</i> and <i>T<sub>chi,set</i></sub> as follows: </p>
<ul>
<li>If <i>u &isin; [0, x]</i> then <i>&Delta;p = &Delta;p<sub>min</sub> + u &nbsp;(&Delta;p<sub>max</sub>-&Delta;p<sub>min</sub>)/x</i> and <i>T = T<sub>max</i></sub></li>
<li>If <i>u &isin; (x, 1]</i> then <i>&Delta;p = &Delta;p<sub>max</i></sub> and <i>T = T<sub>max</sub> - (u-x)&nbsp;(T<sub>max</sub>-T<sub>min</sub>)/(1-x) </i></li>
</ul>
<p>where <i>&Delta;p<sub>min</i></sub> and <i>&Delta;p<sub>max</i></sub> are minimum and maximum values for <i>&Delta;p</i>, and <i>T<sub>min</i></sub> and <i>T<sub>max</i></sub> are the minimum and maximum values for <i>T<sub>chi,set</i></sub>. </p>
<p>Note that we deactivate the trim and response when the chillers are off.</p>

<h4>Reference</h4>
<p>Stein, J. (2009). Waterside Economizing in Data Centers: Design and Control Considerations. ASHRAE Transactions, 115(2), 192-200.</p>
<p>Taylor, S.T. (2007). Increasing Efficiency with VAV System Static Pressure Setpoint Reset. ASHRAE Journal, June, 24-32. </p>
</html>", revisions="<html>
<ul>
<li><i>December 19, 2018</i> by Yangyang Fu:<br/>
        Deactivate reset when chillers are off.
</li>
<li><i>June 23, 2018</i> by Xing Lu:<br/>
        First implementation.
</li>
</ul>
</html>"));
end TrimResponse;
