within FaultInjection.Systems.PhysicalFault.Chicago.HeatingSeason.BaseClasses;
partial model PartialWaterside
  "Partial model that implements water-side cooling system"
  package MediumA = Buildings.Media.Air "Medium model for air";
  package MediumW = Buildings.Media.Water "Medium model for water";

  // Chiller parameters
  parameter Integer numChi=1 "Number of chillers";
  parameter Modelica.SIunits.MassFlowRate m1_flow_chi_nominal= -QEva_nominal*(1+1/COP_nominal)/4200/6.5
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.SIunits.MassFlowRate m2_flow_chi_nominal= QEva_nominal/4200/(5.56-11.56)
    "Nominal mass flow rate at evaporator water in the chillers";
  parameter Modelica.SIunits.PressureDifference dp1_chi_nominal = 46.2*1000
    "Nominal pressure";
  parameter Modelica.SIunits.PressureDifference dp2_chi_nominal = 44.8*1000
    "Nominal pressure";
  parameter Modelica.SIunits.Power QEva_nominal
    "Nominal cooling capaciaty(Negative means cooling)";
 // WSE parameters
  parameter Modelica.SIunits.MassFlowRate m1_flow_wse_nominal= m1_flow_chi_nominal
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.SIunits.MassFlowRate m2_flow_wse_nominal= m2_flow_chi_nominal
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.SIunits.PressureDifference dp1_wse_nominal = 33.1*1000
    "Nominal pressure";
  parameter Modelica.SIunits.PressureDifference dp2_wse_nominal = 34.5*1000
    "Nominal pressure";
  parameter Real COP_nominal=5.9 "COP";
  parameter FaultInjection.Experimental.SystemLevelFaults.Data.Chiller[numChi] perChi(
    each QEva_flow_nominal=QEva_nominal,
    each COP_nominal=COP_nominal,
    each mEva_flow_nominal=m2_flow_chi_nominal,
    each mCon_flow_nominal=m1_flow_chi_nominal);

  parameter Buildings.Fluid.Movers.Data.Generic perPumCW(
    each pressure=
          Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
          V_flow=m1_flow_chi_nominal/1000*pumCWVFloArr,
          dp=(dp1_chi_nominal+133500+30000+6000)*pumCWPreArr),
    each motorEfficiency=Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters(
          V_flow={0},eta=pumCWetaArr))
    "Performance data for condenser water pumps";
    parameter Real pumCWPreArr [4]= {1.2,1.1,1.0,0.6}
      "Pressure performance data for cooling water primary pumps";
    parameter Real pumCWetaArr [1]= {0.7}
      "Efficiency for cooling water primary pumps";
    parameter Real pumCWVFloArr [4]= {0.2,0.6,1.0,1.2}
      "Flow rate performance data for cooling water primary pumps";
  // Set point
  parameter Modelica.SIunits.Temperature TCHWSet = 273.15 + 6
    "Chilled water temperature setpoint";
  parameter Modelica.SIunits.Pressure dpSetPoi = 36000
    "Differential pressure setpoint at cooling coil";

  Experimental.SystemLevelFaults.Controls.ChillerStage chiStaCon(tWai=0)
    "Chiller staging control"
    annotation (Placement(transformation(extent={{1286,-138},{1306,-118}})));
  Modelica.Blocks.Math.RealToBoolean chiOn "Real value to boolean value"
    annotation (Placement(transformation(extent={{1326,-138},{1346,-118}})));
  Modelica.Blocks.Math.IntegerToBoolean intToBoo(threshold=Integer(FaultInjection.Experimental.SystemLevelFaults.Types.CoolingModes.FullMechanical))
    "Inverse on/off signal for the WSE"
    annotation (Placement(transformation(extent={{1286,-164},{1306,-144}})));
  Modelica.Blocks.Logical.Not wseOn "True: WSE is on; False: WSE is off "
    annotation (Placement(transformation(extent={{1326,-164},{1346,-144}})));
  Experimental.SystemLevelFaults.Controls.ConstantSpeedPumpStage CWPumCon(tWai=0)
    "Condenser water pump controller"
    annotation (Placement(transformation(extent={{1284,-216},{1304,-196}})));
  Modelica.Blocks.Sources.IntegerExpression chiNumOn(y=integer(sum(chiStaCon.y)))
    "The number of running chillers"
    annotation (Placement(transformation(extent={{1208,-186},{1230,-164}})));
  Modelica.Blocks.Math.Gain gai(each k=1)                   "Gain effect"
    annotation (Placement(transformation(extent={{1326,-216},{1346,-196}})));
  Experimental.SystemLevelFaults.Controls.CoolingTowerSpeed cooTowSpeCon(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMin=0,
    Ti=60,
    k=0.1) "Cooling tower speed control"
    annotation (Placement(transformation(extent={{1286,-106},{1306,-90}})));
  Modelica.Blocks.Sources.RealExpression TCWSupSet(y=min(29.44 + 273.15, max(273.15
         + 15.56, cooTow.TAir + 3)))
    "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{1196,-100},{1216,-80}})));
  replaceable FaultInjection.Experimental.SystemLevelFaults.BaseClasses.PartialChillerWSEChillerFault chiWSE(
    redeclare replaceable package Medium1 = MediumW,
    redeclare replaceable package Medium2 = MediumW,
    numChi=numChi,
    m1_flow_chi_nominal=m1_flow_chi_nominal,
    m2_flow_chi_nominal=m2_flow_chi_nominal,
    m1_flow_wse_nominal=m1_flow_wse_nominal,
    m2_flow_wse_nominal=m2_flow_wse_nominal,
    dp1_chi_nominal=dp1_chi_nominal,
    dp1_wse_nominal=dp1_wse_nominal,
    dp2_chi_nominal=dp2_chi_nominal,
    dp2_wse_nominal=dp2_wse_nominal,
    perChi = perChi,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    use_controller=false,
    chiFauMod=chiFauMod)
    "Chillers and waterside economizer"
    annotation (Placement(transformation(extent={{694,-198},{674,-218}})));
  Buildings.Fluid.Sources.Boundary_pT expVesCW(redeclare replaceable package
      Medium = MediumW, nPorts=1)
    "Expansion tank"
    annotation (Placement(transformation(extent={{-9,-9.5},{9,9.5}},
        rotation=180,
        origin={969,-299.5})));
  Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel cooTow(
    redeclare each replaceable package Medium = MediumW,
    ratWatAir_nominal=1.5,
    each TAirInWB_nominal(displayUnit="degC") = 273.15 + 25.55,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    each dp_nominal=30000,
    each m_flow_nominal=m1_flow_chi_nominal,
    TWatIn_nominal=273.15 + 35,
    TWatOut_nominal=((273.15 + 35) - 273.15 - 5.56) + 273.15,
    each PFan_nominal=4300)  "Cooling tower" annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={748,-316})));

  Equipment.VariableFaults.FaultTemperatureSensor TCHWSup(redeclare
      replaceable package Medium = MediumW, m_flow_nominal=numChi*
        m2_flow_chi_nominal) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{778,-138},{758,-118}})));
  Equipment.VariableFaults.FaultTemperatureSensor TCWSup(
    redeclare replaceable package Medium = MediumW,
    m_flow_nominal=numChi*m1_flow_chi_nominal,
    faultMode=faultTCWSup) "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{818,-326},{838,-306}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWRet(redeclare replaceable
      package Medium = MediumW, m_flow_nominal=numChi*m1_flow_chi_nominal)
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{534,-326},{554,-306}})));
  Buildings.Fluid.Movers.SpeedControlled_y pumCW(
    redeclare each replaceable package Medium = MediumW,
    addPowerToMedium=false,
    per=perPumCW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
                                "Condenser water pump" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={910,-288})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWRet(redeclare replaceable
      package Medium = MediumW, m_flow_nominal=numChi*m2_flow_chi_nominal)
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{618,-198},{598,-178}})));
  Buildings.Fluid.Sources.Boundary_pT expVesChi(redeclare replaceable package
      Medium = MediumW, nPorts=1)
    "Expansion tank"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={512,-179})));
  Equipment.VariableFaults.FaultRelativePressureSensor senRelPre(redeclare
      replaceable package Medium = MediumW, faultMode=faultRelPre)
    "Differential pressure"
    annotation (Placement(transformation(extent={{578,-130},{558,-150}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val(
    redeclare each package Medium = MediumW,
    m_flow_nominal=m1_flow_chi_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=133500) "Shutoff valves"
    annotation (Placement(transformation(extent={{636,-326},{656,-306}})));
  Buildings.Controls.Continuous.LimPID pumSpe(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=40,
    yMin=0.2,
    k=0.1,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=0)
           "Pump speed controller"
    annotation (Placement(transformation(extent={{1340,-258},{1360,-238}})));
  Modelica.Blocks.Math.Gain dpGai(k=1/dpSetPoi) "Gain effect"
    annotation (Placement(transformation(extent={{1280,-292},{1300,-272}})));
  Equipment.VariableFaults.StuckValve watVal(faultMode=
       faultCoiVavStu, dpFixed_nominal=0)
    "Two-way valve"
     annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={538,-108})));
  Buildings.Fluid.FixedResistances.Pipe resCHW(
    m_flow_nominal=m2_flow_chi_nominal,
    redeclare package Medium = MediumW,
    dp_nominal=150000,
    thicknessIns=0.01,
    lambdaIns=0.04,
    length=0,
    v_nominal=1.2)
              "Resistance in chilled water loop"
    annotation (Placement(transformation(extent={{760,-200},{780,-180}})));
  Experimental.SystemLevelFaults.Controls.TemperatureDifferentialPressureReset
    temDifPreRes(
    dpMin(displayUnit="Pa"),
    dpMax(displayUnit="Pa"),
    TMin(displayUnit="K"),
    TMax(displayUnit="K"))
    annotation (Placement(transformation(extent={{1192,-252},{1212,-232}})));
  Modelica.Blocks.Math.Gain dpSetGai(k=1/dpSetPoi) "Gain effect"
    annotation (Placement(transformation(extent={{1280,-258},{1300,-238}})));
  parameter Utilities.InsertionTypes.Generic.faultMode faultCoiVavStu
    "Cooling coil valve stuck fault"
    annotation (Placement(transformation(extent={{506,-146},{526,-126}})));
  parameter Utilities.InsertionTypes.Generic.faultMode faultTCHWSup
    "Chilled water supply temperature sensor fault"
    annotation (Placement(transformation(extent={{698,-120},{718,-100}})));
  parameter Utilities.InsertionTypes.Generic.faultMode faultTCWSup
    "Cooling water supply temperature sensor fault"
    annotation (Placement(transformation(extent={{780,-306},{800,-286}})));
  parameter Utilities.InsertionTypes.Generic.faultMode faultRelPre
    "Chilled water loop differential pressure sensor fault"
    annotation (Placement(transformation(extent={{558,-174},{578,-154}})));
  parameter Utilities.InsertionTypes.Generic.ChillerFaultMode[numChi] chiFauMod(
    each startTime=17625600,
    each endTime=18230400,
    each fauIntRat=0.4)
    "Chiller fault mode" annotation (Dialog(group="Chiller"), Placement(
        transformation(extent={{674,-254},{694,-234}})));

  Utilities.InsertionTypes.Variables.SignalCorruption.Max maxCHWDifPre(
      faultMode=faultCHWDifPre)
    annotation (Placement(transformation(extent={{1240,-252},{1260,-232}})));
  parameter Utilities.InsertionTypes.Generic.faultMode faultCHWDifPre(minimum=
        0.5*dpSetPoi, maximum=dpSetPoi)
    "Chilled water differential pressure faulty setpoint"
    annotation (Placement(transformation(extent={{1240,-222},{1260,-202}})));
  Utilities.InsertionTypes.Variables.SignalCorruption.Max maxCHWTSupSet(
      faultMode=faultCHWTSupSet)
    annotation (Placement(transformation(extent={{1240,-280},{1260,-260}})));
  parameter Utilities.InsertionTypes.Generic.faultMode faultCHWTSupSet(minimum=5
         + 273.15, maximum=10 + 273.15)
    "Chilled water supply temperature faulty setpoint"
    annotation (Placement(transformation(extent={{1240,-310},{1260,-290}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TEnvCoo(T=288.15)
    annotation (Placement(transformation(extent={{700,-170},{720,-150}})));
  Buildings.Fluid.Delays.DelayFirstOrder del(
    redeclare package Medium = MediumW,
    m_flow_nominal=m2_flow_chi_nominal,
    tau=120,
    nPorts=2)
    annotation (Placement(transformation(extent={{720,-190},{740,-170}})));
equation

  connect(chiStaCon.y,chiOn. u)
    annotation (Line(
      points={{1307,-128},{1324,-128}},
      color={0,0,127}));
  connect(intToBoo.y,wseOn. u)
    annotation (Line(
      points={{1307,-154},{1324,-154}},
      color={255,0,255}));
  connect(TCWSupSet.y,cooTowSpeCon. TCWSupSet)
    annotation (Line(
      points={{1217,-90},{1284,-90}},
      color={0,0,127}));
  connect(dpGai.y, pumSpe.u_m) annotation (Line(points={{1301,-282},{1350,
          -282},{1350,-260}},               color={0,0,127}));

  connect(val.port_b,cooTow. port_a)
    annotation (Line(points={{656,-316},{738,-316}}, color={0,0,255},
      thickness=0.5));
  connect(TCWSup.port_b, expVesCW.ports[1]) annotation (Line(points={{838,-316},
          {938,-316},{938,-299.5},{960,-299.5}}, color={0,0,255},
      thickness=0.5));
  connect(senRelPre.p_rel, dpGai.u) annotation (Line(points={{568,-129},{568,
          -18},{1182,-18},{1182,-282},{1278,-282}}, color={0,0,127}));
  connect(CWPumCon.y[1], gai.u) annotation (Line(points={{1305,-206.5},{1306,
          -206.5},{1306,-206},{1324,-206}},
                                    color={0,0,127}));
  connect(chiWSE.port_a1, pumCW.port_b) annotation (Line(points={{694,-214},{
          708,-214},{708,-228},{910,-228},{910,-278}},
                                 color={0,0,255},
      thickness=0.5));
  connect(TCWSup.port_b, pumCW.port_a) annotation (Line(points={{838,-316},{910,
          -316},{910,-298}}, color={0,0,255},
      thickness=0.5));
  connect(cooTow.port_b, TCWSup.port_a)
    annotation (Line(points={{758,-316},{818,-316}}, color={0,0,255},
      thickness=0.5));
  connect(TCWRet.port_b, val.port_a)
    annotation (Line(points={{554,-316},{636,-316}}, color={0,0,255},
      thickness=0.5));
  connect(dpSetGai.y, pumSpe.u_s)
    annotation (Line(points={{1301,-248},{1338,-248}}, color={0,0,127}));
  connect(senRelPre.port_b, TCHWRet.port_b) annotation (Line(
      points={{558,-140},{538,-140},{538,-188},{598,-188}},
      color={28,108,200},
      thickness=0.5));
  connect(TCWRet.port_a,chiWSE. port_b1) annotation (Line(points={{534,-316},{
          502,-316},{502,-228},{664,-228},{664,-214},{674,-214}},
                                        color={0,0,255},
      thickness=0.5));
  connect(watVal.port_b, TCHWRet.port_b) annotation (Line(points={{538,-118},{
          538,-188},{598,-188}}, color={28,108,200},
      thickness=0.5));
  connect(expVesChi.ports[1], TCHWRet.port_b) annotation (Line(points={{522,
          -179},{538,-179},{538,-188},{598,-188}}, color={28,108,200},
      thickness=0.5));
  connect(senRelPre.port_a, TCHWSup.port_b) annotation (Line(
      points={{578,-140},{594,-140},{594,-128},{758,-128}},
      color={28,108,200},
      thickness=0.5));
  connect(temDifPreRes.dpSet, maxCHWDifPre.u) annotation (Line(points={{1213,
          -237},{1220,-237},{1220,-242},{1238,-242}}, color={0,0,127}));
  connect(maxCHWDifPre.y, dpSetGai.u) annotation (Line(points={{1261,-242},{
          1268,-242},{1268,-248},{1278,-248}}, color={235,0,0}));
  connect(temDifPreRes.TSet, maxCHWTSupSet.u) annotation (Line(points={{1213,
          -247},{1220,-247},{1220,-270},{1238,-270}}, color={0,0,127}));
  connect(chiNumOn.y, CWPumCon.numOnChi) annotation (Line(points={{1231.1,
          -175},{1270,-175},{1270,-211},{1282,-211}}, color={255,127,0}));
  connect(TCHWRet.port_a, chiWSE.port_a2) annotation (Line(
      points={{618,-188},{640,-188},{640,-202},{674,-202}},
      color={28,108,200},
      thickness=0.5));
  connect(resCHW.port_b, TCHWSup.port_a) annotation (Line(
      points={{780,-190},{910,-190},{910,-128},{778,-128}},
      color={28,108,200},
      thickness=0.5));
  connect(TEnvCoo.port, resCHW.heatPort) annotation (Line(points={{720,-160},
          {770,-160},{770,-185}}, color={191,0,0}));
  connect(chiWSE.port_b2, del.ports[1]) annotation (Line(
      points={{694,-202},{708,-202},{708,-190},{728,-190}},
      color={0,127,255},
      thickness=0.5));
  connect(resCHW.port_a, del.ports[2]) annotation (Line(
      points={{760,-190},{732,-190}},
      color={0,127,255},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-400,
            -500},{650,20}})), Documentation(info="<html>
<p>
This is a partial model that describes the chilled water cooling system in a data center. The sizing data
are collected from the reference.
</p>
<h4>Reference </h4>
<ul>
<li>
Taylor, S. T. (2014). How to design &amp; control waterside economizers. ASHRAE Journal, 56(6), 30-36.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
January 12, 2019, by Michael Wetter:<br/>
Removed wrong <code>each</code>.
</li>
<li>
December 1, 2017, by Yangyang Fu:<br/>
Used scaled differential pressure to control the speed of pumps. This can avoid retuning gains
in PID when changing the differential pressure setpoint.
</li>
<li>
September 2, 2017, by Michael Wetter:<br/>
Changed expansion vessel to use the more efficient implementation.
</li>
<li>
July 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialWaterside;
