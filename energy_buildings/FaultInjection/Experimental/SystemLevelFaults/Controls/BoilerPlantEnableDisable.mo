within FaultInjection.Experimental.SystemLevelFaults.Controls;
model BoilerPlantEnableDisable
  extends ChillerPlantEnableDisable(con1(condition=yPlaReq > numIgn and TOut <
          TOutPla and ySupFan and offTim.y >= shoCycTim), con2(condition=(
          lesEquReq.y >= plaReqTim and onTim.y >= shoCycTim and lesEquSpe.y >=
          plaReqTim) or ((TOut > TOutPla - 1 or not ySupFan) and onTim.y >=
          shoCycTim), waitTime=0));
  annotation (Documentation(info="<html>
<p>This is a boiler plant enable disable control that works as follows: </p>
<p>Enable the plant in the lowest stage when the plant has been disabled for at least 15 minutes and: </p>
<ol>
<li>Number of Hot Water Plant Requests &gt; I (I = Ignores shall default to 0, adjustable), and </li>
<li>OAT&lt;H-LOT, and </li>
<li>The boiler plant enable schedule is active. </li>
</ol>
<p>Disable the plant when it has been enabled for at least 15 minutes and: </p>
<ol>
<li>Number of Hot Water Plant Requests &le; I for 3 minutes, or </li>
<li>OAT&gt;H-LOT-1&deg;F, or </li>
<li>The boiler plant enable schedule is inactive. </li>
</ol>
<p>In the above logic, OAT is the outdoor air temperature, CH-LOT is the chiller plant lockout air temperature, H-LOT is the heating plant lockout air temperature.</p>
</html>"));
end BoilerPlantEnableDisable;
