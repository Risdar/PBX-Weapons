class NR_Select_FireMode : inventory {default{inventory.maxamount 1;}}
class NR_Select_DualWield : inventory {default{inventory.maxamount 1;}}
class NR_Select_Laser : inventory {default{inventory.maxamount 1;}}

class NormalRifleAmmo : Ammo
{
    Default
    {
        Inventory.Amount 0;
        Inventory.MaxAmount PBX_NormalRifle.MAGAZINE_SIZE;
        Ammo.BackpackAmount 0;
        Ammo.BackpackMaxAmount PBX_NormalRifle.MAGAZINE_SIZE;
        Inventory.Icon "RIFLA0";
    }
}

class NormalRifleLeftAmmo : Ammo
{
    Default
    {
        Inventory.Amount 0;
        Inventory.MaxAmount PBX_NormalRifle.MAGAZINE_SIZE;
        Ammo.BackpackAmount 0;
        Ammo.BackpackMaxAmount PBX_NormalRifle.MAGAZINE_SIZE;
        Inventory.Icon "RIFLA0";
    }
}
