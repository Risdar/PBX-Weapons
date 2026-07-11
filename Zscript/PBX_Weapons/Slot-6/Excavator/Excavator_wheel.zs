Class ExcavatorWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 5;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		super.GetSpecials(spw,requester);

		double iconScale = 0.6;

		bool upgraded = requester.FindInventory("Excavator_Upgraded");

		PB_SpecialWheel_Mode Weapon_Close = new ("PB_SpecialWheel_Mode");
		Weapon_Close.img = "graphics/WeaponWheel/CloseMenu.png";
		Weapon_Close.Alias = "$PBX_CloseMenu";
		Weapon_Close.tokentogive = "PBX_CloseWheel";
		Weapon_Close.scalex = WHEEL_CLOSEMENU_SCALE;
		Weapon_Close.scaley = WHEEL_CLOSEMENU_SCALE;
		spw.push(Weapon_Close);
		
		PB_SpecialWheel_Mode EX_Drop = new ("PB_SpecialWheel_Mode");
		if(upgraded)
			EX_Drop.img = "graphics/WeaponWheel/Excavator/DropAltUpgraded.png";
		else
			EX_Drop.img = "graphics/WeaponWheel/Excavator/DropAlt.png";
		EX_Drop.Alias = "$PBX_Excavator_DropMode";
		EX_Drop.tokentogive = "EX_Select_DropMode";
		EX_Drop.scalex = iconScale;
		EX_Drop.scaley = iconScale;
		spw.push(EX_Drop);
		
		PB_SpecialWheel_Mode EX_Drill = new ("PB_SpecialWheel_Mode");
		if(upgraded)
			EX_Drill.img = "graphics/WeaponWheel/Excavator/DrillAltUpgraded.png";
		else
			EX_Drill.img = "graphics/WeaponWheel/Excavator/DrillAlt.png";
		EX_Drill.Alias = "$PBX_Excavator_DrillMode";
		EX_Drill.tokentogive = "EX_Select_DrillMode";
		EX_Drill.scalex = iconScale;
		EX_Drill.scaley = iconScale;
		spw.push(EX_Drill);

		bool disabled;
		let disableUpgrade = Cvar.GetCvar('PBXWeapons_backpack_filter', requester.player);
		if(disableUpgrade)
			disabled = disableUpgrade.getint() & DisablePBX_ExcavatorUpgrade;

		if(upgraded || disabled) 
		{
			PB_SpecialWheel_Mode EX_Bola = new ("PB_SpecialWheel_Mode");
			EX_Bola.img = "graphics/WeaponWheel/Excavator/BolaAlt.png";
			EX_Bola.Alias = "$PBX_Excavator_BolaMode";
			EX_Bola.tokentogive = "EX_Select_BolaMode";
			EX_Bola.scalex = iconScale;
			EX_Bola.scaley = iconScale;
			spw.push(EX_Bola);
			
			PB_SpecialWheel_Mode EX_Saw = new ("PB_SpecialWheel_Mode");
			EX_Saw.img = "graphics/WeaponWheel/Excavator/SawAlt.png";
			EX_Saw.Alias = "$PBX_Excavator_SawMode";
			EX_Saw.tokentogive = "EX_Select_SawMode";
			EX_Saw.scalex = iconScale;
			EX_Saw.scaley = iconScale;
			spw.push(EX_Saw);
		}
		else
		{
			PB_SpecialWheel_Mode EX_No_Upgrade = new ("PB_SpecialWheel_Mode");
			EX_No_Upgrade.img = "graphics/WeaponWheel/Excavator/BolaAltNo.png";
			EX_No_Upgrade.Alias = "$PBX_ModeNotAvailable";
			EX_No_Upgrade.tokentogive = "EX_Select_No";
			EX_No_Upgrade.scalex = iconscale;
			EX_No_Upgrade.scaley = iconscale;
			
			spw.Push(EX_No_Upgrade);

			PB_SpecialWheel_Mode EX_No_Upgrade2 = new ("PB_SpecialWheel_Mode");
			EX_No_Upgrade2.img = "graphics/WeaponWheel/Excavator/SawAltNo.png";
			EX_No_Upgrade2.Alias = "$PBX_ModeNotAvailable";
			EX_No_Upgrade2.tokentogive = "EX_Select_No";
			EX_No_Upgrade2.scalex = iconscale;
			EX_No_Upgrade2.scaley = iconscale;
			
			spw.Push(EX_No_Upgrade2);
		}
		
	}
}