extend class PBX_NeoHMG
{
//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////    
	override void postbeginplay()
	{
		ammoType = eHeatedRounds;
		shieldReady = true;
		isOverheating = false;
		giveinventory("HMGShield", PBX_NeoHMG.SHIELD_MAXCHARGE);
		super.postbeginplay();
	}

	override void ModifyDamage(int damage, Name damageType, out int newDamage, bool passive, Actor inflictor, Actor source, int flags)
    {
		if (passive && damage > 0)
		{
			shieldDrain = clamp(int(damage * shieldProtectionMultiplier), 1, PBX_NeoHMG.SHIELD_MAXCHARGE);
			// console.printf("Damage dealt");
			if (owner.player && owner.player.readyweapon is "PBX_NeoHMG" && shieldWasActive)
			{
				// console.printf("Blocked damage");
				owner.TakeInventory("HMGShield", shieldDrain);
				owner.A_StartSound("StickyGrenade/Hit", 125);
				newDamage = 0;
			}
		}

    }
    
	override void DoEffect() 
	{
		super.DoEffect();
		If(	owner.player 
			&& owner.player.readyweapon is "PBX_NeoHMG" 
			&& owner.player.cmd.buttons & BT_ALTATTACK 
			&& shieldready 
			&& countinv("HMGShield") > 0)
		{
			owner.Player.SetPSprite(HMG_SHIELDLAYER,resolvestate("HMGShield"));
			If(!shieldwasactive)
			{
				owner.Player.SetPSprite(HMG_SHIELDLAYER,resolvestate("HMGShieldBash"));
				owner.A_startsound("HMGSHLD3",HMG_SHIELDSOUNDLAYER);
			}
			shieldwasactive = true;
			Shieldactive = true;
			owner.bnoblood = true;
			
			//console.printf("Shield active wooo");
		}
		else if(owner.player)
		{
			Shieldactive = false;
			owner.bnoblood = false;
			If(shieldwasactive && owner.player.readyweapon is "PBX_NeoHMG")
			{
				owner.Player.SetPSprite(HMG_SHIELDLAYER,resolvestate("HMGShieldBreak"));
				owner.A_startsound("HMGSHLD4",HMG_SHIELDSOUNDLAYER);
				owner.a_startsound("StickyGrenade/Hit",125,0,0.5);
				Shieldtimer = shieldCooldown;
				shieldready = false;
				If(countinv("HMGShield") < 1)
				{
					shieldbroken = true;
					EventHandler.SendInterfaceEvent(PlayerNumber(), "PB_HUDInterference", 20);
					owner.A_startsound("HMGSHLD1",HMG_SHIELDSOUNDLAYER);
					owner.Player.SetPSprite(HMG_SHIELDLAYER,resolvestate("HMGShieldBroken"));
				}
				shieldwasactive = false;
			}
			If(shieldtimer > 0)
			{
				shieldtimer--;
			}
			Else if(!shieldbroken && !shieldready)
			{
				shieldready = true;
				
				If(owner.player && owner.player.readyweapon is "PBX_NeoHMG")
				{
					owner.A_startsound("HMGSHLD",HMG_SHIELDSOUNDLAYER2);
				}
			}
			If(ShieldTimer < 1)
			{
				If(rechargetimer < shieldRechargeSpeed)
				{
					rechargetimer++;
				}
				Else if(countinv("HMGShield") < 100)
				{
					rechargetimer = 0;
					giveinventory("HMGShield",shieldRechargeRate);
				}
				Else if(shieldbroken)
				{
					ShieldBroken = false;
					ShieldReady = true;
					// ChangeAmmoIcon2("ASGSA0");
					If(owner.player && owner.player.readyweapon is "PBX_NeoHMG")
					{
						owner.A_startsound("HMGSHLD",HMG_SHIELDSOUNDLAYER2);
					}
				}
			}
		}
	}

//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////
	action void cleanmodetokens()
    {
        A_SetInventory("HMG_Select_Heated",  0);
        A_SetInventory("HMG_Select_Charged", 0);
    }

	action state HMG_HandleSpecial()
    {
        bool goHeated  = CountInv("HMG_Select_Heated") > 0;
        bool goCharged = CountInv("HMG_Select_Charged") > 0;
        bool alreadyHeated  = goHeated  && getAmmoType() == eHeatedRounds;
        bool alreadyCharged = goCharged && getAmmoType() == eChargedRounds;

		if(countinv("PBX_CloseWheel") > 0)
		{
			A_TakeInventory("PBX_CloseWheel",1);
			return resolvestate("Ready3");
		}

        if (alreadyHeated || alreadyCharged)
        {
            A_Print("$PBX_AlreadySelected");
            cleanmodetokens();
            return resolvestate("Ready3");
        }

        if (goHeated)
        {
            setAmmoType(eHeatedRounds);
            A_Print("$PBX_NeoHMG_Heated");
        }

        if (goCharged)
        {
            setAmmoType(eChargedRounds);
            A_Print("$PBX_NeoHMG_Charged");
        }

        cleanmodetokens();
        return resolvestate(null);
    }

	action void HMG_CoolDownBarrel()
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

	action void cooldownOverheat()
	{
		A_Overlay(OVERHEATCOOLING_LAYER,"Cooling",true);
	}

	action int getAmmoType()
	{
		return invoker.ammoType;
	}

	action int setAmmoType(int set)
	{
		return invoker.ammoType = set;
	}

	action void HMG_fireBullet(bool overheating)
	{
		string loadedbullets;
		string soundtouse;
		double spread;

		if(overheating)	
						spread = 7;
		else if(PB_GetOverheat() > OVERHEAT_THRESHOLD) 
						spread = 1.0 + (PB_GetOverheat() / 100.0);
		else			spread = 3;
		
		if(PB_GetOverheat() > OVERHEAT_THRESHOLD)
		{
			invoker.isOverheating = true;
			switch(getAmmoType())
			{
				default:
				case eHeatedRounds:
					loadedbullets = "PB_792x57mm_Heated";
					soundtouse = "MG42FIR";
					break;
				case eChargedRounds:
					loadedbullets = "PB_792x57mm_Charged";
					soundtouse = "LFIRE";
					break;
			}
		}
		else
		{
			loadedbullets = "PB_792x57mm";
			soundtouse = "weapon/HMG/Fire";
		}
		A_Startsound(soundtouse,30);
		PB_FireBullets(loadedbullets, 1, spread, 0, 0, spread);
	}

	action void setMagSprite(
		name l4, 
		name l3, 
		name l2, 
		name l1
	)
	{
		int ammo = invoker.ammo2.amount;
		if		(ammo == 4) A_SetWeaponSpriteEx(l4);
		else if (ammo == 3) A_SetWeaponSpriteEx(l3);
		else if (ammo == 2) A_SetWeaponSpriteEx(l2);
		else if (ammo <= 1)	A_SetWeaponSpriteEx(l1);
	}

	action void fireHMG(int ticCount)
	{
		bool overheating = invoker.isOverheating;

		switch (ticCount)
		{
			case 1:
				// SETUP
				A_AlertMonsters();
				A_WeaponOffset(0,32);
				PB_SetRoll(0);
				A_TakeInventory("PB_LockScreenTilt",1);
				// ACTUAL FIRING
				HMG_fireBullet(overheating);
				PB_DynamicTail("lmg", "lmg");
				A_FlashOverlay();
				PB_WeaponRecoil(-1.1,frandom(-0.82,0.82));
				PB_IncrementHeat(2);
				PB_GunSmoke(0, 0, 0);
				PB_LowAmmoSoundWarning("hdmr");
				PB_FireOffset();
				A_QuakeEx(0,1,0,12,0,10,"",QF_WAVE|QF_RELATIVE|QF_SCALEDOWN,0.6,0,0.2,0,0,0.3,0.40);
				A_Zoomfactor(0.95);
				// TAKE AMMO
				PB_LowAmmoSoundWarning();
				pb_takeammo(invoker.ammotype2,1,0);
				break;
			//Tic 2
			case 2:
				// console.printf("given overheat");
				PB_ModifyOverheat(overheating ? OVERHEAT_GIVE_OVR : OVERHEAT_GIVE_NORM);
				// A_ZoomFactor(1.0, SPF_INTERPOLATE);
				break;
		}
	}
	
	action void A_FireVisualThinker(class<VisualThinker> thinker, int speed = 0, double offsetangle = 0, double offsetpitch = 0, double offsetx = 0, double offsety = 0, double offsetz = 0, bool rvel = true)	
	{
		let thonk = Level.SpawnVisualThinker(thinker);
		if(thonk)
		{
			BDPGMQuaternion base = BDPGMQuaternion.createFromAngles(angle,pitch,roll);
			BDPGMQuaternion angl = BDPGMQuaternion.createFromAngles(offsetangle,0,0);
			BDPGMQuaternion ptch = BDPGMQuaternion.createFromAngles(0,offsetpitch,0);
			BDPGMQuaternion rotated = base.multiplyQuat(angl).multiplyQuat(ptch);
			Vector3 dir;
			[dir.x, dir.y, dir.z] = rotated.toAngles();
			quat ofsbase = Quat.FromAngles(angle, pitch, roll);
			Vector3 offset = (offsety, -offsetx, offsetz);
			Vector3 ppos = ofsbase * offset;
			Vector3 ofs = level.Vec3Offset(pos, ppos);
			thonk.pos = ofs;
			thonk.pos.z += player.mo.height * 0.5 - player.mo.floorclip + player.mo.AttackZOffset*player.crouchFactor - 4 + offsetz; //i want to die
			invoker.Vel3DFromAngle(speed,dir.x,dir.y);
			thonk.vel = invoker.vel;
			invoker.Vel3DFromAngle(clamp(speed/2,0,player.mo.radius),dir.x,dir.y);
			thonk.pos += invoker.vel;
			if(rvel)
			{
				thonk.vel += player.mo.vel;
			}
		}
	}

	action void A_FireShieldParticles()
	{
		for(int i = 40; i > 0; i--)
		{
			A_FireVisualThinker("ShieldParticle", i > 40 / 2 ? 2 : 4,random(-4,4),random(-20,20),frandom(-20,20),10,frandom(0,6));
		}
	}

}