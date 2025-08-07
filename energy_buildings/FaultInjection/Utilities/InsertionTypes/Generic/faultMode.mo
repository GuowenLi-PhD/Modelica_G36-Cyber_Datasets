within FaultInjection.Utilities.InsertionTypes.Generic;
record faultMode "Parameters describing fault mode"
  extends Modelica.Icons.Record;

  parameter Boolean active = false "Fault is active";
  parameter Modelica.SIunits.Time startTime "Fault start time";
  parameter Boolean lastForever = false "Fault lasts forever";
  parameter Modelica.SIunits.Time endTime "Fault end time";
  parameter Real minimum = 0 "Lower bound of faulty signal. Assume that signal exceeds the min-max bounds will be easily detected";
  parameter Real maximum = 1e6 "Upper bound of faulty signal. Assume that signal exceeds the min-max bounds will be easily detected";

    annotation(Dialog(enable = not lastForever,group="Fixed inputs"),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end faultMode;
