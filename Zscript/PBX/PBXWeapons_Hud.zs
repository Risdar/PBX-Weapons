enum PBX_eHudSettingFlags{
    DisablePBX_WeaponHud				= 1 << 0,
}

// The variable scope weapon wheel icon uses this value for its scale
const WHEEL_ZOOM_SCALE  = 2.0;
const WHEEL_SCOPE_SCALE = 1.0;
const WHEEL_NVG_SCALE   = 0.5;

class PBX_Hud : PB_Hud_ZS
{
    // Set Variables
    int pbx_weapon_PosX, pbx_weapon_PosY, pbx_weaponmode_PosX, pbx_weaponmode_PosY;
    double pbx_weaponmode_hudscale, pbx_weapon_hudscale;
    double pbx_weapon_alpha, pbx_weaponmode_alpha;
    int pbx_weapon_boxW, pbx_weapon_boxH;
    int pbx_weaponmode_boxW, pbx_weaponmode_boxH;
    Vector2 pbx_weapon_pos, pbx_weapon_truescale, pbx_weapon_box1;
    Vector2 pbx_weapon_pos2, pbx_weapon_truescale2, pbx_weapon_box2;
    Vector2 pbx_weapon_pos3, pbx_weapon_truescale3, pbx_weapon_box3; // For specific cases
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

        if(hudState != HUD_None && !PlayerWasDead)
		{
            DrawPBXHud();
		}
    }

    // GET THE HUD POSITION FROM THE SETTINGS
    void gatherPBXCVARs()
    {
        // Weapon Pickup Sprites
        pbx_weapon_PosX = CVar.GetCVar("pbxweapons_Weaponhud_x", CPlayer).GetInt();
        pbx_weapon_PosY = CVar.GetCVar("pbxweapons_Weaponhud_y", CPlayer).GetInt();
        pbx_weapon_hudscale = CVar.GetCVar("pbxweapons_Weaponhud_scale", CPlayer).GetFloat();
        pbx_weapon_alpha = CVar.GetCVar("pbxweapons_Weaponhud_alpha", CPlayer).GetFloat();
        pbx_weapon_boxW = CVar.GetCVar("pbxweapons_Weaponhud_boxW", CPlayer).GetInt();
        pbx_weapon_boxH = CVar.GetCVar("pbxweapons_Weaponhud_boxH", CPlayer).GetInt();

        pbx_weapon_pos = (pbx_weapon_PosX, pbx_weapon_PosY);
        pbx_weapon_truescale = (pbx_weapon_hudscale, pbx_weapon_hudscale);
        pbx_weapon_box1 = (pbx_weapon_boxW, pbx_weapon_boxH);

        // Weapon Modes
        pbx_weaponmode_PosX = CVar.GetCVar("pbxweapons_WeaponModehud_x", CPlayer).GetInt();
        pbx_weaponmode_PosY = CVar.GetCVar("pbxweapons_WeaponModehud_y", CPlayer).GetInt();
        pbx_weaponmode_hudscale = CVar.GetCVar("pbxweapons_WeaponModehud_scale", CPlayer).GetFloat();
        pbx_weaponmode_alpha = CVar.GetCVar("pbxweapons_WeaponModehud_alpha", CPlayer).GetFloat();
        pbx_weaponmode_boxW = CVar.GetCVar("pbxweapons_WeaponModehud_boxW", CPlayer).GetInt();
        pbx_weaponmode_boxH = CVar.GetCVar("pbxweapons_WeaponModehud_boxH", CPlayer).GetInt();

        pbx_weapon_pos2 = (pbx_weaponmode_PosX, pbx_weaponmode_PosY);
        pbx_weapon_truescale2 = (pbx_weaponmode_hudscale, pbx_weaponmode_hudscale);
        pbx_weapon_box2 = (pbx_weaponmode_boxW, pbx_weaponmode_boxH);
        
        // Special cases where weapons uses two modes at the same time
        pbx_weapon_pos3 = pbx_weapon_pos2 + (0,-10);
        pbx_weapon_truescale3 = pbx_weapon_truescale2;
        pbx_weapon_box3 = (pbx_weaponmode_boxW, pbx_weaponmode_boxH);

        flagsleft = DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM;
        flagsright = DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM;

    }

    // AUTOMATICALLY DRAW THE WEAPONS, ADD EXCEPTIONS HERE IF YOU WANT TO MANUALLY EDIT THEM
    // FOR EXAMPLE IF YOU WANT THEM TO SHOW DIFFERENT SPRITE IF THEY'RE AKIMBO/UPGRADED/ETC.
    // ADJUSTMENTS LIKE SCALE AND POSITION IS HANDLED IN weaponAdjustments() ABOVE
    void DrawPBXWeaponAuto()
    {
        // Standard check
        if(PBXWeapons_hudsetting_filter & DisablePBX_WeaponHud) return;
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
            "PB_Flamethrower",
            // Slot 9
             
            // PBX Weapons
            "PBX_MastermindChaingun","PBX_MetalSniper","PBX_ProSurvPSG",
            "PBX_BDPBattleRifle","PBX_Prosurv_LeverAction", "PBX_BDPRailgun"
        };

        // Handle exceptions
        string weaponClass = pbWeap.GetClassName();
        for (int i = 0; i < exceptionWeapons.Size(); i++)
        {
            if (weaponClass == exceptionWeapons[i]) return; // do not draw HUD for these weapons
        }

        // Use default Icons
        TextureID iconID = pbWeap.AltHudIcon.IsValid() ? pbWeap.AltHudIcon : pbWeap.Icon;
        pbx_image = TexMan.GetName(iconID);

        if (iconID.IsValid())
        {
            PBX_DrawImage();
        }
    }

    // ADJUST SPECIFIC WEAPON POSITION AND SCALE HERE
    void weaponAdjustments()
    {
        // Set defaults 
        vector2 adjustPos,adjustPos2, adjustPos3 = (0,0);
        double adjustScale  = 1.0;
        double adjustScale2 = 1.0;
        double adjustScale3 = 1.0;
        isAkimbo            = pbWeap.akimboMode;

        // ADD ADJUSTMENTS HERE
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
                let smg = PB_SMG(pbWeap);
                if(!smg) return;
                bool smgSilenced = smg.hasSilencer;
                adjustPos = isAkimbo ?  (smgSilenced ? (-10,-7) : (13,-5)) : // Akimbo ? Silenced : Not Silenced
                                        (smgSilenced ?  (-13,14) : (10,14)); // Single ? Silenced : Not Silenced
                adjustScale = 0.9;
                break;

            case 'PB_Pistol':
                let pistol = PB_Pistol(pbWeap);
                if(!pistol) return;
                bool pistolSilenced = pistol.hasSilencer;
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
                let lar = PBX_Prosurv_LeverAction(pbWeap);
                if(!lar) return;
                adjustPos = lar.laserActive ? (0,18) : (-10, 18);
                adjustScale = lar.laserActive ? 0.6 : 0.7;
                break;

            case 'PBX_PlasmaBlaster':
                adjustPos = (-22, 12); 
                adjustScale = 2.0;
                break;

            case 'PBX_ProsurvBlaster':
                adjustPos = (-30, 30); 
                adjustScale = 1.0;
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
                        : (demonBreath ? (1,12)               // SINGLE QSG DEMON BREATH
                                    : (0,10));                // SINGLE QSG BUCKSHOT
                // MODE
                adjustPos2 = (0,-20);
                adjustScale2 = 0.2;
                break;

            case 'PBX_CSSG':
                adjustPos = (-5, 12);
                // adjustScale = 0.7;
                break;

            case 'PBX_ProSurvPSG':
                let psg = PBX_ProSurvPSG(pbWeap);
                if(!psg) return;
                adjustPos = psg.laserActive ? (13,13) : (-5, 15); 
                adjustScale = psg.laserActive ? 0.8 : 1.1;
                break;
                

//////////////// SLOT 4 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            case 'PB_DMR':
                bool dmrUpgraded    = PBX_PlayerHasInventory("DMRUpgraded");
                bool hdmrSniperMode = PBX_PlayerHasInventory("HDMRSniperMode");
                bool hdmrGrenMode   = PBX_PlayerHasInventory("HDMRGrenadeMode");

                adjustPos   = !dmrUpgraded    ? (isAkimbo ? (-5,-8) : (-5,12))      // Unupgraded: Akimbo : Single
                            : isAkimbo        ? (hdmrSniperMode ? (-5,-14) : (5,2)) // Upgraded Akimbo: Sniper : Normal
                            : hdmrSniperMode  ? (-6,10) : (-4,10);                  // Upgraded Single: Sniper : Normal

                adjustScale = dmrUpgraded ? 0.9 : 1.0;

                if (hdmrGrenMode && !isAkimbo)
                    adjustPos.y -= 19;                                  
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

            case 'PBX_NormalRifle':
                adjustPos = (-5,12);
                // adjustScale = 1.3;
                break;

            case 'PBX_BDPBattleRifle':
                let br = PBX_BDPBattleRifle(pbWeap);
                if(!br) return;
                adjustPos = br.laserActive ? (0,12) : (-7, 12); 
                adjustScale = br.laserActive ? 0.7 : 1.3;
                break;

            case 'PBX_MetalSniper':
                let sniper = PBX_MetalSniper(pbWeap);
                if(!sniper) return;
                adjustPos = sniper.laserActive ? (0,10) : (0,14); 
                if(sniper.AltMode)
                    adjustPos.y -= 19;
                // adjustPos = sniper.AltMode ? (0,-5) : (0,14); 
                
                // Resonance Ammo
                adjustScale2 = 0.7;
                break;

            case 'PBX_Prosurv_Ballista':
                adjustPos = (-10, -8); 
                // adjustScale = 1.3;
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

            case 'PBX_NeoHMG':
                adjustPos = (-3,-3);
                adjustScale = 1.6;
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
                adjustPos = (-15, 28); 
                adjustScale = 1.5;
                break;

            case 'PBX_Excavator':
                adjustPos = (-10, 15); 
                adjustScale = 1.1;
                break;

            case 'PBX_MastermindChaingun':
                adjustPos = (-10, 40); 
                adjustScale = 1.6   ;
                break;

//////////////// SLOT 7 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            case 'PB_M1Plasma':
                adjustPos = isAkimbo ? (-5, -10) : (-10,12);
                break;

            case 'PB_M2Plasma':
                adjustPos = isAkimbo ? (-5, -7) : (-10,15);
                adjustScale = 0.9;
                break;

            case 'PB_DTechRifle':
                adjustPos = (-5, 15);
                adjustScale = 0.9;
                break;

            case 'PBX_BDPRailgun':
                let railgun = PBX_BDPRailgun(pbWeap);
                if(!railgun) return;
                adjustPos = railgun.laserActive ? (0,12) : (-5, 12); 
                adjustScale = railgun.laserActive ? 0.7 : 1.4;
                break;

//////////////// SLOT 8 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            case 'PB_Flamethrower':
                adjustPos = PBX_PlayerHasInventory("FlamerUpgraded") ? (-15, 40) : (-10,15); 
                break;

            case 'PB_CryoRifle':
                adjustPos = (-5, 15);
                // adjustScale = 0.9;
                // MODE
                adjustPos2   = (0,-60);
                adjustScale2 = 0.3;
                adjustPos3   = (0,-10);
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
                adjustPos    = (0,0);
                adjustPos2   = (0,0);
                adjustPos3   = (0,0);
                adjustScale  = 1.0;
                adjustScale2 = 1.0;
                adjustScale3 = 1.0;
                break;
        }
        // Send the Values
        pbx_weapon_pos          += adjustPos;
        pbx_weapon_pos2         += adjustPos2;
        pbx_weapon_pos3         += adjustPos3;
        pbx_weapon_truescale    *= adjustScale;
        pbx_weapon_truescale2   *= adjustScale2;
        pbx_weapon_truescale3   *= adjustScale3;
        // Console.Printf("Pos: %d, %d", adjustPos.x, adjustPos.y);
    }

    // MANUALLY DRAW THE WEAPONS AND WEAPON MODES
    void DrawPBXWeaponManual()
    {
        // Standard Check
        if(PBXWeapons_hudsetting_filter & DisablePBX_WeaponHud) return;
        if (!pbWeap) return;

        // Set Defaults & Variables
        TextureID iconID = pbWeap.AltHudIcon.IsValid() ? pbWeap.AltHudIcon : pbWeap.Icon;
        string icon = TexMan.GetName(iconID);

        // Add the weapons here
        switch(pbWeap.GetClassName())
        {
//////////////// SLOT 2 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            // Shows dual wield and suppressed
            case 'PB_Pistol':
                let pistol = PB_Pistol(pbWeap);
                if(!pistol) return;
                bool pistolSilenced = pistol.hasSilencer;
                pbx_image = isAkimbo ? 
                    // If Akimbo ? Suppressed : Non Suppressed
                    (pistolSilenced ? "graphics/pywheel/PISTOL_7.png" : "graphics/pywheel/PISTOL_4.png") :
                    // If Not Akimbo ? Suppressed : Non Suppressed
                    (pistolSilenced ? "graphics/pywheel/PISTOL_1.png" : "graphics/pywheel/PISTOL_0.png");
                pbx_image2 = " "; //its empty for now
                pbx_image3 = " "; //its empty for now
                break;

            // Same as the Pistol
            case 'PB_SMG':
                let smg = PB_SMG(pbWeap);
                if(!smg) return;
                bool smgSilenced = smg.hasSilencer;
                pbx_image = isAkimbo ? 
                    // If Akimbo ? Suppressed : Non Suppressed
                    (smgSilenced ? "graphics/pywheel/SMG/SMG_DUAL_SUPPRESSED.png" : "graphics/pywheel/SMG/SMG_DUAL.png") :
                    // If Not Akimbo ? Suppressed : Non Suppressed
                    (smgSilenced ? "ATFLA0" : "ATFLB0");
                pbx_image2 = " "; //its empty for now
                pbx_image3 = " "; //its empty for now
                break;

            // Shows dual wield
            case 'PB_MP40':
                pbx_image = isAkimbo ? "graphics/WeaponPickups/MP40_DUAL.png" : icon;
                pbx_image2 = " "; //its empty for now
                pbx_image3 = " "; //its empty for now
                break;
            case 'PB_Revolver':
                pbx_image = isAkimbo ? "graphics/WeaponPickups/REVOLVER_DUAL.png" : icon;
                pbx_image2 = " "; //its empty for now
                pbx_image3 = " "; //its empty for now
                break;
            case 'PB_Deagle':
                pbx_image = isAkimbo ? "graphics/WeaponPickups/DEAGLE_DUAL.png" : icon;
                pbx_image2 = " "; //its empty for now
                pbx_image3 = " "; //its empty for now
                break;

            case 'PBX_Prosurv_LeverAction':
                let lar = PBX_Prosurv_LeverAction(pbWeap);
                if(!lar) return;
                pbx_image  = lar.laserActive ? "graphics/WeaponWheel/LeverAction/LaserOn.png" : icon;
                pbx_image2 = " "; //its empty for now
                pbx_image3 = " "; //its empty for now
                break;

//////////////// SLOT 3 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            // Shows current shell type and if the weapon has been upgraded
            case 'PB_Shotgun':
                let shotgun = PB_Shotgun(pbWeap);
                bool shotgunUpgraded = PBX_PlayerHasInventory("PumpshotgunMagazine");
                if(!shotgun) return;
                switch(shotgun.shellsmode)
                {
                    case PB_Shotgun.Shell_Buck:
                        pbx_image2 = "buckhud";
                        break;
                    case PB_Shotgun.Shell_Slug:
                        pbx_image2 = "slughud";
                        break;
                    case PB_Shotgun.Shell_Drag:
                        pbx_image2 = "drgnhud";
                        break;
                }
                pbx_image = shotgunUpgraded ? "9SMUA0" : icon;
                pbx_image2 = " "; //its empty for now
                pbx_image3 = " "; //its empty for now
                break;

            // Shows dual wield and if the weapon has been upgraded
            case 'PB_Autoshotgun':
                bool asgUpgraded = PBX_PlayerHasInventory("AutoshotgunDrumMag");
                pbx_image = isAkimbo ? 
                    // If Akimbo ? Upgraded : Non Upgraded
                    (asgUpgraded ? "graphics/WeaponPickups/ASG_UPGRADED_DOUBLE.png" : "graphics/WeaponPickups/ASGDOUBLE.png") :
                    // If Not Akimbo ? Upgraded : Non Upgraded
                    (asgUpgraded ? "A9SCA0" : "graphics/WeaponPickups/ASGSINGLE.png");
                pbx_image2 = " "; //its empty for now
                pbx_image3 = " "; //its empty for now
                break;

            // Shows dual wield
            case 'PB_SSG':
                pbx_image = isAkimbo ? "graphics/WeaponPickups/SSG_DUAL.png" : icon;
                pbx_image2 = " "; //its empty for now
                pbx_image3 = " "; //its empty for now
                break;

            // Shows dual wield and current weapon mode
            case 'PB_QuadSG':
                bool quadFullBlast = PBX_PlayerHasInventory("FullBlastMode");
                bool demonBreath = PBX_PlayerHasInventory("BreathMode");
                pbx_image = isAkimbo ? (demonBreath ? "graphics/WeaponPickups/QSGDUAL_DEMON.png" // DUAL QSG DEMON BREATH
                                        : "graphics/pywheel/Quad_Dual.png")                      // DUAL QSG BUCKSHOT
                         : (demonBreath ? "graphics/pywheel/Quad_Demonic.png"                    // SINGLE QSG DEMON BREATH
                                        : "QSPGA0");     
                pbx_image2 = quadFullBlast ? "graphics/WeaponIcons/QUAD_FULL.png" : "graphics/WeaponIcons/QUAD_HALF.png";
                pbx_image3 = " "; //its empty for now
                break;

            // Shows current shell type
            case 'PBX_CSSG':
                let cssg = PBX_CSSG(pbWeap);
                if(!cssg) return;
                static const string cssgIcons[] = {
                    "buckhud", "slughud", "flcthud", "flakhud", "drgnhud", 
                    "explhud", "phoshud", "doomhud", "dnmkhud", "subzhud"
                };
                // Show what Ammo type is selected
                int cssgshell = clamp(cssg.shellsmode, 0, cssgIcons.Size() - 1);
                pbx_image2 = cssgIcons[cssgshell];
                pbx_image3 = " "; //its empty for now
                break;

            case 'PBX_ProSurvPSG':
                let psg = PBX_ProSurvPSG(pbWeap);
                if(!psg) return;
                pbx_image  = psg.laserActive ? "graphics/WeaponWheel/ProsurvPSG/LaserOn.png" : icon;
                pbx_image2 = " "; //its empty for now
                pbx_image3 = " "; //its empty for now
                break;
            

//////////////// SLOT 4 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            // Shows dual wield
            case 'PB_Carbine':
                // If Akimbo
                pbx_image = isAkimbo ? "graphics/pywheel/Carbine_Dual.png" : icon;
                pbx_image2 = " "; //its empty for now
                pbx_image3 = " "; //its empty for now
                break;

            // Shows dual wield and if the weapon has been upgraded
            case 'PB_DMR':
                bool dmrUpgraded   = PBX_PlayerHasInventory("DMRUpgraded");
                bool hdmrSniperMode = PBX_PlayerHasInventory("HDMRSniperMode");
                // WHAT IS THIS LMAOOOOO
                pbx_image = !dmrUpgraded  ? (isAkimbo ? "graphics/WeaponPickups/DMR_DUAL.png" : icon)
                : isAkimbo       ? (hdmrSniperMode ? "graphics/WeaponPickups/HMDR_SNIPER_DOUBLE.png"
                                                    : "graphics/pywheel/hdmr_dual.png")
                : hdmrSniperMode  ? "graphics/WeaponPickups/HDMR_SNIPER_SINGLE.png"
                : "HIFLA0";
                pbx_image2 = " "; //its empty for now
                pbx_image3 = " "; //its empty for now
                break;

            case 'PBX_BDPBattleRifle':
                let br = PBX_BDPBattleRifle(pbWeap);
                if(!br) return;
                pbx_image  = br.laserActive ? "graphics/WeaponWheel/BattleRifle/BR_LaserOn.png" : icon;
                pbx_image2 = " "; //its empty for now
                pbx_image3 = " "; //its empty for now
                break;

            // Draw bars for specific modes and shows the current ammo type
            case 'PBX_MetalSniper':
                let sniper = PBX_MetalSniper(pbWeap);
                if(!sniper) return;
                // Show Rocket Ammo if Grenade Secondary Mode is Selected
                if (sniper.AltMode) 
                {
                    PBHud_DrawImage("BARBACR3", (-90, -71), flagsright, playerBoxAlpha);
                    PBHud_DrawBar("ABAR4", "BGBARL", GetAmount("PB_RocketAmmo"), GetMaxAmount("PB_RocketAmmo"), (-100, -72), 0, 1, flagsright);
                    PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("PB_RocketAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_RED);
                }
                // This draws the overlay when the smart scope is enabled
                if (sniper.enableScopeHUD)
                {
                    vector2 topOffsets1 = ((-24 - visorOffsets) + (-m32to0), -24 - visorOffsets - m32to0);
                    vector2 topOffsets2 = ((24 + visorOffsets) + (m32to0), -24 - visorOffsets - m32to0);
					PBHud_DrawImageManualAlpha("NIGHTVIS", (topOffsets1.x, 0), DI_ITEM_LEFT | DI_SCREEN_LEFT | DI_ITEM_VCENTER | DI_SCREEN_VCENTER, 0.5 + 0.5 * abs(sin(level.MapTime)), scale: (0.3, 0.3), parallax: 1.5, parallax2: 1.5);
					PBHud_DrawImageManualAlpha("NIGHTVIS", (topOffsets2.x, 0), DI_ITEM_RIGHT | DI_SCREEN_RIGHT | DI_MIRROR | DI_ITEM_VCENTER | DI_SCREEN_VCENTER, 0.5 + 0.5 * abs(sin(level.MapTime)), scale: (0.3, 0.3), parallax: 1.5, parallax2: 1.5);
                }
                // Show what Ammo type is selected
                pbx_image  = sniper.laserActive ? "graphics/WeaponWheel/MetalSniper/LaserOn.png" : icon;
                pbx_image2 = sniper && sniper.resonanceAmmoLoaded ? "graphics/WeaponWheel/metalsniper/ResonanceAlt.png" : "graphics/WeaponWheel/metalsniper/StandardAlt.png";
                pbx_image3 = " "; //its empty for now
                break;
                
            // Draw bars for specific modes and the current weapon
            case 'PBX_Prosurv_Ballista':
                let crossbow = PBX_Prosurv_Ballista(pbWeap);
                // Show Fuel if Demonic Mode, Show Rocket if Standard Mode
                if(!crossbow) return;
                if (crossbow.demonicBallistaMode) 
                {
                    PBHud_DrawImage("BARBACD3", (-90, -71), flagsright, playerBoxAlpha);
                    PBHud_DrawBar("ABAR6", "BGBARL", GetAmount("PB_Fuel"), GetMaxAmount("PB_Fuel"), (-100, -72), 0, 1, flagsright);
                    PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("PB_Fuel")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_RED);
                }
                else 
                {
                    PBHud_DrawImage("BARBACR3", (-90, -71), flagsright, playerBoxAlpha);
                    PBHud_DrawBar("ABAR4", "BGBARL", GetAmount("PB_RocketAmmo"), GetMaxAmount("PB_RocketAmmo"), (-100, -72), 0, 1, flagsright);
                    PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("PB_RocketAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_RED);
                }
                pbx_image = crossbow.demonicBallistaMode ? "CBOWT0" : icon;
                pbx_image2 = " "; //its empty for now
                pbx_image3 = " "; //its empty for now
                break;

//////////////// SLOT 5 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            // Show the current mode and if the weapon is in triple barrel mode
            case 'PB_Minigun':
                bool tripleBarrel = PBX_PlayerHasInventory("TripleBarrelMode");
                // If the current mode is the triplebarrel
                pbx_image = tripleBarrel ? "8GUNA0" : icon;
                bool chaingunMode = PBX_PlayerHasInventory("ChainGunMode");
                bool tripleMode = PBX_PlayerHasInventory("TripleBarrelMode");
                int mode = !chaingunMode && tripleMode  ? 2       // triple
                            :  chaingunMode && !tripleMode ? 1    // chaingun (default)
                            : 0;                                  // normal

                pbx_image2   =  mode == 2 ? "graphics/WeaponIcons/EXTREMELYHIHGSPID.png" : 
                                mode == 1 ? "graphics/WeaponIcons/NORMALSPEED.png" : 
                                "graphics/WeaponIcons/HIGHSPEED.png";
                pbx_image3 = " "; //its empty for now
                break;

            // Draw bar for the shield durability
            case 'PBX_NeoHMG':
                let neoHMG = PBX_NeoHMG(pbWeap);
                // Show Shield Durability
                if(!neoHMG) return;
                PBHud_DrawImage("BARBASH3", (-90, -71), flagsright, playerBoxAlpha);
                PBHud_DrawBar("ABAR9", "BGBARL", GetAmount("HMGShield"), GetMaxAmount("HMGShield"), (-100, -72), 0, 1, flagsright);
                PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("HMGShield")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_GREEN);
                // Show what Ammo type is selected
                pbx_image2 = " "; //its empty for now
                pbx_image3 = " "; //its empty for now
                break;

//////////////// SLOT 6 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            // Shows the currnet rocket mode
            case 'PB_RocketLauncher':
                // WHY IS THE ROCKETLAUNCHER MODE SWITCH SO JANK
                // WHAT DO YOU MEAN ITS A STRING
                if(pbweap)
                {
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
                pbx_image3 = " "; //its empty for now
                break;

            // Shows the currnet grenade mode
            case 'PB_SuperGL':
                let sgl = PB_SuperGL(pbWeap);
                if(!sgl) return;
                static const string sglIcons[] = {
                    "graphics/pywheel/grenade_impact.png", "graphics/pywheel/grenade_sticky.png", 
                    "graphics/pywheel/grenade_acid.png", "graphics/pywheel/grenade_incendiary.png", 
                    "graphics/pywheel/grenade_cryo.png"
                };
                int sglgren = clamp(sgl.GrenadeMode, 0, sglIcons.Size() - 1);
                pbx_image2 = sglIcons[sglgren];
                pbx_image3 = " "; //its empty for now
                break;

            // Draw the durability bar
            case 'PBX_CyberdemonRL':
                let crl = PBX_CyberdemonRL(pbWeap);
                if(!crl) return;
                PBHud_DrawImage("BARBADD2", (-73, -49), flagsright, playerBoxAlpha);
                PBHud_DrawBar("ABAR10", "BGBARL", GetAmount("CyberRLDurability"), GetMaxAmount("CyberRLDurability"), (-111, -52), 0, 1, flagsright);
                PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("CyberRLDurability")), (-205, -68.75), DI_TEXT_ALIGN_RIGHT, Font.CR_DARKGRAY);
                pbx_image2 = " "; //its empty for now
                pbx_image3 = " "; //its empty for now
                break;

            // Draw the durablility bar and change the weapon icon
            case 'PBX_MastermindChaingun':
                let mcg = PBX_MastermindChaingun(pbWeap);
                if (!mcg) return; 
                PBHud_DrawImage("BARBADD2", (-73, -49), flagsright, playerBoxAlpha);
                PBHud_DrawBar("ABAR10", "BGBARL", GetAmount("MastermindCGDurability"), GetMaxAmount("MastermindCGDurability"), (-111, -52), 0, 1, flagsright);
                PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("MastermindCGDurability")), (-205, -68.75), DI_TEXT_ALIGN_RIGHT, Font.CR_DARKGRAY);
                pbx_image = "RMN1H0";
                pbx_image2 = " "; //its empty for now
                pbx_image3 = " "; //its empty for now
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
                pbx_image2 = " "; //its empty for now
                pbx_image3 = " "; //its empty for now
                break;

            case 'PBX_BDPRailgun':
                let railgun = PBX_BDPRailgun(pbWeap);
                if(!railgun) return;
                pbx_image  = railgun.laserActive ? "graphics/WeaponWheel/PlatRailgun/LaserOn.png" : icon;
                pbx_image2 = " "; //its empty for now
                pbx_image3 = " "; //its empty for now
                break;


//////////////// SLOT 8 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            //  Change the image if the weapon has been upgraded
            case 'PB_Flamethrower':
                bool flamerUpgraded = PBX_PlayerHasInventory("FlamerUpgraded");
                pbx_image = flamerUpgraded ? "FSPWB0" : "FSPWA0";
                pbx_image2 = " "; //its empty for now
                pbx_image3 = " "; //its empty for now
                break;

            // Shows the current primary and secondary mode
            case 'PB_CryoRifle':
                let cryorifle = PB_CryoRifle(pbWeap);
                if(!cryorifle) return;
                bool cryoMissile = cryorifle.cryoPrimary   == cryorifle.PRIM_MISSILE;
                bool cryoSpear   = cryorifle.cryoSecondary == cryorifle.SEC_SPEAR;
                pbx_image = "FRPKA0";
                pbx_image2 = cryoSpear ? "graphics/pywheel/CryoRifle_Spear.png" : "graphics/pywheel/CryoRifle_Flak.png";
                pbx_image3 = cryoMissile ? "graphics/pywheel/CryoRifle_Missile.png" : "graphics/pywheel/CryoRifle_Beam.png";
                pbx_image3 = " "; //its empty for now
                break;

//////////////// Missing Icons /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            // You dont need to add these weapons to the exceptions above since they dont count as valid
            case 'PB_ChexRifle':
                pbx_image = "CRRSA0";
                pbx_image2 = " "; //its empty for now
                break;
            case 'PB_LMG':
                pbx_image = "LMPIA0";
                pbx_image2 = " "; //its empty for now
                break;
            case 'PB_BFG9000':
                pbx_image = "097GA0";
                pbx_image2 = " "; //its empty for now
                break;
            case 'PB_Unmaker':
                pbx_image = "UNHDA0";
                pbx_image2 = " "; //its empty for now
                pbx_image3 = " "; //its empty for now
                break;

            default:
                pbx_image = " ";
                pbx_image2 = " ";
                pbx_image3 = " ";
                pbx_image3 = " "; //its empty for now
                break;
        }

        // Actually Draw the Thing
        PBX_DrawImage();
        if(pbx_image2 != " ") PBX_DrawImage(2);
        if(pbx_image3 != " ") PBX_DrawImage(3);
    }

    // THIS IS ALL AUXILLIARY FUNCTIONS JUST TO KEEP THE CODE CLEAN
    // Draw what type of image
    void PBX_DrawImage(int whatimage = 1)
    {
        switch(whatimage)
        {
            string image;
            Vector2 pos;
            Vector2 scale;
            Vector2 box;
            double transparency;

            // Weapon Pickup Sprite
            default:
            case 1:
                image           = pbx_image;
                pos             = pbx_weapon_pos;
                scale           =  pbx_weapon_truescale;
                transparency    = pbx_weapon_alpha;
                box             = pbx_weapon_box1;
                break;
            // Weapon Mode Sprite
            case 2:
                image           = pbx_image2;
                pos             = pbx_weapon_pos2;
                scale           = pbx_weapon_truescale2;
                transparency    = pbx_weaponmode_alpha;
                box             = pbx_weapon_box2;
                break;
            // Weapon Mode 2 Sprite
            case 3:
                image           = pbx_image3;
                pos             = pbx_weapon_pos3;
                scale           = pbx_weapon_truescale3;
                transparency    = pbx_weaponmode_alpha;
                box             = pbx_weapon_box3;
                break;
        }
        // PBHud_DrawImage(image, pos, flagsright, transparency, box: box, scale: scale);
        PBHud_DrawImage(image, pos, flagsright, transparency, scale: scale);
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
        if(!weap || !pbWeap) return;
        weaponAdjustments();
        DrawPBXWeaponAuto();
        DrawPBXWeaponManual();
    }
}