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
["vehicles", count _vehicles, 660] call _check;
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
diag_log format ["[SCAVENGER AUDIT] Indoors: %1; result: %2", {_x getVariable ["A3W_scavengerIndoors", false]} count _crates, _ok];
_ok