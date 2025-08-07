within FaultInjection.SystemIBPSA.CyberAttack.ShoulderSeason;
model BaselineSystem "Baseline"
  extends FaultInjection.SystemIBPSA.CyberAttack.BaselineSystem(conAHU(
    kTSup=0.1,
    TiTSup=300));

  annotation (experiment(
      StartTime=6912000,
      StopTime=7516800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end BaselineSystem;
