// Includes
// #include "./PlasmaBlaster_Functions.zs"
// #include "./PlasmaBlaster_Wheel.zs"
// #include "./PlasmaBlaster_helpers.zs"

// Constants
const psgFullAmmo = 9;

class PumpShotgunAmmo : Ammo
{
    Default
    {
        Inventory.Amount 0;
        Inventory.MaxAmount psgFullAmmo;
        Ammo.BackpackAmount 0;
        Ammo.BackpackMaxAmount psgFullAmmo;
        Inventory.Icon "AUSCA0";
        +INVENTORY.IGNORESKILL;
    }
}

// Actual Weapon
class PBX_ProSurvPSG : PB_Weapon
{
    Default
    {
        Weapon.BobRangeX 0.3;
        Weapon.BobRangeY 0.5;
        Weapon.BobStyle "InverseSmooth";
        Weapon.BobSpeed 2.4;
        Weapon.SelectionOrder 1300;
        Weapon.SlotNumber 3;
        Weapon.AmmoGive1 18;
        Weapon.AmmoGive2 9;
        Scale 0.45;
        Weapon.AmmoType1 "PB_Shell";
        Weapon.AmmoType2 "PumpShotgunAmmo";
        Inventory.PickupMessage "$PBX_PSG_PICKUP";
        Inventory.PickupSound "weapons/sgpump";
	    Inventory.AltHUDIcon "AUSXA0";
        Damagetype "Shotgun";
        Obituary "%k Opened %o with a Pump Shotgun";
        AttackSound "None";
        Tag "$PBX_PSG_TAG";
        +DONTGIB;
        +FLOORCLIP;
        +WEAPON.NOALERT;
        +WEAPON.NOAUTOAIM;
        +WEAPON.NOAUTOFIRE;
    }

	action void SG_Fire(int tic)
	{
		bool ads = PB_GetZoom();

		// Shared variables
		double recoilX      = ads ? -0.62 : -1.64;
		double recoilY      = ads ? +0.24 : +0.88;
		double zoomA        = ads ? 1.48  : 0.98;
		double zoomB        = ads ? 1.49  : 0.99;
		double zoomC        = ads ? 1.50  : 1.0;
		int    wadOfsY      = ads ? -3    : -4;

		// Berserk halves recoil
		if (invoker.OwnerHasBerserk())
		{
			recoilX *= 0.5;
			recoilY *= 0.5;
		}

		switch(tic)
		{
			case 1:
				PB_SetRoll(0);
				A_TakeInventory("PB_LockScreenTilt", 1);
				if (ads) A_SetCrosshair(-1);

				PB_FireBullets("PB_12GAPellet", 9, 1.5, 0, 0, 1.5);
				A_FireProjectile("ShotgunWad", random(-2,2), 0, random(-2,2), wadOfsY, FPF_NOAUTOAIM, random(-2,2));
				PB_LowAmmoSoundWarning("shotgun");
				PB_TakeAmmo(invoker.ammo2.getClassName(), 1, 0);
				A_AlertMonsters();
				A_PlaySoundEx("Weapons/Autoshotgun", "Weapon");
				PB_IncrementHeat();
				A_FireCustomMissile("YellowFlareSpawn", 0, 0, 0, 0);
				_SpawnMuzzleSparksSG(0, 0, -4);
				PB_MuzzleFlashEffects(0, 0, -4);
				PB_DynamicTail("shotgun", "shotgun");
				A_SetInventory("CantDoAction", 1);
				PB_SetChamberEmpty(true);
				A_GunFlash();
				A_ZoomFactor(zoomA);
				PB_WeaponRecoil(recoilX, recoilY);
				break;

			case 2:
				A_ZoomFactor(zoomB);
				PB_WeaponRecoil(recoilX, recoilY);
				break;

			case 3:
				A_ZoomFactor(zoomC);
				// if (!ads) PB_SpawnCasing("ShotgunCasing", 15, -5, 26, 0, 3, 3);
				break;

			// Pump
			case 4:
				A_ZoomFactor(zoomC);
				if(ads) A_SetCrosshair(-1);
                A_Giveinventory("PB_LockScreenTilt",1);
                A_PlaySoundEx("Ironsights", "Auto");
				PB_SetReloading(true);
				break;

			case 5:
				PB_SpawnCasing("ShotgunCasing",15,-5,26,0,3,3);
				if(!PB_GetMagEmpty()) PB_SetChamberEmpty(false);
				break;
		}
	}

    States
    {
        Spawn:
            AUSX A -1;
            Stop;

        WeaponRespect:
			TNT1 A 0 {
				A_SetCrosshair(5);
				A_Giveinventory("PB_LockScreenTilt",1);
			}
			TNT1 A 0 PB_SetZoom(false);
			TNT1 AAAAAA 1 {
				PB_SetRoll(roll-0.3);
				return A_DoPBWeaponAction();
			}
			XG10 A 1 {
				PB_SetRoll(roll-0.3);
				return A_DoPBWeaponAction();
			}
			TNT1 A 0 A_PlaysoundEx("weapons/autoshotgun/respect1", "Auto");
			XG10 BCDEFGH 1 {
				PB_SetRoll(roll+0.3);
				return A_DoPBWeaponAction();
			}
			TNT1 A 0 {
				A_Giveinventory("PB_LockScreenTilt",1);
				A_PlaysoundEx("Ironsights", "Auto");
			}
			XG31 ABCD 1 {
				PB_SetRoll(roll+1.0);
				return A_DoPBWeaponAction();
			}
			TNT1 A 0 A_PlaySoundEx("weapons/sgmvpump","Auto");
			XG31 EF 1 {
				PB_SetRoll(roll-2.0);
				return A_DoPBWeaponAction();
			}
			XG31 GHIJKL 1 {
				PB_SetRoll(roll-1.0);
				return A_DoPBWeaponAction();
			}
			XG31 M 1 A_DoPBWeaponAction();
			XG31 N 1 {
				A_PlaySoundEx("insertshell","Auto");
				return A_DoPBWeaponAction();
			}
			XG31 OP 1 A_DoPBWeaponAction();
			XG31 Q 1 {
				A_PlaySoundEx("weapons/sgpump","Auto");
				return A_DoPBWeaponAction();
			}
			XG31 RSTU 1 A_DoPBWeaponAction();
			XG40 HHHHHHHHH 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaysoundEx("H4SGCOCK", "Auto");
			XG40 IJKL 1 {
				PB_SetRoll(roll-0.3);
				return A_DoPBWeaponAction();
			}
			XG40 LLL 1 A_DoPBWeaponAction();
			XG40 MNH 1 {
				PB_SetRoll(roll+0.4);
				return A_DoPBWeaponAction();
			}
			XG40 HG 1 A_DoPBWeaponAction();
			XG40 FEDCBA 1 {
				PB_SetRoll(roll+1.0);
				return A_DoPBWeaponAction();
			}
			TNT1 A 0 A_Takeinventory("PB_LockScreenTilt",1);
			Goto Ready3;

        Deselect:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
				PB_HandleCrosshair(46);
				A_TakeInventory("PB_LockScreenTilt",1);
                A_ZoomFactor(1.0);
                PB_SetZoom(false);
                PB_ClearDualWield();
			}
			XG10 FEDCBA 1;
			TNT1 A 0 A_Lower();
			Wait;

        Select:
            TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
                PB_ClearDualWield();
			    PB_HandleCrosshair(46);
				A_SetInventory("PB_LockScreenTilt",0);
                PB_WeaponRaise("weapons/autoshotgun/respect1");
			    return PB_RespectIfNeeded();
			}
        SelectAnimation:
            TNT1 A 0 A_PlaySoundEx("weapons/autoshotgun/respect1", "Auto");
			TNT1 A 0 PB_SetZoom(false);
			XG10 ABCDEFG 1;
		Ready3:
            TNT1 A 0 A_JumpIf(PB_GetZoom(),"Ready2");
			TNT1 A 0 {
				A_SetInventory("PB_LockScreenTilt",0);
				A_SetInventory("CantWeaponSpecial",0);
				A_SetInventory("CantDoAction",0);
			}
		ReadytoFire:
            XG10 H 1 {
				PB_CoolDownBarrel(0,0,-4);
                PB_HandleCrosshair(46);
                return PB_ReadyFire();
            }
            Loop;

        Ready2:
			TNT1 A 0 {
				A_SetCrosshair(-1);
				A_SetInventory("PB_LockScreenTilt",0);
				A_SetInventory("CantDoAction",0);
			}
		ReadytoFire2:
            ASS1 E 1 {
				PB_CoolDownBarrel(0,-2,6);
				return PB_ReadyFire(ads:true);
			}
            Loop;

        WeaponSpecial:
            TNT1 A 0 {
				A_Takeinventory("GoWeaponSpecialAbility",1);
				A_GiveInventory("PB_LockScreenTilt",1);
				PB_HandleCrosshair(46);
                A_Print("$PBX_NoSpecial");
			}
			Goto Ready3;

        Fire:
			TNT1 A 0 {
				PB_SetRoll(0);
				PB_HandleCrosshair(46);
				A_TakeInventory("PB_LockScreenTilt",1);
			}
            TNT1 A 0 A_JumpIf(PB_GetZoom(),"Fire2");
		Fire1Actual:
			TNT1 A 0 		PB_jumpIfNoAmmo();
			XG20 A 1 BRIGHT SG_Fire(1);
			XG20 B 1 BRIGHT SG_Fire(2);
			XG20 C 1 		SG_Fire(3);
			XG20 DEFGHHH 1; 
			XG20 I 1;
		Pump:
			TNT1 A 0 		SG_Fire(4);
			XG40 ABCDEFGH 1 PB_SetRoll(roll-0.1);
			TNT1 A 0 		A_PlaysoundEx("H4SGCOCK", "Auto");
		PumpBegin:
			XG40 IJKL 1 	PB_SetRoll(roll-0.3);
			TNT1 A 0 		SG_Fire(5);
			XG40 LLL 1;
			XG40 MNH 1 		PB_SetRoll(roll+0.4);
		PumpEnd:
			XG40 HGFEDCBA 1 PB_SetRoll(roll+0.1);
			TNT1 A 0 {
				A_SetInventory("CantDoAction",0);
				PB_SetReloading(false);
				PB_Refire();
			}
			Goto Ready3;
			
		Fire2:
			TNT1 A 0 {
				PB_SetRoll(0);
				A_SetCrosshair(-1);
				A_TakeInventory("PB_LockScreenTilt",1);
			}
		Fire2Actual:
			TNT1 A 0 		PB_jumpIfNoAmmo();
			ASX1 A 1 BRIGHT SG_Fire(1);
			ASX1 B 1 BRIGHT SG_Fire(2);
			ASX1 C 2;
			ASX1 D 2;
		Pump2:
            TNT1 A 0 		SG_Fire(4);
            ASS2 A 5;
            TNT1 A 0 		A_PlaySoundEx("H4SGCOCK", "Auto");
            ASS2 BCD 1;
            TNT1 A 0 		SG_Fire(5);
            ASS2 DDDDCBAAA 1 {
				if(JustPressed(BT_ATTACK) && invoker.ammo2.amount > 0) return ResolveState("Fire2");
                return ResolveState(null);
			}
			TNT1 A 0 {
				A_SetInventory("CantDoAction",0);
				return PB_ReadyFire(ads:true);
			}
            // TNT1 A 0 PB_ReadyFire(ads:true);
			// TNT1 A 0 PB_jumpIfNoAmmo();
            Goto Ready2;

        AltFire:
			TNT1 A 0 {
				PB_SetRoll(0);
				PB_HandleCrosshair(46);
				A_TakeInventory("PB_LockScreenTilt",1);
			}
			TNT1 A 0 A_StartSound("IronSights", 0);
			TNT1 A 0 A_JumpIf(PB_GetZoom(),"Zoomout");
			TNT1 A 0 A_ZoomFactor(1.5);
			ASS1 ABC 1;
			TNT1 A 0 {
                PB_SetZoom(true);
                A_SetCrosshair(-1);
                A_WeaponReady(WRF_NOSECONDARY);
			}
			Goto Ready2;
			
		Zoomout:
			TNT1 A 0 {	
				PB_HandleCrosshair(46);
				A_ZoomFactor(1.0);
            }
			ASS1 CBA 1;
			TNT1 A 0 PB_SetZoom(false);
			TNT1 A 0 A_WeaponReady(WRF_NOSECONDARY);
			Goto Ready3;
        
        Reload:
			TNT1 A 0 {
                PB_SetZoom(false);
                A_ZoomFactor(1.0);
                A_Giveinventory("PB_LockScreenTilt",1);
                A_SetCrosshair(-1);
			}
            TNT1 A 0 PB_CheckReload(null,null,"Pump","Ready3","Ready3",psgFullAmmo);
			TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
            TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(), "ChamberInsertShell"); // Go to insert chamber first
            // Raise Weapon
            XG30 ABCD 1 PB_SetRoll(roll+1.0);
			XG30 EF 1 PB_SetRoll(roll-2.0);
			XG30 GHIJKL 1 PB_SetRoll(roll-1.0);
        ShellChecker:
            // Main reload loop
			TNT1 A 0 A_JumpIf(invoker.ammo1.amount < 1 || invoker.ammo2.amount >= psgFullAmmo,"ReloadFinished");
			XG30 L 3 A_DoPBWeaponAction(WRF_NOBOB);
			XG30 MN 1 A_DoPBWeaponAction(WRF_NOBOB);
			XG30 O 1 { 
				A_PlaySoundEx("insertshell","Auto");
				A_Giveinventory(invoker.ammo2.getClassName(),1);
				A_Takeinventory(invoker.ammo1.getClassName(),1,TIF_NOTAKEINFINITE);
				PB_WeaponRecoil(-0.2,+0.2);
				PB_SetRoll(roll-0.4);
			}
			XG30 PQ 1 {
				PB_WeaponRecoil(+0.1,-0.1);
				PB_SetRoll(roll+0.2);
				return A_DoPBWeaponAction(WRF_NOBOB);
			}
			Loop;

		ReloadFinished:
			TNT1 A 0 {
				A_Takeinventory("PB_LockScreenTilt",1);
				A_PlaysoundEx("Ironsights", "Auto");
			}
			XG30 LKJIHG 1 PB_SetRoll(roll+1.0);
			XG30 FEDCBA 1 PB_SetReloading(false);
			Goto Ready3;
            
		ChamberInsertShell:
			TNT1 A 0 {
				A_Giveinventory("PB_LockScreenTilt",1);
				A_PlaysoundEx("Ironsights", "Auto");
			}
			XG31 ABCD 1 PB_SetRoll(roll+1.0);
			TNT1 A 0 A_PlaySoundEx("weapons/sgmvpump","Auto");
			XG31 EF 1 PB_SetRoll(roll-2.0);
			XG31 GHIJKL 1 PB_SetRoll(roll-1.0);
			XG31 M 1 A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			XG31 N 1 {
				A_PlaySoundEx("insertshell","Auto");
				return A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			XG31 OP 1 A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			XG31 Q 1 {
				A_PlaySoundEx("weapons/sgpump","Auto");
				A_Giveinventory(invoker.ammo2.getClassName(),1);
				A_Takeinventory(invoker.ammo1.getClassName(),1,TIF_NOTAKEINFINITE);
                PB_SetChamberEmpty(false);
				PB_SetMagEmpty(false);
				return A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			}
			XG31 RSTUV 1 A_DoPBWeaponAction(WRF_NOBOB|WRF_NOFIRE);
			Goto ShellChecker;

        Unload:
			TNT1 A 0 {
				A_Giveinventory("PB_LockScreenTilt",1);
				A_WeaponOffset(0,32);
				A_PlaysoundEx("Ironsights", "Auto");
			}
            TNT1 A 0 A_JumpIf(PB_GetMagEmpty(),"Ready3");
			XG40 ABCDEFGH 1 A_DoPBWeaponAction();
		RemoveBullets:
            TNT1 A 0 A_JumpIf(invoker.ammo2.amount <= 0,"FinishUnload");
			TNT1 A 0 {
				A_Takeinventory(invoker.ammo2.getclassname(),1);
				A_Giveinventory(invoker.ammo1.getclassname(),1);
				A_PlaysoundEx("H4SGCOCK", "Weapon");
			}
			XG40 IJKLLLL 1 A_DoPBWeaponAction();
			XG40 MN 1 A_DoPBWeaponAction();
			loop;

		FInishUnload:
			XG40 IHGFEDCBA 1 A_DoPBWeaponAction();
			TNT1 A 0 {
                PB_SetMagEmpty(true);
                PB_SetChamberEmpty(true);
				PB_SetReloading(false);
            }
			Goto Ready3;

        FlashPunching:
			XG51 ABCDEFG 1;
			XG51 GFEDCBA 1;
			Goto Ready3;
			
		FlashPunchingMagazine:
			XG51 AB 1;
			AG5M ABCDE 1;
			AG5M EDCBA 1;
			XG51 BA 1;
			Goto Ready3;

		FlashKicking:
			XG50 ABCDEF 1;
			XG50 G 2;
			XG50 FEDCBA 1;
			XG10 G 1;
			Goto Ready3;
		
		FlashAirKicking:
			XG50 ABCDEF 1;
			XG50 G 3;
			XG50 FEDCBA 1;
			XG10 G 1;
			Goto Ready3;
		
		FlashSlideKicking:
			XG50 ABCDEF 1;
			XG50 G 14;
			XG50 FEDCBA 1;
			XG10 G 1;
			Goto Ready3;

		FlashSlideKickingStop:
			XG50 FEDCBA 1;
			XG10 G 1;
			Goto Ready3;
    }
}


