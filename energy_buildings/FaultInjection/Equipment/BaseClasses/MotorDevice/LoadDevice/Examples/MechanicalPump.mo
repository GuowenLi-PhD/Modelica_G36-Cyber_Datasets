within FaultInjection.Equipment.BaseClasses.MotorDevice.LoadDevice.Examples;
model MechanicalPump "Example that demonstrate the use of mechanical pump"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;

  .FaultInjection.Equipment.BaseClasses.MotorDevice.LoadDevice.MechanicalPump
    pum1(redeclare package Medium = Medium, redeclare
      Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to4 per(
        use_powerCharacteristic=false)) "pump with input shaft"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou1(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou2(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Mechanics.Rotational.Components.Inertia loaInt(J=JLoad)
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Mechanics.Rotational.Sources.ConstantTorque torSou(tau_constant=
        tauMot)
    annotation (Placement(transformation(extent={{-68,40},{-48,60}})));
  parameter Modelica.SIunits.Torque tauMot = 0.05
    "Constant torque (if negative, torque is acting as load in positive direction of rotation)";
  parameter Modelica.SIunits.Inertia JLoad = 0.01 "Moment of inertia";
  SpeedControlled_Nrpm pum2(
    redeclare package Medium = Medium,
    use_inputFilter=false,
    redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to4 per(
        use_powerCharacteristic=false))
             "Pump model"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Fluid.Sources.Boundary_pT bou3(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Fluid.Sources.Boundary_pT bou4(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{80,-70},{60,-50}})));
  Modelica.Blocks.Sources.RealExpression rotSpe(y=
        Modelica.SIunits.Conversions.to_rpm(loaInt.w))  "Rotation speed"
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=1.2,
    dp_nominal=2000)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium,
    m_flow_nominal=1.2,
    dp_nominal=2000)
    annotation (Placement(transformation(extent={{-48,-70},{-28,-50}})));
equation
  connect(pum1.port_b, bou2.ports[1])
    annotation (Line(points={{10,0},{60,0}}, color={0,127,255}));
  connect(loaInt.flange_b, pum1.shaft)
    annotation (Line(points={{0,50},{0,10}}, color={0,0,0}));
  connect(torSou.flange, loaInt.flange_a)
    annotation (Line(points={{-48,50},{-20,50}}, color={0,0,0}));
  connect(pum2.port_b, bou4.ports[1])
    annotation (Line(points={{10,-60},{60,-60}}, color={0,127,255}));
  connect(bou1.ports[1], res.port_a)
    annotation (Line(points={{-60,0},{-50,0}}, color={0,127,255}));
  connect(res.port_b, pum1.port_a)
    annotation (Line(points={{-30,0},{-10,0}}, color={0,127,255}));
  connect(bou3.ports[1], res1.port_a)
    annotation (Line(points={{-60,-60},{-48,-60}}, color={0,127,255}));
  connect(res1.port_b, pum2.port_a)
    annotation (Line(points={{-28,-60},{-10,-60}}, color={0,127,255}));
  connect(rotSpe.y, pum2.Nrpm)
    annotation (Line(points={{-29,-30},{0,-30},{0,-48}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/LoadDevice/Examples/MechanicalPump.mos"
        "Simulate and Plot"));
end MechanicalPump;
