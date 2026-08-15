// What gives the playr Nightvision, its basically a powerup
class PBX_Infrared : PB_PowerLightAmp  {default{Powerup.Duration -1800;}}
class PBX_CloseWheel : inventory {default{inventory.maxamount 1;}}

// Handles giving the player ammo (and other things) on map start
// This is so the player will always have full ammo when picking up a new weapon
class PBXWeapons_Handler : EventHandler
{
    Override void PlayerEntered(PlayerEvent e)
    {
		// Get player pointer
        let pm = players[e.PlayerNumber].mo;
		if(!pm) return;

		// Dont continue if its the titlemap
        if (level.MapName == "TITLEMAP") return;

        // SLOT 2
		PBXCore_Handler.TryGiveInventory(pm,'PBX_PlasmaBlaster', 'HellPistolerAmmo', PBX_PlasmaBlaster.MAXCHARGE);
		PBXCore_Handler.TryGiveInventory(pm,'PBX_Prosurv_LeverAction', 'LeverActionAmmo', PBX_Prosurv_LeverAction.MAGAZINE_SIZE);

		// SLOT 3
		PBXCore_Handler.TryGiveInventory(pm,'PBX_ProSurvPSG', 'PumpShotgunAmmo', PBX_ProSurvPSG.MAGAZINE_SIZE);
		PBXCore_Handler.TryGiveInventory(pm,'PBX_CSSG', 'CSSGShellsIn', PBX_CSSG.BARREL_CAPACITY);
		PBXCore_Handler.TryGiveInventory(pm,'PBX_SPAS12', 'PBX_SPAS12Mag', PBX_SPAS12.MAGAZINE_SIZE);

		// SLOT 4
		PBXCore_Handler.TryGiveInventory(pm,'PBX_NormalRifle', 'NormalRifleAmmo', PBX_NormalRifle.MAGAZINE_SIZE);
		PBXCore_Handler.TryGiveInventory(pm,'PBX_BDPBattleRifle', 'BR_Ammo', PBX_BDPBattleRifle.MAGAZINE_SIZE);
		PBXCore_Handler.TryGiveInventory(pm,'PBX_MetalSniper', 'MetalSniperAmmo', PBX_MetalSniper.MAGAZINE_SIZE - 1); // This is because of the weapon respect animation
		PBXCore_Handler.TryGiveInventory(pm,'PBX_Prosurv_Ballista', 'CrossbowBallistaAmmo', PBX_Prosurv_Ballista.ARROW_AMOUNT);

		// SLOT 5
		PBXCore_Handler.TryGiveInventory(pm,'PBX_NeoHMG', 'HMGChamberAmmo', PBX_NeoHMG.MAGAZINE_SIZE);

		// SLOT 6
		PBXCore_Handler.TryGiveInventory(pm,'PBX_Excavator', 'ExcavatorRounds', PBX_Excavator.MAGAZINE_SIZE);
		PBXCore_Handler.TryGiveInventory(pm,'PBX_CyberdemonRL', 'CyberRLDurability', PBX_CyberdemonRL.DURABILITY);
		PBXCore_Handler.TryGiveInventory(pm,'PBX_MastermindChaingun', 'MastermindCGDurability', PBX_MastermindChaingun.DURABILITY);

		// SLOT 7
		PBXCore_Handler.TryGiveInventory(pm,'PBX_BDPRailgun', 'BDPRailgunAmmo', PBX_BDPRailgun.MAGAZINE_SIZE);

        // SLOT 9
		PBXCore_Handler.TryGiveInventory(pm,'PBX_DemonExt', 'SoulCharge', PBX_DemonExt.SOUL_CAPACITY);

        // OTHERS
		PBXCore_Handler.TryGiveInventory(pm,whatToGive:'PBXWeapons_TipsManager', diffCheck:false);
        if(pbxweapons_normalriflereplace) 
			PBXCore_Handler.TryGiveInventory(pm,whatToGive:'PBX_NormalRifle', diffCheck:false);
        if(pbxweapons_startwithblaster) 
			PBXCore_Handler.TryGiveInventory(pm,whatToGive:'PBX_ProsurvBlaster', diffCheck:false);
    }
}

// Laser sight
// Call in DoEffect()
mixin class PBX_LaserSight
{
    void PBX_SpawnLaserSight(name laser = "PBX_RedDot", StateLabel defaultReadyState = "Ready3", int laserRange = 4096)
    {
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

        Spawn(laser, lasersight.HitLocation);
    }
}

// This is from Doom Deluxe, all credits goes to Dox778 and the Doom Deluxe team
// This handles the target analysis system
class PBXWeapons_ScopeHandler : EventHandler
{
	ui bool CanDraw;
	ui int MaxHealth, Health, ZoomScale, PainChance;
	ui string ActorName;
	ui double Distance;
	ui bool IsBlue;
    
    override void InterfaceProcess(ConsoleEvent e)
    {
		bool blue = e.name.IndexOf("PrintScopeData_Blue:") >= 0;
    	bool green = e.name.IndexOf("PrintScopeData:") >= 0;

		if((blue || green) && !e.IsManual)
        {
			IsBlue = blue;
            Health = e.args[0];
			MaxHealth = e.args[1];
			double fuck = e.args[2];
			PainChance = fuck / 256 * 100;
			Array<string> command;
			e.Name.Split (command, ":");
			
			if(command.Size() == 2)
			{
				ActorName = command[1];
				
			}
			CanDraw = true;
        }
		if(e.name.IndexOf("PrintScopeData2:") >= 0 && !e.IsManual)
        {
            double ok = e.args[0];
			Distance = ok / 32; //32 units should rougly be a meter i hope
			ZoomScale = e.args[1];
        }
	
    }

	override void UItick()
	{
		CanDraw = false;
	}
	
	override void RenderUnderlay(RenderEvent e)
	{	
		if(CanDraw)
		{
			vector2 hud_origin;
			vector2 hud_size;
			int color = IsBlue ? Font.CR_CYAN : Font.CR_GREEN;
			[hud_origin.x, hud_origin.y, hud_size.x, hud_size.y] =
			Screen.GetViewWindow();
			
			Screen.DrawText(BigFont, color, 190, 86, ActorName,
			DTA_Clean, true
			);
		
			string Wow = string.format("Max. HP: %u\nHP: %u\nPain chance: %u%%", MaxHealth, Health, PainChance);
			Screen.DrawText(SmallFont, color, 190, 104, Wow,
			DTA_Clean, true
			);
			
			string DistanceInMeters = string.format("Distance: %.1f m.", Distance);
			Screen.DrawText(SmallFont, color, 190, 74, DistanceInMeters,
			DTA_Clean, true
			);
		}
	}	
}

// For easier testing, though you can also disable the upgrades in the backpack spawners
// and it will bypass the upgrade requirements
// to use these cheats just type "netevent <insert cheat name here>" in the console
Class PBXWeapons_CheatsHandler : Eventhandler
{	
	override void NetworkProcess(ConsoleEvent e)
	{
		let pm = players[e.player].mo;
		if(!pm)
			return;
			
		if (e.Name ~== "CM_AllShells")
		{
			pm.giveinventory("ExplosiveShellsUpgrade",1);
			pm.giveinventory("WPShellsUpgrade",1);
			pm.giveinventory("DoomShellsUpgrade",1);
			pm.giveinventory("DragonBreathUpgrade",1);
			pm.giveinventory("DanmakuUpgrade",1);
			pm.giveinventory("SubZeroUpgrade",1);
		}
		if (e.Name ~== "PBX_AllUpgrades")
		{
			// CSSG
			pm.giveinventory("ExplosiveShellsUpgrade",1);
			pm.giveinventory("WPShellsUpgrade",1);
			pm.giveinventory("DoomShellsUpgrade",1);
			pm.giveinventory("DragonBreathUpgrade",1);
			pm.giveinventory("DanmakuUpgrade",1);
			pm.giveinventory("SubZeroUpgrade",1);

			// Battle Rifle
			pm.giveinventory("BattleRifle_Upgrade",1);

			// Metal Sniper
			pm.giveinventory("MetalSniper_Upgrade",1);

			// Crossbow Ballista
			pm.giveinventory("PBX_DemonicBallistaUpgrade",1);

			// Excavator Upgrade
			pm.giveinventory("PBX_ExcavatorUpgrade",1);

		}
		
	}
}

// Homing Projectiles Base
class HomingShots_Aux : Inventory 
{
	uint level;

	States 
	{
		Homing:
			TNT1 A 0 DoHoming();
			TNT1 A 2;
			LOOP;
	}

	// Check if we're in the terminal homing phase of flight. In order to qualify
	// we need to have a target, have a clear line of sight to it, and to have
	// passed those checks twice in a row.
	bool TerminalHoming() 
	{
		return owner.tracer && owner.CheckLOF(
			0, // flags
			64+level*32, // range, 2m + 1m/level
			0, // minrange
			0, 0, // angles
			0, 0, // offset
			AAPTR_TRACER
		);
	}

	void DoHoming() 
	{
		if (!owner) 
		{
			// Our owning projectile vanished. Ideally this should have destroyed us
			// as well, but sometimes that doesn't happen.
			Destroy();
			return;
		}

		// This is kind of gross.
		// Ideally, we'd just call A_SeekerMissile and let it do its thing. However,
		// when it acquires a lock on something it adjusts the Z velocity without
		// any concern for the maximum turn angle settings, which results in a lot
		// of flying directly into a wall/ceiling.

		// So instead, when we're in target-seek mode, we save our current vectors
		// and call A_SeekerMissile() to find a target, then restore the old vectors
		// so even if we find a target the shot continues to fly straight.
		// Note that in some cases, even if it can't acquire a lock (tracer=null after
		// it returns), it'll still fuck with our vectors!
		if (!TerminalHoming()) 
		{
			//   DEBUG("%s: terminal: no, tracer: %s", TAG(owner), TAG(owner.tracer));
			owner.tracer = null;
			let vel = owner.vel;
			let angle = owner.angle;
			owner.A_SeekerMissile(
			0, // terminal homing cone radius
			1, // max turn angle per tic, degrees
			SMF_LOOK | SMF_PRECISE | SMF_CURSPEED,
			min(level*256, 256), // chance of acquiring a new target if it doesn't have one
			min(ceil((64 + level*32)/128.0), 8)); // scan range for new targets in blocks
			// Reject anything that is not a PB_Monster
			if (owner.tracer && !(owner.tracer is "PB_Monster"))
				owner.tracer = null;
			owner.vel = vel;
			owner.angle = angle;
		} 
		else 
		{
			//   DEBUG("%s: terminal: yes, tracer: %s", TAG(owner), TAG(owner.tracer));
			// If we get here we are in "terminal homing mode", which means that:
			// - we have a target
			// - the target is within our terminal homing radius, which depends on
			//   the upgrade level
			// - we have a clear line of sight to the target
			// - all of these conditions have been true two updates in a row
			// which means we should let A_SeekerMissile take over flight control and
			// guide us in.
			owner.A_SeekerMissile(
				0, // terminal homing cone radius
				min(level, 90), // max turn angle per tic, degrees
				SMF_PRECISE | SMF_CURSPEED
			);
		}

		if (owner.tracer != null && pbxweapons_debug)
		{
			if(owner.tracer.CountInv("PBX_RadiusVisualizer") < 1)
			{
				owner.tracer.GiveInventory("PBX_RadiusVisualizer",1);
			}
		}
	}
}


// Laser sights
CLASS PBX_BlueDot : FastProjectile
{ 
	Default
	{
		Decal "None";
		Mass 0;
		Scale 0.2;
		Radius 1;
		Height 2;
		+NOBLOCKMAP;
		+NOGRAVITY;
		+BLOODLESSIMPACT;
		+ALWAYSPUFF;
		+PUFFONACTORS;
		+DONTSPLASH;
		+FORCEXYBILLBOARD;
		Renderstyle "Add";
		Alpha 0.8;
	}
	States
	{
	Spawn:
		LEYS RR 0;
		LEYS B 1 BRIGHT;
		Stop;
	}
}

class PBX_RedDot : PBX_BlueDot
{
    States
	{
	Spawn:
		LEYS RR 0 BRIGHT;
		LEYS R 1 BRIGHT;
		Stop;
	}
}

class PBX_GreenDot : PBX_BlueDot
{
    States
	{
	Spawn:
		LEYS RR 0 BRIGHT;
		LEYS G 1 BRIGHT;
		Stop;
	}
}

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
	States
	{
		Spawn:
			0000 A 0;
			0000 A 1;
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

Class PBX_CubeRadiusCyan : actor
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
	States
	{
		Spawn:
			0001 A 0;
			0001 A 1;
			stop;
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

// Code that I think could be useful but unused
// and I dont know where else to put them lol

// vector3 targetpos = lasersight.HitLocation;
// switch (lasersight.HitType)
// {
// 	case TRACE_HitWall:
// 	{
// 		vector2 wallnormal = (-lasersight.HitLine.delta.y, lasersight.HitLine.delta.x).unit();
// 		if (!lasersight.LineSide) wallnormal *= -1;
// 		targetpos += (wallnormal.x, wallnormal.y, 0) * 2;
// 		break;
// 	}
// 	case TRACE_HitFloor:
// 		targetpos.z += 2;
// 		break;
// 	case TRACE_HitCeiling:
// 		targetpos.z -= 2;
// 		break;
// 	case TRACE_HitActor:
// 		// push back along trace direction so it sits on the actor surface
// 		vector3 traceDir = (cos(pitch) * cos(angle), cos(pitch) * sin(angle), -sin(pitch));
// 		targetpos -= traceDir * 2;
// 		break;
// }

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

// // Replace the DMR if the replace cvar is enabled
// override void AttachToOwner(Actor other)
// {
//     Super.AttachToOwner(other);
//     if (level.MapName ~== "TITLEMAP") return;       // If its the titlemap, return
//     if(!pbxweapons_normalriflereplace) return;      // If the CVAR is disabled, return
//     if(owner.findinventory("DMRUpgraded")) return;  // If the player has the HDMR, return (though this is probably not needed since this function is only called once)

//     // Force switch
//     owner.TakeInventory("PB_DMR",1);
//     if (Owner.player != null) Owner.player.PendingWeapon = self;
// }
// // Give the player ammo instead of picking up the weapon if the replace cvar is enabled
// override bool HandlePickup(Inventory item)
// {
//     bool hasUpgrade = owner.findinventory("DMRUpgraded");
//     bool isTitlemap = level.MapName ~== "TITLEMAP";

//     // This is so you dont need to pick up the upgrade twice
//     if (item is "PB_HDMRUpgrade")
//     {
//         console.printf("success");
//         owner.GiveInventory("PB_DMR",1);
//         owner.GiveInventory("DMRUpgraded",1);
//         return super.HandlePickup(item);
//     }

// 	if (item.GetClassName() == "PB_DMR" 
//         && !isTitlemap                              // If its the titlemap, return
//         && pbxweapons_normalriflereplace            // If the CVAR is disabled, return
//         && !hasUpgrade)                             // If the player has the HDMR, return
// 	{
// 		item.bPickupgood = true;
// 		owner.GiveInventory("PB_HighCalMag", 15); // Give the replacement
// 		return true; // Do not process Fist further
// 	}
// 	return super.HandlePickup(item);
// }

//shells:
	// 0-buckshot 1-slug 2-flechette
	// 3-flak 4-dragon breath
	// 5-explosive 6-white phosphorous 7-Doom shells
	// 8-danmaku 9-subzero
	
	//to cycle shells ->
	// Action Void CycleShellFw()
	// {
	// 	//cycle to the right
	// 	int actmod = invoker.shellsmode;
	// 	invoker.oldshells = actmod;
	// 	A_startsound("menu/change",CHAN_AUTO);
	// 	actmod++;
		
	// 	//dont need extra checks there
	// 	if(actmod < 4)
	// 	{
	// 		invoker.shellsmode = actmod;
	// 		//PrintCurrentShell();
	// 		return;
	// 	}
		
	// 	//this is kinda weird, the idea is, if you DONT have the upgrade, add another, so it jumps to the next shell type
	// 	//if you dont have any upgrade, just go back to 0, wich means buckshot
	// 	//if got dragon breat upgrade
	// 	if(countinv("DragonBreathUpgrade")<1 && actmod == 4)
	// 		actmod++;
	// 	//if got Explosive upgrade
	// 	if(countinv("ExplosiveUpgrade")<1 && actmod == 5)
	// 		actmod++;
	// 	//if got White phosphoruos upgrade (dragon breath 2: this time its personal)
	// 	if(countinv("WhitePhosphorusUpgrade")<1 && actmod == 6)
	// 		actmod++;
	// 	if(countinv("TripleDoomUpgrade")<1 && actmod == 7)
	// 		actmod++;
	// 	if(countinv("DanmakuUpgrade")<1 && actmod == 8)
	// 		actmod++;
			
	// 	if(actmod > 8)
	// 		actmod = 0;
		
	// 	//clamps, so it never goes out from the types allowed
	// 	actmod = clamp(actmod,0,8);
	// 	invoker.shellsmode = actmod;
	// 	//PrintCurrentShell();
	// 	return;
	// }
	
	// //to cycle shells <-
	// Action Void CycleShellBack()
	// {
	// 	//idk why it was harder to do the back cycling than the forward one
	// 	//console.printf("cicling back.");
	// 	int actmod = invoker.shellsmode;
	// 	invoker.oldshells = actmod;
	// 	A_startsound("menu/change",CHAN_AUTO);
		
	// 	actmod--;
		
	// 	if(actmod < 0)
	// 		actmod = 8;
			
	// 	if(actmod < 4)
	// 	{
	// 		invoker.shellsmode = actmod;
	// 		//PrintCurrentShell();
	// 		return;
	// 	}
		
	// 	//the same as the other functions but the other way around, decrements if you dont have that specific upgrade
	// 	if(countinv("DanmakuUpgrade")<1 && actmod == 8)
	// 		actmod--;
	// 	if(countinv("TripleDoomUpgrade")<1 && actmod == 7)
	// 		actmod--;
	// 	if(countinv("WhitePhosphorusUpgrade")<1 && actmod == 6)
	// 		actmod--;
	// 	if(countinv("ExplosiveUpgrade")<1 && actmod == 5)
	// 		actmod--;
	// 	if(countinv("DragonBreathUpgrade")<1 && actmod == 4)
	// 		actmod--;
		
	// 	actmod = clamp(actmod,0,8);
	// 	invoker.shellsmode = actmod;
	// 	//PrintCurrentShell();
		
	// }