class ProsurvBlasterProjectile : PB_ProjectileAlt
{
    Default
    {
        
        +BLOODSPLATTER ;
        -DONTSPLASH;
        speed 200;
        PB_Projectile.BaseDamage 5;
		PB_Projectile.RipperCount 1;
		PB_Projectile.PenetrationCount 1;
        // damage 3;
        scale 0.3;
        RenderStyle "Add";
        Alpha 0.2;
        radius 2;
        height 2;
        damagetype "Plasma";
        Decal "BulletPuff";
    }

    States
    {
        Spawn:
            TNT1 A 1 BRIGHT A_SpawnItemEx("ProsurvBlasterTracerTrail", 0,               0,              2);
            TNT1 A 0 A_SpawnItemEx("ProsurvBlasterplasmaTracerTrail2", (2 *Vel.X)/-35.0, -(2 *Vel.Y)/-35.0, 2+(2 *Vel.Z)/-35.0, 0,0,0, 0, SXF_ABSOLUTEANGLE);
            TNT1 A 0 A_SpawnItemEx("ProsurvBlasterplasmaTracerTrail3", (4 *Vel.X)/-35.0, -(4 *Vel.Y)/-35.0, 2+(4 *Vel.Z)/-35.0, 0,0,0, 0, SXF_ABSOLUTEANGLE);
            TNT1 A 0 A_SpawnItemEx("ProsurvBlasterplasmaTracerTrail4", (6 *Vel.X)/-35.0, -(6 *Vel.Y)/-35.0, 2+(6 *Vel.Z)/-35.0, 0,0,0, 0, SXF_ABSOLUTEANGLE);
            TNT1 A 0 A_SpawnItemEx("ProsurvBlasterplasmaTracerTrail5", (8 *Vel.X)/-35.0, -(8 *Vel.Y)/-35.0, 2+(8 *Vel.Z)/-35.0, 0,0,0, 0, SXF_ABSOLUTEANGLE);
            TNT1 A 0 A_SpawnItemEx("ProsurvBlasterplasmaTracerTrail6", (10*Vel.X)/-35.0, -(10*Vel.Y)/-35.0, 2+(10*Vel.Z)/-35.0, 0,0,0, 0, SXF_ABSOLUTEANGLE);
            TNT1 A 0 A_SpawnItemEx("ProsurvBlasterplasmaTracerTrail7", (12*Vel.X)/-35.0, -(12*Vel.Y)/-35.0, 2+(12*Vel.Z)/-35.0, 0,0,0, 0, SXF_ABSOLUTEANGLE);
            TNT1 A 0 A_SpawnItemEx("ProsurvBlasterplasmaTracerTrail8", (14*Vel.X)/-35.0, -(14*Vel.Y)/-35.0, 2+(14*Vel.Z)/-35.0, 0,0,0, 0, SXF_ABSOLUTEANGLE);
            TNT1 A 0 A_SpawnItemEx("ProsurvBlasterplasmaTracerTrail9", (16*Vel.X)/-35.0, -(16*Vel.Y)/-35.0, 2+(16*Vel.Z)/-35.0, 0,0,0, 0, SXF_ABSOLUTEANGLE);
            TNT1 A 0 A_SpawnItemEx("ProsurvBlasterplasmaTracerTrail10", (18*Vel.X)/-35.0, -(18*Vel.Y)/-35.0, 2+(18*Vel.Z)/-35.0, 0,0,0, 0, SXF_ABSOLUTEANGLE);
            TNT1 A 0 A_SpawnItemEx("ProsurvBlasterplasmaTracerTrail11", (20*Vel.X)/-35.0, -(20*Vel.Y)/-35.0, 2+(20*Vel.Z)/-35.0, 0,0,0, 0, SXF_ABSOLUTEANGLE);
            TNT1 A 0 A_SpawnItemEx("ProsurvBlasterplasmaTracerTrail12", (22*Vel.X)/-35.0, -(22*Vel.Y)/-35.0, 2+(22*Vel.Z)/-35.0, 0,0,0, 0, SXF_ABSOLUTEANGLE);
            Loop;

        Death:
            TNT1 AAAAA 0 A_SpawnItem("BlueFlareSmall");
            TNT1 AAAAA 0 A_CustomMissile ("BluePlasmaParticle", 0, 0, random (0, 360), 2, random (0, 360));
            TNT1 B 1 A_Explode(2,50,1);
            BL1I ABCD 1 BRIGHT A_SpawnItem("BlueFlareSmall");
            TNT2 AA 3 A_CustomMissile ("PlasmaSmoke", 1, 0, random (0, 360), 2, random (0, 160));
            Stop;
    }
}

Class BlasterPistolCharge : PB_Ammo
{
	Default
	{
		inventory.amount 0;
		inventory.maxamount PBX_ProsurvBlaster.MAXCHARGE;
		ammo.backpackamount 0;
		ammo.backpackmaxamount PBX_ProsurvBlaster.MAXCHARGE;
	    Inventory.Icon "ARMZA0";
        +INVENTORY.IGNORESKILL;
	}
}

class ProsurvBlasterTracerTrail : actor
{
    Default
    {
        Scale 0.04;
        RenderStyle "Add";
        Alpha 0.9;
        +NOINTERACTION;
        +CLIENTSIDEONLY;
    }

    States
    {
        Spawn:
            SPKB A 2 BRIGHT;
            stop;
    }
}

class ProsurvBlasterplasmaTracerTrail2: ProsurvBlasterTracerTrail {    Default{Alpha 0.85;} }
class ProsurvBlasterplasmaTracerTrail3: ProsurvBlasterTracerTrail {    Default{Alpha 0.80;} }
class ProsurvBlasterplasmaTracerTrail4: ProsurvBlasterTracerTrail {    Default{Alpha 0.75;} }
class ProsurvBlasterplasmaTracerTrail5: ProsurvBlasterTracerTrail {    Default{Alpha 0.70;} }
class ProsurvBlasterplasmaTracerTrail6: ProsurvBlasterTracerTrail {    Default{Alpha 0.65;} }
class ProsurvBlasterplasmaTracerTrail7: ProsurvBlasterTracerTrail {    Default{Alpha 0.60;} }
class ProsurvBlasterplasmaTracerTrail8: ProsurvBlasterTracerTrail {    Default{Alpha 0.55;} }
class ProsurvBlasterplasmaTracerTrail9: ProsurvBlasterTracerTrail {    Default{Alpha 0.50;} }
class ProsurvBlasterplasmaTracerTrail10: ProsurvBlasterTracerTrail {    Default{Alpha 0.45;} }
class ProsurvBlasterplasmaTracerTrail11: ProsurvBlasterTracerTrail {    Default{Alpha 0.40;} }
class ProsurvBlasterplasmaTracerTrail12: ProsurvBlasterTracerTrail {    Default{Alpha 0.35;} }
class ProsurvBlasterplasmaTracerTrail13: ProsurvBlasterTracerTrail {    Default{Alpha 0.30;} }
class ProsurvBlasterplasmaTracerTrail14: ProsurvBlasterTracerTrail {    Default{Alpha 0.25;} }
class ProsurvBlasterplasmaTracerTrail15: ProsurvBlasterTracerTrail {    Default{Alpha 0.20;} }
class ProsurvBlasterplasmaTracerTrail16: ProsurvBlasterTracerTrail {    Default{Alpha 0.15;} }
class ProsurvBlasterplasmaTracerTrail17: ProsurvBlasterTracerTrail {    Default{Alpha 0.10;} }
class ProsurvBlasterplasmaTracerTrail18: ProsurvBlasterTracerTrail {    Default{Alpha 0.05;} }