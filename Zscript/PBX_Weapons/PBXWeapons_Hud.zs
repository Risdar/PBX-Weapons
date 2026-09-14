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
                
            // Draw bar for the shield durability
            case 'PBX_NeoHMG':
                PBXCore_HUDHandler.PBX_DrawAmmoBar(
                    phud,
                    PBXCore_HUDHandler.DRAW_THIRD_BAR,
                    "BARBASH3",
                    "ABAR9",
                    "HMGShield",
                    Font.CR_GREEN
                );
                break;

            // Draw rocket ammo
            case 'PBX_ProSurvPSG':
                PBXCore_HUDHandler.PBX_DrawAmmoBar(
                    phud,
                    PBXCore_HUDHandler.DRAW_THIRD_BAR,
                    "BARBACR3",
                    "ABAR4",
                    "PB_RocketAmmo",
                    Font.CR_RED
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

            // Draw enraged bar
            case 'PBX_Paingiver':
                let pngv = PBX_Paingiver(pbWeap);
                // Show Fuel if Demonic Mode, Show Rocket if Standard Mode
                if(!pngv) return;

                bool enraged = pngv.enragedState;

                PBXCore_HUDHandler.PBX_DrawAmmoBar(
                    phud,
                    PBXCore_HUDHandler.DRAW_SECOND_BAR,
                    enraged ? "BARBACZ2"                      : "BARBASC2",
                    enraged ? "ABAR7"                         : "ABAR11",
                    "SoulCharge",
                    enraged ? Font.FindFontColor("PB_DTech")  : Font.CR_DARKRED
                );
                break;

            // Draw lightning charge bar
            case 'PBX_TeslaGun':
                PBXCore_HUDHandler.PBX_DrawAmmoBar(
                    phud,
                    PBXCore_HUDHandler.DRAW_THIRD_BAR,
                    "BARBACC3",
                    "ABAR8",
                    "Tesla_LightningCharge",
                    Font.FindFontColor("HUDBLUEBAR")
                );
                break;

            default:
                break;
        }
    }
}

//////////////////////////// WEAPON DATA ////////////////////////////////////////////////////////////////////////////////////
//////////////////////////// SLOT 2 ///////////////////////////////////////////////////////////////////////////////
class PBXHUDService_PBX_PlasmaBlaster : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_PlasmaBlaster')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;

        data.Image1 = "";       // Weapon Icon
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-22, 12);    // Weapon Icon Position
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 2.0;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

class PBXHUDService_PBX_ProsurvBlaster : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_ProsurvBlaster')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;

        data.Image1 = "";
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-30, 30);   // Weapon Icon Position
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 1.0;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

class PBXHUDService_PBX_LeverAction : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;
        if(weapon.GetClassName() != 'PBX_Prosurv_LeverAction')return null;
        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = true;

        let lar = PBX_Prosurv_LeverAction(objectArg);
        if(!lar) return null;

        data.Image1 = lar.mLaserSightActivated 
            ? "graphics/WeaponWheel/LeverAction/LaserOn.png" 
            : "graphics/WeaponWheel/LeverAction/LaserOff.png";
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = lar.mLaserSightActivated ? (0,18) : (-10, 18);
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = lar.mLaserSightActivated ? 0.6 : 0.7;
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

//////////////////////////// SLOT 3 ///////////////////////////////////////////////////////////////////////////////
class PBXHUDService_PBX_CSSG : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;
        if(weapon.GetClassName() != 'PBX_CSSG')return null;
        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;

        let cssg = PBX_CSSG(objectArg);
        if(!cssg) return null;
        
        static const string cssgIcons[] = {
            "buckhud", "slughud", "flcthud", 
            "flakhud", "drgnhud", "explhud", 
            "phoshud", "doomhud", "dnmkhud", 
            "subzhud", "helfhud", "acshhud"
        };
        // Show what Ammo type is selected
        int cssgshell = clamp(cssg.shellsmode, 0, cssgIcons.Size() - 1);

        data.Image1 = "";
        data.Image2 = cssgIcons[cssgshell];
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-5, 12);
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 0.9; 
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

class PBXHUDService_PBX_PSG : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_ProSurvPSG')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = true;

        let psg = PBX_ProSurvPSG(objectArg);
        if(!psg) return null;

        data.Image1 = psg.mLaserSightActivated 
            ? "graphics/WeaponWheel/ProsurvPSG/LaserOn.png" 
            : "graphics/WeaponWheel/ProsurvPSG/LaserOff.png";
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = psg.mLaserSightActivated ? (13,-9) : (-5, -7); 
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = psg.mLaserSightActivated ? 0.8 : 1.1;
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

class PBXHUDService_PBX_SPAS12 : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_SPAS12')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;

        data.Image1 = "";
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-10,10); 
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 0.65;
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

class PBXHUDService_PBX_CryoSG : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_CryoSG')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;

        data.Image1 = "";       // Weapon Icon
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-15, 15);    // Weapon Icon Position
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 1.35;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

class PBXHUDService_PBX_CryoASG : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_CryoASG')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;

        data.Image1 = "";       // Weapon Icon
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-15, 15);    // Weapon Icon Position
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 1.5;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

//////////////////////////// SLOT 4 ///////////////////////////////////////////////////////////////////////////////
class PBXHUDService_PBX_BattleRifle : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_BDPBattleRifle')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = true;

        let br = PBX_BDPBattleRifle(objectArg);
        if(!br) return null;

        data.Image1 = br.mLaserSightActivated 
            ? "graphics/WeaponWheel/BattleRifle/br_LaserOn.png" 
            : "graphics/WeaponWheel/BattleRifle/br_LaserOff.png";
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = br.mLaserSightActivated ? (0,12) : (-7, 12);  
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = br.mLaserSightActivated ? 0.7 : 1.3;
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

class PBXHUDService_PBX_MetalSniper : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_MetalSniper')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = true;

        let sniper = PBX_MetalSniper(objectArg);
        if(!sniper) return null;

        data.Image1 = sniper.mLaserSightActivated 
            ? "graphics/WeaponWheel/MetalSniper/LaserOn.png" 
            : "graphics/WeaponWheel/MetalSniper/LaserOff.png";
        data.Image2 = sniper.resonanceAmmoLoaded ? 
            "graphics/WeaponWheel/metalsniper/ResonanceAlt.png"
            : "graphics/WeaponWheel/metalsniper/StandardAlt.png";
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = sniper.mLaserSightActivated ? (0,10) : (0,14); 
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        if(sniper.AltMode) data.Offset1.y -= 19;

        data.Scale1 = 1.0;      // Weapon Icon Scale
        data.Scale2 = 0.7;      // Weapon Mode Icon Scale

        return data;
    }
}

class PBXHUDService_PBX_Crossbow : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_Prosurv_Ballista')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;

        data.Image1 = "";
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-10, 10);   // Weapon Icon Position
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 1.0;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

class PBXHUDService_PBX_NormalRifle : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_NormalRifle')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = true;

        let nr = PBX_NormalRifle(objectArg);
        if(!nr) return null;

        data.Image1 = nr.mLaserSightActivated 
            ? "graphics/WeaponWheel/NormalRifle/laseron.png" 
            : "graphics/WeaponWheel/NormalRifle/laseroff.png";
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = nr.mLaserSightActivated ? (0,12) : (-5,12);
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = nr.mLaserSightActivated ? 0.8 : 0.9;
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

//////////////////////////// SLOT 5 ///////////////////////////////////////////////////////////////////////////////
class PBXHUDService_PBX_NeoHMG : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_NeoHMG')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;

        data.Image1 = "";       // Weapon Icon
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-3,-3);   // Weapon Icon Position
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 1.6;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

class PBXHUDService_PBX_EternalChaingun : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_EternalMinigun')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;

        data.Image1 = "";       // Weapon Icon
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-20,35);   // Weapon Icon Position
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 1.5;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

class PBXHUDService_PBX_SuperNailgun : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_SuperNailgun')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;

        data.Image1 = "";       // Weapon Icon
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-2,16);   // Weapon Icon Position
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 0.7;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

//////////////////////////// SLOT 6 ///////////////////////////////////////////////////////////////////////////////
class PBXHUDService_PBX_CyberRL : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_CyberdemonRL')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;

        data.Image1 = "";       // Weapon Icon
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-12, 12);   // Weapon Icon Position
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 1.6;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

class PBXHUDService_PBX_MasterCG : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_MastermindChaingun')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = true;

        data.Image1 = "RMN1H0"; // Weapon Icon
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-10, 40);   // Weapon Icon Position
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 1.6;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

class PBXHUDService_PBX_Excavator : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_Excavator')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;


        data.Image1 = "";       // Weapon Icon
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-10, 15);     // Weapon Icon Position
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 1.1;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

class PBXHUDService_PBX_Paingiver : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_Paingiver')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;

        data.Image1 = "";       // Weapon Icon
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-10,15); // Weapon Icon Position
        data.Offset2 = (0,0);    // Weapon Mode Icon Position

        data.Scale1 = 1.3;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

//////////////////////////// SLOT 7 ///////////////////////////////////////////////////////////////////////////////
class PBXHUDService_PBX_Railgun : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_BDPRailgun')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = true;

        let railgun = PBX_BDPRailgun(objectArg);
        if(!railgun) return null;

        data.Image1 = railgun.mLaserSightActivated 
            ? "graphics/WeaponWheel/PlatRailgun/LaserOn.png" 
            : "graphics/WeaponWheel/PlatRailgun/LaserOff.png";
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = railgun.mLaserSightActivated ? (0,12) : (-5, 12);   // Weapon Icon Position
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = railgun.mLaserSightActivated ? 0.7 : 1.4;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

//////////////////////////// SLOT 8 ///////////////////////////////////////////////////////////////////////////////
class PBXHUDService_PBX_TeslaGun : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_TeslaGun')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;

        data.Image1 = "";       // Weapon Icon
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-10, -10);    // Weapon Icon Position
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 1.4;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

//////////////////////////// SLOT 9 ///////////////////////////////////////////////////////////////////////////////
class PBXHUDService_PBX_DemonExt : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_DemonExt')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;

        data.Image1 = "";       // Weapon Icon
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-10, 10);    // Weapon Icon Position
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 1.3;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

class PBXHUDService_PBX_NukeLauncher : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_NukeLauncher')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;

        data.Image1 = "";       // Weapon Icon
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (25,35);   // Weapon Icon Position
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 1.5;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}