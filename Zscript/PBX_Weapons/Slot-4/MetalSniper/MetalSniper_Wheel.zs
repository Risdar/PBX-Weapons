Class MetalSniperWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 4;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		if(!spw || !requester)
			return;
			
		let weap = PBX_MetalSniper(requester.player.readyweapon);
        if(!weap) return;

		super.GetSpecials(spw,requester);

		vector2 iconScale = (0.7, 0.7);

		PB_SpecialWheel_Mode Weapon_Close = new ("PB_SpecialWheel_Mode");
		Weapon_Close.img = "graphics/WeaponWheel/CloseMenu.png";
		Weapon_Close.Alias = "$PBX_CloseMenu";
		Weapon_Close.tokentogive = "PBX_CloseWheel";
		Weapon_Close.scalex = WHEEL_CLOSEMENU_SCALE;
		Weapon_Close.scaley = WHEEL_CLOSEMENU_SCALE;
		spw.push(Weapon_Close);

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

		bool disabled = PBXWeapons_backpack_filter & DisablePBX_MetalSniperUpgrade;

		iconScale = (1.0, 1.0);

		PB_SpecialWheel_Mode MS_Laser = new ("PB_SpecialWheel_Mode");
		if(weap.mLaserSightActivated) {
			MS_Laser.Alias = "$PBX_LaserOff";
			MS_Laser.img = "graphics/WeaponWheel/MetalSniper/LaserOff.png";
		}
		else {
			MS_Laser.Alias = "$PBX_LaserON";
			MS_Laser.img = "graphics/WeaponWheel/MetalSniper/LaserOn.png";
		}
		MS_Laser.tokentogive = "PBX_Toggle_Laser";
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
		if(!spw || !requester)
			return;
			
		let weap = PBX_MetalSniper(requester.player.readyweapon);
        if(!weap) return;

		super.GetSpecials(spw,requester);

		vector2 iconScale = (1.0, 1.0);

		PB_SpecialWheel_Mode Weapon_Close = new ("PB_SpecialWheel_Mode");
		Weapon_Close.img = "graphics/WeaponWheel/CloseMenu.png";
		Weapon_Close.Alias = "$PBX_CloseMenu";
		Weapon_Close.tokentogive = "PBX_CloseWheel";
		Weapon_Close.scalex = WHEEL_CLOSEMENU_SCALE;
		Weapon_Close.scaley = WHEEL_CLOSEMENU_SCALE;
		spw.push(Weapon_Close);

		// Laser
		PB_SpecialWheel_Mode MS_Laser = new ("PB_SpecialWheel_Mode");
		if(weap.mLaserSightActivated) {
			MS_Laser.Alias = "$PBX_LaserOff";
			MS_Laser.img = "graphics/WeaponWheel/MetalSniper/LaserOff.png";
		}
		else {
			MS_Laser.Alias = "$PBX_LaserON";
			MS_Laser.img = "graphics/WeaponWheel/MetalSniper/LaserOn.png";
		}
		MS_Laser.tokentogive = "PBX_Toggle_Laser";
		MS_Laser.scalex = iconscale.x;
		MS_Laser.scaley = iconscale.y;
		spw.push(MS_Laser);

		// Scope Mode
		PB_SpecialWheel_Mode MS_goScope = new ("PB_SpecialWheel_Mode");
		MS_goScope.img = "graphics/WeaponWheel/ScopeMode.png";
		MS_goScope.Alias = "$PBX_GoScope";
		MS_goScope.tokentogive = "PBX_Toggle_Scope";
		MS_goScope.scalex = WHEEL_SCOPE_SCALE;
		MS_goScope.scaley = WHEEL_SCOPE_SCALE;
		spw.push(MS_goScope);


		// NVG
		PB_SpecialWheel_Mode MS_goNVG = new ("PB_SpecialWheel_Mode");
		MS_goNVG.img = "GRAPHICS/HiResPickups/Powerups/VISR1.png";
		if(weap.mNightVisionActivated) 
			MS_goNVG.Alias = "$PBX_nvgOffWW";
		else 
			MS_goNVG.Alias = "$PBX_nvgOnWW";
		MS_goNVG.tokentogive = "PBX_Toggle_NVG";
		MS_goNVG.scalex = WHEEL_NVG_SCALE;
		MS_goNVG.scaley = WHEEL_NVG_SCALE;
		spw.push(MS_goNVG);
	}
}