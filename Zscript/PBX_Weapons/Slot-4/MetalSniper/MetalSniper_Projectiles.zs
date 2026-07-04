class MS_ResonanceAmmo : PB_Projectile
{
	Default
	{
		PB_Projectile.BaseDamage 300;
		PB_Projectile.RipperCount 3;
		PB_Projectile.PenetrationCount 3;
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
		A_SpawnItemEx("PBX_ResonanceExplosion",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
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
		PB_StunGrenadeExplosion.props 250, 600, "Stun";
	}
}