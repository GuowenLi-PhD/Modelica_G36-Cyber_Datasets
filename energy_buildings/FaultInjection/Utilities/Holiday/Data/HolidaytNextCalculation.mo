within FaultInjection.Utilities.Holiday.Data;
record HolidaytNextCalculation
  parameter Integer threeDaysCountdown[:,2] = [[1,17];[5,22];[9,4];[10,9];[7,2];[12,24]];
  parameter Integer twoDaysCountdown[:,2] = [[1,18];[5,23];[9,5];[10,10];[7,3];[12,25]];
  parameter Integer oneDayCountdown[:,2] = [[1,19];[5,24];[9,6];[10,11];[7,4];[12,26];[11,10];[11,25]];
  parameter Integer zeroDayCountdown[:,2] = [[1,20];[5,25];[9,7];[10,12];[7,5];[12,27];[1,1];[11,11];[11,26]];

  parameter Integer tNextOccStart[:,2] = [[1,17];[5,22];[7,2];[9,4];[10,9];[11,10];[11,25];[12,24];[0,0]];
  parameter Integer tNextOccCont1[:,2] = [[1,18];[5,23];[9,5];[10,10];[7,3];[12,25];[11,11];[11,26];[1,1]];
  parameter Integer tNextOccCont2[:,2] = [[1,19];[5,24];[9,6];[10,11];[7,4];[12,26];[0,0];[0,0];[0,0]];
  parameter Integer tNextOccCont3[:,2] = [[1,20];[5,25];[9,7];[10,12];[7,5];[12,27];[0,0];[0,0];[0,0]];
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          origin={0,-25},
          lineColor={64,64,64},
          fillColor={255,215,136},
          fillPattern=FillPattern.Solid,
          extent={{-100.0,-75.0},{100.0,75.0}},
          radius=25.0),
        Text(
          lineColor={0,0,255},
          extent={{-150,60},{150,100}},
          textString="%name"),
        Line(
          points={{-100,0},{100,0}},
          color={64,64,64}),
        Line(
          origin={0,-50},
          points={{-100.0,0.0},{100.0,0.0}},
          color={64,64,64}),
        Line(
          origin={0,-25},
          points={{0.0,75.0},{0.0,-75.0}},
          color={64,64,64})}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This block stores and groups dates for the convenience of tNextOcc calculations. Note that the current stored dates are only valid for year 2020.</p>
</html>"));
end HolidaytNextCalculation;
