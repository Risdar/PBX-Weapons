Class BattleRifleWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 4;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		let battleRifle = PBX_BDPBattleRifle(requester.player.readyweapon);

		super.GetSpecials(spw,requester);
        
        vector2 scale = (0.9,0.9);
		
		// Semi Auto
		PB_SpecialWheel_Mode BR_Semi = new ("PB_SpecialWheel_Mode");
		BR_Semi.img = "graphics/WeaponWheel/BattleRifle/BR_Semi.png";
		BR_Semi.Alias = "$PBX_BattleRifle_SemiAuto";
		BR_Semi.tokentogive = "BR_Select_Semi";
		BR_Semi.scalex = scale.x;
		BR_Semi.scaley = scale.y;
		spw.push(BR_Semi);
		
		// Burst Fire
		PB_SpecialWheel_Mode BR_Burst = new ("PB_SpecialWheel_Mode");
		BR_Burst.img = "graphics/WeaponWheel/BattleRifle/BR_Burst.png";
		BR_Burst.Alias = "$PBX_BattleRifle_Burst";
		BR_Burst.tokentogive = "BR_Select_Burst";
		BR_Burst.scalex = scale.x;
		BR_Burst.scaley = scale.y;
		spw.push(BR_Burst);

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