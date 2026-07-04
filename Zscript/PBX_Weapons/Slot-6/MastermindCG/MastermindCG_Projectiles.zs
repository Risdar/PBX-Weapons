class MastermindCGProjectile : PB_MasterMindTracer
{
	Default
	{
		+RIPPER;
		PB_Projectile.BaseDamage 200;
		PB_Projectile.RipperCount 1;
        PB_Projectile.PenetrationCount 3;
		Species "Marines";
	}
}

// The code homing code is from Gun Bonsai
class MastermindCG_SoulSeeker : MastermindCGProjectile
{
	Default
	{
		+RIPPER;
		PB_Projectile.BaseDamage 150;
		// PB_Projectile.RipperCount 1;
		// PB_Projectile.PenetrationCount 3;
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();

		let aux = HomingShots_Aux(GiveInventoryType("HomingShots_Aux"));
		if (aux)
		{
			aux.level = 16; // adjusts how strong is the homing
			aux.SetStateLabel("Homing");
		}
	}

	override void OnDestroy()
	{
		Super.OnDestroy();

		// Remove the homing aux if we die
		Inventory aux = FindInventory("HomingShots_Aux");
		if (aux) aux.Destroy();
	}
}

class HomingShots_Aux : Inventory 
{
	uint level;

	States 
	{
	Homing:
		TNT1 A 0 DoHoming();
		TNT1 A 2;
		LOOP;
	}

	// Check if we're in the terminal homing phase of flight. In order to qualify
	// we need to have a target, have a clear line of sight to it, and to have
	// passed those checks twice in a row.
	bool TerminalHoming() 
	{
		return owner.tracer && owner.CheckLOF(
			0, // flags
			64+level*32, // range, 2m + 1m/level
			0, // minrange
			0, 0, // angles
			0, 0, // offset
			AAPTR_TRACER
		);
	}

	void DoHoming() 
	{
		if (!owner) 
		{
			// Our owning projectile vanished. Ideally this should have destroyed us
			// as well, but sometimes that doesn't happen.
			Destroy();
			return;
		}

		// This is kind of gross.
		// Ideally, we'd just call A_SeekerMissile and let it do its thing. However,
		// when it acquires a lock on something it adjusts the Z velocity without
		// any concern for the maximum turn angle settings, which results in a lot
		// of flying directly into a wall/ceiling.

		// So instead, when we're in target-seek mode, we save our current vectors
		// and call A_SeekerMissile() to find a target, then restore the old vectors
		// so even if we find a target the shot continues to fly straight.
		// Note that in some cases, even if it can't acquire a lock (tracer=null after
		// it returns), it'll still fuck with our vectors!
		if (!TerminalHoming()) 
		{
			//   DEBUG("%s: terminal: no, tracer: %s", TAG(owner), TAG(owner.tracer));
			owner.tracer = null;
			let vel = owner.vel;
			let angle = owner.angle;
			owner.A_SeekerMissile(
			0, // terminal homing cone radius
			1, // max turn angle per tic, degrees
			SMF_LOOK | SMF_PRECISE | SMF_CURSPEED,
			min(level*256, 256), // chance of acquiring a new target if it doesn't have one
			min(ceil((64 + level*32)/128.0), 8)); // scan range for new targets in blocks
			// Reject anything that is not a PB_Monster
			if (owner.tracer && !(owner.tracer is "PB_Monster"))
				owner.tracer = null;
			owner.vel = vel;
			owner.angle = angle;
		} 
		else 
		{
			//   DEBUG("%s: terminal: yes, tracer: %s", TAG(owner), TAG(owner.tracer));
			// If we get here we are in "terminal homing mode", which means that:
			// - we have a target
			// - the target is within our terminal homing radius, which depends on
			//   the upgrade level
			// - we have a clear line of sight to the target
			// - all of these conditions have been true two updates in a row
			// which means we should let A_SeekerMissile take over flight control and
			// guide us in.
			owner.A_SeekerMissile(
				0, // terminal homing cone radius
				min(level, 90), // max turn angle per tic, degrees
				SMF_PRECISE | SMF_CURSPEED
			);
		}

		if (owner.tracer != null && pbxweapons_debug)
		{
			if(owner.tracer.CountInv("PBX_RadiusVisualizer") < 1)
			{
				owner.tracer.GiveInventory("PBX_RadiusVisualizer",1);
			}
			// actor Wireframe = Spawn("PBX_CubeRadius2", owner.tracer.pos);
			// if(Wireframe)
			// {
			// 	Wireframe.scale.x = double(owner.tracer.Radius) * 2;
			// 	Wireframe.scale.Y = double(owner.tracer.Height);
			// 	Wireframe.vel = owner.tracer.vel;
			// }
		}
	}
}