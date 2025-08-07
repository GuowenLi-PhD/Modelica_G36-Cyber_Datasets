within FaultInjection.Equipment.ParameterFaults.Examples;
model WetCoilCounterFlowStoreStateVariables
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Water;
  package Medium2 = Buildings.Media.Air;
  // fault parameters
  parameter Modelica.SIunits.ThermalConductance UA_nominal(fixed=false)
    "Thermal conductance at nominal flow, used to compute heat capacity";

  // external fault singals for the parameter
  parameter String faultParameters = Modelica.Utilities.Files.loadResource("faultParameters.txt") annotation(Evaluate=false);
  // read start states
  parameter String inStates=Modelica.Utilities.Files.loadResource("inStates.txt");
  // Output system states for next time step: we ignore the system states in this example, because the thermal dynamics is fast in seconds.
  parameter String outStates = Modelica.Utilities.Files.loadResource("outStates.txt") "Output system states for next time step" annotation(Evaluate=false);

  parameter Real iniT1[nEle](fixed = false); //initial value for water temperature at each segment inlet
  parameter Real iniT2[nEle](fixed = false); //initial value for air temperature at each segment inlet
  parameter Real iniTmas[nEle](fixed = false); //initial value for mass tempertature each segment inlet
  parameter Real inider_Tmas[nEle](fixed = false); //initial value for mass tempertature differential each segment inlet
  parameter Real inip_w[nEle](fixed = false); //initial value for mass tempertature each segment inlet
  parameter Real inix_w[nEle](fixed = false); //initial value for mass tempertature differential each segment inlet

  Real out[6*nEle] "System states if any. Here set the size = 0";

  // normal parameters
  parameter Modelica.SIunits.Temperature T_a1_nominal=5 + 273.15;
  parameter Modelica.SIunits.Temperature T_b1_nominal=10 + 273.15;
  parameter Modelica.SIunits.Temperature T_a2_nominal=30 + 273.15;
  parameter Modelica.SIunits.Temperature T_b2_nominal=15 + 273.15;
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal=0.1
    "Nominal mass flow rate medium 1";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal=m1_flow_nominal*4200/
      1000*(T_a1_nominal - T_b1_nominal)/(T_b2_nominal - T_a2_nominal)
    "Nominal mass flow rate medium 2";

  parameter Integer nEle(min=1) = 4
    "Number of pipe segments used for discretization";

  Buildings.Fluid.Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium2,
    nPorts=1,
    use_p_in=false,
    p(displayUnit="Pa") = 101325,
    T=303.15) annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium2,
    nPorts=1,
    T=T_a2_nominal,
    X={0.02,1 - 0.02},
    use_T_in=true,
    use_X_in=true,
    p(displayUnit="Pa") = 101325 + 300) annotation (Placement(transformation(
          extent={{140,10},{120,30}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = Medium1,
    nPorts=1,
    use_p_in=false,
    p=300000,
    T=293.15) annotation (Placement(transformation(extent={{140,50},{120,70}})));
  Buildings.Fluid.Sources.MassFlowSource_T
                                      sou_1(
    redeclare package Medium = Medium1,
    m_flow=0.1412,
    use_T_in=true,
    nPorts=1)      annotation (Placement(transformation(extent={{-40,50},{-20,
            70}})));
  Buildings.Fluid.FixedResistances.PressureDrop res_2(
    from_dp=true,
    redeclare package Medium = Medium2,
    dp_nominal=100,
    m_flow_nominal=m2_flow_nominal)
    annotation (Placement(transformation(extent={{-20,10},{-40,30}})));
  Buildings.Fluid.FixedResistances.PressureDrop res_1(
    from_dp=true,
    redeclare package Medium = Medium1,
    dp_nominal=3000,
    m_flow_nominal=m1_flow_nominal)
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSen(redeclare package Medium =
               Medium2, m_flow_nominal=m2_flow_nominal)
    annotation (Placement(transformation(extent={{20,10},{0,30}})));
  FaultWetCoilCounterFlowStoreStateVariables hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp2_nominal(displayUnit="Pa") = 200,
    allowFlowReversal1=true,
    allowFlowReversal2=true,
    dp1_nominal(displayUnit="Pa") = 3000,
    show_T=true,
    UA_nominal=UA_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nEle=nEle,
    iniT1=iniT1,
    iniT2=iniT2,
    iniTmas=iniTmas,
    inider_Tmas=inider_Tmas,
    inip_w=inip_w,
    inix_w=inix_w)
    annotation (Placement(transformation(extent={{60,16},{80,36}})));
  Modelica.Blocks.Sources.Constant const(k=0.8)
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Buildings.Utilities.Psychrometrics.X_pTphi x_pTphi(use_p_in=false)
    annotation (Placement(transformation(extent={{150,-42},{170,-22}})));
  Modelica.Blocks.Sources.Constant const1(k=T_a2_nominal)
    annotation (Placement(transformation(extent={{100,-38},{120,-18}})));
  Modelica.Blocks.Sources.Constant TWat(k=T_a1_nominal)
                   "Water temperature, raised to high value at t=3000 s"
    annotation (Placement(transformation(extent={{-80,54},{-60,74}})));

  // added for injecting faulty parameters
initial algorithm
  for i in 1:nEle loop
    iniT1[i] := Modelica.Utilities.Examples.readRealParameter(inStates, "ini"+integerString(number=i));
  end for;
  for i in 1:nEle loop
    iniT2[i] := Modelica.Utilities.Examples.readRealParameter(inStates, "ini"+integerString(number=i+nEle));
  end for;
  for i in 1:nEle loop
    iniTmas[i] := Modelica.Utilities.Examples.readRealParameter(inStates, "ini"+integerString(number=i+2*nEle));
  end for;
  for i in 1:nEle loop
    inider_Tmas[i] := Modelica.Utilities.Examples.readRealParameter(inStates, "ini"+integerString(number=i+3*nEle));
  end for;
  for i in 1:nEle loop
    inip_w[i] := Modelica.Utilities.Examples.readRealParameter(inStates, "ini"+integerString(number=i+4*nEle));
  end for;
  for i in 1:nEle loop
    inix_w[i] := Modelica.Utilities.Examples.readRealParameter(inStates, "ini"+integerString(number=i+5*nEle));
  end for;

 if (outStates <> "") then
    Modelica.Utilities.Files.removeFile(outStates);
 end if;

 // read fault parameters
  UA_nominal := Modelica.Utilities.Examples.readRealParameter(faultParameters,"UA_nominal");

 // read initial states for simulation if any

algorithm
    when terminal() then
      for i in 1:scalar(size(out)) loop
        Modelica.Utilities.Streams.print("ini"+integerString(number=i,minimumWidth=1)+"  =  "+realString(number=out[i],minimumWidth=1),outStates);
      end for;
    end when;

equation
  out[1:nEle] = hex.outT1;
  out[(nEle+1):(2*nEle)] = hex.outT2;
  out[(2*nEle+1):(3*nEle)] = hex.outTmas;
  out[(3*nEle+1):(4*nEle)] = hex.outder_Tmas;
  out[(4*nEle+1):(5*nEle)] = hex.outp_w;
  out[(5*nEle+1):(6*nEle)] = hex.outx_w;

  connect(hex.port_b1, res_1.port_a) annotation (Line(points={{80,32},{86,32},{
          86,60},{90,60}}, color={0,127,255}));
  connect(sin_1.ports[1], res_1.port_b) annotation (Line(
      points={{120,60},{110,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_2.ports[1], res_2.port_b) annotation (Line(
      points={{-60,20},{-40,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_2.ports[1], hex.port_a2) annotation (Line(
      points={{120,20},{80,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_b2, temSen.port_a) annotation (Line(
      points={{60,20},{20,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temSen.port_b, res_2.port_a) annotation (Line(
      points={{-5.55112e-16,20},{-20,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(x_pTphi.X, sou_2.X_in) annotation (Line(
      points={{171,-32},{178,-32},{178,-34},{186,-34},{186,16},{142,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, x_pTphi.phi) annotation (Line(
      points={{121,-60},{136,-60},{136,-38},{148,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const1.y, x_pTphi.T) annotation (Line(
      points={{121,-28},{134,-28},{134,-32},{148,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const1.y, sou_2.T_in) annotation (Line(
      points={{121,-28},{134,-28},{134,0},{160,0},{160,24},{142,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TWat.y, sou_1.T_in) annotation (Line(
      points={{-59,64},{-42,64}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(sou_1.ports[1], hex.port_a1) annotation (Line(points={{-20,60},{40,60},
          {40,32},{60,32}}, color={0,127,255}));
  annotation ( Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{200,120}})),
      experiment(StopTime=3600));
end WetCoilCounterFlowStoreStateVariables;
