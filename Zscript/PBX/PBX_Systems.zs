enum PBX_eGeneralSettingFlags{
    DisablePBX_Smoke				= 1 << 0
}

class PBX_Handler : EventHandler
{
    // Override void WorldLoaded (WorldEvent e)
    // {
    //     // Sets the PB Monster Drop to Just Ammo on First Time Loading
    //     if (!FirstTimeLoadingPBX) return;
    //     CVAR.FindCVar('FirstTimeLoadingPBX').SetBool(false);
    //     //destroy();
    // }

    // Gives the player the AmmoType 2 on spawn
    // This is so the player will always have full ammo when picking up a new weapon
    Override void PlayerEntered(PlayerEvent e)
    {
        let pm = players[e.PlayerNumber].mo;
		if(!pm) return;
        // SLOT 2
        pm.giveinventory("LeverActionAmmo", leveractionFullAmmo);
        // SLOT 3
        pm.giveinventory("CSSGShellsIn",2);
        // SLOT 4
        pm.giveinventory("BR_Ammo", BR_AmmoFull);
        pm.giveinventory("MetalSniperAmmo", MetalSniperFullAmmo-1);
        // SLOT 5
        pm.giveinventory("HMGChamberAmmo", neohmgFullAmmo);
        // SLOT 6
        pm.giveinventory("ExcavatorRounds", excavatorFullAmmo);
        // SLOT 9
        return;
    }
}