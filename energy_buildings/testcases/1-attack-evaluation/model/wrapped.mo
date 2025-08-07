model wrapped "Wrapped model"
	// Parameter Overwrite
	parameter Real oveTCooOn_p(unit="K", min=291.15, max=303.15) = 297.15 "Zone temperature setpoint during cooling on";
	// Input overwrite
	Modelica.Blocks.Interfaces.RealInput oveChiOn_u(unit="1", min=0.0, max=1.0) "Chiller on signal";
	Modelica.Blocks.Interfaces.BooleanInput oveChiOn_activate "Activation for Chiller on signal";
	Modelica.Blocks.Interfaces.RealInput oveTZonResReq_u(unit="1", min=0.0, max=15.0) "Zone temperature reset request numbers";
	Modelica.Blocks.Interfaces.BooleanInput oveTZonResReq_activate "Activation for Zone temperature reset request numbers";
	Modelica.Blocks.Interfaces.RealInput oveTSetChiWatSup_u(unit="K", min=273.65, max=303.15) "Chilled water supply temperature setpoint";
	Modelica.Blocks.Interfaces.BooleanInput oveTSetChiWatSup_activate "Activation for Chilled water supply temperature setpoint";
	Modelica.Blocks.Interfaces.RealInput oveSupFanSpe_u(unit="1", min=0.0, max=1.0) "Supply air fan speed";
	Modelica.Blocks.Interfaces.BooleanInput oveSupFanSpe_activate "Activation for Supply air fan speed";
	// Out read
	// Original model
	template.BaselineSystem mod(
		oveTCooOn(p=oveTCooOn_p),
		oveChiOn(uExt(y=oveChiOn_u),activate(y=oveChiOn_activate)),
		oveTZonResReq(uExt(y=oveTZonResReq_u),activate(y=oveTZonResReq_activate)),
		oveTSetChiWatSup(uExt(y=oveTSetChiWatSup_u),activate(y=oveTSetChiWatSup_activate)),
		oveSupFanSpe(uExt(y=oveSupFanSpe_u),activate(y=oveSupFanSpe_activate))) "Original model with overwrites";
annotation(experiment(Tolerance=1e-06));
end wrapped;