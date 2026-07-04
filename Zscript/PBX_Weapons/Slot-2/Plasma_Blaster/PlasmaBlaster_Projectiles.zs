class HellPistolNormal : PB_ProjectileAlt
{
    Default
    {
        PB_Projectile.BaseDamage 35;
		+PB_PROJECTILE.NOCRITICALS
        DamageType "Plasma";
        Speed 350;
    }
}

class HellPistolAuto : HellPistolNormal
{
    Default
    {
        PB_Projectile.BaseDamage 20;
        Speed 100;
    }
}

class HellPistolCharge : HellPistolNormal
{
    Default
    {
        PB_Projectile.BaseDamage 150;
        Speed 350;
        Scale 1.5;
        Height 2.0;
    }
}