within FaultInjection.Experimental.SystemLevelFaults.Controls;
model CoolingTowerSpeed "Controller for the fan speed in cooling towers"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Blocks.Types.SimpleController controllerType=
    Modelica.Blocks.Types.SimpleController.PID
    "Type of controller"
    annotation(Dialog(tab="Controller"));
  parameter Real k(min=0, unit="1") = 1
    "Gain of controller"
    annotation(Dialog(tab="Controller"));
  parameter Modelica.SIunits.Time Ti(min=Modelica.Constants.small)=0.5
    "Time constant of integrator block"
     annotation (Dialog(enable=
          (controllerType == Modelica.Blocks.Types.SimpleController.PI or
          controllerType == Modelica.Blocks.Types.SimpleController.PID),tab="Controller"));
  parameter Modelica.SIunits.Time Td(min=0)=0.1
    "Time constant of derivative block"
     annotation (Dialog(enable=
          (controllerType == Modelica.Blocks.Types.SimpleController.PD or
          controllerType == Modelica.Blocks.Types.SimpleController.PID),tab="Controller"));
  parameter Real yMax(start=1)=1
   "Upper limit of output"
    annotation(Dialog(tab="Controller"));
  parameter Real yMin=0
   "Lower limit of output"
    annotation(Dialog(tab="Controller"));
  parameter Boolean reverseAction = true
    "Set to true for throttling the water flow rate through a cooling coil controller"
    annotation(Dialog(tab="Controller"));
  Modelica.Blocks.Interfaces.RealInput TCHWSupSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput TCWSupSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput TCHWSup(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Chilled water supply temperature " annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        origin={-120,-74}), iconTransformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput TCWSup(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Condenser water supply temperature " annotation (
      Placement(transformation(
        extent={{20,20},{-20,-20}},
        rotation=180,
        origin={-120,-40})));
  Modelica.Blocks.Interfaces.RealOutput y
    "Speed signal for cooling tower fans"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Sources.Constant uni(k=1) "Unit"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Modelica.Blocks.Sources.BooleanExpression pmcMod(
    y= cooMod == Integer(FaultInjection.Experimental.SystemLevelFaults.Types.CoolingModes.PartialMechanical))
    "Partially mechanical cooling mode"
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));

  Modelica.Blocks.Interfaces.IntegerInput cooMod
    "Cooling mode signal, integer value of
    Buildings.Applications.DataCenters.Types.CoolingMode"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.Continuous.LimPID conPID(
    controllerType=controllerType,
    k=k,
    Ti=Ti,
    Td=Td,
    yMax=yMax,
    yMin=yMin,
    reverseAction=reverseAction,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=0)
    "PID controller"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Modelica.Blocks.Math.IntegerToBoolean fmcMod(threshold=Integer(FaultInjection.Experimental.SystemLevelFaults.Types.CoolingModes.FullMechanical))
    "Fully mechanical cooling mode"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));

  Modelica.Blocks.Sources.BooleanExpression offMod(y=cooMod == Integer(
        FaultInjection.Experimental.SystemLevelFaults.Types.CoolingModes.Off))
    "off mode" annotation (Placement(transformation(extent={{30,22},{50,42}})));
  Modelica.Blocks.Sources.Constant off(k=0) "zero"
    annotation (Placement(transformation(extent={{30,54},{50,74}})));
  Buildings.Controls.OBC.CDL.Integers.LessThreshold notOff(threshold=Integer(
        FaultInjection.Experimental.SystemLevelFaults.Types.CoolingModes.Off))
    annotation (Placement(transformation(extent={{-88,-100},{-68,-80}})));
protected
  Modelica.Blocks.Logical.Switch swi1
    "Switch 1"
    annotation (Placement(transformation(extent={{-46,30},{-26,50}})));
  Modelica.Blocks.Logical.Switch swi2
    "Switch 2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={-34,-60})));
  Modelica.Blocks.Logical.Switch swi3
    "Switch 3"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={42,0})));

  Modelica.Blocks.Logical.Switch swi4
    "Switch 3"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={80,32})));
equation
  connect(TCWSupSet, swi1.u1)
    annotation (Line(points={{-120,80},{-58,80},{-58,48},{-48,48}},
                         color={0,0,127}));
  connect(TCHWSupSet, swi1.u3)
    annotation (Line(points={{-120,0},{-58,0},{-58,32},{-48,32}},
                         color={0,0,127}));
  connect(swi1.y, conPID.u_s)
    annotation (Line(points={{-25,40},{-20,40},{-20,-40},{-12,-40}},
                 color={0,0,127}));
  connect(fmcMod.y, swi2.u2)
    annotation (Line(points={{-69,40},{-64,40},{-64,-60},{-46,-60}},
                      color={255,0,255}));
  connect(TCWSup, swi2.u1)
    annotation (Line(points={{-120,-40},{-60,-40},{-60,-52},{-46,-52}},
                      color={0,0,127}));
  connect(swi2.y, conPID.u_m)
    annotation (Line(points={{-23,-60},{0,-60},{0,-52}},   color={0,0,127}));
  connect(pmcMod.y, swi3.u2)
    annotation (Line(points={{13,0},{30,0}},          color={255,0,255}));
  connect(uni.y, swi3.u1)
    annotation (Line(points={{11,80},{20,80},{20,8},{30,8}}, color={0,0,127}));
  connect(fmcMod.y, swi1.u2)
    annotation (Line(points={{-69,40},{-48,40}},
                     color={255,0,255}));
  connect(cooMod, fmcMod.u)
    annotation (Line(points={{-120,40},{-92,40}},
                color={255,127,0}));
  connect(conPID.y, swi3.u3) annotation (Line(points={{11,-40},{20,-40},{20,-8},
          {30,-8}}, color={0,0,127}));
  connect(offMod.y, swi4.u2)
    annotation (Line(points={{51,32},{68,32}}, color={255,0,255}));
  connect(off.y, swi4.u1) annotation (Line(points={{51,64},{60,64},{60,40},{68,
          40}}, color={0,0,127}));
  connect(swi3.y, swi4.u3)
    annotation (Line(points={{53,0},{60,0},{60,24},{68,24}}, color={0,0,127}));
  connect(swi4.y, y) annotation (Line(points={{91,32},{96,32},{96,0},{110,0}},
        color={0,0,127}));
  connect(cooMod, notOff.u) annotation (Line(points={{-120,40},{-96,40},{-96,
          -90},{-90,-90}}, color={255,127,0}));
  connect(TCHWSup, swi2.u3) annotation (Line(points={{-120,-74},{-60,-74},{-60,
          -68},{-46,-68}}, color={0,0,127}));
  connect(notOff.y, conPID.trigger)
    annotation (Line(points={{-66,-90},{-8,-90},{-8,-52}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,80}})),    Documentation(info="<html>
<p>This model describes a simple cooling tower speed controller for
a chilled water system with integrated waterside economizers.
</p>
<p>The control logics are described in the following:</p>
<ul>
<li>When the system is in Fully Mechanical Cooling (FMC) mode,
the cooling tower fan speed is controlled to maintain the condener water supply temperature (CWST)
at or around the setpoint.
</li>
<li>When the system is in Partially Mechanical Cooling (PMC) mode,
the cooling tower fan speed is set as 100% to make condenser water
as cold as possible and maximize the waterside economzier output.
</li>
<li>When the system is in Free Cooling (FC) mode,
the cooling tower fan speed is controlled to maintain the chilled water supply temperature (CHWST)
at or around its setpoint.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
July 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolingTowerSpeed;
