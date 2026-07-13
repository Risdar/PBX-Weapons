Class HMGWheel : wheelinfocontainer
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

		PB_SpecialWheel_Mode Weapon_Close = new ("PB_SpecialWheel_Mode");
		Weapon_Close.img = "graphics/WeaponWheel/CloseMenu.png";
		Weapon_Close.Alias = "$PBX_CloseMenu";
		Weapon_Close.tokentogive = "PBX_CloseWheel";
		Weapon_Close.scalex = WHEEL_CLOSEMENU_SCALE;
		Weapon_Close.scaley = WHEEL_CLOSEMENU_SCALE;
		spw.push(Weapon_Close);
		
		PB_SpecialWheel_Mode HMG_Heated = new ("PB_SpecialWheel_Mode");
		HMG_Heated.img = "graphics/WeaponWheel/NeoHMG/heatedrounds.png";
		HMG_Heated.Alias = "$PBX_NeoHMG_Heated";
		HMG_Heated.tokentogive = "HMG_Select_Heated";
		HMG_Heated.scalex = 1.2;
		HMG_Heated.scaley = 1.2;
		spw.push(HMG_Heated);
		
		PB_SpecialWheel_Mode HMG_Charged = new ("PB_SpecialWheel_Mode");
		HMG_Charged.img = "graphics/WeaponWheel/NeoHMG/chargedrounds.png";
		HMG_Charged.Alias = "$PBX_NeoHMG_Charged";
		HMG_Charged.tokentogive = "HMG_Select_Charged";
		HMG_Charged.scalex = 1.2;
		HMG_Charged.scaley = 1.2;
		spw.push(HMG_Charged);
		
	}
}