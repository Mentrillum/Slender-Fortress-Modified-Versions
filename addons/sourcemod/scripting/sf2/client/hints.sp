#if defined _sf2_client_hints_included
 #endinput
#endif
#define _sf2_client_hints_included

bool g_PlayerHints[MAXTF2PLAYERS][PlayerHint_MaxNum];
static Handle g_ShowHintTimer[MAXPLAYERS + 1];

void SetupHints()
{
	g_OnPlayerPutInServerPFwd.AddFunction(null, OnPutInServer);
	g_OnPlayerDisconnectedPFwd.AddFunction(null, OnDisconnected);
	g_OnPlayerSpawnPFwd.AddFunction(null, OnPlayerSpawn);
	g_OnPlayerDeathPFwd.AddFunction(null, OnPlayerDeath);
	g_OnPlayerEscapePFwd.AddFunction(null, OnPlayerEscape);
	g_OnPlayerChangePlayStatePFwd.AddFunction(null, OnPlayerChangePlayState);
	g_OnDifficultyVoteFinishedPFwd.AddFunction(null, OnDifficultyVoteFinished);
}

static void OnPutInServer(SF2_BasePlayer client)
{
	if (!g_Enabled)
	{
		return;
	}

	ClientResetHints(client.index);

	g_ShowHintTimer[client.index] = null;
}

static void OnDisconnected(SF2_BasePlayer client)
{
	if (!g_Enabled)
	{
		return;
	}

	ClientResetHints(client.index);
}

static void OnPlayerSpawn(SF2_BasePlayer client)
{
	if (!g_Enabled)
	{
		return;
	}

	ClientResetHints(client.index);
}

static void OnPlayerDeath(SF2_BasePlayer client, int attacker, int inflictor, bool fake)
{
	if (!g_Enabled)
	{
		return;
	}

	if (!fake)
	{
		ClientResetHints(client.index);
	}
}

static void OnPlayerEscape(SF2_BasePlayer client)
{
	ClientResetHints(client.index);
}

static void OnPlayerChangePlayState(SF2_BasePlayer client, bool state, bool queue)
{
	if (!state)
	{
		g_ShowHintTimer[client.index] = null;
	}
}

static Action OnDifficultyVoteFinished(int difficulty, int& newDifficulty)
{
	for (int i = 1; i <= MaxClients; i++)
	{
		SF2_BasePlayer player = SF2_BasePlayer(i);
		if (!player.IsValid) // || !g_PlayerPreferences[player.index].PlayerPreference_ShowHints
		{
			continue;
		}

		if (player.IsEliminated)
		{
			if (!player.HasHint(PlayerHint_MainMenu))
			{
				player.ShowHint(PlayerHint_MainMenu);
			}
		}
		else
		{
			if (!player.HasHint(PlayerHint_Flashlight))
			{
				player.ShowHint(PlayerHint_Flashlight);

				if (!player.HasHint(PlayerHint_Noises)) // PlayerHint_Sprint
				{
					g_ShowHintTimer[player.index] = CreateTimer(10.0, Timer_ShowNoisesHint, player.UserID, TIMER_FLAG_NO_MAPCHANGE); // Timer_ShowSprintHint
				}
			}
			/*else if (!player.HasHint(PlayerHint_Sprint))
			{
				player.ShowHint(PlayerHint_Sprint);

				if (!player.HasHint(PlayerHint_Noises))
				{
					g_ShowHintTimer[player.index] = CreateTimer(10.0, Timer_ShowNoisesHint, player.UserID, TIMER_FLAG_NO_MAPCHANGE);
				}
			}*/
			else if (!player.HasHint(PlayerHint_Noises))
			{
				player.ShowHint(PlayerHint_Noises);
			}
		}
	}
	return Plugin_Continue;
}

static Action Timer_ShowSprintHint(Handle timer, any userId)
{
	int clientIndex = GetClientOfUserId(userId);
	if (clientIndex == 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_ShowHintTimer[clientIndex])
	{
		return Plugin_Stop;
	}

	SF2_BasePlayer player = SF2_BasePlayer(clientIndex);

	if (player.IsEliminated || player.HasEscaped) // || !g_PlayerPreferences[player.index].PlayerPreference_ShowHints
	{
		return Plugin_Stop;
	}

	if (!player.HasHint(PlayerHint_Sprint))
	{
		player.ShowHint(PlayerHint_Sprint);
	}

	if (!player.HasHint(PlayerHint_Noises))
	{
		g_ShowHintTimer[player.index] = CreateTimer(10.0, Timer_ShowNoisesHint, player.UserID, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Stop;
}

static Action Timer_ShowNoisesHint(Handle timer, any userId)
{
	int clientIndex = GetClientOfUserId(userId);
	if (clientIndex == 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_ShowHintTimer[clientIndex])
	{
		return Plugin_Stop;
	}

	SF2_BasePlayer player = SF2_BasePlayer(clientIndex);

	if (player.IsEliminated || player.HasEscaped) // || !g_PlayerPreferences[player.index].PlayerPreference_ShowHints
	{
		return Plugin_Stop;
	}

	if (!player.HasHint(PlayerHint_Noises))
	{
		player.ShowHint(PlayerHint_Noises);
	}

	return Plugin_Stop;
}

// Hint data.
enum
{
	PlayerHint_Sprint = 0,
	PlayerHint_Flashlight,
	PlayerHint_MainMenu,
	PlayerHint_Blink,
	PlayerHint_Trap,
	PlayerHint_Noises,
	PlayerHint_Crouch,
	PlayerHint_MaxNum
};

void ClientResetHints(int client)
{
    #if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START ClientResetHints(%d)", client);
	}
    #endif

	for (int i = 0; i < PlayerHint_MaxNum; i++)
	{
		g_PlayerHints[client][i] = false;
	}

    #if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END ClientResetHints(%d)", client);
	}
    #endif
}

void ClientShowHint(int client, int hint)
{
	g_PlayerHints[client][hint] = true;

	switch (hint)
	{
		case PlayerHint_Sprint:
		{
			PrintHintText(client, "%T", "SF2 Hint Sprint", client);
		}
		case PlayerHint_Flashlight:
		{
			PrintHintText(client, "%T", "SF2 Hint Flashlight", client);
		}
		case PlayerHint_Blink:
		{
			PrintHintText(client, "%T", "SF2 Hint Blink", client);
		}
		case PlayerHint_MainMenu:
		{
			PrintHintText(client, "%T", "SF2 Hint Main Menu", client);
		}
		case PlayerHint_Trap:
		{
			PrintHintText(client, "%T", "SF2 Hint Trap", client);
		}
		case PlayerHint_Noises:
		{
			PrintHintText(client, "%T", "SF2 Hint Noises", client);
		}
		case PlayerHint_Crouch:
		{
			PrintHintText(client, "%T", "SF2 Hint Crouch", client);
		}
	}
}

bool ClientHasHint(int client, int hint)
{
	return g_PlayerHints[client][hint];
}