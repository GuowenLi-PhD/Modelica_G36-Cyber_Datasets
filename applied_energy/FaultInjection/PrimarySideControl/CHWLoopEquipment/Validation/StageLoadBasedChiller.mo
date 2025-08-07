within FaultInjection.PrimarySideControl.CHWLoopEquipment.Validation;
model StageLoadBasedChiller "Test the load-based chiller stage control"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Sine cooLoa(
    amplitude=0.45*chiStaLoa.QEva_nominal,
    offset=0.5*chiStaLoa.QEva_nominal,
    freqHz=1/3000,
    startTime=500)                     "Cooling load input"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  FaultInjection.PrimarySideControl.CHWLoopEquipment.StageLoadBasedChiller chiStaLoa(
      QEva_nominal=-1055000) "Chiller stage controller based on load"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.IntegerTable uOpeMod(table=[0,1; 720,2; 1440,3; 2160,
        4; 2880,5])
    "Operation mode"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
equation
  connect(cooLoa.y, chiStaLoa.QTot) annotation (Line(points={{-39,-40},{-20,-40},
          {-20,-4},{-12,-4}}, color={0,0,127}));
  connect(uOpeMod.y, chiStaLoa.uOpeMod) annotation (Line(points={{-39,40},{-20,
          40},{-20,4},{-12,4}}, color={255,127,0}));
  annotation (    __Dymola_Commands(file=
          "modelica://WSEControlLogics/Resources/Scripts/Dymola/Controls/LocalControls/CHWLoopEquipment/Validation/StageLoadBasedChiller.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>This example test the chiller staging controller implemented in 
<a href=\"modelica://WSEControlLogics.Controls.LocalControls.CHWLoopEquipment.StageLoadBasedChiller\">
WSEControlLogics/Controls/LocalControls/CHWLoopEquipment/StageLoadBasedChiller</a>. 
</p>
</html>", revisions="<html>
<ul>
<li>June 14, 2018, by Xing Lu:<br>First implementation. </li>
</ul>
</html>"),
experiment(
      StartTime=0,
      StopTime=1440,
      Tolerance=1e-06));
end StageLoadBasedChiller;
