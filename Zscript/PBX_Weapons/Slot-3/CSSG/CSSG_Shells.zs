class PBX_CSSG_ShellBase : PB_Shell
{
	Default
    {
        Inventory.Amount 2;
		Ammo.BackpackAmount 2;
        Inventory.PickupSound "weapons/casing";
        Scale 0.25;
    }

	States
	{
		CacheSprites:
			ZCG1 A 0;
			ZCG2 A 0;
			ZCG3 A 0;
			ZCG4 A 0;
			ZCG5 A 0;
			ZCG6 A 0;
			ZCG7 A 0;
			ZCG8 A 0;
			ZCG9 A 0;
			ZC10 A 0;
	}
}

class PBX_CSSG_BuckShell : PBX_CSSG_ShellBase
{
    override void PB_SetAmmoSprite()
    {
        sprite = GetSpriteIndex("ZCG8A0");
    }
}

class PBX_CSSG_DragonsBreathShell : PBX_CSSG_ShellBase
{
    override void PB_SetAmmoSprite()
    {
        sprite = GetSpriteIndex("ZC10A0");
    }
}

class PBX_CSSG_SlugShell : PBX_CSSG_ShellBase
{
    override void PB_SetAmmoSprite()
    {
        sprite = GetSpriteIndex("ZCG9A0");
    }
}

class PBX_CSSG_FlechetteShell : PBX_CSSG_ShellBase
{
    override void PB_SetAmmoSprite()
    {
        sprite = GetSpriteIndex("ZCG1A0");
    }
}

class PBX_CSSG_FlakShell : PBX_CSSG_ShellBase
{
    override void PB_SetAmmoSprite()
    {
        sprite = GetSpriteIndex("ZCG2A0");
    }
}

class PBX_CSSG_ExplosiveShell : PBX_CSSG_ShellBase
{
    override void PB_SetAmmoSprite()
    {
        sprite = GetSpriteIndex("ZCG7A0");
    }
}

class PBX_CSSG_WPShell : PBX_CSSG_ShellBase
{
    override void PB_SetAmmoSprite()
    {
        sprite = GetSpriteIndex("ZCG6A0");
    }
}

class PBX_CSSG_TDoomShell : PBX_CSSG_ShellBase
{
    override void PB_SetAmmoSprite()
    {
        sprite = GetSpriteIndex("ZCG5A0");
    }
}

class PBX_CSSG_DanmakuShell : PBX_CSSG_ShellBase
{
    override void PB_SetAmmoSprite()
    {
        sprite = GetSpriteIndex("ZCG4A0");
    }
}

class PBX_CSSG_SubZeroShell : PBX_CSSG_ShellBase
{
    override void PB_SetAmmoSprite()
    {
        sprite = GetSpriteIndex("ZCG3A0");
    }
}