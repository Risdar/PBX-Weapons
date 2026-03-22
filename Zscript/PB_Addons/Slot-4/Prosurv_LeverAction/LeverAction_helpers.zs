class RespectLeverAction : inventory {default{inventory.maxamount 1;}}
class LA_Select_Marlin : inventory {default{inventory.maxamount 1;}}
class LA_Select_Magnum : inventory {default{inventory.maxamount 1;}}
class LeverActionAmmo : PB_Ammo {default{inventory.maxamount leveractionFullAmmo;}}

class PB_357Magnum : PB_500SW
{
	Default
	{
		PB_Projectile.BaseDamage 120;
		PB_Projectile.RipperCount 4;
		PB_Projectile.PenetrationCount 5;
		+PB_Projectile.WHIZCRACK;
		Obituary "%o was shot at somewhere else by %k.";
	}
}

class PB_444Marlin : PB_500SW
{
	Default
	{
		PB_Projectile.BaseDamage 200;
		PB_Projectile.RipperCount 5;
		PB_Projectile.PenetrationCount 5;
		+PB_Projectile.WHIZCRACK;
		DamageType "SSG";
		Obituary "%o was Hard hit with punch of Marlin by %k.";
	}
}

Class LeverActionWheel : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
		return 2;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		super.GetSpecials(spw,requester);
		
		PB_SpecialWheel_Mode LA_Marlin = new ("PB_SpecialWheel_Mode");
		LA_Marlin.img = "graphics/Weapon Wheel/LeverAction/Marlin.png";
		LA_Marlin.Alias = "$PBX_LeverAction_Marlin";
		LA_Marlin.tokentogive = "LA_Select_Marlin";
		LA_Marlin.scalex = 0.6;
		LA_Marlin.scaley = 0.6;
		spw.push(LA_Marlin);
		
		PB_SpecialWheel_Mode LA_357Magnum = new ("PB_SpecialWheel_Mode");
		LA_357Magnum.img = "graphics/Weapon Wheel/LeverAction/Magnum.png";
		LA_357Magnum.Alias = "$PBX_LeverAction_Magnum";
		LA_357Magnum.tokentogive = "LA_Select_Magnum";
		LA_357Magnum.scalex = 0.6;
		LA_357Magnum.scaley = 0.6;
		spw.push(LA_357Magnum);
		
	}
}