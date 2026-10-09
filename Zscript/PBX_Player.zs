// This is so the meathook work
// All credits goes to EmeraldCoasttt and the BDP Team
class meathook : Inventory {Default {Inventory.MaxAmount 1;}}
class PBXCore_Player : PB_PlayerPrawn
{
	Actor aimActor;
	Actor aimActor2;
	vector3 aimpos;
	vector3	Acceleration;

    //Grappling Hook
	actor	GrappledMonster;
	actor	HookFired;
	bool	Grappled;
	float	PendulumLength;
	vector3	GrappleVel;
	vector3 Rope;
	int grapplesidespeed;
	double lasttickrope;

    vector3 SafeUnit3(Vector3 VecToUnit)
	{
		if(VecToUnit.Length()) { VecToUnit /= VecToUnit.Length(); }
		return VecToUnit;
	}
	
	vector2 SafeUnit2(Vector2 VecToUnit)
	{
		if(VecToUnit.Length()) { VecToUnit /= VecToUnit.Length(); }
		return VecToUnit;
	}

    bool HookLOS()
	{
		Float LOSPitch = atan2(Rope.XY.Length(), Rope.Z) - 90;
		Float LOSAngle = VectorAngle(Rope.X, Rope.Y);
		FLineTraceData LOSCheck; LineTrace(LOSAngle, Rope.Length(), LOSPitch, TRF_SOLIDACTORS|TRF_BLOCKSELF, Height / 2.f, data: LOSCheck);
		
		if(GrappledMonster != Null && LOSCheck.HitActor == GrappledMonster) { return true; }
		
		return LOSCheck.Distance == Rope.Length();
	}
	
	void GrapplingMove()
	{
		{ Grappled = True; }
		
		//Fun is over kids, go home
		if(bNOGRAVITY || Rope.Length() <= 4.f * Radius || !CheckMove(Pos.XY + Vel.XY) || (lasttickrope && rope.length() > (lasttickrope + 30)))
		{
			StopHook();
			return;
		}
		lasttickrope = rope.length();
		
		Usercmd cmd = player.cmd;
		GrappleVel = SafeUnit3(Rope) * GrappleVel.Length();
		Vel = GrappleVel;
		If(cmd.sidemove > 0)
		{
			grapplesidespeed = grapplesidespeed + 2;
		}
		else if(cmd.sidemove < 0)
		{
			grapplesidespeed = grapplesidespeed - 2;
		}
		Acceleration.XY = RotateVector((0, -grapplesidespeed), Angle);
		//
		double currentvel = vel.length();
		vel.xy = (vel.xy + acceleration.xy);
		
		
		//console.printf("%i",rope.length());
		If(!cmd.sidemove && grapplesidespeed > 0)
		{
			grapplesidespeed = grapplesidespeed - 2;
		}
		Else if (!cmd.sidemove && grapplesidespeed < 0)
		{
			grapplesidespeed = grapplesidespeed + 2;
		}
			
	}
	
    void StopHook(bool severed = false)
	{
		if(GrappledMonster) A_StartSound(severed ? "MHKRTRCT" : "MHKSTP", CHAN_AUTO);
		if(severed) vel += GrappleVel;
		Rope = GrappleVel = (0, 0, 0);
		PendulumLength = 0;
		GrappledMonster = Null;
		grapplesidespeed = 0;
		lasttickrope = 0;
		
	}

	Override void HandleMovement() 
    {
		super.HandleMovement();
        if(GrappleVel.Length())
        {
            takeinventory("meathook",1);
            GrapplingMove();
        }
		Else
        {
            giveinventory("meathook",1);
            Grappled = False; 
        }
    } 

    // The 400 and 1600 are arbitrary numbers
    // I think they're used for the crosshairs
	Override void Tick()
    {
        super.Tick();

        FLineTraceData lt;
        If(player)
        {
            LineTrace(angle, 400, pitch, 0, player.viewz-pos.z, 0, data:lt);
            
            aimpos = lt.HitLocation;
            aimActor = lt.HitActor;
            if(1600 > 0)
            {
                aimActor2 = null;
                double lastAim = -1;
                BlockThingsIterator CheckForTargets = BlockThingsIterator.create(Self,1600); 
                Actor CurrentActor; //A pointer to whatever actor the iterator is iterating through.
                While (CheckForTargets.Next()) 
                {
                    CurrentActor = CheckForTargets.Thing;
                    If(CurrentActor && (CurrentActor.bIsMonster && currentactor.bshootable && !currentactor.bfriendly || currentactor is "PBXCore_Player") && CheckSight(CurrentActor,SF_IGNOREWATERBOUNDARY) && currentactor != self)
                    {
                        vector3 targetpos = LevelLocals.SphericalCoords((pos.x,pos.y,player.viewz),currentactor.pos+(0,0,currentactor.default.height*0.5),(angle,pitch));
                        let tr = new("HookTracer");
                        if(tr)
                        {
                            tr.Trace((pos.x,pos.y,player.viewz),cursector,(AngleToVector(angle - targetpos.x, cos(pitch - targetpos.y)), -sin(pitch - targetpos.y)),1600,0,ignore:self);
                            if (tr.results.HitActor == CurrentActor && abs(targetpos.x) <= CurrentActor.Radius * 2 / (Distance3D(CurrentActor) / 100) && abs(targetpos.y) <= CurrentActor.Height / (Distance3D(CurrentActor) / 100) && (lastAim == -1 || abs(targetpos.x) + abs(targetpos.y) <= lastAim))
                            {
                                lastAim = abs(targetpos.x) + abs(targetpos.y);
                                aimActor2 = currentactor;
                            }
                        }
                    }
                }
            }
        }
    }
}

Class Hook : Actor
{
	Default
	{
		+FORCEXYBILLBOARD;
		+HITMASTER;
		+MISSILE;
		+NOGRAVITY;
		+NOTELEPORT;
		+puffonactors;
		+NOTONAUTOMAP;
		+THRUSPECIES;
		+dontcorpse;
		+explodeonwater;
		Damagefunction 0;
		+nodamagethrust;
		Height 4;
		Radius 10;
		Speed 1;
		Species "Hook";
		+puffgetsowner;
		+NOTIMEFREEZE;
	}
	
	vector3 HookToPlayer;
	vector3	HookToMonster;
	int		MonsterSpeed;
	int		MonsterFloatSpeed;
	float maxdistnew;
	//bool bisflaming;
	
	vector3 SafeUnit3(Vector3 VecToUnit)
	{
		if(VecToUnit.Length()) { VecToUnit /= VecToUnit.Length(); }
		return VecToUnit;
	}
	
	vector2 SafeUnit2(Vector2 VecToUnit)
	{
		if(VecToUnit.Length()) { VecToUnit /= VecToUnit.Length(); }
		return VecToUnit;
	}
	
	Override void Tick()
	{
		//bool isflaming = false;
		
		Let HookOwner = PBXCore_Player(Target);
		if(HookOwner)
		{
			Vector3 WaistPos = (HookOwner.Pos.X, HookOwner.Pos.Y, HookOwner.Pos.Z + HookOwner.Height / 2.f); // player position
			HookToPlayer = Pos - WaistPos; //hook-to-player vector
		}
		
		Super.Tick();
		UpdateTrail();
	}
	
	void UpdateTrail()
	{
		int b;
		for(b = 1; b <= 14; b++)
		{
			ActorIterator BallOfSteele = Level.CreateActorIterator(84115 + b);
			Actor Ball = BallOfSteele.Next();
			
			if(Ball != Null)
			{
				//Set trail velocity
				Vector3 TargetPos = Pos - (HookToPlayer * b / 15.f);
				Ball.Vel = TargetPos - Ball.Pos;
			}
		}
	}
	
	void InitiateGrapple(Bool Monster)
	{
		Let HookOwner = PBXCore_Player(Target);
		
		Float	PushLength = 4 * 5.5;
		Vector3 HookPush = SafeUnit3(HookToPlayer) * PushLength;
		Float 	HookSpeed = max((HookPush).Length(), PushLength);
		HookOwner.Rope = HookToPlayer; //needed for the LOS check
		
		HookSpeed = HookOwner.MaxAirSpeed = min(HookSpeed, 24);
		HookOwner.Vel = HookOwner.GrappleVel = HookSpeed * SafeUnit3(HookPush);
		
		//Hooking monsters specific
		if(Monster)
		{
			Let Monster = Actor(Master);
			If(!monster.bnoblood)
			    Monster.spawnblood(pos,angle,1);

			monster.a_pain();
			PBXCore_Player(Target).GrappledMonster = Monster;
			SetMonsterSpeed(False);
			A_StartSound("HookMeat", 7);
		}
		else
			A_StartSound("HookWall", 7);
	}
	
	void SetMonsterSpeed(Bool Reset)
	{
		Let Monster = Actor(Master);
	}
	
	void SpawnTrail()
	{
		int h;
		for(h = 1; h <= 14; h++)
		{		
			A_SpawnItemEx("HookTrail",0,0,0,0,0,0,0,SXF_ISTRACER|SXF_SETTARGET|SXF_ORIGINATOR|SXF_NOCHECKPOSITION);
			Let SlaveTrail = HookTrail(Tracer);
			SlaveTrail.ChangeTid(84115 + h);
		}
	}

	States
	{
	//====================================
	//Hook is traveling through space
	Spawn:
		OCLW A 0 NoDelay {
        	PBXCore_Debug.Print("Hook Spawned");
			Let HookOwner = PBXCore_Player(Target);
			A_AlertMonsters();
			
			if (target && target.target)
			{//ensure that the shooter even has a target
				SetOrigin(target.target.pos+(0,0,target.target.height*0.5),false);
				target.a_cleartarget();
			}
			SpawnTrail();
		}
	Looper:
		OCLW A 1 {
			Let HookOwner = PBXCore_Player(Target);
        	PBXCore_Debug.Print("Hook is Flying");
		}
		Goto despawnhook;
	
	//====================================
	//Hook hit a wall or ceiling
	TillDeathDoesUsApart:
		OCLW A 1 {
        	PBXCore_Debug.Print("Hook Hit a Wall");
			Let HookOwner = PBXCore_Player(Target);
			if(!HookOwner.GrappleVel.Length() || !HookOwner)
			{
				SetState(FindState("DespawnHook"));
				return;
			}
			
			if(HookOwner)
			{
				Vector3 WaistPos = (HookOwner.Pos.X, HookOwner.Pos.Y, HookOwner.Pos.Z + HookOwner.Height / 2.f); // player position
				HookToPlayer = Pos - WaistPos; //hook-to-player vector
			}
			UpdateTrail();		
			HookOwner.Rope = HookToPlayer;
		}
		Loop;
	XDeath:
		OCLW A 1 {
        	PBXCore_Debug.Print("Hook XDeath");
			Let HookOwner = PBXCore_Player(Target);
			//SpawnTrail();
			Let Monster = Actor(Master);
			InitiateGrapple(True); 
			maxdistnew = HookToPlayer.length();
		}
	
	TillXDeathDoesUsApart:
		OCLW A 1 {
			Let HookOwner = PBXCore_Player(Target);
			Let Monster = Actor(Master);
			If (monster)
				setorigin(monster.pos+(0,0,monster.height*0.5),TRUE);
			
			if(!HookOwner || !Monster || Monster.health <=0)
				return resolvestate("despawnhook");
			if(!HookOwner.GrappleVel.Length())
				return resolvestate("Death");

			if(HookOwner)
			{
				Vector3 WaistPos = (HookOwner.Pos.X, HookOwner.Pos.Y, HookOwner.Pos.Z + HookOwner.Height / 2.f); // player position
				HookToPlayer = Pos - WaistPos; //hook-to-player vector
			}
			UpdateTrail();
			a_startsound("MHKLOOP",194,CHANF_LOOPING,0.5,ATTN_NONE);
			Vel = Monster.Vel;
			HookOwner.Rope = HookToPlayer;
			Return resolvestate(null);
		}
		Loop;
		
	//====================================
	//Die Monster! You don't belong in this world
	Death:
		OCLW AAA 0 {
        	PBXCore_Debug.Print("Hook Death");
			Let HookOwner = PBXCore_Player(Target);
			a_stopsound(194);
			Let Monster = Actor(Master);
			if(Monster && MonsterSpeed) { SetMonsterSpeed(True); }
		}
		Stop;
		
	DespawnHook:
		OCLW A 0 {
        	PBXCore_Debug.Print("Hook Despawned");
			Let HookOwner = PBXCore_Player(Target);
			if(HookOwner)
			{
				HookOwner.StopHook(true);
				HookOwner.a_startsound("MHKSTP",194,CHANF_DEFAULT,1,ATTN_NONE);
			}
			a_stopsound(194);
			Let Monster = Actor(Master);
			if(Monster && MonsterSpeed) { SetMonsterSpeed(True); }
		}
		Stop;
	}
}

Class HookTrail : Actor
{
	Default
	{
		+FORCEXYBILLBOARD;
		+MISSILE;
		+NOGRAVITY;
		+NOTELEPORT;
		+NOTONAUTOMAP;
		+THRUSPECIES;
		+ExplodeOnWater;
		Radius 2;
		Height 4;
		Scale 0.5;
		Species "HookTrail";
		+NOTIMEFREEZE;
	}
	
	States
	{
		Spawn:
		Looper:
			TEND A 1 {
				if(!Hook(Target))
				{
					SetState(FindState("DespawnTrail"));
					return;
				}
			}
			Loop;
			
		Death:
			TEND A 1 {
				if(!Hook(Target))
				{
					SetState(FindState("DespawnTrail"));
					return;
				}
			}
			Loop;
			
		DespawnTrail:
			Stop;
	}
}

Class Speedline : Actor
{
	Default
	{
		+nogravity;
		Renderstyle "Add";
		Alpha 0.2;
		+noteleport;
		+noclip;
	}

	States
	{
		Spawn:
			TNT1 A 0 NODELAY A_recoil(30);
			TRAC A 5;
		Spawn2:
			TRAC A 1 A_FadeOut(0.10);
			LOOP;
	}
}

class HookTracer : LineTracer
{
	override ETraceStatus TraceCallback()
	{
		if(results.HitType == TRACE_HitActor && (results.hitActor.bIsMonster && results.hitActor.bshootable && !results.hitActor.bfriendly || results.hitActor is "PBXCore_Player"))
			return TRACE_Stop;
		else
			return TRACE_Skip;
	}
}