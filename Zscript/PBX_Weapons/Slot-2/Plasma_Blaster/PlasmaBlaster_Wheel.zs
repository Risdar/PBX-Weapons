Class PlasmaBlasterWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 5;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		if(!spw || !requester)
			return;
			
		vector2 iconScale = (1.2, 1.2);

		PB_SpecialWheel_Mode Weapon_Close = new ("PB_SpecialWheel_Mode");
		Weapon_Close.img = "graphics/WeaponWheel/CloseMenu.png";
		Weapon_Close.Alias = "$PBX_CloseMenu";
		Weapon_Close.tokentogive = "PBX_CloseWheel";
		Weapon_Close.scalex = WHEEL_CLOSEMENU_SCALE;
		Weapon_Close.scaley = WHEEL_CLOSEMENU_SCALE;
		spw.push(Weapon_Close);
			
		PB_SpecialWheel_Mode plasmablaster_semi = new ("PB_SpecialWheel_Mode");
		plasmablaster_semi.img = "graphics/WeaponWheel/PlasmaBlaster/semi.png";
		plasmablaster_semi.Alias = "$PBX_PlasmaBlaster_Semi";
		plasmablaster_semi.tokentogive = "Plasma_Select_Semi";
		plasmablaster_semi.scalex = iconscale.x;
		plasmablaster_semi.scaley = iconscale.y;
		
		spw.Push(plasmablaster_semi);

		PB_SpecialWheel_Mode plasmablaster_auto = new ("PB_SpecialWheel_Mode");
		plasmablaster_auto.img = "graphics/WeaponWheel/PlasmaBlaster/fullauto.png";
		plasmablaster_auto.Alias = "$PBX_PlasmaBlaster_Auto";
		plasmablaster_auto.tokentogive = "Plasma_Select_Auto";
		plasmablaster_auto.scalex = iconscale.x;
		plasmablaster_auto.scaley = iconscale.y;
		
		spw.Push(plasmablaster_auto);

		PB_SpecialWheel_Mode plasmablaster_burst = new ("PB_SpecialWheel_Mode");
		plasmablaster_burst.img = "graphics/WeaponWheel/PlasmaBlaster/burst.png";
		plasmablaster_burst.Alias = "$PBX_PlasmaBlaster_Burst";
		plasmablaster_burst.tokentogive = "Plasma_Select_Burst";
		plasmablaster_burst.scalex = iconscale.x;
		plasmablaster_burst.scaley = iconscale.y;
		
		spw.Push(plasmablaster_burst);

		PB_SpecialWheel_Mode plasmablaster_charge = new ("PB_SpecialWheel_Mode");
		plasmablaster_charge.img = "graphics/WeaponWheel/PlasmaBlaster/blast.png";
		plasmablaster_charge.Alias = "$PBX_PlasmaBlaster_Charge";
		plasmablaster_charge.tokentogive = "Plasma_Select_Charge";
		plasmablaster_charge.scalex = iconscale.x;
		plasmablaster_charge.scaley = iconscale.y;
		
		spw.Push(plasmablaster_charge);
	}
}