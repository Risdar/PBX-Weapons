extend class PBX_CyberdemonRL
{
//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////
    override void PostBeginPlay()
    {
        PiercingRockets = false;
        shotCount = 0;
        Super.PostBeginPlay();
    }

	// Basically gives the player full durability each time they pickup another launcher
	override void attachtoowner(actor other)
	{
		if(other && other.player)
		{
			if(other.countinv("CyberRLDurability") < CyberdemonRLDurability)
			{
				other.A_giveinventory("CyberRLDurability", CyberdemonRLDurability);
			}
		}
		super.attachtoowner(other);
	}
    
//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////

	action void CyberRL_FireCheck()
	{
		string tofire;
		if(invoker.PiercingRockets) {tofire = "CRL_PiercingRockets";}
		else {tofire = "CRL_NormalRockets";}
		PB_FireBullets(tofire, 1, frandom(-2,2), 0, 0, frandom(-0.5, 0.5));
	}

	action void CyberRl_FireWeapon(int weaponSide, int ticCount)
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
						A_StartSound("Rifle/DSCANFIR", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
						A_ZoomFactor(0.98, SPF_INTERPOLATE);
						// PB_FireBullets("CyberBallsPlayer", 1, frandom(-2,2), 0, 0, frandom(-0.5, 0.5));
				        PB_LowAmmoSoundWarning("default", invoker.ammotype1.getclassname());
        				// PB_TakeAmmo(invoker.ammotype2,1);
						A_TakeInventory(invoker.AmmoType1, invoker.ammoTake, TIF_NOTAKEINFINITE);
						A_TakeInventory("CyberRLDurability",1,TIF_NOTAKEINFINITE);
						CyberRL_FireCheck();
						// A_FireProjectile("CyberBallsPlayer", PB_Math.LinearMap(pb_weapon_recoil_mod_horizontal, 0.0, 1.0, 1.0, 0.2), 0, 0, 0, FPF_NOAUTOAIM, PB_Math.LinearMap(pb_weapon_recoil_mod_vertical, 0.0, 1.0, 1.0, 0.2));
						PB_IncrementHeat(4);
						// A_FireCustomMissile(, random(-2,2), 0, 0, 0, 0, frandom(-0.5,0.5));
						break;
				}
				break;
			//Tic 2
			case 2:
				A_ZoomFactor(1.0, SPF_INTERPOLATE);
				PB_WeaponRecoil(-2,frandom(-2,2));
				break;
		}
	}

	action state CyberRL_HandleAmmo()
	{
		if (CountInv("CyberRLDurability") < 1)
			return ResolveState("WeaponBreak");
		if (invoker.ammo1.amount < ammoTake)
			return ResolveState("NoAmmo");
		return ResolveState(null);
	}

}