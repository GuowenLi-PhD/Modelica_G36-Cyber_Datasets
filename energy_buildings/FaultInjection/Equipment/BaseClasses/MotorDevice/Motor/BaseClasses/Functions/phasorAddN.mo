within FaultInjection.Equipment.BaseClasses.MotorDevice.Motor.BaseClasses.Functions;
function phasorAddN "Add function for n phasors"
  input Real x[n,2];
  input Integer n;
  output Real y[1,2];

protected
  Modelica_LinearSystems2.Math.Complex xn = 0 + 0*Modelica.ComplexMath.j;
  Integer l;
  Complex xn_n[n];

algorithm

  for i in 1:n loop
    xn_n[i] := Modelica.ComplexMath.fromPolar(x[i,1],x[i,2]);
  end for;
  xn :=Complex(sum(xn_n[:].re), sum(xn_n[:].im));

  y[1,1] := Modelica.ComplexMath.'abs'(xn);
  y[1,2] := Modelica.ComplexMath.arg(xn);

end phasorAddN;
