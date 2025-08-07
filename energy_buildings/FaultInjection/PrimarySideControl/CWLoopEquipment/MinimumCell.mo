within FaultInjection.PrimarySideControl.CWLoopEquipment;
model MinimumCell "Required minimum tower cell"
  extends Modelica.Blocks.Icons.Block;
  parameter Integer numCooTow "Design number of cooling towers";

  Modelica.Blocks.Interfaces.IntegerInput uOpeMod
    "Cooling mode in WSEControls.Type.OperationaModes" annotation (Placement(
        transformation(extent={{-140,-60},{-100,-20}}),iconTransformation(
          extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.IntegerInput numActPum
    "Number of active pumps in condenser water loop"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Sources.IntegerConstant allOn(k=numCooTow) "All cells are on"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.BooleanExpression FreOrFul(
    y=uOpeMod == Integer(WSEControlLogics.Controls.WSEControls.Type.OperationModes.FreeCooling)
         or
    uOpeMod == Integer(WSEControlLogics.Controls.WSEControls.Type.OperationModes.FullMechanical))
    "Free cooling or full mechanical cooling"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{36,60},{56,80}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    annotation (Placement(transformation(extent={{-60,68},{-40,88}})));
  Modelica.Blocks.Sources.BooleanExpression parMec(
    y=
    uOpeMod == Integer(WSEControlLogics.Controls.WSEControls.Type.OperationModes.PrePartialMechanical)
    or
    uOpeMod == Integer(WSEControlLogics.Controls.WSEControls.Type.OperationModes.PartialMechanical))
    "Partial mechanical cooling"
    annotation (Placement(transformation(extent={{-66,-28},{-46,-8}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    annotation (Placement(transformation(extent={{-10,-28},{10,-8}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea2
    annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(k=0) "Zero"
    annotation (Placement(transformation(extent={{-50,-60},{-30,-40}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y
    "Minimum number of active cooling tower cells"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(numActPum, intToRea1.u) annotation (Line(points={{-120,40},{-90,40},{
          -90,78},{-62,78}},
                         color={255,127,0}));
  connect(intToRea1.y,swi1. u1)
    annotation (Line(points={{-39,78},{34,78}}, color={0,0,127}));
  connect(FreOrFul.y,swi1. u2) annotation (Line(points={{-39,50},{-20,50},{-20,
          70},{34,70}},
                    color={255,0,255}));
  connect(parMec.y,swi2. u2)
    annotation (Line(points={{-45,-18},{-12,-18}}, color={255,0,255}));
  connect(allOn.y, intToRea2.u)
    annotation (Line(points={{-59,10},{-52,10}}, color={255,127,0}));
  connect(intToRea2.y,swi2. u1) annotation (Line(points={{-29,10},{-20,10},{-20,
          -10},{-12,-10}}, color={0,0,127}));
  connect(zer.y,swi2. u3) annotation (Line(points={{-29,-50},{-20,-50},{-20,-26},
          {-12,-26}}, color={0,0,127}));
  connect(swi2.y,swi1. u3) annotation (Line(points={{11,-18},{28,-18},{28,62},{
          34,62}},
                color={0,0,127}));
  connect(swi1.y, reaToInt.u)
    annotation (Line(points={{57,70},{60,70},{60,0},{68,0}}, color={0,0,127}));
  connect(reaToInt.y, y)
    annotation (Line(points={{91,0},{110,0}}, color={255,127,0}));
  annotation (defaultComponentName = "minCel",
    Documentation(info="<html>
<p>
The required minimum tower cell during different operation modes should be reset based on the following logic. Here assume the number of condenser pumps <code>numConPum</code> and 
that of the cooling towers <code>numCooTow</code> are equal. 
</p>
<ul>
<li>
When in unoccupied mode, the minimum number is 0.
</li>
<li>
When in free cooling mode, the minimum number of active cooling towers should be equal to the number of active condenser water pumps.
</li>
<li>
When in pre-partial and partial mechanical cooling mode, the minimum number of active cooling towers should be equal to <code>numCooTow</code>, which means all the cooling towers should 
be commanded on.
</li>
<li>
When in full mechanical cooling mode, the minimum number of active cooling towers should be equal to the number of active condenser water pumps.
</li>
</ul>
</html>"));
end MinimumCell;
