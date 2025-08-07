within FaultInjection.Systems.PhysicalFault.Tuscaloosa.CoolingSeason;
model Scenario3_OADamperLeakage
  extends
    FaultInjection.Systems.PhysicalFault.Tuscaloosa.CoolingSeason.BaselineSystem(
      eco(damOut(l=0.05)));

    annotation (Placement(transformation(extent={{-114,-18},{-94,2}})),
            experiment(
      StartTime=16934400,
      StopTime=17539200,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://FaultInjection/Resources/Scripts/dymola/Systems/PhysicalFault/Tuscaloosa/CoolingSeason/Scenario3_OADamperLeakage.mos"
        "Simulate and Plot"));
end Scenario3_OADamperLeakage;
