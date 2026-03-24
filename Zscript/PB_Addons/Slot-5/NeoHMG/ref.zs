Class PB_NeoHMG : PB_WeaponBase
{
	default
	{
		weapon.slotnumber 5;
		Tag "HMG";
		inventory.pickupsound "LMGPKP";
		inventory.pickupmessage "HMG (Slot 5)";
		
		weapon.ammotype1 "PB_HighCalMag";
		Weapon.AmmoGive1 30;
		weapon.ammotype2 "HMGChamberAmmo";
		
		//PB_WeaponBase.unloadertoken "HMGIsUnloaded";
		PB_WeaponBase.respectItem "HMGJustRespect"; 
		Inventory.AltHUDIcon "HG0WA0"; 
		PB_WeaponBase.OffsetRecoilX 2.5;
		PB_WeaponBase.OffsetRecoilY 2.0;
		PB_WeaponBase.TailPitch 0.8;
	}
	
	states
	{
		Spawn:
			HG0W A -1;
			stop;
			
		Select:
			TNT1 A 0 PB_WeaponRaise("weapon/HMG/Stop");
			TNT1 A 0 PB_WeapTokenSwitch("CarbineSelected");
			TNT1 A 0 PB_RespectIfNeeded();
		SelectContinue:
			TNT1 A 0;
		SelectAnimation:
			HG0U ABCD 1;
			goto ready;
		
		WeaponRespect:
			TNT1 A 0 A_setInventory(invoker.respectInventoryItem,1);
			HG0U ABCD 1;
			goto ready;
			
		Deselect:
			//TNT1 A 0 PB_jumpIfHasBarrel("PlaceBarrel","PlaceFlameBarrel","PlaceIceBarrel");
			HG0D ABCD 1;
			TNT1 A 0 A_lower(120);	
			wait;
			

		Ready:
		Ready3:
			HG0F A 1 {
				PB_CoolDownBarrel(0, 0, 3);
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD); 
			}
			loop;
			
		NoAmmo:
			HG0F A 1 {
				PB_CoolDownBarrel(0, 0, 3);
				return A_DoPBWeaponAction(); 
			}
			goto ready;
		
		Fire:
			//TNT1 A 0 PB_jumpIfHasBarrel("ThrowBarrel","ThrowFlameBarrel","ThrowIceBarrel");
			TNT1 A 0 PB_jumpIfNoAmmo("Reload",1);
			HG0F B 1 bright fireHMG();
			HG0F C 1 bright;
			TNT1 A 0 A_Zoomfactor(1.0);
			HG0F D 1;
			HG0F E 1;
			TNT1 A 0 A_Weaponoffset(0,32);
			HG0F F 1 A_refire();
			TNT1 A 0 A_startsound("weapon/HMG/Stop",32);
			goto ready;
		
		AltFire:
			//TNT1 A 0 PB_jumpIfHasBarrel("PlaceBarrel","PlaceFlameBarrel","PlaceIceBarrel");
			goto ready;
		
		Weaponspecial:
			TNT1 A 0 A_takeinventory("GoWeaponSpecialAbility",1); 
			goto ready3;
		
		//i fkucing hate this thing, so i didnt even made an animation for it
		Unload:
			TNT1 A 0 A_Takeinventory("Unloading",1);
			HG0R ABCD 1;
			HG0R EFGH 1;
			TNT1 A 0 A_StartSound("weapons/sgl/detach", 33);
			//TNT1 A 0 PB_SpawnCasing("EmptyLMGMag", 12, -2.5, 6.25,frandom(2,5),frandom(1,3),frandom(2,4));//A_Spawnitem("EmptyLMGMag");EmptyLMGMissileMag
			HG0R IJKL 1;
			HG0R MNOOPP 1;
			HG0R QQQ 1;
			HG0R QRST 1;
			TNT1 A 0 A_Startsound("weapon/HMG/Reload1",34);
			TNT1 A 0 PB_UnloadMag(invoker.ammo2.getclassname(),invoker.ammo1.getclassname(),1);
			TNT1 A 0 A_giveinventory("HMGIsUnloaded",1);
			HG0R UVWXX 1;
			HG0R YYZ 1;
			HG1R ABC 1;
			goto ready3;
			

		Reload:
			TNT1 A 0 {
				A_ZoomFactor(1.0);
				A_WeaponOffset(0,32);
			}
			//TNT1 A 0 PB_jumpIfHasBarrel("IdleBarrel","IdleFlameBarrel","IdleIceBarrel");
			TNT1 A 0 PB_checkReload("Reload_Unloaded", null, null, "Ready","NoAmmo",80,1);
			HG0R ABCD 1;
			HG0R EFGH 1;
			TNT1 A 0 A_StartSound("weapons/sgl/detach",33);
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(),"Reload_Unloaded");
			TNT1 A 0 {
				if(invoker.ammo2.amount < 1 && !findinventory("HMGIsUnloaded"))
					PB_SpawnCasing("EmptyLMGMag", 12, -2.5, 6.25,frandom(2,5),frandom(1,3),frandom(2,4));//A_Spawnitem("EmptyLMGMag");EmptyLMGMissileMag
			}
			TNT1 A 0 A_takeinventory("HMGIsUnloaded",1);
		Reload_Unloaded:	
			HG0R IJKL 1;
			HG0R MNOOPP 1;
			HG0R QQQ 1;
			HG0R QRST 1;
			TNT1 A 0 A_Startsound("weapon/HMG/Reload1",34);
			TNT1 A 0 PB_AmmoIntoMag(invoker.ammo2.getclassname(),invoker.ammo1.getclassname(),80,1);
			HG0R UVWXX 1;
			HG0R YYZ 1;
			HG1R ABC 1;
			goto ready3;
		
		
		FlashPunching:
			HG0K ABCDEFGHFEDCBA 1;
			stop;
		
		FlashKicking:
			HG0K ABCDEFGHHFEDCBA 1;
			goto ready3;
			
		FlashAirKicking:
			HG0K ABCDEFGHHHFEDCBA 1;
			goto ready3;
			
		FlashSlideKicking:
			HG0K ABCDEFGHHHHHHHHHHHHHGFEDCBA 1;
			goto ready3;
			
		FlashSlideKickingStop:
			HG0K GFEDCBA 1;
			goto ready3;
		
		
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
	
	action void fireHMG()
	{
		PB_FireBullets("PB_792x57mm", 1, 3, 0, 0, 2.5);
		A_Startsound("weapon/HMG/Fire",30);
		PB_DynamicTail("lmg", "lmg");
		A_overlay(-7,"MuzzleFlash");
		PB_WeaponRecoil(-1.1,frandom(-0.82,0.82));
		PB_IncrementHeat(2);
		PB_GunSmoke(0, 0, 0);
		PB_LowAmmoSoundWarning("hdmr");
		PB_FireOffset();
		A_QuakeEx(0,1,0,12,0,10,"",QF_WAVE|QF_RELATIVE|QF_SCALEDOWN,0.6,0,0.2,0,0,0.3,0.40);
		A_Zoomfactor(0.985);
		if(invoker.ammo2.amount > 0)
			invoker.ammo2.amount--;
		
		//im too lazy to add the different animations for the 4 bullets in the mag box
		//so just imagine this is a futuristic gun that keeps the casings inside the mag
		//PB_SpawnCasing("LMGCasingStandard", 19,4,29,0,frandom(3,5),frandom(0,4), false);
	}
	
	//i think this should be added to pb itself
	override void attachtoowner(actor other)
	{
		if(other && other.player)
		{
			if(other.countinv(ammotype2) < 1 && (countinv(respectInventoryItem) < 1))
				other.A_giveinventory(ammotype2,80);
		}
		super.attachtoowner(other);
	}
	
	
}


Class HMGJustRespect : inventory
{
	default
	{
		inventory.maxamount 1;
	}
}



Class HMGIsUnloaded : inventory
{
	default
	{
		inventory.maxamount 1;
	}
}

Class HMGChamberAmmo : Ammo
{
	default
	{
		inventory.maxamount 80;
		ammo.backpackamount 0;
		ammo.backpackmaxamount 80;
	}
}
