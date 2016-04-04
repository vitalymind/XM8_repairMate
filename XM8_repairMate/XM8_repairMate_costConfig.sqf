//Configuration of repair costs, you can use any item classname. It should be from CfgMagazines though.
XM8_repairMate_costConfig = [
	//Part name (do not change this!)
	"car_engine",
	//Materials needed for repair (will be consumed)
	[
		// item classname, repair cost,
		"Exile_Item_MetalScrews",4, 
		"Exile_Item_ExtensionCord",1,
		"Exile_Item_DuctTape", 3,
		"Exile_Item_OilCanister", 1,
		"Exile_Item_ZipTie", 1,
		"Exile_Item_JunkMetal", 2	// Note, no comma after last number
	],
	//Tools needed for repair (will stay in inventory)
	[
		// item classname or [item classnames]
		"Exile_Item_Wrench",
		"Exile_Item_Foolbox",
		"Exile_Item_Hammer",
		["Exile_Item_CordlessScrewdriver","Exile_Item_Screwdriver"], //Can be array, if several tools are fit for repair
		"Exile_Item_Pliers"  // Note, no comma after last item
	],
	"car_wheel", //do not change this! Wheels are special, you will need given material count for each damaged wheel.
	//Unlike other parts, you are able to repair one wheel at a time.
	["Exile_Item_CarWheel",1,"Exile_Item_MetalScrews",1],
	["Exile_Item_Wrench","Exile_Item_Foolbox","Exile_Item_Hammer"],
	"car_glass", //do not change this!
	["Exile_Item_DuctTape",2,"Exile_Item_ToiletPaper",2,"Exile_Item_Rope",2],
	["Exile_Item_Foolbox",["Exile_Item_Knife","Exile_Item_Handsaw"]],
	"car_fuel", //do not change this!
	["Exile_Item_Rope",1,"Exile_Item_ZipTie",1,"Exile_Item_MetalWire",1,"Exile_Item_MetalBoard",1],
	["Exile_Item_Knife","Exile_Item_Pliers","Exile_Item_Foolbox"],
	"car_body", //do not change this!
	["Exile_Item_MetalScrews",2,"Exile_Item_DuctTape",1,"Exile_Item_MetalBoard",1,"Exile_Item_WoodSticks",1,"Exile_Item_JunkMetal",1],
	["Exile_Item_Foolbox",["Exile_Item_Grinder","Exile_Item_Hammer"],["Exile_Item_Screwdriver","Exile_Item_CordlessScrewdriver"],"Exile_Item_Pliers"] //Note, no comma after last element
];



//Additional, hopefully usefull, information
/*
More or less full list of tools in Exile 0.9.6
	"Exile_Item_Matches","Exile_Item_CanOpener","Exile_Item_CordlessScrewdriver",
	"Exile_Item_Foolbox","Exile_Item_Grinder","Exile_Item_Hammer","Exile_Item_Handsaw","Exile_Item_Knife",
	"Exile_Item_Pliers","Exile_Item_PortableGeneratorKit","Exile_Item_Screwdriver","Exile_Item_Shovel",
	"Exile_Item_Wrench"
More or less full list of material in Exile 0.9.6
	"Exile_Item_MetalScrews","Exile_Item_CarWheel","Exile_Item_DuctTape","Exile_Item_ExtensionCord",
	"Exile_Item_JunkMetal","Exile_Item_Leaves","Exile_Item_MetalPole","Exile_Item_MetalBoard",
	"Exile_Item_MetalWire","Exile_Item_OilCanister","Exile_Item_Rope","Exile_Item_ToiletPaper",
	"Exile_Item_WoodLog","Exile_Item_WoodPlank","Exile_Item_WoodSticks","Exile_Item_WoodWindowKit",
	"Exile_Item_ZipTie"
*/


