within FaultInjection.Equipment.ParameterFaults.BaseClasses;
type EfficiencyCurves = enumeration(
    Constant "constant",
    Polynomial "Polynomial",
    QuadraticLinear "quadratic in x1, linear in x2",
    BiQuadratic "biquadratic")
  "Enumeration to define the efficiency curves";
