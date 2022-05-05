#if defined _sf2_specialround_included
 #endinput
#endif
#define _sf2_specialround_included

#define SR_CYCLELENGTH 10.0
#define SR_STARTDELAY 0.25
#define SR_MUSIC "slender/specialround.mp3"
#define SR_SOUND_SELECT "slender/specialroundselect.mp3"
#define SR_SOUND_SELECT_BR "ambient/rottenburg/rottenburg_belltower.wav"

#define FILE_SPECIALROUNDS "configs/sf2/specialrounds.cfg"
#define FILE_SPECIALROUNDS_DATA "data/sf2/specialrounds.cfg"

static ArrayList g_SpecialRoundCycleNames = null;

static Handle g_SpecialRoundTimer = null;
static int g_SpecialRoundCycleNum = 0;
static float g_SpecialRoundCycleEndTime = -1.0;
static bool g_Started = false;
static int doublerouletteCount = 0;
static int g_SpecialRoundType = 0;
void ReloadSpecialRounds()
{
	if (g_SpecialRoundCycleNames == null)
	{
		g_SpecialRoundCycleNames = new ArrayList(128);
	}
	
	g_SpecialRoundCycleNames.Clear();

	if (g_SpecialRoundsConfig != null)
	{
		delete g_SpecialRoundsConfig;
		g_SpecialRoundsConfig = null;
	}
	
	char buffer[PLATFORM_MAX_PATH];
	if (!g_UseAlternateConfigDirectoryConVar.BoolValue)
	{
		BuildPath(Path_SM, buffer, sizeof(buffer), FILE_SPECIALROUNDS);
	}
	else
	{
		BuildPath(Path_SM, buffer, sizeof(buffer), FILE_SPECIALROUNDS_DATA);
	}
	KeyValues kv = new KeyValues("root");
	if (!FileToKeyValues(kv, buffer))
	{
		delete kv;
		LogError("Failed to load special rounds! File %s not found!", !g_UseAlternateConfigDirectoryConVar.BoolValue ? FILE_SPECIALROUNDS : FILE_SPECIALROUNDS_DATA);
	}
	else
	{
		g_SpecialRoundsConfig = kv;
		LogMessage("Loaded special rounds file!");
		
		// Load names for the cycle.
		char buffer2[128];
		for (int specialRound = SPECIALROUND_DOUBLETROUBLE; specialRound < SPECIALROUND_MAXROUNDS; specialRound++)
		{
			SpecialRoundGetDescriptionHud(specialRound, buffer2, sizeof(buffer2));
			g_SpecialRoundCycleNames.PushString(buffer2);
		}
		
		kv.Rewind();
		if (kv.JumpToKey("jokes"))
		{
			if (kv.GotoFirstSubKey(false))
			{
				do
				{
					kv.GetString(NULL_STRING, buffer2, sizeof(buffer2));
					if (strlen(buffer2) > 0)
					{
						g_SpecialRoundCycleNames.PushString(buffer2);
					}
				}
				while (kv.GotoNextKey(false));
			}
		}
		
		g_SpecialRoundCycleNames.Sort(Sort_Random, Sort_String);
	}
}

stock void SpecialRoundGetDescriptionHud(int specialRound, char[] buffer,int bufferLen)
{
	strcopy(buffer, bufferLen, "");

	if (g_SpecialRoundsConfig == null)
	{
		return;
	}
	
	g_SpecialRoundsConfig.Rewind();
	char specialRoundString[32];
	FormatEx(specialRoundString, sizeof(specialRoundString), "%d", specialRound);
	
	if (!g_SpecialRoundsConfig.JumpToKey(specialRoundString))
	{
		return;
	}
	
	g_SpecialRoundsConfig.GetString("display_text_hud", buffer, bufferLen);
}

stock void SpecialRoundGetDescriptionChat(int specialRound, char[] buffer,int bufferLen)
{
	strcopy(buffer, bufferLen, "");

	if (g_SpecialRoundsConfig == null)
	{
		return;
	}
	
	g_SpecialRoundsConfig.Rewind();
	char specialRoundString[64];
	FormatEx(specialRoundString, sizeof(specialRoundString), "%d", specialRound);
	
	if (!g_SpecialRoundsConfig.JumpToKey(specialRoundString))
	{
		return;
	}
	
	g_SpecialRoundsConfig.GetString("display_text_chat", buffer, bufferLen);
}

stock void SpecialRoundGetIconHud(int specialRound, char[] buffer,int bufferLen)
{
	strcopy(buffer, bufferLen, "");

	if (g_SpecialRoundsConfig == null)
	{
		return;
	}
	
	g_SpecialRoundsConfig.Rewind();
	char specialRoundString[32];
	FormatEx(specialRoundString, sizeof(specialRoundString), "%d", specialRound);
	
	if (!g_SpecialRoundsConfig.JumpToKey(specialRoundString))
	{
		return;
	}
	
	g_SpecialRoundsConfig.GetString("display_icon_hud", buffer, bufferLen);
}

stock bool SpecialRoundCanBeSelected(int specialRound)
{
	if (g_SpecialRoundsConfig == null)
	{
		return false;
	}
	
	g_SpecialRoundsConfig.Rewind();
	char specialRoundString[32];
	FormatEx(specialRound, sizeof(specialRoundString), "%d", specialRound);
	
	if (!g_SpecialRoundsConfig.JumpToKey(specialRoundString))
	{
		return false;
	}
	
	return view_as<bool>(g_SpecialRoundsConfig.GetNum("enabled", 1));
}

public Action Timer_SpecialRoundCycle(Handle timer)
{
	if (timer != g_SpecialRoundTimer)
	{
		return Plugin_Stop;
	}
	
	if (GetGameTime() >= g_SpecialRoundCycleEndTime)
	{
		SpecialRoundCycleFinish();
		return Plugin_Stop;
	}
	
	char buffer[128];
	g_SpecialRoundCycleNames.GetString(g_SpecialRoundCycleNum, buffer, sizeof(buffer));
	
	if (!SF_SpecialRound(SPECIALROUND_SUPRISE))
	{
		SpecialRoundGameText(buffer);
	}
	
	g_SpecialRoundCycleNum++;
	if (g_SpecialRoundCycleNum >= g_SpecialRoundCycleNames.Length)
	{
		g_SpecialRoundCycleNum = 0;
	}
	
	return Plugin_Continue;
}

public Action Timer_SpecialRoundStart(Handle timer)
{
	if (timer != g_SpecialRoundTimer)
	{
		return Plugin_Stop;
	}
	if (!g_IsSpecialRound)
	{
		return Plugin_Stop;
	}
	
	SpecialRoundStart();

	return Plugin_Stop;
}
public Action Timer_SpecialRoundFakeBosses(Handle timer)
{
	if (!g_IsSpecialRound)
	{
		return Plugin_Stop;
	}
	if (!SF_SpecialRound(SPECIALROUND_DREAMFAKEBOSSES))
	{
		return Plugin_Stop;
	}
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	int fakeBossCount = 0;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetUniqueID(i) == -1)
		{
			continue;
		}
		if (NPCGetFlags(i) & SFF_FAKE)
		{
			fakeBossCount += 1;
		}
	}
	if (fakeBossCount == 3)
	{
		return Plugin_Continue;
	}
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		SF2NPC_BaseNPC Npc = view_as<SF2NPC_BaseNPC>(i);
		if (!Npc.IsValid())
		{
			continue;
		}
		if (Npc.Flags & SFF_FAKE)
		{
			continue;
		}
		//Harcoded max of 3 fake bosses
		if (fakeBossCount == 3)
		{
			break;
		}
		Npc.GetProfile(profile, sizeof(profile));
		SF2NPC_BaseNPC NpcFake = AddProfile(profile, SFF_FAKE, Npc);
		if (!NpcFake.IsValid())
		{
			LogError("Could not add fake boss for %d: No free slots!", i);
		}
		fakeBossCount += 1;
	}
	//PrintToChatAll("Fake count: %i",fakeBossCount);
	return Plugin_Continue;
}
	
/*
public Action Timer_SpecialRoundAttribute(Handle timer)
{
	if (timer != g_SpecialRoundTimer) return Plugin_Stop;
	if (!g_IsSpecialRound) return Plugin_Stop;
	
	int iCond = -1;
	
	switch (g_SpecialRoundType)
	{
		case SPECIALROUND_DEFENSEBUFF: iCond = _:TFCond_DefenseBuffed;
		case SPECIALROUND_MARKEDFORDEATH: iCond = _:TFCond_MarkedForDeath;
	}
	
	if (iCond != -1)
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (!IsClientInGame(i) || !IsPlayerAlive(i) || g_PlayerEliminated[i] || g_PlayerInGhostMode[i]) continue;
			
			TF2_AddCondition(i, view_as<TFCond>(iCond), 0.8);
		}
	}
	
	return Plugin_Continue;
}
*/

void SpecialRoundCycleStart()
{
	if (!g_IsSpecialRound)
	{
		return;
	}
	if (g_Started)
	{
		return;
	}
	
	g_Started = true;
	EmitSoundToAll(SR_MUSIC, _, MUSIC_CHAN);
	g_SpecialRoundType = 0;
	g_SpecialRoundCycleNum = 0;
	g_SpecialRoundCycleEndTime = GetGameTime() + SR_CYCLELENGTH;
	g_SpecialRoundTimer = CreateTimer(0.1, Timer_SpecialRoundCycle, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

void SpecialRoundCycleFinish()
{
	EmitSoundToAll(SR_SOUND_SELECT, _, SNDCHAN_AUTO);
	int override = g_SpecialRoundOverrideConVar.IntValue;
	if (override >= 1 && override < SPECIALROUND_MAXROUNDS)
	{
		g_SpecialRoundType = override;
	}
	else
	{
		ArrayList enabledRounds = SpecialEnabledList();
		
		g_SpecialRoundType = enabledRounds.Get(GetRandomInt(0, enabledRounds.Length-1));
		
		delete enabledRounds;
	}
	g_SpecialRoundOverrideConVar.SetInt(-1);
	
	if (!SF_SpecialRound(SPECIALROUND_SUPRISE))
	{
		char descHud[64];
		SpecialRoundGetDescriptionHud(g_SpecialRoundType, descHud, sizeof(descHud));
				
		char iconHud[64];
		SpecialRoundGetIconHud(g_SpecialRoundType, iconHud, sizeof(iconHud));
				
		char descChat[64];
		SpecialRoundGetDescriptionChat(g_SpecialRoundType, descChat, sizeof(descChat));
				
		SpecialRoundGameText(descHud, iconHud);
		CPrintToChatAll("%t", "SF2 Special Round Announce Chat", descChat); // For those who are using minimized HUD...
	}
		
	g_SpecialRoundTimer = CreateTimer(SR_STARTDELAY, Timer_SpecialRoundStart, _, TIMER_FLAG_NO_MAPCHANGE);
}

ArrayList SpecialEnabledList()
{
	if (g_IsSpecialRound)
	{
		ArrayList enabledRounds = new ArrayList();
		char snatcher[64] = "hypersnatcher_nerfed";
		
		int players;
		for (int client = 1; client <= MaxClients; client++)
		{
			if (IsValidClient(client) && !g_PlayerEliminated[client])
			{
				players++;
			}
		}

		if (!SF_IsBoxingMap())
		{
			if (GetSelectableBossProfileList().Length > 0)
			{
				enabledRounds.Push(SPECIALROUND_DOUBLETROUBLE);
				enabledRounds.Push(SPECIALROUND_DOOMBOX);
			}
		}
		else
		{
			if (GetSelectableBoxingBossProfileList().Length > 0)
			{
				enabledRounds.Push(SPECIALROUND_DOUBLETROUBLE);
				enabledRounds.Push(SPECIALROUND_DOOMBOX);
			}
		}
		
		if (GetActivePlayerCount() <= g_MaxPlayersConVar.IntValue * 2 && g_DifficultyConVar.IntValue < 3 && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_DOUBLEMAXPLAYERS);
		}
		if (!SF_IsBoxingMap())
		{
			if (GetSelectableBossProfileList().Length > 0 && GetActivePlayerCount() <= g_MaxPlayersConVar.IntValue * 2)
			{
				if (g_DifficultyConVar.IntValue < 3)
				{
					enabledRounds.Push(SPECIALROUND_2DOUBLE);
				}
				if (g_DifficultyConVar.IntValue < 2)
				{
					enabledRounds.Push(SPECIALROUND_2DOOM);
				}
			}
		}
		else
		{
			if (GetSelectableBossProfileList().Length > 0 && GetActivePlayerCount() <= g_MaxPlayersConVar.IntValue * 2)
			{
				enabledRounds.Push(SPECIALROUND_2DOUBLE);
			}
		}
		if (!SF_SpecialRound(SPECIALROUND_INSANEDIFFICULTY) && !SF_SpecialRound(SPECIALROUND_DOUBLEMAXPLAYERS) && !SF_SpecialRound(SPECIALROUND_DOUBLETROUBLE) && !SF_SpecialRound(SPECIALROUND_2DOUBLE) && !SF_SpecialRound(SPECIALROUND_2DOOM) && g_DifficultyConVar.IntValue < 3 && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_INSANEDIFFICULTY);
		}
		if (!SF_SpecialRound(SPECIALROUND_LIGHTSOUT) && !g_NightvisionEnabledConVar.BoolValue && !SF_SpecialRound(SPECIALROUND_NOULTRAVISION) && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_LIGHTSOUT);
		}
		if (!SF_SpecialRound(SPECIALROUND_BEACON) && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_BEACON);
		}
		if (!SF_SpecialRound(SPECIALROUND_NOGRACE) && !SF_IsBoxingMap() && !SF_SpecialRound(SPECIALROUND_REVOLUTION) && GetRoundState() != SF2RoundState_Intro && g_RoundGraceTimer != null)
		{
			enabledRounds.Push(SPECIALROUND_NOGRACE);
		}
		if (!SF_SpecialRound(SPECIALROUND_NIGHTVISION) && !g_NightvisionEnabledConVar.BoolValue && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_NIGHTVISION);
		}	
		if (!SF_SpecialRound(SPECIALROUND_DOUBLEROULETTE) && !SF_SpecialRound(SPECIALROUND_REVOLUTION) && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_DOUBLEROULETTE);
		}
		if (!SF_SpecialRound(SPECIALROUND_INFINITEFLASHLIGHT) && !SF_SpecialRound(SPECIALROUND_NIGHTVISION) && !g_NightvisionEnabledConVar.BoolValue && !SF_IsBoxingMap() && !g_RoundInfiniteFlashlight)
		{
			enabledRounds.Push(SPECIALROUND_INFINITEFLASHLIGHT);
		}	
		if (!SF_SpecialRound(SPECIALROUND_DREAMFAKEBOSSES) && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_DREAMFAKEBOSSES);
		}		
		if (!SF_SpecialRound(SPECIALROUND_EYESONTHECLOACK) && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_EYESONTHECLOACK);
		}
		if (!SF_SpecialRound(SPECIALROUND_NOPAGEBONUS) && g_PageMax > 2 && GetRoundState() != SF2RoundState_Escape && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_NOPAGEBONUS);
		}
		if (g_PageMax > 3 && !SF_SpecialRound(SPECIALROUND_DUCKS) && GetRoundState() != SF2RoundState_Escape && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_DUCKS);
		}
		if (!SF_SpecialRound(SPECIALROUND_1UP) && !SF_SpecialRound(SPECIALROUND_REVOLUTION) && !SF_SpecialRound(SPECIALROUND_DOUBLEROULETTE))
		{
			enabledRounds.Push(SPECIALROUND_1UP);
		}
		if (g_PageMax > 2 && !SF_SpecialRound(SPECIALROUND_NOULTRAVISION) && !SF_SpecialRound(SPECIALROUND_LIGHTSOUT) && !SF_SpecialRound(SPECIALROUND_NIGHTVISION) && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_NOULTRAVISION);
		}
		if (!SF_SpecialRound(SPECIALROUND_SUPRISE) && !SF_SpecialRound(SPECIALROUND_DOUBLEROULETTE) && !SF_SpecialRound(SPECIALROUND_REVOLUTION) && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_SUPRISE);
		}
		if (!SF_SpecialRound(SPECIALROUND_LASTRESORT) && GetRoundState() != SF2RoundState_Escape && !SF_IsBoxingMap() && g_PageMax > 1)
		{
			enabledRounds.Push(SPECIALROUND_LASTRESORT);
		}		
		if (!SF_SpecialRound(SPECIALROUND_ESCAPETICKETS) && g_PageMax > 4 && GetRoundState() != SF2RoundState_Escape && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_ESCAPETICKETS);
		}	
		if (!SF_SpecialRound(SPECIALROUND_REVOLUTION) && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_REVOLUTION);
		}
		if (!SF_SpecialRound(SPECIALROUND_DISTORTION) && players >= 4 && g_PageMax > 4 && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_DISTORTION);
		}
		if (!SF_SpecialRound(SPECIALROUND_MULTIEFFECT) && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_MULTIEFFECT);
		}
		if (!SF_SpecialRound(SPECIALROUND_BOO) && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_BOO);
		}
		if (!SF_SpecialRound(SPECIALROUND_COFFEE) && !SF_IsRaidMap() && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_COFFEE);
		}
		if (!SF_SpecialRound(SPECIALROUND_PAGEDETECTOR) && !SF_IsRaidMap() && g_PageMax >= 4 && GetRoundState() != SF2RoundState_Escape && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_PAGEDETECTOR);
		}
		if (!SF_SpecialRound(SPECIALROUND_CLASSSCRAMBLE) && g_PageMax >= 4 && GetRoundState() != SF2RoundState_Escape && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_CLASSSCRAMBLE);
		}
		if (!SF_SpecialRound(SPECIALROUND_PAGEREWARDS) && !SF_IsRaidMap() && !SF_IsSurvivalMap() && !SF_SpecialRound(SPECIALROUND_REVOLUTION) && g_PageMax > 4 && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_PAGEREWARDS);
		}
		if (!SF_SpecialRound(SPECIALROUND_TINYBOSSES) && !SF_SpecialRound(SPECIALROUND_REVOLUTION) && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_TINYBOSSES);
		}
		if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) && !SF_IsRaidMap() && !SF_IsSurvivalMap() && !SF_SpecialRound(SPECIALROUND_REVOLUTION) && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_RUNNINGINTHE90S);
		}
		if (!SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES) && !SF_IsRaidMap() && !SF_SpecialRound(SPECIALROUND_REVOLUTION) && !SF_SpecialRound(SPECIALROUND_DOUBLEROULETTE) && GetArraySize(GetSelectableBossProfileList()) > 0 && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_TRIPLEBOSSES);
		}
		if (!SF_SpecialRound(SPECIALROUND_20DOLLARS) && !SF_IsRaidMap() && !SF_SpecialRound(SPECIALROUND_REVOLUTION) && !SF_SpecialRound(SPECIALROUND_DOUBLEROULETTE) && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_20DOLLARS);
		}
		if (!SF_SpecialRound(SPECIALROUND_MODBOSSES) && !SF_IsRaidMap() && !SF_IsBoxingMap() && !SF_BossesChaseEndlessly() && !SF_IsProxyMap() && !SF_SpecialRound(SPECIALROUND_VOTE) && (GetSelectableAdminBossProfileList().Length > 0 || IsProfileValid(snatcher)))
		{
			enabledRounds.Push(SPECIALROUND_MODBOSSES);
		}
		if (!SF_SpecialRound(SPECIALROUND_THANATOPHOBIA) && !SF_IsRaidMap() && !SF_IsBoxingMap() && !SF_IsProxyMap() && !SF_SpecialRound(SPECIALROUND_REVOLUTION) && !SF_SpecialRound(SPECIALROUND_DOUBLEROULETTE) && !SF_SpecialRound(SPECIALROUND_VOTE))
		{
			enabledRounds.Push(SPECIALROUND_THANATOPHOBIA);
		}
		if (!SF_SpecialRound(SPECIALROUND_BOSSROULETTE) && !SF_IsRaidMap() && !SF_IsBoxingMap() && !SF_IsProxyMap() && g_PageMax > 4 && g_PageMax < 13 && GetArraySize(GetSelectableBossProfileList()) > 0)
		{
			enabledRounds.Push(SPECIALROUND_BOSSROULETTE);
		}
		if (!SF_SpecialRound(SPECIALROUND_WALLHAX) && !SF_IsRaidMap() && !SF_IsBoxingMap() && g_DifficultyConVar.IntValue < 3)
		{
			enabledRounds.Push(SPECIALROUND_WALLHAX);
		}
		//Always keep this special round push at the bottom, we need the array length.
		if (!SF_SpecialRound(SPECIALROUND_VOTE) && !SF_SpecialRound(SPECIALROUND_DOUBLEROULETTE) && !SF_SpecialRound(SPECIALROUND_REVOLUTION) && !SF_SpecialRound(SPECIALROUND_SUPRISE) && enabledRounds.Length > 5 && !SF_IsBoxingMap())
		{
			enabledRounds.Push(SPECIALROUND_VOTE);
		}
		
		return enabledRounds;
	}
	return null;
}

void SpecialRoundStart()
{
	if (!g_IsSpecialRound)
	{
		return;
	}
	if (g_SpecialRoundType < 1 || g_SpecialRoundType >= SPECIALROUND_MAXROUNDS)
	{
		return;
	}
	g_Started = false;
	g_SpecialRoundTimer = null;
	if (SF_SpecialRound(SPECIALROUND_DOUBLEROULETTE))
	{
		doublerouletteCount += 1;
	}
	switch (g_SpecialRoundType)
	{
		case SPECIALROUND_DOUBLETROUBLE:
		{
			char buffer[SF2_MAX_PROFILE_NAME_LENGTH];
			ArrayList selectableBosses = GetSelectableBossProfileList().Clone();
			ArrayList selectableBoxingBosses = GetSelectableBoxingBossProfileList().Clone();
			
			if (!SF_IsBoxingMap())
			{
				if (selectableBosses.Length > 0)
				{
					selectableBosses.GetString(GetRandomInt(0, selectableBosses.Length - 1), buffer, sizeof(buffer));
					AddProfile(buffer);
				}
			}
			else
			{
				if (selectableBoxingBosses.Length > 0)
				{
					selectableBoxingBosses.GetString(GetRandomInt(0, selectableBoxingBosses.Length - 1), buffer, sizeof(buffer));
					AddProfile(buffer);
				}
			}
			delete selectableBosses;
			delete selectableBoxingBosses;
			SF_AddSpecialRound(SPECIALROUND_DOUBLETROUBLE);
		}
		case SPECIALROUND_DOOMBOX:
		{
			char buffer[SF2_MAX_PROFILE_NAME_LENGTH];
			ArrayList selectableBosses = GetSelectableBossProfileList().Clone();
			ArrayList selectableBoxingBosses = GetSelectableBoxingBossProfileList().Clone();
			
			if (!SF_IsBoxingMap())
			{
				if (selectableBosses.Length > 0)
				{
					selectableBosses.GetString(GetRandomInt(0, selectableBosses.Length - 1), buffer, sizeof(buffer));
					AddProfile(buffer,_,_,_,false);
					selectableBosses.GetString(GetRandomInt(0, selectableBosses.Length - 1), buffer, sizeof(buffer));
					AddProfile(buffer,_,_,_,false);
				}
			}
			else
			{
				if (selectableBoxingBosses.Length > 0)
				{
					selectableBoxingBosses.GetString(GetRandomInt(0, selectableBoxingBosses.Length - 1), buffer, sizeof(buffer));
					AddProfile(buffer,_,_,_,false);
					selectableBoxingBosses.GetString(GetRandomInt(0, selectableBoxingBosses.Length - 1), buffer, sizeof(buffer));
					AddProfile(buffer,_,_,_,false);
				}
			}
			delete selectableBosses;
			delete selectableBoxingBosses;
			SF_AddSpecialRound(SPECIALROUND_DOOMBOX);
		}
		case SPECIALROUND_THANATOPHOBIA:
		{
			for (int client = 1; client <= MaxClients; client++)
			{
				if (!IsValidClient(client))
				{
					continue;
				}
				if (!IsPlayerAlive(client))
				{
					continue;
				}
				if (g_PlayerEliminated[client])
				{
					continue;
				}
				if (DidClientEscape(client))
				{
					continue;
				}
				TFClassType class = TF2_GetPlayerClass(client);
				int classToInt = view_as<int>(class);
				if (!IsClassConfigsValid())
				{
					if (class == TFClass_Medic)
					{
						TFClassType newClass;
						int random = GetRandomInt(1,8);
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
							case 9:
							{
								newClass = TFClass_Medic;
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
						ArrayList classArrays = new ArrayList();
						for (int i = 0; i < MAX_CLASSES; i++)
						{
							if (!g_ClassBlockedOnThanatophobia[classToInt])
							{
								classArrays.Push(view_as<TFClassType>(i + 1));
							}
						}
						TFClassType newClass = classArrays.Get(GetRandomInt(0, classArrays.Length - 1));
						TF2_SetPlayerClass(client, newClass);
						TF2_RegeneratePlayer(client);
						delete classArrays;
					}
				}
				if (TF2_GetPlayerClass(client) == TFClass_Sniper)
				{
					int ent = -1;
					while ((ent = FindEntityByClassname(ent, "tf_wearable")) != -1)
					{
						int itemIndex = GetEntProp(ent, Prop_Send, "m_iItemDefinitionIndex");

						if (642 == itemIndex)
						{
							if (GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == client)
							{
								RemoveEntity(ent);
							}
						}
					}
				}
			}
			SF_AddSpecialRound(SPECIALROUND_THANATOPHOBIA);
		}
		case SPECIALROUND_INSANEDIFFICULTY:
		{
			if (g_DifficultyConVar.IntValue < 3)
			{
				g_DifficultyConVar.SetString("3"); // Override difficulty to Insane.
			}
			SF_AddSpecialRound(SPECIALROUND_INSANEDIFFICULTY);
		}
		case SPECIALROUND_NOGRACE:
		{
			if (g_DifficultyConVar.IntValue < 2)
			{
				g_DifficultyConVar.SetString("2"); // Override difficulty to Hardcore.
			}
			if (g_RoundGraceTimer != null)
			{
				TriggerTimer(g_RoundGraceTimer);
			}
			SF_AddSpecialRound(SPECIALROUND_NOGRACE);
		}
		case SPECIALROUND_ESCAPETICKETS:
		{
			if (g_DifficultyConVar.IntValue < 3)
			{
				g_DifficultyConVar.SetString("3"); // Override difficulty to Insane.
			}
			if (g_RoundGraceTimer != null)
			{
				TriggerTimer(g_RoundGraceTimer);
			}
			SF_AddSpecialRound(SPECIALROUND_ESCAPETICKETS);
		}
		case SPECIALROUND_2DOUBLE:
		{
			ForceInNextPlayersInQueue(g_MaxPlayersConVar.IntValue);
			if (g_DifficultyConVar.IntValue < 3 && !SF_IsBoxingMap())
			{
				g_DifficultyConVar.SetString("3"); // Override difficulty to Insane.
			}
			char buffer[SF2_MAX_PROFILE_NAME_LENGTH];
			ArrayList selectableBosses = GetSelectableBossProfileList().Clone();
			ArrayList selectableBoxingBosses = GetSelectableBossProfileList().Clone();
			if (!SF_IsBoxingMap())
			{
				if (selectableBosses.Length > 0)
				{
					selectableBosses.GetString(GetRandomInt(0, selectableBosses.Length - 1), buffer, sizeof(buffer));
					AddProfile(buffer);
				}
			}
			else
			{
				if (selectableBoxingBosses.Length > 0)
				{
					selectableBoxingBosses.GetString(GetRandomInt(0, selectableBoxingBosses.Length - 1), buffer, sizeof(buffer));
					AddProfile(buffer);
				}
			}
			delete selectableBosses;
			delete selectableBoxingBosses;
			SF_AddSpecialRound(SPECIALROUND_2DOUBLE);
		}
		case SPECIALROUND_SUPRISE:
		{
			SpecialRoundCycleStart();
			SF_AddSpecialRound(SPECIALROUND_SUPRISE);
		}
		case SPECIALROUND_DOUBLEMAXPLAYERS:
		{
			ForceInNextPlayersInQueue(g_MaxPlayersConVar.IntValue);
			if (g_DifficultyConVar.IntValue < 3)
			{
				g_DifficultyConVar.SetString("3"); // Override difficulty to Insane.
			}
			SF_AddSpecialRound(SPECIALROUND_DOUBLEMAXPLAYERS);
		}
		case SPECIALROUND_CLASSSCRAMBLE:
		{
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsValidClient(i) || g_PlayerEliminated[i] || GetClientTeam(i) != TFTeam_Red || DidClientEscape(i) || !IsPlayerAlive(i))
				{
					continue;
				}
				g_PlayerRandomClassNumber[i] = GetRandomInt(1, 9);
			}
			SF_AddSpecialRound(SPECIALROUND_CLASSSCRAMBLE);
		}
		case SPECIALROUND_MODBOSSES:
		{
			char buffer[SF2_MAX_PROFILE_NAME_LENGTH], sNightmareDisplay[256];
			if (!SF_SpecialRound(SPECIALROUND_DOUBLEROULETTE) && !SF_SpecialRound(SPECIALROUND_REVOLUTION))
			{
				NPCStopMusic();
				NPCRemoveAll();
			}
			ArrayList selectableBosses = GetSelectableAdminBossProfileList().Clone();
			if (selectableBosses.Length > 0)
			{
				selectableBosses.GetString(GetRandomInt(0, selectableBosses.Length - 1), buffer, sizeof(buffer));
				AddProfile(buffer);
				int randomDifficulty = GetRandomInt(1, 5);
				if (!SF_SpecialRound(SPECIALROUND_DOUBLEROULETTE) && !SF_SpecialRound(SPECIALROUND_REVOLUTION))
				{
					switch (randomDifficulty)
					{
						case 1:
						{
							g_DifficultyConVar.SetInt(Difficulty_Normal);
							CPrintToChatAll("{royalblue}%t{default}The difficulty has been set to {yellow}%t{default}.", "SF2 Prefix", "SF2 Normal Difficulty");
						}
						case 2:
						{
							g_DifficultyConVar.SetInt(Difficulty_Hard);
							CPrintToChatAll("{royalblue}%t{default}The difficulty has been set to {orange}%t{default}.", "SF2 Prefix", "SF2 Hard Difficulty");
						}
						case 3:
						{
							g_DifficultyConVar.SetInt(Difficulty_Insane);
							CPrintToChatAll("{royalblue}%t{default}The difficulty has been set to {red}%t{default}.", "SF2 Prefix", "SF2 Insane Difficulty");
						}
						case 4:
						{
							for (int i = 0; i < sizeof(g_SoundNightmareMode)-1; i++)
							{
								EmitSoundToAll(g_SoundNightmareMode[i]);
							}
							FormatEx(sNightmareDisplay, sizeof(sNightmareDisplay), "%t mode!", "SF2 Nightmare Difficulty");
							SpecialRoundGameText(sNightmareDisplay, "leaderboard_streak");
							g_DifficultyConVar.SetInt(Difficulty_Nightmare);
							CPrintToChatAll("{royalblue}%t{default}The difficulty has been set to {valve}%t!", "SF2 Prefix", "SF2 Nightmare Difficulty");
						}
						case 5:
						{
							for (int i = 0; i < sizeof(g_SoundNightmareMode)-1; i++)
							{
								EmitSoundToAll(g_SoundNightmareMode[i]);
							}
							FormatEx(sNightmareDisplay, sizeof(sNightmareDisplay), "%t mode!", "SF2 Apollyon Difficulty");
							SpecialRoundGameText(sNightmareDisplay, "leaderboard_streak");
							g_DifficultyConVar.SetInt(Difficulty_Apollyon);
							CPrintToChatAll("{royalblue}%t{default}The difficulty has been set to {darkgray}%t!", "SF2 Prefix", "SF2 Apollyon Difficulty");
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
						}
					}
				}
				else
				{
					if (randomDifficulty > g_DifficultyConVar.IntValue)
					{
						switch (randomDifficulty)
						{
							case 1:
							{
								g_DifficultyConVar.SetInt(Difficulty_Normal);
								CPrintToChatAll("{royalblue}%t{default}The difficulty has been set to {yellow}%t{default}.", "SF2 Prefix", "SF2 Normal Difficulty");
							}
							case 2:
							{
								g_DifficultyConVar.SetInt(Difficulty_Hard);
								CPrintToChatAll("{royalblue}%t{default}The difficulty has been set to {orange}%t{default}.", "SF2 Prefix", "SF2 Hard Difficulty");
							}
							case 3:
							{
								g_DifficultyConVar.SetInt(Difficulty_Insane);
								CPrintToChatAll("{royalblue}%t{default}The difficulty has been set to {red}%t{default}.", "SF2 Prefix", "SF2 Insane Difficulty");
							}
							case 4:
							{
								for (int i = 0; i < sizeof(g_SoundNightmareMode)-1; i++)
								{
									EmitSoundToAll(g_SoundNightmareMode[i]);
								}
								FormatEx(sNightmareDisplay, sizeof(sNightmareDisplay), "%t mode!", "SF2 Nightmare Difficulty");
								SpecialRoundGameText(sNightmareDisplay, "leaderboard_streak");
								g_DifficultyConVar.SetInt(Difficulty_Nightmare);
								CPrintToChatAll("{royalblue}%t{default}The difficulty has been set to {valve}%t!", "SF2 Prefix", "SF2 Nightmare Difficulty");
							}
							case 5:
							{
								for (int i = 0; i < sizeof(g_SoundNightmareMode)-1; i++)
								{
									EmitSoundToAll(g_SoundNightmareMode[i]);
								}
								FormatEx(sNightmareDisplay, sizeof(sNightmareDisplay), "%t mode!", "SF2 Apollyon Difficulty");
								SpecialRoundGameText(sNightmareDisplay, "leaderboard_streak");
								g_DifficultyConVar.SetInt(Difficulty_Apollyon);
								CPrintToChatAll("{royalblue}%t{default}The difficulty has been set to {darkgray}%t!", "SF2 Prefix", "SF2 Apollyon Difficulty");
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
							}
						}
					}
				}
			}
			delete selectableBosses;
			SF_AddSpecialRound(SPECIALROUND_MODBOSSES);
		}
		case SPECIALROUND_TRIPLEBOSSES:
		{
			char buffer[SF2_MAX_PROFILE_NAME_LENGTH];
			currentMusicTrack = TRIPLEBOSSESMUSIC;
			int tripleBosses=0;
			for(int client = 1; client <= MaxClients; client++)
			{
				if (IsValidClient(client) && !g_PlayerEliminated[client])
				{
					ClientChaseMusicReset(client);
					ClientChaseMusicSeeReset(client);
					ClientAlertMusicReset(client);
					ClientIdleMusicReset(client);
					if (currentMusicTrack[0] != '\0')
					{
						StopSound(client, MUSIC_CHAN, currentMusicTrack);
					}
					ClientMusicStart(client, TRIPLEBOSSESMUSIC, _, MUSIC_PAGE_VOLUME);
					ClientUpdateMusicSystem(client);
				}
			}
			for (int i = 0; i < MAX_BOSSES; i++)
			{
				NPCStopMusic();
				SF2NPC_BaseNPC Npc = view_as<SF2NPC_BaseNPC>(i);
				if (!Npc.IsValid())
				{
					continue;
				}
				Npc.GetProfile(buffer, sizeof(buffer));
				if (tripleBosses == 1)
				{
					break;
				}
				AddProfile(buffer,_,_,_,false);
				AddProfile(buffer,_,_,_,false);
				tripleBosses += 1;
			}
			SF_AddSpecialRound(SPECIALROUND_TRIPLEBOSSES);
		}
		case SPECIALROUND_LIGHTSOUT,SPECIALROUND_NIGHTVISION:
		{
			if (g_SpecialRoundType == SPECIALROUND_LIGHTSOUT)
			{
				SF_RemoveSpecialRound(SPECIALROUND_NIGHTVISION);
				SF_RemoveSpecialRound(SPECIALROUND_INFINITEFLASHLIGHT);
				SF_AddSpecialRound(SPECIALROUND_LIGHTSOUT);
			}
			else if (g_SpecialRoundType == SPECIALROUND_NIGHTVISION)
			{
				SF_RemoveSpecialRound(SPECIALROUND_NOULTRAVISION);
				SF_RemoveSpecialRound(SPECIALROUND_LIGHTSOUT);
				SF_AddSpecialRound(SPECIALROUND_NIGHTVISION);
			}
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsClientInGame(i))
				{
					continue;
				}
				
				if (!g_PlayerEliminated[i])
				{
					ClientDeactivateUltravision(i);
					ClientResetFlashlight(i);
					ClientActivateUltravision(i);
				}
			}
		}
		case SPECIALROUND_WALLHAX:
		{
			if (g_DifficultyConVar.IntValue < 3)
			{
				g_DifficultyConVar.SetString("3"); // Override difficulty to Hardcore.
			}
			for (int npcIndex = 0; npcIndex < MAX_BOSSES; npcIndex++)
			{	
				if (NPCGetUniqueID(npcIndex) == -1)
				{
					continue;
				}
				SlenderRemoveGlow(npcIndex);
				if (NPCGetCustomOutlinesState(npcIndex))
				{
					if (!NPCGetRainbowOutlineState(npcIndex))
					{
						int color[4];
						color[0] = NPCGetOutlineColorR(npcIndex);
						color[1] = NPCGetOutlineColorG(npcIndex);
						color[2] = NPCGetOutlineColorB(npcIndex);
						color[3] = NPCGetOutlineTransparency(npcIndex);
						if (color[0] < 0)
						{
							color[0] = 0;
						}
						if (color[1] < 0)
						{
							color[1] = 0;
						}
						if (color[2] < 0)
						{
							color[2] = 0;
						}
						if (color[3] < 0)
						{
							color[3] = 0;
						}
						if (color[0] > 255)
						{
							color[0] = 255;
						}
						if (color[1] > 255)
						{
							color[1] = 255;
						}
						if (color[2] > 255)
						{
							color[2] = 255;
						}
						if (color[3] > 255)
						{
							color[3] = 255;
						}
						SlenderAddGlow(npcIndex,_,color);
					}
					else
					{
						SlenderAddGlow(npcIndex,_,view_as<int>({0, 0, 0, 0}));
					}
				}
				else
				{
					int purple[4] = {150, 0, 255, 255};
					SlenderAddGlow(npcIndex,_,purple);
				}
			}
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsValidClient(i))
				{
					continue;
				}
				ClientDisableConstantGlow(i);
				if (!g_PlayerProxy[i] && !DidClientEscape(i) && !g_PlayerEliminated[i])
				{
					int red[4] = {184, 56, 59, 255};
					ClientEnableConstantGlow(i, "head", red);
				}
				else if ((g_PlayerProxy[i] && GetClientTeam(i) == TFTeam_Blue))
				{
					int yellow[4] = {255, 208, 0, 255};
					ClientEnableConstantGlow(i, "head", yellow);
				}
			}
			SF_AddSpecialRound(SPECIALROUND_WALLHAX);
		}
		case SPECIALROUND_INFINITEFLASHLIGHT:
		{
			SF_RemoveSpecialRound(SPECIALROUND_LIGHTSOUT);
			bool nightVision = (g_NightvisionEnabledConVar.BoolValue || SF_SpecialRound(SPECIALROUND_NIGHTVISION));
			if (nightVision && g_NightvisionType != 1)
			{
				g_NightvisionType = 1;
				for (int i = 1; i <= MaxClients; i++)
				{
					if (!IsClientInGame(i))
					{
						continue;
					}
					
					if (!g_PlayerEliminated[i])
					{
						ClientDeactivateUltravision(i);
						ClientResetFlashlight(i);
						ClientActivateUltravision(i);
					}
				}
			}
			SF_AddSpecialRound(SPECIALROUND_INFINITEFLASHLIGHT);
		}
		case SPECIALROUND_DREAMFAKEBOSSES:
		{
			CreateTimer(2.0,Timer_SpecialRoundFakeBosses,_,TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			SF_AddSpecialRound(SPECIALROUND_DREAMFAKEBOSSES);
		}
		case SPECIALROUND_1UP:
		{
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsClientInGame(i))
				{
					continue;
				}
				
				if (!g_PlayerEliminated[i])
				{
					g_PlayerDied1Up[i] = false;
					g_PlayerIn1UpCondition[i] = true;
					g_PlayerFullyDied1Up[i] = false;
				}
			}
			SF_AddSpecialRound(SPECIALROUND_1UP);
		}
		case SPECIALROUND_NOULTRAVISION:
		{
			SF_AddSpecialRound(SPECIALROUND_NOULTRAVISION);
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsClientInGame(i))
				{
					continue;
				}
				
				if (!g_PlayerEliminated[i])
				{
					ClientDeactivateUltravision(i);
				}
			}
		}
		case SPECIALROUND_DUCKS:
		{
			char model[255], targetName[64];
			PrecacheModel("models/workshop/player/items/pyro/eotl_ducky/eotl_bonus_duck.mdl");
			int ent = -1;
			while ((ent = FindEntityByClassname(ent, "*")) != -1)
			{
				if (!IsEntityClassname(ent, "prop_dynamic", false) && !IsEntityClassname(ent, "prop_dynamic_override", false))
				{
					continue;
				}
				
				GetEntPropString(ent, Prop_Data, "m_ModelName", model, sizeof(model));
				GetEntPropString(ent, Prop_Data, "m_iName", targetName, sizeof(targetName));
				if (model[0] != '\0')
				{
					if ((strcmp(model, g_PageRefModelName) == 0 || strcmp(model, PAGE_MODEL) == 0) && StrContains(targetName, "sf2_page_", false) != -1)
					{
						SetEntityModel(ent, "models/workshop/player/items/pyro/eotl_ducky/eotl_bonus_duck.mdl");
					}
				}
			}
			SF_AddSpecialRound(SPECIALROUND_DUCKS);
		}
		case SPECIALROUND_REVOLUTION:
		{
			SF_AddSpecialRound(SPECIALROUND_REVOLUTION);
			g_SpecialRoundTime = 0;
		}
		case SPECIALROUND_VOTE:
		{
			if (!NativeVotes_IsVoteInProgress())
			{
				SpecialCreateVote();
			}
			else
			{
				CreateTimer(5.0, Timer_SpecialRoundVoteLoop, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			}
			SF_AddSpecialRound(SPECIALROUND_VOTE);
		}
		case SPECIALROUND_PAGEDETECTOR:
		{
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsClientInGame(i))
				{
					continue;
				}
				
				if (!g_PlayerEliminated[i])
				{
					ClientSetSpecialRoundTimer(i, 0.0, Timer_ClientPageDetector, GetClientUserId(i));
				}
			}
			SF_AddSpecialRound(SPECIALROUND_PAGEDETECTOR);
		}
		case SPECIALROUND_2DOOM:
		{
			ForceInNextPlayersInQueue(g_MaxPlayersConVar.IntValue);
			if (g_DifficultyConVar.IntValue < 2)
			{
				g_DifficultyConVar.SetString("2"); // Override difficulty to Hardcore.
			}
			char buffer[SF2_MAX_PROFILE_NAME_LENGTH];
			ArrayList selectableBosses = GetSelectableBossProfileList().Clone();
			if (selectableBosses.Length > 0)
			{
				selectableBosses.GetString(GetRandomInt(0, selectableBosses.Length - 1), buffer, sizeof(buffer));
				AddProfile(buffer,_,_,_,false);
				selectableBosses.GetString(GetRandomInt(0, selectableBosses.Length - 1), buffer, sizeof(buffer));
				AddProfile(buffer,_,_,_,false);
				selectableBosses.GetString(GetRandomInt(0, selectableBosses.Length - 1), buffer, sizeof(buffer));
				AddProfile(buffer,_,_,_,false);
			}
			delete selectableBosses;
			SF_AddSpecialRound(SPECIALROUND_2DOOM);
		}
		default:
		{
			SF_AddSpecialRound(g_SpecialRoundType);
		}
	}
	if (doublerouletteCount == 2)
	{
		doublerouletteCount = 0;
		SF_RemoveSpecialRound(SPECIALROUND_DOUBLEROULETTE);
	}
	if (SF_SpecialRound(SPECIALROUND_DOUBLEROULETTE))
		SpecialRoundCycleStart();
}

public Action Timer_SpecialRoundVoteLoop(Handle timer)
{
	if (!g_IsSpecialRound)
	{
		return Plugin_Stop;
	}
	if (!SF_SpecialRound(SPECIALROUND_VOTE))
	{
		return Plugin_Stop;
	}
	if (GetRoundState() != SF2RoundState_Escape && GetRoundState() != SF2RoundState_Active && GetRoundState() != SF2RoundState_Intro)
	{
		return Plugin_Stop;
	}
	if (NativeVotes_IsVoteInProgress())
	{
		return Plugin_Continue;
	}
	
	SpecialCreateVote();
	return Plugin_Stop;
}

public Action Timer_DisplaySpecialRound(Handle timer)
{
	char descHud[64];
	SpecialRoundGetDescriptionHud(g_SpecialRoundType, descHud, sizeof(descHud));
		
	char iconHud[64];
	SpecialRoundGetIconHud(g_SpecialRoundType, iconHud, sizeof(iconHud));
		
	char descChat[64];
	SpecialRoundGetDescriptionChat(g_SpecialRoundType, descChat, sizeof(descChat));
		
	SpecialRoundGameText(descHud, iconHud);
	if (strcmp(descChat, "") != 0)
	{
		CPrintToChatAll("%t", "SF2 Special Round Announce Chat", descChat);
	}
	else
	{
		CPrintToChatAll("{dodgerblue}Special round in developement...");
	}

	return Plugin_Stop;
}

void SpecialCreateVote()
{
	Handle voteMenu = NativeVotes_Create(Menu_SpecialVote, NativeVotesType_Custom_Mult);
	NativeVotes_SetInitiator(voteMenu, NATIVEVOTES_SERVER_INDEX);
	
	char title[255];
	FormatEx(title,255,"%t%t","SF2 Prefix","SF2 Special Round Vote Menu Title");
	NativeVotes_SetDetails(voteMenu,title);
	
	ArrayList enabledRounds = SpecialEnabledList().Clone();

	int eraseVoteRound = enabledRounds.FindValue(SPECIALROUND_VOTE);
	if (eraseVoteRound != -1)
	{
		enabledRounds.Erase(eraseVoteRound);
	}

	eraseVoteRound = enabledRounds.FindValue(SPECIALROUND_MODBOSSES);
	if (eraseVoteRound != -1)
	{
		enabledRounds.Erase(eraseVoteRound);
	}

	eraseVoteRound = enabledRounds.FindValue(SPECIALROUND_THANATOPHOBIA);
	if (eraseVoteRound != -1)
	{
		enabledRounds.Erase(eraseVoteRound);
	}

	for (int i = 0; i < 5; i++)
	{
		int round = enabledRounds.Get(GetRandomInt(0,enabledRounds.Length-1));
		int eraseRound = enabledRounds.FindValue(round);
		if (eraseRound != -1)
		{
			enabledRounds.Erase(eraseRound);
		}

		char item[30], itemOutPut[30];
		switch (round)
		{
			case SPECIALROUND_DOUBLETROUBLE:
			{
				FormatEx(item, sizeof(item), "Double Trouble");
			}
			case SPECIALROUND_INSANEDIFFICULTY:
			{
				FormatEx(item, sizeof(item), "Suicide Time");
			}
			case SPECIALROUND_DOUBLEMAXPLAYERS:
			{
				FormatEx(item, sizeof(item), "Double Players");
			}
			case SPECIALROUND_LIGHTSOUT:
			{
				FormatEx(item, sizeof(item), "Lights Out");
			}
			case SPECIALROUND_BEACON:
			{
				FormatEx(item, sizeof(item), "Bacon Spray");
			}
			case SPECIALROUND_DOOMBOX:
			{
				FormatEx(item, sizeof(item), "Doom Box");
			}
			case SPECIALROUND_NOGRACE:
			{
				FormatEx(item, sizeof(item), "Start Running");
			}
			case SPECIALROUND_2DOUBLE:
			{
				FormatEx(item, sizeof(item), "Double It All");
			}
			case SPECIALROUND_DOUBLEROULETTE:
			{
				FormatEx(item, sizeof(item), "Double Roulette");
			}
			case SPECIALROUND_NIGHTVISION:
			{
				FormatEx(item, sizeof(item), "Night Vision");
			}
			case SPECIALROUND_INFINITEFLASHLIGHT:
			{
				FormatEx(item, sizeof(item), "Infinite Flashlight");
			}
			case SPECIALROUND_DREAMFAKEBOSSES:
			{
				FormatEx(item, sizeof(item), "Just a Dream");
			}
			case SPECIALROUND_EYESONTHECLOACK:
			{
				FormatEx(item, sizeof(item), "Countdown");
			}
			case SPECIALROUND_NOPAGEBONUS:
			{
				FormatEx(item, sizeof(item), "Deadline");
			}
			case SPECIALROUND_DUCKS:
			{
				FormatEx(item, sizeof(item), "Ducks");
			}
			case SPECIALROUND_1UP:
			{
				FormatEx(item, sizeof(item), "1-Up");
			}
			case SPECIALROUND_NOULTRAVISION:
			{
				FormatEx(item, sizeof(item), "Blind");
			}
			case SPECIALROUND_SUPRISE:
			{
				FormatEx(item, sizeof(item), "Surprise");
			}
			case SPECIALROUND_LASTRESORT:
			{
				FormatEx(item, sizeof(item), "Last Resort");
			}
			case SPECIALROUND_ESCAPETICKETS:
			{
				FormatEx(item, sizeof(item), "Escape Tickets");
			}
			case SPECIALROUND_REVOLUTION:
			{
				FormatEx(item, sizeof(item), "Special Round Revolution");
			}
			case SPECIALROUND_DISTORTION:
			{
				FormatEx(item, sizeof(item), "Space Distortion");
			}
			case SPECIALROUND_MULTIEFFECT:
			{
				FormatEx(item, sizeof(item), "Multieffect");
			}
			case SPECIALROUND_BOO:
			{
				FormatEx(item, sizeof(item), "Boo");
			}
			case SPECIALROUND_COFFEE:
			{
				FormatEx(item, sizeof(item), "Coffee");
			}
			case SPECIALROUND_PAGEDETECTOR:
			{
				FormatEx(item, sizeof(item), "Page Detector");
			}
			case SPECIALROUND_CLASSSCRAMBLE:
			{
				FormatEx(item, sizeof(item), "Class Scramble");
			}
			case SPECIALROUND_2DOOM:
			{
				FormatEx(item, sizeof(item), "Silent Slender");
			}
			case SPECIALROUND_PAGEREWARDS:
			{
				FormatEx(item, sizeof(item), "Page Rewards");
			}
			case SPECIALROUND_TINYBOSSES:
			{
				FormatEx(item, sizeof(item), "Tiny Bosses");
			}
			case SPECIALROUND_RUNNINGINTHE90S:
			{
				FormatEx(item, sizeof(item), "In The 90s");
			}
			case SPECIALROUND_TRIPLEBOSSES:
			{
				FormatEx(item, sizeof(item), "Triple Bosses");
			}
			case SPECIALROUND_20DOLLARS:
			{
				FormatEx(item, sizeof(item), "20 Dollars");
			}
			case SPECIALROUND_BOSSROULETTE:
			{
				FormatEx(item, sizeof(item), "Boss Roulette");
			}
			case SPECIALROUND_WALLHAX:
			{
				FormatEx(item, sizeof(item), "Wall Hax");
			}
		}
		for (int iBit = 0; iBit < 30; iBit++)
		{
			if (strcmp(item[iBit],"-") == 0 ||strcmp(item[iBit],":") == 0)
			{
				break;
			}
			itemOutPut[iBit] = item[iBit];
		}
		FormatEx(item, sizeof(item), "%d", round);
		NativeVotes_AddItem(voteMenu, item, itemOutPut);
	}
	
	delete enabledRounds;
	
	int total = 0;
	int[] players = new int[MaxClients];
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i))
		{
			continue;
		}
		
		if (!g_PlayerEliminated[i])
		{
			players[total++] = i;
		}
	}
	
	NativeVotes_Display(voteMenu, players, total, 20);
}

public int Menu_SpecialVote(Handle menu, MenuAction action,int param1,int param2)
{
	switch (action)
	{	
		case MenuAction_VoteCancel:
		{
			if (param1 == VoteCancel_NoVotes)
			{
				NativeVotes_DisplayFail(menu, NativeVotesFail_NotEnoughVotes);
				
				ArrayList enabledRounds = SpecialEnabledList();
				g_SpecialRoundType = enabledRounds.Get(GetRandomInt(0, enabledRounds.Length-1));
				g_SpecialRoundOverrideConVar.SetInt(g_SpecialRoundType);
				SpecialRoundCycleFinish();
				delete enabledRounds;
			}
			else
			{
				NativeVotes_DisplayFail(menu, NativeVotesFail_Generic);
			}
		}
		case MenuAction_VoteEnd:
		{
			char specialRound[64], specialRoundName[64], display[120];
			NativeVotes_GetItem(menu, param1, specialRound, sizeof(specialRound), specialRoundName, sizeof(specialRoundName));
			
			CPrintToChatAll("{royalblue}%t{default}%t", "SF2 Prefix", "SF2 Special Round Vote Successful", specialRoundName);
			FormatEx(display,120,"%t","SF2 Special Round Vote Successful", specialRoundName);
			
			g_SpecialRoundType = StringToInt(specialRound);
			g_SpecialRoundOverrideConVar.SetInt(g_SpecialRoundType);
			SpecialRoundCycleFinish();
			
			NativeVotes_DisplayPass(menu, display);
		}
		case MenuAction_End:
		{
			delete menu;
		}
	}
}

void SpecialRound_RoundEnd()
{
	g_Started = false;
	SF_RemoveAllSpecialRound();
}
void SpecialRoundReset()
{
	g_SpecialRoundType = 0;
	g_SpecialRoundTimer = null;
	g_SpecialRoundCycleNum = 0;
	g_SpecialRoundCycleEndTime = -1.0;
}

bool IsSpecialRoundRunning()
{
	return g_IsSpecialRound;
}

public void SpecialRoundInitializeAPI()
{
	CreateNative("SF2_IsSpecialRoundRunning", Native_IsSpecialRoundRunning);
	CreateNative("SF2_GetSpecialRoundType", Native_GetSpecialRoundType);
}

public int Native_IsSpecialRoundRunning(Handle plugin,int numParams)
{
	return view_as<bool>(g_IsSpecialRound);
}

public int Native_GetSpecialRoundType(Handle plugin,int numParams)
{
	return g_SpecialRoundType;
}