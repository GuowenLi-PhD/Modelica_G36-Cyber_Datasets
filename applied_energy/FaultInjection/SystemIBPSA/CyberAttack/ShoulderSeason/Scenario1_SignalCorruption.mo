within FaultInjection.SystemIBPSA.CyberAttack.ShoulderSeason;
model Scenario1_SignalCorruption "System example for fault injection"
  extends FaultInjection.SystemIBPSA.CyberAttack.ShoulderSeason.BaselineSystem;
  annotation (
    experiment(
      StartTime=6912000,
      StopTime=7516800,
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
          "modelica://FaultInjection/Resources/Scripts/dymola/Systems/CyberAttack/ShoulderSeason/Scenario1_SignalCorruption.mos"
        "Simulate and Plot"));
end Scenario1_SignalCorruption;
