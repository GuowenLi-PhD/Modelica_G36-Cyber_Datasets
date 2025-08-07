within FaultInjection.Utilities.InsertionTypes.Variables.SignalCorruption;
model Max "Maximum attack"

extends FaultInjection.Utilities.InsertionTypes.Variables.BaseClass.PartialFaultInjectionReal;

  Modelica.Blocks.Sources.RealExpression upBou(y=faultMode.maximum)
    "Maximum signal for attack"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
equation
  connect(upBou.y, fauPas.u_f_in) annotation (Line(points={{-59,40},{16,40},{16,
          8},{38,8}}, color={0,0,127}));
  annotation (defaultComponentName="maxAtt",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
August 20, 2020, by Yangyang Fu:<br/>
First implementation
</li>
</ul>
</html>",
      info="<html>
<p> Max attack model corrupts the passing signal <code>u</code> by resetting it to its maximum allowable value. 
This attck assumes that any corruptted value that is lower than the maximum will be detected by the control communication systm automatically.
</p>
</html>"));
end Max;
