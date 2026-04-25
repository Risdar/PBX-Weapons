
class MetalSniperAmmo : PB_Ammo
{
	default
	{
		Inventory.Amount 0;
		inventory.maxamount MetalSniperFullAmmo;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount MetalSniperFullAmmo;
	}
}
class PBX_ResoRound : PB_HighCalMag
{
    Default
    {
        Inventory.Amount 6;
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

class MS_Select_AimMode : inventory {default{inventory.maxamount 1;}}
class MS_Select_GrenMode : inventory {default{inventory.maxamount 1;}}
class MS_Select_Resonance : inventory {default{inventory.maxamount 1;}}
class MS_Select_NO : inventory {default{inventory.maxamount 1;}}
class MetalSniperUpgraded : inventory {default{inventory.maxamount 1;}}

class ResonanceAmmo_Upgrade : PB_UpgradeItem
{
	Default
	{
		//$Title Metal Sniper Upgrade
		//$Category Project Brutality - Weapon Upgrades
		//Game Doom;
		//SpawnID
		Height 32;
		//-COUNTITEM
		-INVENTORY.ALWAYSPICKUP;
		-COUNTITEM;
		Inventory.Pickupsound "CLIPIN";
		Inventory.PickupMessage "$PBX_MetalSniper_UpgradePickup";
		Tag "Metal Sniper Upgrade";
		Scale 0.65;
		FloatBobStrength 0.5;
	}

	States
	{
	Spawn:
		MSUR A -1;
		Stop;

	Pickup:
		TNT1 A 0 A_JumpIf(!FindInventory("PBX_MetalSniper") || !FindInventory("MetalSniperUpgraded") || CountInv("PB_HighCalMag") < GetAmmoCapacity("PB_HighCalMag"),1);
		fail;
		TNT1 A 0 {
			A_SetInventory("MetalSniperUpgraded", 1);
			A_GiveInventory("PBX_MetalSniper", 1);
			A_SetWeaponTag("PBX_MetalSniper","$PBX_MetalSniper_Tag");
		}
		Stop;
	}
}

class MS_ResonanceAmmo : PB_Projectile
{
	Default
	{
		PB_Projectile.BaseDamage 300;
		PB_Projectile.RipperCount 3;
		PB_Projectile.PenetrationCount 0;
        DamageType "Stun";
		RipperLevel 1;
		+PB_Projectile.WHIZCRACK;
		Obituary "%o was shredded by %k.";
	}

	actor isShield;

	override void OnHitActor(Actor target, Name dmgType)
	{
		if(!isShield) return;
		// console.printf("Resonance Ammo Shot");
		A_SpawnItemEx ("PBX_ResonanceExplosion",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
		A_StopSound(CHAN_BODY);
		A_StartSound("Explosion", CHAN_AUTO,CHANF_OVERLAP);
		A_StartSound("FAREXPL", CHAN_AUTO,CHANF_OVERLAP);
		Radius_Quake (3, 8, 0, 15, 0);
	}

	override int SpecialMissileHit(Actor victim)
	{
		if(victim && victim.GetClassName() == "Shield")
		{
			isShield = victim;
		}
		return super.SpecialMissileHit(victim);
	}
	
}

class PBX_ResonanceExplosion : PB_StunGrenadeExplosion
{
	Default
	{
		PB_StunGrenadeExplosion.props 150, 600, "Stun";
	}
}