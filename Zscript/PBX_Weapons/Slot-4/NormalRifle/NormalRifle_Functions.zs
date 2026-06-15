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

        if (level.frozen) return;
        
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

    // I cant believe I actually need to make custom left and right action functions
    // just so the dual full auto and burst fire works

    action state NormalRifle_DoLeftAction(int minammo = 1)
	{
		int firemodecvar = Cvar.GetCvar("SingleDualFire",player).GetInt();

        if(invoker.waitReleaseLeft)
        {
            if(firemodecvar == 0 || checkDualWieldButton(true,firemodecvar))
                invoker.waitReleaseLeft = false;
            else
                return resolvestate(null);
        }   

		if(CountInv(invoker.ammotypeleft) >= minammo && !PB_GetChamberEmpty(true))
		{
			switch(firemodecvar)
			{
				case 0:
					if(PressingFire() && !A_IsFiringRightWeapon() && CountInv("DualFiring") == 0)
						return resolvestate("FireLeft_Overlay");
					break;
				case 1:
					if(PressingFire() && !A_IsFiringLeftWeapon())
						return resolvestate("FireLeft_Overlay");
					break;
				case 2:
					if(PressingAltFire() && !A_IsFiringLeftWeapon())
						return resolvestate("FireLeft_Overlay");
					break;
			}
		}
		else
		{
			switch(firemodecvar)
			{
				case 0:
					if(JustPressed(BT_ATTACK) && !A_IsFiringRightWeapon() && CountInv("DualFiring") == 0)
						A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
					break;
				case 1:
					if(JustPressed(BT_ATTACK) && !A_IsFiringLeftWeapon())
						A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
					break;
				case 2:
					if(JustPressed(BT_ALTATTACK) && !A_IsFiringLeftWeapon())
						A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
					break;
			}
			if(!PB_GetChamberEmpty() && CountInv(invoker.ammotype2) >= minammo)
				A_SetInventory("DualFiring",1);
		}
		return resolvestate(null);
	}
		
	action state NormalRifle_DoRightAction(int minammo = 1)
	{
		int firemodecvar = Cvar.GetCvar("SingleDualFire",player).GetInt();

        if(invoker.waitReleaseRight)
        {
            if(firemodecvar == 0 || checkDualWieldButton(false,firemodecvar))
                invoker.waitReleaseRight = false;
            else
                return resolvestate(null);
        }

		if(CountInv(invoker.ammotype2) >= minammo && !PB_GetChamberEmpty())
		{
			switch(firemodecvar)
			{
				case 0:
					if(PressingFire() && !A_IsFiringLeftWeapon() && CountInv("DualFiring") == 1)
						return resolvestate("FireRight_Overlay");
					break;
				case 1:
					if(PressingAltFire() && !A_IsFiringRightWeapon())
						return resolvestate("FireRight_Overlay");
					break;
				case 2:
					if(PressingFire() && !A_IsFiringRightWeapon())
						return resolvestate("FireRight_Overlay");
					break;
			}
		}
		else
		{
			switch(firemodecvar)
			{
				case 0:
					if(JustPressed(BT_ATTACK) && !A_IsFiringLeftWeapon() && CountInv("DualFiring") == 1)
						A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
					break;
				case 1:
					if(JustPressed(BT_ALTATTACK) && !A_IsFiringRightWeapon())
						A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
					break;
				case 2:
					if(JustPressed(BT_ATTACK) && !A_IsFiringRightWeapon())
						A_StartSound("weapons/empty", 10,CHANF_OVERLAP);
					break;
			}
			if(!PB_GetChamberEmpty(true) && CountInv(invoker.ammotypeleft) >= minammo)
				A_SetInventory("DualFiring",0);
		}
		return resolvestate(null);
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

            case 4: // DualFireReload check, reset burst
                setBurstCount(0, isLeft ? true : false);

                if(burst)
                {
                    if(isLeft) invoker.waitReleaseLeft = true;
                    else        invoker.waitReleaseRight = true;
                }

                if(isLeft && invoker.ammo2.amount <= 0)
                    A_GiveInventory("DualFireReload", 1);
                else if(!isLeft && invoker.ammoleft.amount <= 0)
                    A_GiveInventory("DualFireReload", 1);

                if(isLeft)
                    A_SetFiringLeftWeapon(false);
                else
                    A_SetFiringRightWeapon(false);
                break;
        }
    }

    action bool checkDualWieldButton(bool isLeft, int firemodecvar)
    {
        switch(firemodecvar)
        {
            case 0:
                return !PressingFire();
            case 1:
                return isLeft ? !PressingFire() : !PressingAltFire();
            case 2:
                return isLeft ? !PressingAltFire() : !PressingFire();
            default:
                return true;
        }
    }

    // action int checkDualWieldButton(bool isLeft)
    // {
    //     // Get the CVAR and weapon side
    //     int firemode = Cvar.GetCvar("SingleDualFire", player).GetInt();
    //     int fireButton = BT_ATTACK;
    //     if (firemode == 1)
    //     {
    //         int fireButton = isLeft ? BT_ATTACK : BT_ALTATTACK;
    //     }
    //     // Mode 2: Inverted (Primary fire: Fire right weapon, Alt-fire: Fire left weapon)
    //     else if (firemode == 2)
    //     {
    //         int fireButton = isLeft ? BT_ALTATTACK : BT_ATTACK;
    //     }
    //     return fireButton;
    // }

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