within FaultInjection.Equipment.VariableFaults;
model FaultTemperatureSensor "Temperature sensor with faults"
    extends Buildings.Fluid.Interfaces.PartialTwoPort;

  Modelica.Blocks.Interfaces.RealOutput T(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=0,
    start=T_start)
    "Temperature of the passing fluid"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270)));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    tau=tau,
    initType=initType,
    T_start=T_start)
             annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate, used for regularization near zero flow";
  parameter Modelica.SIunits.Time tau=1
    "Time constant at nominal flow rate (use tau=0 for steady-state sensor, but see user guide for potential problems)";
      parameter Modelica.Blocks.Types.Init initType = Modelica.Blocks.Types.Init.InitialState
    "Type of initialization (InitialState and InitialOutput are identical)"
  annotation(Evaluate=true, Dialog(group="Initialization"));

  parameter Modelica.SIunits.Temperature T_start=Medium.T_default
    "Initial or guess value of output (= state)";
  Utilities.InsertionTypes.Variables.SignalCorruption.Additive bias(faultMode=
        faultMode, use_uFau_in=use_uFau_in) "Bias"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

 parameter Utilities.InsertionTypes.Generic.faultMode faultMode
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Modelica.Blocks.Interfaces.RealInput uFau_in if use_uFau_in "Prescribed signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  parameter Boolean use_uFau_in = true "Get the faulty signal from the input connector"
    annotation(Evaluate=true, HideResult=true, Dialog(group="Conditional inputs"));

equation
  connect(port_a, senTem.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(senTem.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(senTem.T, bias.u) annotation (Line(points={{0,11},{0,28},{-60,28},{
          -60,50},{-42,50}}, color={0,0,127}));
  connect(bias.y, T)
    annotation (Line(points={{-19,50},{0,50},{0,110}}, color={0,0,127}));
  connect(bias.uFau_in, uFau_in) annotation (Line(points={{-42,56},{-60,56},{-60,
          80},{-120,80}}, color={0,0,127}));
  annotation (defaultComponentName="senTem",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(visible=(tau <> 0),
        points={{52,60},{58,74},{66,86},{76,92},{88,96},{98,96}}, color={0,
              0,127}),
        Line(points={{-100,0},{92,0}}, color={0,128,255}),
        Ellipse(
          extent={{-20,-58},{20,-20}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-40,60},{-12,60}}),
        Line(points={{-40,30},{-12,30}}),
        Line(points={{-40,0},{-12,0}}),
        Rectangle(
          extent={{-12,60},{12,-24}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-12,60},{-12,80},{-10,86},{-6,88},{0,90},{6,88},{10,86},{12,
              80},{12,60},{-12,60}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Text(
          extent={{102,140},{-18,90}},
          lineColor={0,0,0},
          textString="T"),
        Line(
          points={{-12,60},{-12,-25}},
          thickness=0.5),
        Line(
          points={{12,60},{12,-24}},
          thickness=0.5),
        Line(points={{0,100},{0,50}}, color={0,0,127}),
        Line(
          points={{-54,76},{56,-58}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{-52,-56},{54,74}},
          color={238,46,47},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end FaultTemperatureSensor;
