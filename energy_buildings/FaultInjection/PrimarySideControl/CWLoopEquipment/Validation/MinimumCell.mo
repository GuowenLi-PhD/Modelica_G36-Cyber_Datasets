within FaultInjection.PrimarySideControl.CWLoopEquipment.Validation;
model MinimumCell "Test the minimum cell number reset control"

  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.IntegerTable numActPum(table=[0,0; 360,2; 720,1; 1080,
        2; 1440,1]) "Number of active condenser pumps"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  FaultInjection.PrimarySideControl.CWLoopEquipment.MinimumCell minCel(numCooTow=
       2) "Minimum cell number reset controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.IntegerTable uOpeMod(table=[0,1; 360,2; 720,3; 1080,4;
        1440,5]) "Operation mode"
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
equation
  connect(numActPum.y, minCel.numActPum) annotation (Line(points={{-29,30},{-20,
          30},{-20,4},{-12,4}}, color={255,127,0}));
  connect(uOpeMod.y, minCel.uOpeMod) annotation (Line(points={{-29,-30},{-20,
          -30},{-20,-4},{-12,-4}}, color={255,127,0}));
  annotation (
    Documentation(info="<html>
<p>This example tests the controller for the minimum cell number reset implemented in <a href=\"modelica://WSEControlLogics.Controls.LocalControls.CWLoopEquipment.MinimumCell\">WSEControlLogics/Controls/LocalControls/CWLoopEquipment/MinimumCell</a>. </p>
</html>"),
    __Dymola_Commands(file=
          "modelica://WSEControlLogics/Resources/Scripts/Dymola/Controls/LocalControls/CWLoopEquipment/Validation/MinimumCell.mos"
        "Simulate and Plot"));
end MinimumCell;
