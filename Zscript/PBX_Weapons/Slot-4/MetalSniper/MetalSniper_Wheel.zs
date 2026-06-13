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
		PB_SpecialWheel_Mode MS_Laser = new ("PB_SpecialWheel_Mode");
		if(weap.laserActive) {
			MS_Laser.Alias = "$PBX_LaserOff";
			MS_Laser.img = "graphics/WeaponWheel/MetalSniper/LaserOff.png";
		}
		else {
			MS_Laser.Alias = "$PBX_LaserON";
			MS_Laser.img = "graphics/WeaponWheel/MetalSniper/LaserOn.png";
		}
		MS_Laser.tokentogive = "MS_Select_Laser";
		MS_Laser.scalex = iconscale.x;
		MS_Laser.scaley = iconscale.y;
		spw.push(MS_Laser);

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

Class MS_Zoomed_Wheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 4;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		super.GetSpecials(spw,requester);

		vector2 iconScale = (1.0, 1.0);
		let weap = PBX_MetalSniper(requester.player.readyweapon);

		// Laser
		PB_SpecialWheel_Mode MS_Laser = new ("PB_SpecialWheel_Mode");
		if(weap.laserActive) {
			MS_Laser.Alias = "$PBX_LaserOff";
			MS_Laser.img = "graphics/WeaponWheel/MetalSniper/LaserOff.png";
		}
		else {
			MS_Laser.Alias = "$PBX_LaserON";
			MS_Laser.img = "graphics/WeaponWheel/MetalSniper/LaserOn.png";
		}
		MS_Laser.tokentogive = "MS_Select_Laser";
		MS_Laser.scalex = iconscale.x;
		MS_Laser.scaley = iconscale.y;
		spw.push(MS_Laser);

		// Scope Mode
		PB_SpecialWheel_Mode MS_goScope = new ("PB_SpecialWheel_Mode");
		MS_goScope.img = "graphics/WeaponWheel/ScopeMode.png";
		MS_goScope.Alias = "$PBX_GoScope";
		MS_goScope.tokentogive = "MS_Select_ToggleScope";
		MS_goScope.scalex = WHEEL_SCOPE_SCALE;
		MS_goScope.scaley = WHEEL_SCOPE_SCALE;
		spw.push(MS_goScope);

		// Zoom Strength
		PB_SpecialWheel_Mode MS_goZoom = new ("PB_SpecialWheel_Mode");
		MS_goZoom.img = "graphics/WeaponWheel/ChangeZoom.png";
		if(weap.zoomstrength == weap.HIGHZOOM) MS_goZoom.Alias = "$PBX_Zoom40";
		else MS_goZoom.Alias = "$PBX_Zoom70";
		MS_goZoom.tokentogive = "MS_Select_ToggleZoom";
		MS_goZoom.scalex = WHEEL_ZOOM_SCALE;
		MS_goZoom.scaley = WHEEL_ZOOM_SCALE;
		spw.push(MS_goZoom);
		
		// NVG
		PB_SpecialWheel_Mode MS_goNVG = new ("PB_SpecialWheel_Mode");
		MS_goNVG.img = "GRAPHICS/HiResPickups/Powerups/VISR1.png";
		if(weap.nvgActive) MS_goNVG.Alias = "$PBX_nvgOffWW";
		else MS_goNVG.Alias = "$PBX_nvgOnWW";
		MS_goNVG.tokentogive = "MS_Select_ToggleNVG";
		MS_goNVG.scalex = WHEEL_NVG_SCALE;
		MS_goNVG.scaley = WHEEL_NVG_SCALE;
		spw.push(MS_goNVG);
	}
}