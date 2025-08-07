within FaultInjection.Experimental.SystemLevelFaults.Controls;
model PlantRequest "Plant request control"
  extends Modelica.Blocks.Icons.Block;

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yPlaReq
    "Plant request" annotation (Placement(transformation(extent={{100,-10},{120,
            10}}), iconTransformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPlaVal(
    min=0,
    max=1,
    final unit="1") "Cooling or Heating valve position"
annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(final uHigh=uHigh,
      final uLow=uLow)
    "Check if valve position is greater than 0.95"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  parameter Real uLow=0.1 "if y=true and u<uLow, switch to y=false";
  parameter Real uHigh=0.95 "if y=false and u>uHigh, switch to y=true";
protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant onePlaReq(final k=1)
    "Constant 1"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerPlaReq(final k=0) "Constant 0"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Output 0 or 1 request "
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt "Convert real to integer value"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
equation
  connect(reaToInt.y, yPlaReq) annotation (Line(points={{92,0},{96,0},{96,0},{
          110,0}},
               color={255,127,0}));
  connect(swi.y, reaToInt.u)
    annotation (Line(points={{52,0},{68,0}}, color={0,0,127}));
  connect(onePlaReq.y, swi.u1)
    annotation (Line(points={{12,30},{20,30},{20,8},{28,8}}, color={0,0,127}));
  connect(zerPlaReq.y, swi.u3) annotation (Line(points={{12,-30},{20,-30},{20,
          -8},{28,-8}},
                    color={0,0,127}));
  connect(hys.y, swi.u2)
    annotation (Line(points={{-48,0},{28,0}}, color={255,0,255}));
  connect(uPlaVal, hys.u)
    annotation (Line(points={{-120,0},{-72,0}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>This module calculates the plant request number based on the valve position: </p>
<p><br><b>Chiller Plant Requests</b>. Send the chiller plant that serves the system a Chiller Plant Request as follows: </p>
<ol>
<li>If the CHW valve position is greater than 95&percnt;, send 1 Request until the CHW valve position is less than 10&percnt; </li>
<li>Else if the CHW valve position is less than 95&percnt;, send 0 Requests. </li>
</ol>
<p><b>Hot Water Plant Requests: </b>Send the heating hot water plant that serves the AHU a Hot Water Plant Request as follows: </p>
<ol>
<li>If the HW valve position is greater than 95&percnt;, send 1 Request until the HW valve position is less than 10&percnt; </li>
<li>Else if the HW valve position is less than 95&percnt;, send 0 Requests. </li>
</ol>
</html>", revisions="<html>
<ul>
<li>Sep 1, 2020, by Xing Lu:<br>First implementation. </li>
</ul>
</html>"));
end PlantRequest;
