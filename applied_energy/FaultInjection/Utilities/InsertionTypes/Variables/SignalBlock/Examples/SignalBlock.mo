within FaultInjection.Utilities.InsertionTypes.Variables.SignalBlock.Examples;
model SignalBlock "Test SignalBlock"
  extends Modelica.Icons.Example;

  Blocking sigBlo(faultMode=faultMode)
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Modelica.Blocks.Sources.Sine sin(freqHz=1/3600)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  parameter Generic.faultMode faultMode(
    active=true,
    startTime=1800,
    endTime=2700,
    minimum=-1,
    maximum=1)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(sin.y, sigBlo.u)
    annotation (Line(points={{-39,0},{8,0}}, color={0,0,127}));
  annotation (
    experiment(StopTime=3600, __Dymola_Algorithm="Dassl"));
end SignalBlock;
