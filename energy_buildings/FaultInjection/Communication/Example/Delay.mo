within FaultInjection.Communication.Example;
model Delay "Variable delays"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Sine sine(freqHz=1/60)
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  FaultInjection.Communication.VariableDelay variableDelay(delayMax=30)
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Modelica.Blocks.Sources.Step step(
    height=10,
    offset=10,
    startTime=60)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  FaultInjection.Communication.FixedDelay fixedDelay(delayTime=10)
    annotation (Placement(transformation(extent={{-8,40},{12,60}})));
  FaultInjection.Communication.PadeDelay padeDelay(delayTime=10, balance=true)
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  Sampler sam1(samplePeriod=1)
    annotation (Placement(transformation(extent={{30,40},{50,60}})));
  Sampler sam2(samplePeriod=1)
    annotation (Placement(transformation(extent={{32,-10},{52,10}})));
  Sampler sam3(samplePeriod=1)
    annotation (Placement(transformation(extent={{32,-60},{52,-40}})));
equation
  connect(sine.y, variableDelay.u) annotation (Line(points={{-39,20},{-24,
          20},{-24,0},{-10,0}}, color={0,0,127}));
  connect(step.y, variableDelay.delayTime) annotation (Line(points={{-39,
          -20},{-24,-20},{-24,-6},{-10,-6}}, color={0,0,127}));
  connect(sine.y, fixedDelay.u) annotation (Line(points={{-39,20},{-24,20},
          {-24,50},{-10,50}}, color={0,0,127}));
  connect(sine.y, padeDelay.u) annotation (Line(points={{-39,20},{-26,20},{
          -26,-50},{-12,-50}}, color={0,0,127}));
  connect(fixedDelay.y, sam1.u)
    annotation (Line(points={{13,50},{28,50}}, color={0,0,127}));
  connect(variableDelay.y, sam2.u)
    annotation (Line(points={{13,0},{30,0}}, color={0,0,127}));
  connect(padeDelay.y, sam3.u)
    annotation (Line(points={{11,-50},{30,-50}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=120, __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Communication/Example/Delay.mos"
        "Simulate and Plot"));
end Delay;
