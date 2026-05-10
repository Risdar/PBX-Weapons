class CB_Select_DemonicMode : inventory {default{inventory.maxamount 1;}}
class CB_Select_NormalMode : inventory {default{inventory.maxamount 1;}}
class Crossbow_Upgraded : inventory {default{inventory.maxamount 1;}}

Class CrossbowBallistaAmmo : PB_Ammo{
	Default
	{
		inventory.maxamount crossbowBallistaFullAmmo;
		ammo.backpackamount 0;
		ammo.backpackmaxamount crossbowBallistaFullAmmo;
		+INVENTORY.IGNORESKILL
	}
}

class PBX_DemonicBallistaUpgrade : PB_UpgradeItem
{
    Default
    {
	    +INVENTORY.ALWAYSPICKUP
		-COUNTITEM;
        Inventory.PickupMessage "$PBX_DemonicBallistaUpgrade_Pickup";
        Inventory.PickupSound "weapons/ballista/drawstring";
		Tag "$PBX_Prosurv_Ballista_UpgradeTag";
    }

    States
	{
        Spawn:
            CBOW T -1;
            Stop;

        Pickup:
            TNT1 A 0 A_JumpIf(!FindInventory("PBX_Prosurv_Ballista") || !FindInventory("Crossbow_Upgraded") || CountInv("PB_DTech") < GetAmmoCapacity("PB_DTech"),1);
            fail;
            TNT1 A 0 {
                A_SetInventory("Crossbow_Upgraded", 1);
                A_GiveInventory("PBX_Prosurv_Ballista", 1);
                A_GiveInventory("CB_Select_DemonicMode", 1);
                A_SetWeaponTag("PBX_Prosurv_Ballista","$PBX_Prosurv_Ballista_Tag");
                A_GiveInventory("PB_DTech", 60);
            }
            Stop;
	}
}