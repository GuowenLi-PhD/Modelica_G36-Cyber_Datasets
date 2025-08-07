within FaultInjection.Experimental.Regulation.Controls;
model HotWaterTemperatureReset "Hot Water Temperature Reset Control"

  parameter Real uHigh=0.95 "if y=false and u>uHigh, switch to y=true";
  parameter Real uLow=0.85 "if y=true and u<uLow, switch to y=false";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPlaHeaVal
    "Heating valve position"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  parameter Real iniSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") = maxSet
    "Initial setpoint"
    annotation (Dialog(group="Trim and respond for pressure setpoint"));
  parameter Real minSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") = 273.15 + 32.2
    "Minimum setpoint"
    annotation (Dialog(group="Trim and respond for pressure setpoint"));
  parameter Real maxSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") = 273.15 + 45
    "Maximum setpoint"
    annotation (Dialog(group="Trim and respond for pressure setpoint"));
  parameter Real delTim(
    final unit="s",
    final quantity="Time")= 600
   "Delay time after which trim and respond is activated"
    annotation (Dialog(group="Trim and respond for pressure setpoint"));
  parameter Real samplePeriod(
    final unit="s",
    final quantity="Time") = 300  "Sample period"
    annotation (Dialog(group="Trim and respond for pressure setpoint"));
  parameter Integer numIgnReq = 0
    "Number of ignored requests"
    annotation (Dialog(group="Trim and respond for pressure setpoint"));
  parameter Real triAmo(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference") = -1
    "Trim amount"
    annotation (Dialog(group="Trim and respond for pressure setpoint"));
  parameter Real resAmo(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference") = 1.5
    "Response amount"
    annotation (Dialog(group="Trim and respond for pressure setpoint"));
  parameter Real maxRes(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference") = 4
    "Maximum response per time interval (same sign as resAmo)"
    annotation (Dialog(group="Trim and respond for pressure setpoint"));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.TrimAndRespond staTBoiSupSetRes(
    final iniSet=iniSet,
    final minSet=minSet,
    final maxSet=maxSet,
    final delTim=delTim,
    final samplePeriod=samplePeriod,
    final numIgnReq=numIgnReq,
    final triAmo=triAmo,
    final resAmo=resAmo,
    final maxRes=maxRes)
    "Static pressure setpoint reset using trim and respond logic"
    annotation (Placement(transformation(extent={{-40,-2},{-20,18}})));

  FaultInjection.Experimental.Regulation.Controls.PlantRequest plaReq(uLow=uLow,
      uHigh=uHigh)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDevSta
    "On/Off status of the associated device"
    annotation (Placement(transformation(extent={{-140,54},{-100,94}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupBoi(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Setpoint for boiler supply water temperature"
    annotation (Placement(transformation(extent={{100,-12},{140,28}}),
        iconTransformation(extent={{100,-20},{140,20}})));
protected
  Buildings.Controls.OBC.CDL.Discrete.FirstOrderHold firOrdHol(final
      samplePeriod=samplePeriod)
    "Extrapolation through the values of the last two sampled input signals"
    annotation (Placement(transformation(extent={{10,-2},{30,18}})));
equation
  connect(plaReq.uPlaVal, uPlaHeaVal)
    annotation (Line(points={{-82,0},{-120,0}}, color={0,0,127}));
  connect(plaReq.yPlaReq, staTBoiSupSetRes.numOfReq)
    annotation (Line(points={{-59,0},{-42,0}}, color={255,127,0}));
  connect(staTBoiSupSetRes.uDevSta, uDevSta) annotation (Line(points={{-42,16},{
          -50,16},{-50,74},{-120,74}}, color={255,0,255}));
  connect(staTBoiSupSetRes.y, firOrdHol.u)
    annotation (Line(points={{-18,8},{8,8}}, color={0,0,127}));
  connect(firOrdHol.y, TSupBoi)
    annotation (Line(points={{32,8},{120,8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                                        Text(
        extent={{-152,146},{148,106}},
        textString="%name",
        lineColor={0,0,255})}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Hot water supply temperature setpoint shall be reset using Trim &amp; Respond logic using following parameters as a starting point: </p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"1\"><tr>
<td><p align=\"center\"><h4>Variable </h4></p></td>
<td><p align=\"center\"><h4>Value </h4></p></td>
<td><p align=\"center\"><h4>Definition </h4></p></td>
</tr>
<tr>
<td><p>Device</p></td>
<td><p>HW Loop</p></td>
<td><p>Associated device</p></td>
</tr>
<tr>
<td><p>SP0</p></td>
<td><p><span style=\"font-family: Courier New;\">iniSet</span></p></td>
<td><p>Initial setpoint</p></td>
</tr>
<tr>
<td><p>SPmin</p></td>
<td><p><span style=\"font-family: Courier New;\">minSet</span></p></td>
<td><p>Minimum setpoint</p></td>
</tr>
<tr>
<td><p>SPmax</p></td>
<td><p><span style=\"font-family: Courier New;\">maxSet</span></p></td>
<td><p>Maximum setpoint</p></td>
</tr>
<tr>
<td><p>Td</p></td>
<td><p><span style=\"font-family: Courier New;\">delTim</span></p></td>
<td><p>Delay timer</p></td>
</tr>
<tr>
<td><p>T</p></td>
<td><p><span style=\"font-family: Courier New;\">samplePeriod</span></p></td>
<td><p>Time step</p></td>
</tr>
<tr>
<td><p>I</p></td>
<td><p><span style=\"font-family: Courier New;\">numIgnReq</span></p></td>
<td><p>Number of ignored requests</p></td>
</tr>
<tr>
<td><p>R</p></td>
<td><p><span style=\"font-family: Courier New;\">uZonPreResReq</span></p></td>
<td><p>Number of requests</p></td>
</tr>
<tr>
<td><p>SPtrim</p></td>
<td><p><span style=\"font-family: Courier New;\">triAmo</span></p></td>
<td><p>Trim amount</p></td>
</tr>
<tr>
<td><p>SPres</p></td>
<td><p><span style=\"font-family: Courier New;\">resAmo</span></p></td>
<td><p>Respond amount</p></td>
</tr>
<tr>
<td><p>SPres_max</p></td>
<td><p><span style=\"font-family: Courier New;\">maxRes</span></p></td>
<td><p>Maximum response per time interval</p></td>
</tr>
</table>
</html>"));
end HotWaterTemperatureReset;
