within FaultInjection.Systems.AnnualSimulation;
model Annual
  extends FaultInjection.Systems.AnnualSimulation.DebugPI.HeatingSeason(
          conAHU(kMinOut=
          0.05, kTSup=0.01),
          weaDat(filNam=
          ModelicaServices.ExternalReferences.loadResource(
          "modelica://Buildings/Resources/weatherdata/USA_AL_Tuscaloosa.Muni.AP.722286_TMY3.mos")),
          each TZonSet(zonSta(hys4(uLow=-1.2, uHigh=-1))));
   annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-400,-400},{1440,
            750}})),
experiment(
      StartTime=0,
      StopTime=31536000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://FaultInjection/Resources/Scripts/dymola/Systems/AnnualSimulation/Annual.mos"
        "Simulate and Plot"));
end Annual;
