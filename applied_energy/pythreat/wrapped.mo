model wrapped "Wrapped model"
	// Parameter Overwrite
	parameter Real oveTCooOn_p(unit="K") = 297.15 "Zone temperature setpoint during cooling on";
	// Input overwrite
	Modelica.Blocks.Interfaces.RealInput oveTZonResReq_u(unit="1", min=0.0, max=20.0) "Zone temperature reset request numbers";
	Modelica.Blocks.Interfaces.BooleanInput oveTZonResReq_activate "Activation for Zone temperature reset request numbers";
	Modelica.Blocks.Interfaces.RealInput oveTSetChiWatSup_u(unit="K", min=273.65, max=303.15) "Chilled water supply temperature setpoint";
	Modelica.Blocks.Interfaces.BooleanInput oveTSetChiWatSup_activate "Activation for Chilled water supply temperature setpoint";
	// Out read
	// Original model
	FaultInjection.SystemIBPSA.CyberAttack.BaselineSystem mod(
		oveTCooOn(p=oveTCooOn_p),
		oveTZonResReq(uExt(y=oveTZonResReq_u),activate(y=oveTZonResReq_activate)),
		oveTSetChiWatSup(uExt(y=oveTSetChiWatSup_u),activate(y=oveTSetChiWatSup_activate))) "Original model with overwrites";
end wrapped;