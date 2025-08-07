within FaultInjection.Equipment.BaseClasses.MotorDevice.Motor.Examples;
model DoubleCage
  import Modelica.Constants.pi;
  import FaultInjection.Equipment.BaseClasses.MotorDevice;
  extends Modelica.Icons.Example;

  Real Ias_mag;
  Real Ias_ang;
  Real Ias_t;

  Modelica.Blocks.Sources.Ramp volDow(
    startTime=5,
    duration=0.02,
    offset=offset,
    height=-1)   "Voltage ramp down"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Sources.Ramp volUp(
    offset=0,
    duration=0.02,
    startTime=5.32,
    height=1) "Voltage ramp up"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Math.Add vol
    annotation (Placement(transformation(extent={{-30,60},{-10,80}})));
  Modelica.ComplexBlocks.Sources.ComplexConstant a(k(re=cos(0), im=sin(0)))
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.ComplexBlocks.Sources.ComplexConstant b(k(re=cos(-2/3*pi), im=sin(-2/
          3*pi)))
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.ComplexBlocks.Sources.ComplexConstant c(k(re=cos(2/3*pi), im=sin(2/3*
          pi)))
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal1
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal2
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal3
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Modelica.Blocks.Math.Product pro1[2]
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Modelica.Blocks.Math.Product pro2[2]
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Modelica.Blocks.Math.Product pro3[2]
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Modelica.Blocks.Sources.Step freq1(
    offset=60,
    height=0,
    startTime=8)
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Modelica.Blocks.Sources.Constant Tl(k=0.1)
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Modelica.Blocks.Math.Gain gain(k=1)
    annotation (Placement(transformation(extent={{-64,80},{-44,100}})));
  Modelica.Blocks.Math.Gain gain1(k=1)
    annotation (Placement(transformation(extent={{-64,40},{-44,60}})));
  Modelica.Blocks.Math.Gain ws_pu(k=1/60)
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  parameter Real offset(start=0) = 1 "Offset of output signal";
  MotorDevice.Motor.DoubleCage douCagIM
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
equation
  //calculate instantenous current
   // magnititude
   Ias_mag = sqrt(douCagIM.Ias[1,1]^2+douCagIM.Ias[1,2]^2);
   Ias_ang = atan2(douCagIM.Ias[1,2],douCagIM.Ias[1,1]);
   Ias_t =Ias_mag*cos(2*pi*freq1.y*time + Ias_ang);

  connect(a.y, complexToReal1.u)
    annotation (Line(points={{-59,-10},{-42,-10}},
                                                 color={85,170,255}));
  connect(b.y, complexToReal2.u)
    annotation (Line(points={{-59,-50},{-42,-50}}, color={85,170,255}));
  connect(c.y, complexToReal3.u)
    annotation (Line(points={{-59,-90},{-42,-90}}, color={85,170,255}));
  connect(complexToReal1.re, pro1[1].u2) annotation (Line(points={{-18,-4},{-10,
          -4},{-10,-16},{-2,-16}},
                               color={0,0,127}));
  connect(vol.y, pro1[1].u1) annotation (Line(points={{-9,70},{-6,70},{-6,-4},{
          -2,-4}}, color={0,0,127}));
  connect(pro1[1].y, douCagIM.Vas[1, 1]) annotation (Line(points={{21,-10},{40,
          -10},{40,19},{58,19}},
                            color={0,0,127}));
  connect(complexToReal1.im, pro1[2].u2)
    annotation (Line(points={{-18,-16},{-2,-16}},
                                              color={0,0,127}));
  connect(vol.y, pro1[2].u1) annotation (Line(points={{-9,70},{-6,70},{-6,-4},{
          -2,-4}}, color={0,0,127}));
  connect(pro1[2].y, douCagIM.Vas[1, 2]) annotation (Line(points={{21,-10},{40,
          -10},{40,19},{58,19}},
                            color={0,0,127}));
  connect(vol.y, pro2[1].u1) annotation (Line(points={{-9,70},{-6,70},{-6,-44},
          {-2,-44}}, color={0,0,127}));
  connect(vol.y, pro2[2].u1) annotation (Line(points={{-9,70},{-6,70},{-6,-44},
          {-2,-44}}, color={0,0,127}));
  connect(complexToReal2.re, pro2[1].u2) annotation (Line(points={{-18,-44},{
          -12,-44},{-12,-56},{-2,-56}},
                                    color={0,0,127}));
  connect(complexToReal2.im, pro2[2].u2)
    annotation (Line(points={{-18,-56},{-2,-56}}, color={0,0,127}));
  connect(vol.y, pro3[1].u1) annotation (Line(points={{-9,70},{-6,70},{-6,-84},
          {-2,-84}}, color={0,0,127}));
  connect(complexToReal3.re, pro3[1].u2) annotation (Line(points={{-18,-84},{
          -12,-84},{-12,-96},{-2,-96}},
                                    color={0,0,127}));
  connect(complexToReal3.im, pro3[2].u2)
    annotation (Line(points={{-18,-96},{-2,-96}}, color={0,0,127}));
  connect(pro2[1].y, douCagIM.Vbs[1, 1]) annotation (Line(points={{21,-50},{42,
          -50},{42,16},{58,16}},
                            color={0,0,127}));
  connect(pro2[2].y, douCagIM.Vbs[1, 2]) annotation (Line(points={{21,-50},{42,
          -50},{42,16},{58,16}},
                            color={0,0,127}));
  connect(pro3[1].y, douCagIM.Vcs[1, 1]) annotation (Line(points={{21,-90},{44,
          -90},{44,13},{58,13}},
                            color={0,0,127}));
  connect(pro3[2].y, douCagIM.Vcs[1, 2]) annotation (Line(points={{21,-90},{44,
          -90},{44,13},{58,13}},
                            color={0,0,127}));
  connect(freq1.y, douCagIM.f) annotation (Line(points={{21,90},{46,90},{46,10},
          {58,10}}, color={0,0,127}));
  connect(Tl.y, douCagIM.Tl)
    annotation (Line(points={{21,60},{48,60},{48,3},{58,3}}, color={0,0,127}));
  connect(vol.y, pro3[2].u1) annotation (Line(points={{-9,70},{-6,70},{-6,-84},
          {-2,-84}}, color={0,0,127}));
  connect(volDow.y, gain.u)
    annotation (Line(points={{-79,90},{-66,90}}, color={0,0,127}));
  connect(gain.y, vol.u1) annotation (Line(points={{-43,90},{-40,90},{-40,76},{
          -32,76}}, color={0,0,127}));
  connect(volUp.y, gain1.u)
    annotation (Line(points={{-79,50},{-66,50}}, color={0,0,127}));
  connect(gain1.y, vol.u2) annotation (Line(points={{-43,50},{-40,50},{-40,64},
          {-32,64}}, color={0,0,127}));
  connect(freq1.y, ws_pu.u) annotation (Line(points={{21,90},{44,90},{44,36},{-50,
          36},{-50,20},{-42,20}}, color={0,0,127}));
  connect(ws_pu.y, douCagIM.ws) annotation (Line(points={{-19,20},{38,20},{38,7},
          {58,7}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
          preserveAspectRatio=false)),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Motor/Examples/DoubleCage.mos"
        "Simulate and Plot"),
    experiment(
      StopTime=8,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end DoubleCage;
