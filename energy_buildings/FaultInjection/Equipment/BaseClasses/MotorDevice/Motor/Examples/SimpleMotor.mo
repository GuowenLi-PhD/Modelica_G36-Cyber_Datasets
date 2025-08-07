within FaultInjection.Equipment.BaseClasses.MotorDevice.Motor.Examples;
model SimpleMotor
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Resistance R_s=0.641 "Electric resistance of stator";
  parameter Modelica.SIunits.Resistance R_r=0.332 "Electric resistance of rotor";
  parameter Modelica.SIunits.Reactance X_s=1.106 "Complex component of the impedance of stator";
  parameter Modelica.SIunits.Reactance X_r=0.464 "Complex component of the impedance of rotor";
  parameter Modelica.SIunits.Reactance X_m=26.3 "Complex component of the magnetizing reactance";
  MotorDevice.Motor.SimpleMotor simMot(
    J=2,
    R_s=R_s,
    R_r=R_r,
    X_s=X_s,
    X_r=X_r,
    X_m=X_m)
    annotation (Placement(transformation(extent={{-10,-6},{10,14}})));
  Modelica.Blocks.Sources.Step Vrms(
    height=10,
    startTime=1200,
    offset=120)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Step Tor(
    startTime=2400,
    height=5,
    offset=21)    "Mechanical torque"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.Step f(
    height=0,
    startTime=0,
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
    experiment(StopTime=3600),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Motor/Examples/SimpleMotor.mos"
        "Simulate and Plot"));
end SimpleMotor;
