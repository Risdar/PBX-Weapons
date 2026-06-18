// The Wheel for Scope Mode, Variable Zoom, and NVG Toggle uses these values for its scale
const WHEEL_ZOOM_SCALE  = 0.16;
const WHEEL_SCOPE_SCALE = 0.16;
const WHEEL_NVG_SCALE   = 0.5;

// Draw the ammo bar for some weapons
class PBXWeapons_HUDHandler : EventHandler
{
//////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////////////////////
    // Icons
    ui string pbx_image, pbx_image2, pbx_image3;

    // Flags
    ui int flagsleft, flagsright, flagssTextAlignRight, flagsManualVisor1, flagsManualVisor2;

    // Others
    ui int8 pbx_m32to0;
    ui float pbx_visorOffsets;
    ui vector2 topOffsets1, topOffsets2;

    // Defaults for the draw ammo bar function
    ui vector2 BGBAR_AMMO2_DEFAULT,ABAR_AMMO2_DEFAULT,ASTRING_AMMO2_DEFAULT;  
    ui vector2 BGBAR_AMMO3_DEFAULT,ABAR_AMMO3_DEFAULT,ASTRING_AMMO3_DEFAULT;  

    // This is a boolean for now
    enum PBXHud_DrawBarSettings{
        DRAW_SECOND_BAR,
        DRAW_THIRD_BAR
    }

//////////////////////////// MAIN FUNCTION ////////////////////////////////////////////////////////////////////////////////////
    override void RenderUnderlay(RenderEvent e)
    {
        // Dont draw if the player is not in a leve or if the automap is active
        if (gamestate != GS_LEVEL || automapactive)
            return;

        // Get a pointer to the PB Hud so we can access it
        let phud = PB_Hud_ZS(StatusBar);
        if (!phud) return;

        // Dont draw if the player is dead
        if (phud.hudState == BaseStatusBar.HUD_None || phud.PlayerWasDead) 
            return;

        // Get a pointer to the player and weapon
        let plr = players[consoleplayer];
        let weap = plr.ReadyWeapon;
        let pbWeap = PB_WeaponBase(weap);
        if (!pbWeap) return;

        // Flags
        flagsleft = BaseStatusBar.DI_SCREEN_LEFT_BOTTOM | BaseStatusBar.DI_ITEM_LEFT_BOTTOM;
        flagsright = BaseStatusBar.DI_SCREEN_RIGHT_BOTTOM | BaseStatusBar.DI_ITEM_RIGHT_BOTTOM;
        flagssTextAlignRight = BaseStatusBar.DI_TEXT_ALIGN_RIGHT;

        // These are used for the Metal Sniper Smart Scope Overlay
        pbx_visorOffsets = phud.visorOffsets;
        pbx_m32to0 = phud.m32to0;
        topOffsets1 = ((-24 - pbx_visorOffsets) + (-pbx_m32to0), -24 - pbx_visorOffsets - pbx_m32to0);
        topOffsets2 = ((24 + pbx_visorOffsets) + (pbx_m32to0), -24 - pbx_visorOffsets - pbx_m32to0);
        flagsManualVisor1 = BaseStatusBar.DI_ITEM_LEFT | BaseStatusBar.DI_SCREEN_LEFT | BaseStatusBar.DI_ITEM_VCENTER | BaseStatusBar.DI_SCREEN_VCENTER;
        flagsManualVisor2 = BaseStatusBar.DI_ITEM_RIGHT | BaseStatusBar.DI_SCREEN_RIGHT | BaseStatusBar.DI_MIRROR | BaseStatusBar.DI_ITEM_VCENTER | BaseStatusBar.DI_SCREEN_VCENTER;
        
        // These are the defaults for the PBX's Draw Ammo Bar
        BGBAR_AMMO2_DEFAULT      = (-73, -49);
        ABAR_AMMO2_DEFAULT       = (-111, -52);
        ASTRING_AMMO2_DEFAULT    = (-205, -68.75);

        BGBAR_AMMO3_DEFAULT       = (-90, -71);
        ABAR_AMMO3_DEFAULT        = (-100, -72);
        ASTRING_AMMO3_DEFAULT     = (-207, -90);

        // Begin drawing the HUD
        phud.BeginHUD();                    // Initialize
        DrawPBXWeaponBar(phud,pbWeap);
    }

//////////////////////////// BAR ////////////////////////////////////////////////////////////////////////////////////
    protected
    ui void DrawPBXWeaponBar(PB_Hud_ZS phud, PB_WeaponBase pbWeap)
    {       
        // Set Defaults & Variables
        TextureID iconID = pbWeap.AltHudIcon.IsValid() ? pbWeap.AltHudIcon : pbWeap.Icon;
        string icon = TexMan.GetName(iconID);

        switch(pbWeap.GetClassName())
        {
            // Draw bars and effects for specific modes
            case 'PBX_MetalSniper':
                let sniper = PBX_MetalSniper(pbWeap);
                if(!sniper) return;
                
                // Show Rocket Ammo if Grenade Secondary Mode is Selected
                if (sniper.AltMode) 
                    PBX_DrawAmmoBar(phud,DRAW_THIRD_BAR,"BARBACR3","ABAR4","PB_RocketAmmo",Font.CR_RED);

                // This draws the overlay when the smart scope is enabled
                if (sniper.enableScopeHUD)
                {
                    // Draw
					phud.PBHud_DrawImageManualAlpha("NIGHTVIS", (topOffsets1.x, 0), flagsManualVisor1, 0.5 + 0.5 * abs(sin(level.MapTime)), scale: (0.3, 0.3), parallax: 1.5, parallax2: 1.5);
					phud.PBHud_DrawImageManualAlpha("NIGHTVIS", (topOffsets2.x, 0), flagsManualVisor2, 0.5 + 0.5 * abs(sin(level.MapTime)), scale: (0.3, 0.3), parallax: 1.5, parallax2: 1.5);
                }
                break;
                
            // Draw bars for specific modes and the current weapon
            case 'PBX_Prosurv_Ballista':
                let crossbow = PBX_Prosurv_Ballista(pbWeap);
                // Show Fuel if Demonic Mode, Show Rocket if Standard Mode
                if(!crossbow) return;

                if (crossbow.demonicBallistaMode) 
                    PBX_DrawAmmoBar(phud,DRAW_THIRD_BAR,"BARBACD3","ABAR6","PB_Fuel",Font.CR_RED);
                else 
                    PBX_DrawAmmoBar(phud,DRAW_THIRD_BAR,"BARBACR3","ABAR4","PB_RocketAmmo",Font.CR_RED);
                    
                break;

            // Draw the durability bar
            case 'PBX_CyberdemonRL':
                let crl = PBX_CyberdemonRL(pbWeap);
                if(!crl) return;

                PBX_DrawAmmoBar(phud,DRAW_SECOND_BAR,"BARBADD2","ABAR10","CyberRLDurability",Font.CR_DARKGRAY);
                break;

            case 'PBX_MastermindChaingun':
                let mcg = PBX_MastermindChaingun(pbWeap);
                if (!mcg) return; 

                PBX_DrawAmmoBar(phud,DRAW_SECOND_BAR,"BARBADD2","ABAR10","MastermindCGDurability",Font.CR_DARKGRAY);
                break;

            default:
                break;
        }

    }

//////////////////////////// HELPER FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////
    // Wrapper for PB's draw ammo bar
    protected
    ui void PBX_DrawAmmoBar(
        PB_Hud_ZS phud,     // Pointer to the PB Hud
        bool whatBar,       // What Bar to Draw
        String bgimg,       // Background Image
        String ongfx,       // Ammo Bar
        String ammoName,    // What Ammo to Count
        int fontTranslation // Font Color
    )
    {
        vector2 bgpos       = whatBar ? BGBAR_AMMO3_DEFAULT     : BGBAR_AMMO2_DEFAULT;
        vector2 barpos      = whatBar ? ABAR_AMMO3_DEFAULT      : ABAR_AMMO2_DEFAULT;
        vector2 stringpos   = whatBar ? ASTRING_AMMO3_DEFAULT   : ASTRING_AMMO2_DEFAULT;

        phud.PBHud_DrawImage(bgimg, bgpos, flagsright, phud.playerBoxAlpha);
        phud.PBHud_DrawBar(ongfx, "BGBARL", phud.GetAmount(ammoName), phud.GetMaxAmount(ammoName), barpos, 0, 1, flagsright);
        phud.PBHud_DrawString(phud.mDefaultFont, phud.Formatnumber(phud.GetAmount(ammoName)), stringpos, flagssTextAlignRight, fontTranslation);
    }

}


