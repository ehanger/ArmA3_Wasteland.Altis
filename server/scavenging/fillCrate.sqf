params ["_box", "_faction", "_loadout"];
clearWeaponCargoGlobal _box;
clearMagazineCargoGlobal _box;
clearItemCargoGlobal _box;
clearBackpackCargoGlobal _box;

private _items = [];
switch (_loadout) do
{
	case "smallarms":
	{
		private _weapons = switch (_faction) do
		{
			case "NATO": { ["arifle_MX_F", "arifle_MXC_F", "arifle_MXM_F", "arifle_MX_SW_F", "SMG_01_F"] };
			case "CSAT": { ["arifle_Katiba_F", "arifle_Katiba_C_F", "LMG_Zafir_F", "srifle_DMR_01_F", "SMG_02_F"] };
			case "AAF": { ["arifle_Mk20_F", "arifle_Mk20C_F", "LMG_Mk200_F", "srifle_EBR_F", "hgun_PDW2000_F"] };
			default { ["arifle_TRG21_F", "arifle_TRG20_F", "hgun_PDW2000_F", "srifle_EBR_F"] };
		};
		_items = [["wep", _weapons, 6, 4], ["item", "FirstAidKit", 4], ["item", "optic_Aco", 2], ["mag", "SmokeShell", 4]];
		_box addBackpackCargoGlobal ["B_AssaultPack_khk", 2];
	};
	case "launchers":
	{
		private _launchers = switch (_faction) do
		{
			case "NATO": { ["launch_B_Titan_F", "launch_B_Titan_short_F"] };
			case "CSAT": { ["launch_O_Titan_F", "launch_O_Titan_short_F"] };
			case "AAF": { ["launch_I_Titan_F", "launch_I_Titan_short_F"] };
			default { ["launch_B_Titan_F", "launch_RPG32_F"] };
		};
		_items = [["wep", _launchers select 0, 1, 3], ["wep", _launchers select 1, 1, 3]];
		_box addBackpackCargoGlobal ["B_Carryall_khk", 2];
	};
	case "minesUAV":
	{
		_items =
		[
			["mag", "ATMine_Range_Mag", 2],
			["mag", "APERSMine_Range_Mag", 2],
			["mag", "DemoCharge_Remote_Mag", 2],
			["item", "MineDetector", 1],
			["item", "ToolKit", 1]
		];
		// Terminals for every player side allow anyone to acquire and operate found UAVs.
		{ _box addItemCargoGlobal [_x, 1] } forEach ["B_UavTerminal", "O_UavTerminal", "I_UavTerminal"];
		private _pack = switch (_faction) do
		{
			case "CSAT": { "O_UAV_01_backpack_F" };
			case "AAF": { "I_UAV_01_backpack_F" };
			default { "B_UAV_01_backpack_F" };
		};
		_box addBackpackCargoGlobal [_pack, 1];
	};
};
[_box, _items] call processItems;