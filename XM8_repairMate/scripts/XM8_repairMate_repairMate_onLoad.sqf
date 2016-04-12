/*	XM8 RepairMate by vitaly'mind'chizhikov
	
	Vehicle repair script
	Forum thread 
*/
/*
	file: XM8_repairMate\scripts\XM8_repairMate_repairMate_onLoad.sqf
	function: XM8_repairMate_repairMate_onLoad
	
	This script will be executed once, when XM8 is opened.
	It is best place to create sliders and make controls.
*/

/*
function: XM8_repairMate_makeSlider
file: XM8_repairMate\scripts\XM8_repairMate_makeSlider.sqf

INPUT: NOTHING
OUTPUT: NOTHING

XM8 RepairMate by vitaly'mind'chizhikov
Vehicle repair script
*/

disableSerialization;
private ["_makeProgressBar","_makePictureControl","_makeSTextControl","_makeBackgroundControl","_makeFrameControl","_makeButtonControl",
"_display","_repairMateSliderIDC","_pW","_pH","_goBackScript"];

_pW = 0.025;
_pH = 0.04;
_display = uiNameSpace getVariable ["RscExileXM8", displayNull];
if (isNull _display) exitWith {diag_log "Error loading XM8 RepairMate, display is null"};
_sliders = _display displayCtrl 4007;
if (isNull _sliders) exitWith {diag_log "Error loading XM8 RepairMate, sliders control is null"};

_makeProgressBar = {
	params ["_pos","_amount","_enable","_parent","_color","_idc","_shown"];
	_ctrl = _display ctrlCreate ["RscProgress", _idc, _parent];
	_ctrl ctrlSetPosition _pos;
	_ctrl progressSetPosition _amount;
	_ctrl ctrlSetTextColor _color;
	_ctrl ctrlEnable _enable;
	_ctrl ctrlShow _shown;
	_ctrl ctrlCommit 0;
	_ctrl;
};
_makePictureControl = {
	params ["_pos","_pic","_parent","_color","_enable","_idc"];
	_ctrl = _display ctrlCreate ["RscPictureKeepAspect", _idc, _parent];
	_ctrl ctrlSetPosition _pos;
	_ctrl ctrlSetText _pic;
	_ctrl ctrlSetTextColor _color;
	_ctrl ctrlEnable _enable;
	_ctrl ctrlCommit 0;
	_ctrl;
};
_makeSTextControl = {
	params ["_pos","_parent","_text","_font","_size","_color","_align","_idc"];
	_ctrl = _display ctrlCreate ["RscStructuredText", _idc, _parent];
	_ctrl ctrlSetPosition _pos;
	_ctrl ctrlSetStructuredText (parseText format ["<t shadow='0' font='%5' align='%4' size='%2' color='%3'>%1</t>", _text,_size,_color, _align,_font]);
	_ctrl ctrlEnable false;
	_ctrl ctrlCommit 0;
	_ctrl;
};
_makeBackgroundControl = {
	params ["_pos","_color","_parent","_idc"];
	_ctrl = _display ctrlCreate ["RscBackground", _idc, _parent];
	_ctrl ctrlSetPosition _pos;
	_ctrl ctrlSetBackgroundColor _color;
	_ctrl ctrlEnable false;
	_ctrl ctrlCommit 0;
	_ctrl;
};
_makeFrameControl = {
	params ["_pos","_parent","_idc"];
	_ctrl = _display ctrlCreate ["RscFrame", _idc, _parent];
	_ctrl ctrlSetPosition _pos;
	_ctrl ctrlEnable false;
	_ctrl ctrlCommit 0;
	_ctrl;
};
_makeButtonControl = {
	params ["_pos","_action","_text","_parent","_idc"];
	_ctrl = _display ctrlCreate ["RscButtonMenu",_idc,_parent];
	_ctrl ctrlSetPosition _pos;
	_ctrl ctrlSetText _text;
	_ctrl ctrlSetEventHandler ["ButtonClick",_action];
	_ctrl ctrlCommit 0;
	_ctrl;
};
_getNextIDC = {
	params ["_key"];
	private ["_slideClassName","_baseIDC","_result","_map"];
	_slideClassName = "repairMate";
	_map = XM8_repairMate_repairMateIDCmap;
	_baseIDC = getNumber (missionConfigFile >> "CfgXM8" >> _slideClassName >> "controlID");
	_result = _baseIDC + (_map pushBack _key);
	_result;
};

//Clean up IDC map
XM8_repairMate_repairMateIDCmap = [];

//Initialize eventHandlers
_unloadScript = '
	if (ExileClientXM8CurrentSlide == "repairMate") then {
		ExileClientXM8CurrentSlide = "sideApps";
	};
	XM8_repairMate_vehicle = nil;
	XM8_repairMate_vehicleType = nil;
';
_display displayAddEventHandler ["unload",_unloadScript];

_repairSlider = _display ctrlCreate ["RscExileXM8Slide", ("mainSlide" call _getNextIDC), _sliders];

_goBackScript = '
	["sideApps", 1] call ExileClient_gui_xm8_slide;
	if (XM8_repairMate_inProgress) then {
		["RepairFailedWarning", [(XM8_repairMate_stringtable select 13)]] call ExileClient_gui_notification_event_addNotification;
	};
';
[[27.6*_pW,17.7*_pH,6*_pW,1*_pH],_goBackScript,"GO BACK",_repairSlider,("backBut" call _getNextIDC)] call _makeButtonControl;

[[0,0,0,0],_repairSlider,"","PuristaMedium",1,"#FFFFFF","left",("vehDispName" call _getNextIDC)] call _makeSTextControl;
[[0,0,0,0],_repairSlider,"PARTNAME","PuristaMedium",1,"#FFFFFF","left",("selPartName" call _getNextIDC)] call _makeSTextControl;
[[0*_pW,0*_pH,0*_pW,0*_pH],"",_repairSlider,[1,1,1,0],false,("vehPicMain" call _getNextIDC)] call _makePictureControl;
for "_i" from 1 to 10 do {
	[[0*_pW,0*_pH,0*_pW,0*_pH],"",_repairSlider,[1,1,1,0],false,((format ["vehPic_L%1",_i]) call _getNextIDC)] call _makePictureControl;
	[[0*_pW,0*_pH,0*_pW,0*_pH],"",_repairSlider,[1,1,1,0],false,((format ["vehPicMask_L%1",_i]) call _getNextIDC)] call _makePictureControl;
};
[[27.3*_pW,12*_pH,6.1*_pW,1.3*_pH],_repairSlider,"OVERALL","PuristaLight",1.38,"#FFFFFF","right",("overallT" call _getNextIDC)] call _makeSTextControl;
[[27.5*_pW,13*_pH,6*_pW,1*_pH],_repairSlider,"CONDITION","PuristaLight",1.12,"#FFFFFF","right",("conditionT" call _getNextIDC)] call _makeSTextControl;
[[24.95*_pW,13.1*_pH,9*_pW,3*_pH],_repairSlider,"","PuristaMedium",3.8,"#00FF00","right",("basicDmg" call _getNextIDC)] call _makeSTextControl;
[[0,0,0,0],"","",_repairSlider,("repPartBut" call _getNextIDC)] call _makeButtonControl;
[[0,0,0,0],"","",_repairSlider,("repAllBut" call _getNextIDC)] call _makeButtonControl;

for "_i" from 1 to 10 do {
	[[0*_pW,0*_pH,0*_pW,0*_pH],"",_repairSlider,[1,1,1,1],true,((format ["vehPartArea_%1",_i]) call _getNextIDC)] call _makePictureControl;
};
for "_i" from 1 to 2 do {
	[[0*_pW,0*_pH,0*_pW,0*_pH],[1,1,0.3,0.7],_repairSlider,((format ["partSelLineBack_%1",_i]) call _getNextIDC)] call _makeBackgroundControl;
	[[0*_pW,0*_pH,0*_pW,0*_pH],[1,1,0.3,0.7],_repairSlider,((format ["partSelLine_%1",_i]) call _getNextIDC)] call _makeBackgroundControl;
};

[[0.02*_pW,13.9*_pH,5*_pW,0.9*_pH],_repairSlider,"Materials","PuristaMedium",0.9,"#FFFFFF","left",("materialsT" call _getNextIDC)] call _makeSTextControl;
[[0*_pW,4.3*_pH,4*_pW,0.9*_pH],_repairSlider,"Tools","PuristaMedium",0.9,"#FFFFFF","left",("toolsT" call _getNextIDC)] call _makeSTextControl;
for "_i" from 1 to 10 do {
	[[0,0,0,0],_repairSlider,"","OrbitronLight",0.6,"#FFFFFF","center",((format ["matCount_%1",_i]) call _getNextIDC)] call _makeSTextControl;
	[[0,0,0,0],"",_repairSlider,[1,1,1,1],true,((format ["matPic_%1",_i]) call _getNextIDC)] call _makePictureControl;
};
for "_i" from 1 to 12 do {
	[[0,0,0,0],"",_repairSlider,[0,0,0,0],true,((format ["toolPic_%1",_i]) call _getNextIDC)] call _makePictureControl;
	[[0,0,0,0],[0,0,0,0],_repairSlider,((format ["toolBack_%1",_i]) call _getNextIDC)] call _makeBackgroundControl;
};

[[0.3*_pW,17.5*_pH,33.3*_pW,0.1*_pH],0,true,_repairSlider,[(150/255),(190/255),(200/255),1],("progress" call _getNextIDC),false] call _makeProgressBar








