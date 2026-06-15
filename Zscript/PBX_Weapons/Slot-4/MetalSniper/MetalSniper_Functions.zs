extend class PBX_MetalSniper
{
    // ── Overrides ──────────────────────────────────────────────────────────────────
    override void PostBeginPlay()
    {
        grenadeloaded  = true;
        currentMaxAmmo = MAGAZINE_SIZE;
        zoomstrength = LOWZOOM;
		laserActive  = false;
        LockedOn = false;
        ScopeMode = 0;
        enableScopeHUD = false;
        Super.PostBeginPlay();
    }

    override void DoEffect() 
	{
		super.DoEffect();

        if (level.frozen) return;
        
        // Check if the player exists and if the current weapon they're using is the blaster
		If(	owner.player && owner.player.readyweapon.GetClass() is self.GetClass())
        {
            // Get a pointer to it
            let weap = PBX_MetalSniper(owner.player.readyweapon);
            if(!weap) return;

			// Get a pointer to PSprite
			let psp = owner.player.FindPSprite(PSP_WEAPON);
			if(!psp) return;

            if(!weap.laserActive) return;

            // Dont spawn the laser sight if the weapon is in one of these states
            static const StateLabel blockedStates[] = {
                "Reload", "Reload_Grenade", "StandardReload", "WeaponRespect",
                "TakeMagStandard", "TakeMagResonance", "InsertMag", "ReloadFromSpecial", "Deselect",
                "FinishReload", "RaiseFromEmpty", "Start_Rechamber", "Rechamber", "ChangeAnim",
                "UnloadFromSpecial","Unload","UnloadRaise","UnloadMagStandard", "UnloadMagEmpty",
                "UnloadMagResonance", "UnloadChamber", "FinishUnload", "StartUnloadChamber", "SelectAnimation",
                "FlashPunching", "FlashKicking", "FlashAirKicking", "FlashSlideKicking", "FlashSlideKickingStop"
            };

            for (int i = 0; i < blockedStates.Size(); i++)
            {
                if (InStateSequence(psp.curstate, ResolveState(blockedStates[i])) && !InStateSequence(psp.curstate, ResolveState("Ready3"))) 
                    return;
            }

            // Spawn the laser sight
            double pz = owner.height * 0.5 - owner.floorclip + owner.player.mo.AttackZOffset*owner.player.crouchFactor;
            FLineTraceData lasersight;
            owner.LineTrace(owner.angle, 
                4096, 
                owner.pitch, 
                TRF_SOLIDACTORS|TRF_THRUHITSCAN, 
                offsetz: pz, 
                data: lasersight
            );

            Spawn("PBX_GreenDot", lasersight.HitLocation);
		}
    }

    // ═════════════════════════════════════════════════════════════════════════
    // ACTION FUNCTIONS
    // ═════════════════════════════════════════════════════════════════════════
    action void setADSWheel()
    {
        invoker.wheelinfo = "MS_Zoomed_Wheel";
    }

    action void resetVariables()
    {
        invoker.enableScopeHUD = false;
        A_SetRenderstyle(1.0, STYLE_Normal);
        invoker.wheelinfo = "MetalSniperWheel";
        A_SetInventory("PBX_Infrared", 0);
    }

    // ── Zoom Helpers ────────────────────────────────────────────────────────
    action double getZoomStrength()
	{
		return invoker.zoomstrength;
	}

	action void setZoomStrength(double set)
	{
		invoker.zoomstrength = set;
	}

    action state MS_ReadyZoom()
    {
        A_SetRoll(0);
        // PB_HandleCrosshair(-1);
        A_SetCrosshair(-1);
        PB_CoolDownBarrel(-5, 0, 7, 0,  1);
        PB_CoolDownBarrel( 5, 0, 7, 0, -1);
        A_SetInventory("PB_LockScreenTilt", 0);
        A_ZoomFactor(getZoomStrength());
        if(invoker.ScopeMode == 1 || invoker.ScopeMode == 2)
        {
            // A_SetBlend(0x00a100, 0.2, 99999);
            A_SetCrosshair(52);
            MS_ReadyScope();
            A_SetRenderstyle(0.1, Style_Translucent);
            invoker.enableScopeHUD = true;
        }
        else
        {
            // EndBlend("DarkGreen");
            invoker.enableScopeHUD = false;
            A_SetRenderstyle(1.0, STYLE_Normal);
        }
        return PB_ReadyFire(ads:true);
    }

    // ── Scope Function ────────────────────────────────────────────────────────
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
                    PBXWeapons_ScopeHandler.SendInterfaceEvent(self.PlayerNumber(), "PrintScopeData2:", Distance3D(Bule.HitActor), invoker.getZoomStrength());
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

    // ── Ammo / magazine helpers ───────────────────────────────────────────────
    action void MS_ReloadMag()
    {
        int amount = invoker.currentMaxAmmo;
        if (PB_GetChamberEmpty()) amount--;
        PB_AmmoIntoMag(invoker.ammo2.GetClassName(), invoker.ammo1.GetClassName(), amount, invoker.ReserveToMagAmmoFactor);
    }

    action void MS_UnloadMag(bool UnloadChamber = false)
    {
        int goal = UnloadChamber ? 0 : 1;
		string rounds = isResonance() ? "PBX_ResoRound" : "PB_HigherCalRound";
        PB_UnloadMag(invoker.ammotype2, invoker.ammotype1, invoker.ReserveToMagAmmoFactor, 1, 0, goal, rounds);
    }

    action void MS_AmmoCapacity()
    {
        bool res      = invoker.resonanceAmmoLoaded;
        // these are 3 because the ammo couunter already counts 2 reserve as 1 in the ammo bar
        int  capacity = res ? MAGAZINE_SIZE / 3 : MAGAZINE_SIZE;
        int  amount   = res ? invoker.ammo2.amount / 3 : invoker.ammo2.amount * 3;
        A_SetInventory(invoker.ammotype2, amount);
        SetAmmoCapacity(invoker.ammotype2, capacity);
        invoker.ReserveToMagAmmoFactor = res ? AMMO_TAKE_RESONANCE : AMMO_TAKE_NORMAL;
        invoker.currentMaxAmmo = capacity;
    }

    // ── Mode switch handler ───────────────────────────────────────────────────
    action state MS_HandleSpecial()
    {
        // Get the tokens
        bool noResonance = FindInventory("MS_Select_NO");
        bool toggleResonance = FindInventory("MS_Select_Resonance");

        bool goAim  = FindInventory("MS_Select_AimMode");
        bool goGren = FindInventory("MS_Select_GrenMode");
        bool toggleLaser = FindInventory("MS_Select_Laser");
        
        bool toggleZoom = FindInventory("MS_Select_ToggleZoom");
        bool toggleScope = FindInventory("MS_Select_ToggleScope");
        bool toggleNVG = FindInventory("MS_Select_ToggleNVG");

        // Handle Resonance Ammo
        if (noResonance)
        {
            cleanmodetokens();
            A_Print("$PBX_AmmoNotAvailable");
            return resolvestate("Ready3");
        }

        if (toggleResonance)
        {
			// The actual weapon switch is at the end of the unload > reload > chamber sequence
            A_Print(!isResonance() ? "$PBX_MetalSniper_Resonance" : "$PBX_MetalSniper_Standard");
            return PB_GetChamberEmpty() ? resolvestate("ReloadFromSpecial") : resolvestate("UnloadFromSpecial");
        }
        
        // Handle Mode Switch

        // Check if the mode is already selected
        if (goAim && MS_getmode() == SniperMode || goGren && MS_getmode() == GrenadeMode)
        {
            A_Print("$PBX_AlreadySelected");
            cleanmodetokens();
            return resolvestate("Ready3"); // Skip the change animation
        }

        // Actual Mode Switch
        if (goAim)
        {
            MS_SetMode(SniperMode);
            A_Print("$PBX_MetalSniper_AimMode");
        }
        if (goGren)
        {
            MS_SetMode(GrenadeMode);
            A_Print("$PBX_MetalSniper_GrenMode");
        }
        if (toggleLaser)
        {
            if(invoker.laserActive) invoker.laserActive = false;
            else invoker.laserActive = true;
            A_StartSound("MS/Button", CHAN_AUTO, CHANF_OVERLAP);
            A_Print(invoker.laserActive ? "$PBX_LaserOn" : "$PBX_LaserOff");

            // Basically only play the change animation if the player is not in ADS
            // Since the laser can be toggled from both the normal and ads wheel
            if(!PB_GetZoom()) {
                cleanmodetokens();
                return ResolveState("ChangeAnim");
            }
        }
        if(toggleScope)
        {
            invoker.ScopeMode = (invoker.ScopeMode + 1) % 3;
            A_StartSound("MS/Button", CHAN_WEAPON);
            A_SetBlend(0x00a100, 0.2, 3);
            switch (invoker.ScopeMode)
            {
                case 0: A_Print("$PBX_Scope1"); break;
                case 1: A_Print("$PBX_Scope2"); break;
                case 2: A_Print("$PBX_Scope3"); break;
            }
        }
        if (toggleZoom)
        {
            if(getZoomStrength() == HIGHZOOM) {
				setZoomStrength(LOWZOOM);
				A_Print("$PBX_Zoom40");
			}
			else {
				setZoomStrength(HIGHZOOM);
				A_Print("$PBX_Zoom70");
			}
            A_StartSound("MS/Button", CHAN_AUTO, CHANF_OVERLAP);
        }

        if(toggleNVG)
        {
            if(invoker.nvgActive) {
                invoker.nvgActive = false;
				A_Print("$PBX_nvgOn");
                A_SetInventory("PBX_Infrared", 0);
            }
            else {
                invoker.nvgActive = true;
                A_SetInventory("PBX_Infrared", 1);
				A_Print("$PBX_nvgOff");
                A_StartSound("RA1IF1", CHAN_AUTO, CHANF_OVERLAP);
            }
            A_SetBlend("Black",0.75,16);
        }

        // Always clear the tokens
        cleanmodetokens();
        return resolvestate(null);
    }

    action void MS_ToggleResonance()
    {
        if(isResonance()){setResonance(false);}
		else {setResonance(true);}
    }

    action void cleanmodetokens()
    {
        A_TakeInventory("MS_Select_AimMode",      1);
        A_TakeInventory("MS_Select_GrenMode",     1);
        A_TakeInventory("MS_Select_Resonance",    1);
        A_TakeInventory("MS_Select_Laser",        1);
        A_TakeInventory("MS_Select_ToggleZoom",   1);
        A_TakeInventory("MS_Select_ToggleScope",  1);
        A_TakeInventory("MS_Select_ToggleNVG",    1);
        A_TakeInventory("MS_Select_NO",           1);
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

    // ── Input helpers ─────────────────────────────────────────────────────────
    action bool PlayerPressedOnce(int button)
    {
        return (player.cmd.buttons & button) && !(player.oldbuttons & button);
    }

}