within FaultInjection.Systems.PhysicalFaultHeating;
model Scenario1_OADamperStuck
  extends FaultInjection.Systems.PhysicalFaultHeating.BaselineSystem(
      faultOADamStu(active=true), eco(yStu=1),
    boiTSup(yMin=0));
annotation (experiment(
      StartTime=259200,
      StopTime=864000,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file="Resources/Scripts/dymola/Systems/PhysicalFaultsHeating/Scenario1_OADamperStuck.mos"
        "Simulate and Plot"));
end Scenario1_OADamperStuck;
