within FaultInjection.Experimental.SystemLevelFaults.Controls.Validation;
model PlantRequest
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Sine uPlaReq(
    amplitude=0.5,
    freqHz=1/2000,
    offset=0.5,
    startTime(displayUnit="min") = 300)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  FaultInjection.Experimental.SystemLevelFaults.Controls.PlantRequest plaReq
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
equation
  connect(uPlaReq.y, plaReq.uPlaVal)
    annotation (Line(points={{-39,0},{-9,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=21600, __Dymola_Algorithm="Cvode"));
end PlantRequest;
