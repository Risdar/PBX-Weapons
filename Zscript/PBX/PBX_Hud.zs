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

    void DrawPBXHud()
    {
       let plr = PlayerPawn(CPlayer.mo);
       if(plr)
       {
            if(CPlayer.ReadyWeapon)
            {
                let PB_Weap = PB_WeaponBase(CPlayer.ReadyWeapon);
                switch(CPlayer.ReadyWeapon.GetClassName())
                {
                    case 'PB_MetalSniper':
                        let sniper = PB_MetalSniper(CPlayer.ReadyWeapon);
                        if(sniper && sniper.AltMode)
                        {
                            PBHud_DrawImage("BARBACR3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
                            PBHud_DrawBar("ABAR4", "BGBARL", GetAmount("PB_RocketAmmo"), GetMaxAmount("PB_RocketAmmo"), (-100, -72), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
                            PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("PB_RocketAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_RED);
                        }
                        break;
                    default:
                        break;
                }
            }
       }
    }
}