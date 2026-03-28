class PBX_CyberdemonRL : PB_WeaponBase
{
	Default
	{
        //$Title Cyberdemon RL
        //$Category Weapons
        //$Sprite CYBFA0
//////////////////////////// WEAPON DATA ////////////////////////////////////////////////////////////////////////////////////
		Weapon.SlotNumber 6;
		Weapon.SlotPriority 0;
	    Weapon.SelectionOrder 3800;
	    // PB_WeaponBase.RespectItem "RespectExcavatorLauncher";
        Inventory.AltHudIcon "HND7E0";
		
//////////////////////////// AMMO ////////////////////////////////////////////////////////////////////////////////////
		Weapon.AmmoType1 "PB_RocketAmmo";
	    Weapon.AmmoGive1 30;
		
//////////////////////////// MESSAGES & SOUNDS ////////////////////////////////////////////////////////////////////////////////////
		Obituary "%o was blown up by %k's Cyberdemon missile launcher. Ouch!";
		Inventory.Pickupmessage "$PBX_CyberdemonRL_Pickup";
		Inventory.PickupSound "BFGREADY";
		Tag "$PBX_CyberdemonRL_Tag";
        
//////////////////////////// WEAPON FLAGS ////////////////////////////////////////////////////////////////////////////////////
        +WEAPON.NOAUTOAIM
        +WEAPON.EXPLOSIVE
        +WEAPON.NOAUTOFIRE
        +FORCEXYBILLBOARD
        +FLOORCLIP
        +DONTGIB
	}
	
//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////

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
						A_StartSound("Rifle/DSCANFIR", CHAN_WEAPON, CHANF_OVERLAP, 1.0, pitch: 0.6);
						A_ZoomFactor(0.98, SPF_INTERPOLATE);
						// PB_FireBullets("CyberBallsPlayer", 1, frandom(-2,2), 0, 0, frandom(-0.5, 0.5));
				        PB_LowAmmoSoundWarning("default", invoker.ammotype1.getclassname());
						A_TakeInventory(invoker.AmmoType1,2,TIF_NOTAKEINFINITE);
						A_FireProjectile("CyberBallsPlayer", PB_Math.LinearMap(pb_weapon_recoil_mod_horizontal, 0.0, 1.0, 1.0, 0.2), 0, 0, 0, FPF_NOAUTOAIM, PB_Math.LinearMap(pb_weapon_recoil_mod_vertical, 0.0, 1.0, 1.0, 0.2));
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

	
//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////
    // override void attachtoowner(actor other)
	// {
	// 	if(other && other.player)
	// 	{
	// 		if(other.countinv(ammotype1) < 1)other.A_giveinventory(ammotype1,GetAmmoCapacity(ammotype1));
	// 	}
	// 	super.attachtoowner(other);
	// }
      
//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
	States
	{
//////////////////////////// SETUP ////////////////////////////////////////////////////////////////////////////////////
		Spawn:
            HND7 E -1;
            Stop;
        Steady:
            TNT1 A 0;
            Goto Ready;
        Deselect:
           TNT1 A 0 {
				A_WeaponOffset(0,32);
				A_SetRoll(0);
				PB_HandleCrosshair(-1);
				A_TakeInventory("PB_LockScreenTilt",1);
			}
			TNT1 A 0 A_StopSound(6);
			TNT1 A 0 A_ZoomFactor(1);
			CYBF LMNO 1 BRIGHT;
			TNT1 A 0 A_Lower;
			Wait;
		Select:
			TNT1 A 0 PB_WeaponRaise("BFGREADY");
			// TNT1 A 0 PB_RespectIfNeeded();
		SelectContinue:
			TNT1 A 0;
		SelectAnimation:
			TNT1 A 0 A_StartSound("RLCYCLE", CHAN_AUTO, CHANF_OVERLAP);
			CYBF I 0 A_GunFlash;
			CYBF ONML 1 BRIGHT;
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
		Ready:
		Ready3:
			TNT1 A 0 PB_HandleCrosshair(78);
			TNT1 A 0 {
				if(!(pbx_generalsetting_filter & DisablePBX_Smoke)){
					PB_CoolDownBarrel();
				}
			}
            TNT1 A 0 A_PlaySound("BFGHUM", 6,1,1);
			CYBF IJ 1 BRIGHT A_DoPBWeaponAction;
			Loop;
		
//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
		Fire:
            TNT1 A 0 PB_JumpIfNoAmmo("NoAmmo",2,false,false);
            TNT1 AAAA 0;
			CYBF A 1 BRIGHT CyberRl_FireWeapon(0,1);
			CYBF B 1 BRIGHT CyberRl_FireWeapon(0,2);
			CYBF C 1 A_SetPitch(pitch-1, SPF_INTERPOLATE);
			CYBF D 1 BRIGHT;
			CYBF D 1 BRIGHT A_SetPitch(pitch+0.6, SPF_INTERPOLATE);
			CYBF EFG 1 BRIGHT A_SetPitch(pitch+0.8, SPF_INTERPOLATE);
			CYBF HJ 1 BRIGHT;
			//CYBF I 0 PB_ReFire;
			TNT1 A 0 A_FireCustomMissile("SmokeSpawner11",0,0,0,7);
			TNT1 A 0 PB_ReFire;
			goto Ready3;

//////////////////////////// ALT FIRE ////////////////////////////////////////////////////////////////////////////////////
		AltFire:
			TNT1 AAAA 0;
			// Shot 1
			TNT1 A 0 PB_JumpIfNoAmmo("NoAmmo", 2, false, false);
			CYBF A 1 BRIGHT CyberRl_FireWeapon(0, 1);
			CYBF B 1 BRIGHT CyberRl_FireWeapon(0, 2);
			CYBF C 1 A_SetPitch(pitch - 1, SPF_INTERPOLATE);
			CYBF D 1 BRIGHT A_SetPitch(pitch + 0.6, SPF_INTERPOLATE);
			CYBF EFG 1 BRIGHT A_SetPitch(pitch + 0.8, SPF_INTERPOLATE);
			// Shot 2
			TNT1 A 0 PB_JumpIfNoAmmo("NoAmmo", 2, false, false);
			CYBF A 1 BRIGHT CyberRl_FireWeapon(0, 1);
			CYBF B 1 BRIGHT CyberRl_FireWeapon(0, 2);
			CYBF C 1 A_SetPitch(pitch - 1, SPF_INTERPOLATE);
			CYBF D 1 BRIGHT A_SetPitch(pitch + 0.6, SPF_INTERPOLATE);
			CYBF EFG 1 BRIGHT A_SetPitch(pitch + 0.8, SPF_INTERPOLATE);
			// Shot 3
			TNT1 A 0 PB_JumpIfNoAmmo("NoAmmo", 2, false, false);
			CYBF A 1 BRIGHT CyberRl_FireWeapon(0, 1);
			CYBF B 1 BRIGHT CyberRl_FireWeapon(0, 2);
			CYBF C 1 A_SetPitch(pitch - 1, SPF_INTERPOLATE);
			CYBF D 1 BRIGHT A_SetPitch(pitch + 0.6, SPF_INTERPOLATE);
			CYBF EFG 1 BRIGHT A_SetPitch(pitch + 0.8, SPF_INTERPOLATE);
			// Shot 4
			TNT1 A 0 PB_JumpIfNoAmmo("NoAmmo", 2, false, false);
			CYBF A 1 BRIGHT CyberRl_FireWeapon(0, 1);
			CYBF B 1 BRIGHT CyberRl_FireWeapon(0, 2);
			CYBF C 1 A_SetPitch(pitch - 1, SPF_INTERPOLATE);
			CYBF D 3 BRIGHT;
			CYBF D 1 BRIGHT A_SetPitch(pitch + 0.6, SPF_INTERPOLATE);
			CYBF EEFFGG 1 BRIGHT A_SetPitch(pitch + 0.4, SPF_INTERPOLATE);
			TNT1 A 0 A_FireCustomMissile("SmokeSpawner11", 0, 0, 0, 7);
			CYBF HHJ 1 BRIGHT;
			CYBF IJIJIJ 1 BRIGHT;
			TNT1 A 0 A_FireCustomMissile("SmokeSpawner11", 0, 0, 0, 7);
			TNT1 A 0 PB_ReFire;
			goto Ready3;

        NoAmmo:
            TNT1 A 0 A_PlaySound("weapons/empty", 4);
			CYBF IJIJ 1 BRIGHT A_DoPBWeaponAction(WRF_NOFIRE);
		   	goto Ready3;
		
//////////////////////////// WEAPON SPECIAL ////////////////////////////////////////////////////////////////////////////////////
		Weaponspecial:
			TNT1 A 0 A_Takeinventory("GoWeaponSpecialAbility",1);
			TNT1 A 0 A_Print("$PBX_NoSpecial");
			goto Ready3;

//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
		FlashPunching:
            CYBF PQRSTTUUUTTSRQP 1;
			goto Ready3;

        FlashKicking:
			CYBF PQRSTTUUUUTTSRQP 1;
			goto Ready3;
			
		FlashAirKicking:
            CYBF PQRSTTTUUUTTTSRQP 1;
			goto Ready3;
			
		FlashSlideKicking:
            CYBF PQQRRSSTTTTUUUUUTTTTSSRRQQP 1;
			goto Ready3;
			
		FlashSlideKickingStop:
			CYBF SRRQQPP 1;
			goto Ready3;
	}
}