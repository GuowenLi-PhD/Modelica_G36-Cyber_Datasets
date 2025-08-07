within FaultInjection.Experimental.SystemLevelFaults.Controls;
model MinimumFlowBypassValve "Minimum flow bypass valve control"
  extends Modelica.Blocks.Icons.Block;

  Buildings.Controls.OBC.CDL.Interfaces.RealInput m_flowHW(final quantity="MassFlowRate",
      final unit="kg/s") "Water mass flow rate measurement" annotation (
      Placement(transformation(extent={{-140,10},{-100,50}}),
        iconTransformation(extent={{-20,-20},{20,20}}, origin={-120,30})));
  Modelica.Blocks.Sources.RealExpression m_flow_min(y=m_flow_minimum)
    "Design minimum water flow rate"
    annotation (Placement(transformation(extent={{-80,48},{-60,68}})));
  Buildings.Controls.Continuous.LimPID conPID(
    controllerType=controllerType,
    k=k,
    Ti=Ti,
    Td=Td,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=0) annotation (Placement(transformation(extent={{-10,48},{10,68}})));
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  parameter Modelica.SIunits.MassFlowRate m_flow_minimum=0.1 "Design minimum water mass flow rate";
 // Controller
  parameter Modelica.Blocks.Types.SimpleController controllerType=
    Modelica.Blocks.Types.SimpleController.PI
    "Type of controller";
  parameter Real k(min=0, unit="1") = 0.1
    "Gain of controller";
  parameter Modelica.SIunits.Time Ti(min=Modelica.Constants.small)=60
    "Time constant of integrator block"
     annotation (Dialog(enable=
          (controllerType == Modelica.Blocks.Types.SimpleController.PI or
          controllerType == Modelica.Blocks.Types.SimpleController.PID)));
  parameter Modelica.SIunits.Time Td(min=0)=0.1
    "Time constant of derivative block"
     annotation (Dialog(enable=
         (controllerType == Modelica.Blocks.Types.SimpleController.PD or
          controllerType == Modelica.Blocks.Types.SimpleController.PID)));


  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput yPlaBoi
    "Plant on/off"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Output 0 or 1 request "
    annotation (Placement(transformation(extent={{54,-10},{74,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Constant 0"
    annotation (Placement(transformation(extent={{14,-40},{34,-20}})));
equation
  connect(m_flow_min.y, conPID.u_s)
    annotation (Line(points={{-59,58},{-12,58}},
                                               color={0,0,127}));
  connect(conPID.u_m, m_flowHW)
    annotation (Line(points={{0,46},{0,30},{-120,30}}, color={0,0,127}));
  connect(yPlaBoi, conPID.trigger)
    annotation (Line(points={{-120,-50},{-8,-50},{-8,46}}, color={255,0,255}));
  connect(zer.y, swi.u3) annotation (Line(points={{36,-30},{42,-30},{42,-8},{52,
          -8}}, color={0,0,127}));
  connect(yPlaBoi, swi.u2) annotation (Line(points={{-120,-50},{-8,-50},{-8,0},
          {52,0}}, color={255,0,255}));
  connect(conPID.y, swi.u1)
    annotation (Line(points={{11,58},{44,58},{44,8},{52,8}}, color={0,0,127}));
  connect(swi.y, y) annotation (Line(points={{76,0},{110,0}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>The bypass valve PID loop is enabled when the plant is on. When enabled, the bypass valve loop starts with the valve 0&percnt; open. It is closed when the plant is off. </p>
</html>", revisions="<html>
<ul>
<li>Sep 1, 2020, by Xing Lu:<br>First implementation. </li>
</ul>
</html>"));
end MinimumFlowBypassValve;
