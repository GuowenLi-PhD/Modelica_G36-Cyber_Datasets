within FaultInjection.Equipment.BaseClasses.MotorDevice.Motor.BaseClasses.Functions.Examples;
model phasorAddN "Add for N phasors"
  extends Modelica.Icons.Example;
  import Modelica_LinearSystems2.Math.Complex;

  Complex x1_c=Complex(3,4);
  Complex x2_c=-Complex(3,-4);
  Complex x3_c=-Complex(3,0);

  Real x1[1,2] = [Modelica.ComplexMath.'abs'(x1_c),Modelica.ComplexMath.arg(x1_c)];
  Real x2[1,2] = [Modelica.ComplexMath.'abs'(x2_c),Modelica.ComplexMath.arg(x2_c)];
  Real x3[1,2] = [Modelica.ComplexMath.'abs'(x3_c),Modelica.ComplexMath.arg(x3_c)];

  Real y[1,2];
  Complex y_c;
  Real x[3,2];

equation
  x = [x1;x2;x3];
  y = MotorDevice.Motor.BaseClasses.Functions.phasorAddN(x, 3);
  y_c = Modelica.ComplexMath.fromPolar(y[1,1],y[1,2]);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end phasorAddN;
