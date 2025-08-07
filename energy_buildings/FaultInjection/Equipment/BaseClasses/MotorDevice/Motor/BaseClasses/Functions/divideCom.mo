within FaultInjection.Equipment.BaseClasses.MotorDevice.Motor.BaseClasses.Functions;
function divideCom
  input Real x1[1,2];
  input Real x2[1,2];
  output Real y[1,2];

protected
  Real x2_cj[1,2] = [x2[1,1],-x2[1,2]];
algorithm

  y := 1/(x2[1, 1]^2 + x2[1, 2]^2)*
    MotorDevice.Motor.BaseClasses.Functions.productCom([x1; x2_cj], 2);

end divideCom;
