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
	const ammoTakeNormal = 1;
	const ammoTakeDemonic = 3;
	const ammoTakeNormalAlt = 1;
	const ammoTakeDemonicAlt = 5;

//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////

	action bool getUpgraded()
	{
		if(FindInventory("Crossbow_Upgraded"))
			return true;
		else return false;
	}

	action void setUpgraded(bool value)
	{
		invoker.isUpgraded = value;
	}

	action bool isDemonicBallistaMode()
	{
		return invoker.demonicBallistaMode;
	}

	action void setDemonicBallistaMode(bool value)
	{
		invoker.demonicBallistaMode = value;
	}

	action int getAmmoTake()
	{
		return invoker.ammoTake;
	}

	action state jumpIfChamberEmpty(statelabel label)
	{
		if(PB_GetChamberEmpty() || invoker.ammo2.amount < 1) {
			return ResolveState(label);
		}
		return ResolveState(null);
	}

	action state getSelectAnimation()
	{
		if(PB_GetMagUnloaded() || PB_GetChamberEmpty() || PB_GetMagEmpty())
			return ResolveState("SelectAnimationUnloaded");
		else if(isDemonicBallistaMode()) 
			return ResolveState("SelectAnimationUpgraded");
		else
			return ResolveState(null);
	}

	action state ammoCheck()
	{
		if(!PB_GetMagUnloaded() || !PB_GetChamberEmpty() || !PB_GetMagEmpty())
			return ResolveState("Ready3");
		else if(isDemonicBallistaMode()) 
			return ResolveState("ReloadStartDemonic");

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
						A_TakeInventory("PB_RocketAmmo",1,TIF_NOTAKEINFINITE)
						break;
					// Demonic Alt Fire
					case 3:
						A_StartSound("weapons/ballista/firerazor", CHAN_WEAPON, CHANF_OVERLAP, 1.0, pitch: 1.2);
                		PB_FireBullets("RazorBlade", 1, 0, 0, 0, 3);
						A_TakeInventory("PB_Fuel",5,TIF_NOTAKEINFINITE)
						break;
				}
				pb_takeammo(invoker.ammotype2,1,0);
				break;

			//Tic 2
			case 2:
				PB_WeaponRecoil(-recoilPitch);
				A_ZoomFactor(1.0, SPF_INTERPOLATE);
				//A_ZoomFactor(1.0, SPF_INTERPOLATE); WE DONT NEED THIS SINCE THE NEXT FRAMES ALREADY GOES TO 1.0
				break;
			//Tic 3
			case 3:
				PB_WeaponRecoil(+1.0);
				break;
			//Tic 4
			case 4:
				PB_WeaponRecoil(+1.0);
				break;
			//Tic 5
			case 5:
				PB_WeaponRecoil(+0.5);
				break;
		}
	}
	
//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////
	override void postbeginplay()
	{
		excavatorMode = eDrillChargeMode;
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
            TNT1 A 0 setExcavatorMode();
		    5DKF EFGHI 1;
			TNT1 AAA 0 A_lower();
			Wait;
		WeaponRespect:
			TNT1 A 1 A_DoPBWeaponAction(); dont forget to add A_DoPBWeaponAction() so you can cancel this animation in game
			goto WeaponReady;
		Select:
			TNT1 A 0 PB_WeaponRaise("RLANDRAW");
			TNT1 A 0 PB_RespectIfNeeded();
		SelectContinue:
			TNT1 A 0;
		SelectAnimation:
			TNT1 A 0 A_JumpIf(pb_getmagunloaded(), "NoAmmo");
            5DKF IHGFE 1;
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
		Ready3:
        ReadyDrillChargaMode:
			TNT1 A 0 PB_HandleCrosshair(78);
            TNT1 A 0 A_Jumpif(getExcavatorMode() == eDropShotMode, "ReadyDropShotMode");
			5DKF A 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			Loop;
            
		ReadyDropShotMode:
			TNT1 A 0 PB_HandleCrosshair(79);
            TNT1 A 0 A_Jumpif(getExcavatorMode() == eDrillChargeMode, "ReadyDrillChargaMode");
		    5DKF B 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			Loop;
		
//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
		Fire:
            TNT1 A 0 PB_JumpIfNoAmmo("Reload",1,false);
            6DKF A 1 BRIGHT FireWeapon(0,1);
			6DKF A 1 BRIGHT FireWeapon(0,2);
            5DKF L 1 BRIGHT A_ZoomFactor(0.97);
            5DKF M 1 BRIGHT A_ZoomFactor(0.98);
            5DKF N 1 BRIGHT A_ZoomFactor(0.99);
            TNT1 A 0 A_ZoomFactor(1.0);
            5DKF OPQRDDD 1 A_WeaponReady(WRF_NOPRIMARY);
            TNT1 A 0 A_PlaySound("RLCYCLE2", 5);
            5DKF DDDD 1 A_WeaponReady(WRF_NOPRIMARY);
            5DKF D 0 A_ReFire;
			Goto ReadyDrillChargaMode;
		
//////////////////////////// RELOAD ////////////////////////////////////////////////////////////////////////////////////
		Reload:
            TNT1 A 0 PB_CheckReload("RaiseFromEmpty", null, null, "ReadyDrillChargaMode", "NoAmmo", excavatorFullAmmo, 1);
			6DKF A 1 A_PlaySound("Ironsights", 15);
            TNT1 A 0 A_SetRoll(roll-0.6,SPF_INTERPOLATE);
            6DKF BCDEF 1 ;
            TNT1 A 0 A_PlaySound("weapons/sgl/cycle", 14);
            TNT1 A 0 {
                PB_SpawnCasing("SGL_Drum",25,0,20,Frandom(3,4),Frandom(3,4),1);
                PB_SetMagUnloaded(true);
                PB_SetMagEmpty(true);
                PB_SetChamberEmpty(true);
            }
            //TNT1 A 0 A_FireCustomMissile("RocketCaseSpawn",-30,0,-4,-4);
            TNT1 A 0 A_SetRoll(roll+0.6,SPF_INTERPOLATE);
            6DKF GHIJK 1 ;
            TNT1 A 0 A_PlaySound("RLCYCLE2", 13);
            TNT1 A 0 A_SetRoll(0,SPF_INTERPOLATE);
            6DKF KKKKK 1 ;
            TNT1 A 0 A_PlaySound("weapons/minigun/respect1", 13);
            TNT1 A 0 A_SetRoll(roll-0.5,SPF_INTERPOLATE);
        ContinueReload:
            6DKF LMNOPQRS 1 ;
            TNT1 A 0 A_PlaySound("weapons/nailgun/up", 10);
            TNT1 A 0 A_SetRoll(roll-0.5,SPF_INTERPOLATE);
            6DKF TUVWWWWW 1 ;
            TNT1 A 0 A_SetRoll(0,SPF_INTERPOLATE);
            TNT1 A 0 A_PlaySound("Ironsights", 15);
            TNT1 A 0 A_SetRoll(roll+1.0,SPF_INTERPOLATE);
            6DKF XYZ 1 ;
            TNT1 A 0 A_PlaySound("weapons/sgl/inspect1", 15);
            7DKF A 1 ;
            TNT1 A 0 {
                PB_AmmoIntoMag("ExcavatorRounds","PB_RocketAmmo",5,2);
                PB_SetMagUnloaded(false);
                PB_SetMagEmpty(false);
                PB_SetChamberEmpty(false);
            }
            TNT1 A 0 A_SetRoll(roll-1.0,SPF_INTERPOLATE);
            7DKF BCD 1 ;
            TNT1 A 0 A_SetRoll(0,SPF_INTERPOLATE);
            7DKF EFGHIJK 1 ;
            TNT1 A 0 A_PlaySound("excavator/detonate");
            5DKF CCDDCCDDCCDCDCD 1 ;
            TNT1 A 0 PB_SetReloading(false);
            Goto ReadyDrillChargaMode;

        RaiseFromEmpty:
            8DKF DCBA 1;
            goto ContinueReload;

//////////////////////////// UNLOAD ////////////////////////////////////////////////////////////////////////////////////
		Unload:
			TNT1 A 0 A_Jumpif(pb_getmagunloaded(),"NoAmmo");
			6DKF A 1 A_PlaySound("Ironsights", 15);
            TNT1 A 0 A_SetRoll(roll-0.6,SPF_INTERPOLATE);
            6DKF BCDEF 1;
            TNT1 A 0 A_PlaySound("weapons/sgl/cycle", 14);
            //TNT1 A 0 A_FireCustomMissile("RocketCaseSpawn",-30,0,-4,-4);
            TNT1 A 0 A_SetRoll(roll+0.6,SPF_INTERPOLATE);
            6DKF GHI 1;
		    6DKF J 1;
			TNT1 A 0 {
				PB_UnloadMag("ExcavatorRounds","PB_RocketAmmo", 2, 1, 0, 0, "PB_SGLAmmo");
				PB_SetMagUnloaded(true);
				PB_SetMagEmpty(true);
                PB_SetChamberEmpty(true);
			}
            6DKF K 1;
            8DKF ABCD 1;
            TNT1 A 0 PB_SetReloading(false);
            goto NoAmmo;

        NoAmmo:
            5DKF S 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
		    Loop;
		
//////////////////////////// WEAPON SPECIAL ////////////////////////////////////////////////////////////////////////////////////
		Weaponspecial:
           TNT1 A 0 A_Takeinventory("GoWeaponSpecialAbility",1);
		
//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
		FlashPunching:
            TNT1 AAAAAAAAAAAAAA 0; //14 frames
			goto Ready3;

        FlashKicking:
			TNT1 AAAAAAAAAAAAAAA 0 //15 frames
			goto Ready3;
			
		FlashAirKicking:
            TNT1 AAAAAAAAAAAAAAAA 0 //16 frames
			goto Ready3;
			
		FlashSlideKicking:
            TNT1 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 0 //27 frames
			goto Ready3;
			
		FlashSlideKickingStop:
			TNT1 AAAAAAA 0 //7 frames 
			goto Ready3;
	}
}