// [Name, count, placement category, randomly selected class variants]
// The counts are per mission start, not respawn targets.
// Scaled from 660 to 1000 using largest remainders; ties follow table order.
A3W_scavengerVehicles =
[
	["Hatchback", 151, "wheeled", ["C_Hatchback_01_F"]],
	["Quadbike", 227, "wheeled", ["B_Quadbike_01_F", "O_Quadbike_01_F", "I_Quadbike_01_F"]],
	["Offroad", 38, "wheeled", ["C_Offroad_01_F"]],
	["MSE-3 Marid", 45, "wheeled", ["O_APC_Wheeled_02_rcws_v2_F"]],
	["Hunter armed", 182, "wheeled", ["B_MRAP_01_hmg_F", "B_MRAP_01_gmg_F"]],
	["AFV-4 Gorgon", 38, "wheeled", ["I_APC_Wheeled_03_cannon_F"]],
	["SUV", 38, "wheeled", ["C_SUV_01_F"]],
	["Strider armed", 45, "wheeled", ["I_MRAP_03_hmg_F", "I_MRAP_03_gmg_F"]],
	["Tempest", 38, "wheeled", ["O_Truck_03_transport_F", "O_Truck_03_covered_F"]],
	["UGV Stomper", 8, "wheeled", ["B_UGV_01_F"]],
	["Zamak", 23, "wheeled", ["I_Truck_02_transport_F", "I_Truck_02_covered_F"]],
	["M2A1 Slammer", 8, "tracked", ["B_MBT_01_cannon_F"]],
	["M2A4 Slammer UP", 5, "tracked", ["B_MBT_01_TUSK_F"]],
	["M5 Sandstorm", 8, "tracked", ["B_MBT_01_mlrs_F"]],
	["M4 Scorcher", 8, "tracked", ["B_MBT_01_arty_F"]],
	["T-100 Varsuk", 8, "tracked", ["O_MBT_02_cannon_F"]],
	["ZSU-39 Tigris", 12, "tracked", ["O_APC_Tracked_02_AA_F"]],
	["AH-9 Pawnee", 8, "rotor", ["B_Heli_Light_01_dynamicLoadout_F"]],
	["AR-2 Darter", 30, "rotor", ["B_UAV_01_F"]],
	["AH-99 Blackfoot", 3, "rotor", ["B_Heli_Attack_01_dynamicLoadout_F"]],
	["MH-9 Hummingbird", 8, "rotor", ["B_Heli_Light_01_F"]],
	["Mi-48 Kajman", 4, "rotor", ["O_Heli_Attack_02_dynamicLoadout_F"]],
	["A-143 Buzzard", 4, "fixed", ["I_Plane_Fighter_03_dynamicLoadout_F"]],
	["A-164 Wipeout", 4, "fixed", ["B_Plane_CAS_01_dynamicLoadout_F"]],
	["To-199 Neophron", 3, "fixed", ["O_Plane_CAS_02_dynamicLoadout_F"]],
	["MQ4 Greyhawk", 1, "fixed", ["B_UAV_02_dynamicLoadout_F"]],
	["Assault boat", 30, "boat", ["B_Boat_Transport_01_F", "O_Boat_Transport_01_F", "I_Boat_Transport_01_F"]],
	["Motorboat", 15, "boat", ["C_Boat_Civil_01_F"]],
	["Speedboat armed", 8, "boat", ["B_Boat_Armed_01_minigun_F", "O_Boat_Armed_01_hmg_F", "I_Boat_Armed_01_minigun_F"]]
];

// Small physical boxes fit inside buildings; their default cargo is replaced completely.
A3W_scavengerCrates =
[
	["NATO", 150, "Box_NATO_Wps_F"],
	["CSAT", 150, "Box_East_Wps_F"],
	["AAF", 150, "Box_IND_Wps_F"],
	["FIA", 50, "Box_FIA_Wps_F"]
];

// Exact global allocations, shuffled independently of class/faction.
A3W_scavengerWheeledLocations = [["field", 333], ["settlement", 333], ["road", 167]];
A3W_scavengerRotorLocations = [["field", 42], ["airfield", 11]];
A3W_scavengerFixedLocations = [["field", 9], ["airfield", 3]];
A3W_scavengerCrateLocations = [["field", 125], ["settlement", 225], ["road", 100], ["forest", 50]];
A3W_scavengerCrateLoadouts = [["smallarms", 400], ["launchers", 75], ["minesUAV", 25]];
A3W_scavengerIndoorChance = 0.5; // Fraction of settlement attempts that try an accessible interior first.
A3W_scavengerPositionAttempts = 600; // Bounded search; failures are logged, never silently placed at [0,0,0].
// Search lightly populated areas first, giving each area several local attempts.
A3W_scavengerSectorSize = 2000;
A3W_scavengerAreaAttempts = 20;
A3W_scavengerSectorVehicleLimit = 24; // Scaled with the vehicle population; spacing is unchanged.
A3W_scavengerSectorCrateLimit = 20;
A3W_scavengerVehicleSpacing = 45;
A3W_scavengerCrateSpacing = 20;