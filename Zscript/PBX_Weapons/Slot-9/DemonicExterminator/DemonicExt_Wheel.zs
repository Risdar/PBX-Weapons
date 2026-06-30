Class DemonicExtWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 4;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		super.GetSpecials(spw,requester);

		vector2 iconscale = (0.6,0.6);

		PB_SpecialWheel_Mode Weapon_Close = new ("PB_SpecialWheel_Mode");
		Weapon_Close.img = "graphics/WeaponWheel/CloseMenu.png";
		Weapon_Close.Alias = "$PBX_CloseMenu";
		Weapon_Close.tokentogive = "PBX_CloseWheel";
		Weapon_Close.scalex = WHEEL_CLOSEMENU_SCALE;
		Weapon_Close.scaley = WHEEL_CLOSEMENU_SCALE;
		spw.push(Weapon_Close);
		
		PB_SpecialWheel_Mode DE_LaserMode = new ("PB_SpecialWheel_Mode");
		DE_LaserMode.img = "graphics/WeaponWheel/DemonExt/LaserAlt.png";
		DE_LaserMode.Alias = "$PBX_DemonExt_Laser";
		DE_LaserMode.tokentogive = "UMDE_Select_LaserMode";
		DE_LaserMode.scalex = iconscale.x;
		DE_LaserMode.scaley = iconscale.y;
		spw.push(DE_LaserMode);
		
		PB_SpecialWheel_Mode DE_IncinMode = new ("PB_SpecialWheel_Mode");
		DE_IncinMode.img = "graphics/WeaponWheel/DemonExt/IncinerationAlt.png";
		DE_IncinMode.Alias = "$PBX_DemonExt_Incin";
		DE_IncinMode.tokentogive = "UMDE_Select_IncinerationMode";
		DE_IncinMode.scalex = iconscale.x;
		DE_IncinMode.scaley = iconscale.y;
		spw.push(DE_IncinMode);
		
		PB_SpecialWheel_Mode DE_LightningMode = new ("PB_SpecialWheel_Mode");
		DE_LightningMode.img = "graphics/WeaponWheel/DemonExt/LightningAlt.png";
		DE_LightningMode.Alias = "$PBX_DemonExt_Lightning";
		DE_LightningMode.tokentogive = "UMDE_Select_LightningMode";
		DE_LightningMode.scalex = iconscale.x;
		DE_LightningMode.scaley = iconscale.y;
		spw.push(DE_LightningMode);
		
	}
}
/*
class UMDE_Select_LaserMode : inventory{default{inventory.maxamount 1;}}
class UMDE_Select_IncinerationMode : inventory{default{inventory.maxamount 1;}}
class UMDE_Select_LightningMode : inventory{default{inventory.maxamount 1;}}
*/