class PBX_Hud : PB_Hud_ZS
{
    override void Draw(int state, double TicFrac)
    {
		Super.Draw(state, TicFrac);

        if(hudState != HUD_None)
		{
            DrawPBXHud();
		}
    }

    void DrawPBXWeaponMode()
    {
        let PB_Weap = CPlayer.ReadyWeapon;
        if (!PB_Weap) return;

        int flags = DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM;

        switch(PB_Weap.GetClassName())
        {
            case 'PBX_MetalSniper':
                let sniper = PBX_MetalSniper(PB_Weap);
                if (sniper && sniper.AltMode) 
                {
                    PBHud_DrawImage("BARBACR3", (-90, -71), flags, playerBoxAlpha);
                    PBHud_DrawBar("ABAR4", "BGBARL", GetAmount("PB_RocketAmmo"), GetMaxAmount("PB_RocketAmmo"), (-100, -72), 0, 1, flags);
                    PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("PB_RocketAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_RED);
                }
                break;

            case 'PBX_CSSG':
                let cssg = PBX_CSSG(PB_Weap);
                if (cssg) 
                {
                    Vector2 pos = (-130, -90);
                    Vector2 scale = (2.0, 2.0);

                    static const string cssgIcons[] = {
                        "buckhud", "slughud", "flcthud", "flakhud", "drgnhud", 
                        "explhud", "phoshud", "doomhud", "dnmkhud"
                    };
                    
                    int m = clamp(cssg.shellsmode, 0, cssgIcons.Size() - 1);
                    PBHud_DrawImage(cssgIcons[m], pos, flags, playerBoxAlpha, scale: scale);
                }
                break;

        }
    }

    void DrawPBXWeapon()
    {
        let PB_Weap = PB_WeaponBase(CPlayer.ReadyWeapon);
        if (!PB_Weap) return;

        TextureID iconID = PB_Weap.AltHudIcon.IsValid() ? PB_Weap.AltHudIcon : PB_Weap.Icon;

        if (iconID.IsValid())
        {
            Vector2 pos = (90, -90);
            Vector2 scale = (1.0, 1.0);
            int flags = DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT_BOTTOM;

            PBHud_DrawImage(TexMan.GetName(iconID), pos, flags, playerBoxAlpha, scale: scale);
        }
    }

    void DrawPBXHud()
    {
       let plr = PlayerPawn(CPlayer.mo);
       if(plr)
       {
            if(CPlayer.ReadyWeapon)
            {
                DrawPBXWeaponMode();
                DrawPBXWeapon();
            }
       }
    }
}