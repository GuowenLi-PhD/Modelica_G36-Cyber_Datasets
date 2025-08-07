within FaultInjection.Experimental.Regulation;
model SystemHeatSeason
  extends System(conAHU(
    kTSup=0.1),
    pumSpeHW(k=0.5,
             y_reset=0),
    boiTSup(Ti=60, yMin=0.1),
    flo(gai(K=5*[0.4; 0.4; 0.2])));

  annotation (experiment(
      StartTime=259200,
      StopTime=864000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"), __Dymola_Commands(file=
          "Resources/Scripts/dymola/FaultInjection/Experimental/SystemLevelFaults/SystemHeatSeason.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>This example is to test the  system performance in a week under a heating season. It is noted that the supply air temperature control parameters need to be retuned for different load conditions.</p>
</html>"));
end SystemHeatSeason;
