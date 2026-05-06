class CacoTimer : PB_Ammo {Default{Inventory.MaxAmount 48;}}

class PBXWeapons_ExperimentalSpawner : PBInjector
{
    override void Init(PB_EventHandler handler)
    {
		// Demon Ext
		if(pbxweapons_experimental)
		{
		   handler.InjectSpawn("PB_RLSpawnerT3","RideableCaco",255,1);
		}
    }
}

class RideableCaco : custominventory
{
    Default
    {
        -INVENTORY.ALWAYSPICKUP;
		-COUNTITEM;
        +FLOAT;
		FloatSpeed 4;
        FloatBobStrength 0.25;
		+NOGRAVITY;
		Gravity 0;
		Scale 0.65;
    }


    States
    {
        Spawn:
            CPAR A -1;
            stop;

        Pickup:
            CPAR A 0 {
                A_TakeInventory("RideableCaco",1);
                A_GiveInventory("FunnyCaco",1);
            }
            stop;
    }
}

class CacoBallPlayer : PB_Monster_Projectile
{
    Default
    {
        DamageType "Plasma";
        SeeSound "pb/monsters/caco/spit";
        DeathSound "CacoBallImpact";
        Radius 8;
        Height 8;
        Speed 12;
        FastSpeed 20;
        Damage 60;
        RenderStyle "Add";
        Alpha 0.99;
        +THRUGHOST;
        +RANDOMIZE;
        Projectile;
        Scale 0.58;
    }

    States 
    {
        Spawn:
            0DB0 A 1 BRIGHT {
                A_StartSound("CacoBallLoop", CHAN_BODY , CHANF_LOOP, 1);
            }
        Fly:
            0DB0 BCDEFA 2 BRIGHT A_SpawnProjectile("RailGunTrailSpark", 0, 0, random(0, 360), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random(0, 360));
            Loop;
        Death:
            TNT1 A 0 {
                A_StopSound(CHAN_BODY);
                A_StartSound("CacoBallImpact", CHAN_AUTO);
                A_SpawnItem("Plasma_Puff", 0);
            }
            TNT1 A 4;
            Stop;
	}
}

class FunnyCaco : PB_WeaponBase
{
    Default
    {
        Weapon.SelectionOrder 30000000;
        Weapon.AmmoType1 "CacoTimer";
        +INVENTORY.ALWAYSPICKUP;
        +WEAPON.CHEATNOTWEAPON;
    }

   override void AttachToOwner(Actor other)
    {
        Super.AttachToOwner(other);
        
        // Force switch
        if (Owner.player != null)
            Owner.player.PendingWeapon = self;
    }

    States
    {
        Spawn:
            HND7 E -1;
            Stop;
        Steady:
            TNT1 A 0;
            Goto Ready;
        Deselect:
           TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(-1);
				A_TakeInventory("PB_LockScreenTilt",1);
			}
			TNT1 A 0 A_StopSound(6);
			TNT1 A 0 A_ZoomFactor(1);
			CYBF LMNO 1 BRIGHT;
			TNT1 A 0 A_Lower;
			Wait;
		Select:
            TNT1 A 0 A_GiveInventory("CacoTimer",48);
            TNT1 A 0 setplayerproperty (1, 1, 3);
            TNT1 A 0 A_SetInvulnerable();
			TNT1 A 0 PB_WeaponRaise();
		SelectContinue:
			TNT1 A 0;
		SelectAnimation:
			TNT1 A 0;
        Ready:
        Ready3:
            TNT1 A 0 A_JumpIfInventory("CacoTimer",1,2);
            Goto TimeOut;
            TNT1 A 0 A_JumpIfInventory("GoWeaponSpecialAbility", 1, "WeaponSpecial");
            TNT1 A 0 A_PlaySound ("caco/pain", 6);
            CAPL ABCDEEEE 4 {
                A_WeaponReady(WRF_NOBOB | WRF_NOSWITCH);
                A_SetRoll(roll-3);
                A_CustomMissile ("Blue_FlyingBlood", 47, 0, random (0, 360), 2, random (30, 150));
            }
            TNT1 A 0 A_Recoil(+8);
            CAPL ABCDEEEE 4 {
                A_WeaponReady(WRF_NOBOB | WRF_NOSWITCH);
                A_SetRoll(roll+3);
                A_CustomMissile ("Blue_FlyingBlood", 47, 0, random (0, 360), 2, random (30, 150));
            }
            TNT1 A 0 A_Recoil(-5);
            TNT1 A 0 A_Jump(90, "Fire");
            TNT1 A 0 A_TakeInventory("CacoTimer",1);
            Loop;
        WeaponSpecial:
            TNT1 A 0 A_TakeInventory("GoWeaponSpecialAbility");
            CAPL JKLMNOOO 2;
            TNT1 A 0 A_TakeInventory("CacoTimer",2);
            TNT1 A 0 A_Jump(20,"GachiScream");
            TNT1 A 0 A_PlaySound ("caco/active", 8);
            CAPL PQRSRQRSRSQRQRSRQRSRSQRQRSRQRSRSQR  1  A_SetRoll (roll+1.5);
            CAPL PONMLKJ 2 A_SetRoll(roll+7);
            TNT1 A 0 A_SetRoll(0);
            Goto Ready;
        GachiScream:
            TNT1 A 0 A_PlaySound ("gachiah", 8);
            CAPL PQRSRQRSRSQRQRSRQRSRSQRQRSRQRSRSQR 1 A_SetRoll (roll+3);
            CAPL PONMLKJ 2 A_SetRoll(roll+7);
            TNT1 A 0 A_SetRoll(0);
            Goto Ready;
        Fire:
            TNT1 A 0 A_SetRoll(0);
            TNT1 A 0 A_Recoil(-8);
            TNT1 A 0 A_TakeInventory("CacoTimer",1);
            TNT1 A 0 A_FireCustomMissile("CacoBallPlayer");
            CAPL EFGHIHGFE 2 A_SetRoll(roll-2);
            TNT1 A 0 A_SetRoll(0);
            Goto Ready;
        TimeOut:
        AltFire:
            TNT1 A 0 A_SetRoll(0);
            TNT1 A 0 A_UnSetInvulnerable();
            TNT1 A 0 A_FireCustomMissile ("CacoXDeath");
            TNT1 A 0 SetPlayerProperty(1,0,3);
            //TNT1 A 0 A_SelectWeapon("Melee_Attacks")
            TNT1 A 0 A_TakeInventory("FunnyCaco",1);
            Stop;
                    
    }
}

// class CacoBallPlayer : PB_Monster_Projectile
// {
//        const PI = 3.14159265;
//     bool isAlive;
//     int startTime;
    
//     // Set full orbit duration in tics.
//     const orbitDurationTics = 35;  // A full orbit will take 35 tics.
    
//     // An offset to adjust the center of rotation.
//     // If the projectile's visual center is not exactly at self.pos, tweak this value.
//     const centerOffsetY = 0;  // For example, shift the center 6 units upward.
    
//     // Hardcoded initial offsets for each orbiter relative to the projectile's center.
//     double orbInitX[3];
//     double orbInitY[3];
    
// 	Actor lastKnownTarget;
//     Actor orbiters[3];
// 	double initialVelocity;
// 	int CascadeTimer;
// 	int OrbTimer;
// 	double dist;
// 	int checkDistanceTimer;
// 	int distanceTimerInterval;
// 	int launchStartTime;


//     Default {
//         DamageType "Plasma";
//         SeeSound "pb/monsters/caco/spit";
//         DeathSound "CacoBallImpact";
//         Radius 8;
//         Height 8;
//         Speed 12;
//         FastSpeed 20;
//         Damage 60;
//         RenderStyle "Add";
//         Alpha 0.99;
//         +THRUGHOST;
//         +RANDOMIZE;
//         Projectile;
//         Scale 0.58;
//     }


//     override void PostBeginPlay()
//     {
//         Super.PostBeginPlay();

//         // Try monster targeting first
//         if (self.target && self.target.target)
//         {
//             lastKnownTarget = self.target.target;
//         }
//         // If fired by player, use a linetrace to find what they're aiming at
//         else if (self.target && self.target.player)
//         {
//             FLineTraceData ltd;
//             self.target.LineTrace(self.target.angle, 8192, self.target.pitch, 
//                 TRF_SOLIDACTORS, self.target.player.viewheight, 0, 0, ltd);
//             if (ltd.HitActor && ltd.HitActor.bIsMonster)
//                 lastKnownTarget = ltd.HitActor;
//         }

//         isAlive = true;
//         startTime = level.time;
//         initialVelocity = vel.Length() > 0 ? vel.Length() : 12;
//         CascadeTimer = 35;
//         OrbTimer = 22;
//         checkDistanceTimer = 5;
//         launchStartTime = -1;

//         double centerX = self.pos.x;
//         double centerY = self.pos.y;
//         for (int i = 0; i < 3; i++)
//         {
//             double angleDeg = i * 120.0;
//             double offsetX = 30.0 * Cos(angleDeg);
//             double offsetY = 30.0 * Sin(angleDeg);

//             orbInitX[i] = offsetX;
//             orbInitY[i] = offsetY;

//             Actor orb = Spawn("PB_CacodemonBall", (centerX + orbInitX[i], centerY + orbInitY[i], self.pos.z), ALLOW_REPLACE);
//             if (orb)
//             {
//                 orb.master = self;
//                 if (self.target)
//                     orb.target = self.target;
//                 orbiters[i] = orb;
//             }
//         }
//     }

// 	override void Tick()  //(edit by leviathan)
// 	{
// 		Super.Tick();
// 		if (!isAlive)
// 			return;

// 		int ticDiff = level.time - startTime;
// 		int distanceTimer = level.time - distanceTimerInterval;

// 		if (distanceTimer >= checkDistanceTimer)
//         {
//             distanceTimerInterval = level.time;

//             // Monster case
//             if (self.target && self.target.target)
//             {
//                 lastKnownTarget = self.target.target;
//                 dist = distance3d(self.target.target);
//             }
//             // Player case — update last known target via linetrace
//             else if (self.target && self.target.player)
//             {
//                 FLineTraceData ltd;
//                 self.target.LineTrace(self.target.angle, 8192, self.target.pitch,
//                     TRF_SOLIDACTORS, self.target.player.viewheight, 0, 0, ltd);
//                 if (ltd.HitActor && ltd.HitActor.bIsMonster)
//                 {
//                     lastKnownTarget = ltd.HitActor;
//                     dist = distance3d(lastKnownTarget);
//                 }
//                 else if (lastKnownTarget)
//                 {
//                     dist = distance3d(lastKnownTarget);
//                 }
//                 else
//                 {
//                     dist = 4096;
//                 }
//             }
//             else if (lastKnownTarget)
//             {
//                 dist = distance3d(lastKnownTarget);
//             }
//             else
//             {
//                 dist = 4096;
//                 Console.Printf("\ckUnable to lock target");
//             }


// 			FLineTraceData traceData;
// 			bool traceResult = self.LineTrace(angle, 75, 25, TRF_THRUACTORS, 0, 0, 0, data: traceData);
// 			if (traceResult && (traceData.HitType == TRACE_HitFloor || traceData.HitType == TRACE_HitWall))
// 			{
// 				if (vel.z != 0) vel.z += 0.3; // Avoid adding to NaN 
// 			}
// 		}

// 		// Start the launch timer only when dist <= 700 for the first time
// 		if (launchStartTime == -1 && dist <= 800)
// 		{
// 			launchStartTime = level.time;
// 		}

// 		if (dist <= 700)
// 		{
// 			double timePassed = (double)(ticDiff - CascadeTimer);
// 			double decelerationRate = (initialVelocity * 0.5) / 40.0;
// 			double velocityFactor = Max(initialVelocity * 0.5, initialVelocity - (timePassed * decelerationRate));
// 			if (vel.Length() > 0) vel = vel.Unit() * velocityFactor; // Ensure vel is valid
// 		}

// 		double angleStepDeg = 360.0 / double(orbitDurationTics);
// 		double rotationAngleDeg = ticDiff * angleStepDeg;

// 		for (int i = 0; i < 3; i++)
// 		{
// 			if (orbiters[i])
// 			{
// 				if (launchStartTime != -1)
// 				{
// 					int launchTime = launchStartTime + (i * OrbTimer);
// 					if (level.time >= launchTime)
// 					{
// 						LaunchOrbiter(i);
// 						continue;
// 					}
// 				}

// 				double rotatedX = orbInitX[i] * Cos(rotationAngleDeg) - orbInitY[i] * Sin(rotationAngleDeg);
// 				double rotatedY = orbInitX[i] * Sin(rotationAngleDeg) + orbInitY[i] * Cos(rotationAngleDeg);
// 				orbiters[i].SetOrigin((self.pos.x + rotatedX, self.pos.y + rotatedY, self.pos.z), true);
// 			}
// 		}
// 	}

// 	void LaunchOrbiter(int i)
// 	{
// 		Actor orb = orbiters[i];
// 		if (!orb)
// 			return;

// 		if (self.target && self.target.target)
// 		{
// 			Vector3 direction = (self.target.target.pos - orb.pos).Unit();
// 			if (direction.Length() > 0) orb.vel = direction * 16.0; // Guard against zero vector
// 			else orb.vel = (16.0, 0.0, 0.0); // Fallback direction
// 		}
// 		else if (lastKnownTarget)
// 		{
// 			Vector3 direction = (lastKnownTarget.pos - orb.pos).Unit();
// 			if (direction.Length() > 0) orb.vel = direction * 16.0; // Guard against zero vector
// 			else orb.vel = (16.0, 0.0, 0.0); // Fallback direction
// 		}
// 		else
// 		{
// 			orb.vel = (16.0, 0.0, 0.0);
// 		}

// 		// 💥 Remove from orbiting system
// 		orbiters[i] = null;
// 	}

// 	override void OnDestroy()
// 	{
// 		Super.OnDestroy();
// 		isAlive = false;

// 		for (int i = 0; i < 3; i++)
// 		{
// 			if (orbiters[i])
// 			{

// 				orbiters[i].Destroy();
// 				orbiters[i] = null;
// 			}
// 		}
// 	}

//     States
//     {
//         Spawn:
//             0DB0 A 1 BRIGHT {
//                 A_StartSound("CacoBallLoop", CHAN_BODY , CHANF_LOOP, 1);
//             }
//         Fly:
//             0DB0 BCDEFA 2 BRIGHT A_SpawnProjectile("RailGunTrailSpark", 0, 0, random(0, 360), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random(0, 360));
//             Loop;
//         Death:
//             TNT1 A 0 {
//                 A_StopSound(CHAN_BODY);
//                 A_StartSound("CacoBallImpact", CHAN_AUTO);
//                 A_SpawnItem("Plasma_Puff", 0);
//                 isAlive = false;
//             }
//             TNT1 A 4;
//             Stop;
//     }
// }