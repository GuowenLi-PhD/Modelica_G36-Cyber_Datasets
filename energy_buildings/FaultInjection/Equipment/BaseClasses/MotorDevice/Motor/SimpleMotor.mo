within FaultInjection.Equipment.BaseClasses.MotorDevice.Motor;
model SimpleMotor "Simple motor without electrical implimentation"
  extends Modelica.Icons.MotorIcon;

  parameter Integer pole = 4 "Number of pole pairs";
  parameter Integer n = 3 "Number of phases";
  parameter Modelica.SIunits.Inertia J(min=0) = 2 "Moment of inertia";

  parameter Modelica.SIunits.Resistance R_s=0.013 "Electric resistance of stator";
  parameter Modelica.SIunits.Resistance R_r=0.009 "Electric resistance of rotor";
  parameter Modelica.SIunits.Reactance X_s=0.14 "Complex component of the impedance of stator";
  parameter Modelica.SIunits.Reactance X_r=0.12 "Complex component of the impedance of rotor";
  parameter Modelica.SIunits.Reactance X_m=2.4 "Complex component of the magnetizing reactance";

  Modelica.SIunits.Torque tau_e "Electromagenetic torque of rotor";
  Modelica.SIunits.Power pow_gap "Air gap power";

  Modelica.Blocks.Interfaces.RealInput V_rms(unit="V") "Prescribed phase RMS voltage"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40}),
                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40})));
  Modelica.Blocks.Interfaces.RealInput tau_m(unit="N.m")
    "Prescribed rotational speed"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-40}),
                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-40})));
  Modelica.Blocks.Interfaces.RealOutput omega_r(start=0)
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  BaseClasses.TorqueSpeedCharacteristics torSpe(
    pole=pole,
    n=n,
    R_s=R_s,
    R_r=R_r,
    X_s=X_s,
    X_r=X_r,
    X_m=X_m)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.RealExpression w_r(y=omega_r)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  Modelica.Blocks.Interfaces.RealInput f_in(
    final quantity="Frequency",
    final unit="Hz")
    "Controllale freuqency to the motor"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.SIunits.Resistance Req "Equivelant resistance";
  Modelica.SIunits.Reactance Xeq "Equivelant reactance";
  Real s(min=0,max=1) "Motor slip";

  Modelica.Blocks.Interfaces.RealOutput P(
    quantity = "Power",
    unit = "W")
    "Real power"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealOutput Q(
    quantity = "Power",
    unit = "W")
    "Reactive power"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
equation
  s = torSpe.s;
  tau_e = torSpe.tau_e;
  der(omega_r) = (tau_e-tau_m)/J;
  // constraint the solution of the speed of rotor

  pow_gap = torSpe.omega_s*tau_e;
  // add equations for calculate power
  Req = R_s + R_r*s*X_m^2/(R_r^2+(s^2)*(X_r+X_m)^2);
  Xeq = X_s + X_m*(R_r^2+(s*X_r)^2+(s^2)*X_r*X_m)/(R_r^2+(s^2)*(X_r+X_m)^2);

  P = if noEvent(torSpe.omega_s>0) then n*V_rms^2*Req/(Req^2+Xeq^2) else 0;
  Q = if noEvent(torSpe.omega_s>0) then n*V_rms^2*Xeq/(Req^2+Xeq^2) else 0;

  connect(V_rms, torSpe.V_rms) annotation (Line(points={{-120,40},{-44,40},{-44,
          4},{-12,4}}, color={0,0,127}));
  connect(w_r.y, torSpe.omega_r) annotation (Line(points={{-39,-20},{-26,-20},{-26,
          -4},{-12,-4}}, color={0,0,127}));

  connect(torSpe.f, f_in)
    annotation (Line(points={{-12,0},{-120,0}}, color={0,0,127}));
  annotation(defaultComponentName="simMot", Icon(graphics={
                                          Text(
          extent={{-118,160},{46,114}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="%name")}));
end SimpleMotor;
