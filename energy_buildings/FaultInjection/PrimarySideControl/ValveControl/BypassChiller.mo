within FaultInjection.PrimarySideControl.ValveControl;
model BypassChiller "Controls for bypass valves for chillers"
  extends Modelica.Blocks.Icons.Block;
  extends FaultInjection.PrimarySideControl.BaseClasses.PartialBypassControl;

equation
  connect(off.y, swi1.u1) annotation (Line(points={{-59,90},{20,90},{20,68},{
          38,68}}, color={0,0,127}));
  connect(fulOpe.y, swi2.u1) annotation (Line(points={{-59,50},{20,50},{20,28},
          {38,28}}, color={0,0,127}));
  connect(off.y, swi3.u1) annotation (Line(points={{-59,90},{-14,90},{-14,2},{
          20,2},{20,-12},{38,-12}},  color={0,0,127}));
  connect(con.y, swi4.u1) annotation (Line(points={{-19,0},{-12,0},{-12,-40},{
          20,-40},{20,-52},{38,-52}},  color={0,0,127}));
  connect(con.y, swi5.u1) annotation (Line(points={{-19,0},{-14,0},{-14,-80},{
          20,-80},{20,-92},{38,-92}},       color={0,0,127}));
  connect(off.y, swi5.u3) annotation (Line(points={{-59,90},{-16,90},{-16,-108},
          {38,-108}},       color={0,0,127}));
  annotation (defaultComponentName="bypChi",
  Diagram(coordinateSystem(extent={{-100,-120},{100,100}})),
    Documentation(info="<html>
<p>
Bypass valves are used to switch the cooling system among different operation modes, and maintain desired differential pressure through the equipment such as evaporators or condensers.
</p>
<ul>
<li>
For unoccupied operation mode, the bypass for chillers and economizers are closed.
</li>
<li>
For free cooling mode, the bypass valve on chiller side is fully opened. 
</li>
<li>
For partial mechanical cooling, the chiller bypass valve is modulated to maintain the differential pressure through the active evaporators at its setpoint such as 
design differential pressure.
</li>
<li>
For pre-partial mechanical cooling, the economizer bypass is fully opened.
</li>
<li>
For full mechanical cooling,  the chiller bypass is modulated to maintain the differential pressure through the active evaporators at its setpoint such as 
design differential pressure.
</li>
</ul>
</html>"),
    __Dymola_Commands);
end BypassChiller;
