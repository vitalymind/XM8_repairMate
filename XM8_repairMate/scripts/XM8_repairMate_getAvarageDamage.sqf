/*
function: XM8_repairMate_getAvarageDamage
file: XM8_repairMate\scripts\XM8_repairMate_getAvarageDamage.sqf

INPUT: STRING. Type of part
OUTPUT: SCALAR. Avarage damage

XM8 RepairMate by vitaly'mind'chizhikov
Vehicle repair script
*/
private ["_result","_parts","_dmgs","_allKnownParts"];
_parts = _this;
(getAllHitPointsDamage XM8_repairMate_vehicle) params ["_hitParts","_selectionsNames","_dmgValues"];
_dmgs = [];
_result = 0;
_allKnownParts = [];
_allKnownParts append XM8_repairMate_engineParts;
_allKnownParts append XM8_repairMate_fuelParts;
_allKnownParts append XM8_repairMate_glassParts;
_allKnownParts append XM8_repairMate_wheelParts;
_allKnownParts append XM8_repairMate_rotorParts;
_allKnownParts append XM8_repairMate_avionicsParts;

for "_i" from 0 to ((count _hitParts) - 1) do {
	if ((_selectionsNames select _i) != "") then {
		if (count _parts != 0) then {
			if ((_hitParts select _i) in _parts) then {
				_dmgs pushBack (_dmgValues select _i);
			};
		} else {
			if (!((_hitParts select _i) in _allKnownParts)) then {
				_dmgs pushBack (_dmgValues select _i);
			};
		};
	};
};

{
	if (typeName _x == typeName 0) then {_result = _result + _x}
} forEach _dmgs;
if (count _dmgs != 0) then {_result = _result / (count _dmgs)};
_result;
