within FaultInjection.Systems.PhysicalFault.Tuscaloosa.CoolingSeason;
model Scenario1_OADamperStuck
  extends
    FaultInjection.Systems.PhysicalFault.Tuscaloosa.CoolingSeason.BaselineSystem(
      faultOADamStu(active=true), eco(yStu=0.55));
annotation (experiment(
      StartTime=16934400,
      StopTime=17539200,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://FaultInjection/Resources/Scripts/dymola/Systems/PhysicalFault/Tuscaloosa/CoolingSeason/Scenario1_OADamperStuck.mos"
        "Simulate and Plot"));
end Scenario1_OADamperStuck;
