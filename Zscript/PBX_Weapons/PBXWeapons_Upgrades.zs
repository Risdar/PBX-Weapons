enum PBXWeapons_eUpgradeTipFlags
{
	// UPGRADES
    PBX_TIP_METALSNIPER_UPGRADE = 1 << 0,
    PBX_TIP_BATTLERIFLE_UPGRADE = 1 << 1,
    PBX_TIP_CROSSBOW_UPGRADE    = 1 << 2,
    PBX_TIP_CSSG_UPGRADE        = 1 << 3,
    PBX_TIP_EXCAVATOR_UPGRADE   = 1 << 4,
    // OTHERS
    PBX_TIP_DISABLE_UPGRADE     = 1 << 31
}
//////////////////////////// SLOT 3 ////////////////////////////////////////////////////////////////////////////////////
// CSSG
class CSSGUpgradeBase : PBXCore_UpgradeBase
{
	Default
	{
		Inventory.Pickupsound "misc/shellbox_PickUp";
	}

    override bool TryPickup(in out Actor toucher)
    {
        bool pickup = Super.TryPickup(toucher);
        if (pickup && pbxweapons_sendTip)
		{
			toucher.A_giveinventory("PB_Shell",10);
			Array<String> tips;
			tips.Push("$PBX_CSSGUpgrade_Tip1");
			tips.Push("$PBX_CSSGUpgrade_Tip2");
			PBXCore_TipsManager.SendTipArrayIfNeeded(tips, "PBXWeapons_UpgradeHelpFlags", PBX_TIP_CSSG_UPGRADE);
		}
        return pickup;
    }

    override void PBX_SetUpgradeSprite()
    {
        name s;

        switch(upgradetype)
		{
			case 'ExplosiveUpgrade': 		s = "XHEL"; break;
			case 'WhitePhosphorusUpgrade': 	s = "PHEL"; break;
			case 'TripleDoomUpgrade':		s = "DHEL"; break;
			case 'DanmakuUpgrade': 			s = "THEL"; break;
			case 'SubZeroUpgrade': 			s = "FHEL"; break;
            default:                        s = "TNT1"; break;
		}
        sprite = GetSpriteIndex(s);
    }

    States
	{
		LoadSprites:
			XHEL A 0; PHEL A 0; DHEL A 0; THEL A 0; FHEL A 0;
	}
}

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
		if(toucher.FindInventory("PBX_BDPBattleRifle") 
			&& toucher.FindInventory("BattleRifle_Upgraded") 
			&& toucher.CountInv("PB_HighCalMag") == toucher.GetAmmoCapacity("PB_HighCalMag")) {
			return false;
		}
        bool pickup = Super.TryPickup(toucher);
		if(pickup && pbxweapons_sendTip)
		{
			Array<String> tips;
			tips.Push("$PBX_BattleRifleUpgrade_Tip1");
			tips.Push("$PBX_BattleRifleUpgrade_Tip2");
			PBXCore_TipsManager.SendTipArrayIfNeeded(tips,"PBXWeapons_UpgradeHelpFlags", PBX_TIP_BATTLERIFLE_UPGRADE);
		}
		return pickup;
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
		if(toucher.FindInventory("PBX_MetalSniper") 
			&& toucher.FindInventory("MetalSniperUpgraded") 
			&& toucher.CountInv("PB_HighCalMag") == toucher.GetAmmoCapacity("PB_HighCalMag")) {
			return false;
		}
        bool pickup = Super.TryPickup(toucher);
		if(pickup && pbxweapons_sendTip)
		{
			Array<String> tips;
			tips.Push("$PBX_MetalSniperUpgrade_Tip1");
			tips.Push("$PBX_MetalSniperUpgrade_Tip2");
			tips.Push("$PBX_MetalSniperUpgrade_Tip3");
			PBXCore_TipsManager.SendTipArrayIfNeeded(tips,"PBXWeapons_UpgradeHelpFlags", PBX_TIP_METALSNIPER_UPGRADE);
		}
		return pickup;
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
		Inventory.althudicon "CB_ZC0";
		Tag "$PBX_Prosurv_Ballista_UpgradeTag";
    }

	override bool TryPickup(in out Actor toucher) 
	{
		if(toucher.FindInventory("PBX_Prosurv_Ballista") 
			&& toucher.FindInventory("Crossbow_Upgraded") 
			&& toucher.CountInv("PB_DTech") == toucher.GetAmmoCapacity("PB_DTech")) {
			return false;
		}
		bool pickup = Super.TryPickup(toucher);
		if(pickup && pbxweapons_sendTip)
		{
			Array<String> tips;
			tips.Push("$PBX_DemonicBallista_Tip1");
			tips.Push("$PBX_DemonicBallista_Tip2");
			tips.Push(string.format(StringTable.Localize("$PBX_DemonicBallista_Tip3"),PB_HelpNotificationsHandler.PB_FormatKeybinds("+pb_specialwheel")));
			PBXCore_TipsManager.SendTipArrayIfNeeded(tips,"PBXWeapons_UpgradeHelpFlags", PBX_TIP_CROSSBOW_UPGRADE);
		}
		return pickup;
	}

    States
	{
        Spawn:
            CB_Z C -1;
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
		bool pickup = Super.TryPickup(toucher);
		if(pickup && pbxweapons_sendTip)
		{
			Array<String> tips;
			tips.Push("$PBX_ExcavatorUpgrade_Tip1");
			tips.Push("$PBX_ExcavatorUpgrade_Tip2");
			tips.Push("$PBX_ExcavatorUpgrade_Tip3");
			PBXCore_TipsManager.SendTipArrayIfNeeded(tips,"PBXWeapons_UpgradeHelpFlags", PBX_TIP_EXCAVATOR_UPGRADE);
		}
		return pickup;
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
					weap.AltHudIcon = TexMan.CheckForTexture("EX_ZA0");
				}
                A_SetWeaponTag("PBX_Excavator","$PBX_Excavator_UpgradeTag");
            }
            Stop;
	}
}