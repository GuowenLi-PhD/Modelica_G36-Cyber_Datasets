within FaultInjection.Equipment.BaseClasses.MotorDevice.LoadDevice;
model MechanicalPump
  "Fan or pump with ideally controlled speed Nrpm as input signal"
  extends Buildings.Fluid.Interfaces.PartialTwoPort(
  port_a(p(start=Medium.p_default)),
  port_b(p(start=Medium.p_default)));

  Modelica.SIunits.Angle phi "Shaft angle";
  Modelica.SIunits.AngularVelocity omega "Shaft angular velocity";
  Real Nrpm "Rational speed";

  Modelica.Mechanics.Rotational.Interfaces.Flange_b shaft
  annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  SpeedControlled_Nrpm pum(
    redeclare package Medium = Medium,
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    final addPowerToMedium=addPowerToMedium,
    per=per,
    final use_inputFilter=false)
    "Pump model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.RealExpression rotSpe(y=Nrpm) "Rotation speed"
    annotation (Placement(transformation(extent={{-40,36},{-20,56}})));

  parameter Boolean addPowerToMedium=true
    "Set to false to avoid any power (=heat and flow work) being added to medium (may give simpler equations)";

  replaceable parameter Buildings.Fluid.Movers.Data.Generic per
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{52,60},{72,80}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat dissipation to environment"
    annotation (Placement(transformation(extent={{-70,-110},{-50,-90}}),
        iconTransformation(extent={{-10,-78},{10,-58}})));
equation
  phi = shaft.phi;
  omega = der(phi);
  Nrpm = Modelica.SIunits.Conversions.to_rpm(omega);

  //pum.eff.PEle = omega^2*shaft.tau*Buildings.Utilities.Math.Functions.smoothMax(omega,1e-6,1e-8);
  pum.eff.PEle = shaft.tau*Buildings.Utilities.Math.Functions.smoothMax(omega,1e-6,1e-8);

  connect(rotSpe.y, pum.Nrpm)
    annotation (Line(points={{-19,46},{0,46},{0,12}}, color={0,0,127}));
  connect(port_a, pum.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(pum.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(pum.heatPort, heatPort) annotation (Line(points={{0,-6.8},{0,-70},{
          -60,-70},{-60,-100}}, color={191,0,0}));
  annotation (defaultComponentName="pump",
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-100,16},{100,-14}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
            Text(
              extent={{26,136},{124,114}},
          textString="Nrpm [rpm]",
          lineColor={0,0,127}),
        Rectangle(
          visible=use_inputFilter,
          extent={{-34,40},{32,100}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          visible=use_inputFilter,
          extent={{-34,100},{32,40}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          visible=use_inputFilter,
          extent={{-22,92},{20,46}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="M",
          textStyle={TextStyle.Bold}),
        Ellipse(
          extent={{-58,50},{54,-58}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{0,50},{0,-56},{54,2},{0,50}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Ellipse(
          extent={{4,14},{34,-16}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          visible=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState,
          fillColor={0,100,199})}),
    Documentation(info="<html>
This model describes a fan or pump with prescribed speed in revolutions per minute.
The head is computed based on the performance curve that take as an argument
the actual volume flow rate divided by the maximum flow rate and the relative
speed of the fan.
The efficiency of the device is computed based
on the efficiency curves that take as an argument
the actual volume flow rate divided by the maximum possible volume flow rate, or
based on the motor performance curves.
<br/>
<p>
See the
<a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">
User's Guide</a> for more information.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 24, 2017, by Michael Wetter:<br/>
Renamed <code>filteredSpeed</code> to <code>use_inputFilter</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/665\">#665</a>.
</li>
<li>
March 2, 2016, by Filip Jorissen:<br/>
Refactored model such that it directly extends <code>PartialFlowMachine</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/417\">#417</a>.
</li>
<li>
February 17, 2016, by Michael Wetter:<br/>
Updated parameter names for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/396\">#396</a>.
</li>
<li>
January 19, 2016, by Filip Jorissen:<br/>
Set default value of parameter: <code>speeds=per.speeds</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/396\">#396</a>.
</li>
<li>
April 2, 2015, by Filip Jorissen:<br/>
Added code for supporting stage input and constant input.
</li>
<li>
March 6, 2015, by Michael Wetter<br/>
Made performance record <code>per</code> replaceable
as for the other models.
</li>
<li>
January 6, 2015, by Michael Wetter:<br/>
Revised model for OpenModelica.
</li>
<li>
April 17, 2014, by Filip Jorissen:<br/>
Implemented records for supplying pump/fan parameters
</li>
<li>
February 14, 2012, by Michael Wetter:<br/>
Added filter for start-up and shut-down transient.
</li>
<li>
May 25, 2011, by Michael Wetter:<br/>
Revised implementation of energy balance to avoid having to use conditionally removed models.
</li>
<li>
July 27, 2010, by Michael Wetter:<br/>
Redesigned model to fix bug in medium balance.
</li>
<li>March 24, 2010, by Michael Wetter:<br/>
Revised implementation to allow zero flow rate.
</li>
<li>October 1, 2009,
    by Michael Wetter:<br/>
       Model added to the Buildings library.
</li>
<li><i>31 Oct 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br/>
       Model added to the Fluid library</li>
</ul>
</html>"));
end MechanicalPump;
