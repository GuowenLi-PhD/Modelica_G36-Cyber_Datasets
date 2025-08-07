within FaultInjection.Equipment.BaseClasses.MotorDevice.Motor.Examples;
model ZIPMotor "Test ZIP model using a fraction for fans"
  import FaultInjection.Equipment.BaseClasses.MotorDevice;
  extends Modelica.Icons.Example;

  parameter Real az = -0.47 "Fraction of constant impededance load in active power";
  parameter Real ai = 1.71 "Fraction of constant current load in active power";
  parameter Real ap = -0.24 "Fraction of constant power load in active power";
  parameter Real rz = 2.34 "Fraction of constant impededance load in reactive power";
  parameter Real ri = -3.12 "Fraction of constant current load in reactive power";
  parameter Real rp = 1.78 "Fraction of constant power load in reactive power";
  parameter Modelica.SIunits.Voltage V_nominal = 120;
  parameter Modelica.SIunits.Power P_nominal = 163.25;
  parameter Modelica.SIunits.ReactivePower Q_nominal = 83.28;

  MotorDevice.Motor.ZIPMotor
                        zIPMotor(
    az=az,
    ai=ai,
    ap=ap,
    rz=rz,
    ri=ri,
    rp=rp,
    V_nominal=V_nominal,
    P_nominal=P_nominal,
    Q_nominal=Q_nominal) "ZIP model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.Step Vrms(
    offset=110,
    height=10,
    startTime=120)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.Step f(
    offset=110,
    height=10,
    startTime=240)
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
equation
  connect(Vrms.y, zIPMotor.V_rms) annotation (Line(points={{-59,10},{-36,10},{
          -36,6},{-12,6}}, color={0,0,127}));
  connect(f.y, zIPMotor.f_in) annotation (Line(points={{-59,-40},{-36,-40},{-36,
          -6},{-12,-6}}, color={0,0,127}));
  annotation (
    experiment(StopTime=360),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Motor/Examples/ZIPMotor.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>
The coefficients for the ZIP model in this example is chosen for the fan in a residential building. Details can be found in the following reference.
</p>

<h4> Reference</h4>
<p> Bokhari, Abdullah, et al. &quot;Experimental determination of the ZIP coefficients for modern residential, commercial, and industrial
loads.&quot; IEEE Transactions on Power Delivery 29.3 (2014): 1372-1381.
</p>
</html>"));
end ZIPMotor;
