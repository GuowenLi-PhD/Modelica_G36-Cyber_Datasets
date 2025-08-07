within FaultInjection.Equipment.BaseClasses.MotorDevice.Motor.BaseClasses.Functions;
function productCom "Product of complex number"
  input Real x[n,2];
  input Integer n;
  output Real y[1,2]=[0,0];

protected
  Real x_it[1,2];
  Real y_it[1,2];

algorithm

  y_it :=array(x[1,:]);
  x_it :=array(x[1,:]);
  for i in 1:n loop
    if i>=2 then
    x_it := array(x[i,:]);
    y[1,1] := x_it[1,1]*y_it[1,1] - x_it[1,2]*y_it[1,2];
    y[1,2] := x_it[1,1]*y_it[1,2] + x_it[1,2]*y_it[1,1];
    y_it :=y;
    else
      y := y_it;

    end if;
  end for;

end productCom;
