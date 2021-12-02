#if defined _sf2_afk_mode_included
 #endinput
#endif
#define _sf2_afk_mode_included

#define AFK_TIME	90.0

static float g_fAfkAtGameTime[MAXPLAYERS + 1];

void AFK_SetTime(int iClient, bool bReset = true)
{
	if (g_fAfkAtGameTime[iClient] != 0.0 && g_fAfkAtGameTime[iClient] < GetGameTime())
	{
		g_bPlayerNoPoints[iClient] = false;
	}
	
	if (g_bPlayerNoPoints[iClient] || g_bAdminNoPoints[iClient])
	{
		// Player already has their points disabled
		g_fAfkAtGameTime[iClient] = 0.0;
	}
	else
	{
		g_fAfkAtGameTime[iClient] = bReset ? (GetGameTime() + AFK_TIME) : 0.0;
	}
}

void AFK_CheckTime(int iClient)
{
	if (g_fAfkAtGameTime[iClient] != 0.0 && g_fAfkAtGameTime[iClient] < GetGameTime())
	{
		g_bPlayerNoPoints[iClient] = true;
		PrintCenterText(iClient, "%T", "SF2 AFK Status");
	}
}
