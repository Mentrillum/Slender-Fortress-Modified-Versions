#if defined _sf2_afk_mode_included
 #endinput
#endif
#define _sf2_afk_mode_included

static float g_AfkAtGameTime[MAXPLAYERS + 1];

void AFK_SetTime(int client, bool bReset = true)
{
	if (g_AfkAtGameTime[client] != 0.0 && g_AfkAtGameTime[client] < GetGameTime())
	{
		g_bPlayerNoPoints[client] = false;
		PrintCenterText(client, "");
	}

	if (g_bPlayerNoPoints[client] || g_bAdminNoPoints[client])
	{
		// Player already has their points disabled
		g_AfkAtGameTime[client] = 0.0;
	}
	else if(!bReset || !g_cvPlayerAFKTime.BoolValue)
	{
		g_AfkAtGameTime[client] = 0.0;
	}
	else
	{
		g_AfkAtGameTime[client] = GetGameTime() + g_cvPlayerAFKTime.FloatValue;
	}
}

void AFK_CheckTime(int client)
{
	if (g_AfkAtGameTime[client] != 0.0 && g_AfkAtGameTime[client] < GetGameTime())
	{
		g_bPlayerNoPoints[client] = true;
		PrintCenterText(client, "%T", "SF2 AFK Status", client);
	}
}