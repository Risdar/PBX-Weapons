//////////////////////////// SLOT 2 ////////////////////////////////////////////////////////////////////////////////////
// Plasma Blaster
Class HellPistolerAmmo : PB_Ammo
{
	Default
	{
		inventory.amount 0;
		inventory.maxamount PBX_PlasmaBlaster.MAXCHARGE;
		ammo.backpackamount 0;
		ammo.backpackmaxamount PBX_PlasmaBlaster.MAXCHARGE;
	    Inventory.Icon "ARMZA0";
        +INVENTORY.IGNORESKILL;
	}
}

// Prosurv Blaster
Class BlasterPistolCharge : PB_Ammo
{
	Default
	{
		inventory.amount 0;
		inventory.maxamount PBX_ProsurvBlaster.MAXCHARGE;
		ammo.backpackamount 0;
		ammo.backpackmaxamount PBX_ProsurvBlaster.MAXCHARGE;
	    Inventory.Icon "ARMZA0";
        +INVENTORY.IGNORESKILL;
	}
}

// Lever Action
Class LeverActionAmmo : PB_Ammo
{
	Default
	{
		inventory.amount 0;
		inventory.maxamount PBX_Prosurv_LeverAction.MAGAZINE_SIZE;
		ammo.backpackamount 0;
		ammo.backpackmaxamount PBX_Prosurv_LeverAction.MAGAZINE_SIZE;
	    Inventory.Icon "ARMZA0";
        +INVENTORY.IGNORESKILL;
	}
}

class PBX_MarlinRound : PB_LowCalMag // What the PB_Unload uses
{
    Default
    {
        Inventory.Amount PBX_Prosurv_LeverAction.AMMO_TAKE_MARLIN;
        Inventory.PickupSound "weapons/casing";
        Inventory.Icon "4LVMA0";
    }

    override void PB_SetAmmoSprite()
    {
        sprite = GetSpriteIndex("4LVM");
    }

	States
    {
        CacheSprites:
            4LVM A 0;
    }
}

class PBX_MagnumRound : PB_LowCalMag
{
    Default
    {
        Inventory.Amount PBX_Prosurv_LeverAction.AMMO_TAKE_MAGNUM;
        Inventory.PickupSound "weapons/casing";
        Inventory.Icon "4M35A0";
    }

    override void PB_SetAmmoSprite()
    {
        sprite = GetSpriteIndex("4M35");
    }

	States
    {
        CacheSprites:
            4M35 A 0;
    }
}

//////////////////////////// SLOT 3 ////////////////////////////////////////////////////////////////////////////////////
// CSSG
Class CSSGShellsIn : Ammo
{
	default
	{
        Inventory.Amount 0;
		inventory.maxamount PBX_CSSG.BARREL_CAPACITY;
		ammo.backpackamount 0;
		ammo.backpackmaxamount PBX_CSSG.BARREL_CAPACITY;
		Inventory.Icon "AUSCA0";
        +INVENTORY.IGNORESKILL;
	}
}
class PBX_CSSG_BuckShell          : PBX_CSSG_ShellBase {override void PB_SetAmmoSprite() {sprite = GetSpriteIndex("ZCG8A0");}}
class PBX_CSSG_DragonsBreathShell : PBX_CSSG_ShellBase {override void PB_SetAmmoSprite() {sprite = GetSpriteIndex("ZC10A0");}}
class PBX_CSSG_SlugShell          : PBX_CSSG_ShellBase {override void PB_SetAmmoSprite() {sprite = GetSpriteIndex("ZCG9A0");}}
class PBX_CSSG_FlechetteShell     : PBX_CSSG_ShellBase {override void PB_SetAmmoSprite() {sprite = GetSpriteIndex("ZCG1A0");}}
class PBX_CSSG_FlakShell          : PBX_CSSG_ShellBase {override void PB_SetAmmoSprite() {sprite = GetSpriteIndex("ZCG2A0");}}
class PBX_CSSG_ExplosiveShell     : PBX_CSSG_ShellBase {override void PB_SetAmmoSprite() {sprite = GetSpriteIndex("ZCG7A0");}}
class PBX_CSSG_WPShell            : PBX_CSSG_ShellBase {override void PB_SetAmmoSprite() {sprite = GetSpriteIndex("ZCG6A0");}}
class PBX_CSSG_TDoomShell         : PBX_CSSG_ShellBase {override void PB_SetAmmoSprite() {sprite = GetSpriteIndex("ZCG5A0");}}
class PBX_CSSG_DanmakuShell       : PBX_CSSG_ShellBase {override void PB_SetAmmoSprite() {sprite = GetSpriteIndex("ZCG4A0");}}
class PBX_CSSG_SubZeroShell       : PBX_CSSG_ShellBase {override void PB_SetAmmoSprite() {sprite = GetSpriteIndex("ZCG3A0");}}

// PSG
class PumpShotgunAmmo : Ammo
{
    Default
    {
        Inventory.Amount 0;
        Inventory.MaxAmount PBX_ProSurvPSG.MAGAZINE_SIZE;
        Ammo.BackpackAmount 0;
        Ammo.BackpackMaxAmount PBX_ProSurvPSG.MAGAZINE_SIZE;
        Inventory.Icon "AUSCA0";
        +INVENTORY.IGNORESKILL;
    }
}

class PBX_LaserCharge : PB_RocketAmmo
{
    Default
    {
        Inventory.Amount PBX_ProSurvPSG.LASERCHARGE_TAKE;
        Inventory.PickupSound "Ammocase/Open";
        Inventory.Icon "LSRCS0";
        Scale .45;
    }

    override void PB_SetAmmoSprite()
    {
        sprite = GetSpriteIndex("LSRCS0");
        frame = 18;
    }

	States
    {
        CacheSprites:
            LSRC S 0;
    }
}

class PBX_AcidCharge : PB_RocketAmmo
{
    Default
    {
        Inventory.Amount PBX_ProSurvPSG.ACIDCHARGE_TAKE;
        Inventory.PickupSound "Ammocase/Open";
        Inventory.Icon "REMTS0";
        Scale .45;
    }

    override void PB_SetAmmoSprite()
    {
        sprite = GetSpriteIndex("REMTS0");
        frame = 18;
    }

	States
    {
        CacheSprites:
            REMT S 0;
    }
}

class PBX_SwarmCharge : PB_RocketAmmo
{
    Default
    {
        Inventory.Amount PBX_ProSurvPSG.SWARMCHARGE_TAKE;
        Inventory.PickupSound "Ammocase/Open";
        Inventory.Icon "SWRMS0";
        Scale .45;
    }

    override void PB_SetAmmoSprite()
    {
        sprite = GetSpriteIndex("SWRMS0");
        frame = 18;
    }

	States
    {
        CacheSprites:
            SWRM S 0;
    }
}

class PBX_Tripmine : PB_RocketAmmo
{
    Default
    {
        Inventory.Amount PBX_ProSurvPSG.TRIPMINE_TAKE;
        Inventory.PickupSound "Ammocase/Open";
        Inventory.Icon "TRPMA0";
		Scale 0.08;
    }

    override void PB_SetAmmoSprite()
    {
        sprite = GetSpriteIndex("TRPMA0");
    }

	States
    {
        CacheSprites:
            TRPM A 0;
    }
}

// SPAS 12
class PBX_SPAS12Mag : Ammo
{
    Default
    {
        Inventory.Amount 0;
        Inventory.MaxAmount PBX_SPAS12.MAGAZINE_SIZE;
        Ammo.BackpackAmount 0;
        Ammo.BackpackMaxAmount PBX_SPAS12.MAGAZINE_SIZE;
        Inventory.Icon "AUSCA0";
        +INVENTORY.IGNORESKILL;
    }
}

//////////////////////////// SLOT 4 ////////////////////////////////////////////////////////////////////////////////////
// Battle Rifle
class BR_Ammo : Ammo
{
    Default
    {
        Inventory.Amount 0;
        Inventory.MaxAmount PBX_BDPBattleRifle.MAGAZINE_SIZE;
        Ammo.BackpackAmount 0;
        Ammo.BackpackMaxAmount PBX_BDPBattleRifle.MAGAZINE_SIZE;
        Inventory.Icon "AUSCA0";
        +INVENTORY.IGNORESKILL;
    }
}

// Metal Sniper
class MetalSniperAmmo : PB_Ammo
{
	default
	{
		Inventory.Amount 0;
		inventory.maxamount PBX_MetalSniper.MAGAZINE_SIZE;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount PBX_MetalSniper.MAGAZINE_SIZE;
        Inventory.Icon "AUSCA0";
        +INVENTORY.IGNORESKILL;
	}
}

class PBX_ResoRound : PB_HighCalMag
{
    Default
    {
        Inventory.Amount PBX_MetalSniper.AMMO_TAKE_RESONANCE;
        Inventory.PickupSound "weapons/casing";
    }

    override void PB_SetAmmoSprite()
    {
        sprite = GetSpriteIndex("MSXEA0");
    }

	States
    {
        CacheSprites:
            MSXE A 0;
    }
}

// Normal Rifle
class NormalRifleAmmo : Ammo
{
    Default
    {
        Inventory.Amount 0;
        Inventory.MaxAmount PBX_NormalRifle.MAGAZINE_SIZE;
        Ammo.BackpackAmount 0;
        Ammo.BackpackMaxAmount PBX_NormalRifle.MAGAZINE_SIZE;
        Inventory.Icon "RIFLA0";
    }
}

class NormalRifleLeftAmmo : Ammo
{
    Default
    {
        Inventory.Amount 0;
        Inventory.MaxAmount PBX_NormalRifle.MAGAZINE_SIZE;
        Ammo.BackpackAmount 0;
        Ammo.BackpackMaxAmount PBX_NormalRifle.MAGAZINE_SIZE;
        Inventory.Icon "RIFLA0";
    }
}

// Crossbow Ballista
class CrossbowBallistaAmmo : Ammo
{
    Default
    {
        Inventory.Amount 0;
        Inventory.MaxAmount PBX_Prosurv_Ballista.ARROW_AMOUNT;
        Ammo.BackpackAmount 0;
        Ammo.BackpackMaxAmount PBX_Prosurv_Ballista.ARROW_AMOUNT;
        Inventory.Icon "RIFLA0";
    }
}

class PBX_BoltPickup : PB_HighCalMag
{
    Default
    {
        Inventory.Amount 1;
        Inventory.PickupSound "Ammocase/Open";
    }

    override void PB_SetAmmoSprite()
    {
        sprite = GetSpriteIndex("CRBAA0");
    }

	States
    {
        CacheSprites:
            CRBA A 0;
    }
}

class PBX_ExplosiveBoltPickup : PB_RocketAmmo
{
    Default
    {
        Inventory.Amount 1;
        Inventory.PickupSound "Ammocase/Open";
    }

    override void PB_SetAmmoSprite()
    {
        sprite = GetSpriteIndex("CRBZD0");
        frame = 3;
    }

	States
    {
        CacheSprites:
            CRBZ D 0;
    }
}

//////////////////////////// SLOT 5 ////////////////////////////////////////////////////////////////////////////////////
// Neo HMG
Class HMGChamberAmmo : PB_Ammo
{
	Default
	{
		inventory.amount 0;
		inventory.maxamount PBX_NeoHMG.MAGAZINE_SIZE;
		ammo.backpackamount 0;
		ammo.backpackmaxamount PBX_NeoHMG.MAGAZINE_SIZE;
        +INVENTORY.IGNORESKILL;
	}
}

class HMGShield : PB_Ammo 
{
    Default 
	{
        Inventory.MaxAmount PBX_NeoHMG.SHIELD_MAXCHARGE;
    }
}

//////////////////////////// SLOT 6 ////////////////////////////////////////////////////////////////////////////////////
// Cyberdemon Rocket Launcher
class CyberRLDurability : PB_Ammo
{
	default
	{
		Inventory.Amount 0;
		inventory.maxamount PBX_CyberdemonRL.DURABILITY;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount PBX_CyberdemonRL.DURABILITY;
	}
}

// Excavator
Class ExcavatorRounds : PB_Ammo
{
	Default{
		inventory.maxamount PBX_Excavator.MAGAZINE_SIZE;
		ammo.backpackamount 0;
		ammo.backpackmaxamount PBX_Excavator.MAGAZINE_SIZE;
		+INVENTORY.IGNORESKILL
		Inventory.Icon "5DUNA0";
	}
}

// Mastermind Chaingun
class MastermindCGDurability : PB_Ammo
{
	default
	{
		Inventory.Amount 0;
		inventory.maxamount PBX_MastermindChaingun.DURABILITY;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount PBX_MastermindChaingun.DURABILITY;
	}
}

//////////////////////////// SLOT 7 ////////////////////////////////////////////////////////////////////////////////////
// BDP Railgun
Class BDPRailgunAmmo : PB_Ammo
{
	Default
	{
		inventory.amount 0;
		inventory.maxamount PBX_BDPRailgun.MAGAZINE_SIZE;
		ammo.backpackamount 0;
		ammo.backpackmaxamount PBX_BDPRailgun.MAGAZINE_SIZE;
	    Inventory.Icon "ARMZA0";
        +INVENTORY.IGNORESKILL;
	}
}

//////////////////////////// SLOT 8 ////////////////////////////////////////////////////////////////////////////////////


//////////////////////////// SLOT 9 ////////////////////////////////////////////////////////////////////////////////////

//////////////////////////// OTHERS ////////////////////////////////////////////////////////////////////////////////////
// Soul Charge
Class SoulCharge: PB_Ammo
{
    Default
    {
        inventory.amount 0;
		inventory.maxamount PBX_DemonExt.SOUL_CAPACITY / 2;
		ammo.backpackamount 0;
		ammo.backpackmaxamount PBX_DemonExt.SOUL_CAPACITY;
	    Inventory.Icon "ARMZA0";
        +INVENTORY.IGNORESKILL;
    }
}

// Nuke Ammo
class PBX_NukeAmmo : PB_Ammo
{
	Default
	{
		//$Title Nuclear Warhead
		//$Category Project Brutality/Ammunition
		//$Sprite MBLKA0
		//Scale 0.13;
		Tag "$PB_LOWCALMAG_TAG";
		Inventory.Amount 1;
		Inventory.MaxAmount 1;
		Inventory.PickupSound "misc/rockboxa";
		Ammo.BackpackAmount 1;
		Ammo.BackpackMaxAmount 1;
		// PB_Ammo.ammotype "lowcal";
        PB_Ammo.HUDGraphics "BARBACY1", "BARBACY2", "BARBACY3", "BARBACY4", "ABAR1", "AMMOIC12", "Yellow";
	}
}
