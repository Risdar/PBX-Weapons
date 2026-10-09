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
		PBXCore_Handler.TryGiveInventory(pm,'PBX_CryoSG', 'CryoSGAmmo', PBX_CryoSG.MAGAZINE_SIZE);
		PBXCore_Handler.TryGiveInventory(pm,'PBX_CryoASG', 'CryoASGAmmo', PBX_CryoASG.DRUM_SIZE);

		// SLOT 4
		PBXCore_Handler.TryGiveInventory(pm,'PBX_NormalRifle', 'NormalRifleAmmo', PBX_NormalRifle.MAGAZINE_SIZE);
		PBXCore_Handler.TryGiveInventory(pm,'PBX_BDPBattleRifle', 'BR_Ammo', PBX_BDPBattleRifle.MAGAZINE_SIZE);
		PBXCore_Handler.TryGiveInventory(pm,'PBX_MetalSniper', 'MetalSniperAmmo', PBX_MetalSniper.MAGAZINE_SIZE);
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
		PBXCore_Handler.TryGiveInventory(pm,'PBX_FreezeRifle', 'FreezeRifleAmmo', PBX_FreezeRifle.CELL_SIZE);

        // SLOT 9
		PBXCore_Handler.TryGiveInventory(pm,'PBX_DemonExt', 'SoulCharge', PBX_DemonExt.SOUL_CAPACITY);
		PBXCore_Handler.TryGiveInventory(pm,'PBX_HexaShotgun', 'HexaShotgunAmmo', PBX_HexaShotgun.BARREL_CAPACITY);

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
    	bool noHit = e.name.IndexOf("NoHitSmartScope") >= 0;

		if(e.IsManual || noHit)
		{
			mCanDraw = false;
			return;
		}

		if((blue || green))
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

		if(e.name.IndexOf("PrintScopeData2:") >= 0)
        {
            double ok = e.args[0];
			mDistance = ok / 32; //32 units should rougly be a meter i hope
			mZoomScale = e.args[1];
        }
    }

	override void UITick()
	{
        let plr = players[consoleplayer].mo;
		if(!plr || !plr.FindInventory("Zoomed"))
		{
			mCanDraw = false;
		}
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
		// Screen.DrawText(SmallFont, color, 190, 104, mPainChance, DTA_Clean, true);
		// Screen.DrawText(SmallFont, color, 190, 74, mDistance, DTA_Clean, true);
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
			console.printf("[PBX] Gave all CSSG shells");
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
			
			// Extermination Unmaker
			pm.giveinventory("ArtifactIncinerator",1);
			pm.giveinventory("ArtifactLightning",1);

			console.printf("[PBX] Gave all weapon upgrades");
		}
		
	}
}

class PBXCore_UpgradeBase : PB_UpgradeItem abstract
{
    name upgradetoken, upgradetype, s;
    property UpgradeToken : upgradetoken;
	property Sprite : upgradetype;

	Default
	{
        PBXCore_UpgradeBase.upgradetoken '';
        PBXCore_UpgradeBase.Sprite '';
		+inventory.alwayspickup;
	}

	override void PlayPickupSound(actor toucher)
	{
		let hnd  = PB_EventHandler(EventHandler.Find("PB_EventHandler"));
		if(hnd)
		{
			if(hnd.pickuptic[toucher.PlayerNumber()]==gametic) return;
			hnd.pickuptic[toucher.PlayerNumber()] = gametic;
		}
		double atten;
		int flags = CHANF_OVERLAP|CHANF_MAYBE_LOCAL;
		if(bNoAttenPickupSound) atten = ATTN_NONE;
		else atten = ATTN_NORM;
		if(toucher && toucher.CheckLocalView()) flags |= CHANF_NOPAUSE;
		toucher.A_StartSound(PickupSound,1002,flags,1.0,atten);
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		PBX_SetUpgradeSprite();
	}

	virtual void PBX_SetUpgradeSprite()
	{
		switch(upgradetype)
		{
            default: s = "TNT1"; break;
		}

        if(upgradetype != "TNT1")
		    sprite = GetSpriteIndex(s);
	}

	States
	{
		Spawn:
			TNT1 A -1 bright light("WeaponUpgradeSpawner");
			stop;

		LoadSprites:
			TNT1 A 0;
	}
}

