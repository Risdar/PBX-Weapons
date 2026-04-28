const neohmgFullAmmo = 80;
const neohmgShieldAmmo = 100;

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
		PB_WeaponBase.MaxOverheat 400;
		PB_WeaponBase.OverheatCoolingRate 4;

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
	const HMG_SHIELDLAYER = -567;
	const HMG_SHIELDSOUNDLAYER = 234;
	const HMG_SHIELDSOUNDLAYER2 = 233;

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
	const shieldProtectionMultiplier = 1; // How many shield charges are consumed per point of damage (Multiplier)
	const shieldRechargeSpeed = 1; // How many tics before giving the shield charge
	const shieldRechargeRate = 5; // How many shield charges to give each tic
	const shieldCooldown = 15; // How many tics before shield is available again

	// Modes
	int ammoType;
	enum NeoHMGRounds
	{
		eHeatedRounds = 0,
        eChargedRounds = 1
	}

//////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////

	action void cleanmodetokens()
    {
        A_SetInventory("HMG_Select_Heated",  0);
        A_SetInventory("HMG_Select_Charged", 0);
    }

	action state HMG_HandleSpecial()
    {
        bool alreadyHeated  = FindInventory("HMG_Select_Heated")  && getAmmoType() == eHeatedRounds;
        bool alreadyCharged = FindInventory("HMG_Select_Charged") && getAmmoType() == eChargedRounds;

        if (alreadyHeated || alreadyCharged)
        {
            A_Print("$PBX_AlreadySelected");
            cleanmodetokens();
            return resolvestate("Ready3");
        }

        if (FindInventory("HMG_Select_Heated"))
        {
            setAmmoType(eHeatedRounds);
            A_Print("$PBX_NeoHMG_Heated");
        }
        else if (FindInventory("HMG_Select_Charged"))
        {
            setAmmoType(eChargedRounds);
            A_Print("$PBX_NeoHMG_Charged");
        }

        cleanmodetokens();
        return resolvestate(null);
    }

	action int getAmmoType()
	{
		return invoker.ammoType;
	}

	action int setAmmoType(int set)
	{
		return invoker.ammoType = set;
	}

	action void HMG_fireBullet()
	{
		string loadedbullets;
		string soundtouse;
		
		if(PB_GetOverheat() > 115)
		{
			switch(getAmmoType())
			{
				default:
				case eHeatedRounds:
					loadedbullets = "PB_792x57mm_Heated";
					soundtouse = "MG42FIR";
					break;
				case eChargedRounds:
					loadedbullets = "PB_792x57mm_Charged";
					soundtouse = "PLSM9";
					break;
			}
		}
		else
		{
			loadedbullets = "PB_792x57mm";
			soundtouse = "weapon/HMG/Fire";
		}
		A_Startsound(soundtouse,30);
		PB_FireBullets(loadedbullets, 1, 3, 0, 0, 2.5);
	}

	action void fireHMG(int weaponSide, int ticCount)
	{
		switch (ticCount)
		{
			//Tic 1
			default:
			case 1:
				A_AlertMonsters();
				switch (weaponSide)
				{
					default:
					case 0:
                        // SETUP
						A_WeaponOffset(0,32);
                        A_SetRoll(0);
                        A_TakeInventory("PB_LockScreenTilt",1);
                        // ACTUAL FIRING
						HMG_fireBullet();
						PB_DynamicTail("lmg", "lmg");
						A_overlay(-7,"MuzzleFlash");
						PB_WeaponRecoil(-1.1,frandom(-0.82,0.82));
						PB_IncrementHeat(2);
						PB_GunSmoke(0, 0, 0);
						PB_LowAmmoSoundWarning("hdmr");
						PB_FireOffset();
						A_QuakeEx(0,1,0,12,0,10,"",QF_WAVE|QF_RELATIVE|QF_SCALEDOWN,0.6,0,0.2,0,0,0.3,0.40);
						A_Zoomfactor(0.985);
                        // TAKE AMMO
				        PB_LowAmmoSoundWarning();
				        pb_takeammo(invoker.ammotype2,1,0);
                        break;
				}
			//Tic 2
			case 2:
				PB_ModifyOverheat(5);
				A_ZoomFactor(1.0, SPF_INTERPOLATE);
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

//////////////////////////// OVERRIDES ////////////////////////////////////////////////////////////////////////////////////
    
	override void postbeginplay()
	{
		ammoType = eHeatedRounds;
		shieldReady = true;
		giveinventory("HMGShield", neohmgShieldAmmo);
		super.postbeginplay();
	}

	override void ModifyDamage(int damage, Name damageType, out int newDamage, bool passive, Actor inflictor, Actor source, int flags)
    {
		if (passive && damage > 0)
		{
			shieldDrain = clamp(int(damage * shieldProtectionMultiplier), 1, neohmgShieldAmmo);
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
			If(shieldwasactive)
			{
				owner.Player.SetPSprite(HMG_SHIELDLAYER,resolvestate("HMGShieldBreak"));
				owner.A_startsound("HMGSHLD4",HMG_SHIELDSOUNDLAYER);
				owner.a_startsound("StickyGrenade/Hit",125,0,0.5);
				Shieldtimer = shieldCooldown;
				shieldready = false;
				If(countinv("HMGShield") < 1)
				{
					shieldbroken = true;
					owner.A_startsound("HMGSHLD1",HMG_SHIELDSOUNDLAYER);
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

//////////////////////////// STATES ////////////////////////////////////////////////////////////////////////////////////
	States
	{
//////////////////////////// SETUP ////////////////////////////////////////////////////////////////////////////////////
		Spawn:
            HG0W A -1;
            Stop;
        Steady:
            TNT1 A 0;
            Goto Ready;
        Deselect:
            HG0D ABCD 1;
			TNT1 A 0 A_lower(120);	
			wait;
		WeaponRespect:
			HG0U ABCD 1 A_DoPBWeaponAction();
			goto ready3;
		Select:
			TNT1 A 0 PB_WeaponRaise("weapon/HMG/Stop");
			TNT1 A 0 PB_WeapTokenSwitch("CarbineSelected");
			TNT1 A 0 A_Overlay(3,"Cooling",true);
			TNT1 A 0 PB_RespectIfNeeded();
		SelectContinue:
			TNT1 A 0;
		SelectAnimation:
			TNT1 A 0 {if(PB_GetOverheat() > 1) {A_Overlay(3, "Cooling",true);}}
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(), "UnloadedSelect");
			HG0U ABCD 1;
//////////////////////////// READY ////////////////////////////////////////////////////////////////////////////////////
		Ready3:
			"####" A 0 {
				if(PB_GetOverheat() > 1) {A_Overlay(3, "Cooling",true);}
				PB_HandleCrosshair(52);
			}
		ReadyToFire:
			// Load Sprites
			XH01 A 0;
			XH02 A 0;
			XH03 A 0;
			XH04 A 0;
			// Actual Code
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(), "ReadyUnload");
			HG0F A 1 {
				PB_CoolDownBarrel(0, 0, 3);
				if (invoker.ammo2.amount == 4 )	{A_SetWeaponSprite("XH04");}
				if (invoker.ammo2.amount == 3 )	{A_SetWeaponSprite("XH03");}
				if (invoker.ammo2.amount == 2 )	{A_SetWeaponSprite("XH02");}
				if (invoker.ammo2.amount <= 1 )	{A_SetWeaponSprite("XH01");}
				if (invoker.ammo2.amount == 0 )	{A_SetWeaponSprite("XH01");}
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD); 
			}
			loop;
		
		ReadyUnload:
			HG0R R 1 {
				PB_CoolDownBarrel(0, 0, 3);
				PB_HandleCrosshair(52);
				return A_DoPBWeaponAction(WRF_ALLOWRELOAD); 
			}
			loop;

		UnloadedSelect:
			HG0R MNOPQRS 1;
			goto ReadyUnload;
        
//////////////////////////// FIRE ////////////////////////////////////////////////////////////////////////////////////
		Fire:
			// Load Sprites
			XH01 BCDEF 0;
			XH02 BCDEF 0;
			XH03 BCDEF 0;
			XH04 EF 0;
			// Actual Code
			TNT1 A 0 PB_HandleCrosshair(52);
            TNT1 A 0 PB_jumpIfNoAmmo("Reload",1,false);
			HG0F B 1 bright {
				if (invoker.ammo2.amount == 3 )	{A_SetWeaponSprite("XH03");}
				if (invoker.ammo2.amount == 2 )	{A_SetWeaponSprite("XH02");}
				if (invoker.ammo2.amount <= 1 )	{A_SetWeaponSprite("XH01");}
				if (invoker.ammo2.amount == 0 )	{A_SetWeaponSprite("XH01");}
				return fireHMG(0,1);
			}
			HG0F C 1 bright {
				if (invoker.ammo2.amount == 3 )	{A_SetWeaponSprite("XH03");}
				if (invoker.ammo2.amount == 2 )	{A_SetWeaponSprite("XH02");}
				if (invoker.ammo2.amount <= 1 )	{A_SetWeaponSprite("XH01");}
				if (invoker.ammo2.amount == 0 )	{A_SetWeaponSprite("XH01");}
				return fireHMG(0,2);
			}
			HG0F D 1 {
				if (invoker.ammo2.amount == 3 )	{A_SetWeaponSprite("XH03");}
				if (invoker.ammo2.amount == 2 )	{A_SetWeaponSprite("XH02");}
				if (invoker.ammo2.amount <= 1 )	{A_SetWeaponSprite("XH01");}
				if (invoker.ammo2.amount == 0 )	{A_SetWeaponSprite("XH01");}
			}
			HG0F E 1 {
				if (invoker.ammo2.amount == 4 )	{A_SetWeaponSprite("XH04");}
				if (invoker.ammo2.amount == 3 )	{A_SetWeaponSprite("XH03");}
				if (invoker.ammo2.amount == 2 )	{A_SetWeaponSprite("XH02");}
				if (invoker.ammo2.amount <= 1 )	{A_SetWeaponSprite("XH01");}
				if (invoker.ammo2.amount == 0 )	{A_SetWeaponSprite("XH01");}
			}
			TNT1 A 0 A_Weaponoffset(0,32);
			HG0F F 1 {
				if (invoker.ammo2.amount == 4 )	{A_SetWeaponSprite("XH04");}
				if (invoker.ammo2.amount == 3 )	{A_SetWeaponSprite("XH03");}
				if (invoker.ammo2.amount == 2 )	{A_SetWeaponSprite("XH02");}
				if (invoker.ammo2.amount <= 1 )	{A_SetWeaponSprite("XH01");}
				if (invoker.ammo2.amount == 0 )	{A_SetWeaponSprite("XH01");}
				return A_refire();
			}
			TNT1 A 0 A_startsound("weapon/HMG/Stop",32);
			goto Ready3;

		AltFire:
			goto Ready3;
		HMGShieldBash:
			PSHL E 0 A_FireProjectile("KickAttack");
		HMGShield:
			TNT1 A 0 
			{
				If(random(0,1) == 1)
					{
						A_OverlayFlags(HMG_SHIELDLAYER,PSPF_FLIP,true);
					}
					Else
					{
						A_OverlayFlags(HMG_SHIELDLAYER,PSPF_FLIP,false);
					}
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
			TNT1 A 0 PB_checkReload("RaiseFromEmpty", null, null, "Ready","Ready",neohmgFullAmmo,1);
			TNT1 A 0 A_Overlay(3,"Cooling",true);
			HG0R ABCDE 1 {
				if (invoker.ammo2.amount == 4 )	{A_SetWeaponSprite("XHR4");}
				if (invoker.ammo2.amount == 3 )	{A_SetWeaponSprite("XHR3");}
				if (invoker.ammo2.amount == 2 )	{A_SetWeaponSprite("XHR2");}
				if (invoker.ammo2.amount <= 1 )	{A_SetWeaponSprite("XHR1");}
				if (invoker.ammo2.amount == 0 )	{A_SetWeaponSprite("XHR1");}
			}
			HG0R FGH 1 {
				if (invoker.ammo2.amount == 3 )	{A_SetWeaponSprite("XHR3");}
				if (invoker.ammo2.amount == 2 )	{A_SetWeaponSprite("XHR2");}
				if (invoker.ammo2.amount <= 1 )	{A_SetWeaponSprite("XHR1");}
				if (invoker.ammo2.amount == 0 )	{A_SetWeaponSprite("XHR1");}
			}
			TNT1 A 0 A_StartSound("weapons/sgl/detach",33);
			TNT1 A 0 A_JumpIf(PB_GetMagUnloaded(),"Reload_Unloaded");
			TNT1 A 0 {
				if(invoker.ammo2.amount < 1 && !PB_GetMagUnloaded())
					PB_SpawnCasing("EmptyLMGMag", 12, -2.5, 6.25,frandom(2,5),frandom(1,3),frandom(2,4));
					//A_Spawnitem("EmptyLMGMag");EmptyLMGMissileMag
			}
			HG0R I 1 {
				if (invoker.ammo2.amount == 3 )	{A_SetWeaponSprite("XHR3");}
				if (invoker.ammo2.amount == 2 )	{A_SetWeaponSprite("XHR2");}
				if (invoker.ammo2.amount <= 1 )	{A_SetWeaponSprite("XHR1");}
				if (invoker.ammo2.amount == 0 )	{A_SetWeaponSprite("XHR1");}
			}
			HG0R JK 1;
			HG0R L 1 {
				PB_SetMagUnloaded(true);
				PB_SetChamberEmpty(true);
			}
			HG0R MNOOPP 1;
			HG0R QQQ 1;
			HG0R QRST 1;
		Reload_Unloaded:	
			TNT1 A 0 A_Startsound("weapon/HMG/Reload1",34);
			HG0R U 1;
			HG0R V 1 {
				if (invoker.ammo2.amount == 4 )	{A_SetWeaponSprite("XHR4");}
				if (invoker.ammo2.amount == 3 )	{A_SetWeaponSprite("XHR3");}
				if (invoker.ammo2.amount == 2 )	{A_SetWeaponSprite("XHR2");}
				if (invoker.ammo2.amount <= 1 )	{A_SetWeaponSprite("XHR1");}
				if (invoker.ammo2.amount == 0 )	{A_SetWeaponSprite("XHR1");}
			}
			TNT1 A 0 {
				PB_AmmoIntoMag(invoker.ammo2.getclassname(),invoker.ammo1.getclassname(),neohmgFullAmmo,1);
				PB_SetMagEmpty(false);
				PB_SetMagUnloaded(false);
				PB_SetChamberEmpty(false);
			}
			HG0R W 1 {
				if (invoker.ammo2.amount == 4 )	{A_SetWeaponSprite("XHR4");}
				if (invoker.ammo2.amount == 3 )	{A_SetWeaponSprite("XHR3");}
				if (invoker.ammo2.amount == 2 )	{A_SetWeaponSprite("XHR2");}
				if (invoker.ammo2.amount <= 1 )	{A_SetWeaponSprite("XHR1");}
				if (invoker.ammo2.amount == 0 )	{A_SetWeaponSprite("XHR1");}
			}
			HG0R XX 1 {
				if (invoker.ammo2.amount == 4 )	{A_SetWeaponSprite("XHR4");}
				if (invoker.ammo2.amount == 3 )	{A_SetWeaponSprite("XHR3");}
				if (invoker.ammo2.amount == 2 )	{A_SetWeaponSprite("XHR2");}
				if (invoker.ammo2.amount <= 1 )	{A_SetWeaponSprite("XHR1");}
				if (invoker.ammo2.amount == 0 )	{A_SetWeaponSprite("XHR1");}
			}
			HG0R YYZ 1 {
				if (invoker.ammo2.amount == 4 )	{A_SetWeaponSprite("XHR4");}
				if (invoker.ammo2.amount == 3 )	{A_SetWeaponSprite("XHR3");}
				if (invoker.ammo2.amount == 2 )	{A_SetWeaponSprite("XHR2");}
				if (invoker.ammo2.amount <= 1 )	{A_SetWeaponSprite("XHR1");}
				if (invoker.ammo2.amount == 0 )	{A_SetWeaponSprite("XHR1");}
			}
			HG1R ABC 1 {
				if (invoker.ammo2.amount == 4 )	{A_SetWeaponSprite("XH4R");}
				if (invoker.ammo2.amount == 3 )	{A_SetWeaponSprite("XH3R");}
				if (invoker.ammo2.amount == 2 )	{A_SetWeaponSprite("XH2R");}
				if (invoker.ammo2.amount <= 1 )	{A_SetWeaponSprite("XH1R");}
				if (invoker.ammo2.amount == 0 )	{A_SetWeaponSprite("XH1R");}
			}
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
			HG0R ABCDE 1 {
				if (invoker.ammo2.amount == 4 )	{A_SetWeaponSprite("XHR4");}
				if (invoker.ammo2.amount == 3 )	{A_SetWeaponSprite("XHR3");}
				if (invoker.ammo2.amount == 2 )	{A_SetWeaponSprite("XHR2");}
				if (invoker.ammo2.amount <= 1 )	{A_SetWeaponSprite("XHR1");}
				if (invoker.ammo2.amount == 0 )	{A_SetWeaponSprite("XHR1");}
			}
			HG0R FGH 1 {
				if (invoker.ammo2.amount == 3 )	{A_SetWeaponSprite("XHR3");}
				if (invoker.ammo2.amount == 2 )	{A_SetWeaponSprite("XHR2");}
				if (invoker.ammo2.amount <= 1 )	{A_SetWeaponSprite("XHR1");}
				if (invoker.ammo2.amount == 0 )	{A_SetWeaponSprite("XHR1");}
			}
			TNT1 A 0 A_StartSound("weapons/sgl/detach", 33);
			HG0R I 1 {
				if (invoker.ammo2.amount == 3 )	{A_SetWeaponSprite("XHR3");}
				if (invoker.ammo2.amount == 2 )	{A_SetWeaponSprite("XHR2");}
				if (invoker.ammo2.amount <= 1 )	{A_SetWeaponSprite("XHR1");}
				if (invoker.ammo2.amount == 0 )	{A_SetWeaponSprite("XHR1");}
			}
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
            TNT1 A 0 A_PlaySound("excavator/switch");		
			HG0U CCDDDD 1;
			goto Ready3;
		
//////////////////////////// FLASH STATES ////////////////////////////////////////////////////////////////////////////////////
		FlashPunching:
			TNT1 A 0 A_Overlay(3,"Cooling",true);
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
			TNT1 A 8;
			TNT1 A 4 PB_ModifyOverheat(-5);
			Wait;

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
}

