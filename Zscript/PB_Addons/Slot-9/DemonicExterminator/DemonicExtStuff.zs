class ExterminatorStuff : EventHandler{
	override void WorldThingDamaged(WorldEvent e)
	{
		if(e.Inflictor && e.Thing.bISMONSTER && CheckForSoulsNoDemon2(e.Thing) && e.Thing.health <=0&&e.DamageSource)
		{
			bool inflictorCheckDExt = ( e.Inflictor is "UNMK_DExtActor" || e.Inflictor is "UNMK_DExtFastProjectile" || e.Inflictor is "Unmaker64Puff" || e.Inflictor is "DemonExterminatorEnergyBlast" );
			//(e.Inflictor is "UNMK_Projectile" || e.Inflictor is "UNMK_AltPj" || e.Inflictor is "ExplosievUNmk" || e.Inflictor is "UNMK_Grounder" || e.Inflictor is "U64BurningPiece" || e.Inflictor is "UnmakerLaser64" || e.Inflictor is "Unmaker64Puff" || e.Inflictor is "DemonExterminatorEnergyBlast");
			bool inflictorCheckDTech = (e.Inflictor is "Hellbullet" || e.Inflictor is "Hellbullet2" || e.Inflictor is "ShrinkBeam" || e.Inflictor is "CausticGreenPlasmaBall" || e.Inflictor is "ACIDFOGSHRINK" || e.Inflictor is "GreenCloudMediumShrink" || e.Inflictor is "GreenCloudSmallShrink");
			bool inflictorCheckUnmaker = (e.Inflictor is "UnmakerLaser" || e.Inflictor is "UnmakerDoomSeeker" || e.Inflictor is "OverchargeLaser" || e.Inflictor is "OverchargeGroundSpike");
			bool inflictorCheck = inflictorCheckDExt || inflictorCheckDTech || inflictorCheckUnmaker || e.Inflictor is "PlayerPawn";
			if( e.DamageSource.CountInv("SoulCharge")<e.DamageSource.GetAmmoCapacity("SoulCharge") ) {// && 
				e.DamageSource.GiveInventory("SoulCharge",6);
				if(inflictorCheck){e.DamageSource.GiveInventory("SoulCharge",6);}
			}
			}
		if(!e.Inflictor && e.DamageSource is "PlayerPawn"){if( e.DamageSource.CountInv("SoulCharge")<e.DamageSource.GetAmmoCapacity("SoulCharge") ) e.DamageSource.GiveInventory("SoulCharge",3);}
	}
	bool CheckForSoulsNoDemon(actor monster){
		bool isDemonType = (
			monster is "Arachnotron" || monster is "Archvile" || monster is "BaronOfHell" || monster is "Cacodemon" || monster is "Cyberdemon" || 
			monster is "Demon" || monster is "DoomImp" || monster is "Fatso" || monster is "HellKnight" || monster is "LostSoul" || monster is "PainElemental" || 
			monster is "Revenant" || monster is "SpiderMastermind" 
			);
		bool isFormerHuman = (monster is "PB_ZombieMan" || monster is "PB_ShotgunGuy" || monster is "PB_Commando" || monster is "PB_Nazi" || monster.GetSpecies() == "Nazi" || monster.GetSpecies() == "Former_Human" );
		bool isNotPBNative = ( !(monster is "PB_Monster") ) ;
		return (isFormerHuman || isNotPBNative ) && !isDemonType;
	}
	bool CheckForSoulsNoDemon2(actor monster){
		bool isDemonType = (
			monster is "Arachnotron" || monster is "Archvile" || monster is "BaronOfHell" || monster is "Cacodemon" || monster is "Cyberdemon" || 
			monster is "Demon" || monster is "DoomImp" || monster is "Fatso" || monster is "HellKnight" || monster is "SpiderMastermind" 
			);
		bool isFormerHuman = (monster is "PB_ZombieMan" || monster is "PB_ShotgunGuy" || monster is "PB_Commando" || monster is "PB_Nazi" || monster.GetSpecies() == "Nazi" || monster.GetSpecies() == "Former_Human" || monster is "Revenant" || monster is "PB_Revenant" || monster is "LostSoul" || monster is "PainElemental");
		bool isNotPBNative = ( !(monster is "PB_Monster") ) ;
		return (isFormerHuman || isNotPBNative ) && !isDemonType;
	}
	//
}