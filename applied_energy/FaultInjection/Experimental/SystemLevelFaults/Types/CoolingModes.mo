within FaultInjection.Experimental.SystemLevelFaults.Types;
type CoolingModes = enumeration(
    FreeCooling "Free cooling mode",
    PartialMechanical "Partial mechanical cooling",
    FullMechanical "Full mechanical cooling",
    Off "Off") annotation (
    Documentation(info="<html>
<p>Enumeration for the type cooling mode. </p>
<ol>
<li>FreeCooling </li>
<li>PartialMechanical </li>
<li>FullMechanical </li>
<li>Off</li>
</ol>
</html>", revisions=
                  "<html>
<ul>
<li>
August 29, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
