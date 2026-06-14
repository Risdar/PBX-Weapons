class BR_Select_FireMode : inventory {default{inventory.maxamount 1;}}
class BR_Select_Zoom : inventory {default{inventory.maxamount 1;}}
class BR_Select_Laser : inventory {default{inventory.maxamount 1;}}
class BattleRifle_Upgraded : inventory {default{inventory.maxamount 1;}}

class BR_Ammo : Ammo
{
    Default
    {
        Inventory.Amount 0;
        Inventory.MaxAmount PBX_BDPBattleRifle.MAGAZINE_SIZE;
        Ammo.BackpackAmount 0;
        Ammo.BackpackMaxAmount PBX_BDPBattleRifle.MAGAZINE_SIZE;
        Inventory.Icon "AUSCA0";
        +INVENTORY.IGNORESKILL;
    }
}

class BattleRifle_Upgrade : PB_UpgradeItem
{
	Default
	{
		//$Title Battle Rifle Upgrade
		//$Category Project Brutality - Weapon Upgrades
		//Game Doom;
		//SpawnID
		Height 32;
		//-COUNTITEM
		-INVENTORY.ALWAYSPICKUP;
		-COUNTITEM;
		Inventory.Pickupsound "CLIPIN";
		Inventory.PickupMessage "$PBX_BattleRifle_UpgradePickup";
		Tag "$PBX_BattleRifle_UpgradeTag";
		Scale 1.0;
		FloatBobStrength 0.5;
	}

	States
	{
	Spawn:
		BRXU A -1;
		Stop;

	Pickup:
		TNT1 A 0 A_JumpIf(!FindInventory("PBX_BDPBattleRifle") || !FindInventory("BattleRifle_Upgraded") || CountInv("PB_HighCalMag") < GetAmmoCapacity("PB_HighCalMag"),1);
		fail;
		TNT1 A 0 {
			A_SetInventory("BattleRifle_Upgraded", 1);
			A_GiveInventory("PBX_BDPBattleRifle", 1);
			A_SetWeaponTag("PBX_BDPBattleRifle","$PBX_BattleRifle_Tag");
            A_GiveInventory("PB_HighCalMag", 30);
		}
		Stop;
	}
}

class DecorativeTracer: FastProjectile
{
	default
	{
		-DONTSPLASH;
		Projectile;
		+RANDOMIZE;
		+FORCEXYBILLBOARD;
		+DONTSPLASH;
		//+BLOODSPLATTER 
		+NOEXTREMEDEATH;
		damage 0;
		radius 2;
		height 2;
		speed 140;
		renderstyle "ADD";
		alpha 0.9;
		scale .15;
	}

	states
	{
		Spawn:
			TNT1 A 0 A_JumpIf(GetCvar("PB_TracerLight") >=1,"Spawn2");
		Spawn1:
			TRAC A 1 BRIGHT;
			Loop;
		Spawn2:
			TRAC A 1 BRIGHT Light("TracerLight");
			Loop;
		Death:
			TNT1 A 0;
			Stop;
		XDeath:
			TNT1 A 0;
			Stop;
	}
}

class BR45BulletPuff: PB_BulletPuff
{
	default
	{
		DamageType "Pistol";
		renderstyle "Translucent";
		alpha 0.4;
		Scale 1.5;
		radius 0;
		height 0;
		+NOBLOCKMAP;
		+NOGRAVITY;
		Gravity 0.01;
		+NOEXTREMEDEATH;
		+FORCEXYBILLBOARD;
		+THRUACTORS;
		+NOCLIP;
		Decal "BulletDecalNew1";
		+DONTSPLASH;
		-EXPLODEONWATER;
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
		bouncetype "Doom";
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
