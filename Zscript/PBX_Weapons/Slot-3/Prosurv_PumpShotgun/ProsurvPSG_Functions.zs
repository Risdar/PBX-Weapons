extend class PBX_ProSurvPSG
{
    override void DoEffect() 
	{
		super.DoEffect();

        if (level.frozen) return;
        // Check if the player exists and if the current weapon they're using is the blaster
		If(	owner.player && owner.player.readyweapon.GetClass() is self.GetClass())
        {
            // Get a pointer to it
            let weap = PBX_ProSurvPSG(owner.player.readyweapon);
            if(!weap) return;

            // Check if the laser is active
            if(!weap.laserActive) return;

			// Get a pointer to PSprite
			let psp = owner.player.FindPSprite(PSP_WEAPON);
			if(!psp) return;

            // Dont spawn the laser sight if the weapon is in one of these states
            static const StateLabel blockedStates[] = {
				"Reload", "ShellChecker", "ChamberInsertShell", "ReloadFinished",
				"Unload", "RemoveBullets", "FinishUnload",
				"Pump", "PumpBegin", "PumpEnd", "WeaponRespect",
				"FlashPunching", "FlashKicking", "FlashAirKicking", "FlashSlideKicking", "FlashSlideKickingStop"
			};

			for (int i = 0; i < blockedStates.Size(); i++)
			{
				if (InStateSequence(psp.curstate, ResolveState(blockedStates[i]))) return;
			}

            // Spawn the laser sight
			double pz = owner.height * 0.5 - owner.floorclip + owner.player.mo.AttackZOffset*owner.player.crouchFactor;
            FLineTraceData lasersight;
			owner.LineTrace(owner.angle, 
				4096, 
				owner.pitch, 
				TRF_SOLIDACTORS|TRF_THRUHITSCAN, 
				offsetz: pz, 
				// offsetz: owner.player.viewz - pos.z, 
				data: lasersight
			);

			Spawn("PBX_GreenDot", lasersight.HitLocation);
		}
    }

	action void SG_Fire(int tic)
	{
		bool ads = PB_GetZoom();

		// Shared variables
		double recoilX      = ads ? -0.62 : -1.64;
		double recoilY      = ads ? +0.24 : +0.88;
		double zoomA        = ads ? 1.48  : 0.98;
		double zoomB        = ads ? 1.49  : 0.99;
		double zoomC        = ads ? 1.50  : 1.0;
		int    wadOfsY      = ads ? -3    : -4;

		// Berserk halves recoil
		if (invoker.OwnerHasBerserk())
		{
			recoilX *= 0.5;
			recoilY *= 0.5;
		}

		switch(tic)
		{
			case 1:
				PB_SetRoll(0);
				A_TakeInventory("PB_LockScreenTilt", 1);
				if (ads) A_SetCrosshair(-1);

				PB_FireBullets("PB_12GAPellet", 9, 1.5, 0, 0, 1.5);

				A_FireProjectile("ShotgunWad", random(-2,2), 0, random(-2,2), wadOfsY, FPF_NOAUTOAIM, random(-2,2));
				PB_LowAmmoSoundWarning("shotgun");
				PB_TakeAmmo(invoker.ammo2.getClassName(), 1, 0);
				A_AlertMonsters();
				A_PlaySoundEx("FLAKFIRE", "Weapon");
				PB_IncrementHeat();
				A_FireCustomMissile("YellowFlareSpawn", 0, 0, 0, 0);
				_SpawnMuzzleSparksSG(0, 0, -4);
				PB_MuzzleFlashEffects(0, 0, -4);
				PB_DynamicTail("shotgun", "shotgun");
				A_SetInventory("CantDoAction", 1);
				PB_SetChamberEmpty(true);
				A_GunFlash();
				A_ZoomFactor(zoomA);
				PB_WeaponRecoil(recoilX, recoilY);
				break;

			case 2:
				A_ZoomFactor(zoomB);
				PB_WeaponRecoil(recoilX, recoilY);
				break;

			case 3:
				A_ZoomFactor(zoomC);
				// if (!ads) PB_SpawnCasing("ShotgunCasing", 15, -5, 26, 0, 3, 3);
				break;

			// Pump
			case 4:
				A_ZoomFactor(zoomC);
				if(ads) A_SetCrosshair(-1);
                A_Giveinventory("PB_LockScreenTilt",1);
                A_PlaySoundEx("Ironsights", "Auto");
				PB_SetReloading(true);
				break;

			case 5:
				PB_SpawnCasing("ShotgunCasing",15,-5,26,0,3,3);
				if(!PB_GetMagEmpty()) PB_SetChamberEmpty(false);
				break;
		}
	}
}