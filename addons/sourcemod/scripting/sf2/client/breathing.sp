#pragma semicolon 1

#define SF2_PLAYER_BREATH_COOLDOWN_MIN 0.8
#define SF2_PLAYER_BREATH_COOLDOWN_MAX 2.0

char g_PlayerBreathSounds[][] =
{
	"slender/fastbreath1.wav"
};

static bool g_PlayerBreath[MAXTF2PLAYERS] = { false, ... };
static Handle g_PlayerBreathTimer[MAXTF2PLAYERS] = { null, ... };

void SetupBreathing()
{
	g_OnPlayerPutInServerPFwd.AddFunction(null, OnPutInServer);
	g_OnPlayerSpawnPFwd.AddFunction(null, OnPlayerSpawn);
	g_OnPlayerDeathPFwd.AddFunction(null, OnPlayerDeath);
	g_OnPlayerEscapePFwd.AddFunction(null, OnPlayerEscape);
}

static void OnPutInServer(SF2_BasePlayer client)
{
	ClientResetBreathing(client.index);

	SDKHook(client.index, SDKHook_PreThink, Hook_BreathingThink);
}

static void OnPlayerSpawn(SF2_BasePlayer client)
{
	ClientResetBreathing(client.index);
}

static void OnPlayerDeath(SF2_BasePlayer client, int attacker, int inflictor, bool fake)
{
	if (!fake)
	{
		ClientResetBreathing(client.index);
	}
}

static void OnPlayerEscape(SF2_BasePlayer client)
{
	ClientResetBreathing(client.index);
}

static void ClientResetBreathing(int client)
{
	g_PlayerBreath[client] = false;
	g_PlayerBreathTimer[client] = null;
}

static float ClientCalculateBreathingCooldown(int client)
{
	float average = 0.0;
	int averageNum = 0;

	// Sprinting only, for now.
	average += (SF2_PLAYER_BREATH_COOLDOWN_MAX * 6.7765 * Pow((float(g_PlayerSprintPoints[client]) / 100.0), 1.65));
	averageNum++;

	average /= float(averageNum);

	if (average < SF2_PLAYER_BREATH_COOLDOWN_MIN)
	{
		average = SF2_PLAYER_BREATH_COOLDOWN_MIN;
	}

	return average;
}

static void ClientStartBreathing(int client)
{
	g_PlayerBreath[client] = true;
	g_PlayerBreathTimer[client] = CreateTimer(ClientCalculateBreathingCooldown(client), Timer_ClientBreath, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
}

static void ClientStopBreathing(int client)
{
	g_PlayerBreath[client] = false;
	g_PlayerBreathTimer[client] = null;
}

static bool ClientCanBreath(int client)
{
	return ClientCalculateBreathingCooldown(client) < SF2_PLAYER_BREATH_COOLDOWN_MAX;
}

static Action Timer_ClientBreath(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerBreathTimer[client])
	{
		return Plugin_Stop;
	}

	if (!g_PlayerBreath[client])
	{
		return Plugin_Stop;
	}

	if (ClientCanBreath(client))
	{
		EmitSoundToAll(g_PlayerBreathSounds[GetRandomInt(0, sizeof(g_PlayerBreathSounds) - 1)], client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);

		ClientStartBreathing(client);
		return Plugin_Stop;
	}

	ClientStopBreathing(client);

	return Plugin_Stop;
}

static void Hook_BreathingThink(int client)
{
	if (!g_Enabled)
	{
		return;
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	RoundState roundState = GameRules_GetRoundState();
	if (player.IsEliminated || roundState != RoundState_RoundRunning ||
		IsRoundEnding() || IsRoundInWarmup() || player.HasEscaped)
	{
		return;
	}

	if (ClientCanBreath(player.index) && !g_PlayerBreath[player.index])
	{
		ClientStartBreathing(player.index);
	}
}