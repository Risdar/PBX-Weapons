extend class PBX_BDPRailgun
{
    mixin PBX_LaserSight;

    static const StateLabel blockedLaserStates[] = {
        "Pumping", "FinishPump", "FinishPump2", "Reload",
        "ShellChecker", "ReloadFinished", "ReloadFromPump", "ReloadFromPumpInsertShells",
        "FinishReloadFromPump", "ReloadFromADS",

        "WeaponRespect", "Deselect", "SelectAnimation",
        "FlashPunching", "FlashKicking", "FlashAirKicking", "FlashSlideKicking", "FlashSlideKickingStop"
    };

	override void PBX_DoEffectWeaponReady()
    {
		PBX_SpawnLaserSight(PBX_LaserSightProjectile.BLUE_DOT);
    }

    override void DoEffect() 
	{
		super.DoEffect();
        if (level.isFrozen()) return;
        if(!owner || !owner.player || !owner.player.readyweapon) return;

        // So it always recharge even when not selected
        if(hologramCooldown > 0 && level.time % TICRATE == 0)
        {
            hologramCooldown--;
            if(hologramCooldown == 0)
            {
                PBXCore_Debug.Print("Hologram Cooldown finished");
                owner.A_StartSound("BEPBEP", CHAN_WEAPON, pitch:1.4);
            }
        }
    }

    action state Railgun_HandleSpecial()
    {
        // Get the tokens
        bool toggleLaser 		= countinv("PBX_Toggle_Laser")  	> 0;
		bool toggleScope 		= countinv("PBX_Toggle_Scope")  	> 0;
		bool toggleNVG 			= countinv("PBX_Toggle_NVG")  		> 0;
		bool goHolo 			= countinv("platRailgun_goHolo")  	> 0;

        if(countinv("PBX_CloseWheel") > 0)
		{
            cleanmodetokens();
			return resolvestate("Ready2"); // Since the wheel can only be accessed from ADS
		}

        // Actual Mode Switch
        if(toggleLaser)	PBX_ToggleLaserSight(skipPlaySound:true);
		if(toggleScope) PBX_ToggleSmartScope();
		if(toggleNVG) 	PBX_ToggleNightVision();

        if(goHolo)
        {
            A_startsound("bepbep",4);
            A_SpawnHologram();
        }

        A_StartSound("BEP", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
        // Always clear the tokens
        cleanmodetokens();
        return resolvestate("Ready2");
    }

    action void cleanmodetokens()
    {
        A_SetInventory("PBX_Toggle_Scope",0);
		A_SetInventory("PBX_Toggle_NVG",0);
		A_SetInventory("PBX_Toggle_Laser",0);
		A_SetInventory("PBX_CloseWheel",0);
        A_SetInventory("platRailgun_goHolo",0);
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

    Action void a_spawnhologram()
	{
        if(invoker.hologramCooldown > 0)
        {
            A_startsound("weapons/carbine/respectbeep",4);
            A_Print("$PBX_BDPRailgun_NoHologram");
            return;
        }

        invoker.hologramCooldown = PBXCore_Duration.GetByCVarInSeconds("pbxweapons_hologram_cooldown");

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

            actor beam = Spawn("PBX_RailgunRail", targetpos);
            if (beam)
            {
                beam.angle = angle;
                beam.pitch = pitch;
            }

            for (int i = 0; i < 20; i++)
            {
                actor rico = Spawn("ricochet", targetpos);
                if (rico)
                    rico.angle = angle + 180;
            }
        }
            
        Vector3 trailpos = (pos.x - railspawn.HitLocation.x, pos.y - railspawn.HitLocation.y, pos.z + player.viewz - player.mo.pos.z - 5 - railspawn.HitLocation.z);
        FSpawnParticleParams trail;
        for(int i = railspawn.distance; i > 0; i -= 2)
        {
            let trail = Level.SpawnVisualThinker("BDP_RailgunTrail");
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
        PB_WeaponRecoil(-6,0);
        if(invoker.owner.pos.z <= invoker.owner.floorz)
            A_Recoil3d(3);
        else
            A_Recoil3d(20);
    }
}