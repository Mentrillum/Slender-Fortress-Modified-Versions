#if defined _sf2_specialround_included
 #endinput
#endif
#define _sf2_specialround_included

#define SR_CYCLELENGTH 10.0
#define SR_STARTDELAY 1.25
#define SR_MUSIC "slender/specialround.mp3"
#define SR_SOUND_SELECT "slender/specialroundselect.mp3"

#define FILE_SPECIALROUNDS "configs/sf2/specialrounds.cfg"
#define FILE_SPECIALROUNDS_DATA "data/sf2/specialrounds.cfg"

static Handle g_hSpecialRoundCycleNames = INVALID_HANDLE;

static Handle g_hSpecialRoundTimer = INVALID_HANDLE;
static int g_iSpecialRoundCycleNum = 0;
static float g_flSpecialRoundCycleEndTime = -1.0;
static bool g_bStarted = false;
static int doubleroulettecount = 0;
static int g_iSpecialRoundType = 0;
void ReloadSpecialRounds()
{
	if (g_hSpecialRoundCycleNames == INVALID_HANDLE)
	{
		g_hSpecialRoundCycleNames = CreateArray(128);
	}
	
	ClearArray(g_hSpecialRoundCycleNames);

	if (g_hSpecialRoundsConfig != INVALID_HANDLE)
	{
		delete g_hSpecialRoundsConfig;
		g_hSpecialRoundsConfig = INVALID_HANDLE;
	}
	
	char buffer[PLATFORM_MAX_PATH];
	if (!GetConVarBool(g_cvUseAlternateConfigDirectory)) BuildPath(Path_SM, buffer, sizeof(buffer), FILE_SPECIALROUNDS);
	else BuildPath(Path_SM, buffer, sizeof(buffer), FILE_SPECIALROUNDS_DATA);
	KeyValues kv = new KeyValues("root");
	if (!FileToKeyValues(kv, buffer))
	{
		delete kv;
		LogError("Failed to load special rounds! File %s not found!", !GetConVarBool(g_cvUseAlternateConfigDirectory) ? FILE_SPECIALROUNDS : FILE_SPECIALROUNDS_DATA);
	}
	else
	{
		g_hSpecialRoundsConfig = kv;
		LogMessage("Loaded special rounds file!");
		
		// Load names for the cycle.
		char sBuffer[128];
		for (int iSpecialRound = SPECIALROUND_DOUBLETROUBLE; iSpecialRound < SPECIALROUND_MAXROUNDS; iSpecialRound++)
		{
			SpecialRoundGetDescriptionHud(iSpecialRound, sBuffer, sizeof(sBuffer));
			PushArrayString(g_hSpecialRoundCycleNames, sBuffer);
		}
		
		KvRewind(kv);
		if (KvJumpToKey(kv, "jokes"))
		{
			if (KvGotoFirstSubKey(kv, false))
			{
				do
				{
					KvGetString(kv, NULL_STRING, sBuffer, sizeof(sBuffer));
					if (strlen(sBuffer) > 0)
					{
						PushArrayString(g_hSpecialRoundCycleNames, sBuffer);
					}
				}
				while (KvGotoNextKey(kv, false));
			}
		}
		
		SortADTArray(g_hSpecialRoundCycleNames, Sort_Random, Sort_String);
	}
}

stock void SpecialRoundGetDescriptionHud(int iSpecialRound, char[] buffer,int bufferlen)
{
	strcopy(buffer, bufferlen, "");

	if (g_hSpecialRoundsConfig == INVALID_HANDLE) return;
	
	KvRewind(g_hSpecialRoundsConfig);
	char sSpecialRound[32];
	IntToString(iSpecialRound, sSpecialRound, sizeof(sSpecialRound));
	
	if (!KvJumpToKey(g_hSpecialRoundsConfig, sSpecialRound)) return;
	
	KvGetString(g_hSpecialRoundsConfig, "display_text_hud", buffer, bufferlen);
}

stock void SpecialRoundGetDescriptionChat(int iSpecialRound, char[] buffer,int bufferlen)
{
	strcopy(buffer, bufferlen, "");

	if (g_hSpecialRoundsConfig == INVALID_HANDLE) return;
	
	KvRewind(g_hSpecialRoundsConfig);
	char sSpecialRound[64];
	IntToString(iSpecialRound, sSpecialRound, sizeof(sSpecialRound));
	
	if (!KvJumpToKey(g_hSpecialRoundsConfig, sSpecialRound)) return;
	
	KvGetString(g_hSpecialRoundsConfig, "display_text_chat", buffer, bufferlen);
}

stock void SpecialRoundGetIconHud(int iSpecialRound, char[] buffer,int bufferlen)
{
	strcopy(buffer, bufferlen, "");

	if (g_hSpecialRoundsConfig == INVALID_HANDLE) return;
	
	KvRewind(g_hSpecialRoundsConfig);
	char sSpecialRound[32];
	IntToString(iSpecialRound, sSpecialRound, sizeof(sSpecialRound));
	
	if (!KvJumpToKey(g_hSpecialRoundsConfig, sSpecialRound)) return;
	
	KvGetString(g_hSpecialRoundsConfig, "display_icon_hud", buffer, bufferlen);
}

stock bool SpecialRoundCanBeSelected(int iSpecialRound)
{
	if (g_hSpecialRoundsConfig == INVALID_HANDLE) return false;
	
	KvRewind(g_hSpecialRoundsConfig);
	char sSpecialRound[32];
	IntToString(iSpecialRound, sSpecialRound, sizeof(sSpecialRound));
	
	if (!KvJumpToKey(g_hSpecialRoundsConfig, sSpecialRound)) return false;
	
	return view_as<bool>(KvGetNum(g_hSpecialRoundsConfig, "enabled", 1));
}

public Action Timer_SpecialRoundCycle(Handle timer)
{
	if (timer != g_hSpecialRoundTimer) return Plugin_Stop;
	
	if (GetGameTime() >= g_flSpecialRoundCycleEndTime)
	{
		SpecialRoundCycleFinish();
		return Plugin_Stop;
	}
	
	char sBuffer[128];
	GetArrayString(g_hSpecialRoundCycleNames, g_iSpecialRoundCycleNum, sBuffer, sizeof(sBuffer));
	
	if(!SF_SpecialRound(SPECIALROUND_SUPRISE))
		SpecialRoundGameText(sBuffer);
	
	g_iSpecialRoundCycleNum++;
	if (g_iSpecialRoundCycleNum >= GetArraySize(g_hSpecialRoundCycleNames))
	{
		g_iSpecialRoundCycleNum = 0;
	}
	
	return Plugin_Continue;
}

public Action Timer_SpecialRoundStart(Handle timer)
{
	if (timer != g_hSpecialRoundTimer) return;
	if (!g_bSpecialRound) return;
	
	SpecialRoundStart();
}
public Action Timer_SpecialRoundFakeBosses(Handle timer)
{
	if (!g_bSpecialRound) return Plugin_Stop;
	if (!SF_SpecialRound(SPECIALROUND_DREAMFAKEBOSSES)) return Plugin_Stop;
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	int iFakeBossCount=0;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetUniqueID(i) == -1) continue;
		if (NPCGetFlags(i) & SFF_FAKE)
			iFakeBossCount+=1;
	}
	//PrintToChatAll("Fake count: %i",iFakeBossCount);
	if(iFakeBossCount==3) return Plugin_Continue;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		SF2NPC_BaseNPC Npc = view_as<SF2NPC_BaseNPC>(i);
		if (!Npc.IsValid()) continue;
		if (Npc.Flags & SFF_FAKE)
		{
			continue;
		}
		//Harcoded max of 3 fake bosses
		if(iFakeBossCount==3) break;
		Npc.GetProfile(sProfile, sizeof(sProfile));
		SF2NPC_BaseNPC NpcFake = AddProfile(sProfile, SFF_FAKE, Npc);
		if (!NpcFake.IsValid())
		{
			LogError("Could not add fake boss for %d: No free slots!", i);
		}
		iFakeBossCount+=1;
	}
	//PrintToChatAll("Fake count: %i",iFakeBossCount);
	return Plugin_Continue;
}
	
/*
public Action Timer_SpecialRoundAttribute(Handle timer)
{
	if (timer != g_hSpecialRoundTimer) return Plugin_Stop;
	if (!g_bSpecialRound) return Plugin_Stop;
	
	int iCond = -1;
	
	switch (g_iSpecialRoundType)
	{
		case SPECIALROUND_DEFENSEBUFF: iCond = _:TFCond_DefenseBuffed;
		case SPECIALROUND_MARKEDFORDEATH: iCond = _:TFCond_MarkedForDeath;
	}
	
	if (iCond != -1)
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (!IsClientInGame(i) || !IsPlayerAlive(i) || g_bPlayerEliminated[i] || g_bPlayerGhostMode[i]) continue;
			
			TF2_AddCondition(i, view_as<TFCond>(iCond), 0.8);
		}
	}
	
	return Plugin_Continue;
}
*/

void SpecialRoundCycleStart()
{
	if (!g_bSpecialRound) return;
	if(g_bStarted) return;
	
	g_bStarted = true;
	EmitSoundToAll(SR_MUSIC, _, MUSIC_CHAN);
	g_iSpecialRoundType = 0;
	g_iSpecialRoundCycleNum = 0;
	g_flSpecialRoundCycleEndTime = GetGameTime() + SR_CYCLELENGTH;
	g_hSpecialRoundTimer = CreateTimer(0.1, Timer_SpecialRoundCycle, _, TIMER_REPEAT);
}

void SpecialRoundCycleFinish()
{
	EmitSoundToAll(SR_SOUND_SELECT, _, SNDCHAN_AUTO);
	int iOverride = GetConVarInt(g_cvSpecialRoundOverride);
	if (iOverride >= 1 && iOverride < SPECIALROUND_MAXROUNDS)
	{
		g_iSpecialRoundType = iOverride;
	}
	else
	{
		ArrayList arrayEnabledRound = SpecialEnabledList();
		
		g_iSpecialRoundType = arrayEnabledRound.Get(GetRandomInt(0, arrayEnabledRound.Length-1));
		
		delete arrayEnabledRound;
	}
	SetConVarInt(g_cvSpecialRoundOverride, -1);
	
	if(!SF_SpecialRound(SPECIALROUND_SUPRISE))
	{
		char sDescHud[64];
		SpecialRoundGetDescriptionHud(g_iSpecialRoundType, sDescHud, sizeof(sDescHud));
				
		char sIconHud[64];
		SpecialRoundGetIconHud(g_iSpecialRoundType, sIconHud, sizeof(sIconHud));
				
		char sDescChat[64];
		SpecialRoundGetDescriptionChat(g_iSpecialRoundType, sDescChat, sizeof(sDescChat));
				
		SpecialRoundGameText(sDescHud, sIconHud);
		CPrintToChatAll("%t", "SF2 Special Round Announce Chat", sDescChat); // For those who are using minimized HUD...
	}
		
	g_hSpecialRoundTimer = CreateTimer(SR_STARTDELAY, Timer_SpecialRoundStart);
}

ArrayList SpecialEnabledList()
{
	if (g_bSpecialRound)
	{
		ArrayList arrayEnabledRounds = new ArrayList();
		
		int iPlayers;
		for (int iClient = 1; iClient <= MaxClients; iClient++)
		{
			if (IsValidClient(iClient) && !g_bPlayerEliminated[iClient])
				iPlayers++;
		}

		if (!SF_IsBoxingMap())
		{
			if (GetArraySize(GetSelectableBossProfileList()) > 0)
			{
				arrayEnabledRounds.Push(SPECIALROUND_DOUBLETROUBLE);
				arrayEnabledRounds.Push(SPECIALROUND_DOOMBOX);
			}
		}
		else
		{
			if (GetArraySize(GetSelectableBoxingBossProfileList()) > 0)
			{
				arrayEnabledRounds.Push(SPECIALROUND_DOUBLETROUBLE);
				arrayEnabledRounds.Push(SPECIALROUND_DOOMBOX);
			}
		}
		
		if (GetActivePlayerCount() <= GetConVarInt(g_cvMaxPlayers) * 2 && GetConVarInt(g_cvDifficulty) < 3 && !SF_IsBoxingMap())
		{
			arrayEnabledRounds.Push(SPECIALROUND_DOUBLEMAXPLAYERS);
		}
		if (!SF_IsBoxingMap())
		{
			if (GetArraySize(GetSelectableBossProfileList()) > 0 && GetActivePlayerCount() <= GetConVarInt(g_cvMaxPlayers) * 2)
			{
				if (GetConVarInt(g_cvDifficulty) < 3)
				{
					arrayEnabledRounds.Push(SPECIALROUND_2DOUBLE);
				}
				if (GetConVarInt(g_cvDifficulty) < 2)
				{
					arrayEnabledRounds.Push(SPECIALROUND_2DOOM);
				}
			}
		}
		else
		{
			if (GetArraySize(GetSelectableBossProfileList()) > 0 && GetActivePlayerCount() <= GetConVarInt(g_cvMaxPlayers) * 2)
			{
				arrayEnabledRounds.Push(SPECIALROUND_2DOUBLE);
			}
		}
		if (!SF_SpecialRound(SPECIALROUND_INSANEDIFFICULTY) && !SF_SpecialRound(SPECIALROUND_DOUBLEMAXPLAYERS) && !SF_SpecialRound(SPECIALROUND_DOUBLETROUBLE) && !SF_SpecialRound(SPECIALROUND_2DOUBLE) && !SF_SpecialRound(SPECIALROUND_2DOOM) && GetConVarInt(g_cvDifficulty) < 3 && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_INSANEDIFFICULTY);
		if (!SF_SpecialRound(SPECIALROUND_LIGHTSOUT) && !GetConVarBool(g_cvNightvisionEnabled) && !SF_SpecialRound(SPECIALROUND_NOULTRAVISION) && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_LIGHTSOUT);
			
		if (!SF_SpecialRound(SPECIALROUND_BEACON) && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_BEACON);
		
		if (!SF_SpecialRound(SPECIALROUND_NOGRACE) && !SF_IsBoxingMap() && !SF_SpecialRound(SPECIALROUND_REVOLUTION) && GetRoundState() != SF2RoundState_Intro && g_hRoundGraceTimer != INVALID_HANDLE)
			arrayEnabledRounds.Push(SPECIALROUND_NOGRACE);
			
		if (!SF_SpecialRound(SPECIALROUND_NIGHTVISION) && !GetConVarBool(g_cvNightvisionEnabled) && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_NIGHTVISION);
			
		if (!SF_SpecialRound(SPECIALROUND_DOUBLEROULETTE) && !SF_SpecialRound(SPECIALROUND_REVOLUTION) && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_DOUBLEROULETTE);
			
		if (!SF_SpecialRound(SPECIALROUND_INFINITEFLASHLIGHT) && !SF_SpecialRound(SPECIALROUND_NIGHTVISION) && !GetConVarBool(g_cvNightvisionEnabled) && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_INFINITEFLASHLIGHT);
			
		if (!SF_SpecialRound(SPECIALROUND_DREAMFAKEBOSSES) && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_DREAMFAKEBOSSES);
			
		if (!SF_SpecialRound(SPECIALROUND_EYESONTHECLOACK))
			arrayEnabledRounds.Push(SPECIALROUND_EYESONTHECLOACK);
		
		if (!SF_SpecialRound(SPECIALROUND_NOPAGEBONUS) && g_iPageMax > 2 && GetRoundState() != SF2RoundState_Escape && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_NOPAGEBONUS);

		//Disabled
		if(g_iPageMax > 3 && !SF_SpecialRound(SPECIALROUND_DUCKS) && GetRoundState() != SF2RoundState_Escape && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_DUCKS);
		
		if (!SF_SpecialRound(SPECIALROUND_1UP) && !SF_SpecialRound(SPECIALROUND_REVOLUTION))
			arrayEnabledRounds.Push(SPECIALROUND_1UP);
		
		if (g_iPageMax > 2 && !SF_SpecialRound(SPECIALROUND_NOULTRAVISION) && !SF_SpecialRound(SPECIALROUND_LIGHTSOUT) && !SF_SpecialRound(SPECIALROUND_NIGHTVISION) && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_NOULTRAVISION);
		
		if (!SF_SpecialRound(SPECIALROUND_SUPRISE) && !SF_SpecialRound(SPECIALROUND_DOUBLEROULETTE) && !SF_SpecialRound(SPECIALROUND_REVOLUTION) && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_SUPRISE);
		
		if (!SF_SpecialRound(SPECIALROUND_LASTRESORT) && GetRoundState() != SF2RoundState_Escape && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_LASTRESORT);
		
		if (!SF_SpecialRound(SPECIALROUND_ESCAPETICKETS) && g_iPageMax > 4 && GetRoundState() != SF2RoundState_Escape && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_ESCAPETICKETS);
		
		if (!SF_SpecialRound(SPECIALROUND_REVOLUTION) && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_REVOLUTION);
		
		if (!SF_SpecialRound(SPECIALROUND_DISTORTION) && iPlayers >= 4 && g_iPageMax > 4 && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_DISTORTION);
		
		if (!SF_SpecialRound(SPECIALROUND_MULTIEFFECT) && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_MULTIEFFECT);
		
		if (!SF_SpecialRound(SPECIALROUND_BOO) && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_BOO);
		
		if (!SF_SpecialRound(SPECIALROUND_REALISM) && !SF_IsRaidMap() && !SF_SpecialRound(SPECIALROUND_REVOLUTION) && !SF_SpecialRound(SPECIALROUND_DOUBLEROULETTE) && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_REALISM);
		
		if (!SF_SpecialRound(SPECIALROUND_COFFEE) && !SF_IsRaidMap() && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_COFFEE);
		
		if (!SF_SpecialRound(SPECIALROUND_PAGEDETECTOR) && !SF_IsRaidMap() && g_iPageMax >= 4 && GetRoundState() != SF2RoundState_Escape && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_PAGEDETECTOR);
		
		if (!SF_SpecialRound(SPECIALROUND_CLASSSCRAMBLE) && g_iPageMax >= 4 && GetRoundState() != SF2RoundState_Escape && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_CLASSSCRAMBLE);
			
		if (!SF_SpecialRound(SPECIALROUND_WALLHAX) && !SF_IsRaidMap() && !SF_BossesChaseEndlessly() && GetConVarInt(g_cvDifficulty) < 4 && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_WALLHAX);
			
		if (!SF_SpecialRound(SPECIALROUND_HYPERSNATCHER) && !SF_IsRaidMap() && !SF_IsProxyMap() && !SF_SpecialRound(SPECIALROUND_ESCAPETICKETS) && g_iPageMax > 4 && !SF_SpecialRound(SPECIALROUND_REVOLUTION) && !SF_SpecialRound(SPECIALROUND_DOUBLEROULETTE) && GetArraySize(GetSelectableBossProfileList()) > 0 && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_HYPERSNATCHER);
			
		if (!SF_SpecialRound(SPECIALROUND_PAGEREWARDS) && !SF_IsRaidMap() && !SF_IsSurvivalMap() && !SF_SpecialRound(SPECIALROUND_REVOLUTION) && g_iPageMax > 4 && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_PAGEREWARDS);
			
		if (!SF_SpecialRound(SPECIALROUND_TINYBOSSES) && !SF_SpecialRound(SPECIALROUND_REVOLUTION) && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_TINYBOSSES);
			
		if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) && !SF_IsRaidMap() && !SF_IsSurvivalMap() && !SF_SpecialRound(SPECIALROUND_REVOLUTION) && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_RUNNINGINTHE90S);
			
		if (!SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES) && !SF_IsRaidMap() && !SF_SpecialRound(SPECIALROUND_REVOLUTION) && !SF_SpecialRound(SPECIALROUND_DOUBLEROULETTE) && GetArraySize(GetSelectableBossProfileList()) > 0 && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_TRIPLEBOSSES);

		if (!SF_SpecialRound(SPECIALROUND_20DOLLARS) && !SF_IsRaidMap() && !SF_SpecialRound(SPECIALROUND_REVOLUTION) && !SF_SpecialRound(SPECIALROUND_DOUBLEROULETTE) && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_20DOLLARS);

		if (!SF_SpecialRound(SPECIALROUND_MODBOSSES) && !SF_IsRaidMap() && !SF_IsBoxingMap() && !SF_BossesChaseEndlessly() && !SF_IsProxyMap() && !SF_SpecialRound(SPECIALROUND_REVOLUTION) && !SF_SpecialRound(SPECIALROUND_DOUBLEROULETTE) && !SF_SpecialRound(SPECIALROUND_VOTE) && GetArraySize(GetSelectableAdminBossProfileList()) > 0)
			arrayEnabledRounds.Push(SPECIALROUND_MODBOSSES);
		
		//Always keep this special round push at the bottom, we need the array lenght
		if (!SF_SpecialRound(SPECIALROUND_VOTE) && !SF_SpecialRound(SPECIALROUND_DOUBLEROULETTE) && !SF_SpecialRound(SPECIALROUND_SUPRISE) && arrayEnabledRounds.Length > 5 && !SF_IsBoxingMap())
			arrayEnabledRounds.Push(SPECIALROUND_VOTE);
		
		return arrayEnabledRounds;
	}
	return null;
}

void SpecialRoundStart()
{
	if (!g_bSpecialRound) return;
	if (g_iSpecialRoundType < 1 || g_iSpecialRoundType >= SPECIALROUND_MAXROUNDS) return;
	g_bStarted = false;
	g_hSpecialRoundTimer = INVALID_HANDLE;
	if(SF_SpecialRound(SPECIALROUND_DOUBLEROULETTE))
		doubleroulettecount += 1;
	switch (g_iSpecialRoundType)
	{
		case SPECIALROUND_DOUBLETROUBLE:
		{
			char sBuffer[SF2_MAX_PROFILE_NAME_LENGTH];
			Handle hSelectableBosses = CloneArray(GetSelectableBossProfileList());
			Handle hSelectableBoxingBosses = CloneArray(GetSelectableBoxingBossProfileList());
			
			if (!SF_IsBoxingMap())
			{
				if (GetArraySize(hSelectableBosses) > 0)
				{
					GetArrayString(hSelectableBosses, GetRandomInt(0, GetArraySize(hSelectableBosses) - 1), sBuffer, sizeof(sBuffer));
					AddProfile(sBuffer);
				}
			}
			else
			{
				if (GetArraySize(hSelectableBoxingBosses) > 0)
				{
					GetArrayString(hSelectableBoxingBosses, GetRandomInt(0, GetArraySize(hSelectableBoxingBosses) - 1), sBuffer, sizeof(sBuffer));
					AddProfile(sBuffer);
				}
			}
			delete hSelectableBosses;
			delete hSelectableBoxingBosses;
			SF_AddSpecialRound(SPECIALROUND_DOUBLETROUBLE);
		}
		case SPECIALROUND_DOOMBOX:
		{
			char sBuffer[SF2_MAX_PROFILE_NAME_LENGTH];
			Handle hSelectableBosses = CloneArray(GetSelectableBossProfileList());
			Handle hSelectableBoxingBosses = CloneArray(GetSelectableBoxingBossProfileList());
			
			if (!SF_IsBoxingMap())
			{
				if (GetArraySize(hSelectableBosses) > 0)
				{
					GetArrayString(hSelectableBosses, GetRandomInt(0, GetArraySize(hSelectableBosses) - 1), sBuffer, sizeof(sBuffer));
					AddProfile(sBuffer,_,_,_,false);
					GetArrayString(hSelectableBosses, GetRandomInt(0, GetArraySize(hSelectableBosses) - 1), sBuffer, sizeof(sBuffer));
					AddProfile(sBuffer,_,_,_,false);
				}
			}
			else
			{
				if (GetArraySize(hSelectableBoxingBosses) > 0)
				{
					GetArrayString(hSelectableBoxingBosses, GetRandomInt(0, GetArraySize(hSelectableBoxingBosses) - 1), sBuffer, sizeof(sBuffer));
					AddProfile(sBuffer,_,_,_,false);
					GetArrayString(hSelectableBoxingBosses, GetRandomInt(0, GetArraySize(hSelectableBoxingBosses) - 1), sBuffer, sizeof(sBuffer));
					AddProfile(sBuffer,_,_,_,false);
				}
			}
			delete hSelectableBosses;
			delete hSelectableBoxingBosses;
			SF_AddSpecialRound(SPECIALROUND_DOOMBOX);
		}
		case SPECIALROUND_INSANEDIFFICULTY:
		{
			if (GetConVarInt(g_cvDifficulty) < 3)
				SetConVarString(g_cvDifficulty, "3"); // Override difficulty to Insane.
			SF_AddSpecialRound(SPECIALROUND_INSANEDIFFICULTY);
		}
		case SPECIALROUND_NOGRACE:
		{
			if (GetConVarInt(g_cvDifficulty) < 2)
				SetConVarString(g_cvDifficulty, "2"); // Override difficulty to Hardcore.
			if(g_hRoundGraceTimer!=INVALID_HANDLE)
				TriggerTimer(g_hRoundGraceTimer);
			SF_AddSpecialRound(SPECIALROUND_NOGRACE);
		}
		case SPECIALROUND_ESCAPETICKETS:
		{
			if (GetConVarInt(g_cvDifficulty) < 3)
				SetConVarString(g_cvDifficulty, "3"); // Override difficulty to Insane.
			if(g_hRoundGraceTimer!=INVALID_HANDLE)
				TriggerTimer(g_hRoundGraceTimer);
			SF_AddSpecialRound(SPECIALROUND_ESCAPETICKETS);
		}
		case SPECIALROUND_2DOUBLE:
		{
			ForceInNextPlayersInQueue(GetConVarInt(g_cvMaxPlayers));
			if (GetConVarInt(g_cvDifficulty) < 3 && !SF_IsBoxingMap())
				SetConVarString(g_cvDifficulty, "3"); // Override difficulty to Insane.
			char sBuffer[SF2_MAX_PROFILE_NAME_LENGTH];
			Handle hSelectableBosses = CloneArray(GetSelectableBossProfileList());
			Handle hSelectableBoxingBosses = CloneArray(GetSelectableBossProfileList());
			if (!SF_IsBoxingMap())
			{
				if (GetArraySize(hSelectableBosses) > 0)
				{
					GetArrayString(hSelectableBosses, GetRandomInt(0, GetArraySize(hSelectableBosses) - 1), sBuffer, sizeof(sBuffer));
					AddProfile(sBuffer);
				}
			}
			else
			{
				if (GetArraySize(hSelectableBoxingBosses) > 0)
				{
					GetArrayString(hSelectableBoxingBosses, GetRandomInt(0, GetArraySize(hSelectableBoxingBosses) - 1), sBuffer, sizeof(sBuffer));
					AddProfile(sBuffer);
				}
			}
			delete hSelectableBosses;
			delete hSelectableBoxingBosses;
			SF_AddSpecialRound(SPECIALROUND_2DOUBLE);
		}
		case SPECIALROUND_SUPRISE:
		{
			SpecialRoundCycleStart();
			SF_AddSpecialRound(SPECIALROUND_SUPRISE);
		}
		case SPECIALROUND_DOUBLEMAXPLAYERS:
		{
			ForceInNextPlayersInQueue(GetConVarInt(g_cvMaxPlayers));
			if (GetConVarInt(g_cvDifficulty) < 3)
				SetConVarString(g_cvDifficulty, "3"); // Override difficulty to Insane.
			SF_AddSpecialRound(SPECIALROUND_DOUBLEMAXPLAYERS);
		}
		case SPECIALROUND_WALLHAX:
		{
			if (GetConVarInt(g_cvDifficulty) < 3)
				SetConVarString(g_cvDifficulty, "3"); //Insane
			for (int iNPCIndex = 0; iNPCIndex < MAX_BOSSES; iNPCIndex++)
			{	
				if (NPCGetUniqueID(iNPCIndex) == -1) continue;
				SlenderRemoveGlow(iNPCIndex);
				char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
				NPCGetProfile(iNPCIndex, sProfile, sizeof(sProfile));
				if (NPCGetCustomOutlinesState(iNPCIndex))
				{
					int color[4];
					color[0] = NPCGetOutlineColorR(iNPCIndex);
					color[1] = NPCGetOutlineColorG(iNPCIndex);
					color[2] = NPCGetOutlineColorB(iNPCIndex);
					color[3] = NPCGetOutlineTransparency(iNPCIndex);
					if (color[0] < 0) color[0] = 0;
					if (color[1] < 0) color[1] = 0;
					if (color[2] < 0) color[2] = 0;
					if (color[3] < 0) color[3] = 0;
					if (color[0] > 255) color[0] = 255;
					if (color[1] > 255) color[1] = 255;
					if (color[2] > 255) color[2] = 255;
					if (color[3] > 255) color[3] = 255;
					SlenderAddGlow(iNPCIndex,_,color);
				}
				else
				{
					int iPurple[4] = {150, 0, 255, 255};
					SlenderAddGlow(iNPCIndex,_,iPurple);
				}
			}
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsValidClient(i)) continue;
				ClientDisableConstantGlow(i);
				if (!g_bPlayerProxy[i] && !DidClientEscape(i) && !g_bPlayerEliminated[i])
				{
					int iRed[4] = {184, 56, 59, 255};
					ClientEnableConstantGlow(i, "head", iRed);
				}
				else if ((g_bPlayerProxy[i] && GetClientTeam(i) == TFTeam_Blue))
				{
					int iYellow[4] = {255, 208, 0, 255};
					ClientEnableConstantGlow(i, "head", iYellow);
				}
			}
			SF_AddSpecialRound(SPECIALROUND_WALLHAX);
		}
		case SPECIALROUND_CLASSSCRAMBLE:
		{
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsValidClient(i) || g_bPlayerEliminated[i] || GetClientTeam(i) != TFTeam_Red || DidClientEscape(i) || !IsPlayerAlive(i)) continue;
				g_iPlayerRandomClassNumber[i] = GetRandomInt(1, 9);
			}
			SF_AddSpecialRound(SPECIALROUND_CLASSSCRAMBLE);
		}
		case SPECIALROUND_HYPERSNATCHER:
		{
			char sBuffer[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCStopMusic();
			char sSnatcher[64] = "hypersnatcher_nerfed";
			NPCRemoveAll();
			Handle hSelectableBosses = CloneArray(GetSelectableBossProfileList());
			if (GetArraySize(hSelectableBosses) > 0)
			{
				if (sSnatcher[0] != '\0' && IsProfileValid(sSnatcher))
				{
					int iRandomDifficulty = GetRandomInt(1, 5);
					switch (iRandomDifficulty)
					{
						case 1:
						{
							AddProfile(sSnatcher);
							SetConVarInt(g_cvDifficulty, Difficulty_Normal);
							CPrintToChatAll("{royalblue}%t{default}The difficulty has been set to {yellow}%t{default}.", "SF2 Prefix", "SF2 Normal Difficulty");
						}
						case 2:
						{
							AddProfile(sSnatcher);
							SetConVarInt(g_cvDifficulty, Difficulty_Hard);
							CPrintToChatAll("{royalblue}%t{default}The difficulty has been set to {orange}%t{default}.", "SF2 Prefix", "SF2 Hard Difficulty");
						}
						case 3:
						{
							AddProfile(sSnatcher);
							SetConVarInt(g_cvDifficulty, Difficulty_Insane);
							CPrintToChatAll("{royalblue}%t{default}The difficulty has been set to {red}%t{default}.", "SF2 Prefix", "SF2 Insane Difficulty");
						}
						case 4:
						{
							for (int i = 0; i < sizeof(g_strSoundNightmareMode)-1; i++)
								EmitSoundToAll(g_strSoundNightmareMode[i]);
							SpecialRoundGameText("Nightmare mode!", "leaderboard_streak");
							SetConVarInt(g_cvDifficulty, Difficulty_Nightmare);
							CPrintToChatAll("{royalblue}%t{default}The difficulty has been set to {valve}Nightmare!", "SF2 Prefix");
							int iRandomQuote = GetRandomInt(1, 5);
							switch (iRandomQuote)
							{
								case 1:
								{
									EmitSoundToAll(HYPERSNATCHER_NIGHTAMRE_1);
									CPrintToChatAll("{ghostwhite}Hyper Snatcher{default}: Oh no! You're not slipping out of your contract THAT easily.");
								}
								case 2:
								{
									EmitSoundToAll(HYPERSNATCHER_NIGHTAMRE_2);
									CPrintToChatAll("{ghostwhite}Hyper Snatcher{default}: You ready to die some more? Great!");
								}
								case 3:
								{
									EmitSoundToAll(HYPERSNATCHER_NIGHTAMRE_3);
									CPrintToChatAll("{ghostwhite}Hyper Snatcher{default}: Live fast, die young, and leave behind a pretty corpse, huh? At least you got two out of three right.");
								}
								case 4:
								{
									EmitSoundToAll(HYPERSNATCHER_NIGHTAMRE_4);
									CPrintToChatAll("{ghostwhite}Hyper Snatcher{default}: I love the smell of DEATH in the morning.");
								}
								case 5:
								{
									EmitSoundToAll(HYPERSNATCHER_NIGHTAMRE_5);
									CPrintToChatAll("{ghostwhite}Hyper Snatcher{default}: Oh ho ho! I hope you don't think one measely death gets you out of your contract. We're only getting started.");
								}
							}
							AddProfile(sSnatcher,_,_,_,false);
						}
						case 5:
						{
							for (int i = 0; i < sizeof(g_strSoundNightmareMode)-1; i++)
								EmitSoundToAll(g_strSoundNightmareMode[i]);
							SpecialRoundGameText("Apollyon mode!", "leaderboard_streak");
							SetConVarInt(g_cvDifficulty, Difficulty_Apollyon);
							CPrintToChatAll("{royalblue}%t{default}The difficulty has been set to {darkgray}Apollyon!", "SF2 Prefix");
							int iRandomQuote = GetRandomInt(1, 8);
							switch (iRandomQuote)
							{
								case 1:
								{
									EmitSoundToAll(HYPERSNATCHER_NIGHTAMRE_1);
									CPrintToChatAll("{ghostwhite}Hyper Snatcher{default}: Oh no! You're not slipping out of your contract THAT easily.");
								}
								case 2:
								{
									EmitSoundToAll(HYPERSNATCHER_NIGHTAMRE_2);
									CPrintToChatAll("{ghostwhite}Hyper Snatcher{default}: You ready to die some more? Great!");
								}
								case 3:
								{
									EmitSoundToAll(HYPERSNATCHER_NIGHTAMRE_3);
									CPrintToChatAll("{ghostwhite}Hyper Snatcher{default}: Live fast, die young, and leave behind a pretty corpse, huh? At least you got two out of three right.");
								}
								case 4:
								{
									EmitSoundToAll(HYPERSNATCHER_NIGHTAMRE_4);
									CPrintToChatAll("{ghostwhite}Hyper Snatcher{default}: I love the smell of DEATH in the morning.");
								}
								case 5:
								{
									EmitSoundToAll(HYPERSNATCHER_NIGHTAMRE_5);
									CPrintToChatAll("{ghostwhite}Hyper Snatcher{default}: Oh ho ho! I hope you don't think one measely death gets you out of your contract. We're only getting started.");
								}
								case 6:
								{
									EmitSoundToAll(SNATCHER_APOLLYON_1);
									CPrintToChatAll("{ghostwhite}Hyper Snatcher{default}: Ah! It gets better every time!");
								}
								case 7:
								{
									EmitSoundToAll(SNATCHER_APOLLYON_2);
									CPrintToChatAll("{ghostwhite}Hyper Snatcher{default}: Hope you enjoyed that one kiddo, because theres a lot more where that came from!");
								}
								case 8:
								{
									EmitSoundToAll(SNATCHER_APOLLYON_3);
									CPrintToChatAll("{ghostwhite}Hyper Snatcher{default}: Killing you is hard work, but it pays off. HA HA HA HA HA HA HA HA HA HA");
								}
							}
							AddProfile(sSnatcher,_,_,_,false);
						}
					}
				}
				else
				{
					CPrintToChatAll("{royalblue}Hyper Snathcer doesn't exist, initiating Doom Box...");
					GetArrayString(hSelectableBosses, GetRandomInt(0, GetArraySize(hSelectableBosses) - 1), sBuffer, sizeof(sBuffer));
					AddProfile(sBuffer,_,_,_,false);
					GetArrayString(hSelectableBosses, GetRandomInt(0, GetArraySize(hSelectableBosses) - 1), sBuffer, sizeof(sBuffer));
					AddProfile(sBuffer,_,_,_,false);
					GetArrayString(hSelectableBosses, GetRandomInt(0, GetArraySize(hSelectableBosses) - 1), sBuffer, sizeof(sBuffer));
					AddProfile(sBuffer,_,_,_,false);
				}
			}
			delete hSelectableBosses;
			SF_AddSpecialRound(SPECIALROUND_HYPERSNATCHER);
		}
		case SPECIALROUND_MODBOSSES:
		{
			char sBuffer[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCStopMusic();
			NPCRemoveAll();
			Handle hSelectableBosses = CloneArray(GetSelectableAdminBossProfileList());
			if (GetArraySize(hSelectableBosses) > 0)
			{
				GetArrayString(hSelectableBosses, GetRandomInt(0, GetArraySize(hSelectableBosses) - 1), sBuffer, sizeof(sBuffer));
				AddProfile(sBuffer);
				int iRandomDifficulty = GetRandomInt(1, 5);
				switch (iRandomDifficulty)
				{
					case 1:
					{
						SetConVarInt(g_cvDifficulty, Difficulty_Normal);
						CPrintToChatAll("{royalblue}%t{default}The difficulty has been set to {yellow}%t{default}.", "SF2 Prefix", "SF2 Normal Difficulty");
					}
					case 2:
					{
						SetConVarInt(g_cvDifficulty, Difficulty_Hard);
						CPrintToChatAll("{royalblue}%t{default}The difficulty has been set to {orange}%t{default}.", "SF2 Prefix", "SF2 Hard Difficulty");
					}
					case 3:
					{
						SetConVarInt(g_cvDifficulty, Difficulty_Insane);
						CPrintToChatAll("{royalblue}%t{default}The difficulty has been set to {red}%t{default}.", "SF2 Prefix", "SF2 Insane Difficulty");
					}
					case 4:
					{
						for (int i = 0; i < sizeof(g_strSoundNightmareMode)-1; i++)
							EmitSoundToAll(g_strSoundNightmareMode[i]);
						SpecialRoundGameText("Nightmare mode!", "leaderboard_streak");
						SetConVarInt(g_cvDifficulty, Difficulty_Nightmare);
						CPrintToChatAll("{royalblue}%t{default}The difficulty has been set to {valve}Nightmare!", "SF2 Prefix");
					}
					case 5:
					{
						for (int i = 0; i < sizeof(g_strSoundNightmareMode)-1; i++)
							EmitSoundToAll(g_strSoundNightmareMode[i]);
						SpecialRoundGameText("Apollyon mode!", "leaderboard_streak");
						SetConVarInt(g_cvDifficulty, Difficulty_Apollyon);
						CPrintToChatAll("{royalblue}%t{default}The difficulty has been set to {darkgray}Apollyon!", "SF2 Prefix");
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
			delete hSelectableBosses;
			SF_AddSpecialRound(SPECIALROUND_MODBOSSES);
		}
		case SPECIALROUND_TRIPLEBOSSES:
		{
			char sBuffer[SF2_MAX_PROFILE_NAME_LENGTH];
			sCurrentMusicTrack = TRIPLEBOSSESMUSIC;
			int iTripleBosses=0;
			for(int client = 1;client <=MaxClients;client ++)
			{
				if(IsValidClient(client) && !g_bPlayerEliminated[client])
				{
					ClientChaseMusicReset(client);
					ClientChaseMusicSeeReset(client);
					ClientAlertMusicReset(client);
					StopSound(client, MUSIC_CHAN, sCurrentMusicTrack);
					ClientMusicStart(client, TRIPLEBOSSESMUSIC, _, MUSIC_PAGE_VOLUME);
					ClientUpdateMusicSystem(client);
				}
			}
			for (int i = 0; i < MAX_BOSSES; i++)
			{
				NPCStopMusic();
				SF2NPC_BaseNPC Npc = view_as<SF2NPC_BaseNPC>(i);
				if (!Npc.IsValid()) continue;
				Npc.GetProfile(sBuffer, sizeof(sBuffer));
				if (iTripleBosses == 1) break;
				AddProfile(sBuffer,_,_,_,false);
				AddProfile(sBuffer,_,_,_,false);
				iTripleBosses += 1;
			}
			SF_AddSpecialRound(SPECIALROUND_TRIPLEBOSSES);
		}
		case SPECIALROUND_LIGHTSOUT,SPECIALROUND_NIGHTVISION:
		{
			if (g_iSpecialRoundType == SPECIALROUND_LIGHTSOUT)
			{
				SF_RemoveSpecialRound(SPECIALROUND_NIGHTVISION);
				SF_RemoveSpecialRound(SPECIALROUND_INFINITEFLASHLIGHT);
				SF_AddSpecialRound(SPECIALROUND_LIGHTSOUT);
			}
			else if (g_iSpecialRoundType == SPECIALROUND_NIGHTVISION)
			{
				SF_RemoveSpecialRound(SPECIALROUND_NOULTRAVISION);
				SF_RemoveSpecialRound(SPECIALROUND_LIGHTSOUT);
				SF_AddSpecialRound(SPECIALROUND_NIGHTVISION);
			}
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsClientInGame(i)) continue;
				
				if (!g_bPlayerEliminated[i])
				{
					ClientDeactivateUltravision(i);
					ClientResetFlashlight(i);
					ClientActivateUltravision(i);
				}
			}
		}
		case SPECIALROUND_INFINITEFLASHLIGHT:
		{
			SF_RemoveSpecialRound(SPECIALROUND_LIGHTSOUT);
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
				if (!IsClientInGame(i)) continue;
				
				if (!g_bPlayerEliminated[i])
				{
					g_bPlayerDied1Up[i] = false;
					g_bPlayerIn1UpCondition[i] = true;
				}
			}
			SF_AddSpecialRound(SPECIALROUND_1UP);
		}
		case SPECIALROUND_NOULTRAVISION:
		{
			SF_AddSpecialRound(SPECIALROUND_NOULTRAVISION);
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsClientInGame(i)) continue;
				
				if (!g_bPlayerEliminated[i])
				{
					ClientDeactivateUltravision(i);
				}
			}
		}
		case SPECIALROUND_DUCKS:
		{
			char sModel[255], targetName[64];
			PrecacheModel("models/workshop/player/items/pyro/eotl_ducky/eotl_bonus_duck.mdl");
			int ent = -1;
			while ((ent = FindEntityByClassname(ent, "*")) != -1)
			{
				if (!IsEntityClassname(ent, "prop_dynamic", false) && !IsEntityClassname(ent, "prop_dynamic_override", false)) continue;
				
				GetEntPropString(ent, Prop_Data, "m_ModelName", sModel, sizeof(sModel));
				GetEntPropString(ent, Prop_Data, "m_iName", targetName, sizeof(targetName));
				if (sModel[0])
				{
					if ((strcmp(sModel, g_strPageRefModel) == 0 || strcmp(sModel, PAGE_MODEL) == 0) && StrContains(targetName, "sf2_page_ex", false) != -1)
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
			g_iSpecialRoundTime = 0;
		}
		case SPECIALROUND_REALISM:
		{
			SF_AddSpecialRound(SPECIALROUND_REALISM);
			NPCStopMusic();
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsClientInGame(i)) continue;
				
				if (!g_bPlayerEliminated[i])
				{
					g_hPlayerOverlayCheck[i] = CreateTimer(0.0, Timer_PlayerOverlayCheck, GetClientUserId(i), TIMER_REPEAT);
					TriggerTimer(g_hPlayerOverlayCheck[i], true);
					ClientRemoveMusicFlag(i, MUSICF_PAGES1PERCENT);
					ClientRemoveMusicFlag(i, MUSICF_PAGES25PERCENT);
					ClientRemoveMusicFlag(i, MUSICF_PAGES50PERCENT);
					ClientRemoveMusicFlag(i, MUSICF_PAGES75PERCENT);
					g_iPlayerPageMusicMaster[i] = INVALID_ENT_REFERENCE;
					g_iPageMusicActiveIndex[i] = -1;
					ClientMusicStart(i, NULLSOUND, _, MUSIC_PAGE_VOLUME);
					CreateTimer(0.1, Timer_RealismCheck, GetClientUserId(i), TIMER_FLAG_NO_MAPCHANGE);
					StopSound(i, MUSIC_CHAN, g_strRoundIntroMusic);
					EmitSoundToClient(i, MARBLEHORNETS_STATIC, _, SNDCHAN_STATIC, 100, _, 0.8);
				}
			}
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
				if (!IsClientInGame(i)) continue;
				
				if (!g_bPlayerEliminated[i])
				{
					ClientSetSpecialRoundTimer(i, 0.0, Timer_ClientPageDetector, GetClientUserId(i));
				}
			}
			SF_AddSpecialRound(SPECIALROUND_PAGEDETECTOR);
		}
		case SPECIALROUND_2DOOM:
		{
			ForceInNextPlayersInQueue(GetConVarInt(g_cvMaxPlayers));
			if (GetConVarInt(g_cvDifficulty) < 2)
				SetConVarString(g_cvDifficulty, "2"); // Override difficulty to Hardcore.
			char sBuffer[SF2_MAX_PROFILE_NAME_LENGTH];
			Handle hSelectableBosses = CloneArray(GetSelectableBossProfileList());
			if (GetArraySize(hSelectableBosses) > 0)
			{
				GetArrayString(hSelectableBosses, GetRandomInt(0, GetArraySize(hSelectableBosses) - 1), sBuffer, sizeof(sBuffer));
				AddProfile(sBuffer,_,_,_,false);
				GetArrayString(hSelectableBosses, GetRandomInt(0, GetArraySize(hSelectableBosses) - 1), sBuffer, sizeof(sBuffer));
				AddProfile(sBuffer,_,_,_,false);
				GetArrayString(hSelectableBosses, GetRandomInt(0, GetArraySize(hSelectableBosses) - 1), sBuffer, sizeof(sBuffer));
				AddProfile(sBuffer,_,_,_,false);
			}
			delete hSelectableBosses;
			SF_AddSpecialRound(SPECIALROUND_2DOOM);
		}
		default:
		{
			SF_AddSpecialRound(g_iSpecialRoundType);
		}
	}
	if(doubleroulettecount==2)
	{
		doubleroulettecount=0;
		SF_RemoveSpecialRound(SPECIALROUND_DOUBLEROULETTE);
	}
	if(SF_SpecialRound(SPECIALROUND_DOUBLEROULETTE))
		SpecialRoundCycleStart();
}

public Action Timer_RealismCheck(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if(client <= 0) return;
	if (!IsValidClient(client) || !IsClientInGame(client) || IsClientSourceTV(client)) return;
	
	ClientUpdateMusicSystem(client);
}

public Action Timer_SpecialRoundVoteLoop(Handle timer)
{
	if (!g_bSpecialRound) return Plugin_Stop;
	if (!SF_SpecialRound(SPECIALROUND_VOTE)) return Plugin_Stop;
	if (GetRoundState() != SF2RoundState_Escape && GetRoundState() != SF2RoundState_Active && GetRoundState() != SF2RoundState_Intro) return Plugin_Stop;
	if (NativeVotes_IsVoteInProgress()) return Plugin_Continue;
	
	SpecialCreateVote();
	return Plugin_Stop;
}

public Action Timer_DisplaySpecialRound(Handle timer)
{
	char sDescHud[64];
	SpecialRoundGetDescriptionHud(g_iSpecialRoundType, sDescHud, sizeof(sDescHud));
		
	char sIconHud[64];
	SpecialRoundGetIconHud(g_iSpecialRoundType, sIconHud, sizeof(sIconHud));
		
	char sDescChat[64];
	SpecialRoundGetDescriptionChat(g_iSpecialRoundType, sDescChat, sizeof(sDescChat));
		
	SpecialRoundGameText(sDescHud, sIconHud);
	if (strcmp(sDescChat, "") != 0)
		CPrintToChatAll("%t", "SF2 Special Round Announce Chat", sDescChat);
	else
		CPrintToChatAll("{dodgerblue}Special round in developement...");
}

void SpecialCreateVote()
{
	Handle voteMenu = NativeVotes_Create(Menu_SpecialVote, NativeVotesType_Custom_Mult);
	NativeVotes_SetInitiator(voteMenu, NATIVEVOTES_SERVER_INDEX);
	
	char Tittle[255];
	FormatEx(Tittle,255,"%t%t","SF2 Prefix","SF2 Special Round Vote Menu Title");
	NativeVotes_SetDetails(voteMenu,Tittle);
	
	ArrayList arrayEnabledRounds = SpecialEnabledList().Clone();

	int iEraseVoteRound = arrayEnabledRounds.FindValue(SPECIALROUND_VOTE);
	if (iEraseVoteRound != -1) arrayEnabledRounds.Erase(iEraseVoteRound);

	iEraseVoteRound = arrayEnabledRounds.FindValue(SPECIALROUND_MODBOSSES);
	if (iEraseVoteRound != -1) arrayEnabledRounds.Erase(iEraseVoteRound);

	for (int i = 0; i < 5; i++)
	{
		int iRound = arrayEnabledRounds.Get(GetRandomInt(0,arrayEnabledRounds.Length-1));
		int iEraseRound = arrayEnabledRounds.FindValue(iRound);
		if (iEraseRound != -1) arrayEnabledRounds.Erase(iEraseRound);

		char sItem[30], sItemOutPut[30];
		switch (iRound)
		{
			case SPECIALROUND_DOUBLETROUBLE: FormatEx(sItem, sizeof(sItem), "Double Trouble");
			case SPECIALROUND_INSANEDIFFICULTY: FormatEx(sItem, sizeof(sItem), "Suicide Time");
			case SPECIALROUND_DOUBLEMAXPLAYERS: FormatEx(sItem, sizeof(sItem), "Double Players");
			case SPECIALROUND_LIGHTSOUT: FormatEx(sItem, sizeof(sItem), "Lights Out");
			case SPECIALROUND_BEACON: FormatEx(sItem, sizeof(sItem), "Bacon Spray");
			case SPECIALROUND_DOOMBOX: FormatEx(sItem, sizeof(sItem), "Doom Box");
			case SPECIALROUND_NOGRACE: FormatEx(sItem, sizeof(sItem), "Start Running");
			case SPECIALROUND_2DOUBLE: FormatEx(sItem, sizeof(sItem), "Double It All");
			case SPECIALROUND_DOUBLEROULETTE: FormatEx(sItem, sizeof(sItem), "Double Roulette");
			case SPECIALROUND_NIGHTVISION: FormatEx(sItem, sizeof(sItem), "Night Vision");
			case SPECIALROUND_INFINITEFLASHLIGHT: FormatEx(sItem, sizeof(sItem), "Infinite Flashlight");
			case SPECIALROUND_DREAMFAKEBOSSES: FormatEx(sItem, sizeof(sItem), "Just a Dream");
			case SPECIALROUND_EYESONTHECLOACK: FormatEx(sItem, sizeof(sItem), "Countdown");
			case SPECIALROUND_NOPAGEBONUS: FormatEx(sItem, sizeof(sItem), "Deadline");
			case SPECIALROUND_DUCKS: FormatEx(sItem, sizeof(sItem), "Ducks");
			case SPECIALROUND_1UP: FormatEx(sItem, sizeof(sItem), "1-Up");
			case SPECIALROUND_NOULTRAVISION: FormatEx(sItem, sizeof(sItem), "Blind");
			case SPECIALROUND_SUPRISE: FormatEx(sItem, sizeof(sItem), "Surprise");
			case SPECIALROUND_LASTRESORT: FormatEx(sItem, sizeof(sItem), "Last Resort");
			case SPECIALROUND_ESCAPETICKETS: FormatEx(sItem, sizeof(sItem), "Escape Tickets");
			case SPECIALROUND_REVOLUTION: FormatEx(sItem, sizeof(sItem), "Special Round Revolution");
			case SPECIALROUND_DISTORTION: FormatEx(sItem, sizeof(sItem), "Space Distortion");
			case SPECIALROUND_MULTIEFFECT: FormatEx(sItem, sizeof(sItem), "Multieffect");
			case SPECIALROUND_BOO: FormatEx(sItem, sizeof(sItem), "Boo");
			case SPECIALROUND_REALISM: FormatEx(sItem, sizeof(sItem), "Marble Hornets");
			case SPECIALROUND_COFFEE: FormatEx(sItem, sizeof(sItem), "Coffee");
			case SPECIALROUND_PAGEDETECTOR: FormatEx(sItem, sizeof(sItem), "Page Detector");
			case SPECIALROUND_CLASSSCRAMBLE: FormatEx(sItem, sizeof(sItem), "Class Scramble");
			case SPECIALROUND_2DOOM: FormatEx(sItem, sizeof(sItem), "Silent Slender");
			case SPECIALROUND_WALLHAX: FormatEx(sItem, sizeof(sItem), "Wall Hax");
			case SPECIALROUND_HYPERSNATCHER: FormatEx(sItem, sizeof(sItem), "Hyper Snatcher");
			case SPECIALROUND_PAGEREWARDS: FormatEx(sItem, sizeof(sItem), "Page Rewards");
			case SPECIALROUND_TINYBOSSES: FormatEx(sItem, sizeof(sItem), "Tiny Bosses");
			case SPECIALROUND_RUNNINGINTHE90S: FormatEx(sItem, sizeof(sItem), "In The 90s");
			case SPECIALROUND_TRIPLEBOSSES: FormatEx(sItem, sizeof(sItem), "Triple Bosses");
			case SPECIALROUND_20DOLLARS: FormatEx(sItem, sizeof(sItem), "20 Dollars");
		}
		for (int iBit = 0; iBit < 30; iBit++)
		{
			if (strcmp(sItem[iBit],"-") == 0 ||strcmp(sItem[iBit],":") == 0)
			{
				break;
			}
			sItemOutPut[iBit] = sItem[iBit];
		}
		FormatEx(sItem, sizeof(sItem), "%d", iRound);
		NativeVotes_AddItem(voteMenu, sItem, sItemOutPut);
	}
	
	delete arrayEnabledRounds;
	
	int total = 0;
	int[] players = new int[MaxClients];
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i)) continue;
		
		if (!g_bPlayerEliminated[i])
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
				
				ArrayList arrayEnabledRounds = SpecialEnabledList();
				g_iSpecialRoundType = arrayEnabledRounds.Get(GetRandomInt(0, arrayEnabledRounds.Length-1));
				SetConVarInt(g_cvSpecialRoundOverride, g_iSpecialRoundType);
				SpecialRoundCycleFinish();
				delete arrayEnabledRounds;
			}
			else
			{
				NativeVotes_DisplayFail(menu, NativeVotesFail_Generic);
			}
		}
		case MenuAction_VoteEnd:
		{
			char sSpecialRound[64], sSpecialRoundName[64], display[120];
			NativeVotes_GetItem(menu, param1, sSpecialRound, sizeof(sSpecialRound), sSpecialRoundName, sizeof(sSpecialRoundName));
			
			CPrintToChatAll("{royalblue}%t{default}%t", "SF2 Prefix", "SF2 Special Round Vote Successful", sSpecialRoundName);
			FormatEx(display,120,"%t","SF2 Special Round Vote Successful", sSpecialRoundName);
			
			g_iSpecialRoundType = StringToInt(sSpecialRound);
			SetConVarInt(g_cvSpecialRoundOverride, g_iSpecialRoundType);
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
	g_bStarted = false;
	SF_RemoveAllSpecialRound();
}
void SpecialRoundReset()
{
	g_iSpecialRoundType = 0;
	g_hSpecialRoundTimer = INVALID_HANDLE;
	g_iSpecialRoundCycleNum = 0;
	g_flSpecialRoundCycleEndTime = -1.0;
}

bool IsSpecialRoundRunning()
{
	return g_bSpecialRound;
}

public void SpecialRoundInitializeAPI()
{
	CreateNative("SF2_IsSpecialRoundRunning", Native_IsSpecialRoundRunning);
	CreateNative("SF2_GetSpecialRoundType", Native_GetSpecialRoundType);
}

public int Native_IsSpecialRoundRunning(Handle plugin,int numParams)
{
	return view_as<bool>(g_bSpecialRound);
}

public int Native_GetSpecialRoundType(Handle plugin,int numParams)
{
	return g_iSpecialRoundType;
}