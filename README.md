# XM8_repairMate

Repair Mate script for Exile mod
This script adds more advanced repair mechanics to Exile.
Deferent items can be used to perform repair, some will be
consumed as materials others are used as tools.
There are 5 types of repairs for cars. They are engine, wheels, glasses,
fuel and body. Script is highly configurable, and allows to set exact
material costs and reqiured tools for deferent types of repair.
It is allowed to have materials and tools inside vehicle being repaired.
Script requires improved XM8 apps to work.

Authors
art and design - z3ro
code - vitaly'mind'chizhikov

Future plans
1. Support for helicopters (mostly done, will be added soon)
2. Support for boats (WIP)

INSTALLATION
1) Copy XM8_repairMate folder to XM8_apps\apps\ folder.
2) Edit "XM8_apps/XM8_apps_config.sqf"
	Uncomment next available app, and change it`s contents to
	XM8_apps_app<availableAppNumber> = [
		"Repair Mate",
		"XM8_apps\apps\XM8_repairMate\icons\repairMate_icon.paa", //FULL PATH FROM MISSION ROOT
		{call XM8_repairMate_checkNearByVehicles},
		true,
		"XM8_apps\apps\XM8_repairMate\scripts\XM8_repairMate_init.sqf" //FULL PATH FROM MISSION ROOT
	];
3) Edit "XM8_apps/XM8_apps_sliders.hpp"
	Add repairMate class
	class CfgXM8 {
		...
		<other classes>
		...
		//This slide use IDCs from 960050 to 960140
		class repairMate {
			controlID = 960050;
			title = "Repair Mate";
			onLoadScript = "XM8_apps\apps\XM8_repairMate\scripts\XM8_repairMate_repairMate_onLoad.sqf"; //FULL PATH FROM MISSION ROOT
		};
	};
4) Change XM8_repairMate\XM8_repairMate_costConfig.sqf to your liking.
5) Enjoy!

