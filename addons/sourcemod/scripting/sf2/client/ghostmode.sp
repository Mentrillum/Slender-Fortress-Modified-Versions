#pragma semicolon 1

#define SF2_OVERLAY_GHOST "overlays/slender/ghostcamera"

static bool g_PlayerInGhostMode[MAXTF2PLAYERS] = { false, ... };
static int g_PlayerGhostModeTarget[MAXTF2PLAYERS] = { INVALID_ENT_REFERENCE, ... };
static int g_PlayerGhostModeBossTarget[MAXTF2PLAYERS] = { INVALID_ENT_REFERENCE, ... };
Handle g_PlayerGhostModeConnectionCheckTimer[MAXTF2PLAYERS] = { null, ... };
float g_PlayerGhostModeConnectionTimeOutTime[MAXTF2PLAYERS] = { -1.0, ... };
float g_PlayerGhostModeConnectionBootTime[MAXTF2PLAYERS] = { -1.0, ... };

void SetupGhost()
{
	g_OnPlayerPutInServerPFwd.AddFunction(null, OnPutInServer);
	g_OnPlayerSpawnPFwd.AddFunction(null, OnPlayerSpawn);
	g_OnPlayerDeathPFwd.AddFunction(null, OnPlayerDeath);
	g_OnPlayerEscapePFwd.AddFunction(null, OnPlayerEscape);
	g_OnPlayerTeamPFwd.AddFunction(null, OnPlayerTeam);
}

static void OnPutInServer(SF2_BasePlayer client)
{
	if (!g_Enabled)
	{
		return;
	}
	ClientSetGhostModeState(client.index, false);
}

static void OnPlayerSpawn(SF2_BasePlayer client)
{
	if (!IsClientParticipating(client.index))
	{
		ClientSetGhostModeState(client.index, false);
	}
	ClientHandleGhostMode(client.index);
}

static void OnPlayerDeath(SF2_BasePlayer client, int attacker, int inflictor, bool fake)
{
	if (!g_Enabled)
	{
		return;
	}

	if (fake || IsRoundInWarmup() || client.IsEliminated)
	{
		return;
	}

	if (g_PlayerPreferences[client.index].PlayerPreference_GhostModeToggleState == 2)
	{
		CreateTimer(0.25, Timer_ToggleGhostModeCommand, client.UserID, TIMER_FLAG_NO_MAPCHANGE);
	}
}

static void OnPlayerEscape(SF2_BasePlayer client)
{
	ClientHandleGhostMode(client.index);
}

static void OnPlayerTeam(SF2_BasePlayer client, int team)
{
	if (team <= TFTeam_Spectator)
	{
		ClientSetGhostModeState(client.index, false);
	}
}

bool IsClientInGhostMode(int client)
{
	return g_PlayerInGhostMode[client];
}

/**
 *	Enables/Disables ghost mode on the player.
 */
void ClientSetGhostModeState(int client, bool state)
{
	if (state == g_PlayerInGhostMode[client])
	{
		return;
	}

	Handle message = StartMessageAll("PlayerTauntSoundLoopEnd", USERMSG_RELIABLE);
	BfWriteByte(message, client);
	delete message;
	EndMessage();

	if (state && !IsValidClient(client))
	{
		return;
	}

	Call_StartForward(g_OnPlayerChangeGhostStatePFwd);
	Call_PushCell(SF2_BasePlayer(client));
	Call_PushCell(state);
	Call_Finish();

	g_PlayerInGhostMode[client] = state;
	g_PlayerGhostModeTarget[client] = INVALID_ENT_REFERENCE;
	g_PlayerGhostModeBossTarget[client] = INVALID_ENT_REFERENCE;

	if (state)
	{
		#if defined DEBUG
		SendDebugMessageToPlayer(client, DEBUG_GHOSTMODE, 0, "{green}Entered ghost mode.");
		#endif
		//Strip the always edict flag
		SetEntityFlags(client, GetEntityFlags(client) ^ FL_EDICT_ALWAYS);
		//Remove the fire cond
		TF2_RemoveCondition(client,TFCond_OnFire);
		//Call the spawn event.
		TF2_RespawnPlayer(client);
		TF2_RemoveCondition(client,TFCond_Taunting);

		TFClassType desiredClass = TF2_GetPlayerClass(client);
		if (desiredClass == TFClass_Unknown)
		{
			desiredClass = TFClass_Spy;
		}

		//Set player's class to spy, this replaces old ghost mode mechanics.
		TF2_SetPlayerClass(client, TFClass_Spy);
		TF2_RegeneratePlayer(client);

		//Set player's old class as desired class.
		SetEntProp(client, Prop_Send, "m_iDesiredPlayerClass", desiredClass);

		ClientHandleGhostMode(client, true);
		if (g_GhostModeConnectionCheckConVar.BoolValue)
		{
			g_PlayerGhostModeConnectionCheckTimer[client] = CreateTimer(0.0, Timer_GhostModeConnectionCheck, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			g_PlayerGhostModeConnectionTimeOutTime[client] = -1.0;
			g_PlayerGhostModeConnectionBootTime[client] = -1.0;
		}

		SetEntityCollisionGroup(client, 1);

		PvP_OnClientGhostModeEnable(client);
	}
	else
	{
		#if defined DEBUG
		SendDebugMessageToPlayer(client, DEBUG_GHOSTMODE, 0, "{green}Exited ghost mode.");
		#endif
		TF2Attrib_SetByName(client, "mod see enemy health", 0.0);
		g_PlayerGhostModeConnectionCheckTimer[client] = null;
		g_PlayerGhostModeConnectionTimeOutTime[client] = -1.0;
		g_PlayerGhostModeConnectionBootTime[client] = -1.0;

		if (IsValidClient(client))
		{
			SetEntProp(client, Prop_Data, "m_takedamage", DAMAGE_YES);
			TF2_RemoveCondition(client, TFCond_Stealthed);
			SetEntProp(client, Prop_Send, "m_bDrawViewmodel", 1);
			SetEntityGravity(client, 1.0);
			SetEntPropEnt(client, Prop_Send, "m_hGroundEntity", -1);
			SetEntityFlags(client, GetEntityFlags(client) &~ FL_NOTARGET);
			SetEntProp(client, Prop_Data, "m_usSolidFlags", 16);
			SetEntProp(client, Prop_Send, "m_nSolidType", 2);
			SetEntPropFloat(client, Prop_Send, "m_flModelScale", 1.0);
			SetEntPropFloat(client, Prop_Send, "m_flHeadScale", 1.0);
			SetEntPropFloat(client, Prop_Send, "m_flTorsoScale", 1.0);
			SetEntPropFloat(client, Prop_Send, "m_flHandScale", 1.0);
			SetEntityRenderMode(client, RENDER_NORMAL);
			SetEntityRenderColor(client, _, _, _, 255);
			SetEntityCollisionGroup(client, COLLISION_GROUP_PLAYER);
		}
	}
}

/**
 *	Makes sure that the player is a ghost when ghost mode is activated.
 */
void ClientHandleGhostMode(int client, bool forceSpawn = false)
{
	if (!IsClientInGhostMode(client))
	{
		return;
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START ClientHandleGhostMode(%d, %d)", client, forceSpawn);
	}
	#endif

	if (!TF2_IsPlayerInCondition(client, TFCond_Stealthed) || forceSpawn)
	{
		TF2_StripWearables(client);
		DestroyAllActiveWeapons(client);
		TF2_DestroySpyWeapons();
		SetEntityGravity(client, 0.5);
		TF2_AddCondition(client, TFCond_Stealthed, -1.0);
		SetEntProp(client, Prop_Send, "m_bDrawViewmodel", 0);
		SetEntProp(client, Prop_Data, "m_takedamage", DAMAGE_NO);
		SetEntProp(client, Prop_Send, "m_usSolidFlags", 4);
		SetEntProp(client, Prop_Data, "m_nSolidType", 0);
		SetEntPropEnt(client, Prop_Send, "m_hGroundEntity", -1);
		SetEntityCollisionGroup(client, 26);
		SetEntityFlags(client, GetEntityFlags(client) | FL_NOTARGET);
		SetEntityRenderMode(client, RENDER_TRANSCOLOR);
		SetEntityRenderColor(client, _, _, _, 0);
		SetEntPropFloat(client, Prop_Send, "m_flModelScale", 1.0);
		SetEntPropFloat(client, Prop_Send, "m_flHeadScale", 1.0);
		SetEntPropFloat(client, Prop_Send, "m_flTorsoScale", 1.0);
		SetEntPropFloat(client, Prop_Send, "m_flHandScale", 1.0);

		// Set first observer target.
		ClientGhostModeNextTarget(client, true);
		ClientActivateUltravision(client);

		// screen overlay timer
		g_PlayerOverlayCheck[client] = CreateTimer(0.0, Timer_PlayerOverlayCheck, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		TriggerTimer(g_PlayerOverlayCheck[client], true);

		CreateTimer(0.2, Timer_ClientGhostStripWearables, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END ClientHandleGhostMode(%d, %d)", client, forceSpawn);
	}
	#endif
}

static Action Timer_ClientGhostStripWearables(Handle timer, int userid)
{
	int client = GetClientOfUserId(userid);
	if (!IsValidClient(client))
	{
		return Plugin_Stop;
	}
	if (!IsClientInGhostMode(client))
	{
		return Plugin_Stop;
	}
	TF2_StripWearables(client);
	DestroyAllActiveWeapons(client);
	TF2_DestroySpyWeapons();
	return Plugin_Stop;
}

void ClientGhostModeNextTarget(int client, bool ignoreSetting = false)
{
	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START ClientGhostModeNextTarget(%d)", client);
	}
	#endif

	if (g_PlayerPreferences[client].PlayerPreference_GhostModeTeleportState == 0 || ignoreSetting)
	{
		int lastTarget = EntRefToEntIndex(g_PlayerGhostModeTarget[client]);
		int nextTarget = -1;
		int firstTarget = -1;
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i) && (!g_PlayerEliminated[i] || g_PlayerProxy[i]) && !IsClientInGhostMode(i) && !DidClientEscape(i) && IsPlayerAlive(i))
			{
				if (firstTarget == -1)
				{
					firstTarget = i;
				}
				if (i > lastTarget)
				{
					nextTarget = i;
					break;
				}
			}
		}

		int target = -1;
		if (IsValidClient(nextTarget))
		{
			target = nextTarget;
		}
		else
		{
			target = firstTarget;
		}

		if (IsValidClient(target))
		{
			g_PlayerGhostModeTarget[client] = EntIndexToEntRef(target);

			float pos[3], ang[3], velocity[3];
			GetClientAbsOrigin(target, pos);
			GetClientEyeAngles(target, ang);
			GetEntPropVector(target, Prop_Data, "m_vecAbsVelocity", velocity);
			TeleportEntity(client, pos, ang, velocity);
		}

		#if defined DEBUG
		if (g_DebugDetailConVar.IntValue > 2)
		{
			DebugMessage("END ClientGhostModeNextTarget(%d)", client);
		}
		#endif
	}
	else
	{
		int lastTarget = NPCGetFromEntIndex(EntRefToEntIndex(g_PlayerGhostModeBossTarget[client]));
		int nextTarget = -1;
		int firstTarget = -1;
		for (int bossIndex = 0; bossIndex < MAX_BOSSES; bossIndex++)
		{
			if (NPCGetUniqueID(bossIndex) == -1 || !IsValidEntity(NPCGetEntIndex(bossIndex)))
			{
				continue;
			}

			if (NPCGetProfileData(bossIndex).IsPvEBoss)
			{
				continue;
			}

			if (firstTarget == -1)
			{
				firstTarget = bossIndex;
			}
			if (bossIndex > lastTarget)
			{
				nextTarget = bossIndex;
				break;
			}
		}

		int target = -1;
		if (nextTarget != - 1 && NPCGetEntIndex(nextTarget) && NPCGetEntIndex(nextTarget) != INVALID_ENT_REFERENCE)
		{
			target = nextTarget;
		}
		else
		{
			target = firstTarget;
		}

		if (target != -1 && IsValidEntity(NPCGetEntIndex(target)))
		{
			g_PlayerGhostModeBossTarget[client] = EntIndexToEntRef(NPCGetEntIndex(target));

			float pos[3], ang[3], velocity[3];
			GetEntPropVector(NPCGetEntIndex(target), Prop_Data, "m_vecAbsOrigin", pos);
			GetEntPropVector(NPCGetEntIndex(target), Prop_Data, "m_angAbsRotation", ang);
			GetEntPropVector(NPCGetEntIndex(target), Prop_Data, "m_vecAbsVelocity", velocity);
			TeleportEntity(client, pos, ang, velocity);
		}

		#if defined DEBUG
		if (g_DebugDetailConVar.IntValue > 2)
		{
			DebugMessage("END ClientGhostModeNextTarget(%d)", client);
		}
		#endif
	}
}

Action Hook_GhostNoTouch(int entity, int other)
{
	if (IsValidClient(other))
	{
		if (IsClientInGhostMode(other))
		{
			return Plugin_Handled;
		}
	}
	return Plugin_Continue;
}

Action Timer_GhostModeConnectionCheck(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerGhostModeConnectionCheckTimer[client])
	{
		return Plugin_Stop;
	}

	if (!IsFakeClient(client) && IsClientTimingOut(client))
	{
		float bootTime = g_PlayerGhostModeConnectionBootTime[client];
		bool checkBool = g_GhostModeConnectionConVar.BoolValue;
		if (bootTime < 0.0 && !checkBool)
		{
			bootTime = GetGameTime() + g_GhostModeConnectionToleranceConVar.FloatValue;
			g_PlayerGhostModeConnectionBootTime[client] = bootTime;
			g_PlayerGhostModeConnectionTimeOutTime[client] = GetGameTime();
		}

		if (GetGameTime() >= bootTime || checkBool)
		{
			ClientSetGhostModeState(client, false);
			TF2_RespawnPlayer(client);

			char authString[128];
			GetClientAuthId(client, AuthId_Engine, authString, sizeof(authString));

			LogSF2Message("Removed %N (%s) from ghost mode due to timing out for %f seconds", client, authString, g_GhostModeConnectionToleranceConVar.FloatValue);

			float timeOutTime = g_PlayerGhostModeConnectionTimeOutTime[client];
			CPrintToChat(client, "\x08FF4040FF%T", "SF2 Ghost Mode Bad Connection", client, RoundFloat(bootTime - timeOutTime));

			return Plugin_Stop;
		}
	}
	else
	{
		// Player regained connection; reset.
		g_PlayerGhostModeConnectionBootTime[client] = -1.0;
	}

	return Plugin_Continue;
}
