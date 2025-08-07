within FaultInjection.Systems.PhysicalFault.Chicago.ShoulderSeason;
model Scenario1_OADamperStuck
  extends
    FaultInjection.Systems.PhysicalFault.Chicago.ShoulderSeason.BaselineSystem(
      faultOADamStu(active=true), eco(yStu=1));
annotation (experiment(
      StartTime=11836800,
      StopTime=12441600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://FaultInjection/Resources/Scripts/dymola/Systems/PhysicalFault/Chicago/ShoulderSeason/Scenario1_OADamperStuck.mos"
        "Simulate and Plot"));
end Scenario1_OADamperStuck;
