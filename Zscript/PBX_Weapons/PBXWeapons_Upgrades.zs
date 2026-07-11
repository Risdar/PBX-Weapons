//////////////////////////// SLOT 3 ////////////////////////////////////////////////////////////////////////////////////
// CSSG
Class ExplosiveShellsUpgrade : CSSGUpgradeBase
{
	default
	{
		inventory.pickupmessage "$PBX_PICKUP_EXPL";
		PBXCore_UpgradeBase.upgradetoken 'ExplosiveUpgrade';
		PBXCore_UpgradeBase.Sprite 'ExplosiveUpgrade';
		Inventory.althudicon "XHELA0";
	}
}

Class WPShellsUpgrade : CSSGUpgradeBase
{
	default
	{
		inventory.pickupmessage "$PBX_PICKUP_WPSP";
		PBXCore_UpgradeBase.upgradetoken 'WhitePhosphorusUpgrade';
		PBXCore_UpgradeBase.Sprite 'WhitePhosphorusUpgrade';
		Inventory.althudicon "PHELA0";
	}
}

Class DoomShellsUpgrade : CSSGUpgradeBase
{
	default
	{
		inventory.pickupmessage "$PBX_PICKUP_DOOM";
		PBXCore_UpgradeBase.upgradetoken 'TripleDoomUpgrade';
		PBXCore_UpgradeBase.Sprite 'TripleDoomUpgrade';
		Inventory.althudicon "DHELA0";
	}
}

Class DanmakuShellsUpgrade : CSSGUpgradeBase
{
	default
	{
		Inventory.PickupMessage "$PBX_PICKUP_DNMK";
		PBXCore_UpgradeBase.upgradetoken 'DanmakuUpgrade';
		PBXCore_UpgradeBase.Sprite 'DanmakuUpgrade';
		Inventory.althudicon "THELA0";
	}
}

Class SubZeroShellsUpgrade : CSSGUpgradeBase
{
	default
	{
		inventory.pickupmessage "$PBX_CM_SUBZRLD";
		PBXCore_UpgradeBase.upgradetoken 'SubZeroUpgrade';
		PBXCore_UpgradeBase.Sprite 'SubZeroUpgrade';
		Inventory.althudicon "FHELA0";
	}
}

//////////////////////////// SLOT 4 ////////////////////////////////////////////////////////////////////////////////////
// Battle Rifle
class BattleRifle_Upgrade : PB_UpgradeItem
{
	Default
	{
		//$Title Battle Rifle Upgrade
		//$Category Project Brutality - Weapon Upgrades
		//Game Doom;
		//SpawnID
		Height 32;
		-INVENTORY.ALWAYSPICKUP;
		-COUNTITEM;
		Inventory.Pickupsound "CLIPIN";
		Inventory.PickupMessage "$PBX_BattleRifle_UpgradePickup";
		Inventory.althudicon "BRXUA0";
		Tag "$PBX_BattleRifle_UpgradeTag";
		Scale 1.0;
		FloatBobStrength 0.5;
	}

	override bool TryPickup(in out Actor toucher) 
	{
		if(toucher.FindInventory("PBX_BDPBattleRifle") && toucher.FindInventory("BattleRifle_Upgraded") && toucher.CountInv("PB_HighCalMag") == toucher.GetAmmoCapacity("PB_HighCalMag")) {
			return false;
		}
		return super.TryPickup(toucher);
	}

	States
	{
	Spawn:
		BRXU A -1;
		Stop;

	Pickup:
		TNT1 A 0 {
			A_SetInventory("BattleRifle_Upgraded", 1);
			A_GiveInventory("PBX_BDPBattleRifle", 1);
			A_SetWeaponTag("PBX_BDPBattleRifle","$PBX_BattleRifle_Tag");
            A_GiveInventory("PB_HighCalMag", 30);
		}
		Stop;
	}
}

// Metal Sniper
class MetalSniper_Upgrade : PB_UpgradeItem
{
	Default
	{
		//$Title Metal Sniper Upgrade
		//$Category Project Brutality - Weapon Upgrades
		//Game Doom;
		//SpawnID
		Height 32;
		-INVENTORY.ALWAYSPICKUP;
		-COUNTITEM;
		Inventory.Pickupsound "CLIPIN";
		Inventory.PickupMessage "$PBX_MetalSniper_UpgradePickup";
		Inventory.althudicon "MSURA0";
		Tag "$PBX_MetalSniper_UpgradeTag";
		Scale 0.65;
		FloatBobStrength 0.5;
	}

	override bool TryPickup(in out Actor toucher) 
	{
		if(toucher.FindInventory("PBX_MetalSniper") && toucher.FindInventory("MetalSniperUpgraded") && toucher.CountInv("PB_HighCalMag") == toucher.GetAmmoCapacity("PB_HighCalMag")) {
			return false;
		}
		return super.TryPickup(toucher);
	}

	States
	{
        Spawn:
            MSUR A -1;
            Stop;

        Pickup:
            TNT1 A 0 {
                A_SetInventory("MetalSniperUpgraded", 1);
                A_GiveInventory("PBX_MetalSniper", 1);
                A_SetWeaponTag("PBX_MetalSniper","$PBX_MetalSniper_Tag");
                A_GiveInventory("PB_HighCalMag", 30);
            }
            Stop;
	}
}

// Crossbow Ballista
class PBX_DemonicBallistaUpgrade : PB_UpgradeItem
{
    Default
    {
        Scale 0.7;
	    -INVENTORY.ALWAYSPICKUP
		-COUNTITEM;
        Inventory.PickupMessage "$PBX_DemonicBallistaUpgrade_Pickup";
        Inventory.PickupSound "weapons/ballista/drawstring";
		Inventory.althudicon "CBOWT0";
		Tag "$PBX_Prosurv_Ballista_UpgradeTag";
    }

	override bool TryPickup(in out Actor toucher) 
	{
		if(toucher.FindInventory("PBX_Prosurv_Ballista") && toucher.FindInventory("Crossbow_Upgraded") && toucher.CountInv("PB_DTech") == toucher.GetAmmoCapacity("PB_DTech")) {
			return false;
		}
		return super.TryPickup(toucher);
	}

    States
	{
        Spawn:
            CBOW T -1;
            Stop;

        Pickup:
            TNT1 A 0 {
                // A_GiveInventory("CB_Select_DemonicMode", 1);
                A_SetInventory("Crossbow_Upgraded", 1);
                A_GiveInventory("PBX_Prosurv_Ballista", 1);
                A_SetWeaponTag("PBX_Prosurv_Ballista","$PBX_CrossbowBallista_Tag");
                A_GiveInventory("PB_DTech", 60);
            }
            Stop;
	}
}

//////////////////////////// SLOT 6 ////////////////////////////////////////////////////////////////////////////////////
// Excavator
class PBX_ExcavatorUpgrade : PB_UpgradeItem
{
	Default
	{
		//$Title Excavator Upgrade
		//$Category Project Brutality - Weapon Upgrades
		//Game Doom;
		//SpawnID
		Height 32;
		-INVENTORY.ALWAYSPICKUP;
		-COUNTITEM;
		Inventory.Pickupsound "misc/ROCKBOXA";
		Inventory.PickupMessage "$PBX_ExcavatorUpgrade_Pickup";
		Inventory.althudicon "EX_ZA0";
		Tag "$PBX_Excavator_UpgradeTag";
		Scale 0.55;
		FloatBobStrength 0.5;
	}

	override bool TryPickup(in out Actor toucher) 
	{
		if(toucher.FindInventory("PBX_Excavator") 
		&& toucher.FindInventory("Excavator_Upgraded") 
		&& toucher.CountInv("PB_RocketAmmo") == toucher.GetAmmoCapacity("PB_RocketAmmo")
		&& toucher.CountInv("PB_Fuel") == toucher.GetAmmoCapacity("PB_Fuel")) {
			return false;
		}
		return super.TryPickup(toucher);
	}

	States
	{
        Spawn:
            EX_Z A -1;
            Stop;

        Pickup:
            TNT1 A 0 {
				A_GiveInventory("PB_RocketAmmo", 30);
                A_GiveInventory("PB_Fuel", 35);
                A_SetInventory("Excavator_Upgraded", 1);
                A_GiveInventory("PBX_Excavator", 1);
				let weap = PBX_Excavator(FindInventory("PBX_Excavator"));
				if(weap) {
					weap.isUpgraded = true;
				}
                A_SetWeaponTag("PBX_Excavator","$PBX_Excavator_UpgradeTag");
            }
            Stop;
	}
}