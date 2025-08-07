within FaultInjection.Experimental.Regulation;
model SystemCoolSeason
  extends FaultInjection.Experimental.Regulation.System(flo(
      cor(T_start=273.15 + 24),
      sou(T_start=273.15 + 24),
      eas(T_start=273.15 + 24),
      wes(T_start=273.15 + 24),
      nor(T_start=273.15 + 24)), boiPlaEnaDis(tWai=10*60));
  annotation (experiment(
      startTime=17625600, stopTime=18230400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"), __Dymola_Commands(file=
          "Resources/Scripts/dymola/FaultInjection/Experimental/SystemLevelFaults/SystemCoolSeason.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>This example is to test the  system performance in a week under a cooling season.</p>
</html>"));
end SystemCoolSeason;
