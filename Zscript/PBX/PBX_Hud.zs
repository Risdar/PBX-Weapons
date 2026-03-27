enum PBX_eHudSettingFlags{
    DisablePBX_WeaponHud				= 1 << 0,
    DisablePBX_WeaponModeHud			= 1 << 1
}

class PBX_Hud : PB_Hud_ZS
{
    double visorScale;
    int pbx_weapon_PosX, pbx_weapon_PosY, pbx_weaponmode_PosX, pbx_weaponmode_PosY;
    double pbx_weaponmode_hudscale, pbx_weapon_hudscale;
    Vector2 pbx_weapon_pos, pbx_weapon_truescale;
    Vector2 pbx_weaponmode_pos, pbx_weaponmode_truescale;
    int flagsleft, flagsright;

    // In case I forgot
    // weap = CPlayer.ReadyWeapon;
	// pbWeap = PB_WeaponBase(weap);
    // PlayerPawn plr;

    override void Draw(int state, double TicFrac)
    {
		Super.Draw(state, TicFrac);

        if(menuactive || consolestate == c_up) 
            gatherPBXCVARs();

        if(hudState != HUD_None)
		{
            DrawPBXHud();
		}
    }

    void gatherPBXCVARs()
    {
        pbx_weapon_PosX = CVar.GetCVar("pbx_Weaponhud_x", CPlayer).GetInt();
        pbx_weapon_PosY = CVar.GetCVar("pbx_Weaponhud_y", CPlayer).GetInt();
        pbx_weapon_hudscale = CVar.GetCVar("pbx_Weaponhud_scale", CPlayer).GetFloat();

        pbx_weapon_pos = (pbx_weapon_PosX, pbx_weapon_PosY);
        pbx_weapon_truescale = (pbx_weapon_hudscale, pbx_weapon_hudscale);

        pbx_weaponmode_PosX = CVar.GetCVar("pbx_WeaponModehud_x", CPlayer).GetInt();
        pbx_weaponmode_PosY = CVar.GetCVar("pbx_WeaponModehud_y", CPlayer).GetInt();
        pbx_weaponmode_hudscale = CVar.GetCVar("pbx_WeaponModehud_scale", CPlayer).GetFloat();

        pbx_weaponmode_pos = (pbx_weaponmode_PosX, pbx_weaponmode_PosY);
        pbx_weaponmode_truescale = (pbx_weaponmode_hudscale, pbx_weaponmode_hudscale);
        
        flagsleft = DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM;
        flagsright = DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM;

    }

    void DrawPBXWeaponMode()
    {
        if(pbx_hudsetting_filter & DisablePBX_WeaponModeHud) return;
        if (!pbWeap) return;

        switch(pbWeap.GetClassName())
        {
            case 'PBX_MetalSniper':
                let sniper = PBX_MetalSniper(pbWeap);
                // Show Rocket Ammo if Grenade Secondary Mode is Selected
                if (sniper && sniper.AltMode) 
                {
                    PBHud_DrawImage("BARBACR3", (-90, -71), flagsright, playerBoxAlpha);
                    PBHud_DrawBar("ABAR4", "BGBARL", GetAmount("PB_RocketAmmo"), GetMaxAmount("PB_RocketAmmo"), (-100, -72), 0, 1, flagsright);
                    PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("PB_RocketAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_RED);
                }
                // Show what Ammo type is selected
                string image = sniper && sniper.resonanceAmmoLoaded ? "graphics/weapon wheel/metalsniper/ResonanceAlt.png" : "graphics/weapon wheel/metalsniper/StandardAlt.png";
                PBHud_DrawImage(image, pbx_weaponmode_pos, flagsright, playerBoxAlpha, scale: pbx_weaponmode_truescale);
                break;

            case 'PBX_CSSG':
                let cssg = PBX_CSSG(pbWeap);
                if (cssg) 
                {
                    static const string cssgIcons[] = {
                        "buckhud", "slughud", "flcthud", "flakhud", "drgnhud", 
                        "explhud", "phoshud", "doomhud", "dnmkhud"
                    };
                    
                    // Show what Ammo type is selected
                    int m = clamp(cssg.shellsmode, 0, cssgIcons.Size() - 1);
                    PBHud_DrawImage(cssgIcons[m], pbx_weaponmode_pos, flagsright, playerBoxAlpha, scale: pbx_weaponmode_truescale);
                }
                break;

            // PB WEAPONS
            case 'PB_Shotgun':

                bool hasSlug = PBX_PlayerHasInventory("HasSlugs");
                bool hasDragonBr = PBX_PlayerHasInventory("HasDragonBreath");
                bool hasBuck = PBX_PlayerHasInventory("HasBuckShot");
                name icon;
                
                if (!hasDragonBr && hasSlug && !hasBuck) {
                    icon = "slughud";
                } else if (hasDragonBr && !hasSlug && !hasBuck) {
                    icon = "drgnhud";
                } else if (!hasDragonBr && !hasSlug && hasBuck) {
                    icon = "buckhud";
                }
                PBHud_DrawImage(icon, pbx_weaponmode_pos, flagsright, playerBoxAlpha, scale: pbx_weaponmode_truescale);

                break;
        }
    }

    void DrawPBXWeapon()
    {
        if(pbx_hudsetting_filter & DisablePBX_WeaponHud) return;
        if (!pbWeap) return;

        static const string exceptionWeapons[] = {
            "PB_Shotgun", "PB_SMG", "PB_Flamethrower", "PB_Minigun"
        };

        string weaponClass = pbWeap.GetClassName();
        for (int i = 0; i < exceptionWeapons.Size(); i++)
        {
            if (weaponClass == exceptionWeapons[i])
            {
                return; // do not draw HUD for these weapons
            }
        }

        TextureID iconID = pbWeap.AltHudIcon.IsValid() ? pbWeap.AltHudIcon : pbWeap.Icon;

        if (iconID.IsValid())
        {
            PBHud_DrawImage(TexMan.GetName(iconID), pbx_weapon_pos, flagsright, playerBoxAlpha, scale: pbx_weapon_truescale);
        }
    }

    void DrawPBXManualWeapon()
    {
        if(pbx_hudsetting_filter & DisablePBX_WeaponHud) return;
        if (!pbWeap) return;

        TextureID iconID = pbWeap.AltHudIcon.IsValid() ? pbWeap.AltHudIcon : pbWeap.Icon;
        string icon = TexMan.GetName(iconID);
        bool isAkimbo = pbWeap.akimboMode;
        string image;
        
        switch(pbWeap.GetClassName())
        {
            case 'PB_Shotgun':
                // If Upgraded
                image = PBX_PlayerHasInventory("PumpshotgunMagazine") ? "9SMUA0" : icon;
                PBHud_DrawImage(image, pbx_weapon_pos, flagsright, playerBoxAlpha, scale: pbx_weapon_truescale);
                break;

            case 'PB_Flamethrower':
                image = PBX_PlayerHasInventory("FlamerUpgraded"); ? "FSPWB0" : "FSPWA0";
                Vector2 posFlamer = PBX_PlayerHasInventory("FlamerUpgraded"); ? pbx_weapon_pos + (0, 30) : pbx_weapon_pos; // Adjust Here
                PBHud_DrawImage(image, posFlamer, flagsright, playerBoxAlpha, scale: pbx_weapon_truescale);
                break;

            case 'PB_SMG':
                // Get Variables
                bool isSilenced = PBX_PlayerHasInventory("SilencedSMG");

                // Positions
                Vector2 posSMG = isAkimbo ? pbx_weapon_pos + (-10, -15) : pbx_weapon_pos; // Adjust Here
                // Magic
                string img = isAkimbo ? 
                    // If Akimbo
                    (isSilenced ? "graphics/pywheel/SMG/SMG_DUAL_SUPPRESSED.png" : "graphics/pywheel/SMG/SMG_DUAL.png") :
                    // If Not Akimbo
                    (isSilenced ? "ATFLA0" : "ATFLB0");
                PBHud_DrawImage(img, posSMG, flagsright, playerBoxAlpha, scale: pbx_weapon_truescale);
                break;

            case 'PB_Minigun':
                image = PBX_PlayerHasInventory("TripleBarrelMode") ? "8GUNA0" : icon;
                PBHud_DrawImage(image, pbx_weapon_pos + (0, 30), flagsright, playerBoxAlpha, scale: pbx_weapon_truescale);
                break;
            // case 'PB_DMR':
            //     bool isUpgraded = PBX_PlayerHasInventory("DMRUpgraded");

            //     Vector2 posDMR = isAkimbo ? pbx_weapon_pos + (-10, -15) : pbx_weapon_pos; // Adjust Here
            //     string img = isAkimbo ? 
            //         // If Akimbo
            //         (isUpgraded ? "graphics/pywheel/SMG/SMG_DUAL_SUPPRESSED.png" : "graphics/pywheel/SMG/SMG_DUAL.png") :
            //         // If Not Akimbo
            //         (isUpgraded ? "ATFLA0" : "ATFLB0");
            //     PBHud_DrawImage(img, posDMR, flagsright, playerBoxAlpha, scale: pbx_weapon_truescale);
            //     break;
        }
    }

    bool PBX_PlayerHasInventory(name inventory)
    {
        return PlayerPawn(CPlayer.mo).CountInv(inventory) > 0;
    }

    void DrawPBXHud()
    {
        let plr = PlayerPawn(CPlayer.mo);
        if(!plr) return;
        if(!weap) return;
        DrawPBXWeaponMode();
        DrawPBXWeapon();
        DrawPBXManualWeapon();
    }
}