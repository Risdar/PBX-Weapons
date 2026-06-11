Class LeverActionWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 3;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		super.GetSpecials(spw,requester);

		vector2 iconscale = (0.6,0.6);
		
		let la = PBX_Prosurv_LeverAction(requester.player.readyweapon);
		if(!la) return;

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
		if(la.laserActive) {
			LA_Laser.Alias = "$PBX_LaserOff";
			LA_Laser.img = "graphics/WeaponWheel/LeverAction/LaserOff.png";
		}
		else {
			LA_Laser.Alias = "$PBX_LaserON";
			LA_Laser.img = "graphics/WeaponWheel/LeverAction/LaserOn.png";
		}
		LA_Laser.tokentogive = "LA_Select_Laser";
		LA_Laser.scalex = iconscale.x;
		LA_Laser.scaley = iconscale.y;
		spw.push(LA_Laser);
		
	}
}