// Includes
#include "./CSSG_Functions.zs"
#include "./CSSG_Casings.zs"
#include "./CSSG_Shells.zs"
#include "./CSSG_Upgrades.zs"
#include "./CSSG_Wheel.zs"
#include "./CSSG_Projectiles.zs"


Class PBX_CSSG : PB_WeaponBase
{
	default
	{
		weapon.slotnumber 3;
		Inventory.PickupMessage "$PBX_CSSG_PICKUP";
		Obituary "%o was devastated by %k.";
		Inventory.PickupSound "COMSSGUP";
		Tag "$PBX_CSSG_TAG";
		Inventory.AltHUDIcon "SG43A0";
		PB_WeaponBase.OffsetRecoilX 5;
		PB_WeaponBase.OffsetRecoilY 4;
		scale 0.5;
		weapon.ammotype2 "CSSGShellsIn";
		weapon.ammotype1 "PB_Shell";
		weapon.ammogive1 4;
		PB_WeaponBase.UsesWheel true;
		PB_WeaponBase.WheelInfo "CSSGWeaponWheel";
		PB_WeaponBase.ReserveToMagAmmoFactor 1;
	}
	
	int shellsmode;
	int oldshells;
	const BARREL_CAPACITY = 2;
	
	enum CM_ShellTypes {
		Shell_Buck = 1,
		Shell_Slug = 2,
		Shell_Flech = 3,
		Shell_Flak = 4,
		Shell_Drgn = 5,
		Shell_EXPL = 6,
		Shell_WPSP = 7,
		Shell_Doom = 8,
		Shell_Damn = 9,
		Shell_SubZ = 10
	};
	
	states
	{
		Spawn:
			SG43 A -1;
			stop;
		
		Select:
			TNT1 A 0 PB_WeaponRaise("COMSSGUP");
			TNT1 A 0 PB_RespectIfNeeded();
			TNT1 A 0 PB_WeapTokenSwitch("SSGSelected");
		SelectAnimation:
			TNT1 A 0 A_startsound("CLIPINSS",8);
			C0SU ABCD 1;
			goto Ready3;
		
		Deselect:
			//TNT1 A 0 A_takeinventory("PB_ShellViewer",10);
			//TNT1 A 0 PB_CheckBarrelPlace1();
			TNT1 A 0 A_startsound("weapons/changing",60);
			C0SU DCBA 1;
			TNT1 A 0 A_Lower(120);
			wait;
			
		WeaponRespect:
			TNT1 A 1 A_DoPBWeaponAction();
			TNT1 A 0 A_Startsound("Ironsights", CHAN_AUTO);
			C0XR ABC 1 A_DoPBWeaponAction();
			C0XR DEEFFFFFFFF 1 A_DoPBWeaponAction();
			C0XR GHI 1 A_DoPBWeaponAction();
			TNT1 A 0 A_startsound("CSSGOPEN",25);
			C0XR JK 1 A_DoPBWeaponAction();
			
			TNT1 A 3 A_DoPBWeaponAction();
			
			C0RO NO 1 A_DoPBWeaponAction();
			TNT1 AA 0 PB_GunSmoke(random(0,1),0,-2);
			C0RO P 1 A_DoPBWeaponAction();
		//insert shells
			C0RB A 1;
			C0RB BCDFGH 1 {
				ChangeCSSGShellsLook('C0RB','C0RS','C0RN','C0RK','C0RD','C0RX','C0RW','C0RT','C0RM','C0RX');
				return A_DoPBWeaponAction();
			}
			TNT1 A 0 A_startsound("weapons/cssg/in",26);
			C0RB IJ 1 A_DoPBWeaponAction();
			
			TNT1 A 4 A_DoPBWeaponAction();
			
			TNT1 A 0 A_startsound("CSSGCLOS",29);
			C0RC ABC 1 A_DoPBWeaponAction();
			C0RC DEF 1 A_DoPBWeaponAction();
			C0RC GHIJ 1 A_DoPBWeaponAction();
			
			C0XR LLLL 1 A_DoPBWeaponAction();
		//random pump
			TNT1 A 0 A_startsound("weapons/sgmvpump",64);
			TNT1 A 0 A_quakeEx(0,1,1,6,0,10,"",QF_RELATIVE|QF_SCALEDOWN|QF_SCALEUP);
			C0XR LMNOOOO 1 A_DoPBWeaponAction();
			TNT1 A 0 A_startsound("weapons/sgpump",65);
			C0XR PPNNMMLLL 1 A_DoPBWeaponAction();
			
			C0XR QQRR 1 A_DoPBWeaponAction();
			C0ID A 2 A_DoPBWeaponAction();
			goto ready;
			
			
			
		Ready:
		Ready3:
			TNT1 A 0 CM_HandleCrosshair();
			TNT1 A 0 PB_CoolDownBarrel();
			C0ID A 2 A_DoPBWeaponAction();
			loop;
		
		// FIRE STATES
		Fire:
			//TNT1 A 0 PB_CheckBarrelThrow1();
			//TNT1 A 0 PB_CheckAmmoFire();
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
				A_SetInventory("PB_LockScreenTilt",0);
				CM_HandleCrosshair();
			}
			TNT1 A 0 PB_JumpIfNoAmmo("LeftFire",2);
			TNT1 A 0 A_overlay(-31,"MuzzleFlashFull");
			TNT1 A 0 CM_PlayFireSound();
			C0FF A 1 bright FireCSSG();
			C0FF B 1 bright {
				PB_GunSmoke(-2,0,-1);
				PB_GunSmoke(2,0,-1);
			}
			TNT1 A 0 A_ZoomFactor(0.95);
			TNT1 A 0 A_recoil(6);
			//C0FF C 1;
			C0FF D 1;
			TNT1 A 0 A_ZoomFactor(0.975);
			C0FF D 1;
			TNT1 A 0 A_ZoomFactor(0.985);
			TNT1 A 0 A_QuakeEx(3,3,3,6,0,60,"",QF_RELATIVE|QF_SCALEDOWN);
			C0FF D 1;
			TNT1 A 0 A_ZoomFactor(0.995);
			C0FF D 1;
			TNT1 A 0 A_ZoomFactor(1.0);
			C0FF EEF 1;
			C0ID A 1 A_DoPBWeaponAction(WRF_NOFIRE);
			goto reload;
		
		AltFire:
			TNT1 A 0 PB_JumpIfNoAmmo("LeftFire",2,true,true);
			TNT1 A 0 CM_HandleCrosshair();
		RightFire:
			TNT1 A 0 CM_PlayAltFireSound();
			TNT1 A 0 A_overlay(-31,"MuzzleFlashRight");
			C0FH A 1 bright FireHalfCSSGRight();
			TNT1 A 0 PB_TakeAmmo(invoker.ammotype2,1);
			TNT1 A 0 A_ZoomFactor(0.975);
			TNT1 A 0 PB_WeaponRecoil(-3,frandom(-0.5,0.5));
			TNT1 A 0 {
				PB_GunSmoke(-2,0,-1);
				A_FireProjectile("ShotgunWad",random(-2,2),0,3,-4,FPF_NOAUTOAIM,random(-2,2));
			}
			C0FH C 1 PB_GunSmoke(-2,0,-1);
			TNT1 A 0 A_ZoomFactor(0.985);
			C0FH C 1;
			TNT1 A 0 A_ZoomFactor(0.995);
			C0FH D 1;
			TNT1 A 0 A_ZoomFactor(1.0);
			C0FH DE 1;
			C0ID A 1;
			goto ready;
		LeftFire:
			TNT1 A 0 PB_JumpIfNoAmmo;
			TNT1 A 0 CM_PlayAltFireSound();
			TNT1 A 0 A_overlay(-31,"MuzzleFlashLeft");
			C0FH B 1 bright FireHalfCSSGLeft();
			TNT1 A 0 PB_TakeAmmo(invoker.ammotype2,1);
			TNT1 A 0 A_ZoomFactor(0.975);
			TNT1 A 0 PB_WeaponRecoil(-3,frandom(-0.5,0.5));
			TNT1 A 0 {
				PB_GunSmoke(2,0,-1);
				A_FireProjectile("ShotgunWad",random(-2,2),0,-3,-4,FPF_NOAUTOAIM,random(-2,2));
			}
			C0FH C 1 PB_GunSmoke(2,0,-1);
			TNT1 A 0 A_ZoomFactor(0.985);
			C0FH C 1;
			TNT1 A 0 A_ZoomFactor(0.995);
			C0FH D 1;
			TNT1 A 0 A_ZoomFactor(1.0);
			C0FH DE 1;
			C0ID A 1;
			goto reload;
		
		// RELOAD STATES
		Reload:
			TNT1 A 0 PB_CheckReload(null, null, null,"Ready3","Ready3",BARREL_CAPACITY);
			// If there is still one shell in the barrel, go to reload half
			// otherwise go to reload full
			TNT1 A 0 A_JumpIf(invoker.ammo2.amount >= 1, "ReloadHalf");
			Goto ReloadFull;
		ReloadHalf:
			C0HO ABC 1;
			TNT1 A 0 A_startsound("CSSGOPEN",25);
			C0HO D 1;
			TNT1 A 0 A_spawnCSSGCasing();
			C0HO EFGH 1;
			TNT1 A 0 PB_GunSmoke(0,0,-2);
			C0HO II 1;
		//insert shell
			C0HB ABC 1 ChangeCSSGShellsLook('C0HB','C0HS','C0HN','C0HK','C0HD','C0HX','C0HW','C0HT','C0HM','C0HX');
			C0HB DEF 1 ChangeCSSGShellsLook('C0HB','C0HS','C0HN','C0HK','C0HD','C0HX','C0HW','C0HT','C0HM','C0HX');
			TNT1 A 0 A_startsound("weapons/cssg/in",24);
			C0HB G 1;
			TNT1 A 0 {
				PB_AmmoIntoMag(invoker.ammo2.GetClassName(),invoker.ammo1.GetClassName(),BARREL_CAPACITY);
				PB_SetMagEmpty(false);
				PB_SetChamberEmpty(false);
			}
			C0HB HI 1;
			TNT1 A 3;
		CloseSSG:
			TNT1 A 0 A_startsound("CSSGCLOS",29);
			C0RC ABC 1;
			C0RC DEEFF 1;
			C0RC GHIJ 1;
			TNT1 A 0 PB_SetReloading(false);
			goto ready3;
			
		ReloadFull:
			//TNT1 A 0 A_takeinventory(invoker.UnloaderToken,10);
			C0RO ABC 1;
			C0RO DEF 1;
			C0RO GHIJ 1;
			TNT1 A 0 A_startsound("CSSGOPEN",25);
			C0RO KLM 1;
			TNT1 A 1;
			C0RO N 1;
			TNT1 AA 0 A_spawnCSSGCasing();
			C0RO O 1;
			TNT1 AA 0 PB_GunSmoke(random(0,1),0,-2);
			C0RO P 1;
		//insert shells
			C0RB A 1;
			C0RB BCDFGHI 1 ChangeCSSGShellsLook('C0RB','C0RS','C0RN','C0RK','C0RD','C0RX','C0RW','C0RT','C0RM','C0RX');
			TNT1 A 0 {
				A_startsound("weapons/cssg/in",26);
				PB_AmmoIntoMag(invoker.ammo2.GetClassName(),invoker.ammo1.GetClassName(),BARREL_CAPACITY);
				PB_SetMagEmpty(false);
				PB_SetChamberEmpty(false);
			}
			C0RB J 1;
			TNT1 A 2;
			goto CloseSSG;
			
		Unload:
			//TNT1 A 0 A_Takeinventory("Unloading",1);
			TNT1 A 0 A_Jumpif(PB_GetChamberEmpty() || countinv(invoker.ammotype2) < 1,"Ready3");
			C0HO ABC 1;
			TNT1 A 0 A_startsound("CSSGOPEN",25);
			C0HO D 1;
			TNT1 A 4;
			C0RB JI 1;
			C0RB HGFEDCB 1 ChangeCSSGShellsLook('C0RB','C0RS','C0RN','C0RK','C0RD','C0RX','C0RW','C0RT','C0RM','C0RX');
			TNT1 A 0 {
				CM_HandleUnload();
				PB_SetChamberEmpty(true);
				PB_SetMagEmpty(true);
			}
			TNT1 A 0 A_Startsound("weapons/ssg/inspect2",26);
			C0RB A 1;
			C0RO PON 1;
			TNT1 A 3;
			goto CloseSSG;
		
		// OTHERS
		WeaponSpecial:
			TNT1 A 0 A_takeinventory("GoWeaponSpecialAbility",1);
			TNT1 A 0 {
				A_Takeinventory("GoWeaponSpecialAbility",1);
				A_Takeinventory("Zoomed",1);
				A_Takeinventory("ADSmode",1);
				A_ZoomFactor(1.0);
				A_ClearOverlays(10,11);
			}
			goto HandleUpgradeSpecial;
		
		CancelWheel:
			TNT1 A 0 ClearCssgTokens();
			goto ready3;
		
		HandleUpgradeSpecial:
			TNT1 A 0 CSSG_HandleWheel();
			
		EndSelection:
			TNT1 A 0 ClearCssgTokens();
			C0HO ABC 1;
			TNT1 A 0 A_startsound("CSSGOPEN",25);
			C0HO D 1;
			TNT1 A 1;
			TNT1 AA 0 {
				A_spawnCSSGCasing(true);
				CM_HandleUnload();
				PB_SetChamberEmpty(true);
				PB_SetMagEmpty(true);
			}
			C0RO NOP 1;
			C0RB A 1;
			C0RB BCDEFGH 1 ChangeCSSGShellsLook('C0RB','C0RS','C0RN','C0RK','C0RD','C0RX','C0RW','C0RT','C0RM','C0RX');
			TNT1 A 0 A_startsound("weapons/cssg/in",24);
			TNT1 A 0 {
				// if(countinv(invoker.ammotype2)<2 && countinv(invoker.ammotype1)>0)
				PB_AmmoIntoMag(invoker.ammo2.GetClassName(),invoker.ammo1.GetClassName(),BARREL_CAPACITY);
				PB_SetMagEmpty(false);
				PB_SetChamberEmpty(false);
			}
			C0RB IJ 1;
			TNT1 A 3;
			goto closeSSG;
			
		// FLASH STATES
		FlashPunching:
			C0MO ABCDEFFFFEDCBA 1;
			goto ready3;
		
		FlashKicking:
			C0KO ABCDEEFFGGEDCBA 1; //A_DoPBWeaponAction();
			goto ready3;
			
		FlashAirKicking:
			C0MO ABCDEFFFFFFEDCBA 1;
			goto ready3;
			
		FlashSlideKicking:
			C0KO ABCDEEFFFGGGFFFEEEGGGFEDCBA 1; //A_DoPBWeaponAction();
			goto ready3;
			
		FlashSlideKickingStop:
			C0KO GFEDCBA 1; //A_DoPBWeaponAction();
			goto ready3;
		
		// OVERLAYS
		MuzzleFlashFull:
			TNT1 A 0 {
				A_overlayFlags(overlayID(),PSPF_MIRROR|PSPF_FLIP,random(0,1));
				A_overlayFlags(overlayID(),PSPF_RENDERSTYLE,1);
				A_OverlayRenderstyle (overlayID(),STYLE_Add);
			}
			C1MZ A 1 bright;
			C1MZ B 1 bright;
			stop;
			
		MuzzleFlashRight:
			TNT1 A 0 {
				A_overlayFlags(overlayID(),PSPF_RENDERSTYLE,1);
				A_OverlayRenderstyle (overlayID(),STYLE_Add);
			}
			C1MZ C 1 bright;
			stop;
			
		MuzzleFlashLeft:
			TNT1 A 0 {
				A_overlayFlags(overlayID(),PSPF_RENDERSTYLE,1);
				A_OverlayRenderstyle (overlayID(),STYLE_Add);
			}
			C1MZ D 1 bright;
			stop;
			
		LoadSprites:
			C0RB ABCDEF 0;
			C0RD ABCDEF 0;
			C0RX ABCDEF 0;
			C0RK ABCDEF 0;
			C0RN ABCDEF 0;
			C0RS ABCDEF 0;
			C0RW ABCDEF 0;
			C0RT ABCDEF 0;
			C0RM ABCDEF 0;
			C0RX ABCDEF 0;
			C0HB ABCD 0;
			C0HD ABCD 0;
			C0HX ABCD 0;
			C0HN ABCD 0;
			C0HS ABCD 0;
			C0HW ABCD 0;
			C0HK ABCD 0;
			C0HT ABCD 0;
			C0HM ABCD 0;
			C0HX ABCD 0;
			stop;
			
	}
	
}

//the ammo counter
Class CSSGShellsIn : Ammo
{
	default
	{
        Inventory.Amount 0;
		inventory.maxamount PBX_CSSG.BARREL_CAPACITY;
		ammo.backpackamount 0;
		ammo.backpackmaxamount PBX_CSSG.BARREL_CAPACITY;
		Inventory.Icon "AUSCA0";
        +INVENTORY.IGNORESKILL;
	}
}


