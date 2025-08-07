within FaultInjection.SystemIBPSA.CyberAttack.BaseClasses;
partial model RunTime "Equipment run time"

  Modelica.Blocks.Continuous.Integrator  chiRunTim "Chiller run time"
    annotation (Placement(transformation(extent={{1340,630},{1360,650}})));

  Modelica.Blocks.Continuous.Integrator boiRunTim "Boiler run time"
    annotation (Placement(transformation(extent={{1340,600},{1360,620}})));
  Modelica.Blocks.Continuous.Integrator supFanRunTim "Supply fan run time"
    annotation (Placement(transformation(extent={{1340,570},{1360,590}})));
  Modelica.Blocks.Continuous.Integrator cooTowRunTim "Cooling tower run time"
    annotation (Placement(transformation(extent={{1340,540},{1360,560}})));
  Modelica.Blocks.Continuous.Integrator  CHWPRunTim "CHWP run time"
    annotation (Placement(transformation(extent={{1400,630},{1420,650}})));
  Modelica.Blocks.Continuous.Integrator CWPRunTim "CWP run time"
    annotation (Placement(transformation(extent={{1400,600},{1420,620}})));
  Modelica.Blocks.Continuous.Integrator HWPRunTim "HWP run time"
    annotation (Placement(transformation(extent={{1400,570},{1420,590}})));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{1580,700}})), Icon(
        coordinateSystem(extent={{-100,-100},{1580,700}})));
end RunTime;
