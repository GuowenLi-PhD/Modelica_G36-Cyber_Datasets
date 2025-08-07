within FaultInjection.Schedules.Examples;
model Occupancy
  extends Modelica.Icons.Example;

  FaultInjection.Schedules.Occupany occ annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  annotation (
    experiment(
      StopTime=2678400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file="modelica://FaultInjection/Resources/Scripts/dymola/Schedules/Examples/Occupancy.mos"
        "Simulate and Plot"));
end Occupancy;
