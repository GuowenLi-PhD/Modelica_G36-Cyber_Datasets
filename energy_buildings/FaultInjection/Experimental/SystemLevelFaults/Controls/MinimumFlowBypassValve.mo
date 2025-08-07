within FaultInjection.Experimental.SystemLevelFaults.Controls;
model MinimumFlowBypassValve "Minimum flow bypass valve control"
  extends Modelica.Blocks.Icons.Block;

  Buildings.Controls.OBC.CDL.Interfaces.RealInput m_flow(final quantity=
        "MassFlowRate", final unit="kg/s") "Water mass flow rate measurement"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
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
    y_reset=0) annotation (Placement(transformation(extent={{-10,60},{10,80}})));
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

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput yPla "Plant on/off"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Modelica.Blocks.Sources.RealExpression dm(y=m_flow - m_flow_minimum)
    "Delta mass flowrate"
    annotation (Placement(transformation(extent={{-92,-20},{-72,0}})));
  Modelica.Blocks.Logical.Hysteresis hys(uLow=0, uHigh=0.1)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Output 0 or 1 request "
    annotation (Placement(transformation(extent={{54,-10},{74,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Constant 0"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
equation
  connect(m_flow_min.y, conPID.u_s)
    annotation (Line(points={{-59,58},{-36,58},{-36,70},{-12,70}},
                                               color={0,0,127}));
  connect(conPID.u_m, m_flow)
    annotation (Line(points={{0,58},{0,30},{-120,30}}, color={0,0,127}));
  connect(swi.y, y) annotation (Line(points={{76,0},{110,0}}, color={0,0,127}));
  connect(dm.y, hys.u)
    annotation (Line(points={{-71,-10},{-62,-10}}, color={0,0,127}));
  connect(conPID.y, swi.u3) annotation (Line(points={{11,70},{16,70},{16,-8},{
          52,-8}}, color={0,0,127}));
  connect(zer.y, swi.u1)
    annotation (Line(points={{42,40},{44,40},{44,8},{52,8}}, color={0,0,127}));
  connect(yPla, and1.u2) annotation (Line(points={{-120,-50},{-20,-50},{-20,-38},
          {-2,-38}}, color={255,0,255}));
  connect(hys.y, and1.u1) annotation (Line(points={{-39,-10},{-20,-10},{-20,-30},
          {-2,-30}}, color={255,0,255}));
  connect(and1.y, swi.u2) annotation (Line(points={{21,-30},{40,-30},{40,0},{52,
          0}}, color={255,0,255}));
  connect(hys.y, conPID.trigger)
    annotation (Line(points={{-39,-10},{-8,-10},{-8,58}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>The bypass valve PID loop is enabled when the plant is on. When enabled, the bypass valve loop starts with the valve 0&percnt; open. It is closed when the plant is off. </p>
</html>", revisions="<html>
<ul>
<li>Sep 1, 2020, by Xing Lu:<br>First implementation. </li>
</ul>
</html>"));
end MinimumFlowBypassValve;
