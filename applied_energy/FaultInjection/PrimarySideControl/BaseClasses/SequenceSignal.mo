within FaultInjection.PrimarySideControl.BaseClasses;
model SequenceSignal "Signal for each cell"
  extends Modelica.Blocks.Icons.Block;
  parameter Integer n(min=1) "Length of the signal";

  Modelica.Blocks.Interfaces.RealOutput y[n]
    "On/off signals for each equipment (1: on, 0: off)"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Interfaces.IntegerInput u
    "Number of active tower cells" annotation (Placement(transformation(extent={{-140,
            -20},{-100,20}}),      iconTransformation(extent={{-140,-20},{-100,20}})));

algorithm
  y := fill(0,n);
  for i in 1:u loop
    y[i] := 1;
  end for;

  annotation (defaultComponentName = "seqSig",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Simple model that is used to determine the on and off sequence of equipment. This model can be replaced by rotation control models.
The logic in this model is explained as follows:
</p>
<ul>
<li>
Among <code>n</code> equipment, the first <code>u</code> equipment are switched on, and the rest <code>n-u</code> are switched off.
</li>
</ul>
</html>"));
end SequenceSignal;
