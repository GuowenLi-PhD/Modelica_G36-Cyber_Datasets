within FaultInjection.Systems.PhysicalFault.Chicago.HeatingSeason;
model Scenario1_OADamperStuck
  extends
    FaultInjection.Systems.PhysicalFault.Chicago.HeatingSeason.BaselineSystem(
      faultOADamStu(active=true), eco(yStu=0.55));
annotation (experiment(
      StartTime=259200,
      StopTime=864000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://FaultInjection/Resources/Scripts/dymola/Systems/PhysicalFault/Chicago/HeatingSeason/Scenario1_OADamperStuck.mos"
        "Simulate and Plot"));
end Scenario1_OADamperStuck;
