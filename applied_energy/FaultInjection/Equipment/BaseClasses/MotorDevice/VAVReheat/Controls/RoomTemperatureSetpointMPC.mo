within FaultInjection.Equipment.BaseClasses.MotorDevice.VAVReheat.Controls;
block RoomTemperatureSetpointMPC
  "Set point scheduler for room temperature used in MPC models"
  extends Modelica.Blocks.Icons.Block;
  import
    FaultInjection.Equipment.BaseClasses.MotorDevice.VAVReheat.Controls.OperationModes;
  parameter Modelica.SIunits.Temperature THeaOn=293.15
    "Heating setpoint during on";
  parameter Modelica.SIunits.Temperature THeaOff=285.15
    "Heating setpoint during off";
  parameter Modelica.SIunits.Temperature TCooOn=297.15
    "Cooling setpoint during on";
  parameter Modelica.SIunits.Temperature TCooOff=303.15
    "Cooling setpoint during off";
  ControlBus controlBus
    annotation (Placement(transformation(extent={{10,50},{30,70}})));
  Modelica.Blocks.Routing.IntegerPassThrough mode
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRooSetCoo(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=0) "Setpoint temperature for room for cooling" annotation (Placement(
        transformation(extent={{-140,40},{-100,80}}), iconTransformation(extent=
           {{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRooSetHea(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=0) "Setpoint temperature for room for cooling" annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}), iconTransformation(
          extent={{-140,20},{-100,60}})));
equation
  connect(controlBus.controlMode,mode. u) annotation (Line(
      points={{20,60},{58,60}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(TRooSetCoo, controlBus.TRooSetCoo) annotation (Line(points={{-120,60},
          {20,60}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TRooSetHea, controlBus.TRooSetHea) annotation (Line(points={{-120,0},
          {20,0},{20,60}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
end RoomTemperatureSetpointMPC;
