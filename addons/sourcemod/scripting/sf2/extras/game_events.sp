#if defined _sf2_game_events_included
 #endinput
#endif
#define _sf2_game_events_included

#pragma semicolon 1

Action Event_RoundStart(Handle event, const char[] name, bool dB)
{
	if (!g_Enabled)
	{
		if (g_LoadOutsideMapsConVar.BoolValue)
		{
			NPCRemoveAll();
		}
		return Plugin_Continue;
	}

	#if defined DEBUG
	Handle profiler = CreateProfiler();
	StartProfiling(profiler);
	SendDebugMessageToPlayers(DEBUG_EVENT, 0, "(Event_RoundStart) Started profiling...");

	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("EVENT START: Event_RoundStart");
	}
	#endif

	// Reset some global variables.
	g_RoundCount++;
	g_RoundTimer = null;
	g_RoundTimerPaused = false;

	SetRoundState(SF2RoundState_Invalid);

	SetPageCount(0);
	g_PageMax = 0;

	g_VoteTimer = null;
	//Stop the music if needed.
	NPCStopMusic();
	// Remove all bosses from the game.
	NPCRemoveAll();
	// Collect trigger_multiple to prevent touch bug.
	SF_CollectTriggersMultiple();
	// Refresh groups.
	for (int i = 0; i < SF2_MAX_PLAYER_GROUPS; i++)
	{
		SetPlayerGroupPlaying(i, false);
		CheckPlayerGroup(i);
	}

	// Refresh players.
	for (int i = 1; i <= MaxClients; i++)
	{
		ClientSetGhostModeState(i, false);

		g_PlayerPlaying[i] = false;
		g_PlayerEliminated[i] = true;
		g_PlayerEscaped[i] = false;
	}
	SF_RemoveAllSpecialRound();
	// Calculate the new round state.
	if (g_RoundWaitingForPlayers)
	{
		int ent = -1;
		while ((ent = FindEntityByClassname(ent, "func_regenerate")) != -1)
		{
			AcceptEntityInput(ent, "Disable");
		}
		SetRoundState(SF2RoundState_Waiting);
	}
	else if (g_WarmupRoundConVar.BoolValue && g_RoundWarmupRoundCount < g_WarmupRoundNumConVar.IntValue)
	{
		int ent = -1;
		while ((ent = FindEntityByClassname(ent, "func_regenerate")) != -1)
		{
			AcceptEntityInput(ent, "Disable");
		}

		g_RoundWarmupRoundCount++;

		SetRoundState(SF2RoundState_Waiting);

		ServerCommand("mp_restartgame 15");
		PrintCenterTextAll("Round restarting in 15 seconds");
	}
	else
	{
		g_RoundActiveCount++;

		InitializeNewGame();
	}

	Call_StartForward(g_OnRoundStartPFwd);
	Call_Finish();
	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("EVENT END: Event_RoundStart");
	}

	StopProfiling(profiler);
	SendDebugMessageToPlayers(DEBUG_EVENT, 0, "(Event_RoundStart) Stopped profiling, total execution time: %f", GetProfilerTime(profiler));
	delete profiler;

	#endif

	return Plugin_Continue;
}

Action Event_WinPanel(Event event, const char[] name, bool dontBroadcast)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	char cappers[7];
	int i = 0;
	for (int client = 1; client <= MaxClients; client++)
	{
		if (IsValidClient(client) && DidClientEscape(client) && i < 7)
		{
			cappers[i] = client;
			event.SetString("cappers", cappers);
			i += 1;
		}
	}
	delete event;
	return Plugin_Continue;
}

Action Event_Audio(Event event, const char[] name, bool dB)
{
	char audio[PLATFORM_MAX_PATH];

	GetEventString(event, "sound", audio, sizeof(audio));
	if (strncmp(audio, "Game.Your", 9) == 0 || strcmp(audio, "Game.Stalemate") == 0)
	{
		for (int bossIndex = 0; bossIndex < MAX_BOSSES; bossIndex++)
		{
			if (NPCGetUniqueID(bossIndex) == -1)
			{
				continue;
			}
			if (!g_SlenderCustomOutroSong[bossIndex])
			{
				continue;
			}

			return Plugin_Handled;
		}
	}
	return Plugin_Continue;
}

Action Event_RoundEnd(Handle event, const char[] name, bool dB)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("EVENT START: Event_RoundEnd");
	}
	#endif

	SF_FailEnd();

	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i))
		{
			continue;
		}
		g_PlayerDied1Up[i] = false;
		g_PlayerIn1UpCondition[i] = false;
		g_PlayerFullyDied1Up[i] = true;
	}

	ArrayList randomBosses = new ArrayList();
	char music[MAX_BOSSES][PLATFORM_MAX_PATH];

	for (int npcIndex = 0; npcIndex < MAX_BOSSES; npcIndex++)
	{
		if (NPCGetUniqueID(npcIndex) == -1)
		{
			continue;
		}

		if (g_SlenderCustomOutroSong[npcIndex])
		{
			char profile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(npcIndex, profile, sizeof(profile));
			SF2BossProfileSoundInfo soundInfo;
			GetBossProfileOutroMusics(profile, soundInfo);
			if (soundInfo.Paths != null && soundInfo.Paths.Length > 0)
			{
				soundInfo.Paths.GetString(GetRandomInt(0, soundInfo.Paths.Length - 1), music[npcIndex], sizeof(music[]));
			}
			if (music[npcIndex][0] != '\0')
			{
				randomBosses.Push(npcIndex);
			}
		}
	}
	if (randomBosses.Length > 0)
	{
		int newBossIndex = randomBosses.Get(GetRandomInt(0, randomBosses.Length - 1));
		if (NPCGetUniqueID(newBossIndex) != -1)
		{
			EmitSoundToAll(music[newBossIndex], _, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
		}
	}

	delete randomBosses;

	SetRoundState(SF2RoundState_Outro);

	DistributeQueuePointsToPlayers();

	g_RoundEndCount++;
	CheckRoundLimitForBossPackVote(g_RoundEndCount);

	Call_StartForward(g_OnRoundEndPFwd);
	Call_Finish();

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("EVENT END: Event_RoundEnd");
	}
	#endif
	delete event;

	return Plugin_Continue;
}

Action Event_PlayerTeam(Handle event, const char[] name, bool dB)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("EVENT START: Event_PlayerTeam");
	}
	#endif

	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (client > 0)
	{
		int teamNum = GetEventInt(event, "team");
		if (teamNum <= TFTeam_Spectator)
		{
			if (!IsRoundPlaying())
			{
				if (g_PlayerPlaying[client] && !g_PlayerEliminated[client])
				{
					ForceInNextPlayersInQueue(1, true);
				}
			}

			// You're not playing anymore.
			if (g_PlayerPlaying[client])
			{
				ClientSetQueuePoints(client, 0);
			}

			g_PlayerPlaying[client] = false;
			g_PlayerEliminated[client] = true;
			g_PlayerEscaped[client] = false;

			if (!GetEntProp(client, Prop_Send, "m_bIsCoaching"))
			{
				// This is to prevent player spawn spam when someone is coaching. Who coaches in SF2, anyway?
				TF2_RespawnPlayer(client);
			}

			// Special round.
			if (g_IsSpecialRound)
			{
				g_PlayerPlayedSpecialRound[client] = true;
			}

			// Boss round.
			if (g_NewBossRound)
			{
				g_PlayerPlayedNewBossRound[client] = true;
			}

			if (!g_FullyEnableSpectatorConVar.BoolValue)
			{
				g_PlayerSwitchBlueTimer[client] = CreateTimer(0.5, Timer_PlayerSwitchToBlue, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
			}
		}
		else
		{
			if (!g_PlayerChoseTeam[client])
			{
				g_PlayerChoseTeam[client] = true;

				if (g_PlayerPreferences[client].PlayerPreference_ProjectedFlashlight)
				{
					EmitSoundToClient(client, SF2_PROJECTED_FLASHLIGHT_CONFIRM_SOUND);
					CPrintToChat(client, "%T", "SF2 Projected Flashlight", client);
				}
				else
				{
					CPrintToChat(client, "%T", "SF2 Normal Flashlight", client);
				}

				CreateTimer(5.0, Timer_WelcomeMessage, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
			}
		}
		Call_StartForward(g_OnPlayerTeamPFwd);
		Call_PushCell(SF2_BasePlayer(client));
		Call_PushCell(teamNum);
		Call_Finish();
	}

	// Check groups.
	if (!IsRoundEnding())
	{
		for (int i = 0; i < SF2_MAX_PLAYER_GROUPS; i++)
		{
			if (!IsPlayerGroupActive(i))
			{
				continue;
			}
			CheckPlayerGroup(i);
		}
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("EVENT END: Event_PlayerTeam");
	}
	#endif
	delete event;

	return Plugin_Continue;
}

Action Event_PlayerSpawn(Handle event, const char[] name, bool dB)
{
	if (!g_Enabled)
	{
		if (g_LoadOutsideMapsConVar.BoolValue && GetClientOfUserId(GetEventInt(event, "userid")) > 0)
		{
			Call_StartForward(g_OnPlayerSpawnPFwd);
			Call_PushCell(SF2_BasePlayer(GetClientOfUserId(GetEventInt(event, "userid"))));
			Call_Finish();
		}
		return Plugin_Continue;
	}

	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (client <= 0)
	{
		return Plugin_Continue;
	}
	#if defined DEBUG

	Handle profiler = CreateProfiler();
	StartProfiling(profiler);
	SendDebugMessageToPlayers(DEBUG_EVENT, 0, "(Event_PlayerSpawn) Started profiling...");

	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("EVENT START: Event_PlayerSpawn(%d)", client);
	}
	#endif

	for (int i = 0; i < view_as<int>(TFCond_PowerupModeDominant); i++)
	{
		g_ClientInCondition[client][i] = false;
	}

	if (GetClientTeam(client) > 1)
	{
		g_LastVisibilityProcess[client] = GetGameTime();
	}
	if (!IsClientParticipating(client))
	{
		TF2Attrib_SetByName(client, "increased jump height", 1.0);
		TF2Attrib_RemoveByDefIndex(client, 10);

		SetEntityGravity(client, 1.0);
		g_PlayerPageCount[client] = 0;

		ClientResetSlenderStats(client);
		ClientResetOverlay(client);
		ClientResetJumpScare(client);
		ClientUpdateListeningFlags(client);
		ClientResetScare(client);

		for (int npcIndex = 0; npcIndex < MAX_BOSSES; npcIndex++)
		{
			if (NPCGetUniqueID(npcIndex) == -1)
			{
				continue;
			}
			if (g_NpcChaseOnLookTarget[npcIndex] == null)
			{
				continue;
			}
			int foundClient = g_NpcChaseOnLookTarget[npcIndex].FindValue(client);
			if (foundClient != -1)
			{
				g_NpcChaseOnLookTarget[npcIndex].Erase(foundClient);
			}
		}
	}

	if (SF_IsBoxingMap() && IsRoundInEscapeObjective())
	{
		CreateTimer(0.2, Timer_CheckAlivePlayers, _, TIMER_FLAG_NO_MAPCHANGE);
	}

	g_PlayerPostWeaponsTimer[client] = null;
	g_PlayerPageRewardCycleTimer[client] = null;
	g_PlayerFireworkTimer[client] = null;

	g_PlayerGettingPageReward[client] = false;
	g_PlayerHitsToCrits[client] = 0;
	g_PlayerHitsToHeads[client] = 0;

	g_PlayerTrapped[client] = false;
	g_PlayerTrapCount[client] = 0;

	g_PlayerLatchedByTongue[client] = false;
	g_PlayerLatchCount[client] = 0;
	g_PlayerLatcher[client] = -1;

	g_PlayerRandomClassNumber[client] = 1;

	if (IsPlayerAlive(client) && IsClientParticipating(client))
	{
		if (MusicActive()) //A boss is overriding the music.
		{
			char path[PLATFORM_MAX_PATH];
			GetBossMusic(path, sizeof(path));
			if (path[0] != '\0')
			{
				StopSound(client, MUSIC_CHAN, path);
			}
		}
		g_PlayerBackStabbed[client] = false;
		TF2_RemoveCondition(client, TFCond_HalloweenKart);
		TF2_RemoveCondition(client, TFCond_HalloweenKartDash);
		TF2_RemoveCondition(client, TFCond_HalloweenKartNoTurn);
		TF2_RemoveCondition(client, TFCond_HalloweenKartCage);
		TF2_RemoveCondition(client, TFCond_SpawnOutline);

		if (HandlePlayerTeam(client))
		{
			#if defined DEBUG
			if (g_DebugDetailConVar.IntValue > 0)
			{
				DebugMessage("client->HandlePlayerTeam()");
			}
			#endif
		}
		else
		{
			g_PlayerPageCount[client] = 0;

			ClientResetSlenderStats(client);
			ClientResetOverlay(client);
			ClientResetJumpScare(client);
			ClientUpdateListeningFlags(client);
			ClientResetScare(client);

			for (int npcIndex = 0; npcIndex < MAX_BOSSES; npcIndex++)
			{
				if (NPCGetUniqueID(npcIndex) == -1)
				{
					continue;
				}
				if (g_NpcChaseOnLookTarget[npcIndex] == null)
				{
					continue;
				}
				int foundClient = g_NpcChaseOnLookTarget[npcIndex].FindValue(client);
				if (foundClient != -1)
				{
					g_NpcChaseOnLookTarget[npcIndex].Erase(foundClient);
				}
			}

			TF2Attrib_SetByName(client, "increased jump height", 1.0);

			if (!g_PlayerEliminated[client])
			{
				if (IsFakeClient(client))
				{
					TF2_SetPlayerClass(client, TFClass_Sniper);
				}
				if ((SF_IsRaidMap() || SF_IsBoxingMap()) && !IsRoundPlaying())
				{
					TF2Attrib_SetByDefIndex(client, 10, 7.0);
				}
				else
				{
					TF2Attrib_RemoveByDefIndex(client, 10);
				}

				if (!DidClientEscape(client))
				{
					TF2Attrib_SetByDefIndex(client, 49, 1.0);
					CreateTimer(0.1, Timer_StopAirDash, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
				}

				ClientSetScareBoostEndTime(client, -1.0);

				HandlePlayerIntroState(client);

				if (IsFakeClient(client))
				{
					CreateTimer(0.1, Timer_SwitchBot, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
				}

				// screen overlay timer
				if (!SF_IsRaidMap() && !SF_IsBoxingMap())
				{
					g_PlayerOverlayCheck[client] = CreateTimer(0.0, Timer_PlayerOverlayCheck, GetClientUserId(client), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
					TriggerTimer(g_PlayerOverlayCheck[client], true);
				}
				if (DidClientEscape(client))
				{
					CreateTimer(0.1, Timer_TeleportPlayerToEscapePoint, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
				}
			}
			else
			{
				g_PlayerOverlayCheck[client] = null;
				TF2Attrib_RemoveByDefIndex(client, 10);
				TF2Attrib_RemoveByDefIndex(client, 49);
				TF2Attrib_RemoveByDefIndex(client, 28);
			}
			ClientSwitchToWeaponSlot(client, TFWeaponSlot_Melee);
			g_PlayerPostWeaponsTimer[client] = CreateTimer(0.1, Timer_ClientPostWeapons, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);

			HandlePlayerHUD(client);
		}
	}

	Call_StartForward(g_OnPlayerSpawnPFwd);
	Call_PushCell(SF2_BasePlayer(client));
	Call_Finish();

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("EVENT END: Event_PlayerSpawn(%d)", client);
	}

	StopProfiling(profiler);
	SendDebugMessageToPlayers(DEBUG_EVENT, 0, "(Event_PlayerSpawn) Stopped profiling, function executed in %f", GetProfilerTime(profiler));
	delete profiler;
	#endif

	delete event;

	return Plugin_Continue;
}

void Event_PlayerClass(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (client <= 0)
	{
		return;
	}

	Call_StartForward(g_OnPlayerClassPFwd);
	Call_PushCell(SF2_BasePlayer(client));
	Call_Finish();
}

Action Event_PostInventoryApplication(Handle event, const char[] name, bool dB)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("EVENT START: Event_PostInventoryApplication");
	}
	#endif

	SF2_BasePlayer client = SF2_BasePlayer(GetClientOfUserId(GetEventInt(event, "userid")));
	if (client.IsValid)
	{
		client.SwitchToWeaponSlot(TFWeaponSlot_Melee);
		g_PlayerPostWeaponsTimer[client.index] = CreateTimer(0.1, Timer_ClientPostWeapons, client.UserID, TIMER_FLAG_NO_MAPCHANGE);
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("EVENT END: Event_PostInventoryApplication");
	}
	#endif
	delete event;

	return Plugin_Continue;
}

Action Event_DontBroadcastToClients(Handle event, const char[] name, bool dB)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}
	if (IsRoundInWarmup())
	{
		return Plugin_Continue;
	}

	SetEventBroadcast(event, true);
	delete event;
	return Plugin_Continue;
}

Action Event_PlayerDeathPre(Event event, const char[] name, bool dB)
{
	if (!g_Enabled)
	{
		if (g_LoadOutsideMapsConVar.BoolValue && GetClientOfUserId(event.GetInt("userid")) > 0)
		{
			Call_StartForward(g_OnPlayerDeathPrePFwd);
			Call_PushCell(SF2_BasePlayer(GetClientOfUserId(event.GetInt("userid"))));
			Call_PushCell(event.GetInt("attacker"));
			Call_PushCell(event.GetInt("inflictor_entindex"));
			Call_PushCell((event.GetInt("death_flags") & TF_DEATHFLAG_DEADRINGER) != 0);
			Call_Finish();
		}
		return Plugin_Continue;
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 1)
	{
		DebugMessage("EVENT START: Event_PlayerDeathPre");
	}
	#endif
	int client = GetClientOfUserId(event.GetInt("userid"));

	for (int i = 0; i < view_as<int>(TFCond_PowerupModeDominant); i++)
	{
		g_ClientInCondition[client][i] = false;
	}

	int inflictor = event.GetInt("inflictor_entindex");
	int owner = inflictor;

	if (IsValidEntity(inflictor) && !SF2_ChaserEntity(inflictor).IsValid() && !SF2_StatueEntity(inflictor).IsValid() && !IsValidClient(inflictor))
	{
		owner = GetEntPropEnt(inflictor, Prop_Send, "m_hOwnerEntity");
	}

	Call_StartForward(g_OnPlayerDeathPrePFwd);
	Call_PushCell(SF2_BasePlayer(client));
	Call_PushCell(event.GetInt("attacker"));
	Call_PushCell(inflictor);
	Call_PushCell((event.GetInt("death_flags") & TF_DEATHFLAG_DEADRINGER) != 0);
	Call_Finish();

	int npcIndex = NPCGetFromEntIndex(owner);
	if (npcIndex != -1)
	{
		int target = GetClientOfUserId(g_SourceTVUserID);
		if (!IsValidClient(target) || !IsClientSourceTV(target)) // If the server has a source TV bot uses to print boss' name in kill feed.
		{
			target = GetClientForDeath(client);
		}

		if (target != -1)
		{
			if (g_TimerChangeClientName[target] != null)
			{
				KillTimer(g_TimerChangeClientName[target]);
			}
			else
			{
				GetEntPropString(target, Prop_Data, "m_szNetname", g_OldClientName[target], sizeof(g_OldClientName[]));
			}

			char bossName[SF2_MAX_NAME_LENGTH], profile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(npcIndex, profile, sizeof(profile));
			NPCGetBossName(npcIndex, bossName, sizeof(bossName));

			SetClientName(target, bossName);
			SetEntPropString(target, Prop_Data, "m_szNetname", bossName);

			event.SetString("assister_fallback", "");
			if ((NPCGetFlags(npcIndex) & SFF_WEAPONKILLS) || (NPCGetFlags(npcIndex) & SFF_WEAPONKILLSONRADIUS))
			{
				if (NPCGetFlags(npcIndex) & SFF_WEAPONKILLS && SF2_ChaserEntity(owner).IsValid())
				{
					SF2_ChaserEntity chaser = SF2_ChaserEntity(owner);
					SF2ChaserBossProfileData data;
					data = NPCChaserGetProfileData(npcIndex);
					SF2ChaserBossProfileAttackData attackData;
					data.GetAttack(chaser.GetAttackName(), attackData);
					event.SetString("weapon_logclassname", attackData.WeaponString);
					event.SetString("weapon", attackData.WeaponString);
					event.SetInt("customkill", attackData.WeaponInt);
				}
				else if (NPCGetFlags(npcIndex) & SFF_WEAPONKILLSONRADIUS)
				{
					char weaponType[PLATFORM_MAX_PATH];
					int weaponNum = GetBossProfileWeaponInt(profile);
					GetBossProfileWeaponString(profile, weaponType, sizeof(weaponType));
					event.SetString("weapon_logclassname", weaponType);
					event.SetString("weapon", weaponType);
					event.SetInt("customkill", weaponNum);
				}
			}
			else
			{
				event.SetString("weapon", "");
				event.SetString("weapon_logclassname", "");
			}

			int userid = GetClientUserId(target);
			event.SetInt("attacker", userid);
			g_TimerChangeClientName[target] = CreateTimer(0.6, Timer_RevertClientName, target, TIMER_FLAG_NO_MAPCHANGE);
		}
	}

	#if defined DEBUG
	char stringName[128];
	event.GetString("weapon", stringName, sizeof(stringName));
	SendDebugMessageToPlayers(DEBUG_KILLICONS, 0, "String kill icon is %s, integer kill icon is %i.", stringName, event.GetInt("customkill"));
	#endif

	if (!IsRoundInWarmup())
	{
		if (client > 0)
		{
			if (g_PlayerBackStabbed[client])
			{
				event.SetInt("customkill", TF_CUSTOM_BACKSTAB);
				g_PlayerBackStabbed[client] = false;
			}
		}
	}

	bool modify = false;

	if (!modify && SF2_ProjectileIceball(inflictor).IsValid())
	{
		modify = true;
		CreateTimer(0.01, Timer_IceRagdoll, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}

	if (!modify && SF2_ProjectileCowMangler(inflictor).IsValid())
	{
		modify = true;
		CreateTimer(0.01, Timer_ManglerRagdoll, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}

	if (npcIndex != -1)
	{
		SF2BossProfileData data;
		data = NPCGetProfileData(npcIndex);
		g_PlayerBossKillSubject[client] = npcIndex;

		if (!modify && (data.AshRagdoll || data.CloakRagdoll || data.DecapRagdoll || data.DeleteRagdoll || data.DissolveRagdoll ||
			data.ElectrocuteRagdoll || data.GoldRagdoll || data.IceRagdoll || data.PlasmaRagdoll || data.PushRagdoll ||
			data.ResizeRagdoll || data.BurnRagdoll || data.GibRagdoll))
		{
			modify = true;
			CreateTimer(0.01, Timer_ModifyRagdoll, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
		}

		if (data.CustomDeathFlag)
		{
			event.SetInt("death_flags", data.CustomDeathFlagType);
		}

		if (!modify && data.DecapOrGibRagdoll)
		{
			modify = true;
			CreateTimer(0.01, Timer_DeGibRagdoll, GetClientUserId(client));
		}

		if (!modify && data.MultiEffectRagdoll)
		{
			modify = true;
			CreateTimer(0.01, Timer_MultiRagdoll, GetClientUserId(client));
		}
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 1)
	{
		DebugMessage("EVENT END: Event_PlayerDeathPre");
	}
	#endif

	event.BroadcastDisabled = true;
	return Plugin_Changed;
}

Action Event_PlayerHurt(Handle event, const char[] name, bool dB)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (client <= 0)
	{
		return Plugin_Continue;
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("EVENT START: Event_PlayerHurt");
	}
	#endif

	int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	if (attacker > 0)
	{
		if (g_PlayerProxy[attacker])
		{
			g_PlayerProxyControl[attacker] = 100;
		}
	}

	// Play any sounds, if any.
	if (g_PlayerProxy[client])
	{
		int proxyMaster = NPCGetFromUniqueID(g_PlayerProxyMaster[client]);
		if (proxyMaster != -1)
		{
			char profile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(proxyMaster, profile, sizeof(profile));

			SF2BossProfileSoundInfo soundInfo;
			GetBossProfileProxyHurtSounds(profile, soundInfo);
			if (soundInfo.Paths != null && soundInfo.Paths.Length > 0)
			{
				soundInfo.EmitSound(_, client);
			}
		}
	}
	delete event;
	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("EVENT END: Event_PlayerHurt");
	}
	#endif
	return Plugin_Continue;
}

Action Event_PlayerDeath(Event event, const char[] name, bool dB)
{
	if (!g_Enabled)
	{
		if (g_LoadOutsideMapsConVar.BoolValue && GetClientOfUserId(event.GetInt("userid")) > 0)
		{
			Call_StartForward(g_OnPlayerDeathPFwd);
			Call_PushCell(SF2_BasePlayer(GetClientOfUserId(event.GetInt("userid"))));
			Call_PushCell(event.GetInt("attacker"));
			Call_PushCell(event.GetInt("inflictor_entindex"));
			Call_PushCell((event.GetInt("death_flags") & TF_DEATHFLAG_DEADRINGER) != 0);
			Call_Finish();
		}
		return Plugin_Continue;
	}

	int client = GetClientOfUserId(event.GetInt("userid"));
	if (client <= 0)
	{
		return Plugin_Continue;
	}

	int attacker = event.GetInt("attacker");

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("EVENT START: Event_PlayerDeath(%d)", client);
	}
	#endif

	bool fake = (event.GetInt("death_flags") & TF_DEATHFLAG_DEADRINGER) != 0;
	int inflictor = event.GetInt("inflictor_entindex");

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("inflictor = %d", inflictor);
	}
	#endif

	if (!fake)
	{
		ClientResetSlenderStats(client);
		ClientResetOverlay(client);
		ClientResetJumpScare(client);

		for (int npcIndex = 0; npcIndex < MAX_BOSSES; npcIndex++)
		{
			if (NPCGetUniqueID(npcIndex) == -1)
			{
				continue;
			}
			if (g_NpcChaseOnLookTarget[npcIndex] == null)
			{
				continue;
			}
			int foundClient = g_NpcChaseOnLookTarget[npcIndex].FindValue(client);
			if (foundClient != -1)
			{
				g_NpcChaseOnLookTarget[npcIndex].Erase(foundClient);
			}
		}

		if (IsRoundInWarmup())
		{
			CreateTimer(0.3, Timer_RespawnPlayer, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
		}
		else
		{
			if (!g_PlayerEliminated[client])
			{
				if (IsRoundInIntro() || (!IsRoundPlaying() && !IsRoundEnding()) || DidClientEscape(client) || (SF_SpecialRound(SPECIALROUND_1UP) && g_PlayerIn1UpCondition[client] && !g_PlayerDied1Up[client]))
				{
					CreateTimer(0.3, Timer_RespawnPlayer, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
				}
				else
				{
					g_PlayerEliminated[client] = true;
					g_PlayerEscaped[client] = false;
					g_PlayerFullyDied1Up[client] = true;
					g_PlayerSwitchBlueTimer[client] = CreateTimer(0.5, Timer_PlayerSwitchToBlue, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
				}
			}
			else
			{
			}

			CreateTimer(0.2, Timer_CheckRoundWinConditions, _, TIMER_FLAG_NO_MAPCHANGE);

			if (g_IgnoreRedPlayerDeathSwapConVar.BoolValue && GetClientTeam(client) == TFTeam_Red)
			{
				g_PlayerEliminated[client] = false;
				g_PlayerEscaped[client] = false;
			}
		}

		ClientUpdateListeningFlags(client);

		// Half-Zatoichi nerf code.
		int katanaHealthGain = 5;
		if (katanaHealthGain >= 0)
		{
			SF2_BasePlayer attackerClient = SF2_BasePlayer(GetClientOfUserId(attacker));
			if (attackerClient.IsValid)
			{
				if (!attackerClient.IsInPvP && (!attackerClient.IsEliminated || attackerClient.IsProxy))
				{
					char weaponClass[64];
					event.GetString("weapon", weaponClass, sizeof(weaponClass));

					if (strcmp(weaponClass, "demokatana") == 0)
					{
						int attackerPreHealth = attackerClient.GetProp(Prop_Send, "m_iHealth");
						Handle pack = CreateDataPack();
						WritePackCell(pack, attackerClient.UserID);
						WritePackCell(pack, attackerPreHealth + katanaHealthGain);

						CreateTimer(0.0, Timer_SetPlayerHealth, pack, TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
		}

		g_PlayerPostWeaponsTimer[client] = null;
		g_PlayerPageRewardCycleTimer[client] = null;
		g_PlayerFireworkTimer[client] = null;

		g_PlayerGettingPageReward[client] = false;
		g_PlayerHitsToCrits[client] = 0;
		g_PlayerHitsToHeads[client] = 0;

		g_PlayerTrapped[client] = false;
		g_PlayerTrapCount[client] = 0;

		g_PlayerLatchedByTongue[client] = false;
		g_PlayerLatchCount[client] = 0;
		g_PlayerLatcher[client] = -1;

		g_PlayerRandomClassNumber[client] = 1;
	}
	if (!IsRoundEnding() && !g_RoundWaitingForPlayers)
	{
		SF2_BasePlayer attackerClient = SF2_BasePlayer(GetClientOfUserId(attacker));
		if (IsRoundPlaying() && client != attackerClient.index)
		{
			//Copy the data
			char string[64];
			Event event2 = CreateEvent("player_death", true);
			event2.SetInt("userid", event.GetInt("userid"));
			event2.SetInt("victim_entindex", event.GetInt("victim_entindex"));
			event2.SetInt("inflictor_entindex", event.GetInt("inflictor_entindex"));
			event2.SetInt("attacker", event.GetInt("attacker"));
			event2.SetInt("weaponid", event.GetInt("weaponid"));
			event2.SetInt("damagebits", event.GetInt("damagebits"));
			event2.SetInt("customkill", event.GetInt("customkill"));
			event2.SetInt("assister", event.GetInt("assister"));
			event2.SetInt("stun_flags", event.GetInt("stun_flags"));
			event2.SetInt("death_flags", event.GetInt("death_flags"));
			event2.SetBool("silent_kill", event.GetBool("silent_kill"));
			event2.SetInt("playerpenetratecount", event.GetInt("playerpenetratecount"));
			event2.SetInt("kill_streak_total", event.GetInt("kill_streak_total"));
			event2.SetInt("kill_streak_wep", event.GetInt("kill_streak_wep"));
			event2.SetInt("kill_streak_assist", event.GetInt("kill_streak_assist"));
			event2.SetInt("kill_streak_victim", event.GetInt("kill_streak_victim"));
			event2.SetInt("ducks_streaked", event.GetInt("ducks_streaked"));
			event2.SetInt("duck_streak_total", event.GetInt("duck_streak_total"));
			event2.SetInt("duck_streak_assist", event.GetInt("duck_streak_assist"));
			event2.SetInt("duck_streak_victim", event.GetInt("duck_streak_victim"));
			event2.SetBool("rocket_jump", event.GetBool("rocket_jump"));
			event2.SetInt("weapon_def_index", event.GetInt("weapon_def_index"));
			event.GetString("weapon_logclassname", string, sizeof(string));
			event2.SetString("weapon_logclassname", string);
			event.GetString("assister_fallback", string, sizeof(string));
			event2.SetString("assister_fallback", string);
			event.GetString("weapon", string, sizeof(string));
			event2.SetString("weapon", string);

			CreateTimer(0.2, Timer_SendDeath, event2, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	if (SF_IsBoxingMap() && IsRoundInEscapeObjective())
	{
		CreateTimer(0.2, Timer_CheckAlivePlayers, _, TIMER_FLAG_NO_MAPCHANGE);
	}

	Call_StartForward(g_OnPlayerDeathPFwd);
	Call_PushCell(SF2_BasePlayer(client));
	Call_PushCell(attacker);
	Call_PushCell(inflictor);
	Call_PushCell(fake);
	Call_Finish();

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("EVENT END: Event_PlayerDeath(%d)", client);
	}
	#endif
	delete event;

	return Plugin_Continue;
}

static bool g_MuteHealOnHit = false;

Action Event_PlayerHealed(Event event, const char[] name, bool dontBroadcast)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	int patient = GetClientOfUserId(event.GetInt("patient"));
	int healer = GetClientOfUserId(event.GetInt("healer"));
	if (!IsValidClient(patient) || !IsValidClient(healer))
	{
		return Plugin_Continue;
	}

	if ((IsClientInPvP(patient) && IsClientInPvP(healer)) || IsRoundInWarmup()) // Both in PvP
	{
		event.BroadcastDisabled = true;
		g_MuteHealOnHit = true;
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

Action Event_HealOnHit(Event event, const char[] name, bool dontBroadcast)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (g_MuteHealOnHit)
	{
		event.BroadcastDisabled = true;
		g_MuteHealOnHit = false;
		return Plugin_Handled;
	}
	return Plugin_Continue;
}
