Class UnmakerLaser64Trail : UNMK_DExtActor{
	Default{
	Scale 0.1;
	+NOCLIP
	+NOGRAVITY
	+THRUGHOST
	}
	States{
	Spawn:
	LENR A 1 A_FadeOut(0.02);
	Loop;
	}
}
Class Unmaker64Puff: BulletPuff{
	Default{
	alpha 1;
	Scale 0.5;
	RenderStyle "Add";
	+NOBLOCKMAP
	+NOGRAVITY
	+NOEXTREMEDEATH
	+FORCEXYBILLBOARD
	+NOBLOOD
	+PUFFONACTORS
	+EXTREMEDEATH
	+ALWAYSPUFF
	-NOEXTREMEDEATH
	+ROLLSPRITE
	+ROLLCENTER
	+BRIGHT
	//+NOINTERACTION
	Decal "UnmakerBeamScorch";
	}
	int flipRoll;
	override void BeginPlay(){
		flipRoll = randompick(-1,1);
		if(random(0,1)){bXFLIP = true;}
		if(random(0,1)){bYFLIP = true;}
		A_Stop();
		super.BeginPlay();
	}
	override void tick(){
		super.tick();
		if(GetAge() >= 1){
			A_SetRoll(roll+(15 * flipRoll ) );
			if(scale.x - 0.08 > 0 && scale.y - 0.08 > 0){
				scale.x -= 0.08;scale.y -= 0.08;
			}
		}
	}
	States{
	Spawn:
	TNT1 A 0 NODELAY {
	}
	TNT1 A 0 A_Jump(256, "Decal1", "Decal2");
	
	Melee:
	TNT1 A 0 A_Jump(256, "Decal1", "Decal2");
	
	Decal1:
	UNPF AB 3 ;
	Stop;
	
	Decal2:
	UNPF CDE 2 ;
	Stop;
	}
}
Class UnmakerLaser64Spark : Actor{
	Default{
	RenderStyle "Add";
	Scale 0.0125;
	Alpha 0.95;
	+NOINTERACTION
	+NOGRAVITY
	+FORCERADIUSDMG
	}
	States{
	Spawn:
	YHE5 A 0 NoDelay A_JumpIf(ScaleX <= 0, "NULL");
	YHE5 A 0 A_SetScale(ScaleX-0.00075);
	YHE5 A 0 A_ChangeVelocity (frandom(-0.03, 0.03), frandom(-0.03, 0.03), frandom(-0.03, 0.03), 0);
	YHE5 A 1 A_FadeOut(0.05);
	Loop;
	}
}
/*
Class UNMK_StormSpray1 : Actor{
	Default{
	Radius 1;
	Height 1;
	Speed 200;
	PROJECTILE;
	Renderstyle "Add";
	Alpha 0.80;
	Damagetype "Incinerate";//"Lightning"
	DeathSound "weapons/devexp";
	+THRUGHOST
	+PIERCEARMOR
	+MTHRUSPECIES
	+THRUSPECIES
	Species "Marines";
	}
	States{
	Spawn:
		TNT1 A 1 A_BFGSpray("UNMK_StormZapper1",180,1,180,268435456,180,0);
		Goto Death;
	Death:
		TNT1 A 1 A_BFGSpray("UNMK_StormZapper1",180,1,180,268435456,180,0,BFGF_MISSILEORIGIN);
		stop;
	}
}
Class UNMK_StormSpray2 : UNMK_StormSpray1{
	States{
	Spawn:
		TNT1 A 1 A_BFGSpray("UNMK_StormZapper2",360,2,180,268435456);
		Goto Death;
	Death:
		TNT1 A 1 A_BFGSpray("UNMK_StormZapper2",360,2,180,268435456);
		stop;
	}
}
*/
Class UNMK_StormSpray : Actor{
	Default{
	Radius 1;
	Height 1;
	Speed 0;
	PROJECTILE;
	Renderstyle "Add";
	Alpha 0.80;
	Damagetype "Incinerate";//"Lightning"
	+THRUGHOST
	+PIERCEARMOR
	DeathSound "weapons/devexp";
	+MTHRUSPECIES
	+THRUSPECIES
	+FORCERADIUSDMG
	Species "Marines";
	}
	void A_UNMKSpray(class<Actor> spraytype = "BFGExtra", int numrays = 40, int damagecnt = 15, double ang = 90, double distance = 16*64, double vrange = 32, int defdamage = 0, int flags = 0)
	{
		int damage;
		FTranslatedLineTarget t;
		array < Actor > bfgtargets;
		// validate parameters
		if (spraytype == null) spraytype = "BFGExtra";
		if (numrays <= 0) numrays = 40;
		if (damagecnt <= 0) damagecnt = 15;
		if (ang == 0) ang = 90.;
		if (distance <= 0) distance = 16 * 64;
		if (vrange == 0) vrange = 32.;

		// [RH] Don't crash if no target
		if (!target) return;

		// [XA] Set the originator of the rays to the projectile (self) if
		//      the new flag is set, else set it to the player (target)
		Actor originator = (flags & BFGF_MISSILEORIGIN) ? Actor(self) : target;
		// offset angles from its attack ang
		for (int i = 0; i < numrays; i++){
			double an = angle - ang / 2 + ang / numrays*i;

			originator.AimLineAttack(an, distance, t, vrange);
			if (t.linetarget != null){//if (t.linetarget != null && bfgtargets.Find(t.linetarget) == bfgtargets.Size()) 
				//bfgtargets.Push(t.linetarget);
				Actor spray = Spawn(spraytype, t.linetarget.pos + (0, 0, t.linetarget.Height / 4), ALLOW_REPLACE);

				int dmgFlags = 0;
				Name dmgType = 'BFGSplash';

				if (spray != null)
				{
					if ((spray.bMThruSpecies && target.GetSpecies() == t.linetarget.GetSpecies()) || 
						(!(flags & BFGF_HURTSOURCE) && target == t.linetarget) ) // [XA] Don't hit oneself unless we say so.|| !t.linetarget.bSHOOTABLE 
					{
						spray.Destroy(); // [MC] Remove it because technically, the spray isn't trying to "hit" them.
						continue;
					}
					if (spray.bPuffGetsOwner) spray.target = target;
					if (spray.bFoilInvul) dmgFlags |= DMG_FOILINVUL;
					if (spray.bFoilBuddha) dmgFlags |= DMG_FOILBUDDHA;
					dmgType = spray.DamageType;
				}

				if (defdamage == 0)
				{
					damage = 0;
					for (int j = 0; j < damagecnt; ++j)
						damage += Random[BFGSpray](1, 8);
				}
				else
				{
					// if this is used, damagecnt will be ignored
					damage = defdamage;
				}

				int newdam = t.linetarget.DamageMobj(originator, target, damage, dmgType, dmgFlags|DMG_USEANGLE, t.angleFromSource);
				t.TraceBleed(newdam > 0 ? newdam : damage, self);
			}
		}
	}
	///

	States{
	Spawn:
		TNT1 A 1 NODELAY {
			//invoker.target.player.fov
			if(bFALLING){
				A_UNMKSpray("UNMK_StormZapper1",180,0,self.target.player.fov,PLAYERMISSILERANGE,self.target.player.fov,0);
			}
			else{
				A_UNMKSpray("UNMK_StormZapper1",180,0,self.target.player.fov,PLAYERMISSILERANGE,self.target.player.fov,0,BFGF_MISSILEORIGIN);
			}
			//BFGF_MISSILEORIGIN
			Destroy();
		}
		Goto Death;
	Death:
		TNT1 A 1 ;//A_BFGSpray("UNMK_StormZapper1",180,1,180,PLAYERMISSILERANGE,180,0,BFGF_MISSILEORIGIN);
		stop;
	}
}
Class UNMK_LightningEffect : Actor{
	Default{
		Renderstyle "Add";
		Alpha 0.75;
		Projectile;
		+FLOORHUGGER
		+NOGRAVITY
	}
	bool deathActive;
	Override Void Tick(){
		if(tracer){
			A_Warp(AAPTR_TRACER,0,0,0,0,WARPF_TOFLOOR|WARPF_NOCHECKPOSITION|WARPF_STOP|WARPF_INTERPOLATE);
		}
		SetZ(floorz);
		if(!deathActive){
			scale.y = (self.ceilingz - self.floorz)/255;
			if(random(0,1) > 0){bSPRITEFLIP = !bSPRITEFLIP;}
		}else{
			if(scale.y != GetDefaultByType(GetClass()).scale.y){
				scale.y = GetDefaultByType(GetClass()).scale.y;
			}
		}
		if(scale.x != GetDefaultByType(GetClass()).scale.x){
			scale.x = GetDefaultByType(GetClass()).scale.x;
		}
		Super.Tick();
	}
	States{
	Spawn:
		LFX4 IJKLM 1 Bright ;// A_JumpIf(!master,"Death");
		stop;
		//loop;
	Death:
		TNT1 A 0 {deathActive = true;}
		LFX1 NOPQR 2 Bright;
		stop;
	}
}
Class UNMK_StormZapper1 : Actor{
	Default{
	Radius 1;
	Height 1;
	Renderstyle "Add";
	Alpha 0.80;
	Projectile;
	DamageType "Incinerate";
	Species "Marines";
	+PIERCEARMOR
	+THRUSPECIES
	+MTHRUSPECIES
	+DONTHARMSPECIES
	-DOHARMSPECIES
	+DONTREFLECT
	+NODAMAGETHRUST
	+PUFFGETSOWNER
	+HITTRACER
	+FOILBUDDHA
	+FOILINVUL
	+FORCERADIUSDMG
	}
	
	Override Void Tick(){
		if(tracer){A_Warp(AAPTR_TRACER);}
		A_Explode(16,32,XF_NOALLIES);
		Super.Tick();
	}
	//floorz
	//ceilingz
	void A_SoulLightningStrike(class<Actor> MissileUp = "UNMK_StormStrike1", class<Actor> MissileDown = "UNMK_StormStrike4"){
		Actor MisUp;Actor MisDown;
		MisUp = A_SpawnProjectile(MissileUp,0,0,0,CMF_TRACKOWNER,90);
		MisDown = A_SpawnProjectile(MissileDown,0,0,0,CMF_TRACKOWNER,-90);
		//if(MisUp){int properheight = MisUp.ceilingz - MisUp.pos.z;}
		//if(MisDown){int properheight = MisDown.pos.z - MisDown.floorz;}
		bool a; actor b;
		[a,b] = A_SpawnItemEx("UNMK_LightningEffect",0,0,floorz,0,0,0);
		if(b){b.tracer = self.tracer;b.master = self;}
	}
	States{
	Spawn:
		LFX1 S 0 NODELAY A_SoulLightningStrike();
		LFX1 STUVW 1 Bright ;//A_Explode(16,32,XF_NOALLIES);
		LFX1 S 0 A_SoulLightningStrike();
		LFX1 STUVW 1 Bright ;//A_Explode(16,32,XF_NOALLIES);
		LFX1 S 0 A_SoulLightningStrike();
		LFX1 STUVW 1 Bright ;//A_Explode(16,32,XF_NOALLIES);
		LFX1 S 0 A_SoulLightningStrike();
		LFX1 STUVW 1 Bright ;//A_Explode(16,32,XF_NOALLIES);
		LFX1 S 0 A_SoulLightningStrike();
		LFX1 STUVW 1 Bright ;//A_Explode(16,32,XF_NOALLIES);
		LFX1 S 0 A_SoulLightningStrike();
		LFX1 STUVW 1 Bright ;//A_Explode(16,32,XF_NOALLIES);
		LFX1 S 0 A_SoulLightningStrike();
		LFX1 STUVW 1 Bright ;//A_Explode(16,32,XF_NOALLIES);
		LFX1 S 0 A_SoulLightningStrike("UNMK_StormStrike2","UNMK_StormStrike5");
		LFX1 STUVW 1 Bright ;//A_Explode(16,32,XF_NOALLIES);
		LFX1 S 0 A_SoulLightningStrike("UNMK_StormStrike2","UNMK_StormStrike5");
		LFX1 STUVW 1 Bright ;//A_Explode(16,32,XF_NOALLIES);
		LFX1 S 0 A_SoulLightningStrike("UNMK_StormStrike2","UNMK_StormStrike5");
		LFX1 STUVW 1 Bright ;//A_Explode(16,32,XF_NOALLIES);
		LFX1 S 0 A_SoulLightningStrike("UNMK_StormStrike2","UNMK_StormStrike5");
		LFX1 STUVW 1 Bright ;//A_Explode(16,32,XF_NOALLIES);
		LFX1 S 0 A_SoulLightningStrike("UNMK_StormStrike2","UNMK_StormStrike5");
		LFX1 STUVW 1 Bright ;//A_Explode(16,32,XF_NOALLIES);
		LFX1 S 0 A_SoulLightningStrike("UNMK_StormStrike2","UNMK_StormStrike5");
		LFX1 STUVW 1 Bright ;//A_Explode(16,32,XF_NOALLIES);
		LFX1 S 0 A_SoulLightningStrike("UNMK_StormStrike2","UNMK_StormStrike5");
		LFX1 STUVW 1 Bright A_Explode(16,32,XF_NOALLIES);//A_Explode(32,32,XF_NOALLIES);
		stop;
	}
}
Class UNMK_StormZapper2 : UNMK_StormZapper1{
	Override Void Tick(){
		if(tracer){A_Warp(AAPTR_TRACER);}
		A_Explode(32,64,XF_NOALLIES);
		Super.Tick();
	}
	States{
	Spawn:
		LFX2 K 0 NODELAY A_SoulLightningStrike("UNMK_StormStrike3","UNMK_StormStrike6");
		LFX2 KLMNO 1 Bright ;//A_Explode(32,64,XF_NOALLIES);
		LFX2 K 0 A_SoulLightningStrike("UNMK_StormStrike3","UNMK_StormStrike6");
		LFX2 KLMNO 1 Bright ;//A_Explode(32,64,XF_NOALLIES);
		LFX2 K 0 A_SoulLightningStrike("UNMK_StormStrike3","UNMK_StormStrike6");
		LFX2 KLMNO 1 Bright ;//A_Explode(32,64,XF_NOALLIES);
		LFX2 K 0 A_SoulLightningStrike("UNMK_StormStrike3","UNMK_StormStrike6");
		LFX2 KLMNO 1 Bright ;//A_Explode(32,64,XF_NOALLIES);
		LFX2 K 0 A_SoulLightningStrike("UNMK_StormStrike3","UNMK_StormStrike6");
		LFX2 KLMNO 1 Bright ;//A_Explode(32,64,XF_NOALLIES);
		LFX2 K 0 A_SoulLightningStrike("UNMK_StormStrike3","UNMK_StormStrike6");
		LFX2 KLMNO 1 Bright ;//A_Explode(32,64,XF_NOALLIES);
		LFX2 K 0 A_SoulLightningStrike();
		LFX2 KLMNO 1 Bright ;//A_Explode(32,64,XF_NOALLIES);
		LFX2 K 0 A_SoulLightningStrike();
		LFX2 KLMNO 1 Bright ;//A_Explode(32,64,XF_NOALLIES);
		LFX2 K 0 A_SoulLightningStrike();
		LFX2 KLMNO 1 Bright ;//A_Explode(32,64,XF_NOALLIES);
		LFX2 K 0 A_SoulLightningStrike();
		LFX2 KLMNO 1 Bright ;//A_Explode(32,64,XF_NOALLIES);
		LFX2 K 0 A_SoulLightningStrike();
		LFX2 KLMNO 1 Bright ;//A_Explode(32,64,XF_NOALLIES);
		LFX2 K 0 A_SoulLightningStrike();
		LFX2 KLMNO 1 Bright ;//A_Explode(32,64,XF_NOALLIES);
		stop;
	}
}

Class UNMK_StormStrike1 : Actor{
	Default{
	Radius 16;
	Height 1;
	Speed 90;
	Damage 2;
	PROJECTILE;
	Damagetype "Incinerate";//"Lightning"
	Renderstyle "None";//Add
	Alpha 0.75;
	Species "Marines";
	DeathSound "weapons/devzap";
	+PIERCEARMOR
	+THRUGHOST
	+RIPPER
	+NODAMAGETHRUST
	+DONTREFLECT
	+STRIFEDAMAGE
	+THRUSPECIES
	+MTHRUSPECIES
	+DONTHARMSPECIES
	-DOHARMSPECIES
	+FORCERADIUSDMG
	}
	States{
	Spawn:
		LFX1 IJKLM 1 Bright A_Explode(32,64,XF_NOALLIES);
		loop;
	Death:
		LFX1 NOPQR 2 Bright;
		stop;
	}
}

Class UNMK_StormStrike2 : UNMK_StormStrike1{
	Default{
	Speed 35;
	Damage 0;
	DeathSound "weapons/gnthit";
	}
	States{
	Spawn:
		LFX1 ABC 1 Bright A_Explode(16,64,XF_NOALLIES);
		loop;
	Death:
		LFX1 DEFGH 2 Bright;
		stop;
	}
}

Class UNMK_StormStrike3 : UNMK_StormStrike1{
	Default{
	Speed 120;
	Damage 4;
	DeathSound "weapons/shock";
	}
	States{
	Spawn:
		LFX2 FGHIJ 1 Bright A_Explode(64,64,XF_NOALLIES);
		loop;
	Death:
		LFX2 A 2 Bright A_Explode(32,128,XF_NOALLIES);
		LFX2 BCDE 2 Bright;
		stop;
	}
}

Class UNMK_StormStrike4 : UNMK_StormStrike1{
	States{
	Spawn:
		LFX3 DEFGH 1 Bright A_Explode(16,32,XF_NOALLIES);
		loop;
	Death:
		LFX1 NOPQR 2 Bright;
		stop;
	}
}

Class UNMK_StormStrike5 : UNMK_StormStrike2{
	States{
	Spawn:
		LFX3 ABC 1 Bright A_Explode(8,16,XF_NOALLIES);
		loop;
	Death:
		LFX1 DEFGH 2 Bright;
		stop;
	}
}

Class UNMK_StormStrike6 : UNMK_StormStrike3{
	States{
	Spawn:
		LFX3 IJKLM 1 Bright A_Explode(32,64,XF_NOALLIES);
		loop;
	Death:
		LFX2 A 2 Bright A_Explode(32,128,XF_NOALLIES);
		LFX2 BCDE 2 Bright;
		stop;
	}
}
