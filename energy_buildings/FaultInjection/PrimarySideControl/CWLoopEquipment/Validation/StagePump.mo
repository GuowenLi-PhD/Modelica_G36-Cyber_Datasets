within FaultInjection.PrimarySideControl.CWLoopEquipment.Validation;
model StagePump "Test the cooling water pump stage control"

  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=50 "Nominal mass flowrate";
  FaultInjection.PrimarySideControl.CWLoopEquipment.StagePump staPum(
    numPum=2,
    numChi=2,
    staUpThr=0.8,
    waiTimStaUp=120,
    waiTimStaDow=120,
    shoCycTim=200) "Cooling water pump stage controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Sine uSpeTow(
    amplitude=0.3,
    freqHz=1/1080,
    offset=0.7)    "Speed of cooling tower fans"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.IntegerTable uOpeMod(table=[0,1; 720,2; 1440,3; 2160,
        4; 2880,5])
                 "Operation mode"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.IntegerTable numActChi(table=[0,0; 720,2; 1440,1;
        2160,2; 3200,1])
                    "Number of active chillers"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
equation
  connect(uSpeTow.y, staPum.uSpeTow) annotation (Line(points={{-39,50},{-26,50},
          {-26,8},{-12,8}}, color={0,0,127}));
  connect(uOpeMod.y, staPum.uOpeMod)
    annotation (Line(points={{-39,0},{-12,0},{-12,0}}, color={255,127,0}));
  connect(numActChi.y, staPum.numActChi) annotation (Line(points={{-39,-50},{
          -26,-50},{-26,-8},{-12,-8}}, color={255,127,0}));
  annotation (    __Dymola_Commands(file=
          "modelica://WSEControlLogics/Resources/Scripts/Dymola/Controls/LocalControls/CWLoopEquipment/Validation/StagePump.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>This example tests the controller for cooling water pump stage control implemented in <a href=\"modelica://WSEControlLogics.Controls.LocalControls.CWLoopEquipment.StagePump\">WSEControlLogics/Controls/LocalControls/CWLoopEquipment/StagePump</a>. </p>
</html>", revisions="<html>
<ul>
<li>June 14, 2018, by Xing Lu:<br>First implementation. </li>
</ul>
</html>"),
experiment(StopTime=3600, Tolerance=1e-06),
      Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end StagePump;
