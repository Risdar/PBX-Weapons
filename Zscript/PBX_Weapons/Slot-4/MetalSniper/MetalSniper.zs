const MetalSniperFullAmmo = 12;
const MetalSniperFullAmmoResonance = 4;

Class PBX_MetalSniper : PB_WeaponBase
{
	default
	{
		weapon.slotnumber 4;
		Tag "$PBX_MetalSniper_Tag";
		inventory.pickupsound "CLIPIN";
		inventory.pickupmessage "$PBX_MetalSniper_Pickup";
		Inventory.AltHudIcon "MSNWA0";
		weapon.ammotype1 "PB_HighCalMag";
		weapon.ammogive1 32;
		weapon.ammotype2 "MetalSniperAmmo";
		//PB_WeaponBase.unloadertoken "SniperUnloaded"; 
		PB_WeaponBase.respectItem "MetalSniperRespect";
		PB_WeaponBase.UsesWheel true;
		PB_WeaponBase.WheelInfo "MetalSniperWheel";
		scale 0.62;
		+weapon.noalert;
		+weapon.noautofire;
	}
	
	const SniperMode = 0;
	const GrenadeMode = 1;
	const muzzlelayer = -52;

	bool resonanceAmmoLoaded;
	bool grenadeloaded;
	bool AltMode;
	bool isZooming;
	int currentMaxAmmo;

	states
	{
		Spawn:
			MSNW A -1;
			stop;
		
		Steady:
			TNT1 A 1;
			Goto Ready;
		
		WeaponRespect:
			TNT1 A 0 A_setInventory(invoker.respectInventoryItem,1);
			MSNI ABCD 1 A_DoPBWeaponAction();
			MSNI EFGH 1 A_DoPBWeaponAction();
			MSNI IJKL 1 A_DoPBWeaponAction();
			MSNI MNOP 1 A_DoPBWeaponAction();
			MSNI QRSSSS 1 A_DoPBWeaponAction();
			// Raise
			MSU0 ABCD 1 A_DoPBWeaponAction();
			MSU0 EFGH 1 A_DoPBWeaponAction();
			MSU0 IJKL 1 A_DoPBWeaponAction();
			// Check Chamber
			M3NC ABCD 1 A_DoPBWeaponAction();
            M3NC EFGHI 1 A_DoPBWeaponAction();
            TNT1 A 0 A_startsound("MS/BoltDown",24);
            M3NC J 15 A_DoPBWeaponAction();
            M3NC K 10 A_DoPBWeaponAction();
			M3NC LL 1 A_DoPBWeaponAction();
            TNT1 A 0 A_startsound("MS/BoltUp",25);
            M3NC M 1 A_DoPBWeaponAction();
			// Put Mag
			MSNR ABCD 1 A_DoPBWeaponAction();
            MSNR EFG 1 A_DoPBWeaponAction();
            TNT1 A 0 A_startsound("MS/InsertMag",20);
			MSNR HIJKL 1 A_DoPBWeaponAction();
            MSNR MNOP 1 A_DoPBWeaponAction();
            MSNR QR 1 A_DoPBWeaponAction();
			// Lower
			MSU1 LKJIHGFEDCBA 1 A_DoPBWeaponAction();
			// Rechamber
            MSNI T 1 A_DoPBWeaponAction();
			MSNI UVWX 1 A_DoPBWeaponAction();
			MSNI YZ 1 A_DoPBWeaponAction();
			MSNJ AAB 1 A_DoPBWeaponAction();
			TNT1 A 0 A_startsound("MS/BoltDown",24);
			MSNJ BCDEEF 1 A_DoPBWeaponAction();
			TNT1 A 0 A_startsound("MS/BoltUp",25);
			MSNJ GHIJKL 1 A_DoPBWeaponAction();
			goto ready3;
			
		
		Select:
			TNT1 A 0 PB_WeaponRaise("MS/Up");
		SelectContinue:
			TNT1 A 0 PB_WeapTokenSwitch("RifleSelected");
			TNT1 A 0 PB_RespectIfNeeded();
		SelectAnimation:
			MSNU ABCD 1;
			goto ready3;
		Deselect:
			// TNT1 A 0 cleanmodetokens(); // I dont think this is needed
			TNT1 A 0 A_Zoomfactor(1.0);
			TNT1 A 0 A_takeinventory("Zoomed",10);
			TNT1 A 0 setZoom(false);
			MSND ABCD 1;
			TNT1 A 0 A_lower(120);
			wait;
		
		Ready:
			MST0 ABCDEFGHIJKL 0;
			MST3 ABCDEFGHIJKL 0;
			MSR6 ABCDEFGHIJKLMNOPQR 0;
			MSN4 ABCDEFGHIJKLM 0;
		Ready3:
			TNT1 A 0 PB_HandleCrosshair(42);
			TNT1 A 0 A_jumpif(countinv("zoomed") > 0,"Ready_ADS");
			MSNF A 1 {
				PB_CoolDownBarrel(-4,0,6,0,1);
				PB_CoolDownBarrel(4,0,6,0,-1);
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			}
			loop;
		
		NoAmmo:
			MSNF A 1 A_StartSound("weapons/empty");
			goto ready3;
			
		NoAmmo_Grenade:
			MSNG A 1 A_StartSound("weapons/empty");
			goto AltFire_Grenade;
		
		Fire:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(42);
				A_SetInventory("PB_LockScreenTilt",0);
			}
			TNT1 A 0 A_jumpifinventory("zoomed",1,"Fire_ADS");
			TNT1 A 0 PB_JumpIfNoAmmo("Reload",1);
			TNT1 A 0 A_AlertMonsters();
			MSNF B 1 bright MetalSniperFire();
			MSNF C 1 bright;
			MSNF DDDEF 1;
			MSNF GHAAAAAAAAAA 1 {
                if(PlayerPressedOnce(BT_ATTACK)) return resolvestate("Fire");
                return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
            }
			TNT1 A 0 A_refire("Fire");
			goto ready3;
		
		AltFire:
			TNT1 A 0 A_jumpif(MS_getmode() == GrenadeMode,"AltFire_Grenade");
		AltFire_Zoom:
			TNT1 A 0 A_Jumpif(countinv("Zoomed") > 0 && iszoom(),"ZoomOut");
		ZoomIn:
			TNT1 A 0 A_giveinventory("Zoomed",1);
			TNT1 A 0 setZoom(true);
			TNT1 A 0 A_startsound("IronSights",29);
			MSNA A 1 A_zoomfactor(1.5);
			MSNA B 1 A_zoomfactor(2.0);
			MSNA C 1 A_zoomfactor(2.5);
			MSNA D 1 A_zoomfactor(3.0);
			MSNA E 1 A_zoomfactor(3.5);
			MSNA F 1 A_zoomfactor(4.0);
			goto Ready_ADS;
		ZoomOut:
			TNT1 A 0 A_takeinventory("Zoomed",1);
			TNT1 A 0 setZoom(false);
			TNT1 A 0 A_startsound("IronSights",29);
			MSNA F 1 A_zoomfactor(3.5);
			MSNA E 1 A_zoomfactor(3.0);
			MSNA D 1 A_zoomfactor(2.5);
			MSNA C 1 A_zoomfactor(2.0);
			MSNA B 1 A_zoomfactor(1.5);
			MSNA A 1 A_zoomfactor(1.0);
			goto ready3;
			
		Ready2:
		Ready_ADS:
			TNT1 A 0;
			MSNS A 1 {
				A_SetRoll(0);
				PB_HandleCrosshair(-1);
				PB_CoolDownBarrel(-5,0,7,0,1);
				PB_CoolDownBarrel(5,0,7,0,-1);
				A_SetInventory("PB_LockScreenTilt",0);
				if(Cvar.GetCvar("pb_toggle_aim_hold",player).getint() == 1) 
				{
					if(!PressingAltfire() || JustReleased(BT_ALTATTACK))
						return resolvestate("Zoomout");
					
					if (PressingFire() && PressingAltfire() && CountInv(invoker.ammotype2) > 0)
							return resolvestate("Fire_ADS");
					
					return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
					
				}
				else 
				{
					if (PressingFire() && CountInv(invoker.ammotype2) > 0)
						return resolvestate("Fire_ADS");
					
					return A_DoPBWeaponAction(WRF_ALLOWRELOAD);
				}
				return resolvestate(null);
			}
			loop;
			
		Fire_ADS:
			TNT1 A 0 PB_jumpIfNoAmmo("ReloadFromADS",1);
		ActualFireADS:
			MSNS B 1 bright MetalSniperFireADS();
		FireADSContinue:
			MSNS C 1 bright;
			MSNS DDD 1;
			MSNS EFG 1;
			MSNS HIAAAAAAAAAA 1
			{
				A_SetInventory("CantDoAction",0);
				 
				if(Cvar.GetCvar("pb_toggle_aim_hold",player).getint()) 
				{
					if(JustReleased(BT_ALTATTACK))
						return resolvestate("Zoomout");
					if (JustPressed(BT_ATTACK) && PressingAltfire())
							return resolvestate("Fire_ADS");
				}
				else 
				{
					if(PressingAltfire())
						return resolvestate("Zoomout");
					if (JustPressed(BT_ATTACK))
							return resolvestate("Fire_ADS");
					A_Refire("Fire_ADS");
				}
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
			}
			Goto Ready_ADS;
			
		AltFire_Grenade:
			MSNG A 1 {
				PB_CoolDownBarrel(-4,0,6,0,1);
				PB_CoolDownBarrel(4,0,6,0-1);
				if(PlayerPressedOnce(BT_ATTACK))
				{
					if(getgrenqtty() > 0)
						return resolvestate("FireGrenade");
					else
						return resolvestate("Reload_Grenade");
				}
				return resolvestate(null);
			}
			TNT1 A 0 A_refire("AltFire_Grenade");
			goto ready3;
			
		FireGrenade:
			TNT1 A 0 A_overlay(muzzlelayer,"MuzzleFlash_Gren");
			TNT1 A 0 A_AlertMonsters();
			TNT1 A 0 A_startsound("MS/Grenade",20);
			MSNG B 1 bright A_Fireprojectile("PB_FragGrenade",0,0);
			TNT1 A 0 MS_SetGrenadeQ(0);
			TNT1 A 0 PB_FireOffset();
			TNT1 A 0 PB_GunSmoke(0,0,-2);
			TNT1 A 0 PB_WeaponRecoil(-3,frandom(-1.5,1.5));
			MSNG C 1 bright;
			MSNG D 1;
			MSNG E 1;
			MSNG FG 1;
			MSNG A 1;
			TNT1 A 0 A_jumpif(countinv("PB_RocketAmmo") > 0,"Reload_grenade");
			goto ready3;
		
		Reload_Grenade:
			TNT1 A 0 A_jumpif(countinv("PB_RocketAmmo") < 1,"NoAmmo_Grenade");
			MSNL ABCDEFGGG 1;
			TNT1 A 0 A_startsound("MS/GrenOpen",21);
			MSNL G 1;
			TNT1 A 0 PB_SpawnCasing("EmptyGrenadeBrass", 30, -2, 34, frandom(1.0, 2.0), frandom(-4.0,-2.0), 1.0);
			MSNL HIJKLMN 1;
			TNT1 A 0 {
				if(countinv("PB_RocketAmmo") > 0)
				{
					MS_SetGrenadeQ(1);
					A_takeinventory("PB_RocketAmmo",1);
				}
				A_startsound("MS/GrenClose",22);
			}
			MSNL OPQRSTU 1;
			MSNL GGG 1;
			MSNL FEDCBA 1;
			TNT1 A 0 A_refire("AltFire_Grenade");
			goto ready3;
		
		ReloadFromADS:
			TNT1 A 0 A_Zoomfactor(1.0);
			TNT1 A 0 A_takeinventory("Zoomed",10);
		Reload:
            TNT1 A 0 A_Zoomfactor(1.0);
            TNT1 A 0 A_takeinventory("Zoomed",10);
            TNT1 A 0 setZoom(false);
            TNT1 A 0 PB_CheckReload("RaiseFromEmpty", null, "Start_Rechamber", "Ready3", "NoAmmo", MetalSniperFullAmmo, 2);
        StandardReload:
            //raise
            TNT1 A 0 A_startsound("IronSights",30);
            MSU1 ABCD 1;
            MSU1 EFGH 1;
            MSU1 IJKL 1;
            //take
            MST1 ABCD 1 ;
            TNT1 A 0 A_startsound("MS/Button",22);
            MST1 E 1 ;
            TNT1 A 0 {
                A_startsound("MS/TakeMag",23);
                PB_SetMagUnloaded(true);
            }
            MST1 FGHIJKL 1 ;
        ResumeReload:
            //insert
            MSNR ABCDEFG 1 ;
            TNT1 A 0 A_startsound("MS/InsertMag",20);
			MSNR HIJKL 1 ;
			TNT1 A 0 {
				MS_ReloadMag();
            	PB_SetMagUnloaded(false);
            	PB_SetMagEmpty(false);
			}
            MSNR MNOPQR 1 ;
            TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(), "Rechamber");
            //lower
            MSU1 LKJIHGFEDCBA 1;
            TNT1 A 0 PB_SetReloading(false);
            goto ready3;
        
        Start_Rechamber:
			//raise
            TNT1 A 0 A_startsound("IronSights",30);
            MSU1 ABCD 1;
            MSU1 EFGH 1;
            MSU1 IJKL 1;
        Rechamber:
            MSNC ABCDEFG 1 ;
            TNT1 A 0 A_startsound("MS/BoltDown",24);
            TNT1 A 0 PB_SetChamberEmpty(false);
            MSNC HIJKL 1 ;
            TNT1 A 0 A_startsound("MS/BoltUp",25);
            MSNC M 1 ;
            MSU1 LKJIHGFEDCBA 1 ;
            TNT1 A 0 PB_SetReloading(false);
            goto ready3;
			
		RaiseFromEmpty:
			TNT1 A 0 A_startsound("IronSights",30);
			MSU0 ABCD 1;
			MSU0 EFGH 1;
			MSU0 IJKL 1;
			goto ResumeReload;
			
		ReloadFromSpecial:
			//insert
            MSR6 ABCD 1 {if(!invoker.resonanceAmmoLoaded) {A_SetWeaponSprite("MSNR");}}
            MSR6 EFG 1 {if(!invoker.resonanceAmmoLoaded) {A_SetWeaponSprite("MSNR");}}
            TNT1 A 0 A_startsound("MS/InsertMag",20);
			MSNR HIJKL 1;
			TNT1 A 0 MS_ReloadMag();
            TNT1 A 0 PB_SetMagUnloaded(false);
            TNT1 A 0 PB_SetMagEmpty(false);
            MSNR MNOP 1;
            MSNR QR 1;
            goto Rechamber;

		UnloadMagEmpty:
			MST0 ABCD 1;
			TNT1 A 0 A_startsound("MS/Button",22);
			MST0 E 1;
			TNT1 A 0 {
				PB_UnloadMag(invoker.ammotype2, invoker.ammotype1, 2,1,0,1,"PB_HigherCalRound");
				PB_SetMagUnloaded(true);
				PB_SetMagEmpty(true);
			}
			TNT1 A 0 A_startsound("MS/TakeMag",23);
			MST0 FGH 1;
            MST0 IJKL 1;
			TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(), "FinishUnload");
			Goto UnloadChamber;

		Unload:
			// TNT1 A 0 A_Jumpif(pb_getmagunloaded() || countinv(invoker.ammotype2) < 1,"Ready3");
			TNT1 A 0 A_startsound("IronSights",30);
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded() && !PB_GetChamberEmpty(), "StartUnloadChamber");
			MSU1 ABCD 1;
			MSU1 EFGH 1;
			MSU1 IJKL 1;
			TNT1 A 0 A_JumpIf(PB_GetMagEmpty(), "UnloadMagEmpty");
			MST1 ABCD 1;
			TNT1 A 0 A_startsound("MS/Button",22);
			MST1 E 1;
			TNT1 A 0 A_startsound("MS/TakeMag",23);
			MST1 FGH 1 MS_UnloadSprite("MST3", "MST1");
			TNT1 A 0{
				MS_UnloadMag();
				PB_SetMagUnloaded(true);
				PB_SetMagEmpty(true);
			}
            MST1 IJKL 1 MS_UnloadSprite("MST3", "MST1");
			TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(), "FinishUnload");
		UnloadChamber:
			M3NC ABCD 1;
            M3NC EFGHI 1;
            TNT1 A 0 A_startsound("MS/BoltDown",24);
            M3NC JKL 1;
			TNT1 A 0{
				MS_UnloadMag();
				PB_SetChamberEmpty(true);
			}
            TNT1 A 0 A_startsound("MS/BoltUp",25);
            M3NC M 1;
		FinishUnload:
			TNT1 A 0 {
				if(findinventory("MS_Select_Resonance")){
					MS_AmmoCapacity();
					cleanmodetokens();
					return ResolveState("ReloadFromSpecial");
				}
				return ResolveState(null);
			}
           	MSU0 LKJI 1;
			MSU0 HGFE 1;
			MSU0 DCBA 1;
			goto ready3;

		StartUnloadChamber:
			MSU0 ABCD 1;
			MSU0 EFGH 1;
			MSU0 IJKL 1;
			goto UnloadChamber;
		//
		WeaponSpecial:
			TNT1 A 0 {
				A_Takeinventory("GoWeaponSpecialAbility",1);
				A_Takeinventory("Zoomed",1);
				A_Takeinventory("ADSmode",1);
				A_ZoomFactor(1.0);
			}
			TNT1 A 0 MS_HandleAmmo();
			TNT1 A 0 MS_HandleSpecial();
		ChangeAnim:
			TNT1 A 0 cleanmodetokens();
			TNT1 A 0 A_startsound("IronSights",30);
			MSSW ABCDEFF 1;
			TNT1 A 0 A_startsound("MS/Button",26);
			MSSW GHIJKLM 1;
			goto ready;
			
		MuzzleFlash:
			TNT1 A 0 A_overlayFlags(overlayID(),PSPF_MIRROR|PSPF_FLIP,random(0,1));
			TNT1 A 0 A_jump(128,"MF2");
			MSNM AB 1 bright;
			stop;
		MF2:
			MSNM AC 1 bright;
			stop;
		MuzzleFlash_ADS:
			TNT1 A 0 A_overlayFlags(overlayID(),PSPF_MIRROR|PSPF_FLIP,random(0,1));
			TNT1 A 0 A_jump(128,"MFADS2");
			MSNM DE 1 bright;
			stop;
		MFADS2:
			MSNM DF 1 bright;
			stop;
		MuzzleFlash_Gren:
			TNT1 A 0 A_overlayFlags(overlayID(),PSPF_MIRROR|PSPF_FLIP,random(0,1));
			MSNM G 1 bright;
			stop;
			
		FlashPunching:
			MSNQ ABCDEFGHFEDCBA 1; //14 frames
			goto ready3;
		
		FlashKicking:
			MSNK ABCDEFGHGFEDCBA 1; //15 frames
			goto ready3;
			
		FlashAirKicking:
			MSNQ ABCDEFGHHGFEDCBA 1; //16 frames
			goto ready3;
			
		FlashSlideKicking:
			MSNK ABCDEFGHHHHHHHHHHHHHGFEDCBA 1; //27 frames
			goto ready3;
			
		FlashSlideKickingStop:
			MSNK GFEDCBA 1; //7 frames 
			goto ready3;
		
	}
	
	action void MS_UnloadSprite(name Res, name Normal, int layer = PSP_WEAPON)
	{
		let psp = player.findpsprite(layer);
		
		if(!psp)
			return;
		if(FindInventory("MS_Select_Resonance") && !invoker.resonanceAmmoLoaded)
			psp.sprite = GetspriteIndex(Res);
		else if (invoker.resonanceAmmoLoaded)
			psp.sprite = GetspriteIndex(Res);
		else if (!invoker.resonanceAmmoLoaded)
			psp.sprite = GetspriteIndex(Normal);
	}

	action void MS_ReloadMag()
	{
		int amount = invoker.currentMaxAmmo;
		if(PB_GetChamberEmpty()) amount--;
		int type = invoker.resonanceAmmoLoaded ? 4 : 2;
		PB_AmmoIntoMag(invoker.ammo2.getclassname(), invoker.ammo1.getclassname(), amount, type);
	}

	action void MS_UnloadMag()
	{
		int goal = 1;
		if(PB_GetChamberEmpty()) goal--;
		int type = invoker.resonanceAmmoLoaded ? 3 : 2;
		PB_UnloadMag(invoker.ammotype2, invoker.ammotype1, type, 1, 0, goal, "PB_HigherCalRound");
	}
	
	action void MS_AmmoCapacity()
	{
		int amount = invoker.resonanceAmmoLoaded ? invoker.ammo2.amount / 3 : invoker.ammo2.amount * 3;
		int capacity = invoker.resonanceAmmoLoaded ? MetalSniperFullAmmoResonance : MetalSniperFullAmmo;
		A_SetInventory(invoker.ammotype2, amount);
		SetAmmoCapacity(invoker.ammotype2, capacity);
		invoker.currentMaxAmmo = capacity;
	}

	action state MS_HandleAmmo()
	{
		if(findinventory("MS_Select_NO"))
		{
			cleanmodetokens();
			A_print("$PBX_AmmoNotAvailable");
			return resolvestate("ready3");
		}
		if(findinventory("MS_Select_Resonance"))
		{
			invoker.resonanceAmmoLoaded = !invoker.resonanceAmmoLoaded;
			A_print(invoker.resonanceAmmoLoaded ? "$PBX_MetalSniper_Resonance" : "$PBX_MetalSniper_Standard");
			if(pb_getmagunloaded()) return resolvestate("ReloadFromSpecial");
			return resolvestate("unload");
		}
		return resolvestate(null);
	}

	action state MS_HandleSpecial()
	{
		if((findinventory("MS_Select_AimMode") && MS_getmode() == 0) || 
		(findinventory("MS_Select_GrenMode") && MS_getmode() == 1))
		{
			A_print("$PBX_AlreadySelected");
			cleanmodetokens();
			return resolvestate("ready3");
		}
		
		if(findinventory("MS_Select_AimMode"))
		{
			MS_SetMode();
			A_print("$PBX_MetalSniper_AimMode");
		}
		
		if(findinventory("MS_Select_GrenMode"))
		{
			MS_SetMode(GrenadeMode);
			A_print("$PBX_MetalSniper_GrenMode");
		}
		return resolvestate(null);
	}

	action void MS_ChangeSprite(name empty, name resonance, name normal, int layer = PSP_WEAPON)
	{
		let psp = player.findpsprite(layer);
		
		if(!psp)
			return;
		if(PB_GetMagEmpty())
			psp.sprite = GetspriteIndex(empty);
		else if(invoker.resonanceAmmoLoaded && !PB_GetMagEmpty())
			psp.sprite = GetspriteIndex(resonance);
		// else if(!invoker.resonanceAmmoLoaded && !PB_GetMagEmpty())
		// 	psp.sprite = GetspriteIndex(normal);
			
	}

	action void MS_FireActual()
	{
		if(invoker.resonanceAmmoLoaded){
			PB_FireBullets("MS_ResonanceAmmo", 1, frandom(-0.1, 0.1), 0, 0, frandom(-0.1, 0.1));
			A_startsound("weapons/railgf",20,CHANF_OVERLAP);
		}
		else {
			PB_FireBullets("PB_762x51mmAP", 1, frandom(-0.1, 0.1), 0, 0, frandom(-0.1, 0.1));
			A_startsound("MS/Fire",20,CHANF_OVERLAP);
		}
	}
	action void MetalSniperFireADS()
	{
		A_weaponoffset(0,32);
		A_AlertMonsters();
		PB_DynamicTail("lmg", "lmg");
		A_overlay(muzzlelayer,"MuzzleFlash_ADS");
		MS_FireActual();
		// PB_LowAmmoSoundWarning("lmg");
		pb_takeammo(invoker.ammotype2,1);
		A_SetInventory("CantDoAction",1);
		PB_IncrementHeat(4);
		PB_IncrementHeat(4,true);
		PB_FireOffset();
		PB_GunSmoke(0,0,-2);
		PB_WeaponRecoil(-5,frandom(-1.5,1.5));
		PB_SpawnCasing("LMGCasingStandard",26,2,28,0,Frandom(5,8),Frandom(1,4));
	}
	
	action void MetalSniperFire()
	{
		A_weaponoffset(0,32);
		A_AlertMonsters();
		PB_DynamicTail("lmg", "lmg");
		A_overlay(muzzlelayer,"MuzzleFlash");
		MS_FireActual();
		PB_LowAmmoSoundWarning("lmg");
		pb_takeammo(invoker.ammotype2,1);
		PB_IncrementHeat(4);
		PB_IncrementHeat(4,true);
		PB_FireOffset();
		PB_WeaponRecoil(-4,frandom(-1.5,1.5));
		PB_GunSmoke(0,0,-1);
		PB_SpawnCasing("LMGCasingStandard",26,2,28,0,Frandom(5,8),Frandom(1,4));
		PB_WeaponRecoil(-3,frandom(-0.5,0.5));
	}
	
	action bool iszoom()
	{
		return invoker.isZooming;
	}
	
	action void setZoom(bool set = false)
	{
		invoker.isZooming = set;
	}
	
	action void MS_SetGrenadeQ(bool q = 0)
	{
		invoker.grenadeloaded = q;
	}
	
	action int getgrenqtty()
	{
		return invoker.grenadeloaded;
	}
	
	action bool MS_getmode()
	{
		return invoker.AltMode;
	}
	
	action void MS_SetMode(bool set = SniperMode)
	{
		invoker.AltMode = set;
	}
	
	action void cleanmodetokens()
	{
		A_Takeinventory("MS_Select_AimMode",1);
		A_takeinventory("MS_Select_GrenMode",1);
		A_takeinventory("MS_Select_Resonance",1);
		A_takeinventory("MS_Select_NO",1);
	}
	
	action bool PlayerPressedOnce(int button)
	{
		int bt = player.cmd.buttons;
		int oldbt = player.oldbuttons;
		if((bt & button) && !(oldbt & button))
			return true;
		return false;
	}
	
	override void postbeginplay()
	{
		grenadeloaded = true;
		currentMaxAmmo = MetalSniperFullAmmo;
		super.postbeginplay();
	}
	
	// override void attachtoowner(actor other)
	// {
	// 	if(other && other.player)
	// 	{
	// 		if(other.countinv(ammotype2) < 1 && (countinv(respectInventoryItem) < 1))
	// 			other.A_giveinventory(ammotype2,20);
			
	// 	}
	// 	super.attachtoowner(other);
	// }
	
}
