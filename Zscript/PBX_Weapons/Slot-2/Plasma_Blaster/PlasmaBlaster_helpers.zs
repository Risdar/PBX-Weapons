class Plasma_Select_Auto : inventory {default{inventory.maxamount 1;}}
class Plasma_Select_Semi : inventory {default{inventory.maxamount 1;}}
class Plasma_Select_Burst : inventory {default{inventory.maxamount 1;}}
class Plasma_Select_Charge : inventory {default{inventory.maxamount 1;}}

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

class HellPistolAuto : PB_ProjectileAlt
{
    Default
    {
        PB_Projectile.BaseDamage 20;
		PB_Projectile.RipperCount 1;
		PB_Projectile.PenetrationCount 1;
        Speed 100;
        DamageType "Fire";
    }
}

class HellPistolNormal : PB_ProjectileAlt
{
    Default
    {
        +Ripper;
        PB_Projectile.BaseDamage 35;
		PB_Projectile.RipperCount 1;
		PB_Projectile.PenetrationCount 1;
        Speed 350;
        DamageType "Fire";
    }
}

class HellPistolCharge : PB_ProjectileAlt
{
    Default
    {
        +Ripper;
        PB_Projectile.BaseDamage 150;
		PB_Projectile.RipperCount 1;
		PB_Projectile.PenetrationCount 1;
        DamageType "Fire";
        Speed 350;
        Scale 1.5;
        Height 2.0;
    }
}