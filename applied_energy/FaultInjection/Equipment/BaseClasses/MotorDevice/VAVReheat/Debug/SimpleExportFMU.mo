within FaultInjection.Equipment.BaseClasses.MotorDevice.VAVReheat.Debug;
model SimpleExportFMU
  "This is a simple model that can be exported as fmu and then communicate with fncs"
  Modelica.Blocks.Interfaces.RealInput u(unit = "1")
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y(unit = "1")
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  y = u+1;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SimpleExportFMU;
