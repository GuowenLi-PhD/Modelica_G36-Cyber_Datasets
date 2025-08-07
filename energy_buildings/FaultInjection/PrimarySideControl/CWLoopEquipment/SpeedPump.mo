within FaultInjection.PrimarySideControl.CWLoopEquipment;
model SpeedPump "Pump speed control in condenser water loop"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.Pressure dpSetDes "Differential pressure setpoint at design condition ";

  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.PID
    "Type of controller";
  parameter Real k=1 "Gain of controller";
  parameter Modelica.SIunits.Time Ti=0.5 "Time constant of Integrator block";
  parameter Modelica.SIunits.Time Td=0.1 "Time constant of Derivative block";
  parameter Real yMax=1 "Upper limit of output";
  parameter Real yMin=0.4 "Lower limit of output";
  parameter Boolean reverseAction=false
    "Set to true for throttling the water flow rate through a cooling coil controller";
  Modelica.Blocks.Interfaces.RealInput uLoa
    "Percentage of load in chillers (total loads divided by nominal capacity of all operating chillers)"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.IntegerInput uOpeMod
    "Cooling mode in WSEControls.Type.OperationaModes" annotation (Placement(
        transformation(extent={{-140,60},{-100,100}}), iconTransformation(
          extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput uSpeTow "Speed of cooling tower fans"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minPumSpe(k=yMin)
    "Minimum pump speed"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(k=0) "Zero"
    annotation (Placement(transformation(extent={{32,40},{52,60}})));
  Modelica.Blocks.Sources.BooleanExpression notOcc(y=uOpeMod == Integer(
        WSEControlLogics.Controls.WSEControls.Type.OperationModes.Unoccupied))
    "Not occupied"
    annotation (Placement(transformation(extent={{32,10},{52,30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max
    annotation (Placement(transformation(extent={{-32,20},{-12,40}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{32,-18},{52,2}})));
  Modelica.Blocks.Sources.BooleanExpression freCoo(y=uOpeMod == Integer(
        WSEControlLogics.Controls.WSEControls.Type.OperationModes.FreeCooling))
    "Free cooling"
    annotation (Placement(transformation(extent={{0,-18},{20,2}})));
  Buildings.Controls.Continuous.LimPID con(
    controllerType=controllerType,
    k=k,
    Ti=Ti,
    Td=Td,
    yMax=yMax,
    yMin=yMin,
    reverseAction=reverseAction)           "PID controller"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Modelica.Blocks.Interfaces.RealInput dpSet "Differential pressure setpoint"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput dpMea
    "Differential pressure measurement"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(k=1/dpSetDes)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai2(k=1/dpSetDes)
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Utilities.Math.Max max2(nin=3)
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y "Speed signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(notOcc.y, swi.u2) annotation (Line(points={{53,20},{58,20},{58,0},{68,
          0}},  color={255,0,255}));
  connect(zer.y, swi.u1) annotation (Line(points={{53,50},{60,50},{60,8},{68,8}},
        color={0,0,127}));
  connect(minPumSpe.y,max. u1) annotation (Line(points={{-59,60},{-50,60},{-50,
          36},{-34,36}},
                     color={0,0,127}));
  connect(uSpeTow,max. u2) annotation (Line(points={{-120,40},{-86,40},{-86,24},
          {-34,24}}, color={0,0,127}));
  connect(max.y, swi1.u1) annotation (Line(points={{-11,30},{20,30},{20,0},{30,
          0}},
        color={0,0,127}));
  connect(freCoo.y, swi1.u2) annotation (Line(points={{21,-8},{30,-8}},
                color={255,0,255}));
  connect(gai1.y, con.u_s) annotation (Line(points={{-59,-30},{-50,-30},{-50,-50},
          {-42,-50}}, color={0,0,127}));
  connect(dpSet, gai1.u)
    annotation (Line(points={{-120,-40},{-90,-40},{-90,-30},{-82,-30}},
                                                    color={0,0,127}));
  connect(dpMea, gai2.u) annotation (Line(points={{-120,-80},{-102,-80},{-102,
          -80},{-82,-80}},
                      color={0,0,127}));
  connect(gai2.y, con.u_m)
    annotation (Line(points={{-59,-80},{-30,-80},{-30,-62}}, color={0,0,127}));
  connect(minPumSpe.y,max2. u[1]) annotation (Line(points={{-59,60},{-50,60},{
          -50,-18},{-14,-18},{-14,-41.3333},{-2,-41.3333}},
                                                    color={0,0,127}));
  connect(uLoa,max2. u[2]) annotation (Line(points={{-120,0},{-52,0},{-52,-20},
          {-16,-20},{-16,-40},{-2,-40}},color={0,0,127}));
  connect(con.y,max2. u[3]) annotation (Line(points={{-19,-50},{-12,-50},{-12,
          -38.6667},{-2,-38.6667}},
                          color={0,0,127}));
  connect(max2.y, swi1.u3) annotation (Line(points={{21,-40},{24,-40},{24,-16},
          {30,-16}},
                color={0,0,127}));
  connect(swi1.y, swi.u3) annotation (Line(points={{53,-8},{68,-8}},
        color={0,0,127}));
  connect(swi.y, y) annotation (Line(points={{91,0},{110,0}}, color={0,0,127}));
  annotation (defaultComponentName="spePum", Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Condenser water pump speed control is different in different operation modes.
</p>
<ul>
<li>
For unoccupied operation mode, the pump is turned off.
</li>
<li>
For free cooling mode, the condenser water pump speed is equal to a high signal select of a PID loop output and a minimum speed (e.g. 40%). The PID loop outputs the cooling tower
fan speed signal to maintain chilled water supply temperature at its setpoint. 
</li>
<li>
For pre-partial, partial and full mechanical cooling, the condenser water pump speed is equal to a high signal select of the following three: (1) a minimum speed (e.g. 40%); (2) highest chiller percentage load; 
(3) CW system differential pressure PID output signal. 
</li>
</ul>
</html>"));
end SpeedPump;
