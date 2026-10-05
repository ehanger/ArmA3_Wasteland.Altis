// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: vehicleSpawnClasses.sqf
//	@file Author: AgentRev

A3W_smallVehicles =
[
	"C_Quadbike_01_F",
	["B_Quadbike_01_F", "O_Quadbike_01_F", "I_Quadbike_01_F", "I_G_Quadbike_01_F"]
];

heavyTurrets = [
	"B_Radar_System_01_F", // MPQ-105 Radar
	"B_SAM_System_03_F", // MIM-105 Defender
	"B_SAM_System_02_F", // Mk21 Centurion
	"B_SAM_System_01_F", // Mk49 Spartan
	"B_AAA_System_01_F", // Praetorian 1C
	"O_Radar_System_02_F", // R-750 Cronus Radar 
	"O_SAM_System_04_F" // S-750 Rhea
];

tier1Vehicles = [

	// BLUFOR
	"B_MBT_01_cannon_F", // m2a1 slammer
	"B_MBT_01_TUSK_F", // m2a1 slammer TUSK
	"B_MBT_01_mlrs_F", // M5 Sandstorm
	"B_MBT_01_arty_F", // M4 Scorcher
	"B_Plane_CAS_01_F", // A-164 Wipeout
	"B_Plane_Fighter_01_F", // F/A-181 Black Wasp
	"B_Plane_Fighter_01_Stealth_F", // F/A-181 Black Wasp Stealth
	
	// OPFOR
	"O_MBT_02_cannon_F", // T-100 varsuk
	"O_MBT_04_cannon_F", // T-140 angara
	"O_MBT_04_command_F", // T-140K
	"O_MBT_02_arty_F", // 2S9 Sochor
	"O_Plane_CAS_02_dynamicLoadout_F", // To-199 Neophron
	"O_Plane_Fighter_02_F", // To-201 Shikra
	"O_Plane_Fighter_02_Stealth_F" // To-201 Shikra stealth
];

tier2Vehicles = [

	// BLUFOR
	"B_APC_Tracked_01_AA_F", // IFV-6a Cheetah
	"B_APC_Wheeled_01_cannon_F", // AMV-7 Marshall 
	"B_APC_Tracked_01_CRV_F", // CRV-6e Bobcat 
	"B_APC_Tracked_01_rcws_F", // IFV-6c Panther
	"B_AFV_Wheeled_01_cannon_F", // Rhino MGS 
	"B_AFV_Wheeled_01_up_cannon_F", // Rhino MGS UP

	// OPFOR
	"O_APC_Tracked_02_AA_F", // ZSU-39 Tigris
	"O_APC_Tracked_02_cannon_F", // BTR-K Kamish
	"O_APC_Wheeled_02_rcws_v2_F" // MSE-3 Marid
];

tier3Vehicles = [

	// BLUFOR
	"B_MRAP_01_F", // Hunter
	"B_MRAP_01_gmg_F", // Hunter GMG
	"B_MRAP_01_hmg_F", // Hunter HMG
	"B_LSV_01_AT_F", // Prowler AT 
	"B_LSV_01_armed_F", // Prowler HMG,
	"B_LSV_01_unarmed_F", // Prowler unarmed

	// OPFOR
	"O_MRAP_02_F", // Ifrit 
	"O_MRAP_02_hmg_F", // Ifrit GMG
	"O_MRAP_02_gmg_F" // Ifrit HMG
];


//Civilian Vehicle List - Random Spawns
civilianVehicles =
[
	"C_Hatchback_01_F",
	"C_Hatchback_01_sport_F",
	"C_SUV_01_F",
	"C_Offroad_01_F",
	["C_Van_01_box_F", "C_Van_01_transport_F", "C_Van_01_fuel_F"]
];

//Light Military Vehicle List - Random Spawns
lightMilitaryVehicles =
[
	"I_G_Offroad_01_F", "I_G_Offroad_01_armed_F", "I_G_Offroad_01_AT_F",
	"I_G_Offroad_01_F", "I_G_Offroad_01_armed_F"
];

//Medium Military Vehicle List - Random Spawns
mediumMilitaryVehicles =
[
	"B_MRAP_01_F",
	"O_MRAP_02_F",
	"I_MRAP_03_F"
];

//Water Vehicles - Random Spawns
waterVehicles =
[
	"C_Boat_Civil_01_F",
	"C_Boat_Civil_01_F",
	["C_Boat_Civil_01_police_F", "C_Boat_Civil_01_rescue_F"],
	["B_Boat_Armed_01_minigun_F", "O_Boat_Armed_01_hmg_F", "I_Boat_Armed_01_minigun_F"]
];

//Object List - Random Spawns.
staticWeaponsList =
[
	"B_Mortar_01_F",
	"O_Mortar_01_F",
	"I_Mortar_01_F",
	"I_G_Mortar_01_F"
];

//Object List - Random Helis.
staticHeliList =
[
	"C_Heli_Light_01_civil_F",
	"B_Heli_Light_01_F",
	"O_Heli_Light_02_unarmed_F",
	"I_Heli_light_03_unarmed_F"
	// don't put cargo helicopters here, it doesn't make sense to find them in towns; they spawn in the CivHeli mission
];

//Object List - Random Planes.
staticPlaneList =
[
	"I_Plane_Fighter_03_dynamicLoadout_F"
];

A3W_planeSpawnOdds = 0.25; // 0.0 to 1.0

//Random Weapon List - Change this to what you want to spawn in cars.
vehicleWeapons =
[
	[
		"hgun_PDW2000_F",
		"SMG_01_F", // Vermin
		"SMG_02_F", // Sting
		[
			"SMG_03_black", // ADR-97
			"SMG_03_camo",
			"SMG_03_hex",
			"SMG_03_khaki",
			"SMG_03_TR_black",
			"SMG_03_TR_camo",
			"SMG_03_TR_hex",
			"SMG_03_TR_khaki",
			"SMG_03C_black",
			"SMG_03C_camo",
			"SMG_03C_hex",
			"SMG_03C_khaki",
			"SMG_03C_TR_black",
			"SMG_03C_TR_camo",
			"SMG_03C_TR_hex",
			"SMG_03C_TR_khaki"
		]
	],
	["arifle_TRG20_F", "arifle_TRG21_F", "arifle_TRG21_GL_F"],
	["arifle_Mk20C_F", "arifle_Mk20_F", "arifle_Mk20_GL_F"],
	["arifle_Katiba_F", "arifle_Katiba_C_F", "arifle_Katiba_GL_F"],
	["arifle_MXC_F", "arifle_MX_F", "arifle_MX_GL_F", "arifle_MXM_F"],
	["srifle_EBR_F", "srifle_DMR_01_F"],
	["arifle_MX_SW_F", "LMG_Mk200_F", "LMG_Zafir_F"]
];

vehicleAddition =
[
	"muzzle_snds_L", // 9mm
	"muzzle_snds_M", // 5.56mm
	"muzzle_snds_570", // 5.7mm
	"muzzle_snds_H", // 6.5mm
	"muzzle_snds_H_MG", // 6.5mm LMG
	"muzzle_snds_B", // 7.62mm
	"muzzle_snds_acp", // .45 ACP
	"optic_Arco",
	"optic_SOS",
	"optic_Hamr",
	"optic_Aco",
	"optic_ACO_grn",
	"optic_aco_smg",
	"optic_Holosight",
	"optic_Holosight_smg",
	"acc_flashlight",
	"acc_pointer_IR",
	"Medikit",
	"Medikit",
	"FirstAidKit",
	"ToolKit"
];

vehicleAddition2 =
[
	"Chemlight_blue",
	"Chemlight_green",
	"Chemlight_yellow",
	"Chemlight_red"
];
