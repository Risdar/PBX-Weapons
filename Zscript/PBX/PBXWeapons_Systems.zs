enum PBXWeapons_eGeneralFlags{
    ePBX_Weapons_Version = 1 << 0
}

class PBXWeapons_Handler : EventHandler
{
    // Gives the player the AmmoType 2 on spawn
    // This is so the player will always have full ammo when picking up a new weapon
    Override void PlayerEntered(PlayerEvent e)
    {
        let pm = players[e.PlayerNumber].mo;
		if(!pm) return;
        if (level.MapName ~== "TITLEMAP") return;
        // SLOT 2
        pm.giveinventory("HellPistolerAmmo", plasmaBlasterFullAmmo);
        pm.giveinventory("LeverActionAmmo", leveractionFullAmmo);
        // SLOT 3
        pm.giveinventory("PumpShotgunAmmo",psgFullAmmo);
        pm.giveinventory("CSSGShellsIn",2);
        // SLOT 4
        pm.giveinventory("NormalRifleAmmo", NormalRifleFullAmmo);
        pm.giveinventory("BR_Ammo", BR_AmmoFull);
        pm.giveinventory("MetalSniperAmmo", MetalSniperFullAmmo-1); // This is because of the weapon respect animation
        pm.giveinventory("CrossbowBallistaAmmo", crossbowBallistaFullAmmo);
        // SLOT 5
        pm.giveinventory("HMGChamberAmmo", neohmgFullAmmo);
        // SLOT 6
        pm.giveinventory("ExcavatorRounds", excavatorFullAmmo);
        pm.giveinventory("CyberRLDurability", CyberdemonRLDurability);
        pm.giveinventory("MastermindCGDurability", MastermindCGFullDurability);
        // SLOT 7
        pm.giveinventory("BDPRailgunAmmo", BDPRailgunFullAmmo);
        // SLOT 9
        // OTHERS
        PB_HelpNotificationsHandler.PB_SendTip("$PBXWeapons_Version", "PBXWeapons_GeneralFlags", ePBX_Weapons_Version);
        pm.giveinventory("PBXWeapons_TipsManager",1);
        if(pbxweapons_normalriflereplace) pm.giveinventory("PBX_NormalRifle",1);
        if(pbxweapons_startwithblaster) pm.giveinventory("PBX_ProsurvBlaster",1);
        // pm.giveinventory("PBXWeapons_MonsterWeapons",1);
        return;
    }

    // Override void WorldLoaded (WorldEvent e)
    // {
    //     // Sets the PB Monster Drop to Just Ammo on First Time Loading
    //     if (!FirstTimeLoadingPBX) return;
    //     CVAR.FindCVar('FirstTimeLoadingPBX').SetBool(false);
    //     //destroy();
    // }
}

// This is from Doom Deluxe, all credits goes to Dox778 and the Doom Deluxe team
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

Class PBXWeapons_CheatsHandler : Eventhandler
{	
	//basically, just type in console "NetEvent CM_AllShells" and voila, you got all the upgrades of this
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