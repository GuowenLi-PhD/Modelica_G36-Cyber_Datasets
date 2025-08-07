within FaultInjection.Utilities.InsertionTypes.Variables.SignalCorruption.Examples;
model SignalCorruption "Signal corruption injection"
  extends Modelica.Icons.Example;
  parameter Generic.faultMode faultMode(
    active=true,
    startTime=3600,
    endTime=7200,
    minimum=273.15 + 4,
    maximum=273.15 + 15)
    annotation (Placement(transformation(extent={{40,80},{60,100}})));

  Min minAtt(faultMode=faultMode)
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Max maxAtt(faultMode=faultMode)
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  Scaling scaAtt(k=0.998,
    faultMode=faultMode)
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  FaultInjection.Utilities.InsertionTypes.Variables.SignalCorruption.Additive
           addAtt(k=5,
    faultMode=faultMode)
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  Ramping ramAtt(k=10/3600,
    faultMode=faultMode)
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Random ranAtt(
    samplePeriod=60,
    mu=10,
    sigma=6,
    faultMode=faultMode)
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));

  Modelica.Blocks.Sources.Constant tem(k(unit="K")=273.15 + 6)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  External extAtt(faultMode=faultMode)
    annotation (Placement(transformation(extent={{-10,-106},{10,-86}})));
  Modelica.Blocks.Sources.Constant extSig12(k(unit="K") = 273.15 + 12)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
equation
  connect(tem.y, minAtt.u) annotation (Line(points={{-59,0},{-40,0},{-40,80},{-12,
          80}}, color={0,0,127}));
  connect(tem.y, maxAtt.u) annotation (Line(points={{-59,0},{-40,0},{-40,50},{-12,
          50}}, color={0,0,127}));
  connect(tem.y, scaAtt.u) annotation (Line(points={{-59,0},{-40,0},{-40,20},{-12,
          20}}, color={0,0,127}));
  connect(tem.y, addAtt.u) annotation (Line(points={{-59,0},{-40,0},{-40,-10},{-12,
          -10}}, color={0,0,127}));
  connect(tem.y, ramAtt.u) annotation (Line(points={{-59,0},{-40,0},{-40,-40},{-12,
          -40}}, color={0,0,127}));
  connect(tem.y, ranAtt.u) annotation (Line(points={{-59,0},{-40,0},{-40,-70},{-12,
          -70}}, color={0,0,127}));
  connect(tem.y, extAtt.u) annotation (Line(points={{-59,0},{-40,0},{-40,-96},{-12,
          -96}}, color={0,0,127}));
  connect(extSig12.y, extAtt.uFau) annotation (Line(points={{-59,-70},{-44,-70},
          {-44,-90},{-12,-90}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=10800, __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file="modelica://FaultInjection/Resources/Scripts/dymola/Utilities/InsertionTypes/Variables/SignalCorruption/Examples/SignalCorruption.mos"
        "Simulation and Plot"),
    Documentation(info="<html>
<p>
This example tests all the signal corruption components. The attack lasts for 1 hour.
</p>
</html>", revisions="<html>
<ul>
<li>
August 21, 2020, by Yangyang Fu:<br/>
First implementation
</li>
</ul>
</html>"));
end SignalCorruption;
