within FaultInjection.Equipment.BaseClasses.MotorDevice.Examples;
model DoubleCagePumpVoltage
  "Validate the simple electric pump model with changing voltage "
  import Modelica.Constants.pi;
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 0.06*1000;
  parameter Modelica.SIunits.Pressure dp_nominal = 25*188.5/(m_flow_nominal/1000);
  parameter Real p_nominal = m_flow_nominal*dp_nominal/0.7;

  MotorDevice.DoubleCagePump pum1(
    redeclare package Medium = Medium,
    per=per,
    Pbase=p_nominal)
    annotation (Placement(transformation(extent={{10,40},{30,60}})));
  Modelica.Blocks.Sources.Step freUp(
    startTime=400,
    offset=60,
    height=0)
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Sources.Step freDow(
    startTime=400,
    offset=60,
    height=0)
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  MotorDevice.DoubleCagePump pum2(
    redeclare package Medium = Medium,
    per=per,
    Pbase=p_nominal)
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Fluid.Sources.Boundary_pT bou1(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Fluid.Sources.Boundary_pT bou2(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{90,40},{70,60}})));
  Buildings.Fluid.Sources.Boundary_pT bou4(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{90,-50},{70,-30}})));
  Buildings.Fluid.FixedResistances.PressureDrop res2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Fluid.Sources.Boundary_pT bou3(nPorts=1, redeclare package
      Medium =
        Medium)
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  parameter Buildings.Fluid.Movers.Data.Generic per(
    pressure(V_flow=m_flow_nominal/1000*{0,0.41,0.54,0.66,0.77,0.89,1,1.12,1.19},
        dp=dp_nominal*{1.461,1.455,1.407,1.329,1.234,1.126,1.0,0.85,0.731}),
    motorEfficiency(V_flow={0}, eta={1}),
    speed_rpm_nominal=1800)
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{40,80},{60,100}})));
  Modelica.Blocks.Sources.Ramp volDow(
    offset=1,
    startTime=0,
    duration=0.01,
    height=-0.10)
                 "Voltage ramp down"
    annotation (Placement(transformation(extent={{-220,70},{-200,90}})));
  Modelica.Blocks.Sources.Ramp volUp(
    duration=0.01,
    offset=0,
    startTime=5.31,
    height=0.1)
              "Voltage ramp up"
    annotation (Placement(transformation(extent={{-220,30},{-200,50}})));
  Modelica.Blocks.Math.Add vol
    annotation (Placement(transformation(extent={{-150,50},{-130,70}})));
  Modelica.ComplexBlocks.Sources.ComplexConstant a(k(re=cos(0), im=sin(0)))
    annotation (Placement(transformation(extent={{-200,-10},{-180,10}})));
  Modelica.ComplexBlocks.Sources.ComplexConstant b(k(re=cos(-2/3*pi), im=sin(-2/
          3*pi)))
    annotation (Placement(transformation(extent={{-200,-50},{-180,-30}})));
  Modelica.ComplexBlocks.Sources.ComplexConstant c(k(re=cos(2/3*pi), im=sin(2/3*
          pi)))
    annotation (Placement(transformation(extent={{-200,-90},{-180,-70}})));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal1
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal2
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal3
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));
  Modelica.Blocks.Math.Product pro1[2]
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Math.Product pro2[2]
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Modelica.Blocks.Math.Product pro3[2]
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Modelica.Blocks.Math.Gain gain(k=1)
    annotation (Placement(transformation(extent={{-184,70},{-164,90}})));
  Modelica.Blocks.Math.Gain gain1(k=1)
    annotation (Placement(transformation(extent={{-184,30},{-164,50}})));
equation
  connect(res2.port_b, pum2.port_a)
    annotation (Line(points={{-20,-40},{10,-40}}, color={0,127,255}));
  connect(bou3.ports[1], res2.port_a)
    annotation (Line(points={{-60,-40},{-40,-40}}, color={0,127,255}));
  connect(pum2.port_b, bou4.ports[1])
    annotation (Line(points={{30,-40},{70,-40}}, color={0,127,255}));
  connect(pum1.port_b, bou2.ports[1])
    annotation (Line(points={{30,50},{70,50}}, color={0,127,255}));
  connect(pum1.port_a, res1.port_b)
    annotation (Line(points={{10,50},{-20,50}}, color={0,127,255}));
  connect(res1.port_a, bou1.ports[1])
    annotation (Line(points={{-40,50},{-60,50}}, color={0,127,255}));
  connect(freUp.y, pum1.f_in)
    annotation (Line(points={{-59,90},{12,90},{12,62}},     color={0,0,127}));
  connect(freDow.y, pum2.f_in) annotation (Line(points={{-59,-90},{-8,-90},{-8,-18},
          {12,-18},{12,-28}},          color={0,0,127}));
  connect(a.y,complexToReal1. u)
    annotation (Line(points={{-179,0},{-162,0}}, color={85,170,255}));
  connect(b.y,complexToReal2. u)
    annotation (Line(points={{-179,-40},{-162,-40}},
                                                   color={85,170,255}));
  connect(c.y,complexToReal3. u)
    annotation (Line(points={{-179,-80},{-162,-80}},
                                                   color={85,170,255}));
  connect(complexToReal1.re,pro1 [1].u2) annotation (Line(points={{-138,6},{-130,
          6},{-130,-6},{-122,-6}},
                               color={0,0,127}));
  connect(vol.y,pro1 [1].u1) annotation (Line(points={{-129,60},{-126,60},{-126,
          6},{-122,6}},
                   color={0,0,127}));
  connect(complexToReal1.im,pro1 [2].u2)
    annotation (Line(points={{-138,-6},{-122,-6}},
                                              color={0,0,127}));
  connect(vol.y,pro1 [2].u1) annotation (Line(points={{-129,60},{-126,60},{-126,
          6},{-122,6}},
                   color={0,0,127}));
  connect(vol.y,pro2 [1].u1) annotation (Line(points={{-129,60},{-126,60},{-126,
          -34},{-122,-34}},
                     color={0,0,127}));
  connect(vol.y,pro2 [2].u1) annotation (Line(points={{-129,60},{-126,60},{-126,
          -34},{-122,-34}},
                     color={0,0,127}));
  connect(complexToReal2.re,pro2 [1].u2) annotation (Line(points={{-138,-34},{-132,
          -34},{-132,-46},{-122,-46}},
                                    color={0,0,127}));
  connect(complexToReal2.im,pro2 [2].u2)
    annotation (Line(points={{-138,-46},{-122,-46}},
                                                  color={0,0,127}));
  connect(vol.y,pro3 [1].u1) annotation (Line(points={{-129,60},{-126,60},{-126,
          -74},{-122,-74}},
                     color={0,0,127}));
  connect(complexToReal3.re,pro3 [1].u2) annotation (Line(points={{-138,-74},{-132,
          -74},{-132,-86},{-122,-86}},
                                    color={0,0,127}));
  connect(complexToReal3.im,pro3 [2].u2)
    annotation (Line(points={{-138,-86},{-122,-86}},
                                                  color={0,0,127}));
  connect(vol.y,pro3 [2].u1) annotation (Line(points={{-129,60},{-126,60},{-126,
          -74},{-122,-74}},
                     color={0,0,127}));
  connect(volDow.y, gain.u)
    annotation (Line(points={{-199,80},{-186,80}}, color={0,0,127}));
  connect(gain.y, vol.u1) annotation (Line(points={{-163,80},{-160,80},{-160,66},
          {-152,66}}, color={0,0,127}));
  connect(volUp.y, gain1.u)
    annotation (Line(points={{-199,40},{-186,40}}, color={0,0,127}));
  connect(gain1.y, vol.u2) annotation (Line(points={{-163,40},{-160,40},{-160,54},
          {-152,54}}, color={0,0,127}));
  connect(pro1.y, pum1.Vas[1, :])
    annotation (Line(points={{-99,0},{0,0},{0,56},{8,56}}, color={0,0,127}));
  connect(pro2.y, pum1.Vbs[1, :]) annotation (Line(points={{-99,-40},{-88,-40},
          {-88,-2},{2,-2},{2,52},{8,52}},color={0,0,127}));
  connect(pro3.y, pum1.Vcs[1, :]) annotation (Line(points={{-99,-80},{-86,-80},
          {-86,-4},{4,-4},{4,48},{8,48}},color={0,0,127}));
  connect(pro1.y, pum2.Vas[1, :])
    annotation (Line(points={{-99,0},{0,0},{0,-34},{8,-34}}, color={0,0,127}));
  connect(pro2.y, pum2.Vbs[1, :]) annotation (Line(points={{-99,-40},{-88,-40},
          {-88,-2},{2,-2},{2,-38},{8,-38}},color={0,0,127}));
  connect(pro3.y, pum2.Vcs[1, :]) annotation (Line(points={{-99,-80},{-86,-80},
          {-86,-4},{4,-4},{4,-42},{8,-42}},color={0,0,127}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-240,-100},{100,100}})),
    experiment(StopTime=800),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Examples/SimpleElectricPumpFrequency.mos"
        "Simulate and Plot"));
end DoubleCagePumpVoltage;
