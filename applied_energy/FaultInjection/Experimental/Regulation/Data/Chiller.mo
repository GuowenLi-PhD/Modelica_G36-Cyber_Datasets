within FaultInjection.Experimental.Regulation.Data;
record Chiller =
  Buildings.Fluid.Chillers.Data.ElectricEIR.Generic (
    QEva_flow_nominal =  -1076100,
    COP_nominal =         5.52,
    PLRMin =              0.10,
    PLRMinUnl =           0.10,
    PLRMax =              1.02,
    mEva_flow_nominal =   1000 * 0.03186,
    mCon_flow_nominal =   1000 * 0.04744,
    TEvaLvg_nominal =     273.15 + 5.56,
    TConEnt_nominal =     273.15 + 24.89,
    TEvaLvgMin =          273.15 + 5.56,
    TEvaLvgMax =          273.15 + 10.00,
    TConEntMin =          273.15 + 12.78,
    TConEntMax =          273.15 + 24.89,
    capFunT =             {1.785912E-01,-5.900023E-02,-5.946963E-04,9.297889E-02,-2.841024E-03,4.974221E-03},
    EIRFunT =             {5.245110E-01,-2.850126E-02,8.034720E-04,1.893133E-02,1.151629E-04,-9.340642E-05},
    EIRFunPLR =           {2.619878E-01,2.393605E-01,4.988306E-01},
    etaMotor =            1.0)
  "ElectricEIRChiller Carrier 19XR 1076kW/5.52COP/Vanes" annotation (
  defaultComponentName="datChi",
  defaultComponentPrefixes="parameter",
  Documentation(info=
                 "<html>
Performance data for chiller model.
This data corresponds to the following EnergyPlus model:

</html>"));
