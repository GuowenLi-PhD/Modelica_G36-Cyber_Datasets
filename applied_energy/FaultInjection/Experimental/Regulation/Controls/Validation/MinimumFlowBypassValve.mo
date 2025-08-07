within FaultInjection.Experimental.Regulation.Controls.Validation;
model MinimumFlowBypassValve
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Sine m_flow(
    amplitude=0.05,
    freqHz=1/10000,
    offset=0.1,
    startTime(displayUnit="min") = 60)
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  FaultInjection.Experimental.Regulation.Controls.MinimumFlowBypassValve minFloBypVal(
      m_flow_minimum=0.13, controllerType=Modelica.Blocks.Types.SimpleController.PI)
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  Modelica.Blocks.Sources.BooleanConstant boo
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation
  connect(m_flow.y, minFloBypVal.m_flowHW) annotation (Line(points={{-39,20},{
          -25.5,20},{-25.5,3},{-14,3}}, color={0,0,127}));
  connect(boo.y, minFloBypVal.yPlaBoi) annotation (Line(points={{-39,-30},{-26,
          -30},{-26,-3},{-14,-3}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=21600, __Dymola_Algorithm="Cvode"));
end MinimumFlowBypassValve;
