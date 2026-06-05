// Includes
// #include "./MetalSniper_Functions.zs"
// #include "./MetalSniper_Wheel.zs"
// #include "./MetalSniper_helpers.zs"

// Constants
const NormalRifleFullAmmo = 31;

class NormalRifleAmmo : Ammo
{
    Default
    {
        Inventory.Amount 0;
        Inventory.MaxAmount NormalRifleFullAmmo;
        Ammo.BackpackAmount 0;
        Ammo.BackpackMaxAmount NormalRifleFullAmmo;
        Inventory.Icon "RIFLA0";
    }
}

Class PBX_NormalRifle : PB_WeaponBase
{
    Default
    {
        weapon.slotnumber 4;
        inventory.pickupsound "CLIPIN";
        inventory.pickupmessage "$PBX_NormalRifle_Pickup";
        Inventory.AltHudIcon "RIFXA0";
        weapon.ammotype1 "PB_HighCalMag";
        weapon.ammogive1 32;
        weapon.ammotype2 "NormalRifleAmmo";
        // PB_WeaponBase.UsesWheel true;
        // PB_WeaponBase.WheelInfo "MetalSniperWheel";
		PB_WeaponBase.ReserveToMagAmmoFactor 1;
        Tag "$PBX_NormalRifle_Tag";
        scale 0.8;
        +weapon.noalert;
        +weapon.noautofire;
    }

    bool doBurst;
    int burstcount;

    override void PostBeginPlay()
    {
        doBurst = false;
        burstcount = 0;
        Super.PostBeginPlay();
    }

    action bool getBurst()
    {
        return invoker.doBurst;
    }

    action void setBurst(bool set)
    {
        invoker.doBurst = set;
    }

    action void fireweapon(int tic)
    {
        bool ads     = PB_GetZoom();
        double zoomA = ads ? 1.9 : 0.98;
        double zoomB = ads ? 2.0 : 1.0;

        switch(tic)
        {
            case 1:
                A_StartSound("weapons/rifle", CHAN_Weapon, CHANF_DEFAULT, 1.0);
                A_AlertMonsters();
                PB_IncrementHeat();
			    PB_DynamicTail("lmg", "br");
				PB_LowAmmoSoundWarning();
				PB_GunSmoke(0,0,0); PB_MuzzleFlashEffects(0,0,0);
                A_FireCustomMissile("YellowFlareSpawn",0,0,0,0);
                PB_TakeAmmo(invoker.ammo2.getclassname());
                A_GunFlash();
                PB_WeaponRecoil(-0.5,0);
                PB_FireOffset();
                if(ads) {
                    PB_SpawnCasing("PB_EmptyBrass",28,0,30,3,Frandom(5,8),Frandom(3,4));
                    PB_FireBullets("PB_556x45mm",1, 0.1, 0, 0, 0.1);
                }
                else {
				    PB_SpawnCasing("PB_EmptyBrass",22,2,28,Frandom(-2, -1),Frandom(5,8),Frandom(3,4));
                    PB_FireBullets("PB_556x45mm",1, 1, 0, 0, 1);
                }
                A_ZoomFactor(zoomA);
                break;

            case 2:
                PB_WeaponRecoil(-1.0,0);
                A_ZoomFactor(zoomB);
                invoker.burstCount++;
                break;

            // Everything below here is not called by ADS
            case 3:
                PB_WeaponRecoil(+1.0,0);
                break;

            case 4:
                A_WeaponOffset(0,32);
                break;
        }
    }

    States
    {
        Spawn:
            RIFX A -1;
            Stop;

        WeaponRespect:
            RIR3 ABCDEFG 1 A_DoPBWeaponAction();
            RIFR HIJKLMNOPQR 1 A_DoPBWeaponAction();
            RIFL C 0 {
                A_PlaySoundEx("weapons/rifle/magin", "Auto");
                return A_DoPBWeaponAction();
            }
            RIFR STUVWXYZ 1 A_DoPBWeaponAction();
            RIFR "[]" 1 A_DoPBWeaponAction();
            RIR2 AB 1 A_DoPBWeaponAction();
            Goto Ready3;

        Deselect:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
				PB_HandleCrosshair(55);
                PB_SetZoom(false);
				A_TakeInventory("PB_LockScreenTilt",1);
                A_ZoomFactor(1.0);
			}
			RIFS ABCDE 1;
			TNT1 A 0 A_Lower();
			Wait;

        Select:
            TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
                PB_ClearDualWield();
			    PB_HandleCrosshair(55);
				A_SetInventory("PB_LockScreenTilt",0);
                PB_WeaponRaise("CLIPIN");
			    return PB_RespectIfNeeded();
			}
        SelectAnimation:
            RIFS EDCBA 1;
        Ready3:
            RIFL C 1 {
                PB_CooldownBarrel();
			    PB_HandleCrosshair(55);
                return A_DoPBWeaponAction();
            }
            loop;

        Ready2:
            RIFZ D 1 {
                A_SetCrosshair(-1);
                PB_CooldownBarrel();
                return PB_ReadyFire(ads:true);
            }
            loop;

        Fire:
			TNT1 A 0 A_JumpIf(PB_GetZoom(), "Fire2");
            TNT1 A 0 {
                PB_HandleCrosshair(55);
				A_WeaponOffset(0, 32);
				PB_SetRoll(0);
				A_SetInventory("PB_LockScreenTilt", 0);
				A_ZoomFactor(1.0);
            }
            RIFL J 0 A_Jump(128,3);
            RIFL I 0 A_Jump(128,2);
            RIFL A 0;
            RIFL "#" 0;
			TNT1 A 0 { invoker.burstCount = 0; }
        FireLoop:
            TNT1 A 0 PB_JumpIfNoAmmo();
            RIFL D 1 BRIGHT fireweapon(1);
            RIFL G 1        fireweapon(2);
            RIFL E 1        fireweapon(3);
			TNT1 A 0 A_JumpIf(invoker.burstCount < 3 && getBurst(), "FireLoop");
        FireEnd:
            RIFL F 1        fireweapon(4); 
            TNT1 A 0 {invoker.burstCount = 0;}
            TNT1 A 0 {
                if(!getBurst()) PB_Refire();
                // return ResolveState(null);
            }
            Goto Ready3;

        Fire2:
            TNT1 A 0 {
                A_WeaponOffset(0,32);
                A_SetCrosshair(-1);
				PB_SetRoll(0);
			}
			TNT1 A 0 { invoker.burstCount = 0; }
        Fire2Loop:
            TNT1 A 0 PB_JumpIfNoAmmo();
            RIFZ E 1 BRIGHT fireweapon(1);
            RIFZ F 1        fireweapon(2);
			TNT1 A 0 A_JumpIf(invoker.burstCount < 3 && getBurst(), "Fire2Loop");
        Fire2End:
            TNT1 A 0 {invoker.burstCount = 0;}
            RIFZ G 1;
            RIFZ H 1;
            RIFZ D 1 {
                if(!getBurst()) return PB_ReadyFire(ads:true);
                return ResolveState(null);
            }
            Goto Ready2;

        AltFire:
			TNT1 A 0 A_Jumpif(PB_GetZoom(),"ZoomOut");
        ZoomIn:
            TNT1 A 0 {
                PB_SetZoom(true);
                A_startsound("IronSights",29);
                A_SetCrosshair(-1);
            }
            RIFZ ABC 1;
            TNT1 A 0 A_ZoomFactor(2.0);
            RIFZ D 2;
            Goto Ready2;
            
        Zoomout:
            TNT1 A 0 {
                PB_SetZoom(false);
                A_startsound("IronSights",29);
			    PB_HandleCrosshair(55);
            }
            RIFZ BA 1 A_ZoomFactor(1.0);
            Goto Ready3;

        Weaponspecial:
			TNT1 A 0 A_Takeinventory("GoWeaponSpecialAbility",1);
			TNT1 A 0 {
				if(invoker.doBurst) invoker.doBurst = false;
				else invoker.doBurst = true;
            	A_StartSound("MS/Button", CHAN_AUTO, CHANF_OVERLAP);
				A_Print(invoker.doBurst ? "$PBX_NormalRifle_Burst" : "$PBX_NormalRifle_Auto");
			}
			TNT1 A 0 A_JumpIf(PB_GetZoom(),"Ready2");
			goto Ready3;

         RaiseFromEmpty:
            TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
            RIFR ABCDEFG 1;
            goto ContinueReload;

        Reload:
            TNT1 A 0 {
                A_Zoomfactor(1.0);
                PB_SetZoom(false);
            }
            TNT1 A 0 PB_CheckReload("RaiseFromEmpty", null, "ChamberFromReload", "Ready3", "Ready3", NormalRifleFullAmmo);
            TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
            // Raise
            RIR2 BA 1;
            RIFR "][" 1;
		    RIFR ZYXWVVV 1;
            // Remove Mag
		    RIFR UTSRQ 1;
            TNT1 A 0 {
                A_PlaySoundEx("weapons/rifle/magout", "Auto");
                if(PB_GetMagEmpty()) PB_SpawnCasing("EmptyDMRMag",38,26,7,frandom(0, 3.5),frandom(-7.2, -3.3),frandom(3,7));
                PB_SetMagUnloaded(true);
            }
            // Put Away Mag
            RIFR PONMLKJIHG 1;
        ContinueReload:
            // Insert Mag
            TNT1 A 0 A_PlaySoundEx("weapons/rifle/magchange", "Auto");
            RIFR HIJKLMNN 1;
            RIFR OP 1;
            RIFR Q 3;
            RIFR R 1;
            TNT1 A 0 A_PlaySoundEx("weapons/rifle/magin", "Auto");
            RIFR S 1 {
				PB_AmmoIntoMag(invoker.ammo2.getclassname(), invoker.ammo1.getclassname(), NormalRifleFullAmmo);
                PB_SetMagEmpty(false);
                PB_SetMagUnloaded(false);
            }
            RIFR STU 1;
            TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(), "Rechamber");
            RIFR V 4;
            RIFR WXYZ 1;
        FinishReload:
            RIFR "[]" 1;
            RIR2 AB 1;
            goto Ready3;

        ChamberFromReload:
            RIFL HIJKLMNOP 1;
            TNT1 A 0 {
                PB_SetChamberEmpty(false);
                A_PlaySoundEx("RIFCL_CK", "Auto");
            }
            RIFL PONMLKJIH 1;
            goto Ready3;

        Rechamber:
            TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
            RIFR W 1;
            RIR2 CDEFGHII 1;
            RIR2 J 3;
            TNT1 A 0 A_PlaySoundEx("RIFCL_CK", "Auto");
            RIR2 LM 1;
            TNT1 A 0 PB_SetChamberEmpty(false);
            RIR2 N 4;
            RIR2 OPQ 1;
            RIR2 R 3;
            RIR2 SSTUV 1;
            goto FinishReload;

       Unload:
            TNT1 A 0 {
				A_WeaponOffset(0, 32);
                A_ZoomFactor(1.0);
                PB_SetZoom(false);
                PB_SetRoll(0);
				PB_HandleCrosshair(55);
            }
			// TNT1 A 0 A_Jumpif(pb_getmagunloaded() || invoker.ammo2.amount < 1,"Ready3");
            TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
            TNT1 A 0 A_JumpIf(PB_GetMagUnloaded() && !PB_GetChamberEmpty(), "UnloadChamber");
            // Raise
            RIR2 BA 1;
            RIFR "][" 1;
		    RIFR ZYXWVVV 1;
		    RIFR UTSRQ 1;
            TNT1 A 0 A_PlaySoundEx("weapons/rifle/magout", "Auto");
            // Remove Mag
            RIFR PONMLKJIHG 1;
            TNT1 A 0 {
                A_PlaySoundEx("weapons/rifle/magchange", "Auto");
                if(PB_GetMagEmpty()) PB_SpawnCasing("EmptyDMRMag",38,26,7,frandom(0, 3.5),frandom(-7.2, -3.3),frandom(3,7));
                PB_UnloadMag(invoker.ammotype2,invoker.ammotype1,1,1,0,1);
                PB_SetMagUnloaded(true);
                PB_SetMagEmpty(true);
            }
            // Lower
            RIFR GFEDCBA 1;
            RIR2 B 1;
        UnloadChamber:
            TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
            RIFL HIJKLMNOP 1;
            TNT1 A 0 {
                PB_SetChamberEmpty(true);
                PB_UnloadMag(invoker.ammotype2,invoker.ammotype1,1,1,0,0,"PB_HighCalRound");
            }
            RIFL PONMLKJIH 1;
            goto Ready3;

        FlashPunching:
	        RIFL RSTUVVVVVVVVUTSR 1;
            goto Ready3;

		FlashKicking:
	        RIFL RSTUVVVVVVVVUTSR 1;
			goto Ready3;
			
		FlashAirKicking:
	        RIFL RSTUVVVVVVVVUTSR 1;
			goto Ready3;
			
		FlashSlideKicking:
	        RIFL RSTUVVVVVVVVVVVVVVVVVVVUTSR 1;
			goto Ready3;
			
		FlashSlideKickingStop:
	        RIFL VVVUTSR 1;
			goto Ready3;

    }
}