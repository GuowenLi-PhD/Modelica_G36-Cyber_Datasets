within FaultInjection.Systems.PhysicalFaultShoulder;
model Scenario3_OADamperLeakage
  extends FaultInjection.Systems.PhysicalFaultShoulder.BaselineSystem(eco(
        damOut(l=0.05)));

    annotation (Placement(transformation(extent={{-114,-18},{-94,2}})),
            experiment(
      StartTime=11836800,
      StopTime=12441600,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
              __Dymola_Commands(file="Resources/Scripts/dymola/Systems/PhysicalFaultsShoulder/Scenario3_OADamperLeakage.mos"
        "Simulate and Plot"));
end Scenario3_OADamperLeakage;
