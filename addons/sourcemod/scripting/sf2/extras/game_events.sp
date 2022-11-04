#if defined _sf2_game_events_included
 #endinput
#endif
#define _sf2_game_events_included

#pragma semicolon 1

public Action Event_RoundStart(Handle event, const char[] name, bool dB)
{
	if (!g_Enabled)
	{
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

	PvP_OnRoundStart();
	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("EVENT END: Event_RoundStart");
	}

	StopProfiling(profiler);
	SendDebugMessageToPlayers(DEBUG_EVENT, 0, "(Event_RoundStart) Stopped profiling, total execution time: %f", GetProfilerTime(profiler));
	delete profiler;

	#endif
	//Nextbot doesn't trigger the triggers with npc flags, for map backward compatibility we are going to change the trigger filter and force a custom one.
	/*int iEnt = -1;
	while ((iEnt = FindEntityByClassname(iEnt, "trigger_*")) != -1)
	{
		if (IsValidEntity(iEnt))
		{
			int flags = GetEntProp(iEnt, Prop_Data, "m_spawnflags");
			if ((flags & TRIGGER_NPCS) && !(flags & TRIGGER_EVERYTHING_BUT_PHYSICS_DEBRIS))
			{
				//Set the trigger to allow every entity, our custom filter will discard the unwanted entities.
				SetEntProp(iEnt, Prop_Data, "m_spawnflags", flags|TRIGGER_EVERYTHING_BUT_PHYSICS_DEBRIS);
				SDKHook(iEnt, SDKHook_StartTouch, Hook_TriggerNPCTouch);
				SDKHook(iEnt, SDKHook_Touch, Hook_TriggerNPCTouch);
				SDKHook(iEnt, SDKHook_EndTouch, Hook_TriggerNPCTouch);
			}
		}
	}*/

	return Plugin_Continue;
}

public Action Event_WinPanel(Event event, const char[] name, bool dontBroadcast)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	char cappers[7];
	int i = 0;
	for (int client; client <= MaxClients; client++)
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

public Action Event_Audio(Event event, const char[] name, bool dB)
{
	char strAudio[PLATFORM_MAX_PATH];

	GetEventString(event, "sound", strAudio, sizeof(strAudio));
	if (strncmp(strAudio, "Game.Your", 9) == 0 || strcmp(strAudio, "Game.Stalemate") == 0)
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

public Action Event_RoundEnd(Handle event, const char[] name, bool dB)
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

	if (SF_IsRenevantMap() && g_RenevantWaveTimer != null) KillTimer(g_RenevantWaveTimer);

	for (int i = 1; i < MaxClients; i++)
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

	SpecialRound_RoundEnd();

	SetRoundState(SF2RoundState_Outro);

	DistributeQueuePointsToPlayers();

	g_RoundEndCount++;
	CheckRoundLimitForBossPackVote(g_RoundEndCount);

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("EVENT END: Event_RoundEnd");
	}
	#endif
	delete event;

	return Plugin_Continue;
}

public Action Event_PlayerTeamPre(Handle event, const char[] name, bool dB)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 1)
	{
		DebugMessage("EVENT START: Event_PlayerTeamPre");
	}
	#endif

	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (client > 0)
	{
		if (GetEventInt(event, "team") > 1 || GetEventInt(event, "oldteam") > 1)
		{
			SetEventBroadcast(event, true);
		}
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 1)
	{
		DebugMessage("EVENT END: Event_PlayerTeamPre");
	}
	#endif

	delete event;

	return Plugin_Continue;
}

public Action Event_PlayerTeam(Handle event, const char[] name, bool dB)
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

			ClientSetGhostModeState(client, false);

			if (!view_as<bool>(GetEntProp(client, Prop_Send, "m_bIsCoaching")))
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
				AFK_SetAFK(client);
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
			if (SF_SpecialRound(SPECIALROUND_THANATOPHOBIA) && !g_PlayerEliminated[client] && teamNum == TFTeam_Red &&
				!DidClientEscape(client))
			{
				TFClassType class = TF2_GetPlayerClass(client);
				int classToInt = view_as<int>(class);
				if (!IsClassConfigsValid())
				{
					if (class == TFClass_Medic)
					{
						ShowVGUIPanel(client, "class_red");
						EmitSoundToClient(client, THANATOPHOBIA_MEDICNO);
						TFClassType newClass;
						int random = GetRandomInt(1, 8);
						switch (random)
						{
							case 1:
							{
								newClass = TFClass_Scout;
							}
							case 2:
							{
								newClass = TFClass_Soldier;
							}
							case 3:
							{
								newClass = TFClass_Pyro;
							}
							case 4:
							{
								newClass = TFClass_DemoMan;
							}
							case 5:
							{
								newClass = TFClass_Heavy;
							}
							case 6:
							{
								newClass = TFClass_Engineer;
							}
							case 7:
							{
								newClass = TFClass_Sniper;
							}
							case 8:
							{
								newClass = TFClass_Spy;
							}
						}
						TF2_SetPlayerClass(client, newClass);
						TF2_RegeneratePlayer(client);
					}
				}
				else
				{
					if (g_ClassBlockedOnThanatophobia[classToInt])
					{
						ShowVGUIPanel(client, "class_red");
						switch (class)
						{
							case TFClass_Scout:
							{
								EmitSoundToClient(client, THANATOPHOBIA_SCOUTNO);
							}
							case TFClass_Soldier:
							{
								EmitSoundToClient(client, THANATOPHOBIA_SOLDIERNO);
							}
							case TFClass_Pyro:
							{
								EmitSoundToClient(client, THANATOPHOBIA_PYRONO);
							}
							case TFClass_DemoMan:
							{
								EmitSoundToClient(client, THANATOPHOBIA_DEMOMANNO);
							}
							case TFClass_Heavy:
							{
								EmitSoundToClient(client, THANATOPHOBIA_HEAVYNO);
							}
							case TFClass_Engineer:
							{
								EmitSoundToClient(client, THANATOPHOBIA_ENGINEERNO);
							}
							case TFClass_Medic:
							{
								EmitSoundToClient(client, THANATOPHOBIA_MEDICNO);
							}
							case TFClass_Sniper:
							{
								EmitSoundToClient(client, THANATOPHOBIA_SNIPERNO);
							}
							case TFClass_Spy:
							{
								EmitSoundToClient(client, THANATOPHOBIA_SPYNO);
							}
						}
						ArrayList classArrays = new ArrayList();
						for (int i = 1; i < MAX_CLASSES + 1; i++)
						{
							if (!g_ClassBlockedOnThanatophobia[i])
							{
								classArrays.Push(view_as<TFClassType>(i));
							}
						}
						TFClassType newClass = classArrays.Get(GetRandomInt(0, classArrays.Length - 1));
						TF2_SetPlayerClass(client, newClass);
						TF2_RegeneratePlayer(client);
						delete classArrays;
					}
				}
			}
		}
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

public Action Event_PlayerSpawn(Handle event, const char[] name, bool dB)
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

	Handle profiler = CreateProfiler();
	StartProfiling(profiler);
	SendDebugMessageToPlayers(DEBUG_EVENT, 0, "(Event_PlayerSpawn) Started profiling...");

	//PrintToChatAll("(SPAWN) Spawn event called.");
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("EVENT START: Event_PlayerSpawn(%d)", client);
	}
	#endif

	if (GetClientTeam(client) > 1)
	{
		g_LastVisibilityProcess[client] = GetGameTime();
		ClientResetStatic(client);
		if (!g_SeeUpdateMenu[client])
		{
			g_SeeUpdateMenu[client] = true;
			DisplayMenu(g_MenuUpdate, client, 30);
		}
	}
	if (!IsClientParticipating(client))
	{
		TF2Attrib_SetByName(client, "increased jump height", 1.0);
		TF2Attrib_RemoveByDefIndex(client, 10);

		ClientSetGhostModeState(client, false);
		SetEntityGravity(client, 1.0);
		g_PlayerPageCount[client] = 0;

		ClientResetStatic(client);
		ClientResetSlenderStats(client);
		ClientResetCampingStats(client);
		ClientResetOverlay(client);
		ClientResetJumpScare(client);
		ClientUpdateListeningFlags(client);
		ClientUpdateMusicSystem(client);
		ClientChaseMusicReset(client);
		ClientChaseMusicSeeReset(client);
		ClientAlertMusicReset(client);
		ClientIdleMusicReset(client);
		Client90sMusicReset(client);
		ClientMusicReset(client);
		ClientResetProxy(client);
		ClientResetHints(client);
		ClientResetScare(client);

		ClientResetDeathCam(client);
		ClientResetFlashlight(client);
		ClientDeactivateUltravision(client);
		ClientResetSprint(client);
		ClientResetBreathing(client);
		ClientResetBlink(client);
		ClientResetInteractiveGlow(client);
		ClientDisableConstantGlow(client);

		ClientHandleGhostMode(client);

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
	g_PlayerIgniteTimer[client] = null;
	g_PlayerPageRewardCycleTimer[client] = null;
	g_PlayerFireworkTimer[client] = null;

	g_PlayerBossKillSubject[client] = INVALID_ENT_REFERENCE;

	g_PlayerGettingPageReward[client] = false;
	g_PlayerHitsToCrits[client] = 0;
	g_PlayerHitsToHeads[client] = 0;

	g_PlayerTrapped[client] = false;
	g_PlayerTrapCount[client] = 0;

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

			ClientResetStatic(client);
			ClientResetSlenderStats(client);
			ClientResetCampingStats(client);
			ClientResetOverlay(client);
			ClientResetJumpScare(client);
			ClientUpdateListeningFlags(client);
			ClientUpdateMusicSystem(client);
			ClientChaseMusicReset(client);
			ClientChaseMusicSeeReset(client);
			ClientAlertMusicReset(client);
			ClientIdleMusicReset(client);
			Client90sMusicReset(client);
			ClientMusicReset(client);
			ClientResetProxy(client);
			ClientResetHints(client);
			ClientResetScare(client);

			ClientResetDeathCam(client);
			ClientResetFlashlight(client);
			ClientDeactivateUltravision(client);
			ClientResetSprint(client);
			ClientResetBreathing(client);
			ClientResetBlink(client);
			ClientResetInteractiveGlow(client);
			ClientDisableConstantGlow(client);

			ClientHandleGhostMode(client);

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

				if (SF_SpecialRound(SPECIALROUND_SINGLEPLAYER))
				{
					TF2_StripContrackerOnly(client);
				}

				ClientStartDrainingBlinkMeter(client);
				ClientSetScareBoostEndTime(client, -1.0);

				ClientStartCampingTimer(client);

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
				else
				{
					int red[4] = { 184, 56, 59, 255 };
					ClientEnableConstantGlow(client, red);
					ClientActivateUltravision(client);
				}

				if (SF_IsRenevantMap() && g_RenevantMarkForDeath && !DidClientEscape(client))
				{
					TF2_AddCondition(client, TFCond_MarkedForDeathSilent, -1.0);
				}

				if (SF_SpecialRound(SPECIALROUND_1UP) && !g_PlayerIn1UpCondition[client] && !g_PlayerDied1Up[client])
				{
					g_PlayerDied1Up[client] = false;
					g_PlayerIn1UpCondition[client] = true;
					g_PlayerFullyDied1Up[client] = false;
				}

				if (SF_SpecialRound(SPECIALROUND_PAGEDETECTOR))
				{
					ClientSetSpecialRoundTimer(client, 0.0, Timer_ClientPageDetector, GetClientUserId(client));
				}

				if (SF_SpecialRound(SPECIALROUND_THANATOPHOBIA) && !DidClientEscape(client))
				{
					TFClassType class = TF2_GetPlayerClass(client);
					int classToInt = view_as<int>(class);
					if (!IsClassConfigsValid())
					{
						if (class == TFClass_Medic)
						{
							ShowVGUIPanel(client, "class_red");
							EmitSoundToClient(client, THANATOPHOBIA_MEDICNO);
							TFClassType newClass;
							int random = GetRandomInt(1, 8);
							switch (random)
							{
								case 1:
								{
									newClass = TFClass_Scout;
								}
								case 2:
								{
									newClass = TFClass_Soldier;
								}
								case 3:
								{
									newClass = TFClass_Pyro;
								}
								case 4:
								{
									newClass = TFClass_DemoMan;
								}
								case 5:
								{
									newClass = TFClass_Heavy;
								}
								case 6:
								{
									newClass = TFClass_Engineer;
								}
								case 7:
								{
									newClass = TFClass_Sniper;
								}
								case 8:
								{
									newClass = TFClass_Spy;
								}
							}
							TF2_SetPlayerClass(client, newClass);
							TF2_RegeneratePlayer(client);
						}
					}
					else
					{
						if (g_ClassBlockedOnThanatophobia[classToInt])
						{
							ShowVGUIPanel(client, "class_red");
							switch (class)
							{
								case TFClass_Scout:
								{
									EmitSoundToClient(client, THANATOPHOBIA_SCOUTNO);
								}
								case TFClass_Soldier:
								{
									EmitSoundToClient(client, THANATOPHOBIA_SOLDIERNO);
								}
								case TFClass_Pyro:
								{
									EmitSoundToClient(client, THANATOPHOBIA_PYRONO);
								}
								case TFClass_DemoMan:
								{
									EmitSoundToClient(client, THANATOPHOBIA_DEMOMANNO);
								}
								case TFClass_Heavy:
								{
									EmitSoundToClient(client, THANATOPHOBIA_HEAVYNO);
								}
								case TFClass_Engineer:
								{
									EmitSoundToClient(client, THANATOPHOBIA_ENGINEERNO);
								}
								case TFClass_Medic:
								{
									EmitSoundToClient(client, THANATOPHOBIA_MEDICNO);
								}
								case TFClass_Sniper:
								{
									EmitSoundToClient(client, THANATOPHOBIA_SNIPERNO);
								}
								case TFClass_Spy:
								{
									EmitSoundToClient(client, THANATOPHOBIA_SPYNO);
								}
							}
							ArrayList classArrays = new ArrayList();
							for (int i = 1; i < MAX_CLASSES + 1; i++)
							{
								if (!g_ClassBlockedOnThanatophobia[i])
								{
									classArrays.Push(view_as<TFClassType>(i));
								}
							}
							TFClassType newClass = classArrays.Get(GetRandomInt(0, classArrays.Length - 1));
							TF2_SetPlayerClass(client, newClass);
							TF2_RegeneratePlayer(client);
							delete classArrays;
						}
					}
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

	PvP_OnPlayerSpawn(client);

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

public void Event_PlayerClass(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (client <= 0)
	{
		return;
	}

	int teamNum = GetClientTeam(client);

	if (SF_SpecialRound(SPECIALROUND_THANATOPHOBIA) && !g_PlayerEliminated[client] &&
		teamNum == TFTeam_Red && TF2_GetPlayerClass(client) == TFClass_Medic && !DidClientEscape(client))
	{
		TFClassType class = TF2_GetPlayerClass(client);
		int classToInt = view_as<int>(class);
		if (!IsClassConfigsValid())
		{
			if (class == TFClass_Medic)
			{
				ShowVGUIPanel(client, "class_red");
				EmitSoundToClient(client, THANATOPHOBIA_MEDICNO);
				TFClassType newClass;
				int random = GetRandomInt(1, 8);
				switch (random)
				{
					case 1:
					{
						newClass = TFClass_Scout;
					}
					case 2:
					{
						newClass = TFClass_Soldier;
					}
					case 3:
					{
						newClass = TFClass_Pyro;
					}
					case 4:
					{
						newClass = TFClass_DemoMan;
					}
					case 5:
					{
						newClass = TFClass_Heavy;
					}
					case 6:
					{
						newClass = TFClass_Engineer;
					}
					case 7:
					{
						newClass = TFClass_Sniper;
					}
					case 8:
					{
						newClass = TFClass_Spy;
					}
				}
				TF2_SetPlayerClass(client, newClass);
				TF2_RegeneratePlayer(client);
			}
		}
		else
		{
			if (g_ClassBlockedOnThanatophobia[classToInt])
			{
				ShowVGUIPanel(client, "class_red");
				switch (class)
				{
					case TFClass_Scout:
					{
						EmitSoundToClient(client, THANATOPHOBIA_SCOUTNO);
					}
					case TFClass_Soldier:
					{
						EmitSoundToClient(client, THANATOPHOBIA_SOLDIERNO);
					}
					case TFClass_Pyro:
					{
						EmitSoundToClient(client, THANATOPHOBIA_PYRONO);
					}
					case TFClass_DemoMan:
					{
						EmitSoundToClient(client, THANATOPHOBIA_DEMOMANNO);
					}
					case TFClass_Heavy:
					{
						EmitSoundToClient(client, THANATOPHOBIA_HEAVYNO);
					}
					case TFClass_Engineer:
					{
						EmitSoundToClient(client, THANATOPHOBIA_ENGINEERNO);
					}
					case TFClass_Medic:
					{
						EmitSoundToClient(client, THANATOPHOBIA_MEDICNO);
					}
					case TFClass_Sniper:
					{
						EmitSoundToClient(client, THANATOPHOBIA_SNIPERNO);
					}
					case TFClass_Spy:
					{
						EmitSoundToClient(client, THANATOPHOBIA_SPYNO);
					}
				}
				ArrayList classArrays = new ArrayList();
				for (int i = 1; i < MAX_CLASSES + 1; i++)
				{
					if (!g_ClassBlockedOnThanatophobia[i])
					{
						classArrays.Push(view_as<TFClassType>(i));
					}
				}
				TFClassType newClass = classArrays.Get(GetRandomInt(0, classArrays.Length - 1));
				TF2_SetPlayerClass(client, newClass);
				TF2_RegeneratePlayer(client);
				delete classArrays;
			}
		}
	}
}

public Action Event_PostInventoryApplication(Handle event, const char[] name, bool dB)
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

	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (client > 0)
	{
		ClientSwitchToWeaponSlot(client, TFWeaponSlot_Melee);
		g_PlayerPostWeaponsTimer[client] = CreateTimer(0.1, Timer_ClientPostWeapons, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
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
public Action Event_DontBroadcastToClients(Handle event, const char[] name, bool dB)
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

public Action Event_PlayerDeathPre(Event event, const char[] name, bool dB)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 1)
	{
		DebugMessage("EVENT START: Event_PlayerDeathPre");
	}
	#endif
	int client = GetClientOfUserId(event.GetInt("userid"));

	int inflictor = event.GetInt("inflictor_entindex");

	// If this player was killed by a boss, play a sound.
	int npcIndex = NPCGetFromEntIndex(inflictor);
	if (npcIndex != -1 && !IsEntityAProjectile(inflictor))
	{
		int target = GetClientOfUserId(g_SourceTVUserID);
		int attackIndex = NPCGetCurrentAttackIndex(npcIndex);
		if (MaxClients < target || target < 1 || !IsClientInGame(target) || !IsClientSourceTV(target)) //If the server has a source TV bot uses to print boss' name in kill feed.
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
				if (NPCGetFlags(npcIndex) & SFF_WEAPONKILLS)
				{
					char weaponType[PLATFORM_MAX_PATH];
					int weaponNum = NPCChaserGetAttackWeaponTypeInt(npcIndex, attackIndex);
					GetChaserProfileAttackWeaponTypeString(profile, attackIndex, weaponType, sizeof(weaponType));
					event.SetString("weapon_logclassname", weaponType);
					event.SetString("weapon", weaponType);
					event.SetInt("customkill", weaponNum);
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

			if (IsValidClient(target))
			{
				event.SetInt("ignore", target);

				//Show a different attacker to the user were taking
				target = GetClientForDeath(client, target);
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

					Format(bossName, sizeof(bossName), " %s", bossName);

					SetClientName(target, bossName);
					SetEntPropString(target, Prop_Data, "m_szNetname", bossName);

					g_TimerChangeClientName[target] = CreateTimer(0.6, Timer_RevertClientName, target, TIMER_FLAG_NO_MAPCHANGE);

					char string[64];
					Event event2 = CreateEvent("player_death", true);
					event2.SetInt("userid", event.GetInt("userid"));
					event2.SetInt("victim_entindex", event.GetInt("victim_entindex"));
					event2.SetInt("inflictor_entindex", event.GetInt("inflictor_entindex"));
					event2.SetInt("attacker", GetClientUserId(target));
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
					event.GetString("weapon", string, sizeof(string));
					event2.SetString("weapon", string);
					event2.SetInt("send", userid);

					CreateTimer(0.2, Timer_SendDeathToSpecific, event2);
				}
			}
		}
	}

	#if defined DEBUG
	char stringName[128];
	event.GetString("weapon", stringName, sizeof(stringName));
	SendDebugMessageToPlayers(DEBUG_KILLICONS, 0, "String kill icon is %s, integer kill icon is %i.", stringName, event.GetInt("customkill"));
	#endif

	if (IsEntityAProjectile(inflictor))
	{
		int npcIndex2 = NPCGetFromEntIndex(GetEntPropEnt(inflictor, Prop_Send, "m_hOwnerEntity"));
		if (npcIndex2 != -1)
		{
			int target = GetClientOfUserId(g_SourceTVUserID);
			if (MaxClients < target || target < 1 || !IsClientInGame(target) || !IsClientSourceTV(target)) //If the server has a source TV bot uses to print boss' name in kill feed.
			{
				target = GetClientForDeath(client);
			}

			if (target != -1)
			{
				if (g_TimerChangeClientName[target] != null)
				{
					KillTimer(g_TimerChangeClientName[target]);
				}
				else //No timer running that means the SourceTV bot's current name is the correct one, we can safely update our last known SourceTV bot's name.
				{
					GetEntPropString(target, Prop_Data, "m_szNetname", g_OldClientName[target], sizeof(g_OldClientName[]));
				}

				char bossName[SF2_MAX_NAME_LENGTH], profile[SF2_MAX_PROFILE_NAME_LENGTH];
				NPCGetProfile(npcIndex2, profile, sizeof(profile));
				NPCGetBossName(npcIndex2, bossName, sizeof(bossName));

				SetClientName(target, bossName);
				SetEntPropString(target, Prop_Data, "m_szNetname", bossName);

				event.SetString("assister_fallback", "");

				switch (ProjectileGetFlags(inflictor))
				{
					case PROJ_ROCKET:
					{
						event.SetString("weapon_logclassname", "tf_projectile_rocket");
						event.SetString("weapon", "tf_projectile_rocket");
					}
					case PROJ_MANGLER:
					{
						event.SetString("weapon_logclassname", "cow_mangler");
						event.SetString("weapon", "cow_mangler");
					}
					case PROJ_GRENADE:
					{
						event.SetString("weapon_logclassname", "tf_projectile_pipe");
						event.SetString("weapon", "tf_projectile_pipe");
					}
					case PROJ_FIREBALL, PROJ_ICEBALL, PROJ_FIREBALL_ATTACK, PROJ_ICEBALL_ATTACK:
					{
						event.SetString("weapon_logclassname", "spellbook_fireball");
						event.SetString("weapon", "spellbook_fireball");
					}
					case PROJ_SENTRYROCKET:
					{
						event.SetString("weapon_logclassname", "obj_sentrygun3");
						event.SetString("weapon", "obj_sentrygun3");
					}
				}

				int userid = GetClientUserId(target);
				event.SetInt("attacker", userid);
				g_TimerChangeClientName[target] = CreateTimer(0.6, Timer_RevertClientName, target, TIMER_FLAG_NO_MAPCHANGE);

				if (IsValidClient(target))
				{
					event.SetInt("ignore", target);

					//Show a different attacker to the user were taking
					target = GetClientForDeath(client, target);
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

						Format(bossName, sizeof(bossName), " %s", bossName);

						SetClientName(target, bossName);
						SetEntPropString(target, Prop_Data, "m_szNetname", bossName);

						g_TimerChangeClientName[target] = CreateTimer(0.6, Timer_RevertClientName, target, TIMER_FLAG_NO_MAPCHANGE);

						char string[64];
						Event event2 = CreateEvent("player_death", true);
						event2.SetInt("userid", event.GetInt("userid"));
						event2.SetInt("victim_entindex", event.GetInt("victim_entindex"));
						event2.SetInt("inflictor_entindex", event.GetInt("inflictor_entindex"));
						event2.SetInt("attacker", GetClientUserId(target));
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
						event.GetString("weapon", string, sizeof(string));
						event2.SetString("weapon", string);
						event2.SetInt("send", userid);

						CreateTimer(0.2, Timer_SendDeathToSpecific, event2);
					}
				}
			}
		}
	}

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
	if (MAX_BOSSES > npcIndex >= 0 && (g_SlenderHasAshKillEffect[npcIndex] || g_SlenderHasCloakKillEffect[npcIndex]
			 || g_SlenderHasDecapKillEffect[npcIndex] || g_SlenderHasDeleteKillEffect[npcIndex]
			 || g_SlenderHasDissolveRagdollOnKill[npcIndex]
			 || g_SlenderHasElectrocuteKillEffect[npcIndex] || g_SlenderHasGoldKillEffect[npcIndex]
			 || g_SlenderHasIceKillEffect[npcIndex] || g_SlenderHasPlasmaRagdollOnKill[npcIndex]
			 || g_SlenderHasPushRagdollOnKill[npcIndex] || g_SlenderHasResizeRagdollOnKill[npcIndex]
			 || g_SlenderHasBurnKillEffect[npcIndex] || g_SlenderHasGibKillEffect[npcIndex]))
	{
		CreateTimer(0.01, Timer_ModifyRagdoll, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}
	if (MAX_BOSSES > npcIndex >= 0 && g_SlenderPlayerCustomDeathFlag[npcIndex])
	{
		event.SetInt("death_flags", g_SlenderPlayerSetDeathFlag[npcIndex]);
	}
	if (MAX_BOSSES > npcIndex >= 0 && g_SlenderHasDecapOrGibKillEffect[npcIndex])
	{
		CreateTimer(0.01, Timer_DeGibRagdoll, GetClientUserId(client));
	}

	if (MAX_BOSSES > npcIndex >= 0 && g_SlenderHasMultiKillEffect[npcIndex])
	{
		CreateTimer(0.01, Timer_MultiRagdoll, GetClientUserId(client));
	}
	if (IsEntityAProjectile(inflictor))
	{
		switch (ProjectileGetFlags(inflictor))
		{
			case PROJ_MANGLER:
			{
				CreateTimer(0.01, Timer_ManglerRagdoll, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
			}
			case PROJ_ICEBALL:
			{
				CreateTimer(0.01, Timer_IceRagdoll, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
			}
			case PROJ_ICEBALL_ATTACK:
			{
				CreateTimer(0.01, Timer_IceRagdoll, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	if (MAX_BOSSES > npcIndex >= 0)
	{
		float value = NPCGetAttributeValue(npcIndex, SF2Attribute_IgnitePlayerOnDeath);
		if (MAX_BOSSES > npcIndex >= 0 && value > 0.0)
		{
			TF2_IgnitePlayer(client, client);
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

public Action Event_PlayerHurt(Handle event, const char[] name, bool dB)
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

			char buffer[PLATFORM_MAX_PATH];
			SF2BossProfileSoundInfo soundInfo;
			GetBossProfileProxyHurtSounds(profile, soundInfo);
			if (soundInfo.Paths != null && soundInfo.Paths.Length > 0)
			{
				soundInfo.Paths.GetString(GetRandomInt(0, soundInfo.Paths.Length - 1), buffer, sizeof(buffer));
				if (buffer[0] != '\0')
				{
					EmitSoundToAll(buffer, client, soundInfo.Channel, soundInfo.Level, soundInfo.Flags, soundInfo.Volume, soundInfo.Pitch);
				}
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

public Action Event_PlayerDeath(Event event, const char[] name, bool dB)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	int client = GetClientOfUserId(event.GetInt("userid"));
	if (client <= 0)
	{
		return Plugin_Continue;
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("EVENT START: Event_PlayerDeath(%d)", client);
	}
	#endif

	bool fake = view_as<bool>(event.GetInt("death_flags") & TF_DEATHFLAG_DEADRINGER);
	int inflictor = event.GetInt("inflictor_entindex");

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("inflictor = %d", inflictor);
	}
	#endif

	if (!fake)
	{
		ClientResetStatic(client);
		ClientResetSlenderStats(client);
		ClientResetCampingStats(client);
		ClientResetOverlay(client);
		ClientResetJumpScare(client);
		ClientResetInteractiveGlow(client);
		ClientChaseMusicReset(client);
		ClientChaseMusicSeeReset(client);
		ClientAlertMusicReset(client);
		ClientIdleMusicReset(client);
		Client90sMusicReset(client);
		ClientMusicReset(client);

		ClientResetFlashlight(client);
		ClientDeactivateUltravision(client);
		ClientResetSprint(client);
		ClientResetBreathing(client);
		ClientResetBlink(client);
		ClientResetDeathCam(client);

		ClientUpdateMusicSystem(client);

		ClientDisableConstantGlow(client);

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
			switch (NPCGetType(npcIndex))
			{
				case SF2BossType_Chaser:
				{
					if (g_SlenderState[npcIndex] == STATE_CHASE && EntRefToEntIndex(g_SlenderTarget[npcIndex]) == client)
					{
						g_SlenderGiveUp[npcIndex] = true;
					}
				}
			}
		}

		PvP_SetPlayerPvPState(client, false, false, false);

		if (IsRoundInWarmup())
		{
			CreateTimer(0.3, Timer_RespawnPlayer, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
		}
		else
		{
			if (!g_PlayerEliminated[client])
			{
				if (IsFakeClient(client))
				{
					TF2_SetPlayerClass(client, TFClass_Sniper);
				}
				if (SF_SpecialRound(SPECIALROUND_MULTIEFFECT) || g_RenevantMultiEffect)
				{
					CreateTimer(0.1, Timer_ReplacePlayerRagdoll, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
				}
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
				if (g_PlayerPreferences[client].PlayerPreference_GhostModeToggleState == 2)
				{
					CreateTimer(0.25, Timer_ToggleGhostModeCommand, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
				}
				if (SF_SpecialRound(SPECIALROUND_THANATOPHOBIA) && IsRoundPlaying() && !DidClientEscape(client))
				{
					for (int reds = 1; reds <= MaxClients; reds++)
					{
						if (!IsValidClient(reds) ||
							g_PlayerEliminated[reds] ||
							DidClientEscape(reds) ||
							GetClientTeam(reds) != TFTeam_Red ||
							!IsPlayerAlive(reds))
						{
							continue;
						}
						int randomNegative = GetRandomInt(1, 5);
						switch (randomNegative)
						{
							case 1:
							{
								TF2_MakeBleed(reds, reds, 4.0);
								EmitSoundToClient(reds, BLEED_ROLL, reds, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							}
							case 2:
							{
								TF2_AddCondition(reds, TFCond_Jarated, 5.0);
								EmitSoundToClient(reds, JARATE_ROLL, reds, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							}
							case 3:
							{
								TF2_AddCondition(reds, TFCond_Gas, 5.0);
								EmitSoundToClient(reds, GAS_ROLL, reds, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							}
							case 4:
							{
								int maxHealth = SDKCall(g_SDKGetMaxHealth, reds);
								float damageToTake = float(maxHealth) / 10.0;
								SDKHooks_TakeDamage(reds, reds, reds, damageToTake, 128, _, view_as<float>( { 0.0, 0.0, 0.0 } ));
							}
							case 5:
							{
								TF2_AddCondition(reds, TFCond_MarkedForDeath, 5.0);
							}
						}
					}
				}
			}
			else
			{
			}

			// If this player was killed by a boss, play a sound, or print a message.
			int npcIndex = NPCGetFromEntIndex(inflictor);
			if (npcIndex != -1)
			{
				int slender = NPCGetEntIndex(npcIndex);
				if (slender && slender != INVALID_ENT_REFERENCE)
				{
					g_PlayerBossKillSubject[client] = EntIndexToEntRef(slender);
				}

				char npcProfile[SF2_MAX_PROFILE_NAME_LENGTH], buffer[PLATFORM_MAX_PATH], bossName[SF2_MAX_NAME_LENGTH];
				NPCGetProfile(npcIndex, npcProfile, sizeof(npcProfile));
				NPCGetBossName(npcIndex, bossName, sizeof(bossName));

				#if defined _store_included
				int difficulty = GetLocalGlobalDifficulty(npcIndex);
				if (NPCGetDrainCreditState(npcIndex))
				{
					Store_SetClientCredits(client, Store_GetClientCredits(client) - NPCGetDrainCreditAmount(npcIndex, difficulty));
					CPrintToChat(client, "{valve}%s{default} has stolen {green}%i credits{default} from you.", bossName, NPCGetDrainCreditAmount(npcIndex, difficulty));
				}
				#endif

				ArrayList soundList;
				SF2BossProfileSoundInfo soundInfo;
				GetChaserProfileAttackKilledClientSounds(npcProfile, soundInfo);
				soundList = soundInfo.Paths;
				if (soundList != null && soundList.Length > 0)
				{
					soundList.GetString(GetRandomInt(0, soundList.Length - 1), buffer, sizeof(buffer));
					if (buffer[0] != '\0' && g_PlayerEliminated[client])
					{
						EmitSoundToClient(client, buffer, _, SNDCHAN_STATIC, SNDLEVEL_HELICOPTER);
					}
				}

				GetChaserProfileAttackKilledAllSounds(npcProfile, soundInfo);
				soundList = soundInfo.Paths;
				if (soundList != null && soundList.Length > 0)
				{
					soundList.GetString(GetRandomInt(0, soundList.Length - 1), buffer, sizeof(buffer));
					if (buffer[0] != '\0' && g_PlayerEliminated[client])
					{
						EmitSoundToAll(buffer, _, SNDCHAN_STATIC, SNDLEVEL_HELICOPTER);
					}
				}
				soundList = null;

				SlenderPrintChatMessage(npcIndex, client);

				SlenderPerformVoice(npcIndex, _, SF2BossSound_AttackKilled);
			}

			if (IsEntityAProjectile(inflictor))
			{
				int npcIndex2 = NPCGetFromEntIndex(GetEntPropEnt(inflictor, Prop_Send, "m_hOwnerEntity"));
				if (npcIndex2 != -1)
				{
					int slender = NPCGetEntIndex(npcIndex2);
					if (slender && slender != INVALID_ENT_REFERENCE)
					{
						g_PlayerBossKillSubject[client] = EntIndexToEntRef(slender);
					}

					char npcProfile[SF2_MAX_PROFILE_NAME_LENGTH], buffer[PLATFORM_MAX_PATH], bossName[SF2_MAX_NAME_LENGTH];
					NPCGetProfile(npcIndex2, npcProfile, sizeof(npcProfile));
					NPCGetBossName(npcIndex2, bossName, sizeof(bossName));

					#if defined _store_included
					int difficulty = GetLocalGlobalDifficulty(npcIndex2);
					if (NPCGetDrainCreditState(npcIndex2))
					{
						Store_SetClientCredits(client, Store_GetClientCredits(client) - NPCGetDrainCreditAmount(npcIndex2, difficulty));
						CPrintToChat(client, "{valve}%s{default} has stolen {green}%i credits{default} from you.", bossName, NPCGetDrainCreditAmount(npcIndex2, difficulty));
					}
					#endif

					ArrayList soundList;
					SF2BossProfileSoundInfo soundInfo;
					GetChaserProfileAttackKilledClientSounds(npcProfile, soundInfo);
					soundList = soundInfo.Paths;
					if (soundList != null && soundList.Length > 0)
					{
						soundList.GetString(GetRandomInt(0, soundList.Length - 1), buffer, sizeof(buffer));
						if (buffer[0] != '\0' && g_PlayerEliminated[client])
						{
							EmitSoundToClient(client, buffer, _, SNDCHAN_STATIC, SNDLEVEL_HELICOPTER);
						}
					}

					GetChaserProfileAttackKilledAllSounds(npcProfile, soundInfo);
					soundList = soundInfo.Paths;
					if (soundList != null && soundList.Length > 0)
					{
						soundList.GetString(GetRandomInt(0, soundList.Length - 1), buffer, sizeof(buffer));
						if (buffer[0] != '\0' && g_PlayerEliminated[client])
						{
							EmitSoundToAll(buffer, _, SNDCHAN_STATIC, SNDLEVEL_HELICOPTER);
						}
					}
					soundList = null;

					SlenderPrintChatMessage(npcIndex2, client);

					SlenderPerformVoice(npcIndex2, _, SF2BossSound_AttackKilled);
				}
			}

			CreateTimer(0.2, Timer_CheckRoundWinConditions, _, TIMER_FLAG_NO_MAPCHANGE);

			// Notify to other bosses that this player has died.
			for (int i = 0; i < MAX_BOSSES; i++)
			{
				if (NPCGetUniqueID(i) == -1)
				{
					continue;
				}

				if (EntRefToEntIndex(g_SlenderTarget[i]) == client)
				{
					g_SlenderInterruptConditions[i] |= COND_CHASETARGETINVALIDATED;
					GetClientAbsOrigin(client, g_SlenderChaseDeathPosition[i]);
					g_BossPathFollower[i].Invalidate();
				}
			}

			if (g_IgnoreRedPlayerDeathSwapConVar.BoolValue && GetClientTeam(client) == TFTeam_Red)
			{
				g_PlayerEliminated[client] = false;
				g_PlayerEscaped[client] = false;
			}
		}

		if (g_PlayerProxy[client])
		{
			// We're a proxy, so play some sounds.

			int proxyMaster = NPCGetFromUniqueID(g_PlayerProxyMaster[client]);
			if (proxyMaster != -1)
			{
				char profile[SF2_MAX_PROFILE_NAME_LENGTH];
				NPCGetProfile(proxyMaster, profile, sizeof(profile));

				char buffer[PLATFORM_MAX_PATH];
				SF2BossProfileSoundInfo soundInfo;
				GetBossProfileProxyDeathSounds(profile, soundInfo);
				if (soundInfo.Paths != null && soundInfo.Paths.Length > 0)
				{
					soundInfo.Paths.GetString(GetRandomInt(0, soundInfo.Paths.Length - 1), buffer, sizeof(buffer));
					if (buffer[0] != '\0')
					{
						EmitSoundToAll(buffer, client, soundInfo.Channel, soundInfo.Level, soundInfo.Flags, soundInfo.Volume, soundInfo.Pitch);
					}
				}
			}
		}

		ClientResetProxy(client, true);
		ClientUpdateListeningFlags(client);

		// Half-Zatoichi nerf code.
		int katanaHealthGain = 5;
		if (katanaHealthGain >= 0)
		{
			int attacker = GetClientOfUserId(event.GetInt("attacker"));
			if (attacker > 0)
			{
				if (!IsClientInPvP(attacker) && (!g_PlayerEliminated[attacker] || g_PlayerProxy[attacker]))
				{
					char weaponClass[64];
					event.GetString("weapon", weaponClass, sizeof(weaponClass));

					if (strcmp(weaponClass, "demokatana") == 0)
					{
						int attackerPreHealth = GetEntProp(attacker, Prop_Send, "m_iHealth");
						Handle pack = CreateDataPack();
						WritePackCell(pack, GetClientUserId(attacker));
						WritePackCell(pack, attackerPreHealth + katanaHealthGain);

						CreateTimer(0.0, Timer_SetPlayerHealth, pack, TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
		}

		g_PlayerPostWeaponsTimer[client] = null;
		g_PlayerIgniteTimer[client] = null;
		g_PlayerPageRewardCycleTimer[client] = null;
		g_PlayerFireworkTimer[client] = null;

		g_PlayerGettingPageReward[client] = false;
		g_PlayerHitsToCrits[client] = 0;
		g_PlayerHitsToHeads[client] = 0;

		g_PlayerTrapped[client] = false;
		g_PlayerTrapCount[client] = 0;

		g_PlayerRandomClassNumber[client] = 1;
	}
	if (!IsRoundEnding() && !g_RoundWaitingForPlayers)
	{
		int attacker = GetClientOfUserId(event.GetInt("attacker"));
		if (IsRoundPlaying() && client != attacker)
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

			event2.SetInt("ignore", event.GetInt("ignore"));
			CreateTimer(0.2, Timer_SendDeath, event2, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	if (SF_IsBoxingMap() && IsRoundInEscapeObjective())
	{
		CreateTimer(0.2, Timer_CheckAlivePlayers, _, TIMER_FLAG_NO_MAPCHANGE);
	}
	PvP_OnPlayerDeath(client, fake);

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("EVENT END: Event_PlayerDeath(%d)", client);
	}
	#endif
	delete event;

	return Plugin_Continue;
}
