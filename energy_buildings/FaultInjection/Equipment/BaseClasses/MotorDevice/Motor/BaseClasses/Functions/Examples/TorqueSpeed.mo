within FaultInjection.Equipment.BaseClasses.MotorDevice.Motor.BaseClasses.Functions.Examples;
model TorqueSpeed "Torque speed"
  extends Modelica.Icons.Example;
  import Modelica.Constants.pi;
  parameter Modelica.SIunits.Frequency f=60 "Frequency of the source";
  parameter Integer pole = 2 "Number of pole pairs";
  parameter Integer n = 3 "Number of phases";

  parameter Modelica.SIunits.Resistance R_s(start=10)=24.5 "Electric resistance of stator";
  parameter Modelica.SIunits.Resistance R_r(start=10)=23 "Electric resistance of rotor";
  parameter Modelica.SIunits.Reactance X_s(start = 1)=10 "Complex component of the impedance of stator";
  parameter Modelica.SIunits.Reactance X_r(start = 1)=40 "Complex component of the impedance of rotor";
  parameter Modelica.SIunits.Reactance X_m(start = 1)=25 "Complex component of the magnetizing reactance";
  parameter Modelica.SIunits.Voltage V_rms = 110;

  Real omega_r;
  Real tau_e;

equation
  omega_r = pi*f/(50*pole)*time;
  tau_e = MotorDevice.Motor.BaseClasses.Functions.TorqueSpeed(
              f=f,
              pole=pole,
              n=n,
              R_s=R_s,
              R_r=R_r,
              X_s=X_s,
              X_r=X_r,
              X_m=X_m,
              V_rms=V_rms,
              omega_r=omega_r);

end TorqueSpeed;
