Class NormalRifleWheel : wheelinfocontainer
{
	mixin PBX_GenericSpecialWheel;
	
	override int GetSPCount(actor requester)
	{
		return 4; // Close Wheel (1) + Toggle Fire (1) + Dual Wield (1) + Laser Sight (1)
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		if(!spw || !requester)
			return;
			
		PBX_InitializeWheel(spw,requester,scale:(0.8,0.8));
		let nr = PBX_NormalRifle(mWeap); if(!nr) return;
		
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
		NR_ToggleFire.scalex = mIconScale.x;
		NR_ToggleFire.scaley = mIconScale.y;
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
		NR_DualWield.scalex = mIconScale.x;
		NR_DualWield.scaley = mIconScale.y;
		spw.push(NR_DualWield);

		// Laser
		PBX_LaserWheel(spw,"NormalRifle",mIconScale);
		
	}
}