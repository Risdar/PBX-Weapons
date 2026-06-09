class killhologram : inventory {default{inventory.maxamount 1;}}

Class BDPRailgunAmmo : PB_Ammo
{
	Default
	{
		inventory.amount 0;
		inventory.maxamount BDPRailgunFullAmmo;
		ammo.backpackamount 0;
		ammo.backpackmaxamount BDPRailgunFullAmmo;
	    Inventory.Icon "ARMZA0";
        +INVENTORY.IGNORESKILL;
	}
}

class BDP_GunLight : DynamicLight 
{
	default 
	{
		DynamicLight.Type "Point";
		+DYNAMICLIGHT.ATTENUATE;
		+DYNAMICLIGHT.SPOT
		self.alivetime 2;
	}

	int alivetime; 
	property alivetime : alivetime;

	override void Tick() 
	{
		super.Tick();
		alivetime--;
		If(alivetime <= 0) Destroy();
	}
}

class BluePlasmaParticleWeapon : actor
{
	Default
	{
		Height 0;
		Radius 0;
		Mass 0;
		+Missile;
		+NoBlockMap;
		-NoGravity;
		+DontSplash;
		BounceType "Doom";
		+FORCEXYBILLBOARD;
		RenderStyle "Add";
		BounceFactor 0.2;
		Gravity 0.8;
		Scale 0.02;
		Speed 9;
	}

	States
	{
		Spawn:
		Death:
			SPKB A 2 Bright A_FadeOut(0.04);
			Loop;
	}
}

class RailCaseSpawn : actor
{
	Default
	{
		Speed 20;
		PROJECTILE;
		+NOCLIP;
		+CLIENTSIDEONLY;
	}

	States
	{
		Spawn:
			TNT1 A 0;
			TNT1 A 1 A_CustomMissile("RailCasing",-9,20,random(-38,-48),2,random(10,20));
			Stop;
	}
} 

class RailCasing: BaseMagActor
{
	Default
	{
		Speed 7;
		BounceFactor 0.7;
		Scale 0.3;
	}
	States
	{
		Spawn:
			ECLI H 4;
		Spawn2:
			ECLI HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH 4 A_SetRoll(roll-45);
			LOOP;

		Death:
			"####" "#" 0;
			"####" "#" 0 A_Jump(128,"Die2");
			"####" "#" 0 A_SetRoll(-90);
			"####" "#" 0;
		StayDead:
			"####" "#" 350;
			Goto Fadeout;

		Die2:
			"####" "#" 0 A_SetRoll(90);
			"####" "#" 0 A_ChangeFlag("XFLIP",1);
			Goto staydead;
	}
}

class RailgunTrail : VisualThinker
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

class HoloTarget : FastProjectile
{ 
	Default
	{
		Decal "None";
		Mass 0;
		Scale 0.2;
		Radius 1;
		Height 2;
		+NOBLOCKMAP;
		+NOGRAVITY;
		+BLOODLESSIMPACT;
		+ALWAYSPUFF;
		+PUFFONACTORS;
		+DONTSPLASH;
		+FORCEXYBILLBOARD;
		Renderstyle "Add";
		Alpha 0.8;
	}
	Int HoloTimer;
	Override void tick()
	{
		Holotimer++;
		If ( holotimer >= 1000 )
		{
			Destroy();
		}
		Super.tick();
	}
	States
	{
	Spawn:
		TNT1 A 1;
		LOOP;
	}
}

class HoloPlayer : PB_Monster
{
	Default
	{
		Monster;
		-Solid;
		+notrigger;
		+noblockmonst;
		-Countkill;
		+NOBLOODDECALS;
		+BRIGHT;
		+FRIENDLY;
		Renderstyle "Translucent";
		Alpha 0.75;
		Radius 16;
		Height 42;
		Health 200;
		Maxstepheight 666;
		Mass 99999;
		BloodType "HoloBlood";
	}
	Override void tick()
	{
		If ( !tracer || findinventory("KillHologram") )
		{
			A_fadeout(0.05);
		}
		Super.tick();
	}
	Action void A_HoloGramAlert()
	{
		BlockThingsIterator CheckFortracers = BlockThingsIterator.create(Self,1000); //256 can be whatever range around the actor.
		Actor CurrentActor;
		While (CheckFortracers.Next())
		{
			CurrentActor = CheckFortracers.Thing;
						
			//If the actor is a monster, has none of the specified item, the caller has a line of sight to the actor, and the actor is within 512 MU, then jump to the see state.
			//Itemname obviously has to be whatever item you want the actor to check that the possible target has none of, and the 512 map unit sight range can be changed to anything else.
			If (CurrentActor && CurrentActor.bismonster && currentactor.health > 0 && !currentactor.bfriendly && CheckSight(CurrentActor,SF_IGNOREWATERBOUNDARY) && currentactor.target && currentactor.target is "playerpawn")
			{
				Currentactor.target = self;
			}
			
		}
		A_alertmonsters(0,AMF_TARGETEMITTER);
	}

	States
	{
	Spawn:
		MARN AAABBBCCCBBB 1 {
			A_facetracer();
			vector3 movepos = Vec3Angle(6,angle,0);
			If (checkmove(Vec2Angle(6,angle),PCM_NOACTORS))
			{
				setorigin(movepos,TRUE);
			}
			A_hologramAlert();
			If(tracer && distance2d(tracer) <= 32)
			{
				Return resolvestate("Spawn2");
			}
			
			Return resolvestate(null);
		}
		LOOP;
	Spawn2:
		TNT1 A 0 A_jump(30,"Twerk","TeaBag","Moves1","Moves2","Moves3","TPose");
		TNT1 A 0 A_jump(255,"Wave1","Wave2","Observe","Medkit");
	Wave1:
		MWAV IJK 1;
	Wave1Continue:
		MWAV LMNNML 3 A_hologramAlert();
		LOOP;
	Wave2:
		MWAV ABCD 3;
	Wave2Continue:
		MWAV EEEEEEEFFFFFFF 1 A_HoloGramAlert();
		LOOP;
	Observe:
		MR7S AAAAABBBBBACCCCCABBBBBAA 4 A_hologramalert();
		LOOP;
	MedKit:
		MR8S AAAAAAABBBBBBB 2 A_HoloGramAlert();
		LOOP;
	TeaBag:
		MARN AA 2 A_hologramalert();
		PLYC AA 2 A_hologramalert();
		LOOP;
	Twerk:
		TWRK CBA 2 A_hologramAlert();
		LOOP;
	Moves1:
		2AKE ABCDEFGHIJKLMOPQR 4 A_hologramAlert();
		LOOP;
	Moves2:
		3AKE ABCDEFGHIJKLMNO 4 A_hologramAlert();
		LOOP;
	Moves3:
		JAKE ABCDEFGHIJKLMNOP 4 A_hologramAlert();
		LOOP;
	TPose:
		TWRK D 4 A_hologramAlert();
		LOOP;
		
	Death:
		PLAY O 5;
		PLAY P 5 A_XScream();
		PLAY Q 5;
		PLAY RSTUV 5;
	
	Death2:
		PLAY W 1 A_fadeout(0.05);
		LOOP;
	}
}

class HoloBlood : Actor
{
	Default
	{
		+nogravity;
		+noblockmap;
	}
	States
	{
		Spawn:
			TNT1 AAA 0 NODELAY
			{
				A_spawnitemex("blueplasmaparticle",0,0,0,frandom(-5,5),frandom(-5,5),frandom(1,5));
				A_startsound("StickyGrenade/hit");
			}
			STOP;
	}
}

class RailgunProjectile : Actor
{
	int user_railangle;
	Default
	{
		Radius 2;
		Height 2;
		Speed 80;
		DamageFactor 0;
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