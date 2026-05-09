const MastermindCGFullDurability = 100;

class PBX_MastermindChaingun : PB_WeaponBase
{
	Default
	{
        //$Title Spider Mastermind Chaingun
        //$Category Weapons
        //$Sprite RMN2A0
//////////////////////////// WEAPON DATA ////////////////////////////////////////////////////////////////////////////////////
		Weapon.SlotNumber 6;
		Weapon.SlotPriority 0;
	    Weapon.SelectionOrder 3800;
        Inventory.AltHudIcon "RMN2A0";
		PB_WeaponBase.ReserveToMagAmmoFactor 1;
		
		Weapon.BobRangeX 0.3;
		Weapon.BobRangeY 0.5;
		Weapon.BobStyle "InverseSmooth";
   		Weapon.BobSpeed 2.0;
    	FloatBobStrength 0.5;
		Scale 0.9;
//////////////////////////// AMMO ///-/////////////////////////////////////////////////////////////////////////////////
		Weapon.AmmoType1 "PB_RocketAmmo";
		// Weapon.AmmoType2 "MastermindCGDurability";
	    Weapon.AmmoGive1 50;
		
//////////////////////////// MESSAGES & SOUNDS ////////////////////////////////////////////////////////////////////////////////////
		Obituary "Mowed down by Mastermind's Chaingun.";
		Inventory.Pickupmessage "$PBX_MastermindCG_Pickup";
		Inventory.PickupSound "CBOXPKUP";
		Tag "$PBX_MastermindCG_Tag";
        
//////////////////////////// WEAPON FLAGS ////////////////////////////////////////////////////////////////////////////////////
        +WEAPON.NOAUTOAIM
        +WEAPON.EXPLOSIVE
        +WEAPON.NOAUTOFIRE
        +FORCEXYBILLBOARD
        +FLOORCLIP
        +DONTGIB
	}

	bool SoulSeekerMode;
	const ammoTake = 2;
	
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
      
//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
	States
	{
//////////////////////////// SETUP ////////////////////////////////////////////////////////////////////////////////////
		Spawn:
            TRP6 A -1;
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
			RMNG JKLMN 1;
			TNT1 A 0 A_Lower();
			Wait;
		Select:
			TNT1 A 0 PB_WeaponRaise("CBOXPKUP");
			// TNT1 A 0 PB_RespectIfNeeded();
		SelectContinue:
			TNT1 A 0;
		SelectAnimation:
			RMNG NMLKJ 1 A_GunFlash();
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
		Ready:
		Ready3:
			TNT1 A 0 PB_HandleCrosshair(69);
			TNT1 A 0 PB_CoolDownBarrel();
			RMNG F 1 A_DoPBWeaponAction();
			Loop;
		
//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
		Fire:
            TNT1 A 0 MastermindCG_HandleAmmo();
            TNT1 AAAA 0;
			RMNG A 1 BRIGHT MastermindCG_FireWeapon(0,1);
			RMNG G 1 BRIGHT MastermindCG_FireWeapon(0,2);
			RMNG HI 1 BRIGHT MastermindCG_FireWeapon(0,3);
		FireSecondShot:
            TNT1 A 0 MastermindCG_HandleAmmo();
			RMNG B 1 BRIGHT MastermindCG_FireWeapon(0,1);
			RMNG G 1 BRIGHT MastermindCG_FireWeapon(0,2);
			RMNG HI 1 BRIGHT MastermindCG_FireWeapon(0,3);
			TNT1 A 0 PB_ReFire();
			RMNG FCDEF 1 A_DoPBWeaponAction();
			RMNG CDEF 2 A_DoPBWeaponAction();
			RMNG CDE 3 A_DoPBWeaponAction();
			goto Ready3;

		Reload:
			TNT1 A 0;
			goto Ready3;

//////////////////////////// ALT FIRE ////////////////////////////////////////////////////////////////////////////////////
		// AltFire:
		// 	TNT1 A 0 { invoker.shotCount = 0; }
		// AltFireLoop:
		// 	TNT1 A 0 CyberRL_HandleAmmo();
		// 	CYBF A 1 Bright CyberRl_FireWeapon(0, 1);
		// 	CYBF B 1 Bright CyberRl_FireWeapon(0, 2);
		// 	CYBF C 1 A_SetPitch(pitch - 1, SPF_INTERPOLATE);
		// 	CYBF D 1 Bright A_SetPitch(pitch + 0.6, SPF_INTERPOLATE);
		// 	CYBF EFG 1 Bright A_SetPitch(pitch + 0.8, SPF_INTERPOLATE);
		// 	TNT1 A 0 { invoker.shotCount++; }
		// 	TNT1 A 0 A_JumpIf(invoker.shotCount < 3, "AltFireLoop");
		// 	// Shot 4
		// 	TNT1 A 0 CyberRL_HandleAmmo();
		// 	CYBF A 1 Bright CyberRl_FireWeapon(0, 1);
		// 	CYBF B 1 Bright CyberRl_FireWeapon(0, 2);
		// 	CYBF C 1 A_SetPitch(pitch - 1, SPF_INTERPOLATE);
		// 	CYBF D 3 Bright;
		// 	CYBF D 1 Bright A_SetPitch(pitch + 0.6, SPF_INTERPOLATE);
		// 	CYBF EEFFGG 1 Bright A_SetPitch(pitch + 0.4, SPF_INTERPOLATE);
		// 	// TNT1 A 0 A_FireCustomMissile("SmokeSpawner11", 0, 0, 0, 7);
		// 	CYBF HHJ 1 Bright;
		// 	CYBF IJIJIJ 1 Bright;
		// 	// TNT1 A 0 A_FireCustomMissile("SmokeSpawner11", 0, 0, 0, 7);
		// 	TNT1 A 0 PB_ReFire();
		// 	goto Ready3;

        NoAmmo:
			RMNG C 2 A_DoPBWeaponAction(WRF_NOFIRE);
			RMNG D 2 A_DoPBWeaponAction(WRF_NOFIRE);
			RMNG E 3 A_DoPBWeaponAction();
			RMNG F 3 A_DoPBWeaponAction();
            TNT1 A 0 A_PlaySound("weapons/empty", 4);
		   	goto Ready3;

		WeaponBreak:
			TNT1 A 0 {
				for(int i = 0; i < 5; i++)
				{
					A_CustomMissile ("MetalShard1", 5, 0, random (-10, -20), 2, random (0, 30));
					A_CustomMissile ("MetalShard2", 5, 0, random (-10, -20), 2, random (0, 30));
					A_CustomMissile ("MetalShard3", 5, 0, random (-10, -20), 2, random (0, 30));
				}
				A_TakeInventory("PBX_MastermindChaingun",1);
				A_Startsound("meleeweapon/break");
				A_ALertMonsters();
				}
			Stop;
		
//////////////////////////// WEAPON SPECIAL ////////////////////////////////////////////////////////////////////////////////////
		Weaponspecial:
			TNT1 A 0 A_Takeinventory("GoWeaponSpecialAbility",1);
			TNT1 A 0 {
				if(invoker.SoulSeekerMode) {
					invoker.SoulSeekerMode = false;
				}
				else {
					invoker.SoulSeekerMode = true;
				}
            	A_StartSound("REVCYC", CHAN_AUTO, CHANF_OVERLAP);
				A_StartSound("weapons/rocket/innercycle", CHAN_AUTO, CHANF_OVERLAP);
				A_Print(invoker.SoulSeekerMode ? "$PBX_MastermindCG_SoulSeeker" : "$PBX_MastermindCG_Normal");
			}
			goto Ready3;

//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
		FlashPunching:
        	RMNG F 1;
			RMNG O 1;
			RMNG P 1;
			RMNG Q 1;
			RMNG R 1;
			RMNG S 4;
			RMNG R 1;
			RMNG Q 1;
			RMNG P 1;
			RMNG O 1;
			RMNG F 1;
			goto Ready3;

        FlashKicking:
			RMNG F 1;
			RMNG O 1;
			RMNG P 1;
			RMNG Q 1;
			RMNG R 1;
			RMNG S 6;
			RMNG R 1;
			RMNG Q 1;
			RMNG P 1;
			RMNG O 1;
			RMNG F 1;
			goto Ready3;
			
		FlashAirKicking:
            RMNG F 1;
			RMNG O 1;
			RMNG P 1;
			RMNG Q 1;
			RMNG R 1;
			RMNG S 7;
			RMNG R 1;
			RMNG Q 1;
			RMNG P 1;
			RMNG O 1;
			RMNG F 1;
			goto Ready3;
			
		FlashSlideKicking:
            RMNG F 1;
			RMNG O 1;
			RMNG P 1;
			RMNG Q 1;
			RMNG R 1;
			RMNG S 13;
			RMNG R 1;
			RMNG Q 1;
			RMNG P 1;
			RMNG O 1;
			RMNG F 1;
			goto Ready3;
			
		FlashSlideKickingStop:
			RMNG F 7;
			goto Ready3;
	}
}