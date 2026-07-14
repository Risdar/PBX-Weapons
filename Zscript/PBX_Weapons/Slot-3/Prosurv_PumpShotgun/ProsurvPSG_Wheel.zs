Class PSGWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 7;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		if(!spw || !requester)
			return;

        let psg = PBX_ProSurvPSG(requester.player.readyweapon);
        if(!psg) return;

		super.GetSpecials(spw,requester);
			
		double iconScale = 0.9;

		PB_SpecialWheel_Mode Weapon_Close = new ("PB_SpecialWheel_Mode");
		Weapon_Close.img = "graphics/WeaponWheel/CloseMenu.png";
		Weapon_Close.Alias = "$PBX_CloseMenu";
		Weapon_Close.tokentogive = "PBX_CloseWheel";
		Weapon_Close.scalex = WHEEL_CLOSEMENU_SCALE;
		Weapon_Close.scaley = WHEEL_CLOSEMENU_SCALE;
		spw.push(Weapon_Close);

		// Laser
		PB_SpecialWheel_Mode PSG_Laser = new ("PB_SpecialWheel_Mode");
		if(psg.laserActive) {
			PSG_Laser.Alias = "$PBX_LaserOff";
			PSG_Laser.img = "graphics/WeaponWheel/ProsurvPSG/LaserOff.png";
		}
		else {
			PSG_Laser.Alias = "$PBX_LaserON";
			PSG_Laser.img = "graphics/WeaponWheel/ProsurvPSG/LaserOn.png";
		}
		PSG_Laser.tokentogive = "PSG_Select_Laser";
		PSG_Laser.scalex = 1.1;
		PSG_Laser.scaley = 1.1;
		spw.push(PSG_Laser);

        PB_SpecialWheel_Mode PSG_Tripmine = new ("PB_SpecialWheel_Mode");
		PSG_Tripmine.img = "graphics/WeaponWheel/ProsurvPSG/Tripmine.png";
		PSG_Tripmine.Alias = "$PBX_PSG_TRIPMINE";
		PSG_Tripmine.tokentogive = "PSG_Select_Tripmine";
		PSG_Tripmine.scalex = 0.3;
		PSG_Tripmine.scaley = 0.3;
		spw.push(PSG_Tripmine);

        PB_SpecialWheel_Mode PSG_LaserCharge = new ("PB_SpecialWheel_Mode");
		PSG_LaserCharge.img = "graphics/WeaponWheel/ProsurvPSG/LaserCharge.png";
		PSG_LaserCharge.Alias = "$PBX_PSG_LASERCHARGE";
		PSG_LaserCharge.tokentogive = "PSG_Select_LaserCharge";
		PSG_LaserCharge.scalex = iconScale;
		PSG_LaserCharge.scaley = iconScale;
		spw.push(PSG_LaserCharge);

        PB_SpecialWheel_Mode PSG_AcidCharge = new ("PB_SpecialWheel_Mode");
		PSG_AcidCharge.img = "graphics/WeaponWheel/ProsurvPSG/AcidCharge.png";
		PSG_AcidCharge.Alias = "$PBX_PSG_ACIDCHARGE";
		PSG_AcidCharge.tokentogive = "PSG_Select_AcidCharge";
		PSG_AcidCharge.scalex = iconScale;
		PSG_AcidCharge.scaley = iconScale;
		spw.push(PSG_AcidCharge);

        PB_SpecialWheel_Mode PSG_SwarmCharge = new ("PB_SpecialWheel_Mode");
		PSG_SwarmCharge.img = "graphics/WeaponWheel/ProsurvPSG/SwarmCharge.png";
		PSG_SwarmCharge.Alias = "$PBX_PSG_SWARMACHARGE";
		PSG_SwarmCharge.tokentogive = "PSG_Select_SwarmCharge";
		PSG_SwarmCharge.scalex = iconScale;
		PSG_SwarmCharge.scaley = iconScale;
		spw.push(PSG_SwarmCharge);

        PB_SpecialWheel_Mode PSG_Detonator = new ("PB_SpecialWheel_Mode");
		PSG_Detonator.img = "graphics/WeaponWheel/ProsurvPSG/Detonator.png";
		PSG_Detonator.Alias = "$PBX_PSG_DETONATOR";
		PSG_Detonator.tokentogive = "PSG_Select_Detonator";
		PSG_Detonator.scalex = 0.9;
		PSG_Detonator.scaley = 0.9;
		spw.push(PSG_Detonator);

	}
}