within FaultInjection.Equipment.BaseClasses.MotorDevice.Motor.BaseClasses.Functions.Examples;
model productCom
  extends Modelica.Icons.Example;
  parameter Real x1[1,2]=[1,2];
  parameter Real x2[1,2]=[1,-2];

  Real y[1,2];
equation
  y = MotorDevice.Motor.BaseClasses.Functions.productCom([x1; x2], 2);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end productCom;
