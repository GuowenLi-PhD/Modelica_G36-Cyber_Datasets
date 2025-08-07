within FaultInjection.Systems.PhysicalFault.Tuscaloosa.ShoulderSeason;
model Scenario2_CoilValveStuck
  extends
    FaultInjection.Systems.PhysicalFault.Tuscaloosa.ShoulderSeason.BaselineSystem(
      faultCoiVavStu(active=true), watVal(yStu=1))
annotation (experiment(
      StartTime=27043200,
      StopTime=27648000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://FaultInjection/Resources/Scripts/dymola/Systems/PhysicalFault/Tuscaloosa/ShoulderSeason/Scenario2_CoilValveStuck.mos"
        "Simulate and Plot"));
end Scenario2_CoilValveStuck;
