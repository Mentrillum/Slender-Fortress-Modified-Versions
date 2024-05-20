#if defined _sf2_debug_included
 #endinput
#endif
#define _sf2_debug_included

#pragma semicolon 1

#include <profiler>

#define DEBUG_BOSS_TELEPORTATION (1 << 0)
#define DEBUG_BOSS_CHASE (1 << 1)
#define DEBUG_PLAYER_STRESS (1 << 2)
#define DEBUG_PLAYER_ACTION_SLOT (1 << 3)
#define DEBUG_BOSS_PROXIES (1 << 4)
#define DEBUG_BOSS_HITBOX (1 << 5)
#define DEBUG_BOSS_STUN (1 << 6)
#define DEBUG_ENTITIES (1 << 7)
#define DEBUG_GHOSTMODE (1 << 8)
#define DEBUG_NEXTBOT (1 << 9)
#define DEBUG_BOSS_ANIMATION (1 << 10)
#define DEBUG_EVENT (1 << 11)
#define DEBUG_KILLICONS (1 << 12)
#define DEBUG_BOSS_IDLE (1 << 14)
#define DEBUG_BOSS_EYES (1 << 15)
#define DEBUG_BOSS_PATH (1 << 16)

int g_PlayerDebugFlags[MAXTF2PLAYERS] = { 0, ... };

static char g_DebugLogFilePath[512] = "";

ConVar g_DebugDetailConVar = null;

void InitializeDebug()
{
	g_DebugDetailConVar = CreateConVar("sf2_debug_detail", "0", "0 = off, 1 = debug only large, expensive functions, 2 = debug more events, 3 = debug client functions");

	RegAdminCmd("sm_sf2_debug_boss_teleport", Command_DebugBossTeleport, ADMFLAG_CHEATS);
	RegAdminCmd("sm_sf2_debug_boss_chase", Command_DebugBossChase, ADMFLAG_CHEATS);
	RegAdminCmd("sm_sf2_debug_boss_nextbot", Command_DebugNextbot, ADMFLAG_CHEATS);
	RegAdminCmd("sm_sf2_debug_boss_animation", Command_DebugBossAnimation, ADMFLAG_CHEATS);
	RegAdminCmd("sm_sf2_debug_player_stress", Command_DebugPlayerStress, ADMFLAG_CHEATS);
	RegAdminCmd("sm_sf2_debug_boss_proxies", Command_DebugBossProxies, ADMFLAG_CHEATS);
	RegAdminCmd("sm_sf2_debug_hitbox", Command_DebugHitbox, ADMFLAG_CHEATS);
	RegAdminCmd("sm_sf2_debug_entity", Command_DebugEntity, ADMFLAG_CHEATS);
	RegAdminCmd("sm_sf2_debug_boss_stun", Command_DebugStun, ADMFLAG_CHEATS);
	RegAdminCmd("sm_sf2_debug_ghost_mode", Command_DebugGhostMode, ADMFLAG_CHEATS);
	RegAdminCmd("sm_sf2_debug_events", Command_DebugEvent, ADMFLAG_CHEATS);
	RegAdminCmd("sm_sf2_debug_kill_icons", Command_DebugKillIcons, ADMFLAG_CHEATS);
	RegAdminCmd("sm_sf2_debug_boss_idle", Command_DebugBossIdle, ADMFLAG_CHEATS);
	RegAdminCmd("sm_sf2_debug_boss_eyes", Command_DebugBossEyes, ADMFLAG_CHEATS);
	RegAdminCmd("sm_sf2_debug_boss_path", Command_DebugBossPath, ADMFLAG_CHEATS);
}

void InitializeDebugLogging()
{
	char dateSuffix[256];
	FormatTime(dateSuffix, sizeof(dateSuffix), "sf2-debug-%Y-%m-%d.log", GetTime());

	BuildPath(Path_SM, g_DebugLogFilePath, sizeof(g_DebugLogFilePath), "logs/%s", dateSuffix);

	char map[64];
	GetCurrentMap(map, sizeof(map));

	DebugMessage("-------- Mapchange to %s -------", map);
}

void DebugMessage(const char[] message, any ...)
{
	char debugMessage[1024], temp[1024];
	VFormat(temp, sizeof(temp), message, 2);
	FormatEx(debugMessage, sizeof(debugMessage), "%s", temp);
	//LogMessage(debugMessage);
	LogToFile(g_DebugLogFilePath, debugMessage);
}

void SendDebugMessageToPlayer(int client, int debugFlags, int type, const char[] message, any ...)
{
	if (!IsValidClient(client) || IsFakeClient(client))
	{
		return;
	}

	char msg[1024];
	VFormat(msg, sizeof(msg), message, 5);

	if (g_PlayerDebugFlags[client] & debugFlags)
	{
		switch (type)
		{
			case 0:
			{
				CPrintToChat(client, msg);
			}
			case 1:
			{
				PrintCenterText(client, msg);
			}
			case 2:
			{
				PrintHintText(client, msg);
			}
		}
	}
}

void SendDebugMessageToPlayers(int debugFlags, int type, const char[] message, any ...)
{
	char msg[1024];
	VFormat(msg, sizeof(msg), message, 4);

	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i) || IsFakeClient(i))
		{
			continue;
		}

		if (g_PlayerDebugFlags[i] & debugFlags)
		{
			switch (type)
			{
				case 0:
				{
					CPrintToChat(i, msg);
				}
				case 1:
				{
					PrintCenterText(i, msg);
				}
				case 2:
				{
					PrintHintText(i, msg);
				}
			}
		}
	}
}

static Action Command_DebugBossTeleport(int client, int args)
{
	if (client < 1 || client > MaxClients)
	{
		return Plugin_Handled;
	}

	bool inMode = (g_PlayerDebugFlags[client] & DEBUG_BOSS_TELEPORTATION) != 0;
	if (!inMode)
	{
		g_PlayerDebugFlags[client] |= DEBUG_BOSS_TELEPORTATION;
		PrintToChat(client, "Enabled debugging boss teleportation.");
	}
	else
	{
		g_PlayerDebugFlags[client] &= ~DEBUG_BOSS_TELEPORTATION;
		PrintToChat(client, "Disabled debugging boss teleportation.");
	}

	return Plugin_Handled;
}

static Action Command_DebugBossChase(int client, int args)
{
	if (client < 1 || client > MaxClients)
	{
		return Plugin_Handled;
	}

	bool inMode = (g_PlayerDebugFlags[client] & DEBUG_BOSS_CHASE) != 0;
	if (!inMode)
	{
		g_PlayerDebugFlags[client] |= DEBUG_BOSS_CHASE;
		PrintToChat(client, "Enabled debugging boss chasing.");
	}
	else
	{
		g_PlayerDebugFlags[client] &= ~DEBUG_BOSS_CHASE;
		PrintToChat(client, "Disabled debugging boss chasing.");
	}

	return Plugin_Handled;
}

static Action Command_DebugBossIdle(int client, int args)
{
	if (client < 1 || client > MaxClients)
	{
		return Plugin_Handled;
	}

	bool inMode = (g_PlayerDebugFlags[client] & DEBUG_BOSS_IDLE) != 0;
	if (!inMode)
	{
		g_PlayerDebugFlags[client] |= DEBUG_BOSS_IDLE;
		PrintToChat(client, "Enabled debugging boss idling.");
	}
	else
	{
		g_PlayerDebugFlags[client] &= ~DEBUG_BOSS_IDLE;
		PrintToChat(client, "Disabled debugging boss idling.");
	}

	return Plugin_Handled;
}

static Action Command_DebugBossEyes(int client, int args)
{
	if (client < 1 || client > MaxClients)
	{
		return Plugin_Handled;
	}

	bool inMode = (g_PlayerDebugFlags[client] & DEBUG_BOSS_EYES) != 0;
	if (!inMode)
	{
		g_PlayerDebugFlags[client] |= DEBUG_BOSS_EYES;
		PrintToChat(client, "Enabled debugging boss eyes.");
	}
	else
	{
		g_PlayerDebugFlags[client] &= ~DEBUG_BOSS_EYES;
		PrintToChat(client, "Disabled debugging boss eyes.");
	}

	return Plugin_Handled;
}

static Action Command_DebugBossPath(int client, int args)
{
	if (client < 1 || client > MaxClients)
	{
		return Plugin_Handled;
	}

	bool inMode = (g_PlayerDebugFlags[client] & DEBUG_BOSS_PATH) != 0;
	if (!inMode)
	{
		g_PlayerDebugFlags[client] |= DEBUG_BOSS_PATH;
		PrintToChat(client, "Enabled debugging boss pathing.");
	}
	else
	{
		g_PlayerDebugFlags[client] &= ~DEBUG_BOSS_PATH;
		PrintToChat(client, "Disabled debugging boss pathing.");
	}

	return Plugin_Handled;
}

static Action Command_DebugBossAnimation(int client, int args)
{
	if (client < 1 || client > MaxClients)
	{
		return Plugin_Handled;
	}

	bool inMode = (g_PlayerDebugFlags[client] & DEBUG_BOSS_ANIMATION) != 0;
	if (!inMode)
	{
		g_PlayerDebugFlags[client] |= DEBUG_BOSS_ANIMATION;
		PrintToChat(client, "Enabled debugging boss animation.");
	}
	else
	{
		g_PlayerDebugFlags[client] &= ~DEBUG_BOSS_ANIMATION;
		PrintToChat(client, "Disabled debugging boss animation.");
	}

	return Plugin_Handled;
}

static Action Command_DebugNextbot(int client, int args)
{
	if (client < 1 || client > MaxClients)
	{
		return Plugin_Handled;
	}

	bool inMode = (g_PlayerDebugFlags[client] & DEBUG_NEXTBOT) != 0;
	if (!inMode)
	{
		g_PlayerDebugFlags[client] |= DEBUG_NEXTBOT;
		PrintToChat(client, "Enabled debugging nextbot.");
	}
	else
	{
		g_PlayerDebugFlags[client] &= ~DEBUG_NEXTBOT;
		PrintToChat(client, "Disabled debugging nextbot.");
	}

	return Plugin_Handled;
}

static Action Command_DebugPlayerStress(int client, int args)
{
	if (client < 1 || client > MaxClients)
	{
		return Plugin_Handled;
	}

	bool inMode = (g_PlayerDebugFlags[client] & DEBUG_PLAYER_STRESS) != 0;
	if (!inMode)
	{
		g_PlayerDebugFlags[client] |= DEBUG_PLAYER_STRESS;
		PrintToChat(client, "Enabled debugging player stress.");
	}
	else
	{
		g_PlayerDebugFlags[client] &= ~DEBUG_PLAYER_STRESS;
		PrintToChat(client, "Disabled debugging player stress.");
	}

	return Plugin_Handled;
}

static Action Command_DebugBossProxies(int client, int args)
{
	if (client < 1 || client > MaxClients)
	{
		return Plugin_Handled;
	}

	bool inMode = (g_PlayerDebugFlags[client] & DEBUG_BOSS_PROXIES) != 0;
	if (!inMode)
	{
		g_PlayerDebugFlags[client] |= DEBUG_BOSS_PROXIES;
		PrintToChat(client, "Enabled debugging boss proxies.");
	}
	else
	{
		g_PlayerDebugFlags[client] &= ~DEBUG_BOSS_PROXIES;
		PrintToChat(client, "Disabled debugging boss proxies.");
	}

	return Plugin_Handled;
}
static Action Command_DebugHitbox(int client, int args)
{
	if (client < 1 || client > MaxClients)
	{
		return Plugin_Handled;
	}

	bool inMode = (g_PlayerDebugFlags[client] & DEBUG_BOSS_HITBOX) != 0;
	if (!inMode)
	{
		g_PlayerDebugFlags[client] |= DEBUG_BOSS_HITBOX;
		PrintToChat(client, "Enabled debugging boss's hitbox.");
	}
	else
	{
		g_PlayerDebugFlags[client] &= ~DEBUG_BOSS_HITBOX;
		PrintToChat(client, "Disabled debugging boss's hitbox.");
	}

	return Plugin_Handled;
}

static Action Command_DebugStun(int client, int args)
{
	if (client < 1 || client > MaxClients)
	{
		return Plugin_Handled;
	}

	bool inMode = (g_PlayerDebugFlags[client] & DEBUG_BOSS_STUN) != 0;
	if (!inMode)
	{
		g_PlayerDebugFlags[client] |= DEBUG_BOSS_STUN;
		PrintToChat(client, "Enabled debugging boss's stun.");
	}
	else
	{
		g_PlayerDebugFlags[client] &= ~DEBUG_BOSS_STUN;
		PrintToChat(client, "Disabled debugging boss's stun.");
	}

	return Plugin_Handled;
}

static Action Command_DebugGhostMode(int client, int args)
{
	if (client < 1 || client > MaxClients)
	{
		return Plugin_Handled;
	}

	bool inMode = (g_PlayerDebugFlags[client] & DEBUG_GHOSTMODE) != 0;
	if (!inMode)
	{
		g_PlayerDebugFlags[client] |= DEBUG_GHOSTMODE;
		PrintToChat(client, "Enabled debugging ghost mode.");
	}
	else
	{
		g_PlayerDebugFlags[client] &= ~DEBUG_GHOSTMODE;
		PrintToChat(client, "Disabled debugging ghost mode.");
	}

	return Plugin_Handled;
}

static Action Command_DebugEntity(int client, int args)
{
	if (client < 1 || client > MaxClients)
	{
		return Plugin_Handled;
	}

	bool inMode = (g_PlayerDebugFlags[client] & DEBUG_ENTITIES) != 0;
	if (!inMode)
	{
		g_PlayerDebugFlags[client] |= DEBUG_ENTITIES;
		PrintToChat(client, "Enabled debugging entities.");
	}
	else
	{
		g_PlayerDebugFlags[client] &= ~DEBUG_ENTITIES;
		PrintToChat(client, "Disabled debugging entities.");
	}

	return Plugin_Handled;
}

static Action Command_DebugEvent(int client, int args)
{
	if (client < 1 || client > MaxClients)
	{
		return Plugin_Handled;
	}

	bool inMode = (g_PlayerDebugFlags[client] & DEBUG_EVENT) != 0;
	if (!inMode)
	{
		g_PlayerDebugFlags[client] |= DEBUG_EVENT;
		PrintToChat(client, "Enabled debugging events.");
	}
	else
	{
		g_PlayerDebugFlags[client] &= ~DEBUG_EVENT;
		PrintToChat(client, "Disabled debugging events.");
	}

	return Plugin_Handled;
}

static Action Command_DebugKillIcons(int client, int args)
{
	if (client < 1 || client > MaxClients)
	{
		return Plugin_Handled;
	}

	bool inMode = (g_PlayerDebugFlags[client] & DEBUG_KILLICONS) != 0;
	if (!inMode)
	{
		g_PlayerDebugFlags[client] |= DEBUG_KILLICONS;
		PrintToChat(client, "Enabled debugging kill icons.");
	}
	else
	{
		g_PlayerDebugFlags[client] &= ~DEBUG_KILLICONS;
		PrintToChat(client, "Disabled debugging kill icons.");
	}

	return Plugin_Handled;
}

void TE_DrawBox(int client, float origin[3], float endOrigin[3], float mins[3], float maxs[3], float duration = 0.1, int laserIndex, int color[4])
{
	if( mins[0] == maxs[0] && mins[1] == maxs[1] && mins[2] == maxs[2] )
	{
		mins = {-15.0, -15.0, -15.0};
		maxs = {15.0, 15.0, 15.0};
	}
	else
	{
		AddVectors(endOrigin, maxs, maxs);
		AddVectors(origin, mins, mins);
	}

	float pos1[3], pos2[3], pos3[3], pos4[3], pos5[3], pos6[3];
	pos1 = maxs;
	pos1[0] = mins[0];
	pos2 = maxs;
	pos2[1] = mins[1];
	pos3 = maxs;
	pos3[2] = mins[2];
	pos4 = mins;
	pos4[0] = maxs[0];
	pos5 = mins;
	pos5[1] = maxs[1];
	pos6 = mins;
	pos6[2] = maxs[2];

	TE_SendBeam(client, maxs, pos1, duration, laserIndex, color);
	TE_SendBeam(client, maxs, pos2, duration, laserIndex, color);
	TE_SendBeam(client, maxs, pos3, duration, laserIndex, color);
	TE_SendBeam(client, pos6, pos1, duration, laserIndex, color);
	TE_SendBeam(client, pos6, pos2, duration, laserIndex, color);
	TE_SendBeam(client, pos6, mins, duration, laserIndex, color);
	TE_SendBeam(client, pos4, mins, duration, laserIndex, color);
	TE_SendBeam(client, pos5, mins, duration, laserIndex, color);
	TE_SendBeam(client, pos5, pos1, duration, laserIndex, color);
	TE_SendBeam(client, pos5, pos3, duration, laserIndex, color);
	TE_SendBeam(client, pos4, pos3, duration, laserIndex, color);
	TE_SendBeam(client, pos4, pos2, duration, laserIndex, color);
}

void TE_SendBeam(int client, float mins[3], float maxs[3], float duration = 0.1, int laserIndex, int color[4])
{
	TE_SetupBeamPoints(mins, maxs, laserIndex, laserIndex, 0, 30, duration, 1.0, 1.0, 1, 0.0, color, 30);
	TE_SendToClient(client);
}