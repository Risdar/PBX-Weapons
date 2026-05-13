extend class PBX_Prosurv_LeverAction
{
//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////  
	override void postbeginplay()
	{
		LAMode = LA_357Magnum;
		currentMaxAmmo = leveractionFullAmmo;
		super.postbeginplay();
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

	action void setZoom(bool set = true)
	{
		invoker.isZooming = set;
	}
	action bool getZoom()
	{
		return invoker.isZooming;
	}

	action void clearLAModeTokens()
	{
		A_SetInventory("CantWeaponSpecial" ,0);
		A_SetInventory("LA_Select_Marlin", 0);
		A_SetInventory("LA_Select_Magnum", 0);
	}
	
	action void LA_Deselect()
	{
		A_SetInventory("Unloading",0);
		A_SetInventory("Zoomed",0);
		A_SetInventory("ADSmode",0);
		A_ZoomFactor(1.0);
	}

	action void PB_FireLA()
	{
		switch(getLAMode())
		{
			case LA_444Marlin: 	
				A_StartSound("weapons/leveraction/magfire", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
				PB_FireBullets("PB_444Marlin",1, 0, 0, 0, 0);
				PB_DynamicTail("sniper", "sniper");
				PB_LowAmmoSoundWarning("revolver");
				break;
			case LA_357Magnum: 
				A_StartSound("weapons/leveraction/fire", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
				PB_FireBullets("PB_357Magnum",1, 0, 0, 0, 0);
				PB_LowAmmoSoundWarning();
				break;
		}
	}

	action void LA_FireWeapon(int weaponSide, int ticCount)
	{
		switch (ticCount)
		{
			//Tic 1
			default:
			case 1:
				A_AlertMonsters();
				PB_FireLA();
				PB_GunSmoke(0,0,0);
				A_FireCustomMissile("YellowFlareSpawn",0,0,0,0);
				PB_IncrementHeat(4);
				A_GunFlash();
				switch (weaponSide)
				{
					default:
					case 0:
						A_ZoomFactor(0.98);
						PB_WeaponRecoil(-1.83,+0.75);
						break;
					case 1:
						A_ZoomFactor(1.48);
						PB_WeaponRecoil(-1.75,+0.50);
						break;
				}
				pb_takeammo(invoker.ammotype2,1);
				PB_SpawnCasing("EmptyBrassPistol");
				PB_SetChamberEmpty(true);
				break;
			//Tic 2
			case 2:
				if(getZoom())
				{
					A_ZoomFactor(1.49);
					PB_WeaponRecoil(-1.75,+0.50);
				}
				else
				{
					A_ZoomFactor(0.99);
					PB_WeaponRecoil(-1.83,+0.75);
				}
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
				SetAmmoCapacity(invoker.ammotype2,leveractionFullAmmoMarlin);
				break;
			case LA_357Magnum:
				SetAmmoCapacity(invoker.ammotype2,leveractionFullAmmo);
				A_SetInventory(invoker.ammotype2,invoker.ammo2.amount * 2);
				break;
		}
		PB_SetChamberEmpty(true);
		// PB_SetMagUnloaded(true);
		PB_SetMagEmpty(true);
	}

	action state PB_PreHandleLAWheel()
	{
		if(
		findinventory("LA_Select_Marlin") && getLAMode() == LA_444Marlin ||
		findinventory("LA_Select_Magnum") && getLAMode() == LA_357Magnum)
		{
			A_Print("$PB_ALREADYSELECTED");
			clearLAModeTokens();
			return resolvestate("ready");
		}
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
					invoker.ReserveToMagAmmoFactor = 2;
					invoker.currentMaxAmmo = leveractionFullAmmoMarlin;
				}
				if (CountInv("LA_Select_Magnum") == 1) {
					LA_SetAmmo(LA_357Magnum);
					setLAMode(LA_357Magnum);
					invoker.ReserveToMagAmmoFactor = 1;
					invoker.currentMaxAmmo = leveractionFullAmmo;
				}
			}
			clearLAModeTokens();
			return ResolveState("Reload");
		}
		return resolvestate(null);
	}
	
	action void PrintLAMode()
	{
		if(findinventory("LA_Select_Marlin")) A_Print("$PBX_LeverAction_Marlin", 2);
		if(findinventory("LA_Select_Magnum")) A_Print("$PBX_LeverAction_Magnum", 2);
	}
    
}