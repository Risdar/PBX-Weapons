// Includes
#include "./prosurvblaster_Functions.zs"
#include "./prosurvblaster_helpers.zs"
// #include "./PlasmaBlaster_Wheel.zs"

// Actual Weapon
class PBX_ProsurvBlaster : PB_WeaponBase
{
    Default
    {
        Weapon.BobRangeX 0.3;
        Weapon.BobRangeY 0.5;
        Weapon.BobStyle "InverseSmooth";
        Weapon.BobSpeed 2.4;
		Weapon.SlotNumber 2;
        Weapon.SlotPriority 0;
        Weapon.SelectionOrder 1300;
        Weapon.AmmoType1 "BlasterPistolCharge";
        Inventory.MaxAmount 3;
        Inventory.Amount 1;
        +FLOORCLIP;
        +DONTGIB;
        Obituary "%k Zapped %o with a Blaster Pistol";
        AttackSound "None";
        Tag "$PBX_ProsurvBlaster_Tag";
        Inventory.Icon "BRPIA0";
        DamageType "Plasma";
        Inventory.PickupSound "weapons/pistolup";
        Inventory.Pickupmessage "$PBX_ProsurvBlaster_Pickup";
        +WEAPON.WIMPY_WEAPON;
        +WEAPON.NOAUTOAIM;
        +WEAPON.NOAUTOFIRE;
        +WEAPON.NOALERT;
        Scale 0.44;
        Inventory.AltHUDIcon "BRPIA0";
        FloatBobStrength 0.5;
    }

    bool laserActive;
    enum blasterChargeSet{
        SET,
        TAKE,
        GIVE
    }
    enum blasterChargeAmount{
        GIVECHARGERATE  = 3, // Give the charge every this amount of tic
        GIVECHARGE      = 1, // How many charge is given each rate
        TAKECHARGE      = 5, // Take this many charge each shot
        CHARGERELOAD    = 3  // How fast should the reload charge the battery
    }
    const MAXCHARGE = 100;
    const MUZZLELAYER = -5;

    States
    {
        Spawn:
            BRPI A -1;
            Stop;

        WeaponRespect:
            TNT1 A 0 {
                A_Giveinventory("PB_LockScreenTilt",1);
                A_SetCrosshair(-1);
            }
            TNT1 A 10 A_DoPBWeaponAction();
            TNT1 A 0 A_PlaySoundEx("weapons/blasterpistol/ready", "Auto");
            BRGT EDCBAAAAA 1 A_DoPBWeaponAction();
            BRGC CDEF 1 {
                PB_SetRoll(roll+.2);
                A_DoPBWeaponAction();
            }
            TNT1 A 0 A_PlaySoundEx("weapons/blasterpistol/recharge","Weapon");
            BRGC GHIJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJK 1 A_DoPBWeaponAction();
            TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
            BRGC LM 1 A_DoPBWeaponAction();
            BRGC NOPQ 1 {
                PB_SetRoll(roll-.2);
                A_DoPBWeaponAction();
            }
            Goto Ready3;

        Deselect:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
				PB_HandleCrosshair(65);
				A_TakeInventory("PB_LockScreenTilt",1);
                A_ZoomFactor(1.0);
                PB_SetZoom(false);
			}
			BRGT BCDE 1;
			TNT1 A 0 A_Lower();
			Wait;

        Select:
            TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
			    PB_HandleCrosshair(65);
				A_SetInventory("PB_LockScreenTilt",0);
                modifyBlasterCharge(SET,MAXCHARGE);
                PB_WeaponRaise("weapons/blasterpistol/ready");
			    return PB_RespectIfNeeded();
			}
        SelectAnimation:
            BRGT EDCB 1;
        Ready3:
            TNT1 A 0 A_PressingReload();
            BRGT A 1 {
			    PB_HandleCrosshair(65);
                PB_CoolDownBarrel();
                return PB_ReadyFire(useMag:false);
            }
            Loop;

        Ready2:
            TNT1 A 0 A_PressingReload();
            BRGG F 1 {
                A_SetCrosshair(-1);
                PB_CoolDownBarrel();
                return PB_ReadyFire(ads:true,useMag:false);
            }
            Loop;

        Fire:
            TNT1 A 0 {
			    PB_HandleCrosshair(65);
                A_WeaponOffset(0,32);
                PB_SetRoll(0);
                A_TakeInventory("PB_LockScreenTilt",1);			
            }
			TNT1 A 0 A_JumpIf(PB_GetZoom(), "Fire2");
			TNT1 A 0 PB_JumpIfNoAmmo(secondary:false);
            BRGF A 1 BRIGHT fireweapon(1);
            BRGF B 1 fireweapon(2);
            BRGF C 1 fireweapon(3);
            BRGF DC 1 {
                if (JustPressed(BT_ATTACK) && invoker.ammo1.amount > 0) 
                    return ResolveState("Fire");
                return ResolveState(null);
            }
            BRGT AAAAAAA 1 {
                if (JustPressed(BT_ATTACK) && invoker.ammo1.amount > 0) 
                    return ResolveState("Fire");
                return ResolveState(null);
            }
            Goto Ready3;

        Fire2:
            TNT1 A 0 {
                A_WeaponOffset(0,32);
                A_SetCrosshair(-1);
            }
			TNT1 A 0 PB_JumpIfNoAmmo(secondary:false);
            BRGG G 1 BRIGHT fireweapon(1);
            BRGG H 1 fireweapon(2);
            BRGG I 1 fireweapon(3);
            BRGG JKLFFFFFF 1 {
                if (JustPressed(BT_ATTACK) && invoker.ammo1.amount > 0) 
                    return ResolveState("Fire2");
                return ResolveState(null);
            }
            Goto Ready2;

        AltFire:
            TNT1 A 0 {
                A_GunFlash("LightDone",GFF_NOEXTCHANGE);
                A_WeaponOffset(0,32);
                PB_SetRoll(0);
                PB_HandleCrosshair(65);
                A_TakeInventory("PB_LockScreenTilt",1);
            }
            TNT1 A 0 A_StartSound("IronSights");
            TNT1 A 0 A_JumpIf(PB_GetZoom(),"Zoomout");
        ZoomIn:
            TNT1 A 0 A_ZoomFactor(1.2);
            BRGG BC 1 ;
            BRGG DEF 1;
            TNT1 A 0 {
                PB_SetZoom(true);
                A_SetCrosshair(-1);
            }
            Goto Ready2;

        Zoomout:
            TNT1 A 0 {	
                A_GunFlash("LightDone",GFF_NOEXTCHANGE);
                PB_SetZoom(false);
                PB_HandleCrosshair(65);
                A_ZoomFactor(1.0);
            }
            BRGG FED 1 ;
            BRGG CB 1 ;
            Goto Ready3;

        Reload:
            TNT1 A 0 {
                PB_SetZoom(false);
                A_ZoomFactor(1.0);
                A_Giveinventory("PB_LockScreenTilt",1);
                A_SetCrosshair(-1);
			}
            TNT1 A 0 PB_CheckReload(null, null, null, "Ready3", "Ready3", MAXCHARGE);
        Recharge:
            TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
            BRGC CDEF 1 PB_SetRoll(roll+.2);
            TNT1 A 0 A_PlaySoundEx("weapons/blasterpistol/recharge","Weapon");
            BRGC GH 1;
            BRGC I 1;
            BRGC JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ 1 {
                modifyBlasterCharge(GIVE, CHARGERELOAD);
                PB_SetMagEmpty(false);
                PB_SetMagUnloaded(false);
                PB_SetChamberEmpty(false);
            }
            BRGC JJJ 1;
            BRGC K 1;
            TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
            BRGC LM 1;
            BRGC NOPQ 1 PB_SetRoll(roll-.2);
            TNT1 A 0 PB_SetReloading(false);
            Goto Ready3;

        Unload:
            TNT1 A 0 ;
            Goto Ready3;

        WeaponSpecial:
            TNT1 A 0 {
				A_Takeinventory("GoWeaponSpecialAbility",1);
				A_GiveInventory("PB_LockScreenTilt",1);
				PB_HandleCrosshair(65);
			}
            TNT1 A 0 {
				if(invoker.laserActive) invoker.laserActive = false;
				else invoker.laserActive = true;
            	A_StartSound("MS/Button", CHAN_AUTO, CHANF_OVERLAP);
				A_Print(invoker.laserActive ? "$PBX_LaserOn" : "$PBX_LaserOff");
			}
			Goto Ready3;

        FlashKicking:
            BRGY ABCDEFGFEDCBAA 1;
            Goto Ready3;	
            
        FlashAirKicking:
            BRGY ABCDEFGGFEDCBAAA 1;
            Goto Ready3;
            
        FlashSlideKicking:
            BRGY ABCDEFGGGGGGGGGGGGGGGGGG 1;
            Goto Ready3;
        
        FlashSlideKickingStop:
            BRGY FEDCBAA 1;
            Goto Ready3;
            
        FlashPunching:
            BRGS ABCCCCCCCCCCMN 1;
			Goto Ready3;

        GunFlash:
            TNT1 A 0 A_Jump(256, "Flash1", "Flash2", "Flash3", "Flash4", "Flash5", "Flash6", "Flash7", "Flash8");
            TNT1 A 1;
            Stop;
        Flash1:
            BRGM A 1 Bright;
            STOP;
        Flash2:
            BRGM B 1 Bright;
            STOP;
        Flash3:
            BRGM C 1 Bright;
            STOP;
        Flash4:
            BRGM D 1 Bright;
            STOP;
        Flash5:
            BRGM E 1 Bright;
            STOP;
        Flash6:
            BRGM F 1 Bright;
            STOP;
        Flash7:
            BRGM G 1 Bright;
            STOP;
        Flash8:
            BRGM H 1 Bright;
            STOP;
    }
}
