within FaultInjection.Equipment.BaseClasses.MotorDevice.Motor.BaseClasses.Functions;
function phasorAdd "Add function for two phasors"
  input Real x1[1,2];
  input Real x2[1,2];
  output Real y[1,2];

protected
  Modelica_LinearSystems2.Math.Complex x1x2;

algorithm

  x1x2 := Modelica.ComplexMath.fromPolar(x1[1,1],x1[1,2]) + Modelica.ComplexMath.fromPolar(x2[1,1],x2[1,2]);
  y[1,1] := Modelica.ComplexMath.'abs'(x1x2);
  y[1,2] := Modelica.ComplexMath.arg(x1x2);

end phasorAdd;
