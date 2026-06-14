Class BattleRifleWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 3;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		let battleRifle = PBX_BDPBattleRifle(requester.player.readyweapon);

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

		// Zoom Strength
		PB_SpecialWheel_Mode BR_Zoom = new ("PB_SpecialWheel_Mode");
		BR_Zoom.img = "graphics/WeaponWheel/ChangeZoom.png";
		if(battleRifle.zoomstrength == battleRifle.HIGHZOOM) BR_Zoom.Alias = "$PBX_Zoom20";
		else BR_Zoom.Alias = "$PBX_Zoom40";
		BR_Zoom.tokentogive = "BR_Select_Zoom";
		BR_Zoom.scalex = WHEEL_ZOOM_SCALE;
		BR_Zoom.scaley = WHEEL_ZOOM_SCALE;
		spw.push(BR_Zoom);

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
		
	}
}