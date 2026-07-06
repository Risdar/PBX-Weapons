class MastermindCGProjectile : PB_MasterMindTracer
{
	Default
	{
		+RIPPER;
		PB_Projectile.BaseDamage 200;
		PB_Projectile.RipperCount 1;
        PB_Projectile.PenetrationCount 3;
		+PB_PROJECTILE.NOCRITICALS
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
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();

		let aux = HomingShots_Aux(GiveInventoryType("HomingShots_Aux"));
		if (aux)
		{
			aux.level = 50; // adjusts how strong is the homing
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