const neohmgFullAmmo = 80;

Class HMGChamberAmmo : PB_Ammo{
	Default{
		inventory.maxamount neohmgFullAmmo;
		ammo.backpackamount 0;
		ammo.backpackmaxamount neohmgFullAmmo;
	}
}

Class HMGJustRespect : inventory {default{inventory.maxamount 1;}}

class PBX_NeoHMG : PB_WeaponBase
{
	Default
	{
        //$Title NeoHMG
        //$Category Weapons
        //$Sprite 5DUNA0
        ////SpawnID 9530;
//////////////////////////// WEAPON DATA ////////////////////////////////////////////////////////////////////////////////////
		Weapon.SlotNumber 5;
		Weapon.SlotPriority 0;
	    Weapon.SelectionOrder 506;
	    PB_WeaponBase.RespectItem "HMGJustRespect";
        PB_WeaponBase.UsesWheel true;
		PB_WeaponBase.WheelInfo "HMGWheel";
        Inventory.AltHudIcon "HG0WA0";
		
//////////////////////////// AMMO ////////////////////////////////////////////////////////////////////////////////////
		Weapon.AmmoType1 "PB_HighCalMag";
	    Weapon.AmmoType2 "HMGChamberAmmo";
	    Weapon.AmmoGive1 40;
		
//////////////////////////// SPRITES & OFFSETS ////////////////////////////////////////////////////////////////////////////////////
        PB_WeaponBase.OffsetRecoilX 2.5;
		PB_WeaponBase.OffsetRecoilY 2.0;
		PB_WeaponBase.TailPitch 0.8;

//////////////////////////// MESSAGES & SOUNDS ////////////////////////////////////////////////////////////////////////////////////
        // Obituary "Shattered Into Pieces By Excavator Launcher. Ouch!";
        Inventory.PickupMessage "$PBX_NeoHMG_Pickup";
        Inventory.PickupSound "LMGPKP";
	    Tag "PBX_NeoHMG_Tag";
        
//////////////////////////// WEAPON FLAGS ////////////////////////////////////////////////////////////////////////////////////
        +FORCEXYBILLBOARD
	}
	
//////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////////////////////
	int ammoType;
	enum NeoHMGRounds
	{
		eHeatedRounds = 0,
        eChargedRounds = 1
	}

//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////

	action int getAmmoType()
	{
		return invoker.ammoType;
	}

	action int setAmmoType(int set)
	{
		return invoker.ammoType = set;
	}

	action void Cooldown_Overlay(bool select = false)
	{
		if(!select)
			return A_Overlay(3,"Cooling",true);
		else
			return A_Overlay(3,"Cooling2",true);
	}

	action void fireHMG(int weaponSide, int ticCount)
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
                        A_SetRoll(0);
                        A_TakeInventory("PB_LockScreenTilt",1);
                        // ACTUAL FIRING
						PB_FireBullets("PB_792x57mm", 1, 3, 0, 0, 2.5);
						A_Startsound("weapon/HMG/Fire",30);
						PB_DynamicTail("lmg", "lmg");
						PB_ModifyOverheat(5);
						A_overlay(-7,"MuzzleFlash");
						PB_WeaponRecoil(-1.1,frandom(-0.82,0.82));
						PB_IncrementHeat(2);
						PB_GunSmoke(0, 0, 0);
						PB_LowAmmoSoundWarning("hdmr");
						PB_FireOffset();
						A_QuakeEx(0,1,0,12,0,10,"",QF_WAVE|QF_RELATIVE|QF_SCALEDOWN,0.6,0,0.2,0,0,0.3,0.40);
						A_Zoomfactor(0.985);
                        // TAKE AMMO
				        PB_LowAmmoSoundWarning();
				        pb_takeammo(invoker.ammotype2,1,0);
                        break;
				}
			//Tic 2
			case 2:
				A_ZoomFactor(1.0, SPF_INTERPOLATE);
				break;
		}
	}
	
//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////
    override void attachtoowner(actor other)
	{
		if(other && other.player)
		{
			if(other.countinv(ammotype2) < 1 &&(countinv(respectInventoryItem) < 1))other.A_giveinventory(ammotype2,GetAmmoCapacity(ammotype2));
		}
		super.attachtoowner(other);
	}
    
	override void postbeginplay()
	{
		ammoType = eHeatedRounds;
		super.postbeginplay();
	}
    
//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
	States
	{
//////////////////////////// SETUP ////////////////////////////////////////////////////////////////////////////////////
		Spawn:
            HG0W A -1;
            Stop;
        Steady:
            TNT1 A 0;
            Goto Ready;
        Deselect:
            HG0D ABCD 1;
			TNT1 A 0 A_lower(120);	
			wait;
		WeaponRespect:
			TNT1 A 0 A_setInventory(invoker.respectInventoryItem,1);
			HG0U ABCD 1 A_DoPBWeaponAction();
			goto ready3;
		Select:
			TNT1 A 0 PB_WeaponRaise("weapon/HMG/Stop");
			TNT1 A 0 PB_WeapTokenSwitch("CarbineSelected");
			TNT1 A 0 Cooldown_Overlay(true);
			TNT1 A 0 PB_RespectIfNeeded();
		SelectContinue:
			TNT1 A 0;
		SelectAnimation:
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded, "UnloadedSelect")
			HG0U ABCD 1;
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
		Ready3:
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(), "ReadyUnload")
			HG0F A 1 {
				PB_CoolDownBarrel(0, 0, 3);
				Cooldown_Overlay();
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD); 
			}
			loop;
		
		ReadyUnload:
			HG0R S 1 {
				PB_CoolDownBarrel(0, 0, 3);
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOSECONDARY); 
			}
			loop;

		UnloadedSelect:
			HG0R MNOPQRS 1;
			goto ReadyUnload;
        
//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
		Fire:
            TNT1 A 0 PB_jumpIfNoAmmo("Reload",1,false);
			HG0F B 1 bright fireHMG(0,1);
			HG0F C 1 bright fireHMG(0,2);
			HG0F D 1;
			HG0F E 1;
			TNT1 A 0 A_Weaponoffset(0,32);
			HG0F F 1 A_refire();
			TNT1 A 0 A_startsound("weapon/HMG/Stop",32);
			goto Ready3;

		AltFire:
			goto Ready3;
		
//////////////////////////// RELOAD ////////////////////////////////////////////////////////////////////////////////////
		Reload:
            TNT1 A 0 {
				A_ZoomFactor(1.0);
				A_WeaponOffset(0,32);
			}
			TNT1 A 0 PB_checkReload("RaiseFromEmpty", null, null, "Ready","ReadyUnload",neohmgFullAmmo,1);
			TNT1 A 0 Cooldown_Overlay();
			HG0R ABCD 1;
			HG0R EFGH 1;
			TNT1 A 0 A_StartSound("weapons/sgl/detach",33);
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(),"Reload_Unloaded");
			TNT1 A 0 {
				if(invoker.ammo2.amount < 1 && !PB_GetMagUnloaded())
					PB_SpawnCasing("EmptyLMGMag", 12, -2.5, 6.25,frandom(2,5),frandom(1,3),frandom(2,4));//A_Spawnitem("EmptyLMGMag");EmptyLMGMissileMag
			}
			HG0R IJK 1;
			HG0R L 1 {
				PB_SetMagUnloaded(true);
			}
			HG0R MNOOPP 1;
			HG0R QQQ 1;
			HG0R QRST 1;
		Reload_Unloaded:	
			TNT1 A 0 A_Startsound("weapon/HMG/Reload1",34);
			HG0R UV 1;
			HG0R W 1 {
				PB_AmmoIntoMag(invoker.ammo2.getclassname(),invoker.ammo1.getclassname(),neohmgFullAmmo,1);
				PB_SetMagEmpty(false);
				PB_SetMagUnloaded(false);
			}
			HG0R XX 1;
			HG0R YYZ 1;
			HG1R ABC 1;
			goto Ready3;

        RaiseFromEmpty:
            HG0R S 1;
            goto Reload_Unloaded;

//////////////////////////// UNLOAD ////////////////////////////////////////////////////////////////////////////////////
		Unload:
			TNT1 A 0 A_Jumpif(pb_getmagunloaded(),"ReadyUnload");
			HG0R ABCD 1;
			HG0R EFGH 1;
			TNT1 A 0 A_StartSound("weapons/sgl/detach", 33);
			HG0R IJK 1;
			HG0R L 1 {
				PB_UnloadMag(invoker.ammo2.getclassname(),invoker.ammo1.getclassname(),1);
				PB_SetMagUnloaded(true);
			}
			HG0R MNOOPP 1;
			HG0R QQQ 1;
			HG0R QRS 1; 
			goto ReadyUnload;

//////////////////////////// WEAPON SPECIAL ////////////////////////////////////////////////////////////////////////////////////
		Weaponspecial:
        	TNT1 A 0 A_Takeinventory("GoWeaponSpecialAbility",1);
			goto Ready3;
		
//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
		FlashPunching:
			TNT1 A 0 Cooldown_Overlay();
			HG0K ABCDEFGHFEDCBA 1;
			goto Ready3;
		
		FlashKicking:
			HG0K ABCDEFGHHFEDCBA 1;
			goto Ready3;
			
		FlashAirKicking:
			HG0K ABCDEFGHHHFEDCBA 1;
			goto Ready3;
			
		FlashSlideKicking:
			HG0K ABCDEFGHHHHHHHHHHHHHGFEDCBA 1;
			goto Ready3;
			
		FlashSlideKickingStop:
			HG0K GFEDCBA 1;
			goto Ready3;
		
//////////////////////////// OVERLAYS ////////////////////////////////////////////////////////////////////////////////////
		Cooling:
			TNT1 A 24;
		Cooling2:
			TNT1 A 2 PB_ModifyOverheat(-5);
			Wait;

		MuzzleFlash:
			TNT1 A 0 A_Overlayflags(Overlayid(),PSPF_MIRROR|PSPF_FLIP,random(0,1));
			TNT1 A 0 A_jump(256,"Muzzle1","Muzzle2");
		Muzzle1:
			HG0M AB 1 bright;
			stop;
		Muzzle2:
			HG0M CD 1 bright;
			stop;
		Muzzle3:
			HG0M EF 1 bright;
			stop;
	}
}