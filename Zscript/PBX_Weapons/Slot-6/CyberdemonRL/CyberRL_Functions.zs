extend class PBX_CyberdemonRL
{
//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////
    override void PostBeginPlay()
    {
        PiercingRockets = false;
        shotCount = 0;
        Super.PostBeginPlay();
    }

	// override bool Use(bool pickup)
	// {
	// 	// if(owner.CountInv("CyberRLDurability") < DURABILITY)
	// 	console.printf("Use Overide Initiated");
	// 	if(owner)
	// 	{
	// 		owner.mo.A_SetInventory("CyberRLDurability",25);
	// 		console.printf("Durability Given");
	// 	}
	// 	return false;
	// }
    
//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////

	action void CyberRl_FireWeapon(int ticCount)
	{
		string tofire = invoker.PiercingRockets ? "CRL_PiercingRockets" : "CRL_NormalRockets";
	
		switch (ticCount)
		{
			default:
			case 1:
				A_AlertMonsters();
				A_StartSound("Rifle/DSCANFIR", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
				A_ZoomFactor(0.98, SPF_INTERPOLATE);
				PB_LowAmmoSoundWarning("default", invoker.ammotype1.getclassname());
				// PB_TakeAmmo(invoker.ammotype2,1);
				A_TakeInventory(invoker.AmmoType1, invoker.ammoTake, TIF_NOTAKEINFINITE);
				A_TakeInventory("CyberRLDurability",1,TIF_NOTAKEINFINITE);
				PB_FireBullets(tofire, 1, 0, 0, 0, 0.5);
				PB_IncrementHeat(4);
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
		if (CountInv("CyberRLDurability") < 1) 	return ResolveState("WeaponBreak");
		if (invoker.ammo1.amount < ammoTake) 	return ResolveState("NoAmmo");
		return ResolveState(null);
	}

}