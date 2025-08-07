within FaultInjection.Equipment.BaseClasses.MotorDevice.Examples;
model ElectricPump
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;

  MotorDevice.ElectricPump electricPump(
    redeclare package Medium = Medium,
    f=60,
    m_flow_nominal=0.032,
    J=1) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou1(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou2(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Blocks.Sources.Step Vrms(
    offset=110,
    height=10,
    startTime=1200)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
equation
  connect(bou1.ports[1], electricPump.port_a)
    annotation (Line(points={{-60,0},{-10,0}}, color={0,127,255}));
  connect(electricPump.port_b, bou2.ports[1])
    annotation (Line(points={{10,0},{60,0}}, color={0,127,255}));
  connect(Vrms.y, electricPump.V_rms) annotation (Line(points={{-59,50},{-34,50},
          {-34,12},{0.4,12}},
                            color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ElectricPump;
