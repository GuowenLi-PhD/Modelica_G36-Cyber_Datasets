within FaultInjection.Systems.PhysicalFault.Chicago.ShoulderSeason;
model Scenario2_CoilValveStuck
  extends
    FaultInjection.Systems.PhysicalFault.Chicago.ShoulderSeason.BaselineSystem(
      faultCoiVavStu(active=true), watVal(yStu=1))
annotation (experiment(
      StartTime=11836800,
      StopTime=12441600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://FaultInjection/Resources/Scripts/dymola/Systems/PhysicalFault/Chicago/ShoulderSeason/Scenario2_CoilValveStuck.mos"
        "Simulate and Plot"));
end Scenario2_CoilValveStuck;
