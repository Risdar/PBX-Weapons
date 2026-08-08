extend class PBX_ProSurvPSG
{
    mixin PBX_LaserSight;

	static const StateLabel blockedLaserStates[] = {
		"Reload", "ShellChecker", "ChamberInsertShell", "ReloadFinished",
		"Unload", "RemoveBullets", "FinishUnload", "SelectAnimation",
		"Pump", "PumpBegin", "PumpEnd", "WeaponRespect", "Deselect",
		"FlashPunching", "FlashKicking", "FlashAirKicking", "FlashSlideKicking", "FlashSlideKickingStop"
	};

	override void PostBeginPlay()
    {
        laserActive = false;
        Super.PostBeginPlay();
    }

    override void DoEffect() 
	{
		super.DoEffect();

        if (level.isFrozen()) return;
        // Check if the player exists and if the current weapon they're using is the blaster
		If(	owner.player && owner.player.readyweapon.GetClass() is self.GetClass())
        {
            // Get a pointer to it
            let weap = PBX_ProSurvPSG(owner.player.readyweapon);
            if(!weap || !weap.laserActive) return;
            PBX_SpawnLaserSight("PBX_GreenDot");
		}
    }

	action void cleanmodetokens()
	{
		A_SetInventory("PBX_CloseWheel",0);
		A_SetInventory("PSG_Select_Laser",0);
		A_SetInventory("PSG_Select_Tripmine",0);
		A_SetInventory("PSG_Select_LaserCharge",0);
		A_SetInventory("PSG_Select_AcidCharge",0);
		A_SetInventory("PSG_Select_SwarmCharge",0);
		A_SetInventory("PSG_Select_Detonator",0);
	}

	action int getTokens() 
	{
		if(FindInventory("PSG_Select_Laser")) 
			return TOGGLE_LASER;
		else if(FindInventory("PSG_Select_Tripmine"))
			return TRY_TRIPMINE;
		else if(FindInventory("PSG_Select_LaserCharge"))
			return LASERCHARGE;
		else if(FindInventory("PSG_Select_AcidCharge"))
			return ACIDCHARGE;
		else if(FindInventory("PSG_Select_SwarmCharge"))
			return SWARMCHARGE;
		else if(FindInventory("PSG_Select_Detonator"))
			return DETONATOR;
		else
			return CLOSE_WHEEL;
	}

	action state handleSpecial()
	{
		int tokens = getTokens();

		switch(tokens)
		{
			case CLOSE_WHEEL:
				cleanmodetokens();
				if(PB_GetZoom())
					return resolvestate("ready2");
				return resolvestate("ready3");
				break;

			case TOGGLE_LASER:
				cleanmodetokens();
				invoker.laserActive = !invoker.laserActive;
				A_Print(invoker.laserActive ? "$PBX_LaserOn" : "$PBX_LaserOff");
				if(PB_GetZoom())
					return resolvestate("ready2");
				return resolvestate("ready3");
				break;

			case TRY_TRIPMINE:
				cleanmodetokens();
				if(!hasEnoughRockets(tokens))
				{
					if(PB_GetZoom())
						return resolvestate("ready2");
					return resolvestate("ready3");
				}
				PB_SetZoom(false);
				A_ZoomFactor(1.0);
				A_overlay(SPECIAL_LAYER,"TripMineOverlay");
				return resolvestate("FlashPunching");
				break;

			case LASERCHARGE: case ACIDCHARGE: case SWARMCHARGE:
				if(!hasEnoughRockets(tokens))
				{
					cleanmodetokens();
					if(PB_GetZoom())
						return resolvestate("ready2");
					return resolvestate("ready3");
				}
				PB_SetZoom(false);
				A_ZoomFactor(1.0);
				return resolvestate("ThrowCharges");
				break;

			case DETONATOR:
				cleanmodetokens();
				PB_SetZoom(false);
				A_ZoomFactor(1.0);
				A_overlay(SPECIAL_LAYER,"DetonatorOverlay");
				return resolvestate("FlashPunching");
				break;
		}
		return resolvestate(null);
	}

	action void throwCharges()
	{
		A_PlaySound("charge/place/remote", 3);
		
		string projectile;
		int amount;

		switch(getTokens())
		{
			case LASERCHARGE: 	projectile = "ThrownLaserCharge"; 	amount = LASERCHARGE_TAKE;	break;
			case ACIDCHARGE: 	projectile = "ThrownAcidCharge";	amount = ACIDCHARGE_TAKE; 	break;
			case SWARMCHARGE: 	projectile = "ThrownSwarmCharge"; 	amount = SWARMCHARGE_TAKE;	break;
		}
		A_TakeInventory(ROCKET_AMMO,amount);
		A_FireCustomMissile(projectile,0,0,0,-1);
		cleanmodetokens();
	}

	action bool hasEnoughRockets(int mode)
	{
		int toCheck;
		switch(mode)
		{
			case TRY_TRIPMINE: 	toCheck = TRIPMINE_TAKE; 		break;
			case LASERCHARGE: 	toCheck = LASERCHARGE_TAKE; 	break;
			case ACIDCHARGE: 	toCheck = ACIDCHARGE_TAKE; 		break;
			case SWARMCHARGE: 	toCheck = SWARMCHARGE_TAKE; 	break;
		}

		if(countinv(ROCKET_AMMO) < toCheck)
		{
			A_Print("$PBX_PSG_NOROCKETS");
			return false;
		}

		return true;
	}

	action void throwChargesSprite()
	{
		name sprite;
		switch(getTokens())
		{
			case LASERCHARGE:	sprite = "LSRC";	break;
			case ACIDCHARGE:	sprite = "REMT";	break;
			case SWARMCHARGE:	sprite = "SWRM";	break;
		}
		A_SetWeaponSpriteEx(sprite);
	}

	action void SG_Fire(int tic)
	{
		bool ads = PB_GetZoom();

		// Shared variables
		double recoilX      = ads ? -0.62 : -1.64;
		double recoilY      = ads ? +0.24 : +0.88;
		double zoomA        = ads ?  1.4  :  0.98;
		double zoomB        = ads ?  1.49 :  0.99;
		double zoomC        = ads ?  1.50 :  1.0 ;
		int    wadOfsY      = ads ?    -3 :    -4;

		switch(tic)
		{
			case 1:
				PB_SetRoll(0);
				A_TakeInventory("PB_LockScreenTilt", 1);
				if (ads) A_SetCrosshair(-1);

				PB_FireBullets("PB_12GAPellet", 9, 1.5, 0, 0, 1.5);

				A_FireProjectile("ShotgunWad", random(-2,2), 0, random(-2,2), wadOfsY, FPF_NOAUTOAIM, random(-2,2));
				PB_LowAmmoSoundWarning("shotgun");
				PB_TakeAmmo(invoker.ammo2.getClassName(),1,0);
				A_AlertMonsters();
				A_StartSound("weapons/sg", CHAN_WEAPON, pitch:frandom(0.95, 1.05));
				PB_IncrementHeat();
				A_FireCustomMissile("YellowFlareSpawn", 0, 0, 0, 0);
				_SpawnMuzzleSparksSG(0, 0, -4);
				PB_MuzzleFlashEffects(0, 0, -4);
				PB_DynamicTail("shotgun", "shotgun");
				A_SetInventory("CantDoAction", 1);
				PB_SetChamberEmpty(true);
				A_GunFlash();
				A_ZoomFactor(zoomA);
				PB_WeaponRecoil(recoilX, recoilY);
				break;

			case 2:
				A_ZoomFactor(zoomB);
				PB_WeaponRecoil(recoilX, recoilY);
				break;

			case 3:
				A_ZoomFactor(zoomC);
				// if (!ads) PB_SpawnCasing("ShotgunCasing", 15, -5, 26, 0, 3, 3);
				break;

			// Pump
			case 4:
				A_ZoomFactor(zoomC);
				if(ads) A_SetCrosshair(-1);
                A_Giveinventory("PB_LockScreenTilt",1);
                A_PlaySoundEx("Ironsights", "Auto");
				PB_SetReloading(true);
				break;

			case 5:
				PB_SpawnCasing("ShotgunCasing",15,-5,26,0,3,3);
				if(!PB_GetMagEmpty()) PB_SetChamberEmpty(false);
				break;
		}
	}
}