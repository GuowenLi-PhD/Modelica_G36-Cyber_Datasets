within FaultInjection.Equipment.BaseClasses.MotorDevice.Motor;
model ZIPMotor "ZIP model for motor"
  parameter Real az = -0.47 "Fraction of constant impededance load in active power";
  parameter Real ai = 1.71 "Fraction of constant current load in active power";
  parameter Real ap = -0.24 "Fraction of constant power load in active power";
  parameter Real af = 0.1 "Dependency on frequence";

  parameter Real rz = 2.34 "Fraction of constant impededance load in reactive power";
  parameter Real ri = -3.12 "Fraction of constant current load in reactive power";
  parameter Real rp = 1.78 "Fraction of constant power load in reactive power";
  parameter Real rf= 0.1 "Dependency on frequence";

  parameter Modelica.SIunits.Voltage V_nominal = 120;
  parameter Modelica.SIunits.Power P_nominal = 163.25;
  parameter Modelica.SIunits.ReactivePower Q_nominal = 83.28;
  parameter Modelica.SIunits.Frequency f_nominal = 60;

  parameter Integer pole = 2 "Number of pole pairs";
  parameter Integer n = 3 "Number of phases";
  parameter Modelica.SIunits.Inertia JMotor(min=0) = 0.1 "Moment of inertia";

  Modelica.SIunits.Torque tau_e "Electromagenetic torque of rotor";
  Modelica.SIunits.AngularVelocity omega_s "Synchronous angular velocity";

  BaseClasses.ZIP zip(
    az=az,
    ai=ai,
    ap=ap,
    rz=rz,
    ri=ri,
    rp=rp,
    V_nominal=V_nominal,
    P_nominal=P_nominal,
    Q_nominal=Q_nominal,
    af=af,
    rf=rf,
    f_nominal=f_nominal)
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Modelica.Blocks.Interfaces.RealInput V_rms "Prescribed rms voltage"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput f_in(
    final quantity="Frequency",
    final unit="Hz")
    "Controllale freuqency to the motor"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));

//  Modelica.Blocks.Interfaces.RealOutput tau_e(quantity="Torque", unit="N.m")
//    "Electromagenetic torque"
//    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Modelica.Blocks.Interfaces.RealOutput P "Active power"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput Q "Reactive power"
    annotation (Placement(transformation(extent={{100,16},{120,36}})));
  Modelica.Mechanics.Rotational.Sources.Torque tor
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.RealExpression eleTor(y=tau_e)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Mechanics.Rotational.Components.Inertia motIne(J=JMotor) "Motor inertia"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b
    "Right flange of shaft"
    annotation (Placement(transformation(extent={{94,-10},{114,10}})));
equation

  omega_s = 4*Modelica.Constants.pi*f_in/pole;
  P = tau_e * omega_s;
  connect(zip.V_rms, V_rms)
    annotation (Line(points={{-42,64},{-82,64},{-82,60},{-120,60}},
                                                color={0,0,127}));
  connect(zip.P, P) annotation (Line(points={{-19,66},{80,66},{80,60},{110,60}},
        color={0,0,127}));
  connect(zip.Q, Q) annotation (Line(points={{-19,54},{80,54},{80,26},{110,26}},
        color={0,0,127}));
  connect(eleTor.y, tor.tau)
    annotation (Line(points={{-39,0},{-2,0}}, color={0,0,127}));
  connect(tor.flange, motIne.flange_a)
    annotation (Line(points={{20,0},{40,0}}, color={0,0,0}));
  connect(motIne.flange_b, flange_b)
    annotation (Line(points={{60,0},{104,0}}, color={0,0,0}));
  connect(f_in, zip.f) annotation (Line(points={{-120,-60},{-80,-60},{-80,56},{-42,
          56}}, color={0,0,127}));
  annotation (Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-72,150},{74,114}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="%name")}));
end ZIPMotor;
