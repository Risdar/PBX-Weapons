class BR_Ammo : PB_Ammo
{
	Default
	{
		inventory.maxamount BR_AmmoFull;
	}
}

class RifleClipSpawn : actor
{
	Default
	{
		Speed 18;
		PROJECTILE;
		+NOCLIP;
		+CLIENTSIDEONLY;
	}
	States
	{
		Spawn:
			TNT1 A 0;
			//TNT1 A 1 A_CustomMissile("EmptyBrass",1,0,random(-80,-100),2,random(45,80))
			//TNT1 A 1 A_CustomMissile("EmptyBrass",1,0,random(-85,-95),2,random(25,40))
			TNT1 A 1 A_CustomMissile("EmptyRifleClip",6,-3,random(-80,-100),2,random(20,45));
			Stop;
	}
}

class EmptyRifleClip: BaseMagActor
{
	Default
	{
		BounceFactor 0.6;
		Scale 0.2;
		SeeSound "null";
		DeathSound "BR45BOUNCE";
		BounceSound "BR45BOUNCE";
		WallBounceSound "BR45BOUNCE";
		-doombounce;
		bouncetype "doom";
		+thruactors;
	}
   States
   {
	Spawn:
		//TNT1 A 7 A_PlaySound("NULL")
		TNT1 A 0;
		TNT1 A 0 A_playsound("BR45PING");
		ECLI I 4 ;
		ECLI IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII 4 A_SetRoll(roll+45,SPF_INTERPOLATE);
		Stop;
	Death:
		TNT1 A 0;
		TNT1 A 0 A_Jump(128,2);
		TNT1 A 0 A_ChangeFlag("XFLIP",1);
		TNT1 A 0;
		TNT1 A 0;
		TNT1 A 0 A_SetRoll(0);
		C4S3 I 0
		{
				bnointeraction = true;
				A_changelinkflags(true);
		}
		
		stay1:
		ECLI J 400;
		Goto Fadeout;
	}
}

class BaseMagActor : actor
{
	Default
	{
		+DOOMBOUNCE;
		- NOGRAVITY;
		+WINDTHRUST;
		+CLIENTSIDEONLY;
		+MOVEWITHSECTOR;
		+MISSILE;
		+NOBLOCKMAP;
		-DROPOFF;
		+NOTELEPORT;
		+FORCEXYBILLBOARD;
		+NOTDMATCH;
		+GHOST;
		+ROLLSPRITE;
		+ROLLCENTER;
		Height 2;
		Radius 2;
		Speed 4;
		Mass 1;
		SeeSound "weapons/largemagdrop";
		DeathSound "weapons/largemagdrop";
		BounceSound "weapons/largemagdrop";
	}

	States
	{
		Spawn:
			TNT1 A 0;
			stop;
		Death:
			"####" "#" 0;
			"####" "#" 0 A_SetRoll(0);
			"####" "#" 350;
		Fadeout:
		"####" "#" 1 A_fadeout(0.02);
		LOOP;
	}
}
