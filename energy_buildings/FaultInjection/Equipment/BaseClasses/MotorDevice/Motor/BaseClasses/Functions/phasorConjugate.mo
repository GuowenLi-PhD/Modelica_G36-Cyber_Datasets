within FaultInjection.Equipment.BaseClasses.MotorDevice.Motor.BaseClasses.Functions;
function phasorConjugate
  input Real x[1,2];
  output Real y[1,2];

algorithm
  y[1,1] := x[1,1];
  y[1,2] := -x[1,2];

end phasorConjugate;
