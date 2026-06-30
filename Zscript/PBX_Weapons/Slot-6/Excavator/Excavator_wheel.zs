Class ExcavatorWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 3;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		super.GetSpecials(spw,requester);

		PB_SpecialWheel_Mode Weapon_Close = new ("PB_SpecialWheel_Mode");
		Weapon_Close.img = "graphics/WeaponWheel/CloseMenu.png";
		Weapon_Close.Alias = "$PBX_CloseMenu";
		Weapon_Close.tokentogive = "PBX_CloseWheel";
		Weapon_Close.scalex = WHEEL_CLOSEMENU_SCALE;
		Weapon_Close.scaley = WHEEL_CLOSEMENU_SCALE;
		spw.push(Weapon_Close);
		
		PB_SpecialWheel_Mode EX_Drop = new ("PB_SpecialWheel_Mode");
		EX_Drop.img = "graphics/WeaponWheel/Excavator/DropAlt.png";
		EX_Drop.Alias = "$PBX_Excavator_DropMode";
		EX_Drop.tokentogive = "EX_Select_DropMode";
		EX_Drop.scalex = 0.6;
		EX_Drop.scaley = 0.6;
		spw.push(EX_Drop);
		
		PB_SpecialWheel_Mode EX_Drill = new ("PB_SpecialWheel_Mode");
		EX_Drill.img = "graphics/WeaponWheel/Excavator/DrillAlt.png";
		EX_Drill.Alias = "$PBX_Excavator_DrillMode";
		EX_Drill.tokentogive = "EX_Select_DrillMode";
		EX_Drill.scalex = 0.6;
		EX_Drill.scaley = 0.6;
		spw.push(EX_Drill);
		
	}
}