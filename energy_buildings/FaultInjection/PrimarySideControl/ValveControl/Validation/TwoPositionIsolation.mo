within FaultInjection.PrimarySideControl.ValveControl.Validation;
model TwoPositionIsolation
  "Test the two position isolation valve control"
  extends Modelica.Icons.Example;
  FaultInjection.PrimarySideControl.ValveControl.TwoPositionIsolation twoPosIso
    "Two position (on/off) isolation valve"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.BooleanPulse ope(startTime=100, period=1000)
    "Open signal"
    annotation (Placement(transformation(extent={{-48,-10},{-28,10}})));
equation
  connect(ope.y, twoPosIso.ope)
    annotation (Line(points={{-27,0},{-12,0}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This example tests the controller for the two position isolation valve control implemented in 
<a href=\"modelica://WSEControlLogics.Controls.LocalControls.ValveControl.TwoPositionIsolation\">
WSEControlLogics/Controls/LocalControls/ValveControl/TwoPositionIsolation</a>. 
</p>
</html>"),
    __Dymola_Commands(file=
          "modelica://WSEControlLogics/Resources/Scripts/Dymola/Controls/LocalControls/ValveControl/Validation/TwoPositionIsolation.mos"
        "Simulate and Plot"));
end TwoPositionIsolation;
