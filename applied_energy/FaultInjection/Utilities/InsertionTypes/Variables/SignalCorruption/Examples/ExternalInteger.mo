within FaultInjection.Utilities.InsertionTypes.Variables.SignalCorruption.Examples;
model ExternalInteger "External integer model"
  extends Modelica.Icons.Example;

  FaultInjection.Utilities.InsertionTypes.Variables.SignalCorruption.ExternalInteger
    extAtt( faultMode=faultMode)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  parameter Generic.faultMode faultMode(
    active=true,
    startTime=3600,
    endTime=7200,
    minimum=273.15 + 4,
    maximum=273.15 + 15)
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Modelica.Blocks.Sources.IntegerConstant
                                   tem(k=6)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.IntegerConstant
                                   extSig12(k=12)
    annotation (Placement(transformation(extent={{-80,-28},{-60,-8}})));
equation
  connect(extSig12.y, extAtt.uFau) annotation (Line(points={{-59,-18},{-36,-18},
          {-36,6},{-12,6}}, color={255,127,0}));
  connect(tem.y, extAtt.u) annotation (Line(points={{-59,50},{-32,50},{-32,0},{-12,
          0}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=10800, __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(
    file="modelica://FaultInjection/Resources/Scripts/dymola/Utilities/InsertionTypes/Variables/SignalCorruption/Examples/ExternalInteger.mos"
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
end ExternalInteger;
