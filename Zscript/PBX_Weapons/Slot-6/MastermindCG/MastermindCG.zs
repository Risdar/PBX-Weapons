// Includes
#include "./MastermindCG_Functions.zs"
#include "./MastermindCG_helpers.zs"

// Constants
const MastermindCGFullDurability = 100;

class PBX_MastermindChaingun : PB_WeaponBase
{
	Default
	{
        //$Title Spider Mastermind Chaingun
        //$Category Weapons
        //$Sprite RMN2A0
//////////////////////////// WEAPON DATA ////////////////////////////////////////////////////////////////////////////////////
		Weapon.SlotNumber 6;
		Weapon.SlotPriority 0;
	    Weapon.SelectionOrder 3800;
        Inventory.AltHudIcon "RMN2A0";
		PB_WeaponBase.ReserveToMagAmmoFactor 1;
		
		Weapon.BobRangeX 0.3;
		Weapon.BobRangeY 0.5;
		Weapon.BobStyle "InverseSmooth";
   		Weapon.BobSpeed 2.0;
    	FloatBobStrength 0.5;
		Scale 0.9;
//////////////////////////// AMMO ///-/////////////////////////////////////////////////////////////////////////////////
		Weapon.AmmoType1 "PB_RocketAmmo";
		// Weapon.AmmoType2 "MastermindCGDurability";
	    Weapon.AmmoGive1 50;
		
//////////////////////////// MESSAGES & SOUNDS ////////////////////////////////////////////////////////////////////////////////////
		Obituary "Mowed down by Mastermind's Chaingun.";
		Inventory.Pickupmessage "$PBX_MastermindCG_Pickup";
		Inventory.PickupSound "CBOXPKUP";
		Tag "$PBX_MastermindCG_Tag";
        
//////////////////////////// WEAPON FLAGS ////////////////////////////////////////////////////////////////////////////////////
        +WEAPON.NOAUTOAIM
        +WEAPON.EXPLOSIVE
        +WEAPON.NOAUTOFIRE
        +FORCEXYBILLBOARD
        +FLOORCLIP
        +DONTGIB
	}

//////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////////////////////
	bool SoulSeekerMode;
	const ammoTake = 2; // How many rockets does it take for one point of durability
      
//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
	States
	{
//////////////////////////// SETUP ////////////////////////////////////////////////////////////////////////////////////
		Spawn:
            TRP6 A -1;
            Stop;
        Steady:
            TNT1 A 0;
            Goto Ready;
        Deselect:
           TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(-1);
				A_TakeInventory("PB_LockScreenTilt",1);
			}
			TNT1 A 0 A_StopSound(6);
			TNT1 A 0 A_ZoomFactor(1);
			RMNG JKLMN 1;
			TNT1 A 0 A_Lower();
			Wait;
		Select:
			TNT1 A 0 PB_WeaponRaise("CBOXPKUP");
			// TNT1 A 0 PB_RespectIfNeeded();
		SelectContinue:
			TNT1 A 0;
		SelectAnimation:
			RMNG NMLKJ 1 A_GunFlash();
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
		Ready:
		Ready3:
			TNT1 A 0 PB_HandleCrosshair(69);
			TNT1 A 0 PB_CoolDownBarrel();
			RMNG F 1 A_DoPBWeaponAction();
			Loop;
		
//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
		Fire:
            TNT1 A 0 MastermindCG_HandleAmmo();
            TNT1 AAAA 0;
			RMNG A 1 BRIGHT MastermindCG_FireWeapon(0,1);
			RMNG G 1 BRIGHT MastermindCG_FireWeapon(0,2);
			RMNG HI 1 BRIGHT MastermindCG_FireWeapon(0,3);
		FireSecondShot:
            TNT1 A 0 MastermindCG_HandleAmmo();
			RMNG B 1 BRIGHT MastermindCG_FireWeapon(0,1);
			RMNG G 1 BRIGHT MastermindCG_FireWeapon(0,2);
			RMNG HI 1 BRIGHT MastermindCG_FireWeapon(0,3);
			TNT1 A 0 PB_ReFire();
			RMNG FCDEF 1 A_DoPBWeaponAction();
			RMNG CDEF 2 A_DoPBWeaponAction();
			RMNG CDE 3 A_DoPBWeaponAction();
			goto Ready3;

		Reload:
			TNT1 A 0;
			goto Ready3;

//////////////////////////// ALT FIRE ////////////////////////////////////////////////////////////////////////////////////
		// AltFire:
		// 	TNT1 A 0 { invoker.shotCount = 0; }
		// AltFireLoop:
		// 	TNT1 A 0 CyberRL_HandleAmmo();
		// 	CYBF A 1 Bright CyberRl_FireWeapon(0, 1);
		// 	CYBF B 1 Bright CyberRl_FireWeapon(0, 2);
		// 	CYBF C 1 A_SetPitch(pitch - 1, SPF_INTERPOLATE);
		// 	CYBF D 1 Bright A_SetPitch(pitch + 0.6, SPF_INTERPOLATE);
		// 	CYBF EFG 1 Bright A_SetPitch(pitch + 0.8, SPF_INTERPOLATE);
		// 	TNT1 A 0 { invoker.shotCount++; }
		// 	TNT1 A 0 A_JumpIf(invoker.shotCount < 3, "AltFireLoop");
		// 	// Shot 4
		// 	TNT1 A 0 CyberRL_HandleAmmo();
		// 	CYBF A 1 Bright CyberRl_FireWeapon(0, 1);
		// 	CYBF B 1 Bright CyberRl_FireWeapon(0, 2);
		// 	CYBF C 1 A_SetPitch(pitch - 1, SPF_INTERPOLATE);
		// 	CYBF D 3 Bright;
		// 	CYBF D 1 Bright A_SetPitch(pitch + 0.6, SPF_INTERPOLATE);
		// 	CYBF EEFFGG 1 Bright A_SetPitch(pitch + 0.4, SPF_INTERPOLATE);
		// 	// TNT1 A 0 A_FireCustomMissile("SmokeSpawner11", 0, 0, 0, 7);
		// 	CYBF HHJ 1 Bright;
		// 	CYBF IJIJIJ 1 Bright;
		// 	// TNT1 A 0 A_FireCustomMissile("SmokeSpawner11", 0, 0, 0, 7);
		// 	TNT1 A 0 PB_ReFire();
		// 	goto Ready3;

        NoAmmo:
			RMNG C 2 A_DoPBWeaponAction(WRF_NOFIRE);
			RMNG D 2 A_DoPBWeaponAction(WRF_NOFIRE);
			RMNG E 3 A_DoPBWeaponAction();
			RMNG F 3 A_DoPBWeaponAction();
            TNT1 A 0 A_PlaySound("weapons/empty", 4);
		   	goto Ready3;

		WeaponBreak:
			TNT1 A 0 {
				for(int i = 0; i < 5; i++)
				{
					A_CustomMissile ("MetalShard1", 5, 0, random (-10, -20), 2, random (0, 30));
					A_CustomMissile ("MetalShard2", 5, 0, random (-10, -20), 2, random (0, 30));
					A_CustomMissile ("MetalShard3", 5, 0, random (-10, -20), 2, random (0, 30));
				}
				A_TakeInventory("PBX_MastermindChaingun",1);
				A_Startsound("meleeweapon/break");
				A_ALertMonsters();
				}
			Stop;
		
//////////////////////////// WEAPON SPECIAL ////////////////////////////////////////////////////////////////////////////////////
		Weaponspecial:
			TNT1 A 0 A_Takeinventory("GoWeaponSpecialAbility",1);
			TNT1 A 0 {
				if(invoker.SoulSeekerMode) {
					invoker.SoulSeekerMode = false;
				}
				else {
					invoker.SoulSeekerMode = true;
				}
            	A_StartSound("REVCYC", CHAN_AUTO, CHANF_OVERLAP);
				A_StartSound("weapons/rocket/innercycle", CHAN_AUTO, CHANF_OVERLAP);
				A_Print(invoker.SoulSeekerMode ? "$PBX_MastermindCG_SoulSeeker" : "$PBX_MastermindCG_Normal");
			}
			goto Ready3;

//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
		FlashPunching:
        	RMNG F 1;
			RMNG O 1;
			RMNG P 1;
			RMNG Q 1;
			RMNG R 1;
			RMNG S 4;
			RMNG R 1;
			RMNG Q 1;
			RMNG P 1;
			RMNG O 1;
			RMNG F 1;
			goto Ready3;

        FlashKicking:
			RMNG F 1;
			RMNG O 1;
			RMNG P 1;
			RMNG Q 1;
			RMNG R 1;
			RMNG S 6;
			RMNG R 1;
			RMNG Q 1;
			RMNG P 1;
			RMNG O 1;
			RMNG F 1;
			goto Ready3;
			
		FlashAirKicking:
            RMNG F 1;
			RMNG O 1;
			RMNG P 1;
			RMNG Q 1;
			RMNG R 1;
			RMNG S 7;
			RMNG R 1;
			RMNG Q 1;
			RMNG P 1;
			RMNG O 1;
			RMNG F 1;
			goto Ready3;
			
		FlashSlideKicking:
            RMNG F 1;
			RMNG O 1;
			RMNG P 1;
			RMNG Q 1;
			RMNG R 1;
			RMNG S 13;
			RMNG R 1;
			RMNG Q 1;
			RMNG P 1;
			RMNG O 1;
			RMNG F 1;
			goto Ready3;
			
		FlashSlideKickingStop:
			RMNG F 7;
			goto Ready3;
	}
}