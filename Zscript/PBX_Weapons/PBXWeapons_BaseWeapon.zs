// Generic Weapon Wheel Tokens
class PBX_Toggle_Laser : inventory {default{inventory.maxamount 1;}}
class PBX_Toggle_Scope : inventory {default{inventory.maxamount 1;}}
class PBX_Toggle_NVG   : inventory {default{inventory.maxamount 1;}}
class PBX_CloseWheel   : inventory {default{inventory.maxamount 1;}}

// What gives the player Nightvision, its basically a powerup
class PBX_Infrared : PB_PowerLightAmp  {default{Powerup.Duration -1800;}}

// Laser sight
// Call in DoEffect()
mixin class PBX_LaserSight
{
    void PBX_SpawnLaserSight(.PBX_LaserSightProjectile.PBX_LaserColor laserColor = PBX_LaserSightProjectile.RED_DOT, StateLabel defaultReadyState = "Ready3", int laserRange = 4096)
    {
        if(!mLaserSightActivated) return;

		let psp = owner.player.FindPSprite(PSP_WEAPON);
		if(!psp) return;

        for (int i = 0; i < blockedLaserStates.Size(); i++)
        {
            if (InStateSequence(psp.curstate, ResolveState(blockedLaserStates[i])) 
                && !InStateSequence(psp.curstate, ResolveState(defaultReadyState)))
                return;
        }

        double pz = owner.height * 0.5 - owner.floorclip + owner.player.mo.AttackZOffset * owner.player.crouchFactor;

        FLineTraceData lasersight;
        owner.LineTrace(
			owner.angle, 
			laserRange, 
			owner.pitch, 
            TRF_SOLIDACTORS|TRF_THRUHITSCAN, 
			offsetz: pz, 
			data: lasersight);

        let lasr = PBX_LaserSightProjectile(Spawn("PBX_LaserSightProjectile", lasersight.HitLocation));
        if(lasr)
        {
            lasr.mColor = laserColor;
        }
    }
}

class PBX_WeaponBase : PB_WeaponBase abstract
{
//////////////////////////// WEAPON SETUP ////////////////////////////////////////////////////////////////////////////////////
    Default
    {
        PBX_WeaponBase.ScopeConfiguration false, 1.0, 1.0; 
    }

    override void PostBeginPlay()
    {
        mZoomLevel = mMinZoom;
        super.PostBeginPlay();
    }

    override void DoEffect() 
	{
		super.DoEffect();

        if (level.isFrozen()) return;
        
		If(	owner.player && owner.player.readyweapon.GetClass() is self.GetClass())
        {
		    PBX_HandleNightVision();
            PBX_DoEffectWeaponReady();
		}
    }

    protected virtual void PBX_DoEffectWeaponReady() {}

    // A wrapper for PB_WeaponRaise so we can do some default behaviours
    action void PBX_WeaponRaise(string upSnd = "")
    {
        PBXCore_Debug.Print("WeaponRaise Called");
        PB_WeaponRaise(upSnd);
        if(pbxweapons_sendTip) PBX_WeaponHelpText(); // This function is in PBXWeapons_Tips.zs
        // if(!pbxweapons_keepweapons)
        // {
        //     if(invoker.UpgradedWeapon) PB_SelectIfUpgrade(invoker.UpgradedWeapon.getclassname());
        //     if(invoker.DowngradeWeapon) PB_TakeIfUpgrade(invoker.DowngradeWeapon.getclassname());
        // }
    }

    // Same as above
    action void PBX_WeaponLower()
    {
        PBX_ResetZoom();
        A_SetInventory("PBX_Infrared", 0);
        A_WeaponOffset(0,32);
        PB_SetRoll(0);
        A_SetCrosshair(-1);
        A_TakeInventory("PB_LockScreenTilt",1);
        A_StopSound(CHAN_WEAPON);
        PB_ClearDualWield();
    }

    action state PBX_SetupDualWield(string noAkimboMsg)
    {
        // Dual Wield Toggle
        if (A_CheckAkimbo()) 
            return ResolveState("StopDualWield");
        if (invoker.amount >= 2) 
        {
            if(PB_GetZoom()) return ResolveState("ZoomOut"); // After zoomout it goes to "SwitchToDualWield"
            return ResolveState("SwitchToDualWield");
        }

        // If you dont have 2 weapon
        A_Print(noAkimboMsg);
        return ResolveState("Ready3");
    }

//////////////////////////// ZOOM/NVG/SMART SCOPE ////////////////////////////////////////////////////////////////////////////////////
    // This is set in PostBeginPlay()
    double mZoomLevel;

    // This is set as a Property
    double mMinZoom;
    double mMaxZoom;
    bool mScopedWeapon;
    property ScopeConfiguration: mScopedWeapon,mMinZoom,mMaxZoom;

    // This only changes the internal values
    // You'll need to actually set the zoomfactor by using A_ZoomFactor(PBX_GetZoomLevel());
    action void PBX_AdjustZoom(int dir, double step = 0.5)
    {
        invoker.mZoomLevel = clamp(invoker.mZoomLevel + dir * step, invoker.mMinZoom, invoker.mMaxZoom);
        PBXCore_Debug.PrintInt("Zoom Adjusted with %d",invoker.mZoomLevel);
        A_StartSound("IronSights", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
        A_StartSound("MS/Button", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
        A_SetBlend("Black", 1, 35);
    }

    action void PBX_ResetZoom()
    {
        invoker.mZoomLevel = 1.0;
        PB_SetZoom(false);
    }

    action double PBX_GetZoomLevel()
    {
        return invoker.mZoomLevel;
    }

    bool mLaserSightActivated;

    bool mNightVisionActivated;

    bool mScopeLockedOn;
    int mSmartScopeMode;

    enum PBX_SmartScopeMode
    {
        SMARTSCOPE_DISABLED,
        SMARTSCOPE_PARTIAL,
        SMARTSCOPE_FULL
    }

    // Call in wherever the function to handle the weapon special is located
    action void PBX_ToggleSmartScope()
    {
        invoker.mSmartScopeMode = (invoker.mSmartScopeMode + 1) % 3;
        A_StartSound("MS/Button", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
        A_SetBlend(0x00a100, 0.2, 3);
        switch(PBX_GetSmartScopeMode())
        {
            case SMARTSCOPE_DISABLED:   A_Print("$PBX_Scope1"); break;
            case SMARTSCOPE_PARTIAL:    A_Print("$PBX_Scope2"); break;
            case SMARTSCOPE_FULL:       A_Print("$PBX_Scope3"); break;
        }
    }

    action void PBX_ToggleNightVision()
    {
        invoker.mNightVisionActivated = !invoker.mNightVisionActivated;
        A_Print(invoker.mNightVisionActivated ? "$PBX_nvgOn" : "$PBX_nvgOff");
        A_SetInventory("PBX_Infrared", invoker.mNightVisionActivated);

        if(invoker.mNightVisionActivated) 
            A_StartSound("RA1IF1", CHAN_WEAPON, CHANF_OVERLAP, 1.0);

        A_SetBlend("Black",0.75,16);
    }

    action void PBX_ToggleLaserSight(bool skipPlaySound = false)
    {
        invoker.mLaserSightActivated = !invoker.mLaserSightActivated;
        A_Print(invoker.mLaserSightActivated ? "$PBX_LaserOn" : "$PBX_LaserOff");
        if(!skipPlaySound) 
            A_StartSound("MS/Button", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
    }

    action PBX_SmartScopeMode PBX_GetSmartScopeMode()
    {
        return invoker.mSmartScopeMode;
    }

    // Call in DoEffect()
    bool mShouldPlayNVGSound;
    void PBX_HandleNightVision()
    {
        bool isZoomed = owner.FindInventory("Zoomed");

        if(mNightVisionActivated && isZoomed)
        {
            owner.A_SetInventory("PBX_Infrared",1);
            if(mShouldPlayNVGSound)
            {
                owner.A_StartSound("RA1IF1", CHAN_AUTO, CHANF_OVERLAP);
                mShouldPlayNVGSound = false;
            }
        }
        else
        {
            owner.A_SetInventory("PBX_Infrared",0);
            mShouldPlayNVGSound = true;
        }
    }

    // Call in Ready States
    action void PBX_ReadySmartScope(string fontColor = "Green")
    {
        // Check if the scope is disabled
        if(PBX_GetSmartScopeMode() == SMARTSCOPE_DISABLED) return;

        // Check whats in front of the player
        FLineTraceData HitData;
        bool hit = LineTrace(Angle, 6000, Pitch, 0, player.ViewHeight, 0, 0, HitData);
        if(!hit) return;

        // If it hits something, is a monster, and is not friendly
        if(HitData.HitActor && HitData.HitActor.bISMONSTER && HitData.HitActor.bFRIENDLY == false)
        {	
            // Play a sound
            if(!invoker.mScopeLockedOn)
            {
                // A_SetBlend(0x00a100, 0.2, 3);
                invoker.mScopeLockedOn = true;
                A_StartSound("IronSights", CHAN_WEAPON, CHANF_OVERLAP, 1.0, pitch:1.4);
            }

            // Show the actor's wireframe
            let Wireframe = PBX_CubeRadius(Spawn("PBX_CubeRadius", HitData.HitActor.pos));
            if(Wireframe)
            {
                Wireframe.scale.x = double(HitData.HitActor.Radius) * 2;
                Wireframe.scale.Y = double(HitData.HitActor.Height) * Level.pixelstretch;
                Wireframe.vel = HitData.HitActor.vel;
                Wireframe.mColor = fontColor == "Blue" ? PBX_CubeRadius.BLUE : PBX_CubeRadius.GREEN;
            }

            // Show the Monsters Information
            if(PBX_GetSmartScopeMode() == SMARTSCOPE_FULL)
            {
                // Get the Name, Max HP, and Painchance
                PBXWeapons_ScopeHandler.SendInterfaceEvent(
                    self.PlayerNumber(), 
                    "PrintScopeData_"..fontColor..":"..
                    HitData.HitActor.GetTag(), 
                    HitData.HitActor.health, 
                    HitData.HitActor.GetSpawnHealth(), 
                    HitData.HitActor.PainChance
                );
                // Get the Distance
                PBXWeapons_ScopeHandler.SendInterfaceEvent(
                    self.PlayerNumber(), 
                    "PrintScopeData2:", 
                    Distance3D(HitData.HitActor), 
                    PBX_GetZoomLevel()
                );
            }
        }
        // If it doesnt hit anything, play another sound
        else if(invoker.mScopeLockedOn)
        {
            // A_SetBlend(0xa19900, 0.2, 3);
            invoker.mScopeLockedOn = false;
            A_StartSound("IronSights", CHAN_WEAPON, CHANF_OVERLAP, 1.0, pitch:1.3);
        }
    }

//////////////////////////// FIRING ////////////////////////////////////////////////////////////////////////////////////
    // PB's firebullets modified to shoot non pb_projectile projectiles
    // Taken from one of CSSG's function
    action void PBX_FireBullets(string type, int amount, double angle, double offs, double height, double pitch)
	{
		vector2 spread;
		for(int i = amount; i > 0; i--)
		{
			spread.x = frandom(-angle, angle);
			spread.y = frandom(-pitch, pitch);

			if(i == amount) 
			{
				spread.x *= PB_Math.LinearMap(pb_weapon_recoil_mod_horizontal, 0.0, 1.0, 1.0, 0.2);
				spread.y *= PB_Math.LinearMap(pb_weapon_recoil_mod_vertical, 0.0, 1.0, 1.0, 0.2);
				// spread *= clamp((invoker.sustainedFire / 5), 0, 1);
				spread *= GetCrouchFactor();
			}

			Actor p1, p2 = A_FireProjectile(type, spread.x, 0, offs, height, FPF_NOAUTOAIM, spread.y);

            if(p2)
            {
                PB_Projectile pbProj = PB_Projectile(p2);
				if(pbProj)
					pbProj.isBloodExplosionGenerator = amount > 4 && i == amount;
            }
		}
	}

    // Fire Lighting
    action void PBX_FireLightningGun(
        int damage, 
        double horOfs = 0, 
        double spawnheight = 0, 
        double range = 512, 
        int duration = 1, 
        int delay = 0, 
        int maxChains = 1, 
        int maxlinks = 5,
        name damageType = 'plasma'
    )
	{
		// beamstart is where the lightning appears from:
		Vector3 beamstart = PBXCore_LightningController.L_GetBeamAttachPos(self, horOfs, spawnheight);
		Vector3 beamEnd;

		// hit victim:
		FLineTraceData tr;
		LineTrace(angle, range, pitch, offsetz: PBXCore_LightningController.L_GetAttackHeight(PlayerPawn(self)), data: tr);
		if (tr.HitType == TRACE_HitActor && tr.hitActor && PBXCore_LightningController.L_IsValidVictim(tr.hitActor, self))
		{
			beamEnd = PBXCore_LightningController.L_GetBeamAttachPos(tr.HitActor);
			PBXCore_LightningController.L_StartChain(self, tr.HitActor, damage, range, duration, delay, maxChains, maxlinks, damageType:damageType);
		}
		// hit nothing:
		else
		{
			beamEnd = tr.HitLocation;
		}
		PBXCore_LightningController.L_DrawLightning(beamstart, beamend, spawnSpark: (tr.HitType != TRACE_HitNone), playersource: player);
	}

    // Ricochet function from BDP
    Action void PBX_FireRicochet(
        name projectileName, 
        name casingName = "",
        int projectileAmount = 1, 
        double angle = 1.0,
        double offsets = 0, 
        double height = 0, 
        double pitch = 0,
        name damageType = "Pistol",
        name puffType = "PB_BulletPuff"
    )
	{
		FLineTraceData ricochetdata;
		invoker.owner.LineTrace(invoker.owner.angle, 4096, invoker.owner.pitch, TRF_SOLIDACTORS, offsetz: invoker.owner.player.viewz - invoker.owner.pos.z, data: ricochetdata);
		vector3 hitNormal;

		if(ricochetdata.HitType == TRACE_HitWall )
		{
			if(!ricochetdata.LineSide)
				hitnormal = (ricochetdata.Hitline.delta.y, -ricochetdata.Hitline.delta.x, 0).unit();
			else
				hitnormal = (-ricochetdata.Hitline.delta.y, ricochetdata.Hitline.delta.x, 0).unit();
		}
        
		else if (ricochetdata.HitType == TRACE_HitFloor)
			hitnormal = ricochetdata.HitSector.FloorPlane.normal;
			
		else if (ricochetdata.HitType == TRACE_HitCeiling)
			hitnormal = ricochetdata.HitSector.CeilingPlane.normal;

		Vector3 PlayerAngle = BDPMATH.AngletoVector3(1.0,invoker.owner.angle,invoker.owner.pitch);
		Vector3 BounceAngle = BDPMATH.BounceNormal(PlayerAngle,hitNormal);
		
		Double NextShotAngle,NextShotPitch;
		[NextShotAngle, NextShotPitch] = BDPMATH.Vector3toangles(BounceAngle);

		double anglediff = BDPMath.AngleDiff(invoker.owner.angle % 360.0,nextshotangle % 360.0);
		double pitchdiff = BDPMath.AngleDiff(invoker.owner.pitch % 360.0,nextshotpitch % 360.0);
		
		Vector3 NextShotPosition = level.Vec3Offset(ricochetData.hitlocation, hitnormal * 2.0);
		
        // Actually fire
        PBXCore_Debug.Print("Projectile Fired");
		PB_FireBullets(projectileName, projectileAmount, angle, offsets, height, pitch);
        PB_SpawnCasing(casingName,22,2,28,Frandom(-2, -1),Frandom(5,8),Frandom(3,4));

		If(pitchdiff > 45 || anglediff > 45 || pitchdiff < -45 || anglediff < -45)
			return;
		
		If(ricochetdata.HitType == TRACE_HitWall || ricochetdata.HitType == TRACE_HitFloor || ricochetdata.HitType == TRACE_HitCeiling)
		{
            PBXCore_Debug.Print("Ricochet");
			Invoker.Owner.LineAttack(NextShotAngle,8192,NextShotPitch,35,damageType,puffType,LAF_ABSPOSITION | LAF_ABSOFFSET,null,NextShotPosition.Z,NextShotPosition.x,NextShotPosition.y);
			let ricochettracer = Invoker.owner.spawn("decorativetracer",nextshotposition);
			If(ricochettracer)
			{
                PBXCore_Debug.Print("Ricochet Tracer");
				ricochettracer.angle = nextshotangle;
				ricochettracer.pitch = nextshotpitch;
				ricochettracer.vel3dfromangle(140,nextshotangle,nextshotpitch);
			}
		}
	}

    action void A_Recoil3D(double amt)
	{
		vel += BDPMath.VecFromAngles(angle, pitch, -amt);
	}

//////////////////////////// OTHERS ////////////////////////////////////////////////////////////////////////////////////
    action bool PlayerPressedOnce(int button)
	{
		int bt = player.cmd.buttons;
		int oldbt = player.oldbuttons;
		if((bt & button) && !(oldbt & button))
			return true;
		return false;
	}

    action state A_PressingReload(StateLabel st)
	{
		if ((player.cmd.buttons & BT_RELOAD) || (player.oldbuttons & BT_RELOAD)) 
            return resolvestate(st);
		else 
            return resolvestate(null);
	}

//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
    States
    {
        // Used by monster weapons since they have durability
        WeaponBreak:
			TNT1 A 0 {
				for(int i = 0; i < 5; i++)
				{
					A_CustomMissile ("MetalShard1", 5, 0, random (-10, -20), 2, random (0, 30));
					A_CustomMissile ("MetalShard2", 5, 0, random (-10, -20), 2, random (0, 30));
					A_CustomMissile ("MetalShard3", 5, 0, random (-10, -20), 2, random (0, 30));
				}
				A_ALertMonsters();
				A_Startsound("meleeweapon/break");
            }
        // So any weapon can go to this state if they want to be safely removed
        SafelyRemoveWeapon:
            TNT1 A 0 {
                player.pendingweapon = player.mo.BestWeapon(null);
                self.RemoveInventory(invoker);
            }
			Stop;
    }

    // Proof of concept weapon inspect system
    // will probably lag a lot since its iterating through an array every tic
    // it is also very buggy with things like zooming in
    // override void Tick()
    // {
    //     Super.Tick();

    //     if (!owner || !owner.player || !owner.player.readyweapon)
    //         return;

    //     if (!AmmoType1)
    //         return;

    //     // If ammo2 exists, only proceed when it's maxed out.
    //     // If ammo2 doesn't exist, ammo1 alone is enough (checked above).
    //     if (AmmoType2)
    //     {
    //         let ammo2 = Ammo(owner.FindInventory(ammoType2));
    //         if (!ammo2 || ammo2.amount < ammo2.maxAmount)
    //             return;
    //     }

    //     bool reloadPressed = (owner.player.cmd.buttons & BT_RELOAD) && !(owner.player.oldbuttons & BT_RELOAD);
    //     if(!PB_WeaponIsInReadyState()) return; 

    //     if (reloadPressed)
    //     {
    //         owner.player.SetPSprite(PSP_WEAPON, owner.player.readyweapon.ResolveState("WeaponRespect"));
    //         owner.A_SetZoom(1.0);
    //     }
    // }
}
//////////////////////////// WEAPON WHEEL ////////////////////////////////////////////////////////////////////////////////////
mixin class PBX_GenericSpecialWheel
{
    PBX_WeaponBase mWeap; // Weapon pointer (Needs to be casted again for specific weapon vars)
    actor mRequester;     // Player pointer
    bool mDisabled;       // For upgrades if they're disabled
    vector2 mIconScale;   // Icon scale

    // Bundles the close wheel, laser, scope mode, and nvg
    void PBX_GenericWheel(in out array <PB_SpecialWheel_Mode> spw, string wheelFolder, vector2 laserWheelScale = (1.0,1.0))
    {
		PBX_LaserWheel(spw,wheelFolder,laserWheelScale);
		PBX_ScopeWheel(spw);
        PBX_NVGWheel(spw);
    }

    // Set up class fields
    void PBX_InitializeWheel(in out array <PB_SpecialWheel_Mode> spw, actor requester, vector2 scale = (1.0,1.0))
    {
		super.GetSpecials(spw,requester);
        mRequester = requester;
        mWeap = PBX_WeaponBase(requester.player.readyweapon);
        mIconScale = scale;
        PBX_CloseWheel(spw);
    }

    void PBX_AddWheel(in out array <PB_SpecialWheel_Mode> spw, string img, string alias, string token, vector2 scale = (0,0))
    {
        vector2 scl = scale == (0,0) ? mIconScale : scale;
        PB_SpecialWheel_Mode newWheel = new ("PB_SpecialWheel_Mode");
		newWheel.img = "graphics/WeaponWheel/"..img..".png";
		newWheel.Alias = alias;
		newWheel.tokentogive = token;
		newWheel.scalex = scl.x;
		newWheel.scaley = scl.y;
		spw.push(newWheel);
    }

    bool PBX_CheckInv(name inv, bool checkDisabled = true)
    {
        if(checkDisabled)
            return (mRequester && mRequester.CountInv(inv) > 0) || mDisabled;
        else
            return (mRequester && mRequester.CountInv(inv) > 0);
    }

    void PBX_CloseWheel(in out array <PB_SpecialWheel_Mode> spw)
    {
        PB_SpecialWheel_Mode PBX_CloseWheel = new ("PB_SpecialWheel_Mode");
		PBX_CloseWheel.img = "graphics/WeaponWheel/CloseMenu.png";
		PBX_CloseWheel.Alias = "$PBX_CloseMenu";
		PBX_CloseWheel.tokentogive = "PBX_CloseWheel";
		PBX_CloseWheel.scalex = WHEEL_CLOSEMENU_SCALE;
		PBX_CloseWheel.scaley = WHEEL_CLOSEMENU_SCALE;
		spw.push(PBX_CloseWheel);
    }

    void PBX_LaserWheel(in out array <PB_SpecialWheel_Mode> spw, string wheelFolder, vector2 laserWheelScale = (1.0,1.0))
    {
        if(!mWeap) return;

        PB_SpecialWheel_Mode PBX_ToggleLaser = new("PB_SpecialWheel_Mode");
		if(!mWeap.mLaserSightActivated) 
        {
            PBX_ToggleLaser.Alias = "$PBX_LaserON";
            PBX_ToggleLaser.img = "graphics/WeaponWheel/"..wheelFolder.."/LaserOn.png";
		}
		else 
        {
            PBX_ToggleLaser.Alias = "$PBX_LaserOff";
            PBX_ToggleLaser.img = "graphics/WeaponWheel/"..wheelFolder.."/LaserOff.png";
		}
		PBX_ToggleLaser.tokentogive = "PBX_Toggle_Laser";
		PBX_ToggleLaser.scalex = laserWheelScale.x;
		PBX_ToggleLaser.scaley = laserWheelScale.y;
		spw.push(PBX_ToggleLaser);
    }

    void PBX_ScopeWheel(in out array <PB_SpecialWheel_Mode> spw)
    {
        PB_SpecialWheel_Mode PBX_ToggleScope = new ("PB_SpecialWheel_Mode");
		PBX_ToggleScope.img = "graphics/WeaponWheel/ScopeMode.png";
		PBX_ToggleScope.Alias = "$PBX_GoScope";
		PBX_ToggleScope.tokentogive = "PBX_Toggle_Scope";
		PBX_ToggleScope.scalex = WHEEL_SCOPE_SCALE;
		PBX_ToggleScope.scaley = WHEEL_SCOPE_SCALE;
		spw.push(PBX_ToggleScope);
    }

    void PBX_NVGWheel(in out array <PB_SpecialWheel_Mode> spw)
    {
        if(!mWeap) return;

        PB_SpecialWheel_Mode PBX_ToggleNVG = new ("PB_SpecialWheel_Mode");
		PBX_ToggleNVG.img = "GRAPHICS/HiResPickups/Powerups/VISR1.png";
		if(mWeap.mNightVisionActivated) 
			PBX_ToggleNVG.Alias = "$PBX_nvgOffWW";
		else 
			PBX_ToggleNVG.Alias = "$PBX_nvgOnWW";
		PBX_ToggleNVG.tokentogive = "PBX_Toggle_NVG";
		PBX_ToggleNVG.scalex = WHEEL_NVG_SCALE;
		PBX_ToggleNVG.scaley = WHEEL_NVG_SCALE;
		spw.push(PBX_ToggleNVG);
    }
}

//////////////////////////// LASER SIGHTS ////////////////////////////////////////////////////////////////////////////////////
// Laser sights
CLASS PBX_LaserSightProjectile : FastProjectile
{ 
	Default
	{
		Decal "None";
		Mass 0;
		Scale 0.2;
		Radius 1;
		Height 2;
		Renderstyle "Add";
		Alpha 0.8;
		+NOBLOCKMAP;		+NOGRAVITY;		+BLOODLESSIMPACT;
		+ALWAYSPUFF;		+PUFFONACTORS;	+DONTSPLASH;
		+FORCEXYBILLBOARD;
	}

	int mColor;

	enum PBX_LaserColor
    {
        RED_DOT = 17,
        GREEN_DOT = 6,
        BLUE_DOT = 1
    }

	States
	{
		Spawn:
			LEYS RR 0;
			LEYS B 1 BRIGHT {frame = mColor;}
			Stop;
	}
}

//////////////////////////// CUBES ////////////////////////////////////////////////////////////////////////////////////
// Cubes
Class PBX_CubeRadius : actor
{
	DEFAULT
	{
		Radius 20;
		Height 20;
		Scale 32.0;
		//RenderStyle "STYLE_Translucent";
		//Alpha 0.8;
		+NOINTERACTION
		+NOBLOCKMAP
		+THRUACTORS
		-RANDOMIZE
	}

	int mColor;

	enum PBX_CubeColor
	{
		RED,
		GREEN,
		BLUE
	}

	States
	{
		Spawn:
			0001 A 0;
			0000 A 1 {
				if(mColor == BLUE)
					sprite = GetSpriteIndex("0001");
			}
			stop;
	}
}

Class PBX_CubeRadiusLoop : PBX_CubeRadius
{
	States
	{
		Spawn:
			0000 A 0;
			0000 A 1;
			wait;
	}
}

class PBX_RadiusVisualizer : Inventory
{
    Actor currentCube;

    Default
    {
        +INVENTORY.UNDROPPABLE;
    }

    override void DoEffect()
    {
        Super.DoEffect();

        if (!owner) return;

        if (currentCube && currentCube.bDestroyed)
        {
            currentCube = null;
        }

        // Spawn and size — runs once when cube is null
        if (!currentCube)
        {
            currentCube = Spawn("PBX_CubeRadiusLoop", owner.pos);
            if (!currentCube) return;

            // Set size once on spawn
            currentCube.scale.x = double(owner.radius) * 2;
            currentCube.scale.y = double(owner.height);
        }

        // Every tic change position only
        currentCube.SetOrigin(owner.pos, true);
        currentCube.vel = owner.vel;
        currentCube.angle = owner.angle;
    }

    override void OnDestroy()
    {
        if (currentCube && !currentCube.bDestroyed)
        {
            currentCube.Destroy();
            currentCube = null;
        }

        Super.OnDestroy();
    }
}