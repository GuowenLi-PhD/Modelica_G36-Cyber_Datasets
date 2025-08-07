within FaultInjection.Equipment.BaseClasses.MotorDevice.LoadDevice;
model MechanicalChiller
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    m1_flow_nominal = QCon_flow_nominal/cp1_default/dTCon_nominal,
    m2_flow_nominal = QEva_flow_nominal/cp2_default/dTEva_nominal);

 parameter Modelica.SIunits.HeatFlowRate QEva_flow_nominal(max=0)= -P_nominal * COP_nominal
    "Nominal cooling heat flow rate (QEva_flow_nominal < 0)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.HeatFlowRate QCon_flow_nominal(min=0)= P_nominal - QEva_flow_nominal
    "Nominal heating flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.TemperatureDifference dTEva_nominal(
    final max=0) = -10 "Temperature difference evaporator outlet-inlet"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.TemperatureDifference dTCon_nominal(
    final min=0) = 10 "Temperature difference condenser outlet-inlet"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.Power P_nominal(min=0)
    "Nominal compressor power (at y=1)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm Nrpm_nominal=1500
    "Nominal rotational speed for flow characteristic"
    annotation (Dialog(group="Nominal condition"));
 // Efficiency
  parameter Boolean use_eta_Carnot_nominal = true
    "Set to true to use Carnot effectiveness etaCarnot_nominal rather than COP_nominal"
    annotation(Dialog(group="Efficiency"));
  parameter Real etaCarnot_nominal(unit="1") = COP_nominal/
    (TUseAct_nominal/(TCon_nominal+TAppCon_nominal - (TEva_nominal-TAppEva_nominal)))
    "Carnot effectiveness (=COP/COP_Carnot) used if use_eta_Carnot_nominal = true"
    annotation (Dialog(group="Efficiency", enable=use_eta_Carnot_nominal));

  parameter Real COP_nominal(unit="1") = etaCarnot_nominal*TUseAct_nominal/
    (TCon_nominal+TAppCon_nominal - (TEva_nominal-TAppEva_nominal))
    "Coefficient of performance at TEva_nominal and TCon_nominal, used if use_eta_Carnot_nominal = false"
    annotation (Dialog(group="Efficiency", enable=not use_eta_Carnot_nominal));

  parameter Modelica.SIunits.Temperature TCon_nominal = 303.15
    "Condenser temperature used to compute COP_nominal if use_eta_Carnot_nominal=false"
    annotation (Dialog(group="Efficiency", enable=not use_eta_Carnot_nominal));
  parameter Modelica.SIunits.Temperature TEva_nominal = 278.15
    "Evaporator temperature used to compute COP_nominal if use_eta_Carnot_nominal=false"
    annotation (Dialog(group="Efficiency", enable=not use_eta_Carnot_nominal));

  parameter Real a[:] = {1}
    "Coefficients for efficiency curve (need p(a=a, yPL=1)=1)"
    annotation (Dialog(group="Efficiency"));

  parameter Modelica.SIunits.Pressure dp1_nominal(displayUnit="Pa")
    "Pressure difference over condenser"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Pressure dp2_nominal(displayUnit="Pa")
    "Pressure difference over evaporator"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.TemperatureDifference TAppCon_nominal(min=0) = if cp1_default < 1500 then 5 else 2
    "Temperature difference between refrigerant and working fluid outlet in condenser"
    annotation (Dialog(group="Efficiency"));

  parameter Modelica.SIunits.TemperatureDifference TAppEva_nominal(min=0) = if cp2_default < 1500 then 5 else 2
    "Temperature difference between refrigerant and working fluid outlet in evaporator"
    annotation (Dialog(group="Efficiency"));

protected
  constant Boolean COP_is_for_cooling = true
    "Set to true if the specified COP is for cooling";
  final parameter Modelica.SIunits.Temperature TUseAct_nominal=
    if COP_is_for_cooling
      then TEva_nominal - TAppEva_nominal
      else TCon_nominal + TAppCon_nominal
    "Nominal evaporator temperature for chiller or condenser temperature for heat pump, taking into account pinch temperature between fluid and refrigerant";

    final parameter Modelica.SIunits.SpecificHeatCapacity cp1_default=
    Medium1.specificHeatCapacityCp(Medium1.setState_pTX(
      p = Medium1.p_default,
      T = Medium1.T_default,
      X = Medium1.X_default))
    "Specific heat capacity of medium 1 at default medium state";

  final parameter Modelica.SIunits.SpecificHeatCapacity cp2_default=
    Medium2.specificHeatCapacityCp(Medium2.setState_pTX(
      p = Medium2.p_default,
      T = Medium2.T_default,
      X = Medium2.X_default))
    "Specific heat capacity of medium 2 at default medium state";
  Buildings.Fluid.Chillers.Carnot_y chi(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dTEva_nominal=dTEva_nominal,
    dTCon_nominal=dTCon_nominal,
    use_eta_Carnot_nominal=use_eta_Carnot_nominal,
    etaCarnot_nominal=etaCarnot_nominal,
    COP_nominal=COP_nominal,
    TCon_nominal=TCon_nominal,
    TEva_nominal=TEva_nominal,
    a=a,
    dp1_nominal=dp1_nominal,
    dp2_nominal=dp2_nominal,
    TAppCon_nominal=TAppCon_nominal,
    TAppEva_nominal=TAppEva_nominal,
    P_nominal=P_nominal)
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  Modelica.Blocks.Sources.RealExpression rotSpe(y=Nrpm/Nrpm_nominal)
    "Rotation speed"
    annotation (Placement(transformation(extent={{-60,42},{-40,62}})));

equation

  chi.P = omega*shaft.tau;

  connect(rotSpe.y, chi.y) annotation (Line(points={{-39,52},{-30,52},{-30,9},{-14,
          9}}, color={0,0,127}));
  connect(port_a1, chi.port_a1) annotation (Line(points={{-100,60},{-68,60},{-68,
          6},{-12,6}}, color={0,127,255}));
  connect(port_b2, chi.port_b2) annotation (Line(points={{-100,-60},{-66,-60},{-66,
          -6},{-12,-6}}, color={0,127,255}));
  connect(chi.port_a2, port_a2) annotation (Line(points={{8,-6},{40,-6},{40,-60},
          {100,-60}}, color={0,127,255}));
  connect(chi.port_b1, port_b1) annotation (Line(points={{8,6},{40,6},{40,60},{100,
          60}}, color={0,127,255}));
  annotation (defaultComponentName = "mecChi",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end MechanicalChiller;
