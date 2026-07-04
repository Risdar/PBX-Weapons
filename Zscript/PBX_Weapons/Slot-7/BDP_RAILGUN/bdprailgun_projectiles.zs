class RailgunProjectile : PB_JavelinProjectile_Hot
{
	int user_railangle;
	Default
	{
		Radius 2;
		Height 2;
		Speed 80;
		// DamageFactor 0;
		DamageType 'Railgun';
		Projectile;
		+RANDOMIZE
		+MISSILE
		+FORCERADIUSDMG
		+THRUACTORS
		Species "Marines";
		Scale 1.0;
		
		renderstyle 'ADD';
		alpha 0.90;
		Scale 0.10;
		DeathSound "weapons/plasmax";
		SeeSound "None";
		Obituary "$OB_MPPLASMARIFLE";
		BounceCount 3;
	}
	States
	{
	DM:
		RAIL A 0;
		RAIL A 0 A_ChangeFLag("THRUSPECIES", 0);
		RAIL A 0 A_ChangeFLag("MTHRUSPECIES", 0);
		Goto Spawn1;
	Spawn:
		TNT1 A 0;
		RAIL A 0 A_FaceTarget;
		RAIL A 0 {user_railangle = angle;}
		RAIL A 0 A_SpawnItem("WhiteShockwave");
		// RAIL A 0 ACS_NamedExecuteAlways("CheckIfDM", 0, 0, 0, 0);//Check if Coop
		TNT1 C 1 BRIGHT A_SpawnItem("WhiteShockwave");
	Spawn1:
		TNT1 C 1 BRIGHT A_SpawnItem("WhiteShockwave");
		RAIL A 0 A_SpawnItem("WhiteShockwave");
		RAIL A 0 A_CheckFloor("Death");
		RAIL A 0 A_CustomMissile ("OldschoolRocketSmokeTrail2", 2, 0, random (160, 210), 2, random (-30, 30));
		Loop;
	Death:
	Melee:
	Xdeath:
		TNT1 AAAA 0 A_SpawnItemEx("BluePlasmaParticleSpawner", 0, 0, 0, 0, 0, 0, 0, 128);
		TNT1 AA 0 A_SpawnItem("WhiteShockwave");
		TNT1 AAAAAAAAA 0 A_CustomMissile ("ExplosionParticleHeavy", 0, 0, random (0, 360), 2, random (0, 180));
		TNT1 AAAAAAAAAAAAAAAAAA 0 A_CustomMissile ("ExplosionParticleHeavy", 0, 0, random (0, 360), 2, random (0, 360));
		TNT1 AAAAAAAAA 0 A_CustomMissile ("ExplosionParticleVeryFast", 0, 0, random (0, 360), 2, random (0, 360));
		EXPL AAAAA 0 A_CustomMissile ("ExplosionSmokeFast22", 0, 0, random (0, 360), 2, random (0, 360));
		TNT1 AAAA 0 A_CustomMissile ("FireworkSFXType2", 2, 0, random (0, 360), 2, random (10, 80));
		RAIL A 0 A_SpawnItemEx ("DetectFloorCraterSmall",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
		RAIL A 0 A_SpawnItemEx ("DetectCeilCraterSmall",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
		RAIL A 0 A_CustomMissile ("BluePlasmaFire", 0, 0, random (0, 360), 2, random (0, 360));
		TNT1 AAAAA 0 A_CustomMissile ("BluePlasmaParticle", 0, 0, random (0, 360), 2, random (0, 360));
		TNT1 ABE 0 BRIGHT A_SpawnItem("BlueFlare" ,0);
		Death:
	Melee:
	Xdeath:
		Stop;
		Stop;
	}
}


class NailgunGib1 : Actor
{
	Default
	{
		Projectile;
		Gravity 1;
		damage 0;
		BounceType "Doom";
		BounceFactor 0.6;
		WallBounceFactor 0.6;
		Radius 4;
		Height 4;
		Speed 6;
		scale 0.6;
		SeeSound "NAILBOUN";
		BounceSound "NAILBOUN";
		+FORCEXYBILLBOARD
		-NOGRAVITY
		+BOUNCEONACTORS
		+ROLLSPRITE
		+ROLLCENTER
	}

	int lifetime;
	
	override void PostBeginPlay()
	{
		lifetime = 140;
		super.PostBeginPlay();
	}

	States
	{
	Spawn:
		NAIL B 1 {
			A_SetRoll(roll + 6, SPF_INTERPOLATE);
			lifetime--;
			if(lifetime <= 0) return resolvestate("Death");
			else return resolvestate(null);
		}
		Loop;
	Death:
		NAIL B 70;
		NAIL BBBBBBBBBBBBBBBBBBBB 1 A_FadeOut(0.05);
		stop;
	Bounce:
		TNT1 A 0;
		Goto Spawn;
	}
}

class NailgunGib2 : NailgunGib1
{
	Default
	{
		Speed 4;
	}

	States
	{
		Spawn:
			NAIL C 1 {
				A_SetRoll(roll + 6, SPF_INTERPOLATE);
				lifetime--;
				if(lifetime <= 0) return resolvestate("Death");
				else return resolvestate(null);
			}
		Death:
			NAIL C 70;
			NAIL CCCCCCCCCCCCCCCCCCCC 1 A_FadeOut(0.05);
			stop;
	}
}

class NailgunGib3: NailgunGib1
{
	Default
	{
		Speed 7;
	}

	States
	{
		Spawn:
			NAIL D 1 {
				A_SetRoll(roll + 6, SPF_INTERPOLATE);
				lifetime--;
				if(lifetime <= 0) return resolvestate("Death");
				else return resolvestate(null);
			}
		Death:
			NAIL D 70;
			NAIL DDDDDDDDDDDDDDDDDDDD 1 A_FadeOut(0.05);
			stop;
	}
}

class BDP_RailgunTrail : VisualThinker
{
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		texture = TexMan.CheckForTexture('SPKOB0');
		scale = (0.3,0.3);
		alpha = 1.0;
		flags = SPF_FULLBRIGHT;
		SetRenderStyle(STYLE_Add);
	}
	
	override void Tick()
	{
		scale -= (0.01,0.01);
		Super.Tick();
		if(scale.x <= 0)
		{
			Destroy();
		}
	}
}

CLASS RailgunRail : Actor
{
	Default
	{
		Radius 1; 
		Height 1;
		+nogravity;
		+noclip;
	}

	States
	{
		Spawn:
			TNT1 AAA 0 A_SpawnItemEX("WhiteShockwave");
			TNT1 AAAA 0 A_spawnprojectile ("FireworkSFXType2", 2, 0, random (0, 360), 2, random (-10, -80));
			RAIL A 0 A_SpawnItemEx ("DetectFloorCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			RAIL A 0 A_SpawnItemEx ("DetectCeilCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			//RAIL A 0 A_spawnprojectile ("BluePlasmaFire", 0, 0, random (0, 360), 2, random (0, 360));
			TNT1 AAAAAAAAAA 0 A_spawnprojectile ("ExplosionParticleVeryFast", 0, 0, random (0, 360), 2, random (0, 360));
			TNT1 AAAAAAAA 0 A_spawnprojectile ("ExplosionParticleHeavy", 5, 0, random (0, 360), 2, random (0, -180));
			TNT1 AAAAAAAAAA 0 A_spawnprojectile ("ExplosionParticleHeavy", 5, 0, random (0, 360), 2, random (0, 360));
			TNT1 AAAAAAAAA 0 A_spawnprojectile ("ExplosionParticleVeryFast", 5, 0, random (0, 360), 2, random (0, 360));
			MODL A 1 BRIGHT{
				Radius_Quake(3, 8, 0, 15, 0);
				A_startsound("BONECRACK",1);
				A_startsound("RICMET",2);
				A_spraydecal("RailLightning",36);
				Actor Core = spawn("railgunrail2",pos);
				core.angle = angle;
				core.pitch = pitch;
			}
			MODL A 35 BRIGHT;
		TimeToFade:
			MODL A 1 BRIGHT {
				A_fadeout(0.01);
			}
			LOOP;
	}
}

CLASS RailgunRail2 : Actor
{
	Default
	{
		Radius 1; 
		Height 1;
		+nogravity;
		+noclip;
	}

	States
	{
		Spawn:
			MODL A 225 NODELAY;
		Death:
			TNT1 AAAAAAAA 0 {
			A_startsound("BONECRACK",1);
			// A_spawnitemex("Nailgungib1",frandom(-1,1),frandom(-3,-20),frandom(-1,1),frandom(-7,-3),frandom(-1,1),frandom(-10,10));
			// A_spawnitemex("Nailgungib2",frandom(-1,1),frandom(-3,-20),frandom(-1,1),frandom(-7,-3),frandom(-1,1),frandom(-10,10));
			// A_spawnitemex("Nailgungib3",frandom(-1,1),frandom(-3,-20),frandom(-1,1),frandom(-7,-3),frandom(-1,1),frandom(-10,10));
			}
			Stop;
			
	}
}