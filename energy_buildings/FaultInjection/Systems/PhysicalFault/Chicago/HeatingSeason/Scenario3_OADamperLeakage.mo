within FaultInjection.Systems.PhysicalFault.Chicago.HeatingSeason;
model Scenario3_OADamperLeakage
  extends
    FaultInjection.Systems.PhysicalFault.Chicago.HeatingSeason.BaselineSystem(
      eco(damOut(l=0.05)));

    annotation (Placement(transformation(extent={{-114,-18},{-94,2}})),
            experiment(
      StartTime=259200,
      StopTime=864000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://FaultInjection/Resources/Scripts/dymola/Systems/PhysicalFault/Chicago/HeatingSeason/Scenario3_OADamperLeakage.mos"
        "Simulate and Plot"));
end Scenario3_OADamperLeakage;
