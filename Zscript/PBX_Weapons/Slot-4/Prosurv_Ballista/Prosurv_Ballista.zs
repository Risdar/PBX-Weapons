// Includes
#include "./CrossbowBallista_Functions.zs"
#include "./CrossbowBallista_Projectiles.zs"
#include "./CrossbowBallista_Wheel.zs"

// Tokens
class CB_Select_DemonicMode : inventory {default{inventory.maxamount 1;}}
class CB_Select_NormalMode : inventory {default{inventory.maxamount 1;}}
class CB_Select_NO : inventory {default{inventory.maxamount 1;}}
class Crossbow_Upgraded : inventory {default{inventory.maxamount 1;}}

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
	int currentTakeAmmo;
	const ARROW_AMOUNT	 		= 1; 
	const ammoTakeNormal 		= 1; // Normal Shot
	const ammoTakeDemonic 		= 3; // Demonic Shot
	const ammoTakeNormalAlt 	= 1; // Normal Altfire (PB_RocketAmmo)
	const ammoTakeDemonicAlt 	= 5; // Demonic Altfire (PB_Fuel)

//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
	States
	{
//////////////////////////// SETUP ////////////////////////////////////////////////////////////////////////////////////
		Spawn:
			CBOW S -1;
            Stop;
        Deselect:
		    CRBW LMNO 1;
			CBOW P 1;
			TNT1 AAA 0 A_lower();
			Wait;
		WeaponRespect:
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
			CBOW Q 1 A_DoPBWeaponAction();
			CRBW TSRQ 1 A_DoPBWeaponAction();
			CRBW A 5 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
			CBWR ABCDEF 1 {
				PB_SetRoll(roll-.4);
                return A_DoPBWeaponAction();
			}
			CBWR GGGGGGGGG 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySoundEx("Ironsights","Auto");
			CBWR HIJKKKKKKK 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/drawstring","Auto");
			CBWR LMNOP 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySoundEx("Ironsights","Auto");
			CBOR AB 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/boltin","Auto");
			CBOR CDE 1 A_DoPBWeaponAction();
			CBOR FG 1 {
				PB_SetRoll(roll-.3);
                return A_DoPBWeaponAction();
			}
			CBOR H 1 {
				PB_SetRoll(roll+.3);
                return A_DoPBWeaponAction();
			}
			CBOR IJ 1 {
				PB_SetRoll(roll+.4);
                return A_DoPBWeaponAction();
			}
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
			CBOR KLMN 1 {
				PB_SetRoll(roll+.4);
                return A_DoPBWeaponAction();
			}
			Goto Ready3;
			
		Select:
			TNT1 A 0 PB_WeaponRaise("weapons/ballista/raise");
			TNT1 A 0 PB_RespectIfNeeded();
		SelectContinue:
			TNT1 A 0;
		SelectAnimation:
			TNT1 A 0 genericChecker("SelectAnimationUnloaded","SelectAnimationUpgraded");
            CRBW ONML 1;
			goto Ready3;
		SelectAnimationUpgraded:
			CBOW R 1;
			CRBW YXWV 1;
			Goto Ready3;
		SelectAnimationUnloaded:
			CBOW Q 1;
			CRBW TSRQ 1;
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
		Ready3:
			TNT1 A 0 PB_HandleCrosshair(29);
			TNT1 A 0 genericChecker("ReadyEmpty","ReadyDemonic");
		ReadyNormal:
			CRBW B 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			goto Ready3;
            
		ReadyDemonic:
		    CRBW CDED 3 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			goto Ready3;

		ReadyEmpty:
            TNT1 A 0 A_PlaySound("weapons/empty", 4);
		ReadyEmptyActual:
		    CRBW A 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			loop;
		
//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
		Fire:
			TNT1 A 0 PB_HandleCrosshair(29);
			TNT1 A 0 genericChecker("Reload","FireDemonic");
			CRBW F 1 FireWeapon(0,1);
			CRBW G 1 FireWeapon(0,2);
			CRBW J 1 FireWeapon(0,3);
			CRBW JJ 1 FireWeapon(0,4);
			CRBW J 1 FireWeapon(0,5);
			CRBW JA 2 A_WeaponReady(WRF_NOFIRE|WRF_NOBOB);
			goto Reload;
		FireDemonic:
			CRBW K 1 BRIGHT FireWeapon(1,1);
			CRBW G 1 BRIGHT FireWeapon(1,2);
			CRBW J 1 FireWeapon(1,3);
			CRBW JJ 1 FireWeapon(1,4);
			CRBW J 1 FireWeapon(1,5);
			CRBW JA 2 A_WeaponReady(WRF_NOFIRE|WRF_NOBOB);
			goto Reload;
		

//////////////////////////// ALTFIRE ////////////////////////////////////////////////////////////////////////////////////
		Altfire:
			TNT1 A 0 genericChecker("ReadyEmpty","AltFireDemonic");
			TNT1 A 0 checkAltfire();
			CRBW F 1 FireWeapon(2,1);
			CRBW G 1 FireWeapon(2,2);
			CRBW J 1 FireWeapon(2,3);
			CRBW JJ 1 FireWeapon(2,4);
			CRBW J 1 FireWeapon(2,5);
			CRBW JA 2 A_WeaponReady(WRF_NOFIRE|WRF_NOBOB);
			goto Reload;
		AltFireDemonic:
			TNT1 A 0 checkAltfire(true);
			CRBW K 1 BRIGHT FireWeapon(3,1);
			CRBW G 1 BRIGHT FireWeapon(3,2);
			CRBW J 1 FireWeapon(3,3);
			CRBW JJ 1 FireWeapon(3,4);
			CRBW J 1 FireWeapon(3,5);
			CRBW JA 2 A_WeaponReady(WRF_NOFIRE|WRF_NOBOB);
			goto Reload;

//////////////////////////// RELOAD ////////////////////////////////////////////////////////////////////////////////////
		Reload:
            TNT1 A 0 PB_CheckReload(null, null, null, "Ready3", "ReadyEmpty", ARROW_AMOUNT, getCurrentAmmoTake());
			// Raise
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
			CBWR ABCDEF 1 PB_SetRoll(roll-.4);
			CBWR GGGGGGGGG 1 ;
			TNT1 A 0 A_PlaySoundEx("Ironsights","Auto");
			// Pulll the bowstring
			CBWR HIJKKKKKKK 1;
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/drawstring","Auto");
			CBWR LMNOPPPPP 1;
			TNT1 A 0 A_JumpIf(isDemonicBallistaMode(),"ReloadDemonic");
		StandardReload:
			// Put the Arrow in
			CBOR AB 1;
			TNT1 A 0 {
				A_SetInventory(invoker.ammo2.getclassname(),1); // Gives the arrow
				A_TakeInventory(invoker.ammo1.getclassname(),1,TIF_NOTAKEINFINITE); // Take 1 reserve
				PB_SetMagUnloaded(false);
				PB_SetMagEmpty(false);
				PB_SetChamberEmpty(false);
			}
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/boltin","Auto");
			CBOR CDE 1;
			CBOR FG 1 PB_SetRoll(roll-.3);
			CBOR H 1 PB_SetRoll(roll+.3);
			CBOR IJ 1 PB_SetRoll(roll+.4);
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
			// Lower
			CBOR KLMN 1 PB_SetRoll(roll+.4);
			TNT1 A 0 PB_SetReloading(false);
			goto Ready3;
		ReloadDemonic:
			CBOR OPQ 1 PB_SetRoll(roll+.3);
			TNT1 A 0 {
				A_SetInventory(invoker.ammo2.getclassname(),1);
				A_TakeInventory("PB_DTech",3,TIF_NOTAKEINFINITE);
				PB_SetMagUnloaded(false);
				PB_SetMagEmpty(false);
				PB_SetChamberEmpty(false);
			}
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/boltinoutdemonic","Auto");
			CBOR RST 1 PB_SetRoll(roll-.3);
			CBOR UU 1;
			CBOR UU 1 PB_SetRoll(roll+.4);
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
			CBOR VWXY 1 PB_SetRoll(roll+.4);
			goto Ready3;


//////////////////////////// UNLOAD ////////////////////////////////////////////////////////////////////////////////////
		Unload:
			TNT1 A 0 genericChecker("ReadyEmpty","UnloadDemonic");
			// Raise
			CBOR NMLK 1 PB_SetRoll(roll+.4);
			// Put the Arrow out
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
			CBOR JI 1 PB_SetRoll(roll+.4);
			CBOR H 1 PB_SetRoll(roll+.3);
			CBOR GF 1 PB_SetRoll(roll-.3);
			CBOR EDC 1;
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/boltout","Auto");
			TNT1 A 0 {
				PB_UnloadMag(invoker.ammo2.getclassname(),invoker.ammo1.getclassname(),getCurrentAmmoTake(),spawnActor: "BoltPickup");
				PB_SetMagUnloaded(true);
				PB_SetMagEmpty(true);
				PB_SetChamberEmpty(true);
			}
			CBOR BA 1;
			CBWR P 1;
			TNT1 A 0 actualModeChange();
		FinishUnload:
			// Release the bowstring
			CBWR PPPPONML 1;
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/drawstring","Auto");
			CBWR KKKKKKKJIH 1;
			// Loewr
			TNT1 A 0 A_PlaySoundEx("Ironsights","Auto");
			CBWR GGGGGGGGG 1 ;
			CBWR FEDCBA 1 PB_SetRoll(roll-.4);
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
			goto Ready3;

		UnloadDemonic:
			CBOR YXWV 1 PB_SetRoll(roll+.4);
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/raise","Auto");
			CBOR UU 1 PB_SetRoll(roll+.4);
			CBOR UU 1;
			CBOR TSR 1 PB_SetRoll(roll-.3);
			TNT1 A 0 A_PlaySoundEx("weapons/ballista/boltinoutdemonic","Auto");
			TNT1 A 0 {
				PB_UnloadMag(invoker.ammo2.getclassname(),"PB_DTech",getCurrentAmmoTake());
				PB_SetMagUnloaded(true);
				PB_SetMagEmpty(true);
				PB_SetChamberEmpty(true);
			}
			CBOR QPO 1 PB_SetRoll(roll+.3);
			TNT1 A 0 actualModeChange();
			goto FinishUnload;
		
//////////////////////////// WEAPON SPECIAL ////////////////////////////////////////////////////////////////////////////////////
		Weaponspecial:
           TNT1 A 0 A_Takeinventory("GoWeaponSpecialAbility",1);
		   TNT1 A 0 HandleWheel();
		   goto Ready3;
		
//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
		FlashPunching:
			TNT1 A 0 genericChecker("FlashPunchingUnloaded", "FlashPunchingUpgraded");
			CBOW ABCDEEEEEEDCBA 1;
			goto Ready3;
		FlashPunchingUpgraded:
			CBOW KLMNOOOOOONMLK 1;
			goto Ready3;
		FlashPunchingUnloaded:
			CBOW FGHIJJJJJJIHGF 1;
			goto Ready3;

        FlashKicking:
			TNT1 A 0 genericChecker("FlashKickingUnloaded", "FlashKickingUpgraded");
			CRBW LMNOPPPPPPONML 1;
			goto Ready3;
		FlashKickingUpgraded:
			CRBW VWXYZZZZZZYXWV 1;
			Goto Ready3;
		FlashKickingUnloaded:
			CRBW QRSTUUUUUUTSRQ 1;
			Goto Ready3;
			
		FlashAirKicking:
			TNT1 A 0 genericChecker("FlashAirKickingUnloaded", "FlashAirKickingUpgraded");
			CRBW LMNOPPPPPPONML 1;
			goto Ready3;
		FlashAirKickingUpgraded:
			CRBW VWXYZZZZZZYXWV 1;
			Goto Ready3;
		FlashAirKickingUnloaded:
			CRBW QRSTUUUUUUTSRQ 1;
			Goto Ready3;
			
		FlashSlideKicking:
			TNT1 A 0 genericChecker("FlashSlideKickingUnloaded", "FlashSlideKickingUpgraded");
            CRBW LMNO 1;
			CRBW P 21;
			goto Ready3;
		FlashSlideKickingUnloaded:
			CRBW QRST 1;
			CRBW U 21;
			Goto Ready3;
		FlashSlideKickingUpgraded:
			CRBW VWXY 1;
			CRBW Z 21;
			Goto Ready3;
			
		FlashSlideKickingStop:
			TNT1 A 0 genericChecker("FlashSlideKickingStopUnloaded", "FlashSlideKickingStopUpgraded");
			CRBW PPPONML 1;
			goto Ready3;
		FlashSlideKickingStopUnloaded:
			CRBW UUUTSRQ 1;
			Goto Ready3;
		FlashSlideKickingStopUpgraded:
			CRBW ZZZYXWV 1;
			Goto Ready3;
	}
}