within FaultInjection.Utilities.Overwrite;
record OverwriteParameter
  "Record that contains overwritten parameters"
  extends Modelica.Icons.Record;
  parameter Real p_min;
  parameter Real p_max;
  parameter String unit;
  parameter Real p(min=p_min, max=p_max, unit=unit)
    "Parameter passed to simulation";
  parameter String description = " "
    "Description that decribes the overwritten parameter";

protected
  final parameter Boolean mtiOverwriteParameter=true
    "Protected parameter, only used by the parser to search for overwrite block in models";

    annotation(defaultComponentName = "ovePar");
end OverwriteParameter;
