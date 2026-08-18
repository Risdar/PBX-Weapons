// Includes
#include "./CrossbowBallista_Functions.zs"
#include "./CrossbowBallista_Wheel.zs"

// Tokens
class CB_Select_DemonicMode : inventory {default{inventory.maxamount 1;}}
class CB_Select_ExplosiveMode : inventory {default{inventory.maxamount 1;}}
class CB_Select_NormalMode : inventory {default{inventory.maxamount 1;}}
class CB_Select_NO : inventory {default{inventory.maxamount 1;}}
class Crossbow_Upgraded : inventory {default{inventory.maxamount 1;}}

class PBX_Prosurv_Ballista : PBX_WeaponBase
{
	Default
	{
        //$Title Ballista Crossbow
        //$Category Weapons
        //$Sprite CBOWS0
        ////SpawnID 9530;
		Weapon.SlotNumber 4;
		Weapon.SlotPriority 0;
	    Weapon.SelectionOrder 506;
        PB_WeaponBase.UsesWheel true;
		PB_WeaponBase.ReserveToMagAmmoFactor 1;
		PB_WeaponBase.WheelInfo "CrossbowBallistaWheel";
        Inventory.AltHudIcon "CB_ZA0";
		
		Weapon.AmmoType1 "PB_HighCalMag";
	    Weapon.AmmoType2 "CrossbowBallistaAmmo";
	    Weapon.AmmoGive1 HIGHCAL_AMMO_GIVE;
		
        Weapon.BobStyle "InverseSmooth";
        Scale 0.7;

        Obituary "%k Speared %o with a Ballista";
        Inventory.PickupMessage "$PBX_CrossbowBallista_Pickup";
        Inventory.PickupSound "weapons/ballista/drawstring";
	    Tag "$PBX_CrossbowBallista_Tag";
        
        +WEAPON.NOAUTOAIM
        +WEAPON.NOAUTOFIRE
        +FORCEXYBILLBOARD
        +FLOORCLIP
        +DONTGIB
	}
	
    bool unwindString;
	int currentMode;
	const ARROW_AMOUNT	 	= 1; // This is kinda dumb lol but oh well... consistency
	const ammoTakeNormal	= 1; // Normal Shot
	const ammoTakeDemonic 	= 5; // Demonic Shot

	const HIGHCAL_AMMO_GIVE = 15; 
	const ROCKET_AMMO_GIVE 	= 10; 

	enum crossbowMode
	{
        CLOSE_WHEEL = -2,
        UNLOADED,
        NO_UPGRADE,
		NORMAL_BOLT,
		EXPLOSIVE_BOLT,
		DEMONIC_BOLT
	}

    States
    {
        CacheSprites:
            CB0S A 0; CB1S A 0; CB2S A 0; CB3S A 0;
            CB0T A 0; CB1T A 0; CB2T A 0; CB3T A 0;
            CB0P A 0; CB1P A 0; CB2P A 0; CB3P A 0;
            CB0K A 0; CB1K A 0; CB2K A 0; CB3K A 0;
            CB_F A 0; CB_G A 0;

        Spawn:
            CB_Z A -1;
            Stop;

        Deselect:
            TNT1 A 0 {
                A_WeaponOffset(0,32);
                PB_SetRoll(0);
                A_SetCrosshair(-1);
                PB_SetZoom(false);
            }
        ActualDeselect:
		    CB_A EDCBA 1 setCrossbowSprite("CB0S","CB1S","CB2S","CB3S");
			TNT1 AAA 0 A_lower();
			Wait;

        WeaponRespect:
            TNT1 A 1;
        ContinueRespectBolt:
            TNT1 A 0 A_PlaySoundEx("Ironsights","Auto");
            TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
            CB0P EDCBA 1 A_DoPBWeaponAction();
            CB0S E 5 A_DoPBWeaponAction();
            TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
            CB_E ABCDEF 1 {
                PB_SetRoll(roll-.4);
                return A_DoPBWeaponAction();
            }
            CB_E GGGGGGGGG 1 A_DoPBWeaponAction();
            TNT1 A 0 A_PlaySoundEx("Ironsights","Auto");
            CB_E HIJKKKKKKK 1 A_DoPBWeaponAction();
            TNT1 A 0 A_PlaySoundEx("weapons/ballista/drawstring","Auto");
            CB_E LMNOP 1 A_DoPBWeaponAction();
            // Switch to another animation depending on weapon state
            TNT1 A 0 {
                if(pb_getmagunloaded())
                    return resolvestate("RespectEmpty");
                else if(getCrossbowMode() == DEMONIC_BOLT)
                    return resolvestate("ContinueRespectDemonic");
                else
                    return resolvestate(null);
            }
            CB_F AB 1 {
                setCrossbowSprite("TNT1","CB_F","CB_G","TNT1");
                return A_DoPBWeaponAction();
            }
            TNT1 A 0 A_PlaySoundEx("weapons/ballista/boltin","Auto");
            CB_F CDE 1 {
                setCrossbowSprite("TNT1","CB_F","CB_G","TNT1");
                return A_DoPBWeaponAction();
            }
            CB_F FFFFF 1 {
                setCrossbowSprite("TNT1","CB_F","CB_G","TNT1");
                return A_DoPBWeaponAction();
            }
            CB_F FG 1 {
                PB_SetRoll(roll-.3);
                setCrossbowSprite("TNT1","CB_F","CB_G","TNT1");
                return A_DoPBWeaponAction();
            }
            CB_F HHHHH 1 {
                setCrossbowSprite("TNT1","CB_F","CB_G","TNT1");
                return A_DoPBWeaponAction();
            }
            CB_F H 1 {
                setCrossbowSprite("TNT1","CB_F","CB_G","TNT1");
                PB_SetRoll(roll+.3);
                return A_DoPBWeaponAction();
            }
            CB_F IJ 1 {
                setCrossbowSprite("TNT1","CB_F","CB_G","TNT1");
                PB_SetRoll(roll+.4);
                return A_DoPBWeaponAction();
            }
            TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
            CB_F KLMN 1 {
                setCrossbowSprite("TNT1","CB_F","CB_G","TNT1");
                PB_SetRoll(roll+.4);
                return A_DoPBWeaponAction();
            }
            goto Ready3;

        ContinueRespectDemonic:
            TNT1 A 0 A_PlaySoundEx("weapons/ballista/boltinoutdemonic","Auto");
            CB_H ABC 1 PB_SetRoll(roll+.3);
            CB_H DEF 1 PB_SetRoll(roll-.3);
            CB_H GG 1;
            CB_H GG 1 PB_SetRoll(roll+.4);
            TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
            CB_H HIJK 1 PB_SetRoll(roll+.4);
            goto Ready3;

        Select:
            TNT1 A 0 {
                A_WeaponOffset(0,32);
                PB_SetRoll(0);
                PB_HandleCrosshair(29);
                PBX_WeaponRaise("weapons/ballista/raise");
                return PB_RespectIfNeeded();
            }
        SelectAnimation:
            CB1S ABCDE 1 setCrossbowSprite("CB0S","CB1S","CB2S","CB3S");
            goto Ready3;
            
        RespectEmpty:
            TNT1 A 0 A_PlaySoundEx("Ironsights","Auto");
            CB_E FED 1 {
                PB_SetRoll(roll+.4);
                return A_DoPBWeaponAction();
            }
            CB_E CB 1 {
                PB_SetRoll(roll+.4);
                return A_DoPBWeaponAction();
            }
            TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
            CB_E A 1 {
                PB_SetRoll(roll+.4);
                return A_DoPBWeaponAction();
            }
            CB0S EEE 1 A_DoPBWeaponAction();
        // Fallthrough to Ready3
        Ready3:    
            TNT1 A 0 {
                PB_SetRoll(0);
                A_TakeInventory("PB_LockScreenTilt",1);
                PB_HandleCrosshair(29);
            }
            TNT1 A 0 A_JumpIf(PB_GetZoom(),"Ready2");
            TNT1 A 0 readyCheck("ReadyToFireDemonic","ReadyToFireExplosive");
        ReadyToFire:
            CB1S E 1 {				
                PB_HandleCrosshair(29);
                setCrossbowSprite("CB0S","CB1S","TNT1","TNT1");
                return PB_ReadyFire(ads:false);
            }
            Loop;

        ReadyToFireExplosive:
            CB2S EEEEEEEEEEEEEEEEEEEEFGHGF 1 {
                PB_HandleCrosshair(29);
                return PB_ReadyFire(ads:false);
            }
            Loop;

        ReadyToFireDemonic:
            CB3S EEEFFFGGGFFF 1 {
                PB_HandleCrosshair(29);
                return PB_ReadyFire(ads:false);
            }
            Loop;

        Ready2:
            TNT1 A 0 {
                PB_SetRoll(0);
                A_TakeInventory("PB_LockScreenTilt",1);
                A_SetCrosshair(-1);
            }
            TNT1 A 0 readyCheck("Ready2Demonic","Ready2Explosive");
        ReadyToFire2:
            CB1T E 1 {
                A_SetCrosshair(-1);
                setCrossbowSprite("CB0T","CB1T","TNT1","TNT1");
                return PB_ReadyFire(ads:true);
            }
            Loop;

        Ready2Explosive:
            CB2T EEEEEEEEEEEEEEEEEEEEFGHGF 1 {
                A_SetCrosshair(-1);
                return PB_ReadyFire(ads:true);
            }
            Loop;

        Ready2Demonic:
            CB3T EFGF 3 {
                A_SetCrosshair(-1);
                return PB_ReadyFire(ads:true);
            }
            Loop;

        Fire:
            TNT1 A 0 A_JumpIf(PB_GetZoom(),"Fire2");
            TNT1 A 0 PB_JumpIfNoAmmo("Ready3");
			TNT1 A 0 PB_HandleCrosshair(29);
            TNT1 A 0 A_JumpIf(getCrossbowMode() == DEMONIC_BOLT,"FireDemonic");
            TNT1 A 0 A_PlaySoundEx("weapons/ballista/firebolt","Auto");
            CB_B A 1 ;
            TNT1 A 0 FireWeapon();
            CB_B B 1 ;
        ContinueFire:
            CB_B C 0 A_SetPitch(getCrossbowMode() == DEMONIC_BOLT ? -3.5 : -1.5 + pitch);
            CB_B C 0 A_ZoomFactor(1.00);
            CB_B C 1 A_SetPitch(+1.0 + pitch);
            CB_B CC 1 A_SetPitch(+1.0 + pitch);
            CB_B C 1 A_SetPitch(+0.5 + pitch);
            CB_B C 2 A_WeaponReady(WRF_NOFIRE|WRF_NOBOB);
            goto Reload;

        FireDemonic:
            TNT1 A 0 A_PlaySoundEx("weapons/ballista/firedemonic","Auto");
            CB_B D 1 BRIGHT;
            TNT1 A 0 FireWeapon();
            CB_B B 1 BRIGHT;
            goto ContinueFire;

        Fire2:
            TNT1 A 0 PB_JumpIfNoAmmo("Ready2");
			TNT1 A 0 A_SetCrosshair(-1);
            TNT1 A 0 A_JumpIf(getCrossbowMode() == DEMONIC_BOLT,"Fire2Demonic");
            TNT1 A 0 A_PlaySoundEx("weapons/ballista/firebolt","Auto");
            CB_M A 1 ;
            TNT1 A 0 FireWeapon();
            CB_M B 1 ;
        ContinueFire2:
            CB_M C 0 A_SetPitch(-1.2 + pitch);
            CB_M C 0 A_ZoomFactor(1.5);
            CB_M C 1 A_SetPitch(+0.7 + pitch);
            CB_M CC 1 A_SetPitch(+0.7 + pitch);
            CB_M C 1 A_SetPitch(+0.2 + pitch);
            CB_M C 2 A_WeaponReady(WRF_NOFIRE| WRF_NOBOB);
            goto Reload;

        Fire2Demonic:
            TNT1 A 0 A_PlaySoundEx("weapons/ballista/firedemonic","Auto");
            CB_M D 1 BRIGHT;
            TNT1 A 0 FireWeapon();
            CB_M B 1 BRIGHT;
            goto ContinueFire2;
            
        AltFire:
            TNT1 A 0 {
                PB_SetRoll(0);
                PB_HandleCrosshair(29);
                A_TakeInventory("PB_LockScreenTilt",1);
            }
            TNT1 A 0 A_StartSound("IronSights", 0);
            TNT1 A 0 A_JumpIf(PB_GetZoom(),"ZoomOut");
        ZoomIn:
            TNT1 A 0 A_ZoomFactor(1.5);
            CB1T ABCD 1 setCrossbowSprite("CB0T","CB1T","CB2T","CB3T");
            TNT1 A 0 {
                PB_SetZoom(true);
                A_SetCrosshair(-1);
            }
            Goto Ready2;

        ZoomOut:
            TNT1 A 0 PB_HandleCrosshair(29);
            CB1T DCBA 1 setCrossbowSprite("CB0T","CB1T","CB2T","CB3T");
            TNT1 A 0 PB_SetZoom(false);
            TNT1 A 0 {
                if(checkTokens())
                    return resolvestate("unload");
                return resolvestate(null);
            }
            Goto Ready3;

        Weaponspecial:
           TNT1 A 0 A_Takeinventory("GoWeaponSpecialAbility",1);
		   TNT1 A 0 HandleWheel();
		   goto Unload;

        Reload:
            TNT1 A 0 {
                A_SetCrosshair(-1);
                A_Giveinventory("PB_LockScreenTilt",1);
                PB_SetZoom(false);
            }
            TNT1 A 0 A_JumpIf(invoker.ammo1.amount < invoker.ReserveToMagAmmoFactor, "Ready3");
            TNT1 A 0 A_JumpIf(invoker.unwindString, "ContinueReload");
            TNT1 A 0 PB_CheckReload(null, null, null, "Ready3", "Ready3", ARROW_AMOUNT, invoker.ReserveToMagAmmoFactor);
        StandardReload:
            TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
            CB_E ABCDEF 1 PB_SetRoll(roll-.4);
            CB_E GGGGGGGGG 1 ;
            TNT1 A 0 A_PlaySoundEx("Ironsights","Auto");
            CB_E HIJKKKKKKK 1;
            TNT1 A 0 A_PlaySoundEx("weapons/ballista/drawstring","Auto");
            CB_E LMN 1;
			TNT1 A 0 PB_SetMagUnloaded(true);
            CB_E OPPPPP 1;
        ContinueReload: // Used by the mode change
            TNT1 A 0 A_JumpIf(invoker.ammo1.amount < invoker.ReserveToMagAmmoFactor, "ContinueUnload"); // Edge case where you mode change but has no reserve
            TNT1 A 0 A_JumpIf(getCrossbowMode() == DEMONIC_BOLT,"ReloadDemonic");
            CB_F AB 1 setCrossbowSprite("TNT1","CB_F","CB_G","TNT1");
            TNT1 A 0 A_PlaySoundEx("weapons/ballista/boltin","Auto");
            CB_F CDE 1 setCrossbowSprite("TNT1","CB_F","CB_G","TNT1");
            CB_F FG 1 {
                setCrossbowSprite("TNT1","CB_F","CB_G","TNT1");
                PB_SetRoll(roll-.3);
                invoker.unwindString = true;
            }
            TNT1 A 0 {
				A_SetInventory(invoker.ammo2.getclassname(),ARROW_AMOUNT); // Gives the arrow
				A_TakeInventory(invoker.ammo1.getclassname(),invoker.ReserveToMagAmmoFactor,TIF_NOTAKEINFINITE); // Take 1 reserve
                A_PlaySoundEx("Ironsights","Auto");
				PB_SetMagUnloaded(false);
				PB_SetMagEmpty(false);
				PB_SetChamberEmpty(false);
			}
            CB_F H 1 {
                setCrossbowSprite("TNT1","CB_F","CB_G","TNT1");
                PB_SetRoll(roll+.3);
            }
            CB_F IJ 1 {
                setCrossbowSprite("TNT1","CB_F","CB_G","TNT1");
                PB_SetRoll(roll+.4);
            }
            TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
            CB_F KLMN 1 {
                setCrossbowSprite("TNT1","CB_F","CB_G","TNT1");
                PB_SetRoll(roll+.4);
            }
        EndReload:
            TNT1 A 0 {
                invoker.unwindString = false;
                PB_SetReloading(false);
            }
            Goto Ready3;

		ReloadDemonic:
            CB_H ABC 1 PB_SetRoll(roll+.3);
            CB_H DEF 1 PB_SetRoll(roll-.3);
            CB_H GG 1;
            TNT1 A 0 {
				A_SetInventory(invoker.ammo2.getclassname(),ARROW_AMOUNT); // Gives the arrow
				A_TakeInventory(invoker.ammo1.getclassname(),invoker.ReserveToMagAmmoFactor,TIF_NOTAKEINFINITE); // Take 1 reserve
                A_PlaySoundEx("Ironsights","Auto");
				PB_SetMagUnloaded(false);
				PB_SetMagEmpty(false);
				PB_SetChamberEmpty(false);
			}
            CB_H GG 1 PB_SetRoll(roll+.4);
            TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
            CB_H HIJK 1 PB_SetRoll(roll+.4);
            Goto EndReload;

        Unload:
            TNT1 A 0 {
                A_SetCrosshair(-1);
                A_Giveinventory("PB_LockScreenTilt",1);
                PB_SetZoom(false);
            }
            TNT1 A 0 A_JumpIf(checkTokens() && PB_GetChamberEmpty(), "ContinueUnload"); // Skip the taking out arrow animation
            TNT1 A 0 A_JumpIf(getCrossbowMode() == DEMONIC_BOLT, "UnloadDemonic");
            CB_F NMLK 1 {
                setCrossbowSprite("TNT1","CB_F","CB_G","TNT1");
                PB_SetRoll(roll+.4);
            }
            CB_F JI 1 {
                setCrossbowSprite("TNT1","CB_F","CB_G","TNT1");
                PB_SetRoll(roll+.4);
            }
            CB_F H 1 {
                setCrossbowSprite("TNT1","CB_F","CB_G","TNT1");
                PB_SetRoll(roll-.3);
            }
            TNT1 A 0 A_PlaySoundEx("weapons/ballista/boltout","Auto");
            TNT1 A 0 {
                unloadCrossbow();
                PB_SetChamberEmpty(true);
                PB_SetMagEmpty(true);
                PB_SetMagUnloaded(true);
            }
            CB_F GF 1 {
                setCrossbowSprite("TNT1","CB_F","CB_G","TNT1");
                PB_SetRoll(roll+.3);
            }
            CB_F EDC 1 setCrossbowSprite("TNT1","CB_F","CB_G","TNT1");
            CB_F BA 1 setCrossbowSprite("TNT1","CB_F","CB_G","TNT1");
        ContinueUnload:
            TNT1 A 0 A_PlaySoundEx("Ironsights","Auto");
            TNT1 A 0 A_PlaySoundEx("weapons/ballista/drawstring","Auto");
            CB_E PPPPP 1;
            TNT1 A 0 handleModeChange(); // actual mode change here, jumps to ContinueReload
            CB_E ONM 1;
            TNT1 A 0 A_PlaySoundEx("Ironsights","Auto");
            CB_E KKKKKKKIH 1;
            CB_E GGGGGGGGG 1;
            CB_E FEDCBA 1 PB_SetRoll(roll+.4);
            TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
            TNT1 A 0 PB_SetReloading(false);
            Goto Ready3;

        UnloadDemonic:
            CB_H KJIH 1 PB_SetRoll(roll-.4);
            TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
            CB_H GG 1;
            CB_H GG 1 PB_SetRoll(roll-.4);
            TNT1 A 0 A_PlaySoundEx("weapons/ballista/boltinoutdemonic","Auto");
            TNT1 A 0 {
                unloadCrossbow();
                PB_SetChamberEmpty(true);
                PB_SetMagEmpty(true);
                PB_SetMagUnloaded(true);
            }
            CB_H FED 1 PB_SetRoll(roll+.3);
            CB_H CBA 1 PB_SetRoll(roll-.3);
            Goto ContinueUnload;

        FlashPunching:
            CB1P ABCDEEEEEEDCBA 1 setCrossbowSprite("CB0P","CB1P","CB2P","CB3P");
            goto Ready3;

        FlashKicking:
            CB1K ABCDEEEEEEDCBA 1 setCrossbowSprite("CB0K","CB1K","CB2K","CB3K");
            goto Ready3;

        FlashAirKicking:
            CB1K ABCDEEEEEEEDCBA 1 setCrossbowSprite("CB0K","CB1K","CB2K","CB3K");
            goto Ready3;

        FlashSlideKicking:
            CB1K ABCD 1 setCrossbowSprite("CB0K","CB1K","CB2K","CB3K");
            CB1K E 21 setCrossbowSprite("CB0K","CB1K","CB2K","CB3K");
            goto Ready3;

        FlashSlideKickingStop:
            CB1K EEEDCBA 1 setCrossbowSprite("CB0K","CB1K","CB2K","CB3K");
            goto Ready3;

    }

}