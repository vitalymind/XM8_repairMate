/*
function: XM8_repairMate_checkNearByVehicles
file: XM8_repairMate\scripts\XM8_repairMate_checkNearByVehicles.sqf

INPUT: NOTHING
OUTPUT: ARRAY
	- STRING. Check result.
	- OBJECT. Found vehicle. objNull if not found.

XM8 RepairMate by vitaly'mind'chizhikov
Vehicle repair script
*/
private ["_result","_nearVehicles","_vehicle"];
_result = ["error", objNull];
_nearVehicles = (nearestObjects [player, ["Car","Tank","Helicopter"], XM8_repairMate_vehicleScanRadius]);
if (count _nearVehicles == 0) then {
	_result set [0,"noVehicles"];
} else {
	_vehicle = _nearVehicles select 0;
	if (cursorTarget in _nearVehicles) then {_vehicle = cursorTarget};
	if (!local _vehicle) then {
		_result set [0,"vehicleIsNotLocal"];
	} else {
		if (_vehicle isKindOf "Car") then {_result set [0,"Car"]};
		if (_vehicle isKindOf "Tank") then {_result set [0,"Tank"]};
		if (_vehicle isKindOf "Helicopter") then {_result set [0,"Helicopter"]};
		_result set [1,_vehicle];
	};
};
_result;