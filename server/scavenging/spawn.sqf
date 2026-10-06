// One startup pass only: no replenishment, no legacy respawn registration.
if (!isServer || !isNil "A3W_scavengerStarted") exitWith {};
A3W_scavengerStarted = true;
call compile preprocessFileLineNumbers "server\scavenging\config.sqf";
private _findPosition = compile preprocessFileLineNumbers "server\scavenging\findPosition.sqf";
private _fillCrate = compile preprocessFileLineNumbers "server\scavenging\fillCrate.sqf";
private _deck =
{
	private _values = [];
	{
		_x params ["_value", "_count"];
		for "_i" from 1 to _count do { _values pushBack _value };
	} forEach _this;
	_values call BIS_fnc_arrayShuffle
};

A3W_scavengerTowns = (call cityList) select {markerShape (_x select 0) != ""};
A3W_scavengerAirfields = allMapMarkers select {(_x select [0,11]) == "planeSpawn_"};
A3W_scavengerLand = [];
A3W_scavengerShore = [];
A3W_scavengerObjects = [];
A3W_scavengerFailures = [];
A3W_scavengerSectorColumns = ceil (worldSize / A3W_scavengerSectorSize);
A3W_scavengerSectors = [];
A3W_scavengerTownCounts = A3W_scavengerTowns apply { [0, 0] };
// Each sector holds [land anchors, shore anchors, airfield markers, vehicles, crates].
for "_i" from 1 to (A3W_scavengerSectorColumns * A3W_scavengerSectorColumns) do
{
	A3W_scavengerSectors pushBack [[], [], [], 0, 0];
};
private _sectorIndex =
{
	floor ((_this select 0) / A3W_scavengerSectorSize) +
		floor ((_this select 1) / A3W_scavengerSectorSize) * A3W_scavengerSectorColumns
};
{
	((A3W_scavengerSectors select ((markerPos _x) call _sectorIndex)) select 2) pushBack _x;
} forEach A3W_scavengerAirfields;
private _recordPlacement =
{
	params ["_object", "_location", "_crate"];
	private _sector = (_location select 0) call _sectorIndex;
	private _counts = A3W_scavengerSectors select _sector;
	private _column = if (_crate) then { 4 } else { 3 };
	_counts set [_column, (_counts select _column) + 1];
	_object setVariable ["A3W_scavengerSector", _sector];
	private _town = _location select 3;
	if (_town >= 0) then
	{
		_counts = A3W_scavengerTownCounts select _town;
		_column = if (_crate) then { 1 } else { 0 };
		_counts set [_column, (_counts select _column) + 1];
		_object setVariable ["A3W_scavengerTown", _town];
	};
};

// Sample the whole island once instead of repeatedly searching the sea that surrounds Altis.
// Shore anchors are land points with nearby water; spawned boats stay within 160 m of land.
for "_xPos" from 100 to (worldSize - 100) step 200 do
{
	for "_yPos" from 100 to (worldSize - 100) step 200 do
	{
		private _point = [_xPos, _yPos, 0];
		if (!surfaceIsWater _point) then
		{
			A3W_scavengerLand pushBack _point;
			((A3W_scavengerSectors select (_point call _sectorIndex)) select 0) pushBack _point;
			{
				private _water = _point getPos [100, _x];
				if (surfaceIsWater _water && {(_water select 0) >= 0} && {(_water select 1) >= 0} &&
					{(_water select 0) < worldSize} && {(_water select 1) < worldSize}) then
				{
					A3W_scavengerShore pushBack [_water, _x];
					((A3W_scavengerSectors select (_water call _sectorIndex)) select 1) pushBack [_water, _x];
				};
			} forEach [0,45,90,135,180,225,270,315];
		};
	};
	sleep 0.001;
};

if (A3W_scavengerLand isEqualTo [] || A3W_scavengerTowns isEqualTo []) exitWith
{
	diag_log "[SCAVENGER] ERROR: No land/town candidates; population not spawned.";
	A3W_scavengerFailures pushBack ["terrain", "No land/town candidates"];
};

private _wheeled = A3W_scavengerWheeledLocations call _deck;
private _rotor = A3W_scavengerRotorLocations call _deck;
private _fixed = A3W_scavengerFixedLocations call _deck;
private _cratePlaces = A3W_scavengerCrateLocations call _deck;
private _crateLoads = A3W_scavengerCrateLoadouts call _deck;
private _vehicleCount = 0;
private _crateCount = 0;
private _indoorCount = 0;

{
	_x params ["_name", "_count", "_category", "_classes"];
	private _spawned = 0;
	for "_i" from 1 to _count do
	{
		private _class = selectRandom _classes;
		private _place = switch (_category) do
		{
			case "wheeled": { _wheeled deleteAt (count _wheeled - 1) };
			case "rotor": { _rotor deleteAt (count _rotor - 1) };
			case "fixed": { _fixed deleteAt (count _fixed - 1) };
			case "boat": { "shore" };
			default { "field" };
		};
		private _location = if (isClass (configFile >> "CfgVehicles" >> _class)) then { [_place, _class] call _findPosition } else { [] };
		if !(_location isEqualTo []) then
		{
			_location params ["_pos", "_dir"];
			private _vehicle = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];
			_vehicle allowDamage false;
			_vehicle setDir _dir;
			if (_category == "boat") then
			{
				_vehicle setPosASL _pos;
			}
			else
			{
				_vehicle setPosATL (_pos vectorAdd [0,0,0.2]);
				_vehicle setVectorUp surfaceNormal _pos;
			};
			_vehicle setVariable ["A3W_scavengerObject", true, true];
			_vehicle setVariable ["A3W_scavengerPlacement", _place];
			_vehicle setVariable ["A3W_scavengerEntry", _name];
			_vehicle setVariable ["A3W_skipAutoSave", true, true];
			_vehicle setDamage 0;
			[_vehicle] call vehicleSetup;
			_vehicle setFuel 1;
			_vehicle setVehicleAmmo 1;
			// Wasteland custom loadouts can partially fill pylons: explicitly top them up.
			{
				if (_x != "") then { _vehicle setAmmoOnPylon [_forEachIndex + 1, getNumber (configFile >> "CfgMagazines" >> _x >> "count")] };
			} forEach getPylonMagazines _vehicle;
			[_vehicle, 1] call A3W_fnc_setLockState;
			if (unitIsUAV _vehicle) then
			{
				// Civilian, non-autonomous drones stay parked; existing Acquire Vehicle Ownership
				// moves their crew to the claimant's side, allowing any faction to scavenge them.
				[_vehicle, civilian, false, false] call fn_createCrewUAV;
				_vehicle engineOn false;
			};
			_vehicle spawn { sleep 3; _this allowDamage true };
			A3W_scavengerObjects pushBack _vehicle;
			[_vehicle, _location, false] call _recordPlacement;
			_spawned = _spawned + 1;
		}
		else
		{
			A3W_scavengerFailures pushBack [_name, _class, _place];
			diag_log format ["[SCAVENGER] FAILED vehicle %1 (%2), habitat %3", _name, _class, _place];
		};
		sleep 0.01;
	};
	_vehicleCount = _vehicleCount + _spawned;
	diag_log format ["[SCAVENGER] %1: %2/%3 spawned", _name, _spawned, _count];
} forEach A3W_scavengerVehicles;

{
	_x params ["_faction", "_count", "_class"];
	for "_i" from 1 to _count do
	{
		private _place = _cratePlaces deleteAt (count _cratePlaces - 1);
		private _loadout = _crateLoads deleteAt (count _crateLoads - 1);
		private _location = if (isClass (configFile >> "CfgVehicles" >> _class)) then { [_place, _class, true] call _findPosition } else { [] };
		if !(_location isEqualTo []) then
		{
			_location params ["_pos", "_dir", "_indoors"];
			private _box = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];
			_box setDir _dir;
			_box setPosATL (_pos vectorAdd [0,0,0.05]);
			if (!_indoors) then { _box setVectorUp surfaceNormal _pos };
			_box allowDamage false;
			_box setVariable ["allowDamage", false, true];
			_box setVariable ["A3W_scavengerObject", true, true];
			_box setVariable ["A3W_scavengerPlacement", _place];
			_box setVariable ["A3W_scavengerEntry", _faction];
			_box setVariable ["A3W_scavengerLoadout", _loadout];
			_box setVariable ["A3W_scavengerIndoors", _indoors];
			_box setVariable ["A3W_skipAutoSave", true, true];
			[_box, _faction, _loadout] call _fillCrate;
			A3W_scavengerObjects pushBack _box;
			[_box, _location, true] call _recordPlacement;
			_crateCount = _crateCount + 1;
			if (_indoors) then { _indoorCount = _indoorCount + 1 };
		}
		else
		{
			A3W_scavengerFailures pushBack [_faction, _class, _place, _loadout];
			diag_log format ["[SCAVENGER] FAILED crate %1, habitat %2, loadout %3", _faction, _place, _loadout];
		};
		sleep 0.01;
	};
} forEach A3W_scavengerCrates;

diag_log format ["[SCAVENGER] Complete: %1/1000 vehicles, %2/500 crates (%3 indoors), %4 failures. No replenishment until restart.", _vehicleCount, _crateCount, _indoorCount, count A3W_scavengerFailures];