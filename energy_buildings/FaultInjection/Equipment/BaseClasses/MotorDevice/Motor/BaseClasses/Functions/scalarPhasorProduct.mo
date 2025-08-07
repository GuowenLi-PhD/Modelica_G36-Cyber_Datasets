within FaultInjection.Equipment.BaseClasses.MotorDevice.Motor.BaseClasses.Functions;
function scalarPhasorProduct "Product function for a phasor"
  input Real x1;
  input Real x2[1,2];
  output Real y[1,2];

algorithm
  y[1,1] := x1*x2[1,1];
  y[1,2] := x2[1,2];

end scalarPhasorProduct;
