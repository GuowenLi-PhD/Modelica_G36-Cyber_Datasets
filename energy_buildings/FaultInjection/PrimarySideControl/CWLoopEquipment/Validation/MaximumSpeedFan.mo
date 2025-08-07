within FaultInjection.PrimarySideControl.CWLoopEquipment.Validation;
model MaximumSpeedFan "Test the maximum fan speed reset control"

  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.IntegerTable numActPum(table=[0,0; 360,2; 720,1; 1080,
        2; 1440,1]) "Number of active condenser pumps"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  FaultInjection.PrimarySideControl.CWLoopEquipment.MaximumSpeedFan maxSpeFan(numPum=2)
    "Maximum fan speed reset controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.IntegerTable uOpeMod(table=[0,1; 360,2; 720,3; 1080,4;
        1440,5]) "Operation mode"
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
equation
  connect(numActPum.y, maxSpeFan.numActPum) annotation (Line(points={{-29,30},{
          -20,30},{-20,4},{-12,4}}, color={255,127,0}));
  connect(uOpeMod.y, maxSpeFan.uOpeMod) annotation (Line(points={{-29,-30},{-20,
          -30},{-20,-4},{-12,-4}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This example tests the controller for the maximum fan speed reset implemented in <a href=\"modelica://WSEControlLogics.Controls.LocalControls.CWLoopEquipment.MaximumSpeedFan\">WSEControlLogics/Controls/LocalControls/CWLoopEquipment/MaximumSpeedFan</a>. </p>
</html>"),
    __Dymola_Commands(file=
          "modelica://WSEControlLogics/Resources/Scripts/Dymola/Controls/LocalControls/CWLoopEquipment/Validation/MaximumSpeedFan.mos"
        "Simulate and Plot"));
end MaximumSpeedFan;
