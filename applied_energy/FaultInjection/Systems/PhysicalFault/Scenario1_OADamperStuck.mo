within FaultInjection.Systems.PhysicalFault;
model Scenario1_OADamperStuck
  extends FaultInjection.Systems.PhysicalFault.BaselineSystem(faultOADamStu(
        active=true), eco(yStu=0.55));
annotation (experiment(
      StartTime=17625600,
      StopTime=18230400,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file="Resources/Scripts/dymola/Systems/PhysicalFaults/Scenario1_OADamperStuck.mos"
        "Simulate and Plot"));
end Scenario1_OADamperStuck;
