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

	action state handleSpecial()
	{
		A_Takeinventory("GoWeaponSpecialAbility",1);
		A_ZoomFactor(1.0);

		bool goDrop	= countinv("EX_Select_DropMode")  > 0;
		bool goDril	= countinv("EX_Select_DrillMode") > 0;
		bool alreadyDrop = goDrop && getExcavatorMode() == eDropShotMode;
		bool alreadyDrill = goDril && getExcavatorMode() == eDrillChargeMode;

		if(countinv("PBX_CloseWheel") > 0)
		{
			A_TakeInventory("PBX_CloseWheel",1);
			return resolvestate("Ready3");
		}

		if(alreadyDrop || alreadyDrill)
		{
			A_print("$PBX_AlreadySelected");
			cleanmodetokens();
			return resolvestate("ready3");
		}
		
		if(goDrop)
		{
			setExcavatorMode(eDropShotMode);
			A_takeinventory("EX_Select_DropMode",1);
			A_Print("$PBX_Excavator_DropMode");
		}
		if(goDril)
		{
			setExcavatorMode(eDrillChargeMode);
			A_takeinventory("EX_Select_DrillMode",1);
			A_Print("$PBX_Excavator_DrillMode");
		}
		return resolvestate(null);
	}
	
	action void FireWeapon()
	{
		int mode 	 		= getExcavatorMode();
		string msl 	 		= "DrillChargeMode";
        string sound 		= mode == eDrillChargeMode ? "excavator/firedigger" : "excavator/firedropshot";
        string projectile 	= mode == eDrillChargeMode ? "ExcavatorDrill" : "ExcavatorDropShot";
		double pitch 		= mode == eDrillChargeMode ? 3 : 0;
		int crosshair 		= mode == eDrillChargeMode ? 78 : 79;

		A_AlertMonsters();
		A_WeaponOffset(0,32);
		PB_SetRoll(0);
		A_TakeInventory("PB_LockScreenTilt",1);

		A_FireCustomMissile("ShotgunParticles", random(-16,16), 0, -1, random(-9,9));
		A_FireBullets(0, 0, 1, 50, "shotpuff", 0, 130);
		PB_IncrementHeat(4);
		A_FireCustomMissile("RedFlareSpawn",-5,0,0,0);
		A_ZoomFactor(0.96);
		PB_HandleCrosshair(crosshair);

		// ACTUAL FIRING
		PB_FireBullets(projectile, 1, 0, 0, 0, pitch);
		A_StartSound(sound, CHAN_WEAPON, CHANF_OVERLAP);
		
		PB_WeaponRecoil(-3.2,+1.61);//same as the SuperGL - sarge945
		PB_SpawnCasing("EmptyGrenadeBrass", 30, 0, 34, -frandom(1, 3), -frandom(2, 4), 5);
		// TAKE AMMO
		PB_LowAmmoSoundWarning();
		pb_takeammo(invoker.ammotype2,1,0);
	}
	
}