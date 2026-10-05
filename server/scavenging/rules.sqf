// Scavenger rules are applied after external configuration, on server and saving HC.
// General stores, base building, player inventories and non-equipment money uses remain available.
A3W_serverSpawning = 1;
A3W_vehicleSpawning = 0;
A3W_heliSpawning = 0;
A3W_planeSpawning = 0;
A3W_boatSpawning = 0;
A3W_boxSpawning = 0;
A3W_buildingLoot = 0;
A3W_buildingLootWeapons = 0;
A3W_vehicleLoot = 0;
A3W_serverMissions = 0; // Mission rewards/convoys would add equipment outside the requested population.
A3W_artilleryStrike = 0; // No paid artillery equipment as an alternate weapon purchase.
A3W_vehicleSaving = 0;
A3W_boxSaving = 0;
A3W_staticWeaponSaving = 0;
A3W_privateParking = 0;
A3W_showGunStoreStatus = 0;
A3W_gunStoreIntruderWarning = 0;
// Keep food/water and base parts without adding the legacy medical/ammunition supply crates.
essentialsList = essentialsList select {!(_x isKindOf "ReammoBox_F")};