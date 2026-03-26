enum PBX_eHudSettingFlags{
    DisablePBX_WeaponHud				= 1 << 0,
    DisablePBX_WeaponModeHud			= 1 << 1
}

class PBX_Hud : PB_Hud_ZS
{
    double visorScale;
    double pbx_weapon_PosX, pbx_weapon_PosY, pbx_weapon_hudscale;
    double pbx_weaponmode_PosX, pbx_weaponmode_PosY, pbx_weaponmode_hudscale;
    Vector2 pbx_weapon_pos;
    Vector2 pbx_weapon_truescale;
    Vector2 pbx_weaponmode_pos;
    Vector2 pbx_weaponmode_truescale;
    int flagsleft, flagsright;

    override void Draw(int state, double TicFrac)
    {
		Super.Draw(state, TicFrac);

        if(hudState != HUD_None)
		{
            DrawPBXHud();
		}
    }

    void gatherPBXCVARs()
    {
        visorScale = CVar.GetCVar("pb_visorscale", CPlayer).GetFloat();
        pbx_weapon_PosX = CVar.GetCVar("pbx_Weaponhud_x", CPlayer).GetFloat();
        pbx_weapon_PosY = CVar.GetCVar("pbx_Weaponhud_y", CPlayer).GetFloat();
        pbx_weapon_hudscale = CVar.GetCVar("pbx_Weaponhud_scale", CPlayer).GetFloat();

        pbx_weapon_pos = (pbx_weapon_PosX, pbx_weapon_PosY);
        pbx_weapon_truescale = (pbx_weapon_hudscale, pbx_weapon_hudscale);

        pbx_weaponmode_PosX = CVar.GetCVar("pbx_WeaponModehud_x", CPlayer).GetFloat();
        pbx_weaponmode_PosY = CVar.GetCVar("pbx_WeaponModehud_y", CPlayer).GetFloat();
        pbx_weaponmode_hudscale = CVar.GetCVar("pbx_WeaponModehud_scale", CPlayer).GetFloat();

        pbx_weaponmode_pos = (pbx_weaponmode_PosX, pbx_weaponmode_PosY);
        pbx_weaponmode_truescale = (pbx_weaponmode_hudscale, pbx_weaponmode_hudscale);
        
        flagsleft = DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM;
        flagsright = DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM;
    }

    void DrawPBXWeaponMode()
    {
        if(pbx_hudsetting_filter & DisablePBX_WeaponModeHud) return;
        let PB_Weap = CPlayer.ReadyWeapon;
        if (!PB_Weap) return;

        switch(PB_Weap.GetClassName())
        {
            case 'PBX_MetalSniper':
                let sniper = PBX_MetalSniper(PB_Weap);
                if (sniper && sniper.AltMode) 
                {
                    PBHud_DrawImage("BARBACR3", (-90, -71), flagsright, playerBoxAlpha);
                    PBHud_DrawBar("ABAR4", "BGBARL", GetAmount("PB_RocketAmmo"), GetMaxAmount("PB_RocketAmmo"), (-100, -72), 0, 1, flagsright);
                    PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("PB_RocketAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_RED);
                }
                string image = sniper && sniper.resonanceAmmoLoaded ? "graphics/weapon wheel/metalsniper/ResonanceAlt.png" : "graphics/weapon wheel/metalsniper/StandardAlt.png";
                PBHud_DrawImage(image, pbx_weaponmode_pos, flagsright, playerBoxAlpha, scale: pbx_weaponmode_truescale);
                break;

            case 'PBX_CSSG':
                let cssg = PBX_CSSG(PB_Weap);
                if (cssg) 
                {
                    static const string cssgIcons[] = {
                        "buckhud", "slughud", "flcthud", "flakhud", "drgnhud", 
                        "explhud", "phoshud", "doomhud", "dnmkhud"
                    };
                    
                    int m = clamp(cssg.shellsmode, 0, cssgIcons.Size() - 1);
                    PBHud_DrawImage(cssgIcons[m], pbx_weaponmode_pos, flagsright, playerBoxAlpha, scale: pbx_weaponmode_truescale);
                }
                break;

        }
    }

    void DrawPBXWeapon()
    {
        if(pbx_hudsetting_filter & DisablePBX_WeaponHud) return;
        let PB_Weap = PB_WeaponBase(CPlayer.ReadyWeapon);
        if (!PB_Weap) return;

        TextureID iconID = PB_Weap.AltHudIcon.IsValid() ? PB_Weap.AltHudIcon : PB_Weap.Icon;

        if (iconID.IsValid())
        {
            PBHud_DrawImage(TexMan.GetName(iconID), pbx_weapon_pos, flagsright, playerBoxAlpha, scale: pbx_weapon_truescale);
        }
    }

    void DrawPBXHud()
    {
       let plr = PlayerPawn(CPlayer.mo);
       if(plr)
       {
            if(CPlayer.ReadyWeapon)
            {
                gatherPBXCVARs();
                DrawPBXWeaponMode();
                DrawPBXWeapon();
            }
       }
    }
}