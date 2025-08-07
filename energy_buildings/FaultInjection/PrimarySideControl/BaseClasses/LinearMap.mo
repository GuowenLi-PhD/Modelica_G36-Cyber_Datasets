within FaultInjection.PrimarySideControl.BaseClasses;
model LinearMap "Ratio function"
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Boolean use_uInpRef1_in = false "True if use outside values for uInpRef1";
  parameter Boolean use_uInpRef2_in = false "True if use outside values for uInpRef2";
  parameter Boolean use_yOutRef1_in = false "True if use outside values for uOutRef1";
  parameter Boolean use_yOutRef2_in = false "True if use outside values for uOutRef2";
  parameter Real uInpRef1= 0 "Minimum limit"
    annotation(Dialog(enable = not use_uInpRef1_in));
  parameter Real uInpRef2= 1 "Maximum limit"
    annotation(Dialog(enable = not use_uInpRef2_in));
  parameter Real yOutRef1= 0 "Minimum limit"
    annotation(Dialog(enable = not use_yOutRef1_in));
  parameter Real yOutRef2= 1 "Maximum limit"
    annotation(Dialog(enable = not use_yOutRef2_in));
  parameter Real dy= 1e-3 "Transition interval";

  Modelica.Blocks.Interfaces.RealInput uInpRef1_in if use_uInpRef1_in "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput uInpRef2_in if use_uInpRef2_in "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  Modelica.Blocks.Interfaces.RealInput yOutRef2_in if use_yOutRef2_in "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  Modelica.Blocks.Interfaces.RealInput yOutRef1_in if use_yOutRef1_in "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

protected
  Real outInt "Intermediate output";
  Modelica.Blocks.Interfaces.RealInput y1;
  Modelica.Blocks.Interfaces.RealInput y2;
  Modelica.Blocks.Interfaces.RealInput u1;
  Modelica.Blocks.Interfaces.RealInput u2;

equation
  connect(u1,uInpRef1_in);
  connect(u2,uInpRef2_in);
  connect(y1,yOutRef1_in);
  connect(y2,yOutRef2_in);

  if not use_uInpRef1_in then
    u1 = uInpRef1;
  end if;
  if not use_uInpRef2_in then
    u2 = uInpRef2;
  end if;
  if not use_yOutRef1_in then
    y1 = yOutRef1;
  end if;
  if not use_yOutRef2_in then
    y2 = yOutRef2;
  end if;

  outInt = y1 + (u - u1)*(y2 - y1)/(u2 - u1);

  y=Buildings.Utilities.Math.Functions.smoothLimit(
               outInt,min(y1,y2),max(y1,y2),dy);

  annotation (defaultComponentName = "linMap",
  Icon(graphics={Text(
        extent={{-98,24},{100,-12}},
        lineColor={238,46,47},
          textString="%name")}));
end LinearMap;
