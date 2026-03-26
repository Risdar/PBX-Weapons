Class MetalSniperWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 3;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		super.GetSpecials(spw,requester);

		let weap = PBX_MetalSniper(requester.player.readyweapon);
		vector2 iconScale = (0.7, 0.7);

		PB_SpecialWheel_Mode MS_AimMode = new ("PB_SpecialWheel_Mode");
		MS_AimMode.img = "graphics/Weapon Wheel/MetalSniper/ADSAlt.png";
		MS_AimMode.Alias = "$PBX_MetalSniper_AimMode";
		MS_AimMode.tokentogive = "MS_Select_AimMode";
		MS_AimMode.scalex = iconscale.x;
		MS_AimMode.scaley = iconscale.y;
		spw.push(MS_AimMode);
		
		PB_SpecialWheel_Mode MS_GrenMode = new ("PB_SpecialWheel_Mode");
		MS_GrenMode.img = "graphics/Weapon Wheel/MetalSniper/GrenadeAlt.png";
		MS_GrenMode.Alias = "$PBX_MetalSniper_GrenMode";
		MS_GrenMode.tokentogive = "MS_Select_GrenMode";
		MS_GrenMode.scalex = iconscale.x;
		MS_GrenMode.scaley = iconscale.y;
		spw.push(MS_GrenMode);

		if(requester.FindInventory("MetalSniperUpgraded") || pbx_backpack_filter & DisablePBX_MetalSniperUpgrade) 
		{
			if(weap && weap.resonanceAmmoLoaded)
			{
				PB_SpecialWheel_Mode MS_Resonance = new ("PB_SpecialWheel_Mode");
				MS_Resonance.img = "graphics/Weapon Wheel/MetalSniper/StandardAlt.png";
				MS_Resonance.Alias = "$PBX_MetalSniper_Standard";
				MS_Resonance.tokentogive = "MS_Select_Resonance";
				MS_Resonance.scalex = iconscale.x;
				MS_Resonance.scaley = iconscale.y;
				
				spw.Push(MS_Resonance);
			}
			else
			{
				PB_SpecialWheel_Mode MS_StandardAmmo = new ("PB_SpecialWheel_Mode");
				MS_StandardAmmo.img = "graphics/Weapon Wheel/MetalSniper/ResonanceAlt.png";
				MS_StandardAmmo.Alias = "$PBX_MetalSniper_Resonance";
				MS_StandardAmmo.tokentogive = "MS_Select_Resonance";
				MS_StandardAmmo.scalex = iconscale.x;
				MS_StandardAmmo.scaley = iconscale.y;
				
				spw.Push(MS_StandardAmmo);
			}
		} 
		else 
		{
			PB_SpecialWheel_Mode MS_Resonance_No = new ("PB_SpecialWheel_Mode");
			MS_Resonance_No.img = "graphics/Weapon Wheel/MetalSniper/ResonanceNo.png";
			MS_Resonance_No.Alias = "$PBX_AmmoNotAvailable";
			MS_Resonance_No.tokentogive = "MS_Select_NO";
			MS_Resonance_No.scalex = iconscale.x;
			MS_Resonance_No.scaley = iconscale.y;
			
			spw.Push(MS_Resonance_No);
		}
		
	}
}