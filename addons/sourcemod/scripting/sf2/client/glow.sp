static const int g_DefaultRedColor[4] = { 184, 56, 59, 255 };
static const int g_DefaultProxyColor[4] = { 255, 208, 0, 255 };

static float g_NextCheckTime[MAXTF2PLAYERS];

void SetupPlayerGlows()
{
	g_OnPlayerPutInServerPFwd.AddFunction(null, OnPutInServer);
	g_OnPlayerDisconnectedPFwd.AddFunction(null, OnDisconnected);
	g_OnPlayerSpawnPFwd.AddFunction(null, OnPlayerSpawn);
	g_OnPlayerDeathPFwd.AddFunction(null, OnPlayerDeath);
	g_OnPlayerEscapePFwd.AddFunction(null, OnPlayerEscape);
	g_OnPlayerChangePlayStatePFwd.AddFunction(null, OnPlayerChangePlayState);
	g_OnPlayerChangeProxyStatePFwd.AddFunction(null, OnPlayerChangeProxyState);
	g_OnPlayerConditionAddedPFwd.AddFunction(null, OnPlayerConditionAdded);
	g_OnPlayerConditionRemovedPFwd.AddFunction(null, OnPlayerConditionRemoved);
	g_OnSpecialRoundStartPFwd.AddFunction(null, OnSpecialRoundStart);
	g_OnRenevantTriggerWavePFwd.AddFunction(null, OnRenevantTriggerWave);
	g_OnWallHaxDebugPFwd.AddFunction(null, OnWallHaxDebug);
}

static void OnPutInServer(SF2_BasePlayer client)
{
	SDKHook(client.index, SDKHook_PreThinkPost, PreThinkPost);

	g_NextCheckTime[client.index] = -1.0;
}

static void OnDisconnected(SF2_BasePlayer client)
{

}

static void OnPlayerSpawn(SF2_BasePlayer client)
{
	DestroyGlowEntity(client.index);

	if (ShouldHaveGlow(client))
	{
		int color[4];
		GetGlowColor(client, color);
		CreateGlowEntity(client.index, color);
		UpdateVisibility(client);
	}

	UpdateVisibilityOfOtherGlows(client);
}

static void OnPlayerDeath(SF2_BasePlayer client, int attacker, int inflictor, bool fake)
{
	if (!fake)
	{
		DestroyGlowEntity(client.index);
		UpdateVisibilityOfOtherGlows(client);
	}
}

static void OnPlayerEscape(SF2_BasePlayer client)
{
	DestroyGlowEntity(client.index);
	UpdateVisibilityOfOtherGlows(client);
}

static void OnPlayerChangePlayState(SF2_BasePlayer client)
{
	UpdateVisibilityOfOtherGlows(client);
}

static void OnPlayerChangeProxyState(SF2_BasePlayer client, bool state)
{
	if (state)
	{
		if (!DoesEntityHaveGlow(client.index))
		{
			CreateGlowEntity(client.index);
		}
		int color[4];
		GetGlowColor(client, color);
		SetGlowColor(client.index, color);
		UpdateVisibility(client);
		UpdateVisibilityOfOtherGlows(client);
	}
}

static void OnPlayerConditionAdded(SF2_BasePlayer client, TFCond condition)
{
	if (DoesEntityHaveGlow(client.index) && (TF2_IsInvisible(client.index)))
	{
		UpdateVisibility(client);
	}
}

static void OnPlayerConditionRemoved(SF2_BasePlayer client, TFCond condition)
{
	if (DoesEntityHaveGlow(client.index) && (TF2_IsInvisible(client.index)))
	{
		UpdateVisibility(client);
	}
}

static void OnSpecialRoundStart(int specialRound)
{
	if (specialRound == SPECIALROUND_WALLHAX)
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			SF2_BasePlayer client = SF2_BasePlayer(i);
			if (!client.IsValid)
			{
				continue;
			}

			if (!client.IsEliminated)
			{
				UpdateVisibilityOfOtherGlows(client);
			}
		}
	}
}

static void OnRenevantTriggerWave(int wave, RenevantWave condition)
{
	if (condition == RenevantWave_WallHax)
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			SF2_BasePlayer client = SF2_BasePlayer(i);
			if (!client.IsValid)
			{
				continue;
			}

			if (!client.IsEliminated)
			{
				UpdateVisibilityOfOtherGlows(client);
			}
		}
	}
}

static void OnWallHaxDebug()
{
	for (int i = 1; i <= MaxClients; i++)
	{
		SF2_BasePlayer client = SF2_BasePlayer(i);
		if (!client.IsValid)
		{
			continue;
		}

		if (!client.IsEliminated)
		{
			UpdateVisibilityOfOtherGlows(client);
		}
	}
}

static void PreThinkPost(int clientIndex)
{
	SF2_BasePlayer client = SF2_BasePlayer(clientIndex);

	float gameTime = GetGameTime();
	if (gameTime >= g_NextCheckTime[clientIndex])
	{
		g_NextCheckTime[clientIndex] = gameTime + 0.1;

		if (client.IsProxy)
		{
			UpdateVisibilityOfOtherGlows(client);
		}
	}
}

static bool ShouldBeVisibleToPlayer(SF2_BasePlayer client, SF2_BasePlayer other)
{
	if (client.index == other.index)
	{
		return false;
	}

	if (!client.IsEliminated)
	{
		if (other.IsInGhostMode)
		{
			return true;
		}

		if (!other.IsEliminated)
		{
			if (other.HasEscaped)
			{
				return false;
			}

			if (SF_SpecialRound(SPECIALROUND_WALLHAX) || g_EnableWallHaxConVar.BoolValue || g_RenevantWallHax)
			{
				return true;
			}

			return false;
		}
		else if (other.IsProxy)
		{
			if (TF2_IsInvisible(client.index))
			{
				return false;
			}

			if (client.IsProxy || client.InCondition(TFCond_Taunting))
			{
				return true;
			}

			float vecVel[3], movespeed;
			other.GetAbsVelocity(vecVel);
			movespeed = GetVectorLength(vecVel, true);

			if (movespeed <= Pow(163.0, 2.0))
			{
				float ownerPos[3], proxyPos[3];
				client.GetEyePosition(ownerPos);
				other.GetEyePosition(proxyPos);

				float distance = Pow(500.0, 2.0);
				return GetVectorSquareMagnitude(ownerPos, proxyPos) <= distance;
			}
		}
	}
	else
	{
		if (client.IsProxy)
		{
			if (other.IsProxy || other.IsInGhostMode)
			{
				return true;
			}
		}
	}

	return false;
}

static void UpdateVisibility(SF2_BasePlayer client)
{
	int clients[MAXPLAYERS + 1];
	int numClients = 0;
	bool states[MAXPLAYERS + 1];
	for (int i = 1; i <= MaxClients; i++)
	{
		SF2_BasePlayer other = SF2_BasePlayer(i);
		if (!other.IsValid)
		{
			continue;
		}

		int i2 = numClients++;
		clients[i2] = i;
		states[i2] = ShouldBeVisibleToPlayer(client, other);
	}

	SetGlowVisibility(client.index, clients, numClients, states);
}

static void UpdateVisibilityOfOtherGlows(SF2_BasePlayer client)
{
	for (int i = 1; i <= MaxClients; i++)
	{
		SF2_BasePlayer other = SF2_BasePlayer(i);
		if (!other.IsValid)
		{
			continue;
		}

		if (ShouldHaveGlow(other))
		{
			SetGlowVisibilityForClient(other.index, client.index, ShouldBeVisibleToPlayer(other, client));
		}
	}
}

static bool ShouldHaveGlow(SF2_BasePlayer client)
{
	return client.IsAlive && ((!client.IsEliminated && !client.HasEscaped) || client.IsProxy);
}

static void GetGlowColor(SF2_BasePlayer client, int color[4])
{
	if (!client.IsEliminated && !client.HasEscaped)
	{
		color = g_DefaultRedColor;
	}
	else if (client.IsProxy)
	{
		color = g_DefaultProxyColor;
	}
}
