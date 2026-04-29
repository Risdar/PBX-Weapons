class HMG_Select_Heated : inventory {default{inventory.maxamount 1;}}
class HMG_Select_Charged : inventory {default{inventory.maxamount 1;}}

Class HMGChamberAmmo : PB_Ammo{
	Default{
		inventory.maxamount neohmgFullAmmo;
		ammo.backpackamount 0;
		ammo.backpackmaxamount neohmgFullAmmo;
	}
}

class HMGShield : PB_Ammo 
{
    Default 
	{
        Inventory.MaxAmount neohmgShieldAmmo;
    }
}

class PB_792x57mm_Heated : PB_792x57mm
{
	Default
	{
		PB_Projectile.BaseDamage 45;
		PB_Projectile.RipperCount 8;
		PB_Projectile.PenetrationCount 3;
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
		PB_Projectile.BaseDamage 35;
		PB_Projectile.RipperCount 1;
		PB_Projectile.PenetrationCount 3;
		+PB_Projectile.WHIZCRACK;
		+PB_Projectile.SMALLIMPACT;
		DamageType "Plasma";
		// Obituary "%k forced %o to read Mein Kampf.";
	}
}

class ShieldParticle : VisualThinker
{
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		texture = TexMan.CheckForTexture('SPKGA0');
		scale = (0.01,0.01);
		alpha = 1;
		flags = SPF_FULLBRIGHT;
		SetRenderStyle(STYLE_Add);
	}
	
	override void Tick()
	{
		if(alpha <= 0)
		{
			Destroy();
		}
		vel.z -= 0.2;
		alpha -= 0.04;
		Super.Tick();
	}
}