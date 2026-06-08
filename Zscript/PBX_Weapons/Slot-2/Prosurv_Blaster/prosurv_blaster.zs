// Includes
// #include "./PlasmaBlaster_Functions.zs"
// #include "./PlasmaBlaster_Wheel.zs"
#include "./prosurvblaster_helpers.zs"

// Constants
const prosurvblasterMaxHeat = 100;

// Actual Weapon
class PBX_ProsurvBlaster : PB_WeaponBase
{
    Default
    {
        Weapon.BobRangeX 0.3;
        Weapon.BobRangeY 0.5;
        Weapon.BobStyle "InverseSmooth";
        Weapon.BobSpeed 2.4;
		Weapon.SlotNumber 2;
        Weapon.SlotPriority 0;
        Weapon.SelectionOrder 1300;
        Weapon.AmmoType1 "BlasterPistolHeatLevel";
        Inventory.MaxAmount 3;
        Inventory.Amount 1;
        +FLOORCLIP;
        +DONTGIB;
        Obituary "%k Zapped %o with a Blaster Pistol";
        AttackSound "None";
        Tag "$PBX_ProsurvBlaster_Tag";
        Inventory.Icon "BRPIA0";
        DamageType "Plasma";
        Inventory.PickupSound "weapons/pistolup";
        Inventory.Pickupmessage "$PBX_ProsurvBlaster_Pickup";
        +WEAPON.WIMPY_WEAPON;
        +WEAPON.NOAUTOAIM;
        +WEAPON.NOAUTOFIRE;
        +WEAPON.NOALERT;
        Scale 0.44;
        Inventory.AltHUDIcon "BRPIA0";
        FloatBobStrength 0.5;
    }

    enum overheatSet{
        SET,
        TAKE,
        GIVE
    }
    const MUZZLELAYER = -5;

    action void fireweapon(int tic)
    {
        bool ads = PB_GetZoom();
        double zoomA = ads ? 1.24 : 0.985;
        double zoomB = ads ? 1.245 : 0.99;
        double zoomC = ads ? 1.25 : 1.0;

        switch(tic)
        {
            case 1: case 2: case 3:
                if(tic == 1)
                {
                    PB_IncrementHeat();
                    A_GunFlash();
                    A_Overlay(MUZZLELAYER, "GunFlash", true);
                    A_AlertMonsters();
                    modifyBlasterOverheat(GIVE,5);
                    A_PlaySoundEx("weapons/blasterpistol/fire","Weapon");
                    PB_WeaponRecoil(-0.18,-0.08);
                    A_FireCustomMissile("BlueFlareSpawn", 0, 0, 0, 0, 0, 0);
		            PB_FireBullets("ProsurvBlasterProjectile", 1, 0, 0, 0, frandom(-0.1, 0.1));
                    // A_FireCustomMissile("ProsurvBlasterProjectile", 0,0,0,1,0,0); // THE BOOLET
                }
                A_ZoomFactor(tic == 1 ? zoomA : tic == 2 ? zoomB : zoomC);
                if(!ads)
                {
                    if (invoker.OwnerHasBerserk())  PB_WeaponRecoil(-0.18,+0.8);
                    else PB_WeaponRecoil(-0.9,+0.4);
                }
                break;
        }
    }

    // All in one function to modify the overheat
    // tbh I want the overheat to be an int 
    // but then the weapon wont have an ammo class lol
    action void modifyBlasterOverheat(int mode, int amount)
    {
        string ammo = invoker.ammo1.getClassName();
        switch(mode)
        {
            case SET:
                A_SetInventory(ammo,amount);
                // console.printf("Set");
                break;
            case TAKE:
                A_TakeInventory(ammo,amount);
                // console.printf("Take");
                break;
            case GIVE:
                A_Giveinventory(ammo,amount);
                // console.printf("Give");
                break;
        }
    }

    States
    {
        Spawn:
            BRPI A -1;
            Stop;

        WeaponRespect:
            TNT1 A 0 {
                A_Giveinventory("PB_LockScreenTilt",1);
                A_SetCrosshair(-1);
            }
            TNT1 A 10 A_DoPBWeaponAction();
            TNT1 A 0 A_PlaySoundEx("weapons/blasterpistol/ready", "Auto");
            BRGT EDCBAAAAA 1 A_DoPBWeaponAction();
            BRGC CDEF 1 {
                PB_SetRoll(roll+.2);
                A_DoPBWeaponAction();
            }
            TNT1 A 0 A_PlaySoundEx("weapons/blasterpistol/recharge","Weapon");
            BRGC GHIJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJK 1 A_DoPBWeaponAction();
            TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
            BRGC LM 1 A_DoPBWeaponAction();
            BRGC NOPQ 1 {
                PB_SetRoll(roll-.2);
                A_DoPBWeaponAction();
            }
            Goto Ready3;

        Deselect:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
				PB_HandleCrosshair(65);
				A_TakeInventory("PB_LockScreenTilt",1);
                A_ZoomFactor(1.0);
                PB_SetZoom(false);
			}
			BRGT BCDE 1;
			TNT1 A 0 A_Lower();
			Wait;

        Select:
            TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
			    PB_HandleCrosshair(65);
				A_SetInventory("PB_LockScreenTilt",0);
                modifyBlasterOverheat(SET,0);
                PB_WeaponRaise("weapons/blasterpistol/ready");
			    return PB_RespectIfNeeded();
			}
        SelectAnimation:
            BRGT EDCB 1;
        Ready3:
            BRGT A 4 {
			    PB_HandleCrosshair(65);
                PB_CoolDownBarrel();
                modifyBlasterOverheat(TAKE,1);
                if (PressingFire() && PressingAltfire() && invoker.ammo1.amount < prosurvblasterMaxHeat)
					return ResolveState("Fire");
                if (PressingFire() && invoker.ammo1.amount < prosurvblasterMaxHeat)
                    return ResolveState("Fire");
                return A_DoPBWeaponAction();
            }
            Loop;

        Ready2:
            BRGG F 1 {
                A_SetCrosshair(-1);
                PB_CoolDownBarrel();
                modifyBlasterOverheat(TAKE,1);
                if(PB_GetAimMode())
                {
                    if(!PressingAltfire() || JustReleased(BT_ALTATTACK))
                        return ResolveState("Zoomout");
                    if (PressingFire() && PressingAltfire())
                        return ResolveState("Fire2");
                    return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
                }
                else 
                {
                    if (PressingFire())
                        return ResolveState("Fire2");
                    return A_DoPBWeaponAction(WRF_ALLOWRELOAD);
                }
                return ResolveState(null);
            }
            Loop;

        Fire:
            TNT1 A 0 {
			    PB_HandleCrosshair(65);
                A_WeaponOffset(0,32);
                PB_SetRoll(0);
                A_TakeInventory("PB_LockScreenTilt",1);			
            }
			TNT1 A 0 A_JumpIf(PB_GetZoom(), "Fire2");
			TNT1 A 0 A_JumpIf(invoker.ammo1.amount == prosurvblasterMaxHeat, "Reload");
            BRGF A 1 BRIGHT fireweapon(1);
            BRGF B 1 fireweapon(2);
            BRGF C 1 fireweapon(3);
            BRGF DC 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOPRIMARY);
            BRGT AAAAAAA 1 {
                if (JustPressed(BT_ATTACK)) 
                    return ResolveState("Fire");
                return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOPRIMARY);
            }
            Goto Ready3;

        Fire2:
            TNT1 A 0 {
                A_WeaponOffset(0,32);
                A_SetCrosshair(-1);
            }
			TNT1 A 0 A_JumpIf(invoker.ammo1.amount == prosurvblasterMaxHeat, "Reload");
            BRGG G 1 BRIGHT fireweapon(1);
            BRGG H 1 fireweapon(2);
            BRGG I 1 fireweapon(3);
            BRGG J 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
            BRGG KLFFFFFF 1 {
                if(PB_GetAimMode()) 
                {
                    if(JustReleased(BT_ALTATTACK))
                        return ResolveState("Zoomout");
                    if (JustPressed(BT_ATTACK) && PressingAltfire())
                        return ResolveState("Fire2");
                }
                else 
                {
                    if(PressingAltfire())
                        return ResolveState("Zoomout");
                    if (JustPressed(BT_ATTACK))
                        return ResolveState("Fire2");
                    // if(invoker.ammo1.amount < prosurvblasterMaxHeat) PB_Refire("Fire2");
                
                }
                return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOFIRE);
            }
            Goto Ready2;

        AltFire:
            TNT1 A 0 {
                A_GunFlash("LightDone",GFF_NOEXTCHANGE);
                A_WeaponOffset(0,32);
                PB_SetRoll(0);
                PB_HandleCrosshair(65);
                A_TakeInventory("PB_LockScreenTilt",1);
            }
            TNT1 A 0 A_StartSound("IronSights");
            TNT1 A 0 A_JumpIf(PB_GetZoom(),"Zoomout");
        ZoomIn:
            TNT1 A 0 A_ZoomFactor(1.2);
            BRGG BC 1 ;
            BRGG DEF 1;
            TNT1 A 0 {
                PB_SetZoom(true);
                A_SetCrosshair(-1);
            }
            Goto Ready2;

        Zoomout:
                TNT1 A 0 {	
                    A_GunFlash("LightDone",GFF_NOEXTCHANGE);
                    PB_SetZoom(false);
                    PB_HandleCrosshair(65);
                    A_ZoomFactor(1.0);
                }
                BRGG FED 1 ;
                BRGG CB 1 ;
                Goto Ready3;

        Reload:
            TNT1 A 0 {
                PB_SetZoom(false);
                A_ZoomFactor(1.0);
                A_Giveinventory("PB_LockScreenTilt",1);
                A_SetCrosshair(-1);
			}
            TNT1 A 0 {
                if(invoker.ammo1.amount != 0) {
                    console.printf("Goint to Recharge");
                    return ResolveState("Recharge");
                }
                console.printf("Goint to Ready3");
                return ResolveState(null);
            }
            goto Ready3;

        Recharge:
            TNT1 A 0 PB_SetReloading(true);
            TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
            BRGC CDEF 1 PB_SetRoll(roll+.2);
            TNT1 A 0 A_PlaySoundEx("weapons/blasterpistol/recharge","Weapon");
            BRGC GH 1;
            BRGC I 1;
            BRGC JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ 1 modifyBlasterOverheat(TAKE, 3);
            BRGC JJJ 1;
            BRGC K 1;
            TNT1 A 0 A_PlaySoundEx("Ironsights", "Auto");
            BRGC LM 1;
            BRGC NOPQ 1 PB_SetRoll(roll-.2);
            TNT1 A 0 PB_SetReloading(false);
            Goto Ready3;

        Unload:
            TNT1 A 0 ;
            Goto Ready3;

        WeaponSpecial:
            TNT1 A 0 {
				A_Takeinventory("GoWeaponSpecialAbility",1);
				A_GiveInventory("PB_LockScreenTilt",1);
				PB_HandleCrosshair(65);
                A_Print("$PBX_NoSpecial");
			}
			Goto Ready3;

        FlashKicking:
            BRGY ABCDEFGFEDCBAA 1;
            Goto Ready3;	
            
        FlashAirKicking:
            BRGY ABCDEFGGFEDCBAAA 1;
            Goto Ready3;
            
        FlashSlideKicking:
            BRGY ABCDEFGGGGGGGGGGGGGGGGGG 1;
            Goto Ready3;
        
        FlashSlideKickingStop:
            BRGY FEDCBAA 1;
            Goto Ready3;
            
        FlashPunching:
            BRGS ABCCCCCCCCCCMN 1;
			Goto Ready3;

        GunFlash:
            TNT1 A 0 A_Jump(256, "Flash1", "Flash2", "Flash3", "Flash4", "Flash5", "Flash6", "Flash7", "Flash8");
            TNT1 A 1;
            Stop;
        Flash1:
            BRGM A 1 Bright;
            STOP;
        Flash2:
            BRGM B 1 Bright;
            STOP;
        Flash3:
            BRGM C 1 Bright;
            STOP;
        Flash4:
            BRGM D 1 Bright;
            STOP;
        Flash5:
            BRGM E 1 Bright;
            STOP;
        Flash6:
            BRGM F 1 Bright;
            STOP;
        Flash7:
            BRGM G 1 Bright;
            STOP;
        Flash8:
            BRGM H 1 Bright;
            STOP;
    }
}
