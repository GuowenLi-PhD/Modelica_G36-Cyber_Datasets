within FaultInjection.Systems.CyberAttack.ShoulderSeason;
model BaselineSystem "Baseline"
  extends FaultInjection.Systems.CyberAttack.BaselineSystem(
    conAHU(kTSup=0.1,
        TiTSup=300),
    faultZoneTemp(
      startTime=83*24*3600 + 12*3600,
      endTime=83*24*3600 + 12*3600 + 3*3600),
    faultFanSpeed(
      startTime=83*24*3600 + 12*3600,
      endTime=83*24*3600 + 12*3600 + 3*3600),
    faultTZoneRequest(
      startTime=83*24*3600 + 12*3600,
      endTime=83*24*3600 + 12*3600 + 3*3600),
    faultCHWTSet(
      startTime=83*24*3600 + 12*3600,
      endTime=83*24*3600 + 12*3600 + 6*3600),
    TCHWSup(T_start=293.15),
    chiWSE(use_inputFilter=false));

  annotation (experiment(
      StartTime=6912000,
      StopTime=7516800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end BaselineSystem;
