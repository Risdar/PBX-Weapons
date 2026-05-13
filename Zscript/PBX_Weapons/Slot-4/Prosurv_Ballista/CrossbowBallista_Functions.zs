extend class PBX_Prosurv_Ballista
{
//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////
	override void postbeginplay()
	{
		demonicBallistaMode = false;
		super.postbeginplay();
	}

//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////
	action int getCurrentAmmoTake()
	{
		return invoker.currentTakeAmmo;
    }

    action bool isDemonicBallistaMode()
	{
		return invoker.demonicBallistaMode;
	}

	action void setDemonicBallistaMode(bool value)
	{
		invoker.demonicBallistaMode = value;
	}

	action state genericChecker(statelabel stateEmpty, statelabel stateUpgraded)
	{
		if(PB_GetChamberEmpty() || invoker.ammo2.amount < 1)
			return ResolveState(stateEmpty);
		else if(isDemonicBallistaMode()) 
			return ResolveState(stateUpgraded);
		else
			return ResolveState(null);
	}

	// action state actualModeChange()
	// {
	// 	bool selectNormal = FindInventory("CB_Select_NormalMode");
	// 	bool selectDemonic = FindInventory("CB_Select_DemonicMode");

	// 	if(selectNormal && isDemonicBallistaMode())
	// 	{
	// 		setDemonicBallistaMode(false);
	// 		invoker.currentTakeAmmo = ammoTakeNormal;
	// 		invoker.ReserveToMagAmmoFactor = ammoTakeNormal;
	// 		invoker.ammo1 = Ammo(FindInventory("PB_HighCalMag"));
    //         cleanmodetokens();
	// 		return resolvestate("StandardReload");
	// 	}
	// 	else if(selectDemonic && !isDemonicBallistaMode())
	// 	{
	// 		setDemonicBallistaMode(true);
	// 		invoker.currentTakeAmmo = ammoTakeDemonic;
	// 		invoker.ReserveToMagAmmoFactor = ammoTakeDemonic;
	// 		invoker.ammo1 = Ammo(FindInventory("PB_DTech"));
    //         cleanmodetokens();
	// 		return resolvestate("ReloadDemonic");
	// 	}

	// 	return resolvestate(null);
	// }

    action state actualModeChange()
    {
        // Check tokens
        bool selectNormal = FindInventory("CB_Select_NormalMode");
        bool selectDemonic = FindInventory("CB_Select_DemonicMode");

        // SWITCH TO NORMAL: Must be in Demonic mode AND have the Normal token
        if(selectNormal && invoker.demonicBallistaMode)
        {
            invoker.demonicBallistaMode = false; // Toggle boolean FIRST
            invoker.currentTakeAmmo = ammoTakeNormal;
            invoker.ReserveToMagAmmoFactor = ammoTakeNormal;
            invoker.ammo1 = Ammo(FindInventory("PB_HighCalMag"));
            
            cleanmodetokens(); // Clear tokens so this block doesn't repeat
            return ResolveState("StandardReload"); // Jump to the specific reload
        }
        
        // SWITCH TO DEMONIC: Must NOT be in Demonic mode AND have the Demonic token
        else if(selectDemonic && !invoker.demonicBallistaMode)
        {
            invoker.demonicBallistaMode = true; // Toggle boolean FIRST
            invoker.currentTakeAmmo = ammoTakeDemonic;
            invoker.ReserveToMagAmmoFactor = ammoTakeDemonic;
            invoker.ammo1 = Ammo(FindInventory("PB_DTech"));
            
            cleanmodetokens();
            return ResolveState("ReloadDemonic"); // Jump to the specific reload
        }

        // If we are already in the mode we selected, just clean up and go back
        cleanmodetokens();
        return ResolveState("FinishUnload"); 
    }

    action state HandleWheel()
    {
        bool selectNormal = FindInventory("CB_Select_NormalMode");
        bool selectDemonic = FindInventory("CB_Select_DemonicMode");
        bool selectNo = FindInventory("CB_Select_No");

        if (selectNo)
        {
            cleanmodetokens();
            A_Print("$PBX_AmmoNotAvailable");
            return ResolveState("Ready3");
        }

        // Check if we are trying to switch to the mode we ALREADY HAVE
        if ((selectNormal && !isDemonicBallistaMode()) || (selectDemonic && isDemonicBallistaMode()))
        {
            cleanmodetokens();
            A_Print("$PBX_AlreadySelected");
            return ResolveState("Ready3");
        }

        // If we reached here, a valid mode change is requested.
        // DO NOT clean tokens here yet, because actualModeChange() needs them!
        if(selectNormal)
        {
            A_Print("$PBX_Crossbow_Standard");
            return ResolveState("Unload");
        }
        if(selectDemonic)
        {
            A_Print("$PBX_Crossbow_Demonic");
            return ResolveState("Unload");
        }

        return ResolveState(null);
    }

	// action state HandleWheel()
	// {
	// 	bool selectNormal = FindInventory("CB_Select_NormalMode");
	// 	bool selectDemonic = FindInventory("CB_Select_DemonicMode");
	// 	bool selectNo = FindInventory("CB_Select_NO");

	// 	// If you dont have the upgrade
	// 	if (selectNo)
    //     {
    //         cleanmodetokens();
    //         A_Print("$PBX_AmmoNotAvailable");
    //         return resolvestate("Ready3");
    //     }

	// 	// If you select the current mode again
    //     if (selectNormal && !isDemonicBallistaMode
	// 		|| selectDemonic && isDemonicBallistaMode)
    //     {
    //         cleanmodetokens();
    //         A_Print("$PBX_AlreadySelected");
    //         return resolvestate("Ready3");
    //     }

	// 	// Actual mode change
	// 	if(selectNormal)
	// 	{
    //         // cleanmodetokens();
	// 		A_Print("$PBX_Crossbow_Standard");
    //         return resolvestate("Unload");
	// 	}
	// 	if(selectDemonic)
	// 	{
    //         // cleanmodetokens();
	// 		A_Print("$PBX_Crossbow_Demonic");
    //         return resolvestate("Unload");
	// 	}
    //     return resolvestate(null);
	// }

	action state checkAltfire(bool demonicmode = false)
	{
		if(!demonicmode)
		{
			if(CountInv("PB_RocketAmmo") < ammoTakeNormalAlt)
			{
				A_Print("$PBX_NotEnoughAmmo");
				return resolvestate("Ready3");
			}
		}
		else
		{
			if(CountInv("PB_Fuel") < ammoTakeDemonicAlt)
			{
				A_Print("$PBX_NotEnoughAmmo");
				return resolvestate("Ready3");
			}
		}
		return resolvestate(null);
	}

	action void FireWeapon(int weaponSide, int ticCount)
	{
		switch (ticCount)
		{
			double recoilPitch = isDemonicBallistaMode() ? 3.5 : 1.5;

			//Tic 1
			default:
			case 1:
				// SETUP
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				A_TakeInventory("PB_LockScreenTilt",1);
				A_AlertMonsters();
		        A_ZoomFactor(0.98);

				// What is being fired?
				switch (weaponSide)
				{
					default:
					// Normal Fire
					case 0:
						A_StartSound("weapons/ballista/firebolt", CHAN_WEAPON, CHANF_OVERLAP, 1.0, pitch: 1.2);
                		PB_FireBullets("BallistaBolt", 1, 0, 0, 0, 3);
                        break;
					// Demonic Fire
					case 1:
						A_StartSound("weapons/ballista/firedemonic", CHAN_WEAPON, CHANF_OVERLAP, 1.0, pitch: 1.2);
                		PB_FireBullets("DemonicBolt", 1, 0, 0, 0, 3);
                        break;
					// Normal Alt Fire
					case 2:
						A_StartSound("weapons/ballista/firebolt", CHAN_WEAPON, CHANF_OVERLAP, 1.0, pitch: 1.2);
                		PB_FireBullets("ExplosiveBolt", 1, 0, 0, 0, 3);
						A_TakeInventory("PB_RocketAmmo",ammoTakeNormalAlt,TIF_NOTAKEINFINITE);
						break;
					// Demonic Alt Fire
					case 3:
						A_StartSound("weapons/ballista/firerazor", CHAN_WEAPON, CHANF_OVERLAP, 1.0, pitch: 1.2);
                		PB_FireBullets("RazorBlade", 1, 0, 0, 0, 3);
						A_TakeInventory("PB_Fuel",ammoTakeDemonicAlt,TIF_NOTAKEINFINITE);
						break;
				}
				PB_FireOffset();
				pb_takeammo(invoker.ammotype2,1,0); // Whatever the case always take the loaded arrow
				break;

			//Tic 2
			case 2:
				PB_WeaponRecoil(-recoilPitch,0);
				A_ZoomFactor(1.0, SPF_INTERPOLATE);
				break;
			//Tic 3
			case 3:
				PB_WeaponRecoil(+1.0,0);
				break;
			//Tic 4
			case 4:
				PB_WeaponRecoil(+1.0,0);
				break;
			//Tic 5
			case 5:
				PB_WeaponRecoil(+0.5,0);
				break;
		}
	}	
	
	action void cleanmodetokens()
	{
        A_SetInventory("CB_Select_NormalMode", 0);
        A_SetInventory("CB_Select_DemonicMode", 0);
        A_SetInventory("CB_Select_NO", 0);
	}

}