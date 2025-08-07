within FaultInjection.Equipment.BaseClasses.MotorDevice.Motor.BaseClasses.Functions;
function TorqueSpeed "Torque speed in motor"
  input Modelica.SIunits.Frequency f "Frequency of the source";
  input Integer pole = 2 "Number of pole pairs";
  input Integer n = 3 "Number of phases";

  input Modelica.SIunits.Resistance R_s=24.5 "Electric resistance of stator";
  input Modelica.SIunits.Resistance R_r=23 "Electric resistance of rotor";
  input Modelica.SIunits.Reactance X_s=10 "Complex component of the impedance of stator";
  input Modelica.SIunits.Reactance X_r=40 "Complex component of the impedance of rotor";
  input Modelica.SIunits.Reactance X_m=25 "Complex component of the magnetizing reactance";

  input Modelica.SIunits.Voltage V_rms = 110;

  input Modelica.SIunits.AngularVelocity omega_r;
  output Modelica.SIunits.Torque tau_e;

protected
  Real ratio "Intermediate value";
  Real s(min=0,max=1) "Motor slip";
  Modelica.SIunits.AngularVelocity omega_s "Synchronous angular velocity";

algorithm

  omega_s := 4*Modelica.Constants.pi*f/pole;
  s := (omega_s-omega_r)/omega_s;
  ratio := X_m/(X_m+X_s);
  tau_e := n*R_r*s*(V_rms*ratio)^2/(omega_s*(((s*R_s*ratio^2+R_r)^2)+s^2*(X_s+X_r)^2));
end TorqueSpeed;
