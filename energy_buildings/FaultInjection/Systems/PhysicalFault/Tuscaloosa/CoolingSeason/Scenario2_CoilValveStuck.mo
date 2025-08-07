within FaultInjection.Systems.PhysicalFault.Tuscaloosa.CoolingSeason;
model Scenario2_CoilValveStuck
  extends
    FaultInjection.Systems.PhysicalFault.Tuscaloosa.CoolingSeason.BaselineSystem(
      faultCoiVavStu(active=true), watVal(yStu=0))
  annotation (experiment(
      StartTime=16934400,
      StopTime=17539200,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://FaultInjection/Resources/Scripts/dymola/Systems/PhysicalFault/Tuscaloosa/CoolingSeason/Scenario2_CoilValveStuck.mos"
        "Simulate and Plot"));
end Scenario2_CoilValveStuck;
