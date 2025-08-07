within FaultInjection.Utilities.InsertionTypes.Variables.SignalDelay.Examples;
model TriggerDelay "Signal delay for real signal"
  extends Modelica.Icons.Example;

  parameter Generic.faultMode faultMode(
    active=true,
    startTime=1200,
    endTime=2400)
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=5,
    freqHz=1/1800,
    offset=10)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  FaultInjection.Utilities.InsertionTypes.Variables.SignalDelay.RealFixedDelay
    triFixDel(delayTime=300, faultMode=faultMode) "Trigger fixed delay"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  RealVariableDelay triVarDel(delayMax=900, faultMode=faultMode)
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  Modelica.Blocks.Sources.Step step(
    height=300,
    offset=300,
    startTime=1800)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
equation
  connect(sine.y, triFixDel.u)
    annotation (Line(points={{-59,0},{-34,0},{-34,50},{-12,50}},
                                               color={0,0,127}));
  connect(step.y, triVarDel.delayTime) annotation (Line(points={{-59,-50},{-36,-50},{-36,-44},{-12,-44}}, color={0,0,127}));
  connect(sine.y, triVarDel.u) annotation (Line(points={{-59,0},{-34,0},{-34,-50},
          {-12,-50}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This example demonstrates the use of fixed delay and variable delays for a passing signal.
</p>
</html>"),
    experiment(StopTime=3600, __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file="Resources/Scripts/dymola/Utilities/InsertionTypes/Variables/SignalDelay/Examples/TriggerDelay.mos"
        "Simulate and Plot"));
end TriggerDelay;
