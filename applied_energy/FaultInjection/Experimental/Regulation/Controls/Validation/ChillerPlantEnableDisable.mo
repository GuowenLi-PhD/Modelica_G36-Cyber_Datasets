within FaultInjection.Experimental.Regulation.Controls.Validation;
model ChillerPlantEnableDisable
  extends Modelica.Icons.Example;
  FaultInjection.Experimental.Regulation.Controls.ChillerPlantEnableDisable plaEnaDis(TOutChi=
        279.15)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.BooleanPulse ySupFan(
    width=60,
    period(displayUnit="h") = 10800,
    startTime(displayUnit="min") = 300)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.Sine TOut(
    amplitude=10,
    freqHz=1/10800,
    offset=16 + 273.15,
    startTime(displayUnit="min") = 1200)
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.IntegerTable yPlaReq(table=[0,0; 800,1; 2500,0; 3000,
        1; 3800,0; 4500,1; 10800,0; 15000,1; 18000,0]) "Plant Request Numbers"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
equation
  connect(ySupFan.y, plaEnaDis.ySupFan) annotation (Line(points={{-59,-10},{-36,
          -10},{-36,0},{-12,0}}, color={255,0,255}));
  connect(TOut.y, plaEnaDis.TOut) annotation (Line(points={{-59,40},{-36,40},{-36,
          4},{-12,4}}, color={0,0,127}));
  connect(yPlaReq.y, plaEnaDis.yPlaReq) annotation (Line(points={{-59,-50},{-34,
          -50},{-34,-4},{-12,-4}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=21600, __Dymola_Algorithm="Cvode"));
end ChillerPlantEnableDisable;
