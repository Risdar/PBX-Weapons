// Includes
#include "./BattleRifle_Functions.zs"
#include "./BattleRifle_Wheel.zs"
#include "./BattleRifle_helpers.zs"

class BR_Select_Scope : inventory {default{inventory.maxamount 1;}}
class BR_Select_NVG : inventory {default{inventory.maxamount 1;}}
class BR_Select_FireMode : inventory {default{inventory.maxamount 1;}}
class BR_Select_Zoom : inventory {default{inventory.maxamount 1;}}
class BR_Select_Laser : inventory {default{inventory.maxamount 1;}}
class BattleRifle_Upgraded : inventory {default{inventory.maxamount 1;}}

class PBX_BDPBattleRifle : PBX_WeaponBase
{
	Default
	{
//////////////////////////// WEAPON DATA ////////////////////////////////////////////////////////////////////////////////////
		Weapon.SlotNumber 4;
	    Weapon.SlotPriority 2;
	    Weapon.SelectionOrder 1550;
	    Inventory.PickupSound "BR45PICK";
	    Inventory.AltHUDIcon "BR45A0";
		inventory.maxamount 1;
		PB_WeaponBase.UsesWheel true;
		PB_WeaponBase.WheelInfo "BattleRifleWheel";
		PB_WeaponBase.ReserveToMagAmmoFactor 1;
		Scale 1.0;
		
        // Messages
	    Obituary "%o was pierced by %k's Battle Rifle.";
	    Inventory.Pickupmessage "$PBX_BattleRifle_Pickup";
		Tag "$PBX_BattleRifle_Tag";
		
        // Ammo
        weapon.ammotype1 "PB_HighCalMag"; // Reserve
		weapon.ammogive1 30;
		weapon.ammotype2 "BR_Ammo"; // Primary
		
        // Flags
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.NOAUTOFIRE; //[Pop] Use NOAUTOFIRE if you want a semi auto gun.
		//Albeit PB has QOL stuff for holding down left click already, firing it
		//at a slower rate
	}
	
//////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////////////////////
    bool nvgActive;
    bool isSemiAuto;
	bool semiclear;
	bool LockedOn;
	bool laserActive;
	int burstcount;
    int scopeMode;
	double zoomstrength;
	// Change these if you want to edit how strong the zoom modes are
	const MAGAZINE_SIZE = 15;
	const HIGHZOOM = 4.0;
	const LOWZOOM  = 2.0;
	
//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
	States
	{
        // SETUP
        Spawn:
			BR45 A -1;
			stop;

		Deselect:
            TNT1 A 0 A_SetInventory("PBX_Infrared", 0);
			TNT1 A 0 PB_SetZoom(false);
			BR4S ABCDE 1; 
			TNT1 A 0 A_StopSound(1);
			TNT1 A 0 A_StopSound(2);
			TNT1 A 0 A_StopSound(6);
			TNT1 A 1;
            TNT1 A 0 A_lower();
            Wait;
		Select:
            TNT1 A 0 A_SetInventory("PBX_Infrared", 0);
			TNT1 A 0 PBX_WeaponRaise("BR45PICK");
			TNT1 A 0 PB_RespectIfNeeded();
		SelectAnimation:
			TNT1 A 0 {invoker.burstcount = 0;}
			BR4S EDCBA 1;
			goto Ready3;
		
		WeaponRespect:
			TNT1 A 0 A_SetCrosshair(-1);
			BR4S EDCBA 1 A_DoPBWeaponAction();
			BR45 BBB 1 A_DoPBWeaponAction();
			TNT1 A 0 A_startsound("BR45OPEN",3,CHANF_OVERLAP);
            BR4R ABCDE 1 A_DoPBWeaponAction();
			BR4R FGGGGG 1 A_DoPBWeaponAction();
			BR4R GHIJKLMNOP 1 A_DoPBWeaponAction();
			TNT1 A 0 A_startsound("BR45LOAD",3);
			BR4R QRSTUVWX 1 A_DoPBWeaponAction();
			goto Ready3;

        // READY STATES
        Ready:
        Ready3:
            TNT1 A 0 A_SetInventory("PBX_Infrared", 0);
			TNT1 A 0 A_jumpif(PB_GetZoom(),"Ready2");
		ReadyToFire:
			BR45 B 1 {
				A_zoomfactor(1.0);
				PB_HandleCrosshair(42);
				PB_CoolDownBarrel();
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			}
			Loop;
		
		Ready2:
			TNT1 A 0 {
                if(invoker.nvgActive) {
                    A_SetInventory("PBX_Infrared", 1);
                    A_StartSound("RA1IF1", CHAN_AUTO, CHANF_OVERLAP);
                }
            }
		ReadyToFire2:
			TNT1 A 0;
			BR4Z D 1 Bright  {
				A_zoomfactor(getZoomStrength());
				PB_SetRoll(0);
                // PB_HandleCrosshair(5);
                A_SetCrosshair(-1);
				PB_CoolDownBarrel();
                A_SetInventory("PB_LockScreenTilt",0);

				// Enables the scope if the player has the upgrade
				if(	(countinv("BattleRifle_Upgraded") > 0 || (pbxweapons_backpack_filter & DisablePBX_BattleRifleUpgrade)) &&
                	(invoker.ScopeMode == 1 || invoker.ScopeMode == 2))
					BR_ReadyScope();

				return PB_ReadyFire(ads:true);
            }
			Loop;
		
		//[Pop] Firing states
		Fire:
			TNT1 A 0 {
				A_WeaponOffset(0, 32);
				PB_SetRoll(0);
				PB_HandleCrosshair(42);
				A_SetInventory("PB_LockScreenTilt", 0);
				A_ZoomFactor(1.0);
			}
			TNT1 A 0 A_JumpIf(PB_GetZoom(), "FireADS");
			TNT1 A 0 PB_JumpIfNoAmmo("Reload", 1, false);
			BR4F A 0 A_Jump(85, 3);
			BR4F B 0 A_Jump(85, 2);
			BR4F C 0;
			BR4F "#" 1 FireWeapon();
			BR45 D 1 {
				if (getBRMag() < 1) PB_SpawnCasing("RifleClipSpawn");
			}
			// Semi-auto: always go to BurstDone after 1 shot
			// Burst: loop until burstcount hits 3
			TNT1 A 0 A_JumpIf(getSemiAuto(), "BurstDone");
			TNT1 A 0 A_JumpIf(invoker.burstcount < 3, "BurstFireRecoil");
			goto BurstDone;

		BurstDone:
			TNT1 A 0 { invoker.burstcount = 0; }
			BR45 DEF 1;
			BR45 GH 1 {
				// Track button release
				if (!(player.cmd.buttons & BT_ATTACK))
					invoker.semiclear = true;
				// Refire only if button was released and pressed again
				if (invoker.semiclear && PlayerPressedOnce(BT_ATTACK))
					return resolvestate("Fire");
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOFIRE | WRF_NOPRIMARY);
			}
			TNT1 A 0 { invoker.semiclear = false; }
			goto Ready3;

		BurstFireRecoil:
			BR45 EF 1;
			goto Fire;

		//[Pop] because different animations too
		Fire2:
		FireADS:
			TNT1 A 0 A_ZoomFactor(getZoomStrength());
			TNT1 A 0 PB_JumpIfNoAmmo("Reload", 1, false);
			BR4Z D 1 Bright FireWeapon();
			BR4Z D 1 Bright {
				if (getBRMag() < 1) PB_SpawnCasing("RifleClipSpawn");
			}
			// Same logic as hipfire
			TNT1 A 0 A_JumpIf(getSemiAuto(), "BurstDoneADS");
			TNT1 A 0 A_JumpIf(invoker.burstcount < 3, "BurstFireRecoilADS");
			goto BurstDoneADS;

		BurstDoneADS:
			TNT1 A 0 {
				invoker.burstcount = 0;
				// A_SetInventory("CantDoAction", 0);
			}
			BR4Z DDDDDDDDDDDD 1 Bright {
				// Track button release
				if (!(player.cmd.buttons & BT_ATTACK))
					invoker.semiclear = true;
				// Refire only if button was released and repressed
				if (invoker.semiclear && PlayerPressedOnce(BT_ATTACK))
					return resolvestate("FireADS");

				if (PB_GetAimMode())
				{
					if (JustReleased(BT_ALTATTACK))
						return resolvestate("ZoomOut");
				}
				else
				{
					if (PressingAltfire())
						return resolvestate("ZoomOut");
				}

				return A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOFIRE | WRF_NOPRIMARY);
			}
			TNT1 A 0 { invoker.semiclear = false; }
			goto Ready2;

		BurstFireRecoilADS:
			BR4Z DD 1 Bright;
			goto FireADS;
	
        // ALTFIRE
        AltFire:
            TNT1 A 0 {invoker.LockedOn = false;}
			TNT1 A 0 A_Jumpif(PB_GetZoom(),"ZoomOut");
		ZoomIn:
            TNT1 A 0 PB_SetZoom(true);
			TNT1 A 0 A_startsound("IronSights",29);
            BR4Z A 1 A_zoomfactor(1.0);
		    BR4Z B 1 A_zoomfactor(2.0);
			BR4Z C 1 A_zoomfactor(getZoomStrength());
            goto Ready2;
        ZoomOut:
            TNT1 A 0 A_SetInventory("PBX_Infrared", 0);
			TNT1 A 0 PB_SetZoom(false);
			TNT1 A 0 A_startsound("IronSights",29);
            BR4Z C 1 A_zoomfactor(getZoomStrength());
		    BR4Z B 1 A_zoomfactor(2.0);
			BR4Z A 1 A_zoomfactor(1.0);
			goto Ready3;

        // RELOAD
		Reload:
            TNT1 A 0 A_SetInventory("PBX_Infrared", 0);
			TNT1 A 0 A_ZoomFactor(1.0);
            TNT1 A 0 PB_SetZoom(false);
            TNT1 A 0 PB_CheckReload("RaiseFromEmpty", null, null, "Ready3", "NoAmmo", MAGAZINE_SIZE, 1);
			TNT1 A 0 A_startsound("BR45OPEN",3,CHANF_OVERLAP);
            BR4R ABCDE 1;
            TNT1 A 0
			{
                PB_SetMagUnloaded(true);
                PB_SetMagEmpty(true);
                PB_SetChamberEmpty(true);
                If(getBRMag() > 0)
				{
					PB_SpawnCasing("RifleClipSpawn");
					A_fireprojectile("RifleClipSpawn",5,false,0,-14,0);
				}
			}
            BR4R FGGGGG 1;
        ContinueReload:
			BR4R GHIJKLMNOP 1;
			TNT1 A 0 
			{
				A_startsound("BR45LOAD",3);
				PB_AmmoIntoMag(invoker.ammo2.getclassname(), invoker.ammo1.getclassname(), MAGAZINE_SIZE,1);
                PB_SetMagUnloaded(false);
                PB_SetMagEmpty(false);
                PB_SetChamberEmpty(false);
			}
			BR4R QRSTUVWX 1;
            TNT1 A 0 PB_SetReloading(false);
			goto Ready3;

        RaiseFromEmpty:
            TNT1 A 0 A_ZoomFactor(1.0);
			TNT1 A 0 A_startsound("BR45OPEN",3,CHANF_OVERLAP);
            BR4R ABCDEF 1;
            goto ContinueReload;
		
		Unload:
			TNT1 A 0 A_Jumpif(pb_getmagunloaded() || getBRMag() < 1,"Ready3");
			TNT1 A 0 A_startsound("BR45OPEN",3,CHANF_OVERLAP);
            BR4R ABCDE 1;
            TNT1 A 0
			{
				If(getBRMag() > 0)
					{
						PB_UnloadMag(invoker.ammotype2, invoker.ammotype1, 1);
						PB_SpawnCasing("RifleClipSpawn");
						// A_fireprojectile("RifleClipSpawn",5,false,0,-14,0);
						PB_SetMagUnloaded(true);
						PB_SetMagEmpty(true);
						PB_SetChamberEmpty(true);
					}
			}
            BR4R STUVWX 1;
            goto Ready3;

		NoAmmo:
			BR45 B 1 A_StartSound("weapons/empty");
			goto Ready3;

		SpecialFromADS:
			TNT1 A 0 A_Takeinventory("GoWeaponSpecialAbility",1);
			goto ActualModeChange;
		Weaponspecial:
			TNT1 A 0 A_SetCrosshair(-1);
			TNT1 A 0 A_JumpIf(PB_GetZoom(),"SpecialFromADS");
			TNT1 A 0 {
				A_Takeinventory("GoWeaponSpecialAbility",1);
				PB_SetZoom(false);
				A_ZoomFactor(1.0);
			}
		ActualModeChange:
			TNT1 A 0 checkSpecial();
        SwitchAnimation:
            BR4R ABCDEFG 1;
            TNT1 A 0 A_StartSound("MS/Button", 26);
			BR4R GFEDCBA 1;
			goto Ready3;
		
        // FLASH STATES
        FlashPunching:
            TNT1 A 0 A_SetInventory("PBX_Infrared", 0);
            BR4K ABCD 1;
		    BR4K E 13;
		    BR4K DCBA 1; //14 frames
            goto Ready3;

		FlashKicking:
            TNT1 A 0 A_SetInventory("PBX_Infrared", 0);
			BR4K ABCD 1;
		    BR4K E 13;
		    BR4K DCBA 1; //15 frames
			goto Ready3;
			
		FlashAirKicking:
            TNT1 A 0 A_SetInventory("PBX_Infrared", 0);
			BR4K ABCD 1;
		    BR4K E 14;
		    BR4K DCBA 1; //16 frames
			goto Ready3;
			
		FlashSlideKicking:
            TNT1 A 0 A_SetInventory("PBX_Infrared", 0);
			BR4K A 1; 
			BR4K B 2; 
			BR4K C 4;
			BR4K D 6; 
			BR4K E 7; 
			BR4K D 3; 
			BR4K C 2;
			BR4K B 1;
			BR4K A 1; //27 frames
			goto Ready3;
			
		FlashSlideKickingStop:
            TNT1 A 0 A_SetInventory("PBX_Infrared", 0);
			BR4K EDCBAAA 1; //7 frames 
			goto Ready3;
	}
	
}