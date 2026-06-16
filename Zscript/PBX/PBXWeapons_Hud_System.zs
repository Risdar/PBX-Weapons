#include "./PBXWeapons_Hud_Data.zs" // What actually contains the data for the PBX Weapons

enum PBX_eHudSettingFlags{
    DisablePBX_WeaponHud				= 1 << 0,
}

// The Wheel for Scope Mode, Variable Zoom, and NVG Toggle uses these values for its scale
const WHEEL_ZOOM_SCALE  = 0.16;
const WHEEL_SCOPE_SCALE = 0.16;
const WHEEL_NVG_SCALE   = 0.5;

// HUD System
class PBXHUD_Handler : EventHandler
{
//////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////////////////////
    // Position
    ui int pbx_weapon_PosX, pbx_weapon_PosY, pbx_weaponmode_PosX, pbx_weaponmode_PosY;

    // Scale
    ui double pbx_weaponmode_hudscale, pbx_weapon_hudscale;

    // Transparency
    ui double pbx_weapon_alpha, pbx_weaponmode_alpha;

    // Cut Off Range (Box)
    ui int pbx_weapon_boxW, pbx_weapon_boxH;
    ui int pbx_weaponmode_boxW, pbx_weaponmode_boxH;

    // Combine all individual values into one vector2
    ui Vector2 pbx_weapon_pos, pbx_weapon_truescale, pbx_weapon_box1;
    ui Vector2 pbx_weapon_pos2, pbx_weapon_truescale2, pbx_weapon_box2;
    ui Vector2 pbx_weapon_pos3, pbx_weapon_truescale3, pbx_weapon_box3;

    // Flags
    ui int flagsleft, flagsright, flagssTextAlignRight, flagsManualVisor1, flagsManualVisor2;

    // Icons
    ui string pbx_image, pbx_image2, pbx_image3;

    // Services
    ui Array<Service> PBX_HUDServices;
    ui bool ServicesLoaded;

    // Others
    ui bool isAkimbo;
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

    enum PBXHud_DrawImageSettings{
        DRAW_WEAPON_ICON    = 1,
        DRAW_MODE_ICON      = 2,
        DRAW_MODE2_ICON     = 3
    }

//////////////////////////// MAIN FUNCTION ////////////////////////////////////////////////////////////////////////////////////
    override void RenderUnderlay(RenderEvent e)
    {
        // Dont draw if the HUD is disabled
        if(PBXWeapons_hudsetting_filter & DisablePBX_WeaponHud) 
            return;

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

        // If the menu is active or the console is up
        if (menuactive || consolestate == c_up)
            gatherPBXCVARs(plr,phud); // Gather the CVARs

        // Begin drawing the HUD
        phud.BeginHUD();                    // Initialize
        FindHUDServices();                  // Find other mods that uses PBX HUD
        weaponAdjustments(pbWeap);          // Load in the weapon hud adjustments
        DrawPBXWeaponAuto(phud, pbWeap);    // Automatically draw weapons that set their AltHudIcon
        
        // First check if any other mod added their own PBX Hud
        // if there is then draw them
        let ext = GetExternalHUD(pbWeap);
        if (ext)
        {
            pbx_image = ext.Image1;
            pbx_image2 = ext.Image2;
            pbx_image3 = ext.Image3;

            pbx_weapon_pos += ext.Offset1;
            pbx_weapon_pos2 += ext.Offset2;
            pbx_weapon_pos3 += ext.Offset3;

            pbx_weapon_truescale *= ext.Scale1;
            pbx_weapon_truescale2 *= ext.Scale2;
            pbx_weapon_truescale3 *= ext.Scale3;

            PBX_DrawImage(phud, DRAW_WEAPON_ICON);

            if(ext.Image2 != "")
                PBX_DrawImage(phud, DRAW_MODE_ICON);

            if(ext.Image3 != "")
                PBX_DrawImage(phud, DRAW_MODE2_ICON);

        }

        // If there isnt any then fallback to default
        else
        {
            DrawPBXWeaponManual(phud,pbWeap);
        }
    }

//////////////////////////// GATHER DATA ////////////////////////////////////////////////////////////////////////////////////
    // Find the Services function
    private
    ui void FindHUDServices()
    {
        if (ServicesLoaded)
            return;

        let it = ServiceIterator.Find("PBXHUDService");

        Service svc;

        while ((svc = it.Next()))
        {
            PBX_HUDServices.Push(svc);
        }

        ServicesLoaded = true;
    }

    // Function to get the Data from those Services
    private
    ui PBXHUDData GetExternalHUD(PB_WeaponBase weapon)
    {
        for (int i = 0; i < PBX_HUDServices.Size(); i++)
        {
            let data = PBXHUDData(PBX_HUDServices[i].GetObjectUI("PBX_HUD",objectArg:weapon));
            if (data && data.Handled){
                // console.printf("data loaded");
                return data;
            }
        }
        return null;
    }

    // Get the user CVARs
    protected
    ui void gatherPBXCVARs(PlayerInfo plr, PB_Hud_ZS phud)
    {
        // Weapon Pickup Sprites
        pbx_weapon_PosX = CVar.GetCVar("pbxweapons_Weaponhud_x", plr).GetInt();
        pbx_weapon_PosY = CVar.GetCVar("pbxweapons_Weaponhud_y", plr).GetInt();
        pbx_weapon_hudscale = CVar.GetCVar("pbxweapons_Weaponhud_scale", plr).GetFloat();
        pbx_weapon_alpha = CVar.GetCVar("pbxweapons_Weaponhud_alpha", plr).GetFloat();
        pbx_weapon_boxW = CVar.GetCVar("pbxweapons_Weaponhud_boxW", plr).GetInt();
        pbx_weapon_boxH = CVar.GetCVar("pbxweapons_Weaponhud_boxH", plr).GetInt();

        pbx_weapon_pos = (pbx_weapon_PosX, pbx_weapon_PosY);
        pbx_weapon_truescale = (pbx_weapon_hudscale, pbx_weapon_hudscale);
        pbx_weapon_box1 = (pbx_weapon_boxW, pbx_weapon_boxH);

        // Weapon Modes
        pbx_weaponmode_PosX = CVar.GetCVar("pbxweapons_WeaponModehud_x", plr).GetInt();
        pbx_weaponmode_PosY = CVar.GetCVar("pbxweapons_WeaponModehud_y", plr).GetInt();
        pbx_weaponmode_hudscale = CVar.GetCVar("pbxweapons_WeaponModehud_scale", plr).GetFloat();
        pbx_weaponmode_alpha = CVar.GetCVar("pbxweapons_WeaponModehud_alpha", plr).GetFloat();
        pbx_weaponmode_boxW = CVar.GetCVar("pbxweapons_WeaponModehud_boxW", plr).GetInt();
        pbx_weaponmode_boxH = CVar.GetCVar("pbxweapons_WeaponModehud_boxH", plr).GetInt();

        pbx_weapon_pos2 = (pbx_weaponmode_PosX, pbx_weaponmode_PosY);
        pbx_weapon_truescale2 = (pbx_weaponmode_hudscale, pbx_weaponmode_hudscale);
        pbx_weapon_box2 = (pbx_weaponmode_boxW, pbx_weaponmode_boxH);
        
        // Special cases where weapons uses two modes at the same time
        pbx_weapon_pos3 = pbx_weapon_pos2 + (0,-10);
        pbx_weapon_truescale3 = pbx_weapon_truescale2;
        pbx_weapon_box3 = (pbx_weaponmode_boxW, pbx_weaponmode_boxH);

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

    }

//////////////////////////// HELPER FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////
    protected
    ui void PBX_DrawImage(PB_Hud_ZS phud, PBXHud_DrawImageSettings whatimage)
    {
        string image; 
        Vector2 pos, scale, box; 
        double transparency;

        switch (whatimage)
        {
            default:
            case DRAW_WEAPON_ICON : image = pbx_image;  pos = pbx_weapon_pos;  scale = pbx_weapon_truescale;  transparency = pbx_weapon_alpha;     box = pbx_weapon_box1; break;
            case DRAW_MODE_ICON   : image = pbx_image2; pos = pbx_weapon_pos2; scale = pbx_weapon_truescale2; transparency = pbx_weaponmode_alpha; box = pbx_weapon_box2; break;
            case DRAW_MODE2_ICON  : image = pbx_image3; pos = pbx_weapon_pos3; scale = pbx_weapon_truescale3; transparency = pbx_weaponmode_alpha; box = pbx_weapon_box3; break;
        }
        phud.PBHud_DrawImage(image, pos, flagsright, transparency, scale: scale);
    }

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

    // This function can be called from anywhere by using the PBXHUD_Handler prefix
    // so it'll be PBXHUD_Handler.PBX_PlayerHasInventory("inventoryname");
    static clearscope bool PBX_PlayerHasInventory(name inv)
    {
        return PlayerPawn(players[consoleplayer].mo).CountInv(inv) > 0;
    }
}

// Data class for the HUD
class PBXHUDData : Object
{
    bool Handled;

    String Image1;
    String Image2;
    String Image3;

    Vector2 Offset1;
    Vector2 Offset2;
    Vector2 Offset3;

    double Scale1;
    double Scale2;
    double Scale3;
}

// ALWAYS START THE NAME WITH "PBXHUDService" , after that you can name it whatever
// MAKE SURE IT INHERITS "service"
// class PBXHUDService_Katana : service
// {
//     // Override this function, you can just copy and paste it
//     override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
//     {
//         // You dont need to change these since they're only for initialization
//         if(request != "PBX_HUD") return null;
//         let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
//         if(!weapon) return null;

//         // Change this to your weapon name
//         if(weapon.GetClassName() != 'PB_ArgentSith')return null;

//         // This is to make sure the data is initialized, you can also ignore this
//         let data = new("PBXHUDData");
//         data.Handled = true;

//         // If you want to check the players inventory for weapon mode
//         // use PBXHUD_Handler.PBX_PlayerHasInventory("inventorynamehere");
//         // like this example
// 		bool haszoom = PBXHUD_Handler.PBX_PlayerHasInventory("zoomed");

//         // This is where all the data is
//         // You can change anything here

//         // This is the path for the weapon icons
//         data.Image1 = "";       // Weapon Icon
//         data.Image2 = "";       // Weapon Mode Icon
//         data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

//         // This is for its position (x,y)
//         data.Offset1 = (0,0);   // Weapon Icon Position
//         data.Offset2 = (0,0);   // Weapon Mode Icon Position

//         // This is for the scale
//         data.Scale1 = 1.0;      // Weapon Icon Scale
//         data.Scale2 = 1.0;      // Weapon Mode Icon Scale

//         // You can ignore this
//         return data;
//     }
// }