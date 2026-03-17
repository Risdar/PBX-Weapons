
class CyberBallsPlayer : actor
{
    Default
    {
        Projectile;
        Radius 10;
        Height 8;
        Speed 90;
        Damage 180;
        DamageType "Explosive";
        Gravity 0.00;
        Decal "Scorch";
        RenderStyle "Add";
        // +MISSILE;
        -NOGRAVITY
        +EXTREMEDEATH
        +BLOODSPLATTER 
        +THRUSPECIES
        +MTHRUSPECIES
        +RANDOMIZE
        Species "Marines";
        Scale 1.7;
        SeeSound "DSCANFIR";
        DeathSound "Explosion";
        Obituary "%o was blown up by %k's Cyberdemon missile launcher. Ouch!";
    }
    States
	{
        Spawn:
            TNT1 A 0;
            
        Spawn1:
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
            // TNT1 A 0 A_CustomMissile ("BUBULZ", 0, 0, random (0, 360), 2, random (0, 180));
            Goto Spawn1;
            
        Death:
            EXPL A 1 A_Explode(80,200);
            EXPL A 0 Radius_Quake (2, 8, 0, 15, 0);
            TNT1 A 0; //A_AlertMonsters;
            TNT1 A 0 A_SpawnItemEx ("DetectFloorCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
            TNT1 A 0 A_SpawnItemEx ("DetectCeilCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
            // TNT1 A 0 A_SpawnItemEx ("UnderwaterExplosion",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
            TNT1 A 0 A_SpawnItemEx ("ExplosionFlareSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
            TNT1 A 0 A_SpawnItemEx ("RocketExplosion",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
            TNT1 AAA 0 A_CustomMissile ("ExplosionParticleHeavy", 0, 0, random (0, 360), 2, random (0, 180));
            TNT1 AAAAAAAAAAAAAAAAAA 0 A_CustomMissile ("ExplosionParticleHeavy", 0, 0, random (0, 360), 2, random (0, 360));
            TNT1 AAAAAAAAA 0 A_CustomMissile ("ExplosionParticleVeryFast", 0, 0, random (0, 360), 2, random (0, 360));
            TNT1 AAAAAAA 0 A_CustomMissile ("MediumExplosionFlames", 0, 0, random (0, 360), 2, random (0, 360));
            TNT1 A 1;
            TNT1 A 0 A_PlaySound("FAREXPL", 3);
            //TNT1 A 3 A_CustomMissile ("HeavyExplosionSmoke", 2, 0, random (0, 360), 2, random (0, 360))
            Stop;
	}
}