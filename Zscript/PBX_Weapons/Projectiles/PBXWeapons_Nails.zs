//////////////////////////// CROSSBOW BALLISTA ////////////////////////////////////////////////////////////////////////////////////
class PBX_BallistaBolt : PB_NailgunGlue 
{
    Default
    {
        Radius 2;
        Height 2;
        Projectile;
        Speed 150;
        PB_Projectile.BaseDamage 60;
		PB_Projectile.RipperCount 5;
		PB_Projectile.PenetrationCount 3;
        Scale 1.0;
        Decal "Scorch";
        Damagetype "Nail";
        Projectile;
        +MISSILE;
        -NOGRAVITY;
        +BLOODSPLATTER;
        +THRUSPECIES;
        +MTHRUSPECIES;
        SeeSound "";
        Obituary "$OB_MPROCKET";
        Species "Marines";
    }

    States
	{
		Spawn:
			TNT1 A 0;
			CRBA A 1 A_StartSound("Weapons/NailFlight", CHAN_BODY, CHANF_LOOP, 1.0 );
			Goto Fly;
		Bounce:
			TNT1 A 0 A_SpawnItemEx("HitPuff");
		Fly:
			TNT1 A 0;
			CRBA A 1;
			Loop;
		Crash:
		Death:
			CRBA A 1 { 
				LIFETIME = CVar.GetCVar("pb_naillifetime").GetInt(); 
				A_StopSound(CHAN_BODY);
				A_SpawnItemEx("HitPuff");
				A_Stop();
                StickToWall();
			}
		DeathLoop:
			CRBA A 35 A_JumpIf(LIFETIME <= 0, "Fade");
			TNT1 A 0 {
				LIFETIME--;
				return A_CheckBlock("DeathLoop", 0, 0, (RADIUS / 2) + 1);
			}
		Drop:
			TNT1 A 0 {
				bNOINTERACTION = false;
				bNOGRAVITY = false;
				bTHRUACTORS = true;
			}
		Fade:
            CRBA A 1 A_SpawnItemEx("PBX_BallistaBoltPickup",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			stop;

		XDeath:
			CRBA A 1 { 
				LIFETIME = CVar.GetCVar("pb_naillifetime").GetInt(); 
				A_StopSound(CHAN_BODY);
				A_StartSound("Weapons/NailHitBleed");
                StickToWall();
			}
		XDeathloop:
			CRBA A 35 A_JumpIf(LIFETIME <= 0, "Fade");
			TNT1 A 0 { LIFETIME--; }
			Loop;
	}
}
				
class PBX_ExplosiveBolt : PBX_BallistaBolt
{
    int user_stickycounter;
    int user_stuckEnemy;

    Default
    {
        PB_Projectile.BaseDamage 60;
		PB_Projectile.RipperCount 1;
        DamageType "Nail";
        +DONTBOUNCEONSHOOTABLES;
        +USEBOUNCESTATE;
        +HITTRACER;
    }

    States
    {
        Fly:
            CRBZ D 2 A_SpawnItemEx("BoltTrail", 0, 0, 0, 1, 0, 0, 180, 128);
            Loop;

        Death:
        Crash:
            CRBZ D 1 {
                user_stickycounter = 0;
                A_NoGravity();
                A_ScaleVelocity(0);
                StickToWall();
            }
        Stuck:
            CRBZ DDDDDDD 1 {
                if (user_stuckEnemy == 1)
                {
                    if (tracer)
                        A_Warp(AAPTR_TRACER, 0, 0, 20, 0, WARPF_NOCHECKPOSITION);
                    else
                        A_Fall();
                }
                return ResolveState(null);
            }
            TNT1 A 0 {
                A_SpawnItem("GreenFlareSmall", 0, 0);
                A_PlaySound("BEP", CHAN_BODY);
                user_stickycounter++;
            }
            TNT1 A 0 A_JumpIf(user_stickycounter < 4, "Stuck");
            TNT1 A 0 A_PlaySoundEx("RA1IF1", "Auto");
            CRBZ DDDDD 1;
            TNT1 A 0 {
                A_SpawnItem("GreenFlareSmall", 0, 0);
                A_PlaySound("BEP", CHAN_BODY);
                A_Warp(AAPTR_TRACER, 0, 0, 20, 0, WARPF_NOCHECKPOSITION);
            }
            CRBZ DDDD 1;
            TNT1 A 0 {
                A_SpawnItem("GreenFlareSmall", 0, 0);
                A_PlaySound("BEP", CHAN_BODY);
                A_Warp(AAPTR_TRACER, 0, 0, 20, 0, WARPF_NOCHECKPOSITION);
            }
            CRBZ DD 1;
            TNT1 A 0 {
                A_SpawnItem("GreenFlareSmall", 0, 0);
                A_PlaySound("BEP", CHAN_BODY);
                A_Warp(AAPTR_TRACER, 0, 0, 20, 0, WARPF_NOCHECKPOSITION);
            }
            TNT1 A 0 A_JumpIf(user_stickycounter > 4, "Detonate");
            Loop;

        XDeath:
        Bounce.Creature:
            CRBZ D 1 {
                bTHRUACTORS = true;
                bSOLID = true;
                user_stuckEnemy = 1;
                A_Stop();
            }
            CRBZ D 1 {
                bTHRUACTORS = false;
                bSOLID = false;
            }
            Goto Stuck;

        Detonate:
            TNT1 A 0 A_StopSound();
            TNT1 A 0 A_PlaySound("Explosion", CHAN_BODY);
            TNT1 AAA 0 A_CustomMissile("ExplosionSmoke", 22, 0, random(0, 360), 2, random(0, 360));
            TNT1 A 0 A_SpawnItemEx("ExplosionFlareSpawner", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
            TNT1 A 0 A_SpawnItemEx("DetectFloorCraterSmall", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
            TNT1 A 0 A_SpawnItemEx("DetectCeilCraterSmall", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
            // StickyExplosion is what deals damage, below are the definitions
            // TNT1 A 0 A_Explode(250, 10, 0, 0,10,0,0,"BulletPuff","Explosive")
            // TNT1 A 0 A_Explode(200,200)
            TNT1 A 0 A_SpawnItemEx("StickyExplosion", 0, 0, -2, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
            TNT1 A 0 A_SpawnItemEx("NewRocketExploFX", 0, 0, 0);
            TNT1 AAAAA 0 A_CustomMissile("ExplosionParticleVeryFast", 0, 0, random(0, 360), 2, random(0, 360));
            XXXX A 0 A_CustomMissile("ExplosionQuake", 1, 0, random(0, 360), 2, random(0, 160));
            TNT1 AAAAA 0 A_CustomMissile("MediumExplosionFlames", 0, 0, random(0, 360), 2, random(0, 360));
            TNT1 A 0 A_PlaySound("FAREXPL", CHAN_BODY);
            EXPL AA 0 A_CustomMissile("ExplosionSmoke", 0, 0, random(0, 360), 2, random(0, 360));
            Stop;
    }
}

class PBX_DemonicBolt : PB_NailgunGlue
{
    Default
    {
        Radius 5;
        Height 3;
        Projectile;
        Speed 100;
        PB_Projectile.BaseDamage 100;
		PB_Projectile.RipperCount 5;
		PB_Projectile.PenetrationCount 3;
        DamageType "Nail";
        Scale 1.0;
        Decal "Scorch";
        +MISSILE;
        +RIPPER;
        +NOGRAVITY;
        +EXTREMEDEATH;
        +BLOODSPLATTER;
        +THRUSPECIES;
        +MTHRUSPECIES;
        SeeSound "";
        DeathSound "Weapons/NailHit";
        Obituary "$OB_MPROCKET";
        Species "Marines";
    }

    States
    {
        Spawn:
            CRBA B 1 Bright;
            TNT1 AAAAA 0 A_CustomMissile("ObeliskTrailSpark", 0, 0, random(0, 40), 2, random(0, 160));
            TNT1 A 0 A_SpawnItem("BallistaFlare", -10, 0);
            CRBA B 1 Bright;
            TNT1 A 0 A_SpawnItem("BallistaFlare", -10, 0);
            CRBA B 1 Bright;
            TNT1 A 0 A_SpawnItem("BallistaFlare", -10, 0);
            Loop;

        Crash:
        Death:
            TNT1 A 0 A_SpawnItemEx("RicoChet", 0, 0, -5, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
            CRBA B 45 Bright;
            CRBA A 1 StickToWall();
        XDeath:
            TNT1 A 0 A_PlaySoundEx("RAILIMP", "Auto");
            TNT1 A 0 A_SpawnItem("ExplosionParticleSpawner");
            //TNT1 A 0 A_SpawnItemEx("SmallUnderwaterExplosion", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
            TNT1 A 0 A_SpawnItemEx("DetectFloorCraterSmall", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
            TNT1 A 0 A_SpawnItemEx("DetectCeilCraterSmall", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
            TNT1 A 0 A_CustomMissile("PBExplosionparticlesSmall", 8, 0, random(0, 180), 2, random(40, 90));
            Stop;

    }
}

class BoltTrail : RazorBladeTrail
{
    Default
    {
        radius 2;
        height 4;
        Scale 1.0;
    }

    States
    {
        Spawn:
			CRBA AAAAAAAAAAAAAAA 1 A_FadeOut(0.15);
			Stop;
    }
}

class BallistaFlare : actor
{
    Default
    {
        alpha 1.0;
        yscale 0.2;
        xscale 0.2;

        +NOINTERACTION;
        +NOGRAVITY;
        +FORCEXYBILLBOARD;
        +SQUAREPIXELS;

        renderstyle "Add";
        radius 1;
        height 1;
    }

    States
    {
        Spawn:
            FLAR A 2 BRIGHT;
            Stop;
    }
}

class PBX_ShockBolt : PBX_BallistaBolt
{
    Default
    {
        PB_Projectile.BaseDamage 60;
		PB_Projectile.RipperCount 1;
        DamageType "Nail";
        +DONTBOUNCEONSHOOTABLES;
        +USEBOUNCESTATE;
        +HITTRACER;
    }

    States
    {
        Fly:
            CRBS D 2 A_SpawnItemEx("BoltTrail", 0, 0, 0, 1, 0, 0, 180, 128);
            Loop;
        Crash:
		Stuck:
        Death:
		XDeath:
            TNT1 A 0 A_StopSound(6);
			TNT1 A 0 A_SpawnItemEx("PB_ShockBoltExplosion",0,0,1,0,0,0,0,SXF_NOCHECKPOSITION,0);
            Stop;
    }
}


// Unsure where this should actually go, but the same file worked just fine. Move it where it should be.
// The "A_SpawnItemEx("LightningGunPuff")" wasnt just a graphical thing. It carried a rather large stun area, making unusable for the intended bolt use.
// There are two A_Explode calls. The first one carries most of the damage: 250 electric in a small area.
// The other call carries the actual stun effect. 0 damage does not seem to have any effect, so it needs to be set to 1 damage.
class PB_ShockBoltExplosion : PB_StunGrenadeExplosion
{
	Default
	{
		PB_StunGrenadeExplosion.props 250, 16, "Electric"; //expDmg, expRad, expType;
	}
	States
	{
		Spawn:
			TNT1 A 0 NoDelay A_StartSound("LGBOMB");
			STFL ABCDEF 1 BRIGHT Light("LightningImpactLight") {
				A_SetScale(Scale.X+0.032,Scale.Y+0.032);
				A_SpawnProjectile("ElectroBlastTrail",6,0,random(0,359),CMF_AIMDIRECTION|CMF_TRACKOWNER,random(-180,180));
			}
		TNT1 A 0 {
			//A_SpawnItemEx("LightningGunPuff"); // Stun part
			A_SpawnItemEx("BlueFlare");
			A_Explode(expDmg,expRad,XF_THRUSTLESS,false,expRad,damagetype:expType);
			A_Explode(1,expRad,XF_THRUSTLESS,false,expRad,damagetype:"Stun");
			A_StartSound("STNBOEX");
			for(int i = 0; i < 10; i++)
			{
				A_SpawnProjectile("ElectroBlastTrail",6,0,random(0,359),CMF_AIMDIRECTION|CMF_TRACKOWNER,random(-180,180));
			}
		}
		XELC AABBCCDDEEFF 1 Bright Light("LightningImpactLight") A_SpawnProjectile("ElectroBlastTrail",6,0,random(0,359),CMF_AIMDIRECTION|CMF_TRACKOWNER,random(-180,180));
		Stop;
	}
}

//////////////////////////// SUPER NAILGUN ////////////////////////////////////////////////////////////////////////////////////
class SuperNail_Hot : PB_MGNailHot
{
    Default
    {
		PB_Projectile.BaseDamage 75;
    }
}

// Copied from the lightning API in PBXCore
class SuperNail_Lightning : PB_MGNail
{
	double ac_detectRange;
	double ac_range;
	int ac_maxvictims, ac_damage, ac_duration, ac_delay, ac_maxChains, ac_maxLinks;
	array<Actor> ac_victims;

	Default
	{
		Projectile;
        PB_Projectile.BaseDamage 50;
        DamageType "Nails";
        Translation "112:127=192:207", "224:231=80:87";
	}

    override void PostBeginPlay()
    {
        super.PostBeginPlay();
        ac_detectRange = 256;
        ac_range = 256;
        ac_maxvictims = 5;
        ac_damage = 1;
        ac_duration = 2;
        ac_delay = 2;
        ac_maxChains = 1;
        ac_maxLinks = 2;
    }

	virtual bool L_IsValidVictim(Actor victim, Actor damageSource, double distSquared)
	{
		return victim &&
			victim != self &&
			PBXCore_LightningController.L_IsValidVictim(victim, damageSource) &&
			self.Distance3DSquared(victim) <= distSquared &&
			self.CheckSight(victim);
	}

	virtual void L_ProjTick()
	{
		if (!bMissile)
		{
			A_StopSound(CHAN_VOICE);
			return;
		}

		Actor damageSource = target != null? target : Actor(self);
		PBXCore_LightningController.L_RemoveInvalidVictimsFromArr(damageSource, self, ac_victims, ac_detectRange);
		PBXCore_LightningController.L_AddValidVictimsToArr(damageSource, self, ac_victims, ac_detectRange, ac_maxvictims);

		if (ac_victims.Size() > 0)
			A_StartSound("lightnin/loop", CHAN_VOICE, CHANF_LOOPING);
		else
			A_StopSound(CHAN_VOICE);
		

		// Attack victims and draw lightning towards them:
		foreach (thing : ac_victims)
		{
			PBXCore_LightningController.L_StartChain(damageSource, thing, ac_damage, ac_range, ac_duration, ac_delay, ac_maxChains, ac_maxLinks);
			PBXCore_LightningController.L_DrawLightning(self.pos.PlusZ(self.height*0.5), thing.pos.PlusZ(thing.height*0.5));
		}
	}

	override void Tick()
	{
		Super.Tick();
		if (isFrozen()) return;

		L_ProjTick();
	}
}