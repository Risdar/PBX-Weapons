enum PBXWeapons_eGeneralFlags{
    ePBX_Weapons_Version = 1 << 0
}

class PBXWeapons_Handler : EventHandler
{
    ui bool CanDraw;
	ui int MaxHealth, Health, ZoomScale, PainChance;
	ui string ActorName;
	ui double Distance;
    
    // This is from Doom Deluxe, all credits goes to Dox778 and the Doom Deluxe team
    override void InterfaceProcess(ConsoleEvent e)
    {
		if(e.name.IndexOf("PrintScopeData:") >= 0 && !e.IsManual)
        {
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
			[hud_origin.x, hud_origin.y, hud_size.x, hud_size.y] =
			Screen.GetViewWindow();
			
			Screen.DrawText(BigFont, Font.CR_GREEN, 190, 86, ActorName,
			DTA_Clean, true
			);
		
			string Wow = string.format("Max. HP: %u\nHP: %u\nPain chance: %u%%", MaxHealth, Health, PainChance);
			Screen.DrawText(SmallFont, Font.CR_GREEN, 190, 104, Wow,
			DTA_Clean, true
			);
			
			string DistanceInMeters = string.format("Distance: %.1f m.", Distance);
			Screen.DrawText(SmallFont, Font.CR_GREEN, 190, 74, DistanceInMeters,
			DTA_Clean, true
			);
		}
	}	

    // Gives the player the AmmoType 2 on spawn
    // This is so the player will always have full ammo when picking up a new weapon
    Override void PlayerEntered(PlayerEvent e)
    {
        let pm = players[e.PlayerNumber].mo;
		if(!pm) return;
        // SLOT 2
        pm.giveinventory("LeverActionAmmo", leveractionFullAmmo);
        // SLOT 3
        pm.giveinventory("CSSGShellsIn",2);
        // SLOT 4
        pm.giveinventory("BR_Ammo", BR_AmmoFull);
        pm.giveinventory("MetalSniperAmmo", MetalSniperFullAmmo-1);
        // SLOT 5
        pm.giveinventory("HMGChamberAmmo", neohmgFullAmmo);
        // SLOT 6
        pm.giveinventory("ExcavatorRounds", excavatorFullAmmo);
        // SLOT 9
        // OTHERS
        PB_HelpNotificationsHandler.PB_SendTip("$PBXWeapons_Version", "PBXWeapons_GeneralFlags", ePBX_Weapons_Version);
        if(!pm.findinventory("PBX_TipsManager"))
            pm.giveinventory("PBX_TipsManager",1);
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