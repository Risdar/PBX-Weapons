// The Wheel for Scope Mode, Variable Zoom, and NVG Toggle uses these values for its scale
const WHEEL_ZOOM_SCALE       = 0.16;
const WHEEL_SCOPE_SCALE      = 0.16;
const WHEEL_NVG_SCALE        = 0.5;
const WHEEL_CLOSEMENU_SCALE  = 0.15;

// Draw the ammo bar for some weapons
class PBXWeapons_HUDHandler : EventHandler
{
//////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////////////////////
    ui int flagsManualVisor1, flagsManualVisor2;
    ui int8 pbx_m32to0;
    ui float pbx_visorOffsets;
    ui vector2 topOffsets1, topOffsets2;

    // The constants used for MetalSniper's overlay (the graphics you see at the side when target scope is active)
    const MS_SCOPEOVERLAY = 24; 

//////////////////////////// MAIN FUNCTION ////////////////////////////////////////////////////////////////////////////////////
    override void RenderOverlay(RenderEvent e)
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

        // These are used for the Metal Sniper Smart Scope Overlay
        pbx_visorOffsets = phud.visorOffsets;
        pbx_m32to0 = phud.m32to0;
        topOffsets1 = ((-MS_SCOPEOVERLAY - pbx_visorOffsets) + (-pbx_m32to0), -MS_SCOPEOVERLAY - pbx_visorOffsets - pbx_m32to0);
        topOffsets2 = ((MS_SCOPEOVERLAY + pbx_visorOffsets) + (pbx_m32to0), -MS_SCOPEOVERLAY - pbx_visorOffsets - pbx_m32to0);
        flagsManualVisor1 = BaseStatusBar.DI_ITEM_LEFT | BaseStatusBar.DI_SCREEN_LEFT | BaseStatusBar.DI_ITEM_VCENTER | BaseStatusBar.DI_SCREEN_VCENTER;
        flagsManualVisor2 = BaseStatusBar.DI_ITEM_RIGHT | BaseStatusBar.DI_SCREEN_RIGHT | BaseStatusBar.DI_MIRROR | BaseStatusBar.DI_ITEM_VCENTER | BaseStatusBar.DI_SCREEN_VCENTER;
        
        // Begin drawing the HUD
        phud.BeginHUD();                    // Initialize

        switch(pbWeap.GetClassName())
        {
            // Draw bars and effects for specific modes
            case 'PBX_MetalSniper':
                let sniper = PBX_MetalSniper(pbWeap);
                if(!sniper) return;
                
                // Show Rocket Ammo if Grenade Secondary Mode is Selected
                if (sniper.AltMode) 
                    PBXCore_HUDHandler.PBX_DrawAmmoBar(
                        phud,
                        PBXCore_HUDHandler.
                        DRAW_THIRD_BAR,
                        "BARBACR3",
                        "ABAR4",
                        "PB_RocketAmmo",
                        Font.CR_RED
                    );

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

                bool dbMode = crossbow.demonicBallistaMode;

                PBXCore_HUDHandler.PBX_DrawAmmoBar(
                    phud,
                    PBXCore_HUDHandler.DRAW_THIRD_BAR,
                    dbMode ? "BARBACD3"     : "BARBACR3",
                    dbMode ? "ABAR6"        : "ABAR4",
                    dbMode ? "PB_Fuel"      : "PB_RocketAmmo",
                    dbMode ? Font.CR_RED    : Font.FindFontColor("PB_Fuel")
                );
                    
                break;

            // Draw bar for the shield durability
            case 'PBX_NeoHMG':
                PBXCore_HUDHandler.PBX_DrawAmmoBar(
                    phud,
                    PBXCore_HUDHandler.
                    DRAW_THIRD_BAR,
                    "BARBASH3",
                    "ABAR9",
                    "HMGShield",
                    Font.CR_GREEN
                );
                break;

            // Draw the durability bar
            case 'PBX_CyberdemonRL':
                PBXCore_HUDHandler.PBX_DrawAmmoBar(
                    phud,
                    PBXCore_HUDHandler.DRAW_SECOND_BAR,
                    "BARBADD2",
                    "ABAR10",
                    "CyberRLDurability",
                    Font.CR_DARKGRAY
                );
                break;

            case 'PBX_MastermindChaingun':
                PBXCore_HUDHandler.PBX_DrawAmmoBar(
                    phud,
                    PBXCore_HUDHandler.DRAW_SECOND_BAR,
                    "BARBADD2",
                    "ABAR10",
                    "MastermindCGDurability",
                    Font.CR_DARKGRAY
                );
                break;

            default:
                break;
        }
    }
}


