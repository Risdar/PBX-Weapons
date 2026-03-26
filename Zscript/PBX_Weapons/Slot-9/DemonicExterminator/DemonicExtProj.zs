Class UNMK_Projectile : UNMK_DExtFastProjectile
{
	default
	{
		speed 350;
		//damage 72;
		//damagefunction (324);
		//damagefunction (247.5);
		Species "Marines";
		damagefunction (108);
		radius 5;
		height 5;
		//damagetype "incinerate";
		damagetype "saw";
		DeathSound "weapons/StachanovHit";
		renderstyle "add";
		scale 0.1;
		decal "PlasmaScorchLower";
	}
	states
	{
		Spawn:
			UAE3 C 1 bright;
			loop;
		Death:
			TNT1 A 0 A_setscale(frandom(0.25,0.50));
			TNT1 A 0 SpawnFlareImpact(pos);
			TNT1 A 0 A_Explode(random(64,128),8,0,0);
			DB26 IJKLMNOPQRSTUV 1 bright;
			stop;
	}
	
	override void postbeginplay()
	{
		//inflict different damage types
		int dtp = random(1,4);
		switch(dtp)
		{
			case 1:		damagetype = "Saw";				break;
			case 2:		damagetype = "Incinerate";		break;
			case 3:		damagetype = "ExplosiveImpact";	break;
			case 4:		damagetype = "Fire";			break;
		}
		super.postbeginplay();
	}
	
	//this spawns the trail, replaces the actors trail for a particles one
	override void effect()
	{
		spawnTrailPx(pos);
	}
	
	void spawnTrailPx(vector3 where)
	{
		FSpawnParticleParams UNMKPX;
		UNMKPX.Texture = TexMan.CheckForTexture("YHE5A0");
		UNMKPX.Color1 = "FFFFFF";
		UNMKPX.Style = STYLE_Add;
		UNMKPX.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		UNMKPX.Vel = (frandom(-0.5,0.5),frandom(-0.5,0.5),frandom(-0.5,0.5));
		UNMKPX.accel = (frandom(-0.25,0.25),frandom(-0.25,0.25),frandom(-0.25,0.25));
		UNMKPX.Startroll = random(0,360);
		UNMKPX.RollVel = random(-15,15);
		UNMKPX.StartAlpha = 0.75;
		UNMKPX.FadeStep = 0.031;
		UNMKPX.Size = 28;
		UNMKPX.SizeStep = -2;
		UNMKPX.Lifetime = 7; 
		UNMKPX.Pos = where;
		Level.SpawnParticle(UNMKPX);
	}
	
	void SpawnFlareImpact(vector3 where)
	{
		FSpawnParticleParams UNMFLAR;
		UNMFLAR.Texture = TexMan.CheckForTexture("UAE3C0");
		UNMFLAR.Color1 = "FFFFFF";
		UNMFLAR.Style = STYLE_TRANSLUCENT;
		UNMFLAR.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		UNMFLAR.Vel = (0,0,0);//(frandom(-0.5,0.5),frandom(-0.5,0.5),frandom(-0.5,0.5));
		UNMFLAR.Startroll = randompick(0,180);
		//UNMFLAR.RollVel = random(-5,5);
		UNMFLAR.StartAlpha = 0.85;
		UNMFLAR.FadeStep = 0.12;
		UNMFLAR.Size = random(150,160);
		//UNMFLAR.SizeStep = -7;
		UNMFLAR.Lifetime = 10; 
		UNMFLAR.Pos = where;
		Level.SpawnParticle(UNMFLAR);
	}
}

//unused	- too generic tbh
Class UNMK_AltPj : UNMK_DExtActor
{
	default
	{
		damagetype "incinerate";
		Translation "0:255=%[0,0,0]:[2.0,0.0,0.0]";
		renderstyle "translucent";
		+bright;
		Scale 0.18;
		+missile;
		projectile;
		speed 20;
		damage 100;
		Species "Marines";
		+rollsprite;
		+rollcenter;
	}
	
	states
	{
		spawn:
			TNT1 A 0 nodelay A_Startsound("UNMFLY1",18,CHANF_LOOPING);
			029G ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 Bright;
			loop;
		Death:
			TNT1 A 0 { 
				A_StopSound(18);
				bedead = true; 
				A_setroll(random(0,360));
				alpha = frandom(0.75,0.80);
				A_setscale(0.45,0.60);
				A_Startsound("unmbal",CHAN_AUTO);
			}
			TNT1 A 0 DoUnmakerAttack(1200,100);
			TNT1 A 0 A_QuakeEx(2,2,2,8,0,300,"",QF_SCALEDOWN);
			DB26 IJKLMNOPQRSTUV 1 bright;
			//HRX2 ABCDEFGH 1 bright;
			stop;
	}
	bool beDead;
	override void tick()
	{
		super.tick();
		
		if(isfrozen() || beDead)
			return;
			
		if(getage() % 3 == 0)
		{
			PB_SpawnUNMShockWave(pos);
			SPawnUnmkCal(self.vec3offset(2 * random(-radius,radius),2 * random(-radius,radius),1.25 * random(0,height) ));
		}
		if(getage() % 35 == 0)
			DoUnmakerAttack();
			
		spawnTrailPx(self.vec3offset(random(-radius,radius),random(-radius,radius), random(0,height) ));
		
	}
	
	void DoUnmakerAttack(int dist = 800, int dmg = -1)
	{
		let bt = blockthingsiterator.create(self,dist);
		actor v;
		if(dmg < 0)
			dmg = random(45,60);
		while(bt.next())
		{
			v = bt.thing;
			int sd = random(1,4);
			name damagetype = "Incinerate";
			switch(sd)
			{
				case 1:	damagetype = "Incinerate";	break;
				case 2:	damagetype = "Fire";	break;
				case 3:	damagetype = "Saw";	break;
				case 4:	damagetype = "Incinerate";	break;
			}
			if(v && v.health > 0 && v.checksight(self) && v != target)
				v.damagemobj(self,target,dmg,damagetype,DMG_THRUSTLESS);
		}
	}
	
	void spawnTrailPx(vector3 where)
	{
		FSpawnParticleParams UNMKPX;
		UNMKPX.Texture = TexMan.CheckForTexture("YHE5A0");
		UNMKPX.Color1 = "FFFFFF";
		UNMKPX.Style = STYLE_Add;
		UNMKPX.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		UNMKPX.Vel = (frandom(-2.5,2.5),frandom(-2.5,2.5),frandom(-2.5,2.5));
		UNMKPX.accel = (frandom(-0.15,0.15),frandom(-0.15,0.15),frandom(-0.15,0.15));
		UNMKPX.Startroll = random(0,360);
		UNMKPX.RollVel = random(-15,15);
		UNMKPX.StartAlpha = 0.75;
		UNMKPX.FadeStep = 0.031;
		UNMKPX.Size = 28;
		UNMKPX.SizeStep = -2;
		UNMKPX.Lifetime = 18; 
		UNMKPX.Pos = where;
		Level.SpawnParticle(UNMKPX);
	}
	
	Void PB_SpawnUNMShockWave(vector3 where)
	{
		FSpawnParticleParams ShockWv;
		ShockWv.Texture = TexMan.CheckForTexture("PBSWV1");
		ShockWv.Style = STYLE_ADD;
		ShockWv.Color1 = "FFFFFF";
		ShockWv.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		ShockWv.Startroll = randompick(0,180);
		//ShockWv.RollVel = random(-45,45);
		ShockWv.StartAlpha = 1.0;
		ShockWv.Lifetime = 20;
		ShockWv.FadeStep = 0.05;
		ShockWv.Size = 120;
		ShockWv.SizeStep = -5;
		ShockWv.Pos = where;
		Level.SpawnParticle(ShockWv);
	}
	
	void SPawnUnmkCal(vector3 where)
	{
		FSpawnParticleParams redcr;
		string f = String.Format("%c", int("A") + random(1,5));
		redcr.Texture = TexMan.CheckForTexture("HRX2"..f..0);
		redcr.Style = STYLE_TRANSLUCENT;
		redcr.Color1 = "FFFFFF";
		redcr.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		redcr.Startroll = random(0,360);
		//redcr.RollVel = random(-45,45);
		redcr.vel = (frandom(-0.25,0.25),frandom(-0.25,0.25),frandom(-0.25,0.25));
		redcr.StartAlpha = 0.85;
		redcr.Lifetime = 15;
		redcr.FadeStep = 0.075;
		redcr.Size = random(55,80);
		redcr.SizeStep = random(2,6);
		redcr.Pos = where;
		Level.SpawnParticle(redcr);
	}
}

Class ExplosievUNmk : PB_lightactor
{
	default
	{
		scale 0.5;
		alpha 0.85;
		renderstyle "Add";
		damagetype "Fire";
		+nointeraction;
		+rollsprite;
		+rollcenter;
	}
	States
	{
		spawn:
			HRX2 ABCDEFGH 1 bright;
			stop;
	}
	
	override void beginplay()
	{
		A_Setscale(self.scale.x + frandom(-0.1,0.1));
		A_Setroll(random(0,360));
		super.beginplay();
	}
}

//
//	ground fire attack, spawns dtech fire as its trail, and explodes dealing big damage
//	couldnt come up with something better, sorry 
//

Class UNMK_Grounder : UNMK_DExtActor
{
	default
	{
		+missile;
		projectile;
		+floorhugger;
		speed 45;
		damage 5;
		radius 7;
		height 5;
		damagetype "Incinerate";
		Species "Marines";
		+ripper;
		-bloodsplatter;
		decal "Scorch";
	}
	states
	{
		Spawn:
			TNT1 A 1;
			TNT1 A 0 A_startsound("UNOCBLL",16,CHANF_LOOPING);
			TNT1 A 1;
		Run:
			TNT1 A 1 Unmk_SpawnDtechFire((random(-25,25),random(-25,25),random(0,5)));
			TNT1 A 0 SpawnUNMKFlare(pos,true);
			TNT1 A 0 spawnTrailPx(pos);
			TNT1 A 0 A_jump(64,"DamageSpecial");	// 1/4 chance to do the area attack before exploding,so it isnt just a useless ground attack
			loop;
		DamageSpecial:
			TNT1 A 1 Unmk_SpawnDtechFire((random(-30,30),random(-25,25),random(0,5)));
			TNT1 A 0 SpawnUNMKFlare(pos,true);
			TNT1 A 0 DoUnmakerAttack(600,-1);
			TNT1 A 0 A_SPawnitem("ExplosievUNmk",0,10);
			TNT1 A 1 Unmk_SpawnDtechFire((random(-30,30),random(-25,25),random(0,5)));
			TNT1 A 0 SpawnUNMKFlare(pos,true);
			goto Run;
		Death:
			TNT1 A 0 A_StopSound(16);
			TNT1 A 0 SpawnUNMKFlare(self.vec3offset(0,0,5));
			TNT1 A 0 A_Startsound("weapons/demontech/respect2",CHAN_AUTO);
			TNT1 A 0 A_StartSound("FAREXPL",CHAN_AUTO,CHANF_OVERLAP);
			TNT1 A 0 PB_SpawnUNMShockWave(pos);
			TNT1 A 0 DoUnmakerAttack(1200,150);
			TNT1 A 0 A_QuakeEx(3,3,3,8,0,120,"",QF_SCALEDOWN);
			TNT1 AAA 0 A_SpawnProjectile("FireworkSFXUnmaker", 2, 0, random (0, 360), 2, -random(10, 80));
			TNT1 A 8;
			stop;
	}
	
	void SpawnUNMKFlare(vector3 where, bool fast = false)
	{
		FSpawnParticleParams UNMFLAR;
		UNMFLAR.Texture = TexMan.CheckForTexture("UAE3C0");
		UNMFLAR.Color1 = "FFFFFF";
		UNMFLAR.Style = STYLE_TRANSLUCENT;
		UNMFLAR.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		UNMFLAR.Vel = (0,0,0);
		UNMFLAR.Startroll = randompick(0,180);
		UNMFLAR.StartAlpha = 0.85;
		UNMFLAR.FadeStep = 0.05;
		UNMFLAR.Size = fast ? 300 : random(400,500);
		UNMFLAR.SizeStep = -10;
		UNMFLAR.Lifetime = fast ? 1 : 18; 
		UNMFLAR.Pos = where;
		Level.SpawnParticle(UNMFLAR);
	}
	
	void Unmk_SpawnDtechFire(vector3 offs)
	{
		actor dtc = Spawn("U64BurningPiece",self.vec3offset(offs.x,offs.y,offs.z));
		if(dtc)
		{
			dtc.target = self;
			//dtc.A_setscale(dtc.scale.x + frandom(-0.1,0.45));
		}
	}
	
	void DoUnmakerAttack(int dist = 1200, int dmg = -1)
	{
		let bt = blockthingsiterator.create(self,dist);
		actor v;
		if(dmg < 0)
			dmg = random(45,60);
		while(bt.next())
		{
			v = bt.thing;
			int sd = random(1,4);
			name damagetype = "Incinerate";
			switch(sd)
			{
				case 1:	damagetype = "Incinerate";	break;
				case 2:	damagetype = "Fire";	break;
				case 3:	damagetype = "Saw";	break;
				case 4:	damagetype = "Incinerate";	break;
			}
			if(v && v.health > 0 && v.checksight(self) && v != target)
				v.damagemobj(self,target,dmg,damagetype,DMG_THRUSTLESS);
		}
	}
	
	void spawnTrailPx(vector3 where)
	{
		FSpawnParticleParams UNMKPX;
		UNMKPX.Texture = TexMan.CheckForTexture("YHE5A0");
		UNMKPX.Color1 = "FFFFFF";
		UNMKPX.Style = STYLE_Add;
		UNMKPX.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		UNMKPX.Vel = (frandom(-2.5,2.5),frandom(-2.5,2.5),frandom(1.75,4.5));
		UNMKPX.accel = (frandom(-0.75,0.75),frandom(-0.75,0.75),frandom(-0.25,0.25));
		UNMKPX.Startroll = random(0,360);
		UNMKPX.RollVel = random(-15,15);
		UNMKPX.StartAlpha = 0.75;
		UNMKPX.FadeStep = 0.031;
		UNMKPX.Size = 28;
		UNMKPX.SizeStep = -2;
		UNMKPX.Lifetime = 18; 
		UNMKPX.Pos = where;
		Level.SpawnParticle(UNMKPX);
	}
	
	Void PB_SpawnUNMShockWave(vector3 where)
	{
		FSpawnParticleParams ShockWv;
		ShockWv.Texture = TexMan.CheckForTexture("PBSWV1");
		ShockWv.Style = STYLE_ADD;
		ShockWv.Color1 = "FFFFFF";
		ShockWv.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		ShockWv.Startroll = randompick(0,180);
		//ShockWv.RollVel = random(-45,45);
		ShockWv.StartAlpha = 1.0;
		ShockWv.Lifetime = 8;
		ShockWv.FadeStep = 0.15;
		ShockWv.Size = 125;
		ShockWv.SizeStep = 65;
		ShockWv.Pos = where;
		Level.SpawnParticle(ShockWv);
	}
	
}

Class U64BurningPiece : DTechBurningPiece
{
	default
	{
		scale 0.6;
		radius 10;
		height 10;
	}
	states
	{
		Spawn:
			TNT1 A 0 A_JumpIf(waterlevel > 1, "StopBurning");
			TNT1 A 0 A_Explode(15, 50);
			TNT1 A 0 SpawnParticleSlow("YAE4A0");
			DFIR ABCDEFGHIJKLMNOP 2 BRIGHT;
			TNT1 A 0 A_Jump(50, "StopBurning");
			Loop;
		StopBurning:
			DFIR A 2 BRIGHT A_SetScale(0.06);
			DFIR B 2 BRIGHT A_SetScale(0.04);
			DFIR C 2 BRIGHT A_SetScale(0.02);
			Stop;
	}
	
	override void beginplay()
	{
		self.bxflip = random(0,1);
		A_setscale(self.scale.x + frandom(-0.1,0.25));
		super.beginplay();
	}
}
Class UnmakerLaser64 : UNMK_DExtActor{
	Default{
	Radius 18;
	Height 18;
	Speed 40;
	Damage 20;
	Projectile;
	+NOGRAVITY
	MissileType "UnmakerLaser64Trail";
	DamageType "Fire";
	DeathSound "";
	Scale 0.1;
	}
	States{
	Spawn:
	TNT1 A 1;
	Loop;
	Death:
	TNT1 A 0 A_SetScale(1);
	LENR C 1	A_FadeOut(0.02);
	Stop;
	}
}
Class DExtShoque : UNMK_DExtActor{
	Default{
	Radius 1;
	Height 1;
	Speed 2;
	Damage 0;
	RenderStyle "Add";
	Scale 0.7;
	Gravity 0;
	Alpha 0.5;
	+NOBLOCKMAP
	+NOTELEPORT
	+DONTSPLASH
	+MISSILE
	+FORCEXYBILLBOARD
	+ROLLSPRITE
	+ROLLCENTER
	}
	States{
	Spawn:
		TNT1 A 1;
		SHOQ ABCDEFG 1 BRIGHT;
		Stop;
	}
}

Class DemonExterminatorEnergyBlast : PlasmaBall{
	Default{
		Scale 0.8;
		Speed 85;
		Damagefunction 216;
		//Damage 25;
		//54*4
		Height 7;
		Radius 7;
		Alpha 0.9;
		RenderStyle "Add";
		Decal "MedScorch";
		DamageType "Plasma";
		ReactionTime 60;
		+DONTSPLASH
		+BLOODSPLATTER
		+FORCERADIUSDMG
		+NOGRAVITY
		+BOUNCEONWALLS
		+EXPLODEONWATER
		+PAINLESS
		Obituary "%o was barbequed by %k's Lasergun.";
		SeeSound "";
		BounceFactor 0.95;
		ReactionTime 45;
	}
	int flipRoll;
	override void BeginPlay(){
		flipRoll = randompick(-1,1);
		if(random(0,1)){bXFLIP = true;}
		if(random(0,1)){bYFLIP = true;}
		super.BeginPlay();
	}
	override void tick(){
		super.tick();
		if(GetAge() >= 1){
			A_SetRoll(roll+(15 * flipRoll ) );
		}
	}
	States{
	Spawn:
		TNT1 A 0 NoDelay A_JumpIf(waterlevel > 1,"Death");
		TNT1 A 0 A_CountDown;
		TNT1 A 0 A_SpawnItemEx("RocketFlare");
		LEYS R 1 Bright Light("BIGREDLASER") A_SpawnItemEx("DemonExterminatorLaserTrail",0,0,0,0,0,0,0,SXF_TRANSFERROLL);
		TNT1 A 0 A_CustomMissile("ObeliskTrailSpark",0,0,random(0,360));
		TNT1 A 0 A_SpawnItemEx("DExtShoque",0,0,0,0,0,0,0,SXF_TRANSFERROLL);
		Loop;
	Death:
		TNT1 A 0 A_Stop;
		TNT1 A 0 {A_PlaySound("DSFIRXPL",CHAN_ITEM); A_Explode(50,75,0);}//100
		L2NR AB 3 Bright Light("BIGREDLASER") A_SpawnItemEx("RocketFlare");
		LENR AB 1 Bright Light("BIGREDLASER") A_SpawnItemEx("RocketFlare");
		TNT1 AAAAAAAAAA 0 {A_CustomMissile("ExplosionParticleHeavy",2,0,random(0,360),2,random(0,180));A_CustomMissile("ExplosionParticleLaser",0,0,random(0,360),2,random(0,360));}
		LPUF A 1 Light("REDLASER") A_Explode(50,75,0);
		TNT1 A 0 A_SpawnItemEx("DExtShoque");
		TNT1 A 0 A_SpawnItemEx("LiquidExplosionEffectSpawner");
		TNT1 A 0 A_SetScale(1.2);
		LPUF ABC 7 Bright Light("REDLASER") A_CustomMissile("PlasmaSmoke",1,0,random(0,360),2,random(0,160));
		Stop;
	}
}
Class ExplosionParticleLaser : UNMK_DExtActor{
	Default{
	Scale 0.02;
	Speed 6;
	Radius 1;
	Height 1;
	Gravity 0.9;
	RenderStyle "Add";
	BounceType "Doom";
	BounceFactor 0.01;
	BounceCount 1;
	+MISSILE
	+NOTELEPORT
	+NOBLOCKMAP
	+BLOODLESSIMPACT
	+FORCEXYBILLBOARD
	+CLIENTSIDEONLY
	+DONTSPLASH
	+THRUACTORS
	+THRUGHOST
	+GHOST
	+ROLLSPRITE
	+ROLLCENTER
	}
	States{
	Spawn:
		SPRK O 8 Bright NoDelay A_JumpIf(waterlevel > 1,"Splash");
	Death:
		TNT1 A 0 A_JumpIf(waterlevel > 1,"Splash");
		SPRK O 1 Bright A_FadeOut(0.03);
		Loop;
	Splash:
		TNT1 A 1;
		Stop;
	}
}
Class DemonExterminatorLaserTrail : UNMK_DExtActor{
	Default{
		Scale 2.75;
		Height 7;
		Radius 7;
		Speed 80;
		Damage 0;
		Alpha 1;
		RenderStyle "Add";
		+ROLLSPRITE
		+ROLLCENTER
	}
	states{
	Spawn:
		LAZR AB 1 Bright A_SpawnItemEx("RocketFlare");
		Stop;
	Death:
		LPUF A 1 Bright;
		Stop;
	}
}