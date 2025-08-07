within FaultInjection.Systems.PhysicalFaultShoulder;
model Scenario2_CoilValveStuck
  extends FaultInjection.Systems.PhysicalFaultShoulder.BaselineSystem(
      faultCoiVavStu(active=true), watVal(yStu=1))
annotation (experiment(
      StartTime=11836800,
      StopTime=12441600,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
      __Dymola_Commands(file="Resources/Scripts/dymola/Systems/PhysicalFaultsShoulder/Scenario2_CoilValveStuck.mos"
        "Simulate and Plot"));
annotation (experiment(
      StartTime=11836800,
      StopTime=12441600,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
      __Dymola_Commands(file="Resources/Scripts/dymola/Systems/PhysicalFaultsShoulder/Scenario2_CoilValveStuck.mos"
        "Simulate and Plot"));
end Scenario2_CoilValveStuck;
