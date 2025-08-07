within FaultInjection.Equipment.BaseClasses.MotorDevice.VFD;
model Ideal "Ideal VFD model"

  Modelica.Blocks.Interfaces.RealInput Vas[1,2](final quantity="Voltage",
      final unit="V")
    "Supply voltage, complex number [1]: real, [2]:image, pu"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput Vbs[1,2](final quantity="Voltage",
      final unit="V")
    "Supply voltage, complex number [1]: real, [2]:image, pu"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Modelica.Blocks.Interfaces.RealInput Vcs[1,2](final quantity="Voltage",
      final unit="V")
    "Supply voltage, complex number [1]: real, [2]:image, pu"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Interfaces.RealInput f_in(final quantity="Frequency", final
      unit="Hz")
    "Controllale freuqency to the motor"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-50})));

  Modelica.Blocks.Interfaces.RealOutput Vas_out[1,2](final quantity="Voltage",
      final unit="V")
    "Supply voltage, complex number [1]: real, [2]:image, pu"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  Modelica.Blocks.Interfaces.RealOutput Vbs_out[1,2](final quantity="Voltage",
      final unit="V")
    "Supply voltage, complex number [1]: real, [2]:image, pu"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Modelica.Blocks.Interfaces.RealOutput Vcs_out[1,2](final quantity="Voltage",
      final unit="V")
    "Supply voltage, complex number [1]: real, [2]:image, pu"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  Modelica.Blocks.Interfaces.RealOutput f_out(final quantity="Frequency", final
      unit="Hz")
    "Controllale freuqency to the motor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-30})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-114},{151,-154}},
          lineColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Ideal;
