enum PBX_eWeaponSpawnerFlags
{
	// SHOTGUN
		// SLOT 2
	DisablePBX_LeverActionRifle				= 1 << 0,

	// SSG
		//SLOT 3
	DisablePBX_CSSG			                = 1 << 0,
    
	// CHAINGUN
		// SLOT 4
	DisablePBX_BattleRifle					= 1 << 0,
	DisablePBX_MetalSniper			        = 1 << 1,
		// SLOT 6
	DisablePBX_NeoHMG			        	= 1 << 2,

	// ROCKET LAUNCHER
		// SLOT 6
	DisablePBX_Excavator			        = 1 << 0,

	// BFG
		// SLOT 9
	DisablePBX_DemonExt			            = 1 << 0,

	// Monster Drops
		// SLOT 6
	DisablePBX_CyberdemonRL			        = 1 << 0,

	// Upgrades
	DisablePBX_CSSGUpgrades			        = 1 << 0,
	DisablePBX_MetalSniperUpgrade			= 1 << 1
}
//////////////////////////// CHAINSAW ////////////////////////////////////////////////////////////////////////////////////


//////////////////////////// PISTOL ////////////////////////////////////////////////////////////////////////////////////


//////////////////////////// SHOTGUN ////////////////////////////////////////////////////////////////////////////////////
class PBXShotgun_Injector : PBInjector
{
	override void Init(PB_EventHandler handler)
	{
		// Lever Action
		if(!(pbx_shotgun_filter & DisablePBX_LeverActionRifle))
		{
			handler.InjectSpawn('PB_ShotSpawnerT1', 'PBX_Prosurv_LeverAction', 255, 1);
			handler.InjectSpawn('PB_ShotSpawnerT2', 'PBX_Prosurv_LeverAction', 255, 1);

			// handler.InjectSpawn('PB_MGSpawnerT1', 'PBX_Prosurv_LeverAction', 255, 1);
		}
	}
}

//////////////////////////// SSG ////////////////////////////////////////////////////////////////////////////////////
class PBXSSG_Injector : PBInjector
{
	override void Init(PB_EventHandler handler)
	{
		// CSSG
		if(!(pbx_ssg_filter & DisablePBX_CSSG))
		{
			handler.InjectSpawn('PB_SSGSpawnerT2', 'PBX_CSSG', 255, 1);
			handler.InjectSpawn('PB_SSGSpawnerT3', 'PBX_CSSG', 255, 1);
			handler.InjectSpawn('PB_SSGSpawnerT4', 'PBX_CSSG', 255, 1);
		}
	}
}

//////////////////////////// CHAINGUN ////////////////////////////////////////////////////////////////////////////////////
class PBXChaingun_Injector : PBInjector
{
	override void Init(PB_EventHandler handler)
	{
		// Battle Rifle
		if(!(pbx_chaingun_filter & DisablePBX_BattleRifle))
		{
			handler.InjectSpawn('PB_MGSpawnerT1', 'PBX_BattleRifle', 255, 1);
			handler.InjectSpawn('PB_MGSpawnerT2', 'PBX_BattleRifle', 255, 1);
		}
		// Metal Sniper
		if(!(pbx_chaingun_filter & DisablePBX_MetalSniper))
		{
			handler.InjectSpawn('PB_MGSpawnerT2', 'PBX_MetalSniper', 255, 1);
			handler.InjectSpawn('PB_MGSpawnerT3', 'PBX_MetalSniper', 255, 1);
			// handler.InjectSpawn('PB_UpgradeSpawnerT3', 'PBX_MetalSniper', 255, 1);
		}

		// Neo HMG
		if(!(pbx_chaingun_filter & DisablePBX_NeoHMG))
		{
			handler.InjectSpawn('PB_MGSpawnerT2', 'PBX_NeoHMG', 255, 1);
			handler.InjectSpawn('PB_MGSpawnerT3', 'PBX_NeoHMG', 255, 1);
			// handler.InjectSpawn('PB_UpgradeSpawnerT3', 'PBX_MetalSniper', 255, 1);
		}
	}
}

//////////////////////////// ROCKETLAUNCHER ////////////////////////////////////////////////////////////////////////////////////
class PBXRocketLauncher_Injector : PBInjector
{
	override void Init(PB_EventHandler handler)
	{
		// Excavator
		if(!(pbx_rocketlauncher_filter & DisablePBX_Excavator))
		{
			handler.InjectSpawn('PB_RLSpawnerT3', 'PBX_Excavator', 255, 1);
			handler.InjectSpawn('PB_RLSpawnerT4', 'PBX_Excavator', 255, 1);
		}
		// // Cyberdemon RL
		// if(!(pbx_rocketlauncher_filter & DisablePBX_CyberdemonRL))
		// {
		// 	handler.InjectSpawn('PB_RLSpawnerT3', 'CyberdemonsMissileLauncher', 255, 1);
		// handler.InjectSpawn('PB_RLSpawnerT4', 'CyberdemonsMissileLauncher', 255, 1);
		// }
	}
}
//////////////////////////// PLASMARIFLE ////////////////////////////////////////////////////////////////////////////////////

//////////////////////////// BFG ////////////////////////////////////////////////////////////////////////////////////
class PBXBFG_Injector : PBInjector
{
    override void Init(PB_EventHandler handler)
    {
		// Demon Ext
		if(!(pbx_bfg_filter & DisablePBX_DemonExt))
		{
		   handler.InjectSpawn("PB_BFGSpawnerT4","PBX_DemonExt",255,1);
		}
    }
}
//////////////////////////// BACKPACKS ////////////////////////////////////////////////////////////////////////////////////
class PBXUpgrades_Injector : PBInjector
{
    override void Init(PB_EventHandler handler)
    {
		// CSSG Upgrades
		if(!(pbx_backpack_filter & DisablePBX_CSSGUpgrades))
		{
			handler.InjectSpawn('PB_UpgradeSpawnerT3', 'DanmakuShellsUpgrade', 255, 1);
			handler.InjectSpawn('PB_UpgradeSpawnerT3', 'WPShellsUpgrade', 255, 1);
			handler.InjectSpawn('PB_UpgradeSpawnerT4', 'ExplosiveShellsUpgrade', 255, 1);
			handler.InjectSpawn('PB_UpgradeSpawnerT4', 'DoomShellsUpgrade', 255, 1);
		}
		
		// Metal Sniper Upgrade
		if(!(pbx_backpack_filter & DisablePBX_MetalSniperUpgrade))
		{
			handler.InjectSpawn('PB_UpgradeSpawnerT3', 'ResonanceAmmo_Upgrade', 255, 1);
			handler.InjectSpawn('PB_UpgradeSpawnerT4', 'ResonanceAmmo_Upgrade', 255, 1);
		}
    }
}

//////////////////////////// OTHER TYPES ////////////////////////////////////////////////////////////////////////////////////
class PBX_WeaponSpawner : EventHandler
{
	override void WorldThingSpawned (WorldEvent e)
    {
        if (!e || !e.thing) return;
        let  actor = e.Thing;

        // Check and Spawn
        switch(actor.GetClassName())
        {
            case 'XDeathCyberdemonGun':
                if(!(special_drop_filter & DisablePBX_CyberdemonRL))
                { 
					// console.printf("Spawning CyberdemonRL from %s", actor.GetClassName());
                   	actor.spawn("PBX_CyberdemonRL", actor.pos);
                    actor.destroy(); 
                } 
                break;

            // case 'PB_FlamethrowerMancubusGas':
            //     if(MancFLameCNDrop)
            //     { 
            //         self.spawnThings("MancubusFlameCannon", monsPos);
            //         self.destroy(); 
            //     } 
            //     break;
        }
    }
}