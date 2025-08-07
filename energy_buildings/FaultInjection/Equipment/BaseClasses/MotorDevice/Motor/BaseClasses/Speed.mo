within FaultInjection.Equipment.BaseClasses.MotorDevice.Motor.BaseClasses;
model Speed
  "Forced movement of a flange according to a reference angular velocity signal"
  extends
    Modelica.Mechanics.Rotational.Interfaces.PartialElementaryOneFlangeAndSupport2;
  parameter Boolean exact=false
    "true/false exact treatment/filtering the input signal";
  parameter Modelica.SIunits.Frequency f_crit=50
    "if exact=false, critical frequency of filter to filter input signal"
    annotation (Dialog(enable=not exact));
  Modelica.SIunits.Angle phi(
    start=0,
    fixed=true,
    stateSelect=StateSelect.prefer)
    "Rotation angle of flange with respect to support";
  Modelica.SIunits.AngularVelocity w(stateSelect=if exact then StateSelect.default
         else StateSelect.prefer)
    "Angular velocity of flange with respect to support";
  Modelica.SIunits.AngularAcceleration a
    "If exact=false, angular acceleration of flange with respect to support else dummy";
  Modelica.Blocks.Interfaces.RealInput w_ref(unit="rad/s")
    "Reference angular velocity of flange with respect to support as input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

protected
  parameter Modelica.SIunits.AngularFrequency w_crit=2*Modelica.Constants.pi
      *f_crit "Critical frequency";
initial equation
  if not exact then
    w = w_ref;
  end if;
equation
  phi = flange.phi - phi_support;
  w = der(phi);
  if exact then
    w = w_ref;
    a = 0;
  else
    // Filter: a = w_ref/(1 + (1/w_crit)*s)
    a = der(w);
    a = (w_ref - w)*w_crit;
  end if;
  annotation (Documentation(info="<html>
<p>
The input signal <b>w_ref</b> defines the <b>reference
speed</b> in [rad/s]. Flange <b>flange</b> is <b>forced</b>
to move relative to flange support according to this reference motion. According to parameter
<b>exact</b> (default = <b>false</b>), this is done in the following way:
</p>
<ol>
<li><b>exact=true</b><br>
    The reference speed is treated <b>exactly</b>. This is only possible, if
    the input signal is defined by an analytical function which can be
    differentiated at least once. If this prerequisite is fulfilled,
    the Modelica translator will differentiate the input signal once
    in order to compute the reference acceleration of the flange.</li>
<li><b>exact=false</b><br>
    The reference angle is <b>filtered</b> and the second derivative
    of the filtered curve is used to compute the reference acceleration
    of the flange. This second derivative is <b>not</b> computed by
    numerical differentiation but by an appropriate realization of the
    filter. For filtering, a first order filter is used.
    The critical frequency (also called cut-off frequency) of the
    filter is defined via parameter <b>f_crit</b> in [Hz]. This value
    should be selected in such a way that it is higher as the essential
    low frequencies in the signal.</li>
</ol>
<p>
The input signal can be provided from one of the signal generator
blocks of the block library Modelica.Blocks.Sources.
</p>
</html>"),
       Icon(
    coordinateSystem(preserveAspectRatio=true,
      extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
    Rectangle(lineColor={64,64,64},
      fillColor={192,192,192},
      fillPattern=FillPattern.HorizontalCylinder,
      extent={{-100.0,-20.0},{100.0,20.0}}),
    Line(points={{-30.0,-32.0},{30.0,-32.0}}),
    Line(points={{0.0,52.0},{0.0,32.0}}),
    Line(points={{-29.0,32.0},{30.0,32.0}}),
    Line(points={{0.0,-32.0},{0.0,-100.0}}),
    Line(points={{-10.0,-32.0},{-30.0,-52.0}}),
    Line(points={{0.0,-32.0},{-20.0,-52.0}}),
    Line(points={{10.0,-32.0},{-10.0,-52.0}}),
    Line(points={{20.0,-32.0},{0.0,-52.0}}),
    Line(points={{-20.0,-32.0},{-30.0,-42.0}}),
    Line(points={{30.0,-32.0},{10.0,-52.0}}),
    Line(points={{30.0,-42.0},{20.0,-52.0}}),
    Text(extent={{-158.0,-78.0},{-54.0,-44.0}},
      textString="w_ref"),
    Text(lineColor={0,0,255},
      extent={{-0.0,60.0},{0.0,120.0}},
      textString="%name"),
    Text(extent={{30.0,-60.0},{146.0,-26.0}},
      textString="exact="),
    Text(extent={{30.0,-96.0},{146.0,-62.0}},
      textString="%exact")}));
end Speed;
