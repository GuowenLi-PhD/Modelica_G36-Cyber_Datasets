within FaultInjection.Systems.PhysicalFault.Chicago.CoolingSeason;
model Scenario3_OADamperLeakage
  extends
    FaultInjection.Systems.PhysicalFault.Chicago.CoolingSeason.BaselineSystem(
      eco(damOut(l=0.05)));

    annotation (Placement(transformation(extent={{-114,-18},{-94,2}})),
            experiment(
      StartTime=17625600,
      StopTime=18230400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://FaultInjection/Resources/Scripts/dymola/Systems/PhysicalFault/Chicago/CoolingSeason/Scenario3_OADamperLeakage.mos"
        "Simulate and Plot"));
end Scenario3_OADamperLeakage;
