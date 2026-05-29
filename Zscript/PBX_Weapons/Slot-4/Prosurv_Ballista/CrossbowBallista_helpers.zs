class CB_Select_DemonicMode : inventory {default{inventory.maxamount 1;}}
class CB_Select_NormalMode : inventory {default{inventory.maxamount 1;}}
class CB_Select_NO : inventory {default{inventory.maxamount 1;}}
class Crossbow_Upgraded : inventory {default{inventory.maxamount 1;}}

Class CrossbowBallistaAmmo : PB_Ammo{
	Default
	{
		inventory.maxamount crossbowBallistaFullAmmo;
		ammo.backpackamount 0;
		ammo.backpackmaxamount crossbowBallistaFullAmmo;
		+INVENTORY.IGNORESKILL
	}
}

class BoltPickup : PB_HighCalMag
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

class PBX_DemonicBallistaUpgrade : PB_UpgradeItem
{
    Default
    {
        Scale 0.7;
	    +INVENTORY.ALWAYSPICKUP
		-COUNTITEM;
        Inventory.PickupMessage "$PBX_DemonicBallistaUpgrade_Pickup";
        Inventory.PickupSound "weapons/ballista/drawstring";
		Tag "$PBX_Prosurv_Ballista_UpgradeTag";
    }

    States
	{
        Spawn:
            CBOW T -1;
            Stop;

        Pickup:
            TNT1 A 0 A_JumpIf(!FindInventory("PBX_Prosurv_Ballista") || !FindInventory("Crossbow_Upgraded") || CountInv("PB_DTech") < GetAmmoCapacity("PB_DTech"),1);
            fail;
            TNT1 A 0 {
                // A_GiveInventory("CB_Select_DemonicMode", 1);
                A_SetInventory("Crossbow_Upgraded", 1);
                A_GiveInventory("PBX_Prosurv_Ballista", 1);
                A_SetWeaponTag("PBX_Prosurv_Ballista","$PBX_CrossbowBallista_Tag");
                A_GiveInventory("PB_DTech", 60);
            }
            Stop;
	}
}

class BallistaBolt : PB_MGNail 
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
        +NOGRAVITY;
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
			TNT1 A 0 { 
				LIFETIME = CVar.GetCVar("pb_naillifetime").GetInt(); 
				A_StopSound(CHAN_BODY);
				A_SpawnItemEx("HitPuff");
				A_Stop();
			}
		Hanging:
			CRBA A 35 A_JumpIf(LIFETIME <= 0, "Fade");
			TNT1 A 0 {
				LIFETIME--;
				return A_CheckBlock("Hanging", 0, 0, (RADIUS / 2) + 1);
			}
		Drop:
			TNT1 A 0 {
				bNOINTERACTION = false;
				bNOGRAVITY = false;
				bTHRUACTORS = true;
			}
		Fade:
            CRBA A 1 A_SpawnItemEx ("BoltPickup",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			stop;
		XDeath:
			TNT1 A 0 { 
				LIFETIME = CVar.GetCVar("pb_naillifetime").GetInt(); 
				A_StopSound(CHAN_BODY);
				A_StartSound("Weapons/NailHitBleed");
			}
		XDeathloop:
			CRBA A 35 A_JumpIf(LIFETIME <= 0, "Fade");
			TNT1 A 0 { LIFETIME--; }
			Loop;
	}
}
				
class ExplosiveBolt : BallistaBolt
{
    int user_stickycounter;
    int user_stuckEnemy;

    Default
    {
        PB_Projectile.BaseDamage 70;
		PB_Projectile.RipperCount 1;
        DamageType "Explosive";
        +DONTBOUNCEONSHOOTABLES;
        +USEBOUNCESTATE;
        +HITTRACER;
    }

    States
    {
        Fly:
            CRBA A 2 A_SpawnItemEx("BoltTrail", 0, 0, 0, 1, 0, 0, 180, 128);
            Loop;

        Death:
        Crash:
            TNT1 A 0
            {
                user_stickycounter = 0;
                A_NoGravity();
                A_ScaleVelocity(0);
            }

        Stuck:
            CRBA AAAAAAA 1 {
                if (user_stuckEnemy == 1)
                {
                    if (tracer)
                    {
                        A_Warp(AAPTR_TRACER, 0, 0, 20, 0, WARPF_NOCHECKPOSITION);
                    }
                    else
                    {
                        A_Fall();
                    }
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
            CRBA AAAAA 1;
            TNT1 A 0 {
                A_SpawnItem("GreenFlareSmall", 0, 0);
                A_PlaySound("BEP", CHAN_BODY);
                A_Warp(AAPTR_TRACER, 0, 0, 20, 0, WARPF_NOCHECKPOSITION);
            }
            CRBA AAAA 1;
            TNT1 A 0 {
                A_SpawnItem("GreenFlareSmall", 0, 0);
                A_PlaySound("BEP", CHAN_BODY);
                A_Warp(AAPTR_TRACER, 0, 0, 20, 0, WARPF_NOCHECKPOSITION);
            }
            CRBA AA 1;
            TNT1 A 0 {
                A_SpawnItem("GreenFlareSmall", 0, 0);
                A_PlaySound("BEP", CHAN_BODY);
                A_Warp(AAPTR_TRACER, 0, 0, 20, 0, WARPF_NOCHECKPOSITION);
            }
            TNT1 A 0 A_JumpIf(user_stickycounter > 4, "Detonate");
            Loop;

        XDeath:
        Bounce.Creature:
            CRBA A 1 {
                bTHRUACTORS = true;
                bSOLID = true;
                user_stuckEnemy = 1;
                A_Stop();
            }
            CRBA A 1 {
                bTHRUACTORS = false;
                bSOLID = false;
            }
            Goto Stuck;

        Detonate:
            TNT1 A 0 A_StopSound();
            TNT1 A 0 A_PlaySound("Explosion", CHAN_BODY);
            TNT1 A 0 A_Explode(250, 150);
            TNT1 AAA 0 A_CustomMissile("ExplosionSmoke", 22, 0, random(0, 360), 2, random(0, 360));
            TNT1 A 0 A_SpawnItemEx("ExplosionFlareSpawner", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
            TNT1 A 0 A_SpawnItemEx("DetectFloorCraterSmall", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
            TNT1 A 0 A_SpawnItemEx("DetectCeilCraterSmall", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
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

class DemonicBolt : PB_ProjectileAlt
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
        DamageType "Railgun";
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
            TNT1 A 0 A_PlaySoundEx("RAILIMP", "Auto");
            TNT1 A 0 A_SpawnItem("ExplosionParticleSpawner");
            //TNT1 A 0 A_SpawnItemEx("SmallUnderwaterExplosion", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
            TNT1 A 0 A_SpawnItemEx("DetectFloorCraterSmall", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
            TNT1 A 0 A_SpawnItemEx("DetectCeilCraterSmall", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
            TNT1 A 0 A_CustomMissile("PBExplosionparticlesSmall", 8, 0, random(0, 180), 2, random(40, 90));
            Stop;

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

class Razorblade : PB_ProjectileAlt
{
    Default
    {
        Radius 6;
        Height 8;
        Scale 0.75;
        Speed 60;
        PB_Projectile.BaseDamage 20;
		PB_Projectile.RipperCount 5;
		PB_Projectile.PenetrationCount 3;
        SeeSound "";
        DeathSound "";
        Obituary "%o's guts were shredded by %k's flying blade.";
        DamageType "Cut";
        Gravity 0;
        WallBounceFactor 1;
        BounceFactor 1;
        BounceCount 10;
        BounceSound "sawblade/ricochet";
        +BOUNCEONWALLS;
        +BOUNCEONFLOORS;
        +BOUNCEONCEILINGS;
        +BOUNCEONACTORS;
        +CANBOUNCEWATER;
        +USEBOUNCESTATE;
        +MISSILE;
        +RIPPER;
        -NOGRAVITY;
    }

    States
    {
        Spawn:
            CRBA A 0 NoDelay;
            CRBA CC 1 Bright {
                A_SpawnItemEx("RazorbladeTrail", 0, 0, 0, 0, 0, 0, 0, SXF_CLIENTSIDE);
                A_CustomMissile("ShotgunParticles", 0, 0, random(-160, -200), 2, random(0, 160));
                A_CustomMissile("SparkX", 0, 0, random(-160, -200), 2, random(30, 170));
                A_CustomMissile("SparkX", 0, 0, random(-160, -200), 2, random(30, 170));
                A_CustomMissile("SparkX", 0, 0, random(-160, -200), 2, random(30, 170));
            }
            CRBA LL 1 Bright
            {
                A_SpawnItemEx("RazorbladeTrail", 0, 0, 0, 0, 0, 0, 0, SXF_CLIENTSIDE);
                A_CustomMissile("ShotgunParticles", 0, 0, random(-160, -200), 2, random(0, 160));
                A_CustomMissile("SparkX", 0, 0, random(-160, -200), 2, random(30, 170));
                A_CustomMissile("SparkX", 0, 0, random(-160, -200), 2, random(30, 170));
                A_CustomMissile("SparkX", 0, 0, random(-160, -200), 2, random(30, 170));
            }
            TNT1 A 0 { bHITOWNER = true; }
            Loop;

        Bounce:
            TNT1 A 0 A_SpawnItemEx("RicoChet", 0, 0, -5, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
            TNT1 AAAAAAAAAAAAAAAA 0 A_CustomMissile("SparkX", 2, 0, random(0, 360), 2, random(30, 170));
            TNT1 AAAA 0 A_CustomMissile("HitSpark", 2, 0, frandom(0, 1) * frandom(0, 360), 2, frandom(0, 1) * frandom(30, 360));
            TNT1 AAAA 0 A_CustomMissile("HitSpark22", 2, 0, frandom(0, 1) * frandom(0, 360), 2, frandom(0, 1) * frandom(30, 360));
            TNT1 AAAA 0 A_CustomMissile("HitSpark23", 2, 0, frandom(0, 1) * frandom(0, 360), 2, frandom(0, 1) * frandom(30, 360));
            CRBA DD 1 Bright A_SpawnItemEx("RazorbladeTrail", 0, 0, 0, 0, 0, 0, 0, SXF_CLIENTSIDE);
            Goto Spawn;

        Death:
            TNT1 A 0 {
                A_Stop();
                A_PlaySoundEx("weapons/ballista/razor", "Auto");
                A_SetGravity(1.0);
            }
            TNT1 A 0 A_SpawnItemEx("RicoChet", 0, 0, -5, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
            CRBA EFGHIJK 1 Bright;
            CRBA L 38 Bright;
            TNT1 A 0 A_PlaySoundEx("RAILIMP", "Auto");
            TNT1 A 0 A_SpawnItem("ExplosionParticleSpawner");
            //TNT1 A 0 A_SpawnItemEx("SmallUnderwaterExplosion", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
            TNT1 A 0 A_SpawnItemEx("DetectFloorCraterSmall", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
            TNT1 A 0 A_SpawnItemEx("DetectCeilCraterSmall", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
            TNT1 A 0 A_CustomMissile("PBExplosionparticlesSmall", 8, 0, random(0, 180), 2, random(40, 90));
            Stop;

        XDeath:
            TNT1 A 0 {
                A_Stop();
                A_PlaySoundEx("weapons/ballista/razor", "Auto");
                A_SetGravity(1.0);
            }
            CRBA EFGHIJK 1 Bright;
            CRBA L 38 Bright;
            TNT1 A 0 A_PlaySoundEx("RAILIMP", "Auto");
            TNT1 A 0 A_SpawnItem("ExplosionParticleSpawner");
            //TNT1 A 0 A_SpawnItemEx("SmallUnderwaterExplosion", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
            TNT1 A 0 A_SpawnItemEx("DetectFloorCraterSmall", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
            TNT1 A 0 A_SpawnItemEx("DetectCeilCraterSmall", 0, 0, 0, 0, 0, 0, 0, SXF_NOCHECKPOSITION, 0);
            TNT1 A 0 A_CustomMissile("PBExplosionparticlesSmall", 8, 0, random(0, 180), 2, random(40, 90));
            Stop;
    }
}

class RazorBladeTrail : actor
{
    Default
    {
        radius 6;
        height 8;
        Scale 0.95;
        Alpha 0.95;
        +NOCLIP;
        +NOINTERACTION;
        Renderstyle "Translucent";
    }

    States
    {
        Spawn:
			CRBA CCCCCCCCCCCCCCC 1 A_FadeOut(0.15);
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