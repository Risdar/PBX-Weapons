Class BattleRifleWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		bool hasUpgrade = requester.FindInventory("BattleRifle_Upgraded");
		bool isZooming  = requester.FindInventory("Zoomed");
		bool disabled;
		let disableUpgrade = Cvar.GetCvar('PBXWeapons_backpack_filter', requester.player);
		if(disableUpgrade)
			disabled = disableUpgrade.getint() & DisablePBX_BattleRifleUpgrade;
		// this is so the nvg and scope mode is added when
		// the weapon has been upgraded and is zoomed in
		int result = 3;
		if((hasUpgrade || disabled) && isZooming) result++;
		return result;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		let battleRifle = PBX_BDPBattleRifle(requester.player.readyweapon);
		bool hasUpgrade = requester.FindInventory("BattleRifle_Upgraded");
		bool isZooming  = requester.FindInventory("Zoomed");

		super.GetSpecials(spw,requester);
        
        vector2 scale = (0.9,0.9);
		
		// Toggle Fire
		PB_SpecialWheel_Mode BR_ToggleFire = new ("PB_SpecialWheel_Mode");
		if(battleRifle.isSemiAuto)
		{
			BR_ToggleFire.img 	= "graphics/WeaponWheel/BattleRifle/BR_Burst.png";
			BR_ToggleFire.Alias = "$PB_WHEEL_BURST";
		}
		else
		{
			BR_ToggleFire.img 	= "graphics/WeaponWheel/BattleRifle/BR_Semi.png";
			BR_ToggleFire.Alias = "$PB_WHEEL_SEMI";
		}
		BR_ToggleFire.tokentogive = "BR_Select_FireMode";
		BR_ToggleFire.scalex = scale.x;
		BR_ToggleFire.scaley = scale.y;
		spw.push(BR_ToggleFire);

		// Laser
		PB_SpecialWheel_Mode BR_Laser = new ("PB_SpecialWheel_Mode");
		if(battleRifle.laserActive) {
			BR_Laser.Alias = "$PBX_LaserOff";
			BR_Laser.img = "graphics/WeaponWheel/BattleRifle/BR_LaserOff.png";
		}
		else {
			BR_Laser.Alias = "$PBX_LaserON";
			BR_Laser.img = "graphics/WeaponWheel/BattleRifle/BR_LaserOn.png";
		}
		BR_Laser.tokentogive = "BR_Select_Laser";
		BR_Laser.scalex = scale.x;
		BR_Laser.scaley = scale.y;
		spw.push(BR_Laser);

		// Zoom Strength
		PB_SpecialWheel_Mode BR_Zoom = new ("PB_SpecialWheel_Mode");
		BR_Zoom.img = "graphics/WeaponWheel/ChangeZoom.png";
		if(battleRifle.zoomstrength == battleRifle.HIGHZOOM) BR_Zoom.Alias = "$PBX_Zoom20";
		else BR_Zoom.Alias = "$PBX_Zoom40";
		BR_Zoom.tokentogive = "BR_Select_Zoom";
		BR_Zoom.scalex = WHEEL_ZOOM_SCALE;
		BR_Zoom.scaley = WHEEL_ZOOM_SCALE;
		spw.push(BR_Zoom);

		bool disabled;
		let disableUpgrade = Cvar.GetCvar('PBXWeapons_backpack_filter', requester.player);
		if(disableUpgrade)
			disabled = disableUpgrade.getint() & DisablePBX_BattleRifleUpgrade;

		if((hasUpgrade || disabled) && isZooming)
		{
			// Scope
			PB_SpecialWheel_Mode BR_Scope = new ("PB_SpecialWheel_Mode");
			BR_Scope.img = "graphics/WeaponWheel/ScopeMode.png";
			BR_Scope.Alias = "$PBX_GoScope";
			BR_Scope.tokentogive = "BR_Select_Scope";
			BR_Scope.scalex = WHEEL_SCOPE_SCALE;
			BR_Scope.scaley = WHEEL_SCOPE_SCALE;
			spw.push(BR_Scope);
		
			// NVG
			PB_SpecialWheel_Mode BR_goNVG = new ("PB_SpecialWheel_Mode");
			BR_goNVG.img = "GRAPHICS/HiResPickups/Powerups/VISR1.png";
			if(battleRifle.nvgActive) BR_goNVG.Alias = "$PBX_nvgOffWW";
			else BR_goNVG.Alias = "$PBX_nvgOnWW";
			BR_goNVG.tokentogive = "BR_Select_NVG";
			BR_goNVG.scalex = WHEEL_NVG_SCALE;
			BR_goNVG.scaley = WHEEL_NVG_SCALE;
			spw.push(BR_goNVG);
		}
	}
}