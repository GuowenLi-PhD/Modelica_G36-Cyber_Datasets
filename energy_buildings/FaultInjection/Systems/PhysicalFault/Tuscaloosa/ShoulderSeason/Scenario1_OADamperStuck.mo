within FaultInjection.Systems.PhysicalFault.Tuscaloosa.ShoulderSeason;
model Scenario1_OADamperStuck
  extends
    FaultInjection.Systems.PhysicalFault.Tuscaloosa.ShoulderSeason.BaselineSystem(
      faultOADamStu(active=true), eco(yStu=1));
annotation (experiment(
      StartTime=27043200,
      StopTime=27648000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://FaultInjection/Resources/Scripts/dymola/Systems/PhysicalFault/Tuscaloosa/ShoulderSeason/Scenario1_OADamperStuck.mos"
        "Simulate and Plot"));
end Scenario1_OADamperStuck;
