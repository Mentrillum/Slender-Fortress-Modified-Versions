#if defined _sf2_debug_included
 #endinput
#endif
#define _sf2_debug_included

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
#define DEBUG_NAV (1 << 10)
#define DEBUG_BOSS_ANIMATION (1 << 11)
#define DEBUG_EVENT (1 << 12)
#define DEBUG_KILLICONS (1 << 13)
#define DEBUG_ARRAYLIST (1 << 14)
#define DEBUG_BOSS_IDLE (1 << 15)

int g_iPlayerDebugFlags[MAXPLAYERS + 1] = { 0, ... };

static char g_strDebugLogFilePath[512] = "";

ConVar g_cvDebugDetail = null;

void InitializeDebug()
{
	g_cvDebugDetail = CreateConVar("sf2_debug_detail", "0", "0 = off, 1 = debug only large, expensive functions, 2 = debug more events, 3 = debug client functions");
	
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
	RegAdminCmd("sm_sf2_debug_nav", Command_DebugNav, ADMFLAG_CHEATS);
	RegAdminCmd("sm_sf2_debug_events", Command_DebugEvent, ADMFLAG_CHEATS);
	RegAdminCmd("sm_sf2_debug_kill_icons", Command_DebugKillIcons, ADMFLAG_CHEATS);
	RegAdminCmd("sm_sf2_debug_arraylists", Command_DebugArrayLists, ADMFLAG_CHEATS);
	RegAdminCmd("sm_sf2_debug_boss_idle", Command_DebugBossIdle, ADMFLAG_CHEATS);
}

void InitializeDebugLogging()
{
	char sDateSuffix[256];
	FormatTime(sDateSuffix, sizeof(sDateSuffix), "sf2-debug-%Y-%m-%d.log", GetTime());
	
	BuildPath(Path_SM, g_strDebugLogFilePath, sizeof(g_strDebugLogFilePath), "logs/%s", sDateSuffix);
	
	char sMap[64];
	GetCurrentMap(sMap, sizeof(sMap));
	
	DebugMessage("-------- Mapchange to %s -------", sMap);
}

stock void DebugMessage(const char[] sMessage, any ...)
{
	char sDebugMessage[1024], sTemp[1024];
	VFormat(sTemp, sizeof(sTemp), sMessage, 2);
	FormatEx(sDebugMessage, sizeof(sDebugMessage), "%s", sTemp);
	//LogMessage(sDebugMessage);
	LogToFile(g_strDebugLogFilePath, sDebugMessage);
}

stock void SendDebugMessageToPlayer(int client,int iDebugFlags,int iType, const char[] sMessage, any ...)
{
	if (!IsClientInGame(client) || IsFakeClient(client)) return;

	char sMsg[1024];
	VFormat(sMsg, sizeof(sMsg), sMessage, 5);
	
	if (g_iPlayerDebugFlags[client] & iDebugFlags)
	{
		switch (iType)
		{
			case 0: CPrintToChat(client, sMsg);
			case 1: PrintCenterText(client, sMsg);
			case 2: PrintHintText(client, sMsg);
		}
	}
}

stock void SendDebugMessageToPlayers(int iDebugFlags,int iType, const char[] sMessage, any ...)
{
	char sMsg[1024];
	VFormat(sMsg, sizeof(sMsg), sMessage, 4);

	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i) || IsFakeClient(i)) continue;
		
		if (g_iPlayerDebugFlags[i] & iDebugFlags)
		{
			switch (iType)
			{
				case 0: CPrintToChat(i, sMsg);
				case 1: PrintCenterText(i, sMsg);
				case 2: PrintHintText(i, sMsg);
			}
		}
	}
}

public Action Command_DebugBossTeleport(int client,int args)
{
	if (client < 1 || client > MaxClients) return Plugin_Handled;
	
	bool bInMode = view_as<bool>(g_iPlayerDebugFlags[client] & DEBUG_BOSS_TELEPORTATION);
	if (!bInMode)
	{
		g_iPlayerDebugFlags[client] |= DEBUG_BOSS_TELEPORTATION;
		PrintToChat(client, "Enabled debugging boss teleportation.");
	}
	else
	{
		g_iPlayerDebugFlags[client] &= ~DEBUG_BOSS_TELEPORTATION;
		PrintToChat(client, "Disabled debugging boss teleportation.");
	}
	
	return Plugin_Handled;
}

public Action Command_DebugBossChase(int client,int args)
{
	if (client < 1 || client > MaxClients) return Plugin_Handled;
	
	bool bInMode = view_as<bool>(g_iPlayerDebugFlags[client] & DEBUG_BOSS_CHASE);
	if (!bInMode)
	{
		g_iPlayerDebugFlags[client] |= DEBUG_BOSS_CHASE;
		PrintToChat(client, "Enabled debugging boss chasing.");
	}
	else
	{
		g_iPlayerDebugFlags[client] &= ~DEBUG_BOSS_CHASE;
		PrintToChat(client, "Disabled debugging boss chasing.");
	}
	
	return Plugin_Handled;
}

public Action Command_DebugBossIdle(int client,int args)
{
	if (client < 1 || client > MaxClients) return Plugin_Handled;
	
	bool bInMode = view_as<bool>(g_iPlayerDebugFlags[client] & DEBUG_BOSS_IDLE);
	if (!bInMode)
	{
		g_iPlayerDebugFlags[client] |= DEBUG_BOSS_IDLE;
		PrintToChat(client, "Enabled debugging boss idling.");
	}
	else
	{
		g_iPlayerDebugFlags[client] &= ~DEBUG_BOSS_IDLE;
		PrintToChat(client, "Disabled debugging boss idling.");
	}
	
	return Plugin_Handled;
}

public Action Command_DebugBossAnimation(int client,int args)
{
	if (client < 1 || client > MaxClients) return Plugin_Handled;
	
	bool bInMode = view_as<bool>(g_iPlayerDebugFlags[client] & DEBUG_BOSS_ANIMATION);
	if (!bInMode)
	{
		g_iPlayerDebugFlags[client] |= DEBUG_BOSS_ANIMATION;
		PrintToChat(client, "Enabled debugging boss animation.");
	}
	else
	{
		g_iPlayerDebugFlags[client] &= ~DEBUG_BOSS_ANIMATION;
		PrintToChat(client, "Disabled debugging boss animation.");
	}
	
	return Plugin_Handled;
}

public Action Command_DebugNextbot(int client,int args)
{
	if (client < 1 || client > MaxClients) return Plugin_Handled;
	
	bool bInMode = view_as<bool>(g_iPlayerDebugFlags[client] & DEBUG_NEXTBOT);
	if (!bInMode)
	{
		g_iPlayerDebugFlags[client] |= DEBUG_NEXTBOT;
		PrintToChat(client, "Enabled debugging nextbot.");
	}
	else
	{
		g_iPlayerDebugFlags[client] &= ~DEBUG_NEXTBOT;
		PrintToChat(client, "Disabled debugging nextbot.");
	}
	
	return Plugin_Handled;
}

public Action Command_DebugPlayerStress(int client, int args)
{
	if (client < 1 || client > MaxClients) return Plugin_Handled;
	
	bool bInMode = view_as<bool>(g_iPlayerDebugFlags[client] & DEBUG_PLAYER_STRESS);
	if (!bInMode)
	{
		g_iPlayerDebugFlags[client] |= DEBUG_PLAYER_STRESS;
		PrintToChat(client, "Enabled debugging player stress.");
	}
	else
	{
		g_iPlayerDebugFlags[client] &= ~DEBUG_PLAYER_STRESS;
		PrintToChat(client, "Disabled debugging player stress.");
	}
	
	return Plugin_Handled;
}

public Action Command_DebugBossProxies(int client, int args)
{
	if (client < 1 || client > MaxClients) return Plugin_Handled;
	
	bool bInMode = view_as<bool>(g_iPlayerDebugFlags[client] & DEBUG_BOSS_PROXIES);
	if (!bInMode)
	{
		g_iPlayerDebugFlags[client] |= DEBUG_BOSS_PROXIES;
		PrintToChat(client, "Enabled debugging boss proxies.");
	}
	else
	{
		g_iPlayerDebugFlags[client] &= ~DEBUG_BOSS_PROXIES;
		PrintToChat(client, "Disabled debugging boss proxies.");
	}
	
	return Plugin_Handled;
}
public Action Command_DebugHitbox(int client, int args)
{
	if (client < 1 || client > MaxClients) return Plugin_Handled;
	
	bool bInMode = view_as<bool>(g_iPlayerDebugFlags[client] & DEBUG_BOSS_HITBOX);
	if (!bInMode)
	{
		g_iPlayerDebugFlags[client] |= DEBUG_BOSS_HITBOX;
		PrintToChat(client, "Enabled debugging boss's hitbox.");
	}
	else
	{
		g_iPlayerDebugFlags[client] &= ~DEBUG_BOSS_HITBOX;
		PrintToChat(client, "Disabled debugging boss's hitbox.");
	}
	
	return Plugin_Handled;
}

public Action Command_DebugStun(int client, int args)
{
	if (client < 1 || client > MaxClients) return Plugin_Handled;
	
	bool bInMode = view_as<bool>(g_iPlayerDebugFlags[client] & DEBUG_BOSS_STUN);
	if (!bInMode)
	{
		g_iPlayerDebugFlags[client] |= DEBUG_BOSS_STUN;
		PrintToChat(client, "Enabled debugging boss's stun.");
	}
	else
	{
		g_iPlayerDebugFlags[client] &= ~DEBUG_BOSS_STUN;
		PrintToChat(client, "Disabled debugging boss's stun.");
	}
	
	return Plugin_Handled;
}

public Action Command_DebugGhostMode(int client, int args)
{
	if (client < 1 || client > MaxClients) return Plugin_Handled;
	
	bool bInMode = view_as<bool>(g_iPlayerDebugFlags[client] & DEBUG_GHOSTMODE);
	if (!bInMode)
	{
		g_iPlayerDebugFlags[client] |= DEBUG_GHOSTMODE;
		PrintToChat(client, "Enabled debugging ghost mode.");
	}
	else
	{
		g_iPlayerDebugFlags[client] &= ~DEBUG_GHOSTMODE;
		PrintToChat(client, "Disabled debugging ghost mode.");
	}
	
	return Plugin_Handled;
}

public Action Command_DebugEntity(int client, int args)
{
	if (client < 1 || client > MaxClients) return Plugin_Handled;
	
	bool bInMode = view_as<bool>(g_iPlayerDebugFlags[client] & DEBUG_ENTITIES);
	if (!bInMode)
	{
		g_iPlayerDebugFlags[client] |= DEBUG_ENTITIES;
		PrintToChat(client, "Enabled debugging entities.");
	}
	else
	{
		g_iPlayerDebugFlags[client] &= ~DEBUG_ENTITIES;
		PrintToChat(client, "Disabled debugging entities.");
	}
	
	return Plugin_Handled;
}

public Action Command_DebugNav(int client,int args)
{
	if (client < 1 || client > MaxClients) return Plugin_Handled;
	
	bool bInMode = view_as<bool>(g_iPlayerDebugFlags[client] & DEBUG_NAV);
	if (!SF_SpecialRound(SPECIALROUND_DEBUGMODE))
	{
		if (!bInMode)
		{
			g_iPlayerDebugFlags[client] |= DEBUG_NAV;
			PrintToChat(client, "Enabled debugging nav.");
		}
		else
		{
			g_iPlayerDebugFlags[client] &= ~DEBUG_NAV;
			PrintToChat(client, "Disabled debugging nav.");
		}

		g_bDebuggingBossPathing = !bInMode;
	}
	else PrintToChat(client, "This command cannot be used at this time.");
	
	return Plugin_Handled;
}

public Action Command_DebugEvent(int client,int args)
{
	if (client < 1 || client > MaxClients) return Plugin_Handled;
	
	bool bInMode = view_as<bool>(g_iPlayerDebugFlags[client] & DEBUG_EVENT);
	if (!bInMode)
	{
		g_iPlayerDebugFlags[client] |= DEBUG_EVENT;
		PrintToChat(client, "Enabled debugging events.");
	}
	else
	{
		g_iPlayerDebugFlags[client] &= ~DEBUG_EVENT;
		PrintToChat(client, "Disabled debugging events.");
	}
	
	return Plugin_Handled;
}

public Action Command_DebugKillIcons(int client,int args)
{
	if (client < 1 || client > MaxClients) return Plugin_Handled;
	
	bool bInMode = view_as<bool>(g_iPlayerDebugFlags[client] & DEBUG_KILLICONS);
	if (!bInMode)
	{
		g_iPlayerDebugFlags[client] |= DEBUG_KILLICONS;
		PrintToChat(client, "Enabled debugging kill icons.");
	}
	else
	{
		g_iPlayerDebugFlags[client] &= ~DEBUG_KILLICONS;
		PrintToChat(client, "Disabled debugging kill icons.");
	}
	
	return Plugin_Handled;
}

public Action Command_DebugArrayLists(int client,int args)
{
	if (client < 1 || client > MaxClients) return Plugin_Handled;
	
	bool bInMode = view_as<bool>(g_iPlayerDebugFlags[client] & DEBUG_ARRAYLIST);
	if (!bInMode)
	{
		g_iPlayerDebugFlags[client] |= DEBUG_ARRAYLIST;
		PrintToChat(client, "Enabled debugging array lists.");
	}
	else
	{
		g_iPlayerDebugFlags[client] &= ~DEBUG_ARRAYLIST;
		PrintToChat(client, "Disabled debugging array lists.");
	}
	
	return Plugin_Handled;
}