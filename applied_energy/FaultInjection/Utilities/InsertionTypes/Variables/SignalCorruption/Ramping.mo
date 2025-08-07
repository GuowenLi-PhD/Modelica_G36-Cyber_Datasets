within FaultInjection.Utilities.InsertionTypes.Variables.SignalCorruption;
model Ramping "Ramping attack"

  extends FaultInjection.Utilities.InsertionTypes.Variables.BaseClass.PartialFaultInjectionReal;
  parameter Real k=1 "Gain value multiplied with input signal";

  BaseClass.Limiter limiter(uMax=faultMode.maximum, uMin=faultMode.minimum)
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));

  Modelica.Blocks.Sources.RealExpression ram(y=k*max(0, time - faultMode.startTime))
    "Ramping signal for attack"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Math.Add addTer "Scaling factor"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
equation
  connect(addTer.y, limiter.u)
    annotation (Line(points={{-19,30},{-12,30}}, color={0,0,127}));
  connect(ram.y, addTer.u1) annotation (Line(points={{-59,40},{-52,40},{-52,36},
          {-42,36}},     color={0,0,127}));
  connect(u, addTer.u2) annotation (Line(points={{-120,0},{-52,0},{-52,24},
          {-42,24}}, color={0,0,127}));
  connect(limiter.y, fauPas.u_f_in)
    annotation (Line(points={{11,30},{18,30},{18,8},{38,8}}, color={0,0,127}));
  annotation (defaultComponentName="ramAtt",
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
<p> Ramping attack model corrupts the passing signal <code>u</code> by ramping up or down the signal using predefined ramping factor <code>k</code>. 
This attck assumes that any corruptted value that is out of bounds will be detected by the control communication systm automatically. Ramping starts at 
the beginning of fault injection.
</p>
</html>"));
end Ramping;
