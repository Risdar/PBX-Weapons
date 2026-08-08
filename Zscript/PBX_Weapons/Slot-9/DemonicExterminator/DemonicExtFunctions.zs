extend class PBX_DemonExt{

	override void ondrop(actor dropper)
	{
		dropper.A_StopSound(chan_unmkidle);
		super.ondrop(dropper);
	}
	
	Action Void UNM_ChangePSFrame(int frm = 0,int layer = PSP_WEAPON)
	{
		let PS = player.findPSprite(layer);
		if(PS)
			PS.frame = frm;
	}

	Action void WeaponSpecialCheck()
	{
		bool goLaser = countinv("UMDE_Select_LaserMode") > 0;
		bool goIncenartor = countinv("UMDE_Select_IncinerationMode") > 0;
		bool goLightning = countinv("UMDE_Select_LightningMode") > 0;

		if(FindInventory("GoWeaponSpecialAbility") || goLaser || goIncenartor || goLightning)
		{
			A_TakeInventory("GoWeaponSpecialAbility",1);
			
			if(countinv("PBX_CloseWheel") > 0)
			{
				A_TakeInventory("PBX_CloseWheel",1);
				return;
			}

			if((goLaser      && invoker.ExterminatorMode == LaserMode) 
			|| (goIncenartor && invoker.ExterminatorMode == IncinerationMode) 
			|| (goLightning  && invoker.ExterminatorMode == LightningMode))
			{
				A_print("$PBX_AlreadySelected");
				cleanmodetokens();
				return;
			}
			
			if(goLaser)
			{
				DEUM_SetMode(LaserMode);
				A_print("$PBX_DemonExt_Laser");
			}
			
			if(goIncenartor)
			{
				DEUM_SetMode(IncinerationMode);
				A_print("$PBX_DemonExt_Incin");
			}
			
			if(goLightning)
			{
				DEUM_SetMode(LightningMode);
				A_print("$PBX_DemonExt_Lightning");
			}

			A_StartSound("unmaker/switch",CHAN_WEAPON);
			cleanmodetokens();
			A_Overlay(specialOverlay,"WeaponSpecialLayer");
		}
	}

	const LaserMode = 0;
	const IncinerationMode = 1;
	const LightningMode = 2;

	action void DEUM_SetMode(int set = 0){invoker.ExterminatorMode = set;}

	action void cleanmodetokens()
	{
		A_TakeInventory("UMDE_Select_LaserMode",1);
		A_TakeInventory("UMDE_Select_IncinerationMode",1);
		A_TakeInventory("UMDE_Select_LightningMode",1);
	}

	action void DemonExtCrosshair()
	{
		switch(invoker.ExterminatorMode)
		{
			case 0 : PB_HandleCrosshair(26); break;
			case 1 : PB_HandleCrosshair(14); break;
			case 2 : PB_HandleCrosshair(90); break;
			default : PB_HandleCrosshair(0); break;
		}
	}
	
	action state UNM_WeaponReady()
	{
		WeaponSpecialCheck();
		DemonExtCrosshair();
		A_TakeInventory("CantDoAction",0);
		if(!invoker.ExterminatorWeaponSpecial){
			A_DoPBWeaponAction(0);
		}
		return ResolveState(NULL);
	}

	action void UNM_Add_level()
	{
		invoker.U_level++;
		if(invoker.U_level > 2)
			invoker.U_level = 0;
		
	}
	
	static const int UN_LevelOfs[] = {
		5,10,15
	};
	
	
	action void UNM_FireBeams(int ofs = 0)
	{
		/*
		ofs = clamp(ofs,0,PB_DemonExt.UN_LevelOfs.size()-1);	//make sure it doesnt go out of bounds
		int lv = PB_DemonExt.UN_LevelOfs[ofs];
		for(int i = -lv; i <= lv; i += lv)
			A_FireProjectile("UNMK_Projectile",i,0);
			*/
		int lv = Player.ReFire%3*5+5;
		for(int i = -lv; i <= lv; i += lv) A_FireProjectile("UNMK_Projectile",i,0);
		//A_RailAttack(54, 0, 0, "none", "red", RGF_SILENT | RGF_FULLBRIGHT | RGF_EXPLICITANGLE, 0, "Unmaker64Puff", i, 0, 0, 0, 5, 2, "UnmakerLaser64Spark", -1,270,1);
	}
	//A_FireProjectile("UNMK_StormSpray",0,0);

	action void UNM_FireLasers()
	{
		int lv = Player.ReFire%3*5+5;
		for(int i = -lv; i <= lv; i += lv) 
			A_RailAttack(
				LASER_DAMAGE, 0, 0, 
				"", "red", 
				RGF_SILENT | RGF_FULLBRIGHT | RGF_EXPLICITANGLE | RGF_NORANDOMPUFFZ, 
				0, "Unmaker64Puff", i, 0, 0, 0, 5, 2, "UnmakerLaser64Spark", -1,270,1);
	}
	
	action void UNM_FireStorm(int stormLayers = 2, int distanceIntervals = 40)
	{
		//A_SpawnItemEx("UNMK_StormSpray", 0, 0, 0, 0, 0, 0, 0, SXF_SETTARGET|SXF_ORIGINATOR, 0);
		for(int i = 0; i < stormLayers; i++){
			actor a = A_FireProjectile("UNMK_StormSpray",0,0);
			if(a){
				if(i == 0){a.bFALLING = true;}
				//a.target = self;
				//a.A_Warp(AAPTR_TARGET,10*i);
				a.Warp( a , distanceIntervals * i );
			}
			
		}
	}
	
}