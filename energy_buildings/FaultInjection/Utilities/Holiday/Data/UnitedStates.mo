within FaultInjection.Utilities.Holiday.Data;
record UnitedStates "Holidays in united states"
  extends FaultInjection.Utilities.Holiday.Data.Generic(holidays=[[1,1]; [1,20];
        [5,25]; [7,3]; [9,7]; [10,12]; [11,11]; [11,26]; [12,25]]);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          lineColor={0,0,255},
          extent={{-150,60},{150,100}},
          textString="%name"),
        Rectangle(
          origin={0,-25},
          lineColor={64,64,64},
          fillColor={255,215,136},
          fillPattern=FillPattern.Solid,
          extent={{-100.0,-75.0},{100.0,75.0}},
          radius=25.0),
        Line(
          points={{-100,0},{100,0}},
          color={64,64,64}),
        Line(
          origin={0,-50},
          points={{-100.0,0.0},{100.0,0.0}},
          color={64,64,64}),
        Line(
          origin={0,-25},
          points={{0.0,75.0},{0.0,-75.0}},
          color={64,64,64})}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This block stores 2020 US federal holidays. They are: </p>
<p>New Year&apos;s Day: Wednesday, Jan 1</p>
<p>Birthday of Martin Luther King, Jr.: Monday, Jan 20</p>
<p>Memorial Day: Monday, May 25</p>
<p>Independance Day: Friday, July 3 (Note: the legal public holiday for Independence Day July 4,2020 was a Saturday)</p>
<p>Labor Day: Monday, Sept 7</p>
<p>Columbus Day: Monday, Oct 12</p>
<p>Veterans Day: Wednesday, Nov 11</p>
<p>Thanksgiving Day: Thursday, Nov 26</p>
<p>Christmas Day: Friday, Dec 25</p>
</html>"));
end UnitedStates;
