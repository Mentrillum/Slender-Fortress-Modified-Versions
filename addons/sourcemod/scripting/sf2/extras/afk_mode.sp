#if defined _sf2_afk_mode_included
 #endinput
#endif
#define _sf2_afk_mode_included

static float g_fAfkAtGameTime[MAXPLAYERS + 1];

void AFK_SetTime(int iClient, bool bReset = true)
{
	if (g_fAfkAtGameTime[iClient] != 0.0 && g_fAfkAtGameTime[iClient] < GetGameTime())
	{
		g_bPlayerNoPoints[iClient] = false;
		PrintCenterText(iClient, "");
	}

	if (g_bPlayerNoPoints[iClient] || g_bAdminNoPoints[iClient])
	{
		// Player already has their points disabled
		g_fAfkAtGameTime[iClient] = 0.0;
	}
	else if(!bReset || !g_cvPlayerAFKTime.BoolValue)
	{
		g_fAfkAtGameTime[iClient] = 0.0;
	}
	else
	{
		g_fAfkAtGameTime[iClient] = GetGameTime() + g_cvPlayerAFKTime.FloatValue;
	}
}

void AFK_CheckTime(int iClient)
{
	if (g_fAfkAtGameTime[iClient] != 0.0 && g_fAfkAtGameTime[iClient] < GetGameTime())
	{
		g_bPlayerNoPoints[iClient] = true;
		PrintCenterText(iClient, "%T", "SF2 AFK Status", iClient);
	}
}