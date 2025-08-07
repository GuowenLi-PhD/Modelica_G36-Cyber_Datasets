within FaultInjection.PrimarySideControl.CHWLoopEquipment.Validation;
model StageCHWSTBasedChiller "Test the CHWST-based chiller stage control"
  import WSEControlLogics;
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Sine TCHWSup(
    offset=273.15 + 7,
    amplitude=4.5,
    freqHz=1/3000,
    startTime=500) "CHWST input"
    annotation (Placement(transformation(extent={{-58,-50},{-38,-30}})));
  WSEControlLogics.Controls.LocalControls.CHWLoopEquipment.StageCHWSTBasedChiller
    chiStaCHWST(shoCycTim=300)
                "Chiller stage controller based on CHWST"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.IntegerTable uOpeMod(table=[0,1; 720,2; 1440,3; 2160,
        4; 2880,5])
    "Operation mode"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
equation
  connect(TCHWSup.y, chiStaCHWST.TCHWSup) annotation (Line(points={{-37,-40},{
          -20,-40},{-20,-4},{-12,-4}},
                                   color={0,0,127}));
  connect(uOpeMod.y, chiStaCHWST.uOpeMod) annotation (Line(points={{-39,40},{
          -20,40},{-20,4},{-12,4}}, color={255,127,0}));
  annotation (    __Dymola_Commands(file=
          "modelica://WSEControlLogics/Resources/Scripts/Dymola/Controls/LocalControls/CHWLoopEquipment/Validation/StageCHWSTBasedChiller.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>This example test the chiller staging controller implemented in 
<a href=\"modelica://WSEControlLogics.Controls.LocalControls.CHWLoopEquipment.StageCHWSTBasedChiller\">
WSEControlLogics/Controls/LocalControls/CHWLoopEquipment/StageCHWSTBasedChiller</a>. 
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
end StageCHWSTBasedChiller;
