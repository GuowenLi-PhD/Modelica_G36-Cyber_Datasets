within FaultInjection.Equipment.BaseClasses.MotorDevice;
model DoubleCagePump
  import Modelica.Constants.pi;
  extends Buildings.Fluid.Interfaces.PartialTwoPort(
  port_a(p(start=Medium.p_default)),
  port_b(p(start=Medium.p_default)));

  Motor.DoubleCage  douCagIM(
    rs=rs,
    lls=lls,
    lm=lm,
    rr=rr,
    llr=llr,
    wref=wref,
    H=H,
    Pbase=Pbase,
    Kfric=Kfric)             annotation (Placement(transformation(extent={{-42,40},
            {-22,60}})));
  parameter Modelica.SIunits.Frequency f_base=60 "Frequency of the source";
  parameter Modelica.SIunits.Torque Tm_nominal = 36.5;
  parameter Integer pole = 4 "Number of pole pairs";

  Modelica.Blocks.Sources.RealExpression loaTorExp(y=pum.shaft.tau)
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Modelica.Mechanics.Rotational.Sources.Speed spe(f_crit=f_base, exact=true)
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Modelica.Blocks.Interfaces.RealInput f_in(
    final quantity="Frequency",
    final unit="Hz")
    "Controllale freuqency to the motor"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-80,120})));
  LoadDevice.MechanicalPump pum(
    redeclare package Medium = Medium,
    addPowerToMedium=addPowerToMedium,
    per=per) "Mechanical pump with a shaft port"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  parameter Boolean addPowerToMedium=true
    "Set to false to avoid any power (=heat and flow work) being added to medium (may give simpler equations)";

  replaceable parameter Buildings.Fluid.Movers.Data.Generic per
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{52,60},{72,80}})));
  Modelica.Blocks.Interfaces.RealOutput P(quantity="Power",unit="W")
    "Real power"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealOutput Q "Reactive power"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealInput Vas[1,2](final quantity="Voltage",
      final unit="V")
    "Supply voltage, complex number [1]: real, [2]:image, pu"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput Vbs[1,2](final quantity="Voltage",
      final unit="V")
    "Supply voltage, complex number [1]: real, [2]:image, pu"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Modelica.Blocks.Interfaces.RealInput Vcs[1,2](final quantity="Voltage",
      final unit="V")
    "Supply voltage, complex number [1]: real, [2]:image, pu"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Math.Gain ws_pu(k=1/f_base)
    annotation (Placement(transformation(extent={{-72,70},{-52,90}})));
  parameter Real rs=0.01;
  parameter Real lls=0.1;
  parameter Real lm=3;
  parameter Real rr=0.005;
  parameter Real llr=0.08;
  parameter Real wref=0 "Reference frame rotation speed,pu";
  parameter Real H=0.4;
  parameter Real Pbase=30000 "Motor base power";
  parameter Real Kfric=0 "Friction, pu";
  Modelica.Blocks.Sources.Constant const(k=4*pi/pole)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Math.Product ws_gain
    annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));
  Modelica.Blocks.Math.Product wr_gain
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Math.Gain Tl_pu(k=1/Tm_nominal)
    annotation (Placement(transformation(extent={{-72,-70},{-52,-50}})));
  Modelica.Blocks.Interfaces.RealOutput Sas[1,2](each quantity="Power", each
      unit="VA")
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.RealOutput Sbs[1,2](each quantity="Power", each
      unit="VA")
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput Scs[1,2](each quantity="Power", each
      unit="VA")
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
equation

  connect(port_a, pum.port_a)
    annotation (Line(points={{-100,0},{60,0}}, color={0,127,255}));
  connect(pum.port_b, port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(spe.flange, pum.shaft)
    annotation (Line(points={{60,40},{70,40},{70,10}},  color={0,0,0}));
  connect(douCagIM.f, f_in)
    annotation (Line(points={{-44,50},{-80,50},{-80,120}}, color={0,0,127}));
  connect(Vas, douCagIM.Vas) annotation (Line(points={{-120,60},{-82,60},{-82,
          59},{-44,59}},
                     color={0,0,127}));
  connect(Vbs, douCagIM.Vbs) annotation (Line(points={{-120,20},{-84,20},{-84,
          56},{-44,56}},
                     color={0,0,127}));
  connect(Vcs, douCagIM.Vcs) annotation (Line(points={{-120,-20},{-84,-20},{-84,
          53},{-44,53}},
                     color={0,0,127}));
  connect(douCagIM.Pmotor, P) annotation (Line(points={{-21,56},{-12,56},{-12,
          98},{90,98},{90,80},{110,80}},
                     color={0,0,127}));
  connect(douCagIM.Qmotor, Q) annotation (Line(points={{-21,54},{-10,54},{-10,96},
          {88,96},{88,60},{110,60}},
                     color={0,0,127}));
  connect(ws_pu.y, douCagIM.ws) annotation (Line(points={{-51,80},{-50,80},{-50,
          47},{-44,47}}, color={0,0,127}));
  connect(f_in, ws_pu.u)
    annotation (Line(points={{-80,120},{-80,80},{-74,80}}, color={0,0,127}));
  connect(f_in, ws_gain.u1) annotation (Line(points={{-80,120},{-80,-38},{-42,-38},
          {-42,-84},{-22,-84}}, color={0,0,127}));
  connect(const.y, ws_gain.u2) annotation (Line(points={{-79,-90},{-60,-90},{-60,
          -96},{-22,-96}}, color={0,0,127}));
  connect(douCagIM.omega_r, wr_gain.u1) annotation (Line(points={{-21,52},{-8,
          52},{-8,56},{-2,56}},
                              color={0,0,127}));
  connect(ws_gain.y, wr_gain.u2) annotation (Line(points={{1,-90},{10,-90},{10,
          20},{-6,20},{-6,44},{-2,44}},
                                      color={0,0,127}));
  connect(wr_gain.y, spe.w_ref) annotation (Line(points={{21,50},{32,50},{32,40},
          {38,40}}, color={0,0,127}));
  connect(loaTorExp.y, Tl_pu.u)
    annotation (Line(points={{-79,-60},{-74,-60}}, color={0,0,127}));
  connect(Tl_pu.y, douCagIM.Tl) annotation (Line(points={{-51,-60},{-44,-60},{
          -44,-40},{-78,-40},{-78,43},{-44,43}},
                                             color={0,0,127}));
  connect(douCagIM.Sas, Sas) annotation (Line(points={{-21,48},{-8,48},{-8,-20},
          {110,-20}}, color={0,0,127}));
  connect(douCagIM.Sbs, Sbs) annotation (Line(points={{-21,46},{-10,46},{-10,
          -40},{110,-40}}, color={0,0,127}));
  connect(douCagIM.Scs, Scs) annotation (Line(points={{-21,44},{-12,44},{-12,
          -60},{110,-60}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Defaulted parameters are from the reference listed as follows.
</p>
<h4>
Reference
</h4>
<p>
<uo>
<li>
Price, W. W., C. W. Taylor, and G. J. Rogers. \"Standard load models for power flow and dynamic performance simulation.\" IEEE Transactions on power systems 10, no. CONF-940702- (1995).
</li>
</uo>
</p>
</html>"));
end DoubleCagePump;
