#if defined _sf2_profiles_included
 #endinput
#endif
#define _sf2_profiles_included

#define FILE_PROFILES "configs/sf2/profiles.cfg"
#define FILE_PROFILES_DIR "configs/sf2/profiles"
#define FILE_PROFILES_PACKS "configs/sf2/profiles_packs.cfg"
#define FILE_PROFILES_PACKS_DIR "configs/sf2/profiles/packs"

#define FILE_PROFILES_DATA "data/sf2/profiles.cfg"
#define FILE_PROFILES_DIR_DATA "data/sf2/profiles"
#define FILE_PROFILES_PACKS_DATA "data/sf2/profiles_packs.cfg"
#define FILE_PROFILES_PACKS_DIR_DATA "data/sf2/profiles/packs"

static ArrayList g_hBossProfileList = null;
static ArrayList g_hSelectableBossProfileList = null;
static ArrayList g_hSelectableAdminBossProfileList = null;
static ArrayList g_hSelectableBoxingBossProfileList = null;
static ArrayList g_hSelectableRenevantBossProfileList = null;
static ArrayList g_hSelectableRenevantBossAdminProfileList = null;
static ArrayList g_hSelectableBossProfileQueueList = null;

StringMap g_hBossProfileNames = null;
ArrayList g_hBossProfileData = null;

ConVar g_cvBossProfilePack = null;
ConVar g_cvBossProfilePackDefault = null;

KeyValues g_hBossPackConfig = null;

ConVar g_cvBossPackEndOfMapVote;
ConVar g_cvBossPackVoteStartTime;
ConVar g_cvBossPackVoteStartRound;
ConVar g_cvBossPackVoteShuffle;

static bool g_bBossPackVoteEnabled = false;

static char MapbossPack[64];

#include "sf2/profiles/profile_chaser.sp"

void InitializeBossProfiles()
{
	g_hBossProfileNames = new StringMap();
	g_hBossProfileData = new ArrayList(BossProfileData_MaxStats);
	
	g_cvBossProfilePack = CreateConVar("sf2_boss_profile_pack", "", "The boss pack referenced in profiles_packs.cfg that should be loaded.", FCVAR_NOTIFY | FCVAR_DONTRECORD);
	g_cvBossProfilePackDefault = CreateConVar("sf2_boss_profile_pack_default", "", "If the boss pack defined in sf2_boss_profile_pack is blank or could not be loaded, this pack will be used instead.", FCVAR_NOTIFY);
	g_cvBossPackEndOfMapVote = CreateConVar("sf2_boss_profile_pack_endvote", "0", "Enables/Disables a boss pack vote at the end of the map.");
	g_cvBossPackVoteStartTime = CreateConVar("sf2_boss_profile_pack_endvote_start", "4", "Specifies when to start the vote based on time remaining on the map, in minutes.", FCVAR_NOTIFY);
	g_cvBossPackVoteStartRound = CreateConVar("sf2_boss_profile_pack_endvote_startround", "2", "Specifies when to start the vote based on rounds remaining on the map.", FCVAR_NOTIFY);
	g_cvBossPackVoteShuffle = CreateConVar("sf2_boss_profile_pack_endvote_shuffle", "0", "Shuffles the menu options of boss pack endvotes if enabled.");
	
	InitializeChaserProfiles();
}
/*
Command
*/
public Action Command_Pack(int client,int args)
{
	if (!g_cvBossPackEndOfMapVote.BoolValue || !g_bBossPackVoteEnabled)
	{
		CPrintToChat(client,"{red}Boss pack vote is disabled on this server.");
		return Plugin_Handled;
	}
	g_hBossPackConfig.Rewind();
	if(!g_hBossPackConfig.JumpToKey("packs"))
		return Plugin_Handled;
	if(!g_hBossPackConfig.JumpToKey(MapbossPack))
		return Plugin_Handled;
	char bossPackName[64];
	g_hBossPackConfig.GetString("name", bossPackName, sizeof(bossPackName), MapbossPack);
	if(bossPackName[0] == '\0')
		FormatEx(bossPackName,sizeof(bossPackName),"Core Pack");
	CPrintToChat(client,"{dodgerblue}Pack: {lightblue}%s",bossPackName);
	return Plugin_Handled;
}

public Action Command_NextPack(int client,int args)
{
	if (!g_cvBossPackEndOfMapVote.BoolValue || !g_bBossPackVoteEnabled)
	{
		CPrintToChat(client,"{red}Boss pack vote is disabled on this server.");
		return Plugin_Handled;
	}

	char nextpack[128];
	g_cvBossProfilePack.GetString(nextpack, sizeof(nextpack));

	if (strcmp(nextpack, "") == 0)
	{
		CPrintToChat(client,"{dodgerblue}%t{lightblue}%t.","SF2 Prefix","Pending Vote");
		return Plugin_Handled;
	}
	
	g_hBossPackConfig.Rewind();
	if(!g_hBossPackConfig.JumpToKey("packs"))
		return Plugin_Handled;
	if(!g_hBossPackConfig.JumpToKey(nextpack))
		return Plugin_Handled;
	char bossPackName[64];
	g_hBossPackConfig.GetString("name", bossPackName, sizeof(bossPackName), nextpack);
	if(bossPackName[0] == '\0')
		FormatEx(bossPackName,sizeof(bossPackName),"Core Pack");
	CPrintToChat(client,"{dodgerblue}Next pack: {lightblue}%s",bossPackName);
	return Plugin_Handled;
}

void BossProfilesOnMapEnd()
{
	ClearBossProfiles();
}

/**
 *	Clears all data and memory currently in use by all boss profiles.
 */
void ClearBossProfiles()
{
	if (g_hBossProfileList != null)
	{
		delete g_hBossProfileList;
	}
	
	if (g_hSelectableBossProfileList != null)
	{
		delete g_hSelectableBossProfileList;
	}

	if (g_hSelectableAdminBossProfileList != null)
	{
		delete g_hSelectableAdminBossProfileList;
	}	

	if (g_hSelectableBoxingBossProfileList != null)
	{
		delete g_hSelectableBoxingBossProfileList;
	}
	
	if (g_hSelectableRenevantBossProfileList != null)
	{
		delete g_hSelectableRenevantBossProfileList;
	}
	
	if (g_hSelectableRenevantBossAdminProfileList != null)
	{
		delete g_hSelectableRenevantBossAdminProfileList;
	}
	
	g_hBossProfileNames.Clear();
	g_hBossProfileData.Clear();
	
	ClearChaserProfiles();
}

void ReloadBossProfiles()
{
	if (g_hConfig != null)
	{
		delete g_hConfig;
	}
	
	if (g_hBossPackConfig != null)
	{
		delete g_hBossPackConfig;
	}
	
	// Clear and reload the lists.
	ClearBossProfiles();
	
	g_hConfig = new KeyValues("root");
	g_hBossPackConfig = new KeyValues("root");
	
	if (g_hBossProfileList == null)
	{
		g_hBossProfileList = new ArrayList(SF2_MAX_PROFILE_NAME_LENGTH);
	}
	
	if (g_hSelectableBossProfileList == null)
	{
		g_hSelectableBossProfileList = new ArrayList(SF2_MAX_PROFILE_NAME_LENGTH);
	}
	
	if (g_hSelectableAdminBossProfileList == null)
	{
		g_hSelectableAdminBossProfileList = new ArrayList(SF2_MAX_PROFILE_NAME_LENGTH);
	}
	
	if (g_hSelectableBoxingBossProfileList == null)
	{
		g_hSelectableBoxingBossProfileList = new ArrayList(SF2_MAX_PROFILE_NAME_LENGTH);
	}
	
	if (g_hSelectableRenevantBossProfileList == null)
	{
		g_hSelectableRenevantBossProfileList = new ArrayList(SF2_MAX_PROFILE_NAME_LENGTH);
	}
	
	if (g_hSelectableRenevantBossAdminProfileList == null)
	{
		g_hSelectableRenevantBossAdminProfileList = new ArrayList(SF2_MAX_PROFILE_NAME_LENGTH);
	}
	
	if (g_hSelectableBossProfileQueueList != null)
	{
		delete g_hSelectableBossProfileQueueList;
	}
	
	char configPath[PLATFORM_MAX_PATH];
	
	// First load from configs/sf2/profiles.cfg or data/sf2/profiles.cfg
	if (!g_cvUseAlternateConfigDirectory.BoolValue) BuildPath(Path_SM, configPath, sizeof(configPath), FILE_PROFILES);
	else BuildPath(Path_SM, configPath, sizeof(configPath), FILE_PROFILES_DATA);
	LoadProfilesFromFile(configPath);
	
	// Then, load profiles individually from configs/sf2/profiles or data/sf2/profiles directory.
	if (!g_cvUseAlternateConfigDirectory.BoolValue) LoadProfilesFromDirectory(FILE_PROFILES_DIR);
	else LoadProfilesFromDirectory(FILE_PROFILES_DIR_DATA);

	if (!g_cvUseAlternateConfigDirectory.BoolValue) BuildPath(Path_SM, configPath, sizeof(configPath), FILE_PROFILES_PACKS);
	else BuildPath(Path_SM, configPath, sizeof(configPath), FILE_PROFILES_PACKS_DATA);
	FileToKeyValues(g_hBossPackConfig, configPath);
	
	g_bBossPackVoteEnabled = true;
	
	// Try loading boss packs, if they're set to load.
	g_hBossPackConfig.Rewind();
	if (g_hBossPackConfig.JumpToKey("packs"))
	{
		if (g_hBossPackConfig.GotoFirstSubKey())
		{
			int endVoteItemCount = 0;
		
			g_cvBossProfilePack.GetString(MapbossPack, sizeof(MapbossPack));
			
			bool voteBossPackLoaded = false;
			
			do
			{
				char bossPackName[128];
				g_hBossPackConfig.GetSectionName(bossPackName, sizeof(bossPackName));
				
				bool autoLoad = view_as<bool>(g_hBossPackConfig.GetNum("autoload"));
				
				if (autoLoad || (MapbossPack[0] != '\0' && strcmp(MapbossPack, bossPackName) == 0))
				{
					char packConfigFile[PLATFORM_MAX_PATH];
					g_hBossPackConfig.GetString("file", packConfigFile, sizeof(packConfigFile));
					
					char packConfigFilePath[PLATFORM_MAX_PATH];
					if (!g_cvUseAlternateConfigDirectory.BoolValue) FormatEx(packConfigFilePath, sizeof(packConfigFilePath), "%s/%s", FILE_PROFILES_PACKS_DIR, packConfigFile);
					else FormatEx(packConfigFilePath, sizeof(packConfigFilePath), "%s/%s", FILE_PROFILES_PACKS_DIR_DATA, packConfigFile);
					
					BuildPath(Path_SM, configPath, sizeof(configPath), packConfigFilePath);

					if (DirExists(configPath))
					{
						FormatEx(packConfigFilePath, sizeof(packConfigFilePath), "%s/%s", !g_cvUseAlternateConfigDirectory.BoolValue ? FILE_PROFILES_PACKS_DIR : FILE_PROFILES_PACKS_DIR_DATA, packConfigFile);
						LoadProfilesFromDirectory(packConfigFilePath);
					}
					else if (FileExists(configPath))
					{
						LoadProfilesFromFile(configPath);
					}
					
					if (!voteBossPackLoaded)
					{
						if (strcmp(MapbossPack, bossPackName) == 0)
						{
							voteBossPackLoaded = true;
						}
					}
				}
				
				if (!autoLoad)
				{
					endVoteItemCount++; 
				}
			}
			while (g_hBossPackConfig.GotoNextKey());
			
			g_hBossPackConfig.GoBack();
			
			if (!voteBossPackLoaded)
			{
				g_cvBossProfilePackDefault.GetString(MapbossPack, sizeof(MapbossPack));
				if (MapbossPack[0] != '\0')
				{
					if (g_hBossPackConfig.JumpToKey(MapbossPack))
					{
						char packConfigFile[PLATFORM_MAX_PATH];
						g_hBossPackConfig.GetString("file", packConfigFile, sizeof(packConfigFile));
						
						char packConfigFilePath[PLATFORM_MAX_PATH];
						if (!g_cvUseAlternateConfigDirectory.BoolValue) FormatEx(packConfigFilePath, sizeof(packConfigFilePath), "%s/%s", FILE_PROFILES_PACKS_DIR, packConfigFile);
						else FormatEx(packConfigFilePath, sizeof(packConfigFilePath), "%s/%s", FILE_PROFILES_PACKS_DIR_DATA, packConfigFile);
						
						BuildPath(Path_SM, configPath, sizeof(configPath), packConfigFilePath);

						if (DirExists(configPath))
						{
							FormatEx(packConfigFilePath, sizeof(packConfigFilePath), "%s/%s", !g_cvUseAlternateConfigDirectory.BoolValue ? FILE_PROFILES_PACKS_DIR : FILE_PROFILES_PACKS_DIR_DATA, packConfigFile);
							LoadProfilesFromDirectory(packConfigFilePath);
						}
						else if (FileExists(configPath))
						{
							LoadProfilesFromFile(configPath);
						}
					}
				}
			}
			
			if (endVoteItemCount <= 0)
			{
				g_bBossPackVoteEnabled = false;
			}
		}
		else
		{
			g_bBossPackVoteEnabled = false;
		}
	}
	else
	{
		g_bBossPackVoteEnabled = false;
	}
	g_hSelectableBossProfileQueueList = g_hSelectableBossProfileList.Clone();
	
	g_cvBossProfilePack.SetString("");
}

static void LoadProfilesFromFile(const char[] configPath)
{
	LogSF2Message("Loading boss profiles from file %s...", configPath);
	
	if (!FileExists(configPath))
	{
		LogSF2Message("File not found! Skipping...");
		return;
	}
	
	KeyValues kv = new KeyValues("root");
	if (!FileToKeyValues(kv, configPath))
	{
		delete kv;
		LogSF2Message("Unexpected error while reading file! Skipping...");
		return;
	}
	else
	{
		if (KvGotoFirstSubKey(kv))
		{
			char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			char sProfileLoadFailReason[512];
			
			int iLoadedCount = 0;
			
			do
			{
				kv.GetSectionName(sProfile, sizeof(sProfile));
				if (LoadBossProfile(kv, sProfile, sProfileLoadFailReason, sizeof(sProfileLoadFailReason)))
				{
					iLoadedCount++;
					LogSF2Message("%s...", sProfile);
				}
				else
				{
					LogSF2Message("%s...FAILED (reason: %s)", sProfile, sProfileLoadFailReason);
				}
			}
			while (kv.GotoNextKey());
			
			LogSF2Message("Loaded %d boss profile(s) from file!", iLoadedCount);
		}
		else
		{
			LogSF2Message("No boss profiles loaded from file!");
		}
		
		delete kv;
	}
}

/**
 * Loads a profile from the specified file.
 */
static bool LoadProfileFile(const char[] profilePath, char[] profileName, int profileNameLen, char[] errorReason, int errorReasonLen)
{
	if (!FileExists(profilePath))
	{
		strcopy(errorReason, errorReasonLen, "File not found.");
		return false;
	}

	KeyValues kv = new KeyValues("root");
	if (!FileToKeyValues(kv, profilePath))
	{
		delete kv;
		strcopy(errorReason, errorReasonLen, "Parsing failed. Check the formatting of your file!");
		return false;
	}

	kv.GetSectionName(profileName, profileNameLen);

	bool result = LoadBossProfile(kv, profileName, errorReason, errorReasonLen);

	delete kv;

	return result;
}

static void LoadProfilesFromDirectory(const char[] relDirPath)
{
	LogSF2Message("Loading boss profile files from directory %s...", relDirPath);

	char dirPath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, dirPath, sizeof(dirPath), relDirPath);

	if (!DirExists(dirPath))
	{
		LogSF2Message("%s does not exist, skipping.", dirPath);
		return;
	}

	DirectoryListing directory = OpenDirectory(dirPath);
	if (directory == null)
	{
		LogSF2Message("%s directory could not be read, skipping.", dirPath);
		return;
	}

	int count = 0;

	char filePath[PLATFORM_MAX_PATH];
	char fileName[PLATFORM_MAX_PATH];
	char profileName[SF2_MAX_PROFILE_NAME_LENGTH];
	char errorReason[512];
	FileType fileType;

	while (directory.GetNext(fileName, sizeof(fileName), fileType))
	{
		if (fileType == FileType_Directory)
			continue;
		
		FormatEx(filePath, sizeof(filePath), "%s/%s", relDirPath, fileName);
		BuildPath(Path_SM, filePath, sizeof(filePath), filePath);

		if (!LoadProfileFile(filePath, profileName, sizeof(profileName), errorReason, sizeof(errorReason)))
		{
			LogSF2Message("%s...FAILED (reason: %s)", filePath, errorReason);
		}
		else 
		{
			LogSF2Message("%s...", profileName, filePath);
			count++;
		}
	}

	delete directory;

	LogSF2Message("Loaded %d boss profile(s) from directory!", count, relDirPath);
}

/**
 * Attempts to precache a sound path, a path relative to sound/ folder.
 *
 * If the sound file exists within the server files, the file is added to the downloads table.
 *
 * @param soundPath		Path to sound, relative to sound/ folder.
 */
void TryPrecacheBossProfileSoundPath(const char[] soundPath)
{
	if (soundPath[0] == '\0')
		return;
	
	char fullPath[PLATFORM_MAX_PATH];
	FormatEx(fullPath, sizeof(fullPath), "sound/%s", soundPath);

	if (FileExists(fullPath, false) || FileExists(fullPath, true))
	{
		PrecacheSound2(soundPath);
	}
	else
	{
		LogSF2Message("Sound file %s does not exist, excluding from downloads!", fullPath);
		PrecacheSound(soundPath);
	}
}

Handle g_hBossPackVoteMapTimer = null;
Handle g_hBossPackVoteTimer = null;
static bool g_bBossPackVoteCompleted;
static bool g_bBossPackVoteStarted;

void InitializeBossPackVotes()
{
	g_hBossPackVoteMapTimer = null;
	g_hBossPackVoteTimer = null;
	g_bBossPackVoteCompleted = false;
	g_bBossPackVoteStarted = false;
}

void SetupTimeLimitTimerForBossPackVote()
{
	int time;
	if (GetMapTimeLeft(time) && time > 0)
	{
		if (g_cvBossPackEndOfMapVote.BoolValue && g_bBossPackVoteEnabled && !g_bBossPackVoteCompleted && !g_bBossPackVoteStarted)
		{
			int startTime = g_cvBossPackVoteStartTime.IntValue * 60;
			if ((time - startTime) <= 0)
			{
				if (!NativeVotes_IsVoteInProgress())
				{
					InitiateBossPackVote(99);
				}
				else
				{
					g_hBossPackVoteTimer = CreateTimer(5.0, Timer_BossPackVoteLoop, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				}
			}
			else
			{
				if (g_hBossPackVoteMapTimer != null)
				{
					delete g_hBossPackVoteMapTimer;
				}
				
				if (g_hBossPackVoteMapTimer == null) g_hBossPackVoteMapTimer = CreateTimer(float(time - startTime), Timer_StartBossPackVote, _, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
}

void CheckRoundLimitForBossPackVote(int roundCount)
{
	if (!g_cvBossPackEndOfMapVote.BoolValue || !g_bBossPackVoteEnabled || g_bBossPackVoteStarted || g_bBossPackVoteCompleted) return;
	
	if (g_cvMaxRounds == null) return;
	
	if (g_cvMaxRounds.IntValue > 0)
	{
		if (roundCount >= (g_cvMaxRounds.IntValue - g_cvBossPackVoteStartRound.IntValue))
		{
			if (!NativeVotes_IsVoteInProgress())
			{
				InitiateBossPackVote(99);
			}
			else
			{
				g_hBossPackVoteTimer = CreateTimer(5.0, Timer_BossPackVoteLoop, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	
	// CloseHandle(g_cvMaxRounds);
}

void InitiateBossPackVote(int Initiator)
{
	if(Initiator<33)//A admin called the command, it's probably for a good reason
		g_bBossPackVoteCompleted = false;
	if (g_bBossPackVoteStarted || g_bBossPackVoteCompleted || NativeVotes_IsVoteInProgress()) return;
	//PrintToChatAll("Start vote");
	// Gather boss packs, if any.
	if (g_hBossPackConfig == null) return;
	
	g_hBossPackConfig.Rewind();
	if (!g_hBossPackConfig.JumpToKey("packs")) return;
	if (!g_hBossPackConfig.GotoFirstSubKey()) return;
	Handle voteMenu = NativeVotes_Create(Menu_BossPackVote, NativeVotesType_Custom_Mult);
	NativeVotes_SetInitiator(voteMenu, Initiator);
	char Tittle[255];
	FormatEx(Tittle,255,"%t%t","SF2 Prefix","SF2 Boss Pack Vote Menu Title");
	NativeVotes_SetDetails(voteMenu,Tittle);
	StringMap menuDisplayNamesTrie = new StringMap();
	ArrayList menuOptionsInfo = new ArrayList(128);
	
	do
	{
		if (!view_as<bool>(g_hBossPackConfig.GetNum("autoload")) && view_as<bool>(g_hBossPackConfig.GetNum("show_in_vote", 1)))
		{
			
			char bossPack[128];
			g_hBossPackConfig.GetSectionName(bossPack, sizeof(bossPack));
			if(strcmp(bossPack,MapbossPack) != 0)
			{
				char bossPackName[64];
				g_hBossPackConfig.GetString("name", bossPackName, sizeof(bossPackName), bossPack);
				
				menuDisplayNamesTrie.SetString(bossPack, bossPackName);
				menuOptionsInfo.PushString(bossPack);
			}
		}
	}
	while (g_hBossPackConfig.GotoNextKey());
	
	if (menuOptionsInfo.Length == 0)
	{
		delete menuDisplayNamesTrie;
		delete menuOptionsInfo;
		delete voteMenu;
		return;
	}
	
	if (g_cvBossPackVoteShuffle.BoolValue)
	{
		menuOptionsInfo.Sort(Sort_Random, Sort_String);
	}
	
	for (int i = 0; i < menuOptionsInfo.Length; i++)
	{
		if(i<=5)
		{
			char bossPack[128], bossPackName[64];
			menuOptionsInfo.GetString(i, bossPack, sizeof(bossPack));
			menuDisplayNamesTrie.GetString(bossPack, bossPackName, sizeof(bossPackName));
			NativeVotes_AddItem(voteMenu, bossPack, bossPackName);
		}
	}
	
	delete menuDisplayNamesTrie;
	delete menuOptionsInfo;
	
	g_bBossPackVoteStarted = true;
	if (g_hBossPackVoteMapTimer != null)
	{
		delete g_hBossPackVoteMapTimer;
	}
	
	if (g_hBossPackVoteTimer != null)
	{
		delete g_hBossPackVoteTimer;
	}
	
	NativeVotes_DisplayToAll(voteMenu, 20);

	Call_StartForward(fOnBossPackVoteStart);
	Call_Finish();
}
public int Menu_BossPackVote(Handle menu, MenuAction action,int param1,int param2)
{
	switch (action)
	{
		
		case MenuAction_VoteCancel:
		{
			if (param1 == VoteCancel_NoVotes)
			{
				NativeVotes_DisplayFail(menu, NativeVotesFail_NotEnoughVotes);
				char defaultpack[128];
				g_cvBossProfilePackDefault.GetString(defaultpack, sizeof(defaultpack));
				g_cvBossProfilePack.SetString(defaultpack);
				//CPrintToChatAll("%t%t", "SF2 Prefix", "SF2 Boss Pack No Vote");
			}
			else
			{
				char defaultpack[128];
				g_cvBossProfilePackDefault.GetString(defaultpack, sizeof(defaultpack));
				g_cvBossProfilePack.SetString(defaultpack);
				NativeVotes_DisplayFail(menu, NativeVotesFail_Generic);
			}
			g_bBossPackVoteStarted = false;
		}
		case MenuAction_VoteStart:
		{
			g_bBossPackVoteStarted = true;
		}
		case MenuAction_VoteEnd:
		{
			g_bBossPackVoteCompleted = true;
		
			char bossPack[64], bossPackName[64], display[120];
			NativeVotes_GetItem(menu, param1, bossPack, sizeof(bossPack), bossPackName, sizeof(bossPackName));
			
			g_cvBossProfilePack.SetString(bossPack);
			
			CPrintToChatAll("%t%t", "SF2 Prefix", "SF2 Boss Pack Vote Successful", bossPackName);
			FormatEx(display,120,"%t","SF2 Boss Pack Vote Successful", bossPackName);
			NativeVotes_DisplayPass(menu, display);
		}
		case MenuAction_End:
		{
			g_bBossPackVoteStarted = false;
			delete menu;
		}
	}
}

public Action Timer_StartBossPackVote(Handle timer)
{
	if (timer != g_hBossPackVoteMapTimer) return Plugin_Stop;
	
	g_hBossPackVoteTimer = CreateTimer(5.0, Timer_BossPackVoteLoop, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_hBossPackVoteTimer, true);

	return Plugin_Handled;
}

public Action Timer_BossPackVoteLoop(Handle timer)
{
	if (timer != g_hBossPackVoteTimer || g_bBossPackVoteCompleted || g_bBossPackVoteStarted) 
		return Plugin_Stop;
	
	if (!NativeVotes_IsVoteInProgress())
	{
		g_hBossPackVoteTimer = null;
		InitiateBossPackVote(99);
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

bool IsProfileValid(const char[] sProfile)
{
	return view_as<bool>((GetBossProfileList().FindString(sProfile) != -1));
}

stock int GetProfileNum(const char[] sProfile, const char[] keyValue,int defaultValue=0)
{
	if (!IsProfileValid(sProfile)) return defaultValue;
	
	g_hConfig.Rewind();
	g_hConfig.JumpToKey(sProfile);
	
	return g_hConfig.GetNum(keyValue, defaultValue);
}

stock float GetProfileFloat(const char[] sProfile, const char[] keyValue, float defaultValue=0.0)
{
	if (!IsProfileValid(sProfile)) return defaultValue;
	
	g_hConfig.Rewind();
	g_hConfig.JumpToKey(sProfile);
	
	return g_hConfig.GetFloat(keyValue, defaultValue);
}

stock bool GetProfileVector(const char[] sProfile, const char[] keyValue, float buffer[3], const float defaultValue[3]=NULL_VECTOR)
{
	for (int i = 0; i < 3; i++) buffer[i] = defaultValue[i];
	
	if (!IsProfileValid(sProfile)) return false;
	
	g_hConfig.Rewind();
	g_hConfig.JumpToKey(sProfile);
	
	g_hConfig.GetVector(keyValue, buffer, defaultValue);
	return true;
}

stock bool GetProfileColor(const char[] sProfile, 
	const char[] keyValue, 
	int &r, 
	int &g, 
	int &b, 
	int &a,
	int dr=255,
	int dg=255,
	int db=255,
	int da=255)
{
	r = dr;
	g = dg;
	b = db;
	a = da;
	
	if (!IsProfileValid(sProfile)) return false;
	
	g_hConfig.Rewind();
	g_hConfig.JumpToKey(sProfile);
	
	char sValue[64];
	g_hConfig.GetString(keyValue, sValue, sizeof(sValue));
	
	if (sValue[0] != '\0')
	{
		g_hConfig.GetColor(keyValue, r, g, b, a);
	}
	
	return true;
}

stock bool GetProfileString(const char[] sProfile, const char[] keyValue, char[] buffer,int bufferlen, const char[] defaultValue="")
{
	strcopy(buffer, bufferlen, defaultValue);
	
	if (!IsProfileValid(sProfile)) return false;
	
	g_hConfig.Rewind();
	g_hConfig.JumpToKey(sProfile);
	
	g_hConfig.GetString(keyValue, buffer, bufferlen, defaultValue);
	return true;
}

// Code originally from FF2. Credits to the original authors Rainbolt Dash and FlaminSarge.
stock bool GetRandomStringFromProfile(const char[] sProfile, const char[] strKeyValue, char[] buffer,int bufferlen,int index = -1,int iAttackIndex = -1,int &result = 0)
{
	buffer[0] = '\0';
	result = 0;
	
	if (!IsProfileValid(sProfile)) return false;
	
	g_hConfig.Rewind();
	if (!g_hConfig.JumpToKey(sProfile)) return false;
	if (!g_hConfig.JumpToKey(strKeyValue)) return false;
	
	char s[32], s2[PLATFORM_MAX_PATH], s3[3], s4[PLATFORM_MAX_PATH], s5[3];
	int i = 1;
	if (iAttackIndex != -1)
	{
		FormatEx(s3, sizeof(s3), "%d", iAttackIndex);
		FormatEx(s5, sizeof(s5), "%d", iAttackIndex);
		g_hConfig.GetString(s5, s4, sizeof(s4));
		if (s4[0] == '\0')
		{
			if (g_hConfig.JumpToKey(s3))
			{
				for (;;)
				{
					FormatEx(s, sizeof(s), "%d", i);
					g_hConfig.GetString(s, s2, sizeof(s2));
					if (s2[0] == '\0') break;

					i++;
				}
			}
			else
			{
				for (;;)
				{
					FormatEx(s, sizeof(s), "%d", i);
					g_hConfig.GetString(s, s2, sizeof(s2));
					if (s2[0] == '\0') break;
						
					i++;
				}
			}
		}
		else
		{
			for (;;)
			{
				FormatEx(s, sizeof(s), "%d", i);
				g_hConfig.GetString(s, s2, sizeof(s2));
				if (s2[0] == '\0') break;
					
				i++;
			}
		}
	}
	else
	{
		for (;;)
		{
			FormatEx(s, sizeof(s), "%d", i);
			g_hConfig.GetString(s, s2, sizeof(s2));
			if (s2[0] == '\0') break;
				
			i++;
		}
	}

	if (i == 1) return false;
	int iRandomReturn = GetRandomInt(1, i - 1);
	FormatEx(s, sizeof(s), "%d", index < 0 ? iRandomReturn : index);
	g_hConfig.GetString(s, buffer, bufferlen);
	result = iRandomReturn;
	return true;
}

/**
 *	Returns an array of strings of the profile names of every valid boss.
 */
ArrayList GetBossProfileList()
{
	return g_hBossProfileList;
}

/**
 *	Returns an array of strings of the profile names of every valid boss that can be randomly selected.
 */
ArrayList GetSelectableBossProfileList()
{
	return g_hSelectableBossProfileList;
}

ArrayList GetSelectableBoxingBossProfileList()
{
	return g_hSelectableBoxingBossProfileList;
}

ArrayList GetSelectableAdminBossProfileList()
{
	return g_hSelectableAdminBossProfileList;
}

ArrayList GetSelectableRenevantBossProfileList()
{
	return g_hSelectableRenevantBossProfileList;
}

ArrayList GetSelectableRenevantBossAdminProfileList()
{
	return g_hSelectableRenevantBossAdminProfileList;
}

bool GetRandomRenevantBossProfile(char[] sBuffer, int iBufferLen)
{
	if (g_hSelectableRenevantBossProfileList.Length == 0)
		return false;

	GetArrayString(g_hSelectableRenevantBossProfileList, GetRandomInt(0, g_hSelectableRenevantBossProfileList.Length - 1), sBuffer, iBufferLen);
	return true;
}

/**
 * Returns an array of boss that didn't play in game yet.
 */
ArrayList GetSelectableBossProfileQueueList()
{
	if (g_hSelectableBossProfileQueueList.Length <= 0) //If every boss were selected at least once, refill the list.
	{
		delete g_hSelectableBossProfileQueueList;
		g_hSelectableBossProfileQueueList = GetSelectableBossProfileList().Clone();
	}

	if (g_hSelectableBossProfileQueueList == null)
		g_hSelectableBossProfileQueueList = GetSelectableBossProfileList().Clone();

	return g_hSelectableBossProfileQueueList;
}

void RemoveBossProfileFromQueueList(const char[] sProfile)
{
	int selectIndex = GetSelectableBossProfileQueueList().FindString(sProfile);
	if (selectIndex != -1)
	{
		GetSelectableBossProfileQueueList().Erase(selectIndex);
	}
}