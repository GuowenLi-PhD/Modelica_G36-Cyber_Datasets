within FaultInjection.Equipment.ParameterFaults;
model FaultWetCoilCounterFlowStoreStateVariables
  "Cooling coil with fouling faults injected to nominal UA"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(show_T=false);
  extends Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters(
    final computeFlowResistance1=false,
    final computeFlowResistance2=false,
    from_dp1=false,
    from_dp2=false);

  parameter Real iniT1[nEle];
  Modelica.SIunits.Temperature outT1[nEle];
  parameter Real iniT2[nEle];
  Modelica.SIunits.Temperature outT2[nEle];
  parameter Real iniTmas[nEle];
  Modelica.SIunits.Temperature outTmas[nEle];
  parameter Real inider_Tmas[nEle];
  Modelica.SIunits.TemperatureSlope outder_Tmas[nEle];
  parameter Real inip_w[nEle];
  Modelica.SIunits.Pressure outp_w[nEle];
  parameter Real inix_w[nEle];
  Modelica.SIunits.MassFraction outx_w[nEle];

  // fault parameters

  parameter Modelica.SIunits.ThermalConductance UA_nominal
    "Thermal conductance at nominal flow, used to compute heat capacity"
    annotation (Dialog(tab="General", group="Nominal condition"));

 // external files

  // other normal parameters
  parameter Real r_nominal=2/3
    "Ratio between air-side and water-side convective heat transfer coefficient"
    annotation (Dialog(group="Nominal condition"));
  parameter Integer nEle(min=1)
    "Number of pipe segments used for discretization"
    annotation (Dialog(group="Geometry"));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Formulation of energy balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  parameter Modelica.SIunits.Time tau1=10
    "Time constant at nominal flow for medium 1"
    annotation (Dialog(group="Nominal condition",
                enable=not (energyDynamics==Modelica.Fluid.Types.Dynamics.SteadyState)));
  parameter Modelica.SIunits.Time tau2=2
    "Time constant at nominal flow for medium 2"
    annotation (Dialog(group="Nominal condition",
                enable=not (energyDynamics==Modelica.Fluid.Types.Dynamics.SteadyState)));
  parameter Modelica.SIunits.Time tau_m=5
    "Time constant of metal at nominal UA value"
    annotation (Dialog(group="Nominal condition"));

  parameter Boolean waterSideFlowDependent=true
    "Set to false to make water-side hA independent of mass flow rate"
    annotation (Dialog(tab="Heat transfer"));
  parameter Boolean airSideFlowDependent=true
    "Set to false to make air-side hA independent of mass flow rate"
    annotation (Dialog(tab="Heat transfer"));
  parameter Boolean waterSideTemperatureDependent=false
    "Set to false to make water-side hA independent of temperature"
    annotation (Dialog(tab="Heat transfer"));
  parameter Boolean airSideTemperatureDependent=false
    "Set to false to make air-side hA independent of temperature"
    annotation (Dialog(tab="Heat transfer"));

  FaultInjection.Equipment.ParameterFaults.BaseClasses.FaultWetCoilCounterFlowStoreStateVariables.WetCoilCounterFlow
    cooCoi(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    m1_flow_small=m1_flow_small,
    m2_flow_small=m2_flow_small,
    show_T=show_T,
    dp1_nominal=dp1_nominal,
    dp2_nominal=dp2_nominal,
    UA_nominal=UA_nominal,
    r_nominal=r_nominal,
    nEle=nEle,
    energyDynamics=energyDynamics,
    tau1=tau1,
    tau2=tau2,
    tau_m=tau_m,
    waterSideFlowDependent=waterSideFlowDependent,
    airSideFlowDependent=airSideFlowDependent,
    waterSideTemperatureDependent=waterSideTemperatureDependent,
    airSideTemperatureDependent=airSideTemperatureDependent,
    iniT1=iniT1,
    iniT2=iniT2,
    iniTmas=iniTmas,
    inider_Tmas=inider_Tmas,
    inip_w=inip_w,
    inix_w=inix_w)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  // states outputs
  outT1=cooCoi.T1;
  outT2=cooCoi.T2;
  outTmas=cooCoi.T_m;
  outder_Tmas=cooCoi.der_T_m;
  outp_w=cooCoi.ele[:].masExc.humRatPre.p_w;
  outx_w=cooCoi.ele[:].masExc.humRatPre.x_w;
  connect(port_a1, cooCoi.port_a1) annotation (Line(points={{-100,60},{-60,60},
          {-60,6},{-10,6}},color={0,127,255}));
  connect(cooCoi.port_b1, port_b1) annotation (Line(points={{10,6},{60,6},{60,
          60},{100,60}},
                     color={0,127,255}));
  connect(cooCoi.port_a2, port_a2) annotation (Line(points={{10,-6},{60,-6},{60,
          -60},{100,-60}}, color={0,127,255}));
  connect(cooCoi.port_b2, port_b2) annotation (Line(points={{-10,-6},{-60,-6},{
          -60,-60},{-100,-60}},
                            color={0,127,255}));
  annotation (defaultComponentName="cooCoi",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{36,80},{40,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,80},{-36,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,80},{2,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-55},{101,-65}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-98,65},{103,55}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{36,80},{40,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,80},{-36,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,80},{2,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-55},{101,-65}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-98,65},{103,55}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-54,70},{56,-64}},
          color={238,46,47},
          thickness=1),
        Line(
          points={{-52,-62},{54,68}},
          color={238,46,47},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end FaultWetCoilCounterFlowStoreStateVariables;
