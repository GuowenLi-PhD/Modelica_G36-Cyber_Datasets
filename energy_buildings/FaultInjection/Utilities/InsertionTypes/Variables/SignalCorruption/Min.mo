within FaultInjection.Utilities.InsertionTypes.Variables.SignalCorruption;
model Min "Minimum attack"

  extends FaultInjection.Utilities.InsertionTypes.Variables.BaseClass.PartialFaultInjectionReal;

  Modelica.Blocks.Sources.RealExpression lowBou(y=faultMode.minimum)
    "Minimum signal for attack"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
equation
  connect(lowBou.y, fauPas.u_f_in) annotation (Line(points={{-59,40},{16,40},{
          16,8},{38,8}}, color={0,0,127}));
  annotation (defaultComponentName="minAtt",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p> Min attack model corrupts the passing signal <code>u</code> by resetting it to its minimum allowable value. 
This attck assumes that any corruptted value that is lower than the minimum will be detected by the control communication systm automatically.
</p>
</html>",
      revisions="<html>
<ul>
<li>
August 20, 2020, by Yangyang Fu:<br/>
First implementation
</li>
</ul>
</html>"));
end Min;
