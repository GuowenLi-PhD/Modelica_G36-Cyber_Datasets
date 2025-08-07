within FaultInjection.Utilities.InsertionTypes.Generic;
record ChillerFaultMode
  extends faultMode;
  parameter Modelica.SIunits.LinearTemperatureCoefficient perChiFau_c23 [2] = {-0.02031,0.03281}
    "Chiller fault coefficient data {c2,c3}";
  parameter Real perChiFau_c1456 [4] = {-4.278,0.6404,0.05028,0}
    "Chiller fault coefficient data {c1,c4,c5,c6}";
  parameter Real fauIntRat( min=0,max=1, unit="1") = 0.1 "Fault intensity ratio";
end ChillerFaultMode;
