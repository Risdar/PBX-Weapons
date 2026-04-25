enum ePBX_WeaponTipFlags
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

enum ePBX_WeaponUpgradeTipFlags
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
	
	override bool HandlePickup(Inventory item)
	{
        switch(item.getClassName())
        {
            default:
                break;

            // SLOT 2
            case 'PBX_Prosurv_LeverAction':
                if(!PB_HelpNotificationsHandler.CheckTipEvent(PBX_TIP_LEVERACTION, CVar.GetCvar("PBX_WeaponHelpFlags")))
                {
                    Array<String> leveractionPickup;
                    leveractionPickup.Push("$PBX_LeverAction_Tip1");
                    leveractionPickup.Push("$PBX_LeverAction_Tip2");
                    leveractionPickup.Push("$PBX_LeverAction_Tip3");
                    PB_HelpNotificationsHandler.PB_SendTipArray(leveractionPickup, "PBX_WeaponHelpFlags", PBX_TIP_LEVERACTION);
                }
                break;
            // SLOT 3
            case 'PBX_CSSG':
                if(!PB_HelpNotificationsHandler.CheckTipEvent(PBX_TIP_CSSG, CVar.GetCvar("PBX_WeaponHelpFlags")))
                {
                    Array<String> cssgPickup;
                    cssgPickup.Push("$PBX_CSSG_Tip1");
                    cssgPickup.Push("$PBX_CSSG_Tip2");
                    cssgPickup.Push("$PBX_DisableUpgrade");
                    PB_HelpNotificationsHandler.PB_SendTipArray(cssgPickup, "PBX_WeaponHelpFlags", PBX_TIP_CSSG);
                }
                break;
            // SLOT 4
            case 'PBX_MetalSniper':
                if(!PB_HelpNotificationsHandler.CheckTipEvent(PBX_TIP_METALSNIPER, CVar.GetCvar("PBX_WeaponHelpFlags")))
                {
                    Array<String> metalSniperPickup;
                    metalSniperPickup.Push("$PBX_MetalSniper_Tip1");
                    metalSniperPickup.Push("$PBX_MetalSniper_Tip2");
                    metalSniperPickup.Push("$PBX_MetalSniper_Tip3");
                    metalSniperPickup.Push("$PBX_MetalSniper_Tip4");
                    metalSniperPickup.Push("$PBX_DisableUpgrade");
                    PB_HelpNotificationsHandler.PB_SendTipArray(metalSniperPickup, "PBX_WeaponHelpFlags", PBX_TIP_METALSNIPER);
                }
                break;
            // SLOT 5
            case 'PBX_NeoHMG':
                if(!PB_HelpNotificationsHandler.CheckTipEvent(PBX_TIP_NEOHMG, CVar.GetCvar("PBX_WeaponHelpFlags")))
                {
                    Array<String> neoHmgPickup;
                    neoHmgPickup.Push("$PBX_NeoHMG_Tip1");
                    neoHmgPickup.Push("$PBX_NeoHMG_Tip2");
                    neoHmgPickup.Push("$PBX_NeoHMG_Tip3");
                    neoHmgPickup.Push("$PBX_NeoHMG_Tip4");
                    PB_HelpNotificationsHandler.PB_SendTipArray(neoHmgPickup, "PBX_WeaponHelpFlags", PBX_TIP_NEOHMG);
                }
                break;
            // SLOT 9
            case 'PBX_DemonExt':
                if(!PB_HelpNotificationsHandler.CheckTipEvent(PBX_TIP_DEMONEXT, CVar.GetCvar("PBX_WeaponHelpFlags")))
                {
                    Array<String> demonExtPickup;
                    demonExtPickup.Push("$PBX_DemonExt_Tip1");
                    demonExtPickup.Push("$PBX_DemonExt_Tip2");
                    PB_HelpNotificationsHandler.PB_SendTipArray(demonExtPickup, "PBX_WeaponHelpFlags", PBX_TIP_DEMONEXT);
                }
                break;
            // UPGRADES
            case 'ResonanceAmmo_Upgrade':
                if(!PB_HelpNotificationsHandler.CheckTipEvent(PBX_TIP_METALSNIPER_UPGRADE, CVar.GetCvar("PBX_UpgradeHelpFlags")))
                {
                    Array<String> metalsniperUpgradePickup;
                    metalsniperUpgradePickup.Push("$PBX_MetalSniperUpgrade_Tip1");
                    metalsniperUpgradePickup.Push("$PBX_MetalSniperUpgrade_Tip2");
                    metalsniperUpgradePickup.Push("$PBX_MetalSniperUpgrade_Tip3");
                    PB_HelpNotificationsHandler.PB_SendTipArray(metalsniperUpgradePickup, "PBX_UpgradeHelpFlags", PBX_TIP_METALSNIPER_UPGRADE);
                }
                break;
        }
		
		//otherwise do what should normally be done 
		return super.HandlePickup(item);
	}
}