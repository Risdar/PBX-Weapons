extend class PBX_MastermindChaingun
{
//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////
    override void PostBeginPlay()
    {
        SoulSeekerMode = false;
        Super.PostBeginPlay();
    }

	// Basically gives the player full durability each time they pickup another launcher
	// override void attachtoowner(actor other)
	// {
	// 	if(other && other.player)
	// 	{
	// 		if(other.countinv(DURABILITY_NAME) < PBX_MastermindChaingun.DURABILITY)
	// 		{
	// 			other.A_giveinventory(DURABILITY_NAME, PBX_MastermindChaingun.DURABILITY);
	// 		}
	// 	}
	// 	super.attachtoowner(other);
	// }
    
//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////
	action void MastermindCG_FireWeapon(int ticCount)
	{
		string tofire = invoker.SoulSeekerMode ? "MastermindCG_SoulSeeker" : "MastermindCGProjectile";

		switch (ticCount)
		{
			default:
			case 1:
				A_AlertMonsters();
				A_StartSound("CHGNSHOT", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
				A_StartSound("FARMGN", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
				A_ZoomFactor(0.98, SPF_INTERPOLATE);
				// PB_FireBullets("CyberBallsPlayer", 1, frandom(-2,2), 0, 0, frandom(-0.5, 0.5));
				PB_LowAmmoSoundWarning("default", invoker.ammotype1.getclassname());
				// PB_TakeAmmo(invoker.ammotype2,1);
				A_TakeInventory(invoker.AmmoType1, invoker.ammoTake, TIF_NOTAKEINFINITE);
				A_TakeInventory(DURABILITY_NAME,1,TIF_NOTAKEINFINITE);
				A_SpawnItemEx("PlayerMuzzle2",30,5,27);
				A_FireCustomMissile("YellowFlareSpawn", 15, 0, 0, 0);
				A_FireCustomMissile("YellowFlareSpawn", -15, 0, 0, 0);
				PB_FireBullets(tofire, 1, frandom(-2,2), 0, 0, frandom(3,-3));
				PB_FireOffset();
				PB_IncrementHeat(4);
				break;
			//Tic 2
			case 2: case 3:
				if(ticCount == 2){
					A_ZoomFactor(1.0, SPF_INTERPOLATE);
					A_FireCustomMissile("EmptyGrenadeBrass", random(-2,2), 0, 0, -12, 0, random(-2,2));
					// A_FireCustomMissile("PBX_20mmDoomguy", random(-2,2), 0, 0, -12, 0, random(-2,2));
				}
				PB_WeaponRecoil(-0.75,frandom(-0.75,0.75));
				break;
		}
	}

	action state MastermindCG_HandleAmmo()
	{
		if (CountInv(DURABILITY_NAME) < 1)
			return ResolveState("WeaponBreak");
		if (invoker.ammo1.amount < ammoTake)
			return ResolveState("NoAmmo");
		return ResolveState(null);
	}


}