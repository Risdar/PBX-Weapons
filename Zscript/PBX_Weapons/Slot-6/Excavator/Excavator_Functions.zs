extend class PBX_Excavator
{
//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////
    
	Override void DoEffect(){
		if (!owner || !owner.player)
        return;

		let rw = PB_WeaponBase(owner.player.ReadyWeapon);
		if (!rw)
        return;
		
		if( self.GetClass() is rw.GetClass() ){
			if( (owner.player.cmd.buttons & BT_ALTATTACK) && !owner.FindInventory("GrenadeDetonator") ){
				owner.A_SetInventory("GrenadeDetonator",1);owner.A_PlaySound("excavator/detonate");
			}
			if( !(owner.player.cmd.buttons & BT_ALTATTACK) && owner.FindInventory("GrenadeDetonator") ){
				owner.A_SetInventory("GrenadeDetonator",0);
			}
		}
	}

	override void postbeginplay()
	{
		excavatorMode = eDrillChargeMode;
		super.postbeginplay();
	}

//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////

    action int getExcavatorMode()
	{
		return invoker.excavatorMode;
	}
	
	action void setExcavatorMode(int mode = eDrillChargeMode)
	{
		invoker.excavatorMode = mode;
	}

    action void cleanmodetokens()
	{
		A_Takeinventory("EX_Select_DrillMode",1);
		A_takeinventory("EX_Select_DropMode",1);
	}
	
    action void fireExcavator()
	{
		string msl = "DrillChargeMode";
        string sound = "excavator/firedropshot";
					
		switch(getExcavatorMode())
		{
			case eDrillChargeMode:  
				PB_HandleCrosshair(78);
                A_StartSound("excavator/firedigger", 18);
                PB_FireBullets("ExcavatorDrill", 1, 0, 0, 0, 3);
                break;
			case eDropShotMode: 	
				PB_HandleCrosshair(79);
                A_StartSound("excavator/firedropshot", 0);
                PB_FireBullets("ExcavatorDropShot", 1, 0, 0, 0, 0);
                break;
		}
	}

	action void FireWeapon(int weaponSide, int ticCount)
	{
		switch (ticCount)
		{
			//Tic 1
			default:
			case 1:
				A_AlertMonsters();
				switch (weaponSide)
				{
					default:
					case 0:
                        // SETUP
						A_WeaponOffset(0,32);
                        PB_SetRoll(0);
                        A_TakeInventory("PB_LockScreenTilt",1);
                        // ACTUAL FIRING
						A_FireCustomMissile("ShotgunParticles", random(-16,16), 0, -1, random(-9,9));
		                A_FireBullets(0, 0, 1, 50, "shotpuff", 0, 130);
				        PB_IncrementHeat(4);
		                A_FireCustomMissile("RedFlareSpawn",-5,0,0,0);
		                A_ZoomFactor(0.96);
                        fireExcavator(); // THIS FUNCTION ALREADY PLAYS THE FIRING SOUND
		                PB_WeaponRecoil(-3.2,+1.61);//same as the SuperGL - sarge945
						PB_SpawnCasing("EmptyGrenadeBrass", 30, 0, 34, -frandom(1, 3), -frandom(2, 4), 5);
                        // TAKE AMMO
				        PB_LowAmmoSoundWarning();
				        pb_takeammo(invoker.ammotype2,1,0);
                        break;
				}
			//Tic 2
			case 2:
				//A_ZoomFactor(1.0, SPF_INTERPOLATE); WE DONT NEED THIS SINCE THE NEXT FRAMES ALREADY GOES TO 1.0
				break;
			//Tic 3
		}
	}
	
}