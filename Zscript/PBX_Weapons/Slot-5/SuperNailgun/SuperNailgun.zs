// Includes
// #include "./PlasmaBlaster_Functions.zs"
// #include "./PlasmaBlaster_Projectiles.zs"
// #include "./PlasmaBlaster_Wheel.zs"

// Actual Weapon
class PBX_SuperNailgun : PB_WeaponBase
{
    Default
    {
//////////////////////////// WEAPON DATA ////////////////////////////////////////////////////////////////////////////////////
        Weapon.SelectionOrder 2545;
        Weapon.SlotNumber 5;
        Weapon.SlotPriority 0.5;
	    Inventory.AltHUDIcon "SNPIA0";
		PB_WeaponBase.MaxOverheat MAX_OVERHEAT;
		PB_WeaponBase.OverheatCoolingRate OVERHEATCOOLING_RATE;
        Weapon.BobRangeX 0.3;
        Weapon.BobRangeY 0.5;
        Weapon.BobStyle "InverseSmooth";
        Weapon.BobSpeed 2.4;
        FloatBobStrength 0.5;

//////////////////////////// AMMO ////////////////////////////////////////////////////////////////////////////////////
        Weapon.AmmoType1 "PB_HighCalMag";
        Weapon.AmmoType2 "SuperNailgunAmmo";
        Weapon.AmmoGive1 30;

//////////////////////////// MESSAGES & SOUNDS ////////////////////////////////////////////////////////////////////////////////////
        Inventory.Pickupmessage  "$PBX_SuperNailgun_Pickup";
        Inventory.PickupSound "CBOXPKUP";
        Obituary "Became a Leaking Piece Of Meat By The Super Nailgun";
        AttackSound "None";
        Tag "$PBX_SuperNailgun_Tag";
        Scale 0.4;

//////////////////////////// WEAPON FLAGS ////////////////////////////////////////////////////////////////////////////////////
        +WEAPON.NOAUTOAIM;
        +WEAPON.NOAUTOFIRE;
        +WEAPON.NO_AUTO_SWITCH;
        +INVENTORY.ALWAYSPICKUP;
        +FORCEXYBILLBOARD;
    }

//////////////////////////// VARIABLES ////////////////////////////////////////////////////////////////////////////////////
	bool isOverheating;

    const MAGAZINE_SIZE         = 100; 

    const MAX_OVERHEAT	 		= 300;
	const OVERHEAT_THRESHOLD	= 80;	// Overheat threshold for firing the special rounds
	const OVERHEATCOOLING_RATE 	= 4;	// How many tics before removing 5 overheat when not selected
	const OVERHEATCOOLING_RATE2 = -5;	// Same as above but when the weapon is selected
	const OVERHEATCOOLING_LAYER = 3;
	const OVERHEAT_GIVE_OVR 	= 12;	// How much heat given when over Threshold
	const OVERHEAT_GIVE_NORM	= 10;	// How much heat given when normal fire

//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////

//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////
    action void superNailgun_setSprite(name mSprite)
    {
        if(PB_GetMagUnloaded())
            A_SetWeaponSpriteEx(mSprite);
    }

    action void cooldownOverheat()
	{
		A_Overlay(OVERHEATCOOLING_LAYER,"Cooling",true);
	}

    action void SuperNailgun_CoolDownBarrel()
	{
		int heat = PB_GetOverheat();
		
		if (heat < OVERHEAT_THRESHOLD)
		{
			PB_CoolDownBarrel(0, 0, 2, 0, 0, 0, 1.0, 1.0, true);
			return;
		}
		
		double scale = PB_Math.LinearMap(double(heat), 175.0, 500.0, 0.8, 2.5);
		double alpha = PB_Math.LinearMap(double(heat), 175.0, 500.0, 0.5, 1.5);
		
		PB_CoolDownBarrel(0, 0, 2, 0, 0, 0, scale, alpha, true);
	}

    action void SuperNailgun_Fire()
    {
        A_ZoomFactor (0.98);
        PB_LowAmmoSoundWarning("lmg");
        PB_TakeAmmo(invoker.ammo2.getClassName(),emptyMag:0,emptyChamber:0);
        A_PlaySound("SNFIRE", 50);
        A_FireProjectile("SuperNail_Hot");
        PB_WeaponRecoil(-0.6, 0);
        PB_ModifyOverheat(invoker.isOverheating ? OVERHEAT_GIVE_OVR : OVERHEAT_GIVE_NORM);
    }

    // To Reduce boilerplate
    action void SuperNailgun_PLaysound()
    {
        A_Playsound("SNGA", 50);
        A_Playsound("SNGB", 51);
    }

//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
    States
    {
//////////////////////////// SETUP ////////////////////////////////////////////////////////////////////////////////////
        Spawn:
            SNPI A -1;
            Stop;

        WeaponRespect:
            SNRE ABCDEFGHIIIIIIIJK 1 A_DoPBWeaponAction();
            TNT1 A 0 A_PlaysoundEx("weapons/riflemagslap", "Auto");
            SNRE LMNOPPPQRSTUVWXYZ  1 A_DoPBWeaponAction();
            SNR1 AB 1 A_DoPBWeaponAction();
            TNT1 A 0 A_Playsound("weapons/shotgun/detach", 50);
            TNT1 A 0 A_Playsound("weapons/minigun/respect1", 51);
            SNR1 CDEFGGGHIJKL 1 A_DoPBWeaponAction();
            SNLR A 6 A_DoPBWeaponAction();
            TNT1 A 0 SuperNailgun_PLaysound();
            SNR1 MNO 1 A_DoPBWeaponAction();
            TNT1 A 0 SuperNailgun_PLaysound();
            SNR1 MNO 2 A_DoPBWeaponAction();
            TNT1 A 0 SuperNailgun_PLaysound();
            SNR1 MNO 3 A_DoPBWeaponAction();
            TNT1 A 0 SuperNailgun_PLaysound();
            SNR1 MNO 4 A_DoPBWeaponAction();
            TNT1 A 0 SuperNailgun_PLaysound();
		    SNR1 MNO 5 A_DoPBWeaponAction();
            Goto Ready3;

        CacheSprites:
            SNXL A 0; SNSU A 0;

        Deselect:
			TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
				PB_HandleCrosshair(39);
				A_TakeInventory("PB_LockScreenTilt",1);
                A_StopSound(1);
			}
			SNSE GFEDCBA 1 superNailgun_setSprite("SNSU");
			TNT1 A 0 A_Lower();
			Wait;

        Select:
            TNT1 A 0 {
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
			    PB_HandleCrosshair(67);
				A_SetInventory("PB_LockScreenTilt",0);
				A_ClearOverlays(OVERHEATCOOLING_LAYER,OVERHEATCOOLING_LAYER);
				cooldownOverheat();
                PB_WeaponRaise("GENREADY");
			    return PB_RespectIfNeeded();
			}
        SelectAnimation:
            SNSE ABCDEFG 1 superNailgun_setSprite("SNSU");
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
        Ready3:
			SNLR A 1 {
                if(PB_GetOverheat() > 1) {cooldownOverheat();}
				if(PB_GetOverheat() == 0) {invoker.isOverheating = false;}
                SuperNailgun_CoolDownBarrel();
			    PB_HandleCrosshair(67);
                superNailgun_setSprite("SNXL");
                return A_DoPBWeaponAction();
            }
            loop;

        Cooling:
			TNT1 A 1 {if(PB_GetOverheat() == 0) invoker.isOverheating = false;}
			TNT1 A 8;
			TNT1 A 4 {
				PBXCore_Debug.Print("Lowered Overheat");
				PB_ModifyOverheat(OVERHEATCOOLING_RATE2);
			}
			Wait;

//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
        Fire:
            TNT1 A 0 PB_JumpIfNoAmmo();
            SNLR F 1 BRIGHT SuperNailgun_Fire();
            SNLR GHI 1 A_ZoomFactor(1);
            TNT1 A 0 PB_ReFire("Fire");
        SpinAfterFire:
            SNLR CDECD 1 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
            SNLR ECDE 2 A_DoPBWeaponAction(WRF_ALLOWRELOAD);
            Goto Ready3;
  
//////////////////////////// ALT FIRE ////////////////////////////////////////////////////////////////////////////////////
        AltFire:
            TNT1 A 0 {
                A_WeaponOffset(0,32);
                PB_SetRoll(0);
                PB_HandleCrosshair(39);
                A_TakeInventory("PB_LockScreenTilt",1);
            }
            // TNT1 A 0 PB_JumpIfNoAmmo(min:4);
            TNT1 A 0 SuperNailgun_PLaysound();
            SNR1 MNO 1 A_DoPBWeaponAction();
            TNT1 A 0 SuperNailgun_PLaysound();
            SNR1 MNO 1 A_DoPBWeaponAction();
            TNT1 A 0 SuperNailgun_PLaysound();
            TNT1 A 0 PB_ModifyOverheat(invoker.isOverheating ? OVERHEAT_GIVE_OVR : OVERHEAT_GIVE_NORM);
            loop;

            SNR1 MNO 1;
            TNT1 A 0 A_ZoomFactor (0.96);
            TNT1 A 0 SuperNailgun_PLaysound();
            TNT1 A 0 A_PlaySound("SNFIRE", 52);
            TNT1 A 0 A_FireProjectile("SuperNail_Hot");
            TNT1 A 0 A_FireProjectile("SuperNail_Hot",  0, 0, 7);
            TNT1 A 0 A_FireProjectile("SuperNail_Hot",  0, 0, -7);
            TNT1 A 0 A_FireProjectile("SuperNail_Hot",  0, 0, 0, -8);
            TNT1 A 0 PB_TakeAmmo(invoker.ammo2.getClassName(),emptyMag:0,emptyChamber:0);
            SNLR F 1 BRIGHT;
            TNT1 A 0 PB_WeaponRecoil(-2.5, 0);
            TNT1 A 0 A_ZoomFactor (1);
            SNLR GHI 2;
            TNT1 A 0 PB_ReFire("AltFire");
            Goto Ready3;

//////////////////////////// RELOAD ////////////////////////////////////////////////////////////////////////////////////
        Reload:
            TNT1 A 0 PB_CheckReload("ReloadUnloaded",null,null,"Ready3","Ready3",MAGAZINE_SIZE);
            TNT1 A 0 A_ZoomFactor(1.0);
            TNT1 A 0 A_StartSound("IronSights", 30);
            SNRL ABCD 1 PB_SetRoll(roll-2);
            SNRL EF 1 PB_SetRoll(roll+2);
            TNT1 A 0 {
                A_FireCustomMissile("EmptyASGDrum",-5,0,8,-4);
                A_PlaysoundEx("weapons/shotgun/detach", "Auto");
                PB_SetMagUnloaded(true);
            }
            SNRL GH 1;
        ReloadUnloaded:
            SNRL IJKLM 1;
            SNRL NOP 1 PB_SetRoll(roll+2);
            TNT1 A 0 {
				PB_SetOverheat(0);
				invoker.isOverheating = false;
                A_PlaysoundEx("weapons/riflemagslap", "Auto");
                PB_AmmoIntoMag(
                    invoker.ammo2.getClassName(),
                    invoker.ammo1.getClassName(),
                    MAGAZINE_SIZE);
                PB_SetChamberEmpty(false);
                PB_SetMagUnloaded(false);
                PB_SetMagEmpty(false);
            }
            SNRL QR 1;
            SNRL STUVWX 1 PB_SetRoll(roll-2);
            TNT1 A 0 PB_SetRoll(0);
            Goto Ready3;
            
//////////////////////////// UNLOAD ////////////////////////////////////////////////////////////////////////////////////
        Unload:
			TNT1 A 0 A_Jumpif(pb_getmagunloaded(),"Ready3");
            TNT1 A 0 A_ZoomFactor(1.0);
            TNT1 A 0 A_StartSound("IronSights", 30);
            SNRL ABCD 1 PB_SetRoll(roll-2);
            SNRL EF 1 PB_SetRoll(roll+2);
            TNT1 A 0 {
                A_PlaysoundEx("weapons/shotgun/detach", "Auto");
                PB_UnloadMag(invoker.ammo2.getclassname(),invoker.ammo1.getclassname());
                PB_SetChamberEmpty(true);
                PB_SetMagUnloaded(true);
                PB_SetMagEmpty(true);
            }
            SNRL GHI 1;
            Goto Ready3;

//////////////////////////// WEAPON SPECIAL ////////////////////////////////////////////////////////////////////////////////////
        WeaponSpecial:
            TNT1 A 0 {
                A_TakeInventory("GoWeaponSpecialAbility", 1);
                A_Print("$PBX_NoSpecial");
            }
            Goto Ready3;
            
//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
        FlashPunching:
			TNT1 A 0 cooldownOverheat();
            SNSE GFEDCB 1 superNailgun_setSprite("SNSU");
            "####" AA 1;
            "####" BCDEFG 1;      // 14 frames
            goto Ready3;

        FlashKicking:
			TNT1 A 0 cooldownOverheat();
            SNSE GFEDCB 1 superNailgun_setSprite("SNSU");
            "####" AAA 1;
            "####" BCDEFG 1;      
            goto Ready3;        // 15 frames

        FlashAirKicking:
			TNT1 A 0 cooldownOverheat();
            SNSE GFEDCB 1 superNailgun_setSprite("SNSU");
            "####" A 4;
            "####" BCDEFG 1;      
            goto Ready3;        // 16 frames

        FlashSlideKicking:
			TNT1 A 0 cooldownOverheat();
            SNSE GFEDCB 1 superNailgun_setSprite("SNSU");
            "####" A 15;
            "####" BCDEFG 1;      
            goto Ready3; // 27 frames

        FlashSlideKickingStop:
			TNT1 A 0 cooldownOverheat();
            MSNK BCDEFGG 1;             // 7 frames
            goto Ready3;
    }
}

class SuperNail_Hot : PB_MGNailHot
{
    Default
    {
		PB_Projectile.BaseDamage 50;
    }

	override void OnHitActor(Actor target, Name dmgType)
    {
        if(target.bIsMonster && target is "PB_Monster" && self.truedamage >= target.health)
        {
            S_StartSound("ThunderStrike",0);
            // Compute angles for LineTraceVisual
            double yaw = 0;         // Straight up
            double pitch = -90;     // -90 degrees (purely vertical)

            FLineTraceData traceData;
/* 					bool traceResult = Line3d.LineTraceVisual(
                target,             // Source actor
                yaw,                // Yaw (straight up)
                2000,               // Distance to check
                pitch,              // Pitch (-90° up)
                TRF_NOSKY | TRF_THRUACTORS, // Ignore actors, but stop at sky
                target.Height,                 // OffsetZ (check from above)
                0,                  // OffsetXY
                0,                  // OffsetSide
                data: traceData,    // Output trace data
                LineClassName: "Line3d",
                TimeToLive: 1,
                TimeToCycle: 0,
                MarkerClassName: "Marker3d"
            );
*/
            
            bool traceResult = target.LineTrace(
                yaw,                // Yaw (straight up)
                2000,               // Distance to check
                pitch,              // Pitch (-90° up)
                TRF_NOSKY | TRF_THRUACTORS, // Ignore actors, but stop at sky
                target.Height,                 // OffsetZ (check from above)
                0,                  // OffsetXY
                0,                  // OffsetSide
                data: traceData
            );

            if (!traceResult) 
            {
//					Console.Printf("\cy%s is under open sky! Spawning explosion.", target.GetTag());
                Actor.Spawn("LightningBolt",(target.pos.x,target.pos.y,target.pos.z));
            }
            else
            {
//					Console.Printf("\cy%s is NOT under open sky! Finding nearest valid spot...", target.GetTag());
                FireGroundTracers(target);
            }
        }
    }

    void FireGroundTracers(Actor target)
	{
		double distance = 256;  // Distance outward
		double pitch = 25;      // Downward pitch in degrees

		// Separate arrays for X, Y, Z coordinates of valid locations
		Array<double> validX;
		Array<double> validY;
		Array<double> validZ;

		for (int i = 0; i < 8; i++)
		{
			double yaw = i * 45; // 0°, 45°, 90°, ..., 315°

			FLineTraceData traceData;
/*			bool traceResult = Line3d.LineTraceVisual(
				target,               // Source actor (target)
				yaw,                  // Yaw angle (fixed-point Doom angle)
				distance,             // Distance of the trace
				pitch,                // Downward pitch
				TRF_THRUACTORS,       // Pass through actors, but hit ground
				target.Height,        // Start at the actor’s height
				0,                    // OffsetXY
				0,                    // OffsetSide
				data: traceData,      // Output trace data
				LineClassName: "LaserBlast", // Debug visual
				TimeToLive: 105,
				TimeToCycle: 0,
				MarkerClassName: "Marker3d"
			);
			*/
			
			bool traceResult = target.LineTrace(
				yaw,                  // Yaw angle (fixed-point Doom angle)
				distance,             // Distance of the trace
				pitch,                // Downward pitch
				TRF_THRUACTORS,       // Pass through actors, but hit ground
				target.Height,        // Start at the actor’s height
				0,                    // OffsetXY
				0,                    // OffsetSide
				data: traceData
			);

			if (traceResult && traceData.HitType == TRACE_HitFloor)
			{
//				Console.Printf("\cdTracer %d hit ground at: (%f, %f, %f)", i, traceData.HitLocation.X, traceData.HitLocation.Y, traceData.HitLocation.Z);

				// SECOND TRACE UPWARD
				FLineTraceData skyTraceData;
			/*	bool skyTraceResult = Line3d.LineTraceVisual(
					target,                // Source actor (target)
					0,                     // Yaw angle (same as before)
					2000,                  // Large upward distance
					-90,                   // Straight up
					TRF_NOSKY | TRF_THRUACTORS | TRF_ABSPOSITION | TRF_ABSOFFSET, // Ignore actors, check for sky
					traceData.HitLocation.Z,    // Start from ground hit location
					traceData.HitLocation.X,    // X offset (from previous hit)
					traceData.HitLocation.Y,    // Y offset (from previous hit)
					data: skyTraceData,         // Output trace data
					LineClassName: "Line3d",    // Debug visual
					TimeToLive: 105,
					TimeToCycle: 0,
					MarkerClassName: "Marker3d"
				);
				*/
				
				bool skyTraceResult = target.LineTrace(
					0,                     // Yaw angle (same as before)
					2000,                  // Large upward distance
					-90,                   // Straight up
					TRF_NOSKY | TRF_THRUACTORS | TRF_ABSPOSITION | TRF_ABSOFFSET, // Ignore actors, check for sky
					traceData.HitLocation.Z,    // Start from ground hit location
					traceData.HitLocation.X,    // X offset (from previous hit)
					traceData.HitLocation.Y,    // Y offset (from previous hit)
					data: skyTraceData
				);

				if (!skyTraceResult) // Sky is clear
				{
//					Console.Printf("\cySky is clear above: (%f, %f, %f)", traceData.HitLocation.X, traceData.HitLocation.Y, traceData.HitLocation.Z);

					// Store X, Y, Z separately
					validX.Push(traceData.HitLocation.X);
					validY.Push(traceData.HitLocation.Y);
					validZ.Push(traceData.HitLocation.Z);
				//	Actor.Spawn("LightningBolt",(traceData.HitLocation.X,traceData.HitLocation.Y,traceData.HitLocation.Z));
				}
				else
				{
//					Console.Printf("\cgSky blocked at: (%f, %f, %f)", skyTraceData.HitLocation.X, skyTraceData.HitLocation.Y, skyTraceData.HitLocation.Z);
				}
			}
			else
			{
//				Console.Printf("\coTracer %d missed ground! No valid hit location.", i);
			}
		}

		// Spawn explosion at a random valid location if we have any
		if (validX.Size() > 0)
		{
			int randomIndex = Random(0, validX.Size() - 1);
			double chosenX = validX[randomIndex];
			double chosenY = validY[randomIndex];
			double chosenZ = validZ[randomIndex];

//			Console.Printf("\cGSpawning explosion at: (%f, %f, %f)", chosenX, chosenY, chosenZ);

			// Spawn the explosion
			Actor.Spawn("LightningBolt", (chosenX, chosenY, chosenZ));
		}
    }
}