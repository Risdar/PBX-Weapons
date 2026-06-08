extend class PBX_BDPRailgun
{
    override void PostBeginPlay()
    {
        LockedOn = false;
        scopeZoom = false;
        Super.PostBeginPlay();
    }

    action void doScope()
    {
        FLineTraceData Bule;
        bool hit = LineTrace(Angle, 6000, Pitch, 0, player.ViewHeight, 0, 0, Bule); //Line to kick enemy or wall
        if(hit)
        {
            if(Bule.HitActor && Bule.HitActor.bISMONSTER && Bule.HitActor.bFRIENDLY == false && Bule.HitActor is "PB_Monster")
            {	
                if(!invoker.LockedOn)
                {
                    // A_SetBlend(0x00a100, 0.2, 3);
                    invoker.LockedOn = true;
                    A_StartSound("IronSights", CHAN_WEAPON, pitch:1.4);
                }
                //show the actor's wireframe
                let Wireframe = Spawn("PBX_CubeRadiusCyan", Bule.HitActor.pos);
                if(Wireframe)
                {
                    Wireframe.scale.x = double(Bule.HitActor.Radius) * 2;
                    Wireframe.scale.Y = double(Bule.HitActor.Height) * Level.pixelstretch;
                    Wireframe.vel = Bule.HitActor.vel;
                }
                // player.PSprites.frame = 1;
                PBXWeapons_ScopeHandler.SendInterfaceEvent(self.PlayerNumber(), "PrintScopeData_Blue:"..Bule.HitActor.GetTag(), Bule.HitActor.health, Bule.HitActor.GetSpawnHealth(), Bule.HitActor.PainChance);
                PBXWeapons_ScopeHandler.SendInterfaceEvent(self.PlayerNumber(), "PrintScopeData2:", Distance3D(Bule.HitActor), getZoomStrength());
            }
            else
            if(invoker.LockedOn)
            {
                // A_SetBlend(0xa19900, 0.2, 3);
                invoker.LockedOn = false;
                A_StartSound("IronSights", CHAN_WEAPON, pitch:1.3);
            }
        }
        // return A_DoPBWeaponAction();
    }

    action double getZoomStrength()
    {
        return invoker.scopeZoom ? highfactor : lowfactor;
    }

    action void A_GunLight(int intensity = 500, int alivetime = 2, int lightr = 255, int lightg = 237, int lightb = 162)
	{
		{
			BDP_Gunlight SelfLight1 = BDP_Gunlight(Spawn("BDP_Gunlight",(invoker.owner.pos.x, invoker.owner.pos.y, invoker.owner.pos.z + invoker.owner.player.viewheight),false));
			SelfLight1.args[DynamicLight.LIGHT_RED] = lightr; //R
			SelfLight1.args[DynamicLight.LIGHT_GREEN] = lightg; //G
			SelfLight1.args[DynamicLight.LIGHT_BLUE] = lightb; //B
			SelfLight1.args[DynamicLight.LIGHT_INTENSITY] = intensity; //Intensity
			SelfLight1.SpotInnerAngle = 60;
			SelfLight1.SpotOuterAngle = 90;
			SelfLight1.angle = invoker.owner.angle;
			SelfLight1.pitch = invoker.owner.pitch;
			SelfLight1.alivetime = alivetime;
		}
	}

    action state A_PressingReload()
	{
		if ((player.cmd.buttons & BT_RELOAD) || (player.oldbuttons & BT_RELOAD)) return resolvestate("ReloadFromPump");
			//console.printf("YeeHaw");
		else return resolvestate(null);
	}

    action void A_Recoil3D(double amt)
	{
		vel += BDPMath.VecFromAngles(angle, pitch, -amt);
	}

    action void A_HandleScope()
	{
		if(!invoker.scopeZoom)
		{
			A_StartSound("BEP");
			invoker.scopeZoom = true;
		}
		else
		{
			A_StartSound("BEPBEP");
			invoker.scopeZoom = false;
		}
		A_ZoomFactor(getZoomStrength());
	}

    Action void a_spawnhologram()
	{
		A_radiusgive("KillHologram",10000,RGF_MONSTERS | RGF_NOSIGHT,1,"HoloPlayer");
		FLineTraceData lasersight;
        LineTrace(angle, 4096, pitch, TRF_SOLIDACTORS|TRF_THRUHITSCAN, offsetz: player.viewz - pos.z, data: lasersight);
        vector3 targetpos = lasersight.HitLocation;
        if (lasersight.HitLine)
        {
            vector2 wallnormal = (-lasersight.HitLine.delta.y,lasersight.HitLine.delta.x).unit();
            if (!lasersight.LineSide)
            wallnormal *= -1;
            targetpos += (wallnormal * 18);
        }
        if (lasersight.hittype == trace_hitceiling)
        {
            targetpos.z -= 13;
        }
        Let HoloTarget = Spawn("Holotarget",targetpos);
        Let HoloPlayer = Spawn("Holoplayer",pos);
        If(HoloTarget && HoloPlayer)
        {
            HoloPlayer.angle = angle;
            HoloPlayer.Tracer = Holotarget;
            HoloPlayer.Translation = Invoker.owner.Translation;
        }
	}
	
	Action void a_firenurailgun()
	{
		FLineTraceData railspawn;
        LineTrace(angle, 8192, pitch, TRF_NOSKY | TRF_THRUACTORS, player.viewz - player.mo.pos.z - 5, data: railspawn);
        if (railspawn.HitType != TRACE_HitNone)
        {
            vector3 targetpos = railspawn.HitLocation;
            if (railspawn.HitLine)
            {
                vector2 wallnormal = (-railspawn.HitLine.delta.y,railspawn.HitLine.delta.x).unit();
                if (!railspawn.LineSide)
                wallnormal *= -1;
                targetpos += (wallnormal * 3);
            }

            actor beam = Spawn("railgunrail", targetpos);
            if (beam)
            {
                beam.angle = angle;
                beam.pitch = pitch;
            }

            for (int i = 0; i < 20; i++)
            {
                actor rico = Spawn("ricochet", targetpos);
                if (rico)
                {
                    rico.angle = angle + 180;
                }
            }
        }
            
        Vector3 trailpos = (pos.x - railspawn.HitLocation.x, pos.y - railspawn.HitLocation.y, pos.z + player.viewz - player.mo.pos.z - 5 - railspawn.HitLocation.z);
        FSpawnParticleParams trail;
        for(int i = railspawn.distance; i > 0; i -= 2)
        {
            let trail = Level.SpawnVisualThinker("RailgunTrail");
            trail.pos = railspawn.HitLocation + trailpos * (i/railspawn.distance);
            trail.pos += (frandom(1,-1),frandom(1,-1),frandom(1,-1));
        }
        
        PB_SetChamberEmpty(true);
        
        PB_IncrementHeat(10);
        A_Fireprojectile("RailgunProjectile", 0, 0, 0, 0);
        A_alertmonsters(500);
        A_RailAttack(bdpraildamage, 0, 0, "", "", 0, 0, "RailgunPuff1");
        A_Fireprojectile ("PlasmaSmoke", 0, 0, 0, 2);
        A_StartSound("RAILF01", 1);
        PB_TakeAmmo(invoker.ammotype2,1,0);
        PB_WeaponRecoil(6,0);
        if(invoker.owner.pos.z <= invoker.owner.floorz) {
            A_Recoil3d(3);
        }
        else {
            A_Recoil3d(20);
        }
    }
}