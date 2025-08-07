within FaultInjection.Systems.AnnualSimulation.DebugPI;
model CoolingSeason
  extends FaultInjection.Systems.AnnualSimulation.DebugPI.HeatingSeason(
        conAHU(kMinOut=0.05,
        kTSup=0.5));
   annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-400,-400},{1440,
            750}})),
experiment(
      StopTime=31536000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://FaultInjection/Resources/Scripts/dymola/Systems/AnnualSimulation/DebugPI/CoolingSeason.mos"
        "Simulate and Plot"));
end CoolingSeason;
