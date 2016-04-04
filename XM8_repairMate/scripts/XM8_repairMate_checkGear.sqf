/*
function: XM8_repairMate_checkGear
file: XM8_repairMate\scripts\XM8_repairMate_checkGear.sqf

INPUT: STRING. Part name
OUTPUT: ARRAY.
	- ARRAY with materials info
	- ARRAY with tools info
	- BOOL Is materials enough
	- BOOL Is tools enough

XM8 Repair Assistant by vitaly'mind'chizhikov
Vehicle repair script
*/

private ["_requiredMats","_requiredTools","_materials","_pic","_need","_have","_tools","_elem","_name","_enaughMats","_enaughTools","_availableItems"];
params ["_part"];

if ((XM8_repairMate_costConfig find _part) == -1) exitWith {diag_log "XM8_repairMate error: Part names were changed in XM8_repairMate_costConfig";[];};
_requiredMats = XM8_repairMate_costConfig select ((XM8_repairMate_costConfig find _part) + 1);
_requiredTools = XM8_repairMate_costConfig select ((XM8_repairMate_costConfig find _part) + 2);

_availableItems = ((itemsWithMagazines player) + (magazineCargo XM8_repairMate_vehicle));
if (count _requiredMats > 20) then {_requiredMats resize 20}; //Only 10 types of material supported for single repair
if (count _requiredTools > 12) then {_requiredTools resize 12}; //Only 12 types of tools supported for single repair

_materials = [];
for "_i" from 0 to (count _requiredMats - 1) step 2 do {
	_pic = getText (configfile >> "CfgMagazines" >> (_requiredMats select _i) >> "picture");
	_need = (_requiredMats select (_i + 1));
	_have = {_x == (_requiredMats select _i)} count _availableItems;
	_materials pushBack [_pic,_need,_have,(_requiredMats select _i)];
};
_tools = [];
{
	_elem = _x;
	_pic = "";
	_have = false;
	_name = "";
	if (typeName _elem == typeName []) then {
		{
			_name = _name + (getText (configfile >> "CfgMagazines" >> _x >> "displayName")) + " / ";
			if (_x in _availableItems) then {
				_have = true;
				_pic = getText (configfile >> "CfgMagazines" >> _x >> "picture");
			};
		} forEach _elem;
		_name = _name select [0, count _name - 3];
		if (count _elem != 0) then {
			if (!_have) then {_pic = getText (configfile >> "CfgMagazines" >> (_elem select 0) >> "picture");};
		};
	};
	if (typeName _elem == typeName "") then {
		_pic = getText (configfile >> "CfgMagazines" >> _elem >> "picture");
		_name = getText (configfile >> "CfgMagazines" >> _elem >> "displayName");
		if (_elem in _availableItems) then {
			_have = true;
		};
	};
	_tools pushBack [_pic, _have,_name];
} forEach _requiredTools;
_enaughMats = true;
{
	if ((_x select 1) > (_x select 2)) then {_enaughMats = false};
} forEach _materials;
_enaughTools = true;
{
	if (!(_x select 1)) then {_enaughTools = false};
} forEach _tools;

[_materials, _tools, _enaughMats, _enaughTools];