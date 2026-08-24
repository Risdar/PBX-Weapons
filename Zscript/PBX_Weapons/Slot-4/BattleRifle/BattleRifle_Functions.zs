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
		semiClear = false;
		isSemiAuto = true;
		super.postbeginplay();
	}

	override void PBX_DoEffectWeaponReady(Weapon weap)
	{
		PBX_SpawnLaserSight(PBX_LaserSightProjectile.GREEN_DOT);
	}
   
//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////
	action void cleanmodetokens()
	{
		A_SetInventory("BR_Select_FireMode",0);
		A_SetInventory("PBX_Toggle_Scope",0);
		A_SetInventory("PBX_Toggle_NVG",0);
		A_SetInventory("PBX_Toggle_Laser",0);
		A_SetInventory("PBX_CloseWheel",0);
	}

	action bool getSemiAuto()
	{
		return invoker.isSemiAuto;
	}

	action bool isUpgraded()
	{
		return countinv("BattleRifle_Upgraded") > 0 || (pbxweapons_backpack_filter & DisablePBX_BattleRifleUpgrade);
	}

    // FIRE FUNCTION
	action void FireWeapon()
	{
		// Set up Variables
		bool ads 	  = PB_GetZoom();
		double recoil = ads ? -1.5 : -3;
		double smoke  = ads ? -2   : -1;
		double zoom	  = ads ? PBX_GetZoomLevel() : 1.0;

		A_AlertMonsters();
		PB_DynamicTail("lmg", "lmg");

		// Firing Logic, basically check if the player has the upgrade or not
		if(isUpgraded()) 
			PBX_FireRicochet("PB_762x51mm","PB_EmptyBrass",1,0.1,0,0,0.1,puffType:"BR45BulletPuff");
		else {
			PB_FireBullets("PB_762x51mm", 1, 0.1, 0, 0, 0.1);
        	PB_SpawnCasing("PB_EmptyBrass",22,2,28,Frandom(-2, -1),Frandom(5,8),Frandom(3,4));
		}

		// Everything Else
		PB_LowAmmoSoundWarning("default");
		pb_takeammo(invoker.ammotype2,1,0);
		A_StartSound("BR45FIRE", CHAN_WEAPON, 0, 1.0, pitch: 1.2);
		invoker.burstcount++;
		PB_IncrementHeat(4);

		PB_GunSmoke(0,0,smoke);
		PB_WeaponRecoil(recoil,frandom(-0.3,0.3));
		A_ZoomFactor(zoom, SPF_INTERPOLATE);
	}

	action state checkSpecial()
	{
		bool toggleFireMode 	= countinv("BR_Select_FireMode")  	> 0;
		bool toggleLaser 		= countinv("PBX_Toggle_Laser")  	> 0;
		bool toggleScope 		= countinv("PBX_Toggle_Scope")  	> 0;
		bool toggleNVG 			= countinv("PBX_Toggle_NVG")  		> 0;

		if(countinv("PBX_CloseWheel") > 0)
		{
			cleanmodetokens();
			return resolvestate("Ready3");
		}

		if(toggleFireMode)
		{
			invoker.isSemiAuto = !invoker.isSemiAuto;
			A_Print(invoker.isSemiAuto ? "$PB_FIREMODE_SEMI" : "$PB_FIREMODE_BURST");
		}

		if(toggleLaser)	PBX_ToggleLaserSight(skipPlaySound:true);
		if(toggleScope) PBX_ToggleSmartScope();
		if(toggleNVG) 	PBX_ToggleNightVision();

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