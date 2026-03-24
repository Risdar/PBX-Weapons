class PBX_Handler : EventHandler
{
    // Override void WorldLoaded (WorldEvent e)
    // {
    //     // Sets the PB Monster Drop to Just Ammo on First Time Loading
    //     if (!FirstTimeLoadingPBX) return;
    //     CVAR.FindCVar('FirstTimeLoadingPBX').SetBool(false);
    //     //destroy();
    // }

    Override void PlayerEntered(PlayerEvent e)
    {
        let pm = players[e.PlayerNumber].mo;
		if(!pm) return;
        pm.giveinventory("CSSGShellsIn",2);
        pm.giveinventory("BR_Ammo", BR_AmmoFull);
        pm.giveinventory("MetalSniperAmmo", MetalSniperFullAmmo-1);
        pm.giveinventory("ExcavatorRounds", excavatorFullAmmo);
        pm.giveinventory("LeverActionAmmo", leveractionFullAmmo);
        return;
    }
}