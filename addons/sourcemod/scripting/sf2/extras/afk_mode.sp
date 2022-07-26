#if defined _sf2_afk_mode_included
 #endinput
#endif
#define _sf2_afk_mode_included

static float g_AfkAtGameTime[MAXPLAYERS + 1];

void AFK_SetTime(int client, bool bReset = true)
{
	if (g_AfkAtGameTime[client] != 0.0 && g_AfkAtGameTime[client] < GetGameTime())
	{
		g_PlayerNoPoints[client] = false;
		PrintCenterText(client, "");
	}

	if (g_PlayerNoPoints[client] || g_AdminNoPoints[client])
	{
		// Player already has their points disabled
		g_AfkAtGameTime[client] = 0.0;
	}
	else if (!bReset || !g_PlayerAFKTimeConVar.BoolValue)
	{
		g_AfkAtGameTime[client] = 0.0;
	}
	else
	{
		g_AfkAtGameTime[client] = GetGameTime() + g_PlayerAFKTimeConVar.FloatValue;
	}
}

void AFK_SetAFK(int client)
{
	g_PlayerNoPoints[client] = true;
	g_AfkAtGameTime[client] = 1.0;
}

void AFK_CheckTime(int client)
{
	if (g_AfkAtGameTime[client] != 0.0 && g_AfkAtGameTime[client] < GetGameTime())
	{
		g_PlayerNoPoints[client] = true;
		PrintCenterText(client, "%T", "SF2 AFK Status", client);
	}
}