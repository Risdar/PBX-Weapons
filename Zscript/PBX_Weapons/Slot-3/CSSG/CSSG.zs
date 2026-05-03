//the main weapon, defined here before a thousand tokens
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
		
		Steady:
			TNT1 A 1;
			Goto Ready;
		
		Select:
			TNT1 A 0 A_weaponoffset(0,32);
			goto SelectFirstPersonLegs;
		SelectContinue:
			TNT1 A 0 PB_WeapTokenSwitch("SSGSelected");
			TNT1 A 0 PB_RespectIfNeeded();
		SelectAnimation:
			TNT1 A 0 A_zoomfactor(1.0);
			TNT1 A 0 A_startsound("COMSSGUP",7);
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
			TNT1 A 0 PB_AmmoIntoMag("CSSGShellsIn","PB_Shell",2,1);
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
				A_SetRoll(0);
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
			TNT1 A 0 PB_JumpIfNoAmmo("LeftFire",2,true,true,"");
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
			TNT1 A 0 PB_CheckReload(null, null, null,"Ready3","Ready3",2);
			TNT1 A 0 A_JumpIfInventory("CSSGShellsIn", 1, 1);
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
				PB_AmmoIntoMag("CSSGShellsIn","PB_Shell",2,1);
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
				PB_AmmoIntoMag("CSSGShellsIn","PB_Shell",2,1);
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
				PB_UnloadMag("CSSGShellsIn","PB_Shell",1);
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
			TNT1 AA 0 A_spawnCSSGCasing(true);
			C0RO NOP 1;
			C0RB A 1;
			C0RB BCDEFGH 1 ChangeCSSGShellsLook('C0RB','C0RS','C0RN','C0RK','C0RD','C0RX','C0RW','C0RT','C0RM','C0RX');
			TNT1 A 0 A_startsound("weapons/cssg/in",24);
			TNT1 A 0 {
				if(countinv(invoker.ammotype2)<2 && countinv(invoker.ammotype1)>0)
					PB_AmmoIntoMag("CSSGShellsIn","PB_Shell",2,1);
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
	
	static const string CSSG_ShellsType[] = {
		"\cgBuckshot\c- ","\cdSlug\c- ","\cjFlechette\c- ",
		"\chFlak\c- ","\ciDragon Breath's\c- ","\cuExplosive\c- ",
		"\c[WPBronze]White Phosphorous\c- ","\ctTriple Doom\c- ",
		"\c[DanmakuYellow]Danmaku\c- ","\cnSub-Zero\c- "
	};
	
	static const string CSSG_ShellsToken1[] = {
		"SelectCSG_Buckshot","SelectCSG_Slugshot","SelectCSG_Flechette","SelectCSG_Flak",
		"SelectCSG_Dragonsbreath","SelectCSG_Explosive","SelectCSG_WPhosphorus",
		"SelectCSG_Doom","SelectCSG_Danmaku","SelectCSG_SubZero"
	};
	
	static const string CSSG_ConfirmShell[] = {
		"$PBX_CM_BUCKLD","$PBX_CM_SLUGLD","$PBX_CM_FLCHLD","$PBX_CM_FLAKLD","$PBX_CM_DGBTLD","$PBX_CM_EXPLLD",
		"$PBX_CM_WPLOAD","$PBX_CM_DOOMLD","$PBX_CM_DNMKULD","$PBX_CM_SUBZRLD"
	};
	
	//for easier sprites manipulation
	//gets a pointer to the asked layer and sets the defined sprite 
	Action Void PB_ChangePsPrite(name spt,int layer = PSP_WEAPON)
	{
		let PS = player.findPSprite(layer);
		if(PS)
			PS.sprite = GetSpriteIndex(spt);
	}
	
	//bascially, check wich shells is actually used, and change the sprite based on that
	Action Void ChangeCSSGShellsLook(
		name buck = '',
		name slug = '',
		name flech = '',
		name flak = '',
		name dragons = '',
		name explo = '',
		name wp = '',
		name tds = '',
		name dnm = '',
		name subz = '',
		bool old = false)
	{
		int wich = old ? invoker.oldshells : invoker.shellsmode;
		wich++;
		switch(wich)
		{
			case Shell_Buck: PB_ChangePsPrite(buck); break;
			case Shell_Slug: PB_ChangePsPrite(slug); break;
			case Shell_Flech: PB_ChangePsPrite(flech); break;
			case Shell_Flak: PB_ChangePsPrite(flak); break;
			case Shell_Drgn: PB_ChangePsPrite(dragons); break;
			case Shell_EXPL: PB_ChangePsPrite(explo); break;
			case Shell_WPSP: PB_ChangePsPrite(wp); break; 
			case Shell_Doom: PB_ChangePsPrite(tds); break;
			case Shell_Damn: PB_ChangePsPrite(dnm); break;
			case Shell_SubZ: PB_ChangePsPrite(subz); break;
		}
		
	}
	
	//shells:
	// 0-buckshot 1-slug 2-flechette
	// 3-flak 4-dragon breath
	// 5-explosive 6-white phosphorous 7-Doom shells
	// 8-danmaku
	
	//to cycle shells ->
	Action Void CycleShellFw()
	{
		//cycle to the right
		int actmod = invoker.shellsmode;
		invoker.oldshells = actmod;
		A_startsound("menu/change",CHAN_AUTO);
		actmod++;
		
		//dont need extra checks there
		if(actmod < 4)
		{
			invoker.shellsmode = actmod;
			//PrintCurrentShell();
			return;
		}
		
		//this is kinda weird, the idea is, if you DONT have the upgrade, add another, so it jumps to the next shell type
		//if you dont have any upgrade, just go back to 0, wich means buckshot
		//if got dragon breat upgrade
		if(countinv("DragonBreathUpgrade")<1 && actmod == 4)
			actmod++;
		//if got Explosive upgrade
		if(countinv("ExplosiveUpgrade")<1 && actmod == 5)
			actmod++;
		//if got White phosphoruos upgrade (dragon breath 2: this time its personal)
		if(countinv("WhitePhosphorusUpgrade")<1 && actmod == 6)
			actmod++;
		if(countinv("TripleDoomUpgrade")<1 && actmod == 7)
			actmod++;
		if(countinv("DanmakuUpgrade")<1 && actmod == 8)
			actmod++;
			
		if(actmod > 8)
			actmod = 0;
		
		//clamps, so it never goes out from the types allowed
		actmod = clamp(actmod,0,8);
		invoker.shellsmode = actmod;
		//PrintCurrentShell();
		return;
	}
	
	//to cycle shells <-
	Action Void CycleShellBack()
	{
		//idk why it was harder to do the back cycling than the forward one
		//console.printf("cicling back.");
		int actmod = invoker.shellsmode;
		invoker.oldshells = actmod;
		A_startsound("menu/change",CHAN_AUTO);
		
		actmod--;
		
		if(actmod < 0)
			actmod = 8;
			
		if(actmod < 4)
		{
			invoker.shellsmode = actmod;
			//PrintCurrentShell();
			return;
		}
		
		//the same as the other functions but the other way around, decrements if you dont have that specific upgrade
		if(countinv("DanmakuUpgrade")<1 && actmod == 8)
			actmod--;
		if(countinv("TripleDoomUpgrade")<1 && actmod == 7)
			actmod--;
		if(countinv("WhitePhosphorusUpgrade")<1 && actmod == 6)
			actmod--;
		if(countinv("ExplosiveUpgrade")<1 && actmod == 5)
			actmod--;
		if(countinv("DragonBreathUpgrade")<1 && actmod == 4)
			actmod--;
		
		actmod = clamp(actmod,0,8);
		invoker.shellsmode = actmod;
		//PrintCurrentShell();
		
	}

	
	//this just prints the selected shell message
	Action Void PrintSelectedShell()
	{
		int wich = invoker.shellsmode + 1;
		switch(wich)
		{
			case Shell_Buck: A_Print("$PBX_CM_BUCKLD"); break;
			case Shell_Slug: A_Print("$PBX_CM_SLUGLD"); break;
			case Shell_Flech: A_Print("$PBX_CM_FLCHLD"); break;
			case Shell_Flak: A_Print("$PBX_CM_FLAKLD"); break;
			case Shell_Drgn: A_Print("$PBX_CM_DGBTLD"); break;
			case Shell_EXPL: A_Print("$PBX_CM_EXPLLD"); break;
			case Shell_WPSP: A_Print("$PBX_CM_WPLOAD"); break;
			case Shell_Doom: A_Print("$PBX_CM_DOOMLD"); break;
			case Shell_Damn: A_Print("$PBX_CM_DNMKULD"); break;
			case Shell_SubZ: A_Print("$PBX_CM_SUBZRLD"); break;
		}
	}
	
	//this was just a debug thing
	Action Void PrintCurrentShell()
	{
		int wich = invoker.shellsmode + 1;
		switch(wich)
		{
			case Shell_Buck: console.printf("\cg Buckshot"); break;
			case Shell_Slug: console.printf("\cd Slugs"); break;
			case Shell_Flech: console.printf("\cjFlechette"); break;
			case Shell_Flak: console.printf("\chFlak"); break;
			case Shell_Drgn: console.printf("\ci Dragon Breath"); break;
			case Shell_EXPL: console.printf("\cuExplosive"); break;
			case Shell_WPSP: console.printf("\c[WPBronze]White Phosphorus"); break;
			case Shell_Doom: console.printf("\ctDoom Shells"); break;
			case Shell_Damn: console.printf("\c[DanmakuYellow]Danmaku Shells"); break;
			case Shell_SubZ: console.printf("\cnSub-Zero Shells"); break;
		}
	}
	
	
	//this function spawns the casing based on the current shell
	Action Void A_spawnCSSGCasing(bool useprev = false)
	{
		string shelltype = "BuckShellCasing";
		int wich = invoker.shellsmode + 1;
		if(useprev)
			wich = invoker.oldshells + 1;
		switch(wich)
		{
			case Shell_Buck: shelltype = "BuckShellCasing"; break;
			case Shell_Slug: shelltype = "SlugShellCasing"; break;
			case Shell_Flech: shelltype = "FlechetShellCasing"; break;
			case Shell_Flak: shelltype = "FlakShellCasing"; break;
			case Shell_Drgn: shelltype = "DragonShellCasing"; break;
			case Shell_EXPL: shelltype = "ExplosiveShellCasing"; break;
			case Shell_WPSP: shelltype = "WhitePShellCasing"; break;
			case Shell_Doom: shelltype = "TDoomCasing"; break;
			case Shell_Damn: shelltype = "DanmakuCasing"; break;
			case Shell_SubZ: shelltype = "SubZeroCasing"; break;
		}
		
		
		PB_SpawnCasing(shelltype,random(10,14),random(-1,3),random(26,28),random(1,3),random(-5,-2),random(4,7));
	}
	
	//just the pb_Firebullets but with a null check added
	//might remove this when the null check is added in pb itself
	action void CSSG_FireBullets(string type, int amount, double angle, double offs, double height, double pitch)
	{
		vector2 spread;
		for(int i = amount; i > 0; i--)
		{
			spread.x = frandom(-angle, angle);
			spread.y = frandom(-pitch, pitch);

			if(i == amount) 
			{
				spread.x *= PB_Math.LinearMap(pb_weapon_recoil_mod_horizontal, 0.0, 1.0, 1.0, 0.2);
				spread.y *= PB_Math.LinearMap(pb_weapon_recoil_mod_vertical, 0.0, 1.0, 1.0, 0.2);
				// spread *= clamp((invoker.sustainedFire / 5), 0, 1);
				spread *= GetCrouchFactor();
			}

			Actor p1, p2 = A_FireProjectile(type, spread.x, 0, offs, height, FPF_NOAUTOAIM, spread.y);

            if(p2)
            {
                PB_Projectile pbProj = PB_Projectile(p2);
				if(pbProj)
					pbProj.isBloodExplosionGenerator = amount > 4 && i == amount;
            }
		}
	}
	
	//the nexts funcions exist only to not bloat the code and dont make a lot of different fire states
	//so all is handled here, so if something goes wrong, i can fix it here once, and not in every state
	Action Void FireCSSGFirst()
	{
		int mode = invoker.shellsmode + 1;
		switch(mode)
		{
			case Shell_Buck: 
				PB_FireBullets("PB_10GAPellet",20,8,0,0,6);
				PB_FireBullets("PB_10GAPellet_LP",1,0,0,0,0);
				break;
			case Shell_Slug:
				PB_FireBullets("PB_12GASlug",1,0.1,2,0,0); 
				PB_FireBullets("PB_12GASlug",1,0.1,-2,0,0); 
				break;
			case Shell_Flech: 
				PB_FireBullets("PB_MGNail",12,3,0,0,3); 
				break;
			case Shell_Flak: 
				CSSG_FireBullets("chunk1",3,5,0,0,3); 
				CSSG_FireBullets("chunk2",3,3,0,0,4);
				CSSG_FireBullets("chunk4",1,4,0,0,3);
				break;
			case Shell_Drgn: 
				PB_FireBullets("PB_DragonsBreathTracer",10,6,0,0,6); 
				break; 
			case Shell_EXPL:
				PB_FireBullets("ExplosiveProjectile",4,6,0,0,6); 
				break; 
			case Shell_WPSP: 
				PB_FireBullets("WPhosphorusProjectile",7,6,0,0,6);
				break;
			case Shell_Doom:
				PB_FireBullets("PB_12GASlug",1,0.1,2,0,0); 
				PB_FireBullets("PB_12GASlug",1,0.1,-2,0,0);
				PB_FireBullets("PB_10GAPellet",10,6,0,0,6);
				PB_FireBullets("PB_10GAPellet_LP",2,6,0,0,6);
				PB_FireBullets("PB_8GAPellet",10,16,0,0,12);
				break;
			case Shell_Damn:
				CSSG_FireBullets("DanmakuProjectile",16,4.0,0,0,2.5);
				break;
			case Shell_SubZ:
				A_SpawnItemEx("BlueFlareSpawn", 0, 0, -3);
				A_SpawnItemEx("BlueFlareSpawn", 0, 0, 3);
				PB_FireBullets("SubZeroProjectile",10,6,0,0,6);
				// A_FireBullets (8, 6, 10, 18, "ShotKeeperPuff",FBF_NORANDOM,8192,"CSSG_FrozenTracer",-12);
         		A_FireBullets (8, 6, 10, 18, "SubZ_Puff",FBF_NORANDOM,8192,"CSSG_FrozenTracer",-12);
				break;
		}
		
	}
	
	action void FireCSSG()
	{
			FireCSSGFirst();
			A_ZoomFactor(0.92);
			PB_FireOffset();
			A_takeinventory(invoker.ammotype2,2);
			PB_WeaponRecoil(-7,frandom(-1.5,1.5));
			PB_GunSmoke(2,0,-1);
			PB_GunSmoke(-2,0,-1);
			A_FireProjectile("ShotgunWad",random(-2,2),0,3,-4,FPF_NOAUTOAIM,random(-2,2));
			A_FireProjectile("ShotgunWad",random(-2,2),0,-3,-4,FPF_NOAUTOAIM,random(-2,2));	
	}
	
	Action Void CM_HandleCrosshair()
	{
		int mode = invoker.shellsmode + 1;
		switch(mode)
		{
			case Shell_Buck: 
				PB_HandleCrosshair(69);
				break;
			case Shell_Slug:
				PB_HandleCrosshair(69);
				break;
			case Shell_Flech: 
				PB_HandleCrosshair(70);
				break;
			case Shell_Flak: 
				PB_HandleCrosshair(72);
				break;
			case Shell_Drgn: 
				PB_HandleCrosshair(69);
				break; 
			case Shell_EXPL:
				PB_HandleCrosshair(73);
				break; 
			case Shell_WPSP: 
				PB_HandleCrosshair(74);
				break;
			case Shell_Doom:
				PB_HandleCrosshair(11);
				break;
			case Shell_Damn:	
				PB_HandleCrosshair(45);
				break;
			case Shell_SubZ:	
				PB_HandleCrosshair(71);
				break;
		}
		
	}

	Action Void FireHalfCSSGRight()
	{
		
		int mode = invoker.shellsmode + 1;
		switch(mode)
		{
			case Shell_Buck: 
				PB_FireBullets("PB_10GAPellet",10,8,0,0,6);
				break;
			case Shell_Slug: 
				PB_FireBullets("PB_12GASlug",1,0.1,2,0,0); 
				break;
			case Shell_Flech: 
				PB_FireBullets("PB_MGNail",6,3,0,0,3); 
				break;
			case Shell_Flak: 
				CSSG_FireBullets("chunk1",3,3,0,0,3); 
				CSSG_FireBullets("chunk4",1,3,0,0,3);
				break;
			case Shell_Drgn: 
				PB_FireBullets("PB_DragonsBreathTracer",5,6,0,0,6); 
				break; 
			case Shell_EXPL:
				PB_FireBullets("ExplosiveProjectile",2,6,0,0,6); 
				break; 
			case Shell_WPSP: 
				PB_FireBullets("WPhosphorusProjectile",4,6,0,0,6);
				break;
			case Shell_Doom:
				PB_FireBullets("PB_12GASlug",1,0.1,2,0,0); 
				PB_FireBullets("PB_10GAPellet",4,6,0,0,6);
				PB_FireBullets("PB_10GAPellet_LP",2,6,0,0,6);
				PB_FireBullets("PB_8GAPellet",5,13,0,0,8);
				break;
			case Shell_Damn:
				CSSG_FireBullets("DanmakuProjectile",8,1.5,2,0,1.2);
				break;
			case Shell_SubZ:
				A_SpawnItemEx("BlueFlareSpawn", 0, 0, -3);
				A_SpawnItemEx("BlueFlareSpawn", 0, 0, 3);
				PB_FireBullets("SubZeroProjectile",5,6,0,0,6);
				// A_FireBullets (8, 6, 10, 18, "ShotKeeperPuff",FBF_NORANDOM,8192,"CSSG_FrozenTracer",-12);
         		A_FireBullets (8, 6, 10, 18, "SubZ_Puff",FBF_NORANDOM,8192,"CSSG_FrozenTracer",-12);
				break;
		}
		PB_IncrementHeat(4);
		
	}
	
	Action Void FireHalfCSSGLeft()
	{
		
		int mode = invoker.shellsmode + 1;
		switch(mode)
		{
			case Shell_Buck: 
				PB_FireBullets("PB_10GAPellet",9,6,0,0,6);
				break;
			case Shell_Slug: 
				PB_FireBullets("PB_12GASlug",1,0.1,-2,0,0); 
				break;
			case Shell_Flech: 
				PB_FireBullets("PB_MGNail",6,3,0,0,3); 
				break;
			case Shell_Flak: 
				CSSG_FireBullets("chunk2",3,3,0,0,3); 
				break;
			case Shell_Drgn: 
				PB_FireBullets("PB_DragonsBreathTracer",5,6,0,0,6); 
				break; 
			case Shell_EXPL:
				PB_FireBullets("ExplosiveProjectile",2,6,0,0,6); 
				break; 
			case Shell_WPSP: 
				PB_FireBullets("WPhosphorusProjectile",3,6,0,0,6);
				break;
			case Shell_Doom:
				PB_FireBullets("PB_12GASlug",1,0.1,-2,0,0); 
				PB_FireBullets("PB_10GAPellet",4,6,0,0,6);
				PB_FireBullets("PB_10GAPellet_LP",2,6,0,0,6);
				PB_FireBullets("PB_8GAPellet",5,12,0,0,8);
				break;
			case Shell_Damn:
				CSSG_FireBullets("DanmakuProjectile",8,1.6,-2,0,1.2);
				break;
			case Shell_SubZ:
				A_SpawnItemEx("BlueFlareSpawn", 0, 0, -3);
				A_SpawnItemEx("BlueFlareSpawn", 0, 0, 3);
				PB_FireBullets("SubZeroProjectile",5,6,0,0,6);
				// A_FireBullets (8, 6, 10, 18, "ShotKeeperPuff",FBF_NORANDOM,8192,"CSSG_FrozenTracer",-12);
         		A_FireBullets (8, 6, 10, 18, "SubZ_Puff",FBF_NORANDOM,8192,"CSSG_FrozenTracer",-12);
				break;
		}
		PB_IncrementHeat(4);
		
	}
	
	Action Void CM_PlayFireSound()
	{
		int mode = invoker.shellsmode + 1;
		switch(mode)
		{
			case Shell_Buck: 
				A_Startsound("SSHFIRE",21);
				A_Startsound("CSSGFULL",22);
				break;
			case Shell_Slug:
				A_Startsound("CSSGSLGF",22);
				break;
			case Shell_Flech: 
				A_Startsound("CSSGFULL",21);
				A_Startsound("CSSGFLKF",22);
				break;
			case Shell_Flak: 
				A_Startsound("CSSGFULL",21);
				A_Startsound("CSSGFLKF",22);
				break;
			case Shell_Drgn: 
				A_Startsound("SSHFIRE",21);
				A_Startsound("CSSGDBF",22);
				break; 
			case Shell_EXPL:
				A_Startsound("CSSGEXPF",22);
				break; 
			case Shell_WPSP: 
				A_Startsound("CSSGPHOF",22);
				break;
			case Shell_Doom:
				A_Startsound("CSSGEXPF",21);
				A_Startsound("CSSGSLGF",23);
				A_Startsound("CSSGFULL",22);
				break;
			case Shell_Damn:	
				A_Startsound("CSSGDANF",22);
				break;
			case Shell_SubZ:	
				A_Startsound("weapons/CryoRifle/missile",21);
				break;
		}
		
	}
	
	Action void CM_PlayAltFireSound()
	{
		int mode = invoker.shellsmode + 1;
		switch(mode)
		{
			case Shell_Buck: 
				A_Startsound("weapons/shh2",21);
				A_Startsound("CSSGSNGL",22);
				break;
			case Shell_Slug:
				A_Startsound("CSSGSLGS",22);
				break;
			case Shell_Flech: 
				A_Startsound("CSSGSNGL",21);
				A_Startsound("CSSGFLKS",22);
				break;
			case Shell_Flak: 
				A_Startsound("CSSGSNGL",21);
				A_Startsound("CSSGFLKS",22);
				break;
			case Shell_Drgn: 
				A_Startsound("weapons/shh2",21);
				A_Startsound("CSSGDBS",22);
				break; 
			case Shell_EXPL:
				A_Startsound("CSSGEXPS",22);
				break; 
			case Shell_WPSP: 
				A_Startsound("CSSGPHOS",22);
				break;
			case Shell_Doom:
				A_Startsound("CSSGEXPF",21);
				A_Startsound("CSSGSLGS",22);
				break; 
			case Shell_Damn:	
				A_Startsound("CSSGDANS",22);
				break;
			case Shell_SubZ:	
				A_Startsound("weapons/CryoRifle/missile",21);
				break;
		}

	}
	
	Action state CSSG_HandleWheel()
	{
		int mode = invoker.shellsmode + 1;
		int actmode = invoker.shellsmode;
		
		if(countinv("SelectCSG_No") > 0)
		{
			A_TakeInventory("SelectCSG_No",1);
			A_Print("$PBX_AmmoNotAvailable");
			return resolvestate("CancelWheel");
		}

		if(countinv(PBX_CSSG.CSSG_ShellsToken1[actmode]) > 0)
		{
			A_Print("Ammo type already selected: "..PBX_CSSG.CSSG_ShellsType[actmode]);
			return resolvestate("CancelWheel");
		}
		
		for(int i = 0; i < PBX_CSSG.CSSG_ShellsToken1.size(); i++)
		{
			if(countinv(PBX_CSSG.CSSG_ShellsToken1[i]) > 0)
			{
				invoker.oldshells = invoker.shellsmode;
				invoker.shellsmode = i;
				A_print(PBX_CSSG.CSSG_ConfirmShell[i]);
				return resolvestate("EndSelection");
			}
		}
		 
		 return resolvestate("EndSelection");
	}
	
	action void clearcssgtokens()
	{
		for(int j = 0; j < PBX_CSSG.CSSG_ShellsToken1.size(); j++)
			A_takeinventory(PBX_CSSG.CSSG_ShellsToken1[j],10);
	}
	
}

//the ammo counter
Class CSSGShellsIn : Ammo
{
	default
	{
		inventory.maxamount 2;
		ammo.backpackamount 0;
		ammo.backpackmaxamount 2;
	}
}

//random token that apparently is needed
Class CSSGHasUnloaded : inventory
{
	default
	{
		inventory.maxamount 1;
	}
}


