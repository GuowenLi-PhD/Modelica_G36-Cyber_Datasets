within FaultInjection.Utilities.SignalExchange;
record OverwriteParameter
  "Record that contains overwritten parameters"
  extends Modelica.Icons.Record;
  parameter Real p
    "Parameter passed to simulation";
  parameter String description = " "
    "Description that decribes the overwritten parameter";

protected
  final parameter Boolean mtiOverwriteParameter=true
    "Protected parameter, only used by the parser to search for overwrite block in models";

    annotation(defaultComponentName = "ovePar");
end OverwriteParameter;
