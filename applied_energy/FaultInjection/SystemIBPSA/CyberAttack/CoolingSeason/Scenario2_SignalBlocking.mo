within FaultInjection.SystemIBPSA.CyberAttack.CoolingSeason;
model Scenario2_SignalBlocking
  "System example for fault injection of signal blocking"
  extends FaultInjection.SystemIBPSA.CyberAttack.CoolingSeason.BaselineSystem;
  annotation (
    experiment(
      StartTime=17625600,
      StopTime=18230400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file="modelica://FaultInjection/Resources/Scripts/Systems/CyberAttack/CoolingSeason/Scenario2_SignalBlocking.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>The example shows how to inject a cyber attack on the AHU fan speed controller. The attack model is signal blocking. 
Under attack, the fan speed signal from the controller is blocked, and the fan runs at a previous speed all the time during attack. 
The blocking lasts for 6 hours from 12pm on the third day.
</p>
</html>"));
end Scenario2_SignalBlocking;
