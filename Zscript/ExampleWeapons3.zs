// Includes
#include "./PlasmaBlaster_Functions.zs"
#include "./PlasmaBlaster_Projectiles.zs"
#include "./PlasmaBlaster_Wheel.zs"

class Plasma_Select_Auto : inventory {default{inventory.maxamount 1;}}
class Plasma_Select_Semi : inventory {default{inventory.maxamount 1;}}
class Plasma_Select_Burst : inventory {default{inventory.maxamount 1;}}
class Plasma_Select_Charge : inventory {default{inventory.maxamount 1;}}

// Actual Weapon
class PBX_PlasmaBlaster : PB_WeaponBase
{
    Default
    {
//////////////////////////// WEAPON DATA ////////////////////////////////////////////////////////////////////////////////////
        Weapon.SelectionOrder 2545;
        Weapon.SlotNumber 2;
        Weapon.SlotPriority 0.5;
        PB_WeaponBase.UsesWheel true;
        PB_WeaponBase.WheelInfo "PlasmaBlasterWheel";
	    Inventory.AltHUDIcon "ARMZA0";

//////////////////////////// AMMO ////////////////////////////////////////////////////////////////////////////////////
        Weapon.AmmoType1 "PB_Cell";
        Weapon.AmmoType2 "HellPistolerAmmo";
        Weapon.AmmoGive1 30;

//////////////////////////// MESSAGES & SOUNDS ////////////////////////////////////////////////////////////////////////////////////
        Inventory.Pickupmessage  "$PBX_PlasmaBlaster_Pickup";
        Inventory.PickupSound "CHGNPKUP";
        Obituary "%o was decapitated by %k's Assasin.";
        AttackSound "None";
        Tag "$PBX_PlasmaBlaster_Tag";
        Scale 0.8;

//////////////////////////// WEAPON FLAGS ////////////////////////////////////////////////////////////////////////////////////
        +WEAPON.NOAUTOAIM;
        +WEAPON.NOAUTOFIRE;
        +WEAPON.NO_AUTO_SWITCH;
    }

//////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////////////////////
    bool blasterPrimary;
    bool blasterSecondary;
    int burstcount;
    const MAXCHARGE = 16;
    enum blasterEnum {
        PRIM_SEMI       = 0,
        PRIM_AUTO       = 1,
        SEC_BURST       = 0,
        SEC_CHARGE      = 1,
        TAKE_CHARGE     = 2   // Ammo take charge
    }
//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////

//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////
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

//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
    States
    {
//////////////////////////// SETUP ////////////////////////////////////////////////////////////////////////////////////
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
            AMGR ABCDEF 1;
            TNT1 A 0 PBX_WeaponLower();
			Wait;

        Select:
            TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
			    PB_HandleCrosshair(39);
				A_SetInventory("PB_LockScreenTilt",0);
                PBX_WeaponBase("weapons/smg_magfly1");
			    return PB_RespectIfNeeded();
			}
        SelectAnimation:
            AMGR FEDCBA 1;
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
        Ready3:
			AMGL A 1 {
                PB_HandleCrosshair(39);
                return A_DoPBWeaponAction();
            }
            loop;

//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
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
  
//////////////////////////// ALT FIRE ////////////////////////////////////////////////////////////////////////////////////
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

//////////////////////////// RELOAD ////////////////////////////////////////////////////////////////////////////////////
        Reload:
            TNT1 A 0 PB_CheckReload("RaiseFromEmpty", null,null,"Ready3","Ready3",MAXCHARGE);
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
                    MAXCHARGE);
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

//////////////////////////// UNLOAD ////////////////////////////////////////////////////////////////////////////////////
        Unload:
			TNT1 A 0 A_Jumpif(pb_getmagunloaded(),"Ready3");
            TNT1 A 0 {
				PB_UnloadMag(invoker.ammo2.getclassname(),invoker.ammo1.getclassname());
				PB_SetMagUnloaded(true);
				PB_SetChamberEmpty(true);
			}
            goto Ready3;

//////////////////////////// WEAPON SPECIAL ////////////////////////////////////////////////////////////////////////////////////
        WeaponSpecial:
            TNT1 A 0 A_TakeInventory("GoWeaponSpecialAbility", 1);
            Goto Ready3;            

//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
        FlashPunching:
            MSNQ ABCDEFGHFEDCBA 1;      // 14 frames
            goto Ready3;

        FlashKicking:
            MSNK ABCDEFGHGFEDCBA 1;     // 15 frames
            goto Ready3;

        FlashAirKicking:
            MSNQ ABCDEFGHHGFEDCBA 1;    // 16 frames
            goto Ready3;

        FlashSlideKicking:
            MSNK ABCDEFGHHHHHHHHHHHHHGFEDCBA 1; // 27 frames
            goto Ready3;

        FlashSlideKickingStop:
            MSNK GFEDCBA 1;             // 7 frames
            goto Ready3;
    }
}