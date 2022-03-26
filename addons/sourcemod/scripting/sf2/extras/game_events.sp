#if defined _sf2_game_events_included
 #endinput
#endif
#define _sf2_game_events_included

public Action Event_RoundStart(Handle event, const char[] name, bool dB)
{
	if (!g_bEnabled) return;
	
	#if defined DEBUG
	Handle hProf = CreateProfiler();
	StartProfiling(hProf);
	SendDebugMessageToPlayers(DEBUG_EVENT, 0, "(Event_RoundStart) Started profiling...");
	
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT START: Event_RoundStart");
	#endif
	
	// Reset some global variables.
	g_iRoundCount++;
	g_hRoundTimer = null;
	g_bRoundTimerPaused = false;
	
	SetRoundState(SF2RoundState_Invalid);
	
	SetPageCount(0);
	g_iPageMax = 0;
	g_flPageFoundLastTime = GetGameTime();
	
	g_hVoteTimer = null;
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
		
		g_bPlayerPlaying[i] = false;
		g_bPlayerEliminated[i] = true;
		g_bPlayerEscaped[i] = false;
	}
	SF_RemoveAllSpecialRound();
	// Calculate the new round state.
	if (g_bRoundWaitingForPlayers)
	{
		int ent = -1;
		while ((ent = FindEntityByClassname(ent, "func_regenerate")) != -1)
		{
			AcceptEntityInput(ent, "Disable");
		}
		SetRoundState(SF2RoundState_Waiting);
	}
	else if (g_cvWarmupRound.BoolValue && g_iRoundWarmupRoundCount < g_cvWarmupRoundNum.IntValue)
	{
		int ent = -1;
		while ((ent = FindEntityByClassname(ent, "func_regenerate")) != -1)
		{
			AcceptEntityInput(ent, "Disable");
		}
		
		g_iRoundWarmupRoundCount++;
		
		SetRoundState(SF2RoundState_Waiting);
		
		ServerCommand("mp_restartgame 15");
		PrintCenterTextAll("Round restarting in 15 seconds");
	}
	else
	{
		g_iRoundActiveCount++;
		
		InitializeNewGame();
	}
	
	PvP_OnRoundStart();
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT END: Event_RoundStart");
	
	StopProfiling(hProf);
	SendDebugMessageToPlayers(DEBUG_EVENT, 0, "(Event_RoundStart) Stopped profiling, total execution time: %f", GetProfilerTime(hProf));
	delete hProf;
	
	#endif
	//Nextbot doesn't trigger the triggers with npc flags, for map backward compatibility we are going to change the trigger filter and force a custom one.
	/*int iEnt = -1;
	while ((iEnt = FindEntityByClassname(iEnt, "trigger_*")) != -1)
	{
		if(IsValidEntity(iEnt))
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
}

public Action Event_WinPanel(Event event, const char[] name, bool dontBroadcast)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	char cappers[7];
	int i = 0;
	for (int iClient; iClient <= MaxClients; iClient++)
	{
		if (IsValidClient(iClient) && DidClientEscape(iClient) && i < 7)
		{
			cappers[i] = iClient;
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
		for (int iBossIndex = 0; iBossIndex < MAX_BOSSES; iBossIndex++)
		{
			if (NPCGetUniqueID(iBossIndex) == -1) continue;
			if (!g_bSlenderCustomOutroSong[iBossIndex]) continue;
			
			return Plugin_Handled;
		}
	}
	return Plugin_Continue;
}

public Action Event_RoundEnd(Handle event, const char[] name, bool dB)
{
	if (!g_bEnabled) return;
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT START: Event_RoundEnd");
	#endif
	
	SF_FailEnd();

	if (SF_IsRenevantMap() && g_hRenevantWaveTimer != null) KillTimer(g_hRenevantWaveTimer);
	
	for (int i = 1; i < MaxClients; i++)
	{
		if (!IsValidClient(i)) continue;
		g_bPlayerDied1Up[i] = false;
		g_bPlayerIn1UpCondition[i] = false;
		g_bPlayerFullyDied1Up[i] = true;
	}
	
	ArrayList aRandomBosses = new ArrayList();
	char sMusic[MAX_BOSSES][PLATFORM_MAX_PATH];
	
	for (int iNPCIndex = 0; iNPCIndex < MAX_BOSSES; iNPCIndex++)
	{
		if (NPCGetUniqueID(iNPCIndex) == -1) continue;
		
		if (g_bSlenderCustomOutroSong[iNPCIndex])
		{
			char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(iNPCIndex, sProfile, sizeof(sProfile));
			GetRandomStringFromProfile(sProfile, "sound_music_outro", sMusic[iNPCIndex], sizeof(sMusic[]));
			if (sMusic[iNPCIndex][0] != '\0') aRandomBosses.Push(iNPCIndex);
		}
	}
	if (aRandomBosses.Length > 0)
	{
		int iNewBossIndex = aRandomBosses.Get(GetRandomInt(0, aRandomBosses.Length - 1));
		if (NPCGetUniqueID(iNewBossIndex) != -1)
			EmitSoundToAll(sMusic[iNewBossIndex], _, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
	}
	
	delete aRandomBosses;
	
	SpecialRound_RoundEnd();
	
	SetRoundState(SF2RoundState_Outro);
	
	DistributeQueuePointsToPlayers();
	
	g_iRoundEndCount++;
	CheckRoundLimitForBossPackVote(g_iRoundEndCount);
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT END: Event_RoundEnd");
	#endif
	delete event;
}

public Action Event_PlayerTeamPre(Handle event, const char[] name, bool dB)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 1) DebugMessage("EVENT START: Event_PlayerTeamPre");
	#endif
	
	int iClient = GetClientOfUserId(GetEventInt(event, "userid"));
	if (iClient > 0)
	{
		if (GetEventInt(event, "team") > 1 || GetEventInt(event, "oldteam") > 1) SetEventBroadcast(event, true);
	}
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 1) DebugMessage("EVENT END: Event_PlayerTeamPre");
	#endif
	
	delete event;
	
	return Plugin_Continue;
}

public Action Event_PlayerTeam(Handle event, const char[] name, bool dB)
{
	if (!g_bEnabled) return;
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT START: Event_PlayerTeam");
	#endif
	
	int iClient = GetClientOfUserId(GetEventInt(event, "userid"));
	if (iClient > 0)
	{
		int iintTeam = GetEventInt(event, "team");
		if (iintTeam <= TFTeam_Spectator)
		{
			if (!IsRoundPlaying())
			{
				if (g_bPlayerPlaying[iClient] && !g_bPlayerEliminated[iClient])
				{
					ForceInNextPlayersInQueue(1, true);
				}
			}
			
			// You're not playing anymore.
			if (g_bPlayerPlaying[iClient])
			{
				ClientSetQueuePoints(iClient, 0);
			}
			
			g_bPlayerPlaying[iClient] = false;
			g_bPlayerEliminated[iClient] = true;
			g_bPlayerEscaped[iClient] = false;
			
			ClientSetGhostModeState(iClient, false);
			
			if (!view_as<bool>(GetEntProp(iClient, Prop_Send, "m_bIsCoaching")))
			{
				// This is to prevent player spawn spam when someone is coaching. Who coaches in SF2, anyway?
				TF2_RespawnPlayer(iClient);
			}
			
			// Special round.
			if (g_bSpecialRound) g_bPlayerPlayedSpecialRound[iClient] = true;
			
			// Boss round.
			if (g_bNewBossRound) g_bPlayerPlayedNewBossRound[iClient] = true;
			
			if (!g_cvFullyEnableSpectator.BoolValue) g_hPlayerSwitchBlueTimer[iClient] = CreateTimer(0.5, Timer_PlayerSwitchToBlue, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
		}
		else
		{
			if (!g_bPlayerChoseTeam[iClient])
			{
				g_bPlayerChoseTeam[iClient] = true;
				
				if (g_iPlayerPreferences[iClient].PlayerPreference_ProjectedFlashlight)
				{
					EmitSoundToClient(iClient, SF2_PROJECTED_FLASHLIGHT_CONFIRM_SOUND);
					CPrintToChat(iClient, "%T", "SF2 Projected Flashlight", iClient);
				}
				else
				{
					CPrintToChat(iClient, "%T", "SF2 Normal Flashlight", iClient);
				}
				
				CreateTimer(5.0, Timer_WelcomeMessage, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
			}
			if (SF_SpecialRound(SPECIALROUND_THANATOPHOBIA) && !g_bPlayerEliminated[iClient] && iintTeam == TFTeam_Red && 
				TF2_GetPlayerClass(iClient) == TFClass_Medic && !DidClientEscape(iClient))
			{
				ShowVGUIPanel(iClient, "class_red");
				EmitSoundToClient(iClient, THANATOPHOBIA_MEDICNO);
				TFClassType newClass;
				int iRandom = GetRandomInt(1, 8);
				switch (iRandom)
				{
					case 1: newClass = TFClass_Scout;
					case 2: newClass = TFClass_Soldier;
					case 3: newClass = TFClass_Pyro;
					case 4: newClass = TFClass_DemoMan;
					case 5: newClass = TFClass_Heavy;
					case 6: newClass = TFClass_Engineer;
					case 7: newClass = TFClass_Sniper;
					case 8: newClass = TFClass_Spy;
				}
				TF2_SetPlayerClass(iClient, newClass);
				TF2_RegeneratePlayer(iClient);
			}
		}
	}
	
	// Check groups.
	if (!IsRoundEnding())
	{
		for (int i = 0; i < SF2_MAX_PLAYER_GROUPS; i++)
		{
			if (!IsPlayerGroupActive(i)) continue;
			CheckPlayerGroup(i);
		}
	}
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT END: Event_PlayerTeam");
	#endif
	delete event;
}

public Action Event_PlayerSpawn(Handle event, const char[] name, bool dB)
{
	if (!g_bEnabled) return;
	
	int iClient = GetClientOfUserId(GetEventInt(event, "userid"));
	if (iClient <= 0) return;
	#if defined DEBUG
	
	Handle hProf = CreateProfiler();
	StartProfiling(hProf);
	SendDebugMessageToPlayers(DEBUG_EVENT, 0, "(Event_PlayerSpawn) Started profiling...");

	//PrintToChatAll("(SPAWN) Spawn event called.");
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT START: Event_PlayerSpawn(%d)", iClient);
	#endif
	
	if (GetClientTeam(iClient) > 1)
	{
		g_flLastVisibilityProcess[iClient] = GetGameTime();
		ClientResetStatic(iClient);
		if (!g_bSeeUpdateMenu[iClient])
		{
			g_bSeeUpdateMenu[iClient] = true;
			DisplayMenu(g_hMenuUpdate, iClient, 30);
		}
	}
	if (!IsClientParticipating(iClient))
	{
		TF2Attrib_SetByName(iClient, "increased jump height", 1.0);
		TF2Attrib_RemoveByDefIndex(iClient, 10);
		
		ClientSetGhostModeState(iClient, false);
		SetEntityGravity(iClient, 1.0);
		g_iPlayerPageCount[iClient] = 0;
		
		ClientResetStatic(iClient);
		ClientResetSlenderStats(iClient);
		ClientResetCampingStats(iClient);
		ClientResetOverlay(iClient);
		ClientResetJumpScare(iClient);
		ClientUpdateListeningFlags(iClient);
		ClientUpdateMusicSystem(iClient);
		ClientChaseMusicReset(iClient);
		ClientChaseMusicSeeReset(iClient);
		ClientAlertMusicReset(iClient);
		ClientIdleMusicReset(iClient);
		Client20DollarsMusicReset(iClient);
		Client90sMusicReset(iClient);
		ClientMusicReset(iClient);
		ClientResetProxy(iClient);
		ClientResetHints(iClient);
		ClientResetScare(iClient);
		
		ClientResetDeathCam(iClient);
		ClientResetFlashlight(iClient);
		ClientDeactivateUltravision(iClient);
		ClientResetSprint(iClient);
		ClientResetBreathing(iClient);
		ClientResetBlink(iClient);
		ClientResetInteractiveGlow(iClient);
		ClientDisableConstantGlow(iClient);
		
		ClientHandleGhostMode(iClient);
	}
	
	if (SF_IsBoxingMap() && IsRoundInEscapeObjective())
	{
		CreateTimer(0.2, Timer_CheckAlivePlayers, _, TIMER_FLAG_NO_MAPCHANGE);
	}
	
	g_hPlayerPostWeaponsTimer[iClient] = null;
	g_hPlayerIgniteTimer[iClient] = null;
	g_hPlayerResetIgnite[iClient] = null;
	g_hPlayerPageRewardTimer[iClient] = null;
	g_hPlayerPageRewardCycleTimer[iClient] = null;
	g_hPlayerFireworkTimer[iClient] = null;

	g_iPlayerBossKillSubject[iClient] = INVALID_ENT_REFERENCE;
	
	g_bPlayerGettingPageReward[iClient] = false;
	g_iPlayerHitsToCrits[iClient] = 0;
	g_iPlayerHitsToHeads[iClient] = 0;
	
	g_bPlayerTrapped[iClient] = false;
	g_iPlayerTrapCount[iClient] = 0;
	
	g_iPlayerRandomClassNumber[iClient] = 1;
	
	if (IsPlayerAlive(iClient) && IsClientParticipating(iClient))
	{
		if (MusicActive() || SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES)) //A boss is overriding the music.
		{
			char sPath[PLATFORM_MAX_PATH];
			GetBossMusic(sPath, sizeof(sPath));
			if (sPath[0] != '\0') StopSound(iClient, MUSIC_CHAN, sPath);
			if (SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))
			{
				StopSound(iClient, MUSIC_CHAN, TRIPLEBOSSESMUSIC);
			}
		}
		g_bBackStabbed[iClient] = false;
		TF2_RemoveCondition(iClient, TFCond_HalloweenKart);
		TF2_RemoveCondition(iClient, TFCond_HalloweenKartDash);
		TF2_RemoveCondition(iClient, TFCond_HalloweenKartNoTurn);
		TF2_RemoveCondition(iClient, TFCond_HalloweenKartCage);
		TF2_RemoveCondition(iClient, TFCond_SpawnOutline);
		
		if (HandlePlayerTeam(iClient))
		{
			#if defined DEBUG
			if (g_cvDebugDetail.IntValue > 0) DebugMessage("iClient->HandlePlayerTeam()");
			#endif
		}
		else
		{
			g_iPlayerPageCount[iClient] = 0;
			
			ClientResetStatic(iClient);
			ClientResetSlenderStats(iClient);
			ClientResetCampingStats(iClient);
			ClientResetOverlay(iClient);
			ClientResetJumpScare(iClient);
			ClientUpdateListeningFlags(iClient);
			ClientUpdateMusicSystem(iClient);
			ClientChaseMusicReset(iClient);
			ClientChaseMusicSeeReset(iClient);
			ClientAlertMusicReset(iClient);
			ClientIdleMusicReset(iClient);
			Client20DollarsMusicReset(iClient);
			Client90sMusicReset(iClient);
			ClientMusicReset(iClient);
			ClientResetProxy(iClient);
			ClientResetHints(iClient);
			ClientResetScare(iClient);
			
			ClientResetDeathCam(iClient);
			ClientResetFlashlight(iClient);
			ClientDeactivateUltravision(iClient);
			ClientResetSprint(iClient);
			ClientResetBreathing(iClient);
			ClientResetBlink(iClient);
			ClientResetInteractiveGlow(iClient);
			ClientDisableConstantGlow(iClient);
			
			ClientHandleGhostMode(iClient);
			
			TF2Attrib_SetByName(iClient, "increased jump height", 1.0);
			
			if (!g_bPlayerEliminated[iClient])
			{
				if ((SF_IsRaidMap() || SF_IsBoxingMap()) && !IsRoundPlaying())
					TF2Attrib_SetByDefIndex(iClient, 10, 7.0);
				else
					TF2Attrib_RemoveByDefIndex(iClient, 10);
				
				TF2Attrib_SetByDefIndex(iClient, 49, 1.0);
				
				ClientStartDrainingBlinkMeter(iClient);
				ClientSetScareBoostEndTime(iClient, -1.0);
				
				ClientStartCampingTimer(iClient);
				
				HandlePlayerIntroState(iClient);
				
				if (IsFakeClient(iClient))
				{
					CreateTimer(0.1, Timer_SwitchBot, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
				}
				
				// screen overlay timer
				if (!SF_IsRaidMap() && !SF_IsBoxingMap())
				{
					g_hPlayerOverlayCheck[iClient] = CreateTimer(0.0, Timer_PlayerOverlayCheck, GetClientUserId(iClient), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
					TriggerTimer(g_hPlayerOverlayCheck[iClient], true);
				}
				if (DidClientEscape(iClient))
				{
					CreateTimer(0.1, Timer_TeleportPlayerToEscapePoint, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
				}
				else
				{
					int iRed[4] = { 184, 56, 59, 255 };
					ClientEnableConstantGlow(iClient, "head", iRed);
					ClientActivateUltravision(iClient);
				}

				if (SF_IsRenevantMap() && g_bRenevantMarkForDeath && !DidClientEscape(iClient))
				{
					TF2_AddCondition(iClient, TFCond_MarkedForDeathSilent, -1.0);
				}
				
				if (SF_SpecialRound(SPECIALROUND_1UP) && !g_bPlayerIn1UpCondition[iClient] && !g_bPlayerDied1Up[iClient])
				{
					g_bPlayerDied1Up[iClient] = false;
					g_bPlayerIn1UpCondition[iClient] = true;
					g_bPlayerFullyDied1Up[iClient] = false;
				}
				
				if (SF_SpecialRound(SPECIALROUND_PAGEDETECTOR))
					ClientSetSpecialRoundTimer(iClient, 0.0, Timer_ClientPageDetector, GetClientUserId(iClient));

				if (SF_SpecialRound(SPECIALROUND_THANATOPHOBIA) && TF2_GetPlayerClass(iClient) == TFClass_Medic && !DidClientEscape(iClient))
				{
					ShowVGUIPanel(iClient, "class_red");
					EmitSoundToClient(iClient, THANATOPHOBIA_MEDICNO);
					TFClassType newClass;
					int iRandom = GetRandomInt(1, 8);
					switch (iRandom)
					{
						case 1:newClass = TFClass_Scout;
						case 2:newClass = TFClass_Soldier;
						case 3:newClass = TFClass_Pyro;
						case 4:newClass = TFClass_DemoMan;
						case 5:newClass = TFClass_Heavy;
						case 6:newClass = TFClass_Engineer;
						case 7:newClass = TFClass_Sniper;
						case 8:newClass = TFClass_Spy;
					}
					TF2_SetPlayerClass(iClient, newClass);
					TF2_RegeneratePlayer(iClient);
				}
			}
			else
			{
				g_hPlayerOverlayCheck[iClient] = null;
				TF2Attrib_RemoveByDefIndex(iClient, 10);
				TF2Attrib_RemoveByDefIndex(iClient, 49);
			}
			ClientSwitchToWeaponSlot(iClient, TFWeaponSlot_Melee);
			g_hPlayerPostWeaponsTimer[iClient] = CreateTimer(0.1, Timer_ClientPostWeapons, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
			
			HandlePlayerHUD(iClient);
		}
	}
	
	PvP_OnPlayerSpawn(iClient);
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0)DebugMessage("EVENT END: Event_PlayerSpawn(%d)", iClient);
	
	StopProfiling(hProf);
	SendDebugMessageToPlayers(DEBUG_EVENT, 0, "(Event_PlayerSpawn) Stopped profiling, function executed in %f", GetProfilerTime(hProf));
	delete hProf;
	#endif
	
	delete event;
}

public void Event_PlayerClass(Event event, const char[] name, bool dontBroadcast)
{
	int iClient = GetClientOfUserId(event.GetInt("userid"));
	if (iClient <= 0) return;
	
	int iTeam = GetClientTeam(iClient);
	
	if (SF_SpecialRound(SPECIALROUND_THANATOPHOBIA) && !g_bPlayerEliminated[iClient] && 
		iTeam == TFTeam_Red && TF2_GetPlayerClass(iClient) == TFClass_Medic && !DidClientEscape(iClient))
	{
		ShowVGUIPanel(iClient, "class_red");
		EmitSoundToClient(iClient, THANATOPHOBIA_MEDICNO);
		TFClassType newClass;
		int iRandom = GetRandomInt(1, 8);
		switch (iRandom)
		{
			case 1:newClass = TFClass_Scout;
			case 2:newClass = TFClass_Soldier;
			case 3:newClass = TFClass_Pyro;
			case 4:newClass = TFClass_DemoMan;
			case 5:newClass = TFClass_Heavy;
			case 6:newClass = TFClass_Engineer;
			case 7:newClass = TFClass_Sniper;
			case 8:newClass = TFClass_Spy;
		}
		TF2_SetPlayerClass(iClient, newClass);
		TF2_RegeneratePlayer(iClient);
	}
}

public Action Event_PostInventoryApplication(Handle event, const char[] name, bool dB)
{
	if (!g_bEnabled) return;
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT START: Event_PostInventoryApplication");
	#endif
	
	int iClient = GetClientOfUserId(GetEventInt(event, "userid"));
	if (iClient > 0)
	{
		ClientSwitchToWeaponSlot(iClient, TFWeaponSlot_Melee);
		g_hPlayerPostWeaponsTimer[iClient] = CreateTimer(0.1, Timer_ClientPostWeapons, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
	}
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT END: Event_PostInventoryApplication");
	#endif
	delete event;
}
public Action Event_DontBroadcastToClients(Handle event, const char[] name, bool dB)
{
	if (!g_bEnabled) return Plugin_Continue;
	if (IsRoundInWarmup()) return Plugin_Continue;
	
	SetEventBroadcast(event, true);
	delete event;
	return Plugin_Continue;
}

public Action Event_PlayerDeathPre(Event event, const char[] name, bool dB)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 1) DebugMessage("EVENT START: Event_PlayerDeathPre");
	#endif
	int iClient = GetClientOfUserId(event.GetInt("userid"));
	
	int inflictor = event.GetInt("inflictor_entindex");
	
	// If this player was killed by a boss, play a sound.
	int npcIndex = NPCGetFromEntIndex(inflictor);
	if (npcIndex != -1 && !IsEntityAProjectile(inflictor))
	{
		int iTarget = GetClientOfUserId(g_iSourceTVUserID);
		int iAttackIndex = NPCGetCurrentAttackIndex(npcIndex);
		if (MaxClients < iTarget || iTarget < 1 || !IsClientInGame(iTarget) || !IsClientSourceTV(iTarget)) //If the server has a source TV bot uses to print boss' name in kill feed.
			iTarget = GetClientForDeath(iClient);

		if (iTarget != -1)
		{
			if (g_hTimerChangeClientName[iTarget] != null)
				KillTimer(g_hTimerChangeClientName[iTarget]);
			else 
				GetEntPropString(iTarget, Prop_Data, "m_szNetname", g_sOldClientName[iTarget], sizeof(g_sOldClientName[]));
			
			char sBossName[SF2_MAX_NAME_LENGTH], sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(npcIndex, sProfile, sizeof(sProfile));
			NPCGetBossName(npcIndex, sBossName, sizeof(sBossName));
			
			//TF2_ChangePlayerName(iTarget, sBossName, true);
			SetClientName(iTarget, sBossName);
			SetEntPropString(iTarget, Prop_Data, "m_szNetname", sBossName);
			
			event.SetString("assister_fallback", "");
			if ((NPCGetFlags(npcIndex) & SFF_WEAPONKILLS) || (NPCGetFlags(npcIndex) & SFF_WEAPONKILLSONRADIUS))
			{
				if (NPCGetFlags(npcIndex) & SFF_WEAPONKILLS)
				{
					char sWeaponType[PLATFORM_MAX_PATH];
					int iWeaponNum = NPCChaserGetAttackWeaponTypeInt(npcIndex, iAttackIndex);
					GetProfileAttackString(sProfile, "attack_weapontype", sWeaponType, sizeof(sWeaponType), "", iAttackIndex + 1);
					event.SetString("weapon_logclassname", sWeaponType);
					event.SetString("weapon", sWeaponType);
					event.SetInt("customkill", iWeaponNum);
				}
				else if (NPCGetFlags(npcIndex) & SFF_WEAPONKILLSONRADIUS)
				{
					char sWeaponType[PLATFORM_MAX_PATH];
					int iWeaponNum = GetProfileNum(sProfile, "kill_weapontypeint", 0);
					GetProfileString(sProfile, "kill_weapontype", sWeaponType, sizeof(sWeaponType));
					event.SetString("weapon_logclassname", sWeaponType);
					event.SetString("weapon", sWeaponType);
					event.SetInt("customkill", iWeaponNum);
				}
			}
			else
			{
				event.SetString("weapon", "");
				event.SetString("weapon_logclassname", "");
			}
			
			int userid = GetClientUserId(iTarget);
			event.SetInt("attacker", userid);
			g_hTimerChangeClientName[iTarget] = CreateTimer(0.6, Timer_RevertClientName, iTarget, TIMER_FLAG_NO_MAPCHANGE);

			if(IsValidClient(iTarget))
			{
				event.SetInt("ignore", iTarget);

				//Show a different attacker to the user were taking
				iTarget = GetClientForDeath(iClient, iTarget);
				if (iTarget != -1)
				{
					if (g_hTimerChangeClientName[iTarget] != null)
						KillTimer(g_hTimerChangeClientName[iTarget]);
					else 
						GetEntPropString(iTarget, Prop_Data, "m_szNetname", g_sOldClientName[iTarget], sizeof(g_sOldClientName[]));

					Format(sBossName, sizeof(sBossName), " %s", sBossName);

					//TF2_ChangePlayerName(iTarget, sBossName, true);
					SetClientName(iTarget, sBossName);
					SetEntPropString(iTarget, Prop_Data, "m_szNetname", sBossName);

					g_hTimerChangeClientName[iTarget] = CreateTimer(0.6, Timer_RevertClientName, iTarget, TIMER_FLAG_NO_MAPCHANGE);

					char sString[64];
					Event event2 = CreateEvent("player_death", true);
					event2.SetInt("userid", event.GetInt("userid"));
					event2.SetInt("victim_entindex", event.GetInt("victim_entindex"));
					event2.SetInt("inflictor_entindex", event.GetInt("inflictor_entindex"));
					event2.SetInt("attacker", GetClientUserId(iTarget));
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
					event.GetString("weapon_logclassname", sString, sizeof(sString));
					event2.SetString("weapon_logclassname", sString);
					event.GetString("weapon", sString, sizeof(sString));
					event2.SetString("weapon", sString);
					event2.SetInt("send", userid);

					CreateTimer(0.2, Timer_SendDeathToSpecific, event2);
				}
			}
		}
	}

	#if defined DEBUG
	char sStringName[128];
	event.GetString("weapon", sStringName, sizeof(sStringName));
	SendDebugMessageToPlayers(DEBUG_KILLICONS, 0, "String kill icon is %s, integer kill icon is %i.", sStringName, event.GetInt("customkill"));
	#endif
	
	if (IsEntityAProjectile(inflictor))
	{
		int npcIndex2 = NPCGetFromEntIndex(GetEntPropEnt(inflictor, Prop_Send, "m_hOwnerEntity"));
		if (npcIndex2 != -1)
		{
			int iTarget = GetClientOfUserId(g_iSourceTVUserID);
			if (MaxClients < iTarget || iTarget < 1 || !IsClientInGame(iTarget) || !IsClientSourceTV(iTarget)) //If the server has a source TV bot uses to print boss' name in kill feed.
				iTarget = GetClientForDeath(iClient);

			if (iTarget != -1)
			{
				if (g_hTimerChangeClientName[iTarget] != null)
					KillTimer(g_hTimerChangeClientName[iTarget]);
				else //No timer running that means the SourceTV bot's current name is the correct one, we can safely update our last known SourceTV bot's name.
				GetEntPropString(iTarget, Prop_Data, "m_szNetname", g_sOldClientName[iTarget], sizeof(g_sOldClientName[]));
				
				char sBossName[SF2_MAX_NAME_LENGTH], sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
				NPCGetProfile(npcIndex2, sProfile, sizeof(sProfile));
				NPCGetBossName(npcIndex2, sBossName, sizeof(sBossName));
				
				//TF2_ChangePlayerName(iTarget, sBossName, true);
				SetClientName(iTarget, sBossName);
				SetEntPropString(iTarget, Prop_Data, "m_szNetname", sBossName);
				
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
				
				int userid = GetClientUserId(iTarget);
				event.SetInt("attacker", userid);
				g_hTimerChangeClientName[iTarget] = CreateTimer(0.6, Timer_RevertClientName, iTarget, TIMER_FLAG_NO_MAPCHANGE);

				if(IsValidClient(iTarget))
				{
					event.SetInt("ignore", iTarget);

					//Show a different attacker to the user were taking
					iTarget = GetClientForDeath(iClient, iTarget);
					if (iTarget != -1)
					{
						if (g_hTimerChangeClientName[iTarget] != null)
							KillTimer(g_hTimerChangeClientName[iTarget]);
						else 
							GetEntPropString(iTarget, Prop_Data, "m_szNetname", g_sOldClientName[iTarget], sizeof(g_sOldClientName[]));

						Format(sBossName, sizeof(sBossName), " %s", sBossName);

						//TF2_ChangePlayerName(iTarget, sBossName, true);
						SetClientName(iTarget, sBossName);
						SetEntPropString(iTarget, Prop_Data, "m_szNetname", sBossName);

						g_hTimerChangeClientName[iTarget] = CreateTimer(0.6, Timer_RevertClientName, iTarget, TIMER_FLAG_NO_MAPCHANGE);

						char sString[64];
						Event event2 = CreateEvent("player_death", true);
						event2.SetInt("userid", event.GetInt("userid"));
						event2.SetInt("victim_entindex", event.GetInt("victim_entindex"));
						event2.SetInt("inflictor_entindex", event.GetInt("inflictor_entindex"));
						event2.SetInt("attacker", GetClientUserId(iTarget));
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
						event.GetString("weapon_logclassname", sString, sizeof(sString));
						event2.SetString("weapon_logclassname", sString);
						event.GetString("weapon", sString, sizeof(sString));
						event2.SetString("weapon", sString);
						event2.SetInt("send", userid);

						CreateTimer(0.2, Timer_SendDeathToSpecific, event2);
					}
				}
			}
		}
	}
	
	if (!IsRoundInWarmup())
	{
		if (iClient > 0)
		{
			if (g_bBackStabbed[iClient])
			{
				event.SetInt("customkill", TF_CUSTOM_BACKSTAB);
				g_bBackStabbed[iClient] = false;
			}
		}
	}
	if (MAX_BOSSES > npcIndex >= 0 && (g_bSlenderHasAshKillEffect[npcIndex] || g_bSlenderHasCloakKillEffect[npcIndex]
			 || g_bSlenderHasDecapKillEffect[npcIndex] || g_bSlenderHasDeleteKillEffect[npcIndex]
			 || g_bSlenderHasDissolveRagdollOnKill[npcIndex]
			 || g_bSlenderHasElectrocuteKillEffect[npcIndex] || g_bSlenderHasGoldKillEffect[npcIndex]
			 || g_bSlenderHasIceKillEffect[npcIndex] || g_bSlenderHasPlasmaRagdollOnKill[npcIndex]
			 || g_bSlenderHasPushRagdollOnKill[npcIndex] || g_bSlenderHasResizeRagdollOnKill[npcIndex]
			 || g_bSlenderHasBurnKillEffect[npcIndex] || g_bSlenderHasGibKillEffect[npcIndex]))
	{
		CreateTimer(0.01, Timer_ModifyRagdoll, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
	}
	if (MAX_BOSSES > npcIndex >= 0 && g_bSlenderPlayerCustomDeathFlag[npcIndex])
	{
		event.SetInt("death_flags", g_iSlenderPlayerSetDeathFlag[npcIndex]);
	}
	if (MAX_BOSSES > npcIndex >= 0 && g_bSlenderHasDecapOrGibKillEffect[npcIndex])
	{
		CreateTimer(0.01, Timer_DeGibRagdoll, GetClientUserId(iClient));
	}

	if (MAX_BOSSES > npcIndex >= 0 && g_bSlenderHasMultiKillEffect[npcIndex])
	{
		CreateTimer(0.01, Timer_MultiRagdoll, GetClientUserId(iClient));
	}
	if (IsEntityAProjectile(inflictor))
	{
		switch (ProjectileGetFlags(inflictor))
		{
			case PROJ_MANGLER: CreateTimer(0.01, Timer_ManglerRagdoll, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
			case PROJ_ICEBALL: CreateTimer(0.01, Timer_IceRagdoll, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
			case PROJ_ICEBALL_ATTACK: CreateTimer(0.01, Timer_IceRagdoll, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	if (MAX_BOSSES > npcIndex >= 0 && NPCHasAttribute(npcIndex, "ignite player on death"))
	{
		float flValue = NPCGetAttributeValue(npcIndex, "ignite player on death");
		if (flValue > 0.0) TF2_IgnitePlayer(iClient, iClient);
	}

	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 1) DebugMessage("EVENT END: Event_PlayerDeathPre");
	#endif
	event.BroadcastDisabled = true;
	return Plugin_Changed;
}

public Action Event_PlayerHurt(Handle event, const char[] name, bool dB)
{
	if (!g_bEnabled) return;
	
	int iClient = GetClientOfUserId(GetEventInt(event, "userid"));
	if (iClient <= 0) return;
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT START: Event_PlayerHurt");
	#endif
	
	int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	if (attacker > 0)
	{
		if (g_bPlayerProxy[attacker])
		{
			g_iPlayerProxyControl[attacker] = 100;
		}
	}
	
	// Play any sounds, if any.
	if (g_bPlayerProxy[iClient])
	{
		int iProxyMaster = NPCGetFromUniqueID(g_iPlayerProxyMaster[iClient]);
		if (iProxyMaster != -1)
		{
			char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(iProxyMaster, sProfile, sizeof(sProfile));
			
			char sBuffer[PLATFORM_MAX_PATH];
			if (GetRandomStringFromProfile(sProfile, "sound_proxy_hurt", sBuffer, sizeof(sBuffer)) && sBuffer[0] != '\0')
			{
				int iChannel = g_iSlenderProxyHurtChannel[iProxyMaster];
				int iLevel = g_iSlenderProxyHurtLevel[iProxyMaster];
				int iFlags = g_iSlenderProxyHurtFlags[iProxyMaster];
				float flVolume = g_flSlenderProxyHurtVolume[iProxyMaster];
				int iPitch = g_iSlenderProxyHurtPitch[iProxyMaster];
				
				EmitSoundToAll(sBuffer, iClient, iChannel, iLevel, iFlags, flVolume, iPitch);
			}
		}
	}
	delete event;
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT END: Event_PlayerHurt");
	#endif
}

public Action Event_PlayerDeath(Event event, const char[] name, bool dB)
{
	if (!g_bEnabled) return;

	int iClient = GetClientOfUserId(event.GetInt("userid"));
	if (iClient <= 0) return;
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT START: Event_PlayerDeath(%d)", iClient);
	#endif
	
	bool bFake = view_as<bool>(event.GetInt("death_flags") & TF_DEATHFLAG_DEADRINGER);
	int inflictor = event.GetInt("inflictor_entindex");
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("inflictor = %d", inflictor);
	#endif
	
	if (!bFake)
	{
		ClientResetStatic(iClient);
		ClientResetSlenderStats(iClient);
		ClientResetCampingStats(iClient);
		ClientResetOverlay(iClient);
		ClientResetJumpScare(iClient);
		ClientResetInteractiveGlow(iClient);
		ClientDisableConstantGlow(iClient);
		ClientChaseMusicReset(iClient);
		ClientChaseMusicSeeReset(iClient);
		ClientAlertMusicReset(iClient);
		ClientIdleMusicReset(iClient);
		Client20DollarsMusicReset(iClient);
		Client90sMusicReset(iClient);
		ClientMusicReset(iClient);
		
		ClientResetFlashlight(iClient);
		ClientDeactivateUltravision(iClient);
		ClientResetSprint(iClient);
		ClientResetBreathing(iClient);
		ClientResetBlink(iClient);
		ClientResetDeathCam(iClient);
		
		ClientUpdateMusicSystem(iClient);
		
		PvP_SetPlayerPvPState(iClient, false, false, false);
		
		if (IsRoundInWarmup())
		{
			CreateTimer(0.3, Timer_RespawnPlayer, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
		}
		else
		{
			if (!g_bPlayerEliminated[iClient])
			{
				if (IsFakeClient(iClient))
				{
					TF2_SetPlayerClass(iClient, TFClass_Sniper);
				}
				if (SF_SpecialRound(SPECIALROUND_MULTIEFFECT) || g_bRenevantMultiEffect)
					CreateTimer(0.1, Timer_ReplacePlayerRagdoll, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
				if (IsRoundInIntro() || !IsRoundPlaying() || DidClientEscape(iClient) || (SF_SpecialRound(SPECIALROUND_1UP) && g_bPlayerIn1UpCondition[iClient] && !g_bPlayerDied1Up[iClient]))
				{
					CreateTimer(0.3, Timer_RespawnPlayer, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
				}
				else
				{
					g_bPlayerEliminated[iClient] = true;
					g_bPlayerEscaped[iClient] = false;
					g_bPlayerFullyDied1Up[iClient] = true;
					g_hPlayerSwitchBlueTimer[iClient] = CreateTimer(0.5, Timer_PlayerSwitchToBlue, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
				}
				if (g_iPlayerPreferences[iClient].PlayerPreference_GhostModeToggleState == 2)
					CreateTimer(0.25, Timer_ToggleGhostModeCommand, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
				if (SF_SpecialRound(SPECIALROUND_THANATOPHOBIA) && IsRoundPlaying() && !DidClientEscape(iClient))
				{
					for (int iReds = 1; iReds <= MaxClients; iReds++)
					{
						if (!IsValidClient(iReds) || 
							g_bPlayerEliminated[iReds] || 
							DidClientEscape(iReds) || 
							GetClientTeam(iReds) != TFTeam_Red || 
							!IsPlayerAlive(iReds)) continue;
						int iRandomNegative = GetRandomInt(1, 5);
						switch (iRandomNegative)
						{
							case 1:
							{
								TF2_MakeBleed(iReds, iReds, 4.0);
								EmitSoundToClient(iReds, BLEED_ROLL, iReds, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							}
							case 2:
							{
								TF2_AddCondition(iReds, TFCond_Jarated, 5.0);
								EmitSoundToClient(iReds, JARATE_ROLL, iReds, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							}
							case 3:
							{
								TF2_AddCondition(iReds, TFCond_Gas, 5.0);
								EmitSoundToClient(iReds, GAS_ROLL, iReds, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							}
							case 4:
							{
								int iMaxHealth = SDKCall(g_hSDKGetMaxHealth, iReds);
								float flDamageToTake = float(iMaxHealth) / 10.0;
								SDKHooks_TakeDamage(iReds, iReds, iReds, flDamageToTake, 128, _, view_as<float>( { 0.0, 0.0, 0.0 } ));
							}
							case 5:
							{
								TF2_AddCondition(iReds, TFCond_MarkedForDeath, 5.0);
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
				int iSlender = NPCGetEntIndex(npcIndex);
				if (iSlender && iSlender != INVALID_ENT_REFERENCE) g_iPlayerBossKillSubject[iClient] = EntIndexToEntRef(iSlender);
				
				char npcProfile[SF2_MAX_PROFILE_NAME_LENGTH], buffer[PLATFORM_MAX_PATH], sBossName[SF2_MAX_NAME_LENGTH];
				NPCGetProfile(npcIndex, npcProfile, sizeof(npcProfile));
				NPCGetBossName(npcIndex, sBossName, sizeof(sBossName));

				#if defined _store_included
				int iDifficulty = GetLocalGlobalDifficulty(npcIndex);
				if (NPCGetDrainCreditState(npcIndex))
				{
					Store_SetClientCredits(iClient, Store_GetClientCredits(iClient) - NPCGetDrainCreditAmount(npcIndex, iDifficulty));
					CPrintToChat(iClient, "{valve}%s{default} has stolen {green}%i credits{default} from you.", sBossName, NPCGetDrainCreditAmount(npcIndex, iDifficulty));
				}
				#endif
				
				if (GetRandomStringFromProfile(npcProfile, "sound_attack_killed_client", buffer, sizeof(buffer)) && buffer[0] != '\0')
				{
					if (g_bPlayerEliminated[iClient])
					{
						EmitSoundToClient(iClient, buffer, _, SNDCHAN_STATIC, SNDLEVEL_HELICOPTER);
					}
				}
				
				if (GetRandomStringFromProfile(npcProfile, "sound_attack_killed_all", buffer, sizeof(buffer)) && buffer[0] != '\0')
				{
					if (g_bPlayerEliminated[iClient])
					{
						EmitSoundToAll(buffer, _, SNDCHAN_STATIC, SNDLEVEL_HELICOPTER);
					}
				}
				
				SlenderPrintChatMessage(npcIndex, iClient);
				
				SlenderPerformVoice(npcIndex, "sound_attack_killed");
			}
			
			if (IsEntityAProjectile(inflictor))
			{
				int npcIndex2 = NPCGetFromEntIndex(GetEntPropEnt(inflictor, Prop_Send, "m_hOwnerEntity"));
				if (npcIndex2 != -1)
				{
					int iSlender = NPCGetEntIndex(npcIndex2);
					if (iSlender && iSlender != INVALID_ENT_REFERENCE)g_iPlayerBossKillSubject[iClient] = EntIndexToEntRef(iSlender);
					
					char npcProfile[SF2_MAX_PROFILE_NAME_LENGTH], buffer[PLATFORM_MAX_PATH], sBossName[SF2_MAX_NAME_LENGTH];
					NPCGetProfile(npcIndex2, npcProfile, sizeof(npcProfile));
					NPCGetBossName(npcIndex2, sBossName, sizeof(sBossName));

					#if defined _store_included
					int iDifficulty = GetLocalGlobalDifficulty(npcIndex2);
					if (NPCGetDrainCreditState(npcIndex2))
					{
						Store_SetClientCredits(iClient, Store_GetClientCredits(iClient) - NPCGetDrainCreditAmount(npcIndex2, iDifficulty));
						CPrintToChat(iClient, "{valve}%s{default} has stolen {green}%i credits{default} from you.", sBossName, NPCGetDrainCreditAmount(npcIndex2, iDifficulty));
					}
					#endif
					
					
					if (GetRandomStringFromProfile(npcProfile, "sound_attack_killed_client", buffer, sizeof(buffer)) && buffer[0] != '\0')
					{
						if (g_bPlayerEliminated[iClient])
						{
							EmitSoundToClient(iClient, buffer, _, SNDCHAN_STATIC);
						}
					}
					
					if (GetRandomStringFromProfile(npcProfile, "sound_attack_killed_all", buffer, sizeof(buffer)) && buffer[0] != '\0')
					{
						if (g_bPlayerEliminated[iClient])
						{
							EmitSoundToAll(buffer, _, SNDCHAN_STATIC, SNDLEVEL_HELICOPTER);
						}
					}
					
					SlenderPrintChatMessage(npcIndex2, iClient);
					
					SlenderPerformVoice(npcIndex2, "sound_attack_killed");
				}
			}
			
			CreateTimer(0.2, Timer_CheckRoundWinConditions, _, TIMER_FLAG_NO_MAPCHANGE);
			
			// Notify to other bosses that this player has died.
			for (int i = 0; i < MAX_BOSSES; i++)
			{
				if (NPCGetUniqueID(i) == -1) continue;
				
				if (EntRefToEntIndex(g_iSlenderTarget[i]) == iClient)
				{
					g_iSlenderInterruptConditions[i] |= COND_CHASETARGETINVALIDATED;
					GetClientAbsOrigin(iClient, g_flSlenderChaseDeathPosition[i]);
				}
			}
			
			if (g_cvIgnoreRedPlayerDeathSwap.BoolValue)
			{
				g_bPlayerEliminated[iClient] = false;
				g_bPlayerEscaped[iClient] = false;
			}
		}
		
		if (g_bPlayerProxy[iClient])
		{
			// We're a proxy, so play some sounds.
			
			int iProxyMaster = NPCGetFromUniqueID(g_iPlayerProxyMaster[iClient]);
			if (iProxyMaster != -1)
			{
				char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
				NPCGetProfile(iProxyMaster, sProfile, sizeof(sProfile));
				
				char sBuffer[PLATFORM_MAX_PATH];
				if (GetRandomStringFromProfile(sProfile, "sound_proxy_death", sBuffer, sizeof(sBuffer)) && sBuffer[0] != '\0')
				{
					int iChannel = g_iSlenderProxyDeathChannel[iProxyMaster];
					int iLevel = g_iSlenderProxyDeathLevel[iProxyMaster];
					int iFlags = g_iSlenderProxyDeathFlags[iProxyMaster];
					float flVolume = g_flSlenderProxyDeathVolume[iProxyMaster];
					int iPitch = g_iSlenderProxyDeathPitch[iProxyMaster];
					
					EmitSoundToAll(sBuffer, iClient, iChannel, iLevel, iFlags, flVolume, iPitch);
				}
			}
		}
		
		ClientResetProxy(iClient, false);
		ClientUpdateListeningFlags(iClient);
		
		// Half-Zatoichi nerf code.
		int iKatanaHealthGain = 10;
		if (iKatanaHealthGain >= 0)
		{
			int iAttacker = GetClientOfUserId(event.GetInt("attacker"));
			if (iAttacker > 0)
			{
				if (!IsClientInPvP(iAttacker) && (!g_bPlayerEliminated[iAttacker] || g_bPlayerProxy[iAttacker]))
				{
					char sWeapon[64];
					event.GetString("weapon", sWeapon, sizeof(sWeapon));
					
					if (strcmp(sWeapon, "demokatana") == 0)
					{
						int iAttackerPreHealth = GetEntProp(iAttacker, Prop_Send, "m_iHealth");
						Handle hPack = CreateDataPack();
						WritePackCell(hPack, GetClientUserId(iAttacker));
						WritePackCell(hPack, iAttackerPreHealth + iKatanaHealthGain);
						
						CreateTimer(0.0, Timer_SetPlayerHealth, hPack, TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
		}
		
		g_hPlayerPostWeaponsTimer[iClient] = null;
		g_hPlayerIgniteTimer[iClient] = null;
		g_hPlayerResetIgnite[iClient] = null;
		g_hPlayerPageRewardTimer[iClient] = null;
		g_hPlayerPageRewardCycleTimer[iClient] = null;
		g_hPlayerFireworkTimer[iClient] = null;
		
		g_bPlayerGettingPageReward[iClient] = false;
		g_iPlayerHitsToCrits[iClient] = 0;
		g_iPlayerHitsToHeads[iClient] = 0;
		
		g_bPlayerTrapped[iClient] = false;
		g_iPlayerTrapCount[iClient] = 0;
		
		g_iPlayerRandomClassNumber[iClient] = 1;
	}
	if (!IsRoundEnding() && !g_bRoundWaitingForPlayers)
	{
		int iAttacker = GetClientOfUserId(event.GetInt("attacker"));
		if (IsRoundPlaying() && iClient != iAttacker)
		{
			//Copy the data
			char sString[64];
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
			event.GetString("weapon_logclassname", sString, sizeof(sString));
			event2.SetString("weapon_logclassname", sString);
			event.GetString("assister_fallback", sString, sizeof(sString));
			event2.SetString("assister_fallback", sString);
			event.GetString("weapon", sString, sizeof(sString));
			event2.SetString("weapon", sString);

			event2.SetInt("ignore", event.GetInt("ignore"));
			CreateTimer(0.2, Timer_SendDeath, event2, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	if (SF_IsBoxingMap() && IsRoundInEscapeObjective())
	{
		CreateTimer(0.2, Timer_CheckAlivePlayers, _, TIMER_FLAG_NO_MAPCHANGE);
	}
	PvP_OnPlayerDeath(iClient, bFake);
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT END: Event_PlayerDeath(%d)", iClient);
	#endif
	delete event;
}
