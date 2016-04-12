/*	XM8 RepairMate by vitaly'mind'chizhikov
	
	Vehicle repair script.
	Forum thread
*/
/*
	file: XM8_repairMate\scripts\ExileClient_gui_xm8_slide_repairMate_onOpen.sqf
	function: ExileClient_gui_xm8_slide_repairMate_onOpen
	
	This script will be executed everytime when related slide opened.
	It is best place to update slide (show players money for example).
*/

private ["_pW","_pH","_display","_getControl","_setPictureControl","_setSTextControl","_setBackgroundControl",
"_setButtonControl","_text","_dmg","_color","_pic","_avarageDamage"];
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
_setPictureControl = {
	params ["_ctrl","_pos","_pic","_color","_enable","_tooltip"];
	_ctrl ctrlSetPosition _pos;
	_ctrl ctrlSetText _pic;
	_ctrl ctrlSetTextColor _color;
	_ctrl ctrlSetTooltip _tooltip;
	_ctrl ctrlEnable _enable;
	_ctrl ctrlCommit 0;
};
_setSTextControl = {
	params ["_ctrl","_pos","_text","_font","_size","_color","_align"];
	_ctrl ctrlSetPosition _pos;
	_ctrl ctrlSetStructuredText (parseText format ["<t shadow='0' font='%5' align='%4' size='%2' color='%3'>%1</t>", _text,_size,_color, _align,_font]);
	_ctrl ctrlEnable false;
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
	_ctrl ctrlSetEventHandler ["ButtonClick",_action];
	_ctrl ctrlEnable _enable;
	_ctrl ctrlCommit 0;
};

//Vehicle name
_text = toUpper(getText (configfile >> "CfgVehicles" >> (typeOf XM8_repairMate_vehicle) >> "displayName"));
[("vehDispName" call _getControl),[0*_pW,1.5*_pH,34*_pW,1.3*_pH],_text,"PuristaBold",1.2,"#FFFFFF","left"] call _setSTextControl;

//Basic damage
_dmg = 1 - (damage XM8_repairMate_vehicle);
_text = format ["%1%2",floor(_dmg * 100),"%"];
_color = [1,1,0,1];
if (_dmg < 0.5) then {_color set [1, ((_dmg * 2) max 0.3)]};
if (_dmg >= 0.5) then {_color set [0, ((1 - ((_dmg - 0.5) * 2)) max 0.4)]};
[("basicDmg" call _getControl),[24.95*_pW,13.1*_pH,9*_pW,3*_pH],_text,"PuristaMedium",3.8,(_color call BIS_fnc_colorRGBAtoHTML),"right"] call _setSTextControl;

//disable buttons, reset vehicle picture
for "_i" from 1 to 10 do {
	[((format ["vehPartArea_%1",_i]) call _getControl),[0*_pW,0*_pH,0*_pW,0*_pH],"",[1,1,1,0],false,""] call _setPictureControl;
};
[("vehPicMain" call _getControl),[0,0,0,0],"",[0,0,0,0],false,""] call _setPictureControl;
for "_i" from 1 to 10 do {
	[((format ["vehPic_L%1",_i]) call _getControl),[0,0,0,0],"",[0,0,0,0],false,""] call _setPictureControl;
	[((format ["vehPicMask_L%1",_i]) call _getControl),[0,0,0,0],"",[0,0,0,0],false,""] call _setPictureControl;
};
{(_x call _getControl) ctrlSetText ""; (_x call _getControl) ctrlEnable false;} forEach ["leftToolsBut","rightToolsBut","leftMatBut","rightMatBut"];

if (XM8_repairMate_vehicleType == "Car") then {
	_pic = format ["%1icons\car_%2.paa",XM8_repairMate_path,"main"];
	[("vehPicMain" call _getControl),[7.5*_pW,-8.4*_pH,26*_pW,24*_pH],_pic,[1,1,1,1],false,""] call _setPictureControl;
	for "_i" from 1 to 5 do {
		_pic = format ["%1icons\car_%2.paa",XM8_repairMate_path,(["wheels","engine","body","glass","fuel"] select (_i - 1))];
		[((format ["vehPic_L%1",_i]) call _getControl),[7.5*_pW,-8.4*_pH,26*_pW,24*_pH],_pic,[1,1,1,0],false,""] call _setPictureControl;
	};
	{
		_ctrl = (format ["vehPartArea_%1",(_forEachIndex + 1)]) call _getControl;
		[_ctrl,[(_x select 0)*_pW,(_x select 1)*_pH,(_x select 2)*_pW,(_x select 3)*_pH],"",[1,1,1,1],true,""] call _setPictureControl;
		_ctrl ctrlSetEventHandler ["mouseEnter",format ["['on',%1] call XM8_rapairMate_focusPart",_forEachIndex]];
		_ctrl ctrlSetEventHandler ["mouseExit",format ["['off',%1] call XM8_rapairMate_focusPart",_forEachIndex]];
	} forEach [
		[18,9.5,5.5,5], //wheel
		[10,5.5,10,3.6], //engine
		[20.1,6,4,3.2],[8,9.5,9.6,4.5],[24,5,5.8,5], //body
		[16,2.3,8,3],[25,2.9,4,2], //Glass
		[30,4,3,2], //Fuel
		[30,6,3,2] //wheel2
	];
	_avarageDamage = [];
	_avarageDamage pushBack (XM8_repairMate_wheelParts call XM8_repairMate_getAvarageDamage);
	_avarageDamage pushBack (XM8_repairMate_engineParts call XM8_repairMate_getAvarageDamage);
	_avarageDamage pushBack ([] call XM8_repairMate_getAvarageDamage);
	_avarageDamage pushBack (XM8_repairMate_glassParts call XM8_repairMate_getAvarageDamage);
	_avarageDamage pushBack (XM8_repairMate_fuelParts call XM8_repairMate_getAvarageDamage);
	for "_i" from 1 to 5 do {
		_color = [0.8,0,0,0.1];
		_color set [3,0.1 * (_avarageDamage select (_i - 1))];
		_pic = format ["%1icons\car_%2_a.paa",XM8_repairMate_path,(["wheels","engine","body","glass","fuel"] select (_i - 1))];
		[((format ["vehPicMask_L%1",_i]) call _getControl),[7.5*_pW,-8.4*_pH,26*_pW,24*_pH],_pic,_color,false,""] call _setPictureControl;
	};
	XM8_repairMate_selectedPart call XM8_rapairMate_selectPart;
};















