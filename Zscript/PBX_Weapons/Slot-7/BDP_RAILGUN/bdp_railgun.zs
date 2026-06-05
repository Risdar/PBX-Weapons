// Includes
#include "./bdprailgun_Functions.zs"
#include "./bdprailgun_Wheel.zs"
#include "./bdprailgun_helpers.zs"

// Constants
const BDPRailgunFullAmmo           = 12;

Class PBX_BDPRailgun : PB_WeaponBase
{
    Default
    {
        Weapon.AmmoGive1 40;
		Weapon.AmmoType2 "BDPCell";
		PB_WeaponBase.ReserveToMagAmmoFactor 10;
		Obituary "%o was pierced by %k's Railgun.";
		Inventory.PickupSound "PLSDRAW";
		Inventory.Pickupmessage "$PBX_BDPRailgun_Pickup";
		DamageType "Railgun";
		Weapon.SlotNumber 7;
		Weapon.SlotPriority 2;
		Weapon.SelectionOrder 1550;
		Inventory.AltHUDIcon "SRCGA0";
		Tag "$PBX_BDPRailgun_Tag";
    }

	bool steam;

    Action void a_spawnhologram()
	{
		A_radiusgive("KillHologram",10000,RGF_MONSTERS | RGF_NOSIGHT,1,"HoloPlayer");
		FLineTraceData lasersight;
				LineTrace(angle, 4096, pitch, TRF_SOLIDACTORS|TRF_THRUHITSCAN, offsetz: player.viewz - pos.z, data: lasersight);
				vector3 targetpos = lasersight.HitLocation;
				if (lasersight.HitLine)
				{
					vector2 wallnormal = (-lasersight.HitLine.delta.y,lasersight.HitLine.delta.x).unit();
					if (!lasersight.LineSide)
					wallnormal *= -1;
					targetpos += (wallnormal * 18);
				}
				if (lasersight.hittype == trace_hitceiling)
				{
					targetpos.z -= 13;
				}
				Let HoloTarget = Spawn("Holotarget",targetpos);
				Let HoloPlayer = Spawn("Holoplayer",pos);
				If(HoloTarget && HoloPlayer)
				{
					HoloPlayer.angle = angle;
					HoloPlayer.Tracer = Holotarget;
					HoloPlayer.Translation = Invoker.owner.Translation;
				}
				
		
	}
	
	Action void a_firenurailgun()
	{
		FLineTraceData railspawn;
        LineTrace(angle, 8192, pitch, TRF_NOSKY | TRF_THRUACTORS, player.viewz - player.mo.pos.z - 5, data: railspawn);
        if (railspawn.HitType != TRACE_HitNone)
        {
            vector3 targetpos = railspawn.HitLocation;
            if (railspawn.HitLine)
            {
                vector2 wallnormal = (-railspawn.HitLine.delta.y,railspawn.HitLine.delta.x).unit();
                if (!railspawn.LineSide)
                wallnormal *= -1;
                targetpos += (wallnormal * 3);
            }

            actor beam = Spawn("railgunrail", targetpos);
            if (beam)
            {
                beam.angle = angle;
                beam.pitch = pitch;
            }

            for (int i = 0; i < 20; i++)
            {
                actor rico = Spawn("ricochet", targetpos);
                if (rico)
                {
                    rico.angle = angle + 180;
                }
            }
        }
            
        Vector3 trailpos = (pos.x - railspawn.HitLocation.x, pos.y - railspawn.HitLocation.y, pos.z + player.viewz - player.mo.pos.z - 5 - railspawn.HitLocation.z);
        FSpawnParticleParams trail;
        for(int i = railspawn.distance; i > 0; i -= 2)
        {
            let trail = Level.SpawnVisualThinker("RailgunTrail");
            trail.pos = railspawn.HitLocation + trailpos * (i/railspawn.distance);
            trail.pos += (frandom(1,-1),frandom(1,-1),frandom(1,-1));
        }
        
        invoker.emptyChamber = true;
        
        A_Fireprojectile("RailgunProjectile", 0, 0, 0, 0);
        A_alertmonstersDX(500);
        A_RailAttack(450, 0, 0, "", "", 0, 0, "RailgunPuff2");
        A_Fireprojectile ("PlasmaSmoke", 0, 0, 0, 2);
        A_StartSound("RAILF01", 1);
        PB_TakeAmmo(invoker.ammotype2, 1);
        A_WeaponRecoil(6);
        A_QuadSound();
        if(invoker.owner.pos.z <= invoker.owner.floorz) {
            A_Recoil3d(3);
        }
        else {
            A_Recoil3d(20);
        }
    }

    States
    {
        
    }
}