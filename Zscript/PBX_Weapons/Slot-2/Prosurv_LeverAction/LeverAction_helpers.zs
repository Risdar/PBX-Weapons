class RespectLeverAction : inventory {default{inventory.maxamount 1;}}
class LA_Select_Marlin : inventory {default{inventory.maxamount 1;}}
class LA_Select_Magnum : inventory {default{inventory.maxamount 1;}}
class LeverActionAmmo : PB_Ammo {default{inventory.maxamount leveractionFullAmmo;}}

class PBX_MarlinRound : PB_LowCalMag // What the PB_Unload uses
{
	Default
	{
		Inventory.Amount 2;
		Inventory.PickupSound "weapons/casing";
		PB_Ammo.ammotype "marlinround";
	}

	override void PostBeginPlay()
    {
        Super.PostBeginPlay();
        sprite = GetSpriteIndex("4LVM");
    }

	States
	{
		Spawn:
			4LVM A -1;
			stop;
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