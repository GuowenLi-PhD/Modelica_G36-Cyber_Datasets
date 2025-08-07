within FaultInjection.Systems.PhysicalFault.Chicago.HeatingSeason;
model Scenario2_CoilValveStuck
  extends
    FaultInjection.Systems.PhysicalFault.Chicago.HeatingSeason.BaselineSystem(
      faultHeaVavStu(active=true), watVal(yStu=0))
  annotation (experiment(
      StartTime=259200,
      StopTime=864000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://FaultInjection/Resources/Scripts/dymola/Systems/PhysicalFault/Chicago/HeatingSeason/Scenario2_CoilValveStuck.mos"
        "Simulate and Plot"));
end Scenario2_CoilValveStuck;
