within FaultInjection.Equipment.BaseClasses.MotorDevice.LoadDevice.Examples;
model Pump
  import FaultInjection.Equipment.BaseClasses.MotorDevice;
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;
  MotorDevice.LoadDevice.Pump pump(
    redeclare package Medium = Medium,
    N_nominal=3600,
    redeclare function flowCharacteristic =
        Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.linearFlow(V_flow_nominal={100,200},head_nominal=400*{1.0,0.999980}))
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
    //Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.quadraticFlow(V_flow_nominal={0.01,0.02,0.03},head_nominal=400*{1.2,1.0,0.8})
  Buildings.Fluid.Sources.Boundary_pT bou1(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou2(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Mechanics.Rotational.Sources.Speed speed
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.Ramp speedRamp(
    startTime=0.4,
    height=150,
    duration=1,
    offset=50)     annotation (Placement(transformation(extent={{-80,40},{
            -60,60}})));
equation
  connect(bou1.ports[1], pump.port_a)
    annotation (Line(points={{-60,0},{-12,0}}, color={0,127,255}));
  connect(pump.port_b, bou2.ports[1])
    annotation (Line(points={{8,0},{60,0}}, color={0,127,255}));
  connect(speed.flange, pump.shaft) annotation (Line(points={{-20,50},{-10,50},{
          -10,10},{-2,10}}, color={0,0,0}));
  connect(speedRamp.y, speed.w_ref)
    annotation (Line(points={{-59,50},{-42,50}}, color={0,0,127}));
  annotation (__Dymola_Commands(file="Resources/Scripts/Dymola/LoadDevice/Examples/Pump.mos"
        "Simulate and Plot"));
end Pump;
