class ExterminatorStuff : EventHandler
{
    override void WorldThingDamaged(WorldEvent e)
    {
        let src = e.DamageSource;
        let thing = e.Thing;
		let inflictor = e.inflictor;

        if (!src || !thing) return;

        if (inflictor && thing.bISMONSTER && thing.Health <= 0 && CheckForSoulsNoDemon2(thing))
        {
            if (src.CountInv("SoulCharge") < src.GetAmmoCapacity("SoulCharge"))
            {
                src.GiveInventory("SoulCharge", PBX_DemonExt.SOUL_GAIN);
                if (IsValidInflictor(inflictor))
                    src.GiveInventory("SoulCharge", PBX_DemonExt.SOUL_GAIN);
            }
        }
        else if (!inflictor && src is "PlayerPawn")
        {
            if (src.CountInv("SoulCharge") < src.GetAmmoCapacity("SoulCharge"))
                src.GiveInventory("SoulCharge", PBX_DemonExt.SOUL_GAIN/2);
        }
    }

    private 
	bool IsValidInflictor(Actor inflictor)
    {
        return
            inflictor is "UNMK_DExtActor"               || inflictor is "UNMK_DExtFastProjectile"  ||
            inflictor is "Unmaker64Puff"                || inflictor is "DemonExterminatorEnergyBlast" ||
            inflictor is "Hellbullet"                   || inflictor is "Hellbullet2"              ||
            inflictor is "ShrinkBeam"                   || inflictor is "CausticGreenPlasmaBall"   ||
            inflictor is "ACIDFOGSHRINK"                || inflictor is "GreenCloudMediumShrink"   ||
            inflictor is "GreenCloudSmallShrink"        || inflictor is "UnmakerLaser"             || 
			inflictor is "UnmakerDoomSeeker"            || inflictor is "OverchargeLaser"          || 
			inflictor is "OverchargeGroundSpike"        || inflictor is "PlayerPawn";
    }

    private
	bool CheckForSoulsNoDemon2(Actor monster)
    {
        bool isDemonType =
            monster is "Arachnotron"       || monster is "Archvile"        ||
            monster is "BaronOfHell"       || monster is "Cacodemon"       ||
            monster is "Cyberdemon"        || monster is "Demon"           ||
            monster is "DoomImp"           || monster is "Fatso"           ||
            monster is "HellKnight"        || monster is "SpiderMastermind";

        bool isFormerHuman =
            monster is "PB_ZombieMan"      || monster is "PB_ShotgunGuy"   ||
            monster is "PB_Commando"       || monster is "PB_Nazi"         ||
            monster is "Revenant"          || monster is "PB_Revenant"     ||
            monster is "LostSoul"          || monster is "PainElemental"   ||
            monster.GetSpecies() == "Nazi" || monster.GetSpecies() == "Former_Human";

        bool isNotPBNative = !(monster is "PB_Monster");

        return (isFormerHuman || isNotPBNative) && !isDemonType;
    }
}