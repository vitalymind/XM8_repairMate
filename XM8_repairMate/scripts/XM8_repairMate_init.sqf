/*	XM8 RepairMate app by vitaly'mind'chizhikov
	
	Vehicle repair script
	Forum thread 
*/

/*
	file: XM8_repairMate\scripts\XM8_repairMate_init.sqf
	function: no function
	
	This script will be executed once, when player login. It is executed straight from initLocalPlayer.sqf.
	This is best place to compile functions, define global variables and read gonfiguration files used in app.
*/

private ["_error","_code","_unloadScript"];
params ["_pathToAppFolder"];

//Inittialize variables
XM8_repairMate_path = _pathToAppFolder;
XM8_repairMate_vehicle = objNull;
XM8_repairMate_vehicleType = "";
XM8_repairMate_vehicleScanRadius = 10;
XM8_repairMate_secondsForRepair = 4;
XM8_repairMate_selectedPart = "";
XM8_repairMate_inProgress = false;
XM8_repairMate_repairMateIDCmap = [];
XM8_repairMate_engineParts = ["HitEngine"];
XM8_repairMate_fuelParts = ["HitFuel","HitFuelTank"];
XM8_repairMate_glassParts = ["HitGlass1","HitGlass2","HitGlass3","HitGlass4","HitGlass5","HitGlass6","HitRGlass","HitLGlass"];
XM8_repairMate_wheelParts = ["HitLFWheel","HitLF2Wheel","HitLMWheel","HitLBWheel","HitRFWheel","HitRF2Wheel","HitRMWheel","HitRBWheel"];
XM8_repairMate_rotorParts = [];
XM8_repairMate_avionicsParts = [];

//Initialize functions
{
	if (isNil _x) then {
		_code = compileFinal (preprocessFileLineNumbers format (["%1scripts\%2.sqf",_pathToAppFolder, _x]));                              
		if (isNil "_code") then {_code = compileFinal ""};
		missionNamespace setVariable [_x, _code];
	};
} forEach [
	"XM8_rapairMate_perform",
	"XM8_repairMate_checkGear",
	"XM8_rapairMate_focusPart",
	"XM8_rapairMate_selectPart",
	"XM8_repairMate_checkNearByVehicles",
	"XM8_repairMate_getAvarageDamage",
	"ExileClient_gui_xm8_slide_repairMate_onOpen",
	"XM8_repairMate_repairMate_onLoad"
];

//Initialize configs and stringtable
call compile preProcessFileLineNumbers format ["%1%2",_pathToAppFolder, "XM8_repairMate_costConfig.sqf"];
call compile preProcessFileLineNumbers format ["%1%2",_pathToAppFolder, "XM8_repairMate_optionalConfigs.sqf"];
call compile preProcessFileLineNumbers format ["%1%2",_pathToAppFolder, "XM8_repairMate_stringtable.sqf"];



