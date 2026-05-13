extend class PBX_MastermindChaingun
{
//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////
    override void PostBeginPlay()
    {
        SoulSeekerMode = false;
        Super.PostBeginPlay();
    }

	// Basically gives the player full durability each time they pickup another launcher
	override void attachtoowner(actor other)
	{
		if(other && other.player)
		{
			if(other.countinv("MastermindCGDurability") < MastermindCGFullDurability)
			{
				other.A_giveinventory("MastermindCGDurability", MastermindCGFullDurability);
			}
		}
		super.attachtoowner(other);
	}
    
//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////

	action void MastermindCG_FireCheck()
	{
		string tofire;
		if(invoker.SoulSeekerMode) {tofire = "MastermindCG_SoulSeeker";}
		else {tofire = "MastermindCGProjectile";}
		PB_FireBullets(tofire, 1, frandom(-2,2), 0, 0, frandom(3,-3));
	}

	action void MastermindCG_FireWeapon(int weaponSide, int ticCount)
	{
		switch (ticCount)
		{
			default:
			case 1:
				A_AlertMonsters();
				
				switch (weaponSide)
				{
					default:
					case 0:
						A_StartSound("CHGNSHOT", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
						A_StartSound("FARMGN", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
						A_ZoomFactor(0.98, SPF_INTERPOLATE);
						// PB_FireBullets("CyberBallsPlayer", 1, frandom(-2,2), 0, 0, frandom(-0.5, 0.5));
				        PB_LowAmmoSoundWarning("default", invoker.ammotype1.getclassname());
        				// PB_TakeAmmo(invoker.ammotype2,1);
						A_TakeInventory(invoker.AmmoType1, invoker.ammoTake, TIF_NOTAKEINFINITE);
						A_TakeInventory("MastermindCGDurability",1,TIF_NOTAKEINFINITE);
			 			A_SpawnItemEx("PlayerMuzzle2",30,5,27);
						A_FireCustomMissile("YellowFlareSpawn", 15, 0, 0, 0);
		     			A_FireCustomMissile("YellowFlareSpawn", -15, 0, 0, 0);
						MastermindCG_FireCheck();
						PB_FireOffset();
						// A_FireProjectile("CyberBallsPlayer", PB_Math.LinearMap(pb_weapon_recoil_mod_horizontal, 0.0, 1.0, 1.0, 0.2), 0, 0, 0, FPF_NOAUTOAIM, PB_Math.LinearMap(pb_weapon_recoil_mod_vertical, 0.0, 1.0, 1.0, 0.2));
						PB_IncrementHeat(4);
						// A_FireCustomMissile(, random(-2,2), 0, 0, 0, 0, frandom(-0.5,0.5));
						break;
				}
				break;
			//Tic 2
			case 2:
				A_ZoomFactor(1.0, SPF_INTERPOLATE);
				PB_WeaponRecoil(0.75,frandom(-0.75,0.75));
		    	A_FireCustomMissile("EmptyGrenadeBrass", random(-2,2), 0, 0, -12, 0, random(-2,2));
		    	// A_FireCustomMissile("PBX_20mmDoomguy", random(-2,2), 0, 0, -12, 0, random(-2,2));
				break;
			case 3:
				PB_WeaponRecoil(0.75,frandom(-0.75,0.75));
				break;
		}
	}

	action state MastermindCG_HandleAmmo()
	{
		if (CountInv("MastermindCGDurability") < 1)
			return ResolveState("WeaponBreak");
		if (invoker.ammo1.amount < ammoTake)
			return ResolveState("NoAmmo");
		return ResolveState(null);
	}


}