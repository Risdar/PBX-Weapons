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
                    case 'PBX_MetalSniper':
                        let sniper = PBX_MetalSniper(CPlayer.ReadyWeapon);
                        if(sniper && sniper.AltMode)
                        {
                            PBHud_DrawImage("BARBACR3", (-90, -71), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha);
                            PBHud_DrawBar("ABAR4", "BGBARL", GetAmount("PB_RocketAmmo"), GetMaxAmount("PB_RocketAmmo"), (-100, -72), 0, 1, DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM);
                            PBHud_DrawString(mDefaultFont, Formatnumber(GetAmount("PB_RocketAmmo")), (-207, -90), DI_TEXT_ALIGN_RIGHT, Font.CR_RED);
                        }
                        break;
                    case 'PBX_CSSG':
                        let cssg = PBX_CSSG(CPlayer.ReadyWeapon);
                        int pbx_xhudvalue = -130;
                        int pbx_yhudvalue = -90;
                        double pbx_scalehud = 2.0;
                        if(cssg)
                        {
                            int mode = cssg.shellsmode + 1;
                            switch(mode)
                            {
                                case 1: 
                                    PBHud_DrawImage("buckhud", (pbx_xhudvalue, pbx_yhudvalue), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha, scale: (pbx_scalehud, pbx_scalehud));
                                    break;
                                case 2:
                                    PBHud_DrawImage("slughud", (pbx_xhudvalue, pbx_yhudvalue), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha, scale: (pbx_scalehud, pbx_scalehud));
                                    break;
                                case 3: 
                                    PBHud_DrawImage("flcthud", (pbx_xhudvalue, pbx_yhudvalue), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha, scale: (pbx_scalehud, pbx_scalehud));
                                    break;
                                case 4: 
                                    PBHud_DrawImage("flakhud", (pbx_xhudvalue, pbx_yhudvalue), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha, scale: (pbx_scalehud, pbx_scalehud));
                                    break;
                                case 5: 
                                    PBHud_DrawImage("drgnhud", (pbx_xhudvalue, pbx_yhudvalue), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha, scale: (pbx_scalehud, pbx_scalehud));
                                    break; 
                                case 6:
                                    PBHud_DrawImage("explhud", (pbx_xhudvalue, pbx_yhudvalue), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha, scale: (pbx_scalehud, pbx_scalehud));
                                    break; 
                                case 7: 
                                    PBHud_DrawImage("phoshud", (pbx_xhudvalue, pbx_yhudvalue), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha, scale: (pbx_scalehud, pbx_scalehud));
                                    break;
                                case 8:
                                    PBHud_DrawImage("doomhud", (pbx_xhudvalue, pbx_yhudvalue), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha, scale: (pbx_scalehud, pbx_scalehud));
                                    break;
                                case 9:	
                                    PBHud_DrawImage("dnmkhud", (pbx_xhudvalue, pbx_yhudvalue), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_RIGHT_BOTTOM, playerBoxAlpha, scale: (pbx_scalehud, pbx_scalehud));
                                    break;
                            }
                        }
                        break;
                    default:
                        break;
                }
            }
       }
    }
}