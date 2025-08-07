within FaultInjection.Utilities.Holiday;
model TimeToNextOccupiedHour
  "Calculate the time period till next occupied hour"

  Integer n;

  Modelica.Blocks.Interfaces.IntegerInput mon "Month"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.IntegerInput day "Day"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}})));
  Modelica.Blocks.Interfaces.IntegerInput hou "Hour"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}})));
  Modelica.Blocks.Interfaces.RealOutput tNexOcc "Next occupied time"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput min "Minute"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Data.HolidaytNextCalculation holtNexOccCal
    annotation (Placement(transformation(extent={{64,68},{84,88}})));
algorithm

  for i in 1:size(holtNexOccCal.threeDaysCountdown,1) loop

    if mon == holtNexOccCal.threeDaysCountdown[i, 1] and day == holtNexOccCal.threeDaysCountdown[
        i, 2] then
        n :=3;
      end if;

  end for;

  for i in 1:size(holtNexOccCal.twoDaysCountdown,1) loop

    if mon == holtNexOccCal.twoDaysCountdown[i, 1] and day == holtNexOccCal.twoDaysCountdown[
        i, 2] then
        n :=2;
      end if;

  end for;

  for i in 1:size(holtNexOccCal.oneDayCountdown,1) loop

    if mon == holtNexOccCal.oneDayCountdown[i, 1] and day == holtNexOccCal.oneDayCountdown[
        i, 2] then
        n :=1;
      end if;

   end for;

   for i in 1:size(holtNexOccCal.zeroDayCountdown,1) loop

    if mon == holtNexOccCal.zeroDayCountdown[i, 1] and day == holtNexOccCal.zeroDayCountdown[
        i, 2] then
        n :=0;
      end if;

   end for;

  tNexOcc := (24 - hou + 24*n + 7)*3600 - min*60;

  annotation (defaultComponentName = "tNexOcc",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-92,94},{18,-16}},
          lineColor={28,108,200},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Line(points={{-58,68},{-38,38},{-14,34}}, color={28,108,200}),
                                        Text(
        extent={{-152,146},{148,106}},
        textString="%name",
        lineColor={0,0,255})}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This model determines how long it will take until the next occupied time on holidays.</p>
</html>"));
end TimeToNextOccupiedHour;
