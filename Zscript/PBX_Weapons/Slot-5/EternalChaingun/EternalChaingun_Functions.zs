extend class PBX_EternalMinigun
{
//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////
    // First time pickup
    override void AttachToOwner(Actor other)
    {
        super.AttachToOwner(other);
        if(!other) return;
        if(owner.player.readyweapon != self)
            owner.player.PendingWeapon = self;
    }
    
    // Consequent Pickup
	override bool HandlePickup(Inventory item)
    {
        // If the item being picked up is this gun
        if(item.getClassName() == self.getClassName())
        {
            let plr = owner.player;
            if(PBXCore_Debug) console.printf("Weapon Found");

            // Check if the player already has this weapons
            let weap = PBX_EternalMinigun(owner.FindInventory("PBX_EternalMinigun"));
            if(weap)
            {
                // If yes then reset the power time
                weap.mPowerTime = PBXCore_Duration.GetByCVarInSeconds("pbxweapons_echaingun_duration");
                // Force switch to this weapon
                if(plr.readyweapon != weap)
                    plr.PendingWeapon = weap;
                // Check if the player is already using this weapon
                if(InStateSequence(plr.FindPSprite(PSP_WEAPON).curstate, weap.ResolveState("Ready3")))
                {
                    // If yes then give powperup
                    owner.A_GiveInventory("PBXWeapons_InfiniteAmmo",1);
                    owner.A_GiveInventory("PBXWeapons_Drain",1);
                }
                if(PBXCore_Debug) console.printf("Getting Cooldown, %d",weap.mPowerTime);
                if(pb_newmugshot) owner.A_SetMugshotState("MegasphereGrin");
            }
            item.bPickupgood = true;
            return true;
        }
        return super.HandlePickup(item);
    }

    // Set Default power time
    override void PostBeginPlay()
    {
        mPowerTime = PBXCore_Duration.GetByCVarInSeconds("pbxweapons_echaingun_duration");
        if(PBXCore_Debug) console.printf("Power Time is %d",mPowerTime);
        Super.PostBeginPlay();
    }

    override void DoEffect() 
	{
		super.DoEffect();
        if (level.isFrozen()) return;
        If(!owner || !owner.player || !owner.player.readyweapon) return;

        let weap = PBX_EternalMinigun(owner.FindInventory("PBX_EternalMinigun"));
        if(!weap || !(owner.player.readyweapon is "PBX_EternalMinigun") || weap.mPowerTime <= 0) return;

        if(level.time % TICRATE != 0) return;
     
        if(PBXCore_Debug) console.printf("counting seconds %d",weap.mPowerTime-1);
        weap.mPowerTime--;
    }

//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////
    action void EChaingun_Fire(bool isAlt = false)
    {
        if(isAlt)
        {
            PB_FireBullets("EternalChaingunTracer", 1, 3, 0, 0, 3);
            PB_FireBullets("EternalChaingunTracer", 1, 3, 0, 0, 3);
            PB_IncrementHeat();
            A_TakeInventory(invoker.ammo1.getClassName(), 1, TIF_NOTAKEINFINITE);
            PB_SpawnCasing("PB_EmptyBrass", 19,-13,24,0,-frandom(3,6),frandom(-1,1), false);
            PB_SpawnCasing("PB_EmptyBrass", 19,-13,24,0,-frandom(3,6),frandom(-1,1), false);
            A_StartSound("weapon/EternalChaingun/Shoot", CHAN_AUTO, CHANF_OVERLAP);
        }
        
        PB_FireBullets("EternalChaingunTracer", 1, 3, 0, 0, 3);
        A_TakeInventory(invoker.ammo1.getClassName(), 1, TIF_NOTAKEINFINITE);
        PB_IncrementHeat();
        PB_GunSmoke_Basic(0,0,2);//A_FireCustomMissile("GunFireSmoke", 0, 0, 0, 0, 0, 0);
        A_StartSound("weapon/EternalChaingun/Shoot", CHAN_AUTO);
        PB_FireOffset();
        PB_DynamicTail("lmg", "lmg");
        A_AlertMonsters();
        PB_SpawnCasing("PB_EmptyBrass", 19,-13,24,0,-frandom(3,6),frandom(-1,1), false);
        PB_WeaponRecoil(-0.6,frandom(1.6, -1.6));
        // A_Firecustommissile("50CaseSpawn",0,0,-12,-18)
    }

    action state EChaingun_Ready()
    {
        if(EChaingun_IsInPowerMode())
            return A_DoPBWeaponAction(WRF_NOSWITCH|WRF_DISABLESWITCH);
        else
            return A_DoPBWeaponAction();
    }

    action bool EChaingun_CanNotFire()
    {
        return !EChaingun_IsInPowerMode() && !invoker.OwnerHasBerserk();
    }

    action bool EChaingun_IsInPowerMode()
    {
        return invoker.mPowerTime > 0;
    }
}