within FaultInjection.Systems.PhysicalFault.Chicago.CoolingSeason;
model Scenario2_CoilValveStuck
  extends
    FaultInjection.Systems.PhysicalFault.Chicago.CoolingSeason.BaselineSystem(
      faultCoiVavStu(active=true), watVal(yStu=0))
  annotation (experiment(
      StartTime=17625600,
      StopTime=18230400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://FaultInjection/Resources/Scripts/dymola/Systems/PhysicalFault/Chicago/CoolingSeason/Scenario2_CoilValveStuck.mos"
        "Simulate and Plot"));
end Scenario2_CoilValveStuck;
