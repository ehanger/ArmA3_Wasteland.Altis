// Returns [ATL/ASL-water position, direction, indoors] or [] on exhausted search.
// Called in the scheduled startup script; never falls back to an unsafe map-centre position.
params ["_kind", "_class", ["_crate", false]];
private _radius = if (_crate) then { 1.2 } else { (sizeOf _class * 0.6) max 3 };
private _gradient = if (_class isKindOf "Air") then { 0.08 } else { 0.18 };
private _result = [];

for "_attempt" from 1 to A3W_scavengerPositionAttempts do
{
	private _pos = [];
	private _dir = random 360;
	private _indoor = false;
	private _mode = _kind;
	if (_mode == "developed") then { _mode = selectRandom ["settlement", "settlement", "airfield"] };

	switch (_mode) do
	{
		case "airfield":
		{
			if !(A3W_scavengerAirfields isEqualTo []) then
			{
				private _marker = selectRandom A3W_scavengerAirfields;
				_pos = (markerPos _marker) getPos [random 100, random 360];
				_dir = markerDir _marker;
			};
		};
		case "settlement":
		{
			private _town = selectRandom A3W_scavengerTowns;
			private _centre = markerPos (_town select 0);
			private _range = (_town select 1) / 2;
			_pos = _centre getPos [sqrt random 1 * _range, random 360];
			if (_crate && {random 1 < A3W_scavengerIndoorChance}) then
			{
				private _houses = nearestObjects [_centre, ["House"], _range] select
				{
					alive _x && {count (_x buildingPos -1) > 0} &&
					{getNumber (configFile >> "CfgVehicles" >> typeOf _x >> "numberOfDoors") > 0} &&
					{!((_x buildingExit 0) isEqualTo [0,0,0])}
				};
				if !(_houses isEqualTo []) then
				{
					private _house = selectRandom _houses;
					private _doorAvailable = false;
					for "_door" from 1 to getNumber (configFile >> "CfgVehicles" >> typeOf _house >> "numberOfDoors") do
					{
						if (_house getVariable [format ["BIS_disabled_Door_%1", _door], 0] == 0) exitWith { _doorAvailable = true };
					};
					private _spots = if (_doorAvailable) then { (_house buildingPos -1) call BIS_fnc_arrayShuffle } else { [] };
					{
						private _spot = _x;
						private _asl = ATLtoASL (_spot vectorAdd [0,0,0.6]);
						// Require a roof overhead: buildingPos can also contain balconies/rooftops.
						private _roof = lineIntersectsSurfaces [_asl, _asl vectorAdd [0,0,8], objNull, objNull, true, 1, "GEOM", "NONE"];
						private _clear = count _roof > 0 && {((_roof select 0) select 2) == _house} &&
							{_spot distance2D (_house buildingExit 0) > 1.8};
						// Keep the box clear of walls, furniture, and door frames.
						{
							if (lineIntersects [_asl, _asl vectorAdd [0.9 * sin _x, 0.9 * cos _x, 0]]) exitWith { _clear = false };
						} forEach [0,45,90,135,180,225,270,315];
						if (_clear && {count (nearestObjects [_spot, ["ReammoBox_F", "LandVehicle", "Air", "Man"], 2]) == 0}) exitWith
						{
							_pos = _spot;
							_indoor = true;
							_dir = 0;
						};
					} forEach _spots;
				};
			};
		};
		case "shore":
		{
			if !(A3W_scavengerShore isEqualTo []) then
			{
				private _edge = selectRandom A3W_scavengerShore;
				_pos = (_edge select 0) getPos [20 + random 40, _edge select 1];
				_dir = _edge select 1;
			};
		};
		default
		{
			_pos = (selectRandom A3W_scavengerLand) getPos [random 180, random 360];
			if (_mode == "road") then
			{
				private _roads = _pos nearRoads 200;
				_pos = [];
				if !(_roads isEqualTo []) then
				{
					private _road = selectRandom _roads;
					private _info = getRoadInfo _road;
					_dir = (_info select 6) getDir (_info select 7);
					_pos = (getPosATL _road) getPos [(_info select 1) / 2 + 3 + random 5, _dir + selectRandom [90,270]];
				};
			};
		};
	};

	private _valid = count _pos >= 2;
	if (_valid) then
	{
		_valid = (_pos select 0) > 0 && {(_pos select 1) > 0} && {(_pos select 0) < worldSize} && {(_pos select 1) < worldSize};
	};
	if (_valid && !_indoor) then
	{
		_pos = [_pos select 0, _pos select 1, 0];
		if (_mode == "shore") then
		{
			_valid = surfaceIsWater _pos && {getTerrainHeightASL _pos < -2};
			// Every edge of the hull must be afloat, not just its centre.
			{
				private _edgePos = _pos getPos [_radius, _x];
				if (!surfaceIsWater _edgePos || {getTerrainHeightASL _edgePos > -1.5}) exitWith { _valid = false };
			} forEach [0,45,90,135,180,225,270,315];
		}
		else
		{
			_valid = !surfaceIsWater _pos && {!isOnRoad _pos};
			if (_valid) then
			{
				_valid = !((_pos isFlatEmpty [_radius, -1, _gradient, _radius, 0, false, objNull]) isEqualTo []);
			};
			if (_valid && _mode == "field") then
			{
				_valid = count (nearestTerrainObjects [_pos, ["TREE", "SMALL TREE", "BUSH", "HOUSE", "BUILDING", "ROCK", "ROCKS"], _radius max 40, false, true]) == 0 &&
					{count (_pos nearRoads 35) == 0} &&
					{A3W_scavengerTowns findIf {_pos distance2D markerPos (_x select 0) < ((_x select 1) / 2 + 80)} == -1} &&
					{A3W_scavengerAirfields findIf {_pos distance2D markerPos _x < 300} == -1};
			};
			if (_valid && _mode == "forest") then
			{
				_valid = count (nearestTerrainObjects [_pos, ["TREE", "SMALL TREE"], 45, false, true]) >= 8;
			};
			if (_valid) then
			{
				_valid = count (nearestTerrainObjects [_pos, ["TREE", "SMALL TREE", "BUSH", "HOUSE", "BUILDING", "WALL", "FENCE", "ROCK", "ROCKS"], _radius, false, true]) == 0;
			};
		};
		if (_valid) then
		{
			_valid = count (nearestObjects [_pos, ["AllVehicles", "ReammoBox_F", "Thing"], _radius + 5]) == 0;
		};
	};
	// Avoid spawning directly on players, including during a long startup.
	if (_valid && {allPlayers findIf {_x distance2D _pos < 50} == -1}) exitWith { _result = [_pos, _dir, _indoor] };
	if (_attempt mod 20 == 0) then { sleep 0.001 };
};

_result