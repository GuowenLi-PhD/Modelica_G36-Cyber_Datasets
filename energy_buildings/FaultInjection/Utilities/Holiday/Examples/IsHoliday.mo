within FaultInjection.Utilities.Holiday.Examples;
model IsHoliday "Test is holiday"
  extends Modelica.Icons.Example;

  FaultInjection.Utilities.Holiday.IsHoliday isHol
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.CalendarTime calTim(zerTim=
        Buildings.Controls.OBC.CDL.Types.ZeroTime.NY2020)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
equation
  connect(calTim.hour, isHol.hou)
    annotation (Line(points={{-39,16},{-22,16}}, color={255,127,0}));
  connect(calTim.day, isHol.day) annotation (Line(points={{-39,13},{-28,13},{-28,
          10},{-22,10}}, color={255,127,0}));
  connect(calTim.month, isHol.mon) annotation (Line(points={{-39,10},{-30,10},{-30,
          4},{-22,4}}, color={255,127,0}));
  annotation (
    experiment(
      StopTime=2678400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file="modelica://FaultInjection/Resources/Scripts/dymola/Utilities/Holiday/Examples/IsHoliday.mos"
        "Simulate and Plot"));
end IsHoliday;
