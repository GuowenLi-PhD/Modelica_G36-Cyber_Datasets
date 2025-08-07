within FaultInjection.Utilities.InsertionTypes.Variables.SignalCorruption.Examples;
model Additive "Additive corruption tests"
  extends Modelica.Icons.Example;

  FaultInjection.Utilities.InsertionTypes.Variables.SignalCorruption.Additive
    addAtt1(faultMode=faultMode, k=5)
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  FaultInjection.Utilities.InsertionTypes.Variables.SignalCorruption.Additive
    addAtt2(faultMode=faultMode, use_uFau_in=true)
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  parameter Generic.faultMode faultMode(
    active=true,
    startTime=3600,
    endTime=7200,
    minimum=273.15 + 4,
    maximum=273.15 + 15)
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Modelica.Blocks.Sources.Constant tem(k(unit="K") = 273.15 + 6)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Constant extSig12(k(unit="K") = 273.15 + 12)
    annotation (Placement(transformation(extent={{-80,-28},{-60,-8}})));
equation
  connect(tem.y, addAtt1.u)
    annotation (Line(points={{-59,50},{-12,50}}, color={0,0,127}));
  connect(tem.y, addAtt2.u) annotation (Line(points={{-59,50},{-36,50},{-36,-30},
          {-12,-30}}, color={0,0,127}));
  connect(extSig12.y, addAtt2.uFau_in) annotation (Line(points={{-59,-18},{-40,-18},
          {-40,-24},{-12,-24}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=10800, __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file="modelica://FaultInjection/Resources/Scripts/dymola/Utilities/InsertionTypes/Variables/SignalCorruption/Examples/Additive.mos"
        "Simulate and Plot"),
    Documentation(revisions="<html>
<ul>
<li>
October 12, 2020, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>
"));
end Additive;
