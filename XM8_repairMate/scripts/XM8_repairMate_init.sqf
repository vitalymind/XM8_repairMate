/* 
function: XM8_repairMate_init
file: XM8_repairMate\scripts\XM8_repairMate_getAvarageDamage.sqf

INPUT: NOTHING
OUTPUT: NOTHING

XM8 RepairMate by vitaly'mind'chizhikov
Vehicle repair script
*/

private ["_error","_code","_unloadScript"];
params ["_root"];

//Mulfunction checks
if (isNil "_root") exitWith {_error = "XM8_repairMate error: Check XM8_apps_config.sqf path given incorrectly"; systemChat _error; diag_log _error;};

//Inittialize variables
XM8_repairMate_path = _root;
XM8_repairMate_vehicle = objNull;
XM8_repairMate_vehicleType = "";
XM8_repairMate_slideInited = false;
XM8_repairMate_vehicleScanRadius = 10;
XM8_repairMate_secondsForRepair = 4;
XM8_repairMate_selectedPart = "";
XM8_repairMate_inProgress = false;
XM8_repairMate_IDClist = [];
XM8_repairMate_engineParts = ["HitEngine"];
XM8_repairMate_fuelParts = ["HitFuel","HitFuelTank"];
XM8_repairMate_glassParts = ["HitGlass1","HitGlass2","HitGlass3","HitGlass4","HitGlass5","HitGlass6","HitRGlass","HitLGlass"];
XM8_repairMate_wheelParts = ["HitLFWheel","HitLF2Wheel","HitLMWheel","HitLBWheel","HitRFWheel","HitRF2Wheel","HitRMWheel","HitRBWheel"];
XM8_repairMate_rotorParts = [];
XM8_repairMate_avionicsParts = [];

//Inittialize functions
{
	if (isNil _x) then {
		_code = compileFinal (preprocessFileLineNumbers format (["%1XM8_repairMate\scripts\%2.sqf",XM8_repairMate_path, _x]));                              
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
	"XM8_rapairMate_fillSlider",
	"XM8_repairMate_makeSlider"
];

//Initialize configs and stringtable
if (isNil "XM8_repairMate_costConfig") then {
	call compile preProcessFileLineNumbers format ["%1%2",XM8_repairMate_path, "XM8_repairMate\XM8_repairMate_costConfig.sqf"];
	call compile preProcessFileLineNumbers format ["%1%2",XM8_repairMate_path, "XM8_repairMate\XM8_repairMate_optionalConfigs.sqf"];
	call compile preProcessFileLineNumbers format ["%1%2",XM8_repairMate_path, "XM8_repairMate\XM8_repairMate_stringtable.sqf"];
};

//Initialize eventHandlers
_unloadScript = '
	XM8_repairMate_slideInited = nil;
	if (ExileClientXM8CurrentSlide == "repairMate") then {
		ExileClientXM8CurrentSlide = "sideApps";
	};
	XM8_repairMate_vehicle = nil;
	XM8_repairMate_vehicleType = nil;
	XM8_repairMate_selectedPart = nil;
	XM8_repairMate_inProgress = nil;
	XM8_repairMate_IDClist = nil;
';
(uiNameSpace getVariable ["RscExileXM8", displayNull]) displayAddEventHandler ["unload",_unloadScript];

//Check nearby vehicles
(0 call XM8_repairMate_checkNearByVehicles) params ["_type","_vehicle"];
if (isNil "_type") exitWith {_error = "XM8_repairMate error: checkNearByVehicles function is not preperly inited"; systemChat _error; diag_log _error;};

if (_type == "noVehicles") exitWith {["RepairFailedWarning", [(XM8_repairMate_stringtable select 0)]] call ExileClient_gui_notification_event_addNotification};
if (_type == "vehicleIsNotLocal") exitWith {["RepairFailedWarning", [(XM8_repairMate_stringtable select 1)]] call ExileClient_gui_notification_event_addNotification};

if (_type in ["Car","Helicopter","Tank"]) then {
	if ((damage _vehicle) == 1) exitWith {["RepairFailedWarning", [(XM8_repairMate_stringtable select 4)]] call ExileClient_gui_notification_event_addNotification};

	//Temporary not supported vehicle classes
	if (_type == "Helicopter") exitWith {["RepairFailedWarning", [(XM8_repairMate_stringtable select 2)]] call ExileClient_gui_notification_event_addNotification};
	if (_type == "Tank") exitWith {["RepairFailedWarning", [(XM8_repairMate_stringtable select 3)]] call ExileClient_gui_notification_event_addNotification};
	
	if (_type == "Car") then {
		XM8_repairMate_selectedPart = "car_engine";
	};
	
	XM8_repairMate_vehicle = _vehicle;
	XM8_repairMate_vehicleType = _type;
	
	if (!XM8_repairMate_slideInited) then {
		XM8_repairMate_slideInited = true;
		0 call XM8_repairMate_makeSlider;
	};
	
	0 call XM8_rapairMate_fillSlider;
	
	["repairMate", 0] call ExileClient_gui_xm8_slide;
};

