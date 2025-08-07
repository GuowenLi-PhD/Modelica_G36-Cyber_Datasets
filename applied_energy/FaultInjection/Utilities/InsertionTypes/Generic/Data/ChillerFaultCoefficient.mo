within FaultInjection.Utilities.InsertionTypes.Generic.Data;
record ChillerFaultCoefficient "Generic coefficients describing fault mode"
  extends Modelica.Icons.Record;
  replaceable parameter Real c1 = -4.278 "coefficient c1";
  replaceable parameter Modelica.SIunits.LinearTemperatureCoefficient c2 =  -0.02031 "coefficient c2";
  replaceable parameter Modelica.SIunits.LinearTemperatureCoefficient c3 = 0.03281 "coefficient c3";
  replaceable parameter Real c4 = 0.6404 "coefficient c4";
  replaceable parameter Real c5 = 0.05028 "coefficient c5";
  replaceable parameter Real c6 = 0 "coefficient c6";
    annotation(Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ChillerFaultCoefficient;
