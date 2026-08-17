extend class PBX_ProsurvBlaster
{
    mixin PBX_LaserSight;

    static const StateLabel blockedLaserStates[] = {
        "Reload", "Recharge","WeaponRespect", "Deselect", "SelectAnimation",
        "FlashPunching", "FlashKicking", "FlashAirKicking", "FlashSlideKicking", "FlashSlideKickingStop"
    };

    override void DoEffect() 
	{
		super.DoEffect();
        if (level.isFrozen()) return;
        if(!owner || !owner.player || !owner.player.readyweapon) return;

        // Get a pointer to the weapon and PSprite
        let psp = owner.player.FindPSprite(PSP_WEAPON);
        if(!psp) return;

        // This way the blaster will always recharge even if not selected
        if(self.ammo1.amount < MAXCHARGE)
            giveBlasterCharge(psp);

        // This way the laser will only spawn if the weapon is selected
        if(owner.player.readyweapon is self.GetClass() && laserActive)
            PBX_SpawnLaserSight("PBX_BlueDot");
    }

    void giveBlasterCharge(PSprite psp)
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
        if(level.time % GIVECHARGE != 0) return;
        owner.A_GiveInventory(self.ammo1.getClassName(),1);
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