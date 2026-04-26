enum PBX_eWeaponTipFlags
{
    // SLOT 2
    PBX_TIP_BLASTERPISTOL       = 1 << 0,
    PBX_TIP_LEVERACTION         = 1 << 1,
    // SLOT 3
    PBX_TIP_CSSG                = 1 << 2,
    PBX_TIP_HASG                = 1 << 3,
    // SLOT 4
    PBX_TIP_BATTLERIFLE         = 1 << 4,
    PBX_TIP_METALSNIPER         = 1 << 5,
    PBX_TIP_CROSSBOW            = 1 << 6,
    PBX_TIP_M41A                = 1 << 7,
    // SLOT 5 
    PBX_TIP_NEOHMG              = 1 << 8,
    // SLOT 6
    PBX_TIP_HGL                 = 1 << 9,
    PBX_TIP_EXCAVATOR           = 1 << 10,
    PBX_TIP_CYBERDEMONRL        = 1 << 11,
    // SLOT 9
    PBX_TIP_DEMONMINIGUN        = 1 << 12,
    PBX_TIP_DEMONEXT            = 1 << 13

}

enum PBX_eWeaponUpgradeTipFlags
{
    PBX_TIP_METALSNIPER_UPGRADE = 1 << 0
}

class PBX_TipsManager : inventory
{
	Default
	{
		// These are just some useful values for an inventory token
		// that make sure it can't be taken away or dropped:
		inventory.maxamount 1;
		+INVENTORY.UNDROPPABLE
		+INVENTORY.UNTOSSABLE
		+INVENTORY.PERSISTENTPOWER
	}

	private void SendTipArrayIfNeeded(Array<String> tipStrings, string cvarName, int tipFlag)
	{
		if(!PB_HelpNotificationsHandler.CheckTipEvent(tipFlag, CVar.GetCvar(cvarName)))
		{
			PB_HelpNotificationsHandler.PB_SendTipArray(tipStrings, cvarName, tipFlag);
		}
	}

	override bool HandlePickup(Inventory item)
	{
		string weaponHelpCvar = "PBX_WeaponHelpFlags";
		string upgradeHelpCvar = "PBX_UpgradeHelpFlags";

        switch(item.getClassName())
        {
            default:
                break;

            // SLOT 2
            case 'PBX_Prosurv_LeverAction':
            {
                Array<String> tips;
                tips.Push("$PBX_LeverAction_Tip1");
                tips.Push("$PBX_LeverAction_Tip2");
                tips.Push("$PBX_LeverAction_Tip3");
                SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_LEVERACTION);
            }
            break;

            // SLOT 3
            case 'PBX_CSSG':
            {
                Array<String> tips;
                tips.Push("$PBX_CSSG_Tip1");
                tips.Push("$PBX_CSSG_Tip2");
                tips.Push("$PBX_DisableUpgrade");
                SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_CSSG);
            }
            break;

            // SLOT 4
            case 'PBX_MetalSniper':
            {
                Array<String> tips;
                tips.Push("$PBX_MetalSniper_Tip1");
                tips.Push("$PBX_MetalSniper_Tip2");
                tips.Push("$PBX_MetalSniper_Tip3");
                tips.Push("$PBX_MetalSniper_Tip4");
                tips.Push("$PBX_DisableUpgrade");
                SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_METALSNIPER);
            }
            break;

            // SLOT 5
            case 'PBX_NeoHMG':
            {
                Array<String> tips;
                tips.Push("$PBX_NeoHMG_Tip1");
                tips.Push("$PBX_NeoHMG_Tip2");
                tips.Push("$PBX_NeoHMG_Tip3");
                tips.Push("$PBX_NeoHMG_Tip4");
                SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_NEOHMG);
            }
            break;

            // SLOT 9
            case 'PBX_DemonExt':
            {
                Array<String> tips;
                tips.Push("$PBX_DemonExt_Tip1");
                tips.Push("$PBX_DemonExt_Tip2");
                SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_DEMONEXT);
            }
            break;

            // UPGRADES
            case 'ResonanceAmmo_Upgrade':
            {
                Array<String> tips;
                tips.Push("$PBX_MetalSniperUpgrade_Tip1");
                tips.Push("$PBX_MetalSniperUpgrade_Tip2");
                tips.Push("$PBX_MetalSniperUpgrade_Tip3");
                SendTipArrayIfNeeded(tips, upgradeHelpCvar, PBX_TIP_METALSNIPER_UPGRADE);
            }
            break;
        }

		return super.HandlePickup(item);
	}
}