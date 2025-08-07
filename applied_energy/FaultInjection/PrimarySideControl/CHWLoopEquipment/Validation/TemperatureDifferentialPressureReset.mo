within FaultInjection.PrimarySideControl.CHWLoopEquipment.Validation;
model TemperatureDifferentialPressureReset
  "Test the CHWST and CHW DP reset control"
  extends Modelica.Icons.Example;
  FaultInjection.PrimarySideControl.CHWLoopEquipment.TemperatureDifferentialPressureReset
    temDifPreRes[3] "CHWST and DP setpoint reset controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Pulse dTAirSup1(period=500)
    "Supply air temperature signal 1"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.Sine dTAirSup2(freqHz=0.001, offset=0.3)
    "Supply air temperature signal 2"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.Sine dTAirSup3(freqHz=0.002, offset=0.2)
    "Supply air temperature signal 3"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Modelica.Blocks.Sources.IntegerTable uOpeMod(table=[0,1; 720,2; 1440,3; 2160,
        4; 2880,5])
    "Operation mode"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
equation
  connect(dTAirSup1.y, temDifPreRes[1].dTAirSup) annotation (Line(points={{-39,
          50},{-30,50},{-30,0},{-12,0}}, color={0,0,127}));
  connect(dTAirSup2.y, temDifPreRes[2].dTAirSup)
    annotation (Line(points={{-39,0},{-12,0}}, color={0,0,127}));
  connect(dTAirSup3.y, temDifPreRes[3].dTAirSup) annotation (Line(points={{-39,
          -50},{-30,-50},{-30,0},{-12,0}}, color={0,0,127}));
  connect(uOpeMod.y, temDifPreRes[1].uOpeMod) annotation (Line(points={{-39,90},
          {-20,90},{-20,6},{-12,6}}, color={255,127,0}));
  connect(uOpeMod.y, temDifPreRes[2].uOpeMod) annotation (Line(points={{-39,90},
          {-20,90},{-20,6},{-12,6}}, color={255,127,0}));
  connect(uOpeMod.y, temDifPreRes[3].uOpeMod) annotation (Line(points={{-39,90},
          {-20,90},{-20,6},{-12,6}}, color={255,127,0}));
  annotation (
    Documentation(info="<html>
<p>This example tests the controller for the chiller CHWST and CHW DP reset control implemented in
<a href=\"modelica://WSEControlLogics.Controls.LocalControls.CHWLoop.TemperatureDifferentialPressureReset\">
WSEControlLogics/Controls/LocalControls/CHWLoop/TemperatureDifferentialPressureReset</a>. 
</p>
</html>"),
    __Dymola_Commands(file="modelica://WSEControlLogics/Resources/Scripts/Dymola/Controls/LocalControls/CHWLoopEquipment/Validation/TemperatureDifferentialPressureReset.mos"
        "Simulate and Plot"));
end TemperatureDifferentialPressureReset;
