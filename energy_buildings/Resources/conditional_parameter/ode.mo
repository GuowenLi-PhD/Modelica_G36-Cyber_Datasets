model ode
   parameter Real  a=1;

   Real x(start=0);

equation
   der(x) = a;

end ode;
