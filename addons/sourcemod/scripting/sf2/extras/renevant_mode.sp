#if defined _sf2_renevant_mode_included
 #endinput
#endif
#define _sf2_renevant_mode_included

stock bool SF_IsRenevantMap()
{
	return view_as<bool>(g_bIsRenevantMap || (g_cvRenevantMap.IntValue == 1));
}

static bool Renevant_TryAddBossProfile(char sProfile[SF2_MAX_PROFILE_NAME_LENGTH], int iProfileLen, char[] sName, int iNameLen, bool bPlaySpawnSound=true)
{
	if (!GetRandomRenevantBossProfile(sProfile, iProfileLen))
		return false;

	NPCGetBossName(_, sName, iNameLen, sProfile);
	if (sName[0] == '\0') strcopy(sName, iNameLen, sProfile);
	AddProfile(sProfile, _, _, _, bPlaySpawnSound);

	return true;
}

static void Renevant_BroadcastMessage(const char[] sMessage, ...)
{
	char sFormat[512];
	VFormat(sFormat, sizeof(sFormat), sMessage, 2);

	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i) || g_bPlayerEliminated[i]) continue;

		ClientShowRenevantMessage(i, sFormat);
	}
}

enum RenevantWave
{
	RenevantWave_Normal = 0,
	RenevantWave_IncreaseDifficulty,
	RenevantWave_MultiEffect,
	RenevantWave_BaconSpray,
	RenevantWave_DoubleTrouble,
	RenevantWave_DoomBox,
	RenevantWave_Max
}

static void Renevant_DoWaveAction(RenevantWave action)
{
	char sBuffer[SF2_MAX_PROFILE_NAME_LENGTH], sBuffer2[SF2_MAX_PROFILE_NAME_LENGTH], sBuffer3[SF2_MAX_PROFILE_NAME_LENGTH];
	char sName[SF2_MAX_NAME_LENGTH], sName2[SF2_MAX_NAME_LENGTH], sName3[SF2_MAX_NAME_LENGTH];

	char sBroadcastMessage[512]; char sBroadcastBuffer[256];
	FormatEx(sBroadcastMessage, sizeof(sBroadcastMessage), "Wave %d", g_iRenevantWaveNumber);

	int iAddedBossCount = 0;
	if (Renevant_TryAddBossProfile(sBuffer, sizeof(sBuffer), sName, sizeof(sName)))
		iAddedBossCount++;

	if (iAddedBossCount == 1 && action != RenevantWave_DoubleTrouble && action != RenevantWave_DoomBox)
	{
		FormatEx(sBroadcastBuffer, sizeof(sBroadcastBuffer), "\nBoss: %s", sName); 
		StrCat(sBroadcastMessage, sizeof(sBroadcastMessage), sBroadcastBuffer);
	}

	switch (action)
	{
		case RenevantWave_Normal:
		{
		}
		case RenevantWave_IncreaseDifficulty:
		{
			switch (g_cvDifficulty.IntValue)
			{
				case Difficulty_Normal:
				{
					g_cvDifficulty.IntValue = Difficulty_Hard;

					FormatEx(sBroadcastBuffer, sizeof(sBroadcastBuffer), "\nDifficulty set to: %t",  "SF2 Hard Difficulty"); 
					StrCat(sBroadcastMessage, sizeof(sBroadcastMessage), sBroadcastBuffer);
				}
				case Difficulty_Hard:
				{
					g_cvDifficulty.IntValue = Difficulty_Insane;

					FormatEx(sBroadcastBuffer, sizeof(sBroadcastBuffer), "\nDifficulty set to: %t",  "SF2 Insane Difficulty"); 
					StrCat(sBroadcastMessage, sizeof(sBroadcastMessage), sBroadcastBuffer);
				}
				case Difficulty_Insane:
				{
					g_cvDifficulty.IntValue = Difficulty_Nightmare;

					FormatEx(sBroadcastBuffer, sizeof(sBroadcastBuffer), "\nDifficulty set to: %t",  "SF2 Nightmare Difficulty"); 
					StrCat(sBroadcastMessage, sizeof(sBroadcastMessage), sBroadcastBuffer);
				}
				case Difficulty_Nightmare:
				{
					g_cvDifficulty.IntValue = Difficulty_Apollyon;

					g_bBossesChaseEndlessly = true;
					g_bRoundInfiniteSprint = true;

					char sNightmareDisplay[256];
					
					Renevant_SpawnApollyon();

					CPrintToChatAll("The difficulty has been set to: {darkgray}%t{default}!", "SF2 Apollyon Difficulty");
					
					for (int i = 0; i < sizeof(g_strSoundNightmareMode)-1; i++)
						EmitSoundToAll(g_strSoundNightmareMode[i]);
					
					FormatEx(sNightmareDisplay, sizeof(sNightmareDisplay), "%t mode!", "SF2 Apollyon Difficulty");
					
					SpecialRoundGameText(sNightmareDisplay, "leaderboard_streak");

					int iRandomQuote = GetRandomInt(1, 8);
					switch (iRandomQuote)
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
				}
			}
		}
		case RenevantWave_MultiEffect:
		{
			g_bRenevantMultiEffect = true;
			StrCat(sBroadcastMessage, sizeof(sBroadcastMessage), "\nBosses can now inflict Multieffect.");
		}
		case RenevantWave_BaconSpray:
		{
			g_bRenevantBeaconEffect = true;
			StrCat(sBroadcastMessage, sizeof(sBroadcastMessage), "\nBosses are now alerted on spawn.");
		}
		case RenevantWave_DoubleTrouble:
		{
			if (Renevant_TryAddBossProfile(sBuffer2, sizeof(sBuffer2), sName2, sizeof(sName2)))
				iAddedBossCount++;

			if (iAddedBossCount == 1)
			{
				FormatEx(sBroadcastBuffer, sizeof(sBroadcastBuffer), "\nBoss: %s", sName); 
				StrCat(sBroadcastMessage, sizeof(sBroadcastMessage), sBroadcastBuffer);
			}
			else if (iAddedBossCount == 2)
			{
				FormatEx(sBroadcastBuffer, sizeof(sBroadcastBuffer), "\nBosses: %s and %s", sName, sName2); 
				StrCat(sBroadcastMessage, sizeof(sBroadcastMessage), sBroadcastBuffer);
			}
		}
		case RenevantWave_DoomBox:
		{
			if (Renevant_TryAddBossProfile(sBuffer2, sizeof(sBuffer2), sName2, sizeof(sName2)))
				iAddedBossCount++;
			if (Renevant_TryAddBossProfile(sBuffer3, sizeof(sBuffer3), sName3, sizeof(sName3)))
				iAddedBossCount++;

			if (iAddedBossCount == 1)
			{
				FormatEx(sBroadcastBuffer, sizeof(sBroadcastBuffer), "\nBoss: %s", sName); 
				StrCat(sBroadcastMessage, sizeof(sBroadcastMessage), sBroadcastBuffer);
			}
			else if (iAddedBossCount == 2)
			{
				FormatEx(sBroadcastBuffer, sizeof(sBroadcastBuffer), "\nBosses: %s and %s", sName, sName2); 
				StrCat(sBroadcastMessage, sizeof(sBroadcastMessage), sBroadcastBuffer);
			}
			else if (iAddedBossCount == 3)
			{
				FormatEx(sBroadcastBuffer, sizeof(sBroadcastBuffer), "\nBosses: %s, %s, and %s", sName, sName2, sName3); 
				StrCat(sBroadcastMessage, sizeof(sBroadcastMessage), sBroadcastBuffer);
			}
		}
	}

	Renevant_BroadcastMessage(sBroadcastMessage);
}

void Renevant_SetWave(int iWave, bool bResetTimer=false)
{
	if (!SF_IsRenevantMap() || g_iRenevantWaveNumber == iWave)
		return;
	
	g_iRenevantWaveNumber = iWave;

	if (bResetTimer && iWave < RENEVANT_MAXWAVES && iWave != 0)
	{
		float flTime = ((float(g_iRoundEscapeTimeLimit) - float(g_iRenevantFinaleTime)) / RENEVANT_MAXWAVES);
		g_hRenevantWaveTimer = CreateTimer(flTime, Timer_RenevantWave, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	}

	if (iWave == 0 || iWave >= RENEVANT_MAXWAVES)
		g_hRenevantWaveTimer = null; // At zero/max wave so stop it.

	switch (g_iRenevantWaveNumber)
	{
		case 1: //Wave 1
		{
			g_cvDifficulty.IntValue = Difficulty_Normal;

			Renevant_DoWaveAction(RenevantWave_Normal);

			CPrintToChatAll("The difficulty has been set to {yellow}%t{default}.", "SF2 Normal Difficulty");
		}
		case 2: //Wave 2
		{
			int iRandomWave = GetRandomInt(0, 2);
			switch (iRandomWave)
			{
				case 0:
				{
					Renevant_DoWaveAction(RenevantWave_Normal);
				}
				case 1:
				{
					Renevant_DoWaveAction(RenevantWave_IncreaseDifficulty);		
				}
				case 2:
				{
					Renevant_DoWaveAction(RenevantWave_MultiEffect);
				}
			}
		}
		case 3: //Wave 3
		{
			int iRandomWave = GetRandomInt(0, 3);
			switch (iRandomWave)
			{
				case 0:
				{
					Renevant_DoWaveAction(RenevantWave_Normal);
				}
				case 1:
				{
					Renevant_DoWaveAction(RenevantWave_DoubleTrouble);
				}
				case 2:
				{
					Renevant_DoWaveAction(RenevantWave_IncreaseDifficulty);
				}
				case 3:
				{
					Renevant_DoWaveAction(RenevantWave_BaconSpray);
				}
			}
		}
		case 4: //Wave 4
		{
			int iRandomWave = GetRandomInt(0, 2);
			switch (iRandomWave)
			{
				case 0:
				{
					Renevant_DoWaveAction(RenevantWave_Normal);
				}
				case 1:
				{
					Renevant_DoWaveAction(RenevantWave_DoubleTrouble);
				}
				case 2:
				{
					Renevant_DoWaveAction(RenevantWave_IncreaseDifficulty);
				}
			}
		}
		case 5: //Wave 5
		{
			int iRandomWave = GetRandomInt(0, 3);
			switch (iRandomWave)
			{
				case 0:
				{
					Renevant_DoWaveAction(RenevantWave_Normal);
				}
				case 1:
				{
					Renevant_DoWaveAction(RenevantWave_DoubleTrouble);
				}
				case 2:
				{
					Renevant_DoWaveAction(RenevantWave_IncreaseDifficulty);
				}
				case 3:
				{
					Renevant_DoWaveAction(RenevantWave_DoomBox);
				}
			}
		}
	}

	SF2MapEntity_OnRenevantWaveTriggered(g_iRenevantWaveNumber);

	Call_StartForward(fOnRenevantTriggerWave);
	Call_PushCell(g_iRenevantWaveNumber);
	Call_Finish();
}

public Action Timer_RenevantWave(Handle timer, any data)
{
	if (timer != g_hRenevantWaveTimer || IsRoundEnding())
		return Plugin_Stop;

	Renevant_SetWave(g_iRenevantWaveNumber + 1);
	
	if (g_iRenevantWaveNumber == RENEVANT_MAXWAVES)
		return Plugin_Stop;
	
	return Plugin_Continue;
}


static void Renevant_SpawnApollyon()
{
	ArrayList hSpawnPoint = new ArrayList();
	float flTeleportPos[3];
	int ent = -1, iSpawnTeam = 0;
	while ((ent = FindEntityByClassname(ent, "info_player_teamspawn")) != -1)
	{
		iSpawnTeam = GetEntProp(ent, Prop_Data, "m_iInitialTeamNum");
		if (iSpawnTeam == TFTeam_Red) 
		{
			hSpawnPoint.Push(ent);
		}
	}

	ent = -1;
	if (hSpawnPoint.Length > 0) ent = hSpawnPoint.Get(GetRandomInt(0,hSpawnPoint.Length-1));

	delete hSpawnPoint;

	if (ent > MaxClients)
	{
		GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flTeleportPos);
		for(int iNpc = 0;iNpc <= MAX_BOSSES; iNpc++)
		{
			SF2NPC_BaseNPC Npc = view_as<SF2NPC_BaseNPC>(iNpc);
			if (!Npc.IsValid()) continue;
			if (Npc.Flags & SFF_NOTELEPORT)
			{
				continue;
			}
			Npc.UnSpawn();
			SpawnSlender(Npc, flTeleportPos);
		}
	}
}

public int Native_IsRenevantMap(Handle plugin, int numParams)
{
	return view_as<int>(SF_IsRenevantMap());
}
