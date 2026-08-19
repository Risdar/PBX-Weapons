Class CSSGWeaponWheelPage1 : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 4;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		if(!spw || !requester)
			return;
			
		super.GetSpecials(spw,requester);

		vector2 iconScale = (1.0, 1.0);

		PB_SpecialWheel_Mode Weapon_Close = new ("PB_SpecialWheel_Mode");
		Weapon_Close.img = "graphics/WeaponWheel/CloseMenu.png";
		Weapon_Close.Alias = "$PBX_CloseMenu";
		Weapon_Close.tokentogive = "PBX_CloseWheel";
		Weapon_Close.scalex = WHEEL_CLOSEMENU_SCALE;
		Weapon_Close.scaley = WHEEL_CLOSEMENU_SCALE;
		spw.Push(Weapon_Close);

		PB_SpecialWheel_Mode CSSG_Switch = new ("PB_SpecialWheel_Mode");
		CSSG_Switch.img = "graphics/WeaponWheel/CSSG/SG_Buck.png";
		CSSG_Switch.Alias = "$PBX_CSSG_PAGE2_WW";
		CSSG_Switch.tokentogive = "SelectCSG_SwitchMenu";
		CSSG_Switch.scalex = iconscale.x/2;
		CSSG_Switch.scaley = iconscale.y/2;
		spw.Push(CSSG_Switch);

		PB_SpecialWheel_Mode CSSG_SingleAlt = new ("PB_SpecialWheel_Mode");
		CSSG_SingleAlt.img = "graphics/WeaponWheel/CSSG/SG_SingleFire.png";
		CSSG_SingleAlt.Alias = "$PBX_CSSG_SINGLE";
		CSSG_SingleAlt.tokentogive = "SelectCSG_SwitchSingle";
		CSSG_SingleAlt.scalex = iconscale.x;
		CSSG_SingleAlt.scaley = iconscale.y;
		spw.Push(CSSG_SingleAlt);

		PB_SpecialWheel_Mode CSSG_HookAlt = new ("PB_SpecialWheel_Mode");
		CSSG_HookAlt.img = "graphics/WeaponWheel/CSSG/SG_Meathook.png";
		CSSG_HookAlt.Alias = "$PBX_CSSG_HOOK";
		CSSG_HookAlt.tokentogive = "SelectCSG_SwitchHook";
		CSSG_HookAlt.scalex = iconscale.x;
		CSSG_HookAlt.scaley = iconscale.y;
		spw.Push(CSSG_HookAlt);

	}
}

Class CSSGWeaponWheelPage2 : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 12;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		if(!spw || !requester)
			return;

		let cssg = PBX_CSSG(requester.player.readyweapon);
        if(!cssg) return;
			
		super.GetSpecials(spw,requester);
		
		vector2 iconScale = (0.5, 0.5);

		PB_SpecialWheel_Mode Weapon_Close = new ("PB_SpecialWheel_Mode");
		Weapon_Close.img = "graphics/WeaponWheel/CloseMenu.png";
		Weapon_Close.Alias = "$PBX_CloseMenu";
		Weapon_Close.tokentogive = "PBX_CloseWheel";
		Weapon_Close.scalex = WHEEL_CLOSEMENU_SCALE;
		Weapon_Close.scaley = WHEEL_CLOSEMENU_SCALE;
		spw.Push(Weapon_Close);

		PB_SpecialWheel_Mode CSSG_Switch = new ("PB_SpecialWheel_Mode");
		CSSG_Switch.img = "graphics/WeaponWheel/CSSG/SG_Page.png";
		CSSG_Switch.Alias = "$PBX_CSSG_PAGE1_WW";
		CSSG_Switch.tokentogive = "SelectCSG_SwitchMenu";
		CSSG_Switch.scalex = iconscale.x;
		CSSG_Switch.scaley = iconscale.y;
		spw.Push(CSSG_Switch);
		
		PB_SpecialWheel_Mode CSSG_BuckShot = new ("PB_SpecialWheel_Mode");
		CSSG_BuckShot.img = "graphics/WeaponWheel/CSSG/SG_Buck.png";
		CSSG_BuckShot.Alias = "$PBX_CM_BUCKLD";
		CSSG_BuckShot.tokentogive = "SelectCSG_Buckshot";
		CSSG_BuckShot.scalex = iconscale.x;
		CSSG_BuckShot.scaley = iconscale.y;
		
		PB_SpecialWheel_Mode CSSG_Slug = new ("PB_SpecialWheel_Mode");
		CSSG_Slug.img = "graphics/WeaponWheel/CSSG/SG_Slug.png";
		CSSG_Slug.Alias = "$PBX_CM_SLUGLD";
		CSSG_Slug.tokentogive = "SelectCSG_Slugshot";
		CSSG_Slug.scalex = iconscale.x;
		CSSG_Slug.scaley = iconscale.y;
		
		PB_SpecialWheel_Mode CSSG_Flechette = new ("PB_SpecialWheel_Mode");
		CSSG_Flechette.img = "graphics/WeaponWheel/CSSG/SG_Flechette.png";
		CSSG_Flechette.Alias = "$PBX_CM_FLCHLD";
		CSSG_Flechette.tokentogive = "SelectCSG_Flechette";
		CSSG_Flechette.scalex = iconscale.x;
		CSSG_Flechette.scaley = iconscale.y;
		

		PB_SpecialWheel_Mode CSSG_Flak = new ("PB_SpecialWheel_Mode");
		CSSG_Flak.img = "graphics/WeaponWheel/CSSG/SG_Flak.png";
		CSSG_Flak.Alias = "$PBX_CM_FLAKLD";
		CSSG_Flak.tokentogive = "SelectCSG_Flak";
		CSSG_Flak.scalex = iconscale.x;
		CSSG_Flak.scaley = iconscale.y;

		spw.Push(CSSG_BuckShot);
		spw.Push(CSSG_Slug);
		spw.Push(CSSG_Flechette);
		spw.Push(CSSG_Flak);

		bool disabled;
		let disableUpgrade = Cvar.GetCvar('PBXWeapons_backpack_filter', requester.player);
		if(disableUpgrade)
			disabled = disableUpgrade.getint() & DisablePBX_CSSGUpgrades;

		if(requester.FindInventory("DragonBreathUpgrade") || disabled) 
		{
			PB_SpecialWheel_Mode CSSG_DragonBreath = new ("PB_SpecialWheel_Mode");
			CSSG_DragonBreath.img = "graphics/WeaponWheel/CSSG/SG_DB.png";
			CSSG_DragonBreath.Alias = "$PBX_CM_DGBTLD";
			CSSG_DragonBreath.tokentogive = "SelectCSG_Dragonsbreath";
			CSSG_DragonBreath.scalex = iconscale.x;
			CSSG_DragonBreath.scaley = iconscale.y;
			
			spw.Push(CSSG_DragonBreath);
		} else 
		{
			PB_SpecialWheel_Mode CSSG_DragonBreath_No = new ("PB_SpecialWheel_Mode");
			CSSG_DragonBreath_No.img = "graphics/pywheel/SG_NO.png";
			CSSG_DragonBreath_No.Alias = "$PBX_AmmoNotAvailable";
			CSSG_DragonBreath_No.tokentogive = "SelectCSG_No";
			CSSG_DragonBreath_No.scalex = iconscale.x;
			CSSG_DragonBreath_No.scaley = iconscale.y;
			
			spw.Push(CSSG_DragonBreath_No);
		}

		if(requester.FindInventory("ExplosiveUpgrade") || disabled) 
		{
			PB_SpecialWheel_Mode CSSG_Explosive = new ("PB_SpecialWheel_Mode");
			CSSG_Explosive.img = "graphics/WeaponWheel/CSSG/SG_Explosive.png";
			CSSG_Explosive.Alias = "$PBX_CM_EXPLLD";
			CSSG_Explosive.tokentogive = "SelectCSG_Explosive";
			CSSG_Explosive.scalex = iconscale.x;
			CSSG_Explosive.scaley = iconscale.y;
			spw.Push(CSSG_Explosive);
		} else 
		{
			PB_SpecialWheel_Mode CSSG_Explosive_No = new ("PB_SpecialWheel_Mode");
			CSSG_Explosive_No.img = "graphics/pywheel/SG_NO.png";
			CSSG_Explosive_No.Alias = "$PBX_AmmoNotAvailable";
			CSSG_Explosive_No.tokentogive = "SelectCSG_No";
			CSSG_Explosive_No.scalex = iconscale.x;
			CSSG_Explosive_No.scaley = iconscale.y;
			
			spw.Push(CSSG_Explosive_No);
		}
		
		
		if(requester.FindInventory("WhitePhosphorusUpgrade") || disabled) 
		{
			PB_SpecialWheel_Mode CSSG_WPhosphorus = new ("PB_SpecialWheel_Mode");
			CSSG_WPhosphorus.img = "graphics/WeaponWheel/CSSG/SG_WPhosphorus.png";
			CSSG_WPhosphorus.Alias = "$PBX_CM_WPLOAD";
			CSSG_WPhosphorus.tokentogive = "SelectCSG_WPhosphorus";
			CSSG_WPhosphorus.scalex = iconscale.x;
			CSSG_WPhosphorus.scaley = iconscale.y;
			spw.Push(CSSG_WPhosphorus);
		} else 
		{
			PB_SpecialWheel_Mode CSSG_WPhosphorus_No = new ("PB_SpecialWheel_Mode");
			CSSG_WPhosphorus_No.img = "graphics/pywheel/SG_NO.png";
			CSSG_WPhosphorus_No.Alias = "$PBX_AmmoNotAvailable";
			CSSG_WPhosphorus_No.tokentogive = "SelectCSG_No";
			CSSG_WPhosphorus_No.scalex = iconscale.x;
			CSSG_WPhosphorus_No.scaley = iconscale.y;
			
			spw.Push(CSSG_WPhosphorus_No);
		}
		
		if(requester.FindInventory("TripleDoomUpgrade") || disabled) 
		{
			PB_SpecialWheel_Mode CSSG_Doom = new ("PB_SpecialWheel_Mode");
			CSSG_Doom.img = "graphics/WeaponWheel/CSSG/SG_Doom.png";
			CSSG_Doom.Alias = "$PBX_CM_DOOMLD";
			CSSG_Doom.tokentogive = "SelectCSG_Doom";
			CSSG_Doom.scalex = iconscale.x;
			CSSG_Doom.scaley = iconscale.y;
			spw.Push(CSSG_Doom);
		} else 
		{
			PB_SpecialWheel_Mode CSSG_Doom_No = new ("PB_SpecialWheel_Mode");
			CSSG_Doom_No.img = "graphics/pywheel/SG_NO.png";
			CSSG_Doom_No.Alias = "$PBX_AmmoNotAvailable";
			CSSG_Doom_No.tokentogive = "SelectCSG_No";
			CSSG_Doom_No.scalex = iconscale.x;
			CSSG_Doom_No.scaley = iconscale.y;
			
			spw.Push(CSSG_Doom_No);
		}
		
		if(requester.FindInventory("DanmakuUpgrade") || disabled) 
		{
			PB_SpecialWheel_Mode CSSG_Danmaku = new ("PB_SpecialWheel_Mode");
			CSSG_Danmaku.img = "graphics/WeaponWheel/CSSG/SG_Danmaku.png";
			CSSG_Danmaku.Alias = "$PBX_CM_DNMKULD";
			CSSG_Danmaku.tokentogive = "SelectCSG_Danmaku";
			CSSG_Danmaku.scalex = iconscale.x;
			CSSG_Danmaku.scaley = iconscale.y;
			spw.Push(CSSG_Danmaku);
		} else 
		{
			PB_SpecialWheel_Mode CSSG_Danmaku_No = new ("PB_SpecialWheel_Mode");
			CSSG_Danmaku_No.img = "graphics/pywheel/SG_NO.png";
			CSSG_Danmaku_No.Alias = "$PBX_AmmoNotAvailable";
			CSSG_Danmaku_No.tokentogive = "SelectCSG_No";
			CSSG_Danmaku_No.scalex = iconscale.x;
			CSSG_Danmaku_No.scaley = iconscale.y;
			
			spw.Push(CSSG_Danmaku_No);
		}

		if(requester.FindInventory("SubZeroUpgrade") || disabled) 
		{
			PB_SpecialWheel_Mode CSSG_SubZero = new ("PB_SpecialWheel_Mode");
			CSSG_SubZero.img = "graphics/WeaponWheel/CSSG/SG_SubZ.png";
			CSSG_SubZero.Alias = "$PBX_CM_SUBZRLD";
			CSSG_SubZero.tokentogive = "SelectCSG_SubZero";
			CSSG_SubZero.scalex = iconscale.x;
			CSSG_SubZero.scaley = iconscale.y;
			spw.Push(CSSG_SubZero);
		} else 
		{
			PB_SpecialWheel_Mode CSSG_SubZero_No = new ("PB_SpecialWheel_Mode");
			CSSG_SubZero_No.img = "graphics/pywheel/SG_NO.png";
			CSSG_SubZero_No.Alias = "$PBX_AmmoNotAvailable";
			CSSG_SubZero_No.tokentogive = "SelectCSG_No";
			CSSG_SubZero_No.scalex = iconscale.x;
			CSSG_SubZero_No.scaley = iconscale.y;
			
			spw.Push(CSSG_SubZero_No);
		}
		
	}
}
