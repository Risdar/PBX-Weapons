extend class PBX_PlasmaBlaster
{
    override void postbeginplay()
	{
        blasterPrimary   = PRIM_SEMI;
        blasterSecondary = SEC_BURST;
		super.postbeginplay();
	}

    action state handleWeaponSpecial()
    {
        A_StopSound(2);
        A_SetInventory("GoWeaponSpecialAbility", 0);
        PB_HandleCrosshair(79);
        A_ZoomFactor(1.0);

        // Get tokens
        bool goSemi     = CountInv("Plasma_Select_Semi")   > 0;
        bool goAuto     = CountInv("Plasma_Select_Auto")   > 0;
        bool goBurst    = CountInv("Plasma_Select_Burst")  > 0;
        bool goCharge   = CountInv("Plasma_Select_Charge") > 0;

        // Check if already selected, if yes go to ready3
        if( goAuto && getPrimary() == PRIM_AUTO || goBurst  && getSecondary() == SEC_BURST ||
            goSemi && getPrimary() == PRIM_SEMI || goCharge && getSecondary() == SEC_CHARGE) 
        {
            A_Print("$PB_ALREADYSELECTED"); 
            cleanModeTokens(); 
            return ResolveState("Ready3");
        }

        A_StartSound("BEP", CHAN_AUTO, CHANF_OVERLAP);

        // Change Mode and then fallthrough to the switch animation
        if(goAuto)    { A_Print("$PBX_PlasmaBlaster_Auto");    setPrimary(PRIM_AUTO);} 
        if(goSemi)    { A_Print("$PBX_PlasmaBlaster_Semi");    setPrimary(PRIM_SEMI);}
        if(goBurst)   { A_Print("$PBX_PlasmaBlaster_Burst");   setSecondary(SEC_BURST);}
        if(goCharge)  { A_Print("$PBX_PlasmaBlaster_Charge");  setSecondary(SEC_CHARGE);}     

        cleanModeTokens();
        return ResolveState(null);
    }

    action state fireWeapon(int tic)
    {
        int mode            = getPrimary();
        string projectile   = mode == PRIM_SEMI ? "HellPistolNormal" : "HellPistolAuto";

        switch(tic)
        {
            case 0:
                A_WeaponOffset(0,32);
                A_SetRoll(0);
                A_SetCrosshair(39);
                return PB_JumpIfNoAmmo(chamber:false);
                break;

            case 1:
                A_PlaySound("HRFire", CHAN_WEAPON);
		        PB_FireBullets(projectile, 1, 0, 0, 0, 0);
                PB_TakeAmmo(invoker.ammo2.getClassName());
                break;

            case 2:
                if(mode == PRIM_SEMI)
                {
                    if(JustPressed(BT_ATTACK)) return ResolveState("Fire");
                    return A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOPRIMARY);
                }
                else return resolvestate(null);
                break;

            case 3:
                if(mode == PRIM_AUTO)
                {
                    if(invoker.ammo2.amount > 0 && PressingFire()) return ResolveState("AutoFire");
                    else return PB_JumpIfNoAmmo(chamber:false);
                }
                else return resolvestate(null);
                break;
        }
        return resolvestate(null);
    }

    action void cleanModeTokens()
    {
        A_SetInventory("Plasma_Select_Auto",0);
        A_SetInventory("Plasma_Select_Semi",0);
        A_SetInventory("Plasma_Select_Burst",0);
        A_SetInventory("Plasma_Select_Charge",0);
    }

    action bool getPrimary()
    {
        return invoker.blasterPrimary;
    }

    action void setPrimary(bool set)
    {
        invoker.blasterPrimary = set;
    }

    action bool getSecondary()
    {
        return invoker.blasterSecondary;
    }

    action void setSecondary(bool set)
    {
        invoker.blasterSecondary = set;
    }
}