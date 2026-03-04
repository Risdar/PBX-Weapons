Class ShellCasingBase : ShotgunCasing  
{	
	states
	{
		cachetextures:
			WCS1 A 0;
			CAS8 A 0;
			CAS9 A 0;
			XCS1 A 0;
			TDS1 A 0;
			DC0S A 0;
			CAF8 A 0;
			stop;

	}
}

Class BuckShellCasing : ShellCasingBase
{
	default
	{
		PB_CasingBase.CasingSprite 'CASX';
	}
}

Class SlugShellCasing : ShellCasingBase
{
	default
	{
		PB_CasingBase.CasingSprite 'CAS5';
	}
}

Class DragonShellCasing : ShellCasingBase
{
	default
	{
		PB_CasingBase.CasingSprite 'CAS6';
	}
}


Class ExplosiveShellCasing : ShellCasingBase
{
	default
	{
		PB_CasingBase.CasingSprite 'XCS1';
	}
}

Class FlakShellCasing : ShellCasingBase
{
	default
	{
		PB_CasingBase.CasingSprite 'CAS9';
	}
}

Class FlechetShellCasing : ShellCasingBase
{
	default
	{
		PB_CasingBase.CasingSprite 'CAF8';
	}
}

Class WhitePShellCasing : ShellCasingBase
{
	default
	{
		PB_CasingBase.CasingSprite 'WCS1';
	}
}

Class TDoomCasing : ShellCasingBase
{
	default
	{
		PB_CasingBase.CasingSprite 'TDS1';
	}
}

Class DanmakuCasing : ShellCasingBase
{
	default
	{
		PB_CasingBase.CasingSprite 'DC0S';
	}
}