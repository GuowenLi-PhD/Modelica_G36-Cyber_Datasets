within FaultInjection.Communication;
block PadeDelay
  "Pade approximation of delay block with fixed delayTime (use balance=true; this is not the default to be backwards compatible)"
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Modelica.SIunits.Time delayTime(start=1)
    "Delay time of output with respect to input signal";
  parameter Integer n(min=1) = 1 "Order of Pade delay";
  parameter Integer m(min=1,max=n) = n
    "Order of numerator (usually m=n, or m=n-1)";
  parameter Boolean balance=false
    "= true, if state space system is balanced (highly recommeded), otherwise textbook version"
    annotation(choices(checkBox=true));
  final output Real x[n]
    "State of transfer function from controller canonical form (balance=false), or balanced controller canonical form (balance=true)";

protected
  parameter Real a1[n]( each fixed=false) "First row of A";
  parameter Real b11(        fixed=false) "= B[1,1]";
  parameter Real c[n](  each fixed=false) "C row matrix";
  parameter Real d(          fixed=false) "D matrix";
  parameter Real s[n-1](each fixed=false) "State scaling";

function padeCoefficients2
  input Real T "delay time";
  input Integer n "order of denominator";
  input Integer m "order of numerator";
  input Boolean balance=false;
  output Real a1[n] "First row of A";
  output Real b11 "= B[1,1]";
  output Real c[n] "C row matrix";
  output Real d "D matrix";
  output Real s[n-1] "Scaling such that x[i] = s[i-1]*x[i-1], i > 1";
  protected
  Real b[m + 1] "numerator coefficients of transfer function";
  Real a[n + 1] "denominator coefficients of transfer function";
  Real nm;
  Real bb[n + 1];
  Real A[n,n];
  Real B[n,1];
  Real C[1,n];
  Real A2[n,n] = zeros(n,n);
  Real B2[n,1] = zeros(n,1);
  Real C2[1,n] "C matrix";
  Integer nb = m+1;
  Integer na = n+1;
  Real sx[n];
algorithm
  a[1] := 1;
  b[1] := 1;
  nm := n + m;

  for i in 1:n loop
    a[i + 1] := a[i]*(T*((n - i + 1)/(nm - i + 1))/i);
    if i <= m then
      b[i + 1] := -b[i]*(T*((m - i + 1)/(nm - i + 1))/i);
    end if;
  end for;

  b  := b[m + 1:-1:1];
  a  := a[n + 1:-1:1];
  bb := vector([zeros(n-m, 1); b]);
  d  := bb[1]/a[1];

  if balance then
    A2[1,:] := -a[2:na]/a[1];
    B2[1,1] := 1/a[1];
    for i in 1:n-1 loop
       A2[i+1,i] :=1;
    end for;
    C2[1,:] := bb[2:na] - d*a[2:na];
    (sx,A,B,C) :=Modelica.Math.Matrices.balanceABC(A2,B2,C2);
    for i in 1:n-1 loop
       s[i] := sx[i]/sx[i+1];
    end for;
    a1  := A[1,:];
    b11 := B[1,1];
    c   := vector(C);
  else
     s  := ones(n-1);
    a1  := -a[2:na]/a[1];
    b11 :=  1/a[1];
    c   := bb[2:na] - d*a[2:na];
  end if;
end padeCoefficients2;

equation
  der(x[1]) = a1*x + b11*u;
  if n > 1 then
     der(x[2:n]) = s.*x[1:n-1];
  end if;
  y = c*x + d*u;

initial equation
  (a1,b11,c,d,s) = padeCoefficients2(delayTime, n, m, balance);

  if balance then
     der(x) = zeros(n);
  else
     // In order to be backwards compatible
     x[n] = u;
  end if;
  annotation (
    Documentation(info="<html>
<p>
The Input signal is delayed by a given time instant, or more precisely:
</p>
<pre>
   y = u(time - delayTime) for time &gt; time.start + delayTime
     = u(time.start)       for time &le; time.start + delayTime
</pre>
<p>
The delay is approximated by a Pade approximation, i.e., by
a transfer function
</p>
<pre>
           b[1]*s^m + b[2]*s^[m-1] + ... + b[m+1]
   y(s) = --------------------------------------------- * u(s)
           a[1]*s^n + a[2]*s^[n-1] + ... + a[n+1]
</pre>
<p>
where the coefficients b[:] and a[:] are calculated such that the
coefficients of the Taylor expansion of the delay exp(-T*s) around s=0
are identical up to order n+m.
</p>
<p>
The main advantage of this approach is that the delay is
approximated by a linear differential equation system, which
is continuous and continuously differentiable. For example, it
is uncritical to linearize a system containing a Pade-approximated
delay.
</p>
<p>
The standard text book version uses order \"m=n\", which is
also the default setting of this block. The setting
\"m=n-1\" may yield a better approximation in certain cases.
</p>

<p>
It is strongly recommended to always set parameter <b>balance</b> = true,
in order to arrive at a much better reliable numerical computation.
This is not the default, in order to be backwards compatible, so you have
to explicitly set it. Besides better numerics, also all states are initialized
with <b>balance</b> = true (in steady-state, so der(x)=0). Longer explanation:
</p>

<p>
By default the transfer function of the Pade approximation is implemented
in controller canonical form. This results in coefficients of the A-matrix in
the order of 1 up to the order of O(1/delayTime)^n. For already modest values
of delayTime and n, this gives largely varying coefficients (for example delayTime=0.001 and n=4
results in coefficients between 1 and 1e12). In turn, this results
in a large norm of the system matrix [A,B;C,D] and therefore in unreliable
numerical computations. When setting parameter <b>balance</b> = true, a state
transformation is performed that considerably reduces the norm of the system matrix.
This is performed without introducing round-off errors. For details see
function <a href=\"modelica://Modelica.Math.Matrices.balanceABC\">balanceABC</a>.
As a result, both the simulation of the PadeDelay block, and especially
its linearization becomes more reliable.
</p>

<h5>Literature:</h5>
<p>Otto Foellinger: Regelungstechnik, 8. Auflage,
chapter 11.9, page 412-414, Huethig Verlag Heidelberg, 1994
</p>
</html>", revisions="<html>
<table cellspacing=\"0\" cellpadding=\"2\" border=\"1\"><tr>
<th>Date</th>
<th>Author</th>
<th>Comment</th>
</tr>
<tr>
<td valign=\"top\">2015-01-05</td>
<td valign=\"top\">Martin Otter (DLR-SR)</td>
<td valign=\"top\">Introduced parameter balance=true and a new implementation
 of the PadeDelay block with an optional, more reliable numerics</td>
</tr>
</table>
</html>"), Icon(
    coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}}),
      graphics={
    Text(extent={{8.0,-142.0},{8.0,-102.0}},
      textString="delayTime=%delayTime"),
    Line(points={{-94.0,0.0},{-82.7,34.2},{-75.5,53.1},{-69.1,66.4},{-63.4,74.6},{-57.8,79.1},{-52.2,79.8},{-46.6,76.6},{-40.9,69.7},{-35.3,59.4},{-28.9,44.1},{-20.83,21.2},{-3.9,-30.8},{3.3,-50.2},{9.7,-64.2},{15.3,-73.1},{21.0,-78.4},{26.6,-80.0},{32.2,-77.6},{37.9,-71.5},{43.5,-61.9},{49.9,-47.2},{58.0,-24.8},{66.0,0.0}},
      color={0,0,127},
      smooth=Smooth.Bezier),
    Line(points={{-72.0,0.0},{-60.7,34.2},{-53.5,53.1},{-47.1,66.4},{-41.4,74.6},{-35.8,79.1},{-30.2,79.8},{-24.6,76.6},{-18.9,69.7},{-13.3,59.4},{-6.9,44.1},{1.17,21.2},{18.1,-30.8},{25.3,-50.2},{31.7,-64.2},{37.3,-73.1},{43.0,-78.4},{48.6,-80.0},{54.2,-77.6},{59.9,-71.5},{65.5,-61.9},{71.9,-47.2},{80.0,-24.8},{88.0,0.0}},
      color={160,160,164},
      smooth=Smooth.Bezier),
    Text(lineColor={160,160,164},
      extent={{-10.0,38.0},{100.0,100.0}},
      textString="m=%m"),
    Text(lineColor={160,160,164},
      extent={{-98.0,-96.0},{6.0,-34.0}},
      textString="n=%n"),
    Text(visible=balance, lineColor={160,160,164},
      extent={{-96,-20},{98,22}},
          textString="balanced")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-80,80},{-88,80}}, color={192,192,192}),
        Line(points={{-80,-80},{-88,-80}}, color={192,192,192}),
        Line(points={{-80,-88},{-80,86}}, color={192,192,192}),
        Text(
          extent={{-75,98},{-46,78}},
          lineColor={0,0,255},
          textString="output"),
        Polygon(
          points={{-80,96},{-86,80},{-74,80},{-80,96}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-100,0},{84,0}}, color={192,192,192}),
        Polygon(
          points={{100,0},{84,6},{84,-6},{100,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,0},{-68.7,34.2},{-61.5,53.1},{-55.1,66.4},{-49.4,
              74.6},{-43.8,79.1},{-38.2,79.8},{-32.6,76.6},{-26.9,69.7},{-21.3,
              59.4},{-14.9,44.1},{-6.83,21.2},{10.1,-30.8},{17.3,-50.2},{23.7,
              -64.2},{29.3,-73.1},{35,-78.4},{40.6,-80},{46.2,-77.6},{51.9,-71.5},
              {57.5,-61.9},{63.9,-47.2},{72,-24.8},{80,0}}, color={0,0,127},
              smooth=Smooth.Bezier),
        Text(
          extent={{-24,98},{-2,78}},
          lineColor={0,0,0},
          textString="input"),
        Line(points={{-64,0},{-52.7,34.2},{-45.5,53.1},{-39.1,66.4},{-33.4,
              74.6},{-27.8,79.1},{-22.2,79.8},{-16.6,76.6},{-10.9,69.7},{-5.3,
              59.4},{1.1,44.1},{9.17,21.2},{26.1,-30.8},{33.3,-50.2},{39.7,-64.2},
              {45.3,-73.1},{51,-78.4},{56.6,-80},{62.2,-77.6},{67.9,-71.5},{
              73.5,-61.9},{79.9,-47.2},{88,-24.8},{96,0}}, smooth=Smooth.Bezier),
        Text(
          extent={{67,22},{96,6}},
          lineColor={160,160,164},
          textString="time"),
        Line(points={{-64,-30},{-64,0}}, color={192,192,192}),
        Text(
          extent={{-58,-42},{-58,-32}},
          textString="delayTime",
          lineColor={0,0,255}),
        Line(points={{-94,-26},{-80,-26}}, color={192,192,192}),
        Line(points={{-64,-26},{-50,-26}}, color={192,192,192}),
        Polygon(
          points={{-80,-26},{-88,-24},{-88,-28},{-80,-26}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-56,-24},{-64,-26},{-56,-28},{-56,-24}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid)}));
end PadeDelay;
