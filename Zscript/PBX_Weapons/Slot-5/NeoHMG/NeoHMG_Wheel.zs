Class HMGWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 2;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		super.GetSpecials(spw,requester);
		
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