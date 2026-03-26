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

//DragonBreathUpgrade

Class WhitePhosphorusUpgrade : CSSGUpgradetokens
{}

Class ExplosiveUpgrade:CSSGUpgradetokens
{}

Class TripleDoomUpgrade:CSSGUpgradetokens
{}

Class DanmakuUpgrade:CSSGUpgradetokens
{}


//the item that gives you the upgrades
Class ExplosiveShellsUpgrade : inventory
{
	default
	{
		+inventory.alwayspickup;
		Inventory.Pickupsound "misc/shellbox_PickUp";
		inventory.pickupmessage "PBX_PICKUP_EXPL";
	}
	states
	{
		Spawn:
			XHEL A -1 bright light("WeaponUpgradeSpawner");
			stop;
	}
	
	override bool trypickup(in out actor toucher)
	{
		if(toucher && toucher.player)
			toucher.A_giveinventory("ExplosiveUpgrade",1);
		return super.trypickup(toucher);
	}
}

Class WPShellsUpgrade : inventory
{
	default
	{
		+inventory.alwayspickup;
		Inventory.Pickupsound "misc/shellbox_PickUp";
		inventory.pickupmessage "$PBX_PICKUP_WPSP";
	}
	states
	{
		Spawn:
			PHEL A -1 bright light("WeaponUpgradeSpawner");
			stop;
	}
	
	override bool trypickup(in out actor toucher)
	{
		if(toucher && toucher.player)
			toucher.A_giveinventory("WhitePhosphorusUpgrade",1);
		return super.trypickup(toucher);
	}
}

Class DoomShellsUpgrade : inventory
{
	default
	{
		+inventory.alwayspickup;
		Inventory.Pickupsound "misc/shellbox_PickUp";
		inventory.pickupmessage "$PBX_PICKUP_DOOM";
	}
	states
	{
		Spawn:
			DHEL A -1 bright light("WeaponUpgradeSpawner");
			stop;
	}
	
	override bool trypickup(in out actor toucher)
	{
		if(toucher && toucher.player)
			toucher.A_giveinventory("TripleDoomUpgrade",1);
		return super.trypickup(toucher);
	}
}


Class DanmakuShellsUpgrade : inventory
{
	default
	{
		+inventory.alwayspickup;
		Inventory.Pickupsound "misc/shellbox_PickUp";
		Inventory.PickupMessage "$PBX_PICKUP_DNMK";
	}
	states
	{
		Spawn:
			THEL A -1 bright light("WeaponUpgradeSpawner");
			stop;
	}
	
	override bool trypickup(in out actor toucher)
	{
		if(toucher && toucher.player)
			toucher.A_giveinventory("DanmakuUpgrade",1);
		return super.trypickup(toucher);
	}
}

//
//	wheel tokens
//
Class SelectCSG_No : Inventory
{
	default
	{
		inventory.maxamount 1;
	}
}

Class SelectCSG_Buckshot : Inventory
{
	default
	{
		inventory.maxamount 1;
	}
}

Class SelectCSG_Danmaku : Inventory
{
	default
	{
		inventory.maxamount 1;
	}
}

Class SelectCSG_Slugshot : Inventory
{
	default
	{
		inventory.maxamount 1;
	}
}

Class SelectCSG_Dragonsbreath : Inventory
{
	default
	{
		inventory.maxamount 1;
	}
}

Class SelectCSG_Flak : Inventory
{
	default
	{
		inventory.maxamount 1;
	}
}

Class SelectCSG_Flechette : Inventory
{
	default
	{
		inventory.maxamount 1;
	}
}

Class SelectCSG_Explosive : Inventory
{
	default
	{
		inventory.maxamount 1;
	}
}

Class SelectCSG_WPhosphorus : Inventory
{
	default
	{
		inventory.maxamount 1;
	}
}

Class SelectCSG_Doom : Inventory
{
	default
	{
		inventory.maxamount 1;
	}
}
