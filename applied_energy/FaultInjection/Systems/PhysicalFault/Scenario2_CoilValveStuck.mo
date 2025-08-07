within FaultInjection.Systems.PhysicalFault;
model Scenario2_CoilValveStuck
  extends  FaultInjection.Systems.PhysicalFault.BaselineSystem(faultCoiVavStu(
        active=true), watVal(yStu=0))
annotation (experiment(
      StartTime=17625600,
      StopTime=18230400,
      Interval=60,
      Tolerance=1e-06));

  annotation (experiment(
      StartTime=17625600,
      StopTime=18230400,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
__Dymola_Commands(file="Resources/Scripts/dymola/Systems/PhysicalFaults/Scenario2_CoilValveStuck.mos"
        "Simulate and Plot"));
end Scenario2_CoilValveStuck;
