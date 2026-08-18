class PBX_WeaponBase : PB_WeaponBase abstract
{
    // Proof of concept weapon inspect system
    // will probably lag a lot since its iterating through an array every tic
    // it is also very buggy with things like zooming in
    // override void Tick()
    // {
    //     Super.Tick();

    //     if (!owner || !owner.player || !owner.player.readyweapon)
    //         return;

    //     if (!AmmoType1)
    //         return;

    //     // If ammo2 exists, only proceed when it's maxed out.
    //     // If ammo2 doesn't exist, ammo1 alone is enough (checked above).
    //     if (AmmoType2)
    //     {
    //         let ammo2 = Ammo(owner.FindInventory(ammoType2));
    //         if (!ammo2 || ammo2.amount < ammo2.maxAmount)
    //             return;
    //     }

    //     bool reloadPressed = (owner.player.cmd.buttons & BT_RELOAD) && !(owner.player.oldbuttons & BT_RELOAD);
    //     if(!PB_WeaponIsInReadyState()) return; 

    //     if (reloadPressed)
    //     {
    //         owner.player.SetPSprite(PSP_WEAPON, owner.player.readyweapon.ResolveState("WeaponRespect"));
    //         owner.A_SetZoom(1.0);
    //     }
    // }

    // A wrapper for the weaponraise that calls the helptext
    // This way the helptext will only be called if the weapon is selected
    action void PBX_WeaponRaise(string upSnd = "")
    {
        PBXCore_Debug.Print("WeaponRaise Called");
        PB_WeaponRaise(upSnd);
        if(pbxweapons_sendTip) PBX_WeaponHelpText();
    }

}