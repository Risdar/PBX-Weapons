extend class PBX_Excavator
{
//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////
    
	Override void DoEffect(){
		if (!owner || !owner.player)
        	return;

		let rw = PBX_Excavator(owner.player.ReadyWeapon);
		if (!rw)
        	return;

		bool pressingAlt = owner.player.cmd.buttons & BT_ALTATTACK;
		bool hasDetonator = owner.countinv("GrenadeDetonator") > 0;
		bool isInDropDrillMode = (rw.excavatorMode == eDrillChargeMode) || (rw.excavatorMode == eDropShotMode);
		
		if( self.GetClass() is rw.GetClass() && isInDropDrillMode)
		{
			if( pressingAlt && !hasDetonator )
			{
				owner.A_SetInventory("GrenadeDetonator",1);
				owner.A_PlaySound("excavator/detonate");
			}
			if( !pressingAlt && hasDetonator )
			{
				owner.A_SetInventory("GrenadeDetonator",0);
			}
		}
	}

	override void postbeginplay()
	{
		isUpgraded = false;
		excavatorMode = eDrillChargeMode;
		super.postbeginplay();
	}

//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////

	action void changeModeSprite(name bolamode, name sawmode)
    {
        int mode = getExcavatorMode();
        if(mode == eSawMode)
            A_SetWeaponSpriteEx(sawmode);
        else
            A_SetWeaponSpriteEx(bolamode);
    }

	action void checkUnloadedSprites(name unloadedBola,name unloadedSaw,name modeBola,name modeSaw)
	{
		if(PB_GetMagUnloaded())
			changeModeSprite(unloadedBola,unloadedSaw);
		else
			changeModeSprite(modeBola,modeSaw);
	}

	action void EX_HandleCrosshair()
	{
		int mode = getExcavatorMode();
		int crosshair = 75;
		switch(mode)
		{
			case eDrillChargeMode: 	crosshair = 78; break;
			case eDropShotMode: 	crosshair = 79; break;
			case eBolaMode: 		crosshair = 77; break;
			case eSawMode: 			crosshair = 75; break;
		}
		PB_HandleCrosshair(crosshair);
	}

	action int isExcavatorUpgraded()
	{
		bool hasUpgraded = countinv("Excavator_Upgraded") > 0;
		bool isDisabled = (PBXWeapons_backpack_filter & DisablePBX_ExcavatorUpgrade);
		return hasUpgraded || isDisabled || invoker.isUpgraded;
	}

    action int getExcavatorMode()
	{
		return invoker.excavatorMode;
	}
	
	action void setExcavatorMode(int mode = eDrillChargeMode)
	{
		invoker.excavatorMode = mode;
	}

    action void cleanmodetokens()
	{
		A_Takeinventory("EX_Select_DrillMode",1);
		A_takeinventory("EX_Select_DropMode",1);
		A_takeinventory("EX_Select_BolaMode",1);
		A_takeinventory("EX_Select_SawMode",1);
		A_takeinventory("EX_Select_No",1);
	}

	action void actualModeChange()
	{
		bool goDrop			= countinv("EX_Select_DropMode")  > 0;
		bool goDrill		= countinv("EX_Select_DrillMode") > 0;
		bool goSaw 			= countinv("EX_Select_SawMode")   > 0;
		if(goSaw)
		{
			setExcavatorMode(eSawMode);
			invoker.ReserveToMagAmmoFactor = AMMO_TAKE_SAW;
			invoker.ammo1 = Ammo(FindInventory("PB_Fuel"));
		}
		else
		{
			setExcavatorMode(goDrop ? eDropShotMode    :
							goDrill ? eDrillChargeMode :
							eBolaMode);
			invoker.ReserveToMagAmmoFactor = AMMO_TAKE_NORMAL;
			invoker.ammo1 = Ammo(FindInventory("PB_RocketAmmo"));
		}
		cleanmodetokens(); // Clear tokens
	}

	// This is called in Unload
	action state handleModeChange()
	{
		int mode			= getExcavatorMode();
		bool goDrop			= countinv("EX_Select_DropMode")  > 0;
		bool goDrill		= countinv("EX_Select_DrillMode") > 0;
		bool goBola			= countinv("EX_Select_BolaMode") > 0;
		bool goSaw			= countinv("EX_Select_SawMode") > 0;

		if(PB_GetMagUnloaded() && (goBola || goDrop || goDrill))
			return resolvestate("SwitchToBola");

		if(PB_GetMagUnloaded() && goSaw)
			return resolvestate("SwitchToSaw");

		return resolvestate(null);
	}

	action state handleSpecial()
	{
		A_Takeinventory("GoWeaponSpecialAbility",1);
		A_ZoomFactor(1.0);

		// Setup Variables
		int mode			= getExcavatorMode();
		bool goDrop			= countinv("EX_Select_DropMode")  > 0;
		bool goDrill		= countinv("EX_Select_DrillMode") > 0;
		bool goBola			= countinv("EX_Select_BolaMode") > 0;
		bool goSaw			= countinv("EX_Select_SawMode") > 0;
		bool alreadySelected =
		   (goDrop  && mode == eDropShotMode)
		|| (goDrill && mode == eDrillChargeMode)
		|| (goBola  && mode == eBolaMode)
		|| (goSaw   && mode == eSawMode);

		// Handlle Close Wheel
		if(countinv("PBX_CloseWheel") > 0)
		{
			A_TakeInventory("PBX_CloseWheel",1);
			if(isExcavatorUpgraded())
				return resolvestate("ready2");
			return resolvestate("Ready3");
		}

		// Handle Non-Upgraded
		if(countinv("EX_Select_No") > 0)
		{
			A_TakeInventory("EX_Select_No",1);
			A_Print("$PBX_ModeNotAvailable");
			return resolvestate("Ready3");
		}

		// Handle Already Selected
		if(alreadySelected)
		{
			A_print("$PBX_AlreadySelected");
			cleanmodetokens();
			if(isExcavatorUpgraded())
				return resolvestate("ready2");
			return resolvestate("ready3");
		}

		// If its from drop/drill and going to bola, just play a sound and go to ready2
		if(goBola && (mode == eDropShotMode || mode == eDrillChargeMode))
		{
			setExcavatorMode(eBolaMode);
			A_PlaySound("excavator/switch");
			A_Print("$PBX_Excavator_BolaMode");
			cleanmodetokens();
			return resolvestate("Ready2");
		}

		// If it goes to Bola or Saw mode, go to unload
		// the actual mode change is handled there
		if(goBola || goSaw)
		{
			A_Print(goBola ? "$PBX_Excavator_BolaMode" : "$PBX_Excavator_SawMode");
			return resolvestate("Unload_Upgraded");
		}
		
		// If its in saw mode and going to drop/drill
		// go to unload so it plays the saw to bola animation
		if(mode == eSawMode && (goDrop || goDrill))
		{
			return resolvestate("Unload_Upgraded");
		}

		// Handle drop/drill mode
		if(goDrop || goDrill)
		{
			setExcavatorMode(goDrop ? eDropShotMode : eDrillChargeMode);
			A_Print(goDrop ? "$PBX_Excavator_DropMode" : "$PBX_Excavator_DrillMode");
			cleanmodetokens();
			if(isExcavatorUpgraded())
			{
				A_PlaySound("excavator/switch");
				return resolvestate("ready2");
			}
			return resolvestate(null);
		}

		// If its not upgraded and going drop/drill, fallthrough
		// this will go to the standard mode switch animation
		return resolvestate(null);
	}

	action state checkAltfire()
	{
		int mode = getExcavatorMode();

		if(!isExcavatorUpgraded())
			return resolvestate("ready3");

		if(mode == eBolaMode || mode == eSawMode)
			return resolvestate(null);

		if(mode == eDrillChargeMode || mode == eDropShotMode)
			return resolvestate("ready2");
			
		return resolvestate(null);
	}
	
	action void FireWeapon(bool altfire = false)
	{
		A_AlertMonsters();
		A_WeaponOffset(0,32);
		PB_SetRoll(0);
		A_TakeInventory("PB_LockScreenTilt",1);

		A_FireCustomMissile("ShotgunParticles", random(-16,16), 0, -1, random(-9,9));
		A_FireBullets(0, 0, 1, 50, "shotpuff", 0, 130);
		PB_IncrementHeat(4);
		A_FireCustomMissile("RedFlareSpawn",-5,0,0,0);
		A_ZoomFactor(0.96);
		EX_HandleCrosshair();
		
		// ACTUAL FIRING
		EX_FireWeapon(altfire);
		PB_FireOffset();
		
		PB_WeaponRecoil(-3.2,+1.61);//same as the SuperGL - sarge945
		PB_SpawnCasing("EmptyGrenadeBrass", 30, 0, 34, -frandom(1, 3), -frandom(2, 4), 5);
		// TAKE AMMO
		PB_LowAmmoSoundWarning();
		pb_takeammo(invoker.ammo2.getclassname(),emptyMag:0);
	}

	action void EX_FireWeapon(bool altfire = false)
	{
		int mode = getExcavatorMode();
		string snd = "excavator/firedigger";
        string projectile = "ExcavatorDrill";

		switch(mode)
		{
			case eDrillChargeMode: 	
				projectile = "ExcavatorDrill"; 		
				snd = "excavator/firedigger"; 	
				break;
			case eDropShotMode: 	
				projectile = "ExcavatorDropShot"; 	
				snd = "excavator/firedropshot"; 	
				break;
			case eBolaMode: 		
				projectile = altfire ? "ExcavatorGrenade" : "ExcavatorBola"; 		
				snd = altfire ? "excavator_grenadelaunch" : "excavator_bolalaunch"; 	
				break;
			case eSawMode: 			
				projectile = altfire ? "HeatedRazorblade" : "Razorblade";	 		
				snd = "excavator_fire_razor"; 	
				break;
		}

		PB_FireBullets(projectile, 1, 0, 0, 0, 3);
		A_StartSound(snd, CHAN_WEAPON, CHANF_OVERLAP);
	}
		
}