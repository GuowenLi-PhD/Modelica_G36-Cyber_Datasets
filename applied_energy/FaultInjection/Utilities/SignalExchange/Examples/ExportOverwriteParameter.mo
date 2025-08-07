within FaultInjection.Utilities.SignalExchange.Examples;
model ExportOverwriteParameter "Test for generating a wrapper"
  parameter Real ovePar_p(min=0,max=20,unit="1")=3;

  FaultInjection.Utilities.SignalExchange.Examples.OverwriteParameter mod(
    ovePar(p=ovePar_p))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

end ExportOverwriteParameter;
