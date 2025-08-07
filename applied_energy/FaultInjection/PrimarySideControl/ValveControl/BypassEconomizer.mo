within FaultInjection.PrimarySideControl.ValveControl;
model BypassEconomizer "Controls for bypass valves for economizer"
  extends Modelica.Blocks.Icons.Block;
  extends FaultInjection.PrimarySideControl.BaseClasses.PartialBypassControl;

equation
  connect(off.y, swi1.u1) annotation (Line(points={{-59,90},{20,90},{20,68},{38,
          68}}, color={0,0,127}));

  connect(con.y, swi2.u1) annotation (Line(points={{-19,0},{-10,0},{-10,40},{20,
          40},{20,28},{38,28}},     color={0,0,127}));
  connect(fulOpe.y, swi3.u1) annotation (Line(points={{-59,50},{-12,50},{-12,-2},
          {20,-2},{20,-12},{38,-12}},color={0,0,127}));
  connect(con.y, swi4.u1) annotation (Line(points={{-19,0},{-10,0},{-10,-40},{
          20,-40},{20,-52},{38,-52}},  color={0,0,127}));
  connect(fulOpe.y, swi5.u1) annotation (Line(points={{-59,50},{-14,50},{-14,-80},
          {20,-80},{20,-92},{38,-92}}, color={0,0,127}));
  connect(off.y, swi5.u3) annotation (Line(points={{-59,90},{-16,90},{-16,-108},
          {38,-108}}, color={0,0,127}));
  annotation (defaultComponentName="bypEco",
    Diagram(coordinateSystem(extent={{-100,-120},{100,100}})),
    Documentation(info="<html>
<p>
Bypass valves for economizers are used to switch the cooling system among different operation modes, and maintain desired differential pressure through economizers. This model can be used 
for both chilled and condenser water side.
</p>
<ul>
<li>
For unoccupied operation mode, the bypass valves for economizers are closed.
</li>
<li>
For free cooling mode, the bypass valve on economizer side is modulated to maintain differential pressure across their respective 
economizers at a setpoint, such as design differential pressure.  
</li>
<li>
For partial mechanical cooling, the bypass valve on economizer side is modulated to maintain the differential pressure through the economizer at a setpoint such as 
design differential pressure. 
</li>
<li>
For pre-partial mechanical cooling, the bypass valve on economizer side is fully opened.
</li>
<li>
For full mechanical cooling, the bypass valve on economizer side is fully opened.
</li>
</ul>
</html>"));
end BypassEconomizer;
