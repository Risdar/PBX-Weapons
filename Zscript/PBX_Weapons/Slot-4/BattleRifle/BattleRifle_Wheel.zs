Class BattleRifleWheel : wheelinfocontainer
{
	mixin PBX_GenericSpecialWheel;
	
	override int GetSPCount(actor requester)
	{
		return 3; // Close Wheel (1) + Toggle Fire (1) + Laser (1)
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		if(!spw || !requester)
			return;
			
		PBX_InitializeWheel(spw,requester,scale:(0.9,0.9));
		let br = PBX_BDPBattleRifle(mWeap); if(!br) return;
		
		// Toggle Fire
		PB_SpecialWheel_Mode BR_ToggleFire = new ("PB_SpecialWheel_Mode");
		if(br.isSemiAuto)
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
		BR_ToggleFire.scalex = mIconScale.x;
		BR_ToggleFire.scaley = mIconScale.y;
		spw.push(BR_ToggleFire);

		// Laser
		PBX_LaserWheel(spw,"BattleRifle",mIconScale);
	}

}