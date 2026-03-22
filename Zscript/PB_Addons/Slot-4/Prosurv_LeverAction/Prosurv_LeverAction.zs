const leveractionFullAmmo = 12;
const leveractionFullAmmoMarlin = 6;

class PBX_Prosurv_LeverAction : PB_WeaponBase
{
	Default
	{
        //$Title Lever Action
        //$Category Weapons
        //$Sprite LVR4E0
//////////////////////////// WEAPON DATA ////////////////////////////////////////////////////////////////////////////////////
		Weapon.SlotNumber 4;
		Weapon.SlotPriority 0;
		Weapon.SelectionOrder 1300;
        PB_WeaponBase.UsesWheel true;
		PB_WeaponBase.WheelInfo "LeverActionWheel";
        Inventory.AltHudIcon "LVR4E0";
		PB_WeaponBase.RespectItem "RespectLeverAction";
		
//////////////////////////// AMMO ////////////////////////////////////////////////////////////////////////////////////
		Weapon.AmmoType1 "PB_LowCalMag";
		Weapon.AmmoType2 "LeverActionAmmo";
	    Weapon.AmmoGive1 24;
		
//////////////////////////// SPRITES & OFFSETS ////////////////////////////////////////////////////////////////////////////////////
        Weapon.BobRangeX 0.3;
		Weapon.BobRangeY 0.5;
		// Weapon.BobStyle InverseSmooth;
		Weapon.BobSpeed 2.4;
        Scale 0.4;

//////////////////////////// MESSAGES & SOUNDS ////////////////////////////////////////////////////////////////////////////////////
		Obituary "%k Drew a Bead On %o with a Lever Action";
		Inventory.PickupMessage "Lever Action (Slot 4)";
		Inventory.PickupSound "weapons/leveraction/rechamber";
	    Tag "UAC M1893 Mod 0 Lever Action";
        
//////////////////////////// WEAPON FLAGS ////////////////////////////////////////////////////////////////////////////////////
        +WEAPON.NOAUTOAIM
		+WEAPON.NOALERT
		+WEAPON.NOAUTOAIM
        +FORCEXYBILLBOARD
        +FLOORCLIP
        +DONTGIB
	}
	
//////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////////////////////
	bool isZooming;
	int LAMode;
	enum eLAMode
	{
		LA_444Marlin,
		LA_357Magnum
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
		A_TakeInventory("LA_Select_Marlin", 1);
		A_TakeInventory("LA_Select_Magnum", 1);
	}
	
	action void LA_Deselect()
	{
		clearLAModeTokens();
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
	
	action void LA_SetAmmo(int Mode = LA_357Magnum)
	{
		switch(Mode)
		{
			case LA_444Marlin:
				PB_UnloadMag("LeverActionAmmo","PB_LowCalMag",1,1,0,CountInv("LeverActionAmmo") - CountInv("LeverActionAmmo") % 2);
				A_SetInventory("LeverActionAmmo",CountInv("LeverActionAmmo") / 2);
				SetAmmoCapacity("LeverActionAmmo",6);
				break;
			case LA_357Magnum:
				SetAmmoCapacity("LeverActionAmmo",leveractionFullAmmo);
				A_SetInventory("LeverActionAmmo",CountInv("LeverActionAmmo") * 2);
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
			A_SetInventory("CantWeaponSpecial" ,0 );
			A_SetInventory("LA_Select_Marlin", 0);
			A_SetInventory("LA_Select_Magnum", 0);
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
				}
				if (CountInv("LA_Select_Magnum") == 1) {
					LA_SetAmmo(LA_357Magnum);
					setLAMode(LA_357Magnum);
				}
			}
			A_SetInventory("CantWeaponSpecial" ,0 );
			A_SetInventory("LA_Select_Marlin", 0);
			A_SetInventory("LA_Select_Magnum", 0);
			return ResolveState("Reload");
		}
		return resolvestate(null);
	}
	
	action void PrintLAMode()
	{
		if(findinventory("LA_Select_Marlin")) A_Print("$PBX_LeverAction_Marlin", 2);
		if(findinventory("LA_Select_Magnum")) A_Print("$PBX_LeverAction_Magnum", 2);
	}

	// THIS IS SUCH JANK LMAOOOOO
	action state HandleReload()
	{
		if(CountInv("PB_LowCalMag") == 0)
		{
			return resolvestate("ReloadFinished");
		}
		else if(getLAMode() == LA_357Magnum && CountInv("LeverActionAmmo") == leveractionFullAmmo)
		{
			return resolvestate("ReloadFinished");
		}
		else if(getLAMode() == LA_444Marlin && CountInv("LeverActionAmmo") == leveractionFullAmmoMarlin)
		{
			return resolvestate("ReloadFinished");
		}
		return resolvestate(null);
	}

//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////  
	override void postbeginplay()
	{
		LAMode = LA_357Magnum;
		super.postbeginplay();
	}
    
//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
	States
	{
//////////////////////////// SETUP ////////////////////////////////////////////////////////////////////////////////////
		Spawn:
            LVR4 E -1;
            Stop;
        Steady:
            TNT1 A 0;
            Goto Ready;
        Deselect:
            TNT1 A 0 LA_Deselect();
		    LVRA AA 1; 
			LVR4 A 1;
			LVRA BCDE 1;
			TNT1 AAA 0 A_lower();
			Wait;
		WeaponRespect:
			TNT1 A 0 {
				PB_HandleCrosshair(-1);
				A_Giveinventory("PB_LockScreenTilt",1);
                A_Takeinventory("Zoomed",1);
				A_Takeinventory("ADSmode",1);
			}
			TNT1 AAAAAA 1 {
				A_SetRoll(roll-0.3,SPF_INTERPOLATE);
				A_DoPBWeaponAction();
			}
			TNT1 A 0 A_PlaysoundEx("weapons/leveraction/inspect", "Auto");
			LVRA ZYXWV 1 {
				A_SetRoll(roll+0.3,SPF_INTERPOLATE);
				A_DoPBWeaponAction();
			}
			TNT1 A 0 A_StartSound("weapons/leveraction/flip");
			LVR4 F 1 {
				A_SetRoll(roll+0.3,SPF_INTERPOLATE);
				A_DoPBWeaponAction();
			}
			LVRA FGIKM 1 {
				A_SetRoll(roll+0.3,SPF_INTERPOLATE);
				A_DoPBWeaponAction();
			}
			TNT1 A 0 A_StartSound("weapons/leveraction/rechamber");
			LVRA NNNNNOPQR 1 {
				A_SetRoll(roll-0.3,SPF_INTERPOLATE);
				A_DoPBWeaponAction();
			}
			LVRA SUT 1 {
				A_SetRoll(roll-0.3,SPF_INTERPOLATE);
				A_DoPBWeaponAction();
			}
			LVR4 G 1 {
				A_SetRoll(roll-0.3,SPF_INTERPOLATE);
				A_DoPBWeaponAction();
			}
			LVRA AA 1 {
				A_SetRoll(roll-0.3,SPF_INTERPOLATE);
				A_DoPBWeaponAction();
			}
			TNT1 A 0 A_StartSound("weapons/leveraction/openchamber");
			LVR2 RSTUVVVV 1 {
				A_SetRoll(roll+1.0,SPF_INTERPOLATE);
				A_DoPBWeaponAction();
			}
			LVR2 V 3 A_DoPBWeaponAction();
			LVR3 AB 1 A_DoPBWeaponAction();
			LVR3 C 1 { 
				A_StartSound("insertshell");
				A_SetPitch(pitch-0.2,SPF_INTERPOLATE);
				A_SetAngle(angle+0.2, SPF_INTERPOLATE);
				A_SetRoll(roll-0.4,SPF_INTERPOLATE);
				A_DoPBWeaponAction();
			}
			LVR3 D 1 {
				A_SetPitch(pitch+0.2,SPF_INTERPOLATE);
				A_SetAngle(angle-0.2, SPF_INTERPOLATE);
				A_SetRoll(roll+0.4,SPF_INTERPOLATE);
				A_DoPBWeaponAction();
			}
			LVR3 EFG 1 A_DoPBWeaponAction();
			LVR2 V 5 A_DoPBWeaponAction();
			TNT1 A 0 A_StartSound("weapons/leveraction/openchamber");
			LVR2 VUTSRQ 1 {
				A_DoPBWeaponAction();
				A_SetRoll(roll-1.0,SPF_INTERPOLATE);
			}
			LVR2 PONM 1 {
				A_DoPBWeaponAction();
				A_SetRoll(roll+1.0,SPF_INTERPOLATE);
			}
			LVRA AA 1 {
				A_DoPBWeaponAction();
				A_SetRoll(roll+1.0,SPF_INTERPOLATE);
			}
			TNT1 A 0 A_Takeinventory("PB_LockScreenTilt",1);
			Goto Ready3;
		Select:
			TNT1 A 0 PB_WeaponRaise("weapons/leveraction/inspect");
			TNT1 A 0 PB_RespectIfNeeded();
		SelectContinue:
			TNT1 A 0;
		SelectAnimation:
			TNT1 A 0 A_JumpIf(pb_getmagunloaded(), "NoAmmo");
            LVRA EDCB 1;  
			LVR4 A 1;
			LVRA AA 1;
            goto Ready3 ;
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
		Ready3:
        ReadyNormal:
			TNT1 A 0 PB_HandleCrosshair(76);
			TNT1 A 0 A_jumpif(countinv("zoomed") > 0,"Ready2");
			LVRA A 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			Loop;
            
		Ready2:
		ReadyZoom:
			LVR3 Q 1 {
				A_SetRoll(0);
				PB_HandleCrosshair(-1);
				A_SetInventory("PB_LockScreenTilt",0);
				if(Cvar.GetCvar("pb_toggle_aim_hold",player).getint() == 1) 
				{
					if(!PressingAltfire() || JustReleased(BT_ALTATTACK))
						return resolvestate("Zoomout");
					
					if (PressingFire() && PressingAltfire() && CountInv(invoker.ammotype2) > 0)
							return resolvestate("Fire2");
					return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
				}
				else 
				{
					if (PressingFire() && CountInv(invoker.ammotype2) > 0)
						return resolvestate("Fire2");
					return A_DoPBWeaponAction(WRF_ALLOWRELOAD);
				}
				return resolvestate(null);
			}
			Loop;
//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
		Fire:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(76);
				A_SetInventory("PB_LockScreenTilt",0);
			}
			TNT1 A 0 A_jumpifinventory("zoomed",1,"Fire2");
            TNT1 A 0 PB_JumpIfNoAmmo();
			TNT1 A 0 A_JumpIf(pb_getchamberempty(), "Pump");
            LVR2 F 1 BRIGHT LA_FireWeapon(0,1);
			LVR2 G 1 BRIGHT LA_FireWeapon(0,2);
			LVR2 H 1 LA_FireWeapon(0,3);
			LVR2 IJKL 1; 
			LVRA A 1; 
			Goto Pump;

		Fire2:
            TNT1 A 0 PB_JumpIfNoAmmo();
			TNT1 A 0 A_JumpIf(pb_getchamberempty(), "Pump");
			LVR3 R 1 BRIGHT LA_FireWeapon(1,1);
			LVR3 S 1 BRIGHT LA_FireWeapon(1,2);
			LVR3 TU 1;
			LVR3 VWX 1; 
			TNT1 A 0 {
				if(Cvar.GetCvar("pb_toggle_aim_hold",player).getint() == 1) 
				{
					if(!PressingAltfire() || JustReleased(BT_ALTATTACK)){
						return resolvestate("Pump");
					}
					if (PressingFire() && PressingAltfire() && CountInv(invoker.ammotype2) > 0){
							return resolvestate("Pump2");
					}
					return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
				}
				else 
				{
					if (PressingFire() && CountInv(invoker.ammotype2) > 0){
						return resolvestate("Pump2");
					}
					return A_DoPBWeaponAction(WRF_ALLOWRELOAD);
				}
				return resolvestate(null);
			}
			Goto Pump2;

		AltFire:
			TNT1 A 0 A_Jumpif(countinv("Zoomed") > 0 && getZoom(),"ZoomOut");
		ZoomIn:
			TNT1 A 0 A_giveinventory("Zoomed",1);
			TNT1 A 0 setZoom();
			TNT1 A 0 A_StartSound("IronSights");
			TNT1 A 0 A_ZoomFactor(1.5);
			LVR3 MNOP 1;
			Goto Ready2;
		Zoomout:
			TNT1 A 0 A_takeinventory("Zoomed",1);
			TNT1 A 0 setZoom(false);
			TNT1 A 0 A_startsound("IronSights");
			TNT1 A 0 A_ZoomFactor(1.0);
			LVR3 PONM 1;
			Goto Ready3;
//////////////////////////// RELOAD ////////////////////////////////////////////////////////////////////////////////////
		Pump:
			TNT1 A 0 {
				A_PlaysoundEx("weapons/leveraction/flip", "Auto");
				A_ZoomFactor(1.0);
				A_TakeInventory("Zoomed",1);
				A_PlaySoundEx("Ironsights", "Auto");
			}
			LVR4 F 1 A_SetRoll(roll+0.3,SPF_INTERPOLATE);
			LVRA FGIKM 1 A_SetRoll(roll+0.3,SPF_INTERPOLATE);
			TNT1 A 0 A_PlaysoundEx("weapons/leveraction/rechamber", "Auto");
			LVRA NNNNNOPQR 1 ;
			TNT1 A 0 PB_SpawnCasing("EmptyBrassPistol");
			// TNT1 A 0 A_FireCustomMissile("EmptyBrassPistol",0,0,-2,-18)
			LVRA SUT 1 A_SetRoll(roll-0.3,SPF_INTERPOLATE);
			LVR4 G 1 A_SetRoll(roll-0.3,SPF_INTERPOLATE);
			TNT1 A 0 pb_setchamberempty(false);
			LVRA AA 1 {
				A_DoPBWeaponAction();
				A_SetRoll(roll-0.3,SPF_INTERPOLATE);
			}
			TNT1 A 0 PB_Refire("Fire");
			Goto Ready3;
		Pump2:
		TNT1 A 0 {
			A_ZoomFactor(1.5);
			A_Giveinventory("PB_LockScreenTilt",1);
			}
	    TNT1 A 0 A_StartSound("weapons/leveraction/rechamber");
		LVR4 ABCD 1;
		TNT1 A 0 PB_SpawnCasing("EmptyBrassPistol");
		// TNT1 A 0 A_FireCustomMissile("EmptyBrassPistol",0,0,4,-7)	 
		LVR4 DDDDCBA 1 ;
		LVR4 A 2;
		TNT1 A 0 pb_setchamberempty(false);
		TNT1 A 0 {
			if(Cvar.GetCvar("pb_toggle_aim_hold",player).getint() == 1) 
			{
				if(JustReleased(BT_ALTATTACK)){
					return resolvestate("Zoomout");
				}
				if (JustPressed(BT_ATTACK) && PressingAltfire()){
						return resolvestate("Fire2");
				}
			}
			else 
			{
				if(PressingAltfire()){
					return resolvestate("Zoomout");
				}
				if (JustPressed(BT_ATTACK)){
						return resolvestate("Fire2");
				}
				PB_Refire("Fire2");
			}
			return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
		}
        TNT1 A 0 PB_JumpIfNoAmmo();
		Goto Ready2;

		ReloadMarlin:
            TNT1 A 0 PB_CheckReload( null, null, "Pump", "Ready3", "Ready3", leveractionFullAmmoMarlin);
			goto ContinueReload;
		Reload:
			TNT1 A 0 A_JumpIf(getLAMode() == LA_444Marlin, "ReloadMarlin");
            TNT1 A 0 PB_CheckReload( null, null, "Pump", "Ready3", "Ready3", leveractionFullAmmo);
		ContinueReload:
			TNT1 A 0 {
				A_SetInventory("Zoomed",0);
				A_WeaponOffset(0,32);
				A_ZoomFactor(1.0);
				A_SetInventory("PB_LockScreenTilt",1);
				pb_handlecrosshair(76);
			}
			TNT1 A 0 A_StartSound("weapons/leveraction/inspect");
		BeginReloadLoop:
			LVR2 MNOP 1 A_SetRoll(roll+1.0,SPF_INTERPOLATE);
			TNT1 A 0 A_StartSound("weapons/leveraction/openchamber");
			LVR2 QQ 1 A_SetRoll(roll-2.0,SPF_INTERPOLATE);
			LVR2 RSTUVV 1 A_SetRoll(roll-0.6,SPF_INTERPOLATE);
		ReloadLoop:
			// TNT1 A 0 A_JumpIf(invoker.ammotype2 == 0 || invoker.ammotype1 == ammoAmount(),"ReloadFinished");
			TNT1 A 0 HandleReload();
			LVR2 V 2 A_DoPBWeaponAction(WRF_NOBOB);
			LVR3 AB 1 A_DoPBWeaponAction(WRF_NOBOB);
			LVR3 C 1 { 
				A_StartSound("weapons/leveraction/loadshell");
				A_Giveinventory(invoker.ammotype2,1);
				switch(getLAMode())
				{
					case LA_444Marlin:
						A_Takeinventory(invoker.ammotype1,2,TIF_NOTAKEINFINITE);
						break;
					case LA_357Magnum:
						A_Takeinventory(invoker.ammotype1,1,TIF_NOTAKEINFINITE);
						break;
				}
				
				// PB_SetMagUnloaded(false);
				PB_SetMagEmpty(false);
				A_SetPitch(pitch-0.2,SPF_INTERPOLATE);
				A_SetAngle(angle+0.2, SPF_INTERPOLATE);
				A_SetRoll(roll-0.4,SPF_INTERPOLATE);
				if(pb_getchamberempty()) {PB_Setchamberempty(false);}
			}
			LVR3 D 1 {
				A_DoPBWeaponAction(WRF_NOBOB);
				A_SetPitch(pitch+0.2,SPF_INTERPOLATE);
				A_SetAngle(angle-0.2, SPF_INTERPOLATE);
				A_SetRoll(roll+0.4,SPF_INTERPOLATE);
			}
			LVR3 EFG 1 A_DoPBWeaponAction(WRF_NOBOB);
			LVR2 V 1 A_DoPBWeaponAction(WRF_NOBOB);
			goto ReloadLoop;
		ReloadFinished:
			TNT1 A 0 {
				A_Takeinventory("PB_LockScreenTilt",1);
				A_StartSound("weapons/leveraction/openchamber");
			}
			LVR2 VVVV 1 {
				A_DoPBWeaponAction(WRF_NOBOB);
			}
			LVR2 VUTSRQ 1 {
				A_DoPBWeaponAction(WRF_NOBOB);
				A_SetRoll(roll+0.6,SPF_INTERPOLATE);
			}
			LVR2 PONM 1 A_DoPBWeaponAction(WRF_NOBOB);
			Goto Ready3;

//////////////////////////// UNLOAD ////////////////////////////////////////////////////////////////////////////////////
		Unload:
			TNT1 A 0 A_JumpIf(PB_GetMagEmpty(),"Ready3");
			TNT1 A 0 {
				A_Giveinventory("PB_LockScreenTilt",1);
				A_StartSound("weapons/leveraction/inspect");
				A_ZoomFactor(1.0);
			}
			TNT1 A 0 A_JumpIfInventory(invoker.ammotype2,1,1);
			Goto Ready3;
			LVR2 MNOPQ 1;
		RemoveBullets:
			TNT1 A 0 A_JumpIfInventory(invoker.ammotype2,1,1);
			Goto FinishUnload;
			TNT1 A 0 {
				if (getLAMode() == LA_444Marlin) {
					PB_UnloadMag(invoker.ammotype2,invoker.ammotype1,2,1,1,CountInv(invoker.ammotype2) - 1);
					if(CountInv(invoker.ammotype2) < 1) 
					{
						PB_SetMagEmpty(true);
						// PB_SetMagUnloaded(true);
						PB_SetChamberEmpty(true);
					}
				}
				else { 
					PB_UnloadMag(invoker.ammotype2,invoker.ammotype1,1,1,1,CountInv(invoker.ammotype2) - 1);
					if(CountInv(invoker.ammotype2) < 1) 
					{
						PB_SetMagEmpty(true);
						// PB_SetMagUnloaded(true);
						PB_SetChamberEmpty(true);
					}
				}
				A_StartSound("weapons/leveraction/rechamber");
			}
			LVR2 POPQQQQQ 1;
			Goto RemoveBullets;
		FinishUnload:
			TNT1 A 0 PB_HandleWheel();
			LVR2 QPONM 1;
			Goto Ready3;
//////////////////////////// WEAPON SPECIAL ////////////////////////////////////////////////////////////////////////////////////
		Weaponspecial:
		TNT1 A 0 {
			A_SetInventory("CantWeaponSpecial",1);
			A_Takeinventory("GoWeaponSpecialAbility",1);
			A_Takeinventory("Zoomed",1);
		}
		TNT1 A 0 PB_PreHandleLAWheel();
		TNT1 A 0 PrintLAMode();
		TNT1 A 0 {
			A_ZoomFactor(1.0);
			A_WeaponOffset(0,32);
			PB_HandleCrosshair(-1);
		}
		goto Unload;
		
//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
		FlashPunching:
          	 LVRA VWXYZZZ 1;
			LVRA ZZZYXWV 1; //14 frames
			goto Ready3;

        FlashKicking:
			LVR2 ABCDE 1;
			LVR2 E 4;
			LVR2 EDCBA 1;
			LVRA A 1; //15 frames
			goto Ready3;
			
		FlashAirKicking:
            LVR2 ABCDE 1;
			LVR2 E 5;
			LVR2 EDCBA 1;
			LVRA A 1; //16 frames
			goto Ready3;
			
		FlashSlideKicking:
            LVRA VWXYZZZZZZZZZZZZZZZZZZ 1; //27 frames
			goto Ready3;
			
		FlashSlideKickingStop:
			LVRA ZYXWVAA 1; //7 frames 
			goto Ready3;
	}
}