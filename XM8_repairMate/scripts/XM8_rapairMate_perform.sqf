/*
function: XM8_rapairMate_perform
file: XM8_repairMate\scripts\XM8_rapairMate_perform.sqf

INPUT: BOOLEAN. True for silent repair
OUTPUT: NOTHING

XM8 RepairMate by vitaly'mind'chizhikov
Vehicle repair script
*/

disableSerialization;
private ["_display","_pW","_pH","_getControl","_otherParts","_allKnownParts","_partsBeingRepaired","_totalDamageToParts","_damageToPartsBeingRepaired",
"_shareOfBasicDamageRepaired","_progressBar","_cancel","_gearData","_basicDamage","_itemsInVeh","_itemNames","_itemAmmo","_vehicleItemsUsed","_index",
"_nonExistentWheels","_dmg","_wheel"];
params ["_silent"];
_pW = 0.025;
_pH = 0.04;
_display = uiNameSpace getVariable ["RscExileXM8", displayNull];
if (isNull _display) exitWith {diag_log "Error loading XM8 RepairMate, display is null"};
_getControl = {
	params ["_key"]; 
	private ["_ctrl","_idc","_index","_slideClassName"]; 
	_ctrl = controlNull;
	_slideClassName = "repairMate";
	_map = XM8_repairMate_repairMateIDCmap;
	_index = _map find _key;
	if (_index != -1) then {
		_idc = ((getNumber (missionConfigFile >> "CfgXM8" >> _slideClassName >> "controlID")) + _index);
		_ctrl = _display displayCtrl _idc;
	};
	_ctrl;
};

//Check if repair must be canceled
if (ExileClientPlayerIsInCombat) exitWith {
	if (!_silent) then {["RepairFailedWarning", [(XM8_repairMate_stringtable select 12)]] call ExileClient_gui_notification_event_addNotification};
};
if (!local XM8_repairMate_vehicle) exitWith {
	if (!_silent) then {["RepairFailedWarning", [(XM8_repairMate_stringtable select 1)]] call ExileClient_gui_notification_event_addNotification};
};
if ((damage XM8_repairMate_vehicle) == 1) exitWith {
	if (!_silent) then {["RepairFailedWarning", [(XM8_repairMate_stringtable select 4)]] call ExileClient_gui_notification_event_addNotification};
};
//Check if player have enough materials and tools in hand or in vehicle
_gearData = XM8_repairMate_selectedPart call XM8_repairMate_checkGear;
if (!(_gearData select 2)) exitWith {
	if (!_silent) then {["RepairFailedWarning", [(XM8_repairMate_stringtable select 14)]] call ExileClient_gui_notification_event_addNotification};
};
if (!(_gearData select 3)) exitWith {
	if (!_silent) then {["RepairFailedWarning", [(XM8_repairMate_stringtable select 15)]] call ExileClient_gui_notification_event_addNotification};
};
if (XM8_repairMate_inProgress) exitWith {};
XM8_repairMate_inProgress = true;

//Gather cost and parts data
_otherParts = []; _allKnownParts = [];
(getAllHitPointsDamage XM8_repairMate_vehicle) params ["_hitParts","_selectionsNames","_dmgValue"];
_basicDamage = damage XM8_repairMate_vehicle;
_allKnownParts append XM8_repairMate_engineParts;
_allKnownParts append XM8_repairMate_fuelParts;
_allKnownParts append XM8_repairMate_glassParts;
_allKnownParts append XM8_repairMate_wheelParts;
_allKnownParts append XM8_repairMate_rotorParts;
_allKnownParts append XM8_repairMate_avionicsParts;
{if (!(_x in _allKnownParts)) then {_otherParts pushBack _x;};} forEach _hitParts;
_partsBeingRepaired = []; _partDamage = 0;
switch (XM8_repairMate_selectedPart) do {
	case "car_engine": {
		_partDamage = (XM8_repairMate_engineParts call XM8_repairMate_getAvarageDamage);
		_partsBeingRepaired = XM8_repairMate_engineParts;
	};
	case "car_body": {
		_partDamage = ([] call XM8_repairMate_getAvarageDamage);
		_partsBeingRepaired = _otherParts;
	};
	case "car_wheel": {
		_partDamage = (XM8_repairMate_wheelParts call XM8_repairMate_getAvarageDamage);
		_partsBeingRepaired = XM8_repairMate_wheelParts;
	};
	case "car_glass": {
		_partDamage = (XM8_repairMate_glassParts call XM8_repairMate_getAvarageDamage);
		_partsBeingRepaired = XM8_repairMate_glassParts;
	};
	case "car_fuel": {
		_partDamage = (XM8_repairMate_fuelParts call XM8_repairMate_getAvarageDamage);
		_partsBeingRepaired = XM8_repairMate_fuelParts;
	};
};
if (_partDamage == 0) exitWith {
	if (!_silent) then {["RepairFailedWarning", [(XM8_repairMate_stringtable select 17)]] call ExileClient_gui_notification_event_addNotification};
	XM8_repairMate_inProgress = false;
};

//Calculate basic damage after repair
_totalDamageToParts = 0;
_damageToPartsBeingRepaired = 0;
_shareOfBasicDamageRepaired = 0;
{
	_totalDamageToParts = _totalDamageToParts + (_dmgValue select _forEachIndex);
	if (_x in _partsBeingRepaired) then {_damageToPartsBeingRepaired = _damageToPartsBeingRepaired + (_dmgValue select _forEachIndex)};
} forEach _hitParts;
if (_totalDamageToParts != 0) then {
	_shareOfBasicDamageRepaired = _damageToPartsBeingRepaired / _totalDamageToParts;
} else {
	_shareOfBasicDamageRepaired = 1;
};

//Animate progress bar and player, play repair sfx
_progressBar = "progress" call _getControl;
_progressBar progressSetPosition 0;
_progressBar ctrlShow true;
player playActionNow "medicStart";
_cancel = false;
for "_i" from 0 to (XM8_repairMate_secondsForRepair * 100) do {
	sleep 0.01;
	_progressBar progressSetPosition (_i / (XM8_repairMate_secondsForRepair * 100));
	if (isNull _display) exitWith {_cancel = true};
	if (ExileClientXM8CurrentSlide != "repairMate") exitWith {_cancel = true};
	if (ExileClientPlayerIsInCombat) exitWith {_cancel = true};
};
_progressBar progressSetPosition 0;
_progressBar ctrlShow false;
player playActionNow "medicStop";
XM8_repairMate_inProgress = false;

//Check if repair should be canceled
if (_cancel) exitWith {
	if (!isNil "XM8_repairMate_vehicle") then {
		if (!local XM8_repairMate_vehicle) then {
			if (!_silent) then {["RepairFailedWarning", [(XM8_repairMate_stringtable select 1)]] call ExileClient_gui_notification_event_addNotification};
		};
	} else {
		if (!_silent) then {["RepairFailedWarning", [(XM8_repairMate_stringtable select 13)]] call ExileClient_gui_notification_event_addNotification};
	};
};
if (ExileClientPlayerIsInCombat) exitWith {
	if (!_silent) then {["RepairFailedWarning", [(XM8_repairMate_stringtable select 12)]] call ExileClient_gui_notification_event_addNotification};
};
if (!local XM8_repairMate_vehicle) exitWith {
	if (!_silent) then {["RepairFailedWarning", [(XM8_repairMate_stringtable select 1)]] call ExileClient_gui_notification_event_addNotification};
};
if ((damage XM8_repairMate_vehicle) == 1) exitWith {
	if (!_silent) then {["RepairFailedWarning", [(XM8_repairMate_stringtable select 4)]] call ExileClient_gui_notification_event_addNotification};
};

//Check if player have enough materials and tools in hand or in vehicle
_gearData = XM8_repairMate_selectedPart call XM8_repairMate_checkGear;
if (!(_gearData select 2)) exitWith {
	if (!_silent) then {["RepairFailedWarning", [(XM8_repairMate_stringtable select 14)]] call ExileClient_gui_notification_event_addNotification};
};
if (!(_gearData select 3)) exitWith {
	if (!_silent) then {["RepairFailedWarning", [(XM8_repairMate_stringtable select 15)]] call ExileClient_gui_notification_event_addNotification};
};

//Remove items from inventory and vehicle
_itemNames = []; _itemAmmo = []; _vehicleItemsUsed = false;
{
	_itemNames pushBack (_x select 0);
	_itemAmmo pushBack (_x select 1);
} forEach (magazinesAmmoCargo XM8_repairMate_vehicle);
{
	for "_i" from 1 to (_x select 1) do {
		_index = _itemNames find (_x select 3);
		if (_index != -1) then {
			_itemNames deleteAt _index;
			_itemAmmo deleteAt _index;
			_vehicleItemsUsed = true;
		} else {
			player removeItem (_x select 3);
		};
	};
} forEach (_gearData select 0);
if (_vehicleItemsUsed) then {
	clearMagazineCargoGlobal XM8_repairMate_vehicle;
	{
		XM8_repairMate_vehicle addMagazineAmmoCargo [_x, 1, (_itemAmmo select _forEachIndex)];
	} forEach _itemNames;
};

//Select mostly damaged wheel
if (XM8_repairMate_selectedPart == "car_wheel") then {
	_wheel = ""; _dmg = 0; _nonExistentWheels = [];
	{
		_index = _hitParts find _x;
		if (_selectionsNames select _index == "") then {
			_nonExistentWheels pushBack _x;
		};
		if ((XM8_repairMate_vehicle getHitPointDamage _x) > _dmg) then {
			_dmg = (XM8_repairMate_vehicle getHitPointDamage _x);
			_wheel = _x;
		};
	} forEach _partsBeingRepaired;
	_partsBeingRepaired = [_wheel];
	_partsBeingRepaired append _nonExistentWheels;
};

//Perform Actual repair
XM8_repairMate_vehicle setDamage (_basicDamage - (_basicDamage * _shareOfBasicDamageRepaired));
{
	if (_x in _partsBeingRepaired) then {
		XM8_repairMate_vehicle setHitIndex [_forEachIndex, 0]
	} else {
		XM8_repairMate_vehicle setHitIndex [_forEachIndex, _dmgValue select _forEachIndex];
	};
} forEach _hitParts;

//Refill slider
0 call ExileClient_gui_xm8_slide_repairMate_onOpen;
if (!_silent) then {["PartyCreatedMessage", [(XM8_repairMate_stringtable select 16)]] call ExileClient_gui_notification_event_addNotification};

















