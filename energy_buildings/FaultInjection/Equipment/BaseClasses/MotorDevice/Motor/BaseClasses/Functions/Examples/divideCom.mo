within FaultInjection.Equipment.BaseClasses.MotorDevice.Motor.BaseClasses.Functions.Examples;
model divideCom
  extends Modelica.Icons.Example;
  parameter Real x1[1,2]=[1,2];
  parameter Real x2[1,2]=[1,2];

  Real y[1,2];
equation
  y = MotorDevice.Motor.BaseClasses.Functions.divideCom(x1, x2);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end divideCom;
