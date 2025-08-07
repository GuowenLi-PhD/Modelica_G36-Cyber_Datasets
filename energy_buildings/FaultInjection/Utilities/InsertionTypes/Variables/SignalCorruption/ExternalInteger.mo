within FaultInjection.Utilities.InsertionTypes.Variables.SignalCorruption;
model ExternalInteger
  "External integer faulty signal specified by users"

  extends
    FaultInjection.Utilities.InsertionTypes.Variables.BaseClass.PartialFaultInjectionInteger;

  FaultInjection.Utilities.InsertionTypes.Interfaces.IntegerInput uFau "Connector of Real input signal" annotation (
      Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
equation
  connect(uFau, fauPas.u_f_in) annotation (Line(points={{-120,60},{-86,60},{-86,
          8},{38,8}}, color={238,46,47}));
  annotation (defaultComponentName="extAtt",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
October 12, 2020, by Yangyang Fu:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p> External attack model corrupts the passing signal <code>u</code> by using an external user-defined signal. 
This attck assumes that any external value that is out of bounds will be detected by the control communication systm automatically. 
</p>
</html>"));
end ExternalInteger;
