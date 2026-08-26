Class BattleRifleWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 3;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		if(!spw || !requester)
			return;
			
		let battleRifle = PBX_BDPBattleRifle(requester.player.readyweapon);
        if(!battleRifle) return;

		super.GetSpecials(spw,requester);
        
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
	}

}