const excavatorFullAmmo = 5;

Class ExcavatorRounds : PB_Ammo{
	Default{
		inventory.maxamount excavatorFullAmmo;
		ammo.backpackamount 0;
		ammo.backpackmaxamount excavatorFullAmmo;
		+INVENTORY.IGNORESKILL
		Inventory.Icon "5DUNA0";
	}
}

class PB_Excavator : PB_WeaponBase
{
	Default
	{
        //$Title Excavator
        //$Category Weapons
        //$Sprite 5DUNA0
        ////SpawnID 9530;
//////////////////////////// WEAPON DATA ////////////////////////////////////////////////////////////////////////////////////
		Weapon.SlotNumber 6;
		Weapon.SlotPriority 0;
	    Weapon.SelectionOrder 506;
	    PB_WeaponBase.RespectItem "RespectExcavatorLauncher";
        Inventory.AltHudIcon "5DUNA0";
		
//////////////////////////// AMMO ////////////////////////////////////////////////////////////////////////////////////
		Weapon.AmmoType1 "PB_RocketAmmo";
	    Weapon.AmmoType2 "ExcavatorRounds";
	    Weapon.AmmoGive2 5;
	    Weapon.AmmoGive1 5;
		//PB_WeaponBase.unloadertoken "MyWeaponUnloaded"; token that indicates if this specific weapon is unloaded, example of the token defined below this class
		//PB_WeaponBase.respectItem "MyWeaponRespect"; token needed for the respect to work, in case your weapon has a respect animation, example of the token defined below this class
		
//////////////////////////// SPRITES & OFFSETS ////////////////////////////////////////////////////////////////////////////////////
        Weapon.BobRangeX 0.3;
        Weapon.BobRangeY 0.5;
        Weapon.BobStyle "InverseSmooth";
        Weapon.BobSpeed 2.4;
        Scale 0.50;
        FloatBobStrength 0.5;

//////////////////////////// MESSAGES & SOUNDS ////////////////////////////////////////////////////////////////////////////////////
        Obituary "Shattered Into Pieces By Excavator Launcher. Ouch!";
        Inventory.PickupMessage "Excavator (Slot 6)";
        Inventory.PickupSound "misc/ROCKBOXA";
	    Tag "UAC-M2 Excavator Launcher";
        
//////////////////////////// WEAPON FLAGS ////////////////////////////////////////////////////////////////////////////////////
        +WEAPON.NOAUTOAIM
        +WEAPON.EXPLOSIVE
        +WEAPON.NOAUTOFIRE
        +FORCEXYBILLBOARD
        +FLOORCLIP
        +DONTGIB
	}
	
//////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////////////////////
    int excavatorMode;
    enum excMode
    {
        eDrillChargeMode = 0,
        eDropShotMode = 1
    }

//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////

    action int getExcavatorMode()
	{
		return invoker.excavatorMode;
	}
	
	action void setExcavatorMode(int mode = eDrillChargeMode)
	{
		invoker.excavatorMode = mode;
	}

    action void cleanmodetokens()
	{
		A_Takeinventory("EX_Select_DrillMode",1);
		A_takeinventory("EX_Select_DropMode",1);
	}
	
    action void fireExcavator()
	{
		string msl = "DrillChargeMode";
        string sound = "excavator/firedropshot";
					
		switch(getExcavatorMode())
		{
			case eDrillChargeMode:   
                A_StartSound("excavator/firedigger", 18);
                PB_FireBullets("ExcavatorDrill", 1, 0, 0, 0, 3);
                break;
			case eDropShotMode: 	    
                A_StartSound("excavator/firedropshot", 0);
                PB_FireBullets("ExcavatorDropShot", 1, 0, 0, 0, 0);
                break;
		}
	}

	action void FireWeapon(int weaponSide, int ticCount)
	{
		switch (ticCount)
		{
			//Tic 1
			default:
			case 1:
				A_AlertMonsters();
				switch (weaponSide)
				{
					default:
					case 0:
                        // SETUP
						A_WeaponOffset(0,32);
                        A_SetRoll(0);
                        A_TakeInventory("PB_LockScreenTilt",1);
                        // ACTUAL FIRING
						A_FireCustomMissile("ShotgunParticles", random(-16,16), 0, -1, random(-9,9));
		                A_FireBullets(0, 0, 1, 50, "shotpuff", 0, 130);
		                A_FireCustomMissile("RedFlareSpawn",-5,0,0,0);
		                A_ZoomFactor(0.96);
                        fireExcavator(); // THIS FUNCTION ALREADY PLAYS THE FIRING SOUND
		                PB_WeaponRecoil(-3.2,+1.61);//same as the SuperGL - sarge945
						PB_SpawnCasing("EmptyGrenadeBrass", 30, 0, 34, -frandom(1, 3), -frandom(2, 4), 5);
                        // TAKE AMMO
				        PB_LowAmmoSoundWarning();
				        pb_takeammo(invoker.ammotype2,1,0);
                        break;
				}
			//Tic 2
			case 2:
				//A_ZoomFactor(1.0, SPF_INTERPOLATE); WE DONT NEED THIS SINCE THE NEXT FRAMES ALREADY GOES TO 1.0
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
    
	Override void DoEffect(){
		if (!owner || !owner.player)
        return;

		Weapon rw = owner.player.ReadyWeapon;
		if (!rw)
        return;
		
		if( self.GetClass() is owner.player.readyweapon.GetClass() ){
			if( (owner.player.cmd.buttons & BT_ALTATTACK) && !owner.FindInventory("GrenadeDetonator") ){
				owner.A_SetInventory("GrenadeDetonator",1);owner.A_PlaySound("excavator/detonate");
			}
			if( !(owner.player.cmd.buttons & BT_ALTATTACK) && owner.FindInventory("GrenadeDetonator") ){
				owner.A_SetInventory("GrenadeDetonator",0);
			}
		}
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
		// NO RESPECT ANIMATION
		// WeaponRespect:
		// 	TNT1 A 1 A_DoPBWeaponAction(); dont forget to add A_DoPBWeaponAction() so you can cancel this animation in game
		// 	goto WeaponReady;
		Select:
			TNT1 A 0 PB_WeaponRaise("RLANDRAW");
			// TNT1 A 0 PB_RespectIfNeeded();
		SelectContinue:
			TNT1 A 0;
		SelectAnimation:
			TNT1 A 0 A_JumpIf(pb_getmagunloaded(), "NoAmmo");
            5DKF IHGFE 1;
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
		Ready3:
        ReadyDrillChargaMode:
            TNT1 A 0 A_Jumpif(getExcavatorMode() == eDropShotMode, "ReadyDropShotMode");
			5DKF A 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			Loop;
            
		ReadyDropShotMode:
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

            // I DONT THINK THIS IS EVEN USED
            //AltFire:
            //TNT1 A 0 A_JumpIfInventory("DropShotMode", 1, "DetonateDropShot");
            DETO B 0 A_PlaySound("excavator/detonate");
            TNT1 A 0 A_SetInventory("GrenadeDetonator",1);
            5DKF C 1 ;
            /*
            //TNT1 A 0 Thing_Projectile(1743,205,0,0,0);
            TNT1 A 0 Thing_Projectile(1743,"DrillBombExplode",0,0,0);
            //MGLG B 0 Thing_Projectile(1744,208,0,0,0);
            MGLG B 0 Thing_Projectile(1744,"DropShotExplode",0,0,0);
            TNT1 A 0 Thing_ReMove(1743);
            TNT1 A 0 Thing_ReMove(1744);
            */
            TNT1 A 0 A_SetInventory("GrenadeDetonator",0);
            5DKF C 3;
            Goto Ready3;
		
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
           TNT1 A 0 {
				A_Takeinventory("GoWeaponSpecialAbility",1);
				A_Takeinventory("Zoomed",1);
				A_Takeinventory("ADSmode",1);
				A_ZoomFactor(1.0);
			}
            TNT1 A 0 {
				if((findinventory("EX_Select_DropMode") && MS_getmode() == 0) || 
				(findinventory("EX_Select_DrillMode") && MS_getmode() == 1))
				{
					A_print("Mode already selected");
					cleanmodetokens();
					return resolvestate("ready3");
				}
				
				if(findinventory("EX_Select_DropMode"))
				{
					MS_SetMode(eDropmode);
					A_print("Aim secondary mode");
				}
				
				if(findinventory("EX_Select_DrillMode"))
				{
					MS_SetMode(GrenadeMode);
					A_print("Grenade secondary mode");
				}
				
				return resolvestate(null);
			}
            TNT1 A 0 A_JumpIf(getExcavatorMode() == eDropShotMode, "SwitchToDrill");
        SwitchToDrop:
            TNT1 A 0 A_Print("\ciDrop Charge \c-Mode Activated");
            TNT1 A 0 setExcavatorMode(1);
            7DKF LMNOP 1;
            TNT1 A 0 A_PlaySound("excavator/switch");		
            7DKF PONML 1;
            Goto ReadyDropShotMode;

        SwitchToDrill:
            TNT1 A 0 A_Takeinventory("GoWeaponSpecialAbility",1);
            TNT1 A 0 A_Print("\cdDrill Charge \c-Mode Activated");
            TNT1 A 0 setExcavatorMode(eDrillChargeMode);
            7DKF LMNOP 1;
            TNT1 A 0 A_PlaySound("excavator/switch");		
            7DKF PONML 1 ;
            Goto ReadyDrillChargaMode;
		
//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
		FlashPunching:
            7DKF L 1;
            7DKF MNOP 1;
            7DKF P 4;
            7DKF PONML 1;
			goto ReadyDrillChargaMode;

        FlashKicking:
			5DKF E 1;
            5DKF FGHI 1 ;
            TNT1 A 4;
            5DKF IHGFE 1; //15 frames
			goto ReadyDrillChargaMode;
			
		FlashAirKicking:
            5DKF E 1;
            5DKF FGHI 1;
            TNT1 A 8;
            5DKF IHGFE 1; //16 frames
			goto ReadyDrillChargaMode;
			
		FlashSlideKicking:
            5DKF E 1;
            5DKF EFGHI 1;
            TNT1 A 16; //27 frames
			goto ready3;
			
		FlashSlideKickingStop:
			5DKF I 1;
		    5DKF IIHGFE 1; //7 frames 
			goto ReadyDrillChargaMode;
	}
}