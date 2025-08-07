within FaultInjection.Utilities.Holiday;
model IsHoliday "Determine if current time is holiday"

  Modelica.Blocks.Interfaces.IntegerInput mon "month"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.IntegerInput day "day"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.BooleanOutput tNexOccHolFla
    "Holiday tNexOcc calculation flag, true: regular occupancy schedule which is not affacted by holidays, false: unoccupied period due to holidays"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));

  Modelica.Blocks.Interfaces.BooleanOutput holFla
    "Holiday flag, true: holiday, false: not holiday"
    annotation (Placement(transformation(extent={{100,-48},{120,-28}})));
  Modelica.Blocks.Interfaces.IntegerInput hou "hour"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Data.UnitedStates USHol "US Holidays"
    annotation (Placement(transformation(extent={{16,72},{36,92}})));
  Data.HolidaytNextCalculation holtNexOccCal
    "Used for holiday next occupied time calculation"
    annotation (Placement(transformation(extent={{54,72},{74,92}})));
algorithm

  tNexOccHolFla := true;
  holFla := false;

  for i in 1:size(holtNexOccCal.tNextOccStart,1) loop

    if mon == holtNexOccCal.tNextOccStart[i, 1] and day == holtNexOccCal.tNextOccStart[
        i, 2] and hou >= 7 or mon == holtNexOccCal.tNextOccCont1[i, 1] and day ==
        holtNexOccCal.tNextOccCont1[i, 2] or mon == holtNexOccCal.tNextOccCont2
        [i, 1] and day == holtNexOccCal.tNextOccCont2[i, 2] or mon ==
        holtNexOccCal.tNextOccCont3[i, 1] and day == holtNexOccCal.tNextOccCont3
        [i, 2] and hou < 7 then

      tNexOccHolFla := false;

    end if;
  end for;

  for i in 1:size(USHol.holidays,1) loop

    if mon == USHol.holidays[i, 1] and day == USHol.holidays[i, 2] then

      holFla := true;

    end if;

  end for;

  annotation (defaultComponentName = "isHol",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,50},{44,-8}},
          lineColor={28,108,200},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,-8},{-44,-100}},
          lineColor={238,46,47},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-22,30},{14,14}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="H"),              Text(
        extent={{-152,146},{148,106}},
        textString="%name",
        lineColor={0,0,255})}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=8640000, __Dymola_Algorithm="Cvode"),
    Documentation(info="<html>
<p>This model determines if the current simulation date is a holiday, it can also decide when to start counting for the next occupied time.</p>
</html>"));
end IsHoliday;
