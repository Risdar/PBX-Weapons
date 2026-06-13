extend class PBX_BDPRailgun
{
    override void PostBeginPlay()
    {
        LockedOn = false;
        scopeMode = 0;
        zoomstrength = LOWZOOM;
		laserActive  = false;
        Super.PostBeginPlay();
    }

        override void DoEffect() 
	{
		super.DoEffect();

        if (level.frozen) return;
        
        // Check if the player exists and if the current weapon they're using is the blaster
		If(	owner.player && owner.player.readyweapon.GetClass() is self.GetClass())
        {
            // Get a pointer to it
            let weap = PBX_BDPRailgun(owner.player.readyweapon);
            if(!weap) return;

			// Get a pointer to PSprite
			let psp = owner.player.FindPSprite(PSP_WEAPON);
			if(!psp) return;

            if(!weap.laserActive) return;

            // Dont spawn the laser sight if the weapon is in one of these states
            static const StateLabel blockedStates[] = {
                "Pumping", "FinishPump", "FinishPump2", "Reload",
                "ShellChecker", "ReloadFinished", "ReloadFromPump", "ReloadFromPumpInsertShells",
                "FinishReloadFromPump", 

                "WeaponRespect", "Deselect", "SelectAnimation",
                "FlashPunching", "FlashKicking", "FlashAirKicking", "FlashSlideKicking", "FlashSlideKickingStop"
            };

            for (int i = 0; i < blockedStates.Size(); i++)
            {
                if (InStateSequence(psp.curstate, ResolveState(blockedStates[i])) && !InStateSequence(psp.curstate, ResolveState("Ready3"))) 
                    return;
            }

            // Spawn the laser sight
            double pz = owner.height * 0.5 - owner.floorclip + owner.player.mo.AttackZOffset*owner.player.crouchFactor;
            FLineTraceData lasersight;
            owner.LineTrace(owner.angle, 
                4096, 
                owner.pitch, 
                TRF_SOLIDACTORS|TRF_THRUHITSCAN, 
                offsetz: pz, 
                data: lasersight
            );

            Spawn("PBX_BlueDot", lasersight.HitLocation);
		}
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
                if(invoker.ScopeMode == 2)
                {
                    // player.PSprites.frame = 1;
                    PBXWeapons_ScopeHandler.SendInterfaceEvent(self.PlayerNumber(), "PrintScopeData_Blue:"..Bule.HitActor.GetTag(), Bule.HitActor.health, Bule.HitActor.GetSpawnHealth(), Bule.HitActor.PainChance);
                    PBXWeapons_ScopeHandler.SendInterfaceEvent(self.PlayerNumber(), "PrintScopeData2:", Distance3D(Bule.HitActor), getZoomStrength());
                }
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

    action state Railgun_HandleSpecial()
    {
        // Get the tokens
        bool toggleLaser    = FindInventory("platrailgun_goLaser");
        bool toggleZoom     = FindInventory("platrailgun_goZoom");
        bool toggleScope    = FindInventory("platrailgun_goScope");
        bool toggleNVG      = FindInventory("platrailgun_goNVG");
        bool goHolo         = FindInventory("platRailgun_goHolo");


        // Actual Mode Switch
        if (toggleLaser)
        {
            if(invoker.laserActive) invoker.laserActive = false;
            else invoker.laserActive = true;
            A_StartSound("MS/Button", CHAN_AUTO, CHANF_OVERLAP);
            A_Print(invoker.laserActive ? "$PBX_LaserOn" : "$PBX_LaserOff");

        }
        if(toggleScope)
        {
            invoker.ScopeMode = (invoker.ScopeMode + 1) % 3;
            A_StartSound("MS/Button", CHAN_WEAPON);
            A_SetBlend(0x00a100, 0.2, 3);
            switch (invoker.ScopeMode)
            {
                case 0: A_Print("$PBX_Scope1"); break;
                case 1: A_Print("$PBX_Scope2"); break;
                case 2: A_Print("$PBX_Scope3"); break;
            }
        }
        if (toggleZoom)
        {
            if(getZoomStrength() == HIGHZOOM) {
                A_StartSound("BEPBEP");
				setZoomStrength(LOWZOOM);
				A_Print("$PBX_Zoom30");
			}
			else {
                A_StartSound("BEP");
				setZoomStrength(HIGHZOOM);
				A_Print("$PBX_Zoom90");
			}
        }

        if(toggleNVG)
        {
            if(invoker.nvgActive) {
                invoker.nvgActive = false;
				A_Print("$PBX_nvgOff");
                A_SetInventory("PBX_Infrared", 0);
            }
            else {
                invoker.nvgActive = true;
				A_Print("$PBX_nvgOn");
                A_SetInventory("PBX_Infrared", 1);
                A_StartSound("RA1IF1", CHAN_AUTO, CHANF_OVERLAP);
            }
            A_SetBlend("Black",0.75,16);
        }

        if(goHolo)
        {
            A_startsound("bepbep",4);
            A_SpawnHologram();
        }

        // Always clear the tokens
        cleanmodetokens();
        return resolvestate("Ready2");
    }

    action void cleanmodetokens()
    {
        A_SetInventory("platrailgun_goLaser", 0);
        A_SetInventory("platrailgun_goZoom",  0);
        A_SetInventory("platrailgun_goScope", 0);
        A_SetInventory("platrailgun_goNVG",   0);
        A_SetInventory("platRailgun_goHolo",  0);
    }

    action double getZoomStrength()
    {
        return invoker.zoomstrength;
    }
    
    action void setZoomStrength(int set)
    {
        invoker.zoomstrength = set;
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