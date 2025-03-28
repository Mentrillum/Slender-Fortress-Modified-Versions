#pragma semicolon 1
#pragma newdecls required

// Blink data.
static Handle g_PlayerBlinkTimer[MAXTF2PLAYERS] = { null, ... };
static bool g_StartBlinking[MAXTF2PLAYERS] = { false, ... };
static float g_TimeUntilStopBlinking[MAXTF2PLAYERS] = { -1.0, ... };
static bool g_PlayerBlink[MAXTF2PLAYERS] = { false, ... };
bool g_PlayerHoldingBlink[MAXTF2PLAYERS] = { false, ... };
static float g_PlayerBlinkMeter[MAXTF2PLAYERS] = { 0.0, ... };
static float g_TimeUntilUnblink[MAXTF2PLAYERS] = { 0.0, ... };
static int g_PlayerBlinkCount[MAXTF2PLAYERS] = { 0, ... };

void SetupBlink()
{
	g_OnPlayerPutInServerPFwd.AddFunction(null, OnPutInServer);
	g_OnPlayerSpawnPFwd.AddFunction(null, OnPlayerSpawn);
	g_OnPlayerDeathPFwd.AddFunction(null, OnPlayerDeath);
	g_OnPlayerEscapePFwd.AddFunction(null, OnPlayerEscape);
	g_OnPlayerLookAtBossPFwd.AddFunction(null, OnPlayerLookAtBoss);
}

static void OnPutInServer(SF2_BasePlayer client)
{
	if (!g_Enabled)
	{
		return;
	}
	ClientResetBlink(client.index);

	if (!client.IsSourceTV)
	{
		SDKHook(client.index, SDKHook_PreThinkPost, BlinkThink);
	}
}

static void OnPlayerSpawn(SF2_BasePlayer client)
{
	ClientResetBlink(client.index);
}

static void OnPlayerDeath(SF2_BasePlayer client, int attacker, int inflictor, bool fake)
{
	if (!g_Enabled)
	{
		return;
	}

	if (!fake)
	{
		ClientResetBlink(client.index);
	}
}

static void OnPlayerEscape(SF2_BasePlayer client)
{
	ClientResetBlink(client.index);
}

static void OnPlayerLookAtBoss(SF2_BasePlayer client, SF2NPC_BaseNPC boss)
{
	if (boss.IsAffectedBySight())
	{
		g_StartBlinking[client.index] = true;
		g_TimeUntilStopBlinking[client.index] = GetGameTime() + 25.0;
	}
}

bool IsClientBlinking(int client)
{
	return g_PlayerBlink[client];
}

bool IsClientHoldingBlink(int client)
{
	return g_PlayerHoldingBlink[client];
}

void ClientSetHoldingBlink(int client, bool value)
{
	g_PlayerHoldingBlink[client] = value;
}

float ClientGetBlinkMeter(int client)
{
	return g_PlayerBlinkMeter[client];
}

void ClientSetBlinkMeter(int client, float amount)
{
	g_PlayerBlinkMeter[client] = amount;
}

int ClientGetBlinkCount(int client)
{
	return g_PlayerBlinkCount[client];
}

bool ClientHasStartedBlinking(int client)
{
	return g_StartBlinking[client];
}

/**
 *	Resets all data on blinking.
 */
void ClientResetBlink(int client)
{
	g_PlayerBlinkTimer[client] = null;
	g_StartBlinking[client] = false;
	g_TimeUntilStopBlinking[client] = -1.0;
	g_PlayerBlink[client] = false;
	g_PlayerHoldingBlink[client] = false;
	g_TimeUntilUnblink[client] = 0.0;
	g_PlayerBlinkMeter[client] = 1.0;
	g_PlayerBlinkCount[client] = 0;
}

/**
 *	Sets the player into a blinking state and blinds the player
 */
void ClientBlink(int client)
{
	if (IsRoundInWarmup() || DidClientEscape(client))
	{
		return;
	}

	if (IsClientBlinking(client))
	{
		return;
	}

	if (SF_IsRaidMap() || SF_IsBoxingMap())
	{
		return;
	}

	g_PlayerBlink[client] = true;
	g_PlayerBlinkCount[client]++;
	g_PlayerBlinkMeter[client] = 0.0;
	g_PlayerBlinkTimer[client] = CreateTimer(0.0, Timer_TryUnblink, GetClientUserId(client), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	g_TimeUntilUnblink[client] = GetGameTime() + g_PlayerBlinkHoldTimeConVar.FloatValue;

	UTIL_ScreenFade(client, 100, RoundToFloor(g_PlayerBlinkHoldTimeConVar.FloatValue * 1000.0), FFADE_IN, 0, 0, 0, 255);

	Call_StartForward(g_OnClientBlinkFwd);
	Call_PushCell(client);
	Call_Finish();
}

/**
 *	Unsets the player from the blinking state.
 */
static void ClientUnblink(int client)
{
	if (!IsClientBlinking(client))
	{
		return;
	}

	g_PlayerBlink[client] = false;
	g_PlayerBlinkTimer[client] = null;
	g_PlayerBlinkMeter[client] = 1.0;
}

static void BlinkThink(int client)
{
	if (IsRoundInWarmup() || IsRoundInIntro())
	{
		return;
	}

	if (IsInfiniteBlinkEnabled())
	{
		return;
	}

	if (!g_StartBlinking[client])
	{
		return;
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);

	for (int bossIndex = 0; bossIndex < MAX_BOSSES; bossIndex++)
	{
		SF2NPC_BaseNPC controller = SF2NPC_BaseNPC(bossIndex);
		if (!controller.IsValid())
		{
			continue;
		}

		if (controller.IsAffectedBySight() && player.IsLookingAtBoss(controller))
		{
			g_TimeUntilStopBlinking[player.index] = GetGameTime() + 25.0;
		}
	}

	if (g_TimeUntilStopBlinking[player.index] < GetGameTime())
	{
		g_StartBlinking[player.index] = false;
		g_TimeUntilStopBlinking[player.index] = -1.0;
		g_PlayerBlinkMeter[player.index] = 1.0;
	}

	if (player.IsAlive && !player.IsInDeathCam && !player.IsEliminated && !player.IsInGhostMode && !IsRoundEnding())
	{
		int override = g_PlayerInfiniteBlinkOverrideConVar.IntValue;
		if ((!g_RoundInfiniteBlink && override != 1) || override == 0)
		{
			g_PlayerBlinkMeter[player.index] -= (0.15 * ClientGetBlinkRate(player.index) * GetGameFrameTime());
		}

		if (g_PlayerBlinkMeter[player.index] <= 0.0)
		{
			player.Blink();
		}
	}
}

static Action Timer_TryUnblink(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0 || timer != g_PlayerBlinkTimer[client] || !g_PlayerBlink[client])
	{
		return Plugin_Stop;
	}

	if (g_PlayerHoldingBlink[client])
	{
		// Some maps use the env_fade entity, so don't use FFADE_PURGE.
		// Instead, we resort to spamming fade messages to the client to keep
		// them blind.
		UTIL_ScreenFade(client, 100, 150, FFADE_IN, 0, 0, 0, 255);
		return Plugin_Continue;
	}

	if (GetGameTime() < g_TimeUntilUnblink[client])
	{
		return Plugin_Continue;
	}

	ClientUnblink(client);

	return Plugin_Stop;
}

static float ClientGetBlinkRate(int client)
{
	float value = g_PlayerBlinkRateConVar.FloatValue;
	TFClassType class = TF2_GetPlayerClass(client);
	int classToInt = view_as<int>(class);
	if (GetEntProp(client, Prop_Send, "m_nWaterLevel") >= 3)
	{
		// Being underwater makes you blink faster, obviously.
		value *= 0.75;
	}

	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetUniqueID(i) == -1)
		{
			continue;
		}

		BaseBossProfile profileData = SF2NPC_BaseNPC(i).GetProfileData();

		if (g_PlayerSeesSlender[client][i])
		{
			value *= profileData.BlinkLookRate;
		}

		else if (g_PlayerStaticMode[client][i] == Static_Increase)
		{
			value *= profileData.BlinkStaticRate;
		}
	}

	if (!IsClassConfigsValid())
	{
		if (class == TFClass_Sniper)
		{
			value *= 2.0;
		}
	}
	else
	{
		value *= g_ClassBlinkRateMultiplier[classToInt];
	}

	if (IsClientUsingFlashlight(client))
	{
		float startPos[3], endPos[3], direction[3];
		float length = SF2_FLASHLIGHT_LENGTH;
		GetClientEyePosition(client, startPos);
		GetClientEyePosition(client, endPos);
		GetClientEyeAngles(client, direction);
		GetAngleVectors(direction, direction, NULL_VECTOR, NULL_VECTOR);
		NormalizeVector(direction, direction);
		ScaleVector(direction, length);
		AddVectors(endPos, direction, endPos);
		Handle trace = TR_TraceRayFilterEx(startPos, endPos, MASK_VISIBLE, RayType_EndPoint, TraceRayDontHitCharactersOrEntity, client);
		TR_GetEndPosition(endPos, trace);
		bool hit = TR_DidHit(trace);
		delete trace;

		if (hit)
		{
			float percent = ((GetVectorSquareMagnitude(startPos, endPos) / length));
			percent *= 3.5;
			if (percent > 1.0)
			{
				percent = 1.0;
			}
			value *= percent;
		}
	}

	return value;
}
