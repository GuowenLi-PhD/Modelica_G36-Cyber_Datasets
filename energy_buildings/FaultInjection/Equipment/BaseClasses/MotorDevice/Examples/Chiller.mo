within FaultInjection.Equipment.BaseClasses.MotorDevice.Examples;
model Chiller
  import FaultInjection.Equipment.BaseClasses.MotorDevice;
  extends Modelica.Icons.Example;
 package Medium1 = Buildings.Media.Water "Medium model";
 package Medium2 = Buildings.Media.Water "Medium model";

  parameter Modelica.SIunits.Power P_nominal=10E3
    "Nominal compressor power (at y=1)";
  parameter Modelica.SIunits.TemperatureDifference dTEva_nominal=-10
    "Temperature difference evaporator outlet-inlet";
  parameter Modelica.SIunits.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";
  parameter Real COPc_nominal = 3 "Chiller COP";

  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal=
     -P_nominal*COPc_nominal/dTEva_nominal/4200
    "Nominal mass flow rate at chilled water side";
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal=
    m2_flow_nominal*(COPc_nominal+1)/COPc_nominal
    "Nominal mass flow rate at condenser water wide";

  MotorDevice.Chiller chiller(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    dp1_nominal=6000,
    dp2_nominal=6000,
    use_eta_Carnot_nominal=false,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    QEva_flow_nominal=m1_flow_nominal*4180*dTEva_nominal,
    QCon_flow_nominal=m2_flow_nominal*4180*dTCon_nominal,
    dTEva_nominal=dTEva_nominal,
    dTCon_nominal=dTCon_nominal,
    P_nominal=P_nominal,
    COP_nominal=COPc_nominal,
    R_s=0.245,
    R_r=0.23,
    X_s=0.1,
    X_r=0.4,
    X_m=0.25,
    Nrpm_nominal=3000)
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium1,
    use_T_in=true,
    m_flow=m1_flow_nominal,
    T=298.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,6},{-40,26}})));
  Buildings.Obsolete.Fluid.Sources.FixedBoundary sin2(redeclare package
      Medium =
        Medium2, nPorts=1) annotation (Placement(transformation(extent={{-10,-10},
            {10,10}}, origin={-50,-20})));
  Modelica.Blocks.Sources.Ramp TCon_in(
    height=10,
    duration=60,
    offset=273.15 + 20,
    startTime=60) "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = Medium2,
    use_T_in=true,
    m_flow=m2_flow_nominal,
    T=291.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{60,-6},{40,14}})));
  Buildings.Obsolete.Fluid.Sources.FixedBoundary sin1(redeclare package
      Medium =
        Medium1, nPorts=1) annotation (Placement(transformation(extent={{10,-10},
            {-10,10}}, origin={70,40})));
  Modelica.Blocks.Sources.Ramp TEva_in(
    height=10,
    duration=60,
    startTime=900,
    offset=273.15 + 15) "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{50,-40},{70,-20}})));
  Modelica.Blocks.Sources.Ramp Vrms(
    duration=60,
    startTime=60,
    height=20,
    offset=208) "Voltage"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Sources.Ramp f(
    duration=60,
    startTime=60,
    height=0,
    offset=50) "Voltage"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
equation
  connect(TCon_in.y,sou1. T_in) annotation (Line(
      points={{-69,20},{-62,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEva_in.y,sou2. T_in) annotation (Line(
      points={{71,-30},{80,-30},{80,8},{62,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(chiller.port_a1, sou1.ports[1])
    annotation (Line(points={{0,16},{-40,16}}, color={0,127,255}));
  connect(chiller.port_b1, sin1.ports[1]) annotation (Line(points={{20,16},{40,16},
          {40,40},{60,40}}, color={0,127,255}));
  connect(chiller.port_a2, sou2.ports[1])
    annotation (Line(points={{20,4},{40,4}}, color={0,127,255}));
  connect(chiller.port_b2, sin2.ports[1]) annotation (Line(points={{0,4},{-20,4},
          {-20,-20},{-40,-20}}, color={0,127,255}));
  connect(Vrms.y, chiller.V_rms)
    annotation (Line(points={{-59,90},{10,90},{10,22}}, color={0,0,127}));
  connect(f.y, chiller.f_in)
    annotation (Line(points={{-59,50},{2,50},{2,22}}, color={0,0,127}));
  annotation (__Dymola_Commands(file=
          "Resources/Scripts/Dymola/Examples/Chiller.mos" "Simulate and Plot"));
end Chiller;
