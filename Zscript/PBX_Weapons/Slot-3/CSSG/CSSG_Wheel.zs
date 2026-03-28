//
//	the info object that holds the data for the wheel handler to read
//
Class CSSGWeaponWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		// int sp = 4;	//total amount of specials available for this weapon
		
		// //basically, add one if the requester has the respective item
		// if(requester.FindInventory("DragonBreathUpgrade"))
		// 	sp++;
		// if(requester.FindInventory("ExplosiveUpgrade"))
		// 	sp++;
		// if(requester.FindInventory("WhitePhosphorusUpgrade"))
		// 	sp++;
		// if(requester.FindInventory("TripleDoomUpgrade"))
		// 	sp++;
		// if(requester.FindInventory("DanmakuUpgrade")) 
		// 	sp++;
		
		// return sp;
		return 9;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		super.GetSpecials(spw,requester);
		vector2 iconScale = (0.7, 0.7);
		
		PB_SpecialWheel_Mode CSSG_BuckShot = new ("PB_SpecialWheel_Mode");
		CSSG_BuckShot.img = "graphics/Weapon Wheel/CSSG/SG_Buck.png";
		CSSG_BuckShot.Alias = "$PBX_CM_BUCKLD";
		CSSG_BuckShot.tokentogive = "SelectCSG_Buckshot";
		CSSG_BuckShot.scalex = iconscale.x;
		CSSG_BuckShot.scaley = iconscale.y;
		
		
		PB_SpecialWheel_Mode CSSG_Slug = new ("PB_SpecialWheel_Mode");
		CSSG_Slug.img = "graphics/Weapon Wheel/CSSG/SG_Slug.png";
		CSSG_Slug.Alias = "$PBX_CM_SLUGLD";
		CSSG_Slug.tokentogive = "SelectCSG_Slugshot";
		CSSG_Slug.scalex = iconscale.x;
		CSSG_Slug.scaley = iconscale.y;
		
		
		
		PB_SpecialWheel_Mode CSSG_Flechette = new ("PB_SpecialWheel_Mode");
		CSSG_Flechette.img = "graphics/Weapon Wheel/CSSG/SG_Flechette.png";
		CSSG_Flechette.Alias = "$PBX_CM_FLCHLD";
		CSSG_Flechette.tokentogive = "SelectCSG_Flechette";
		CSSG_Flechette.scalex = iconscale.x;
		CSSG_Flechette.scaley = iconscale.y;
		

		PB_SpecialWheel_Mode CSSG_Flak = new ("PB_SpecialWheel_Mode");
		CSSG_Flak.img = "graphics/Weapon Wheel/CSSG/SG_Flak.png";
		CSSG_Flak.Alias = "$PBX_CM_FLAKLD";
		CSSG_Flak.tokentogive = "SelectCSG_Flak";
		CSSG_Flak.scalex = iconscale.x;
		CSSG_Flak.scaley = iconscale.y;

		spw.Push(CSSG_BuckShot);
		spw.Push(CSSG_Slug);
		spw.Push(CSSG_Flechette);
		spw.Push(CSSG_Flak);

		if(requester.FindInventory("DragonBreathUpgrade") || pbx_backpack_filter & DisablePBX_CSSGUpgrades) 
		{
			PB_SpecialWheel_Mode CSSG_DragonBreath = new ("PB_SpecialWheel_Mode");
			CSSG_DragonBreath.img = "graphics/Weapon Wheel/CSSG/SG_DB.png";
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

		if(requester.FindInventory("ExplosiveUpgrade") || pbx_backpack_filter & DisablePBX_CSSGUpgrades) 
		{
			PB_SpecialWheel_Mode CSSG_Explosive = new ("PB_SpecialWheel_Mode");
			CSSG_Explosive.img = "graphics/Weapon Wheel/CSSG/SG_Explosive.png";
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
		
		
		if(requester.FindInventory("WhitePhosphorusUpgrade") || pbx_backpack_filter & DisablePBX_CSSGUpgrades) 
		{
			PB_SpecialWheel_Mode CSSG_WPhosphorus = new ("PB_SpecialWheel_Mode");
			CSSG_WPhosphorus.img = "graphics/Weapon Wheel/CSSG/SG_WPhosphorus.png";
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
		
		if(requester.FindInventory("TripleDoomUpgrade") || pbx_backpack_filter & DisablePBX_CSSGUpgrades) 
		{
			PB_SpecialWheel_Mode CSSG_Doom = new ("PB_SpecialWheel_Mode");
			CSSG_Doom.img = "graphics/Weapon Wheel/CSSG/SG_Doom.png";
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
		
		if(requester.FindInventory("DanmakuUpgrade") || pbx_backpack_filter & DisablePBX_CSSGUpgrades) 
		{
			PB_SpecialWheel_Mode CSSG_Danmaku = new ("PB_SpecialWheel_Mode");
			CSSG_Danmaku.img = "graphics/Weapon Wheel/CSSG/SG_Danmaku.png";
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
		
	}
}
