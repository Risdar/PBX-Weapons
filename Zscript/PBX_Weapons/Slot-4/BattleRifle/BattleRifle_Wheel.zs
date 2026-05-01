Class BattleRifleWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 2;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		super.GetSpecials(spw,requester);
        
        vector2 scale = (1.0,1.0);
		
		PB_SpecialWheel_Mode BR_Semi = new ("PB_SpecialWheel_Mode");
		BR_Semi.img = "graphics/WeaponWheel/BattleRifle/BR_Semi.png";
		BR_Semi.Alias = "$PBX_BattleRifle_SemiAuto";
		BR_Semi.tokentogive = "BR_Select_Semi";
		BR_Semi.scalex = scale.x;
		BR_Semi.scaley = scale.y;
		spw.push(BR_Semi);
		
		PB_SpecialWheel_Mode BR_Burst = new ("PB_SpecialWheel_Mode");
		BR_Burst.img = "graphics/WeaponWheel/BattleRifle/BR_Burst.png";
		BR_Burst.Alias = "$PBX_BattleRifle_Burst";
		BR_Burst.tokentogive = "BR_Select_Burst";
		BR_Burst.scalex = scale.x;
		BR_Burst.scaley = scale.y;
		spw.push(BR_Burst);
		
	}
}