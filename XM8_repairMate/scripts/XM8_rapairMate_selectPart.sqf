/*
function: XM8_rapairMate_selectPart
file: XM8_repairMate\scripts\XM8_rapairMate_selectPart.sqf

INPUT: NOTHING
OUTPUT: NOTHING

XM8 Repair Assistant by vitaly'mind'chizhikov
Vehicle repair script
*/

disableSerialization;
private ["_pW","_pH","_display","_getControl","_partDamage","_linesPos","_setSTextControl","_condition","_color","_partName","_gearData",
"_setPictureControl","_setBackgroundControl","_ctrl","_count","_tooltip","_offsetY","_offsetx","_layer","_repairAllScript"];
params ["_selectedPart"];
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
_setSTextControl = {
	params ["_ctrl","_pos","_text","_font","_size","_color","_align"];
	_ctrl ctrlSetPosition _pos;
	_ctrl ctrlSetStructuredText (parseText format ["<t shadow='0' font='%5' align='%4' size='%2' color='%3'>%1</t>", _text,_size,_color, _align,_font]);
	_ctrl ctrlEnable false;
	_ctrl ctrlCommit 0;
};
_setPictureControl = {
	params ["_ctrl","_pos","_pic","_color","_enable","_tooltip"];
	_ctrl ctrlSetPosition _pos;
	_ctrl ctrlSetText _pic;
	_ctrl ctrlSetTextColor _color;
	_ctrl ctrlSetTooltip _tooltip;
	_ctrl ctrlEnable _enable;
	_ctrl ctrlCommit 0;
};
_setBackgroundControl = {
	params ["_ctrl","_pos","_color"];
	_ctrl ctrlSetPosition _pos;
	_ctrl ctrlSetBackgroundColor _color;
	_ctrl ctrlEnable false;
	_ctrl ctrlCommit 0;
};
_setButtonControl = {
	params ["_ctrl","_pos","_action","_text","_enable"];
	_ctrl ctrlSetPosition _pos;
	_ctrl ctrlSetText _text;
	_ctrl ctrlSetEventHandler ["MouseButtonUp",_action];
	_ctrl ctrlEnable _enable;
	_ctrl ctrlCommit 0;
};

XM8_repairMate_selectedPart = _selectedPart;

//Hide parts. Reset materials and tools
for "_i" from 1 to 10 do {
	((format ["vehPic_L%1",_i]) call _getControl) ctrlSetTextColor [1,1,1,0];
	[((format ["matCount_%1",_i]) call _getControl),[0,0,0,0],"","PuristaMedium",1,"#FF0000","center"] call _setSTextControl;
	[((format ["matPic_%1",_i]) call _getControl),[0,0,0,0],"",[1,1,1,1],false,""] call _setPictureControl;
};
for "_i" from 1 to 12 do {
	[((format ["toolPic_%1",_i]) call _getControl),[0,0,0,0],"",[1,1,1,1],false,""] call _setPictureControl;
	[((format ["toolBack_%1",_i]) call _getControl),[0,0,0,0],[1,1,1,1]] call _setBackgroundControl;
};

_linesPos = []; _linesPosBack = [];
_partDamage = 0;
_partName = "";
_layer = -1;
//Geather lines poses, avarage part damage,
switch (_selectedPart) do {
	case "car_engine": {
		_linesPos = [[10*_pW,3.6*_pH,5*_pW,0.03*_pH],[15*_pW,3.6*_pH,0.034*_pW,3.7*_pH]];
		_linesPosBack = [[10*_pW,3.58*_pH,5*_pW,0.1*_pH],[14.97*_pW,3.6*_pH,0.1*_pW,3.7*_pH]];
		_partDamage = (XM8_repairMate_engineParts call XM8_repairMate_getAvarageDamage);
		_partName = (XM8_repairMate_stringtable select 5);
		_layer = 2;
	};
	case "car_body": {
		_linesPos = [[10*_pW,3.6*_pH,16*_pW,0.03*_pH],[26*_pW,3.6*_pH,0.034*_pW,3.7*_pH]];
		_linesPosBack = [[10*_pW,3.58*_pH,16*_pW,0.1*_pH],[25.97*_pW,3.6*_pH,0.1*_pW,3.7*_pH]];
		_partDamage = ([] call XM8_repairMate_getAvarageDamage);
		_partName = (XM8_repairMate_stringtable select 6);
		_layer = 3;
	};
	case "car_wheel": {
		_linesPos = [[10*_pW,3.6*_pH,11*_pW,0.03*_pH],[21*_pW,3.6*_pH,0.034*_pW,8*_pH]];
		_linesPosBack = [[10*_pW,3.58*_pH,11*_pW,0.1*_pH],[20.97*_pW,3.6*_pH,0.1*_pW,8*_pH]];
		_partDamage = (XM8_repairMate_wheelParts call XM8_repairMate_getAvarageDamage);
		_partName = (XM8_repairMate_stringtable select 7);
		_layer = 1;
	};
	case "car_glass": {
		_linesPos = [[10*_pW,3.6*_pH,10*_pW,0.03*_pH],[0*_pW,0*_pH,0*_pW,0*_pH]];
		_linesPosBack = [[10*_pW,3.58*_pH,10*_pW,0.1*_pH],[0*_pW,0*_pH,0*_pW,0*_pH]];
		_partDamage = (XM8_repairMate_glassParts call XM8_repairMate_getAvarageDamage);
		_partName = (XM8_repairMate_stringtable select 8);
		_layer = 4;
	};
	case "car_fuel": {
		_linesPos = [[10*_pW,3.6*_pH,21.5*_pW,0.03*_pH],[31.5*_pW,3.6*_pH,0.034*_pW,1.3*_pH]];
		_linesPosBack = [[10*_pW,3.58*_pH,21.5*_pW,0.1*_pH],[31.47*_pW,3.6*_pH,0.1*_pW,1.3*_pH]];
		_partDamage = (XM8_repairMate_fuelParts call XM8_repairMate_getAvarageDamage);
		_partName = (XM8_repairMate_stringtable select 9);
		_layer = 5;
	};
};

//Show selected part
((format ["vehPic_L%1",_layer]) call _getControl) ctrlSetTextColor [1,1,1,1];

_condition = format ["%3   %1%2",floor((1 - _partDamage) * 100),"%",_partName];
_color = [1,1,0,0.8];
if (_partDamage < 0.5) then {_color set [0, ((_partDamage * 2) max 0.4)];};
if (_partDamage >= 0.5) then {_color set [1, (1 - ((_partDamage - 0.5) * 2)) max 0.3];};


{
	_ctrl = ((format ["partSelLineBack_%1",(_forEachIndex + 1)]) call _getControl);
	_ctrl ctrlSetbackgroundColor [0.35,0.36,0.39,0.5];
	_ctrl ctrlSetPosition (_linesPosBack select _forEachIndex);
	_ctrl ctrlCommit 0;
	_ctrl = ((format ["partSelLine_%1",(_forEachIndex + 1)]) call _getControl);
	_ctrl ctrlSetbackgroundColor _color;
	_ctrl ctrlSetPosition _x;
	_ctrl ctrlCommit 0;
} forEach _linesPos;
[("selPartName" call _getControl),[0*_pW,3.1*_pH,10*_pW,1*_pH],(toUpper _condition),"PuristaMedium",0.9,(_color call BIS_fnc_colorRGBAtoHTML),"left"] call _setSTextControl;

_gearData = _selectedPart call XM8_repairMate_checkGear;
if (count _gearData == 0) exitWith {};

{
	_count = format ["%1/%2",_x select 2,_x select 1];
	_color = if ((_x select 2) >= (_x select 1)) then {[1,1,1,1]} else {[0.5,0.5,0.5,0.7]};
	_tooltip = (getText (configfile >> "CfgMagazines" >> (_x select 3) >> "displayName"));
	[((format ["matCount_%1",(_forEachIndex + 1)]) call _getControl),[0.1*_pW+((_forEachIndex)*2.6*_pW),16.5*_pH,2.6*_pW,2*_pH],_count,"PuristaLight",0.75,(_color call BIS_fnc_colorRGBAtoHTML),"center"] call _setSTextControl;
	[((format ["matPic_%1",(_forEachIndex + 1)]) call _getControl),[0.28*_pW+(_forEachIndex*2.6*_pW),14.9*_pH,2*_pW,1.73*_pH],(_x select 0),_color,true,_tooltip] call _setPictureControl;
} forEach (_gearData select 0);

_offsetY = 0; _offsetX = 0;
{
	_pic = _x select 0;
	_have =  _x select 1;
	_tooltip =  _x select 2;
	_color = if (_have) then {[1,1,1,1]} else {[0.5,0.5,0.5,0.7]};
	if (_forEachIndex == 0) then {_offsetY = 5.2; _offsetX = 0;};
	if (_forEachIndex == 3) then {_offsetY = 7.2; _offsetX = 0;};
	if (_forEachIndex == 6) then {_offsetY = 9.2; _offsetX = 0;};
	if (_forEachIndex == 9) then {_offsetY = 11.2; _offsetX = 0;};
	[((format ["toolPic_%1",(_forEachIndex + 1)]) call _getControl),[0.3*_pW+(_offsetX*2.1*_pW),_offsetY*_pH,2*_pW,1.73*_pH],_pic,_color,true,_tooltip] call _setPictureControl;
	_offsetX = _offsetX + 1;
} forEach (_gearData select 1);

_repairAllScript = '
	0 spawn {
		if (XM8_repairMate_vehicleType == "car") then {
			for "_i" from 1 to 4 do {
				"car_wheel" call XM8_rapairMate_selectPart;
				[true] call XM8_rapairMate_perform;
				sleep 0.3;
			};
			{
				_x call XM8_rapairMate_selectPart;
				[true] call XM8_rapairMate_perform;
				sleep 0.3;
			} forEach ["car_engine","car_body","car_glass","car_fuel"];
		};
		if (ExileClientXM8CurrentSlide == "repairMate") then {
			["PartyCreatedMessage", [(XM8_repairMate_stringtable select 16)]] call ExileClient_gui_notification_event_addNotification;
		};
		if (isNull (uiNameSpace getVariable ["RscExileXM8", displayNull])) then {
			["RepairFailedWarning", [(XM8_repairMate_stringtable select 13)]] call ExileClient_gui_notification_event_addNotification;
		};
	};
';
[("repPartBut" call _getControl),[0.3*_pW,17.7*_pH,6*_pW,1*_pH],"[false] spawn XM8_rapairMate_perform",(XM8_repairMate_stringtable select 11),((_gearData select 2) and (_gearData select 3))] call _setButtonControl;
[("repAllBut" call _getControl),[6.7*_pW,17.7*_pH,6*_pW,1*_pH],_repairAllScript,(XM8_repairMate_stringtable select 10),((_gearData select 2) and (_gearData select 3))] call _setButtonControl;








