// Includes
#include "./NormalRifle_Functions.zs"
#include "./NormalRifle_Wheel.zs"

class NR_Select_FireMode : inventory {default{inventory.maxamount 1;}}
class NR_Select_DualWield : inventory {default{inventory.maxamount 1;}}
class NR_Select_Laser : inventory {default{inventory.maxamount 1;}}

Class PBX_NormalRifle : PB_WeaponBase
{
    Default
    {
        weapon.slotnumber 4;
        inventory.pickupsound "CLIPIN";
        inventory.pickupmessage "$PBX_NormalRifle_Pickup";
        Inventory.AltHudIcon "RIFXA0";
        Inventory.MaxAmount 2;
        Inventory.Amount 1;

        weapon.ammotype1 "PB_HighCalMag";
        weapon.ammogive1 32;
        weapon.ammotype2 "NormalRifleAmmo";
        PB_WeaponBase.AmmoTypeLeft "NormalRifleLeftAmmo";

        PB_WeaponBase.UsesWheel true;
        PB_WeaponBase.WheelInfo "NormalRifleWheel";
		PB_WeaponBase.ReserveToMagAmmoFactor 1;
        
        Tag "$PBX_NormalRifle_Tag";
        scale 0.5;
        +weapon.noalert;
        +weapon.noautofire;
    }

    bool doBurst;
    bool laserActive;
    bool waitReleaseRight;
    bool waitReleaseLeft;
    int burstcount;
    int burstcountLeft;
    const MAGAZINE_SIZE = 31;

    States
    {
        Spawn:
            RIFX A -1;
            Stop;

        WeaponRespect:
            RIR3 ABCDEFG 1 A_DoPBWeaponAction();
            RIFR HIJKLMNOPQR 1 A_DoPBWeaponAction();
            RIFL C 0 {
                A_PlaySoundEx("weapons/rifle/magin", "Auto");
                return A_DoPBWeaponAction();
            }
            RIFR STUVWXYZ 1 A_DoPBWeaponAction();
            RIFR "[]" 1 A_DoPBWeaponAction();
            RIR2 AB 1 A_DoPBWeaponAction();
            Goto Ready3;

        Deselect:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
				PB_HandleCrosshair(55);
                PB_SetZoom(false);
				A_TakeInventory("PB_LockScreenTilt",1);
                A_ZoomFactor(1.0);
                PB_ClearDualWield();
			}
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "DualWieldDeselect");
        NormalDeselect:
			RIFS ABCDE 1;
			TNT1 A 0 A_Lower();
			Wait;

        DualWieldDeselect:
            DURI BCDEF 1;
        FinishDeselect:
            TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower();
            Wait;

        SelectAnimationDualWield:
            DURI FEDCB 1;
            TNT1 A 0 A_PlaySoundEx("CLIPIN", "Auto");
            Goto ReadyDualWield;

        Select:
            TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
                PB_ClearDualWield();
			    PB_HandleCrosshair(55);
				A_SetInventory("PB_LockScreenTilt",0);
                PB_WeaponRaise("CLIPIN");
                invoker.burstcount = 0;
			    return PB_RespectIfNeeded();
			}
        SelectAnimation:
            TNT1 A 0 PB_SetZoom(false);
		    TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "SelectAnimationDualWield");
            RIFS EDCBA 1;
        Ready3:
			TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReadyDualWield");
			TNT1 A 0 A_JumpIf(PB_GetZoom(), "Ready2");
        ReadyToFire:
            RIFL C 1 {
                PB_CooldownBarrel();
			    PB_HandleCrosshair(55);
                return A_DoPBWeaponAction();
            }
            loop;

        Ready2:
            RIFZ D 1 {
                A_SetCrosshair(-1);
                PB_CooldownBarrel();
                return PB_ReadyFire(ads:true);
            }
            loop;

        ReadyDualWield:
			TNT1 A 0 PB_SetupDualWield(crosshair:55);
        ReadyToFireDualWield:
			TNT1 A 1 A_DoPBDualAction();
            Loop;

        IdleLeft_Overlay:
            DURI O 1 {
                PB_CoolDownBarrel(14, 0, 3.2);
                return ReadyOverlay(true);
            }
            Loop;

		IdleRight_Overlay:
            DURI S 1 {
                PB_CoolDownBarrel(-14, 0, 3.2);
                return ReadyOverlay(false);
            }
            Loop;

        Fire:
			TNT1 A 0 A_JumpIf(PB_GetZoom(), "Fire2");
            TNT1 A 0 {
                PB_HandleCrosshair(55);
				A_WeaponOffset(0, 32);
				PB_SetRoll(0);
				A_SetInventory("PB_LockScreenTilt", 0);
				A_ZoomFactor(1.0);
            }
            RIFL J 0 A_Jump(128,3);
            RIFL I 0 A_Jump(128,2);
            RIFL A 0;
            RIFL "#" 0;
			TNT1 A 0 setBurstCount(0);
        FireLoop:
            TNT1 A 0 PB_JumpIfNoAmmo();
            RIFL D 1 BRIGHT fireweapon(1);
            RIFL G 1        fireweapon(2);
            RIFL E 1        fireweapon(3);
			TNT1 A 0 A_JumpIf(getBurstCount() < 3 && getBurst(), "FireLoop");
        FireEnd:
            RIFL F 1        fireweapon(4); 
			TNT1 A 0 setBurstCount(0);
            TNT1 A 0 {
                if(!getBurst()) PB_Refire();
                // return ResolveState(null);
            }
            Goto Ready3;

        Fire2:
            TNT1 A 0 {
                A_WeaponOffset(0,32);
                A_SetCrosshair(-1);
				PB_SetRoll(0);
			}
			TNT1 A 0 setBurstCount(0);
        Fire2Loop:
            TNT1 A 0 PB_JumpIfNoAmmo();
            RIFZ E 1 BRIGHT fireweapon(1);
            RIFZ F 1        fireweapon(2);
			TNT1 A 0 A_JumpIf(getBurstCount() < 3 && getBurst(), "Fire2Loop");
        Fire2End:
			TNT1 A 0 setBurstCount(0);
            RIFZ G 1;
            RIFZ H 1;
            RIFZ D 1 {
                if(!getBurst()) return PB_ReadyFire(ads:true);
                return ResolveState(null);
            }
            Goto Ready2;

        FireRight_Overlay:
            TNT1 A 0 setBurstCount(0);
        BurstRight_Overlay:
            DURI P 1 BRIGHT NormalRifle_FireOverlay(1);
            DURI Q 1        NormalRifle_FireOverlay(2);
            DURI R 1        NormalRifle_FireOverlay(3);
			TNT1 A 0 A_JumpIf(getBurstCount() < 3 && getBurst() && !PB_GetChamberEmpty(), "BurstRight_Overlay");
            DURI S 1        NormalRifle_FireOverlay(4);
            Goto IdleRight_Overlay;

        FireLeft_Overlay:
            TNT1 A 0 setBurstCount(0,true);
        BurstLeft_Overlay:
            DURI L 1 BRIGHT NormalRifle_FireOverlay(1,true);
            DURI M 1        NormalRifle_FireOverlay(2,true);
            DURI N 1        NormalRifle_FireOverlay(3,true);
		    TNT1 A 0 A_JumpIf(getBurstCount(true) < 3 && getBurst() && !PB_GetChamberEmpty(true), "BurstLeft_Overlay");
		    DURI O 1        NormalRifle_FireOverlay(4,true); 
            Goto IdleLeft_Overlay;

        AltFire:
            TNT1 A 0 {
                A_WeaponOffset(0,32);
                PB_SetRoll(0);
                A_SetCrosshair(-1);
                A_SetInventory("PB_LockScreenTilt",0);
            }
			TNT1 A 0 A_Jumpif(PB_GetZoom(),"ZoomOut");
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReadyToFireDualWield");
        ZoomIn:
            TNT1 A 0 {
                PB_SetZoom(true);
                A_startsound("IronSights",29);
                A_SetCrosshair(-1);
            }
            RIFZ ABC 1;
            TNT1 A 0 A_ZoomFactor(2.0);
            RIFZ D 2;
            Goto Ready2;
            
        Zoomout:
            TNT1 A 0 {
                PB_SetZoom(false);
                A_startsound("IronSights",29);
			    PB_HandleCrosshair(55);
            }
            RIFZ BA 1 A_ZoomFactor(1.0);
            Goto Ready3;

        Weaponspecial:
			TNT1 A 0 checkSpecial();
			goto Ready3;

        SwitchToDualWield:
            DURI TUVWX 1;
		    DURI A 0 A_PlaySound("CLIPIN");
            DURI YZ 1;
		    DURI "[]" 1;
            TNT1 A 0 A_SetAkimbo(true);
            Goto ReadyDualWield;

        StopDualWield:
		    DURI "][" 1;
            DURI ZY 1;
		    DURI A 0 A_PlaySound("CLIPIN");
            DURI XWVUT 1;
            TNT1 A 0 A_SetAkimbo(false);
            Goto Ready3;

        RaiseFromEmpty:
            TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
            RIFR ABCDEFG 1;
            goto ContinueReload;

        Reload:
            TNT1 A 0 {
                A_Zoomfactor(1.0);
                PB_SetZoom(false);
            }
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "ReloadDualWield");
            TNT1 A 0 PB_CheckReload("RaiseFromEmpty", null, "ChamberFromReload", "Ready3", "Ready3", MAGAZINE_SIZE);
            TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
            // Raise
            RIR2 BA 1;
            RIFR "][" 1;
		    RIFR ZYXWVVV 1;
            // Remove Mag
		    RIFR UTSRQ 1;
            TNT1 A 0 {
                A_PlaySoundEx("weapons/rifle/magout", "Auto");
                if(PB_GetMagEmpty()) PB_SpawnCasing("EmptyDMRMag",38,26,7,frandom(0, 3.5),frandom(-7.2, -3.3),frandom(3,7));
                PB_SetMagUnloaded(true);
            }
            // Put Away Mag
            RIFR PONMLKJIHG 1;
        ContinueReload:
            // Insert Mag
            TNT1 A 0 A_PlaySoundEx("weapons/rifle/magchange", "Auto");
            RIFR HIJKLMNN 1;
            RIFR OP 1;
            RIFR Q 3;
            RIFR R 1;
            TNT1 A 0 A_PlaySoundEx("weapons/rifle/magin", "Auto");
            RIFR S 1 {
				PB_AmmoIntoMag(
                    invoker.ammo2.getclassname(), 
                    invoker.ammo1.getclassname(), 
                    PB_GetChamberEmpty() ? MAGAZINE_SIZE - 1 : MAGAZINE_SIZE);
                PB_SetMagEmpty(false);
                PB_SetMagUnloaded(false);
            }
            RIFR STU 1;
            TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(), "Rechamber");
            RIFR V 4;
            RIFR WXYZ 1;
        FinishReload:
            RIFR "[]" 1;
            RIR2 AB 1;
            goto Ready3;

        ChamberFromReload:
            RIFL HIJKLMNOP 1;
            TNT1 A 0 {
                PB_SetChamberEmpty(false);
                A_PlaySoundEx("RIFCL_CK", "Auto");
            }
            RIFL PONMLKJIH 1;   
            goto Ready3;

        Rechamber:
            TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
            RIFR W 1;
            RIR2 CDEFGHII 1;
            RIR2 J 3;
            TNT1 A 0 A_PlaySoundEx("RIFCL_CK", "Auto");
            RIR2 LM 1;
            TNT1 A 0 PB_SetChamberEmpty(false);
            RIR2 N 4;
            RIR2 OPQ 1;
            RIR2 R 3;
            RIR2 SSTUV 1;
            goto FinishReload;

        ReloadUnloadRight:
            TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
            RIR3 DEFG 1;
            goto ContinueReloadRight;

        ReloadUnloadLeft:
            TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
            RIR5 DEFG 1;
            goto ContinueReloadLeft;

        ReloadDualWield:
            TNT1 A 0 PB_ClearDualWield();
            TNT1 A 0 PB_CheckReload("ReloadUnloadRight",null,null,"ReloadLeft","Ready3",MAGAZINE_SIZE);
            TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
            // Raise
            // RIR2 BA 1;
            // RIFR "][" 1;
		    // RIFR ZYXWVVV 1;
            RIR3 VUTS 1;
            // Remove Right Mag
            RIR3 RQP 1;
            TNT1 A 0 {
                A_PlaySoundEx("weapons/rifle/magout", "Auto");
                if(PB_GetMagEmpty()) PB_SpawnCasing("EmptyDMRMag",38,26,7,frandom(0, 3.5),frandom(-7.2, -3.3),frandom(3,7));
                PB_SetMagUnloaded(true);
            }
            RIR3 ONMLKJIHG 1;
        ContinueReloadRight:
            // Insert Right Mag
            RIR3 GHIJKLMNOPQR 1;
            RIR3 S 1 {
                A_PlaySoundEx("weapons/rifle/magchange", "Auto");
				PB_AmmoIntoMag(
                    invoker.ammo2.getclassname(), 
                    invoker.ammo1.getclassname(), 
                    PB_GetChamberEmpty() ? MAGAZINE_SIZE - 1: MAGAZINE_SIZE
                );
                PB_SetMagEmpty(false);
                PB_SetMagUnloaded(false);
                PB_SetChamberEmpty(false);
            }
            RIR3 TUVW 1;
        // FinishReloadRight:
        //     RIR3 XYZ 1;
        //     RIR3 "[]" 1;
        ReloadLeft:
            // TNT1 A 3;
            TNT1 A 0 PB_CheckReload("ReloadUnloadLeft",null,null,"Ready3","Ready3",MAGAZINE_SIZE,invoker.reservetomagammofactor,true);
            TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
            // RIR6 BA
            // RIR5 "]["
            // RIR5 ZYXWVUTS
            RIR5 WVUTS 1;
            // Put Away Left Mag
            RIR5 RQP 1;
            TNT1 A 0 {
                A_PlaySoundEx("weapons/rifle/magout", "Auto");
                if(PB_GetMagEmpty(true)) PB_SpawnCasing("EmptyDMRMag",38,26,7,frandom(0, 3.5),frandom(-7.2, -3.3),frandom(3,7));
                PB_SetMagUnloaded(true,true);
            }
            RIR5 ONMLKJIHG 1;
        ContinueReloadLeft:
            // Insert Left Mag
            RIR5 GHIJKLMNOPQR 1;
            RIR5 S 1 {
                A_PlaySoundEx("weapons/rifle/magchange", "Auto");
				PB_AmmoIntoMag(
                    invoker.ammoleft.getclassname(), 
                    invoker.ammo1.getclassname(), 
                    PB_GetChamberEmpty(true) ? MAGAZINE_SIZE - 1: MAGAZINE_SIZE
                );
                PB_SetMagEmpty(false,true);
                PB_SetMagUnloaded(false,true);
                PB_SetChamberEmpty(false,true);
            }
            RIR5 TUVW 1;
            goto Ready3;

        Unload:
            TNT1 A 0 {
				A_WeaponOffset(0, 32);
                A_ZoomFactor(1.0);
                PB_SetZoom(false);
                PB_SetRoll(0);
				// PB_HandleCrosshair(55);
            }
            TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
            TNT1 A 0 A_JumpIf(PB_GetMagUnloaded() && !PB_GetChamberEmpty(), "UnloadChamber");
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "UnloadDualWield");
            // Raise
            RIR2 BA 1;
            RIFR "][" 1;
		    RIFR ZYXWVVV 1;
		    RIFR UTSRQ 1;
            TNT1 A 0 A_PlaySoundEx("weapons/rifle/magout", "Auto");
            // Remove Mag
            RIFR PONMLKJIHG 1;
            TNT1 A 0 {
                A_PlaySoundEx("weapons/rifle/magchange", "Auto");
                if(PB_GetMagEmpty()) PB_SpawnCasing("EmptyDMRMag",38,26,7,frandom(0, 3.5),frandom(-7.2, -3.3),frandom(3,7));
                PB_UnloadMag(invoker.ammotype2,invoker.ammotype1,1,1,0,1);
                PB_SetMagUnloaded(true);
                PB_SetMagEmpty(true);
            }
            // Lower
            RIFR GFEDCBA 1;
            RIR2 B 1;
        UnloadChamber:
            TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
            RIFL HIJKLMNOP 1;
            TNT1 A 0 {
                PB_SetChamberEmpty(true);
                PB_UnloadMag(invoker.ammotype2,invoker.ammotype1,1,1,0,0,"PB_HighCalRound");
            }
            RIFL PONMLKJIH 1;
            goto Ready3;

        UnloadDualWield:
            TNT1 A 0 PB_ClearDualWield();
            TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(),"UnloadLeft");
            // Raise
            RIR3 VUTS 1;
            // Remove Right Mag
            RIR3 RQP 1;
            TNT1 A 0 {
                A_PlaySoundEx("weapons/rifle/magout", "Auto");
                if(PB_GetMagEmpty()) PB_SpawnCasing("EmptyDMRMag",38,26,7,frandom(0, 3.5),frandom(-7.2, -3.3),frandom(3,7));
                PB_UnloadMag(invoker.ammo2.getclassname(),invoker.ammo1.getclassname());
                PB_SetMagEmpty(false);
                PB_SetMagUnloaded(false);
                PB_SetChamberEmpty(false);
            }
            RIR3 ONMLKJIHG 1;
            RIR3 FED 1;
            TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(true),"Ready3");
            Goto UnloadLeft;

        UnloadLeft:
            // TNT1 A 3;
            RIR5 WVUTS 1;
            // Put Away Left Mag
            RIR5 RQP 1;
            TNT1 A 0 {
                A_PlaySoundEx("weapons/rifle/magout", "Auto");
                if(PB_GetMagEmpty(true)) PB_SpawnCasing("EmptyDMRMag",38,26,7,frandom(0, 3.5),frandom(-7.2, -3.3),frandom(3,7));
                PB_UnloadMag(invoker.ammoleft.getclassname(),invoker.ammo1.getclassname());
                PB_SetMagEmpty(true,true);
                PB_SetMagUnloaded(true,true);
                PB_SetChamberEmpty(true,true);
            }
            RIR5 ONMLKJIHG 1;
            RIR5 FED 1;
            TNT1 A 0 PB_SetReloading(false);
            Goto Ready3;

        FlashPunching:
            TNT1 A 0 PB_ClearDualWield();
	        RIFL RSTUVVVVVVVVUTSR 1;
            goto Ready3;

		FlashKicking:
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashKickingAkimbo");
	        RIFL RSTUVVVVVVVVUTSR 1;
			goto Ready3;

        FlashKickingAkimbo:
            TNT1 A 0 PB_ClearDualWield();
            DURI GHIJKKKKKKKKJIHG 1;
			goto Ready3;
			
		FlashAirKicking:
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashAirKickingAkimbo");
	        RIFL RSTUVVVVVVVVUTSR 1;
			goto Ready3;

        FlashAirKickingAkimbo:
            TNT1 A 0 PB_ClearDualWield();
            DURI GHIJKKKKKKKKJIHG 1;
			goto Ready3;
			
		FlashSlideKicking:
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashSlideKickingAkimbo");
	        RIFL RSTUVVVVVVVVVVVVVVVVVVVUTSR 1;
			goto Ready3;

        FlashSlideKickingAkimbo:
            TNT1 A 0 PB_ClearDualWield();
            DURI GHIJKKKKKKKKKKKKKKKKKKKJIHG 1;
			goto Ready3;
			
		FlashSlideKickingStop:
            TNT1 A 0 A_JumpIf(A_CheckAkimbo(), "FlashSlideKickingStopAkimbo");
	        RIFL VVVUTSR 1;
			goto Ready3;

        FlashSlideKickingStopAkimbo:
            TNT1 A 0 PB_ClearDualWield();
	        DURI KKKJIHG 1;
			goto Ready3;

    }
}