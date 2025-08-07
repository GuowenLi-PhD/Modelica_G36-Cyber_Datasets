within FaultInjection.Equipment.BaseClasses.MotorDevice.Motor.Examples;
model SimpleMotorZeroVoltage
  extends Modelica.Icons.Example;

  MotorDevice.Motor.SimpleMotor simMot(pole=4, J=0.024)
    annotation (Placement(transformation(extent={{-10,-6},{10,14}})));
  Modelica.Blocks.Sources.Step Vrms(
    height=120,
    offset=0,
    startTime=600)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Constant
                               Tor(k=0.5)
                  "Mechanical torque"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.Step f(
    startTime=1200,
    height=-60,
    offset=60)   "Frequency"
    annotation (Placement(transformation(extent={{-80,-6},{-60,14}})));
equation
  connect(Vrms.y, simMot.V_rms) annotation (Line(points={{-59,50},{-36,50},{-36,
          8},{-12,8}}, color={0,0,127}));
  connect(Tor.y, simMot.tau_m) annotation (Line(points={{-59,-30},{-34,-30},{-34,
          0},{-12,0}}, color={0,0,127}));
  connect(f.y, simMot.f_in)
    annotation (Line(points={{-59,4},{-12,4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=2400),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Motor/Examples/SimpleMotorZeroVoltage.mos"
        "Simulate and Plot"));
end SimpleMotorZeroVoltage;
