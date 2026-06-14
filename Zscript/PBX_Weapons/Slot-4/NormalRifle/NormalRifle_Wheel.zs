Class NormalRifleWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 3;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		let nr = PBX_NormalRifle(requester.player.readyweapon);

		super.GetSpecials(spw,requester);
        
        vector2 scale = (0.8,0.8);
		
		// Toggle Fire
		PB_SpecialWheel_Mode NR_ToggleFire = new ("PB_SpecialWheel_Mode");
		if(!nr.doBurst)
		{
			NR_ToggleFire.img 	= "graphics/WeaponWheel/NormalRifle/Burst.png";
			NR_ToggleFire.Alias = "$PB_WHEEL_BURST";
		}
		else
		{
			NR_ToggleFire.img 	= "graphics/WeaponWheel/NormalRifle/fullauto.png";
			NR_ToggleFire.Alias = "$PB_WHEEL_FULL";
		}
		NR_ToggleFire.tokentogive = "NR_Select_FireMode";
		NR_ToggleFire.scalex = scale.x;
		NR_ToggleFire.scaley = scale.y;
		spw.push(NR_ToggleFire);

		// Dual Wield
		PB_SpecialWheel_Mode NR_DualWield = new ("PB_SpecialWheel_Mode");
		if(nr.akimboMode) {
			NR_DualWield.Alias = "$PBX_NormalRifle_Single";
			NR_DualWield.img = "graphics/WeaponWheel/NormalRifle/LaserOff.png";
		}
		else {
			NR_DualWield.Alias = "$PBX_NormalRifle_Akimbo";
			NR_DualWield.img = "graphics/WeaponWheel/NormalRifle/dualwield.png";
		}
		NR_DualWield.tokentogive = "NR_Select_DualWield";
		NR_DualWield.scalex = scale.x;
		NR_DualWield.scaley = scale.y;
		spw.push(NR_DualWield);

		// Laser
		PB_SpecialWheel_Mode BR_Laser = new ("PB_SpecialWheel_Mode");
		if(nr.laserActive) {
			BR_Laser.Alias = "$PBX_LaserOff";
			BR_Laser.img = "graphics/WeaponWheel/NormalRifle/LaserOff.png";
		}
		else {
			BR_Laser.Alias = "$PBX_LaserON";
			BR_Laser.img = "graphics/WeaponWheel/NormalRifle/LaserOn.png";
		}
		BR_Laser.tokentogive = "NR_Select_Laser";
		BR_Laser.scalex = scale.x;
		BR_Laser.scaley = scale.y;
		spw.push(BR_Laser);
		
	}
}