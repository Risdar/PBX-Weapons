// Includes
#include "./NeoHMG_Functions.zs"
#include "./NeoHMG_Wheel.zs"
#include "./NeoHMG_helpers.zs"

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
		PB_WeaponBase.MaxOverheat MAX_OVERHEAT;
		PB_WeaponBase.OverheatCoolingRate OVERHEATCOOLING_RATE;
		PB_WeaponBase.ReserveToMagAmmoFactor 1;

//////////////////////////// AMMO ////////////////////////////////////////////////////////////////////////////////////
		Weapon.AmmoType1 "PB_HighCalMag";
	    Weapon.AmmoType2 "HMGChamberAmmo";
	    Weapon.AmmoGive1 80;
		
//////////////////////////// SPRITES & OFFSETS ////////////////////////////////////////////////////////////////////////////////////
        PB_WeaponBase.OffsetRecoilX 2.5;
		PB_WeaponBase.OffsetRecoilY 2.0;
		PB_WeaponBase.TailPitch 0.8;

//////////////////////////// MESSAGES & SOUNDS ////////////////////////////////////////////////////////////////////////////////////
        // Obituary "Shattered Into Pieces By Excavator Launcher. Ouch!";
        Inventory.PickupMessage "$PBX_NeoHMG_Pickup";
        Inventory.PickupSound "LMGPKP";
	    Tag "$PBX_NeoHMG_Tag";
        
//////////////////////////// WEAPON FLAGS ////////////////////////////////////////////////////////////////////////////////////
        +FORCEXYBILLBOARD
	}
	
//////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////////////////////
	// Constants
	const MAGAZINE_SIZE 		= 80;
	const SHIELD_MAXCHARGE 		= 100;
	const HMG_SHIELDLAYER 		= -567;
	const HMG_SHIELDSOUNDLAYER 	= 234;
	const HMG_SHIELDSOUNDLAYER2 = 233;
	const MAX_OVERHEAT	 		= 350;
	const OVERHEAT_THRESHOLD	= 80;	// Overheat threshold for firing the special rounds
	const OVERHEATCOOLING_RATE 	= 4;
	const OVERHEATCOOLING_LAYER = 3;
	const OVERHEAT_GIVE_OVR 	= 12;	// How much heat given when over Threshold
	const OVERHEAT_GIVE_NORM	= 10;	// How much heat given when normal fire

	// Shield Variables
	bool shieldEnabled;
	bool shieldactive;
	bool shieldReady;
	bool shieldWasActive;
	bool shieldBroken;
	int shieldTimer;
	int rechargeTimer;
	int shieldFrame;
	int shieldDrain;

	// Shield Values
	const shieldProtectionMultiplier = 2; // How many shield charges are consumed per point of damage (Multiplier)
	const shieldRechargeSpeed = 5; // How many tics before giving the shield charge
	const shieldRechargeRate = 5; // How many shield charges to give each tic
	const shieldCooldown = 15; // How many tics before shield is available again

	// Modes
	int ammoType;
	bool isOverheating;
	enum NeoHMGRounds
	{
		eHeatedRounds = 0,
        eChargedRounds = 1
	}

//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
	States
	{
//////////////////////////// SETUP ////////////////////////////////////////////////////////////////////////////////////
		Spawn:
            HG0W A -1;
            Stop;
        Deselect:
            HG0D ABCD 1;
			TNT1 A 0 A_lower(120);	
			wait;

		WeaponRespect:
			HG0U ABCD 1 A_DoPBWeaponAction();
			goto ready3;

		Select:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
				PB_HandleCrosshair(52);
				A_SetInventory("PB_LockScreenTilt",0);
                PB_WeaponRaise("HMGUP");
				cooldownOverheat();
			    return PB_RespectIfNeeded();
			}
		SelectAnimation:
			TNT1 A 0 {if(PB_GetOverheat() > 1) {cooldownOverheat();}}
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(), "UnloadedSelect");
			HG0U ABCD 1;
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
		Ready3:
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(), "ReadyUnload");
			"####" A 0 {
				if(PB_GetOverheat() > 1) {cooldownOverheat();}
				if(PB_GetOverheat() == 0) {invoker.isOverheating = false;}
				PB_HandleCrosshair(52);
			}
		ReadyToFire:
			// Load Sprites
			XH01 A 0;
			XH02 A 0;
			XH03 A 0;
			XH04 A 0;
			// Actual Code
			HG0F A 1 {
				PB_HandleCrosshair(52);
				HMG_CoolDownBarrel();
				setMagSprite("XH04","XH03","XH02","XH01");
				if (PressingFire() && PressingAltfire() && CountInv(invoker.ammotype2) > 0)
					return resolvestate("Fire");
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD); 
			}
			loop;
		
		ReadyUnload:
			HG0R R 1 {
				HMG_CoolDownBarrel();
				PB_HandleCrosshair(52);
				if(PB_GetOverheat() == 0) {invoker.isOverheating = false;}
				if (PressingFire() && PressingAltfire() && CountInv(invoker.ammotype2) > 0)
					return resolvestate("Fire");
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD); 
			}
			loop;

		UnloadedSelect:
			HG0R MNOPQRS 1;
			goto ReadyUnload;

		Overheat:
			TNT1 A 0 A_StartSound("MG42HEAT", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
			TNT1 A 0 A_StartSound("weapons/chagan/stop", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
			TNT1 A 0 {
				invoker.isOverheating = false;
				HMG_CoolDownBarrel();
				cooldownOverheat();
			}
			HG0F A 45 {
				setMagSprite("XH04","XH03","XH02","XH01");
				return A_DoPBWeaponAction(WRF_NOFIRE|WRF_NOSWITCH);
			}
			Goto Ready3;
        
//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
		Fire:
			// Load Sprites
			XH01 BCDEF 0;
			XH02 BCDEF 0;
			XH03 BCDEF 0;
			XH04 EF 0;
			// Actual Code
			TNT1 A 0 A_JumpIf(PB_GetOverheat() >= MAX_OVERHEAT-5,"overheat");
			TNT1 A 0 PB_HandleCrosshair(52);
            TNT1 A 0 PB_jumpIfNoAmmo("Reload",1,false);
			TNT1 A 0 A_StartSound("weapons/chagan/start", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
			HG0F A 3 A_ZoomFactor(0.98);
			HG0F A 2 A_ZoomFactor(0.97);
			HG0F A 2 A_ZoomFactor(0.96);
			HG0F A 2 A_ZoomFactor(0.95);
		Hold:
			TNT1 A 0 A_JumpIf(PB_GetOverheat() >= MAX_OVERHEAT-5,"overheat");
            TNT1 A 0 PB_jumpIfNoAmmo("Reload",1,false);
			HG0F B 1 bright {
				setMagSprite("HG0F","XH03","XH02","XH01");
				return fireHMG(1);
			}
			HG0F C 1 bright {
				setMagSprite("HG0F","XH03","XH02","XH01");
				return fireHMG(2);
			}
			HG0F D 2 setMagSprite("HG0F","XH03","XH02","XH01");
			HG0F E 1 setMagSprite("XH04","XH03","XH02","XH01");
			TNT1 A 0 A_Weaponoffset(0,32);
			HG0F F 1 {
				setMagSprite("XH04","XH03","XH02","XH01");
				return A_refire();
			}
			TNT1 A 0 A_StartSound("weapons/HMG/Stop", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
			TNT1 A 0 A_StartSound("weapons/chagan/stop", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
			HG0F A 1 A_ZoomFactor(0.95);
			HG0F A 2 A_ZoomFactor(0.96);
			HG0F A 2 A_ZoomFactor(0.97);
			HG0F A 2 A_ZoomFactor(0.98);
			goto Ready3;

		// AltFire:
		// 	TNT1 A 0;
		// 	goto Ready3;

		HMGShieldBash:
			PSHL E 0 A_FireProjectile("KickAttack");
		HMGShield:
			TNT1 A 0 
			{
				if(random(0,1) == 1)
					A_OverlayFlags(HMG_SHIELDLAYER,PSPF_FLIP,true);
				else
					A_OverlayFlags(HMG_SHIELDLAYER,PSPF_FLIP,false);
				A_OverlayFlags(HMG_SHIELDLAYER,PSPF_RENDERSTYLE|PSPF_FORCESTYLE,true);
				A_OverlayRenderStyle(HMG_SHIELDLAYER,STYLE_Add);
			}
			TNT1 A 0 A_JumpIf(invoker.ShieldFrame > 0,"HMGShield2");
			PSHL A 1 BRIGHT {invoker.ShieldFrame++;}
			stop;
		HMGShield2:
			TNT1 A 0 A_JumpIf(invoker.ShieldFrame > 1,"HMGShield3");
			PSHL B 1 BRIGHT {invoker.ShieldFrame++;}
			stop;
		HMGShield3:
			TNT1 A 0 A_JumpIf(invoker.ShieldFrame > 2,"HMGShield4");
			PSHL C 1 BRIGHT {invoker.ShieldFrame++;}
			stop;
		HMGShield4:
			TNT1 A 0 A_JumpIf(invoker.ShieldFrame > 3,"HMGShield5");
			PSHL D 1 BRIGHT {invoker.ShieldFrame++;}
			stop;
		HMGShield5:
			TNT1 A 0 A_JumpIf(invoker.ShieldFrame > 4,"HMGShield6");
			PSHL E 1 BRIGHT {invoker.ShieldFrame++;}
			stop;
		HMGShield6:
			TNT1 A 0 A_JumpIf(invoker.ShieldFrame > 5,"HMGShield7");
			PSHL F 1 BRIGHT {invoker.ShieldFrame++;}
			stop;
		HMGShield7:
			TNT1 A 0 A_JumpIf(invoker.ShieldFrame > 6,"HMGShield8");
			PSHL G 1 BRIGHT {invoker.ShieldFrame++;}
			stop;
		HMGShield8:
			PSHL H 1 BRIGHT {invoker.ShieldFrame = 0;}
			stop;
		HMGShieldBreak:
			PSHL A 0 A_FireShieldParticles();
			stop;
		HMGShieldBroken:
			TNT1 A 0 {
				A_StartSound("PLSULT", CHAN_WEAPON, CHANF_OVERLAP);
				A_SetBlend("Blue", 0.6, 12);	
				A_FireProjectile("PB_StunGrenadeExplosion", 0, 0, 0, 0);
			}
			PSHL A 0 A_FireShieldParticles();
			stop;
		
//////////////////////////// RELOAD ////////////////////////////////////////////////////////////////////////////////////
		Reload:
			// Load Sprites
			XH1R ABC 0;
			XH2R ABC 0;
			XH3R ABC 0;
			XH4R ABC 0;
			XHR1 ABCDEFGHI 0;
			XHR1 VWXYZ 0;
			XHR2 ABCDEFGHI 0;
			XHR2 VWXYZ 0;
			XHR3 ABCDEFGHI 0;
			XHR3 VWXYZ 0;
			XHR4 ABCDE 0;
			XHR4 VWXYZ 0;
			// Actual Code
            TNT1 A 0 {
				A_ZoomFactor(1.0);
				A_WeaponOffset(0,32);
			}
			TNT1 A 0 PB_checkReload("RaiseFromEmpty", null, null, "Ready","Ready",MAGAZINE_SIZE,1);
			HG0R ABCDE 1 setMagSprite("XHR4","XHR3","XHR2","XHR1");
			HG0R FGH 1 setMagSprite("HG0R","XHR3","XHR2","XHR1");
			TNT1 A 0 A_StartSound("weapons/sgl/detach", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(),"Reload_Unloaded");
			TNT1 A 0 {
				if(invoker.ammo2.amount < 1 && !PB_GetMagUnloaded())
					PB_SpawnCasing("EmptyLMGMag", 12, -2.5, 6.25,frandom(2,5),frandom(1,3),frandom(2,4));
					//A_Spawnitem("EmptyLMGMag");EmptyLMGMissileMag
			}
			HG0R I 1 setMagSprite("HG0R","XHR3","XHR2","XHR1");
			HG0R JK 1;
			HG0R L 1 {
				PB_SetMagUnloaded(true);
				PB_SetChamberEmpty(true);
			}
			HG0R MNOOPP 1;
			HG0R QQQ 1;
			HG0R QRST 1;
		Reload_Unloaded:	
			TNT1 A 0 A_StartSound("weapon/HMG/Reload1", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
			HG0R U 1;
			HG0R V 1 setMagSprite("XHR4","XHR3","XHR2","XHR1");
			TNT1 A 0 {
				invoker.isOverheating = false;
				PB_SetOverheat(0);
			}
			TNT1 A 0 {
				PB_AmmoIntoMag(invoker.ammo2.getclassname(),invoker.ammo1.getclassname(),MAGAZINE_SIZE,1);
				PB_SetMagEmpty(false);
				PB_SetMagUnloaded(false);
				PB_SetChamberEmpty(false);
			}
			HG0R W 1 setMagSprite("XHR4","XHR3","XHR2","XHR1");
			HG0R XX 1 setMagSprite("XHR4","XHR3","XHR2","XHR1");
			HG0R YYZ 1 setMagSprite("XHR4","XHR3","XHR2","XHR1");
			HG1R ABC 1 setMagSprite("XHR4","XHR3","XHR2","XHR1");
			goto Ready3;

        RaiseFromEmpty:
            HG0R S 1;
            goto Reload_Unloaded;

//////////////////////////// UNLOAD ////////////////////////////////////////////////////////////////////////////////////
		Unload:
			// Load Sprites
			XHR1 ABCDEFGHI 0;
			XHR2 ABCDEFGHI 0;
			XHR3 ABCDEFGHI 0;
			XHR4 ABCDE 0;
			// Actual Code
			TNT1 A 0 A_Jumpif(pb_getmagunloaded(),"ReadyUnload");
			HG0R ABCDE 1 setMagSprite("XHR4","XHR3","XHR2","XHR1");
			HG0R FGH 1 setMagSprite("HG0R","XHR3","XHR2","XHR1");
			TNT1 A 0 A_StartSound("weapons/sgl/detach", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
			HG0R I 1 setMagSprite("HG0R","XHR3","XHR2","XHR1");
			HG0R JK 1;
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
			TNT1 A 0 A_StartSound("excavator/switch", CHAN_WEAPON, CHANF_OVERLAP, 1.0);
			HG0U CCDDDD 1;
			goto Ready3;
		
//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
		FlashPunching:
			TNT1 A 0 cooldownOverheat();
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
			TNT1 A 1 {if(PB_GetOverheat() == 0) invoker.isOverheating = false;}
			TNT1 A 8;
			TNT1 A 4 {
				// console.printf("lowered overheat");
				PB_ModifyOverheat(-5);
			}
			Wait;

		MuzzleFlash:
			TNT1 A 0 A_jump(256,"Muzzle1","Muzzle3");
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

