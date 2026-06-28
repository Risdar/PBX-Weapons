// What gives the playr Nightvision, its basically a powerup
class PBX_Infrared : PB_PowerLightAmp  {default{Powerup.Duration -1800;}}

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

        // OTHERS
		PBXCore_Handler.TryGiveInventory(pm,whatToGive:'PBXWeapons_TipsManager', diffCheck:false);
        if(pbxweapons_normalriflereplace) 
			PBXCore_Handler.TryGiveInventory(pm,whatToGive:'PBX_NormalRifle', diffCheck:false);
        if(pbxweapons_startwithblaster) 
			PBXCore_Handler.TryGiveInventory(pm,whatToGive:'PBX_ProsurvBlaster', diffCheck:false);
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