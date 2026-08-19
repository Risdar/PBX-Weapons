extend class PBX_Prosurv_Ballista
{
//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////
	override void postbeginplay()
	{
		currentMode = NORMAL_BOLT;
		unwindString = false;
		super.postbeginplay();
	}

	override void AttachToOwner(Actor other)
	{
		if (!other || !other.player) return;
		other.A_GiveInventory("PB_RocketAmmo", ROCKET_AMMO_GIVE);
		super.AttachToOwner(other);
	}

//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////
	// Automatically change sprites based on the mode
	action void setCrossbowSprite(name unloaded = '', name bolt = '', name explosive = '', name demonic = '', name shock = '')
	{
		int mode = getCrossbowMode();
		name spriteToUse = '';
		
		if(PB_GetChamberEmpty())
			spriteToUse = unloaded;

		switch(mode)
		{
			case NORMAL_BOLT: 	  spriteToUse = bolt;		break;
			case EXPLOSIVE_BOLT:  spriteToUse = explosive;	break;
			case DEMONIC_BOLT: 	  spriteToUse = demonic;	break;
			case SHOCK_BOLT: 	  spriteToUse = shock;		break;
			default: break;
		}

		if(spriteToUse != '')
			A_SetWeaponSpriteEx(spriteToUse);
	}

	action int getCrossbowMode()
	{
		return invoker.currentMode;
	}

	action void setCrossbowMode(int mode)
	{
		invoker.currentMode = mode;
	}

	// Convert tokens to Integers for easier use
	action int getTokens()
	{
		if(FindInventory("CB_Select_ShockMode"))
			return SHOCK_BOLT;
		else if(FindInventory("CB_Select_DemonicMode"))
			return DEMONIC_BOLT;
		else if (FindInventory("CB_Select_ExplosiveMode"))
			return EXPLOSIVE_BOLT;
		else if (FindInventory("CB_Select_NormalMode"))
			return NORMAL_BOLT;
		else if (FindInventory("CB_Select_NO"))
			return NO_UPGRADE;
		else
			return CLOSE_WHEEL;
	}

	// Unload crossbow depending on mode
	action void unloadCrossbow()
	{
		name mToUnload;
		switch(getCrossbowMode())
		{
			case NORMAL_BOLT: 	 mToUnload = "PBX_BallistaBoltPickup"; 	break;
			case EXPLOSIVE_BOLT: mToUnload = "PBX_ExplosiveBoltPickup"; break;
			case DEMONIC_BOLT: 	 mToUnload = "PBX_DemonicBoltPickup"; 	break;
			case SHOCK_BOLT: 	 mToUnload = "PBX_ShockBoltPickup"; 	break;
		}
		PB_UnloadMag(
			invoker.ammo2.getclassname(),
			invoker.ammo1.getclassname(),
			invoker.ReserveToMagAmmoFactor,
			ARROW_AMOUNT,
			invoker.ReserveToMagAmmoFactor,
			0,
			mToUnload
		);
	}

	// Handle Weapon Special, if change mode then go to Unload
	// The actual mode change is handled there
    action state HandleWheel()
    {
		int tokens = getTokens();
		int mode = getCrossbowMode();
		bool alreadySelected = tokens == mode;
		bool notUpgraded = tokens == NO_UPGRADE;

		// Dont do anything
		if(countinv("PBX_CloseWheel") > 0 || alreadySelected || notUpgraded)
		{
			cleanmodetokens();
			if(alreadySelected || notUpgraded)
            	A_Print(alreadySelected ? "$PBX_AlreadySelected" : "$PBX_AmmoNotAvailable");

			if(PB_GetZoom())
				return resolvestate("Ready2");
			else
				return resolvestate("Ready3");
		}

		// Switch modes
		switch(tokens)
		{
			case NORMAL_BOLT: 		A_Print("$PBX_Crossbow_Standard"); 		break;
			case EXPLOSIVE_BOLT: 	A_Print("$PBX_Crossbow_Explosive"); 	break;
			case DEMONIC_BOLT: 		A_Print("$PBX_Crossbow_Demonic"); 		break;
			case SHOCK_BOLT: 		A_Print("$PBX_Crossbow_Shock"); 		break;
		}

		// Very specific case where you've already unloaded and mode switch
		if(PB_GetMagUnloaded())
		{
			handleModeChange();
        	return ResolveState("Reload");
		}

        return ResolveState(null);
    }

	// Check if the player still has a token
	action bool checkTokens()
	{
		return getTokens() > 0;
	}

	action state handleModeChange()
	{
		// Setup Variables
		int mode = getTokens();
		int ammoTake;
		name ammo;
		name icon;

		if(!checkTokens())
			return resolvestate(null);

		// Check what mode is selected
		switch(mode)
		{
			case NORMAL_BOLT: 	  ammoTake = ammoTakeNormal;  ammo = "PB_HighCalMag"; 	icon = "CB_ZA0"; 	break;
			case EXPLOSIVE_BOLT:  ammoTake = ammoTakeNormal;  ammo = "PB_RocketAmmo";	icon = "CB_ZB0";	break;
			case DEMONIC_BOLT: 	  ammoTake = ammoTakeDemonic; ammo = "PB_DTech";	 	icon = "CB_ZC0";	break;
			case SHOCK_BOLT: 	  ammoTake = ammoTakeNormal;  ammo = "PB_Cell";	 		icon = "CB_ZD0";	break;
		}

		// Get a pointer to the ammo type being selected
		let ammoType = FindInventory(ammo);
		if(ammoType)
		{
			// If it exists, do mode change
			setCrossbowMode(mode);
			invoker.ReserveToMagAmmoFactor = ammoTake;
			invoker.ammo1 = Ammo(FindInventory(ammo));
			invoker.AltHudIcon = TexMan.CheckForTexture(icon);
		}
		else if(mode == DEMONIC_BOLT)
			self.A_Print("$PBX_Crossbow_DemonicNoAmmo"); // If it gets to this then the player doesnt have any dtech ammo
		else
			self.A_Print("$PBX_AmmoNotFound"); // This means the ammo being chosen does not exist
		
		// always clear tokens and go to continue reload
		cleanmodetokens();
		return resolvestate("ContinueReload");
	}

	// Since some ready states have animations we made a simple "switch" so it goes to the right ready state
	action state readyCheck(StateLabel demonic, StateLabel explosive, StateLabel shock)
	{
		int mode = getCrossbowMode();
		if(PB_GetChamberEmpty())
			return resolvestate(null);

		switch(mode)
		{
			case SHOCK_BOLT:		return resolvestate(shock);
			case DEMONIC_BOLT:		return resolvestate(demonic);
			case EXPLOSIVE_BOLT:	return resolvestate(explosive);
		}
		
		return resolvestate(null);
	}

	// Fire Function, selects the correct projectile depending on mode
	action void FireWeapon()
	{
		string projectile;
		switch (getCrossbowMode())
		{
			case NORMAL_BOLT: 		projectile = "PBX_BallistaBolt"; 	break;
			case EXPLOSIVE_BOLT: 	projectile = "PBX_ExplosiveBolt"; 	break;
			case DEMONIC_BOLT: 		projectile = "PBX_DemonicBolt"; 	break;
			case SHOCK_BOLT: 		projectile = "PBX_ShockBolt"; 	break;
		}
		PB_FireBullets(projectile, 1, 0, 0, 0, PB_GetZoom() ? 1 : 3);
		pb_takeammo(invoker.ammotype2,invoker.ReserveToMagAmmoFactor,0,0);
	}	
	
	action void cleanmodetokens()
	{
        A_SetInventory("PBX_CloseWheel", 0);
        A_SetInventory("CB_Select_NormalMode", 0);
        A_SetInventory("CB_Select_ExplosiveMode", 0);
        A_SetInventory("CB_Select_DemonicMode", 0);
        A_SetInventory("CB_Select_ShockMode", 0);
        A_SetInventory("CB_Select_NO", 0);
	}

}