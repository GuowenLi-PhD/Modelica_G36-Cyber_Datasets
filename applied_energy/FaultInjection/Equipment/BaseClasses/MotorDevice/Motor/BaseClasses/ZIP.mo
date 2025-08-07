within FaultInjection.Equipment.BaseClasses.MotorDevice.Motor.BaseClasses;
model ZIP "ZIP model for motor"
  parameter Real az "Fraction of constant impededance load in active power";
  parameter Real ai "Fraction of constant current load in active power";
  parameter Real ap "Fraction of constant power load in active power";
  parameter Real af "Dependency on frequence";

  parameter Real rz "Fraction of constant impededance load in reactive power";
  parameter Real ri "Fraction of constant current load in reactive power";
  parameter Real rp "Fraction of constant power load in reactive power";
  parameter Real rf "Dependency on frequence";
  parameter Modelica.SIunits.Voltage V_nominal;
  parameter Modelica.SIunits.Power P_nominal;
  parameter Modelica.SIunits.ReactivePower Q_nominal;
  parameter Modelica.SIunits.Frequency f_nominal;

  Modelica.Blocks.Interfaces.RealInput V_rms(unit="V") "Prescribed rms voltage"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40}),
                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40})));
  Modelica.Blocks.Interfaces.RealInput f(unit="Hz") "Prescribed frequency"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-40}),
                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-40})));
  Modelica.Blocks.Interfaces.RealOutput P(quantity = "Power",unit="W")
    "Active power"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput Q(quantity = "Power",unit="var")
    "Reactive power"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

protected
  Real vpu "Voltage per unit";

initial equation
  assert(abs(az+ai+ap-1)<1E-5,"Sum of ZIP coefficients for active power should be 1",level = AssertionLevel.error);
  assert(abs(rz+ri+rp-1)<1E-5,"Sum of ZIP coefficients for reactive power should be 1",level = AssertionLevel.error);

equation
  vpu = V_rms/V_nominal;
  // zip for active power
  P = if noEvent(V_rms>0 and f>0) then P_nominal*(az*vpu^2 + ai*vpu + ap)*(1+af*(f-f_nominal)) else 0;
  // zip for reactive power
  Q = if noEvent(V_rms>0 and f>0) then Q_nominal*(rz*vpu^2 + ri*vpu + rp)*(1+rf*(f-f_nominal)) else 0;

  annotation (defaultComponentName = "zip",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-72,150},{74,114}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Steady-state power calculation for electric load. This load model cannot reflect the power changes according to variables other than voltage, 
which is not suitable for the estimation of power consumption in HVAC system.
</p>
</html>"));
end ZIP;
