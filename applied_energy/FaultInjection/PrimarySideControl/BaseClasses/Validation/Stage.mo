within FaultInjection.PrimarySideControl.BaseClasses.Validation;
model Stage "Test the general stage model"
  extends Modelica.Icons.Example;
  parameter Integer numSta=4 "Design number of equipment that can be staged";
  parameter Real staUpThr=0.8 "Staging up threshold";
  parameter Real staDowThr=0.45 "Staging down threshold";
  FaultInjection.PrimarySideControl.BaseClasses.Stage sta(
    staUpThr=staUpThr,
    staDowThr=staDowThr,
    waiTimStaUp=300,
    shoCycTim=200)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine u(
    amplitude=0.5,
    offset=0.5,
    freqHz=1/1500) "Input signal"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  Modelica.Blocks.Sources.BooleanPulse on(period=3000)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation
  connect(u.y, sta.u)
    annotation (Line(points={{-39,30},{-26,30},{-26,4},{-12,4}},
                                               color={0,0,127}));
  connect(on.y, sta.on) annotation (Line(points={{-39,-30},{-26,-30},{-26,-4},{
          -12,-4}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=3600),
    __Dymola_Commands(file=
          "modelica://WSEControlLogics/Resources/Scripts/Dymola/Controls/LocalControls/BaseClasses/Validation/Stage.mos"
        "Simulate and Plot"));
end Stage;
