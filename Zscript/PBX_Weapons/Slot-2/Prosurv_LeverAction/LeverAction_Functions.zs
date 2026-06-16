extend class PBX_Prosurv_LeverAction
{
//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////  
	override void postbeginplay()
	{
		laserActive = false;
		LAMode = LA_357Magnum;
		currentMaxAmmo = MAGAZINE_SIZE;
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
            let weap = PBX_Prosurv_LeverAction(owner.player.readyweapon);
            if(!weap) return;

			// Get a pointer to PSprite
			let psp = owner.player.FindPSprite(PSP_WEAPON);
			if(!psp) return;

            if(!weap.laserActive) return;

            // Dont spawn the laser sight if the weapon is in one of these states
            static const StateLabel blockedStates[] = {
                "Pump", "PumpBegin", "PumpEnd", "Reload","FinishUnload", "Deselect", "SelectAnimation",
                "ReloadLoop", "ReloadFinished","Unload","RemoveBullets", "WeaponRespect",
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

            Spawn("PBX_RedDot", lasersight.HitLocation);
		}
    }

//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////

	action void setLAMode(int mode = LA_444Marlin)
	{
		invoker.LAMode = mode;
	}
	action int getLAMode()
	{
		return invoker.LAMode;
	}

	action void clearLAModeTokens()
	{
		A_SetInventory("CantWeaponSpecial", 0);
		A_SetInventory("LA_Select_Marlin", 0);
		A_SetInventory("LA_Select_Magnum", 0);
		A_SetInventory("LA_Select_Laser" ,0);
	}
	
	action void LA_Deselect()
	{
		A_SetInventory("Unloading",0);
		A_SetInventory("Zoomed",0);
		A_SetInventory("ADSmode",0);
		A_ZoomFactor(1.0);
	}

	action void LA_FireWeapon(int ticCount)
	{
		bool ads = PB_GetZoom();
		bool mode = getLAMode();
		double zoomA = ads ? 1.48 : 0.98;
		double zoomB = ads ? 1.49 : 0.99;
		double recoilX = ads ? -1.75 : -1.83;
		double recoilY = ads ? +0.50 : +0.75;
		string projectile = mode == LA_444Marlin ? "PB_444Marlin" : "PB_357Magnum";
		string sound = mode == LA_444Marlin ? "weapons/leveraction/magfire" : "weapons/leveraction/fire";

		switch (ticCount)
		{
			//Tic 1
			default:
			case 1:
				A_AlertMonsters();
				// Firing
				A_StartSound(sound, CHAN_WEAPON, CHANF_OVERLAP, 1.0);
				PB_FireBullets(projectile,1, 0, 0, 0, 0);
				if(mode == LA_357Magnum) {
					PB_DynamicTail("sniper", "sniper");
					PB_LowAmmoSoundWarning("revolver");
				}
				else PB_LowAmmoSoundWarning();
				// Effects
				PB_GunSmoke(0,0,0);
				A_FireCustomMissile("YellowFlareSpawn",0,0,0,0);
				PB_IncrementHeat(4);
				A_GunFlash();
				A_ZoomFactor(zoomA);
				PB_WeaponRecoil(recoilX, recoilY);
				pb_takeammo(invoker.ammotype2,1,0);
				PB_SpawnCasing("EmptyBrassPistol");
				A_SetInventory("CantDoAction", 1);
				PB_SetReloading(true);
				PB_SetChamberEmpty(true);
				break;
			//Tic 2
			case 2:
				A_ZoomFactor(zoomB);
				PB_WeaponRecoil(recoilX, recoilY);
				break;
			//Tic 3
			case 3:
				A_ZoomFactor(1.0);
				// A_FireCustomMissile("EmptyBrassPistol",0,0,4,-8);
				break;
		}
	}
	
	action void LA_SetAmmo(int mode = LA_357Magnum)
	{
		switch(mode)
		{
			case LA_444Marlin:
				A_SetInventory(invoker.ammotype2,invoker.ammo2.amount / 2);
				SetAmmoCapacity(invoker.ammotype2,MAGAZINE_SIZE/2);
				break;
			case LA_357Magnum:
				SetAmmoCapacity(invoker.ammotype2,MAGAZINE_SIZE);
				A_SetInventory(invoker.ammotype2,invoker.ammo2.amount * 2);
				break;
		}
		PB_SetChamberEmpty(true);
		// PB_SetMagUnloaded(true);
		PB_SetMagEmpty(true);
	}

	action state PB_PreHandleLAWheel()
	{
		bool goMarlin 	 = findinventory("LA_Select_Marlin");
		bool goMagnum 	 = findinventory("LA_Select_Magnum");
		bool toggleLaser = findinventory("LA_Select_Laser");

		if(goMarlin && getLAMode() == LA_444Marlin || goMagnum && getLAMode() == LA_357Magnum)
		{
			A_Print("$PB_ALREADYSELECTED");
			clearLAModeTokens();
			return resolvestate("Ready3");
		}

		if(toggleLaser)
		{
            if(invoker.laserActive) invoker.laserActive = false;
            else invoker.laserActive = true;
            A_Print(invoker.laserActive ? "$PBX_LaserOn" : "$PBX_LaserOff");
			A_StartSound("MS/Button", 26);
			clearLAModeTokens();
			if(PB_GetZoom()) return resolvestate("Ready2");
			else return resolvestate("Ready3");
        }

		if(goMarlin) A_Print("$PBX_LeverAction_Marlin", 2);
		if(goMagnum) A_Print("$PBX_LeverAction_Magnum", 2);

		return resolvestate(null);
	}

	action state PB_HandleWheel()
	{
		if(
		findinventory("LA_Select_Marlin") ||
		findinventory("LA_Select_Magnum"))
		{
			{
				if (CountInv("LA_Select_Marlin") == 1) {
					LA_SetAmmo(LA_444Marlin);
					setLAMode(LA_444Marlin);
					invoker.ReserveToMagAmmoFactor = AMMO_TAKE_MARLIN;
					invoker.currentMaxAmmo = MAGAZINE_SIZE/2;
				}
				if (CountInv("LA_Select_Magnum") == 1) {
					LA_SetAmmo(LA_357Magnum);
					setLAMode(LA_357Magnum);
					invoker.ReserveToMagAmmoFactor = AMMO_TAKE_MAGNUM;
					invoker.currentMaxAmmo = MAGAZINE_SIZE;
				}
			}
			clearLAModeTokens();
			return ResolveState("Reload");
		}
		return resolvestate(null);
	}    
}