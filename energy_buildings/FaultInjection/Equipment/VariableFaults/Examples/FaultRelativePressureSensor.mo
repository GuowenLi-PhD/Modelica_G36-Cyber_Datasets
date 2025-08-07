within FaultInjection.Equipment.VariableFaults.Examples;
model FaultRelativePressureSensor
  import FaultInjection;
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air;

 parameter Utilities.InsertionTypes.Generic.faultMode faultMode(startTime=100, endTime=200)
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Modelica.Blocks.Noise.NormalNoise noi(
    samplePeriod=0.5,
    mu=0,
    sigma=1)   "Noise"
    annotation (Placement(transformation(extent={{-46,40},{-26,60}})));
  FaultInjection.Equipment.VariableFaults.FaultRelativePressureSensor senPre(
   redeclare package Medium = Medium, faultMode=faultMode)
    annotation (Placement(transformation(extent={{-10,32},{10,52}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=293.15,
    nPorts=1) "Flow boundary condition" annotation (Placement(
        transformation(extent={{56,-10},{36,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop dp(
    redeclare package Medium = Medium,
    m_flow_nominal=10,
    dp_nominal=200) "Flow resistance"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T masFloRat(
    redeclare package Medium = Medium,
    use_T_in=false,
    X={0.02,0.98},
    use_m_flow_in=true,
    nPorts=1) "Flow boundary condition"
     annotation (Placement(transformation(
          extent={{-58,-10},{-38,10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-20,
    offset=10,
    duration=1)
    annotation (Placement(transformation(extent={{-100,-2},{-80,18}})));
  inner Modelica.Blocks.Noise.GlobalSeed globalSeed
    annotation (Placement(transformation(extent={{-50,-68},{-30,-48}})));
equation
  connect(noi.y,senPre. uFau_in)
    annotation (Line(points={{-25,50},{-12,50}},color={0,0,127}));
  connect(masFloRat.ports[1], dp.port_a)
    annotation (Line(points={{-38,0},{-10,0}},color={0,127,255}));
  connect(dp.port_b, sin.ports[1])
    annotation (Line(points={{10,0},{36,0}},               color={0,127,255}));
  connect(ramp.y, masFloRat.m_flow_in)
    annotation (Line(points={{-79,8},{-60,8}}, color={0,0,127}));
  connect(senPre.port_a, dp.port_a) annotation (Line(points={{-10,42},{-20,42},{
          -20,0},{-10,0}},
                      color={0,127,255}));
  connect(senPre.port_b, dp.port_b) annotation (Line(points={{10,42},{20,42},{20,
          0},{10,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=500));
end FaultRelativePressureSensor;
