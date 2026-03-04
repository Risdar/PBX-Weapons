// class Excavator_injector : PBInjector
// {
// 	override void Init(PB_EventHandler handler)
// 	{
// 		handler.InjectSpawn('PB_RLSpawnerT3', 'PB_Excavator', 255, 1);
// 		handler.InjectSpawn('PB_RLSpawnerT4', 'PB_Excavator', 255, 1);
// 	}
// }

class BattleRifle_injector : PBInjector
{
	override void Init(PB_EventHandler handler)
	{
		handler.InjectSpawn('PB_MGSpawnerT1', 'BDPBattleRifle', 255, 1);
		handler.InjectSpawn('PB_MGSpawnerT2', 'BDPBattleRifle', 255, 1);
	}
}

class MSniperInjector : PBInjector
{
	override void Init(PB_EventHandler handler)
	{
		handler.InjectSpawn('PB_MGSpawnerT2', 'PB_MetalSniper', 255, 1);
		handler.InjectSpawn('PB_MGSpawnerT3', 'PB_MetalSniper', 255, 1);
		handler.InjectSpawn('PB_UpgradeSpawnerT3', 'PB_MetalSniper', 255, 1);
	}
}

//finally
class CSSG_Injector : PBInjector
{
	override void Init(PB_EventHandler handler)
	{
		handler.InjectSpawn('PB_SSGSpawnerT2', 'PB_CSSG', 255, 1);
		handler.InjectSpawn('PB_SSGSpawnerT3', 'PB_CSSG', 255, 1);
		handler.InjectSpawn('PB_SSGSpawnerT4', 'PB_CSSG', 255, 1);
		
// 		handler.InjectSpawn('PB_PackSpawnerT3', 'DanmakuShellsUpgrade', 255, 1);
// 		handler.InjectSpawn('PB_PackSpawnerT3', 'WPShellsUpgrade', 255, 1);
// 		handler.InjectSpawn('PB_PackSpawnerT4', 'ExplosiveShellsUpgrade', 255, 1);
// 		handler.InjectSpawn('PB_PackSpawnerT4', 'DoomShellsUpgrade', 255, 1);
		
		handler.InjectSpawn('PB_UpgradeSpawnerT3', 'DanmakuShellsUpgrade', 255, 1);
		handler.InjectSpawn('PB_UpgradeSpawnerT3', 'WPShellsUpgrade', 255, 1);
		handler.InjectSpawn('PB_UpgradeSpawnerT4', 'ExplosiveShellsUpgrade', 255, 1);
		handler.InjectSpawn('PB_UpgradeSpawnerT4', 'DoomShellsUpgrade', 255, 1);
	}
}

class DEX_Injector : PBInjector
{
    override void Init(PB_EventHandler handler)
    {
        handler.InjectSpawn("PB_BFGSpawnerT4","PB_DemonExt",255,1);
    }
}