enum PBXWeapons_eWeaponTipFlags
{
    // SLOT 2
    PBX_TIP_PLASMABLASTER       = 1 << 0,
    PBX_TIP_LEVERACTION         = 1 << 1,
    // SLOT 3
    PBX_TIP_CSSG                = 1 << 2,
    PBX_TIP_PSG                 = 1 << 3,
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
    PBX_TIP_MASTERMINDCG        = 1 << 12,
    PBX_TIP_PAINGIVER           = 1 << 13,
    // SLOT 7
    PBX_TIP_BDPRAILGUN          = 1 << 14,
    // SLOT 9
    PBX_TIP_DEMONMINIGUN        = 1 << 15,
    PBX_TIP_DEMONEXT            = 1 << 16,
    // OTHERS
    PBX_TIP_COMMANDERWEAPON     = 1 << 29,
    PBX_TIP_MONSTERWEAPON       = 1 << 30,
    PBX_TIP_DEMONICWEAPON       = 1 << 31
}

class PBXWeapons_TipsManager : PBXCore_TipsManager
{
    string weaponHelpCvar;

	override bool HandlePickup(Inventory item)
	{
        bool returnValue = super.HandlePickup(item);
        if(!pbxweapons_sendTip) return returnValue;

        weaponHelpCvar = "PBXWeapons_WeaponHelpFlags";

        switch(item.getClassName())
        {
            default:
                break;

            // SLOT 2
            case 'PBX_PlasmaBlaster':
            {
                Array<String> tips;
                tips.Push("$PBX_PlasmaBlaster_Tip1");
                tips.Push(string.format(StringTable.Localize("$PBX_PlasmaBlaster_Tip2"),PB_HelpNotificationsHandler.PB_FormatKeybinds("+pb_specialwheel")));
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_PLASMABLASTER);
            }
            break;

            case 'PBX_Prosurv_LeverAction':
            {
                Array<String> tips;
                tips.Push("$PBX_LeverAction_Tip1");
                tips.Push(string.format(StringTable.Localize("$PBX_LeverAction_Tip2"),PBX_Prosurv_LeverAction.MAGAZINE_SIZE/2));
                tips.Push(string.format(StringTable.Localize("$PBX_LeverAction_Tip3"),PBX_Prosurv_LeverAction.MAGAZINE_SIZE));
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_LEVERACTION);
            }
            break;
            
            // SLOT 3
            case 'PBX_CSSG':
            {
                Array<String> tips;
                TryGiveSpecialTip(COMMANDER_WEAPON);
                tips.Push("$PBX_CSSG_Tip1");
                tips.Push("$PBX_CSSG_Tip2");
                tips.Push(string.format(StringTable.Localize("$PBX_CSSG_Tip3"),PB_HelpNotificationsHandler.PB_FormatKeybinds("+pb_specialwheel")));
                TryGiveSpecialTip(DISABLE_UPGRADE);
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_CSSG);
            }
            break;

            case 'PBX_ProSurvPSG':
            {
                Array<String> tips;
                TryGiveSpecialTip(COMMANDER_WEAPON);
                tips.Push("$PBX_PSG_Tip1");
                tips.Push(string.format(
                    StringTable.Localize("$PBX_PSG_Tip2"),
                    PBX_ProSurvPSG.TRIPMINE_TAKE,
                    PBX_ProSurvPSG.LASERCHARGE_TAKE,
                    PBX_ProSurvPSG.ACIDCHARGE_TAKE,
                    PBX_ProSurvPSG.SWARMCHARGE_TAKE
                ));
                tips.Push(string.format(StringTable.Localize("$PBX_PSG_Tip3"),PB_HelpNotificationsHandler.PB_FormatKeybinds("+pb_specialwheel")));
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_PSG);
            }
            break;

            // SLOT 4
            case 'PBX_BDPBattleRifle':
            {
                Array<String> tips;
                tips.Push(string.format(StringTable.Localize("$PBX_BattleRifle_Tip1"),PB_HelpNotificationsHandler.PB_FormatKeybinds("+pb_specialwheel")));
                tips.Push("$PBX_BattleRifle_Tip2");
                TryGiveSpecialTip(DISABLE_UPGRADE);
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_BATTLERIFLE);
            }
            break;
            
            case 'PBX_MetalSniper':
            {
                Array<String> tips;
                tips.Push("$PBX_MetalSniper_Tip1");
                tips.Push(string.format(StringTable.Localize("$PBX_MetalSniper_Tip2"),PB_HelpNotificationsHandler.PB_FormatKeybinds("+ALTATTACK"), PB_HelpNotificationsHandler.PB_FormatKeybinds("+ATTACK")));
                tips.Push(string.format(StringTable.Localize("$PBX_MetalSniper_Tip3"),PB_HelpNotificationsHandler.PB_FormatKeybinds("+pb_specialwheel")));
                tips.Push("$PBX_MetalSniper_Tip4");
                TryGiveSpecialTip(DISABLE_UPGRADE);
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_METALSNIPER);
            }
            break;

            case 'PBX_Prosurv_Ballista':
            {
                Array<String> tips;
                tips.Push("$PBX_ProsurvBallista_Tip1");
                tips.Push("$PBX_ProsurvBallista_Tip2");
                tips.Push("$PBX_ProsurvBallista_Tip3");
                tips.Push("$PBX_ProsurvBallista_Tip4");
                TryGiveSpecialTip(DISABLE_UPGRADE);
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_CROSSBOW);
            }
            break;

            // SLOT 5
            case 'PBX_NeoHMG':
            {
                Array<String> tips;
                tips.Push("$PBX_NeoHMG_Tip1");
                tips.Push(string.format(StringTable.Localize("$PBX_NeoHMG_Tip2"),PBX_NeoHMG.OVERHEAT_THRESHOLD));
                tips.Push(string.format(StringTable.Localize("$PBX_NeoHMG_Tip3"),PB_HelpNotificationsHandler.PB_FormatKeybinds("+pb_specialwheel")));
                tips.Push(string.format(StringTable.Localize("$PBX_NeoHMG_Tip4"),PB_HelpNotificationsHandler.PB_FormatKeybinds("+ALTATTACK")));
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_NEOHMG);
            }
            break;

            // SLOT 6
            case 'PBX_Excavator':
            {
                Array<String> tips;
                tips.Push("$PBX_Excavator_Tip1");
                tips.Push("$PBX_Excavator_Tip2");
                tips.Push("$PBX_Excavator_Tip3");
                tips.Push(string.format(StringTable.Localize("$PBX_Excavator_Tip4"),PB_HelpNotificationsHandler.PB_FormatKeybinds("+ALTATTACK")));
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_EXCAVATOR);
            }
            break;
            case 'PBX_CyberdemonRL':
            {
                TryGiveSpecialTip(MONSTER_WEAPON);
                Array<String> tips;
                tips.Push("$PBX_CyberRL_Tip1");
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_CYBERDEMONRL);
            }
            break;
            case 'PBX_MastermindChaingun':
            {
                TryGiveSpecialTip(MONSTER_WEAPON);
                Array<String> tips;
                tips.Push("$PBX_MastermindCG_Tip1");
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_MASTERMINDCG);
            }
            break;
            case 'PBX_Paingiver':
            {
                TryGiveSpecialTip(DEMONIC_WEAPON);
                Array<String> tips;
                tips.Push("$PBX_Paingiver_Tip1");
                tips.Push("$PBX_Paingiver_Tip2");
                tips.Push(string.format(StringTable.Localize("$PBX_Paingiver_Tip3"),PB_HelpNotificationsHandler.PB_FormatKeybinds("+pb_specialwheel")));
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_MASTERMINDCG);
            }
            break;

            // SLOT 7
            case 'PBX_BDPRailgun':
            {
                Array<String> tips;
                tips.Push("$PBX_BDPRailgun_Tip1");
                tips.Push("$PBX_BDPRailgun_Tip2");
                tips.Push(string.format(StringTable.Localize("$PBX_BDPRailgun_Tip3"),PB_HelpNotificationsHandler.PB_FormatKeybinds("+pb_specialwheel")));
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_BDPRAILGUN);
            }
            break;

            // SLOT 9
            case 'PBX_DemonExt':
            {
                Array<String> tips;
                tips.Push("$PBX_DemonExt_Tip1");
                tips.Push("$PBX_DemonExt_Tip2");
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_DEMONEXT);
            }
            break;
        }
		return returnValue;
	}

    enum PBXWeapons_SpecialTip
    {
        MONSTER_WEAPON,
        DEMONIC_WEAPON,
        COMMANDER_WEAPON,
        DISABLE_UPGRADE
    }

    void TryGiveSpecialTip(PBXWeapons_SpecialTip whatToSend)
    {
        switch(whatToSend)
        {
            case MONSTER_WEAPON:
            {
                Array<String> tips;
                tips.Push("$PBX_MonsterWeapon1");
                tips.Push("$PBX_MonsterWeapon2");
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_MONSTERWEAPON);
            }
            break;

            case DEMONIC_WEAPON:
            {
                Array<String> tips;
                tips.Push("$PBX_DemonicWeapon1");
                tips.Push("$PBX_DemonicWeapon2");
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_DEMONICWEAPON);
            }
            break;

            case COMMANDER_WEAPON:
            {
                Array<String> tips;
                tips.Push("$PBX_CommanderWeapon1");
                tips.Push("$PBX_CommanderWeapon2");
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_COMMANDERWEAPON);
            }
            break;

            case DISABLE_UPGRADE:
            {
                Array<String> tips;
                tips.Push("$PBX_DisableUpgrade");
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, "PBXWeapons_UpgradeHelpFlags", PBX_TIP_DISABLE_UPGRADE);
            }
            break;
        }
    }
}