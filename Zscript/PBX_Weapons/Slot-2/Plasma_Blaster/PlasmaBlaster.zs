// Includes
#include "./PlasmaBlaster_Functions.zs"
#include "./PlasmaBlaster_Wheel.zs"
#include "./PlasmaBlaster_helpers.zs"

// Constants
const plasmaBlasterFullAmmo = 16;

// Actual Weapon
class PBX_PlasmaBlaster : PB_WeaponBase
{
    Default
    {
        Weapon.SelectionOrder 2545;
        Weapon.AmmoType1 "PB_Cell";
        Weapon.AmmoType2 "HellPistolerAmmo";
        Weapon.AmmoGive1 30;
        Weapon.SlotNumber 2;
        Weapon.SlotPriority 0.5;
        PB_WeaponBase.UsesWheel true;
        PB_WeaponBase.WheelInfo "PlasmaBlasterWheel";
        Inventory.PickupSound "CHGNPKUP";
        Inventory.Pickupmessage  "$PBX_PlasmaBlaster_Pickup";
	    Inventory.AltHUDIcon "ARMZA0";
        Obituary "%o was decapitated by %k's Assasin.";
        AttackSound "None";
        Scale 0.8;
        Tag "$PBX_PlasmaBlaster_Tag";
        +WEAPON.NOAUTOAIM;
        +WEAPON.NOAUTOFIRE;
        +WEAPON.NO_AUTO_SWITCH;
    }

    bool blasterPrimary;
    bool blasterSecondary;
    int burstcount;
    enum blasterEnum {
        PRIM_SEMI       = 0,
        PRIM_AUTO       = 1,
        SEC_BURST       = 0,
        SEC_CHARGE      = 1,
        TAKE_CHARGE     = 2   // Ammo take charge
    }

    States
    {
        Spawn:
            ARMZ A -1;
            Stop;

        WeaponRespect:
            AMGR ABCD 1 A_DoPBWeaponAction();
            AMGZ ABC 1 A_DoPBWeaponAction();
            AMGR QRSTUV 1 A_DoPBWeaponAction();
            TNT1 A 0 A_PlaySound("CELLIN2", 6);
            AMGR WXY 1 A_DoPBWeaponAction();
            Goto Ready3;

        Deselect:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
				PB_HandleCrosshair(39);
				A_TakeInventory("PB_LockScreenTilt",1);
			}
			TNT1 A 0 A_StopSound(1);
			AMGR ABCDEF 1;
			TNT1 A 0 A_Lower();
			Wait;

        Select:
            TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
                PB_ClearDualWield();
			    PB_HandleCrosshair(39);
				A_SetInventory("PB_LockScreenTilt",0);
                PB_WeaponRaise("weapons/smg_magfly1");
			    return PB_RespectIfNeeded();
			}
        SelectAnimation:
            AMGR FEDCBA 1;
        Ready3:
			AMGL A 1 {
                PB_HandleCrosshair(39);
                return A_DoPBWeaponAction();
            }
            loop;

        Fire:
            TNT1 A 0    fireWeapon(0);
            AMGF A 1;
            AMGF B 1 A_PlaySound("BEP",3);
            AMGF CD 1;
        AutoFire:
            AMGF E 1    fireWeapon(1);
            AMGF FG 1   fireWeapon(2);
            TNT1 A 0    fireWeapon(3);
            Goto Ready3;
  
        AltFire:
            TNT1 A 0 {
                A_WeaponOffset(0,32);
                PB_SetRoll(0);
                PB_HandleCrosshair(39);
                A_TakeInventory("PB_LockScreenTilt",1);
            }
            TNT1 A 0 A_JumpIf(getSecondary() == SEC_CHARGE, "ChargeFire");
            TNT1 A 0 PB_JumpIfNoAmmo(chamber:false);
            AMGF A 1 A_PlaySound("BEP",7);
            AMGF B 1 A_PlaySound("BEP",8);
            AMGF CD 1 A_PlaySound("BEP",9);
            TNT1 A 0 {invoker.burstcount = 0;}
        AltFireBurst:
            TNT1 A 0 PB_JumpIfNoAmmo(chamber:false);
            AMGF E 0 A_PlaySound("HRFire");
            AMGF E 1 {
		        PB_FireBullets("HellPistolNormal", 1, 0, 0, 0, 0);
                PB_TakeAmmo(invoker.ammo2.getClassName());
                invoker.burstcount++;
            }
            AMGF FG 1;
            TNT1 A 0 A_JumpIf(invoker.burstcount < 3, "AltFireBurst");
        EndBurst:
            TNT1 A 0 {invoker.burstcount = 0;}
            AMGL A 10{
                if(JustPressed(BT_ATTACK)) return ResolveState("Fire");
                return A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOPRIMARY);
            }
            TNT1 A 0 PB_ReFire("AltFireBurst");
            Goto Ready3;
            
        ChargeFire:
            TNT1 A 0 PB_JumpIfNoAmmo(min:TAKE_CHARGE,chamber:false);
            AMGF A 1 A_PlaySound("BEP",7);
            AMGF B 1 A_PlaySound("BEP",8);
            AMGF C 1 A_PlaySound("BEP",9);
            AMGF CD 5;
        ChargeHold:
            AMGF D 1 A_FireCustomMissile("RedFlareSpawn", 0, 0, 0, 0);
            TNT1 A 0 PB_ReFire("ChargeHold");
        FireCharge:
            TNT1 E 0 A_PlaySound("HRFire");
            AMGF E 1 {
		        PB_FireBullets("HellPistolCharge", 1, 0, 0, 0, 0);
                PB_TakeAmmo(invoker.ammo2.getClassName(),TAKE_CHARGE);
            }
            AMGF F 1;
            AMGF G 1;
            AMGL A 10;
            Goto Ready3;

        Reload:
            TNT1 A 0 PB_CheckReload("RaiseFromEmpty", null,null,"Ready3","Ready3",plasmaBlasterFullAmmo);
            TNT1 A 0 A_ZoomFactor(1.0);
            TNT1 A 0 A_PlaySound("weapons/smg_magfly1");
            AMGR ABCDEF 1;
            TNT1 A 0 A_PlaySound("weapons/smg_magfly2");
            AMGR GHIJK 1;
            TNT1 A 0 {
                A_PlaySound("CELLOUT2", 5);
                PB_SetMagEmpty(true);
                PB_SetMagUnloaded(true);
                PB_SetChamberEmpty(true);
            }
            AMGR LMNOP 1;
        ContinueReload:
            AMGR QRS 1;
            AMGR TUV 1;
            TNT1 A 0 {
                A_PlaySound("CELLIN2", 6);
                PB_AmmoIntoMag(
                    invoker.ammo2.getClassName(),
                    invoker.ammo1.getClassName(),
                    plasmaBlasterFullAmmo);
                PB_SetMagEmpty(false);
                PB_SetMagUnloaded(false);
                PB_SetChamberEmpty(false);
            }
            AMGR WXY 1;
            Goto Ready3;
        
        RaiseFromEmpty:
            AMGR ABCD 1;
            AMGZ ABC 1;
            Goto ContinueReload;

        WeaponSpecial:
            TNT1 A 0 handleWeaponSpecial();
            Goto Ready3;
            
        // No flash punching lol
        FlashPunching:
            TNT1 A 14;
            Goto Ready3;

        FlashKicking:
            AMGR BCDEFGHIIIIIIIII 1;
            Goto Ready3;
            
        FlashAirKicking:
            AMGR BCDEFGHIIIIIIIIIII 1;
            Goto Ready3;
            
        FlashSlideKicking:
            AMGR BCDEFGHIIIII 1;
            Goto Ready3;

        FlashSlideKickingStop:
            AMGR IIIIIHGFEDCB 1;
            Goto Ready3;
    }
}