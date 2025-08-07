within FaultInjection.PrimarySideControl.ValveControl;
model ModulatingIsolationChiller "Control of modulating isolation valve"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.Time staTim = 120 "Stable time before the valves are modulated";
 // Controller
  parameter Modelica.Blocks.Types.SimpleController controllerType=
    Modelica.Blocks.Types.SimpleController.PID
    "Type of controller";
  parameter Real k(min=0, unit="1") = 1
    "Gain of controller";
  parameter Modelica.SIunits.Time Ti(min=Modelica.Constants.small)=0.5
    "Time constant of integrator block"
     annotation (Dialog(enable=
          (controllerType == Modelica.Blocks.Types.SimpleController.PI or
          controllerType == Modelica.Blocks.Types.SimpleController.PID)));
  parameter Modelica.SIunits.Time Td(min=0)=0.1
    "Time constant of derivative block"
     annotation (Dialog(enable=
         (controllerType == Modelica.Blocks.Types.SimpleController.PD or
          controllerType == Modelica.Blocks.Types.SimpleController.PID)));
  parameter Real yMax(start=1)=1
   "Upper limit of output";
  parameter Real yMin=0
   "Lower limit of output";
  parameter Real wp(min=0) = 1
   "Set-point weight for Proportional block (0..1)";
  parameter Real wd(min=0) = 0
   "Set-point weight for Derivative block (0..1)"
    annotation(Dialog(enable=
        (controllerType==.Modelica.Blocks.Types.SimpleController.PD or
        controllerType==.Modelica.Blocks.Types.SimpleController.PID)));
  parameter Real Ni(min=100*Modelica.Constants.eps) = 0.9
    "Ni*Ti is time constant of anti-windup compensation"
    annotation(Dialog(enable=
        (controllerType==.Modelica.Blocks.Types.SimpleController.PI or
        controllerType==.Modelica.Blocks.Types.SimpleController.PID)));
  parameter Real Nd(min=100*Modelica.Constants.eps) = 10
    "The higher Nd, the more ideal the derivative block"
    annotation(Dialog(enable=
        (controllerType==.Modelica.Blocks.Types.SimpleController.PD or
        controllerType==.Modelica.Blocks.Types.SimpleController.PID)));

  Modelica.Blocks.Interfaces.IntegerInput uOpeMod
    "Operation mode in WSEControlLogics.Controls.WSEControls.Type.OperationModes"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_s
    "Reference point of the signal"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Sources.BooleanExpression valOffCon(y=uOpeMod == Integer(
        WSEControlLogics.Controls.WSEControls.Type.OperationModes.Unoccupied)
         or uOpeMod == Integer(WSEControlLogics.Controls.WSEControls.Type.OperationModes.FreeCooling))
    "Valve off conditions"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_m "Measurement" annotation (
     Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
  Modelica.Blocks.Logical.Not not1 "Not free cooling or unoccupied mode"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1 "Switch 1"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(k=0) "Zero"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Position for modulating isolation valve"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2 "Switch 1"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uni(k=1) "Unity "
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "And "
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  PrimarySideControl.BaseClasses.TimerGreatEqual tim(threshold=0.9) "Timer"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold greEqu(threshold=staTim)
    annotation (Placement(transformation(extent={{-30,0},{-10,20}})));
  Modelica.Blocks.Logical.Not not2 "Not free cooling or unoccupied mode"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  parameter Boolean reverseAction=false
    "Set to true for throttling the water flow rate through a cooling coil controller";
  Buildings.Controls.OBC.CDL.Logical.Switch swi3 "Switch 1"
    annotation (Placement(transformation(extent={{-46,-70},{-26,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqual lesEqu
    annotation (Placement(transformation(extent={{-88,-58},{-68,-78}})));
  Buildings.Controls.Continuous.LimPID conPID(
    controllerType=controllerType,
    k=k,
    Ti=Ti,
    Td=Td,
    yMax=yMax,
    yMin=yMin,
    reset=Buildings.Types.Reset.Parameter,
    reverseAction=true,
    y_reset=1)                             "PID controller"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
equation
  connect(valOffCon.y, not1.u) annotation (Line(points={{-79,60},{-76,60},{
          -76,-20},{-62,-20}},
                      color={255,0,255}));
  connect(valOffCon.y, swi1.u2) annotation (Line(points={{-79,60},{-76,60},{-76,
          70},{-22,70}}, color={255,0,255}));
  connect(zer.y, swi1.u1) annotation (Line(points={{-39,90},{-30,90},{-30,78},{-22,
          78}}, color={0,0,127}));
  connect(uni.y, swi1.u3) annotation (Line(points={{-39,50},{-30,50},{-30,62},{-22,
          62}}, color={0,0,127}));
  connect(swi1.y, swi2.u1)
    annotation (Line(points={{1,70},{62,70},{62,8},{68,8}}, color={0,0,127}));
  connect(not1.y, and1.u2) annotation (Line(points={{-39,-20},{-26,-20},{-26,
          -8},{8,-8}},
                   color={255,0,255}));
  connect(swi1.y, tim.u) annotation (Line(points={{1,70},{12,70},{12,30},{-68,30},
          {-68,10},{-62,10}}, color={0,0,127}));
  connect(tim.y, greEqu.u)
    annotation (Line(points={{-39,10},{-32,10}}, color={0,0,127}));
  connect(greEqu.y, and1.u1) annotation (Line(points={{-9,10},{-2,10},{-2,0},
          {8,0}},
               color={255,0,255}));
  connect(and1.y, not2.u)
    annotation (Line(points={{31,0},{38,0}}, color={255,0,255}));
  connect(not2.y, swi2.u2)
    annotation (Line(points={{61,0},{68,0}}, color={255,0,255}));
  connect(swi2.y, y)
    annotation (Line(points={{91,0},{110,0}}, color={0,0,127}));
  connect(u_s, lesEqu.u2)
    annotation (Line(points={{-120,-60},{-90,-60}}, color={0,0,127}));
  connect(u_m, lesEqu.u1) annotation (Line(points={{0,-120},{0,-98},{-96,-98},{
          -96,-68},{-90,-68}}, color={0,0,127}));
  connect(lesEqu.y, swi3.u2) annotation (Line(points={{-67,-68},{-60,-68},{-60,
          -60},{-48,-60}}, color={255,0,255}));
  connect(u_s, swi3.u1) annotation (Line(points={{-120,-60},{-96,-60},{-96,-52},
          {-48,-52}}, color={0,0,127}));
  connect(u_m, swi3.u3) annotation (Line(points={{0,-120},{0,-88},{-56,-88},{
          -56,-68},{-48,-68}}, color={0,0,127}));
  connect(swi3.y, conPID.u_s)
    annotation (Line(points={{-25,-60},{-12,-60}}, color={0,0,127}));
  connect(conPID.u_m, u_m)
    annotation (Line(points={{0,-72},{0,-120}}, color={0,0,127}));
  connect(conPID.y, swi2.u3) annotation (Line(points={{11,-60},{62,-60},{62,
          -8},{68,-8}}, color={0,0,127}));
  connect(and1.y, conPID.trigger) annotation (Line(points={{31,0},{34,0},{34,
          -84},{-8,-84},{-8,-72}}, color={255,0,255}));
  annotation (defaultComponentName = "modIsoChi",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
          extent={{-100,-34},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid), Text(
          extent={{40,-72},{92,-94}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.None,
          textString="Head Pressure Control",
          textStyle={TextStyle.Bold})}),
    Documentation(info="<html>
<p>
The modulatable isolation valve is usually installed on the condenser water side of a chiller to perform head pressure control during cold climate.
The modulating isolation valve is modulated to control variables such as chiller temperature/pressure lift between evaporator and condenser. 
</p>
<p>The logics for different operational modes are as follows:
</p>
<ul>
<li>
When chiller is not enabled, the isolation valves are closed.
</li>
<li>
When chiller is enbaled, the isolation valves on the condenser side are fully opened at the beginning. Then after a stable time delay <code>staTim</code>, the valve is modulated to
control variables such as temperature lift or pressure lift in a chiller.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>July 31, 2018, by Yangyang Fu:<br>
First implementation. 
</li>
</ul>
</html>"));
end ModulatingIsolationChiller;
