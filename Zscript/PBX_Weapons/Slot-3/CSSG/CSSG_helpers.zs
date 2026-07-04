// Wheel Tokens
Class SelectCSG_No : Inventory {default{inventory.maxamount 1;}}
Class SelectCSG_Buckshot : Inventory {default{inventory.maxamount 1;}}
Class SelectCSG_Danmaku : Inventory {default{inventory.maxamount 1;}}
Class SelectCSG_Slugshot : Inventory {default{inventory.maxamount 1;}}
Class SelectCSG_Dragonsbreath : Inventory {default{inventory.maxamount 1;}}
Class SelectCSG_Flak : Inventory {default{inventory.maxamount 1;}}
Class SelectCSG_Flechette : Inventory {default{inventory.maxamount 1;}}
Class SelectCSG_Explosive : Inventory {default{inventory.maxamount 1;}}
Class SelectCSG_WPhosphorus : Inventory {default{inventory.maxamount 1;}}
Class SelectCSG_Doom : Inventory {default{inventory.maxamount 1;}}
Class SelectCSG_SubZero : Inventory {default{inventory.maxamount 1;}}

// Upgrade Tokens
Class ExplosiveUpgrade : CSSGUpgradetokens{}
Class WhitePhosphorusUpgrade : CSSGUpgradetokens{}
Class TripleDoomUpgrade : CSSGUpgradetokens{}
Class DanmakuUpgrade : CSSGUpgradetokens{}
Class SubZeroUpgrade : CSSGUpgradetokens{}

//a base class for tokens, wasnt really needed, but at first i thought they were a lot more
Class CSSGUpgradetokens : inventory
{
	default
	{
		inventory.maxamount 1;
		+INVENTORY.UNCLEARABLE;
		+INVENTORY.UNDROPPABLE;
	}
}

//the item that gives you the upgrades
class CSSGUpgradeBase : PBXCore_UpgradeBase
{
	Default
	{
		Inventory.Pickupsound "misc/shellbox_PickUp";
	}

    override bool TryPickup(in out Actor toucher)
    {
        bool pickup = Super.TryPickup(toucher);
        if (pickup)
			toucher.A_giveinventory("PB_Shell",10);
        return pickup;
    }

    override void PBX_SetUpgradeSprite()
    {
        name s;

        switch(upgradetype)
		{
			case 'ExplosiveUpgrade': 		s = "XHEL"; break;
			case 'WhitePhosphorusUpgrade': 	s = "PHEL"; break;
			case 'TripleDoomUpgrade':		s = "DHEL"; break;
			case 'DanmakuUpgrade': 			s = "THEL"; break;
			case 'SubZeroUpgrade': 			s = "FHEL"; break;
            default:                        s = "TNT1"; break;
		}
        sprite = GetSpriteIndex(s);
    }

    States
	{
		LoadSprites:
			XHEL A 0; PHEL A 0; DHEL A 0; THEL A 0; FHEL A 0;
	}
}

// Casings
Class ShellCasingBase : ShotgunCasing  
{	
	states
	{
		cachetextures:
			WCS1 A 0; CAS8 A 0; CAS9 A 0; XCS1 A 0;
			TDS1 A 0; DC0S A 0; CAF8 A 0; XFC1 A 0;
			stop;

	}
}

Class BuckShellCasing : ShellCasingBase {default{PB_CasingBase.CasingSprite 'CASX';}}
Class SlugShellCasing : ShellCasingBase {default{PB_CasingBase.CasingSprite 'CAS5';}}
Class DragonShellCasing : ShellCasingBase {default{PB_CasingBase.CasingSprite 'CAS6';}}
Class ExplosiveShellCasing : ShellCasingBase {default{PB_CasingBase.CasingSprite 'XCS1';}}
Class FlakShellCasing : ShellCasingBase {default{PB_CasingBase.CasingSprite 'CAS9';}}
Class FlechetShellCasing : ShellCasingBase {default{PB_CasingBase.CasingSprite 'CAF8';}}
Class WhitePShellCasing : ShellCasingBase {default{PB_CasingBase.CasingSprite 'WCS1';}}
Class TDoomCasing : ShellCasingBase {default{PB_CasingBase.CasingSprite 'TDS1';}}
Class DanmakuCasing : ShellCasingBase {default{PB_CasingBase.CasingSprite 'DC0S';}}
Class SubZeroCasing : ShellCasingBase {default{PB_CasingBase.CasingSprite 'XFC1';}}

// Shells Base
class PBX_CSSG_ShellBase : PB_Shell
{
	Default
    {
        Inventory.Amount PBX_CSSG.BARREL_CAPACITY;
		Ammo.BackpackAmount PBX_CSSG.BARREL_CAPACITY;
        Inventory.PickupSound "weapons/casing";
        Scale 0.25;
    }

	States
	{
		CacheSprites:
			ZCG1 A 0; ZCG2 A 0; ZCG3 A 0; ZCG4 A 0; ZCG5 A 0;
			ZCG6 A 0; ZCG7 A 0; ZCG8 A 0; ZCG9 A 0; ZC10 A 0;
	}
}