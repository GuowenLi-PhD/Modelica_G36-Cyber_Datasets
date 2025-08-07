within FaultInjection.Systems.PhysicalFaultHeating;
model Scenario2_CoilValveStuck
  extends FaultInjection.Systems.PhysicalFaultHeating.BaselineSystem(
      faultHeaVavStu(active=true), watVal(yStu=0),
    HWVal(yStu=0.15))
annotation (experiment(
      StartTime=259200,
      StopTime=864000,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file="Resources/Scripts/dymola/Systems/PhysicalFaultsHeating/Scenario2_CoilValveStuck.mos"
        "Simulate and Plot"));
  annotation (experiment(
      StartTime=259200,
      StopTime=864000,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
      __Dymola_Commands(file="Resources/Scripts/dymola/Systems/PhysicalFaultsHeating/Scenario2_CoilValveStuck.mos"
        "Simulate and Plot"));
end Scenario2_CoilValveStuck;
