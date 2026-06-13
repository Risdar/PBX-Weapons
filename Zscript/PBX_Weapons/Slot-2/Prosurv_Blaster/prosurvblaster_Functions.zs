extend class PBX_ProsurvBlaster
{
    override void DoEffect() 
	{
		super.DoEffect();
        if (level.frozen) return;
        // Check if the player exists and if the current weapon they're using is the blaster
        If(	owner.player && owner.player.readyweapon.GetClass() is self.GetClass())
        {
            // Get a pointer to it
            let weap = PBX_ProsurvBlaster(owner.player.readyweapon);
            if(!weap) return;

            // Get a pointer to PSprite
            let psp = owner.player.FindPSprite(PSP_WEAPON);
            if(!psp) return;

            if(weap.ammo1.amount < prosurvblasterMaxCharge)
                giveBlasterCharge(psp,weap);
            if(weap.laserActive)
                spawnLaser(psp);
        }
    }

    void spawnLaser(PSprite psp)
    {
        // Dont spawn the laser sight if the weapon is in one of these states
        static const StateLabel blockedStates[] = {
            "Reload", "Recharge","WeaponRespect", "Deselect", "SelectAnimation",
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
            // offsetz: owner.player.viewz - pos.z, 
            data: lasersight
        );

        Spawn("PBX_BlueDot", lasersight.HitLocation);
    }

    void giveBlasterCharge(PSprite psp, PBX_ProsurvBlaster weap)
    {
        // Dont give the charge if they're in one of the exceptions
        static const StateLabel blockedStates[] = {
            "Fire", "Fire2", "Reload", "Recharge"
        };

        for (int i = 0; i < blockedStates.Size(); i++)
        {
            if (InStateSequence(psp.curstate, ResolveState(blockedStates[i]))) return;
        }

        // Give the charge every this amount of tic
        if(level.time % GIVECHARGE == 0)
            owner.A_GiveInventory(weap.ammo1.getClassName(),1);
    }

    action state A_PressingReload()
	{
		if ((player.cmd.buttons & BT_RELOAD) || (player.oldbuttons & BT_RELOAD)) return resolvestate("Reload");
		else return resolvestate(null);
	}

    action void fireweapon(int tic)
    {
        bool ads     = PB_GetZoom();
        double zoomA = ads ? 1.24 : 0.985;
        double zoomB = ads ? 1.245 : 0.99;
        double zoomC = ads ? 1.25 : 1.0;

        switch(tic)
        {
            case 1: case 2: case 3:
                // Only called in First Tic
                if(tic == 1)
                {
                    PB_IncrementHeat();
                    A_GunFlash();
                    A_Overlay(MUZZLELAYER, "GunFlash", true);
                    A_AlertMonsters();
                    PB_TakeAmmo(invoker.ammo1.getClassName(),TAKECHARGE,0);
                    // modifyBlasterCharge(TAKE,5);
                    A_PlaySoundEx("weapons/blasterpistol/fire","Weapon");
                    PB_WeaponRecoil(-0.18,-0.08);
                    A_FireCustomMissile("BlueFlareSpawn", 0, 0, 0, 0, 0, 0);
		            PB_FireBullets("ProsurvBlasterProjectile", 1, 0, 0, 0, frandom(-0.1, 0.1));
                    // A_FireCustomMissile("ProsurvBlasterProjectile", 0,0,0,1,0,0); // THE BOOLET
                }

                // Depends on which Tic
                A_ZoomFactor(tic == 1 ? zoomA : tic == 2 ? zoomB : zoomC);
                
                // Will always be called
                if(!ads)
                {
                    if (invoker.OwnerHasBerserk())  PB_WeaponRecoil(-0.18,+0.8);
                    else PB_WeaponRecoil(-0.9,+0.4);
                }
                break;
        }
    }

    // All in one function to modify the battery charge
    action void modifyBlasterCharge(int mode, int amount)
    {
        string ammo = invoker.ammo1.getClassName();
        switch(mode)
        {
            case SET:
                A_SetInventory(ammo,amount);
                break;
            case TAKE:
                A_TakeInventory(ammo,amount);
                break;
            case GIVE:
                A_Giveinventory(ammo,amount);
                break;
        }
    }
}