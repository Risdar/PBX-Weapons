class CacoTimer : PB_Ammo {Default{Inventory.MaxAmount 48;}}

class CacoHandler : EventHandler
{
    override void WorldTick()
    {
		// For every player that exists
		for (int pn = 0; pn < MAXPLAYERS; pn++) 
		{
			// Is the player actually in the game?
			if (!playerInGame[pn])
				continue;

			PlayerInfo player	= players[pn]; 	// The player info
			PlayerPawn mo		= player.mo;	// The player inside the game

			// Is the player pressing the use key
			if (!(player.cmd.buttons & BT_USE)) return;

			// If yes fire a linetrace
			FLineTraceData traceData;
			bool hit = mo.LineTrace(
				mo.angle,          // Horizontal angle (facing direction)
				128,               // Max range (units)
				mo.pitch,          // Vertical angle (looking up/down)
				0,   			   // Flags
				mo.ViewHeight,     // Z offset from pawn origin (eye-level approximation)
				0, 0,              // X/Y offsets
				traceData          // Output struct
			);

			// Did the linetrace hit something?
			if (!hit) return;

			// If yes, is it the cacodemon?
			if(	traceData.HitActor 
				&& traceData.HitActor.bISMONSTER 
				&& traceData.HitActor.bFRIENDLY == false 
				&& traceData.HitActor is "PB_Cacodemon")
			{
				// Cast the cacodemon pointer to dacaco
				let dacaco = traceData.HitActor;

				// Is the Caco in its ready or spawn state?
				if(	dacaco && 
					actor.InStateSequence(dacaco.curstate,dacaco.ResolveState("See")) ||
					actor.InStateSequence(dacaco.curstate,dacaco.ResolveState("Spawn")))
				{
					// Play the execute animation
					// let weapon = PB_Weaponbase(player.ReadyWeapon);
					// let playersprite = player.FindPSprite(PSP_WEAPON);
					// if(!playersprite) return;
					// if(!weapon) return;
					// player.SetPSprite(PSP_WEAPON,weapon.FindState("Execution_Generic"));
					
					// Give the player the rideable caco
					mo.A_GiveInventory("FunnyCaco",1);
					// Destroy the original cacodemon
					dacaco.Destroy();
					return;
				}
			}
		}
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
				A_SetCrosshair(-1);
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
			TNT1 A 0 {
                // This is a modified PB_WeaponRaise
                A_weaponoffset(0,32);
                A_setroll(0);
		        A_zoomfactor(1.0);

                A_StopSound(1);
                A_StopSound(CHAN_VOICE);
                A_StopSound(5);
                A_StopSound(6);
                A_StopSound(7);
                A_StopSOund(CHAN_AUTO);

                A_SetInventory("Spin",0);
                A_SetInventory("CantWeaponSpecial",0);		//Fixes bug with Weapon Special Key no longer working when changing SGL grenade type or RL missile mode
                A_SetInventory("MG42Selected",0); 			//Take this token on every weapon that's not the MG42.
                A_SetInventory("Grabbing_A_Ledge", 0);		//Fixed bug where movement is locked when vaulting after entering a level
                A_SetInventory("RandomHeadExploder",0);
                A_SetInventory("DualFireReload",0);
                A_SetInventory("Kicking",0);
                A_SetInventory("Zoomed",0);

                A_ClearOverlays(-999, -999);
                invoker.WeaponScaleX = 1.0;
                invoker.WeaponScaleX = PB_PixelRenderingFix ? 1.2 : 1.0;
		
                PB_SetUsingKick(false);
                PB_SetUsingMelee(false);
                PB_SetUsingEquipment(false);
                PB_SetExecutingEnemy(false);
                PB_SetReloading(false);
            }
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
                A_WeaponReady(WRF_NOBOB | WRF_NOSWITCH | WRF_DISABLESWITCH);
                A_SetRoll(roll-3);
                A_CustomMissile ("Blue_FlyingBlood", 47, 0, random (0, 360), 2, random (30, 150));
            }
            TNT1 A 0 A_Recoil(+8);
            CAPL ABCDEEEE 4 {
                A_WeaponReady(WRF_NOBOB | WRF_NOSWITCH | WRF_DISABLESWITCH);
                A_SetRoll(roll+3);
                A_CustomMissile ("Blue_FlyingBlood", 47, 0, random (0, 360), 2, random (30, 150));
            }
            TNT1 A 0 A_Recoil(-5);
            TNT1 A 0 A_Jump(90, "Fire");
            TNT1 A 0 A_TakeInventory("CacoTimer",1);
            Loop;
        // This state will never actually be entered
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
            TNT1 A 0 SetPlayerProperty(1,0,3);
            TNT1 A 0 PB_SetPlayerExecutionProperties();
        Execution_Cacodemon1:
            TNT1 A 0  {
				A_SpawnItemEx("PB_Cacodemon_Execution_1", 32, 0,0,0,0,0,0,SXF_NOCHECKPOSITION);
				A_SetPitch(0, SPF_INTERPOLATE);
				A_ZoomFactor(0.8);
			}
			// Frame 1: 5 Ticks
			TNT1 A 0 A_StartSound("weapons/ultrwhoosh", CHAN_AUTO);
			PBFT A 1 {
				A_ZoomFactor(1.25, ZOOM_INSTANT);
				A_SetPitch(pitch+2);
				A_SetAngle(angle+1);
				A_SetRoll(roll-5);
			}
			PBFT B 1 {
				A_ZoomFactor(1.35, ZOOM_INSTANT);
				A_SetPitch(pitch+2);
				A_SetAngle(angle+2);
				A_SetRoll(roll-5);
			}
			PBFT C 1 {
				A_ZoomFactor(1.45, ZOOM_INSTANT);
				A_SetPitch(pitch+2);
				A_SetAngle(angle+2);
				A_SetRoll(roll-5);
			}
			PBFT D 1 {
				A_ZoomFactor(1.55, ZOOM_INSTANT);
				A_SetPitch(pitch+2);
				A_SetAngle(angle+3);
				A_SetRoll(roll-5);
			}
			PBFT E 1 {
				A_ZoomFactor(1.65, ZOOM_INSTANT);
				A_SetPitch(pitch+2);
				A_SetAngle(angle-8);
				A_SetRoll(roll-5);
			}
			TNT1 A 0 {
				A_FireProjectile("ShakeYourAss");
				A_StartSound("NECK_BRK", CHAN_AUTO);
				A_StartSound("EYEPULL", CHAN_AUTO);
			}
			// Frame 2: 24 ticks
			TNT1 A 0 A_StartSound("gore/tension", CHAN_BODY);
			G004 FFGH 1 {
				A_ZoomFactor(1.67, ZOOM_INSTANT);
				A_SetPitch(pitch-2);
				A_SetAngle(angle-1);
				A_SetRoll(roll+2);
			}
			G004 FFGH 1 {
				A_ZoomFactor(1.68, ZOOM_INSTANT);
				A_SetPitch(pitch+2);
				A_SetAngle(angle+1);
				A_SetRoll(roll-2);
			}
			G004 IJKL 1 {
				A_ZoomFactor(1.69, ZOOM_INSTANT);
				A_SetPitch(pitch-2);
				A_SetAngle(angle-1);
				A_SetRoll(roll+2);
				A_FireProjectile("ShakeYourAss");
			}
			G004 MNOP 1 {
				A_ZoomFactor(1.70, ZOOM_INSTANT);
				A_SetPitch(pitch+2);
				A_SetAngle(angle+1);
				A_SetRoll(roll-2);
			}
			G004 QRST 1 {
				A_ZoomFactor(1.71, ZOOM_INSTANT);
				A_SetPitch(pitch-2);
				A_SetAngle(angle-1);
				A_SetRoll(roll+2);
			}
			TNT1 A 0 A_StartSound("NeckSnap", CHAN_AUTO);
			G004 UVWXY 1 {
				A_ZoomFactor(1.72, ZOOM_INSTANT);
				A_SetPitch(pitch+2);
				A_SetAngle(angle+1);
				A_SetRoll(roll-2);
			}
			G004 Z 1 {
				A_FireProjectile("ShakeYourAss");
				A_ZoomFactor(1.8, ZOOM_INSTANT);
				A_StopSound(CHAN_BODY);
				A_StartSound("misc/gibbed", CHAN_AUTO);
			}
			G004 A 1 {
				A_SetPitch(pitch+6);
				A_SetAngle(angle-8);
				A_SetRoll(roll+10);
			}
			G004 BCD 1 {
				A_SetPitch(pitch+3);
				A_SetAngle(angle-2);
				A_SetRoll(roll+8);
			}
			TNT1 A 0 A_ZoomFactor(1.2);
			TNT1 AA 1 A_SetPitch(pitch+1);
			TNT1 AA 1;
			TNT1 AAAAA 1 {
				A_SetPitch(pitch-4);
				A_SetAngle(angle+1);
				A_SetRoll(roll-9);
			}
            TNT1 A 0 A_UnSetInvulnerable();
			TNT1 A 0 PB_UnsetPlayerExecutionProperties();
            TNT1 A 0 {
                NashGoreGibs.SpawnGibs(self);
				NashGoreGibs.SpawnGibs(self);
				A_SpawnProjectile("PB_CacoDemonGib2", 34, 0, random (160, 220), 2, random (-80, -150));
				A_SpawnProjectile("PB_CacoDemonGib5", 46, 0, random (160, 220), 2, random (-30, -150));
				A_SpawnProjectile("PB_CacoDemonGib6", 48, 0, random (160, 220), 2, random (-30, -150));
				A_SpawnProjectile("PB_CacoDemonGib7", 44, 0, random (160, 220), 2, random (-30, -150));
				A_SpawnProjectile("PB_CacoDemonGib14", 48, 0, random (160, 220), 2, random (-30, -150));
				A_SpawnProjectile("PB_CacodemonGib3", 30, 0, random (0, 360), 2, random (-30, -150));
				A_SpawnProjectile ("PB_CacodemonGib11", 35, 0, random (0, 360), 2, random (-30, -150));
				A_SpawnProjectile("PB_CacodemonGib10", 30, 0, random (0, 360), 2, random (-30, -150));
				A_SpawnProjectile ("PB_CacodemonGib12", 24, 0, random (0, 360), 2, random (-65, -150));
				A_SpawnProjectile ("PB_CacodemonGib13", 32, 0, random (0, 360), 2, random (-65, -150));
				A_SpawnProjectile("PB_CacodemonGib8", 30, 0, random (0, 360), 2, random (-30, -150));
				
				for(int i = 0; i < 16; i++) {
					A_SpawnProjectile("PB_FlyingBlood", 47, 0, random (0, 360), 2, random (65, 150));
					A_SpawnProjectile("PB_BloodMistBig", 36, 0, random (0, 360), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random (0, 360));
				}
			}
			TNT1 A 0 A_SetInventory("CantWeaponSpecial",0);
            TNT1 A 0 A_TakeInventory("FunnyCaco",1);
            stop;
                    
    }
}

class CacoBallPlayer : PB_Monster_Projectile
{
    const PI = 3.14159265;
    bool isAlive;
    int startTime;

    const orbitDurationTics = 35;
    const centerOffsetY = 0;

    double orbInitX[3];
    double orbInitY[3];

    Actor lastKnownTarget;
    Actor orbiters[3];
    double initialVelocity;
    int CascadeTimer;
    int OrbTimer;
    double dist;
    int checkDistanceTimer;
    int distanceTimerInterval;
    int launchStartTime;

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

    override void PostBeginPlay()
    {
        Super.PostBeginPlay();

        isAlive = true;
        startTime = level.time;
        initialVelocity = vel.Length() > 0 ? vel.Length() : 12;
        CascadeTimer = 35;
        OrbTimer = 22;
        checkDistanceTimer = 5;
        launchStartTime = -1;

        // Find the monster the player is looking at using LineTrace
        // self.target here is the PlayerPawn who fired this projectile
        if (self.target)
        {
            FLineTraceData traceData;
            bool hit = self.LineTrace(
                self.angle,
                800,
                self.pitch,
                0,
                self.height * 0.5,
                0, 0,
                traceData
            );

            if (hit && traceData.HitType == TRACE_HitActor && traceData.HitActor != null)
            {
                // Only lock on if it's a PB_Monster
                PB_Monster mon = PB_Monster(traceData.HitActor);
                if (mon)
                {
                    lastKnownTarget = mon;
                }
            }
        }

        // Spawn orbiters
        double centerX = self.pos.x;
        double centerY = self.pos.y;

        for (int i = 0; i < 3; i++)
        {
            double angleDeg = i * 120.0;
            double offsetX = 30.0 * Cos(angleDeg);
            double offsetY = 30.0 * Sin(angleDeg);

            orbInitX[i] = offsetX;
            orbInitY[i] = offsetY;

            Actor orb = Spawn("PB_CacodemonBall", (centerX + orbInitX[i], centerY + orbInitY[i], self.pos.z), ALLOW_REPLACE);

            if (orb)
            {
                orb.master = self;
                // Point orb.target at the firing player so it won't damage them
                orb.target = self.target;
                orbiters[i] = orb;
            }
        }
    }

    override void Tick()
    {
        Super.Tick();
        if (!isAlive)
            return;

        int ticDiff = level.time - startTime;
        int distanceTimer = level.time - distanceTimerInterval;

        if (distanceTimer >= checkDistanceTimer)
        {
            distanceTimerInterval = level.time;

            // Refresh lastKnownTarget — check it's still alive
            if (lastKnownTarget && lastKnownTarget.health > 0)
            {
                dist = distance3d(lastKnownTarget);
            }
            else if (lastKnownTarget)
            {
                // Target is dead, keep last known dist but stop updating
                dist = 4096;
            }
            else
            {
                dist = 4096;
            }

            // Wall/floor avoidance nudge
            FLineTraceData traceData;
            bool traceResult = self.LineTrace(angle, 75, 25, TRF_THRUACTORS, 0, 0, 0, data: traceData);
            if (traceResult && (traceData.HitType == TRACE_HitFloor || traceData.HitType == TRACE_HitWall))
            {
                if (vel.z != 0) vel.z += 0.3;
            }
        }

        // Start launch timer once target is within 800 units
        if (launchStartTime == -1 && dist <= 800)
        {
            launchStartTime = level.time;
        }

        // Decelerate when close
        if (dist <= 700)
        {
            double timePassed = (double)(ticDiff - CascadeTimer);
            double decelerationRate = (initialVelocity * 0.5) / 40.0;
            double velocityFactor = Max(initialVelocity * 0.5, initialVelocity - (timePassed * decelerationRate));
            if (vel.Length() > 0) vel = vel.Unit() * velocityFactor;
        }

        // Orbit update
        double angleStepDeg = 360.0 / double(orbitDurationTics);
        double rotationAngleDeg = ticDiff * angleStepDeg;

        for (int i = 0; i < 3; i++)
        {
            if (orbiters[i])
            {
                if (launchStartTime != -1)
                {
                    int launchTime = launchStartTime + (i * OrbTimer);
                    if (level.time >= launchTime)
                    {
                        LaunchOrbiter(i);
                        continue;
                    }
                }

                double rotatedX = orbInitX[i] * Cos(rotationAngleDeg) - orbInitY[i] * Sin(rotationAngleDeg);
                double rotatedY = orbInitX[i] * Sin(rotationAngleDeg) + orbInitY[i] * Cos(rotationAngleDeg);
                orbiters[i].SetOrigin((self.pos.x + rotatedX, self.pos.y + rotatedY, self.pos.z), true);
            }
        }
    }

    void LaunchOrbiter(int i)
    {
        Actor orb = orbiters[i];
        if (!orb) return;

        // Use lastKnownTarget for direction (same fallback chain as original)
        if (lastKnownTarget && lastKnownTarget.health > 0)
        {
            Vector3 direction = (lastKnownTarget.pos - orb.pos).Unit();
            if (direction.Length() > 0) orb.vel = direction * 16.0;
            else orb.vel = (16.0, 0.0, 0.0);
        }
        else
        {
            // No valid target, launch forward
            orb.vel = (16.0, 0.0, 0.0);
        }

        orbiters[i] = null;
    }

    override void OnDestroy()
    {
        Super.OnDestroy();
        isAlive = false;

        for (int i = 0; i < 3; i++)
        {
            if (orbiters[i])
            {
                orbiters[i].Destroy();
                orbiters[i] = null;
            }
        }
    }

    States
    {
        Spawn:
            0DB0 A 1 BRIGHT
            {
                A_StartSound("CacoBallLoop", CHAN_BODY, CHANF_LOOP, 1);
            }
        Fly:
            0DB0 BCDEFA 2 BRIGHT A_SpawnProjectile("RailGunTrailSpark", 0, 0, random(0, 360), CMF_AIMDIRECTION|CMF_ABSOLUTEPITCH|CMF_OFFSETPITCH|CMF_BADPITCH|CMF_SAVEPITCH, random(0, 360));
            Loop;
        Death:
            TNT1 A 0
            {
                A_StopSound(CHAN_BODY);
                A_StartSound("CacoBallImpact", CHAN_AUTO);
                A_SpawnItem("Plasma_Puff", 0);
                isAlive = false;
            }
            TNT1 A 4;
            Stop;
    }
}