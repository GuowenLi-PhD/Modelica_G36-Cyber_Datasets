within FaultInjection.Systems.CyberAttack.CoolingSeason;
model Scenario1_SignalCorruption "System example for fault injection"
 extends FaultInjection.Systems.CyberAttack.CoolingSeason.BaselineSystem(
      faultZoneTemp(active=true), faultTZoneRequest(active=true));
  annotation (
    experiment(
      StartTime=17625600,
      StopTime=18230400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Documentation(info="<html>
<p>
The example shows how to inject a cyber attack on the zone temperature sensors. The attack model is max attack. 
Under attack, the zone temperature reading is corrupted to its maximum value (e.g., 28 C). 
The attack lasts for 3 hours starting from 12pm on the third day.
</p>
</html>"),
    __Dymola_Commands(file=
          "modelica://FaultInjection/Resources/Scripts/dymola/Systems/CyberAttack/CoolingSeason/Scenario1_SignalCorruption.mos"
        "Simulate and Plot"));
end Scenario1_SignalCorruption;
