within FaultInjection.PrimarySideControl.CWLoopEquipment.Validation;
model SupplyTemperatureReset "Test the cooling tower supply temperature reset"

  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.IntegerTable uOpeMod(table=[0,1; 360,2; 720,3; 1080,4;
        1440,5]) "Operation mode"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  FaultInjection.PrimarySideControl.CWLoopEquipment.SupplyTemperatureReset temRes(
      TSetParMec=273.15 + 6)
    "Controller for the cooling tower supply temperature setpoint reset"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Sine TWetBul(
    amplitude=4,
    offset=273.15 + 8,
    freqHz=1/720) "Outdoor air wet bulb emperature"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Modelica.Blocks.Sources.Constant TAppCooTow(k=7)
    "Approach temperature in cooling towers"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
equation
  connect(uOpeMod.y, temRes.uOpeMod) annotation (Line(points={{-29,-40},{-20,
          -40},{-20,-4},{-12,-4}},
                            color={255,127,0}));
  connect(TWetBul.y, temRes.TWetBul) annotation (Line(points={{-29,40},{-20,40},
          {-20,4},{-12,4}},color={0,0,127}));
  connect(TAppCooTow.y, temRes.TAppCooTow) annotation (Line(points={{-29,0},{
          -12,0}},                     color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This example tests the controller for the cooling tower supply temperature reset implemented in <a href=\"modelica://WSEControlLogics.Controls.LocalControls.CWLoopEquipment.SupplyTemperatureReset\">WSEControlLogics/Controls/LocalControls/CWLoopEquipment/SupplyTemperatureReset</a>. </p>
</html>"),
    __Dymola_Commands(file=
          "modelica://WSEControlLogics/Resources/Scripts/Dymola/Controls/LocalControls/CWLoopEquipment/Validation/SupplyTemperatureReset.mos"
        "Simulate and Plot"));
end SupplyTemperatureReset;
