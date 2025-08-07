within FaultInjection.Systems.CyberAttack.CoolingSeason;
model BaselineSystem "Baseline"
  extends FaultInjection.Systems.CyberAttack.BaselineSystem;

  annotation (experiment(
      StartTime=17625600,
      StopTime=18230400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end BaselineSystem;
