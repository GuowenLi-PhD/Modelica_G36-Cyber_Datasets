within FaultInjection.PrimarySideControl.CWLoopEquipment.Validation;
model SpeedFan "Test the cooling tower speed control"

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

  FaultInjection.PrimarySideControl.CWLoopEquipment.SpeedFan cooTowSpe(
      controllerType=Modelica.Blocks.Types.SimpleController.PI, k=0.01)
    "Cooling tower speed controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Sine CHWST(
    amplitude=2,
    freqHz=1/360,
    offset=273.15 + 5)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Modelica.Blocks.Sources.Constant CWSTSet(k=273.15 + 20)
    "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Modelica.Blocks.Sources.Sine CWST(
    amplitude=5,
    freqHz=1/360,
    offset=273.15 + 20) "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Modelica.Blocks.Sources.Constant CHWSTSet(k=273.15 + 6)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Sources.IntegerTable uOpeMod(table=[0,1; 360,2; 720,3])
    "Operation mode"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.TimeTable uFanMax(table=[0,0.9; 360,0.9; 360,1; 720,1;
        720,0.9]) "Maximum Fan Speed"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
equation
  connect(CWSTSet.y, cooTowSpe.TCWSupSet) annotation (Line(points={{-39,80},{
          -20,80},{-20,80},{-20,22},{-20,2},{-12,2}},
                                                    color={0,0,127}));
  connect(CHWSTSet.y, cooTowSpe.TCHWSupSet) annotation (Line(points={{-39,20},{
          -32,20},{-32,6},{-12,6}}, color={0,0,127}));
  connect(CWST.y, cooTowSpe.TCWSup) annotation (Line(points={{-39,-20},{-32,-20},
          {-32,-6},{-12,-6}}, color={0,0,127}));
  connect(CHWST.y, cooTowSpe.TCHWSup) annotation (Line(points={{-39,-50},{-24,
          -50},{-24,-2},{-12,-2}},
                              color={0,0,127}));
  connect(uOpeMod.y, cooTowSpe.uOpeMod) annotation (Line(points={{-39,50},{-26,
          50},{-26,10},{-12,10}}, color={255,127,0}));
  connect(uFanMax.y,cooTowSpe.uFanMax)  annotation (Line(points={{-39,-80},{-18,
          -80},{-18,-10},{-12,-10}}, color={0,0,127}));
  annotation (    __Dymola_Commands(file=
          "modelica://WSEControlLogics/Resources/Scripts/Dymola/Controls/LocalControls/CWLoopEquipment/Validation/SpeedFan.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>This example tests the controller for the cooling tower fan speed implemented in 
<a href=\"modelica://WSEControlLogics.Controls.LocalControls.CWLoopEquipment.SpeedFan\">
WSEControlLogics/Controls/LocalControls/CWLoopEquipment/SpeedFan</a>. 
</p>
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
end SpeedFan;
