within FaultInjection.Equipment.BaseClasses.MotorDevice.Motor;
model DoubleCage "Double cage induction motor"
   //import Modelica_LinearSystems2.Math.Complex;
   import
    FaultInjection.Equipment.BaseClasses.MotorDevice.Motor.BaseClasses.Functions.productCom;
   import
    FaultInjection.Equipment.BaseClasses.MotorDevice.Motor.BaseClasses.Functions.divideCom;
   import Modelica.Constants.pi;

   //parameter
   parameter Real rs = 0.01;
   parameter Real lls = 0.1;
   parameter Real lm = 3;
   parameter Real rr = 0.005;
   parameter Real llr = 0.08;

   parameter Real wref = 0 "Reference frame rotation speed,pu";
   //parameter Real ws = 1 "Synchronous speed, pu";

   parameter Real H = 0.4;
   parameter Real Pbase = 30 "Motor base power";
   parameter Real Kfric = 0 "Friction, pu";

   final Complex alpha_cp = Modelica.ComplexMath.exp(2/3*pi*Modelica.ComplexMath.j);
   Complex alpha2_cp = alpha_cp*alpha_cp;
   Real alpha[1,2] = [alpha_cp.re,alpha_cp.im];
   Real alpha2[1,2] = [alpha2_cp.re,alpha2_cp.im];

   Real wb = 2*pi*f "Base synchronous speed";

   Real Ls = lls + lm;
   Real Lr = llr + lm;
   Real sigma1 = Ls - lm*lm/Lr;
   Real sigma2 = Lr - lm*lm/Ls;

   Real Te "Electricomagnetic torque, pu";
   Real Te_c[1,2];
   //
   Real Vap[1,2];
   Real Van[1,2];
   Real Van_cj[1,2];
   //Real Vaz[1,2];

   Real Ips[1,2];
   Real Ipr[1,2];
   Real Ins_cj[1,2];
   Real Inr_cj[1,2];
   Real Ips_cj[1,2];
   Real Ins[1,2];
   Real Ias[1,2];
   Real Ibs[1,2];
   Real Ics[1,2];

   Real phi_ps[1,2](start=[0,0]);
   Real phi_pr[1,2](start=[0,0]);
   Real phi_ns_cj[1,2](start=[0,0]);
   Real phi_nr_cj[1,2](start=[0,0]);
   Real phi_ps_cj[1,2];
   Real phi_ns[1,2];

   Complex A1_c;
   Complex B2_c;
   Complex C3_c;
   Complex D4_c;

   Real A1[1,2];
   Real B1 = 0.0;
   Real C1;
   Real D1 = 0.0;
   Real E1[1,2] = Vap;

   Real A2 = 0.0;
   Real B2[1,2];
   Real C2 = 0.0;
   Real D2;
   Real E2[1,2] = Van_cj;

   Real A3;
   Real B3 = 0.0;
   Real C3[1,2];
   Real D3 = 0.0;
   Real E3 = 0.0;

   Real A4 = 0.0;
   Real B4;
   Real C4 = 0.0;
   Real D4[1,2];
   Real E4 = 0.0;

   Real x1[1,2];
   Real pow[1,2];

  Modelica.Blocks.Interfaces.RealInput Tl(unit="1")
    "Prescribed load mechanical torque,pu"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-70}),
                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-70})));
  Modelica.Blocks.Interfaces.RealInput f(final quantity="Frequency", final unit=
       "Hz") "Controllale freuqency to the motor"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput Pmotor(quantity="Power", unit="W")
    "Real power"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput Qmotor(quantity="Power", unit="var")
    "Reactive power"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput omega_r(start=0) "Rotor speed, pu"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Modelica.Blocks.Interfaces.RealInput Vas[1,2](each final quantity="Voltage",
      each final unit="V")
    "Supply voltage, complex number [1]: real, [2]:image, pu"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}})));
  Modelica.Blocks.Interfaces.RealInput Vbs[1,2](each final quantity="Voltage",
      each final unit="V")
    "Supply voltage, complex number [1]: real, [2]:image, pu"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput Vcs[1,2](each final quantity="Voltage",
      each final unit="V")
    "Supply voltage, complex number [1]: real, [2]:image, pu"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}})));
  Modelica.Blocks.Interfaces.RealInput ws "Synchronous speed, pu"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}})));

  Modelica.Blocks.Interfaces.RealOutput Sas[1,2](each quantity="Power", each unit="VA")
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.RealOutput Sbs[1,2](each quantity="Power", each unit="VA")
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput Scs[1,2](each quantity="Power", each unit="VA")
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

initial algorithm
  // this initialization equations are discarded because they have an assumption that the motor starts from running mode instead of stop mode.
//phi_ps :=divideCom((B1*C2*D3*E4*[1,0]- B1*C2*D4*E3 - B1*C3*D2*E4+ productCom([productCom([B1*
//    C3; D4], 2); E2], 2) + B1*C4*D2*E3*[1,0] - B1*C4*D3*E2 - B2*C1*D3*E4 + productCom(
//     [B2*C1; D4*E3], 2) + productCom([B2; C3], 2)*D1*E4 - productCom([
//    productCom([productCom([B2; C3], 2); D4], 2); E1], 2) - B2*C4*D1*E3 +
//    productCom([B2*C4; D3*E1], 2) + B3*C1*D2*E4*[1,0] - B3*C1*productCom([D4; E2], 2) -
//    B3*C2*D1*E4*[1,0] + B3*C2*productCom([D4; E1], 2) + B3*C4*D1*E2 - B3*C4*D2*E1 -
//    B4*C1*D2*E3*[1,0] + B4*C1*D3*E2 + B4*C2*D1*E3*[1,0] - B4*C2*D3*E1 - productCom([B4*C3;
//    D1*E2], 2) + productCom([B4*C3; D2*E1], 2)), (productCom([productCom([
//    productCom([A1; B2], 2); C3], 2); D4], 2) - productCom([A1; B2], 2)*C4*D3 -
//    productCom([A1*B3*C2; D4], 2) + A1*B3*C4*D2 + A1*B4*C2*D3 - productCom([A1*
//    B4; C3*D2], 2) - A2*B1*productCom([C3; D4], 2) + A2*B1*C4*D3*[1,0] + A2*B3*C1*D4 -
//    A2*B3*C4*D1*[1,0] - A2*B4*C1*D3*[1,0] + A2*B4*C3*D1 + A3*B1*C2*D4 - A3*B1*C4*D2*[1,0] -
//    productCom([A3*B2; C1*D4], 2) + A3*B2*C4*D1 + A3*B4*C1*D2*[1,0] - A3*B4*C2*D1*[1,0] -
//    A4*B1*C2*D3*[1,0] + A4*B1*C3*D2 + A4*B2*C1*D3 - productCom([A4*B2; C3*D1], 2) -
//    A4*B3*C1*D2*[1,0] + A4*B3*C2*D1*[1,0]));

// phi_pr :=divideCom((A1.*B2.*D3.*E4 - A1.*B2.*D4.*E3 - A1*B3*D2*E4 + A1.*B3.*D4.*E2 + A1*B4*D2*E3 -
//    A1*B4*D3.*E2 - A2*B1*D3*E4*[1,0] + A2*B1*D4*E3 + A2*B3*D1*E4*[1,0] - A2*B3*D4.*E1 - A2*B4*
//    D1*E3*[1,0] + A2*B4*D3*E1 + A3*B1*D2*E4*[1,0] - A3*B1*D4.*E2 - A3*B2*D1*E4 + productCom([productCom([A3*B2;D4],2);E1],2) +
//    A3*B4*D1*E2 - A3*B4*D2*E1 - A4*B1*D2*E3*[1,0] + A4*B1*D3*E2 + A4*B2*D1*E3 - A4*B2*
//    D3.*E1 - A4*B3*D1*E2 + A4*B3*D2*E1),(productCom([productCom([
//   productCom([A1; B2], 2); C3], 2); D4], 2) - productCom([A1; B2], 2)*C4*D3 -
//    productCom([A1*B3*C2; D4], 2) + A1*B3*C4*D2 + A1*B4*C2*D3 - productCom([A1*
//    B4; C3*D2], 2) - A2*B1*productCom([C3; D4], 2) + A2*B1*C4*D3*[1,0] + A2*B3*C1*D4 -
//    A2*B3*C4*D1*[1,0] - A2*B4*C1*D3*[1,0] + A2*B4*C3*D1 + A3*B1*C2*D4 - A3*B1*C4*D2*[1,0] -
//    productCom([A3*B2; C1*D4], 2) + A3*B2*C4*D1 + A3*B4*C1*D2*[1,0] - A3*B4*C2*D1*[1,0] -
//    A4*B1*C2*D3*[1,0] + A4*B1*C3*D2 + A4*B2*C1*D3 - productCom([A4*B2; C3*D1], 2) -
//    A4*B3*C1*D2*[1,0] + A4*B3*C2*D1*[1,0]));

//   phi_ns_cj :=divideCom(-(A1*C2*D3*E4 - A1.*C2.*D4.*E3 - A1.*C3.*D2.*E4 +
//    productCom([productCom([productCom([A1; C3], 2); D4], 2); E2], 2) + A1*C4*
//    D2*E3 - A1.*C4.*D3.*E2 - A2*C1*D3*E4*[1,0] + A2*C1*D4*E3 + A2*C3*D1*E4 - A2.*C3.*D4.*E1 -
//    A2*C4*D1*E3*[1,0] + A2*C4*D3*E1 + A3*C1*D2*E4*[1,0] - productCom([A3*
//    C1*D4; E2], 2) - A3*C2*D1*E4*[1,0] + A3*C2.*D4.*E1 + A3*C4*D1.*E2 - A3*C4*D2.*E1 -
//    A4*C1*D2*E3*[1,0] + A4*C1*D3.*E2 + A4*C2*D1*E3*[1,0] - A4*C2*D3*E1 - A4*C3*D1.*E2 +
//    A4.*C3.*D2.*E1),(productCom([productCom([
//    productCom([A1; B2], 2); C3], 2); D4], 2) - productCom([A1; B2], 2)*C4*D3 -
//    productCom([A1*B3*C2; D4], 2) + A1*B3*C4*D2 + A1*B4*C2*D3 - productCom([A1*
//    B4; C3*D2], 2) - A2*B1*productCom([C3; D4], 2) + A2*B1*C4*D3*[1,0] + A2*B3*C1*D4 -
//    A2*B3*C4*D1*[1,0] - A2*B4*C1*D3*[1,0] + A2*B4*C3*D1 + A3*B1*C2*D4 - A3*B1*C4*D2*[1,0] -
//    productCom([A3*B2; C1*D4], 2) + A3*B2*C4*D1 + A3*B4*C1*D2*[1,0] - A3*B4*C2*D1*[1,0] -
//    A4*B1*C2*D3*[1,0] + A4*B1*C3*D2 + A4*B2*C1*D3 - productCom([A4*B2; C3*D1], 2) -
//    A4*B3*C1*D2*[1,0] + A4*B3*C2*D1*[1,0]));

 // phi_nr_cj := divideCom(-(A1.*B2.*C3.*E4 - A1.*B2.*C4*E3 - A1*B3*C2*E4 + A1*B3*C4.*E2 + A1*B4*C2*E3 -
 //   productCom([productCom([A1*B4;C3],2);E2],2) - A2*B1*C3*E4 + A2*B1*C4*E3*[1,0] +
 //   A2*B3*C1*E4*[1,0] - A2*B3*C4*E1 - A2*B4*C1*E3*[1,0] + A2*B4*C3.*E1 + A3*B1*C2*E4*[1,0] -
 //   A3*B1*C4*E2 - A3*B2*C1*E4 + A3*B2*C4.*E1 + A3*B4*C1*E2 - A3*B4*C2.*E1 - A4*B1*C2*E3*[1,0] +
 //   A4*B1*C3.*E2 + A4*B2*C1*E3 - A4*B2.*C3.*E1 - A4*B3*C1*E2 + A4*B3*C2*E1),(productCom([productCom([
 //   productCom([A1; B2], 2); C3], 2); D4], 2) - productCom([A1; B2], 2)*C4*D3 -
 //   productCom([A1*B3*C2; D4], 2) + A1*B3*C4*D2 + A1*B4*C2*D3 - productCom([A1*
 //   B4; C3*D2], 2) - A2*B1*productCom([C3; D4], 2) + A2*B1*C4*D3*[1,0] + A2*B3*C1*D4 -
 //   A2*B3*C4*D1*[1,0] - A2*B4*C1*D3*[1,0] + A2*B4*C3*D1 + A3*B1*C2*D4 - A3*B1*C4*D2*[1,0] -
 //   productCom([A3*B2; C1*D4], 2) + A3*B2*C4*D1 + A3*B4*C1*D2*[1,0] - A3*B4*C2*D1*[1,0] -
 //   A4*B1*C2*D3*[1,0] + A4*B1*C3*D2 + A4*B2*C1*D3 - productCom([A4*B2; C3*D1], 2) -
 //   A4*B3*C1*D2*[1,0] + A4*B3*C2*D1*[1,0]));

 // Initialize the motor from stop to run
// phi_ps  := [0,0];
// phi_pr := [0,0];
// phi_ns_cj := [0,0];
// phi_nr_cj := [0,0];

equation

  //
  Vap = 1/3*(Vas + productCom([alpha;Vbs],2) + productCom([alpha2;Vcs],2));
  Van = 1/3*(Vas + productCom([alpha2;Vbs],2) + productCom([alpha;Vcs],2));

  //
  A1_c = -((wref + ws)*Modelica.ComplexMath.j + rs/sigma1);
  C1 = rs/sigma1*lm/Lr;
  B2_c = -((wref - ws)*Modelica.ComplexMath.j + rs/sigma1);
  D2 = rs/sigma1*lm/Lr;
  A3 = rr/sigma2*lm/Ls;
  C3_c = -((wref + ws - omega_r)*Modelica.ComplexMath.j + rr/sigma2);
  B4 = rr/sigma2 * lm/Ls;
  D4_c = -((wref - ws - omega_r)*Modelica.ComplexMath.j + rr/sigma2);

  // Complex number in real expression
  A1 = [A1_c.re,A1_c.im];
  B2 = [B2_c.re,B2_c.im];
  C3 = [C3_c.re,C3_c.im];
  D4 = [D4_c.re,D4_c.im];

  //
  Ips = 1/sigma1*(phi_ps - lm/Lr*phi_pr);
  Ipr = 1/sigma2*(phi_pr - lm/Ls*phi_ps);
  Ins_cj = 1/sigma1*(phi_ns_cj - lm/Lr*phi_nr_cj);
  Inr_cj = 1/sigma2*(phi_nr_cj - lm/Ls*phi_ns_cj);

  // excitation voltage equations
  der(phi_ps) = wb*(Vap +
    MotorDevice.Motor.BaseClasses.Functions.productCom([A1; phi_ps], 2) +
    C1*phi_pr);
  Van_cj = [Van[1,1],-Van[1,2]];
  der(phi_ns_cj) = wb*(Van_cj +
    MotorDevice.Motor.BaseClasses.Functions.productCom([B2; phi_ns_cj], 2)
     + D2*phi_nr_cj);
  der(phi_pr) = wb*(A3*phi_ps +
    MotorDevice.Motor.BaseClasses.Functions.productCom([C3; phi_pr], 2));
  der(phi_nr_cj) = wb*(B4*phi_ns_cj +
    MotorDevice.Motor.BaseClasses.Functions.productCom([D4; phi_nr_cj], 2));

  // -----------------------------------
  //conjugate
  phi_ps_cj = [phi_ps[1,1],-phi_ps[1,2]];
  phi_ns = [phi_ns_cj[1,1],-phi_ns_cj[1,2]];

  x1 = MotorDevice.Motor.BaseClasses.Functions.productCom([phi_ps_cj; Ips],
    2) + MotorDevice.Motor.BaseClasses.Functions.productCom([phi_ns; Ins_cj],
    2);
  der(omega_r) = 1/(2*H)*(x1[1,2] - Tl - Kfric*omega_r);

  // active and reactive power of the motor
  Ips_cj = [Ips[1,1],-Ips[1,2]];
  pow = MotorDevice.Motor.BaseClasses.Functions.productCom([Vap; Ips_cj], 2)
     + MotorDevice.Motor.BaseClasses.Functions.productCom([Van; Ins_cj], 2);
  Pmotor = pow[1,1]*Pbase;
  Qmotor = pow[1,2]*Pbase;

  //Three phase current
  Ins = [Ins_cj[1,1],-Ins_cj[1,2]];
  Ias = Ips + Ins;
  Ibs = MotorDevice.Motor.BaseClasses.Functions.productCom([alpha2; Ips], 2)
     + MotorDevice.Motor.BaseClasses.Functions.productCom([alpha; Ins], 2);
  Ics = MotorDevice.Motor.BaseClasses.Functions.productCom([alpha; Ips], 2)
     + MotorDevice.Motor.BaseClasses.Functions.productCom([alpha2; Ins], 2);

  // electricomagnetic torque
  Te_c = (MotorDevice.Motor.BaseClasses.Functions.productCom([phi_ps_cj;
    Ips], 2) + MotorDevice.Motor.BaseClasses.Functions.productCom([phi_ns;
    Ins_cj], 2));
  Te = Te_c[1,2];

  // final calculation; convert pu to actual values
  // rotor speed

  // output three-phase power
  // Sas = Vas*conj(Ias)
  Sas = Pbase/3*MotorDevice.Motor.BaseClasses.Functions.productCom([Vas; [
    Ias[1, 1],-Ias[1, 2]]], 2);
  Sbs = Pbase/3*MotorDevice.Motor.BaseClasses.Functions.productCom([Vbs; [
    Ibs[1, 1],-Ibs[1, 2]]], 2);
  Scs = Pbase/3*MotorDevice.Motor.BaseClasses.Functions.productCom([Vcs; [
    Ics[1, 1],-Ics[1, 2]]], 2);
  annotation (defaultComponentName = "douCagIM",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          lineColor={82,0,2},
          fillColor={252,37,57},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-50.0},{30.0,50.0}},
          radius=10.0),
        Polygon(
          fillColor={64,64,64},
          fillPattern=FillPattern.Solid,
          points={{-100.0,-90.0},{-90.0,-90.0},{-60.0,-20.0},{-10.0,-20.0},{20.0,-90.0},{30.0,-90.0},{30.0,-100.0},{-100.0,-100.0},{-100.0,-90.0}}),
        Rectangle(
          lineColor={64,64,64},
          fillColor={255,255,255},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{30.0,-10.0},{90.0,10.0}}),
                                          Text(
          extent={{-88,156},{76,110}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DoubleCage;
