within FaultInjection.Utilities.InsertionTypes.Variables.SignalCorruption;
model Random "Random attack"

  extends FaultInjection.Utilities.InsertionTypes.Variables.BaseClass.PartialFaultInjectionReal;
  parameter Modelica.SIunits.Period samplePeriod
    "Period for sampling the raw random numbers";
  parameter Real mu=0 "Expectation (mean) value of the normal distribution";
  parameter Real sigma "Standard deviation of the normal distribution";

  BaseClass.Limiter limiter(uMax=faultMode.maximum, uMin=faultMode.minimum)
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));

  Modelica.Blocks.Math.Add addTer "Scaling factor"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  FaultEvolution.NormalNoise norDis(
    samplePeriod=samplePeriod,
    mu=mu,
    sigma=sigma) "Normal distribution"
    annotation (Placement(transformation(extent={{-80,26},{-60,46}})));

  inner Modelica.Blocks.Noise.GlobalSeed globalSeed
    annotation (Placement(transformation(extent={{-78,-82},{-58,-62}})));
equation
  connect(addTer.y, limiter.u)
    annotation (Line(points={{-19,30},{-12,30}}, color={0,0,127}));
  connect(u, addTer.u2) annotation (Line(points={{-120,0},{-52,0},{-52,24},{-42,
          24}}, color={0,0,127}));
  connect(norDis.y, addTer.u1) annotation (Line(points={{-59,36},{-42,36}},
                         color={0,0,127}));
  connect(limiter.y, fauPas.u_f_in)
    annotation (Line(points={{11,30},{18,30},{18,8},{38,8}}, color={0,0,127}));
  annotation (defaultComponentName="ranAtt",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
August 20, 2020, by Yangyang Fu:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p> Random attack model corrupts the passing signal <code>u</code> by adding a random number. 
This attck assumes that any corruptted value that is out of bounds will be detected by the control communication systm automatically. 
</p>
</html>"));
end Random;
