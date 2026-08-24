Class BattleRifleWheel : wheelinfocontainer
{
	bool mHasUpgrade;
	bool mIsZooming;
	bool mUpgradeDisabled;

	void getVariables(actor requester)
	{
		mHasUpgrade = requester.FindInventory("BattleRifle_Upgraded");
		mIsZooming  = requester.FindInventory("Zoomed");
		mUpgradeDisabled = PBXWeapons_backpack_filter & DisablePBX_BattleRifleUpgrade;
	}

	override int GetSPCount(actor requester)
	{
		getVariables(requester);

		// this is so the nvg and scope mode is added when
		// the weapon has been upgraded and is zoomed in
		int result = 3;
		if((mHasUpgrade || mUpgradeDisabled) && mIsZooming) 
			result = 5;
			
		return result;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		if(!spw || !requester)
			return;
			
		let battleRifle = PBX_BDPBattleRifle(requester.player.readyweapon);
        if(!battleRifle) return;

		super.GetSpecials(spw,requester);

		getVariables(requester);
        
        vector2 scale = (0.9,0.9);

		PB_SpecialWheel_Mode Weapon_Close = new ("PB_SpecialWheel_Mode");
		Weapon_Close.img = "graphics/WeaponWheel/CloseMenu.png";
		Weapon_Close.Alias = "$PBX_CloseMenu";
		Weapon_Close.tokentogive = "PBX_CloseWheel";
		Weapon_Close.scalex = WHEEL_CLOSEMENU_SCALE;
		Weapon_Close.scaley = WHEEL_CLOSEMENU_SCALE;
		spw.push(Weapon_Close);
		
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
		if(battleRifle.mLaserSightActivated) 
		{
			BR_Laser.Alias = "$PBX_LaserOff";
			BR_Laser.img = "graphics/WeaponWheel/BattleRifle/BR_LaserOff.png";
		}
		else 
		{
			BR_Laser.Alias = "$PBX_LaserON";
			BR_Laser.img = "graphics/WeaponWheel/BattleRifle/BR_LaserOn.png";
		}
		BR_Laser.tokentogive = "PBX_Toggle_Laser";
		BR_Laser.scalex = scale.x;
		BR_Laser.scaley = scale.y;
		spw.push(BR_Laser);

		if((mHasUpgrade || mUpgradeDisabled) && mIsZooming)
		{
			// Scope
			PB_SpecialWheel_Mode BR_Scope = new ("PB_SpecialWheel_Mode");
			BR_Scope.img = "graphics/WeaponWheel/ScopeMode.png";
			BR_Scope.Alias = "$PBX_GoScope";
			BR_Scope.tokentogive = "PBX_Toggle_Scope";
			BR_Scope.scalex = WHEEL_SCOPE_SCALE;
			BR_Scope.scaley = WHEEL_SCOPE_SCALE;
			spw.push(BR_Scope);
		
			// NVG
			PB_SpecialWheel_Mode BR_goNVG = new ("PB_SpecialWheel_Mode");
			BR_goNVG.img = "GRAPHICS/HiResPickups/Powerups/VISR1.png";
			if(battleRifle.mNightVisionActivated) 
				BR_goNVG.Alias = "$PBX_nvgOffWW";
			else 
				BR_goNVG.Alias = "$PBX_nvgOnWW";
			BR_goNVG.tokentogive = "PBX_Toggle_NVG";
			BR_goNVG.scalex = WHEEL_NVG_SCALE;
			BR_goNVG.scaley = WHEEL_NVG_SCALE;
			spw.push(BR_goNVG);
		}
	}
}