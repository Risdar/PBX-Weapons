const CyberdemonRLDurability = 25;

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
        Inventory.AltHudIcon "HND7E0";
		PB_WeaponBase.ReserveToMagAmmoFactor 3;
		
//////////////////////////// AMMO ////////////////////////////////////////////////////////////////////////////////////
		Weapon.AmmoType1 "PB_RocketAmmo";
		// Weapon.AmmoType2 "CyberRLDurability";
	    Weapon.AmmoGive1 30;
	    // Weapon.AmmoGive2 CyberdemonRLDurability; // Picking up a new launcher fully repairs it
		
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

	bool PiercingRockets;
	int shotCount;
	const ammoTake = 3;
	
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
			TNT1 A 0 A_Lower();
			Wait;
		Select:
			TNT1 A 0 PB_WeaponRaise("BFGREADY");
			// TNT1 A 0 PB_RespectIfNeeded();
		SelectContinue:
			TNT1 A 0;
		SelectAnimation:
			TNT1 A 0 A_StartSound("RLCYCLE", CHAN_AUTO, CHANF_OVERLAP);
			CYBF I 0 A_GunFlash();
			CYBF ONML 1 BRIGHT;
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
		Ready:
		Ready3:
			TNT1 A 0 PB_HandleCrosshair(78);
			TNT1 A 0 PB_CoolDownBarrel();
            TNT1 A 0 A_PlaySound("BFGHUM", 6,1,1);
			CYBF IJ 1 BRIGHT A_DoPBWeaponAction();
			Loop;
		
//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
		Fire:
            TNT1 A 0 CyberRL_HandleAmmo();
            TNT1 AAAA 0;
			CYBF A 1 BRIGHT CyberRl_FireWeapon(0,1);
			CYBF B 1 BRIGHT CyberRl_FireWeapon(0,2);
			CYBF C 1 A_SetPitch(pitch-1, SPF_INTERPOLATE);
			CYBF D 1 BRIGHT;
			CYBF D 1 BRIGHT A_SetPitch(pitch+0.6, SPF_INTERPOLATE);
			CYBF EFG 1 BRIGHT A_SetPitch(pitch+0.8, SPF_INTERPOLATE);
			CYBF HJ 1 BRIGHT;
			//CYBF I 0 PB_ReFire;
			// TNT1 A 0 A_FireCustomMissile("SmokeSpawner11",0,0,0,7);
			TNT1 A 0 PB_ReFire();
			goto Ready3;

		Reload:
			TNT1 A 0;
			goto Ready3;

//////////////////////////// ALT FIRE ////////////////////////////////////////////////////////////////////////////////////
		AltFire:
			TNT1 A 0 { invoker.shotCount = 0; }
		AltFireLoop:
			TNT1 A 0 CyberRL_HandleAmmo();
			CYBF A 1 Bright CyberRl_FireWeapon(0, 1);
			CYBF B 1 Bright CyberRl_FireWeapon(0, 2);
			CYBF C 1 A_SetPitch(pitch - 1, SPF_INTERPOLATE);
			CYBF D 1 Bright A_SetPitch(pitch + 0.6, SPF_INTERPOLATE);
			CYBF EFG 1 Bright A_SetPitch(pitch + 0.8, SPF_INTERPOLATE);
			TNT1 A 0 { invoker.shotCount++; }
			TNT1 A 0 A_JumpIf(invoker.shotCount < 3, "AltFireLoop");
			// Shot 4
			TNT1 A 0 CyberRL_HandleAmmo();
			CYBF A 1 Bright CyberRl_FireWeapon(0, 1);
			CYBF B 1 Bright CyberRl_FireWeapon(0, 2);
			CYBF C 1 A_SetPitch(pitch - 1, SPF_INTERPOLATE);
			CYBF D 3 Bright;
			CYBF D 1 Bright A_SetPitch(pitch + 0.6, SPF_INTERPOLATE);
			CYBF EEFFGG 1 Bright A_SetPitch(pitch + 0.4, SPF_INTERPOLATE);
			// TNT1 A 0 A_FireCustomMissile("SmokeSpawner11", 0, 0, 0, 7);
			CYBF HHJ 1 Bright;
			CYBF IJIJIJ 1 Bright;
			// TNT1 A 0 A_FireCustomMissile("SmokeSpawner11", 0, 0, 0, 7);
			TNT1 A 0 PB_ReFire();
			goto Ready3;

        NoAmmo:
            TNT1 A 0 A_PlaySound("weapons/empty", 4);
			CYBF IJIJ 1 BRIGHT A_DoPBWeaponAction(WRF_NOFIRE);
		   	goto Ready3;

		WeaponBreak:
			TNT1 A 0 {
				for(int i = 0; i < 5; i++)
				{
					A_CustomMissile ("MetalShard1", 5, 0, random (-10, -20), 2, random (0, 30));
					A_CustomMissile ("MetalShard2", 5, 0, random (-10, -20), 2, random (0, 30));
					A_CustomMissile ("MetalShard3", 5, 0, random (-10, -20), 2, random (0, 30));
				}
				A_TakeInventory("PBX_CyberdemonRL",1);
				A_Startsound("meleeweapon/break");
				A_ALertMonsters();
				}
			Stop;
		
//////////////////////////// WEAPON SPECIAL ////////////////////////////////////////////////////////////////////////////////////
		Weaponspecial:
			TNT1 A 0 A_Takeinventory("GoWeaponSpecialAbility",1);
			TNT1 A 0 {
				if(invoker.PiercingRockets){
					invoker.PiercingRockets = false;
					// A_Print("$PBX_CyberdemonRL_Normal");
				}
				else {
					invoker.PiercingRockets = true;
					// A_Print("$PBX_CyberdemonRL_Pierce");
				}
            	A_StartSound("MS/Button", CHAN_AUTO, CHANF_OVERLAP);
				A_Print(invoker.PiercingRockets ? "$PBX_CyberdemonRL_Pierce" : "$PBX_CyberdemonRL_Normal");
			}
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