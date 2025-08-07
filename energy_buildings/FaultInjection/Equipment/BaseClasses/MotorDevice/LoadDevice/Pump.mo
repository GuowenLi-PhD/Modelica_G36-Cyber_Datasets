within FaultInjection.Equipment.BaseClasses.MotorDevice.LoadDevice;
model Pump "Centrifugal pump with mechanical connector for the shaft"
  extends MotorDevice.LoadDevice.PartialPump;
  Modelica.SIunits.Angle phi "Shaft angle";
  Modelica.SIunits.AngularVelocity omega "Shaft angular velocity";
  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft
  annotation (Placement(transformation(extent={{-10,90},{10,110}})));
equation
  phi = shaft.phi;
  omega = der(phi);
  N = Modelica.SIunits.Conversions.to_rpm(omega);
  W_single = omega*shaft.tau;
annotation (
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-10,100},{10,78}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={95,95,95})}),
  Documentation(info="<html>
<p>This model describes a centrifugal pump (or a group of <code>nParallel</code> pumps) with a mechanical rotational connector for the shaft, to be used when the pump drive has to be modelled explicitly. In the case of <code>nParallel</code> pumps, the mechanical connector is relative to a single pump.
<p>The model extends <code>PartialPump</code>
 </html>",
     revisions="<html>
<ul>
<li><i>31 Oct 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Model added to the Fluid library</li>
</ul>
</html>"));
end Pump;
