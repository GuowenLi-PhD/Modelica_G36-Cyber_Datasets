within FaultInjection.Utilities.FaultEvolution;
block Trapezoid "Generate trapezoidal signal of type Real"
  parameter Real amplitude=-10 "Amplitude of trapezoid";
  parameter Modelica.SIunits.Time rising(final min=0)=5
    "Rising duration of trapezoid";
  parameter Modelica.SIunits.Time width(final min=0)=5
    "Width duration of trapezoid";
  parameter Modelica.SIunits.Time falling(final min=0)=5
    "Falling duration of trapezoid";
  parameter Modelica.SIunits.Time period(final min=Modelica.Constants.small,
      start=1)=20 "Time for one period";
  parameter Integer nperiod=integer((faultMode.endTime-faultMode.startTime)/period)
    "Number of periods (< 0 means infinite number of periods)";
  parameter Real offset=110
                          "Offset of output signal";
  parameter Modelica.SIunits.Time startTime=faultMode.startTime
    "Output = offset for time < startTime";
  extends Modelica.Blocks.Interfaces.SO;

protected
  parameter Modelica.SIunits.Time T_rising=rising
    "End time of rising phase within one period";
  parameter Modelica.SIunits.Time T_width=T_rising + width
    "End time of width phase within one period";
  parameter Modelica.SIunits.Time T_falling=T_width + falling
    "End time of falling phase within one period";
  Modelica.SIunits.Time T_start "Start time of current period";
  Integer count "Period count";

public
 parameter InsertionTypes.Generic.faultMode faultMode
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
initial algorithm
  count := integer((time - startTime)/period);
  T_start := startTime + count*period;
equation
  when integer((time - startTime)/period) > pre(count) then
    count = pre(count) + 1;
    T_start = time;
  end when;
  y = offset + (if (time < startTime or nperiod == 0 or (nperiod > 0 and
    count >= nperiod)) then 0 else if (time < T_start + T_rising) then
    amplitude*(time - T_start)/rising else if (time < T_start + T_width)
     then amplitude else if (time < T_start + T_falling) then amplitude*(
    T_start + T_falling - time)/falling else 0);
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-147,-152},{153,-112}},
          lineColor={0,0,0},
          textString="period=%period"),
        Line(points={{-81,-70},{-60,-70},{-30,40},{9,40},{39,-70},{61,-70},{
              90,40}})}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Polygon(
          points={{-81,90},{-87,68},{-75,68},{-81,90}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(points={{-81,68},{-81,-80}}, color={95,95,95}),
        Line(points={{-91,-70},{81,-70}}, color={95,95,95}),
        Polygon(
          points={{89,-70},{67,-65},{67,-76},{89,-70}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-46,-30},{-48,-41},{-44,-41},{-46,-30}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-46,-30},{-46,-70}},
          color={95,95,95}),
        Polygon(
          points={{-46,-70},{-48,-60},{-44,-60},{-46,-70},{-46,-70}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-80,-46},{-42,-55}},
          lineColor={0,0,0},
          textString="offset"),
        Text(
          extent={{-49,-71},{-6,-81}},
          lineColor={0,0,0},
          textString="startTime"),
        Text(
          extent={{-80,95},{-47,80}},
          lineColor={0,0,0},
          textString="y"),
        Text(
          extent={{66,-78},{89,-89}},
          lineColor={0,0,0},
          textString="time"),
        Line(
          points={{-31,82},{-31,-70}},
          color={95,95,95},
          pattern=LinePattern.Dash),
        Line(
          points={{-11,59},{-11,40}},
          color={95,95,95},
          pattern=LinePattern.Dash),
        Line(
          points={{19,59},{19,40}},
          color={95,95,95},
          pattern=LinePattern.Dash),
        Line(
          points={{39,59},{39,-30}},
          color={95,95,95},
          pattern=LinePattern.Dash),
        Line(points={{-31,76},{59,76}}, color={95,95,95}),
        Line(points={{-31,56},{39,56}}, color={95,95,95}),
        Text(
          extent={{-3,86},{24,77}},
          lineColor={0,0,0},
          textString="period"),
        Text(
          extent={{-11,68},{18,59}},
          lineColor={0,0,0},
          textString="width"),
        Line(
          points={{-43,40},{-11,40}},
          color={95,95,95},
          pattern=LinePattern.Dash),
        Line(
          points={{-40,40},{-40,-30}},
          color={95,95,95}),
        Text(
          extent={{-77,11},{-44,1}},
          lineColor={0,0,0},
          textString="amplitude"),
        Polygon(
          points={{-31,56},{-24,58},{-24,54},{-31,56}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-11,56},{-18,58},{-18,54},{-11,56}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-31,76},{-22,78},{-22,74},{-31,76}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{59,76},{51,78},{51,74},{59,76}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-81,-30},{-31,-30},{-11,40},{19,40},{39,-30},{59,-30},{79,
              40},{99,40}},
          color={0,0,255},
          thickness=0.5),
        Polygon(
          points={{-40,40},{-42,29},{-38,29},{-40,40}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-40,-30},{-42,-20},{-38,-20},{-40,-30},{-40,-30}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{59,84},{59,-30}},
          color={95,95,95},
          pattern=LinePattern.Dash),
        Polygon(
          points={{39,56},{32,58},{32,54},{39,56}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{19,56},{26,58},{26,54},{19,56}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{19,56},{12,58},{12,54},{19,56}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-11,56},{-4,58},{-4,54},{-11,56}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-35,68},{-6,60}},
          lineColor={0,0,0},
          textString="rising"),
        Text(
          extent={{16,68},{44,60}},
          lineColor={0,0,0},
          textString="falling")}),
    Documentation(info="<html>
<p>
The Real output y is a trapezoid signal:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Blocks/Sources/Trapezoid.png\"
     alt=\"Trapezoid\">
</p>
</html>"));
end Trapezoid;
