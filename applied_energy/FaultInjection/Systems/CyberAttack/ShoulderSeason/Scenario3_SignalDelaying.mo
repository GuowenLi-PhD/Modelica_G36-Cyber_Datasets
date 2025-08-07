within FaultInjection.Systems.CyberAttack.ShoulderSeason;
model Scenario3_SignalDelaying
  "System example for fault injection of signal delaying"
  extends FaultInjection.Systems.CyberAttack.ShoulderSeason.BaselineSystem(
    faultCHWTSet(active=true));
  annotation (
    experiment(
      StartTime=6912000,
      StopTime=7516800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://FaultInjection/Resources/Scripts/dymola/Systems/CyberAttack/ShoulderSeason/Scenario3_SignalDelaying.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>The example shows how to inject a cyber attack on the AHU fan speed controller. The attack model is signal delaying. 
Under attack, the fan speed signal from the controller is delayed 30 minutes. 
The delaying lasts for 6 hours from 12pm on the third day.
</p>
</html>"));
end Scenario3_SignalDelaying;
