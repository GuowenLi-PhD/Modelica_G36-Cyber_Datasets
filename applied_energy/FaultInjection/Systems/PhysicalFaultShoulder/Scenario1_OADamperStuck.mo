within FaultInjection.Systems.PhysicalFaultShoulder;
model Scenario1_OADamperStuck
  extends FaultInjection.Systems.PhysicalFaultShoulder.BaselineSystem(
      faultOADamStu(active=true), eco(yStu=1));
annotation (experiment(
      StartTime=11836800,
      StopTime=12441600,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file="Resources/Scripts/dymola/Systems/PhysicalFaultsShoulder/Scenario1_OADamperStuck.mos"
        "Simulate and Plot"));
end Scenario1_OADamperStuck;
