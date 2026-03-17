enum PBX_WeaponSpawnerFlags
{
	// SLOT 3
	DisablePBX_CSSG			                = 1 << 0,
    
	// SLOT 4
	DisablePBX_BattleRifle					= 1 << 0,
	DisablePBX_MetalSniper			        = 1 << 1,

	// SLOT 6
	DisablePBX_Excavator			        = 1 << 0,

	// SLOT 9
	DisablePBX_DemonExt			            = 1 << 0,

	// Monster Drops
	DisablePBX_CyberdemonRL			        = 1 << 0,

	// Upgrades
	DisablePBX_CSSGUpgrades			        = 1 << 0
}

//////////////////////////// SLOT 3 ////////////////////////////////////////////////////////////////////////////////////
class PBXSlot3_Injector : PBInjector
{
	override void Init(PB_EventHandler handler)
	{
		// CSSG
		if(!(pbx_shotgun_filter & DisablePBX_CSSG))
		{
			handler.InjectSpawn('PB_SSGSpawnerT2', 'PB_CSSG', 255, 1);
			handler.InjectSpawn('PB_SSGSpawnerT3', 'PB_CSSG', 255, 1);
			handler.InjectSpawn('PB_SSGSpawnerT4', 'PB_CSSG', 255, 1);
		}
	}
}

//////////////////////////// SLOT 4 ////////////////////////////////////////////////////////////////////////////////////
class PBXSlot4_Injector : PBInjector
{
	override void Init(PB_EventHandler handler)
	{
		// Battle Rifle
		if(!(pbx_chaingun_filter & DisablePBX_BattleRifle))
		{
			handler.InjectSpawn('PB_MGSpawnerT1', 'BDPBattleRifle', 255, 1);
			handler.InjectSpawn('PB_MGSpawnerT2', 'BDPBattleRifle', 255, 1);
		}
		// Metal Sniper
		if(!(pbx_chaingun_filter & DisablePBX_MetalSniper))
		{
			handler.InjectSpawn('PB_MGSpawnerT2', 'PB_MetalSniper', 255, 1);
			handler.InjectSpawn('PB_MGSpawnerT3', 'PB_MetalSniper', 255, 1);
			// handler.InjectSpawn('PB_UpgradeSpawnerT3', 'PB_MetalSniper', 255, 1);
		}
	}
}

//////////////////////////// SLOT 6 ////////////////////////////////////////////////////////////////////////////////////
class PBXSlot6_Injector : PBInjector
{
	override void Init(PB_EventHandler handler)
	{
		// Excavator
		if(!(pbx_rocketlauncher_filter & DisablePBX_Excavator))
		{
			handler.InjectSpawn('PB_RLSpawnerT3', 'PB_Excavator', 255, 1);
			handler.InjectSpawn('PB_RLSpawnerT4', 'PB_Excavator', 255, 1);
		}
		// // Cyberdemon RL
		// if(!(pbx_rocketlauncher_filter & DisablePBX_CyberdemonRL))
		// {
		// 	handler.InjectSpawn('PB_RLSpawnerT3', 'CyberdemonsMissileLauncher', 255, 1);
		// handler.InjectSpawn('PB_RLSpawnerT4', 'CyberdemonsMissileLauncher', 255, 1);
		// }
	}
}

//////////////////////////// SLOT 9 ////////////////////////////////////////////////////////////////////////////////////
class PBXSlot9_Injector : PBInjector
{
    override void Init(PB_EventHandler handler)
    {
		// Demon Ext
		if(!(pbx_bfg_filter & DisablePBX_DemonExt))
		{
		   handler.InjectSpawn("PB_BFGSpawnerT4","PB_DemonExt",255,1);
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
                   	actor.spawn("CyberdemonRL", actor.pos);
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