within FaultInjection.PrimarySideControl.ValveControl.Validation;
model BypassChiller "Test chiller bypass control"
  extends Modelica.Icons.Example;
  FaultInjection.PrimarySideControl.ValveControl.BypassChiller bypChi(dpSetDes=
        25000, k=0.01) "Chiller bypass controller"
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
  connect(dpSet.y, bypChi.dpSet) annotation (Line(points={{-39,0},{-26,0},{
          -26,0},{-10,0}}, color={0,0,127}));
  connect(dpMea.y, bypChi.dpMea) annotation (Line(points={{-39,-40},{-20,
          -40},{-20,-6},{-10,-6}}, color={0,0,127}));
  connect(uOpeMod.y, bypChi.uOpeMod) annotation (Line(points={{-39,40},{-20,
          40},{-20,6},{-10,6}}, color={255,127,0}));
  annotation (
    Documentation(info="<html>
<p>This example tests the controller for the chiller bypass control implemented in 
<a href=\"modelica://WSEControlLogics.Controls.LocalControls.ValveControl.BypassChiller\">
WSEControlLogics/Controls/LocalControls/ValveControl/BypassChiller</a>. 
</p>
</html>"),
    __Dymola_Commands(file=
          "modelica://WSEControlLogics/Resources/Scripts/Dymola/Controls/LocalControls/ValveControl/Validation/BypassChiller.mos"
        "Simulate and Plot"));
end BypassChiller;
