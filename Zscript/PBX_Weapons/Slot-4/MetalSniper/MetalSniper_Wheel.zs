Class MetalSniperWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 3;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		super.GetSpecials(spw,requester);

		vector2 iconScale = (0.7, 0.7);

		PB_SpecialWheel_Mode MS_AimMode = new ("PB_SpecialWheel_Mode");
		MS_AimMode.img = "graphics/WeaponWheel/MetalSniper/ADSAlt.png";
		MS_AimMode.Alias = "$PBX_MetalSniper_AimMode";
		MS_AimMode.tokentogive = "MS_Select_AimMode";
		MS_AimMode.scalex = iconscale.x;
		MS_AimMode.scaley = iconscale.y;
		spw.push(MS_AimMode);
		
		PB_SpecialWheel_Mode MS_GrenMode = new ("PB_SpecialWheel_Mode");
		MS_GrenMode.img = "graphics/WeaponWheel/MetalSniper/GrenadeAlt.png";
		MS_GrenMode.Alias = "$PBX_MetalSniper_GrenMode";
		MS_GrenMode.tokentogive = "MS_Select_GrenMode";
		MS_GrenMode.scalex = iconscale.x;
		MS_GrenMode.scaley = iconscale.y;
		spw.push(MS_GrenMode);

		bool disabled;
		let disableUpgrade = Cvar.GetCvar('PBXWeapons_backpack_filter', requester.player);
		if(disableUpgrade)
			disabled = disableUpgrade.getint() & DisablePBX_MetalSniperUpgrade;

		let weap = PBX_MetalSniper(requester.player.readyweapon);
		
		iconScale = (1.0, 1.0);
		if(requester.FindInventory("MetalSniperUpgraded") || disabled) 
		{
			if(weap && weap.resonanceAmmoLoaded)
			{
				PB_SpecialWheel_Mode MS_Resonance = new ("PB_SpecialWheel_Mode");
				MS_Resonance.img = "graphics/WeaponWheel/MetalSniper/StandardAlt.png";
				MS_Resonance.Alias = "$PBX_MetalSniper_Standard";
				MS_Resonance.tokentogive = "MS_Select_Resonance";
				MS_Resonance.scalex = iconscale.x;
				MS_Resonance.scaley = iconscale.y;
				
				spw.Push(MS_Resonance);
			}
			else
			{
				PB_SpecialWheel_Mode MS_StandardAmmo = new ("PB_SpecialWheel_Mode");
				MS_StandardAmmo.img = "graphics/WeaponWheel/MetalSniper/ResonanceAlt.png";
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
			MS_Resonance_No.img = "graphics/WeaponWheel/MetalSniper/ResonanceNo.png";
			MS_Resonance_No.Alias = "$PBX_AmmoNotAvailable";
			MS_Resonance_No.tokentogive = "MS_Select_NO";
			MS_Resonance_No.scalex = iconscale.x;
			MS_Resonance_No.scaley = iconscale.y;
			
			spw.Push(MS_Resonance_No);
		}
		
	}
}