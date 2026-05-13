extend class PBX_BDPBattleRifle
{
//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////
	override void postbeginplay()
	{
		isADS = false;
		LockedOn = false;
		semiClear = false;
		isSemiAuto = true;
		super.postbeginplay();
	}
    
//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////
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
                PBXWeapons_ScopeHandler.SendInterfaceEvent(self.PlayerNumber(), "PrintScopeData:"..Bule.HitActor.GetTag(), Bule.HitActor.health, Bule.HitActor.GetSpawnHealth(), Bule.HitActor.PainChance);
                PBXWeapons_ScopeHandler.SendInterfaceEvent(self.PlayerNumber(), "PrintScopeData2:", Distance3D(Bule.HitActor), 3.0);
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
}