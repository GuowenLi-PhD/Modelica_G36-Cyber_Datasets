within FaultInjection.Equipment.BaseClasses.MotorDevice.Examples;
model ElectricPumpDetailed
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;

  MotorDevice.ElectricPumpDetailed electricPumpDetailed(
    redeclare package Medium = Medium,
    f=60,
    m_flow_nominal=0.032,
    J=1,
    TLoad=10)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou1(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou2(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
equation
  connect(bou1.ports[1], electricPumpDetailed.port_a)
    annotation (Line(points={{-60,0},{-10,0}}, color={0,127,255}));
  connect(electricPumpDetailed.port_b, bou2.ports[1])
    annotation (Line(points={{10,0},{60,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ElectricPumpDetailed;
