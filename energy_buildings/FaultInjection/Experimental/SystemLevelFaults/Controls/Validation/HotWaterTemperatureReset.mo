within FaultInjection.Experimental.SystemLevelFaults.Controls.Validation;
model HotWaterTemperatureReset
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Sine yVal(
    amplitude=0.3,
    freqHz=1/8000,
    offset=0.7,
    startTime(displayUnit="min") = 0)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  FaultInjection.Experimental.SystemLevelFaults.Controls.HotWaterTemperatureReset
    hotWatTemRes(resAmo=2)
    annotation (Placement(transformation(extent={{-10,-8},{10,12}})));
  Modelica.Blocks.Sources.BooleanPulse yPla(
    width=80,
    period(displayUnit="min") = 12000,
    startTime(displayUnit="min") = 600)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
equation
  connect(yPla.y, hotWatTemRes.uDevSta) annotation (Line(points={{-39,30},{-26,
          30},{-26,9.4},{-12,9.4}}, color={255,0,255}));
  connect(yVal.y, hotWatTemRes.uPlaHeaVal) annotation (Line(points={{-39,-20},{
          -26,-20},{-26,2},{-12,2}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=21600, __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file="\"\"" "Simulate and Plot"));
end HotWaterTemperatureReset;
