#pragma semicolon 1

// Anti-camping data.
int g_PlayerCampingStrikes[MAXTF2PLAYERS] = { 0, ... };
Handle g_PlayerCampingTimer[MAXTF2PLAYERS] = { null, ... };
float g_PlayerCampingLastPosition[MAXTF2PLAYERS][3];
bool g_IsPlayerCampingFirstTime[MAXTF2PLAYERS];
static float g_ClientAllowedTimeNearEscape[MAXTF2PLAYERS];

static ConVar g_CampingEnabledConVar;
static ConVar g_CampingMaxStrikesConVar;
static ConVar g_CampingStrikesWarnConVar;
static ConVar g_ExitCampingTimeAllowedConVar;
static ConVar g_CampingMinDistanceConVar;
static ConVar g_CampingNoStrikeSanityConVar;
static ConVar g_CampingNoStrikeBossDistanceConVar;

void SetupAntiCamping()
{
	g_OnPlayerPutInServerPFwd.AddFunction(null, OnPutInServer);
	g_OnPlayerSpawnPFwd.AddFunction(null, OnPlayerSpawn);
	g_OnPlayerDeathPFwd.AddFunction(null, OnPlayerDeath);
	g_OnPlayerEscapePFwd.AddFunction(null, OnPlayerEscape);

	g_CampingEnabledConVar = CreateConVar("sf2_anticamping_enabled", "1", "Enable/Disable anti-camping system for RED.", _, true, 0.0, true, 1.0);
	g_CampingMaxStrikesConVar = CreateConVar("sf2_anticamping_maxstrikes", "4", "How many 5-second intervals players are allowed to stay in one spot before he/she is forced to suicide.", _, true, 0.0);
	g_CampingStrikesWarnConVar = CreateConVar("sf2_anticamping_strikeswarn", "2", "The amount of strikes left where the player will be warned of camping.");
	g_ExitCampingTimeAllowedConVar = CreateConVar("sf2_exitcamping_allowedtime", "25.0", "The amount of time a player can stay near the exit before being flagged as camper.");
	g_CampingMinDistanceConVar = CreateConVar("sf2_anticamping_mindistance", "128.0", "Every 5 seconds the player has to be at least this far away from his last position 5 seconds ago or else he'll get a strike.");
	g_CampingNoStrikeSanityConVar = CreateConVar("sf2_anticamping_no_strike_sanity", "0.1", "The camping system will NOT give any strikes under any circumstances if the players's Sanity is missing at least this much of his maximum Sanity (max is 1.0).");
	g_CampingNoStrikeBossDistanceConVar = CreateConVar("sf2_anticamping_no_strike_boss_distance", "512.0", "The camping system will NOT give any strikes under any circumstances if the player is this close to a boss (ignoring LOS).");
}

static void OnPutInServer(SF2_BasePlayer client)
{
	ClientResetCampingStats(client.index);
}

static void OnPlayerSpawn(SF2_BasePlayer client)
{
	ClientResetCampingStats(client.index);

	if (!client.IsEliminated)
	{
		ClientStartCampingTimer(client.index);
	}
}

static void OnPlayerDeath(SF2_BasePlayer client, int attacker, int inflictor, bool fake)
{
	if (!fake)
	{
		ClientResetCampingStats(client.index);
	}
}

static void OnPlayerEscape(SF2_BasePlayer client)
{
	ClientResetCampingStats(client.index);
}

static void ClientResetCampingStats(int client)
{
	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START ClientResetCampingStats(%d)", client);
	}
	#endif

	g_PlayerCampingStrikes[client] = 0;
	g_PlayerIsExitCamping[client] = false;
	g_PlayerCampingTimer[client] = null;
	g_IsPlayerCampingFirstTime[client] = true;
	g_PlayerCampingLastPosition[client][0] = 0.0;
	g_PlayerCampingLastPosition[client][1] = 0.0;
	g_PlayerCampingLastPosition[client][2] = 0.0;
	g_ClientAllowedTimeNearEscape[client] = g_ExitCampingTimeAllowedConVar.FloatValue;

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END ClientResetCampingStats(%d)", client);
	}
	#endif
}

static void ClientStartCampingTimer(int client)
{
	g_PlayerCampingTimer[client] = CreateTimer(5.0, Timer_ClientCheckCamp, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

/*void ClientNavAreaUpdate(int client, CNavArea newArea, CNavArea oldArea)
{
	if (GetRoundState() != SF2RoundState_Active) return;

	if (g_PlayerEliminated[client]) return;

	if (newArea == INVALID_NAV_AREA) return;

	if ((oldArea != INVALID_NAV_AREA && oldArea.Attributes & NAV_MESH_DONT_HIDE) || newArea.Attributes & NAV_MESH_DONT_HIDE)
	{
		g_ClientAllowedTimeNearEscape[client] -= 0.3;//Remove 0.3sec this function is called every ~0.3sec
	}
	else
	{
		g_ClientAllowedTimeNearEscape[client] += 0.1;//Forgive the player of 0.1
	}
	if (g_ClientAllowedTimeNearEscape[client] <= 0.0 && SF_IsSurvivalMap())
	{
		g_PlayerIsExitCamping[client] = true;
	}
	else
	{
		g_PlayerIsExitCamping[client] = false;
	}
	#if defined DEBUG
	SendDebugMessageToPlayer(client, DEBUG_NAV, 1, "Old area: %i DHF:%s, New area: %i DHF:%s, is considered as exit camper: %s", oldArea.Index, (oldArea.Attributes & NAV_MESH_DONT_HIDE) ? "true" : "false", newArea.Index, (newArea.Attributes & NAV_MESH_DONT_HIDE) ? "true" : "false", (g_PlayerIsExitCamping[client]) ? "true" : "false" );
	#endif
}*/

static Action Timer_ClientCheckCamp(Handle timer, any userid)
{
	if (IsRoundInWarmup())
	{
		return Plugin_Stop;
	}

	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerCampingTimer[client])
	{
		return Plugin_Stop;
	}

	if (IsRoundEnding() || !IsPlayerAlive(client) || g_PlayerEliminated[client] || DidClientEscape(client))
	{
		return Plugin_Stop;
	}

	if (!g_IsPlayerCampingFirstTime[client])
	{
		bool isCamping = false;
		float pos[3], maxs[3], mins[3];
		GetClientAbsOrigin(client, pos);
		GetEntPropVector(client, Prop_Send, "m_vecMins", mins);
		GetEntPropVector(client, Prop_Send, "m_vecMaxs", maxs);

		// Only do something if the player is NOT stuck.
		float distFromLastPosition = GetVectorSquareMagnitude(g_PlayerCampingLastPosition[client], pos);
		float distFromClosestBoss = 9999999.0;
		int closestBoss = -1;

		for (int i = 0; i < MAX_BOSSES; i++)
		{
			if (NPCGetUniqueID(i) == -1)
			{
				continue;
			}

			int slender = NPCGetEntIndex(i);
			if (!slender || slender == INVALID_ENT_REFERENCE)
			{
				continue;
			}

			float slenderPos[3];
			SlenderGetAbsOrigin(i, slenderPos);

			float dist = GetVectorSquareMagnitude(slenderPos, pos);
			if (dist < distFromClosestBoss)
			{
				closestBoss = i;
				distFromClosestBoss = dist;
			}
		}
		/*if (IsSpaceOccupiedIgnorePlayers(pos, mins, maxs, client))
			//LogSF2Message("[SF2 AFK TIMER] Client %i (%N) is stuck, no actions taken", client, client);*/
		if (!SF_IsBoxingMap() && g_CampingEnabledConVar.BoolValue &&
		IsRoundPlaying() &&
			g_PlayerStaticAmount[client] <= g_CampingNoStrikeSanityConVar.FloatValue &&
			(closestBoss == -1 || distFromClosestBoss >= g_CampingNoStrikeBossDistanceConVar.FloatValue) &&
			distFromLastPosition <= SquareFloat(g_CampingMinDistanceConVar.FloatValue))
		{
			isCamping = true;
			//LogSF2Message("[SF2 AFK TIMER] Client %i (%N) is afk, or camping", client, client);
		}
		if (isCamping)
		{
			g_PlayerCampingStrikes[client]++;
			if (g_PlayerCampingStrikes[client] < g_CampingMaxStrikesConVar.IntValue)
			{
				if (g_PlayerCampingStrikes[client] >= g_CampingStrikesWarnConVar.IntValue)
				{
					CPrintToChat(client, "{red}%T", "SF2 Camping System Warning", client, (g_CampingMaxStrikesConVar.IntValue - g_PlayerCampingStrikes[client]) * 5);
				}
			}
			else
			{
				g_PlayerCampingStrikes[client] = 0;
				ClientStartDeathCam(client, 0, pos, true);
			}
		}
		else
		{
			// Forgiveness.
			if (g_PlayerCampingStrikes[client] > 0)
			{
				//LogSF2Message("[SF2 AFK TIMER] Client %i (%N) is forgiven of one strike.", client, client);
				g_PlayerCampingStrikes[client]--;
			}
		}

		g_PlayerCampingLastPosition[client][0] = pos[0];
		g_PlayerCampingLastPosition[client][1] = pos[1];
		g_PlayerCampingLastPosition[client][2] = pos[2];
	}
	else
	{
		g_IsPlayerCampingFirstTime[client] = false;
		//LogSF2Message("[SF2 AFK TIMER] Client %i (%N) is afk/camping for the 1st time since the reset, don't take any actions for now.....", client, client);
	}

	return Plugin_Continue;
}
