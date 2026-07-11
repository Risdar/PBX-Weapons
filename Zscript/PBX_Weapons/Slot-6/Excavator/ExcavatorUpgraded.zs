extend class PBX_Excavator
{
    bool isUpgraded;
    int burstCount; // used in the bola mode altfire

    States
    {
        CacheSprites:
            EX_A A 0; EX_B A 0; EX_C A 0; EX_D A 0; EX_E A 0; 
            EX_F A 0; EX_G A 0; EX_H A 0; EX_I A 0;

		WeaponRespect_UpgradedStart:
            8DKF DCBA 5 A_DoPBWeaponAction();
        WeaponRespect_Upgraded:
			TNT1 A 0 A_PlaySound("RLANDRAW");
			TNT1 A 5 A_DoPBWeaponAction();
		RespectBola:
			TNT1 A 0 A_JumpIf(getExcavatorMode() == eSawMode,"RespectSaw");
			EX_L QRSTUVW 1 {
				PB_SetRoll(roll-0.6);
				return A_DoPBWeaponAction();
			}
			EX_G NNN 1 A_DoPBWeaponAction();
			EX_I HHHHGFE 1 {
				PB_SetRoll(roll+0.6);
				return A_DoPBWeaponAction();
			}
			TNT1 A 0 A_PlaySound("RLCYCLE2", 13);
			EX_I DDDDDCBA 1 A_DoPBWeaponAction();
			EX_E NNN 1 A_DoPBWeaponAction ();
			TNT1 A 0 A_PlaySound("weapons/minigun/respect1", 13);
			EX_E OPQRST 1 {
				PB_SetRoll(roll-0.6);
				return A_DoPBWeaponAction();
			}
			EX_E UVWX 1 A_DoPBWeaponAction();
			EX_E YZ 1 {
				PB_SetRoll(roll+0.6);
				return A_DoPBWeaponAction();
			}
			EX_F ABCC 1 {
				PB_SetRoll(roll+0.6);
				return A_DoPBWeaponAction();
			}
			EX_F CCC 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySound("excavator_magslap", 13);
			EX_F EFGHIJ 1 {
				PB_SetRoll(roll+0.6);
				return A_DoPBWeaponAction();
			}
			EX_F JIHGFL 1 {
				PB_SetRoll(roll-0.6);
				return A_DoPBWeaponAction();
			}
			TNT1 A 0 A_PlaySound("weapons/nailgun/up", 10);
			EX_F MNO 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySound("excavator/detonate");
			EX_A EEEEE 1 A_DoPBWeaponAction();
			TNT1 A 0 A_Takeinventory("PB_LockScreenTilt",1);
			goto Ready2;
			
		RespectSaw:
			EX_K QRSTUVW 1 {
				PB_SetRoll(roll-0.6);
				return A_DoPBWeaponAction();
			}
			EX_E NNN 1 A_DoPBWeaponAction();
			EX_I ABCDDDD 1 {
				PB_SetRoll(roll+0.6);
				return A_DoPBWeaponAction();
			}
			TNT1 A 0 A_PlaySound("RLCYCLE2", 13);
			EX_I EFGHHHHH 1 A_DoPBWeaponAction();
			EX_G NNN 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySound("weapons/minigun/respect1", 13);
			EX_G OPQRST 1 {
				PB_SetRoll(roll-0.6);
				return A_DoPBWeaponAction();
			}
			EX_G UVWX 1 A_DoPBWeaponAction();
			EX_G YZ 1 {
				PB_SetRoll(roll+0.6);
				return A_DoPBWeaponAction();
			}
			EX_H ABCC 1 {
				PB_SetRoll(roll+0.6);
				return A_DoPBWeaponAction();
			}
			EX_H CCC 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySound("excavator_magslap", 13);
			EX_H EFGHIJ 1 {
				PB_SetRoll(roll+0.6);
				return A_DoPBWeaponAction();
			}
			EX_H JIHGFL 1 {
				PB_SetRoll(roll-0.6);
				return A_DoPBWeaponAction();
			}
			TNT1 A 0 A_PlaySound("weapons/nailgun/up", 10);
			EX_H MNO 1 A_DoPBWeaponAction();
			TNT1 A 0 A_PlaySound("excavator/detonate");
			EX_C EEEEE 1 A_DoPBWeaponAction();
			TNT1 A 0 A_Takeinventory("PB_LockScreenTilt",1);
			goto Ready2;
			
        Deselect_Upgraded:
            EX_A EDCBA 1 checkUnloadedSprites("EX_B","EX_D","EX_A","EX_C");
			goto ActualDeselect;

        Select_Upgraded:
			TNT1 A 0 PB_WeaponRaise("RLANDRAW");
			TNT1 A 0 PB_RespectIfNeeded();
        SelectAnimation_Upgraded:
            EX_A ABCDE 1 checkUnloadedSprites("EX_B","EX_D","EX_A","EX_C");
        // Fall through to Ready2
        Ready2:
            EX_A E 1 {
				checkUnloadedSprites("EX_B","EX_D","EX_A","EX_C");
                PB_CoolDownBarrel();
                EX_HandleCrosshair();
                return A_DoPBWeaponAction();
            }
            Loop;

        Fire_Upgraded:
			TNT1 A 0 PB_JumpIfNoAmmo("Reload_Upgraded",1,false);
			EX_A JK 1 BRIGHT changeModeSprite("EX_A","EX_C");
			TNT1 A 0 FireWeapon();
            EX_A L 1 BRIGHT {
				changeModeSprite("EX_A","EX_C");
				A_ZoomFactor(0.97);
			}
			EX_A M 1 BRIGHT {
				changeModeSprite("EX_A","EX_C");
				A_ZoomFactor(0.98);
			}
			EX_A N 1 {
				changeModeSprite("EX_A","EX_C");
				A_ZoomFactor(0.99);
			}
			EX_A OPQR 1 {
				A_ZoomFactor(1.0);
				changeModeSprite("EX_A","EX_C");
				return A_DoPBWeaponAction(WRF_NOPRIMARY);
			}
			TNT1 A 0 A_PlaySound("RLCYCLE2", 5);
			EX_A EEEEEEEEEE 1 {
				changeModeSprite("EX_A","EX_C");
				return A_DoPBWeaponAction(WRF_NOPRIMARY|WRF_NOSECONDARY);
			}
			goto Ready2;

        Altfire:
            TNT1 A 0 checkAltfire();
            TNT1 A 0 A_JumpIf(getExcavatorMode() == eSawMode, "AltFire_UpgradedSaw");
            TNT1 A 0 {invoker.burstcount = 0;}
        AltFire_UpgradedBola:
			TNT1 A 0 PB_JumpIfNoAmmo("Reload_Upgraded",1,false);
			EX_A JK 1 BRIGHT ;
			TNT1 A 0 {
                FireWeapon(true);
                invoker.burstcount++;
            }
			EX_A L 1 BRIGHT A_ZoomFactor(0.97);
			EX_A M 1 BRIGHT A_ZoomFactor(0.98);
            TNT1 A 0 A_JumpIf(invoker.burstcount < 4, "AltFire_UpgradedBola");
		FinishBurst:
			EX_A N 1 A_ZoomFactor(0.99);
			TNT1 A 0 A_ZoomFactor(1.0);
			EX_A OPQR 1 A_WeaponReady(WRF_NOPRIMARY);
			TNT1 A 0 A_PlaySound("RLCYCLE2", 5);
			EX_A EEEEEEEEEE 1 A_WeaponReady(WRF_NOPRIMARY|WRF_NOSECONDARY);
			goto Ready2;

        AltFire_UpgradedSaw:
			TNT1 A 0 PB_JumpIfNoAmmo("Reload_Upgraded",1,false);
			TNT1 A 0 A_PlaySound ("excavator_sawcharge");
			EX_C STU 3;
			TNT1 A 0 A_Startsound("excavator_sawcharge_loop",2,CHANF_LOOP);
		SawBladeCharged:
			EX_C U 1;
			TNT1 A 0 A_Jumpif(PressingAltFire(),"SawBladeCharged");
		FireSawBladeCharged:
			TNT1 A 0 A_Stopsound(2);
			EX_C K 1 BRIGHT;
            TNT1 A 0 FireWeapon(true);
			EX_C L 1 BRIGHT A_ZoomFactor(0.97);
			EX_C M 1 A_ZoomFactor(0.98);
			EX_C N 1 A_ZoomFactor(0.99);
			TNT1 A 0 A_ZoomFactor(1.0);
			EX_C OPQR 1 A_WeaponReady(WRF_NOPRIMARY);
			TNT1 A 0 A_PlaySound("RLCYCLE2", 5);
			EX_C EEEEEEEEEE 1 A_WeaponReady(WRF_NOPRIMARY);
			Goto Ready2;

        RaiseFromEmpty_Upgraded:
            EX_K CBA 1 changeModeSprite("EX_K","EX_L");
            goto ContinueReload_Upgraded;

        Reload_Upgraded:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
				A_SetInventory("PB_LockScreenTilt",0);
			}
            TNT1 A 0 PB_CheckReload(
				"RaiseFromEmpty_Upgraded", 
				null, 
				null, 
				"Ready2", 
				"Ready2", 
				MAGAZINE_SIZE, 
				invoker.ReserveToMagAmmoFactor
			);
			TNT1 A 0 A_PlaySound("Ironsights", 15);
			EX_E ABCD 1 {
                changeModeSprite("EX_E","EX_G");
                PB_SetRoll(roll-0.6);
            }
			EX_E EEE 1 changeModeSprite("EX_E","EX_G");
			EX_E FGHI 1 {
                changeModeSprite("EX_E","EX_G");
                PB_SetRoll(roll+1.2);
            }
			TNT1 A 0 A_PlaySound("weapons/sgl/cycle", 14);
			EX_E JKL 1 {
                changeModeSprite("EX_E","EX_G");
                PB_SetRoll(roll-0.6);
            }
			EX_E M 1 {
                changeModeSprite("EX_E","EX_G");
                PB_SpawnCasing("SGL_Drum",25,0,20,Frandom(3,4),Frandom(3,4),1);
				PB_SetMagUnloaded(true);
                PB_SetChamberEmpty(true);
                PB_SetMagEmpty(true);
			}
        ContinueReload_Upgraded:
			EX_E NNNNN 1 changeModeSprite("EX_E","EX_G");
			TNT1 A 0 A_PlaySound("weapons/minigun/respect1", 13);
			EX_E OPQRST 1 {
                changeModeSprite("EX_E","EX_G");
                PB_SetRoll(roll-0.6);
            }
			EX_E UVW 1 changeModeSprite("EX_E","EX_G");
            EX_E X 1 {
                changeModeSprite("EX_E","EX_G");
                PB_AmmoIntoMag(invoker.ammo2.getclassname(), invoker.ammo1.getclassname(), MAGAZINE_SIZE, invoker.ReserveToMagAmmoFactor);
                PB_SetMagUnloaded(false);
                PB_SetChamberEmpty(false);
                PB_SetMagEmpty(false);
            }
			EX_E YZ 1 {
                changeModeSprite("EX_E","EX_G");
                PB_SetRoll(roll+0.6);
            }
			EX_F ABCC 1 {
                changeModeSprite("EX_F","EX_H");
                PB_SetRoll(roll+0.6);
            }
			EX_F CCC 1 changeModeSprite("EX_F","EX_H");
			TNT1 A 0 A_PlaySound("excavator_magslap", 13);
			EX_F EFG 1 {
                changeModeSprite("EX_F","EX_H");
                PB_SetRoll(roll+0.6);
            }
        FinishReload_Upgraded:
            EX_F HIJ 1 {
                changeModeSprite("EX_F","EX_H");
                PB_SetRoll(roll+0.6);
            }
			EX_F JIHGFL 1 {
                changeModeSprite("EX_F","EX_H");
                PB_SetRoll(roll-0.6);
            }
			TNT1 A 0 A_PlaySound("weapons/nailgun/up", 10);
			EX_F MNO 1 changeModeSprite("EX_F","EX_H");
			TNT1 A 0 A_PlaySound("excavator/detonate");
			EX_A EEEEE 1 changeModeSprite("EX_A","EX_C");
            TNT1 A 0 PB_SetReloading(false);
			Goto Ready2;

        Unload_Upgraded:
			TNT1 A 0 handleModeChange();
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(),"Ready2");
			TNT1 A 0 A_PlaySound("Ironsights", 15);
            EX_E ABCD 1 {
                changeModeSprite("EX_E","EX_G");
                PB_SetRoll(roll-0.6);
            }
			EX_E EEE 1 changeModeSprite("EX_E","EX_G");
			EX_E FGHI 1 {
                changeModeSprite("EX_E","EX_G");
                PB_SetRoll(roll+1.2);
            }
			TNT1 A 0 A_PlaySound("weapons/sgl/cycle", 14);
			EX_E JKLM 1 {
                changeModeSprite("EX_E","EX_G");
                PB_SetRoll(roll-0.6);
            }
            TNT1 A 0 {
				PB_UnloadMag(
					invoker.ammo2.getclassname(),
					invoker.ammo1.getclassname(), 
					invoker.ReserveToMagAmmoFactor, 
					1, 0, 0);
				PB_SetMagUnloaded(true);
				PB_SetMagEmpty(true);
                PB_SetChamberEmpty(true);
			}
            EX_E NNN 1 {
                changeModeSprite("EX_E","EX_G");
                return handleModeChange();
            }
            EX_E NN 1 changeModeSprite("EX_E","EX_G");
			EX_K ABC 1 changeModeSprite("EX_K","EX_L");
			goto Ready2;

        SwitchToSaw:
            EX_I ABCDDDDD 1 ;
			TNT1 A 0 {
				A_PlaySound("RLCYCLE2", 13);
				actualModeChange();
			}
			EX_I EFGHHHHH 1;
			goto ContinueReload_Upgraded;

        SwitchToBola:
            EX_I HHHHHGFE 1 ;
			TNT1 A 0 {
				A_PlaySound("RLCYCLE2", 13);
				actualModeChange();
			}
			EX_I DDDDDCBA 1;
			goto ContinueReload_Upgraded;

        FlashPunching_Upgraded:
            EX_A FGHI 1 checkUnloadedSprites("EX_B","EX_D","EX_A","EX_C");
			EX_A I 6 checkUnloadedSprites("EX_B","EX_D","EX_A","EX_C");
			EX_A IHGF 1 checkUnloadedSprites("EX_B","EX_D","EX_A","EX_C");
            goto Ready2;

        FlashKicking_Upgraded:
            EX_A FGHI 1 checkUnloadedSprites("EX_B","EX_D","EX_A","EX_C");
			EX_A I 6 checkUnloadedSprites("EX_B","EX_D","EX_A","EX_C");
			EX_A IHGF 1 checkUnloadedSprites("EX_B","EX_D","EX_A","EX_C");
            goto Ready2;

        FlashAirKicking_Upgraded:
            EX_A FGHI 1 checkUnloadedSprites("EX_B","EX_D","EX_A","EX_C");
			EX_A I 8 checkUnloadedSprites("EX_B","EX_D","EX_A","EX_C");
			EX_A IHGF 1 checkUnloadedSprites("EX_B","EX_D","EX_A","EX_C");
            goto Ready2;

        FlashSlideKicking_Upgraded:
            EX_A FGHI 1 checkUnloadedSprites("EX_B","EX_D","EX_A","EX_C");
			EX_A I 21 checkUnloadedSprites("EX_B","EX_D","EX_A","EX_C");
            goto Ready2;

        FlashSlideKickingStop_Upgraded:
            EX_A IIIIHGF 1 checkUnloadedSprites("EX_B","EX_D","EX_A","EX_C");
            goto Ready2;

    }
}