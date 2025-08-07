within FaultInjection.Systems.PhysicalFault.Chicago.CoolingSeason;
model Scenario1_OADamperStuck
  extends
    FaultInjection.Systems.PhysicalFault.Chicago.CoolingSeason.BaselineSystem(
      faultOADamStu(active=true), eco(yStu=0.55));
annotation (experiment(
      StartTime=17625600,
      StopTime=18230400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://FaultInjection/Resources/Scripts/dymola/Systems/PhysicalFault/Chicago/CoolingSeason/Scenario1_OADamperStuck.mos"
        "Simulate and Plot"));
end Scenario1_OADamperStuck;
