// Run on the server immediately after startup, before players move/consume equipment.
if (!isServer) exitWith { diag_log "[SCAVENGER AUDIT] Run on server."; false };
if (isNil "A3W_scavengerObjects") exitWith { diag_log "[SCAVENGER AUDIT] Spawner has not run."; false };
private _ok = true;
private _check =
{
	params ["_label", "_actual", "_expected"];
	if (_actual != _expected) then { _ok = false };
	diag_log format ["[SCAVENGER AUDIT] %1: %2/%3 %4", _label, _actual, _expected, ["FAIL", "OK"] select (_actual == _expected)];
};
private _objects = A3W_scavengerObjects select {!isNull _x};
private _vehicles = _objects select {!(_x isKindOf "ReammoBox_F")};
private _crates = _objects select {_x isKindOf "ReammoBox_F"};
["vehicles", count _vehicles, 1000] call _check;
["crates", count _crates, 500] call _check;
["placement failures", count A3W_scavengerFailures, 0] call _check;
{
	_x params ["_name", "_expected", "_category", "_classes"];
	private _matching = _vehicles select {_x getVariable ["A3W_scavengerEntry", ""] == _name};
	[_name, count _matching, _expected] call _check;
	["valid classes: " + _name, {_x in _classes} count (_matching apply {typeOf _x}), _expected] call _check;
	if (_category == "tracked") then
	{
		["tracked field: " + _name, {_x getVariable ["A3W_scavengerPlacement", ""] == "field"} count _matching, _expected] call _check;
	};
} forEach A3W_scavengerVehicles;
{
	_x params ["_faction", "_expected", "_class"];
	[_faction, {_x getVariable ["A3W_scavengerEntry", ""] == _faction && typeOf _x == _class} count _crates, _expected] call _check;
} forEach A3W_scavengerCrates;
{
	_x params ["_place", "_expected"];
	["crate habitat: " + _place, {_x getVariable ["A3W_scavengerPlacement", ""] == _place} count _crates, _expected] call _check;
} forEach A3W_scavengerCrateLocations;
{
	_x params ["_loadout", "_expected"];
	["crate cargo: " + _loadout, {_x getVariable ["A3W_scavengerLoadout", ""] == _loadout} count _crates, _expected] call _check;
} forEach A3W_scavengerCrateLoadouts;
["damaged vehicles", {damage _x > 0.05} count _vehicles, 0] call _check;
["locked vehicles", {locked _x > 1} count _vehicles, 0] call _check;
["empty crates", {count weaponCargo _x + count magazineCargo _x + count itemCargo _x + count backpackCargo _x == 0} count _crates, 0] call _check;
["uncrewed UAVs", {unitIsUAV _x && {count crew _x == 0}} count _vehicles, 0] call _check;
// Use current positions, not creation counters, to expose movement or misplaced objects.
private _sectorCounts = A3W_scavengerSectors apply { [0, 0] };
private _outside = 0;
{
	private _pos = getPosWorld _x;
	if ((_pos select 0) < 0 || {(_pos select 1) < 0} || {(_pos select 0) >= worldSize} || {(_pos select 1) >= worldSize}) then
	{
		_outside = _outside + 1;
	}
	else
	{
		private _index = floor ((_pos select 0) / A3W_scavengerSectorSize) +
			floor ((_pos select 1) / A3W_scavengerSectorSize) * A3W_scavengerSectorColumns;
		private _counts = _sectorCounts select _index;
		private _column = if (_x isKindOf "ReammoBox_F") then { 1 } else { 0 };
		_counts set [_column, (_counts select _column) + 1];
	};
} forEach _objects;
["objects outside map", _outside, 0] call _check;
["overcrowded vehicle sectors", {(_x select 0) > A3W_scavengerSectorVehicleLimit} count _sectorCounts, 0] call _check;
["overcrowded crate sectors", {(_x select 1) > A3W_scavengerSectorCrateLimit} count _sectorCounts, 0] call _check;
diag_log format ["[SCAVENGER AUDIT] Occupied %1 m sectors: vehicles %2, crates %3", A3W_scavengerSectorSize,
	{(_x select 0) > 0} count _sectorCounts, {(_x select 1) > 0} count _sectorCounts];
{
	if ((_x select 0) + (_x select 1) > 0) then
	{
		diag_log format ["[SCAVENGER AUDIT] Sector %1: %2 vehicles, %3 crates", _forEachIndex, _x select 0, _x select 1];
	};
} forEach _sectorCounts;
{
	private _townIndex = _forEachIndex;
	diag_log format ["[SCAVENGER AUDIT] Town %1: %2 settlement vehicles, %3 settlement crates",
		_x select 2,
		{_x getVariable ["A3W_scavengerTown", -1] == _townIndex} count _vehicles,
		{_x getVariable ["A3W_scavengerTown", -1] == _townIndex} count _crates];
} forEach A3W_scavengerTowns;
diag_log format ["[SCAVENGER AUDIT] Indoors: %1; result: %2", {_x getVariable ["A3W_scavengerIndoors", false]} count _crates, _ok];
_ok