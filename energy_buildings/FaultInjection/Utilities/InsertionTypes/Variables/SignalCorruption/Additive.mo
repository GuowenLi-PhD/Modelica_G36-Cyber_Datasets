within FaultInjection.Utilities.InsertionTypes.Variables.SignalCorruption;
model Additive "Additive attack"

  extends FaultInjection.Utilities.InsertionTypes.Variables.BaseClass.PartialFaultInjectionReal;

  parameter Boolean use_uFau_in = false "Get the faulty signal from the input connector"
    annotation(Evaluate=true, HideResult=true, Dialog(group="Conditional inputs"));
  parameter Real k=1 "Additive value added with input signal"
    annotation(Dialog(enable = not use_uFau_in,group="Fixed inputs"));

  BaseClass.Limiter limiter(uMax=faultMode.maximum, uMin=faultMode.minimum)
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Modelica.Blocks.Math.Add addTer "Scaling factor"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));

  Interfaces.RealInput uFau_in if use_uFau_in "Connector of Real input signal" annotation (
      Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

protected
    Modelica.Blocks.Interfaces.RealInput uFau_in_internal
    "Needed to connect to conditional connector";

equation
   connect(uFau_in_internal,addTer.u1);
   connect(uFau_in, uFau_in_internal);
   if not use_uFau_in then
     uFau_in_internal = k;
   end if;

  connect(addTer.y, limiter.u)
    annotation (Line(points={{-29,30},{-12,30}}, color={0,0,127}));
  connect(u, addTer.u2) annotation (Line(points={{-120,0},{-80,0},{-80,24},{-52,
          24}}, color={0,0,127}));
  connect(limiter.y, fauPas.u_f_in)
    annotation (Line(points={{11,30},{18,30},{18,8},{38,8}}, color={0,0,127}));
  annotation (defaultComponentName="addAtt",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
October 12, 2020, by Yangyang Fu:<br/>
Added conditional external faulty signal input connector.
</li>
<li>
August 20, 2020, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p> Additive attack model corrupts the passing signal <code>u</code> by adding an additional term. 
This attck assumes that any corruptted value that is out of bounds will be detected by the control communication systm automatically.
</p>
</html>"));
end Additive;
