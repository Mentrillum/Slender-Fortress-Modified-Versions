#pragma semicolon 1
#pragma newdecls required

static const int g_DefaultColor[4] = { 150, 0, 255, 255 };

void SetupNPCGlows()
{
	g_OnPlayerSpawnPFwd.AddFunction(null, OnPlayerSpawn);
	g_OnDifficultyChangePFwd.AddFunction(null, OnDifficultyChange);
	g_OnSpecialRoundStartPFwd.AddFunction(null, OnSpecialRoundStart);
	g_OnBossSpawnPFwd.AddFunction(null, OnBossSpawn);
	g_OnPlayerChangePlayStatePFwd.AddFunction(null, OnPlayerChangePlayState);
	g_OnPlayerChangeGhostStatePFwd.AddFunction(null, OnPlayerChangeGhostState);
	g_OnPlayerChangeProxyStatePFwd.AddFunction(null, OnPlayerChangeProxyState);
	g_OnPlayerTurnOnFlashlightPFwd.AddFunction(null, OnPlayerTurnOnFlashlight);
	g_OnPlayerTurnOffFlashlightPFwd.AddFunction(null, OnPlayerTurnOffFlashlight);
	g_OnPlayerFlashlightBreakPFwd.AddFunction(null, OnPlayerFlashlightBreak);
	g_OnRenevantTriggerWavePFwd.AddFunction(null, OnRenevantTriggerWave);
	g_OnWallHaxDebugPFwd.AddFunction(null, OnWallHaxDebug);
}

static void OnPlayerSpawn(SF2_BasePlayer client)
{
	UpdateVisibilityOfOtherGlows(client);
}

static void OnDifficultyChange(int oldDifficulty, int newDifficulty)
{

}

static void OnSpecialRoundStart(int specialRound)
{
	if (SF_SpecialRound(SPECIALROUND_WALLHAX))
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			SF2_BasePlayer client = SF2_BasePlayer(i);
			if (!client.IsValid)
			{
				continue;
			}

			UpdateVisibilityOfOtherGlows(client);
		}
	}
}

static void OnBossSpawn(SF2NPC_BaseNPC controller)
{
	BaseBossProfile data = controller.GetProfileDataEx();
	if (data.IsPvEBoss)
	{
		return;
	}

	int color[4];
	color = g_DefaultColor;
	if (data.CustomOutlines)
	{
		data.GetOutlineColor(color);
	}
	CreateGlowEntity(controller.EntIndex, color);
	UpdateVisibility(controller);
}

static void OnPlayerChangePlayState(SF2_BasePlayer client, bool state, bool queue)
{
	UpdateVisibilityOfOtherGlows(client);
}

static void OnPlayerChangeGhostState(SF2_BasePlayer client, bool state)
{
	UpdateVisibilityOfOtherGlows(client);
}

static void OnPlayerChangeProxyState(SF2_BasePlayer client, bool state)
{
	UpdateVisibilityOfOtherGlows(client);
}

static void OnPlayerTurnOnFlashlight(SF2_BasePlayer client)
{
	UpdateVisibilityOfOtherGlows(client);
}

static void OnPlayerTurnOffFlashlight(SF2_BasePlayer client)
{
	UpdateVisibilityOfOtherGlows(client);
}

static void OnPlayerFlashlightBreak(SF2_BasePlayer client)
{
	UpdateVisibilityOfOtherGlows(client);
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

			UpdateVisibilityOfOtherGlows(client);
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

		UpdateVisibilityOfOtherGlows(client);
	}
}

static bool ShouldBeVisibleToPlayer(SF2NPC_BaseNPC controller, SF2_BasePlayer other)
{
	CBaseEntity bossEntity = CBaseEntity(controller.EntIndex);
	if (!bossEntity.IsValid())
	{
		return false;
	}

	if (!other.IsEliminated)
	{
		if (IsNightVisionEnabled() && g_NightVisionType == 2 && other.UsingFlashlight)
		{
			return true;
		}
		return SF_SpecialRound(SPECIALROUND_WALLHAX) || g_RenevantWallHax || g_EnableWallHaxConVar.BoolValue;
	}

	return other.IsProxy || other.IsInGhostMode || other.IsSourceTV;
}

static void UpdateVisibility(SF2NPC_BaseNPC controller)
{
	CBaseEntity bossEntity = CBaseEntity(controller.EntIndex);
	if (!bossEntity.IsValid())
	{
		return;
	}

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
		states[i2] = ShouldBeVisibleToPlayer(controller, other);
	}

	SetGlowVisibility(bossEntity.index, clients, numClients, states);
}

static void UpdateVisibilityOfOtherGlows(SF2_BasePlayer client)
{
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		SF2NPC_BaseNPC controller = SF2NPC_BaseNPC(i);
		if (!controller.IsValid())
		{
			continue;
		}

		CBaseEntity bossEntity = CBaseEntity(controller.EntIndex);
		if (!bossEntity.IsValid())
		{
			continue;
		}

		SetGlowVisibilityForClient(bossEntity.index, client.index, ShouldBeVisibleToPlayer(controller, client));
	}
}