Class DemonicExtWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 2;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		super.GetSpecials(spw,requester);
		
		PB_SpecialWheel_Mode DE_LaserMode = new ("PB_SpecialWheel_Mode");
		DE_LaserMode.img = "graphics/WeaponWheel/DemonExt/LaserAlt.png";
		DE_LaserMode.Alias = "$PBX_DemonExt_Laser";
		DE_LaserMode.tokentogive = "UMDE_Select_LaserMode";
		DE_LaserMode.scalex = 0.6;
		DE_LaserMode.scaley = 0.6;
		spw.push(DE_LaserMode);
		
		PB_SpecialWheel_Mode DE_IncinMode = new ("PB_SpecialWheel_Mode");
		DE_IncinMode.img = "graphics/WeaponWheel/DemonExt/IncinerationAlt.png";
		DE_IncinMode.Alias = "$PBX_DemonExt_Incin";
		DE_IncinMode.tokentogive = "UMDE_Select_IncinerationMode";
		DE_IncinMode.scalex = 0.6;
		DE_IncinMode.scaley = 0.6;
		spw.push(DE_IncinMode);
		
		PB_SpecialWheel_Mode DE_LightningMode = new ("PB_SpecialWheel_Mode");
		DE_LightningMode.img = "graphics/WeaponWheel/DemonExt/LightningAlt.png";
		DE_LightningMode.Alias = "$PBX_DemonExt_Lightning";
		DE_LightningMode.tokentogive = "UMDE_Select_LightningMode";
		DE_LightningMode.scalex = 0.6;
		DE_LightningMode.scaley = 0.6;
		spw.push(DE_LightningMode);
		
	}
}
/*
class UMDE_Select_LaserMode : inventory{default{inventory.maxamount 1;}}
class UMDE_Select_IncinerationMode : inventory{default{inventory.maxamount 1;}}
class UMDE_Select_LightningMode : inventory{default{inventory.maxamount 1;}}
*/