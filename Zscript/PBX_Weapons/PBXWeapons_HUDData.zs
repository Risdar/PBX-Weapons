//////////////// SLOT 2 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class PBXHUDService_PBX_PlasmaBlaster : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_PlasmaBlaster')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;

        data.Image1 = "";       // Weapon Icon
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-22, 12);    // Weapon Icon Position
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 2.0;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

class PBXHUDService_PBX_ProsurvBlaster : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_ProsurvBlaster')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;

        data.Image1 = "";
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-30, 30);   // Weapon Icon Position
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 1.0;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

class PBXHUDService_PBX_LeverAction : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;
        if(weapon.GetClassName() != 'PBX_Prosurv_LeverAction')return null;
        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = true;

        let lar = PBX_Prosurv_LeverAction(objectArg);
        if(!lar) return null;

        data.Image1 = lar.laserActive 
            ? "graphics/WeaponWheel/LeverAction/LaserOn.png" 
            : "graphics/WeaponWheel/LeverAction/LaserOff.png";
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = lar.laserActive ? (0,18) : (-10, 18);
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = lar.laserActive ? 0.6 : 0.7;
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

//////////////// SLOT 3 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class PBXHUDService_PBX_CSSG : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;
        if(weapon.GetClassName() != 'PBX_CSSG')return null;
        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;

        let cssg = PBX_CSSG(objectArg);
        if(!cssg) return null;
        
        static const string cssgIcons[] = {
            "buckhud", "slughud", "flcthud", "flakhud", "drgnhud", 
            "explhud", "phoshud", "doomhud", "dnmkhud", "subzhud"
        };
        // Show what Ammo type is selected
        int cssgshell = clamp(cssg.shellsmode, 0, cssgIcons.Size() - 1);

        data.Image1 = "";
        data.Image2 = cssgIcons[cssgshell];
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-5, 12);
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 0.9; 
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

class PBXHUDService_PBX_PSG : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_ProSurvPSG')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = true;

        let psg = PBX_ProSurvPSG(objectArg);
        if(!psg) return null;

        data.Image1 = psg.laserActive 
            ? "graphics/WeaponWheel/ProsurvPSG/LaserOn.png" 
            : "graphics/WeaponWheel/ProsurvPSG/LaserOff.png";
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = psg.laserActive ? (13,13) : (-5, 15); 
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = psg.laserActive ? 0.8 : 1.1;
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

//////////////// SLOT 4 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class PBXHUDService_PBX_BattleRifle : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_BDPBattleRifle')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = true;

        let br = PBX_BDPBattleRifle(objectArg);
        if(!br) return null;

        data.Image1 = br.laserActive 
            ? "graphics/WeaponWheel/BattleRifle/br_LaserOn.png" 
            : "graphics/WeaponWheel/BattleRifle/br_LaserOff.png";
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = br.laserActive ? (0,12) : (-7, 12);  
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = br.laserActive ? 0.7 : 1.3;
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

class PBXHUDService_PBX_MetalSniper : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_MetalSniper')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = true;

        let sniper = PBX_MetalSniper(objectArg);
        if(!sniper) return null;

        data.Image1 = sniper.laserActive 
            ? "graphics/WeaponWheel/MetalSniper/LaserOn.png" 
            : "graphics/WeaponWheel/MetalSniper/LaserOff.png";
        data.Image2 = sniper.resonanceAmmoLoaded ? 
            "graphics/WeaponWheel/metalsniper/ResonanceAlt.png"
            : "graphics/WeaponWheel/metalsniper/StandardAlt.png";
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = sniper.laserActive ? (0,10) : (0,14); 
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        if(sniper.AltMode) data.Offset1.y -= 19;

        data.Scale1 = 1.0;      // Weapon Icon Scale
        data.Scale2 = 0.7;      // Weapon Mode Icon Scale

        return data;
    }
}

class PBXHUDService_PBX_Crossbow : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_Prosurv_Ballista')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = true;

        let crossbow = PBX_Prosurv_Ballista(objectArg);
        if(!crossbow) return null;

        data.Image1 = crossbow.demonicBallistaMode ? "CBOWT0" : "CBOWS0";
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-10, -8);   // Weapon Icon Position
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 1.0;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

class PBXHUDService_PBX_NormalRifle : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_NormalRifle')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = true;

        let nr = PBX_NormalRifle(objectArg);
        if(!nr) return null;

        data.Image1 = nr.laserActive 
            ? "graphics/WeaponWheel/NormalRifle/laseron.png" 
            : "graphics/WeaponWheel/NormalRifle/laseroff.png";
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = nr.laserActive ? (0,12) : (-5,12);
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = nr.laserActive ? 0.8 : 0.9;
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

//////////////// SLOT 5 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class PBXHUDService_PBX_NeoHMG : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_NeoHMG')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;

        data.Image1 = "";       // Weapon Icon
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-3,-3);   // Weapon Icon Position
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 1.6;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

//////////////// SLOT 6 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class PBXHUDService_PBX_CyberRL : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_CyberdemonRL')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;

        data.Image1 = "";       // Weapon Icon
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-15, 28);   // Weapon Icon Position
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 1.5;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

class PBXHUDService_PBX_MasterCG : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_MastermindChaingun')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = true;

        data.Image1 = "RMN1H0"; // Weapon Icon
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-10, 40);   // Weapon Icon Position
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 1.6;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

class PBXHUDService_PBX_Excavator : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_Excavator')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;

        data.Image1 = "";       // Weapon Icon
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-10, 15);     // Weapon Icon Position
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 1.1;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

class PBXHUDService_PBX_Paingiver : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_Paingiver')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;

        data.Image1 = "";       // Weapon Icon
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-10,15); // Weapon Icon Position
        data.Offset2 = (0,0);    // Weapon Mode Icon Position

        data.Scale1 = 1.3;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

//////////////// SLOT 7 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class PBXHUDService_PBX_Railgun : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_BDPRailgun')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = true;

        let railgun = PBX_BDPRailgun(objectArg);
        if(!railgun) return null;

        data.Image1 = railgun.laserActive 
            ? "graphics/WeaponWheel/PlatRailgun/LaserOn.png" 
            : "graphics/WeaponWheel/PlatRailgun/LaserOff.png";
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = railgun.laserActive ? (0,12) : (-5, 12);   // Weapon Icon Position
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = railgun.laserActive ? 0.7 : 1.4;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}

//////////////// SLOT 9 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class PBXHUDService_PBX_DemonExt : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_DemonExt')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;

        data.Image1 = "";       // Weapon Icon
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-10, 10);    // Weapon Icon Position
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 1.3;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}