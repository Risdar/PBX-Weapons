Class LeverActionWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 4;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		if(!spw || !requester)
			return;
			
		let la = PBX_Prosurv_LeverAction(requester.player.readyweapon);
        if(!la) return;

		super.GetSpecials(spw,requester);

		vector2 iconscale = (0.6,0.6);

		PB_SpecialWheel_Mode Weapon_Close = new ("PB_SpecialWheel_Mode");
		Weapon_Close.img = "graphics/WeaponWheel/CloseMenu.png";
		Weapon_Close.Alias = "$PBX_CloseMenu";
		Weapon_Close.tokentogive = "PBX_CloseWheel";
		Weapon_Close.scalex = WHEEL_CLOSEMENU_SCALE;
		Weapon_Close.scaley = WHEEL_CLOSEMENU_SCALE;
		spw.push(Weapon_Close);

		PB_SpecialWheel_Mode LA_Marlin = new ("PB_SpecialWheel_Mode");
		LA_Marlin.img = "graphics/WeaponWheel/LeverAction/Marlin.png";
		LA_Marlin.Alias = "$PBX_LeverAction_Marlin";
		LA_Marlin.tokentogive = "LA_Select_Marlin";
		LA_Marlin.scalex = iconscale.x;
		LA_Marlin.scaley = iconscale.y;
		spw.push(LA_Marlin);
		
		PB_SpecialWheel_Mode LA_357Magnum = new ("PB_SpecialWheel_Mode");
		LA_357Magnum.img = "graphics/WeaponWheel/LeverAction/Magnum.png";
		LA_357Magnum.Alias = "$PBX_LeverAction_Magnum";
		LA_357Magnum.tokentogive = "LA_Select_Magnum";
		LA_357Magnum.scalex = iconscale.x;
		LA_357Magnum.scaley = iconscale.y;
		spw.push(LA_357Magnum);

		PB_SpecialWheel_Mode LA_Laser = new ("PB_SpecialWheel_Mode");
		if(la.mLaserSightActivated) {
			LA_Laser.Alias = "$PBX_LaserOff";
			LA_Laser.img = "graphics/WeaponWheel/LeverAction/LaserOff.png";
		}
		else {
			LA_Laser.Alias = "$PBX_LaserON";
			LA_Laser.img = "graphics/WeaponWheel/LeverAction/LaserOn.png";
		}
		LA_Laser.tokentogive = "PBX_Toggle_Laser";
		LA_Laser.scalex = iconscale.x;
		LA_Laser.scaley = iconscale.y;
		spw.push(LA_Laser);
		
	}
}