/*
function: XM8_rapairMate_focusPart
file: XM8_repairMate\scripts\XM8_rapairMate_focusPart.sqf

INPUT: ARRAY
	- STRING. 'On' or 'Off'
	- SCALAR. Part code
OUTPUT: NOTHING

XM8 RepairMate by vitaly'mind'chizhikov
Vehicle repair script
*/

disableSerialization;
private ["_display","_getControl","_part","_layer","_ctrl"];
params ["_type","_partCode"];
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

_part = ""; _layer = -1; _ctrl = controlNull;
if (XM8_repairMate_vehicleType == "car") then {
	if (_partCode in [0,8]) then {_part = "car_wheel";_layer = 1;};
	if (_partCode == 1) then {_part = "car_engine";_layer = 2;};
	if (_partCode in [2,3,4]) then {_part = "car_body";_layer = 3;};
	if (_partCode in [5,6]) then {_part = "car_glass";_layer = 4;};
	if (_partCode == 7) then {_part = "car_fuel";_layer = 5;};
	_ctrl = (format ["vehPic_L%1",_layer]) call _getControl;
};

if (isNull _ctrl) exitWith {};
if (_type == "On") then {
	_ctrl ctrlSetTextColor [1,1,1,1];
	((format ["vehPartArea_%1",(_partCode+1)]) call _getControl) ctrlSetEventHandler ["MouseButtonUp",format ["'%1' call XM8_rapairMate_selectPart",_part]];
} else {
	if (XM8_repairMate_selectedPart != _part) then {
		_ctrl ctrlSetTextColor [1,1,1,0];
	};
	((format ["vehPartArea_%1",(_partCode + 1)]) call _getControl) ctrlSetEventHandler ["MouseButtonUp",""];
};
