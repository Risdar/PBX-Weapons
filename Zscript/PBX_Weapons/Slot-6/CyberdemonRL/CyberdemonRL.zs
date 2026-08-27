// Ali Jr. - base sprites
// IDDQD_1337 - base brightmaps
// Sechtera - improved firing frames
// SgtMarkIV, TypicalSF, Acclaim Entertainment and Probe Entertainment - muzzle flashes
// Dox778 -  Original Brutal Doom Addon Creator
// Jenny - Port to PB (maybe?)
// Pickup sprite is from Brutal Doom Arthur Edition by arthoriusb2593

// Includes
// #include "./CyberRL_Functions.zs"

class PBX_CyberdemonRL : PBX_WeaponBase
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
        Inventory.AltHudIcon "CYBFV0";
		PB_WeaponBase.ReserveToMagAmmoFactor 3;
		
//////////////////////////// AMMO ////////////////////////////////////////////////////////////////////////////////////
		Weapon.AmmoType1 "PB_RocketAmmo";
	    Weapon.AmmoGive1 30;
		
//////////////////////////// MESSAGES & SOUNDS ////////////////////////////////////////////////////////////////////////////////////
		Obituary "$OB_WEAP_CYBERRL";
		Inventory.Pickupmessage "$PBX_CyberdemonRL_Pickup";
		Inventory.PickupSound "BFGREADY";
		Tag "$PBX_CyberdemonRL_Tag";
        
//////////////////////////// WEAPON FLAGS ////////////////////////////////////////////////////////////////////////////////////
        +WEAPON.NOAUTOAIM;
        +WEAPON.EXPLOSIVE;
        +WEAPON.NOAUTOFIRE;
		+Inventory.AUTOACTIVATE;
        +Inventory.AlwaysPickUp;
        +FORCEXYBILLBOARD;
        +FLOORCLIP;
        +DONTGIB;
	}

//////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////////////////////
	bool PiercingRockets;
	int shotCount;
	const ammoTake = 3; // How many rockets does it take for one point of durability
	const DURABILITY = 75; // Durability Amount
	const DURABILITY_NAME = "CyberRLDurability"; 
      
//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////
    override void PostBeginPlay()
    {
        PiercingRockets = false;
        shotCount = 0;
        Super.PostBeginPlay();
    }

	override bool TryPickup(in out Actor toucher)
    {
        bool pickup = Super.TryPickup(toucher);
        if (pickup)
			toucher.A_giveinventory(DURABILITY_NAME,DURABILITY);
		
        return pickup;
    }
    
//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////

	action void CyberRl_FireWeapon(int ticCount)
	{
		name tofire = invoker.PiercingRockets ? "CRL_PiercingRockets" : "CRL_NormalRockets";
	
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
				A_TakeInventory(DURABILITY_NAME,1,TIF_NOTAKEINFINITE);
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
		if (CountInv(DURABILITY_NAME) < 1) 		return ResolveState("WeaponBreak");
		if (invoker.ammo1.amount < ammoTake) 	return ResolveState("NoAmmo");
		return ResolveState(null);
	}

//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
	States
	{
//////////////////////////// SETUP ////////////////////////////////////////////////////////////////////////////////////
		Spawn:
            HND7 E -1;
            Stop;

        Deselect:
           TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
				PB_HandleCrosshair(-1);
				A_TakeInventory("PB_LockScreenTilt",1);
				A_TakeInventory("RocketLauncherSelected",1);
			}
			TNT1 A 0 A_StopSound(6);
			TNT1 A 0 A_ZoomFactor(1);
			CYBF LMNO 1 BRIGHT;
			TNT1 A 0 A_Lower();
			Wait;
			
		Select:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
			    PB_HandleCrosshair(78);
				A_SetInventory("PB_LockScreenTilt",0);
                PBX_WeaponRaise("BFGREADY");
                PB_WeapTokenSwitch("RocketLauncherSelected");
			    return PB_RespectIfNeeded();
			}
		SelectAnimation:
			TNT1 A 0 A_StartSound("RLCYCLE", CHAN_AUTO, CHANF_OVERLAP);
			CYBF I 0 A_GunFlash();
			CYBF ONML 1 BRIGHT;
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
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
			CYBF A 1 BRIGHT CyberRl_FireWeapon(1);
			CYBF B 1 BRIGHT CyberRl_FireWeapon(2);
			CYBF C 1 A_SetPitch(pitch-1, SPF_INTERPOLATE);
			CYBF D 1 BRIGHT;
			CYBF D 1 BRIGHT A_SetPitch(pitch+0.6, SPF_INTERPOLATE);
			CYBF EFG 1 BRIGHT {
				A_SetPitch(pitch+0.8, SPF_INTERPOLATE);
				if(JustPressed(BT_ATTACK)) return ResolveState("Fire");
                return A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOPRIMARY);
			}
			CYBF HJ 1 BRIGHT {
				if(JustPressed(BT_ATTACK)) return ResolveState("Fire");
                return A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOPRIMARY);
			}
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
			CYBF A 1 Bright CyberRl_FireWeapon(1);
			CYBF B 1 Bright CyberRl_FireWeapon(2);
			TNT1 A 0 A_JumpIf(invoker.shotCount == 4, "FinishLoop");
			CYBF C 1 A_SetPitch(pitch-1, SPF_INTERPOLATE);
			CYBF D 1 Bright A_SetPitch(pitch + 0.6, SPF_INTERPOLATE);
			CYBF EFG 1 Bright A_SetPitch(pitch + 0.8, SPF_INTERPOLATE);
			TNT1 A 0 { invoker.shotCount++; }
			TNT1 A 0 A_JumpIf(invoker.shotCount < 4, "AltFireLoop");
		FinishLoop:
			CYBF C 1 A_SetPitch(pitch - 1, SPF_INTERPOLATE);
			CYBF D 3 Bright;
			CYBF D 1 Bright A_SetPitch(pitch + 0.6, SPF_INTERPOLATE);
			CYBF EEFFGG 1 Bright A_SetPitch(pitch + 0.4, SPF_INTERPOLATE);
			CYBF HHJ 1 Bright;
			CYBF IJIJIJ 1 Bright;
			TNT1 A 0 PB_ReFire();
			goto Ready3;

        NoAmmo:
            TNT1 A 0 A_PlaySound("weapons/empty", 4);
			CYBF IJIJ 1 BRIGHT A_DoPBWeaponAction(WRF_NOFIRE);
		   	goto Ready3;

//////////////////////////// WEAPON SPECIAL ////////////////////////////////////////////////////////////////////////////////////
		Weaponspecial:
			TNT1 A 0 A_Takeinventory("GoWeaponSpecialAbility",1);
			TNT1 A 0 {
				if(invoker.PiercingRockets) invoker.PiercingRockets = false;
				else invoker.PiercingRockets = true;
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