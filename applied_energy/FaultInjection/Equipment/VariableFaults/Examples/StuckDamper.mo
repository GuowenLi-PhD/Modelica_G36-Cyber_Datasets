within FaultInjection.Equipment.VariableFaults.Examples;
model StuckDamper
  import FaultInjection;
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model for air";

 parameter Utilities.InsertionTypes.Generic.faultMode
                             faultMode(
    active=true,                       startTime=100, endTime=300)
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101335,
    nPorts=1,
    T=293.15) "Pressure boundary condition"
     annotation (Placement(
        transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=1) "Pressure boundary condition"
      annotation (Placement(
        transformation(extent={{62,-10},{42,10}})));
    Modelica.Blocks.Sources.Ramp yRam(
    offset=0,
    height=1,
    duration=300)
              annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  FaultInjection.Equipment.VariableFaults.StuckDamper stuDam(
  redeclare package Medium = Medium,
    m_flow_nominal=1,                faultMode=faultMode,
    dpDamper_nominal=10)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(stuDam.port_b, sin.ports[1])
    annotation (Line(points={{10,0},{42,0}}, color={0,127,255}));
  connect(sou.ports[1], stuDam.port_a)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(yRam.y, stuDam.y)
    annotation (Line(points={{-39,50},{0,50},{0,11.8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=500));
end StuckDamper;
