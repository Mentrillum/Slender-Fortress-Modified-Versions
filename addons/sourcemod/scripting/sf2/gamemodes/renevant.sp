#if defined _sf2_renevant_mode_included
 #endinput
#endif
#define _sf2_renevant_mode_included

#pragma semicolon 1

static GlobalForward g_OnRenevantTriggerWaveFwd;

void SetupRenevantMode()
{
	g_OnRoundEndPFwd.AddFunction(null, OnRoundEnd);
	g_OnPlayerDeathPFwd.AddFunction(null, OnPlayerDeath);
	g_OnPlayerSpawnPFwd.AddFunction(null, OnPlayerSpawn);
	g_OnPlayerEscapePFwd.AddFunction(null, OnPlayerEscape);
}

void Renevant_InitializeAPI()
{
	g_OnRenevantTriggerWaveFwd = new GlobalForward("SF2_OnRenevantWaveTrigger", ET_Ignore, Param_Cell, Param_Cell);

	CreateNative("SF2_IsRenevantMap", Native_IsRenevantMap);
}

static void OnRoundEnd()
{
	if (SF_IsRenevantMap() && g_RenevantWaveTimer != null)
	{
		KillTimer(g_RenevantWaveTimer);
	}
}

static void OnPlayerDeath(SF2_BasePlayer client, int attacker, int inflictor, bool fake)
{
	if (!g_Enabled)
	{
		return;
	}

	if (fake)
	{
		return;
	}

	if (g_RenevantMultiEffect)
	{
		CreateTimer(0.1, Timer_ReplacePlayerRagdoll, client.UserID, TIMER_FLAG_NO_MAPCHANGE);
	}
}

static void OnPlayerSpawn(SF2_BasePlayer client)
{
	if (SF_IsRenevantMap() && g_RenevantMarkForDeath && !client.HasEscaped)
	{
		client.ChangeCondition(TFCond_MarkedForDeathSilent, _, -1.0);
	}
}

static void OnPlayerEscape(SF2_BasePlayer client)
{
	if (SF_IsRenevantMap() && g_RenevantMarkForDeath)
	{
		client.ChangeCondition(TFCond_MarkedForDeathSilent, true);
	}
}

bool SF_IsRenevantMap()
{
	return (g_IsRenevantMap || (g_RenevantMapConVar.IntValue == 1));
}

static bool Renevant_TryAddBossProfile(char profile[SF2_MAX_PROFILE_NAME_LENGTH], int profileLen, char[] name, int nameLen, bool playSpawnSound = true)
{
	if (!GetRandomRenevantBossProfile(profile, profileLen))
	{
		return false;
	}

	NPCGetBossName(_, name, nameLen, profile);
	if (name[0] == '\0')
	{
		strcopy(name, nameLen, profile);
	}
	AddProfile(profile, _, _, _, playSpawnSound);

	return true;
}


static void ShowRenevantMessageToClient(int client, const char[] message, int params, any ...)
{
	char messageDisplay[512];
	VFormat(messageDisplay, sizeof(messageDisplay), message, params);

	SetHudTextParams(-1.0, 0.25,
		5.0,
		255,
		255,
		255,
		200,
		2,
		1.0,
		0.05,
		2.0);
	ShowSyncHudText(client, g_HudSync3, messageDisplay);
}

static void Renevant_BroadcastMessage(const char[] message, int params, ...)
{
	char format[512];
	VFormat(format, sizeof(format), message, params);

	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i) || (g_PlayerEliminated[i] && !IsClientInGhostMode(i)) || !IsPlayerAlive(i))
		{
			continue;
		}

		ShowRenevantMessageToClient(i, format, params + 1);
	}
}

static void Renevant_DoWaveAction(RenevantWave action)
{
	char buffer[SF2_MAX_PROFILE_NAME_LENGTH], buffer2[SF2_MAX_PROFILE_NAME_LENGTH], buffer3[SF2_MAX_PROFILE_NAME_LENGTH];
	char name[SF2_MAX_NAME_LENGTH], name2[SF2_MAX_NAME_LENGTH], name3[SF2_MAX_NAME_LENGTH];

	char broadcastMessage[512], broadcastBuffer[256], singleBossBroadcast[256];
	FormatEx(broadcastMessage, sizeof(broadcastMessage), "Wave %d", g_RenevantWaveNumber);

	g_DefaultRenevantBossMessageConVar.GetString(singleBossBroadcast, sizeof(singleBossBroadcast));

	int addedBossCount = 0;
	if (action != RenevantWave_SingleBoss && action != RenevantWave_AdminBoss && Renevant_TryAddBossProfile(buffer, sizeof(buffer), name, sizeof(name), action != RenevantWave_DoomBox && action != RenevantWave_DoubleTrouble))
	{
		addedBossCount++;
	}

	if (addedBossCount == 1 && action != RenevantWave_DoubleTrouble && action != RenevantWave_DoomBox && action != RenevantWave_SingleBoss && action != RenevantWave_AdminBoss)
	{
		FormatEx(broadcastBuffer, sizeof(broadcastBuffer), "\nBoss: %s", name);
		StrCat(broadcastMessage, sizeof(broadcastMessage), broadcastBuffer);
	}

	switch (action)
	{
		case RenevantWave_Normal:
		{
			// Do nothing
		}
		case RenevantWave_IncreaseDifficulty:
		{
			switch (g_DifficultyConVar.IntValue)
			{
				case Difficulty_Normal:
				{
					g_DifficultyConVar.IntValue = Difficulty_Hard;

					FormatEx(broadcastBuffer, sizeof(broadcastBuffer), "\nDifficulty set to: %t",  "SF2 Hard Difficulty");
					StrCat(broadcastMessage, sizeof(broadcastMessage), broadcastBuffer);
				}
				case Difficulty_Hard:
				{
					g_DifficultyConVar.IntValue = Difficulty_Insane;

					FormatEx(broadcastBuffer, sizeof(broadcastBuffer), "\nDifficulty set to: %t",  "SF2 Insane Difficulty");
					StrCat(broadcastMessage, sizeof(broadcastMessage), broadcastBuffer);
				}
				case Difficulty_Insane:
				{
					g_DifficultyConVar.IntValue = Difficulty_Nightmare;

					FormatEx(broadcastBuffer, sizeof(broadcastBuffer), "\nDifficulty set to: %t",  "SF2 Nightmare Difficulty");
					StrCat(broadcastMessage, sizeof(broadcastMessage), broadcastBuffer);
				}
				case Difficulty_Nightmare:
				{
					g_DifficultyConVar.IntValue = Difficulty_Apollyon;

					g_RenevantBossesChaseEndlessly = true;
					g_IsRoundInfiniteSprint = true;

					char nightmareDisplay[256];

					Renevant_SpawnApollyon();

					CPrintToChatAll("The difficulty has been set to: {darkgray}%t{default}!", "SF2 Apollyon Difficulty");

					PlayNightmareSound();

					FormatEx(nightmareDisplay, sizeof(nightmareDisplay), "%t mode!", "SF2 Apollyon Difficulty");

					SpecialRoundGameText(nightmareDisplay, "leaderboard_streak");

					int randomQuote = GetRandomInt(1, 8);
					switch (randomQuote)
					{
						case 1:
						{
							EmitSoundToAll(HYPERSNATCHER_NIGHTAMRE_1);
							CPrintToChatAll("{purple}Snatcher{default}: Oh no! You're not slipping out of your contract THAT easily.");
						}
						case 2:
						{
							EmitSoundToAll(HYPERSNATCHER_NIGHTAMRE_2);
							CPrintToChatAll("{purple}Snatcher{default}: You ready to die some more? Great!");
						}
						case 3:
						{
							EmitSoundToAll(HYPERSNATCHER_NIGHTAMRE_3);
							CPrintToChatAll("{purple}Snatcher{default}: Live fast, die young, and leave behind a pretty corpse, huh? At least you got two out of three right.");
						}
						case 4:
						{
							EmitSoundToAll(HYPERSNATCHER_NIGHTAMRE_4);
							CPrintToChatAll("{purple}Snatcher{default}: I love the smell of DEATH in the morning.");
						}
						case 5:
						{
							EmitSoundToAll(HYPERSNATCHER_NIGHTAMRE_5);
							CPrintToChatAll("{purple}Snatcher{default}: Oh ho ho! I hope you don't think one measely death gets you out of your contract. We're only getting started.");
						}
						case 6:
						{
							EmitSoundToAll(SNATCHER_APOLLYON_1);
							CPrintToChatAll("{purple}Snatcher{default}: Ah! It gets better every time!");
						}
						case 7:
						{
							EmitSoundToAll(SNATCHER_APOLLYON_2);
							CPrintToChatAll("{purple}Snatcher{default}: Hope you enjoyed that one kiddo, because theres a lot more where that came from!");
						}
						case 8:
						{
							EmitSoundToAll(SNATCHER_APOLLYON_3);
							CPrintToChatAll("{purple}Snatcher{default}: Killing you is hard work, but it pays off. HA HA HA HA HA HA HA HA HA HA");
						}
					}

					int eraseWave = g_RenevantWaveList.FindValue(RenevantWave_BaconSpray);
					if (eraseWave != -1)
					{
						g_RenevantWaveList.Erase(eraseWave);
					}

					eraseWave = g_RenevantWaveList.FindValue(RenevantWave_IncreaseDifficulty);
					if (eraseWave != -1)
					{
						g_RenevantWaveList.Erase(eraseWave);
					}
				}
			}
		}
		case RenevantWave_MultiEffect:
		{
			g_RenevantMultiEffect = true;
			StrCat(broadcastMessage, sizeof(broadcastMessage), "\nBosses can now inflict Multieffect.");
			int eraseWave = g_RenevantWaveList.FindValue(RenevantWave_MultiEffect);
			if (eraseWave != -1)
			{
				g_RenevantWaveList.Erase(eraseWave);
			}
		}
		case RenevantWave_BaconSpray:
		{
			g_RenevantBeaconEffect = true;
			StrCat(broadcastMessage, sizeof(broadcastMessage), "\nBosses are now alerted on spawn.");
			int eraseWave = g_RenevantWaveList.FindValue(RenevantWave_BaconSpray);
			if (eraseWave != -1)
			{
				g_RenevantWaveList.Erase(eraseWave);
			}
		}
		case RenevantWave_DoubleTrouble:
		{
			if (Renevant_TryAddBossProfile(buffer2, sizeof(buffer2), name2, sizeof(name2), false))
			{
				addedBossCount++;
			}

			if (addedBossCount == 1)
			{
				FormatEx(broadcastBuffer, sizeof(broadcastBuffer), "\nBoss: %s", name);
				StrCat(broadcastMessage, sizeof(broadcastMessage), broadcastBuffer);
			}
			else if (addedBossCount == 2)
			{
				FormatEx(broadcastBuffer, sizeof(broadcastBuffer), "\nBosses: %s and %s", name, name2);
				StrCat(broadcastMessage, sizeof(broadcastMessage), broadcastBuffer);
			}
		}
		case RenevantWave_DoomBox:
		{
			if (Renevant_TryAddBossProfile(buffer2, sizeof(buffer2), name2, sizeof(name2), false))
			{
				addedBossCount++;
			}
			if (Renevant_TryAddBossProfile(buffer3, sizeof(buffer3), name3, sizeof(name3), false))
			{
				addedBossCount++;
			}

			if (addedBossCount == 1)
			{
				FormatEx(broadcastBuffer, sizeof(broadcastBuffer), "\nBoss: %s", name);
				StrCat(broadcastMessage, sizeof(broadcastMessage), broadcastBuffer);
			}
			else if (addedBossCount == 2)
			{
				FormatEx(broadcastBuffer, sizeof(broadcastBuffer), "\nBosses: %s and %s", name, name2);
				StrCat(broadcastMessage, sizeof(broadcastMessage), broadcastBuffer);
			}
			else if (addedBossCount == 3)
			{
				FormatEx(broadcastBuffer, sizeof(broadcastBuffer), "\nBosses: %s, %s, and %s", name, name2, name3);
				StrCat(broadcastMessage, sizeof(broadcastMessage), broadcastBuffer);
			}
			int eraseWave = g_RenevantWaveList.FindValue(RenevantWave_DoomBox);
			if (eraseWave != -1)
			{
				g_RenevantWaveList.Erase(eraseWave);
			}
		}
		case RenevantWave_90s:
		{
			g_Renevant90sEffect = true;
			StrCat(broadcastMessage, sizeof(broadcastMessage), "\nYou feel very nervous.");
			int eraseWave = g_RenevantWaveList.FindValue(RenevantWave_90s);
			if (eraseWave != -1)
			{
				g_RenevantWaveList.Erase(eraseWave);
			}
		}
		case RenevantWave_MarkForDeath:
		{
			g_RenevantMarkForDeath = true;
			for (int client = 1; client <= MaxClients; client++)
			{
				if (!IsValidClient(client))
				{
					continue;
				}
				if (!IsValidClient(client) ||
					!IsPlayerAlive(client) ||
					g_PlayerEliminated[client] ||
					IsClientInGhostMode(client) ||
					DidClientEscape(client))
				{
					continue;
				}
				TF2_AddCondition(client, TFCond_MarkedForDeathSilent, -1.0);
			}
			StrCat(broadcastMessage, sizeof(broadcastMessage), "\nEveryone is marked for death permanently.");
			int eraseWave = g_RenevantWaveList.FindValue(RenevantWave_MarkForDeath);
			if (eraseWave != -1)
			{
				g_RenevantWaveList.Erase(eraseWave);
			}
		}
		case RenevantWave_SingleBoss:
		{
			char bufferSingle[SF2_MAX_PROFILE_NAME_LENGTH], singleBossName[SF2_MAX_NAME_LENGTH];
			g_DefaultRenevantBossConVar.GetString(bufferSingle, sizeof(bufferSingle));
			if (Renevant_TryAddBossProfile(bufferSingle, sizeof(bufferSingle), singleBossName, sizeof(singleBossName)))
			{
				addedBossCount++;
			}
			FormatEx(broadcastBuffer, sizeof(broadcastBuffer), "\n%s", singleBossBroadcast);
			StrCat(broadcastMessage, sizeof(broadcastMessage), broadcastBuffer);
			int eraseWave = g_RenevantWaveList.FindValue(RenevantWave_SingleBoss);
			if (eraseWave != -1)
			{
				g_RenevantWaveList.Erase(eraseWave);
			}
		}
		case RenevantWave_AdminBoss:
		{
			ArrayList selectableBosses = GetSelectableRenevantBossAdminProfileList();
			if (selectableBosses.Length > 0)
			{
				selectableBosses.GetString(GetRandomInt(0, selectableBosses.Length - 1), buffer, sizeof(buffer));
				SF2NPC_BaseNPC Npc = AddProfile(buffer);
				if (Npc.IsValid())
				{
					NPCGetBossName(_, name, sizeof(name), buffer);
					if (name[0] == '\0')
					{
						strcopy(name, sizeof(name), buffer);
					}
					FormatEx(broadcastBuffer, sizeof(broadcastBuffer), "\nBoss: %s", name);
					StrCat(broadcastMessage, sizeof(broadcastMessage), broadcastBuffer);
				}
			}
			else
			{
				if (Renevant_TryAddBossProfile(buffer, sizeof(buffer), name, sizeof(name), false))
				{
					FormatEx(broadcastBuffer, sizeof(broadcastBuffer), "\nBoss: %s", name);
					StrCat(broadcastMessage, sizeof(broadcastMessage), broadcastBuffer);
				}
			}
			int eraseWave = g_RenevantWaveList.FindValue(RenevantWave_AdminBoss);
			if (eraseWave != -1)
			{
				g_RenevantWaveList.Erase(eraseWave);
			}
		}
		case RenevantWave_WallHax:
		{
			g_RenevantWallHax = true;
			StrCat(broadcastMessage, sizeof(broadcastMessage), "\nYou can now see players and bosses through walls.");
			int eraseWave = g_RenevantWaveList.FindValue(RenevantWave_WallHax);
			if (eraseWave != -1)
			{
				g_RenevantWaveList.Erase(eraseWave);
			}
		}
	}

	Renevant_BroadcastMessage(broadcastMessage, 2);
}

void Renevant_SetWave(int wave, bool resetTimer = false)
{
	if (!SF_IsRenevantMap() || g_RenevantWaveNumber == wave)
	{
		return;
	}

	g_RenevantWaveNumber = wave;

	if (resetTimer && wave < g_RenevantMaxWaves.IntValue && wave != 0)
	{
		float time = ((float(g_RoundEscapeTimeLimit) - float(g_RenevantFinaleTime)) / g_RenevantMaxWaves.IntValue);
		g_RenevantWaveTimer = CreateTimer(time, Timer_RenevantWave, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	}

	if (wave == 0 || wave >= g_RenevantMaxWaves.IntValue)
	{
		g_RenevantWaveTimer = null; // At zero/max wave so stop it.
	}

	if (wave == 0)
	{
		return;
	}

	RenevantWave randomWave = RenevantWave_Normal;

	switch (g_RenevantWaveNumber)
	{
		case 1: //Wave 1
		{
			g_DifficultyConVar.IntValue = Difficulty_Normal;

			Renevant_DoWaveAction(RenevantWave_Normal);

			CPrintToChatAll("The difficulty has been set to {yellow}%t{default}.", "SF2 Normal Difficulty");
			g_RenevantWaveList = new ArrayList();
			for (int i = 0; i < view_as<int>(RenevantWave_Max); i++)
			{
				g_RenevantWaveList.Push(i);
			}
			char bufferCheck[SF2_MAX_PROFILE_NAME_LENGTH];
			g_DefaultRenevantBossConVar.GetString(bufferCheck, sizeof(bufferCheck));
			if (bufferCheck[0] == '\0' || !IsProfileValid(bufferCheck))
			{
				int eraseWave = g_RenevantWaveList.FindValue(RenevantWave_SingleBoss);
				if (eraseWave != -1)
				{
					g_RenevantWaveList.Erase(eraseWave);
				}
			}
			ArrayList selectableBosses = GetSelectableRenevantBossAdminProfileList();
			if (selectableBosses.Length <= 0)
			{
				int eraseWave = g_RenevantWaveList.FindValue(RenevantWave_AdminBoss);
				if (eraseWave != -1)
				{
					g_RenevantWaveList.Erase(eraseWave);
				}
			}
		}
		case 0:
		{
			// Do nothing
		}
		default: //Waves except 1
		{
			randomWave = view_as<RenevantWave>(g_RenevantWaveList.Get(GetRandomInt(0, g_RenevantWaveList.Length - 1)));
			Renevant_DoWaveAction(randomWave);
		}
	}

	SF2MapEntity_OnRenevantWaveTriggered(g_RenevantWaveNumber);

	Call_StartForward(g_OnRenevantTriggerWaveFwd);
	Call_PushCell(g_RenevantWaveNumber);
	Call_PushCell(randomWave);
	Call_Finish();

	Call_StartForward(g_OnRenevantTriggerWavePFwd);
	Call_PushCell(g_RenevantWaveNumber);
	Call_PushCell(randomWave);
	Call_Finish();
}

static Action Timer_RenevantWave(Handle timer, any data)
{
	if (timer != g_RenevantWaveTimer)
	{
		return Plugin_Stop;
	}

	if (!IsRoundInEscapeObjective())
	{
		return Plugin_Stop;
	}

	Renevant_SetWave(g_RenevantWaveNumber + 1);

	if (g_RenevantWaveNumber == g_RenevantMaxWaves.IntValue)
	{
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

static void Renevant_SpawnApollyon()
{
	ArrayList spawnPoint = new ArrayList();
	float teleportPos[3];
	int ent = -1, spawnTeam = 0;
	while ((ent = FindEntityByClassname(ent, "info_player_teamspawn")) != -1)
	{
		spawnTeam = GetEntProp(ent, Prop_Data, "m_iInitialTeamNum");
		if (spawnTeam == TFTeam_Red)
		{
			spawnPoint.Push(ent);
		}
	}

	ent = -1;
	if (spawnPoint.Length > 0)
	{
		ent = spawnPoint.Get(GetRandomInt(0, spawnPoint.Length - 1));
	}

	delete spawnPoint;

	if (IsValidEntity(ent))
	{
		GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", teleportPos);
		for(int npcIndex = 0; npcIndex <= MAX_BOSSES; npcIndex++)
		{
			SF2NPC_BaseNPC Npc = SF2NPC_BaseNPC(npcIndex);
			if (!Npc.IsValid())
			{
				continue;
			}
			if (Npc.Flags & SFF_NOTELEPORT)
			{
				continue;
			}
			Npc.UnSpawn(true);
			Npc.Spawn(teleportPos);
		}
	}
}

static int Native_IsRenevantMap(Handle plugin, int numParams)
{
	return view_as<int>(SF_IsRenevantMap());
}
