const crossbowBallistaFullAmmo = 1;

class PBX_Prosurv_Ballista : PB_WeaponBase
{
	Default
	{
        //$Title Ballista Crossbow
        //$Category Weapons
        //$Sprite CBOWS0
        ////SpawnID 9530;
//////////////////////////// WEAPON DATA ////////////////////////////////////////////////////////////////////////////////////
		Weapon.SlotNumber 4;
		Weapon.SlotPriority 0;
	    Weapon.SelectionOrder 506;
        PB_WeaponBase.UsesWheel true;
		PB_WeaponBase.ReserveToMagAmmoFactor 1;
		PB_WeaponBase.WheelInfo "CrossbowBallistaWheel";
        Inventory.AltHudIcon "CBOWS0";
		
//////////////////////////// AMMO ////////////////////////////////////////////////////////////////////////////////////
		Weapon.AmmoType1 "PB_HighCalMag";
	    Weapon.AmmoType2 "CrossbowBallistaAmmo";
	    Weapon.AmmoGive1 15;
		//PB_WeaponBase.unloadertoken "MyWeaponUnloaded"; token that indicates if this specific weapon is unloaded, example of the token defined below this class
		//PB_WeaponBase.respectItem "MyWeaponRespect"; token needed for the respect to work, in case your weapon has a respect animation, example of the token defined below this class
		
//////////////////////////// SPRITES & OFFSETS ////////////////////////////////////////////////////////////////////////////////////
        Weapon.BobStyle "InverseSmooth";
        Scale 0.7;

//////////////////////////// MESSAGES & SOUNDS ////////////////////////////////////////////////////////////////////////////////////
        Obituary "%k Speared %o with a Ballista";
        Inventory.PickupMessage "$PBX_CrossbowBallista_Pickup";
        Inventory.PickupSound "weapons/ballista/drawstring";
	    Tag "$PBX_CrossbowBallista_Tag";
        
//////////////////////////// WEAPON FLAGS ////////////////////////////////////////////////////////////////////////////////////
        +WEAPON.NOAUTOAIM
        +WEAPON.NOAUTOFIRE
        +FORCEXYBILLBOARD
        +FLOORCLIP
        +DONTGIB
	}
	
//////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////////////////////
	bool demonicBallistaMode;
	int currentTakeAmmo;
	const ammoTakeNormal = 1; // Normal Shot
	const ammoTakeDemonic = 3; // Demonic Shot
	const ammoTakeNormalAlt = 1; // Normal Altfire (PB_RocketAmmo)
	const ammoTakeDemonicAlt = 5; // Demonic Altfire (PB_Fuel)

//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////
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
		bool selectNormal = FindInventory("CB_Select_NormalMode");
		bool selectDemonic = FindInventory("CB_Select_DemonicMode");

		if(selectNormal && isDemonicBallistaMode())
		{
			setDemonicBallistaMode(false);
			invoker.currentTakeAmmo = ammoTakeNormal;
			invoker.ReserveToMagAmmoFactor = ammoTakeNormal;
			invoker.ammo1 = Ammo(FindInventory("PB_HighCalMag"));
            cleanmodetokens();
			return resolvestate("StandardReload");
		}
		else if(selectDemonic && !isDemonicBallistaMode())
		{
			setDemonicBallistaMode(true);
			invoker.currentTakeAmmo = ammoTakeDemonic;
			invoker.ReserveToMagAmmoFactor = ammoTakeDemonic;
			invoker.ammo1 = Ammo(FindInventory("PB_DTech"));
            cleanmodetokens();
			return resolvestate("ReloadDemonic");
		}

		return resolvestate(null);
	}

	action state HandleWheel()
	{
		bool selectNormal = FindInventory("CB_Select_NormalMode");
		bool selectDemonic = FindInventory("CB_Select_DemonicMode");
		bool selectNo = FindInventory("CB_Select_NO");

		// If you dont have the upgrade
		if (selectNo)
        {
            cleanmodetokens();
            A_Print("$PBX_AmmoNotAvailable");
            return resolvestate("Ready3");
        }

		// If you select the current mode again
        if (selectNormal && !isDemonicBallistaMode
			|| selectDemonic && isDemonicBallistaMode)
        {
            cleanmodetokens();
            A_Print("$PBX_AlreadySelected");
            return resolvestate("Ready3");
        }

		// Actual mode change
		if(selectNormal)
		{
            // cleanmodetokens();
			A_Print("$PBX_Crossbow_Standard");
            return resolvestate("Unload");
		}
		if(selectDemonic)
		{
            // cleanmodetokens();
			A_Print("$PBX_Crossbow_Demonic");
            return resolvestate("Unload");
		}
        return resolvestate(null);
	}

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

//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////
	override void postbeginplay()
	{
		demonicBallistaMode = false;
		super.postbeginplay();
	}


//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
	States
	{
//////////////////////////// SETUP ////////////////////////////////////////////////////////////////////////////////////
		Spawn:
			CBOW S -1;
            Stop;
        Steady:
            TNT1 A 0;
            Goto Ready;
        Deselect:
		    CRBW LMNO 1;
			CBOW P 1;
			TNT1 AAA 0 A_lower();
			Wait;
		WeaponRespect:
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
			CBOW Q 1 A_DoPBWeaponAction();
			CRBW TSRQ 1 A_DoPBWeaponAction();
			CRBW A 5 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
			CBWR ABCDEF 1 {
				A_SetRoll(roll-.4, SPF_INTERPOLATE);
				A_DoPBWeaponAction;
			}
			CBWR GGGGGGGGG 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySoundEx("Ironsights","Auto");
			CBWR HIJKKKKKKK 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/drawstring","Auto");
			CBWR LMNOP 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySoundEx("Ironsights","Auto");
			CBOR AB 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/boltin","Auto");
			CBOR CDE 1 A_DoPBWeaponAction();
			CBOR FG 1 {
				A_SetRoll(roll-.3, SPF_INTERPOLATE);
				A_DoPBWeaponAction();
			}
			CBOR H 1 {
				A_SetRoll(roll+.3, SPF_INTERPOLATE);
				A_DoPBWeaponAction();
			}
			CBOR IJ 1 {
				A_SetRoll(roll+.4, SPF_INTERPOLATE);
				A_DoPBWeaponAction();
			}
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
			CBOR KLMN 1 {
				A_SetRoll(roll+.4, SPF_INTERPOLATE);
				A_DoPBWeaponAction();
			}
			Goto Ready3;
		Select:
			TNT1 A 0 PB_WeaponRaise("weapons/ballista/raise");
			TNT1 A 0 PB_RespectIfNeeded();
		SelectContinue:
			TNT1 A 0;
		SelectAnimation:
			TNT1 A 0 genericChecker("SelectAnimationUnloaded","SelectAnimationUpgraded");
            CRBW ONML 1;
			goto Ready3;
		SelectAnimationUpgraded:
			CBOW R 1;
			CRBW YXWV 1;
			Goto Ready3;
		SelectAnimationUnloaded:
			CBOW Q 1;
			CRBW TSRQ 1;
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
		Ready3:
			TNT1 A 0 PB_HandleCrosshair(29);
			TNT1 A 0 genericChecker("ReadyEmpty","ReadyDemonic");
		ReadyNormal:
			CRBW B 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			goto Ready3;
            
		ReadyDemonic:
		    CRBW CDED 3 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			goto Ready3;

		ReadyEmpty:
            TNT1 A 0 A_PlaySound("weapons/empty", 4);
		ReadyEmptyActual:
		    CRBW A 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			loop;
		
//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
		Fire:
			TNT1 A 0 PB_HandleCrosshair(29);
			TNT1 A 0 genericChecker("ReadyEmpty","FireDemonic");
			CRBW F 1 FireWeapon(0,1);
			CRBW G 1 FireWeapon(0,2);
			CRBW J 1 FireWeapon(0,3);
			CRBW JJ 1 FireWeapon(0,4);
			CRBW J 1 FireWeapon(0,5);
			CRBW JA 2 A_WeaponReady(WRF_NOFIRE|WRF_NOBOB);
			goto Reload;
		FireDemonic:
			CRBW K 1 BRIGHT FireWeapon(1,1);
			CRBW G 1 BRIGHT FireWeapon(1,2);
			CRBW J 1 FireWeapon(1,3);
			CRBW JJ 1 FireWeapon(1,4);
			CRBW J 1 FireWeapon(1,5);
			CRBW JA 2 A_WeaponReady(WRF_NOFIRE|WRF_NOBOB);
			goto Reload;
		

//////////////////////////// ALTFIRE ////////////////////////////////////////////////////////////////////////////////////
		Altfire:
			TNT1 A 0 genericChecker("ReadyEmpty","AltFireDemonic");
			TNT1 A 0 checkAltfire();
			CRBW F 1 FireWeapon(2,1);
			CRBW G 1 FireWeapon(2,2);
			CRBW J 1 FireWeapon(2,3);
			CRBW JJ 1 FireWeapon(2,4);
			CRBW J 1 FireWeapon(2,5);
			CRBW JA 2 A_WeaponReady(WRF_NOFIRE|WRF_NOBOB);
			goto Reload;
		AltFireDemonic:
			TNT1 A 0 checkAltfire(true);
			CRBW K 1 BRIGHT FireWeapon(3,1);
			CRBW G 1 BRIGHT FireWeapon(3,2);
			CRBW J 1 FireWeapon(3,3);
			CRBW JJ 1 FireWeapon(3,4);
			CRBW J 1 FireWeapon(3,5);
			CRBW JA 2 A_WeaponReady(WRF_NOFIRE|WRF_NOBOB);
			goto Reload;

//////////////////////////// RELOAD ////////////////////////////////////////////////////////////////////////////////////
		Reload:
            TNT1 A 0 PB_CheckReload(null, null, null, "Ready3", "ReadyEmpty", 1, invoker.currentTakeAmmo);
			// Raise
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
			CBWR ABCDEF 1 A_SetRoll(roll-.4, SPF_INTERPOLATE);
			CBWR GGGGGGGGG 1 ;
			TNT1 A 0 A_PlaySoundEx("Ironsights","Auto");
			// Pulll the bowstring
			CBWR HIJKKKKKKK 1;
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/drawstring","Auto");
			CBWR LMNOPPPPP 1;
			TNT1 A 0 A_JumpIf(isDemonicBallistaMode(),"ReloadDemonic");
		StandardReload:
			// Put the Arrow in
			CBOR AB 1;
			TNT1 A 0 {
				A_SetInventory("CrossbowBallistaAmmo",1); // Gives the arrow
				A_TakeInventory("PB_HighCalMag",1,TIF_NOTAKEINFINITE); // Take 1 reserve
				PB_SetMagUnloaded(false);
				PB_SetMagEmpty(false);
				PB_SetChamberEmpty(false);
			}
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/boltin","Auto");
			CBOR CDE 1;
			CBOR FG 1 A_SetRoll(roll-.3, SPF_INTERPOLATE);
			CBOR H 1 A_SetRoll(roll+.3, SPF_INTERPOLATE);
			CBOR IJ 1 A_SetRoll(roll+.4, SPF_INTERPOLATE);
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
			// Lower
			CBOR KLMN 1 A_SetRoll(roll+.4, SPF_INTERPOLATE);
			TNT1 A 0 PB_SetReloading(false);
			goto Ready3;
		ReloadDemonic:
			CBOR OPQ 1 A_SetRoll(roll+.3, SPF_INTERPOLATE);
			TNT1 A 0 {
				A_SetInventory("CrossbowBallistaAmmo",1);
				A_TakeInventory("PB_DTech",3,TIF_NOTAKEINFINITE);
				PB_SetMagUnloaded(false);
				PB_SetMagEmpty(false);
				PB_SetChamberEmpty(false);
			}
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/boltinoutdemonic","Auto");
			CBOR RST 1 A_SetRoll(roll-.3, SPF_INTERPOLATE);
			CBOR UU 1;
			CBOR UU 1 A_SetRoll(roll+.4, SPF_INTERPOLATE);
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
			CBOR VWXY 1 A_SetRoll(roll+.4, SPF_INTERPOLATE);
			goto Ready3;


//////////////////////////// UNLOAD ////////////////////////////////////////////////////////////////////////////////////
		Unload:
			TNT1 A 0 genericChecker("ReadyEmpty","UnloadDemonic");
			// Raise
			CBOR NMLK 1 A_SetRoll(roll+.4, SPF_INTERPOLATE);
			// Put the Arrow out
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
			CBOR JI 1 A_SetRoll(roll+.4, SPF_INTERPOLATE);
			CBOR H 1 A_SetRoll(roll+.3, SPF_INTERPOLATE);
			CBOR GF 1 A_SetRoll(roll-.3, SPF_INTERPOLATE);
			CBOR EDC 1;
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/boltout","Auto");
			TNT1 A 0 {
				PB_UnloadMag("CrossbowBallistaAmmo","PB_HighCalMag",invoker.currentTakeAmmo);
				PB_SetMagUnloaded(true);
				PB_SetMagEmpty(true);
				PB_SetChamberEmpty(true);
			}
			CBOR BA 1;
			CBWR P 1;
			TNT1 A 0 actualModeChange();
		FinishUnload:
			// Release the bowstring
			CBWR PPPPONML 1;
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/drawstring","Auto");
			CBWR KKKKKKKJIH 1;
			// Loewr
			TNT1 A 0 A_PlaySoundEx("Ironsights","Auto");
			CBWR GGGGGGGGG 1 ;
			CBWR FEDCBA 1 A_SetRoll(roll-.4, SPF_INTERPOLATE);
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
			goto Ready3;

		UnloadDemonic:
			CBOR YXWV 1 A_SetRoll(roll+.4, SPF_INTERPOLATE);
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
			CBOR UU 1 A_SetRoll(roll+.4, SPF_INTERPOLATE);
			CBOR UU 1;
			CBOR TSR 1 A_SetRoll(roll-.3, SPF_INTERPOLATE);
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/boltinoutdemonic","Auto");
			TNT1 A 0 {
				PB_UnloadMag("CrossbowBallistaAmmo","PB_DTech",invoker.currentTakeAmmo);
				PB_SetMagUnloaded(true);
				PB_SetMagEmpty(true);
				PB_SetChamberEmpty(true);
			}
			CBOR QPO 1 A_SetRoll(roll+.3, SPF_INTERPOLATE);
			goto FinishUnload;
		
//////////////////////////// WEAPON SPECIAL ////////////////////////////////////////////////////////////////////////////////////
		Weaponspecial:
           TNT1 A 0 A_Takeinventory("GoWeaponSpecialAbility",1);
		   TNT1 A 0 HandleWheel();
		   goto Ready3;
		
//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
		FlashPunching:
			TNT1 A 0 genericChecker("FlashPunchingUnloaded", "FlashPunchingUpgraded");
			CBOW ABCDEEEEEEDCBA 1;
			goto Ready3;
		FlashPunchingUpgraded:
			CBOW KLMNOOOOOONMLK 1;
			goto Ready3;
		FlashPunchingUnloaded:
			CBOW FGHIJJJJJJIHGF 1;
			goto Ready3;

        FlashKicking:
			TNT1 A 0 genericChecker("FlashKickingUnloaded", "FlashKickingUpgraded");
			CRBW LMNOPPPPPPONML 1;
			goto Ready3;
		FlashKickingUpgraded:
			CRBW VWXYZZZZZZYXWV 1;
			Goto Ready3;
		FlashKickingUnloaded:
			CRBW QRSTUUUUUUTSRQ 1;
			Goto Ready3;
			
		FlashAirKicking:
			TNT1 A 0 genericChecker("FlashAirKickingUnloaded", "FlashAirKickingUpgraded");
			CRBW LMNOPPPPPPONML 1;
			goto Ready3;
		FlashAirKickingUpgraded:
			CRBW VWXYZZZZZZYXWV 1;
			Goto Ready3;
		FlashAirKickingUnloaded:
			CRBW QRSTUUUUUUTSRQ 1;
			Goto Ready3;
			
		FlashSlideKicking:
			TNT1 A 0 genericChecker("FlashSlideKickingUnloaded", "FlashSlideKickingUpgraded");
            CRBW LMNO 1;
			CRBW P 21;
			goto Ready3;
		FlashSlideKickingUnloaded:
			CRBW QRST 1;
			CRBW U 21;
			Goto Ready3;
		FlashSlideKickingUpgraded:
			CRBW VWXY 1;
			CRBW Z 21;
			Goto Ready3;
			
		FlashSlideKickingStop:
			TNT1 A 0 genericChecker("FlashSlideKickingStopUnloaded", "FlashSlideKickingStopUpgraded");
			CRBW PPPONML 1;
			goto Ready3;
		FlashSlideKickingStopUnloaded:
			CRBW UUUTSRQ 1;
			Goto Ready3;
		FlashSlideKickingStopUpgraded:
			CRBW ZZZYXWV 1;
			Goto Ready3;
	}
}