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
		PBXCore_Handler.TryGiveInventory(pm,'PBX_PlasmaBlaster', 'HellPistolerAmmo', PBX_PlasmaBlaster.CELL_SIZE);
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
		PBXCore_Handler.TryGiveInventory(pm,'PBX_SuperNailgun', 'SuperNailgunAmmo', PBX_SuperNailgun.MAGAZINE_SIZE);

		// SLOT 6
		PBXCore_Handler.TryGiveInventory(pm,'PBX_Excavator', 'ExcavatorRounds', PBX_Excavator.MAGAZINE_SIZE);
		PBXCore_Handler.TryGiveInventory(pm,'PBX_CyberdemonRL', 'CyberRLDurability', PBX_CyberdemonRL.DURABILITY);
		PBXCore_Handler.TryGiveInventory(pm,'PBX_MastermindChaingun', 'MastermindCGDurability', PBX_MastermindChaingun.DURABILITY);

		// SLOT 7
		PBXCore_Handler.TryGiveInventory(pm,'PBX_BDPRailgun', 'BDPRailgunAmmo', PBX_BDPRailgun.MAGAZINE_SIZE);

		// SLOT 8
		PBXCore_Handler.TryGiveInventory(pm,'PBX_TeslaGun', 'TeslaAmmo', PBX_TeslaGun.CELL_SIZE);

        // SLOT 9
		PBXCore_Handler.TryGiveInventory(pm,'PBX_DemonExt', 'SoulCharge', PBX_DemonExt.SOUL_CAPACITY);

        // OTHERS
		PBXCore_Handler.TryGiveInventory(pm,whatToGive:'PBX_ProsurvBlaster', diffCheck:false); // The player will always start with this weapon
		PBXCore_Handler.TryGiveInventory(pm,whatToGive:'PBXWeapons_TipsManager', diffCheck:false);
        if(pbxweapons_normalriflereplace) 
			PBXCore_Handler.TryGiveInventory(pm,whatToGive:'PBX_NormalRifle', diffCheck:false);
		if(pbxweapons_startwithcrossbow) 
			PBXCore_Handler.TryGiveInventory(pm,whatToGive:'PBX_Prosurv_Ballista', diffCheck:false);
    }
}

// This is modified from Doom Deluxe, all credits goes to Dox778 and the Doom Deluxe team
// This handles the target analysis system and scroll zoom inputs
class PBXWeapons_ScopeHandler : EventHandler
{
	// Smart Scope System
	ui bool 	mCanDraw;
	ui int 		mMaxHealth, mCurrentHealth, mZoomScale, mPainChance;
	ui string 	mActorName;
	ui double 	mDistance;
	ui bool 	mUseBlueFont;
    
    override void InterfaceProcess(ConsoleEvent e)
    {
		bool blue = e.name.IndexOf("PrintScopeData_Blue:") >= 0;
    	bool green = e.name.IndexOf("PrintScopeData_Green:") >= 0;

		if((blue || green) && !e.IsManual)
        {
			mUseBlueFont 	= blue;
            mCurrentHealth  = e.args[0];
			mMaxHealth 		= e.args[1];
			double painC 	= e.args[2];
			mPainChance 	= painC / 256 * 100;
			Array<string> command;
			e.Name.Split (command, ":");
			
			if(command.Size() == 2)
				mActorName = command[1];
				
			mCanDraw = true;
        }

		if(e.name.IndexOf("PrintScopeData2:") >= 0 && !e.IsManual)
        {
            double ok = e.args[0];
			mDistance = ok / 32; //32 units should rougly be a meter i hope
			mZoomScale = e.args[1];
        }
    }

	override void UItick()
	{
		mCanDraw = false;
	}
	
	override void RenderUnderlay(RenderEvent e)
	{	
		let phud = PB_Hud_ZS(StatusBar);
        if (!phud || !mCanDraw) return;

		vector2 hud_origin;
		vector2 hud_size;
		[hud_origin.x, hud_origin.y, hud_size.x, hud_size.y] = Screen.GetViewWindow();

		int color = mUseBlueFont ? Font.CR_CYAN : Font.CR_GREEN;
		int flags = BaseStatusBar.DI_SCREEN_CENTER | BaseStatusBar.DI_TEXT_ALIGN_LEFT;

		int hudX = 15;
		int hudY = 30;
		int steps = 15;

		phud.PBHud_DrawString(phud.mBoldFont, mActorName, (hudX, 10), flags, color, scale: (1.3, 1.3));

		Array<string> lines;
		lines.Push(string.format(StringTable.Localize("$PBXWeapons_SmartScope_MaxHP"), mMaxHealth));
		lines.Push(string.format(StringTable.Localize("$PBXWeapons_SmartScope_CurrHP"), mCurrentHealth));
		lines.Push(string.format(StringTable.Localize("$PBXWeapons_SmartScope_PainChance"), mPainChance));
		lines.Push(string.format(StringTable.Localize("$PBXWeapons_SmartScope_Distance"), mDistance));

		for (int i = 0; i < lines.Size(); i++)
		{
			phud.PBHud_DrawString(phud.mDefaultFont, lines[i], (hudX, hudY + i * steps), flags, color);
		}

		// Old version
		// Screen.DrawText(BigFont, color, 190, 86, mActorName, DTA_Clean, true);
		// Screen.DrawText(SmallFont, color, 190, 104, Wow, DTA_Clean, true);
		// Screen.DrawText(SmallFont, color, 190, 74, DistanceInMeters, DTA_Clean, true);
	}
	
	// Scroll Zoom Input
	override bool InputProcess(InputEvent e)
    {
        if (e.Type == InputEvent.Type_None)
            return false;

        let plr = players[consoleplayer].mo;
        if (!plr || !(plr.player.ReadyWeapon is "PBX_WeaponBase") || !plr.FindInventory("Zoomed"))
            return false;

		let weap = PBX_WeaponBase(plr.player.ReadyWeapon);
		if(!weap || !weap.mScopedWeapon) 
			return false;

        if (e.KeyScan == InputEvent.Key_MWheelUp)
        {
        	PBXCore_Debug.Print("Wheel Up");
            SendNetworkEvent("PBXWeapons_ZoomIn");
            return true;
        }

        if (e.KeyScan == InputEvent.Key_MWheelDown)
        {
        	PBXCore_Debug.Print("Wheel Down");
            SendNetworkEvent("PBXWeapons_ZoomOut");
            return true;
        }

        return false;
    }

    override void NetworkProcess(ConsoleEvent e)
    {
        PlayerInfo player = players[e.Player];
        let wpn = PBX_WeaponBase(player.ReadyWeapon);
        if (!wpn || !wpn.mScopedWeapon || !player.mo || !player.mo.FindInventory("Zoomed")) return;

        if (e.Name == "PBXWeapons_ZoomIn")
            wpn.PBX_AdjustZoom(1);
        else if (e.Name == "PBXWeapons_ZoomOut")
            wpn.PBX_AdjustZoom(-1);
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
			// Lever Action
			pm.giveinventory("LeverAction_Upgrade",1);

			// CSSG
			pm.giveinventory("ExplosiveShellsUpgrade",1);
			pm.giveinventory("WPShellsUpgrade",1);
			pm.giveinventory("DoomShellsUpgrade",1);
			pm.giveinventory("DragonBreathUpgrade",1);
			pm.giveinventory("DanmakuUpgrade",1);
			pm.giveinventory("SubZeroUpgrade",1);
			pm.giveinventory("HellFireShellsUpgrade",1);
			pm.giveinventory("AcidShellsUpgradePickup",1);

			// Metal Sniper
			pm.giveinventory("MetalSniper_Upgrade",1);

			// Crossbow Ballista
			pm.giveinventory("PBX_DemonicBallistaUpgrade",1);

			// Excavator Upgrade
			pm.giveinventory("PBX_ExcavatorUpgrade",1);

		}
		
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