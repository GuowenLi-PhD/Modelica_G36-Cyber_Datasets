within FaultInjection.Utilities.InsertionTypes.Connectors.Examples;
model ActuatorDelay "Test delay"
  import FaultInjection;
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model for air";

 parameter Generic.faultMode faultMode(startTime=100, endTime=125)
    annotation (Placement(transformation(extent={{-62,80},{-42,100}})));
  FaultInjection.Utilities.InsertionTypes.Connectors.Delay del(faultMode=
        faultMode)
    annotation (Placement(transformation(extent={{-26,40},{-6,60}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101335,
    nPorts=2,
    T=293.15) "Pressure boundary condition"
     annotation (Placement(
        transformation(extent={{-72,-10},{-52,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=2) "Pressure boundary condition"
      annotation (Placement(
        transformation(extent={{82,-10},{62,10}})));
  Buildings.Fluid.Actuators.Dampers.PressureIndependent preIndDel(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=10,
    use_inputFilter=false) "A damper with actuator delay"
    annotation (Placement(transformation(extent={{-10,-8},{10,12}})));
  Buildings.Fluid.Actuators.Dampers.PressureIndependent preInd(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=10,
    use_inputFilter=false)
    "A damper with a mass flow proportional to the input signal"
    annotation (Placement(transformation(extent={{-10,-52},{10,-32}})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=0.05,
    amplitude=0.5,
    offset=0.5)
    annotation (Placement(transformation(extent={{-74,40},{-54,60}})));
equation
  connect(sou.ports[1], preIndDel.port_a)
    annotation (Line(points={{-52,2},{-10,2}}, color={0,127,255}));
  connect(preIndDel.port_b, sin.ports[1])
    annotation (Line(points={{10,2},{62,2}}, color={0,127,255}));
  connect(del.y1, preIndDel.y)
    annotation (Line(points={{-5,50},{0,50},{0,14}}, color={0,0,127}));
  connect(sou.ports[2], preInd.port_a) annotation (Line(points={{-52,-2},{-40,
          -2},{-40,-42},{-10,-42}}, color={0,127,255}));
  connect(preInd.port_b, sin.ports[2]) annotation (Line(points={{10,-42},{40,
          -42},{40,-2},{62,-2}}, color={0,127,255}));
  connect(sine.y, del.u)
    annotation (Line(points={{-53,50},{-28,50}}, color={0,0,127}));
  connect(sine.y, preInd.y) annotation (Line(points={{-53,50},{-34,50},{-34,-22},
          {0,-22},{0,-30}}, color={0,0,127}));
  annotation (experiment(StopTime=300));
end ActuatorDelay;
