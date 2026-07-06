class SeekerRocket : PB_ProjectileAlt
{
    Default
    {
        PB_Projectile.BaseDamage 100;
		+PB_PROJECTILE.NOCRITICALS
        Radius 11;
        Height 8;
        Speed 30;
        Projectile;
        +FRIENDLY
        +FORCEPAIN
        +RANDOMIZE
        +DEHEXPLOSION
        +EXTREMEDEATH
        +ROCKETTRAIL
        +BOSS
        DamageType "Nodrop";
        SeeSound "weapons/rocklf";
        DeathSound "rlboom";
        Decal "Scorch";
    }

    override void PostBeginPlay()
	{
		Super.PostBeginPlay();

		let aux = HomingShots_Aux(GiveInventoryType("HomingShots_Aux"));
		if (aux)
		{
			aux.level = 50; // adjusts how strong is the homing
			aux.SetStateLabel("Homing");
		}
	}

    override void OnDestroy()
	{
		Super.OnDestroy();

		// Remove the homing aux if we die
		Inventory aux = FindInventory("HomingShots_Aux");
		if (aux) aux.Destroy();
	}

	States
	{
        Spawn:
            MISL A 0;
        MissileFlying:
            TNT1 A 0 {
                If(WaterLevel < 1)
                A_SpawnItemEx("RocketTrailSparks",-10,0,0,-5,0,0);
            }
            MISL A 0;
            M1SL ABCD 1 Bright {
                A_SpawnItemEx("SeekerFlare");
                // A_SeekerMissile(7, 10, SMF_PRECISE|SMF_LOOK, 256, 10);
                A_SpawnItemEx("SeekerRocketSmokeTrail",-14,0,0,0,FRandom(-0.5,0.5),FRandom(-0.5,0.5),0,0,64);
            }
            Loop;

        Death:
            MISL A 0;
            TNT1 A 0 A_StopSound(6);
            EXPL A 0 {
                Radius_Quake (3, 16, 0, 15, 0);
                A_SpawnItem ("RicoChet", 0, -30);
                A_SpawnItemEx ("DetectFloorCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
                A_SpawnItemEx ("DetectCeilCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
            //A_SpawnItemEx ("UnderwaterExplosion",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
            }
            TNT1 A 0 Bright {
                A_SpawnItemEx ("ExplosionFlareSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
                A_SpawnItemEx ("RocketExplosion",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
                A_SpawnItemEx ("NewRocketExploFX", 0, 0, 0);
                A_CustomMissile ("ExplosionParticleHeavy", 0, 0, random (0, 360), 2, random (0, 180));
            }
            TNT1 A 0 Bright {
                A_CustomMissile ("ExplosionParticleHeavy", 0, 0, random (0, 360), 2, random (0, 360));
                A_CustomMissile ("ExplosionParticleVeryFast", 0, 0, random (0, 360), 2, random (0, 360));
                A_CustomMissile ("MediumExplosionFlames", 0, 0, random (0, 360), 2, random (0, 360));
                A_CustomMissile ("ExplosionSmokeFast22", 0, 0, random (0, 360), 2, random (0, 360));
            }
            TNT1 A 0 A_PlaySound("FAREXPL", 3);
            TNT1 A 20;
            Stop;
    }
}

class SeekerFlare : actor
{
    Default
    {
		Radius 6;
		Height 8;
		Scale 0.4;
        +NOGRAVITY
        -SOLID
        +RANDOMIZE
		RenderStyle "Add";
    }

    States
    {
		Spawn:
            W17M A 2 Bright;
            Stop;
    }
}

class SeekerRocketSmokeTrail : actor
{
    Default
    {
        Scale 0.50;
        Speed 0;
        Alpha 0.11;
        -NOGRAVITY
        -NOINTERACTION
        Gravity 0.005;
    }

    States
    {
        Spawn:
            TNT1 A 0;
            PUF2 EEFGHIJK 4 A_FadeOut(0.005);
            PUF2 LMNOPQRSTUVWXYZ 4 A_FadeOut(0.005);
            PUF3 ABC 2 A_FadeOut(0.005);
            Goto Death;
        Death:
            TNT1 A 0;
            Stop;
  }
}