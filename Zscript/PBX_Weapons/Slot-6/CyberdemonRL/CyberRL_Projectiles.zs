class CRL_NormalRockets : PB_ProjectileAlt
{
    Default
    {
		PB_Projectile.BaseDamage 350;
		+PB_PROJECTILE.NOCRITICALS
        DamageType "ExplosiveImpact";
        Decal "Scorch";
        RenderStyle "Add";
        Radius 10;
        Height 8;
        Speed 90;
        gravity 0;
        // +MISSILE;
        Projectile;
        -RIPPER
        +EXTREMEDEATH
        +BLOODSPLATTER 
        +THRUSPECIES
        +MTHRUSPECIES
        +RANDOMIZE
        Species "Marines";
        Scale 2.0;
        SeeSound "DSCANFIR";
        DeathSound "Explosion";
        Obituary "%o was blown up by %k's Cyberdemon missile launcher. Ouch!";
    }

    States
	{
        Spawn:
            TNT1 A 0 A_JumpIf(waterlevel > 1, "SpawnUnderwater");
            WYVB A 1 Bright A_SpawnItem("RedFlareSmall22",0,0);
            TNT1 A 0 A_CustomMissile ("OldschoolRocketSmokeTrail2", 2, 0, random (160, 210), 2, random (-30, 30));
            TNT1 A 0 A_JumpIfInventory("lowgraphicsmode", 1, "SpawnCheap");
            Loop;
            
        SpawnCheap:
            TNT1 A 0;
            WYVB A 1 Bright A_SpawnItem("RedFlareSmall22",0,0);
            Loop;
        
        SpawnUnderwater:
            WYVB A 1 Bright A_SpawnItem("YellowFlareSmall",0,0);
            Goto Spawn1;
           
        Crash:
		XDeath:
		Death:
			TNT1 A 0 {
				A_Stop();
				bNOINTERACTION = true;
				bNOGRAVITY = true;
			}
			TNT1 A 0;
			TNT1 A 0
			{
				A_Explode((80), 200);
				A_StopSound(105);
				A_StartSound("FAREXPL", CHAN_AUTO,CHANF_OVERLAP,0.5,0,1.1);
				Radius_Quake (2, 4, 0, 7, 0);
				A_SpawnItemEx ("DetectFloorCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
				A_SpawnItemEx ("DetectCeilCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
				A_SpawnItemEx ("ExplosionFlareSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
				A_SpawnItemEx ("LiquidExplosionEffectSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
				A_SpawnProjectile ("ExplosionSmokeFast22", 0, 0, random (0, 360), 2, random (0, 360));
				A_SpawnProjectile ("MediumExplosionFlames", 0, 0, random (0, 360), 2, random (0, 360));
				A_SpawnProjectile ("PBExplosionparticles", 0, 0, random (0, 360), 2, random (40, 90));
				A_SpawnProjectile ("PBExplosionparticles2", 0, 0, random (0, 360), 2, random (40, 90));
				A_SpawnProjectile ("PBExplosionparticles3", 10, 0, random (0, 360), 2, random (40, 90));
			}
			TNT1 A 0 A_Jump(256, "Spawn1", "Spawn2", "Spawn3");
		Spawn1:
			X004 ABCDE 1 bright Light("EXPLOSIONFLASH");
			X004 FGHIJKLMNOPQ 1 bright;
			stop;
		Spawn2:
			X003 ABCDE 1 bright Light("EXPLOSIONFLASH");
			X003 FGHIJKLMNOPQRSTUVWXYZ 1 bright;
			stop;
		Spawn3:
			X125 ABCDE 1 bright Light("EXPLOSIONFLASH");
			X125 FGHIJKLMNOPQR 1 bright;
			Stop;
	}
}

class CRL_PiercingRockets : CRL_NormalRockets
{
    Default
    {
        +RIPPER
		PB_Projectile.BaseDamage 250;
		PB_Projectile.RipperCount 12;
        PB_Projectile.PenetrationCount 5;
        Scale 1.0;
    }
}