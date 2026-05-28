extend class PBX_MetalSniper
{
    // ── Overrides ──────────────────────────────────────────────────────────────────
    override void PostBeginPlay()
    {
        grenadeloaded  = true;
        currentMaxAmmo = MetalSniperFullAmmo;
        LockedOn = false;
        ScopeMode = 0;
        enableScopeHUD = false;
        Super.PostBeginPlay();
    }

    // ═════════════════════════════════════════════════════════════════════════
    // ACTION FUNCTIONS
    // ═════════════════════════════════════════════════════════════════════════

    action state MS_ReadyZoom()
    {
        A_SetRoll(0);
        // PB_HandleCrosshair(-1);
        A_SetCrosshair(-1);
        PB_CoolDownBarrel(-5, 0, 7, 0,  1);
        PB_CoolDownBarrel( 5, 0, 7, 0, -1);
        A_SetInventory("PB_LockScreenTilt", 0);
        if(invoker.ScopeMode == 1 || invoker.ScopeMode == 2)
        {
            // A_SetBlend(0x00a100, 0.2, 99999);
            A_SetCrosshair(52);
            A_ZoomFactor(5.0);
            MS_ReadyScope();
            A_SetRenderstyle(0.1, Style_Translucent);
            invoker.enableScopeHUD = true;
        }
        else
        {
            // EndBlend("DarkGreen");
            invoker.enableScopeHUD = false;
            A_SetRenderstyle(1.0, STYLE_Normal);
            A_ZoomFactor(4.0);
        }

        if (PB_GetAimMode())
        {
            if (!PressingAltfire() || JustReleased(BT_ALTATTACK))
                return resolvestate("ZoomOut");

            if (PressingFire() && PressingAltfire() && CountInv(invoker.ammotype2) > 0)
                return resolvestate("Fire_ADS");

            return A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOSECONDARY);
        }
        else
        {
            if (PressingFire() && CountInv(invoker.ammotype2) > 0)
                return resolvestate("Fire_ADS");

            return A_DoPBWeaponAction(WRF_ALLOWRELOAD);
        }
        return ResolveState(null);
    }

    // ── Scope Function ────────────────────────────────────────────────────────
    // action void MS_ReadyNormal()
    // {
    //     FLineTraceData Bule;
    //     bool hit = LineTrace(Angle, 6000, Pitch, 0, player.ViewHeight, 0, 0, Bule);
    //     if(hit)
    //     {
    //         if(Bule.HitActor && Bule.HitActor.bISMONSTER && Bule.HitActor.bFRIENDLY == false && Bule.HitActor is "PB_Monster")
    //         {				
    //             if(!invoker.LockedOn)
    //             {
    //                 invoker.LockedOn = true;
    //                 A_StartSound("IronSights", CHAN_WEAPON, volume:0.5, pitch:1.4);
    //             }
    //             // let damn = player.FindPSprite(1);
    //             // if(damn)
    //             // {
    //             //     damn.frame = 3;
    //             //     damn.sprite = GetSpriteIndex("SPRF");
    //             // }
    //         }
    //         else
    //         if(invoker.LockedOn)
    //         {
    //             invoker.LockedOn = false;
    //             A_StartSound("IronSights", CHAN_WEAPON, volume:0.5, pitch:1.3);
    //         }
    //     }	
    //     // return A_DoPBWeaponAction();
    // }
    
    action void MS_ReadyScope()
    {
        FLineTraceData Bule;
        bool hit = LineTrace(Angle, 6000, Pitch, 0, player.ViewHeight, 0, 0, Bule); //Line to kick enemy or wall
        if(hit)
        {
            if(Bule.HitActor && Bule.HitActor.bISMONSTER && Bule.HitActor.bFRIENDLY == false && Bule.HitActor is "PB_Monster")
            {	
                if(!invoker.LockedOn)
                {
                    A_SetBlend(0x00a100, 0.2, 3);
                    invoker.LockedOn = true;
                    A_StartSound("IronSights", CHAN_WEAPON, pitch:1.4);
                }
                //show the actor's wireframe
                let Wireframe = Spawn("PBX_CubeRadius", Bule.HitActor.pos);
                if(Wireframe)
                {
                    Wireframe.scale.x = double(Bule.HitActor.Radius) * 2;
                    Wireframe.scale.Y = double(Bule.HitActor.Height) * Level.pixelstretch;
                    Wireframe.vel = Bule.HitActor.vel;
                }
                if(invoker.ScopeMode == 2)
                {
                    // player.PSprites.frame = 1;
                    PBXWeapons_ScopeHandler.SendInterfaceEvent(self.PlayerNumber(), "PrintScopeData:"..Bule.HitActor.GetTag(), Bule.HitActor.health, Bule.HitActor.GetSpawnHealth(), Bule.HitActor.PainChance);
                    PBXWeapons_ScopeHandler.SendInterfaceEvent(self.PlayerNumber(), "PrintScopeData2:", Distance3D(Bule.HitActor), 5.0);
                }
            }
            else
            if(invoker.LockedOn)
            {
                A_SetBlend(0x00a100, 0.2, 3);
                // A_SetBlend(0xa19900, 0.2, 3);
                invoker.LockedOn = false;
                A_StartSound("IronSights", CHAN_WEAPON, pitch:1.3);
            }
        }
        // return A_DoPBWeaponAction();
    }

    action void CycleScopeMode()
    {
        invoker.ScopeMode = (invoker.ScopeMode + 1) % 3;
        A_StartSound("MS/Button", CHAN_WEAPON);
        A_SetBlend(0x00a100, 0.2, 3);

        switch (invoker.ScopeMode)
        {
            case 0: A_Print("$PBX_MetalSniper_Scope1"); break;
            case 1: A_Print("$PBX_MetalSniper_Scope2"); break;
            case 2: A_Print("$PBX_MetalSniper_Scope3"); break;
        }
    }
    // ── Ammo / magazine helpers ───────────────────────────────────────────────
    action void MS_ReloadMag()
    {
        int amount = invoker.currentMaxAmmo;
        if (PB_GetChamberEmpty()) amount--;
        invoker.usedAmmo = isResonance() ? 6 : 2;
		
        PB_AmmoIntoMag(invoker.ammo2.GetClassName(), invoker.ammo1.GetClassName(), amount, invoker.usedAmmo);
    }

    action void MS_UnloadMag(bool UnloadChamber = false)
    {
        int goal = UnloadChamber ? 0 : 1;
		string rounds = isResonance() ? "PBX_ResoRound" : "PB_HigherCalRound";
        invoker.usedAmmo = isResonance() ? 6 : 2;
        PB_UnloadMag(invoker.ammotype2, invoker.ammotype1, invoker.usedAmmo, 1, 0, goal, rounds);
    }

    action void MS_AmmoCapacity()
    {
        bool res      = invoker.resonanceAmmoLoaded;
        int  capacity = res ? MetalSniperFullAmmoResonance : MetalSniperFullAmmo;
        int  amount   = res ? invoker.ammo2.amount / 3 : invoker.ammo2.amount * 3;
        A_SetInventory(invoker.ammotype2, amount);
        SetAmmoCapacity(invoker.ammotype2, capacity);
        invoker.ReserveToMagAmmoFactor = res ? 6 : 2;
        invoker.currentMaxAmmo = capacity;
    }

    // ── Ammo-type switch handler ──────────────────────────────────────────────
    action void MS_ToggleResonance()
    {
        if(isResonance()){setResonance(false);}
		else {setResonance(true);}
    }

    action state MS_HandleAmmo()
    {
        if (FindInventory("MS_Select_NO"))
        {
            cleanmodetokens();
            A_Print("$PBX_AmmoNotAvailable");
            return resolvestate("Ready3");
        }

        if (FindInventory("MS_Select_Resonance"))
        {
			// The actual weapon switch is at the end of the unload > reload > chamber sequence
            A_Print(!isResonance() ? "$PBX_MetalSniper_Resonance" : "$PBX_MetalSniper_Standard");
            return PB_GetChamberEmpty() ? resolvestate("ReloadFromSpecial") : resolvestate("UnloadFromSpecial");
        }

        return resolvestate(null);
    }

    // ── Mode switch handler ───────────────────────────────────────────────────
    action state MS_HandleSpecial()
    {
        bool alreadyAim  = FindInventory("MS_Select_AimMode")  && MS_getmode() == SniperMode;
        bool alreadyGren = FindInventory("MS_Select_GrenMode") && MS_getmode() == GrenadeMode;

        if (alreadyAim || alreadyGren)
        {
            A_Print("$PBX_AlreadySelected");
            cleanmodetokens();
            return resolvestate("Ready3");
        }

        if (FindInventory("MS_Select_AimMode"))
        {
            MS_SetMode(SniperMode);
            A_Print("$PBX_MetalSniper_AimMode");
        }
        else if (FindInventory("MS_Select_GrenMode"))
        {
            MS_SetMode(GrenadeMode);
            A_Print("$PBX_MetalSniper_GrenMode");
        }

        return resolvestate(null);
    }

    // ── Fire helpers ──────────────────────────────────────────────────────────
    action void MS_FireActual()
    {
        if (isResonance())
        {
            PB_FireBullets("MS_ResonanceAmmo", 1, frandom(-0.1, 0.1), 0, 0, frandom(-0.1, 0.1));
            A_StartSound("weapons/railgf", 20, CHANF_OVERLAP);
        }
        else
        {
            PB_FireBullets("PB_762x51mmAP", 1, frandom(-0.1, 0.1), 0, 0, frandom(-0.1, 0.1));
            A_StartSound("MS/Fire", 20, CHANF_OVERLAP);
        }
    }

    action void MetalSniperFireADS()
    {
        A_WeaponOffset(0, 32);
        A_AlertMonsters();
        PB_DynamicTail("lmg", "lmg");
        A_Overlay(muzzlelayer, "MuzzleFlash_ADS");
        MS_FireActual();
        PB_TakeAmmo(invoker.ammotype2, 1);
        // A_SetInventory("CantDoAction", 1);
        PB_IncrementHeat(4);
        PB_IncrementHeat(4, true);
        PB_FireOffset();
        PB_GunSmoke(0, 0, -2);
        PB_WeaponRecoil(-5, frandom(-1.5, 1.5));
        PB_SpawnCasing("LMGCasingStandard", 26, 2, 28, 0, frandom(5, 8), frandom(1, 4));
    }

    action void MetalSniperFire()
    {
        A_WeaponOffset(0, 32);
        A_AlertMonsters();
        PB_DynamicTail("lmg", "lmg");
        A_Overlay(muzzlelayer, "MuzzleFlash");
        MS_FireActual();
        // PB_LowAmmoSoundWarning("lmg");
        PB_TakeAmmo(invoker.ammotype2, 1);
        PB_IncrementHeat(4);
        PB_IncrementHeat(4, true);
        PB_FireOffset();
        PB_GunSmoke(0, 0, -1);
        PB_WeaponRecoil(-4, frandom(-1.5, 1.5));
        PB_SpawnCasing("LMGCasingStandard", 26, 2, 28, 0, frandom(5, 8), frandom(1, 4));
        PB_WeaponRecoil(-3, frandom(-0.5, 0.5));
    }

	// ── Resonance helpers ──────────────────────────────────────────────────────────
    action bool isResonance()           { return invoker.resonanceAmmoLoaded; }
    action void setResonance(bool set)  { invoker.resonanceAmmoLoaded = set;  }

    // ── Grenade helpers ───────────────────────────────────────────────────────
    action void MS_SetGrenadeQ(bool q) { invoker.grenadeloaded = q; }
    action int  getgrenqtty()          { return invoker.grenadeloaded; }

    // ── Mode helpers ──────────────────────────────────────────────────────────
    action bool MS_getmode()            { return invoker.AltMode; }
    action void MS_SetMode(bool set = SniperMode) { invoker.AltMode = set; }

    // ── Token cleanup ─────────────────────────────────────────────────────────
    action void cleanmodetokens()
    {
        A_TakeInventory("MS_Select_AimMode",  1);
        A_TakeInventory("MS_Select_GrenMode", 1);
        A_TakeInventory("MS_Select_Resonance",1);
        A_TakeInventory("MS_Select_NO",       1);
    }

    // ── Input helpers ─────────────────────────────────────────────────────────
    action bool PlayerPressedOnce(int button)
    {
        return (player.cmd.buttons & button) && !(player.oldbuttons & button);
    }

}