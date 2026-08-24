Class BDPRailgun_Wheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 5;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		if(!spw || !requester)
			return;
			
		let weap = PBX_BDPRailgun(requester.player.readyweapon);
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
		PB_SpecialWheel_Mode Railgun_Laser = new ("PB_SpecialWheel_Mode");
		if(weap.mLaserSightActivated) {
			Railgun_Laser.Alias = "$PBX_LaserOff";
			Railgun_Laser.img = "graphics/WeaponWheel/PlatRailgun/LaserOff.png";
		}
		else {
			Railgun_Laser.Alias = "$PBX_LaserON";
			Railgun_Laser.img = "graphics/WeaponWheel/PlatRailgun/LaserOn.png";
		}
		Railgun_Laser.tokentogive = "PBX_Toggle_Laser";
		Railgun_Laser.scalex = iconscale.x;
		Railgun_Laser.scaley = iconscale.y;
		spw.push(Railgun_Laser);

		// Scope
		PB_SpecialWheel_Mode Railgun_Scope = new ("PB_SpecialWheel_Mode");
		Railgun_Scope.img = "graphics/WeaponWheel/ScopeMode.png";
		Railgun_Scope.Alias = "$PBX_GoScope";
		Railgun_Scope.tokentogive = "PBX_Toggle_Scope";
		Railgun_Scope.scalex = WHEEL_SCOPE_SCALE;
		Railgun_Scope.scaley = WHEEL_SCOPE_SCALE;
		spw.push(Railgun_Scope);

		// NVG
		PB_SpecialWheel_Mode Railgun_goNVG = new ("PB_SpecialWheel_Mode");
		Railgun_goNVG.img = "GRAPHICS/HiResPickups/Powerups/VISR1.png";
		if(weap.mNightVisionActivated) 
			Railgun_goNVG.Alias = "$PBX_nvgOffWW";
		else 
			Railgun_goNVG.Alias = "$PBX_nvgOnWW";
		Railgun_goNVG.tokentogive = "PBX_Toggle_NVG";
		Railgun_goNVG.scalex = WHEEL_NVG_SCALE;
		Railgun_goNVG.scaley = WHEEL_NVG_SCALE;
		spw.push(Railgun_goNVG);

		// Hologram
		PB_SpecialWheel_Mode Railgun_goHolo = new ("PB_SpecialWheel_Mode");
		Railgun_goHolo.img = "graphics/WeaponWheel/PlatRailgun/spawnHologram.png";
		Railgun_goHolo.Alias = "$PBX_BDPRailgun_SpawnHologram";
		Railgun_goHolo.tokentogive = "platRailgun_goHolo";
		Railgun_goHolo.scalex = iconscale.x*0.9;
		Railgun_goHolo.scaley = iconscale.y*0.9;
		spw.push(Railgun_goHolo);
		
	}
}