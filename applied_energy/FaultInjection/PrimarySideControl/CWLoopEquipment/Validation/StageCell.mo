within FaultInjection.PrimarySideControl.CWLoopEquipment.Validation;
model StageCell "Test the cooling tower cell stage control"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=50 "Nominal mass flowrate";
  Modelica.Blocks.Sources.Sine masFlo(
    startTime=720,
    offset=0,
    amplitude=1.2*m_flow_nominal,
    freqHz=1/6000) "CW Mass flowrate"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  FaultInjection.PrimarySideControl.CWLoopEquipment.StageCell staCel(
    m_flow_nominal=m_flow_nominal,
    staUpThr=1.05,
    waiTimStaUp=120,
    waiTimStaDow=120,
    shoCycTim=200) "Cooling tower cell stage control"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.IntegerStep min(startTime=720)
    "Minimum number"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.IntegerTable uOpeMod(table=[0,1; 720,2; 1440,3; 2160,
        4; 2880,5])
    "Operation mode"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
equation
  connect(masFlo.y, staCel.aveMasFlo) annotation (Line(points={{-39,-40},{-20,
          -40},{-20,-4},{-12,-4}},
                            color={0,0,127}));
  connect(min.y, staCel.minNumCel) annotation (Line(points={{-39,0},{-12,0}},
                              color={255,127,0}));
  connect(uOpeMod.y, staCel.uOpeMod)
    annotation (Line(points={{-39,40},{-20,40},{-20,4},{-12,4}},
                                               color={255,127,0}));
  annotation (    __Dymola_Commands(file=
          "modelica://WSEControlLogics/Resources/Scripts/Dymola/Controls/LocalControls/CWLoopEquipment/Validation/StageCell.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>This example tests the controller for the cooling tower stage control implemented in 
<a href=\"modelica://WSEControlLogics.Controls.LocalControls.CWLoopEquipment.StageCell\">
WSEControlLogics/Controls/LocalControls/CWLoopEquipment/StageCell</a>. </p>
</html>", revisions="<html>
<ul>
<li>June 14, 2018, by Xing Lu:<br>First implementation. </li>
</ul>
</html>"),
experiment(StopTime=3600, Tolerance=1e-06),
      Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end StageCell;
