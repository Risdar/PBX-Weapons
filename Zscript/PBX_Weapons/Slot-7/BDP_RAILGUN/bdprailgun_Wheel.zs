Class BDPRailgun_Wheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 5;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		super.GetSpecials(spw,requester);

		vector2 iconScale = (1.0, 1.0);
		let weap = PBX_BDPRailgun(requester.player.readyweapon);

        // Laser
		PB_SpecialWheel_Mode Railgun_Laser = new ("PB_SpecialWheel_Mode");
		if(weap.laserActive) {
			Railgun_Laser.Alias = "$PBX_LaserOff";
			Railgun_Laser.img = "graphics/WeaponWheel/PlatRailgun/LaserOff.png";
		}
		else {
			Railgun_Laser.Alias = "$PBX_LaserON";
			Railgun_Laser.img = "graphics/WeaponWheel/PlatRailgun/LaserOn.png";
		}
		Railgun_Laser.tokentogive = "platrailgun_goLaser";
		Railgun_Laser.scalex = iconscale.x;
		Railgun_Laser.scaley = iconscale.y;
		spw.push(Railgun_Laser);

		// Scope
		PB_SpecialWheel_Mode Railgun_Scope = new ("PB_SpecialWheel_Mode");
		Railgun_Scope.img = "graphics/WeaponWheel/ScopeMode.png";
		Railgun_Scope.Alias = "$PBX_GoScope";
		Railgun_Scope.tokentogive = "platrailgun_goScope";
		Railgun_Scope.scalex = WHEEL_SCOPE_SCALE;
		Railgun_Scope.scaley = WHEEL_SCOPE_SCALE;
		spw.push(Railgun_Scope);

		// Zoom
		PB_SpecialWheel_Mode Railgun_goZoom = new ("PB_SpecialWheel_Mode");
		Railgun_goZoom.img = "graphics/WeaponWheel/ChangeZoom.png";
		if(weap.zoomstrength == weap.HIGHZOOM) Railgun_goZoom.Alias = "$PBX_Zoom30";
		else Railgun_goZoom.Alias = "$PBX_Zoom90";
		Railgun_goZoom.tokentogive = "platrailgun_goZoom";
		Railgun_goZoom.scalex = WHEEL_ZOOM_SCALE;
		Railgun_goZoom.scaley = WHEEL_ZOOM_SCALE;
		spw.push(Railgun_goZoom);

		// NVG
		PB_SpecialWheel_Mode Railgun_goNVG = new ("PB_SpecialWheel_Mode");
		Railgun_goNVG.img = "GRAPHICS/HiResPickups/Powerups/VISR1.png";
		if(weap.nvgActive) Railgun_goNVG.Alias = "$PBX_nvgOffWW";
		else Railgun_goNVG.Alias = "$PBX_nvgOnWW";
		Railgun_goNVG.tokentogive = "platrailgun_goNVG";
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