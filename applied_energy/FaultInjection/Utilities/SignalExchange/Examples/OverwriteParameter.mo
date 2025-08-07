within FaultInjection.Utilities.SignalExchange.Examples;
model OverwriteParameter
  extends Modelica.Icons.Example;
  parameter Real a = ovePar.p;

  Real x;

  FaultInjection.Utilities.SignalExchange.OverwriteParameter ovePar(p(
      min=0,
      max=20,
      unit="1") = 10,
                 description="parameter a")
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
equation
  der(x) = a;

end OverwriteParameter;
