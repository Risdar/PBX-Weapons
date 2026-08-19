Class CrossbowBallistaWheel : wheelinfocontainer
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
		
		vector2 iconScale = (0.7, 0.7);

		PB_SpecialWheel_Mode Weapon_Close = new ("PB_SpecialWheel_Mode");
		Weapon_Close.img = "graphics/WeaponWheel/CloseMenu.png";
		Weapon_Close.Alias = "$PBX_CloseMenu";
		Weapon_Close.tokentogive = "PBX_CloseWheel";
		Weapon_Close.scalex = WHEEL_CLOSEMENU_SCALE;
		Weapon_Close.scaley = WHEEL_CLOSEMENU_SCALE;
		spw.push(Weapon_Close);

		PB_SpecialWheel_Mode CB_Normal = new ("PB_SpecialWheel_Mode");
		CB_Normal.img = "graphics/WeaponWheel/ProsurvBallista/StandardBallista.png";
		CB_Normal.Alias = "$PBX_Crossbow_Standard_WW";
		CB_Normal.tokentogive = "CB_Select_NormalMode";
		CB_Normal.scalex = iconscale.x;
		CB_Normal.scaley = iconscale.y;
		spw.push(CB_Normal);

		PB_SpecialWheel_Mode CB_Explosive = new ("PB_SpecialWheel_Mode");
		CB_Explosive.img = "graphics/WeaponWheel/ProsurvBallista/ExplosiveBallista.png";
		CB_Explosive.Alias = "$PBX_Crossbow_Explosive_WW";
		CB_Explosive.tokentogive = "CB_Select_ExplosiveMode";
		CB_Explosive.scalex = iconscale.x;
		CB_Explosive.scaley = iconscale.y;
		spw.push(CB_Explosive);
		
        bool disabled;
		let disableUpgrade = Cvar.GetCvar('PBXWeapons_backpack_filter', requester.player);
		if(disableUpgrade)
			disabled = disableUpgrade.getint() & DisablePBX_CrossbowBallistaUpgrade;

		if(requester.FindInventory("Crossbow_Upgraded") || disabled)
        {
            PB_SpecialWheel_Mode CB_Demonic = new ("PB_SpecialWheel_Mode");
            CB_Demonic.img = "graphics/WeaponWheel/ProsurvBallista/DemonicBallista.png";
            CB_Demonic.Alias = "$PBX_Crossbow_Demonic_WW";
            CB_Demonic.tokentogive = "CB_Select_DemonicMode";
            CB_Demonic.scalex = iconscale.x;
            CB_Demonic.scaley = iconscale.y;
            spw.push(CB_Demonic);

			PB_SpecialWheel_Mode CB_Shock = new ("PB_SpecialWheel_Mode");
            CB_Shock.img = "graphics/WeaponWheel/ProsurvBallista/ShockBallista.png";
            CB_Shock.Alias = "$PBX_Crossbow_Shock_WW";
            CB_Shock.tokentogive = "CB_Select_ShockMode";
            CB_Shock.scalex = iconscale.x;
            CB_Shock.scaley = iconscale.y;
            spw.push(CB_Shock);
        } 
		else
        {
            PB_SpecialWheel_Mode CB_DemonicNo = new ("PB_SpecialWheel_Mode");
			CB_DemonicNo.img = "graphics/WeaponWheel/ProsurvBallista/DemonicBallistaNo.png";
			CB_DemonicNo.Alias = "$PBX_AmmoNotAvailable";
			CB_DemonicNo.tokentogive = "CB_Select_NO";
			CB_DemonicNo.scalex = iconscale.x;
			CB_DemonicNo.scaley = iconscale.y;
			spw.Push(CB_DemonicNo);

			PB_SpecialWheel_Mode CB_ShockNo = new ("PB_SpecialWheel_Mode");
			CB_ShockNo.img = "graphics/WeaponWheel/ProsurvBallista/DemonicBallistaNo.png";
			CB_ShockNo.Alias = "$PBX_AmmoNotAvailable";
			CB_ShockNo.tokentogive = "CB_Select_NO";
			CB_ShockNo.scalex = iconscale.x;
			CB_ShockNo.scaley = iconscale.y;
			spw.Push(CB_ShockNo);
        }
		
	}
}