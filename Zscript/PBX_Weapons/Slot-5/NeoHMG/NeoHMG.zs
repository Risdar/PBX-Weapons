const neohmgFullAmmo = 80;

class PBX_NeoHMG : PB_WeaponBase
{
	Default
	{
        //$Title NeoHMG
        //$Category Weapons
        //$Sprite HG0WA0
//////////////////////////// WEAPON DATA ////////////////////////////////////////////////////////////////////////////////////
		Weapon.SlotNumber 5;
		Weapon.SlotPriority 0;
	    Weapon.SelectionOrder 506;
        PB_WeaponBase.UsesWheel true;
		PB_WeaponBase.WheelInfo "HMGWheel";
        Inventory.AltHudIcon "HG0WA0";
		PB_WeaponBase.MaxOverheat 400;
		PB_WeaponBase.OverheatCoolingRate 4;

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

	action void cleanmodetokens()
    {
        A_SetInventory("HMG_Select_Heated",  0);
        A_SetInventory("HMG_Select_Charged", 0);
    }

	action state HMG_HandleSpecial()
    {
        bool alreadyHeated  = FindInventory("HMG_Select_Heated")  && getAmmoType() == eHeatedRounds;
        bool alreadyCharged = FindInventory("HMG_Select_Charged") && getAmmoType() == eChargedRounds;

        if (alreadyHeated || alreadyCharged)
        {
            A_Print("$PBX_AlreadySelected");
            cleanmodetokens();
            return resolvestate("Ready3");
        }

        if (FindInventory("HMG_Select_Heated"))
        {
            setAmmoType(eHeatedRounds);
            A_Print("$PBX_NeoHMG_Heated");
        }
        else if (FindInventory("HMG_Select_Charged"))
        {
            setAmmoType(eChargedRounds);
            A_Print("$PBX_NeoHMG_Charged");
        }

        cleanmodetokens();
        return resolvestate(null);
    }

	action int getAmmoType()
	{
		return invoker.ammoType;
	}

	action int setAmmoType(int set)
	{
		return invoker.ammoType = set;
	}

	action void HMG_fireBullet()
	{
		string loadedbullets;
		string soundtouse;
		
		if(PB_GetOverheat() > 115)
		{
			switch(getAmmoType())
			{
				default:
				case eHeatedRounds:
					loadedbullets = "PB_792x57mm_Heated";
					soundtouse = "MG42FIR";
					break;
				case eChargedRounds:
					loadedbullets = "PB_792x57mm_Charged";
					soundtouse = "PLSM9";
					break;
			}
		}
		else
		{
			loadedbullets = "PB_792x57mm";
			soundtouse = "weapon/HMG/Fire";
		}
		A_Startsound(soundtouse,30);
		PB_FireBullets(loadedbullets, 1, 3, 0, 0, 2.5);
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
						HMG_fireBullet();
						PB_DynamicTail("lmg", "lmg");
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
				PB_ModifyOverheat(5);
				A_ZoomFactor(1.0, SPF_INTERPOLATE);
				break;
		}
	}
	
//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////
    
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
			HG0U ABCD 1 A_DoPBWeaponAction();
			goto ready3;
		Select:
			TNT1 A 0 PB_WeaponRaise("weapon/HMG/Stop");
			TNT1 A 0 PB_WeapTokenSwitch("CarbineSelected");
			TNT1 A 0 A_Overlay(3,"Cooling",true);
			TNT1 A 0 PB_RespectIfNeeded();
		SelectContinue:
			TNT1 A 0;
		SelectAnimation:
			TNT1 A 0 {if(PB_GetOverheat() > 1) {A_Overlay(3, "Cooling",true);}}
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(), "UnloadedSelect");
			HG0U ABCD 1;
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
		Ready3:
			"####" A 0 {
				if(PB_GetOverheat() > 1) {A_Overlay(3, "Cooling",true);}
				PB_HandleCrosshair(52);
			}
		ReadyToFire:
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(), "ReadyUnload");
			HG0F A 1 {
				if (!(pbx_generalsetting_filter & DisablePBX_Smoke))
                	{PB_CoolDownBarrel(0, 0, 3);}
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD); 
			}
			loop;
		
		ReadyUnload:
			HG0R R 1 {
				if (!(pbx_generalsetting_filter & DisablePBX_Smoke))
                	{PB_CoolDownBarrel(0, 0, 3);}
				PB_HandleCrosshair(52);
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOSECONDARY); 
			}
			loop;

		UnloadedSelect:
			HG0R MNOPQRS 1;
			goto ReadyUnload;
        
//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
		Fire:
			TNT1 A 0 PB_HandleCrosshair(52);
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
			TNT1 A 0 PB_checkReload("RaiseFromEmpty", null, null, "Ready","Ready",neohmgFullAmmo,1);
			TNT1 A 0 A_Overlay(3,"Cooling",true);
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
				PB_SetChamberEmpty(true);
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
				PB_SetChamberEmpty(false);
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
				PB_SetChamberEmpty(true);
			}
			HG0R MNOOPP 1;
			HG0R QQQ 1;
			HG0R QRS 1; 
			goto ReadyUnload;

//////////////////////////// WEAPON SPECIAL ////////////////////////////////////////////////////////////////////////////////////
		Weaponspecial:
        	TNT1 A 0 {
				A_Takeinventory("GoWeaponSpecialAbility",1);
                A_ZoomFactor(1.0);
			}
			TNT1 A 0 HMG_HandleSpecial();
			HG0U DDDDCC 1;
            TNT1 A 0 A_PlaySound("excavator/switch");		
			HG0U CCDDDD 1;
			goto Ready3;
		
//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
		FlashPunching:
			TNT1 A 0 A_Overlay(3,"Cooling",true);
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
			TNT1 A 8;
			TNT1 A 4 PB_ModifyOverheat(-5);
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