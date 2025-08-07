within FaultInjection.Utilities.Holiday.Examples;
model TimeToNextOccupiedHour "Time to next occupied hour"
  extends Modelica.Icons.Example;

  .FaultInjection.Utilities.Holiday.TimeToNextOccupiedHour tNexOcc
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.CalendarTime calTim(zerTim=
        Buildings.Controls.OBC.CDL.Types.ZeroTime.NY2020)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
equation
  connect(calTim.minute, tNexOcc.min) annotation (Line(points={{-39,19},{-28,19},
          {-28,18},{-22,18}}, color={0,0,127}));
  connect(calTim.hour, tNexOcc.hou) annotation (Line(points={{-39,16},{-30,16},{
          -30,13},{-22,13}}, color={255,127,0}));
  connect(calTim.day, tNexOcc.day) annotation (Line(points={{-39,13},{-32,13},{-32,
          7},{-22,7}}, color={255,127,0}));
  connect(calTim.month, tNexOcc.mon) annotation (Line(points={{-39,10},{-34,10},
          {-34,2},{-22,2}}, color={255,127,0}));
  annotation (
    __Dymola_Commands(file="modelica://FaultInjection/Resources/Scripts/dymola/Utilities/Holiday/Examples/TimeToNextOccupiedHour.mos"
        "Simulate and Plot"), experiment(
      StopTime=2592000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end TimeToNextOccupiedHour;
