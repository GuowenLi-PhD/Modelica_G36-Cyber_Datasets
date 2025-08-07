within FaultInjection.Utilities.InsertionTypes.Variables.Examples;
model Scale "Example to test scale"
  import FaultInjection;
  extends Modelica.Icons.Example;

  FaultInjection.Utilities.InsertionTypes.Variables.Scale sca(faultMode=
        faultMode)
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));

 parameter Generic.faultMode faultMode(endTime=180)
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Sources.Constant con(k=2000)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Noise.NormalNoise noi(
    samplePeriod=0.5,
    mu=0,
    sigma=0.1) "Noise"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
equation
  connect(con.y, sca.u)
    annotation (Line(points={{-59,0},{-14,0}}, color={0,0,127}));
  connect(noi.y, sca.uFau_in) annotation (Line(points={{-59,40},{-38,40},{-38,
          8},{-14,8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=360));
end Scale;
