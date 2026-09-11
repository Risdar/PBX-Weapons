// Cryo Auto Shotgun from Cat's Frozen Addon Pack
// by SchrödingCat, Eriance/Amuscaria, Realm667
// Bloax, ZZrionTheInsect, Xaser & Ethrill, Tomtefar, SchrödingCat
// Dox778

// Includes
// #include "./PlasmaBlaster_Functions.zs"
// #include "./PlasmaBlaster_Projectiles.zs"
#include "./CryoASG_Wheel.zs"

class CryoASG_Select_Plasma : inventory {default{inventory.maxamount 1;}}
class CryoASG_Select_Freeze : inventory {default{inventory.maxamount 1;}}

// Actual Weapon
class PBX_CryoASG : PBX_WeaponBase
{
    Default
    {
//////////////////////////// WEAPON DATA ////////////////////////////////////////////////////////////////////////////////////
        Weapon.SelectionOrder 2545;
        Weapon.SlotNumber 2;
        Weapon.SlotPriority 0.5;
        PB_WeaponBase.UsesWheel true;
        PB_WeaponBase.WheelInfo "PlasmaBlasterWheel";
	    Inventory.AltHUDIcon "412PA0";

//////////////////////////// AMMO ////////////////////////////////////////////////////////////////////////////////////
        Weapon.AmmoType1 "PB_Cell";
        Weapon.AmmoType2 "CryoASGAmmo";
        Weapon.AmmoGive1 16;

//////////////////////////// MESSAGES & SOUNDS ////////////////////////////////////////////////////////////////////////////////////
        Inventory.Pickupmessage  "$PBX_CryoASG_Pickup";
        Inventory.PickupSound "weapons/sgpump";
        Obituary "$OB_WEAP_CRYOASG";
        AttackSound "None";
        Tag "$PBX_CryoASG_Tag";
        Scale 0.8;

//////////////////////////// WEAPON FLAGS ////////////////////////////////////////////////////////////////////////////////////
        +WEAPON.NOAUTOAIM;
        +WEAPON.NOAUTOFIRE;
        +WEAPON.NO_AUTO_SWITCH;
    }

//////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////////////////////
    int mCurrentMode;

    const DRUM_SIZE = 10;

    enum CryoSGModes {
        ERROR_WHEEL = -2,
        CLOSE_WHEEL,
        PLASMA_MODE,
        FREEZE_MODE,
        LIGHTNING_MODE
    }
//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////

//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////
    action void FireCurrentMode()
    {
        int ofs = PB_GetZoom() ? 3 : 6;
        PB_IncrementHeat();
        A_GunFlash();
        PB_FireOffset();
        PB_LowAmmoSoundWarning("shotgun");

        PB_TakeAmmo(invoker.ammo2.getClassName());
        A_SpawnItemEx("BlueFlareSpawn", 0, 0, -3);
        A_SpawnItemEx("BlueFlareSpawn", 0, 0, 3);

        switch(getCurrentMode())
        {
            case PLASMA_MODE:
                PB_FireBullets("Plasma_Ball",6,ofs,0,0,ofs);
                // PBX_FireLightningShotgun();
                break;

            case FREEZE_MODE:
				A_StartSound("PLSTHRW",CHAN_WEAPON,CHANF_OVERLAP);
                PBX_FireBullets("HotPlasmaGas",6,ofs,0,0,ofs);
                break;
                
            case LIGHTNING_MODE:
                PB_FireBullets("SubZeroProjectile",6,ofs,0,0,ofs);
         		A_FireBullets(8, 6, 6, 18, "SubZ_Puff",FBF_NORANDOM,8192,"CSSG_FrozenTracer",-12);
                break;
        }
    }

    action void FirePrimary()
    {
        A_AlertMonsters();
        PB_WeaponRecoil(random[sfx](-2,2),-1.6);
        A_StartSound("weapons/sg", CHAN_WEAPON);
        A_StartSound("weapons/CryoRifle/missile1", CHAN_AUTO);
        FireCurrentMode();
        PB_DynamicTail("shotgun", "shotgun");
        A_ZoomFactor(0.95);
    }
    
    action CryoSGModes getCurrentMode()
	{
		return invoker.mCurrentMode;
	}

	action void setCurrentMode(CryoSGModes mode)
	{
		invoker.mCurrentMode = mode;
	}
    
    action int getTokens()
	{
		// Prioritize checking the tokens
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
		else if (FindInventory("PBX_CloseWheel"))
			return CLOSE_WHEEL;
		else
			return ERROR_WHEEL;
	}

//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
    States
    {
//////////////////////////// SETUP ////////////////////////////////////////////////////////////////////////////////////
        Spawn:
            412P A -1;
            Stop;

        WeaponRespect:
            A12R ABCD 1 A_DoPBWeaponAction();
            A12G TGGGGHIJK 1 A_DoPBWeaponAction();
            "####" X 0 A_PlaySound("CHAINSPI",1);
            "####" L 6 A_DoPBWeaponAction();
            "####" MNOONNOONNNOOO 1 A_DoPBWeaponAction();
            "####" A 0 A_StopSound(1)
            "####" PQRSGGG 1 A_DoPBWeaponAction();
            "####" X 0 A_PlaySound("Shotgun/Pump2", 5);
            "####" T 1 A_DoPBWeaponAction();
            A12R DCBA 1 A_DoPBWeaponAction();
            Goto Ready3;

        Deselect:
            TNT1 A 0 PBX_WeaponLower();
            A12S ABCDE 1;
			TNT1 A 0 A_Lower();
			Wait;

        Select:
            TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
			    PB_HandleCrosshair(39);
				A_SetInventory("PB_LockScreenTilt",0);
                PBX_WeaponRaise("weapons/smg_magfly1");
			    return PB_RespectIfNeeded();
			}
        SelectAnimation:
            A12S EDCBA 1;
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
        Ready3:
			AMGL A 1 {
                PB_CoolDownBarrel();
                PB_HandleCrosshair(39);
                return A_DoPBWeaponAction();
            }
            loop;

//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
        Fire:
            TNT1 A 0 {
                A_WeaponOffset(0,32);
                PB_SetRoll(0);
                PB_HandleCrosshair(39);
                A_TakeInventory("PB_LockScreenTilt",1);
            }
            TNT1 A 0 PB_JumpIfNoAmmo();
		    A12F AB 1 BRIGHT;
            TNT1 A 0 FirePrimary();
            A12F C 1;
            A12F C 2;
            TNT1 A 0 A_ZoomFactor(1.0);
            A12F D 2 PB_WeaponRecoil(+0.4,0);
            A12F EFG 1 PB_WeaponRecoil(+0.4,0);
            TNT1 A 0 A_WeaponOffset(0,32);
            A12G A 1;
            TNT1 A 0 PB_Refire();
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
                PB_SetMagEmpty(true);
			}
            goto Ready3;

//////////////////////////// WEAPON SPECIAL ////////////////////////////////////////////////////////////////////////////////////
        WeaponSpecial:
            TNT1 A 0 A_TakeInventory("GoWeaponSpecialAbility", 1);
            Goto Ready3;            

//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
        FlashPunching:
            // 14 frames
            A12G BCDEF 1;
            A12G F 4;
            A12G FEDCB 1;  
            goto Ready3;

        FlashKicking:
            // 15 frames
            A12G BCDEF 1;
            A12G F 5;
            A12G FEDCB 1; 
            goto Ready3;

        FlashAirKicking:
            // 16 frames
            A12G BCDEF 1;
            A12G F 6;
            A12G FEDCB 1; 
            goto Ready3;

        FlashSlideKicking:
            // 27 frames
            A12G BCDEF 1;
            A12G F 17;
            A12G FEDCB 1; 
            goto Ready3;

        FlashSlideKickingStop:
            // 7 frames
            A12G FFFEDCB 1;             
            goto Ready3;
    }
}