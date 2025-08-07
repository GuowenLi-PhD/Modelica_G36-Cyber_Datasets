within FaultInjection.Experimental.Regulation.Controls;
model ChillerStage "Chiller staging control logic"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.SIunits.Time tWai "Waiting time";

  Modelica.Blocks.Interfaces.IntegerInput cooMod
    "Cooling mode signal, integer value of
    Buildings.Applications.DataCenters.Types.CoolingMode"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput y
    "On/off signal for the chillers - 0: off; 1: on"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.StateGraph.Transition con1(
    enableTimer=true,
    waitTime=tWai,
    condition=cooMod > Integer(FaultInjection.Experimental.Regulation.Types.CoolingModes.FreeCooling)
         and cooMod < Integer(FaultInjection.Experimental.Regulation.Types.CoolingModes.Off))
    "Fire condition 1: free cooling to partially mechanical cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,42})));
  Modelica.StateGraph.StepWithSignal oneOn(nIn=2, nOut=2)
    "One chiller is commanded on"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-50,10})));
  Modelica.StateGraph.InitialStep off(nIn=1) "Free cooling mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-50,70})));
  Modelica.StateGraph.Transition con4(
    enableTimer=true,
    waitTime=tWai,
    condition=cooMod == Integer(FaultInjection.Experimental.Regulation.Types.CoolingModes.FreeCooling)
         or cooMod == Integer(FaultInjection.Experimental.Regulation.Types.CoolingModes.Off))
    "Fire condition 4: partially mechanical cooling to free cooling"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-20,52})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal    booToRea
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(off.outPort[1], con1.inPort)
    annotation (Line(
      points={{-50,59.5},{-50,46}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con1.outPort, oneOn.inPort[1])
    annotation (Line(
      points={{-50,40.5},{-50,26},{-50.5,26},{-50.5,21}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con4.outPort, off.inPort[1])
    annotation (Line(
      points={{-20,53.5},{-20,90},{-50,90},{-50,81}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(con4.inPort, oneOn.outPort[2])
    annotation (Line(
      points={{-20,48},{-20,-10},{-49.75,-10},{-49.75,-0.5}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(oneOn.active, booToRea.u) annotation (Line(points={{-39,10},{-12,10},{
          -12,0},{18,0}}, color={255,0,255}));
  connect(booToRea.y, y)
    annotation (Line(points={{42,0},{70,0},{70,0},{110,0}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This is a chiller staging control that works as follows:
</p>
<ul>
<li>
The chillers are all off when cooling mode is Free Cooling.
</li>
<li>
One chiller is commanded on when cooling mode is not Free Cooling.
</li>
<li>
Two chillers are commanded on when cooling mode is not Free Cooling
and the cooling load addressed by each chiller is larger than
a critical value.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 11, 2017, by Michael Wetter:<br/>
Revised switch that selects the operation mode for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/921\">issue 921</a>
</li>
<li>
July 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChillerStage;
