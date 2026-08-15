class NuclearRocket : actor
{
    Default
    {
        Gravity 0.2;
        DamageFunction 20000;
        Speed 100;
        Scale 1.0;
        Radius 6;
        Height 6;
        Damagetype "Nuke";
        Species "None";
        Obituary "$OBBD_NUKELAUNCHER";
        Projectile;
        MeleeDamage 0;
        Decal "Scorch";
        +FORCERADIUSDMG
        -NOGRAVITY
        +SKYEXPLODE
        +DOHARMSPECIES
        +NODAMAGETHRUST
        +EXTREMEDEATH
        +BLOODSPLATTER 
        +THRUSPECIES
        +MTHRUSPECIES
        +RANDOMIZE
    }

	States
	{
        Spawn:
			M1SL A 0 NoDelay A_StartSound("weapons/rocketloop",CHAN_BODY,CHANF_LOOP);
		Fly:
			M1SL ABCD 1 Bright Light("PB_ROCKET") {
				if(waterlevel < 1) {
					A_SpawnItemEx("OldschoolRocketSmokeTrail2",-3,0,0,-1,0,0);
					A_SpawnItemEx("RocketTrailSparks",-10,0,0,-5,0,0);
				}
			}
			Loop;

		Death:
            TNT1 A 0 A_SPawnItemEx("NuclearExplosion",0,0,0,0,0,0,0,SXF_TRANSFERPOINTERS | SXF_NOCHECKPOSITION,0);
			Stop;
	}
}



class NuclearExplosion : actor
{
    Default
    {
        Damagetype "Nuke";
        RenderStyle "None";
        Radius 1;
        Height 1;
    }

	States
	{
        Spawn:
            TNT1 A 0;
            TNT1 A 0 A_Explode(300, 1200, 1, 1, 1200);
            TNT1 A 1 ;
            TNT1 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 0 A_CustomMissile ("NuclearFlamesImpact", 5, 0, random (0, 360), 2, random (0, 10));
            TNT1 A 0 A_CustomMissile ("SpawnedExplosionNuke2", 10, 0, random (0, 360), 2, random(80, 90));
            //TNT1 AAA 0 A_CustomMissile ("lONGExplosionSpawner", 30, 0, random (0, 360), 2, 90);
            TNT1 AAA 0  A_SpawnItemEx("SpawnedExplosionNuke", random (-400, 400), random (-400, 400), random (0, 100));
            TNT1 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 0  A_SpawnItemEx("SpawnedExplosionNuke", random (-600, 600), random (-600, 600), random (0, 50));
            EXPL A 0 Radius_Quake (9, 200, 0, 300, 0);
            TNT1 AAAAAAAAAAAAAAAAAAA 0 A_SpawnItemEx("NukeFlare", random (-800, 800), random (-800, 800), random (0, 100));
            // TNT1 A 0 A_SpawnItemEX("HorizontalShockwave4",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
            TNT1 A 0 A_Explode(300, 2000, 1, 1, 4000);
            TNT1 A 0 A_PlaySound("Nuke/Explosion", 1);
            TNT1 A 0 A_Explode(400,3000, 1, 1, 1);
            TNT1 A 6 A_SpawnItemEx("NukeFlare", 0, 0, 300, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
            TNT1 A 6 A_SpawnItemEx("NukeFlare", 0, 0, 450, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
            TNT1 A 6 A_SpawnItemEx("NukeFlare", 0, 0, 600, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
            TNT1 A 6 A_SpawnItemEx("NukeFlare", 0, 0, 750, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
            TNT1 A 6 A_SpawnItemEx("NukeFlare", 0, 0, 900, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
            TNT1 A 6 A_SpawnItemEx("NukeFlare", 0, 0, 1100, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
            TNT1 A 6 A_SpawnItemEx("NukeFlare", 0, 0, 1200, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
            TNT1 A 6 A_SpawnItemEx("NukeFlare", 0, 0, 1300, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
            TNT1 A 6 A_SpawnItemEx("NukeFlare", 0, 0, 1400, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
            TNT1 A 6 A_SpawnItemEx("NukeFlare", 0, 0, 1500, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
            TNT1 AAAAA 0 A_SpawnItemEx("NukeFlare", random(-300, 300), random(-300, 300), 1600, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
            TNT1 AAAAA 6 A_SpawnItemEx("NukeFlare", random(-600, 600), random(-600, 600), 1600, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
            EXPL A 0 Radius_Quake (6, 200, 0, 300, 0);
            TNT1 AAAaaaaaaAA 12 A_SpawnItemEx("NuclearFlamesRepeat2", random(-600, 600), random(-600, 600), 1600, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
            TNT1 Aaaaaa 0 A_SpawnItemEx("NukeSmokebIG", random(-600, 600), random(-600, 600), 1600, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
            //TNT1 AAAAAA 0  A_CustomMissile ("NukeSmoke", random (50, 1200), 0, random (0, 360), 2, random(80, 90));
            //TNT1 AAA 0  A_CustomMissile ("NukeSmokeBig", 1400, 0, random (0, 360), 2, random(80, 90));
            TNT1 A 1000;
            Stop;
	}
}

class SpawnedExplosionNuke : actor
{
    Default
    {
        Speed 2;
        Damagetype "Nuke";
        renderstyle "none";
        +NOCLIP
        +NOGRAVITY
        +MISSILE
        +FORCERADIUSDMG
        +NODAMAGETHRUST
        +NOBLOCKMAP
    }
    
	states
	{
        Spawn:
            TNT1 A 0;
            TNT1 A 2 A_PlaySound("FAREXPL");
            TNT1 AA 32 A_CustomMissile ("NuclearFlames", 0, 0, random (0, 360), 2, random (0, 90));
            TNT1 A 0 A_Explode(128, 1000);
            TNT1 A 0 A_CustomMissile ("NukeSmoke", 0, 0, random (0, 360), 2, random (0, 90));
            TNT1 A 32 A_CustomMissile ("NuclearFlames", 0, 0, random (0, 360), 2, random (0, 90));
            TNT1 A 0 A_Explode(128, 1000);
            TNT1 A 32 A_CustomMissile ("NuclearFlames", 0, 0, random (0, 360), 2, random (0, 90));
            TNT1 A 0 A_Explode(128, 1000);
            TNT1 A 32 A_CustomMissile ("NuclearFlames", 0, 0, random (0, 360), 2, random (0, 90));
            TNT1 A 0 A_Explode(128, 1000);
            TNT1 AA 32 A_Explode(128, 1000);
            Stop;
	}
}

class SpawnedExplosionNuke2 : actor
{
    Default
    {
        Speed 24;
        Radius 2;
        Height 2;
        renderstyle "none";
        +NOCLIP
        +NOGRAVITY
        +MISSILE
        +CLIENTSIDEONLY
        +NOINTERACTION
        +NOBLOCKMAP

    }

	states
	{
        Spawn:
            TNT1 A 0;
            TNT1 A 2;
            TNT1 AAAA 6 A_CustomMissile ("NuclearFlames", 0, 0, random (0, 360), 2, random (0, 90));
            TNT1 AAAA 6 A_CustomMissile ("NuclearFlamesBig", 0, 0, random (0, 360), 2, random (0, 90));
            TNT1 A 0 A_Stop;
            TNT1 AAAAAAAAAAAAAAA 6 A_CustomMissile ("NuclearFlamesBig", 0, 0, random (0, 360), 2, random (0, 90));
            TNT1 A 0 A_CustomMissile ("NukeSmoke", 0, 0, random (0, 360), 2, random (0, 90));
            TNT1 A 0 A_SpawnItemEx("NukeSmoke", random(-100, 100), random(-100, 100), random(-20, 20));
            TNT1 AAA 6 A_CustomMissile ("NuclearFlamesBig", 0, 0, random (0, 360), 2, random (0, 20));
            Stop;
	}
}


class NuclearFlames: ZS_ExplosionFlames
{
    Default
    {
        Scale 2.2;
        Speed 5;
        RenderStyle "Add";
    }
	States
	{
        Spawn:
            FLXP ABCDEFGHIJKLMNOPQRSTUVWXYZ 2 BRIGHT;
            Stop;
	}
}

class NuclearFlamesRepeat: ZS_ExplosionFlames
{
    Default
    {
        Scale 3.0;
        Speed 5;
        Renderstyle "None";
    }

	States
	{
        Spawn:
            TNT1 A 0;
            TNT1 AAAAAAAAAA 9 A_SpawnItemEx("NuclearFlames2", random(-50, 50), random(-50, 50), random(-50, 50), 0, 0, 0, 0, SXF_NOCHECKPOSITION);
            Stop;
	}
}

class NuclearFlames2: ZS_ExplosionFlames
{
    Default
    {
        Scale 3.5;
        Speed 5;
        RenderStyle "Add";
    }

    States
	{
        Spawn:
            FLXP ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 BRIGHT;
            Stop;
	}
}

class NuclearFlamesRepeat2: ZS_ExplosionFlames
{
    Default
    {
        Scale 3.0;
        Speed 5;
        Renderstyle "None";
    }

	States
	{
        Spawn:
            TNT1 A 0;
            TNT1 AAAAAAAAAA 9 A_SpawnItemEx("NuclearFlames3", random(-200, 200), random(-200, 200), random(-50, 50), 0, 0, 0, 0, SXF_NOCHECKPOSITION);
            Stop;
	}
}

class NuclearFlames3: ZS_ExplosionFlames
{
    Default
    {
        YScale 8.5;
        XScale 10.5;
        Speed 5;
        RenderStyle "Add";
    }

	States
	{
        Spawn:
            FLXP ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 BRIGHT;
            Stop;
	}
}

class NuclearFlamesImpact: ZS_ExplosionFlames
{
    Default
    {
        Scale 9.2;
        Speed 96;
        Damagetype "Nuke";
        RenderStyle "Add";
        Alpha 0.25;
        +FORCERADIUSDMG
        -CLIENTSIDEONLY
    }
    
	States
	{
        Spawn:
            FLXP ACFH 1 BRIGHT A_Explode(32, 256);
            FLXP ijklmNOPQRSTUVWXYZ 1 BRIGHT A_FadeOut(0.02);
            Stop;
	}
}

class NuclearFlamesBig: ZS_ExplosionFlames
{
    Default
    {
        Scale 9.2;
        Speed 3;
        RenderStyle "Add";
    }

	States
	{
        Spawn:
            FLXP ABCDEFGHIJKLMNOPQRSTUVWXYZ 4 BRIGHT;
            Stop;
	}
}

class NukeSmoke: ZS_HitpuffSmoke
{
    Default
    {
        Scale 6.0;
        Speed 1;
        Alpha 0.1;
        +SKYEXPLODE
        +FORCEXYBILLBOARD
    }
	States
	{
        Spawn:
            SMk2 CCCCCCCCCC 2 A_FadeIn(0.05);
            SMk2 C 600;

        Death:
            SMk2 CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC 20 A_FadeOut(0.02);
            Stop;
	}
}


class NukeSmokeBig: NukeSmoke
{
    Default
    {
        XScale 18.0;
        YScale 12.0;
    }
}

class ZS_ExplosionFlames : ZS_FlameTrails
{
    Default
    {
        Scale 1.0;
        Speed 2;
        RenderStyle "Add";
        BounceType "Doom";
    }
	States
	{
        Spawn:
            EXPL AA 3 BRIGHT A_SpawnItem("RedFlare",0,0);
            EXPL AA 0 A_CustomMissile ("ExplosionSmokeHD", 0, 0, random (0, 360), 2, random (0, 360));
            EXPL BCDEFGH 3 BRIGHT;
            Stop;
	}
}

class ZS_FlameTrails : actor
{
    Default
    {
        Radius 1;
        Height 1;
        Speed 3;
        RenderStyle "Add";
        Damagetype "fire";
        BounceType "Doom";
        Scale 0.5;
        Gravity 0;
        PROJECTILE;
        -NOGRAVITY
        +FORCEXYBILLBOARD
        +CLIENTSIDEONLY
        +THRUACTORS
    }

	States
	{
        Spawn:
            TNT1 A 2;
            FRPR ABCDEFGH 3 BRIGHT;
            Stop;
	}
}

class ExplosionSmokeHD: ZS_HitpuffSmoke
{
    Default
    {
        Scale 2.0;
        Speed 1;
    }

	States
	{
        Spawn:  
            TNT1 A 0;
            TNT1 A 0 A_Jump(128, 2);
            TNT1 A 0 A_SetScale(-2.5, 2.0);
            TNT1 A 0;
            SM9K ABCDEFGHIJKLMNOPQRSTUVWXYZ 2;
            Stop;
	}
}

class ZS_HitpuffSmoke : actor
{
    Default
    {
        Radius 1;
        Height 1;
        Scale 0.7;
        Speed 1;
        RenderStyle "Translucent";
        BounceType "Doom";
        Alpha 0.4;
        PROJECTILE;
        +CLIENTSIDEONLY
        +FORCEXYBILLBOARD
        +MISSILE
        +THRUACTORS
    }

	States
	{
        Spawn:  
            TNT1 A 0;
            TNT1 A 0 A_Jump(128, 2);
            TNT1 A 0 A_SetScale(-0.7, -0.7);
            TNT1 A 0;
            SMOK ABCDEFGHIJKLMNOPQ 1;
            Stop;
	}
}