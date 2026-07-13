Class CrossbowBallistaWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 3;
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
		CB_Normal.Alias = "$PBX_Crossbow_Standard";
		CB_Normal.tokentogive = "CB_Select_NormalMode";
		CB_Normal.scalex = iconscale.x;
		CB_Normal.scaley = iconscale.y;
		spw.push(CB_Normal);
		
        bool disabled;
		let disableUpgrade = Cvar.GetCvar('PBXWeapons_backpack_filter', requester.player);
		if(disableUpgrade)
			disabled = disableUpgrade.getint() & DisablePBX_CrossbowBallistaUpgrade;

		if(requester.FindInventory("Crossbow_Upgraded") || disabled)
        {
            PB_SpecialWheel_Mode CB_Demonic = new ("PB_SpecialWheel_Mode");
            CB_Demonic.img = "graphics/WeaponWheel/ProsurvBallista/DemonicBallista.png";
            CB_Demonic.Alias = "$PBX_Crossbow_Demonic";
            CB_Demonic.tokentogive = "CB_Select_DemonicMode";
            CB_Demonic.scalex = iconscale.x;
            CB_Demonic.scaley = iconscale.y;
            spw.push(CB_Demonic);
        } 
		else
        {
            PB_SpecialWheel_Mode CB_No = new ("PB_SpecialWheel_Mode");
			CB_No.img = "graphics/WeaponWheel/ProsurvBallista/DemonicBallistaNo.png";
			CB_No.Alias = "$PBX_AmmoNotAvailable";
			CB_No.tokentogive = "CB_Select_NO";
			CB_No.scalex = iconscale.x;
			CB_No.scaley = iconscale.y;
			spw.Push(CB_No);
        }
		
	}
}