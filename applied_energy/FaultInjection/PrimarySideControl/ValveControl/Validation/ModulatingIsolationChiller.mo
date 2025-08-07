within FaultInjection.PrimarySideControl.ValveControl.Validation;
model ModulatingIsolationChiller
  "Test chiller isolation valve control"
  import WSEControlLogics;
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.IntegerTable uOpeMod(table=[0,1; 360,2; 720,3;
        1080,4; 1440,5]) "Operation mode"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  WSEControlLogics.Controls.LocalControls.ValveControl.ModulatingIsolationChiller
    modIsoChi(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=60,
    k=0.03)
    "Chiller isolation valve controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant u_s(k=12)
    "Differential temperature setpoint between condenser leaving water temperature and the evaporator leaving water temperature"
    annotation (Placement(transformation(extent={{-60,-16},{-40,4}})));
  Modelica.Blocks.Sources.Sine u_m(
    offset=12,
    amplitude=3,
    freqHz=1/900)
    "Differential temperature measurement between condenser leaving water temperature and the evaporator leaving water temperature"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
equation
  connect(uOpeMod.y, modIsoChi.uOpeMod) annotation (Line(points={{-39,40},{-20,
          40},{-20,7},{-12,7}},     color={255,127,0}));
  connect(u_s.y, modIsoChi.u_s) annotation (Line(points={{-39,-6},{-26,-6},
          {-26,-6},{-12,-6}}, color={0,0,127}));
  connect(u_m.y, modIsoChi.u_m)
    annotation (Line(points={{-39,-50},{0,-50},{0,-12}}, color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>This example tests the controller for the chiller isolation valve control implemented in 
<a href=\"modelica://WSEControlLogics.Controls.LocalControls.ValveControl.ModulatingIsolationChiller\">
WSEControlLogics/Controls/LocalControls/ValveControl/ModulatingIsolationChiller</a>. 
</p>
</html>"),
    __Dymola_Commands(file=
    "modelica://WSEControlLogics/Resources/Scripts/Dymola/Controls/LocalControls/ValveControl/Validation/ModulatingIsolationChiller.mos"
        "Simulate and Plot"));
end ModulatingIsolationChiller;
