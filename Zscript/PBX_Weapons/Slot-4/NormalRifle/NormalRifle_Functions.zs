extend class PBX_NormalRifle
{
    override void PostBeginPlay()
    {
        doBurst = false;
        laserActive = false;
        burstcount = 0;
        burstcountLeft = 0;
        Super.PostBeginPlay();
    }

    override void DoEffect() 
	{
		super.DoEffect();

        if (level.isFrozen()) return;
        
        // Check if the player exists and if the current weapon they're using is the blaster
		If(	owner.player && owner.player.readyweapon.GetClass() is self.GetClass())
        {
            // Get a pointer to it
            let weap = PBX_NormalRifle(owner.player.readyweapon);
            if(!weap) return;

			// Get a pointer to PSprite
			let psp = owner.player.FindPSprite(PSP_WEAPON);
			if(!psp) return;

            if(!weap.laserActive) return;

            // Dont spawn the laser sight if the weapon is in one of these states
            static const StateLabel blockedStates[] = {
                "Deselect", "NormalDeselect", "DualWieldDeselect", "FinishDeselect",

                "SelectAnimationDualWield", "SelectAnimation",

                "SwitchToDualWield", "StopDualWield",

                "RaiseFromEmpty","Reload","ContinueReload","FinishReload","Rechamber",

                "ReloadUnloadRight","ReloadUnloadLeft","ReloadDualWield","ContinueReloadRight",
                "ReloadLeft","ContinueReloadLeft",

                "Unload","UnloadChamber","UnloadDualWield","UnloadLeft",

                "FlashKickingAkimbo","FlashAirKickingAkimbo","FlashSlideKickingAkimbo","FlashSlideKickingStopAkimbo"

                "WeaponRespect",
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

            Spawn("PBX_RedDot", lasersight.HitLocation);
		}
    }

    action void setBurstCount(int set, bool isLeft = false)
    {
        if(!isLeft) invoker.burstcount  = set;
        else        invoker.burstcountLeft = set;
    }

    action int getBurstCount(bool isLeft = false)
    {
        if(!isLeft) return invoker.burstcount;
        else        return invoker.burstcountLeft;
    }

    action bool getBurst()
    {
        return invoker.doBurst;
    }

    action void setBurst(bool set)
    {
        invoker.doBurst = set;
    }
 
    action void NormalRifle_FireOverlay(int tic, bool isLeft = false)
    {
        bool burst          = getBurst();
        int heat            = burst ? 3 : 1;
        double recoilX      = burst ? -0.6  : -0.24;
        double recoilY      = isLeft ? (burst ? +0.8 : +0.6) : (burst ? -0.8 : -0.6);
        double smokeOfs     = isLeft ?  6  : -6;
        double vertOfs      = isLeft ? -16 :  9;
        string ammoClass    = isLeft ? invoker.ammoleft.getClassName() : invoker.ammo2.getClassName();

        switch(tic)
        {
            case 1:
                // Check Ammo
                if(isLeft && invoker.ammo2.amount <= 0)
                    A_GiveInventory("DualFireReload", 1);
                else if(!isLeft && invoker.ammoleft.amount <= 0)
                    A_GiveInventory("DualFireReload", 1);
                // Shoot + Effects
                PB_IncrementHeat(heat, isLeft);
                PB_FireBullets("PB_556x45mm", 1, 0.1, 0, 0, 0.1);
                PB_SpawnCasing("PB_EmptyBrass", 26, vertOfs, 38, frandom(-2,2), -frandom(2,5), frandom(3,6), true, true);
                A_StartSound("weapons/rifle", CHAN_Weapon, CHANF_DEFAULT, 1.0);
			    PB_DynamicTail("lmg", "br");
                A_ZoomFactor(0.98);
                PB_WeaponRecoil(recoilX, recoilY);

                // Everything Else
                if(isLeft) {
                    invoker.burstcountLeft++;
                    PB_LowAmmoSoundWarning(ammoClass);
                    PB_TakeAmmo(ammoClass,dual:true);
                    A_SetFiringLeftWeapon(true);
                }
                else {
                    invoker.burstcount++;
                    PB_LowAmmoSoundWarning();
                    PB_TakeAmmo(ammoClass);
                    A_SetFiringRightWeapon(true);
                }
                A_AlertMonsters();
                PB_GunSmoke(smokeOfs, 0, 1.6);
                PB_MuzzleFlashEffects(smokeOfs, 0, 1.6);
                break;

            case 2:
                if(isLeft)
                {
                    if(invoker.ammoleft.amount <= 0 || invoker.ammo2.amount > 0)
                        A_GiveInventory("DualFiring", 1);
                    // A_SetFiringLeftWeapon(false);
                }
                else
                {
                    if(invoker.ammoleft.amount > 0 || invoker.ammo2.amount <= 0)
                        A_TakeInventory("DualFiring", 1);
                    // A_SetFiringRightWeapon(false);
                }
                break;

             case 3: 
                A_ZoomFactor(1.0);
                PB_WeaponRecoil(recoilX, recoilY);
                break;

            case 4:
                // Reset burst
                setBurstCount(0, isLeft ? true : false);

                // Set the fire block to true
                // this is so the player cant fire
                // if they havent let go of the firing button
                if(burst)
                {
                    if(isLeft) invoker.waitReleaseLeft = true;
                    else       invoker.waitReleaseRight = true;
                }

                // Ammo Check
                if(isLeft && invoker.ammo2.amount <= 0)
                    A_GiveInventory("DualFireReload", 1);
                else if(!isLeft && invoker.ammoleft.amount <= 0)
                    A_GiveInventory("DualFireReload", 1);

                // Reset burst firing for 
                // the single button dual wield burst fire
                if(isLeft)
                    A_SetFiringLeftWeapon(false);
                else
                    A_SetFiringRightWeapon(false);
                break;
        }
    }

    // A custom ready dual wield function that blocks the player from firing
    // if its in burst fire and they havent let go of the firing button
    // this is because PB has 3 modes that dictates which are the fire buttons
    action state ReadyOverlay(bool isLeft)
    {
        // Set up variables
        int firemodecvar = Cvar.GetCvar("SingleDualFire",player).GetInt();
        bool waiting = isLeft ? invoker.waitReleaseLeft : invoker.waitReleaseRight;
        bool checkDualWieldButton;

        // Check if the fire button is pressed
        switch(firemodecvar)
        {
            case 0: checkDualWieldButton = !PressingFire(); break;
            case 1: checkDualWieldButton = isLeft ? !PressingFire() : !PressingAltFire(); break;
            case 2: checkDualWieldButton = isLeft ? !PressingAltFire() : !PressingFire(); break;
        }

        // Basically dont let the player fire
        // unless they let go of the fire button
        if(waiting)
        {
            if(firemodecvar == 0 || checkDualWieldButton)
            {
                if(isLeft) invoker.waitReleaseLeft = false;
                else invoker.waitReleaseRight = false;
            }
            else return resolvestate(null);
        }
        if(isLeft) return A_DoPBLeftAction();
        else return A_DoPBRightAction();
    }

    action void fireweapon(int tic)
    {
        bool ads     = PB_GetZoom();
        double zoomA = ads ? 1.9 : 0.98;
        double zoomB = ads ? 2.0 : 1.0;

        switch(tic)
        {
            case 1:
                A_StartSound("weapons/rifle", CHAN_Weapon, CHANF_DEFAULT, 1.0);
                A_AlertMonsters();
                PB_IncrementHeat();
			    PB_DynamicTail("lmg", "br");
				PB_LowAmmoSoundWarning();
				PB_GunSmoke(0,0,0); PB_MuzzleFlashEffects(0,0,0);
                A_FireCustomMissile("YellowFlareSpawn",0,0,0,0);
                PB_TakeAmmo(invoker.ammo2.getclassname());
                A_GunFlash();
                PB_WeaponRecoil(-0.5,0);
                PB_FireOffset();
                if(ads) {
                    PB_SpawnCasing("PB_EmptyBrass",28,0,30,3,Frandom(5,8),Frandom(3,4));
                    PB_FireBullets("PB_556x45mm",1, 0.1, 0, 0, 0.1);
                }
                else {
				    PB_SpawnCasing("PB_EmptyBrass",22,2,28,Frandom(-2, -1),Frandom(5,8),Frandom(3,4));
                    PB_FireBullets("PB_556x45mm",1, 1, 0, 0, 1);
                }
                A_ZoomFactor(zoomA);
                break;

            case 2:
                PB_WeaponRecoil(-1.0,0);
                A_ZoomFactor(zoomB);
                invoker.burstCount++;
                break;

            // Everything below here is not called by ADS
            case 3:
                PB_WeaponRecoil(+1.0,0);
                break;

            case 4:
                A_WeaponOffset(0,32);
                break;
        }
    }

    action state checkSpecial()
	{
        A_Takeinventory("GoWeaponSpecialAbility",1);
        PB_ClearDualWield();

		bool toggleFireMode     = countinv("NR_Select_FireMode")    > 0;
		bool toggleDualWield  	= countinv("NR_Select_DualWield")   > 0;
		bool toggleLaser 	    = countinv("NR_Select_Laser")       > 0;

        if(countinv("PBX_CloseWheel") > 0)
		{
			A_TakeInventory("PBX_CloseWheel",1);
            if(PB_GetZoom()) return resolvestate("Ready2");
			else return resolvestate("Ready3");
		}

		if(toggleFireMode)
		{
			if(invoker.doBurst) invoker.doBurst = false;
            else invoker.doBurst = true;
            A_Print(invoker.doBurst ? "$PB_FIREMODE_BURST" : "$PB_FIREMODE_FULL");
		}

		if (toggleLaser)
        {
            if(invoker.laserActive) invoker.laserActive = false;
            else invoker.laserActive = true;
            A_Print(invoker.laserActive ? "$PBX_LaserOn" : "$PBX_LaserOff");
        }

        if (toggleDualWield)
        {
            cleanmodetokens();

            // Dual Wield Toggle
            if (A_CheckAkimbo()) 
                return ResolveState("StopDualWield");
            if (invoker.amount >= 2) {
                if(PB_GetZoom()) return ResolveState("ZoomOut"); // After zoomout it goes to "SwitchToDualWield"
                return ResolveState("SwitchToDualWield");
            }

            // If you dont have 2 rifles
            A_Print("$PBX_NormalRifle_NoAkimbo");
            return ResolveState("Ready3");
        } 

		// Always remove the tokens regardless
		cleanmodetokens();

		// Play sound when opening the wheel in ADS
		if(PB_GetZoom())
		{
			A_StartSound("MS/Button", 26);
			return resolvestate("Ready2");
		}

        A_StartSound("MS/Button", CHAN_AUTO, CHANF_OVERLAP);
		// Fallthrough to Ready3
		return resolvestate(null);
	}

    action void cleanmodetokens()
    {
        A_SetInventory("NR_Select_FireMode",0);
        A_SetInventory("NR_Select_DualWield",0);
        A_SetInventory("NR_Select_Laser",0);
    }
}