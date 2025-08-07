within FaultInjection.Utilities.InsertionTypes.Variables.SignalBlock;
model Blocking "Blocking attack"

  extends FaultInjection.Utilities.InsertionTypes.Variables.BaseClass.PartialFaultInjectionReal;
  parameter Real y_start=0.0
    "Value of output y before the first tick of the clock associated to input u";

  BaseClass.FaultPassReal fauPas(use_u_f_in=true)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Modelica_Synchronous.ClockSignals.Clocks.EventClock triClo "Trigger clock"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica_Synchronous.RealSignals.Sampler.SampleClocked sam "Clocked sampler"
    annotation (Placement(transformation(extent={{-58,10},{-38,30}})));
  Modelica_Synchronous.RealSignals.Sampler.Hold hol(y_start=y_start)
    "Hold the first sample"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));

  BaseClass.Limiter limiter(uMax=faultMode.maximum, uMin=faultMode.minimum)
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
equation
  connect(u, fauPas.u)
    annotation (Line(points={{-120,0},{38,0}}, color={0,0,127}));
  connect(fauPas.y, y)
    annotation (Line(points={{61,0},{110,0}}, color={0,0,127}));
  connect(triClo.y, sam.clock) annotation (Line(
      points={{-59,-30},{-48,-30},{-48,8}},
      color={175,175,175},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(u, sam.u) annotation (Line(points={{-120,0},{-94,0},{-94,20},{-60,20}},
        color={0,0,127}));
  connect(sam.y, hol.u)
    annotation (Line(points={{-37,20},{-22,20}}, color={0,0,127}));
  connect(hol.y, limiter.u) annotation (Line(points={{1,20},{16,20},{16,-2},{
          -16,-2},{-16,-20},{-2,-20}},
                                 color={0,0,127}));
  connect(limiter.y, fauPas.u_f_in)
    annotation (Line(points={{21,-20},{30,-20},{30,8},{38,8}},
                                                             color={0,0,127}));
  connect(and1.y, triClo.u) annotation (Line(points={{-19,70},{-10,70},{-10,48},
          {-90,48},{-90,-30},{-82,-30}}, color={255,0,255}));
  annotation (defaultComponentName = "sigBlo",
    Documentation(revisions="<html>
<ul>
<li>
August 20, 2020, by Yangyang Fu:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p> Blocking attack blocks the transmission of communication signal. In the model, we assume that when the signal <code>u</code> is blocked, the signal from previous time step <code>pre(u)</code> is being used. 
</p>
</html>"));
end Blocking;
