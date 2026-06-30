extend class PBX_Prosurv_Ballista
{
//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////
	override void postbeginplay()
	{
		demonicBallistaMode = false;
		super.postbeginplay();
	}

	// When you select the demonic mode when you dont have the dtech ammo (this can be done with the disable upgrade option)
	// The game will crash and gives a read from zero
	// This fixes that
	override void attachtoowner(actor other)
	{
		if(other && other.player)
		{
			if(other.countinv("PB_DTech") < 0)
			{
				other.A_giveinventory("PB_DTech", 5);
			}
		}
		super.attachtoowner(other);
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

    action state actualModeChange()
    {
        // Check tokens
        bool selectNormal = FindInventory("CB_Select_NormalMode");
        bool selectDemonic = FindInventory("CB_Select_DemonicMode");

        // Switch to Normal
        if(selectNormal && invoker.demonicBallistaMode)
        {
            invoker.demonicBallistaMode = false;
            invoker.currentTakeAmmo = ammoTakeNormal;
            invoker.ReserveToMagAmmoFactor = ammoTakeNormal;
            invoker.ammo1 = Ammo(FindInventory("PB_HighCalMag"));
            
            cleanmodetokens(); // Clear tokens
            return ResolveState("StandardReload"); // Jump to the specific reload
        }
        
        // Switch to Demonic Mode
        else if(selectDemonic && !invoker.demonicBallistaMode)
        {
            invoker.demonicBallistaMode = true;
            invoker.currentTakeAmmo = ammoTakeDemonic;
            invoker.ReserveToMagAmmoFactor = ammoTakeDemonic;
            invoker.ammo1 = Ammo(FindInventory("PB_DTech"));
            
            cleanmodetokens();
            return ResolveState("ReloadDemonic"); // Jump to the specific reload
        }

        // Fall through
        cleanmodetokens();
        return ResolveState("FinishUnload"); 
    }

    action state HandleWheel()
    {
        bool selectNormal = FindInventory("CB_Select_NormalMode");
        bool selectDemonic = FindInventory("CB_Select_DemonicMode");
        bool selectNo = FindInventory("CB_Select_No");

		if(countinv("PBX_CloseWheel") > 0)
		{
			A_TakeInventory("PBX_CloseWheel",1);
			return resolvestate("Ready3");
		}

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
				PB_SetRoll(0);
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
			case 3: case 4: case 5:
				PB_WeaponRecoil(ticCount == 5 ? -0.5 : -1.0,0);
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