Class MetalSniperWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 2;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		super.GetSpecials(spw,requester);
		
		PB_SpecialWheel_Mode MS_AimMode = new ("PB_SpecialWheel_Mode");
		MS_AimMode.img = "graphics/Weapon Wheel/MetalSniper/ADSAlt.png";
		MS_AimMode.Alias = "$PBX_MetalSniper_AimMode";
		MS_AimMode.tokentogive = "MS_Select_AimMode";
		MS_AimMode.scalex = 0.6;
		MS_AimMode.scaley = 0.6;
		spw.push(MS_AimMode);
		
		PB_SpecialWheel_Mode MS_GrenMode = new ("PB_SpecialWheel_Mode");
		MS_GrenMode.img = "graphics/Weapon Wheel/MetalSniper/GrenadeAlt.png";
		MS_GrenMode.Alias = "$PBX_MetalSniper_GrenMode";
		MS_GrenMode.tokentogive = "MS_Select_GrenMode";
		MS_GrenMode.scalex = 0.6;
		MS_GrenMode.scaley = 0.6;
		spw.push(MS_GrenMode);
		
	}
}