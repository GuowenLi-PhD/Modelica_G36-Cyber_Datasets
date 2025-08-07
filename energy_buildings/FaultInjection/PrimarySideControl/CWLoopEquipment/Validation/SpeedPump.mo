within FaultInjection.PrimarySideControl.CWLoopEquipment.Validation;
model SpeedPump "Test the cooling water pump speed control"

  extends Modelica.Icons.Example;

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

  FaultInjection.PrimarySideControl.CWLoopEquipment.SpeedPump cooPumSpe(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    dpSetDes=25000) "Cooling water pump speed controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant dpSet(k=25000)
    "Differential pressure setpoint"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.Sine uSpeTow(
    amplitude=0.3,
    offset=0.5,
    freqHz=1/1080) "Speed of cooling tower fans"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.IntegerTable uOpeMod(table=[0,1; 360,2; 720,3; 1080,4;
        1440,5]) "Operation mode"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Modelica.Blocks.Sources.Sine uLoa(
    amplitude=0.4,
    freqHz=1/720,
    offset=0.5)
    "Percentage of load in chillers (total loads divided by nominal capacity of all operating chillers)"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.Sine dpMea(
    freqHz=1/720,
    amplitude=5000,
    offset=22500) "Differential pressure measurement"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
equation
  connect(uOpeMod.y, cooPumSpe.uOpeMod) annotation (Line(points={{-39,60},{-24,
          60},{-24,8},{-12,8}}, color={255,127,0}));
  connect(uSpeTow.y, cooPumSpe.uSpeTow) annotation (Line(points={{-39,30},{-26,
          30},{-26,4},{-12,4}}, color={0,0,127}));
  connect(uLoa.y, cooPumSpe.uLoa) annotation (Line(points={{-39,0},{-12,0}},
                           color={0,0,127}));
  connect(dpSet.y, cooPumSpe.dpSet) annotation (Line(points={{-39,-30},{-26,-30},
          {-26,-4},{-12,-4}}, color={0,0,127}));
  connect(dpMea.y, cooPumSpe.dpMea) annotation (Line(points={{-39,-60},{-24,-60},
          {-24,-8},{-12,-8}}, color={0,0,127}));
  annotation (    __Dymola_Commands(file=
          "modelica://WSEControlLogics/Resources/Scripts/Dymola/Controls/LocalControls/CWLoopEquipment/Validation/SpeedPump.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>This example tests the controller for the cooling water pump speed control implemented in
 <a href=\"modelica://WSEControlLogics.Controls.LocalControls.CWLoopEquipment.SpeedPump\">WSEControlLogics/Controls/LocalControls/CWLoopEquipment/SpeedPump</a>. </p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2018, by Xing Lu:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(
      StartTime=0,
      StopTime=1080,
      Tolerance=1e-06));
end SpeedPump;
