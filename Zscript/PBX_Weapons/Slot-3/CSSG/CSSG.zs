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
		//PB_WeaponBase.unloadertoken "CSSGHasUnloaded";
		PB_WeaponBase.respectItem "RespectCSSG";
		
		PB_WeaponBase.UsesWheel true;
		PB_WeaponBase.WheelInfo "CSSGWeaponWheel";
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
		Shell_Damn = 9
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
			TNT1 A 0 A_setInventory(invoker.respectInventoryItem,1);
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
				ChangeCSSGShellsLook('C0RB','C0RS','C0RN','C0RK','C0RD','C0RX','C0RW','C0RT','C0RM');
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
			C0HB ABC 1 ChangeCSSGShellsLook('C0HB','C0HS','C0HN','C0HK','C0HD','C0HX','C0HW','C0HT','C0HM');
			C0HB DEF 1 ChangeCSSGShellsLook('C0HB','C0HS','C0HN','C0HK','C0HD','C0HX','C0HW','C0HT','C0HM');
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
			C0RB BCDFGHI 1 ChangeCSSGShellsLook('C0RB','C0RS','C0RN','C0RK','C0RD','C0RX','C0RW','C0RT','C0RM');
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
			C0RB HGFEDCB 1 ChangeCSSGShellsLook('C0RB','C0RS','C0RN','C0RK','C0RD','C0RX','C0RW','C0RT','C0RM');
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
			C0RB BCDEFGH 1 ChangeCSSGShellsLook('C0RB','C0RS','C0RN','C0RK','C0RD','C0RX','C0RW','C0RT','C0RM');
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
			C0HB ABCD 0;
			C0HD ABCD 0;
			C0HX ABCD 0;
			C0HN ABCD 0;
			C0HS ABCD 0;
			C0HW ABCD 0;
			C0HK ABCD 0;
			C0HT ABCD 0;
			C0HM ABCD 0;
			stop;
		
			
	}
	
	static const string CSSG_ShellsType[] = {
		"\cgBuckshot\c- ","\cdSlug\c- ","\cjFlechette\c- ",
		"\chFlak\c- ","\ciDragon Breath's\c- ","\cuExplosive\c- ",
		"\c[WPBronze]White Phosphorous\c- ","\ctTriple Doom\c- ","\c[DanmakuYellow]Danmaku\c- "
	};
	
	static const string CSSG_ShellsToken1[] = {
		"SelectCSG_Buckshot","SelectCSG_Slugshot","SelectCSG_Flechette","SelectCSG_Flak",
		"SelectCSG_Dragonsbreath","SelectCSG_Explosive","SelectCSG_WPhosphorus",
		"SelectCSG_Doom","SelectCSG_Danmaku"
	};
	
	static const string CSSG_ConfirmShell[] = {
		"$PBX_CM_BUCKLD","$PBX_CM_SLUGLD","$PBX_CM_FLCHLD","$PBX_CM_FLAKLD","$PBX_CM_DGBTLD","$PBX_CM_EXPLLD",
		"$PBX_CM_WPLOAD","$PBX_CM_DOOMLD","$PBX_CM_DNMKULD"
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
	Action Void ChangeCSSGShellsLook(name buck = '',name slug = '',name flech = '',name flak = '',name dragons = '',name explo = '',name wp = '',name tds = '',name dnm = '',bool old = false)
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
		}
		
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
		}
		
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
	
	//so i dont need to override the player to add "player.startitem "blablabla",1"
	//its not the full implementation of this, but works for now
	override void attachtoowner(actor other)
	{
		if(other && other.player)
		{
			if(other.countinv(ammotype2) < 1 && (countinv(respectInventoryItem) < 1))
				other.A_giveinventory(ammotype2,2);
		}
		super.attachtoowner(other);
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

//random token for respect animation to work
class RespectCSSG : inventory
{
	default
	{
		inventory.maxamount 1;
	}
}

////////////////////////////////////////////////////
//the projectiles and effects 
////////////////////////////////////////////////////

class ExplosiveProjectile : PB_Projectile
{
	Default
	{
		radius 3;
		height 3;
		Speed 400;
		DamageType "Explosive";
		Gravity 1;
		Scale 0.1;
		Decal "Scorch";
		SeeSound "weapons/RLL";
		Obituary "$PBX_OB_MPROCKET";
		+nogravity;
		damage 12;
		damagetype "ExplosiveImpact";
		PB_Projectile.BaseDamage 20;
		PB_Projectile.RipperCount 0;
	}
	
	States
	{
		Spawn:
			TNT1 A 1;
		Fly:
			DBAC A 1 bright Light("ROCKET")
			{
				if(waterlevel < 1) {
					spawnFirespark(pos);
					//A_SpawnItemEx("RocketTrailSparks",-10,0,0,-5,0,0);
				}
			}
			loop;
		Crash:
		XDeath:
		Death:
			TNT1 A 0;
			TNT1 A 0
			{
				A_Explode(60,128,XF_HURTSOURCE|RTF_THRUSTZ, 0, 64);
				A_StopSound(105);
				A_StartSound("FAREXPL", CHAN_AUTO,CHANF_OVERLAP,0.5,0,1.1);
				A_QuakeEx (2,2,2,4,0,100,"");
				A_SpawnItemEx ("DetectFloorCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
				A_SpawnItemEx ("DetectCeilCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
				A_SpawnItemEx ("ExplosionFlareSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
				A_SpawnItemEx ("LiquidExplosionEffectSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
				A_SpawnProjectile ("ExplosionSmokeFast22", 0, 0, random (0, 360), 2, random (0, 360));
				A_Spawnprojectile ("FireworkSFXType2", 0, 0, random (0, 360), 2, random (-60, -30));
				A_SpawnProjectile ("MediumExplosionFlames", 0, 0, random (0, 360), 2, random (0, 360));
				A_SpawnProjectile ("PBExplosionparticles", 0, 0, random (0, 360), 2, random (40, 90));
				A_SpawnProjectile ("PBExplosionparticles2", 0, 0, random (0, 360), 2, random (40, 90));
				A_SpawnProjectile ("PBExplosionparticles3", 10, 0, random (0, 360), 2, random (40, 90));
			}
			TNT1 A 0 A_Jump(256, "Spawn1", "Spawn2", "Spawn3");
		Spawn1:
			X004 ABCDE 1 bright Light("EXPLOSIONFLASH");
			X004 FGHIJKLMNOPQ 1 bright;
			stop;
		Spawn2:
			X003 ABCDE 1 bright Light("EXPLOSIONFLASH");
			X003 FGHIJKLMNOPQRSTUVWXYZ 1 bright;
			stop;
		Spawn3:
			X125 ABCDE 1 bright Light("EXPLOSIONFLASH");
			X125 FGHIJKLMNOPQR 1 bright;
			Stop;
	}
	
	void spawnFirespark(vector3 position)
	{
		FSpawnParticleParams DBSPK;
		DBSPK.Texture = TexMan.CheckForTexture("REXPA0");
		DBSPK.Color1 = "FFFFFF";//"FF8400";
		DBSPK.Style = STYLE_ADD;
		DBSPK.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		DBSPK.Vel = (frandom(-5,5),frandom(-5,5),frandom(-5,5)); 
		DBSPK.Startroll = random(0,360);
		DBSPK.RollVel = frandom(-15,15);
		DBSPK.StartAlpha = 0.85;
		//DBSPK.FadeStep = 0.1;
		DBSPK.Size = random(12,26);
		DBSPK.SizeStep = -2;
		DBSPK.Lifetime = random(4,8); 
		DBSPK.Pos = position;
		Level.SpawnParticle(DBSPK);
	}
}

Class WPhosphorusProjectile : PB_Projectile
{
	default
	{
		+FORCEXYBILLBOARD;
		+DONTSPLASH;
		damagefunction (15*frandom(2.0,3.0));
		PB_Projectile.BaseDamage 32;
		PB_Projectile.RipperCount 0;
		Decal "SmallerScorch";
		PROJECTILE;
		gravity 0.6;
		DamageType "Fire";
		PoisonDamageType "Fire";
		PoisonDamage 7;
		+ADDITIVEPOISONDURATION;
		renderstyle "add";
		radius 2;
		height 2;
		speed 200;
		alpha 0.95;
		scale 0.45;
	}
	states
	{
		Spawn:
			DBAC A 1 BRIGHT spawnflameFlare(pos);
			//TNT1 A 0 A_SpawnItemEx("ShotgunParticles", random(8,-8), random(8,-8), random(8,-8), 0, 0, 0, 0, 128, 0);
			//TNT1 A 0 A_SpawnItemEx("ExplosionParticleVerySlow", random(8,-8), random(8,-8), random(19,-19), 0, 0, 0, 0, 128, 0);
			Loop;
		/*XDeath:
		Crash:
		Death:
			TNT1 A 0 A_Explode(10,36);
			TNT1 A 1;
			TNT1 A 0 A_SpawnWPSmoke(pos);//A_spawnitem("WhitePSmokeFx");
			TNT1 A 0 A_spawnitem("WPShockWave");
			TNT1 AAAAAA 0 A_spawnitemEx("BigFlamesIG",random(-15,15),random(-15,15),random(-5,5),0,0,0,0,SXF_NOCHECKPOSITION);
			TNT1 A 0 A_SpawnItemEx ("ExplosionFlareSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_startSound("FAREXPL",3);
			stop;*/
	}
	
	bool ticked;
	override void Tick()
	{
		super.tick();
		if(isfrozen())
			return;
		if(!ticked)
			ticked = true;
		else
			SpawnFlameTrail(pos);
	}
	
	override void effect()
	{
		if(ticked)
			SpawnFlameTrail(pos);
	}
	
	override void OnHitActor(Actor target, Name dmgType)
	{
		if(pos.z < floorz)
			SetZ(floorz);
		A_Explode(10,36);
		A_SpawnWPSmoke(pos);
		for(int i = 0; i < random(3,6); i++)
			A_spawnitemEx("BigFlamesIG",random(-15,15),random(-15,15),random(-5,5),0,0,0,0,SXF_NOCHECKPOSITION);
		spawnflameFlare(pos,true);
		A_SpawnItemEx ("ExplosionFlareSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
		A_startSound("FAREXPL",3);
	}
	override void OnExplode(int type)
	{
		if(pos.z < floorz)
			SetZ(floorz);
		A_Explode(10,36);
		A_SpawnWPSmoke(pos);
		for(int i = 0; i < random(3,6); i++)
			A_spawnitemEx("BigFlamesIG",random(-15,15),random(-15,15),random(-5,5),0,0,0,0,SXF_NOCHECKPOSITION);
		spawnflameFlare(pos,true);
		A_SpawnItemEx ("ExplosionFlareSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
		A_startSound("FAREXPL",3);
	}
	
	void A_SpawnWPSmoke(vector3 position)
	{
		FSpawnParticleParams PFSMK;
		PFSMK.Texture = TexMan.CheckForTexture ("X103E0");
		PFSMK.Color1 = "FFFFFF";
		PFSMK.Style = STYLE_Add;
		PFSMK.Flags = SPF_ROLL;
		PFSMK.Vel = (frandom(-2.5,2.5),frandom(-2.5,2.5),frandom(-2.3,2.3)); 
		PFSMK.Startroll = random(0,360);
		PFSMK.RollVel = frandom(-10,10);
		PFSMK.StartAlpha = 0.75;
		PFSMK.FadeStep = 0.1;
		PFSMK.Size = frandom(45,60);
		PFSMK.SizeStep = 6;
		PFSMK.Lifetime = FRandom(10,12); 
		PFSMK.Pos = position;
		Level.SpawnParticle(PFSMK);
	}
	
	void spawnflameFlare(vector3 position, bool bigger = false)
	{
		FSpawnParticleParams FFLAR;
		FFLAR.Texture = TexMan.CheckForTexture("FSO1A0");
		FFLAR.Color1 = "FFFFFF";
		FFLAR.Style = STYLE_ADD;
		FFLAR.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		FFLAR.Vel = (0,0,0);
		FFLAR.Startroll = random(0,360);
		FFLAR.RollVel = frandom(-3,3);
		FFLAR.StartAlpha = 0.85;
		FFLAR.FadeStep = bigger ? 0.15 : 0.25;
		FFLAR.Size = random(100,120);
		FFLAR.SizeStep = 10;
		FFLAR.Lifetime = bigger ? random(3,6): 1; 
		FFLAR.Pos = position;
		Level.SpawnParticle(FFLAR);
	}
	
	void SpawnFlameTrail(vector3 position, bool small = false)
	{
		FSpawnParticleParams FTrail;
		string txt = "EXP7D0";
		int f = random(1,6);
		switch(f)
		{
			case 1:		txt = "EXP7D0";			break;
			case 2:		txt = "EXP8D0";			break;
			case 3:		txt = "EXP2A0";			break;
			case 4:		txt = "EXP0D0";			break;
			case 5:		txt = "EXP9C0";			break;
			case 6:		txt = "EXP6D0";			break;
		}
		FTrail.Texture = TexMan.CheckForTexture(txt);//("DB54K0");
		FTrail.Color1 = "FFFFFF";
		FTrail.Style = STYLE_ADD;
		FTrail.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		FTrail.Vel = (frandom(-1.5,1.5),frandom(-1.5,1.5),frandom(-1.5,1.5)); 
		FTrail.Startroll = random(0,360);
		FTrail.RollVel = frandom(-5,5);
		FTrail.StartAlpha = 1.0;
		FTrail.FadeStep = 0.30;
		FTrail.Size = random(55,72);
		FTrail.SizeStep = -random(4,7);
		FTrail.Lifetime = random(2,3); 
		FTrail.Pos = position;
		Level.SpawnParticle(FTrail);
	}
}

//
//	well, in real life white phosphorous reacts a lot with oxygen and produces a lot of smoke
//
Class BigFlamesIG : FT_GroundFireSpawner
{
	int lifetime;
	Default
	{
		damagetype "Fire";
		renderstyle "add";
		damage 1;
		+nodamagethrust;
		+floorclip;
		scale 0.8;
		+bright;
	}
	
	states
	{
		spawn:
			TNT1 A 0 SpawnWPSmoke(pos + (0,0,random(28,36)));
			TNT1 A 0 spawnphosphorusFlare(pos + (0,0,6));
			FLME ABCDEFG 1 {
				if(random(0,1) == 1)
					A_explode(3,180,XF_NOSPLASH|XF_HURTSOURCE);
			}
			TNT1 A 0 SpawnWPSmoke(pos + (0,0,random(28,36)));
			TNT1 A 0 spawnphosphorusFlare(pos + (0,0,6));
			TNT1 A 0 SpawnParticleFast();
			FLME HIJKLM 1 {
				if(random(0,1) == 1)
					A_explode(3,180,XF_NOSPLASH|XF_HURTSOURCE);
			}
			TNT1 A 0 SpawnWPSmoke(pos + (0,0,random(28,36)));
			FLME N 1 {
				SpawnParticleFast();
				lifetime--;
			}
			TNT1 A 0 A_jumpif(lifetime <= 0 || waterlevel > 0,"Fadening");
			loop;
		Fadening:
			TNT1 A 0 spawnphosphorusFlare(pos + (0,0,6),true);
			FLME ABCDEFGHIJKLMN 1 {
				A_Fadeout(0.1);
				A_setscale(self.scale.x - frandom(0.02,0.07));
			}
			loop;
	}
	
	string flarcol;
	
	override void beginplay()
	{
		lifetime = random(7,35);
		bXFLIP = random(0,1);
		A_Setscale(self.scale.x + frandom(-0.2,0.2));
		flarcol = "LENYA0";
		switch(random(1,6))
		{
			case 1: flarcol = "LENYA0";	break;
			case 2: flarcol = "LENRA0";	break;
			case 3: flarcol = "LEYSO0";	break;
			case 4: flarcol = "L2NYA0";	break;	
			case 5: flarcol = "FLARA0";	break;
			case 6: flarcol = "DBFLA0";	break;
		}
		super.beginplay();
	}
	
	void SpawnWPSmoke(vector3 position)
	{
		if(pb_performance_fire)
			return;
		FSpawnParticleParams PFSMK;
		PFSMK.Texture = TexMan.CheckForTexture("X103E0");
		PFSMK.Color1 = "FFFFFF";
		PFSMK.Style = STYLE_ADD;
		PFSMK.Flags = SPF_ROLL;
		PFSMK.Vel = (frandom(-1.0,1.0),frandom(-1.0,1.0),frandom(2.75,10.5)); 
		PFSMK.Startroll = random(0,360);
		PFSMK.RollVel = frandom(-10,10);
		PFSMK.StartAlpha = 0.25;
		PFSMK.Size = frandom(60,70);
		PFSMK.SizeStep = 6;
		PFSMK.Lifetime = FRandom(9,15);
		PFSMK.FadeStep = PFSMK.StartAlpha / PFSMK.Lifetime;
		PFSMK.Pos = position;
		Level.SpawnParticle(PFSMK);
	}
	
	void spawnphosphorusFlare(vector3 position, bool dying = false)
	{
		FSpawnParticleParams FFLAR;
		FFLAR.Texture = TexMan.CheckForTexture(flarcol);
		FFLAR.Color1 = "FFFFFF";
		FFLAR.Style = STYLE_ADD;
		FFLAR.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		FFLAR.Vel = (0,0,0);
		FFLAR.Startroll = random(0,360);
		FFLAR.RollVel = frandom(-3,3);
		FFLAR.StartAlpha = 0.25;
		FFLAR.FadeStep = dying ? 0.03 : 0;
		FFLAR.Size = random(140,150);
		FFLAR.SizeStep = dying ? -0.25 : 0;
		FFLAR.Lifetime = 7; 
		FFLAR.Pos = position;
		Level.SpawnParticle(FFLAR);
	}
	
}

Class WPShockWave : Actor
{
	default
	{
		Translation "0:255=%[0,0,0]:[1.0,1.0,1.0]";
		renderstyle "add";
		//+bright;
		Scale 0.44;
		+nointeraction;
	}
	states
	{
		Spawn:
			X060 A 1 {
				A_fadeout(0.1);
				A_setscale(self.scale.x + frandom(0.06,0.1));
			}
			loop;
	}
}


Class DanmakuProjectile : Actor
{
	default
	{
		projectile;
		speed 80;
		+doombounce;
		bouncecount 3;
		radius 5;
		height 5;
		projectilekickback 900;
		damage (10);
		renderstyle "add";
		+CANBOUNCEWATER;
		+BOUNCEAUTOOFF;
		+USEBOUNCESTATE;
		+bright;
		+forcexybillboard;
		+rollsprite;
		+FORCERADIUSDMG;
		damagetype "plasma";
	}
	
	color tracercolor;
	
	states
	{
		Spawn:
			TPEL A 1 nodelay A_Spawnparticle(tracercolor,SPF_FULLBRIGHT|SPF_NOTIMEFREEZE|SPF_RELATIVE,3,18,0,0,0,0,0,0,0,0,0,0,1,-1,-1);
		Fly:
			TPEL A 1 {
				spawnDnmkFlare(pos);
				A_Spawnparticle(tracercolor,SPF_FULLBRIGHT|SPF_RELATIVE,3,random(13,15),0,0,0,0,0,0,0,0,0,0,1,-1,-1);
			}
			loop;
			
		Bounce:
			TNT1 A 0 SpawnSparkFx(pos);
			TPEL A 1 SpawnSparkFx(pos);
			goto Fly;
			
		Death:
			TNT1 A 0 A_setscale(0.1);
			TNT1 A 0 A_explode(1,60,0);
			TNT1 A 0 A_Startsound("lildead",32);
			TNT1 A 0 SpawnBounceFx(pos);
			TNT1 A 0 spawnDnmkFlare(pos,true);
			TNT1 A 0 SpawnSparkFx(pos);
			5PRK AAAA 1 { A_setscale(self.scale.x + frandom(0.025,0.075)); A_Fadeout(0.15); }
			stop;
			
	}
	
	static const color DanmkTracerCol[] = {
		"83FFF9","D083FF","83AEFF","BAEFFF","E0BAFF",
		"E9BAFF","FFBAD0","7FC9FF","C27FFF","FFFFFF"
	};
	
	void SpawnBounceFx(vector3 where)
	{
		FSpawnParticleParams DnmkBnc;
		DnmkBnc.Texture = TexMan.CheckForTexture("SHWKK0");
		DnmkBnc.Color1 = tracercolor;//"FFFFFF";
		DnmkBnc.Style = STYLE_AddStencil;
		DnmkBnc.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		DnmkBnc.Vel = (0,0,0); 
		DnmkBnc.Startroll = 0;//random(0,360);
		DnmkBnc.RollVel = frandom(-3,3);
		DnmkBnc.StartAlpha = 0.80;
		DnmkBnc.Lifetime = random(7,10); 
		DnmkBnc.FadeStep = DnmkBnc.StartAlpha / DnmkBnc.Lifetime;
		DnmkBnc.Size = 32;
		DnmkBnc.SizeStep = 15;
		DnmkBnc.Pos = where;
		Level.SpawnParticle(DnmkBnc);
	}
	
	void SpawnSparkFx(vector3 where)
	{
		FSpawnParticleParams DnmkSprk;
		DnmkSprk.Texture = TexMan.CheckForTexture("5PRKA0");
		DnmkSprk.Color1 = tracercolor;//"FFFFFF";
		DnmkSprk.Style = STYLE_Add;
		DnmkSprk.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		DnmkSprk.Vel = (random(-5,5),random(-5,5),random(-2,9));
		DnmkSprk.accel = (0,0,frandom(-1.75,-0.75));
		DnmkSprk.Startroll = randompick(0,90,180,270,360);
		DnmkSprk.RollVel = 0;
		DnmkSprk.StartAlpha = 1.0;
		DnmkSprk.FadeStep = 0.075;
		DnmkSprk.Size = random(8,14);
		DnmkSprk.SizeStep = -0.5;
		DnmkSprk.Lifetime = random(12,18); 
		DnmkSprk.Pos = where;
		Level.SpawnParticle(DnmkSprk);
	}
	
	void spawnDnmkFlare(vector3 position, bool bigger = false)
	{
		FSpawnParticleParams FFLAR;
		FFLAR.Texture = TexMan.CheckForTexture("5PRKA0");//("LENSA0");//("L2NBA0");
		FFLAR.Color1 = tracercolor;//"FFFFFF";
		FFLAR.Style = STYLE_ADDSTENCIL;
		FFLAR.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		FFLAR.Vel = (0,0,0);
		FFLAR.Startroll = random(0,360);
		FFLAR.RollVel = frandom(-5,5);
		FFLAR.StartAlpha = 0.85;
		FFLAR.FadeStep = 0.15;
		FFLAR.Size = bigger ? random(50,69) : random(20,30);
		FFLAR.SizeStep = -5;
		FFLAR.Lifetime = bigger ? random(4,6): 1; 
		FFLAR.Pos = position;
		Level.SpawnParticle(FFLAR);
	}
	
	override void beginplay()
	{
		self.bxflip = random(0,1);
		self.byflip = random(0,1);
		A_Setroll(random(0,360));
		int c = random(0,self.DanmkTracerCol.Size()-1);
		tracercolor = self.DanmkTracerCol[c];
		super.beginplay();
	}
}
