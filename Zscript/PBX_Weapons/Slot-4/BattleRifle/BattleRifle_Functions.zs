extend class PBX_BDPBattleRifle
{
    mixin PBX_LaserSight;

	static const StateLabel blockedLaserStates[] = {
		"Reload", "ReloadFromADS", "ContinueReload", "RaiseFromEmpty",
		"Unload", "SwitchAnimation","WeaponRespect", "Deselect", "SelectAnimation",
		"FlashPunching", "FlashKicking", "FlashAirKicking", "FlashSlideKicking", "FlashSlideKickingStop"
	};

//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////
	override void postbeginplay()
	{
		LockedOn 	 = false;
		semiClear 	 = false;
		laserActive  = false;
		isSemiAuto 	 = true;
		zoomstrength = LOWZOOM;
        scopeMode = 0;
		super.postbeginplay();
	}

	override void DoEffect() 
	{
		super.DoEffect();

        if (level.isFrozen()) return;
        
        // Check if the player exists and if the current weapon they're using is the blaster
		If(	owner.player && owner.player.readyweapon.GetClass() is self.GetClass())
        {
            // Get a pointer to it
            let weap = PBX_BDPBattleRifle(owner.player.readyweapon);
            if(!weap || !weap.laserActive) return;
           	PBX_SpawnLaserSight("PBX_GreenDot");
		}
    }
    
//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////
	action void cleanmodetokens()
	{
		A_SetInventory("BR_Select_Scope",0);
		A_SetInventory("BR_Select_NVG",0);
		A_SetInventory("BR_Select_FireMode",0);
		A_SetInventory("BR_Select_Zoom",0);
		A_SetInventory("BR_Select_Laser",0);
	}

	action double getZoomStrength()
	{
		return invoker.zoomstrength;
	}

	action void setZoomStrength(double set)
	{
		invoker.zoomstrength = set;
	}

	action bool getSemiAuto()
	{
		return invoker.isSemiAuto;
	}

    action void BR_ReadyScope()
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
                let Wireframe = Spawn("PBX_CubeRadius", Bule.HitActor.pos);
                if(Wireframe)
                {
                    Wireframe.scale.x = double(Bule.HitActor.Radius) * 2;
                    Wireframe.scale.Y = double(Bule.HitActor.Height) * Level.pixelstretch;
                    Wireframe.vel = Bule.HitActor.vel;
                }
                if(invoker.ScopeMode == 2)
				{
					PBXWeapons_ScopeHandler.SendInterfaceEvent(self.PlayerNumber(), "PrintScopeData:"..Bule.HitActor.GetTag(), Bule.HitActor.health, Bule.HitActor.GetSpawnHealth(), Bule.HitActor.PainChance);
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

    action int getBRMag()
    {
        return CountInv(invoker.ammotype2);
    }

	action bool PlayerPressedOnce(int button)
	{
		int bt = player.cmd.buttons;
		int oldbt = player.oldbuttons;
		if((bt & button) && !(oldbt & button))
			return true;
		return false;
	}

	// Ricochet function from BDP
    Action void a_FireBattleRifle()
	{
		FLineTraceData ricochetdata;
		invoker.owner.LineTrace(invoker.owner.angle, 4096, invoker.owner.pitch, TRF_SOLIDACTORS, offsetz: invoker.owner.player.viewz - invoker.owner.pos.z, data: ricochetdata);
		vector3 hitNormal;
		if(ricochetdata.HitType == TRACE_HitWall )
		{
			if(!ricochetdata.LineSide)
			{
				hitnormal = (ricochetdata.Hitline.delta.y, -ricochetdata.Hitline.delta.x, 0).unit();
			}
			else
			{
				hitnormal = (-ricochetdata.Hitline.delta.y, ricochetdata.Hitline.delta.x, 0).unit();
			}
			
		}
		else if (ricochetdata.HitType == TRACE_HitFloor)
		{
			hitnormal = ricochetdata.HitSector.FloorPlane.normal;
			
		}
		else if (ricochetdata.HitType == TRACE_HitCeiling)
		{
			hitnormal = ricochetdata.HitSector.CeilingPlane.normal;
		}
		Vector3 PlayerAngle = BDPMATH.AngletoVector3(1.0,invoker.owner.angle,invoker.owner.pitch);
		
		Vector3 BounceAngle = BDPMATH.BounceNormal(PlayerAngle,hitNormal);
		
		Double NextShotAngle;
		Double NextShotPitch;
		
		
		
		[NextShotAngle, NextShotPitch] = BDPMATH.Vector3toangles(BounceAngle);

		double anglediff = BDPMath.AngleDiff(invoker.owner.angle % 360.0,nextshotangle % 360.0);
		double pitchdiff = BDPMath.AngleDiff(invoker.owner.pitch % 360.0,nextshotpitch % 360.0);
		//Console.printf("%f",anglediff);
		
		
		Vector3 NextShotPosition = level.Vec3Offset(ricochetData.hitlocation, hitnormal * 2.0);
		
		//A_FireBullets (0, 0, -1, 25, "BR45BulletPuff", FBF_NORANDOM,8192,"decorativetracer",-12);
		PB_FireBullets("PB_762x51mm", 1, frandom(-0.1, 0.1), 0, 0, frandom(-0.1, 0.1));
        PB_SpawnCasing("PB_EmptyBrass",22,2,28,Frandom(-2, -1),Frandom(5,8),Frandom(3,4));
		If(pitchdiff > 45 || anglediff > 45 || pitchdiff < -45 || anglediff < -45)
		{
			return;
		}
		If(ricochetdata.HitType == TRACE_HitWall || ricochetdata.HitType == TRACE_HitFloor || ricochetdata.HitType == TRACE_HitCeiling)
		{
			Invoker.Owner.LineAttack(NextShotAngle,8192,NextShotPitch,35,"Pistol","BR45BulletPuff",LAF_ABSPOSITION | LAF_ABSOFFSET,null,NextShotPosition.Z,NextShotPosition.x,NextShotPosition.y);
			let ricochettracer = Invoker.owner.spawn("decorativetracer",nextshotposition);
			If(ricochettracer)
			{
				ricochettracer.angle = nextshotangle;
				ricochettracer.pitch = nextshotpitch;
				ricochettracer.vel3dfromangle(140,nextshotangle,nextshotpitch);
			}
			
		}
	}

    // FIRE FUNCTION
	action void FireWeapon()
	{
		// Set up Variables
		bool ads 	  = PB_GetZoom();
		double recoil = ads ? -1.5 : -3;
		double smoke  = ads ? -2   : -1;
		double zoom	  = ads ? getZoomStrength() : 1.0;

		A_AlertMonsters();
		PB_DynamicTail("lmg", "lmg");

		// Firing Logic, basically check if the player has the upgrade or not
		if(countinv("BattleRifle_Upgraded") > 0 || (pbxweapons_backpack_filter & DisablePBX_BattleRifleUpgrade)) {a_FireBattleRifle();}
		else {
			PB_FireBullets("PB_762x51mm", 1, frandom(-0.1, 0.1), 0, 0, frandom(-0.1, 0.1));
        	PB_SpawnCasing("PB_EmptyBrass",22,2,28,Frandom(-2, -1),Frandom(5,8),Frandom(3,4));
		}

		// Everything Else
		PB_LowAmmoSoundWarning("default");
		pb_takeammo(invoker.ammotype2,1,0);
		A_StartSound("BR45FIRE", CHAN_WEAPON, 0, 1.0, pitch: 1.2);
		invoker.burstcount++;
		PB_IncrementHeat(4);

		// if(ads) A_SetInventory("CantDoAction",1);
		
		PB_GunSmoke(0,0,smoke);
		PB_WeaponRecoil(recoil,frandom(-0.3,0.3));
		A_ZoomFactor(zoom, SPF_INTERPOLATE);
	}

	action state checkSpecial()
	{
		bool toggleFireMode 	= countinv("BR_Select_FireMode")  	> 0;
		bool toggleZoom  		= countinv("BR_Select_Zoom")  		> 0;
		bool toggleLaser 		= countinv("BR_Select_Laser")  		> 0;
		bool toggleScope 		= countinv("BR_Select_Scope")  		> 0;
		bool toggleNVG 			= countinv("BR_Select_NVG")  		> 0;

		if(countinv("PBX_CloseWheel") > 0)
		{
			A_TakeInventory("PBX_CloseWheel",1);
			return resolvestate("Ready3");
		}

		if(toggleFireMode)
		{
			if(!invoker.isSemiAuto) invoker.isSemiAuto = true;
			else invoker.isSemiAuto = false;
			A_Print(invoker.isSemiAuto ? "$PB_FIREMODE_SEMI" : "$PB_FIREMODE_BURST");
		}

		if(toggleZoom)
		{
			if(getZoomStrength() == HIGHZOOM) {
				setZoomStrength(LOWZOOM);
				A_Print("$PBX_Zoom20");
			}
			else {
				setZoomStrength(HIGHZOOM);
				A_Print("$PBX_Zoom40");
			}
		}

		if (toggleLaser)
        {
            if(invoker.laserActive) invoker.laserActive = false;
            else invoker.laserActive = true;
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

		// Always remove the tokens regardless
		cleanmodetokens();

		// Play sound when opening the wheel in ADS
		if(PB_GetZoom())
		{
			A_StartSound("MS/Button", 26); 
			return resolvestate("Ready2");
		}

		// Fallthrough to Switch Animation
		// The mode switch sound is played there
		return resolvestate(null);
	}
}