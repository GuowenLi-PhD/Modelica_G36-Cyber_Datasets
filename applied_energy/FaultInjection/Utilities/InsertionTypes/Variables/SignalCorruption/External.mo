within FaultInjection.Utilities.InsertionTypes.Variables.SignalCorruption;
model External "External faulty signal specified by users"

  extends
    FaultInjection.Utilities.InsertionTypes.Variables.BaseClass.PartialFaultInjectionReal;

  BaseClass.Limiter limiter(uMax=faultMode.maximum, uMin=faultMode.minimum)
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));

  Interfaces.RealInput uFau "Connector of Real input signal" annotation (
      Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
equation
  connect(limiter.y, fauPas.u_f_in)
    annotation (Line(points={{11,30},{18,30},{18,8},{38,8}}, color={0,0,127}));
  connect(uFau, limiter.u) annotation (Line(points={{-120,60},{-86,60},{-86,30},
          {-12,30}}, color={235,0,0}));
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
end External;
