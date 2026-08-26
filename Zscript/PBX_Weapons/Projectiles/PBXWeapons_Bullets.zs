//////////////////////////// LEVER ACTION RIFLE ////////////////////////////////////////////////////////////////////////////////////
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
		PB_Projectile.BaseDamage 210;
		PB_Projectile.RipperCount 5;
		PB_Projectile.PenetrationCount 5;
		+PB_Projectile.WHIZCRACK;
		DamageType "SSG";
		Obituary "%o was Hard hit with punch of Marlin by %k.";
	}
}

//////////////////////////// METAL SNIPER ////////////////////////////////////////////////////////////////////////////////////
class MS_ResonanceRounds : PB_Projectile
{
	Default
	{
		PB_Projectile.BaseDamage 300;
		PB_Projectile.RipperCount 8;
		PB_Projectile.PenetrationCount 5;
        DamageType "Stun";
		RipperLevel 1;
		+PB_Projectile.WHIZCRACK;
		Obituary "%o was shredded by %k.";
	}
	
	override int SpecialMissileHit(Actor victim)
	{
		pbxcore_debug.print("Resonance Projectile Shot");
		if(!(victim is "Shield"))
			return super.SpecialMissileHit(victim);

		pbxcore_debug.print("Target is shield");

		let mActor = PB_StunGrenadeExplosion(Spawn("PB_StunGrenadeExplosion",self.pos));
		if(mActor)
		{
			pbxcore_debug.print("spawned stun explosion");
			mActor.target = target.player.mo;
			mActor.expDmg  = 250;
			mActor.expRad  = 1024;
			mActor.expType = "Stun";
		}
		A_StopSound(CHAN_BODY);
		A_StartSound("Explosion", CHAN_AUTO,CHANF_OVERLAP);
		A_StartSound("FAREXPL", CHAN_AUTO,CHANF_OVERLAP);
		Radius_Quake (3, 8, 0, 15, 0);
		return super.SpecialMissileHit(victim);
	}

}

//////////////////////////// NEO HMG ////////////////////////////////////////////////////////////////////////////////////
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