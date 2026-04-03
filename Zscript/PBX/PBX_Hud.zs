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
    Vector2 pbx_weapon_pos3, pbx_weapon_truescale3; // For specific cases
    int flagsleft, flagsright;

    string pbx_image, pbx_image2, pbx_image3;
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
        // Weapon Pickup Sprites
        pbx_weapon_PosX = CVar.GetCVar("pbx_Weaponhud_x", CPlayer).GetInt();
        pbx_weapon_PosY = CVar.GetCVar("pbx_Weaponhud_y", CPlayer).GetInt();
        pbx_weapon_hudscale = CVar.GetCVar("pbx_Weaponhud_scale", CPlayer).GetFloat();

        pbx_weapon_pos = (pbx_weapon_PosX, pbx_weapon_PosY);
        pbx_weapon_truescale = (pbx_weapon_hudscale, pbx_weapon_hudscale);

        // Weapon Modes
        pbx_weaponmode_PosX = CVar.GetCVar("pbx_WeaponModehud_x", CPlayer).GetInt();
        pbx_weaponmode_PosY = CVar.GetCVar("pbx_WeaponModehud_y", CPlayer).GetInt();
        pbx_weaponmode_hudscale = CVar.GetCVar("pbx_WeaponModehud_scale", CPlayer).GetFloat();

        pbx_weapon_pos2 = (pbx_weaponmode_PosX, pbx_weaponmode_PosY);
        pbx_weapon_truescale2 = (pbx_weaponmode_hudscale, pbx_weaponmode_hudscale);
        
        // Special cases where weapons uses two mods at the same time
        pbx_weapon_pos3 = pbx_weapon_pos2 + (0,-10);
        pbx_weapon_truescale3 = pbx_weapon_truescale2;

        flagsleft = DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM;
        flagsright = DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM;

    }

    // ADJUST SPECIFIC WEAPON POSITION AND SCALE HERE
    void weaponAdjustments()
    {
        // Set defaults 
        vector2 adjustPos,adjustPos2, adjustPos3 = (0,0);
        double adjustScale = 1.0;
        double adjustScale2 = 1.0;
        double adjustScale3 = 1.0;
        isAkimbo = pbWeap.akimboMode;

        // ADD ADJUSTMENTS HERE
        // WEAPON PICKUP SPRITE ADJUSTMENT
        switch(pbWeap.GetClassName())
            {
//////////////// SLOT 1 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                case 'PB_Fists':
                    adjustPos = (-15, 20); 
                    adjustScale = 0.6;
                    break;
                case 'PB_Chainsaw':
                    adjustPos = (-20, 32); 
                    break;
                case 'PB_Axe':
                    adjustPos = (-30, 40); 
                    break;

//////////////// SLOT 2 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                case 'PB_MP40':
                    adjustPos = isAkimbo ? (-5, -10) : (-8,10); 
                    adjustScale = 0.7;
                    break;
                case 'PB_SMG':
                    bool smgSilenced = PBX_PlayerHasInventory("SilencedSMG");
                    adjustPos = isAkimbo ?  (smgSilenced ? (-10,-7) : (13,-5)) : // Akimbo ? Silenced : Not Silenced
                                            (smgSilenced ?  (-13,14) : (10,14)); // Single ? Silenced : Not Silenced
                    adjustScale = 0.9;
                    break;
                case 'PB_Pistol':
                    bool pistolSilenced = PBX_PlayerHasInventory("SilencerEquipped");
                    adjustPos = isAkimbo ?  (pistolSilenced ? (-5,-9) : (20,-9)) : // Akimbo ? Silenced : Not Silenced
                                            (pistolSilenced ?  (-2,18) : (18,18)); // Single ? Silenced : Not Silenced
                    adjustScale = 1.1;
                    break;
                case 'PB_Revolver':
                    adjustPos = isAkimbo ? (-20, -12) : (-20, 12); 
                    break;
                case 'PB_Deagle':
                    adjustPos = isAkimbo ? (-30, -8) : (-30, 13); 
                    adjustScale = 1.1;
                    break;

                case 'PBX_Prosurv_LeverAction':
                    adjustPos = (-10, 18); 
                    adjustScale = 0.7;
                    break;

//////////////// SLOT 3 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                case 'PB_Shotgun':
                    adjustPos = (-5, 10); 
                    // adjustScale = 1.0;
                    break;
                case 'PB_Autoshotgun':
                    adjustPos = isAkimbo ? (-7, -10) : (-9,15); 
                    break;
                case 'PB_SSG':
                    adjustPos = isAkimbo ? (-15, -8) : (-20,13); 
                    break;
                case 'PB_QuadSG':
                    bool demonBreath = PBX_PlayerHasInventory("BreathMode");
                    adjustPos = isAkimbo ? (demonBreath ? (1, -5) // DUAL QSG DEMON BREATH
                                        : (3, -2))                // DUAL QSG BUCKSHOT
                         : (demonBreath ? (1,12)                  // SINGLE QSG DEMON BREATH
                                        : (0,10));                // SINGLE QSG BUCKSHOT
                    // MODE
                    adjustPos2 = (0,-20);
                    adjustScale2 = 0.2;
                    break;

                case 'PBX_CSSG':
                    adjustPos = (-5, 12); 
                    // adjustScale = 0.7;
                    break;

//////////////// SLOT 4 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                case 'PB_DMR':
                    bool dmrUpgraded   = PBX_PlayerHasInventory("DMRUpgraded");
                    bool hdmrSniperMode = PBX_PlayerHasInventory("HDMRSniperMode");
                    bool hdmrGrenadeMode = PBX_PlayerHasInventory("HDMRGrenadeMode");

                    adjustPos = !dmrUpgraded  ? (isAkimbo ? (-5,-8) : (-5,12))                                   // Unupgraded Akimbo : Unupgraded Single
                    // Upgraded
                    : hdmrGrenadeMode         ? (isAkimbo ? (-5,-14) : (hdmrSniperMode ? (2,-8) : (4,-8)))       // Akimbo Grenade Mode : Grenade Mode Single Sniper : Grenade Mode Single Normal
                    : isAkimbo                ? (hdmrSniperMode ? (-5,-14) : (5,2))                              // Akimbo Sniper Mode : Akimbo Normal Mode
                    : hdmrSniperMode          ? (-6,10) : (-4,10);                                               // Single Sniper Mode : Single Normal Mode
                    break;
                case 'PB_Carbine':
                    adjustPos = isAkimbo ? (-10, -15) : (-10,15);
                    adjustScale = 1.2;
                    break;
                case 'PB_LMG':
                    adjustPos = (3, 23);
                    adjustScale = 0.8;
                    break;
                case 'PB_ChexRifle':
                    adjustPos = (-10, 13);
                    adjustScale = 0.9;
                    break;

                case 'PBX_BDPBattleRifle':
                    adjustPos = (-7, 12); 
                    adjustScale = 1.3;
                    break;
                case 'PBX_MetalSniper':
                    let sniper = PBX_MetalSniper(pbWeap);
                    if(sniper)
                        adjustPos = sniper.AltMode ? (-3,-15) : (-3,14); 
                    
                    // MODE
                    // adjustPos2 = (0, 0); 
                    adjustScale2 = 0.7;
                    break;

//////////////// SLOT 5 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                case 'PB_MG42':
                    adjustPos = (-10, 32);
                    adjustScale = 0.5;
                    break;
                case 'PB_Minigun':
                    bool tripleMode   = PBX_PlayerHasInventory("TripleBarrelMode");
                    bool chaingunMode = PBX_PlayerHasInventory("ChainGunMode");
                    
                    adjustPos = tripleMode ? (-15,30) : (-15,32);

                    // MODE
                    int mode = !chaingunMode && tripleMode  ? 2    // triple
                            :  chaingunMode && !tripleMode ? 1     // chaingun (default)
                            : 0;                                   // normal

                    adjustPos2   = mode == 2 ? (-3, 0) : mode == 1 ? (0, 0) : (0, 0);
                    adjustScale2 = mode == 2 ? 0.5      : mode == 1 ? 0.9     : 0.9;
                    break;
                case 'PB_Nailgun':
                    adjustPos = (-9,12);
                    break;
                
//////////////// SLOT 6 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                case 'PB_RocketLauncher':
                    adjustPos = (-8 , 15);
                    adjustScale = 0.9;

                    // MODE
                    adjustPos2 = (0,-20);
                    adjustScale2 = 0.3;
                    break;
                case 'PB_SuperGL':
                    adjustPos = (-5, 13);
                    adjustScale = 0.9;

                    // MODE
                    adjustPos2 = (3,-18);
                    adjustScale2 = 0.3;
                    break;

                case 'PBX_CyberdemonRL':
                    adjustPos = (-30, 47); 
                    adjustScale = 1.5;
                    break;
                case 'PBX_Excavator':
                    adjustPos = (-10, 15); 
                    adjustScale = 1.1;
                    break;

//////////////// SLOT 7 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                case 'PB_M1Plasma':
                    adjustPos = isAkimbo ? (-5, -10) : (-10,12);
                    break;
                case 'PB_M2Plasma':
                    adjustPos = isAkimbo ? (-5, -7) : (-10,15);
                    adjustScale = 0.9;
                    break;
                case 'PB_DemonTech':
                    adjustPos = (-5, 15);
                    adjustScale = 0.9;
                    break;

//////////////// SLOT 8 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                case 'PB_Flamethrower':
                    adjustPos = PBX_PlayerHasInventory("FlamerUpgraded") ? (-15, 40) : (-10,15); 
                    break;
                case 'PB_CryoRifle':
                    adjustPos = (-5, 15);
                    // adjustScale = 0.9;

                    // MODE
                    adjustPos2 = (0,-60);
                    adjustScale2 = 0.3;
                    adjustPos3 = (0,-10);
                    adjustScale3 = 0.3;
                    break;

//////////////// SLOT 9 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                case 'PB_BFG9000':
                    adjustPos = (-10,32);
                    adjustScale = 0.8;
                    break;
                case 'PB_Railgun':
                    adjustPos = (-5,15);
                    adjustScale = 0.8;
                    break;
                case 'PB_Unmaker':
                    adjustPos = (-5,15);
                    adjustScale = 0.9;
                    break;
  
                case 'PBX_DemonExt':
                    adjustPos = (-10, 10); 
                    adjustScale = 1.3;
                    break;

                default:
                    adjustPos = (0,0);
                    adjustScale = 1.0;
                    adjustPos2 = (0,0);
                    adjustScale2 = 1.0;
                    adjustPos3 = (0,0);
                    adjustScale3 = 1.0;
                    break;
            }
        // Send the Values
        pbx_weapon_pos += adjustPos;
        pbx_weapon_truescale *= adjustScale;
        pbx_weapon_pos2 += adjustPos2;
        pbx_weapon_truescale2 *= adjustScale2;
        pbx_weapon_pos3 += adjustPos3;
        pbx_weapon_truescale3 *= adjustScale3;
        // Console.Printf("Pos: %d, %d", adjustPos.x, adjustPos.y);
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
//////////////// SLOT 3 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
            case 'PB_QuadSG':
                bool quadFullBlast = PBX_PlayerHasInventory("FullBlastMode");
                // Show what Mode is selected
                pbx_image2 = quadFullBlast ? "graphics/WeaponIcons/QUAD_FULL.png" : "graphics/WeaponIcons/QUAD_HALF.png";
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

//////////////// SLOT 4 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
                pbx_image2 = sniper && sniper.resonanceAmmoLoaded ? "graphics/WeaponWheel/metalsniper/ResonanceAlt.png" : "graphics/WeaponWheel/metalsniper/StandardAlt.png";
                break;

//////////////// SLOT 5 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            case 'PB_Minigun':
                bool chaingunMode = PBX_PlayerHasInventory("ChainGunMode");
                bool tripleMode = PBX_PlayerHasInventory("TripleBarrelMode");

                // Show what Mode is selected
                int mode = !chaingunMode && tripleMode  ? 2       // triple
                            :  chaingunMode && !tripleMode ? 1    // chaingun (default)
                            : 0;                                  // normal

                pbx_image2   =  mode == 2 ? "graphics/WeaponIcons/EXTREMELYHIHGSPID.png" : 
                                mode == 1 ? "graphics/WeaponIcons/NORMALSPEED.png" : 
                                "graphics/WeaponIcons/HIGHSPEED.png";
                break;

//////////////// SLOT 6 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            case 'PB_RocketLauncher':
                // WHY IS THE ROCKETLAUNCHER MODE SWITCH SO JANK
                // WHAT DO YOU MEAN ITS A STRING
                if(pbweap)
                {
                    // Show What Mode is Selected
                    if(pbweap.rocketLauncherMode == "Standard")
                    {
                        pbx_image2 = "graphics/pywheel/rocket_standard.png";
                    }
                    else if (pbweap.rocketLauncherMode == "Homing")
                    {
                        pbx_image2 = "graphics/pywheel/rocket_homing.png";
                    }
                    else if (pbweap.rocketLauncherMode == "Laser")
                    {
                        pbx_image2 = "graphics/pywheel/rocket_laser.png";
                    }
                }
                break;
            case 'PB_SuperGL':
                let sgl = PB_SuperGL(pbWeap);
                if (sgl) 
                {
                    static const string sglIcons[] = {
                        "graphics/pywheel/grenade_impact.png", "graphics/pywheel/grenade_sticky.png", 
                        "graphics/pywheel/grenade_acid.png", "graphics/pywheel/grenade_incendiary.png", 
                        "graphics/pywheel/grenade_cryo.png"
                    };
                    
                    // Show what Ammo type is selected
                    int m = clamp(sgl.GrenadeMode, 0, sglIcons.Size() - 1);
                    pbx_image2 = sglIcons[m];
                }
                break;

//////////////// SLOT 8 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            case 'PB_CryoRifle':
                // Shows the current primary and secondary mode
                bool cryoMissile = PBX_PlayerHasInventory("FireModeCryoRifleMissile");
                // bool cryoBeam = PBX_PlayerHasInventory("FireModeCryoRifleBeam");
                
                bool cryoSpear = PBX_PlayerHasInventory("FireModeCryoRifleSpear");
                // bool cryoFlak = PBX_PlayerHasInventory("FireModeCryoRifleFlak");
                
                pbx_image3 = cryoMissile ? "graphics/pywheel/CryoRifle_Missile.png" : "graphics/pywheel/CryoRifle_Beam.png";
                pbx_image2 = cryoSpear ? "graphics/pywheel/CryoRifle_Spear.png" : "graphics/pywheel/CryoRifle_Flak.png";
                break;

            default:
                pbx_image = " ";
                pbx_image2 = " ";
                pbx_image3 = " ";
                break;
        }
        
        // Actually Draw the Thing
        PBX_DrawImage(2);
        PBX_DrawImage(3);
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
            // Slot 2
            "PB_Pistol", "PB_SMG", "PB_Revolver", "PB_Deagle",
            // Slot 3
            "PB_Shotgun", "PB_Autoshotgun", "PB_QuadSG", "PB_SSG",
            // Slot 4
            "PB_Carbine", "PB_DMR",
            // Slot 5
            "PB_Minigun", 
            // Slot 7
            "PB_M1Plasma", "PB_M2Plasma",
            // Slot 8
            "PB_Flamethrower"
            // Slot 9
             
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
//////////////// SLOT 2 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            case 'PB_SMG':
                bool smgSilenced = PBX_PlayerHasInventory("SilencedSMG");
                pbx_image = isAkimbo ? 
                    // If Akimbo ? Suppressed : Non Suppressed
                    (smgSilenced ? "graphics/pywheel/SMG/SMG_DUAL_SUPPRESSED.png" : "graphics/pywheel/SMG/SMG_DUAL.png") :
                    // If Not Akimbo ? Suppressed : Non Suppressed
                    (smgSilenced ? "ATFLA0" : "ATFLB0");
                break;
            case 'PB_Pistol':
                bool pistolSilenced = PBX_PlayerHasInventory("SilencerEquipped");
                pbx_image = isAkimbo ? 
                    // If Akimbo ? Suppressed : Non Suppressed
                    (pistolSilenced ? "graphics/pywheel/PISTOL_7.png" : "graphics/pywheel/PISTOL_4.png") :
                    // If Not Akimbo ? Suppressed : Non Suppressed
                    (pistolSilenced ? "graphics/pywheel/PISTOL_1.png" : "graphics/pywheel/PISTOL_0.png");
                break;
            case 'PB_MP40':
                pbx_image = isAkimbo ? "graphics/WeaponPickups/MP40_DUAL.png" : icon;
                break;
            case 'PB_Revolver':
                pbx_image = isAkimbo ? "graphics/WeaponPickups/REVOLVER_DUAL.png" : icon;
                break;
            case 'PB_Deagle':
                pbx_image = isAkimbo ? "graphics/WeaponPickups/DEAGLE_DUAL.png" : icon;
                break;

//////////////// SLOT 3 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            case 'PB_Shotgun':
                bool shotgunUpgraded = PBX_PlayerHasInventory("PumpshotgunMagazine");
                // If Upgraded
                pbx_image = shotgunUpgraded ? "9SMUA0" : icon;
                break;
            case 'PB_Autoshotgun':
                bool asgUpgraded = PBX_PlayerHasInventory("AutoshotgunDrumMag");
                pbx_image = isAkimbo ? 
                    // If Akimbo ? Upgraded : Non Upgraded
                    (asgUpgraded ? "graphics/WeaponPickups/ASG_UPGRADED_DOUBLE.png" : "graphics/WeaponPickups/ASGDOUBLE.png") :
                    // If Not Akimbo ? Upgraded : Non Upgraded
                    (asgUpgraded ? "A9SCA0" : "graphics/WeaponPickups/ASGSINGLE.png");
                break;
            case 'PB_SSG':
                pbx_image = isAkimbo ? "graphics/WeaponPickups/SSG_DUAL.png" : icon;
                break;
            case 'PB_QuadSG':
                bool demonBreath = PBX_PlayerHasInventory("BreathMode");
                pbx_image = isAkimbo ? (demonBreath ? "graphics/WeaponPickups/QSGDUAL_DEMON.png" // DUAL QSG DEMON BREATH
                                        : "graphics/pywheel/Quad_Dual.png")                      // DUAL QSG BUCKSHOT
                         : (demonBreath ? "graphics/pywheel/Quad_Demonic.png"                    // SINGLE QSG DEMON BREATH
                                        : "QSPGA0");                                             // SINGLE QSG BUCKSHOT
                break;

//////////////// SLOT 4 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            case 'PB_Carbine':
                // If Akimbo
                pbx_image = isAkimbo ? "graphics/pywheel/Carbine_Dual.png" : icon;
                break;
            case 'PB_DMR':
                bool dmrUpgraded   = PBX_PlayerHasInventory("DMRUpgraded");
                bool hdmrSniperMode = PBX_PlayerHasInventory("HDMRSniperMode");
                
                // WHAT IS THIS LMAOOOOO
                pbx_image = !dmrUpgraded  ? (isAkimbo ? "graphics/WeaponPickups/DMR_DUAL.png" : icon)
                : isAkimbo       ? (hdmrSniperMode ? "graphics/WeaponPickups/HMDR_SNIPER_DOUBLE.png"
                                                    : "graphics/pywheel/hdmr_dual.png")
                : hdmrSniperMode  ? "graphics/WeaponPickups/HDMR_SNIPER_SINGLE.png"
                : "HIFLA0";
                break;

//////////////// SLOT 5 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            case 'PB_Minigun':
                bool tripleBarrel = PBX_PlayerHasInventory("TripleBarrelMode");
                // If the current mode is the triplebarrel
                pbx_image = tripleBarrel ? "8GUNA0" : icon;
                break;

//////////////// SLOT 7 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            case 'PB_M1Plasma':
                // If Akimbo
                pbx_image = isAkimbo ? "graphics/WeaponPickups/M1_DUAL.png" : icon;
                break;
            case 'PB_M2Plasma':
                bool m2Upgraded = PBX_PlayerHasInventory("HasLightningGunUpgrade");
                pbx_image = isAkimbo ? 
                    // If Akimbo ? Upgraded : Non Upgraded
                    (m2Upgraded ? "graphics/WeaponPickups/M2_UPGR_DUAL.png" : "graphics/WeaponPickups/M2_DUAL.png") :
                    // If Not Akimbo ? Upgraded : Non Upgraded
                    (m2Upgraded ? "M2PRB0" : icon);
                break;

//////////////// SLOT 8 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            case 'PB_Flamethrower':
                bool flamerUpgraded = PBX_PlayerHasInventory("FlamerUpgraded");
                // If Upgraded
                pbx_image = flamerUpgraded ? "FSPWB0" : "FSPWA0";
                break;

//////////////// Missing Icons /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            // You dont need to these weapons to the exceptions above since they dont count as valid
            case 'PB_ChexRifle':
                pbx_image = "CRRSA0";
                break;
            case 'PB_LMG':
                pbx_image = "LMPIA0";
                break;
            case 'PB_BFG9000':
                pbx_image = "097GA0";
                break;
            case 'PB_CryoRifle':
                pbx_image = "FRPKA0";
                break;
            case 'PB_Unmaker':
                pbx_image = "UNHDA0";
                break;

            default:
                pbx_image = " ";
                pbx_image2 = " ";
                pbx_image3 = " ";
                break;
        }

        // Actually Draw the Thing
        PBX_DrawImage();
    }

    // THIS IS ALL AUXILLIARY FUNCTIONS JUST TO KEEP THE CODE CLEAN

    // Draw what type of image
    void PBX_DrawImage(int whatimage = 1)
    {
        switch(whatimage)
        {
            // Weapon Pickup Sprite
            default:
            case 1:
                PBHud_DrawImage(pbx_image, pbx_weapon_pos, flagsright, playerBoxAlpha, scale: pbx_weapon_truescale);
                break;
            // Weapon Mode Sprite
            case 2:
                PBHud_DrawImage(pbx_image2, pbx_weapon_pos2, flagsright, playerBoxAlpha, scale: pbx_weapon_truescale2);
                break;
            // Weapon Mode 2 Sprite
            case 3:
                PBHud_DrawImage(pbx_image3, pbx_weapon_pos3, flagsright, playerBoxAlpha, scale: pbx_weapon_truescale3);
                break;
        }
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