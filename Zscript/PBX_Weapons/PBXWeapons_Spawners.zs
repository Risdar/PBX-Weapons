enum PBXWeapons_eWeaponSpecialSpawns
{
////// Backpacks / Upgrades /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	DisablePBX_CSSGUpgrades			        = 1 << 0, // Actually spawns on the ShellBox spawner
	DisablePBX_MetalSniperUpgrade			= 1 << 1,
	DisablePBX_BattleRifleUpgrade			= 1 << 2,
	DisablePBX_CrossbowBallistaUpgrade		= 1 << 3,
	DisablePBX_UACBackpack					= 1 << 4,
	DisablePBX_ExcavatorUpgrade				= 1 << 5,
////// Monster Drops /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// SLOT 6
	DisablePBX_CyberdemonRL			        = 1 << 0,
	DisablePBX_MastermindCG			        = 1 << 1,
////// Power / Secret Weapons /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	DisablePBX_EternalChaingun			    = 1 << 0,  // Spawns on Megaspheres
	DisablePBX_NukeLauncher					= 1 << 1   // Spawns on Secrets
}

enum PBXWeapons_eShotgunSpawns
{
////// SLOT 2  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	DisablePBX_LeverActionRifle				= 1 << 0,
	DisablePBX_PlasmaBlaster				= 1 << 1,
////// SLOT 3  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	DisablePBX_SPAS12						= 1 << 2,
////// SLOT 4  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	DisablePBX_CrossbowBallista				= 1 << 3
}

enum PBXWeapons_eSSGSpawns
{
////// SLOT 3 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	DisablePBX_CSSG			                = 1 << 0
}

enum PBXWeapons_eChaingunSpawns
{
////// SLOT 4 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	DisablePBX_BattleRifle					= 1 << 0,
	DisablePBX_MetalSniper			        = 1 << 1,
////// SLOT 5 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	DisablePBX_NeoHMG			        	= 1 << 2
}

enum PBXWeapons_eRocketLauncherSpawns
{
////// SLOT 6 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	DisablePBX_Excavator			        = 1 << 0,
	DisablePBX_Paingiver			        = 1 << 1
}

enum PBXWeapons_ePlasmaRifleSpawns
{
////// SLOT 7 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	DisablePBX_BDPRailgun					= 1 << 0
}

enum PBXWeapons_eBFGSpawns
{
////// SLOT 9 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	DisablePBX_DemonExt			            = 1 << 0
}
//////////////////////////// CHAINSAW ////////////////////////////////////////////////////////////////////////////////////


//////////////////////////// PISTOL ////////////////////////////////////////////////////////////////////////////////////


//////////////////////////// SHOTGUN ////////////////////////////////////////////////////////////////////////////////////
class PBXShotgun_Injector : PBInjector
{
	override void Init(PB_EventHandler handler)
	{
		// Plasma Blaster
		if(!(pbxweapons_shotgun_filter & DisablePBX_PlasmaBlaster))
		{
			handler.InjectSpawn('PB_ShotSpawnerT2', 'PBX_PlasmaBlaster', 255, 1);
			handler.InjectSpawn('PB_ShotSpawnerT3', 'PBX_PlasmaBlaster', 255, 1);
			handler.InjectSpawn('PB_ShotSpawnerT4', 'PBX_PlasmaBlaster', 255, 1);
		}
		// Lever Action
		if(!(pbxweapons_shotgun_filter & DisablePBX_LeverActionRifle))
		{
			handler.InjectSpawn('PB_ShotSpawnerT1', 'PBX_Prosurv_LeverAction', 255, 1);
			handler.InjectSpawn('PB_ShotSpawnerT2', 'PBX_Prosurv_LeverAction', 255, 1);
			handler.InjectSpawn('PB_ShotSpawnerT3', 'PBX_Prosurv_LeverAction', 255, 1);
			// handler.InjectSpawn('PB_MGSpawnerT1', 'PBX_Prosurv_LeverAction', 255, 1);
		}
		// SPAS12
		if(!(pbxweapons_shotgun_filter & DisablePBX_SPAS12))
		{
			handler.InjectSpawn('PB_ShotSpawnerT2', 'PBX_SPAS12', 255, 1);
			handler.InjectSpawn('PB_ShotSpawnerT3', 'PBX_SPAS12', 255, 1);
			handler.InjectSpawn('PB_ShotSpawnerT4', 'PBX_SPAS12', 255, 1);
		}
		// Crossbow Ballista
		if(!(pbxweapons_shotgun_filter & DisablePBX_CrossbowBallista))
		{
			handler.InjectSpawn('PB_ShotSpawnerT1', 'PBX_Prosurv_Ballista', 255, 1);
			handler.InjectSpawn('PB_ShotSpawnerT2', 'PBX_Prosurv_Ballista', 255, 1);
			handler.InjectSpawn('PB_ShotSpawnerT3', 'PBX_Prosurv_Ballista', 255, 1);
		}
	}
}

//////////////////////////// SSG ////////////////////////////////////////////////////////////////////////////////////
class PBXSSG_Injector : PBInjector
{
	override void Init(PB_EventHandler handler)
	{
		// CSSG
		if(!(pbxweapons_ssg_filter & DisablePBX_CSSG))
		{
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
		if(!(pbxweapons_chaingun_filter & DisablePBX_BattleRifle))
		{
			handler.InjectSpawn('PB_MGSpawnerT1', 'PBX_BattleRifle', 255, 1);
			handler.InjectSpawn('PB_MGSpawnerT2', 'PBX_BattleRifle', 255, 1);
		}
		// Metal Sniper
		if(!(pbxweapons_chaingun_filter & DisablePBX_MetalSniper))
		{
			handler.InjectSpawn('PB_MGSpawnerT2', 'PBX_MetalSniper', 255, 1);
			handler.InjectSpawn('PB_MGSpawnerT3', 'PBX_MetalSniper', 255, 1);
			// handler.InjectSpawn('PB_UpgradeSpawnerT3', 'PBX_MetalSniper', 255, 1);
		}
		// Neo HMG
		if(!(pbxweapons_chaingun_filter & DisablePBX_NeoHMG))
		{
			// handler.InjectSpawn('PB_MGSpawnerT3', 'PBX_NeoHMG', 255, 1);
			handler.InjectSpawn('PB_MGSpawnerT4', 'PBX_NeoHMG', 255, 1);
		}
	}
}

//////////////////////////// ROCKETLAUNCHER ////////////////////////////////////////////////////////////////////////////////////
class PBXRocketLauncher_Injector : PBInjector
{
	override void Init(PB_EventHandler handler)
	{
		// Excavator
		if(!(pbxweapons_rocketlauncher_filter & DisablePBX_Excavator))
		{
			handler.InjectSpawn('PB_RLSpawnerT3', 'PBX_Excavator', 255, 1);
			handler.InjectSpawn('PB_RLSpawnerT4', 'PBX_Excavator', 255, 1);
		}
		// Paingiver
		if(!(pbxweapons_rocketlauncher_filter & DisablePBX_Paingiver))
		{
			handler.InjectSpawn('PB_RLSpawnerT4', 'PBX_Paingiver', 255, 1);
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
class PBXPlasma_Injector : PBInjector
{
    override void Init(PB_EventHandler handler)
    {
		// BDP Railgun
		if(!(pbxweapons_plasmarifle_filter & DisablePBX_BDPRailgun))
		{
		   handler.InjectSpawn("PB_PlasSpawnerT3","PBX_BDPRailgun",255,1);
		   handler.InjectSpawn("PB_PlasSpawnerT4","PBX_BDPRailgun",255,1);
		}
    }
}
//////////////////////////// BFG ////////////////////////////////////////////////////////////////////////////////////
class PBXBFG_Injector : PBInjector
{
    override void Init(PB_EventHandler handler)
    {
		// Demon Ext
		if(!(pbxweapons_bfg_filter & DisablePBX_DemonExt))
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
		// UAC Backpack
		if(!(pbxweapons_backpack_filter & DisablePBX_UACBackpack))
		{
			handler.InjectSpawn('PB_PackSpawnerT1', 'PBX_CommandPack', 255, 1);
		}

		// CSSG Upgrades
		if(!(pbxweapons_backpack_filter & DisablePBX_CSSGUpgrades))
		{
			handler.InjectSpawn('PB_ShellboxSpawnerT2', 'WPShellsUpgrade', 255, 1);
			handler.InjectSpawn('PB_ShellboxSpawnerT2', 'SubZeroShellsUpgrade', 255, 1);
			handler.InjectSpawn('PB_ShellboxSpawnerT3', 'DanmakuShellsUpgrade', 255, 1);
			handler.InjectSpawn('PB_ShellboxSpawnerT3', 'ExplosiveShellsUpgrade', 255, 1);
			handler.InjectSpawn('PB_ShellboxSpawnerT4', 'DoomShellsUpgrade', 255, 1);
		}
		
		// Metal Sniper Upgrade
		if(!(pbxweapons_backpack_filter & DisablePBX_MetalSniperUpgrade))
		{
			handler.InjectSpawn('PB_UpgradeSpawnerT3', 'MetalSniper_Upgrade', 255, 1);
			handler.InjectSpawn('PB_UpgradeSpawnerT4', 'MetalSniper_Upgrade', 255, 1);
			handler.InjectSpawn('PB_MGSpawnerT4', 'MetalSniper_Upgrade', 255, 1);
		}

		// BattleRifle Upgrades
		if(!(pbxweapons_backpack_filter & DisablePBX_BattleRifleUpgrade))
		{
			handler.InjectSpawn('PB_MGSpawnerT2', 'BattleRifle_Upgrade', 255, 1);
			handler.InjectSpawn('PB_UpgradeSpawnerT2', 'BattleRifle_Upgrade', 255, 1);
		}

		// Crossbow Ballista Upgrades
		if(!(pbxweapons_backpack_filter & DisablePBX_CrossbowBallistaUpgrade))
		{
			handler.InjectSpawn('PB_ShotSpawnerT2', 'PBX_DemonicBallistaUpgrade', 255, 1);
			handler.InjectSpawn('PB_UpgradeSpawnerT2', 'PBX_DemonicBallistaUpgrade', 255, 1);
		}

		// Crossbow Ballista Upgrades
		if(!(pbxweapons_backpack_filter & DisablePBX_ExcavatorUpgrade))
		{
			handler.InjectSpawn('PB_RLSpawnerT3', 'PBX_ExcavatorUpgrade', 255, 1);
			handler.InjectSpawn('PB_RLSpawnerT4', 'PBX_ExcavatorUpgrade', 255, 1);
			handler.InjectSpawn('PB_UpgradeSpawnerT3', 'PBX_ExcavatorUpgrade', 255, 1);
			handler.InjectSpawn('PB_UpgradeSpawnerT4', 'PBX_ExcavatorUpgrade', 255, 1);
		}
    }
}

//////////////////////////// OTHER TYPES ////////////////////////////////////////////////////////////////////////////////////
class PBXWeapons_SpecialInjector : PBInjector
{
    override void Init(PB_EventHandler handler)
    {
		// Eternal Chaingun
		if(!(PBXWeapons_specialdrop_filter & DisablePBX_EternalChaingun))
		{
		   handler.InjectSpawn("PB_MegaSpawnerT3","PBX_EternalMinigun",255,1);
		   handler.InjectSpawn("PB_MegaSpawnerT4","PBX_EternalMinigun",255,1);
		}
    }
}

class PBXWeapons_WeaponSpawner : EventHandler
{
	bool mSecretWeaponSpawned;

	override void WorldLoaded(WorldEvent e)
	{
		// Only do it once
		if(mSecretWeaponSpawned || !pbxweapons_enablesecretweapon) return;

		int mSpawnChance = random(1,100);
		if(mSpawnChance > 10) //10% chance of spawning 
		{
			// console.printf("PBX_SpecialWeaponSpawner not Spawned!, got %d",mSpawnChance);
			return;
		}

		for (int i = 0; i < level.Sectors.Size(); ++i)
		{
			Sector CurrSec = level.Sectors[i];
			vector3 SpawnPos = (CurrSec.centerspot.x, CurrSec.centerspot.y, CurrSec.floorplane.ZAtPoint(CurrSec.centerspot));

			if (CurrSec.IsSecret() && !mSecretWeaponSpawned)
			{
				Actor.Spawn("PBX_SpecialWeaponSpawner", SpawnPos);
                // console.printf("PBX_SpecialWeaponSpawner Spawned!");
				mSecretWeaponSpawned = true;
			}			
		}
	}

	override void WorldUnloaded(WorldEvent e)
	{
		mSecretWeaponSpawned = false;
	}

	override void WorldThingSpawned (WorldEvent e)
    {
        if (!e || !e.thing) return;
        let  actor = e.Thing;

        // Check and Spawn
        switch(actor.GetClassName())
        {
            case 'XDeathCyberdemonGun':
                if(!(PBXWeapons_monsterdrop_filter & DisablePBX_CyberdemonRL))
                { 
					// console.printf("Spawning CyberdemonRL from %s", actor.GetClassName());
                   	actor.spawn("CyberRLPickup", actor.pos);
                    actor.destroy(); 
                } 
                break;

			case 'XDeathSpiderPart6':
                if(!(PBXWeapons_monsterdrop_filter & DisablePBX_MastermindCG))
                { 
                   	actor.spawn("MastermindCGPickup", actor.pos);
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

class PBX_SpecialWeaponSpawner : PBRandomSpawner
{
	Default
	{
		DropItem 'PBX_NukeLauncher', 255, 1;
	}

	override bool HandleSpawnExceptions(name toSpawn)
	{
		if(toSpawn == "PBX_NukeLauncher" && (PBXWeapons_specialdrop_filter & DisablePBX_NukeLauncher))
			return false;
		return true;
	}
}

class PBX_CommandPack : CustomInventory
{
    Default
    {
        Inventory.Amount 1;
        Inventory.PickupMessage "$PBX_CommandPack_Pickup";
		Inventory.PickupSound "CLIPIN";
		Tag "$PBX_CommandPack_Tag";
        +Inventory.AlwaysPickUp;
        +FLOORCLIP;
        +DONTGIB;
    }

    States
    {
        Spawn:
            XPCK A -1;
            Stop; 

        Pickup:
            TNT1 A 0 {
				A_GiveInventory("PB_Backpack",1);
				A_GiveInventory("PBX_NormalRifle",1);
				A_GiveInventory("PBX_ProSurvPSG",1);
				A_GiveInventory("PB_RocketAmmo",20);
			}
            Stop;
    }
}

// THIS IS SUCH A HACK LOL
class CyberRLPickup : CustomInventory
{
    Default
    {
        Inventory.Amount 1;
        Inventory.PickupMessage "$PBX_CyberdemonRL_Pickup";
		Inventory.PickupSound "BFGREADY";
		Tag "$PBX_CyberdemonRL_Tag";
        +Inventory.AlwaysPickUp;
        +FLOORCLIP;
        +DONTGIB;
    }

    States
    {
        Spawn:
            HND7 E -1;
            Stop; 

        Pickup:
            TNT1 A 0 A_GiveInventory ("CyberRLDurability",PBX_CyberdemonRL.DURABILITY);
            TNT1 A 0 A_GiveInventory ("PBX_CyberdemonRL",1);
            Stop;
    }
}

class MastermindCGPickup : CustomInventory
{
    Default
    {
        Inventory.Amount 1;
		Inventory.Pickupmessage "$PBX_MastermindCG_Pickup";
		Inventory.PickupSound "CBOXPKUP";
		Tag "$PBX_MastermindCG_Tag";
        +Inventory.AlwaysPickUp;
        +FLOORCLIP;
        +DONTGIB;
    }

    States
    {
        Spawn:
            TRP6 A -1;
            Stop;

        Pickup:
            TNT1 A 0 A_GiveInventory ("MastermindCGDurability", PBX_MastermindChaingun.DURABILITY);
            TNT1 A 0 A_GiveInventory ("PBX_MastermindChaingun",1);
            Stop;
    }
}