// Includes
#include "./MetalSniper_Functions.zs"
#include "./MetalSniper_Wheel.zs"
#include "./MetalSniper_helpers.zs"

// Constants
const MetalSniperFullAmmo           = 12;
const MetalSniperFullAmmoResonance  = 4;

Class PBX_MetalSniper : PB_WeaponBase
{
    default
    {
        weapon.slotnumber 4;
        Tag "$PBX_MetalSniper_Tag";
        inventory.pickupsound "CLIPIN";
        inventory.pickupmessage "$PBX_MetalSniper_Pickup";
        Inventory.AltHudIcon "MSNWA0";
        weapon.ammotype1 "PB_HighCalMag";
        weapon.ammogive1 32;
        weapon.ammotype2 "MetalSniperAmmo";
        PB_WeaponBase.UsesWheel true;
        PB_WeaponBase.WheelInfo "MetalSniperWheel";
		PB_WeaponBase.ReserveToMagAmmoFactor 2;
        scale 0.62;
        +weapon.noalert;
        +weapon.noautofire;
    }

    // ── Constants ────────────────────────────────────────────────────────────
    const SniperMode  = 0;
    const GrenadeMode = 1;
    const muzzlelayer = -52;
    const LOWZOOM = 4.0;
    const HIGHZOOM = 7.0;
    enum MS_Wheel{
        NORMAL,
        ADS
    }

    // ── State ─────────────────────────────────────────────────────────────────
    bool resonanceAmmoLoaded;
    bool grenadeloaded;
    bool laserActive;
    bool nvgActive;
    bool AltMode;
    bool LockedOn;
    bool enableScopeHUD; // This is for the overlay that you see when the scope mode is active
    int currentMaxAmmo;
    int usedAmmo;
    int ScopeMode;
    double zoomstrength;

    // ═════════════════════════════════════════════════════════════════════════
    // STATES
    // ═════════════════════════════════════════════════════════════════════════
    states
    {
        // ── Spawn ─────────────────────────────────────────────────────────
        Spawn:
            MSNW A -1;
            stop;

        // ── Weapon Respect ──────────────────────
        WeaponRespect:
            TNT1 A 0 A_SetCrosshair(-1);
            MSNI ABCDEFGHIJKLMNOPQRSSSS 1 A_DoPBWeaponAction();
            MSU0 ABCDEFGHIJKL 1 A_DoPBWeaponAction();
            M3NC ABCDEFGHI 1 A_DoPBWeaponAction();
            TNT1 A 0 A_StartSound("MS/BoltDown", 24);
            M3NC J 15 A_DoPBWeaponAction();
            M3NC K 10 A_DoPBWeaponAction();
            M3NC LL 1 A_DoPBWeaponAction();
            TNT1 A 0 A_StartSound("MS/BoltUp", 25);
            M3NC M 1 A_DoPBWeaponAction();
            MSNR ABCDEFG 1 A_DoPBWeaponAction();
            TNT1 A 0 A_StartSound("MS/InsertMag", 20);
            MSNR HIJKLMNOPQR 1 A_DoPBWeaponAction();
            MSU1 LKJIHGFEDCBA 1 A_DoPBWeaponAction();
            MSNI T 1 A_DoPBWeaponAction();
            MSNI UVWXYZ 1 A_DoPBWeaponAction();
            MSNJ AAB 1 A_DoPBWeaponAction();
            TNT1 A 0 A_StartSound("MS/BoltDown", 24);
            MSNJ BCDEEF 1 A_DoPBWeaponAction();
            TNT1 A 0 A_StartSound("MS/BoltUp", 25);
            MSNJ GHIJKL 1 A_DoPBWeaponAction();
            goto Ready3;

        // ── 1t / Deselect ─────────────────────────────────────────────
        Select:
            TNT1 A 0 {
                resetVariables();
                PB_WeaponRaise("MS/Up");
                return PB_RespectIfNeeded();
            }
        SelectAnimation:
            MSNU ABCD 1;
            goto Ready3;

        Deselect:
            TNT1 A 0 {
                resetVariables();
                PB_SetZoom(false);
                A_ZoomFactor(1.0);
            }
            // TNT1 A 0 PB_SetUsableWheel(true);
            MSND ABCD 1;
            TNT1 A 0 A_Lower(120);
            wait;

        // ── Ready (hip-fire) ──────────────────────────────────────────────
        //    Sprite-only states consumed by animation tools — never looped into.
        Ready:
            MST0 ABCDEFGHIJKL 0;        // take mag empty
            MST3 ABCDEFGHIJKL 0;        // take mag resonance
            MST1 ABCDEFGHIJKL 0;        // take mag standard
            MSNC ABCDEFGHIJKLM 0;       // standard chamber
            M3NC ABCDEFGHIJKLM 0;       // empty chamber
            MSN4 ABCDEFGHIJKLM 0;       // resonance chamber
            MSU0 ABCDEFGHIJKL 0;        // raise no mag
            MSU1 ABCDEFGHIJKL 0;        // raise normal
            MSNR ABCDEFGHIJKLMNOPQR 0;  // insert standard mag
            MSR6 ABCDEFGHIJKLMNOPQR 0;  // insert resonance mag 
        Ready3:
            TNT1 A 0 PB_HandleCrosshair(42);
            TNT1 A 0 resetVariables();
            TNT1 A 0 A_JumpIf(PB_GetZoom(), "Ready2");
            MSNF A 1
            {
                PB_CoolDownBarrel(-4, 0, 6, 0,  1);
                PB_CoolDownBarrel( 4, 0, 6, 0, -1);
                return A_DoPBWeaponAction(WRF_ALLOWRELOAD);
            }
            loop;

        // ── No Ammo States ─────────────────────────────────────────────
        NoAmmo:
            MSNF A 1 A_StartSound("weapons/empty");
            goto Ready3;

        NoAmmo_Grenade:
            MSNG A 1 A_StartSound("weapons/empty");
            goto AltFire_Grenade;

        // ── Fire ────────────────────────────────────────────────────
        Fire:
            TNT1 A 0 {
                A_WeaponOffset(0, 32);
                PB_SetRoll(0);
                PB_HandleCrosshair(42);
                A_SetInventory("PB_LockScreenTilt", 0);
            }
            TNT1 A 0 A_JumpIf(PB_GetZoom(), "Fire_ADS");
            TNT1 A 0 PB_JumpIfNoAmmo("Reload", 1);
            TNT1 A 0 A_AlertMonsters();
            MSNF B 1 bright MetalSniperFire();
            MSNF C 1 bright;
            MSNF DDDEF 1;
            MSNF GHAAAAAAAAAA 1 {
                if (PlayerPressedOnce(BT_ATTACK)) return resolvestate("Fire");
                return A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOFIRE);
            }
            TNT1 A 0 A_Refire("Fire");
            goto Ready3;

        // ── AltFire: zoom or grenade mode ────────────────────────────────
        AltFire:
            TNT1 A 0 {invoker.LockedOn = false;}
            TNT1 A 0 A_JumpIf(MS_getmode() == GrenadeMode, "AltFire_Grenade");
        AltFire_Zoom:
            TNT1 A 0 A_JumpIf(PB_GetZoom(), "ZoomOut");
        ZoomIn:
            TNT1 A 0 {
                setADSWheel();
                PB_SetZoom(true);
            }
            // TNT1 A 0 PB_SetUsableWheel(false);
            TNT1 A 0 A_StartSound("IronSights", 29);
            MSNA A 1 A_ZoomFactor(1.5);
            MSNA B 1 A_ZoomFactor(2.0);
            MSNA C 1 A_ZoomFactor(2.5);
            MSNA D 1 A_ZoomFactor(3.0);
            MSNA E 1 A_ZoomFactor(3.5);
            MSNA F 1 A_ZoomFactor(4.0);
            goto Ready2;

        ZoomOut:
            TNT1 A 0 {
                resetVariables();
                PB_SetZoom(false);
            }
            // TNT1 A 0 PB_SetUsableWheel(true);
            TNT1 A 0 A_StartSound("IronSights", 29);
            MSNA F 1 A_ZoomFactor(3.5);
            MSNA E 1 A_ZoomFactor(3.0);
            MSNA D 1 A_ZoomFactor(2.5);
            MSNA C 1 A_ZoomFactor(2.0);
            MSNA B 1 A_ZoomFactor(1.5);
            MSNA A 1 A_ZoomFactor(1.0);
            goto Ready3;

        // ── Ready (ADS) ───────────────────────────────────────────────────
        Ready2:  
            TNT1 A 0 {
                if(invoker.nvgActive) {
                    A_SetInventory("PBX_Infrared", 1);
                    A_StartSound("RA1IF1", CHAN_AUTO, CHANF_OVERLAP);
                }
            }
        Ready_ADS:
            MSNS A 1 MS_ReadyZoom();
            loop;

        // ── Fire (ADS) ────────────────────────────────────────────────────
		Fire2:
        Fire_ADS:
            TNT1 A 0 PB_JumpIfNoAmmo("ReloadFromADS", 1);
        ActualFireADS:
            MSNS B 1 bright MetalSniperFireADS();
        FireADSContinue:
            MSNS C 1 bright;
            MSNS DDD 1;
            MSNS EFG 1;
            MSNS HIAAAAAAAAAA 1 {
                // A_SetInventory("CantDoAction", 0);
                if (PB_GetAimMode())
                {
                    if (JustReleased(BT_ALTATTACK)) return resolvestate("ZoomOut");
                    if (JustPressed(BT_ATTACK) && PressingAltfire()) return resolvestate("Fire_ADS");
                }
                else
                {
                    if (PressingAltfire())  return resolvestate("ZoomOut");
                    if (JustPressed(BT_ATTACK)) return resolvestate("Fire_ADS");
                    A_Refire("Fire_ADS");
                }
                return A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOFIRE);
            }
            goto Ready2;

        // ── Grenade mode ──────────────────────────────────────────────────
        AltFire_Grenade:
            MSNG A 1 {
                PB_CoolDownBarrel(-4, 0, 6,  0,  1);
                PB_CoolDownBarrel( 4, 0, 6,  0, -1); 
                if (PlayerPressedOnce(BT_ATTACK))
                    return (getgrenqtty() > 0) ? resolvestate("FireGrenade") : resolvestate("Reload_Grenade");
                return resolvestate(null);
            }
            TNT1 A 0 A_Refire("AltFire_Grenade");
            goto Ready3;

        FireGrenade:
            TNT1 A 0 A_Overlay(muzzlelayer, "MuzzleFlash_Gren");
            TNT1 A 0 A_AlertMonsters();
            TNT1 A 0 A_StartSound("MS/Grenade", 20);
            MSNG B 1 bright A_FireProjectile("PB_FragGrenade", 0, 0);
            TNT1 A 0 MS_SetGrenadeQ(0);
            TNT1 A 0 PB_FireOffset();
            TNT1 A 0 PB_GunSmoke(0, 0, -2);
            TNT1 A 0 PB_WeaponRecoil(-3, frandom(-1.5, 1.5));
            MSNG C 1 bright;
            MSNG DEFGA 1;
            TNT1 A 0 A_JumpIf(CountInv("PB_RocketAmmo") > 0, "Reload_Grenade");
            goto Ready3;

        Reload_Grenade:
            TNT1 A 0 A_JumpIf(CountInv("PB_RocketAmmo") < 1, "NoAmmo_Grenade");
            MSNL ABCDEFGGG 1;
            TNT1 A 0 A_StartSound("MS/GrenOpen", 21);
            MSNL G 1;
            TNT1 A 0 PB_SpawnCasing("EmptyGrenadeBrass", 30, -2, 34, frandom(1.0, 2.0), frandom(-4.0, -2.0), 1.0);
            MSNL HIJKLMN 1;
            TNT1 A 0 {
                if (CountInv("PB_RocketAmmo") > 0)
                {
                    MS_SetGrenadeQ(1);
                    A_TakeInventory("PB_RocketAmmo", 1);
                }
                A_StartSound("MS/GrenClose", 22);
            }
            MSNL OPQRSTUGGGTTT 1;
            MSNL FEDCBA 1;
            TNT1 A 0 A_Refire("AltFire_Grenade");
            goto Ready3;

        // ── Reload ────────────────────────────────────────────────────────
        ReloadFromADS:
        Reload:
            TNT1 A 0{
                A_ZoomFactor(1.0);
                PB_SetZoom(false);
                resetVariables();
            }
            TNT1 A 0 PB_CheckReload("RaiseFromEmpty", null, "Start_Rechamber", "Ready3", "NoAmmo", invoker.currentMaxAmmo, invoker.usedAmmo);
        // ── Raise weapon  ──────────────────
        StandardReload:
            TNT1 A 0 A_StartSound("IronSights", 30);
            MSU1 ABCDEFGHIJKL 1;    // raise
            TNT1 A 0 A_JumpIf(isResonance(), "TakeMagResonance");
        // Take standard mag out
        TakeMagStandard:
            MST1 ABCD 1 { if (PB_GetMagEmpty()) A_SetWeaponSprite("MST0"); }
            TNT1 A 0 A_StartSound("MS/Button", 22);
            MST1 E    1 { if (PB_GetMagEmpty()) A_SetWeaponSprite("MST0"); }
            TNT1 A 0 {
                A_StartSound("MS/TakeMag", 23);
                PB_SetMagUnloaded(true);
            }
            MST1 FGHIJKL 1 { if (PB_GetMagEmpty()) A_SetWeaponSprite("MST0"); }
            goto InsertMag;

        // Take resonance mag out
        TakeMagResonance:
            MST3 ABCD 1 { if (PB_GetMagEmpty()) A_SetWeaponSprite("MST0"); }
            TNT1 A 0 A_StartSound("MS/Button", 22);
            MST3 E    1 { if (PB_GetMagEmpty()) A_SetWeaponSprite("MST0"); }
            TNT1 A 0 {
                A_StartSound("MS/TakeMag", 23);
                PB_SetMagUnloaded(true);
            }
            MST3 FGHIJKL 1 { if (PB_GetMagEmpty()) A_SetWeaponSprite("MST0"); }
        // Insert new mag
        InsertMag:
            MSNR ABCDEFG 1 { if (isResonance()) A_SetWeaponSprite("MSR6"); }
            TNT1 A 0 A_StartSound("MS/InsertMag", 20);
            MSNR HIJKL 1 ;
            TNT1 A 0 {
                MS_ReloadMag();
                PB_SetMagUnloaded(false);
                PB_SetMagEmpty(false);
            }
            MSNR MNOPQR 1 ;
            TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(), "Rechamber");
        FinishReload:
            MSU1 LKJIHGFEDCBA 1;    // lower
            TNT1 A 0 PB_SetReloading(false);
            goto Ready3;

        // ── Raise from fully empty mag ────────────────────────────────────
        RaiseFromEmpty:
            TNT1 A 0 A_StartSound("IronSights", 30);
            MSU0 ABCDEFGHIJKL 1;    // empty-mag raise
            goto InsertMag;

        // ── Rechamber ──────────────────────────
        Start_Rechamber:
            TNT1 A 0 A_StartSound("IronSights", 30);
            MSU1 ABCDEFGHIJKL 1;    // raise
        Rechamber:
            MSNC ABCDEFG 1 ;
            TNT1 A 0 A_StartSound("MS/BoltDown", 24);
            TNT1 A 0 PB_SetChamberEmpty(false);
            MSNC HIJ 1 ;
			MSNC K 1 { if (isResonance()) A_SetWeaponSprite("MSN4"); }
			MSNC L 1 ;
            TNT1 A 0 A_StartSound("MS/BoltUp", 25);
            MSNC M 1 ;
			goto FinishReload;

        // ── Reload from special ─────────────
        ReloadFromSpecial:
            TNT1 A 0 {
                MS_ToggleResonance();
                MS_AmmoCapacity();
                cleanmodetokens();
            }
            MSR6 ABCDEFG 1 { if (!isResonance()) A_SetWeaponSprite("MSNR"); }
            TNT1 A 0 A_StartSound("MS/InsertMag", 20);
            MSNR HIJKL 1;
            TNT1 A 0 {
                MS_ReloadMag();
                PB_SetMagUnloaded(false);
                PB_SetMagEmpty(false);
            }
            MSNR MNOPQR 1;
            goto Rechamber;

        // ── Unload ────────────────────────────────────────────────────────
        UnloadFromSpecial:
            TNT1 A 0 A_StartSound("IronSights", 30);
            TNT1 A 0 A_JumpIf(PB_GetMagUnloaded() && !PB_GetChamberEmpty(), "StartUnloadChamber");
            MSU1 ABCDEFGHIJKL 1;
            TNT1 A 0 A_JumpIf(isResonance(), "UnloadMagResonance");
			goto UnloadMagStandard;

		Unload:
            TNT1 A 0 A_StartSound("IronSights", 30);
            // If mag already unloaded, skip straight to chamber
            TNT1 A 0 A_JumpIf(PB_GetMagUnloaded() && !PB_GetChamberEmpty(), "StartUnloadChamber");
        UnloadRaise:
            MSU1 ABCDEFGHIJKL 1;
            TNT1 A 0 A_JumpIf(PB_GetMagEmpty(), "UnloadMagEmpty");
            TNT1 A 0 A_JumpIf(isResonance(), "UnloadMagResonance");
        // Standard mag unload
        UnloadMagStandard:
            MST1 ABCD 1;
            TNT1 A 0 A_StartSound("MS/Button", 22);
            MST1 E 1;
            TNT1 A 0 A_StartSound("MS/TakeMag", 23);
            MST1 FGH 1;
            TNT1 A 0 {
                MS_UnloadMag();
                PB_SetMagUnloaded(true);
                PB_SetMagEmpty(true);
            }
            MST1 IJKL 1;
            TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(), "FinishUnload");
            goto UnloadChamber;

        // Empty mag unload
        UnloadMagEmpty:
            MST0 ABCD 1;
            TNT1 A 0 A_StartSound("MS/Button", 22);
            MST0 E 1;
            TNT1 A 0 {
                MS_UnloadMag();
                PB_SetMagUnloaded(true);
                PB_SetMagEmpty(true);
            }
            TNT1 A 0 A_StartSound("MS/TakeMag", 23);
            MST0 FGHIJKL 1;
            TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(), "FinishUnload");
            goto UnloadChamber;

        // Resonance mag unload
        UnloadMagResonance:
            MST3 ABCD 1;
            TNT1 A 0 A_StartSound("MS/Button", 22);
            MST3 E 1;
            TNT1 A 0 {
                MS_UnloadMag();
                PB_SetMagUnloaded(true);
                PB_SetMagEmpty(true);
            }
            TNT1 A 0 A_StartSound("MS/TakeMag", 23);
            MST3 FGHIJKL 1;
            TNT1 A 0 A_JumpIf(PB_GetChamberEmpty(), "FinishUnload");
            goto UnloadChamber;

        // Unchamber
        UnloadChamber:
            M3NC ABCDEFGHI 1;
            TNT1 A 0 A_StartSound("MS/BoltDown", 24);
            M3NC JKL 1;
            TNT1 A 0 {
                MS_UnloadMag(true);     // UnloadChamber = true
                PB_SetChamberEmpty(true);
            }
            TNT1 A 0 A_StartSound("MS/BoltUp", 25);
            M3NC M 1;
        FinishUnload:
            TNT1 A 0 A_JumpIfInventory("MS_Select_Resonance", 1, "ReloadFromSpecial");
            MSU0 LKJIHGFEDCBA 1;    // lower
            goto Ready3;

        // Skip raise — already raised when mag was manually removed
        StartUnloadChamber:
            MSU0 ABCDEFGHIJKL 1;
            goto UnloadChamber;

        // ── Weapon Special ────────────────────
        WeaponSpecial:
            TNT1 A 0 A_SetCrosshair(-1);
            TNT1 A 0 A_TakeInventory("GoWeaponSpecialAbility", 1);
            TNT1 A 0 MS_HandleSpecial();
            TNT1 A 0 A_JumpIf(PB_GetZoom(),"Ready2");
        ChangeAnim:
            TNT1 A 0 A_StartSound("IronSights", 30);
            MSSW ABCDEFF 1;
            TNT1 A 0 A_StartSound("MS/Button", 26);
            MSSW GHIJKLM 1;
            goto Ready3;

        // ── Muzzle flashes ────────────────────────────────────────────────
        MuzzleFlash:
            TNT1 A 0 A_OverlayFlags(overlayID(), PSPF_MIRROR | PSPF_FLIP, random(0, 1));
            TNT1 A 0 A_Jump(128, "MF2");
            MSNM AB 1 bright;
            stop;
        MF2:
            MSNM AC 1 bright;
            stop;

        MuzzleFlash_ADS:
            TNT1 A 0 A_OverlayFlags(overlayID(), PSPF_MIRROR | PSPF_FLIP, random(0, 1));
            TNT1 A 0 A_Jump(128, "MFADS2");
            MSNM DE 1 bright;
            stop;
        MFADS2:
            MSNM DF 1 bright;
            stop;

        MuzzleFlash_Gren:
            TNT1 A 0 A_OverlayFlags(overlayID(), PSPF_MIRROR | PSPF_FLIP, random(0, 1));
            MSNM G 1 bright;
            stop;

        // ── Melee flash overlays ──────────────────────────────────────────
        FlashPunching:
            TNT1 A 0 resetVariables();
            MSNQ ABCDEFGHFEDCBA 1;      // 14 frames
            goto Ready3;

        FlashKicking:
            TNT1 A 0 resetVariables();
            MSNK ABCDEFGHGFEDCBA 1;     // 15 frames
            goto Ready3;

        FlashAirKicking:
            TNT1 A 0 resetVariables();
            MSNQ ABCDEFGHHGFEDCBA 1;    // 16 frames
            goto Ready3;

        FlashSlideKicking:
            TNT1 A 0 resetVariables();
            MSNK ABCDEFGHHHHHHHHHHHHHGFEDCBA 1; // 27 frames
            goto Ready3;

        FlashSlideKickingStop:
            TNT1 A 0 resetVariables();
            MSNK GFEDCBA 1;             // 7 frames
            goto Ready3;
    }
}
