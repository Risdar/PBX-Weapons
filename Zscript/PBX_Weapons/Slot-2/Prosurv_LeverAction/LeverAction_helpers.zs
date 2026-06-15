class LA_Select_Marlin : inventory {default{inventory.maxamount 1;}}
class LA_Select_Magnum : inventory {default{inventory.maxamount 1;}}
class LA_Select_Laser : inventory {default{inventory.maxamount 1;}}

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

class PB_357Magnum : PB_500SW
{
	Default
	{
		PB_Projectile.BaseDamage 120;
		PB_Projectile.RipperCount 4;
		PB_Projectile.PenetrationCount 5;
		+PB_Projectile.WHIZCRACK;
		Obituary "%o was shot at somewhere else by %k.";
	}
}

class PB_444Marlin : PB_500SW
{
	Default
	{
		PB_Projectile.BaseDamage 200;
		PB_Projectile.RipperCount 5;
		PB_Projectile.PenetrationCount 5;
		+PB_Projectile.WHIZCRACK;
		DamageType "SSG";
		Obituary "%o was Hard hit with punch of Marlin by %k.";
	}
}