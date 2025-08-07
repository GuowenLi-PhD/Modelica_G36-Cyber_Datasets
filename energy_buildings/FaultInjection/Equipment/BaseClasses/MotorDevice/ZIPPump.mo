within FaultInjection.Equipment.BaseClasses.MotorDevice;
model ZIPPump "ZIP motor with a pump/fan model"
  extends Buildings.Fluid.Interfaces.PartialTwoPort(
  port_a(p(start=Medium.p_default)),
  port_b(p(start=Medium.p_default)));

  parameter Real az = -0.47 "Fraction of constant impededance load in active power";
  parameter Real ai = 1.71 "Fraction of constant current load in active power";
  parameter Real ap = -0.24 "Fraction of constant power load in active power";
  parameter Real af=0.1 "Dependency on frequence";

  parameter Real rz = 2.34 "Fraction of constant impededance load in reactive power";
  parameter Real ri = -3.12 "Fraction of constant current load in reactive power";
  parameter Real rp = 1.78 "Fraction of constant power load in reactive power";
  parameter Real rf=0.1 "Dependency on frequence";

  parameter Modelica.SIunits.Voltage V_nominal = 120;
  parameter Modelica.SIunits.Power P_nominal = 163.25;
  parameter Modelica.SIunits.ReactivePower Q_nominal = 83.28;
  parameter Modelica.SIunits.Frequency f_nominal=60;

  parameter Integer pole=2 "Number of pole pairs";
  parameter Integer n=3 "Number of phases";
  parameter Modelica.SIunits.Inertia JMotor = 0.1 "Moment of inertia";
  parameter Modelica.SIunits.Inertia JLoad = 0.03 "Moment of inertia";
  parameter Boolean addPowerToMedium = true
    "Set to false to avoid any power (=heat and flow work) being added to medium (may give simpler equations)";

  Motor.ZIPMotor zipMot(
    az=az,
    ai=ai,
    ap=ap,
    rz=rz,
    ri=ri,
    rp=rp,
    V_nominal=V_nominal,
    P_nominal=P_nominal,
    Q_nominal=Q_nominal,
    pole=pole,
    n=n,
    JMotor=JMotor,
    f_nominal=f_nominal,
    af=af,
    rf=rf)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Mechanics.Rotational.Components.Inertia loaInt(J=JLoad)
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  LoadDevice.MechanicalPump pum(
    redeclare package Medium = Medium,
    addPowerToMedium=addPowerToMedium,
    per=per) "Mechanical pump with a shaft port"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Interfaces.RealInput f_in(final quantity="Frequency", final
      unit="Hz")
    "Controllale freuqency to the motor"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-90,120})));
  Modelica.Blocks.Interfaces.RealInput V_rms "Prescribed rms voltage"
    annotation (Placement(transformation(extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,120})));
  Modelica.Blocks.Interfaces.RealOutput P "Active power"
    annotation (Placement(transformation(extent={{100,64},{120,84}})));
  Modelica.Blocks.Interfaces.RealOutput Q "Reactive power"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  replaceable parameter Buildings.Fluid.Movers.Data.Generic per
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{60,80},{80,100}})));

equation
  connect(zipMot.flange_b, loaInt.flange_a)
    annotation (Line(points={{-39.6,50},{0,50}}, color={0,0,0}));
  connect(loaInt.flange_b, pum.shaft)
    annotation (Line(points={{20,50},{50,50},{50,10}}, color={0,0,0}));
  connect(port_a, pum.port_a)
    annotation (Line(points={{-100,0},{40,0}}, color={0,127,255}));
  connect(pum.port_b, port_b)
    annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
  connect(f_in, zipMot.f_in)
    annotation (Line(points={{-90,120},{-90,44},{-62,44}}, color={0,0,127}));
  connect(V_rms, zipMot.V_rms) annotation (Line(points={{0,120},{0,80},{-80,80},
          {-80,56},{-62,56}}, color={0,0,127}));
  connect(zipMot.P, P) annotation (Line(points={{-39,56},{-20,56},{-20,74},{110,
          74}}, color={0,0,127}));
  connect(zipMot.Q, Q) annotation (Line(points={{-39,52.6},{-16,52.6},{-16,70},{
          90,70},{90,40},{110,40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ZIPPump;
