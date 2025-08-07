within FaultInjection.Systems.PhysicalFault;
model Scenario3_OADamperLeakage
  extends  FaultInjection.Systems.PhysicalFault.BaselineSystem(eco(damOut(l=0.05)));

    annotation (Placement(transformation(extent={{-114,-18},{-94,2}})),
            experiment(
      StartTime=17625600,
      StopTime=18230400,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
              __Dymola_Commands(file="Resources/Scripts/dymola/Systems/PhysicalFaults/Scenario3_OADamperLeakage.mos"
        "Simulate and Plot"));
end Scenario3_OADamperLeakage;
