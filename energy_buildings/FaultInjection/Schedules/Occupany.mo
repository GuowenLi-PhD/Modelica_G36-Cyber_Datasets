within FaultInjection.Schedules;
model Occupany "Occupncy schedule"
  Buildings.Controls.SetPoints.OccupancySchedule occSch
    "Occupancy schedule with no distinction between working days and non-working days"
    annotation (Placement(transformation(extent={{-84,-12},{-64,8}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.CalendarTime calTim(zerTim=
        Buildings.Controls.OBC.CDL.Types.ZeroTime.NY2020)
    annotation (Placement(transformation(extent={{-36,-4},{-16,16}})));
  Modelica.Blocks.Logical.Switch swi1
    "Overwrite the value of occSch.tNexOcc, keep orignal value when Sun 0700 - Fri 0700, switch down when Fri 0700 - Sun 0700"
    annotation (Placement(transformation(extent={{-28,52},{-8,72}})));
  Modelica.Blocks.Logical.LogicalSwitch swi2
    "Overwrite the value of occSch.occupied, keep original value when Mon - Fri, switch down when Sat - Sun"
    annotation (Placement(transformation(extent={{-24,-60},{-4,-40}})));
  Modelica.Blocks.Sources.BooleanExpression swi2Sig(y=calTim.weekDay >= 1 and
        calTim.weekDay <= 5)
    "Signal of switch 2, true when Mon-Fri 0700-1900, else false"
    annotation (Placement(transformation(extent={{-84,-60},{-64,-40}})));
  Modelica.Blocks.Sources.RealExpression ovetNexOcc(y=(24 - calTim.hour + 24*(7
         - calTim.weekDay) + 7)*3600 - calTim.minute*60)
    "Next-occupied-time expressions for Fri 0700 - Sun 0700"
    annotation (Placement(transformation(extent={{-86,44},{-66,64}})));
  Modelica.Blocks.Sources.BooleanExpression fal(y=false)
    "Unccupied time periods : Mon - Fri: 1900 - 0700, Sat - Sun: all day, output false"
    annotation (Placement(transformation(extent={{-84,-82},{-64,-62}})));
  Modelica.Blocks.Sources.BooleanExpression swi1Sig(y=calTim.weekDay >= 1 and
        calTim.weekDay <= 4 or calTim.weekDay == 5 and calTim.hour < 7 or
        calTim.weekDay == 7 and calTim.hour >= 7)
    "Signal of switch 1, true when Sun 0700 - Fri 0700, else false"
    annotation (Placement(transformation(extent={{-86,70},{-66,90}})));
  Modelica.Blocks.Logical.Switch swi3
    "Overwrite tNexOcc expression for holiday conditions"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Modelica.Blocks.Logical.LogicalSwitch swi4
    "keep swi2.y for regular days (output true), switch down for holidays(output false)"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Utilities.Holiday.IsHoliday holFla
    "Determine the time when overwrite switches should be flipped"
    annotation (Placement(transformation(extent={{16,-4},{36,16}})));
  Modelica.Blocks.Interfaces.RealOutput tNexOcc "Time until next occupancy"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.BooleanOutput occupied
    "Outputs true if occupied at current time"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Utilities.Holiday.TimeToNextOccupiedHour tNexOccOve
    "Expression for next occupied time on holidays"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Blocks.Interfaces.BooleanOutput nonWorDay
    "Nonwork days, false: working days; true: weekends and holidays"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Logical.Or or1
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Modelica.Blocks.Sources.BooleanExpression weeEnd(y=calTim.weekDay >= 6 and
        calTim.weekDay <= 7) "true: Sat - Sun; false: M - F"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
equation
  connect(swi1.y,swi3. u1) annotation (Line(points={{-7,62},{42,62},{42,68},{58,
          68}}, color={0,0,127}));
  connect(swi3.y,tNexOcc)  annotation (Line(points={{81,60},{110,60}},
                    color={0,0,127}));
  connect(swi4.y,occupied)  annotation (Line(points={{81,-60},{110,-60}},
                      color={255,0,255}));
  connect(occSch.occupied,swi2. u1) annotation (Line(points={{-63,-8},{-46,-8},
          {-46,-42},{-26,-42}}, color={255,0,255}));
  connect(swi2Sig.y,swi2. u2)
    annotation (Line(points={{-63,-50},{-26,-50}}, color={255,0,255}));
  connect(fal.y, swi2.u3) annotation (Line(points={{-63,-72},{-46,-72},{-46,-58},
          {-26,-58}}, color={255,0,255}));
  connect(occSch.tNexOcc,swi1. u1) annotation (Line(points={{-63,4},{-52,4},{-52,
          70},{-30,70}},     color={0,0,127}));
  connect(swi1Sig.y,swi1. u2) annotation (Line(points={{-65,80},{-48,80},{-48,62},
          {-30,62}},     color={255,0,255}));
  connect(ovetNexOcc.y,swi1. u3)
    annotation (Line(points={{-65,54},{-30,54}}, color={0,0,127}));
  connect(holFla.holFla, swi4.u2) annotation (Line(points={{37,2.2},{48,2.2},{48,
          -60},{58,-60}}, color={255,0,255}));
  connect(calTim.month, holFla.mon)
    annotation (Line(points={{-15,6},{0,6},{0,0},{14,0}}, color={255,127,0}));
  connect(calTim.hour, holFla.hou) annotation (Line(points={{-15,12},{4,12},{4,12},
          {14,12}}, color={255,127,0}));
  connect(calTim.minute, tNexOccOve.min) annotation (Line(points={{-15,15},{-2,15},
          {-2,38},{58,38}}, color={0,0,127}));
  connect(calTim.hour, tNexOccOve.hou) annotation (Line(points={{-15,12},{8,12},
          {8,33},{58,33}}, color={255,127,0}));
  connect(calTim.day, tNexOccOve.day) annotation (Line(points={{-15,9},{4,9},{4,
          27},{58,27}}, color={255,127,0}));
  connect(calTim.month, tNexOccOve.mon) annotation (Line(points={{-15,6},{0,6},
          {0,22},{58,22}},                  color={255,127,0}));
  connect(holFla.tNexOccHolFla, swi3.u2) annotation (Line(points={{37,10},{48,10},
          {48,60},{58,60}}, color={255,0,255}));
  connect(tNexOccOve.tNexOcc, swi3.u3) annotation (Line(points={{81,30},{90,30},
          {90,46},{52,46},{52,52},{58,52}}, color={0,0,127}));
  connect(weeEnd.y, or1.u2) annotation (Line(points={{41,-40},{50,-40},{50,-38},
          {58,-38}}, color={255,0,255}));
  connect(or1.y, nonWorDay) annotation (Line(points={{81,-30},{96,-30},{96,0},{110,
          0}}, color={255,0,255}));
  connect(holFla.holFla, or1.u1) annotation (Line(points={{37,2.2},{48,2.2},{48,
          -30},{58,-30}}, color={255,0,255}));
  connect(swi2.y, swi4.u3) annotation (Line(points={{-3,-50},{12,-50},{12,-68},{
          58,-68}}, color={255,0,255}));
  connect(fal.y, swi4.u1) annotation (Line(points={{-63,-72},{8,-72},{8,-52},{58,
          -52}}, color={255,0,255}));
  connect(calTim.day, holFla.day)
    annotation (Line(points={{-15,9},{4,9},{4,6},{14,6}}, color={255,127,0}));
  annotation (defaultComponentName="occ",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{-46,32},{-14,16}},
          color={238,46,47}),
        Ellipse(extent={{-62,70},{-30,40}}, lineColor={238,46,47}),
        Line(
          points={{-74,18},{-46,32}},
          color={238,46,47}),
        Line(
          points={{-46,-24},{-46,40}},
          color={238,46,47}),
        Line(
          points={{-70,-72},{-46,-24},{-22,-74}},
          color={238,46,47}),
        Line(points={{-100,-78},{100,-78}}, color={238,46,47}),
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={238,46,47}),
                                        Text(
        extent={{-154,144},{146,104}},
        textString="%name",
        lineColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=31536000, __Dymola_Algorithm="Cvode"),
    Documentation(info="<html>
<p>This model outputs: </p>
<p>a) if the building is occupied at the current simulation time</p>
<p>b) how long it will take until the next occupied time</p>
<p>c) if the current day is an unoccupied day.This will be used as a flag to determine internal heat gain fraction.</p>
<p>On normal work days, the building is occupied at specific time periods which is defined in OccSch inside of this model. The building is unoccupied on weekends, federal holidays, and at undefined time on normal working days.</p>
<p>i.e., The building is occupied 0700 - 1900 M-F (except for holidays), then:</p>
<p>a) <span style=\"background-color: #d0d0d0;\">occupied</span> </p>
<p>true: 0700 - 1900 M-F</p>
<p>false: 0000 - 0700 and 1900 - 2400 M-F, all day Sat, Sun, and holidays</p>
<p>b)<span style=\"background-color: #d0d0d0;\"> tNexOcc</span></p>
<p><span style=\"background-color: #ffffff;\">calculate how long it will take until the next occupied time</span></p>
<p><span style=\"background-color: #ffffff;\">c) </span><span style=\"background-color: #cacaca;\">unoDay</span></p>
<p><span style=\"background-color: #ffffff;\">true: Weekends and holidays</span></p>
<p><span style=\"background-color: #ffffff;\">false: M - F (except for holidays)</span></p>
</html>"));
end Occupany;
