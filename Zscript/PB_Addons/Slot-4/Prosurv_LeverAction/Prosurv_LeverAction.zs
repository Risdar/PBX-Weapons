const leveractionFullAmmo = 11;

Class ExcavatorRounds : PB_Ammo{
	Default{
		inventory.maxamount leveractionFullAmmo;
		ammo.backpackamount 0;
		ammo.backpackmaxamount leveractionFullAmmo;
		+INVENTORY.IGNORESKILL
		Inventory.Icon "LVR4E0";
	}
}

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
        // PB_WeaponBase.UsesWheel true;
		// PB_WeaponBase.WheelInfo "ExcavatorWheel";
        Inventory.AltHudIcon "LVR4E0";
		PB_WeaponBase.RespectItem "RespectLeverAction"
		
//////////////////////////// AMMO ////////////////////////////////////////////////////////////////////////////////////
		Weapon.AmmoType1 "PB_LowCalMag";
		Weapon.AmmoType2 "LeverActionAmmo";
	    Weapon.AmmoGive1 22;
	    Weapon.AmmoGive2 11;
		
//////////////////////////// SPRITES & OFFSETS ////////////////////////////////////////////////////////////////////////////////////
        Weapon.BobRangeX 0.3;
		Weapon.BobRangeY 0.5;
		Weapon.BobStyle InverseSmooth;
		Weapon.BobSpeed 2.4;
        Scale 0.4;

//////////////////////////// MESSAGES & SOUNDS ////////////////////////////////////////////////////////////////////////////////////
		Obituary "%k Drew a Bead On %o with a Lever Action"
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

//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////

	action void FireWeapon(int weaponSide, int ticCount)
	{
		switch (ticCount)
		{
			//Tic 1
			default:
			case 1:
				//[Pop] First do the check to alert monsters or not, then do so
				A_AlertMonsters();
				
				//[Pop] If the weapon has akimbo, use weaponSide to set which side using
				//a switch
				switch (weaponSide)
				{
					//only going to have centered as an example, but use Case 1 for left and Case 2 for Right
					default:
					case 0:
						//[Pop] Lets handle the muzzle flash first. Use a Ternary
						//Conditional Operator to pick between ADS and nonADS 
						//muzzle overlay too if applicable.
						//Example bool isADS used, will need to define your own
						A_Overlay(-3, isADS ? "MuzzleFlashADS" : "MuzzleFlash");
						//Adjust overlayscale if need be here
						//[Pop] render style flags set here for nice blending
						A_OverlayFlags(-3, PSPF_ALPHA, true);
						A_OverlayFlags(-3, PSPF_RENDERSTYLE, true);
						A_OverlayRenderstyle(-3, STYLE_ADD);
						//[Pop] Now to the meat of the gun, play the appropriate sounds here
						//I think they should all really be CHAN_WEAPON, CHANF_OVERLAP
						//should handle everything else
						A_StartSound("Rifle/Fire", CHAN_WEAPON, CHANF_OVERLAP, 1.0, pitch: 1.2);
						A_StartSound("Rifle/FireAdd", CHAN_WEAPON, CHANF_OVERLAP, 0.75, pitch: 0.8);
						A_StartSound("Rifle/FireBass", CHAN_WEAPON, CHANF_OVERLAP, 1.0, pitch: 0.6);
						//[Pop] Then lets fire the projectile here
						PB_FireBullets("PB_762x51mm", 1, frandom(-0.1, 0.1), 0, 0, frandom(-0.1, 0.1));
						//TakeInventory; //[Pop] DONT FORGET to use ammo as well
						//[Pop] And finally, do any extra effects here
						//GunSmoke;
						//MuzzleSparks;
						//[Pop] NEVER do more or less than 0.98, it looks bad
						//ALWAYS make sure to reset to 1.0 on NEXT TIC
						//A_ZoomFactor(0.98, SPF_INTERPOLATE);
						//CameraRoll;
						//etc etc
						break;
				}
			//Tic 2
			case 2:
				//A_ZoomFactor(1.0, SPF_INTERPOLATE);
				break;
			//Tic 3
			case 3:
				//Nothing this time
				break;
		}
	}
	
//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////
    override void attachtoowner(actor other)
	{
		if(other && other.player)
		{
			if(other.countinv(ammotype2) < 1 &&(countinv(respectInventoryItem) < 1))other.A_giveinventory(ammotype2,GetAmmoCapacity(ammotype2));
		}
		super.attachtoowner(other);
	}
    
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
            5DUN A -1;
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