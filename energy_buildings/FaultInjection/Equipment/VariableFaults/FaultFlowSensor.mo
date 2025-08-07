within FaultInjection.Equipment.VariableFaults;
model FaultFlowSensor "Flow rate sensor with faults"
    extends Buildings.Fluid.Interfaces.PartialTwoPort;

  Buildings.Fluid.Sensors.VolumeFlowRate senTem(
    redeclare package Medium = Medium,
    initType=Modelica.Blocks.Types.Init.InitialState,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=allowFlowReversal)
             annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate, used for regularization near zero flow";
  parameter Modelica.SIunits.Time tau=1
    "Time constant at nominal flow rate (use tau=0 for steady-state sensor, but see user guide for potential problems)";
      parameter Modelica.Blocks.Types.Init initType = Modelica.Blocks.Types.Init.InitialState
    "Type of initialization (InitialState and InitialOutput are identical)"
  annotation(Evaluate=true, Dialog(group="Initialization"));

  Utilities.InsertionTypes.Variables.SignalCorruption.Scaling sca(
  faultMode=faultMode, use_uFau_in=use_uFau_in)                     "Scale"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
 parameter Utilities.InsertionTypes.Generic.faultMode faultMode
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Modelica.Blocks.Interfaces.RealOutput V_flow(final quantity="VolumeFlowRate",final unit="m3/s")
    "Volume flow rate from port_a to port_b"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,110})));
  Modelica.Blocks.Interfaces.RealInput uFau_in if use_uFau_in "Prescribed signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  parameter Boolean use_uFau_in = true "Get the faulty signal from the input connector"
    annotation(Evaluate=true, HideResult=true, Dialog(group="Conditional inputs"));

equation
  connect(port_a, senTem.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(senTem.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(senTem.V_flow,sca. u) annotation (Line(points={{0,11},{0,26},{-60,26},
          {-60,50},{-42,50}}, color={0,0,127}));
  connect(sca.y, V_flow)
    annotation (Line(points={{-19,50},{0,50},{0,110}}, color={0,0,127}));
  connect(uFau_in, sca.uFau_in) annotation (Line(points={{-120,80},{-60,80},{
          -60,56},{-42,56}}, color={0,0,127}));
  annotation (defaultComponentName="senVol",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(visible=(tau <> 0),
        points={{52,60},{58,74},{66,86},{76,92},{88,96},{98,96}}, color={0,
              0,127}),
        Line(visible=(tau <> 0),
        points={{52,60},{58,74},{66,86},{76,92},{88,96},{98,96}}, color={0,
              0,127}),
        Ellipse(
          fillColor={245,245,245},
          fillPattern=FillPattern.Solid,
          extent={{-70.0,-70.0},{70.0,70.0}}),
        Line(points={{0.0,70.0},{0.0,40.0}}),
        Line(points={{22.9,32.8},{40.2,57.3}}),
        Line(points={{-22.9,32.8},{-40.2,57.3}}),
        Line(points={{37.6,13.7},{65.8,23.9}}),
        Line(points={{-37.6,13.7},{-65.8,23.9}}),
        Ellipse(
          lineColor={64,64,64},
          fillColor={255,255,255},
          extent={{-12.0,-12.0},{12.0,12.0}}),
        Polygon(
          rotation=-17.5,
          fillColor={64,64,64},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-5.0,0.0},{-2.0,60.0},{0.0,65.0},{2.0,60.0},{5.0,0.0}}),
        Ellipse(
          fillColor={64,64,64},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{-7.0,-7.0},{7.0,7.0}}),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Line(
          points={{-54,-54},{52,76}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{-56,78},{54,-56}},
          color={238,46,47},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end FaultFlowSensor;
