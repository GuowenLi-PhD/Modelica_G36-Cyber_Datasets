within FaultInjection.Systems.PhysicalFault.Tuscaloosa.HeatingSeason;
model Scenario2_CoilValveStuck
  extends
    FaultInjection.Systems.PhysicalFault.Tuscaloosa.HeatingSeason.BaselineSystem(
      faultHeaVavStu(active=true), watVal(yStu=0))
  annotation (experiment(
      StartTime=30326400,
      StopTime=30931200,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://FaultInjection/Resources/Scripts/dymola/Systems/PhysicalFault/Tuscaloosa/HeatingSeason/Scenario2_CoilValveStuck.mos"
        "Simulate and Plot"));
end Scenario2_CoilValveStuck;
