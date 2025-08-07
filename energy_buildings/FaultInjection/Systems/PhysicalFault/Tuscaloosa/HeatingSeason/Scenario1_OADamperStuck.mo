within FaultInjection.Systems.PhysicalFault.Tuscaloosa.HeatingSeason;
model Scenario1_OADamperStuck
  extends
    FaultInjection.Systems.PhysicalFault.Tuscaloosa.HeatingSeason.BaselineSystem(
      faultOADamStu(active=true), eco(yStu=0.55));
annotation (experiment(
      StartTime=30326400,
      StopTime=30931200,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://FaultInjection/Resources/Scripts/dymola/Systems/PhysicalFault/Tuscaloosa/HeatingSeason/Scenario1_OADamperStuck.mos"
        "Simulate and Plot"));
end Scenario1_OADamperStuck;
