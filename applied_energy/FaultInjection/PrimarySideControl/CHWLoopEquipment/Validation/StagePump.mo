within FaultInjection.PrimarySideControl.CHWLoopEquipment.Validation;
model StagePump "Test the CHW pump stage control"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=100 "Nominal mass flowrate";

  Modelica.Blocks.Sources.Sine masFlo(
    offset=0.5*m_flow_nominal,
    amplitude=0.5*m_flow_nominal,
    freqHz=1/3600,
    startTime=500) "CHW mass flowrate"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  FaultInjection.PrimarySideControl.CHWLoopEquipment.StagePump CHWPumSta(
      m_flow_nominal=m_flow_nominal, numPum=2) "CHW pump staging controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.IntegerTable uOpeMod(table=[0,1; 720,2; 1440,3; 2160,
        4; 2880,5])
    "Operation mode"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
equation
  connect(masFlo.y, CHWPumSta.masFloPum) annotation (Line(points={{-39,-40},{
          -20,-40},{-20,-4},{-12,-4}},
                                color={0,0,127}));
  connect(uOpeMod.y, CHWPumSta.uOpeMod) annotation (Line(points={{-39,40},{-20,
          40},{-20,4},{-12,4}}, color={255,127,0}));
  annotation (    __Dymola_Commands(file=
          "modelica://WSEControlLogics/Resources/Scripts/Dymola/Controls/LocalControls/CHWLoopEquipment/Validation/StagePump.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>This example tests the controller for the CHW pump stage control implemented in 
<a href=\"modelica://WSEControlLogics.Controls.LocalControls.CHWLoopEquipment.StagePump\">
WSEControlLogics/Controls/LocalControls/CHWLoopEquipment/StagePump</a>. 
</p>
</html>", revisions="<html>
<ul>
<li>June 14, 2018, by Xing Lu:<br>First implementation. </li>
</ul>
</html>"),
experiment(
      StartTime=0,
      StopTime=1080,
      Tolerance=1e-06));
end StagePump;
