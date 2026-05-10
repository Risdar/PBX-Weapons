extend class PBX_CSSG
{
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
	
	Action Void CM_HandleUnload()
	{
		int mode = invoker.shellsmode + 1;
		name tounload;
		switch(mode)
		{
			case Shell_Buck: 
				tounload = 'PBX_CSSG_BuckShell';
				break;
			case Shell_Slug:
				tounload = 'PBX_CSSG_SlugShell';
				break;
			case Shell_Flech: 
				tounload = 'PBX_CSSG_FlechetteShell';
				break;
			case Shell_Flak: 
				tounload = 'PBX_CSSG_FlakShell';
				break;
			case Shell_Drgn: 
				tounload = 'PBX_CSSG_DragonsBreathShell';
				break; 
			case Shell_EXPL:
				tounload = 'PBX_CSSG_ExplosiveShell';
				break; 
			case Shell_WPSP: 
				tounload = 'PBX_CSSG_WPShell';
				break;
			case Shell_Doom:
				tounload = 'PBX_CSSG_TDoomShell';
				break;
			case Shell_Damn:	
				tounload = 'PBX_CSSG_DanmakuShell';
				break;
			case Shell_SubZ:	
				tounload = 'PBX_CSSG_SubZeroShell';
				break;
		}
		PB_UnloadMag(
			invoker.ammo2.getClassName(),
			invoker.ammo1.getClassName(),
			1,1,0,0,tounload);
		
	}

	Action state CSSG_HandleWheel()
	{
		int mode = invoker.shellsmode + 1;
		int actmode = invoker.shellsmode; // actual mode
		
		// If you dont have an upgrade token, cancel wheel
		if(countinv("SelectCSG_No") > 0)
		{
			A_TakeInventory("SelectCSG_No",1);
			A_Print("$PBX_AmmoNotAvailable");
			return resolvestate("CancelWheel");
		}

		// If you've already selected the same shell type, cancel wheel
		if(countinv(PBX_CSSG.CSSG_ShellsToken1[actmode]) > 0)
		{
			A_Print("Ammo type already selected: "..PBX_CSSG.CSSG_ShellsType[actmode]);
			return resolvestate("CancelWheel");
		}
		
		// Actual handling of the wheel
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
		 
		// End selection regardless
		return resolvestate("EndSelection");
	}
	
	action void clearcssgtokens()
	{
		for(int j = 0; j < PBX_CSSG.CSSG_ShellsToken1.size(); j++)
			A_takeinventory(PBX_CSSG.CSSG_ShellsToken1[j],10);
	}
}