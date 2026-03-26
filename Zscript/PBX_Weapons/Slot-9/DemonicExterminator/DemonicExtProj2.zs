Class UNMK_StormShot1 : Actor{
	Default{
		Radius 12;
		Height 6;
		Speed 30;
		Damagefunction 50;
		PROJECTILE;
		RENDERSTYLE "ADD";
		Alpha 0.80;
		Damagetype "Incinerate";//wepsoul//"Lightning"
		DeathSound "weapons/devexp";
		+THRUGHOST
		+PIERCEARMOR
		+NODAMAGETHRUST
		+FORCEPAIN
		+DONTREFLECT
		+FORCERADIUSDMG
	}
	int user_ang1;
	States
	{
	Spawn:
		TNT1 A 2 NODELAY A_SetUserVar("user_ang1",0);
	Spawn2:
		LFX1 STUVW 1 Bright{
			A_CustomMissile("UNMK_StormLite1",0,0,user_ang1+90,6);
			A_CustomMissile("UNMK_StormLite1",0,0,user_ang1+180,6);
			A_CustomMissile("UNMK_StormLite1",0,0,user_ang1+270,6);
			A_CustomMissile("UNMK_StormLite1",0,0,user_ang1+0,6);
			A_CustomMissile("UNMK_StormLite1",0,0,user_ang1+135,6);
			A_CustomMissile("UNMK_StormLite1",0,0,user_ang1+225,6);
			A_CustomMissile("UNMK_StormLite1",0,0,user_ang1+315,6);
			A_CustomMissile("UNMK_StormLite1",0,0,user_ang1+45,6);
			A_SetUserVar("user_ang1",user_ang1+17);
		}
		loop;
	Death:
		LFX1 STUVWSTUVWSTUVWSTUVWSTUVWSTUVWSTUVWSTUVWSTUVWSTUVWSTUVWSTUVW 1 Bright {
			A_Explode(32,64,0);
			A_CustomMissile("UNMK_StormLite1",0,0,user_ang1+90,6);
			A_CustomMissile("UNMK_StormLite1",0,0,user_ang1+180,6);
			A_CustomMissile("UNMK_StormLite1",0,0,user_ang1+270,6);
			A_CustomMissile("UNMK_StormLite1",0,0,user_ang1+0,6);
			A_SetUserVar("user_ang1",user_ang1+17);
		}
		stop;
	}
}

Class UNMK_StormShot2 : UNMK_StormShot1{
	Default{Damagefunction 150;}
	States
	{
	Spawn:
		TNT1 A 2 NODELAY A_SetUserVar("user_ang1",0);
	Spawn2:
		LFX1 KLMNO 1 Bright{
			A_CustomMissile("UNMK_StormLite2",0,0,user_ang1+90,6);
			A_CustomMissile("UNMK_StormLite2",0,0,user_ang1+180,6);
			A_CustomMissile("UNMK_StormLite2",0,0,user_ang1+270,6);
			A_CustomMissile("UNMK_StormLite2",0,0,user_ang1+0,6);
			A_CustomMissile("UNMK_StormLite2",0,0,user_ang1+135,6);
			A_CustomMissile("UNMK_StormLite2",0,0,user_ang1+225,6);
			A_CustomMissile("UNMK_StormLite2",0,0,user_ang1+315,6);
			A_CustomMissile("UNMK_StormLite2",0,0,user_ang1+45,6);
			A_SetUserVar("user_ang1",user_ang1+17);
		}
		loop;
		Death:
		LFX2 KLMNOKLMNOKLMNOKLMNOKLMNOKLMNOKLMNOKLMNOKLMNOKLMNOKLMNOKLMNO 1 Bright {
			A_Explode(64,128,0);
			A_CustomMissile("UNMK_StormLite2",0,0,user_ang1+90,6);
			A_CustomMissile("UNMK_StormLite2",0,0,user_ang1+180,6);
			A_CustomMissile("UNMK_StormLite2",0,0,user_ang1+270,6);
			A_CustomMissile("UNMK_StormLite2",0,0,user_ang1+0,6);
			A_SetUserVar("user_ang1",user_ang1+17);
		}
		stop;
	}
}
Class UNMK_StormLite1 : Actor{
	Default{
		Radius 6;
		Height 12;
		Speed 32;
		Damagefunction 5;
		PROJECTILE;
		Renderstyle "Add";
		Alpha 0.80;
		Damagetype "Incinerate";//wepsoul//"Lightning"
		DeathSound "weapons/devzap";
		+PIERCEARMOR
		+FORCEPAIN
		+THRUGHOST
		+DONTREFLECT
		+RIPPER
		+FORCERADIUSDMG
	}
	States{
	Spawn:
		DLIT ABC 1 Bright;
		Loop;
	Death:
		DLIT DEFGHIJKLMNO 1 Bright;
		Stop;
	}
}

Class UNMK_StormLite2 : UNMK_StormLite1{
	Default{
		Speed 64;
		Damagefunction 10;
	}
	States
	{
	Spawn:
		LFX1 XYZ 1 Bright;
		Loop;
	Death:
		LFX1 STUVW 3 Bright;
		Stop;
	}
}
Class HolyMissile2 : HolyMissile replaces HolyMissile{
	Default{
		Speed 15;
		Damage 0;
		RenderStyle "None";
		Alpha 0.50;
		Damagetype "wepsoul";
		Obituary "%o was reaped by %k.";
		+Bright
		+EXTREMEDEATH
		+FORCEXYBILLBOARD
		+PIERCEARMOR
		-FOILINVUL
	}
	States{
	Spawn:
		TNT1 A 0 ;
		TNT1 A 1 A_CHolyAttack2;
		Stop;
	}
}

Class ReaperBall : Cacodemonball{//Thanks to Xaser for spiraling projectile code :)
	Default{
		Radius 8;
		Height 16;
		Speed 25;
		Damage 100;
		Damagetype "wepsoul";
		Obituary "%o was reaped by %k.";
		SeeSound "none";
		DeathSound "weapons/solexp";
		RENDERSTYLE "ADD";
		+SEEKERMISSILE
		+EXTREMEDEATH
		+FORCEXYBILLBOARD
		+DONTREFLECT
		+SCREENSEEKER
		+FORCERADIUSDMG
		+PIERCEARMOR
		+NODAMAGETHRUST
	}
	int user_ang1;
	int user_radius1;
	States
	{
	Spawn:
		REAX J 0;
		REAX J 0 {A_SetUserVar("user_ang1",0);A_SetUserVar("user_radius1",24);}
		REAX JK 1 Bright {
			A_SpawnItemEx("SoulPuff",0,(user_radius1*sin(user_ang1*(7.5)+30)),(user_radius1*cos(user_ang1*(7.5)+30)),0,0,0,0,0,0);
			A_SpawnItemEx("SoulPuff",0,(user_radius1*sin(user_ang1*(7.5)+150)),(user_radius1*cos(user_ang1*(7.5)+150)),0,0,0,0,0,0);
			A_SpawnItemEx("SoulPuff",0,(user_radius1*sin(user_ang1*(7.5)+270)),(user_radius1*cos(user_ang1*(7.5)+270)),0,0,0,0,0,0);
			A_SetUserVar("user_ang1",user_ang1+1);
		}
	Spawn2:
		REAX JK 1 Bright {
			A_SpawnItemEx("SoulPuff",0,(user_radius1*sin(user_ang1*(7.5)+30)),(user_radius1*cos(user_ang1*(7.5)+30)),0,0,0,0,0,0);
			A_SpawnItemEx("SoulPuff",0,(user_radius1*sin(user_ang1*(7.5)+150)),(user_radius1*cos(user_ang1*(7.5)+150)),0,0,0,0,0,0);
			A_SpawnItemEx("SoulPuff",0,(user_radius1*sin(user_ang1*(7.5)+270)),(user_radius1*cos(user_ang1*(7.5)+270)),0,0,0,0,0,0);
			A_SetUserVar("user_ang1",user_ang1+1);
			A_SeekerMissile(1,3,SMF_LOOK|SMF_PRECISE);
			A_Explode(16,64,0,0,64,0,0);
		}
		REAX K 0 A_JumpIf(user_ang1==15,"ResetVar");
		loop;
	ResetVar:
		REAX J 0 A_SetUserVar("user_ang1",0);
		goto Spawn2;
	Death:
		REAX A 3 Bright;
		REAX B 3 Bright A_Explode(320,256,0);
		REAX CD 3 Bright ;
		REAX E 3 Bright A_SpawnItemEx("HolyMissile2",0,0,0,0,0,0,0,0,0);
		REAX FGHI 3 Bright;
		stop;
	}
}

Class ReaperBall2 : Cacodemonball{
	Default{
		Radius 8;
		Height 16;
		Speed 25;
		Damage 150;
		Damagetype "wepsoul";
		SeeSound "none";
		DeathSound "weapons/solexp";
		RENDERSTYLE "ADD";
		+SEEKERMISSILE
		+EXTREMEDEATH
		+FORCEXYBILLBOARD
		+DONTREFLECT
		+SCREENSEEKER
		+FORCERADIUSDMG
		+PIERCEARMOR
		+NODAMAGETHRUST
	}
	States{
	Spawn:
		REA2 A 0 Bright;
		REA2 ABCDE 2 Bright;
		REA2 F 0 Bright A_SpawnItemEx("ReaperShot",0,0,0,18,0,0,45,0,0);
		REA2 F 0 Bright A_SpawnItemEx("ReaperShot",0,0,0,18,0,0,135,0,0);
		REA2 F 0 Bright A_SpawnItemEx("ReaperShot",0,0,0,18,0,0,225,0,0);
		REA2 F 0 Bright A_SpawnItemEx("ReaperShot",0,0,0,18,0,0,315,0,0);
		REA2 FA 2 Bright {A_Explode(128,128,0);A_SeekerMissile(1,3,SMF_LOOK|SMF_PRECISE);}
		REA2 B 2 Bright {A_Explode(128,128,0);A_SeekerMissile(1,2,SMF_LOOK|SMF_PRECISE);}
		REA2 CDE 2 Bright {A_Explode(128,128,0);A_SeekerMissile(1,3,SMF_LOOK|SMF_PRECISE);}
		goto Spawn+6;
	Death:
		TNT1 A 9 Bright A_Explode(400,256,0);
		TNT1 AA 0 Bright A_SpawnItemEx("HolyMissile2",0,0,0,0,0,0,0,0,0);
		TNT1 A 4 Bright {A_SpawnItemEx("SoulPuff2",frandom(-60,60),frandom(-60,60),frandom(-60,60),0,0,0,0,0,0);A_SpawnItemEx("SoulPuff2",frandom(-60,60),frandom(-60,60),frandom(-60,60),0,0,0,0,0,0);A_SpawnItemEx("SoulPuff2",frandom(-60,60),frandom(-60,60),frandom(-60,60),0,0,0,0,0,0);}
		TNT1 A 4 Bright A_SpawnItemEx("SoulPuff2",frandom(-60,60),frandom(-60,60),frandom(-60,60),0,0,0,0,0,0);
		TNT1 AAAAAAAAA 4 Bright {A_SpawnItemEx("SoulPuff2",frandom(-60,60),frandom(-60,60),frandom(-60,60),0,0,0,0,0,0);A_SpawnItemEx("SoulPuff2",frandom(-60,60),frandom(-60,60),frandom(-60,60),0,0,0,0,0,0);A_SpawnItemEx("SoulPuff2",frandom(-60,60),frandom(-60,60),frandom(-60,60),0,0,0,0,0,0);}
		stop;
	}
}

Class ReaperShot : CacodemonBall{
	Default{
		Damage 10;
		Speed 20;
		Renderstyle "Add";
		Alpha 0.85 ;
		Damagetype "wepsoul";
		Obituary "%o could not evade %k soul-seekers.";
		SeeSound "weapons/ghomis";
		DeathSound "weapons/ghohit";
		+SEEKERMISSILE
		+FORCEXYBILLBOARD
		+PIERCEARMOR
		-SCREENSEEKER
	}
	States
	{
	Spawn: 
		REAX L 2 Bright A_SpawnItemEx("SoulPuff3",0,0,0,0,0,0,0,8);
	Spawn2:
		REAX L 2 Bright A_SpawnItemEx("SoulPuff3",0,0,0,0,0,0,0,8);
		REAX L 2 Bright A_SeekerMissile(7,12,SMF_LOOK,128);
		loop;
	Death:
		SPIR KLMNO 3 Bright;
		stop;
	XDeath:
		SPIR V 3 Bright;
		SPIR W 0 Bright A_GiveToTarget("Health",1);
		SPIR WXYZ 3 Bright;
		stop;
	}
}

Class SoulPuff : actor{
	Default{
	Radius 0;
	Height 1;
	+NOGRAVITY
	+NOBLOCKMAP
	+FORCEXYBILLBOARD
	Renderstyle "Normal";
	Alpha 1;
	}
	States
	{
	Spawn:
		REAX L 2 Bright;
		SPIR QRSTU 2 Bright A_FadeOut(0.2);
		Stop;
	}
}

Class SoulPuff2 : SoulPuff{
	Default{
	Damagetype "wepsoul";
	Renderstyle "Add";
	Alpha 0.67;
	+NODAMAGETHRUST
	}
	States
	{
	Spawn:
		REAX A 3 Bright;
		REAX BCD 3 Bright;
		REAX E 3 Bright A_Explode(8,144,0);
		REAX FGH 3 Bright ;
		REAX IIIII 3 Bright A_FadeOut(0.10);
		Stop;
	}
}

Class SoulPuff3 : SoulPuff{
	States{
	Spawn:
		TNT1 A 3;
		SPIR QRSTU 3 Bright A_FadeOut(0.1);
		Stop;
	}
}