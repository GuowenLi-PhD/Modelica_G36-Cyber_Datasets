within FaultInjection.Communication.Validation;
model testSampler "Test samplers in two different libraries"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Sine sine(freqHz=1/60)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica_Synchronous.RealSignals.Sampler.SampleClocked sam2
    annotation (Placement(transformation(extent={{2,-20},{22,0}})));
  Modelica_Synchronous.ClockSignals.Clocks.PeriodicExactClock periodicClock(factor=1,
      resolution=Modelica_Synchronous.Types.Resolution.s)
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Modelica.Blocks.Discrete.Sampler sam1(samplePeriod=1)
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica_Synchronous.RealSignals.Sampler.Hold hol
    annotation (Placement(transformation(extent={{38,-20},{58,0}})));
equation
  connect(periodicClock.y, sam2.clock) annotation (Line(
      points={{-19,-40},{12,-40},{12,-22}},
      color={175,175,175},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(sine.y, sam2.u) annotation (Line(points={{-39,30},{-20,30},{-20,-10},
          {0,-10}},
                 color={0,0,127}));
  connect(sine.y, sam1.u)
    annotation (Line(points={{-39,30},{-2,30}},
                                              color={0,0,127}));
  connect(sam2.y, hol.u)
    annotation (Line(points={{23,-10},{36,-10}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-8,60},{36,44}},
          lineColor={28,108,200},
          textString="Ideal Sampler"),
        Rectangle(extent={{-58,4},{76,-60}}, lineColor={28,108,200}),
        Text(
          extent={{-12,-22},{76,-82}},
          lineColor={28,108,200},
          textString="Modelica_Synchronous Sampler")}),
    experiment(StopTime=60, __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Communication/Validation/testSampler.mos"
        "Simulate and Plot"));
end testSampler;
