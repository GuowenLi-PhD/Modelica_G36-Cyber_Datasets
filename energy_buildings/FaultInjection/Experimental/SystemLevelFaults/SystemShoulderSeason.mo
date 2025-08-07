within FaultInjection.Experimental.SystemLevelFaults;
model SystemShoulderSeason
  extends FaultInjection.Experimental.SystemLevelFaults.System(
    flo(
      cor(T_start=273.15 + 24),
      sou(T_start=273.15 + 24),
      eas(T_start=273.15 + 24),
      wes(T_start=273.15 + 24),
      nor(T_start=273.15 + 24)),
    conAHU(kTSup=0.01));
  annotation (experiment(
      StartTime=11836800,
      StopTime=12441600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"), __Dymola_Commands(file=
          "Resources/Scripts/dymola/Experimental/SystemLevelFaults/SystemShoulderSeason.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>This example is to test the  system performance in a week under a shoulder season.</p>
</html>"));
end SystemShoulderSeason;
