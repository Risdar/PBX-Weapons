enum PBXWeapons_eWeaponTipFlags
{
    // SLOT 2
    PBX_TIP_PLASMABLASTER       = 1 << 0,
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
    PBX_TIP_MASTERMINDCG        = 1 << 12,
    // SLOT 7
    PBX_TIP_BDPRAILGUN          = 1 << 13,
    // SLOT 9
    PBX_TIP_DEMONMINIGUN        = 1 << 14,
    PBX_TIP_DEMONEXT            = 1 << 15,
    // UPGRADES
    PBX_TIP_METALSNIPER_UPGRADE = 1 << 0,
    PBX_TIP_BATTLERIFLE_UPGRADE = 1 << 1,
    PBX_TIP_CROSSBOW_UPGRADE    = 1 << 2,
    PBX_TIP_CSSG_UPGRADE        = 1 << 3
}

class PBXWeapons_TipsManager : PBXCore_TipsManager
{
	override bool HandlePickup(Inventory item)
	{
		string weaponHelpCvar = "PBXWeapons_WeaponHelpFlags";
		string upgradeHelpCvar = "PBXWeapons_UpgradeHelpFlags";

        switch(item.getClassName())
        {
            default:
                break;

            // SLOT 2
            case 'PBX_PlasmaBlaster':
            {
                Array<String> tips;
                tips.Push("$PBX_PlasmaBlaster_Tip1");
                tips.Push("$PBX_PlasmaBlaster_Tip2");
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_PLASMABLASTER);
            }
            break;

            case 'PBX_Prosurv_LeverAction':
            {
                Array<String> tips;
                tips.Push("$PBX_LeverAction_Tip1");
                tips.Push("$PBX_LeverAction_Tip2");
                tips.Push("$PBX_LeverAction_Tip3");
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_LEVERACTION);
            }
            break;
            
            // SLOT 3
            case 'PBX_CSSG':
            {
                Array<String> tips;
                tips.Push("$PBX_CSSG_Tip1");
                tips.Push("$PBX_CSSG_Tip2");
                tips.Push("$PBX_CSSG_Tip3");
                tips.Push("$PBX_DisableUpgrade");
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_CSSG);
            }
            break;

            // SLOT 4
            case 'PBX_BDPBattleRifle':
            {
                Array<String> tips;
                tips.Push("$PBX_BattleRifle_Tip1");
                tips.Push("$PBX_BattleRifle_Tip2");
                tips.Push("$PBX_BattleRifle_Tip3");
                tips.Push("$PBX_DisableUpgrade");
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_BATTLERIFLE);
            }
            break;
            
            case 'PBX_MetalSniper':
            {
                Array<String> tips;
                tips.Push("$PBX_MetalSniper_Tip1");
                tips.Push("$PBX_MetalSniper_Tip2");
                tips.Push("$PBX_MetalSniper_Tip3");
                tips.Push("$PBX_MetalSniper_Tip4");
                tips.Push("$PBX_MetalSniper_Tip5");
                tips.Push("$PBX_DisableUpgrade");
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
                tips.Push("$PBX_DisableUpgrade");
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_CROSSBOW);
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
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_EXCAVATOR);
            }
            break;
            case 'PBX_CyberdemonRL':
            {
                Array<String> tips;
                tips.Push("$PBX_MonsterWeapon1");
                tips.Push("$PBX_MonsterWeapon2");
                tips.Push("$PBX_CyberRL_Tip1");
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_CYBERDEMONRL);
            }
            break;
            case 'PBX_MastermindChaingun':
            {
                Array<String> tips;
                tips.Push("$PBX_MonsterWeapon1");
                tips.Push("$PBX_MonsterWeapon2");
                tips.Push("$PBX_MastermindCG_Tip1");
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, weaponHelpCvar, PBX_TIP_MASTERMINDCG);
            }
            break;

            // SLOT 7
            case 'PBX_BDPRailgun':
            {
                Array<String> tips;
                tips.Push("$PBX_BDPRailgun_Tip1");
                tips.Push("$PBX_BDPRailgun_Tip2");
                tips.Push("$PBX_BDPRailgun_Tip3");
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

            // UPGRADES
            case 'ResonanceAmmo_Upgrade':
            {
                Array<String> tips;
                tips.Push("$PBX_MetalSniperUpgrade_Tip1");
                tips.Push("$PBX_MetalSniperUpgrade_Tip2");
                tips.Push("$PBX_MetalSniperUpgrade_Tip3");
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, upgradeHelpCvar, PBX_TIP_METALSNIPER_UPGRADE);
            }
            break;
            case 'BattleRifle_Upgrade':
            {
                Array<String> tips;
                tips.Push("$PBX_BattleRifleUpgrade_Tip1");
                tips.Push("$PBX_BattleRifleUpgrade_Tip2");
                tips.Push("$PBX_BattleRifleUpgrade_Tip3");
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, upgradeHelpCvar, PBX_TIP_BATTLERIFLE_UPGRADE);
            }
            break;
            case 'PBX_DemonicBallistaUpgrade':
            {
                Array<String> tips;
                tips.Push("$PBX_DemonicBallista_Tip1");
                tips.Push("$PBX_DemonicBallista_Tip2");
                tips.Push("$PBX_DemonicBallista_Tip3");
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, upgradeHelpCvar, PBX_TIP_CROSSBOW_UPGRADE);
            }
            break;
            case 'SubZeroShellsUpgrade': case 'ExplosiveShellsUpgrade': case 'WPShellsUpgrade':
            case 'DoomShellsUpgrade':    case 'DanmakuShellsUpgrade':
            {
                Array<String> tips;
                tips.Push("$PBX_CSSGUpgrade_Tip1");
                tips.Push("$PBX_CSSGUpgrade_Tip2");
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips, upgradeHelpCvar, PBX_TIP_CSSG_UPGRADE);
            }
            break;
        }

		return super.HandlePickup(item);
	}
}