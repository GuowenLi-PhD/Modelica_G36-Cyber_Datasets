within FaultInjection.PrimarySideControl.ValveControl.Validation;
model BypassEconomizer "Test WSE bypass control"

  extends Modelica.Icons.Example;
  FaultInjection.PrimarySideControl.ValveControl.BypassEconomizer bypEco(dpSetDes=
        25000, k=0.01) "WSE bypass controller"
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Modelica.Blocks.Sources.Constant dpSet(k=25000)
    "Differential pressure setpoint"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.Sine dpMea(
    offset=25000,
    freqHz=1/720,
    amplitude=1000) "Differential pressure measurement"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Modelica.Blocks.Sources.IntegerTable uOpeMod(table=[0,1; 360,2; 720,3;
        1080,4; 1440,5]) "Operation mode"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
equation
  connect(dpSet.y, bypEco.dpSet) annotation (Line(points={{-39,0},{-26,0},{
          -26,0},{-10,0}}, color={0,0,127}));
  connect(dpMea.y, bypEco.dpMea) annotation (Line(points={{-39,-40},{-20,
          -40},{-20,-6},{-10,-6}}, color={0,0,127}));
  connect(uOpeMod.y, bypEco.uOpeMod) annotation (Line(points={{-39,40},{-20,
          40},{-20,6},{-10,6}}, color={255,127,0}));
  annotation (
    Documentation(info="<html>
<p>This example tests the controller for the economizer bypass control implemented in 
<a href=\"modelica://WSEControlLogics.Controls.LocalControls.ValveControl.BypassEconomizer\">
WSEControlLogics/Controls/LocalControls/ValveControl/BypassEconomizer</a>. 
</p>
</html>"),
    __Dymola_Commands(file=
          "modelica://WSEControlLogics/Resources/Scripts/Dymola/Controls/LocalControls/ValveControl/Validation/BypassEconomizer.mos"
        "Simulate and Plot"));
end BypassEconomizer;
