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

