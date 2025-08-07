within FaultInjection.Equipment.BaseClasses.MotorDevice.Examples;
model SimpleElectricPumpConstantLoad
  import FaultInjection.Equipment.BaseClasses.MotorDevice;
  extends Modelica.Icons.Example;

  MotorDevice.SimpleElectricPumpConstantLoad pum1(
    JMotor=0.1,
    w_nominal=300,
    JLoad=0.01,
    tau_nominal=-0.1)
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Modelica.Blocks.Sources.Step VrmsUp(
    offset=110,
    startTime=1200,
    height=11)
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Sources.Step VrmsDow(
    offset=110,
    startTime=1200,
    height=-11)
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  MotorDevice.SimpleElectricPumpConstantLoad pum2(
    JMotor=0.1,
    w_nominal=300,
    JLoad=0.01,
    tau_nominal=-0.1)
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Modelica.Blocks.Sources.Constant f(k=50)
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
equation
  connect(VrmsUp.y, pum1.V_rms) annotation (Line(points={{-59,20},{-38,20},{-38,
          15},{-22,15}}, color={0,0,127}));
  connect(VrmsDow.y, pum2.V_rms) annotation (Line(points={{-59,-60},{-38,-60},{
          -38,-45},{-22,-45}}, color={0,0,127}));
  connect(f.y, pum1.f_in) annotation (Line(points={{-59,-20},{-38,-20},{-38,5},
          {-22,5}}, color={0,0,127}));
  connect(f.y, pum2.f_in) annotation (Line(points={{-59,-20},{-38,-20},{-38,-55},
          {-22,-55}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Examples/SimpleElectricPumpConstantLoad.mos"
        "Simulate and Plot"));
end SimpleElectricPumpConstantLoad;
