const BR_AmmoFull = 15;

class PBX_BDPBattleRifle : PB_WeaponBase
{
	Default
	{
        // Weapon Data
		Weapon.SlotNumber 4;
	    Weapon.SlotPriority 2;
	    Weapon.SelectionOrder 1550;
	    Inventory.PickupSound "BR45PICK";
	    Inventory.AltHUDIcon "BR45A0";
		inventory.maxamount 1;
		PB_WeaponBase.UsesWheel true;
		PB_WeaponBase.WheelInfo "BattleRifleWheel";
		PB_WeaponBase.ReserveToMagAmmoFactor 1;
		Scale 1.0;
		
        // Messages
	    Obituary "%o was pierced by %k's Battle Rifle.";
	    Inventory.Pickupmessage "$PBX_BattleRifle_Pickup";
		Tag "$PBX_BattleRifle_Tag";
		
        // Ammo
        weapon.ammotype1 "PB_HighCalMag"; // Reserve
		weapon.ammogive1 30;
		weapon.ammotype2 "BR_Ammo"; // Primary
		
        // Flags
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.NOAUTOFIRE; //[Pop] Use NOAUTOFIRE if you want a semi auto gun.
		//Albeit PB has QOL stuff for holding down left click already, firing it
		//at a slower rate
	}
	
    // VARIABLES
    bool isADS;
    bool isSemiAuto;
	bool semiclear;
	bool LockedOn;
	int burstcount;

    // FUCNTIONS
	action void cleanmodetokens()
	{
		A_SetInventory("BR_Select_Semi",0);
		A_SetInventory("BR_Select_Burst",0);
	}

	action bool getSemiAuto()
	{
		return invoker.isSemiAuto;
	}

	action void setSemiAuto(bool set)
	{
		invoker.isSemiAuto = set;
	}

	action void BR_ReadyNormal()
    {
        FLineTraceData Bule;
        bool hit = LineTrace(Angle, 6000, Pitch, 0, player.ViewHeight, 0, 0, Bule);
        if(hit)
        {
            if(Bule.HitActor && Bule.HitActor.bISMONSTER && Bule.HitActor.bFRIENDLY == false && Bule.HitActor is "PB_Monster")
            {				
                if(!invoker.LockedOn)
                {
                    invoker.LockedOn = true;
                    A_StartSound("IronSights", CHAN_WEAPON, volume:0.5, pitch:1.4);
                }
                // let damn = player.FindPSprite(1);
                // if(damn)
                // {
                //     damn.frame = 3;
                //     damn.sprite = GetSpriteIndex("SPRF");
                // }
            }
            else
            if(invoker.LockedOn)
            {
                invoker.LockedOn = false;
                A_StartSound("IronSights", CHAN_WEAPON, volume:0.5, pitch:1.3);
            }
        }	
        // return A_DoPBWeaponAction();
    }
    
    action void BR_ReadyScope()
    {
        FLineTraceData Bule;
        bool hit = LineTrace(Angle, 6000, Pitch, 0, player.ViewHeight, 0, 0, Bule); //Line to kick enemy or wall
        if(hit)
        {
            if(Bule.HitActor && Bule.HitActor.bISMONSTER && Bule.HitActor.bFRIENDLY == false && Bule.HitActor is "PB_Monster")
            {	
                if(!invoker.LockedOn)
                {
                    // A_SetBlend(0x00a100, 0.2, 3);
                    invoker.LockedOn = true;
                    A_StartSound("IronSights", CHAN_WEAPON, pitch:1.4);
                }
                //show the actor's wireframe
                let Wireframe = Spawn("PBX_CubeRadius", Bule.HitActor.pos);
                if(Wireframe)
                {
                    Wireframe.scale.x = double(Bule.HitActor.Radius) * 2;
                    Wireframe.scale.Y = double(Bule.HitActor.Height) * Level.pixelstretch;
                    Wireframe.vel = Bule.HitActor.vel;
                }
                // player.PSprites.frame = 1;
                PBXWeapons_Handler.SendInterfaceEvent(self.PlayerNumber(), "PrintScopeData:"..Bule.HitActor.GetTag(), Bule.HitActor.health, Bule.HitActor.GetSpawnHealth(), Bule.HitActor.PainChance);
                PBXWeapons_Handler.SendInterfaceEvent(self.PlayerNumber(), "PrintScopeData2:", Distance3D(Bule.HitActor), 3.0);
            }
            else
            if(invoker.LockedOn)
            {
                // A_SetBlend(0xa19900, 0.2, 3);
                invoker.LockedOn = false;
                A_StartSound("IronSights", CHAN_WEAPON, pitch:1.3);
            }
        }
        // return A_DoPBWeaponAction();
    }

    action int getBRMag()
    {
        return CountInv(invoker.ammotype2);
    }

    action bool getADS()
    {
        return invoker.isADS;
    }

	action void setADS(bool set = false)
	{
		invoker.isADS = set;
	}

	action bool PlayerPressedOnce(int button)
	{
		int bt = player.cmd.buttons;
		int oldbt = player.oldbuttons;
		if((bt & button) && !(oldbt & button))
			return true;
		return false;
	}

    Action void a_FireBattleRifle()
	{
		FLineTraceData ricochetdata;
		invoker.owner.LineTrace(invoker.owner.angle, 4096, invoker.owner.pitch, TRF_SOLIDACTORS, offsetz: invoker.owner.player.viewz - invoker.owner.pos.z, data: ricochetdata);
		vector3 hitNormal;
		if(ricochetdata.HitType == TRACE_HitWall )
		{
			if(!ricochetdata.LineSide)
			{
				hitnormal = (ricochetdata.Hitline.delta.y, -ricochetdata.Hitline.delta.x, 0).unit();
			}
			else
			{
				hitnormal = (-ricochetdata.Hitline.delta.y, ricochetdata.Hitline.delta.x, 0).unit();
			}
			
		}
		else if (ricochetdata.HitType == TRACE_HitFloor)
		{
			hitnormal = ricochetdata.HitSector.FloorPlane.normal;
			
		}
		else if (ricochetdata.HitType == TRACE_HitCeiling)
		{
			hitnormal = ricochetdata.HitSector.CeilingPlane.normal;
		}
		Vector3 PlayerAngle = BDPMATH.AngletoVector3(1.0,invoker.owner.angle,invoker.owner.pitch);
		
		Vector3 BounceAngle = BDPMATH.BounceNormal(PlayerAngle,hitNormal);
		
		Double NextShotAngle;
		Double NextShotPitch;
		
		
		
		[NextShotAngle, NextShotPitch] = BDPMATH.Vector3toangles(BounceAngle);

		double anglediff = BDPMath.AngleDiff(invoker.owner.angle % 360.0,nextshotangle % 360.0);
		double pitchdiff = BDPMath.AngleDiff(invoker.owner.pitch % 360.0,nextshotpitch % 360.0);
		//Console.printf("%f",anglediff);
		
		
		Vector3 NextShotPosition = level.Vec3Offset(ricochetData.hitlocation, hitnormal * 2.0);
		
		//A_FireBullets (0, 0, -1, 25, "BR45BulletPuff", FBF_NORANDOM,8192,"decorativetracer",-12);
		PB_FireBullets("PB_762x51mm", 1, frandom(-0.1, 0.1), 0, 0, frandom(-0.1, 0.1));
        PB_SpawnCasing("PB_EmptyBrass",22,2,28,Frandom(-2, -1),Frandom(5,8),Frandom(3,4));
		If(pitchdiff > 45 || anglediff > 45 || pitchdiff < -45 || anglediff < -45)
		{
			return;
		}
		If(ricochetdata.HitType == TRACE_HitWall || ricochetdata.HitType == TRACE_HitFloor || ricochetdata.HitType == TRACE_HitCeiling)
		{
			Invoker.Owner.LineAttack(NextShotAngle,8192,NextShotPitch,35,"Pistol","BR45BulletPuff",LAF_ABSPOSITION | LAF_ABSOFFSET,null,NextShotPosition.Z,NextShotPosition.x,NextShotPosition.y);
			let ricochettracer = Invoker.owner.spawn("decorativetracer",nextshotposition);
			If(ricochettracer)
			{
				ricochettracer.angle = nextshotangle;
				ricochettracer.pitch = nextshotpitch;
				ricochettracer.vel3dfromangle(140,nextshotangle,nextshotpitch);
			}
			
		}
	}

    // FIRE FUNCTION
	action void FireWeapon(int weaponSide, int ticCount)
	{
		switch (ticCount)
		{
			//Tic 1
			default:
			case 1:
				A_AlertMonsters();
				//a_FireBattleRifle();
				PB_DynamicTail("lmg", "lmg");
				FireWeaponCheck();
				PB_LowAmmoSoundWarning("default");
				pb_takeammo(invoker.ammotype2,1,0);
				A_StartSound("BR45FIRE", CHAN_WEAPON, 0, 1.0, pitch: 1.2);
				invoker.burstcount++;
				PB_IncrementHeat(4);
				switch (weaponSide)
				{
					default:
					case 0: // NORMAL FIRE
	                	PB_WeaponRecoil(-3,frandom(-0.3,0.3));
						PB_GunSmoke(0,0,-1);
						A_ZoomFactor(1.0, SPF_INTERPOLATE);
						break;
                    case 1: // ADS FIRE
	                	PB_WeaponRecoil(-1.5,frandom(-0.3,0.3));
						PB_GunSmoke(0,0,-2);
						A_SetInventory("CantDoAction",1);
						A_ZoomFactor(3.0, SPF_INTERPOLATE);
						break;
				}
				break;
			//Tic 2
			case 2:
				break;
		}
	}
	
	action void FireWeaponCheck()
	{
		if(countinv("BattleRifle_Upgraded") > 0 || (pbxweapons_backpack_filter & DisablePBX_BattleRifleUpgrade)) {a_FireBattleRifle();}
		else {
			PB_FireBullets("PB_762x51mm", 1, frandom(-0.1, 0.1), 0, 0, frandom(-0.1, 0.1));
        	PB_SpawnCasing("PB_EmptyBrass",22,2,28,Frandom(-2, -1),Frandom(5,8),Frandom(3,4));
		}
	}
	
	States
	{
        // SETUP
        Spawn:
			BR45 A -1;
			stop;

		Steady:
			TNT1 A 1;
			goto Ready;

		Deselect:
			TNT1 A 0 {
				A_Takeinventory("Zoomed",10);
				setADS();
			}
			BR4S ABCDE 1; 
			TNT1 A 0 A_StopSound(1);
			TNT1 A 0 A_StopSound(2);
			TNT1 A 0 A_StopSound(6);
			TNT1 A 1;
            TNT1 A 0 A_lower();
            Wait;
		Select:
			TNT1 A 0 PB_WeaponRaise("BR45PICK");
			TNT1 A 0 PB_RespectIfNeeded();
       	SelectContinue:
			TNT1 A 0;
		SelectAnimation:
			TNT1 A 0 {invoker.burstcount = 0;}
			BR4S EDCBA 1;
			goto WeaponReady;
		
		WeaponRespect:
			BR4S EDCBA 1 A_DoPBWeaponAction();
			BR45 BBB 1 A_DoPBWeaponAction();
			TNT1 A 0 A_startsound("BR45OPEN",3,CHANF_OVERLAP);
            BR4R ABCDE 1 A_DoPBWeaponAction();
			BR4R FGGGGG 1 A_DoPBWeaponAction();
			BR4R GHIJKLMNOP 1 A_DoPBWeaponAction();
			TNT1 A 0 A_startsound("BR45LOAD",3);
			BR4R QRSTUVWX 1 A_DoPBWeaponAction();
			goto WeaponReady;

        // READY STATES
        Ready:
        Ready3:
		WeaponReady:
			TNT1 A 0 A_jumpif(countinv("zoomed") > 0,"WeaponReadyADS");
			BR45 B 1 {
				PB_HandleCrosshair(42);
				PB_CoolDownBarrel();
				if(countinv("BattleRifle_Upgraded") > 0 || (pbxweapons_backpack_filter & DisablePBX_BattleRifleUpgrade))
					BR_ReadyNormal();
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD);
			}
			Loop;
		
		Ready2:
		WeaponReadyADS:
			TNT1 A 0;
			BR4Z D 1 Bright 
            {
				A_SetRoll(0);
                PB_HandleCrosshair(5);
				PB_CoolDownBarrel();
                A_SetInventory("PB_LockScreenTilt",0);
				if(countinv("BattleRifle_Upgraded") > 0 || (pbxweapons_backpack_filter & DisablePBX_BattleRifleUpgrade))
					BR_ReadyScope();
				if(Cvar.GetCvar("pb_toggle_aim_hold",player).getint() == 1) 
				{
					if(!PressingAltfire() || JustReleased(BT_ALTATTACK))
						return resolvestate("ZoomOut");
					
					if (PressingFire() && PressingAltfire() && invoker.ammo2.amount > 0)
							return resolvestate("FireADS");
					
					return A_DoPBWeaponAction(WRF_ALLOWRELOAD|WRF_NOSECONDARY);
					
				}
				else 
				{
					if (PressingFire() && invoker.ammo2.amount > 0)
						return resolvestate("FireADS");
					
					return A_DoPBWeaponAction(WRF_ALLOWRELOAD);
				}
				return resolvestate(null);
            }
			Loop;
		
		//[Pop] Firing states
		Fire:
			TNT1 A 0
			{
				A_WeaponOffset(0, 32);
				A_SetRoll(0);
				PB_HandleCrosshair(42);
				A_SetInventory("PB_LockScreenTilt", 0);
			}
			TNT1 A 0 A_JumpIfInventory("zoomed", 1, "FireADS");
			TNT1 A 0 PB_JumpIfNoAmmo("Reload", 1, false);
			BR4F A 0 A_Jump(85, 3);
			BR4F B 0 A_Jump(85, 2);
			BR4F C 0;
			BR4F "#" 1
			{
				FireWeapon(0, 1);
				FireWeapon(0, 2);
			}
			BR45 D 1
			{
				if (getBRMag() < 1)
					PB_SpawnCasing("RifleClipSpawn");
			}
			// Semi-auto: always go to BurstDone after 1 shot
			// Burst: loop until burstcount hits 3
			TNT1 A 0 A_JumpIf(invoker.isSemiAuto, "BurstDone");
			TNT1 A 0 A_JumpIf(invoker.burstcount < 3, "BurstFireRecoil");
			goto BurstDone;

		BurstDone:
			TNT1 A 0 { invoker.burstcount = 0; }
			BR45 DEFGH 1
			{
				// Track button release
				if (!(player.cmd.buttons & BT_ATTACK))
					invoker.semiclear = true;
				// Refire only if button was released and pressed again
				if (invoker.semiclear && PlayerPressedOnce(BT_ATTACK))
					return resolvestate("Fire");
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOFIRE | WRF_NOPRIMARY);
			}
			TNT1 A 0 { invoker.semiclear = false; }
			goto WeaponReady;

		BurstFireRecoil:
			BR45 EF 1;
			goto Fire;

		//[Pop] because different animations too
		FireADS:
		TNT1 A 0 A_ZoomFactor(3.0);
		TNT1 A 0 PB_JumpIfNoAmmo("ReloadFromADS", 1, false);
		BR4Z D 1 Bright
		{
			FireWeapon(1, 1);
			FireWeapon(1, 2);
		}
		BR4Z D 1 Bright
		{
			if (getBRMag() < 1)
				PB_SpawnCasing("RifleClipSpawn");
		}
		// Same logic as hipfire
		TNT1 A 0 A_JumpIf(invoker.isSemiAuto, "BurstDoneADS");
		TNT1 A 0 A_JumpIf(invoker.burstcount < 3, "BurstFireRecoilADS");
		goto BurstDoneADS;

	BurstDoneADS:
		TNT1 A 0
		{
			invoker.burstcount = 0;
			A_SetInventory("CantDoAction", 0);
		}
		BR4Z DDDDDDDDDDDD 1 Bright
		{
			// Track button release
			if (!(player.cmd.buttons & BT_ATTACK))
				invoker.semiclear = true;
			// Refire only if button was released and repressed
			if (invoker.semiclear && PlayerPressedOnce(BT_ATTACK))
				return resolvestate("FireADS");

			if (Cvar.GetCvar("pb_toggle_aim_hold", player).getint())
			{
				if (JustReleased(BT_ALTATTACK))
					return resolvestate("ZoomOut");
			}
			else
			{
				if (PressingAltfire())
					return resolvestate("ZoomOut");
			}

			return A_DoPBWeaponAction(WRF_ALLOWRELOAD | WRF_NOFIRE | WRF_NOPRIMARY);
		}
		TNT1 A 0 { invoker.semiclear = false; }
		goto WeaponReadyADS;

	BurstFireRecoilADS:
		BR4Z DD 1 Bright;
		goto FireADS;
	
        // ALTFIRE
        AltFire:
            TNT1 A 0 {invoker.LockedOn = false;}
			TNT1 A 0 A_Jumpif(countinv("Zoomed") > 0 && getADS(),"ZoomOut");
		ZoomIn:
            TNT1 A 0 A_giveinventory("Zoomed",1);
			TNT1 A 0 setADS(true);
			TNT1 A 0 A_startsound("IronSights",29);
            BR4Z A 1 A_zoomfactor(1.0);
		    BR4Z B 1 A_zoomfactor(2.0);
			BR4Z C 1 A_zoomfactor(3.0);
            goto WeaponReadyADS;
        ZoomOut:
			TNT1 A 0 A_takeinventory("Zoomed",1);
			TNT1 A 0 setADS(true);
			TNT1 A 0 A_startsound("IronSights",29);
            BR4Z C 1 A_zoomfactor(3.0);
		    BR4Z B 1 A_zoomfactor(2.0);
			BR4Z A 1 A_zoomfactor(1.0);
			goto WeaponReady;

        // RELOAD
		ReloadFromADS:
			TNT1 A 0 A_Zoomfactor(1.0);
			TNT1 A 0 A_takeinventory("Zoomed",10);
		Reload:
			TNT1 A 0 A_ZoomFactor(1.0);
            TNT1 A 0 A_takeinventory("Zoomed",10);
            TNT1 A 0 setADS(false);
            TNT1 A 0 PB_CheckReload("RaiseFromEmpty", null, null, "WeaponReady", "NoAmmo", BR_AmmoFull, 1);
			TNT1 A 0 A_startsound("BR45OPEN",3,CHANF_OVERLAP);
            BR4R ABCDE 1;
            TNT1 A 0
			{
                PB_SetMagUnloaded(true);
                PB_SetMagEmpty(true);
                PB_SetChamberEmpty(true);
                If(getBRMag() > 0)
                    {
						PB_SpawnCasing("RifleClipSpawn");
                        A_fireprojectile("RifleClipSpawn",5,false,0,-14,0);
                    }
			}
            BR4R FGGGGG 1;
        ContinueReload:
			BR4R GHIJKLMNOP 1;
			TNT1 A 0 
			{
				A_startsound("BR45LOAD",3);
				PB_AmmoIntoMag(invoker.ammo2.getclassname(), invoker.ammo1.getclassname(), BR_AmmoFull,1);
                PB_SetMagUnloaded(false);
                PB_SetMagEmpty(false);
                PB_SetChamberEmpty(false);
			}
			BR4R QRSTUVWX 1;
            TNT1 A 0 PB_SetReloading(false);
			goto WeaponReady;

        RaiseFromEmpty:
            TNT1 A 0 A_ZoomFactor(1.0);
			TNT1 A 0 A_startsound("BR45OPEN",3,CHANF_OVERLAP);
            BR4R ABCDEF 1;
            goto ContinueReload;
		
		Unload:
			TNT1 A 0 A_Jumpif(pb_getmagunloaded() || getBRMag() < 1,"WeaponReady");
			TNT1 A 0 A_startsound("BR45OPEN",3,CHANF_OVERLAP);
            BR4R ABCDE 1;
            TNT1 A 0
			{
				If(getBRMag() > 0)
					{
						PB_UnloadMag(invoker.ammotype2, invoker.ammotype1, 1);
						PB_SpawnCasing("RifleClipSpawn");
						// A_fireprojectile("RifleClipSpawn",5,false,0,-14,0);
						PB_SetMagUnloaded(true);
						PB_SetMagEmpty(true);
						PB_SetChamberEmpty(true);
					}
			}
            BR4R STUVWX 1;
            goto WeaponReady;

		NoAmmo:
			BR45 B 1 A_StartSound("weapons/empty");
			goto WeaponReady;

		SpecialFromADS:
			TNT1 A 0 A_Takeinventory("GoWeaponSpecialAbility",1);
			goto ActualModeChange;
		Weaponspecial:
			TNT1 A 0 A_JumpIf(countinv("Zoomed") > 0 && getADS(),"SpecialFromADS");
			TNT1 A 0 {
				A_Takeinventory("GoWeaponSpecialAbility",1);
				A_Takeinventory("Zoomed",1);
				A_Takeinventory("ADSmode",1);
				A_ZoomFactor(1.0);
			}
		ActualModeChange:
			TNT1 A 0 {
				if((findinventory("BR_Select_Semi") && getSemiAuto()) || 
				(findinventory("BR_Select_Burst") && !getSemiAuto()))
				{
					A_print("$PBX_AlreadySelected");
					cleanmodetokens();
					return resolvestate("ready3");
				}
				
				if(findinventory("BR_Select_Semi"))
				{
					setSemiAuto(true);
					cleanmodetokens();
					A_Print("$PBX_BattleRifle_SemiAuto");
				}
				if(findinventory("BR_Select_Burst"))
				{
					setSemiAuto(false);
					cleanmodetokens();
					A_Print("$PBX_BattleRifle_Burst");
				}

				if(countinv("Zoomed") > 0 && getADS())
				{
					A_StartSound("MS/Button", 26);
				}

				return resolvestate(null);
			}
			TNT1 A 0 A_JumpIf(countinv("Zoomed") > 0 && getADS(),"WeaponReadyADS");
        SwitchAnimation:
            BR4R ABCDEFG 1;
            TNT1 A 0 A_StartSound("MS/Button", 26);
			BR4R GFEDCBA 1;
			goto WeaponReady;
		
        // FLASH STATES
        FlashPunching:
            BR4K ABCD 1;
		    BR4K E 13;
		    BR4K DCBA 1; //14 frames
            goto WeaponReady;

		FlashKicking:
			BR4K ABCD 1;
		    BR4K E 13;
		    BR4K DCBA 1; //15 frames
			goto WeaponReady;
			
		FlashAirKicking:
			BR4K ABCD 1;
		    BR4K E 14;
		    BR4K DCBA 1; //16 frames
			goto WeaponReady;
			
		FlashSlideKicking:
			BR4K A 1; 
			BR4K B 2; 
			BR4K C 4;
			BR4K D 6; 
			BR4K E 7; 
			BR4K D 3; 
			BR4K C 2;
			BR4K B 1;
			BR4K A 1; //27 frames
			goto WeaponReady;
			
		FlashSlideKickingStop:
			BR4K EDCBAAA 7; //7 frames 
			goto WeaponReady;
	}
	
	// OVERRRIDES
	override void postbeginplay()
	{
		isADS = false;
		LockedOn = false;
		semiClear = false;
		isSemiAuto = true;
		super.postbeginplay();
	}
	
}