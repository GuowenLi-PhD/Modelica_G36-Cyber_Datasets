model wrapped "Wrapped model"
	// Parameter Overwrite
	parameter Real oveTCooOn_p(unit="K", min=291.15, max=303.15) = 297.15 "Zone temperature setpoint during cooling on";
	// Input overwrite
	Modelica.Blocks.Interfaces.RealInput oveTChiWatSupSet_u(unit="K", min=278.15, max=283.15) "Chilled water supply temperature setpoint";
	Modelica.Blocks.Interfaces.BooleanInput oveTChiWatSupSet_activate "Activation for Chilled water supply temperature setpoint";
	Modelica.Blocks.Interfaces.RealInput oveOnConWatPum_u(unit="1", min=0.0, max=1.0) "condenser water pump on";
	Modelica.Blocks.Interfaces.BooleanInput oveOnConWatPum_activate "Activation for condenser water pump on";
	Modelica.Blocks.Interfaces.RealInput oveOpeMod_u(unit="1", min=1.0, max=7.0) "AHU operation mode";
	Modelica.Blocks.Interfaces.BooleanInput oveOpeMod_activate "Activation for AHU operation mode";
	Modelica.Blocks.Interfaces.RealInput conAHU_oveTSupAir_u(unit="K", min=273.15, max=333.15) "Supply air temperature setpoint";
	Modelica.Blocks.Interfaces.BooleanInput conAHU_oveTSupAir_activate "Activation for Supply air temperature setpoint";
	Modelica.Blocks.Interfaces.RealInput oveTBoiSupSet_u(unit="K", min=313.15, max=321.15) "Boiler supply water temperature setpoint";
	Modelica.Blocks.Interfaces.BooleanInput oveTBoiSupSet_activate "Activation for Boiler supply water temperature setpoint";
	Modelica.Blocks.Interfaces.RealInput oveOnCooTow_u(unit="1", min=0.0, max=1.0) "Cooling tower on signal";
	Modelica.Blocks.Interfaces.BooleanInput oveOnCooTow_activate "Activation for Cooling tower on signal";
	Modelica.Blocks.Interfaces.RealInput oveOnChi_u(unit="1", min=0.0, max=1.0) "Chiller on signal";
	Modelica.Blocks.Interfaces.BooleanInput oveOnChi_activate "Activation for Chiller on signal";
	Modelica.Blocks.Interfaces.RealInput conAHU_supFan_oveDifPreSupFan_u(unit="Pa", min=25.0, max=400.0) "Supply air differential pressure setpoint";
	Modelica.Blocks.Interfaces.BooleanInput conAHU_supFan_oveDifPreSupFan_activate "Activation for Supply air differential pressure setpoint";
	Modelica.Blocks.Interfaces.RealInput oveTDryBulOutAir_u(unit="K", min=253.15, max=313.15) "Outdoor air dry bulb temperature";
	Modelica.Blocks.Interfaces.BooleanInput oveTDryBulOutAir_activate "Activation for Outdoor air dry bulb temperature";
	Modelica.Blocks.Interfaces.RealInput oveTZonResReq_u(unit="1", min=0.0, max=15.0) "Zone temperature reset request numbers";
	Modelica.Blocks.Interfaces.BooleanInput oveTZonResReq_activate "Activation for Zone temperature reset request numbers";
	Modelica.Blocks.Interfaces.RealInput oveValHeaCoi_u(unit="1", min=0.0, max=1.0) "Heating coil valve position";
	Modelica.Blocks.Interfaces.BooleanInput oveValHeaCoi_activate "Activation for Heating coil valve position";
	Modelica.Blocks.Interfaces.RealInput oveOnHotWatPum_u(unit="1", min=0.0, max=1.0) "Hot water pump on signal";
	Modelica.Blocks.Interfaces.BooleanInput oveOnHotWatPum_activate "Activation for Hot water pump on signal";
	Modelica.Blocks.Interfaces.RealInput oveDifPreHotWatSet_u(unit="Pa", min=18000.0, max=36000.0) "Hot water loop differential pressure setpoint";
	Modelica.Blocks.Interfaces.BooleanInput oveDifPreHotWatSet_activate "Activation for Hot water loop differential pressure setpoint";
	Modelica.Blocks.Interfaces.RealInput oveRelHumOutAir_u(unit="1", min=0.0, max=1.0) "Outdoor air relative humidity";
	Modelica.Blocks.Interfaces.BooleanInput oveRelHumOutAir_activate "Activation for Outdoor air relative humidity";
	Modelica.Blocks.Interfaces.RealInput oveValCooCoi_u(unit="1", min=0.0, max=1.0) "Cooling coil valve position";
	Modelica.Blocks.Interfaces.BooleanInput oveValCooCoi_activate "Activation for Cooling coil valve position";
	Modelica.Blocks.Interfaces.RealInput oveTConWatSupSet_u(unit="K", min=288.15, max=303.15) "Condenser water supply temperature setpoint";
	Modelica.Blocks.Interfaces.BooleanInput oveTConWatSupSet_activate "Activation for Condenser water supply temperature setpoint";
	Modelica.Blocks.Interfaces.RealInput oveOnSupFan_u(unit="1", min=0.0, max=1.0) "Supply air fan speed";
	Modelica.Blocks.Interfaces.BooleanInput oveOnSupFan_activate "Activation for Supply air fan speed";
	Modelica.Blocks.Interfaces.RealInput oveTZon5_u(unit="K", min=278.15, max=308.15) "Zone 5 temperatures";
	Modelica.Blocks.Interfaces.BooleanInput oveTZon5_activate "Activation for Zone 5 temperatures";
	Modelica.Blocks.Interfaces.RealInput oveTZon4_u(unit="K", min=278.15, max=308.15) "Zone 4 temperatures";
	Modelica.Blocks.Interfaces.BooleanInput oveTZon4_activate "Activation for Zone 4 temperatures";
	Modelica.Blocks.Interfaces.RealInput oveTZon3_u(unit="K", min=278.15, max=308.15) "Zone 3 temperatures";
	Modelica.Blocks.Interfaces.BooleanInput oveTZon3_activate "Activation for Zone 3 temperatures";
	Modelica.Blocks.Interfaces.RealInput oveTZon2_u(unit="K", min=278.15, max=308.15) "Zone 2 temperatures";
	Modelica.Blocks.Interfaces.BooleanInput oveTZon2_activate "Activation for Zone 2 temperatures";
	Modelica.Blocks.Interfaces.RealInput oveTZon1_u(unit="K", min=278.15, max=308.15) "Zone 1 temperatures";
	Modelica.Blocks.Interfaces.BooleanInput oveTZon1_activate "Activation for Zone 1 temperatures";
	Modelica.Blocks.Interfaces.RealInput oveOnChiWatPum_u(unit="1", min=0.0, max=1.0) "chilled water pump on";
	Modelica.Blocks.Interfaces.BooleanInput oveOnChiWatPum_activate "Activation for chilled water pump on";
	Modelica.Blocks.Interfaces.RealInput oveDifPreChiWatSet_u(unit="Pa", min=18000.0, max=36000.0) "chilled water differential pressure setpoint";
	Modelica.Blocks.Interfaces.BooleanInput oveDifPreChiWatSet_activate "Activation for chilled water differential pressure setpoint";
	Modelica.Blocks.Interfaces.RealInput oveTChiWatRet_u(unit="K", min=273.65, max=333.15) "Chilled water return temperature";
	Modelica.Blocks.Interfaces.BooleanInput oveTChiWatRet_activate "Activation for Chilled water return temperature";
	Modelica.Blocks.Interfaces.RealInput oveOnBoi_u(unit="1", min=0.0, max=1.0) "Boiler on signal";
	Modelica.Blocks.Interfaces.BooleanInput oveOnBoi_activate "Activation for Boiler on signal";
	Modelica.Blocks.Interfaces.RealInput ovePZonResReq_u(unit="1", min=0.0, max=15.0) "Zone pressure reset request numbers";
	Modelica.Blocks.Interfaces.BooleanInput ovePZonResReq_activate "Activation for Zone pressure reset request numbers";
	// Out read
	// Original model
	template.BaselineSystem mod(
		oveTCooOn(p=oveTCooOn_p),
		oveTChiWatSupSet(uExt(y=oveTChiWatSupSet_u),activate(y=oveTChiWatSupSet_activate)),
		oveOnConWatPum(uExt(y=oveOnConWatPum_u),activate(y=oveOnConWatPum_activate)),
		oveOpeMod(uExt(y=oveOpeMod_u),activate(y=oveOpeMod_activate)),
		conAHU(oveTSupAir(uExt(y=conAHU_oveTSupAir_u),activate(y=conAHU_oveTSupAir_activate))),
		oveTBoiSupSet(uExt(y=oveTBoiSupSet_u),activate(y=oveTBoiSupSet_activate)),
		oveOnCooTow(uExt(y=oveOnCooTow_u),activate(y=oveOnCooTow_activate)),
		oveOnChi(uExt(y=oveOnChi_u),activate(y=oveOnChi_activate)),
		conAHU(supFan(oveDifPreSupFan(uExt(y=conAHU_supFan_oveDifPreSupFan_u),activate(y=conAHU_supFan_oveDifPreSupFan_activate)))),
		oveTDryBulOutAir(uExt(y=oveTDryBulOutAir_u),activate(y=oveTDryBulOutAir_activate)),
		oveTZonResReq(uExt(y=oveTZonResReq_u),activate(y=oveTZonResReq_activate)),
		oveValHeaCoi(uExt(y=oveValHeaCoi_u),activate(y=oveValHeaCoi_activate)),
		oveOnHotWatPum(uExt(y=oveOnHotWatPum_u),activate(y=oveOnHotWatPum_activate)),
		oveDifPreHotWatSet(uExt(y=oveDifPreHotWatSet_u),activate(y=oveDifPreHotWatSet_activate)),
		oveRelHumOutAir(uExt(y=oveRelHumOutAir_u),activate(y=oveRelHumOutAir_activate)),
		oveValCooCoi(uExt(y=oveValCooCoi_u),activate(y=oveValCooCoi_activate)),
		oveTConWatSupSet(uExt(y=oveTConWatSupSet_u),activate(y=oveTConWatSupSet_activate)),
		oveOnSupFan(uExt(y=oveOnSupFan_u),activate(y=oveOnSupFan_activate)),
		oveTZon5(uExt(y=oveTZon5_u),activate(y=oveTZon5_activate)),
		oveTZon4(uExt(y=oveTZon4_u),activate(y=oveTZon4_activate)),
		oveTZon3(uExt(y=oveTZon3_u),activate(y=oveTZon3_activate)),
		oveTZon2(uExt(y=oveTZon2_u),activate(y=oveTZon2_activate)),
		oveTZon1(uExt(y=oveTZon1_u),activate(y=oveTZon1_activate)),
		oveOnChiWatPum(uExt(y=oveOnChiWatPum_u),activate(y=oveOnChiWatPum_activate)),
		oveDifPreChiWatSet(uExt(y=oveDifPreChiWatSet_u),activate(y=oveDifPreChiWatSet_activate)),
		oveTChiWatRet(uExt(y=oveTChiWatRet_u),activate(y=oveTChiWatRet_activate)),
		oveOnBoi(uExt(y=oveOnBoi_u),activate(y=oveOnBoi_activate)),
		ovePZonResReq(uExt(y=ovePZonResReq_u),activate(y=ovePZonResReq_activate))) "Original model with overwrites";
end wrapped;