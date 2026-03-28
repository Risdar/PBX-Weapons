enum PBX_eHudSettingFlags{
    DisablePBX_WeaponHud				= 1 << 0,
    DisablePBX_WeaponModeHud			= 1 << 1
}

class PBX_Hud : PB_Hud_ZS
{
    // Set Variables
    int pbx_weapon_PosX, pbx_weapon_PosY, pbx_weaponmode_PosX, pbx_weaponmode_PosY;
    double pbx_weaponmode_hudscale, pbx_weapon_hudscale;
    Vector2 pbx_weapon_pos, pbx_weapon_truescale;
    Vector2 pbx_weapon_pos2, pbx_weapon_truescale2;
    int flagsleft, flagsright;

    string pbx_image, pbx_image2;
    bool isAkimbo;

    // In case I forgot
    // weap = CPlayer.ReadyWeapon;
	// pbWeap = PB_WeaponBase(weap);
    // PlayerPawn plr;

    // What The Engine Draws
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

    // GET THE HUD POSITION FROM THE SETTINGS
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

        pbx_weapon_pos2 = (pbx_weaponmode_PosX, pbx_weaponmode_PosY);
        pbx_weapon_truescale2 = (pbx_weaponmode_hudscale, pbx_weaponmode_hudscale);
        
        flagsleft = DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM;
        flagsright = DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM;

    }

    // ADJUST SPECIFIC WEAPON POSITION AND SCALE HERE
    void weaponAdjustments()
    {
        // Set defaults 
        vector2 adjustPos,adjustPos2 = (0,0);
        double adjustScale = 1.0;
        double adjustScale2 = 1.0;
        isAkimbo = pbWeap.akimboMode;

        // ADD ADJUSTMENTS HERE
        // WEAPON PICKUP SPRITE ADJUSTMENT
        switch(pbWeap.GetClassName())
            {
                // PBX WEAPONS
                case 'PBX_Prosurv_LeverAction':
                    adjustScale = 0.7;
                    break;
                case 'PBX_BDPBattleRifle':
                    adjustScale = 1.3;
                    break;
                case 'PBX_MetalSniper':
                    let sniper = PBX_MetalSniper(pbWeap);
                    if(sniper && sniper.AltMode)
                        adjustPos = (0, -15); 
                    break;

                // PB WEAPONS
                case 'PB_MG42':
                    adjustScale = 0.5;
                    break;
                case 'PB_MP40':
                    adjustScale = 0.7;
                    break;
                case 'PB_Flamethrower':
                    adjustPos = PBX_PlayerHasInventory("FlamerUpgraded") ? (0, 30) : (-5,0); 
                    break;
                case 'PB_SMG':
                    adjustPos = isAkimbo ? (-10, -15) : (-10,0); 
                    break;
                case 'PB_Pistol':
                    adjustPos = isAkimbo ? (-10, -15) : adjustPos; 
                    break;
                case 'PB_Minigun':
                    adjustPos = PBX_PlayerHasInventory("TripleBarrelMode") ? (0,30) : (0,10);
                    break;
                case 'PB_Carbine':
                    adjustPos = isAkimbo ? (-10, -15) : (-5,0);
                    break;
                default:
                    break;
            }
        // WEAPON MODE ADJUSTMENT
        switch(pbWeap.GetClassName())
            {
                // PBX WEAPONS
                case 'PBX_MetalSniper':
                    // adjustPos2 = (0, 0); 
                    adjustScale2 = 0.7;
                    break;
                default:
                    break;
            }
            
        // Send the Values
        pbx_weapon_pos += adjustPos;
        pbx_weapon_truescale *= adjustScale;
        pbx_weapon_pos2 += adjustPos2;
        pbx_weapon_truescale2 *= adjustScale2;
    }

    // DRAW THE WEAPON MODES
    void DrawPBXWeaponMode()
    {
        // Standard check
        if(pbx_hudsetting_filter & DisablePBX_WeaponModeHud) return;
        if (!pbWeap) return;

        // ADD WEAPON MODES HERE
        switch(pbWeap.GetClassName())
        {
            // PBX WEAPONS
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
                pbx_image2 = sniper && sniper.resonanceAmmoLoaded ? "graphics/weapon wheel/metalsniper/ResonanceAlt.png" : "graphics/weapon wheel/metalsniper/StandardAlt.png";
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
                    pbx_image2 = cssgIcons[m];
                }
                break;

            // PB WEAPONS
            case 'PB_Shotgun':
                let shotgun = PB_Shotgun(pbWeap);
                // Show what Ammo type is selected
                if(shotgun)
                {
                    switch(shotgun.shellsmode)
                    {
                        case 1:
                            pbx_image2 = "buckhud";
                            break;
                        case 2:
                            pbx_image2 = "slughud";
                            break;
                        case 3:
                            pbx_image2 = "drgnhud";
                            break;
                    }
                }
                break;

            default:
                pbx_image2 = " ";
                break;
        }
        
        // Actually Draw the Thing
        PBX_DrawImage(true);
    }

    // AUTOMATICALLY DRAW THE WEAPONS, ADD EXCEPTIONS HERE IF YOU WANT TO MANUALLY EDIT THEM
    // FOR EXAMPLE IF YOU WANT THEM TO SHOW DIFFERENT SPRITE IF THEY'RE AKIMBO/UPGRADED/ETC.
    // ADJUSTMENTS LIKE SCALE AND POSITION IS HANDLED IN weaponAdjustments() ABOVE
    void DrawPBXWeapon()
    {
        // Standard check
        if(pbx_hudsetting_filter & DisablePBX_WeaponHud) return;
        if (!pbWeap) return;

        // Add exceptions here
        static const string exceptionWeapons[] = {
            "PB_Shotgun", "PB_SMG", "PB_Flamethrower", "PB_Minigun", "PB_Pistol",
            "PB_Carbine"
        };

        // Handle exceptions
        string weaponClass = pbWeap.GetClassName();
        for (int i = 0; i < exceptionWeapons.Size(); i++)
        {
            if (weaponClass == exceptionWeapons[i])
            {
                return; // do not draw HUD for these weapons
            }
        }

        // Use default Icons
        TextureID iconID = pbWeap.AltHudIcon.IsValid() ? pbWeap.AltHudIcon : pbWeap.Icon;
        pbx_image = TexMan.GetName(iconID);

        if (iconID.IsValid())
        {
            PBX_DrawImage();
        }
    }

    // MANUALLY DRAW THE WEAPONS
    void DrawPBXManualWeapon()
    {
        // Standard Check
        if(pbx_hudsetting_filter & DisablePBX_WeaponHud) return;
        if (!pbWeap) return;

        // Set Defaults & Variables
        TextureID iconID = pbWeap.AltHudIcon.IsValid() ? pbWeap.AltHudIcon : pbWeap.Icon;
        string icon = TexMan.GetName(iconID);

        // Add the weapons here
        switch(pbWeap.GetClassName())
        {
            case 'PB_Shotgun':
                // If Upgraded
                pbx_image = PBX_PlayerHasInventory("PumpshotgunMagazine") ? "9SMUA0" : icon;
                break;

            case 'PB_Flamethrower':
                // If Upgraded
                pbx_image = PBX_PlayerHasInventory("FlamerUpgraded") ? "FSPWB0" : "FSPWA0";
                break;

            case 'PB_SMG':
                pbx_image = isAkimbo ? 
                    // If Akimbo ? Suppressed : Non Suppressed
                    (PBX_PlayerHasInventory("SilencedSMG") ? "graphics/pywheel/SMG/SMG_DUAL_SUPPRESSED.png" : "graphics/pywheel/SMG/SMG_DUAL.png") :
                    // If Not Akimbo ? Suppressed : Non Suppressed
                    (PBX_PlayerHasInventory("SilencedSMG") ? "ATFLA0" : "ATFLB0");
                break;

            case 'PB_Pistol':
                pbx_image = isAkimbo ? 
                    // If Akimbo ? Suppressed : Non Suppressed
                    (PBX_PlayerHasInventory("SilencerEquipped") ? "graphics/pywheel/PISTOL_7.png" : "graphics/pywheel/PISTOL_4.png") :
                    // If Not Akimbo ? Suppressed : Non Suppressed
                    (PBX_PlayerHasInventory("SilencerEquipped") ? "graphics/pywheel/PISTOL_1.png" : "graphics/pywheel/PISTOL_0.png");
                break;

            case 'PB_Minigun':
                // If the current mode is the triplebarrel
                pbx_image = PBX_PlayerHasInventory("TripleBarrelMode") ? "8GUNA0" : icon;
                break;

            case 'PB_Carbine':
                // If Akimbo
                pbx_image = isAkimbo ? "graphics/pywheel/Carbine_Dual.png" : icon;
                break;

            default:
                pbx_image = " ";
                break;
        }

        // Actually Draw the Thing
        PBX_DrawImage();
    }

    // THIS IS ALL AUXILLIARY FUNCTIONS JUST TO KEEP THE CODE CLEAN

    // Basically if true then use the 2nd set of values
    void PBX_DrawImage(bool isWeapon2 = false)
    {
        if(!isWeapon2)
            PBHud_DrawImage(pbx_image, pbx_weapon_pos, flagsright, playerBoxAlpha, scale: pbx_weapon_truescale);
        else
            PBHud_DrawImage(pbx_image2, pbx_weapon_pos2, flagsright, playerBoxAlpha, scale: pbx_weapon_truescale2);
    }

    // Check if the player has an inventory item, returns true if yes
    bool PBX_PlayerHasInventory(name inventory)
    {
        return PlayerPawn(CPlayer.mo).CountInv(inventory) > 0;
    }

    // What Actually Draws the HUD
    void DrawPBXHud()
    {
        let plr = PlayerPawn(CPlayer.mo);
        if(!plr) return;
        if(!weap) return;
        weaponAdjustments();
        DrawPBXWeaponMode();
        DrawPBXWeapon();
        DrawPBXManualWeapon();
    }
}