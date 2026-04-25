class HMG_Select_Heated : inventory {default{inventory.maxamount 1;}}
class HMG_Select_Charged : inventory {default{inventory.maxamount 1;}}

Class HMGChamberAmmo : PB_Ammo{
	Default{
		inventory.maxamount neohmgFullAmmo;
		ammo.backpackamount 0;
		ammo.backpackmaxamount neohmgFullAmmo;
	}
}

class PB_792x57mm_Heated : PB_792x57mm
{
	Default
	{
		PB_Projectile.BaseDamage 35;
		PB_Projectile.RipperCount 0;
		PB_Projectile.PenetrationCount 0;
		+PB_Projectile.WHIZCRACK;
		+PB_Projectile.SMALLIMPACT;
		DamageType "Fire";
		// Obituary "%k forced %o to read Mein Kampf.";
	}
}

class PB_792x57mm_Charged : PB_792x57mm
{
	Default
	{
		PB_Projectile.BaseDamage 45;
		PB_Projectile.RipperCount 8;
		PB_Projectile.PenetrationCount 5;
		+PB_Projectile.WHIZCRACK;
		+PB_Projectile.SMALLIMPACT;
		DamageType "Plasma";
		// Obituary "%k forced %o to read Mein Kampf.";
	}
}