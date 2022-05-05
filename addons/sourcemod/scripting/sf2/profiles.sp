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

static ArrayList g_BossProfileList = null;
static ArrayList g_SelectableBossProfileList = null;
static ArrayList g_SelectableAdminBossProfileList = null;
static ArrayList g_SelectableBoxingBossProfileList = null;
static ArrayList g_SelectableRenevantBossProfileList = null;
static ArrayList g_SelectableRenevantBossAdminProfileList = null;
static ArrayList g_hSelectableBossProfileQueueList = null;

StringMap g_BossProfileNames = null;
ArrayList g_BossProfileData = null;

ConVar g_BossProfilePackConVar = null;
ConVar g_BossProfilePackDefaultConVar = null;

KeyValues g_BossPackConfig = null;

ConVar g_BossPackEndOfMapVoteConVar;
ConVar g_BossPackVoteStartTimeConVar;
ConVar g_BossPackVoteStartRoundConVar;
ConVar g_BossPackVoteShuffleConVar;

static bool g_BossPackVoteEnabled = false;

static char mapBossPack[64];

#include "sf2/profiles/profiles_boss_functions.sp"
#include "sf2/profiles/profile_chaser.sp"
#include "sf2/profiles/profile_statue.sp"

void InitializeBossProfiles()
{
	g_BossProfileNames = new StringMap();
	g_BossProfileData = new ArrayList(BossProfileData_MaxStats);
	
	g_BossProfilePackConVar = CreateConVar("sf2_boss_profile_pack", "", "The boss pack referenced in profiles_packs.cfg that should be loaded.", FCVAR_NOTIFY | FCVAR_DONTRECORD);
	g_BossProfilePackDefaultConVar = CreateConVar("sf2_boss_profile_pack_default", "", "If the boss pack defined in sf2_boss_profile_pack is blank or could not be loaded, this pack will be used instead.", FCVAR_NOTIFY);
	g_BossPackEndOfMapVoteConVar = CreateConVar("sf2_boss_profile_pack_endvote", "0", "Enables/Disables a boss pack vote at the end of the map.");
	g_BossPackVoteStartTimeConVar = CreateConVar("sf2_boss_profile_pack_endvote_start", "4", "Specifies when to start the vote based on time remaining on the map, in minutes.", FCVAR_NOTIFY);
	g_BossPackVoteStartRoundConVar = CreateConVar("sf2_boss_profile_pack_endvote_startround", "2", "Specifies when to start the vote based on rounds remaining on the map.", FCVAR_NOTIFY);
	g_BossPackVoteShuffleConVar = CreateConVar("sf2_boss_profile_pack_endvote_shuffle", "0", "Shuffles the menu options of boss pack endvotes if enabled.");
	
	InitializeStatueProfiles();
	InitializeChaserProfiles();
}
/*
Command
*/
public Action Command_Pack(int client,int args)
{
	if (!g_BossPackEndOfMapVoteConVar.BoolValue || !g_BossPackVoteEnabled)
	{
		CPrintToChat(client,"{red}Boss pack vote is disabled on this server.");
		return Plugin_Handled;
	}
	g_BossPackConfig.Rewind();
	if (!g_BossPackConfig.JumpToKey("packs"))
	{
		return Plugin_Handled;
	}
	if (!g_BossPackConfig.JumpToKey(mapBossPack))
	{
		return Plugin_Handled;
	}
	char bossPackName[64];
	g_BossPackConfig.GetString("name", bossPackName, sizeof(bossPackName), mapBossPack);
	if (bossPackName[0] == '\0')
	{
		FormatEx(bossPackName,sizeof(bossPackName),"Core Pack");
	}
	CPrintToChat(client,"{dodgerblue}Pack: {lightblue}%s",bossPackName);
	return Plugin_Handled;
}

public Action Command_NextPack(int client,int args)
{
	if (!g_BossPackEndOfMapVoteConVar.BoolValue || !g_BossPackVoteEnabled)
	{
		CPrintToChat(client,"{red}Boss pack vote is disabled on this server.");
		return Plugin_Handled;
	}

	char nextpack[128];
	g_BossProfilePackConVar.GetString(nextpack, sizeof(nextpack));

	if (strcmp(nextpack, "") == 0)
	{
		CPrintToChat(client,"{dodgerblue}%t{lightblue}%t.","SF2 Prefix","Pending Vote");
		return Plugin_Handled;
	}
	
	g_BossPackConfig.Rewind();
	if (!g_BossPackConfig.JumpToKey("packs"))
	{
		return Plugin_Handled;
	}
	if (!g_BossPackConfig.JumpToKey(nextpack))
	{
		return Plugin_Handled;
	}
	char bossPackName[64];
	g_BossPackConfig.GetString("name", bossPackName, sizeof(bossPackName), nextpack);
	if (bossPackName[0] == '\0')
	{
		FormatEx(bossPackName,sizeof(bossPackName),"Core Pack");
	}
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
	if (g_BossProfileList != null)
	{
		delete g_BossProfileList;
	}
	
	if (g_SelectableBossProfileList != null)
	{
		delete g_SelectableBossProfileList;
	}

	if (g_SelectableAdminBossProfileList != null)
	{
		delete g_SelectableAdminBossProfileList;
	}	

	if (g_SelectableBoxingBossProfileList != null)
	{
		delete g_SelectableBoxingBossProfileList;
	}
	
	if (g_SelectableRenevantBossProfileList != null)
	{
		delete g_SelectableRenevantBossProfileList;
	}
	
	if (g_SelectableRenevantBossAdminProfileList != null)
	{
		delete g_SelectableRenevantBossAdminProfileList;
	}
	
	g_BossProfileNames.Clear();
	g_BossProfileData.Clear();
	
	ClearChaserProfiles();
	ClearStatueProfiles();
}

void ReloadBossProfiles()
{
	if (g_Config != null)
	{
		delete g_Config;
	}
	
	if (g_BossPackConfig != null)
	{
		delete g_BossPackConfig;
	}
	
	// Clear and reload the lists.
	ClearBossProfiles();
	
	g_Config = new KeyValues("root");
	g_BossPackConfig = new KeyValues("root");
	
	if (g_BossProfileList == null)
	{
		g_BossProfileList = new ArrayList(SF2_MAX_PROFILE_NAME_LENGTH);
	}
	
	if (g_SelectableBossProfileList == null)
	{
		g_SelectableBossProfileList = new ArrayList(SF2_MAX_PROFILE_NAME_LENGTH);
	}
	
	if (g_SelectableAdminBossProfileList == null)
	{
		g_SelectableAdminBossProfileList = new ArrayList(SF2_MAX_PROFILE_NAME_LENGTH);
	}
	
	if (g_SelectableBoxingBossProfileList == null)
	{
		g_SelectableBoxingBossProfileList = new ArrayList(SF2_MAX_PROFILE_NAME_LENGTH);
	}
	
	if (g_SelectableRenevantBossProfileList == null)
	{
		g_SelectableRenevantBossProfileList = new ArrayList(SF2_MAX_PROFILE_NAME_LENGTH);
	}
	
	if (g_SelectableRenevantBossAdminProfileList == null)
	{
		g_SelectableRenevantBossAdminProfileList = new ArrayList(SF2_MAX_PROFILE_NAME_LENGTH);
	}
	
	if (g_hSelectableBossProfileQueueList != null)
	{
		delete g_hSelectableBossProfileQueueList;
	}
	
	char configPath[PLATFORM_MAX_PATH];
	
	// First load from configs/sf2/profiles.cfg or data/sf2/profiles.cfg
	if (!g_UseAlternateConfigDirectoryConVar.BoolValue)
	{
		BuildPath(Path_SM, configPath, sizeof(configPath), FILE_PROFILES);
	}
	else
	{
		BuildPath(Path_SM, configPath, sizeof(configPath), FILE_PROFILES_DATA);
	}
	LoadProfilesFromFile(configPath);
	
	// Then, load profiles individually from configs/sf2/profiles or data/sf2/profiles directory.
	if (!g_UseAlternateConfigDirectoryConVar.BoolValue)
	{
		LoadProfilesFromDirectory(FILE_PROFILES_DIR);
	}
	else
	{
		LoadProfilesFromDirectory(FILE_PROFILES_DIR_DATA);
	}

	if (!g_UseAlternateConfigDirectoryConVar.BoolValue)
	{
		BuildPath(Path_SM, configPath, sizeof(configPath), FILE_PROFILES_PACKS);
	}
	else
	{
		BuildPath(Path_SM, configPath, sizeof(configPath), FILE_PROFILES_PACKS_DATA);
	}
	FileToKeyValues(g_BossPackConfig, configPath);
	
	g_BossPackVoteEnabled = true;
	
	// Try loading boss packs, if they're set to load.
	g_BossPackConfig.Rewind();
	if (g_BossPackConfig.JumpToKey("packs"))
	{
		if (g_BossPackConfig.GotoFirstSubKey())
		{
			int endVoteItemCount = 0;
		
			g_BossProfilePackConVar.GetString(mapBossPack, sizeof(mapBossPack));
			
			bool voteBossPackLoaded = false;
			
			do
			{
				char bossPackName[128];
				g_BossPackConfig.GetSectionName(bossPackName, sizeof(bossPackName));
				
				bool autoLoad = view_as<bool>(g_BossPackConfig.GetNum("autoload"));
				
				if (autoLoad || (mapBossPack[0] != '\0' && strcmp(mapBossPack, bossPackName) == 0))
				{
					char packConfigFile[PLATFORM_MAX_PATH];
					g_BossPackConfig.GetString("file", packConfigFile, sizeof(packConfigFile));
					
					char packConfigFilePath[PLATFORM_MAX_PATH];
					if (!g_UseAlternateConfigDirectoryConVar.BoolValue)
					{
						FormatEx(packConfigFilePath, sizeof(packConfigFilePath), "%s/%s", FILE_PROFILES_PACKS_DIR, packConfigFile);
					}
					else
					{
						FormatEx(packConfigFilePath, sizeof(packConfigFilePath), "%s/%s", FILE_PROFILES_PACKS_DIR_DATA, packConfigFile);
					}
					
					BuildPath(Path_SM, configPath, sizeof(configPath), packConfigFilePath);

					if (DirExists(configPath))
					{
						FormatEx(packConfigFilePath, sizeof(packConfigFilePath), "%s/%s", !g_UseAlternateConfigDirectoryConVar.BoolValue ? FILE_PROFILES_PACKS_DIR : FILE_PROFILES_PACKS_DIR_DATA, packConfigFile);
						LoadProfilesFromDirectory(packConfigFilePath);
					}
					else if (FileExists(configPath))
					{
						LoadProfilesFromFile(configPath);
					}
					
					if (!voteBossPackLoaded)
					{
						if (strcmp(mapBossPack, bossPackName) == 0)
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
			while (g_BossPackConfig.GotoNextKey());
			
			g_BossPackConfig.GoBack();
			
			if (!voteBossPackLoaded)
			{
				g_BossProfilePackDefaultConVar.GetString(mapBossPack, sizeof(mapBossPack));
				if (mapBossPack[0] != '\0')
				{
					if (g_BossPackConfig.JumpToKey(mapBossPack))
					{
						char packConfigFile[PLATFORM_MAX_PATH];
						g_BossPackConfig.GetString("file", packConfigFile, sizeof(packConfigFile));
						
						char packConfigFilePath[PLATFORM_MAX_PATH];
						if (!g_UseAlternateConfigDirectoryConVar.BoolValue)
						{
							FormatEx(packConfigFilePath, sizeof(packConfigFilePath), "%s/%s", FILE_PROFILES_PACKS_DIR, packConfigFile);
						}
						else
						{
							FormatEx(packConfigFilePath, sizeof(packConfigFilePath), "%s/%s", FILE_PROFILES_PACKS_DIR_DATA, packConfigFile);
						}
						
						BuildPath(Path_SM, configPath, sizeof(configPath), packConfigFilePath);

						if (DirExists(configPath))
						{
							FormatEx(packConfigFilePath, sizeof(packConfigFilePath), "%s/%s", !g_UseAlternateConfigDirectoryConVar.BoolValue ? FILE_PROFILES_PACKS_DIR : FILE_PROFILES_PACKS_DIR_DATA, packConfigFile);
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
				g_BossPackVoteEnabled = false;
			}
		}
		else
		{
			g_BossPackVoteEnabled = false;
		}
	}
	else
	{
		g_BossPackVoteEnabled = false;
	}
	g_hSelectableBossProfileQueueList = g_SelectableBossProfileList.Clone();
	
	g_BossProfilePackConVar.SetString("");
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
			char profile[SF2_MAX_PROFILE_NAME_LENGTH];
			char profileLoadFailReason[512];
			
			int loadedCount = 0;
			
			do
			{
				kv.GetSectionName(profile, sizeof(profile));
				if (LoadBossProfile(kv, profile, profileLoadFailReason, sizeof(profileLoadFailReason)))
				{
					loadedCount++;
					LogSF2Message("%s...", profile);
				}
				else
				{
					LogSF2Message("%s...FAILED (reason: %s)", profile, profileLoadFailReason);
				}
			}
			while (kv.GotoNextKey());
			
			LogSF2Message("Loaded %d boss profile(s) from file!", loadedCount);
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
		{
			continue;
		}
		
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
 * @param disableWarning	Disables the warning if a file doesn't exist.
 */
void TryPrecacheBossProfileSoundPath(const char[] soundPath, bool disableWarning = false)
{
	if (soundPath[0] == '\0')
	{
		return;
	}
	
	char fullPath[PLATFORM_MAX_PATH];
	FormatEx(fullPath, sizeof(fullPath), "sound/%s", soundPath);

	if (FileExists(fullPath, false) || FileExists(fullPath, true))
	{
		PrecacheSound2(soundPath);
	}
	else
	{
		if (!disableWarning)
		{
			LogSF2Message("Sound file %s does not exist, excluding from downloads!", fullPath);
		}
		PrecacheSound(soundPath);
	}
}

Handle g_BossPackVoteMapTimer = null;
Handle g_BossPackVoteTimer = null;
static bool g_BossPackVoteCompleted;
static bool g_BossPackVoteStarted;

void InitializeBossPackVotes()
{
	g_BossPackVoteMapTimer = null;
	g_BossPackVoteTimer = null;
	g_BossPackVoteCompleted = false;
	g_BossPackVoteStarted = false;
}

void SetupTimeLimitTimerForBossPackVote()
{
	int time;
	if (GetMapTimeLeft(time) && time > 0)
	{
		if (g_BossPackEndOfMapVoteConVar.BoolValue && g_BossPackVoteEnabled && !g_BossPackVoteCompleted && !g_BossPackVoteStarted)
		{
			int startTime = g_BossPackVoteStartTimeConVar.IntValue * 60;
			if ((time - startTime) <= 0)
			{
				if (!NativeVotes_IsVoteInProgress())
				{
					InitiateBossPackVote(99);
				}
				else
				{
					g_BossPackVoteTimer = CreateTimer(5.0, Timer_BossPackVoteLoop, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				}
			}
			else
			{
				if (g_BossPackVoteMapTimer != null)
				{
					delete g_BossPackVoteMapTimer;
				}
				
				if (g_BossPackVoteMapTimer == null)
				{
					g_BossPackVoteMapTimer = CreateTimer(float(time - startTime), Timer_StartBossPackVote, _, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}
	}
}

void CheckRoundLimitForBossPackVote(int roundCount)
{
	if (!g_BossPackEndOfMapVoteConVar.BoolValue || !g_BossPackVoteEnabled || g_BossPackVoteStarted || g_BossPackVoteCompleted)
	{
		return;
	}
	
	if (g_MaxRoundsConVar == null)
	{
		return;
	}
	
	if (g_MaxRoundsConVar.IntValue > 0)
	{
		if (roundCount >= (g_MaxRoundsConVar.IntValue - g_BossPackVoteStartRoundConVar.IntValue))
		{
			if (!NativeVotes_IsVoteInProgress())
			{
				InitiateBossPackVote(99);
			}
			else
			{
				g_BossPackVoteTimer = CreateTimer(5.0, Timer_BossPackVoteLoop, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	
	//delete g_MaxRoundsConVar;
}

void InitiateBossPackVote(int initiator)
{
	if (initiator<33)//A admin called the command, it's probably for a good reason
	{
		g_BossPackVoteCompleted = false;
	}
	if (g_BossPackVoteStarted || g_BossPackVoteCompleted || NativeVotes_IsVoteInProgress())
	{

	}
	//PrintToChatAll("Start vote");
	// Gather boss packs, if any.
	if (g_BossPackConfig == null)
	{
		return;
	}
	
	g_BossPackConfig.Rewind();
	if (!g_BossPackConfig.JumpToKey("packs"))
	{
		return;
	}
	if (!g_BossPackConfig.GotoFirstSubKey())
	{
		return;
	}
	Handle voteMenu = NativeVotes_Create(Menu_BossPackVote, NativeVotesType_Custom_Mult);
	NativeVotes_SetInitiator(voteMenu, initiator);
	char title[255];
	FormatEx(title,255,"%t%t","SF2 Prefix","SF2 Boss Pack Vote Menu Title");
	NativeVotes_SetDetails(voteMenu,title);
	StringMap menuDisplayNamesTrie = new StringMap();
	ArrayList menuOptionsInfo = new ArrayList(128);
	
	do
	{
		if (!view_as<bool>(g_BossPackConfig.GetNum("autoload")) && view_as<bool>(g_BossPackConfig.GetNum("show_in_vote", 1)))
		{
			
			char bossPack[128];
			g_BossPackConfig.GetSectionName(bossPack, sizeof(bossPack));
			if (strcmp(bossPack,mapBossPack) != 0)
			{
				char bossPackName[64];
				g_BossPackConfig.GetString("name", bossPackName, sizeof(bossPackName), bossPack);
				
				menuDisplayNamesTrie.SetString(bossPack, bossPackName);
				menuOptionsInfo.PushString(bossPack);
			}
		}
	}
	while (g_BossPackConfig.GotoNextKey());
	
	if (menuOptionsInfo.Length == 0)
	{
		delete menuDisplayNamesTrie;
		delete menuOptionsInfo;
		delete voteMenu;
		return;
	}
	
	if (g_BossPackVoteShuffleConVar.BoolValue)
	{
		menuOptionsInfo.Sort(Sort_Random, Sort_String);
	}
	
	for (int i = 0; i < menuOptionsInfo.Length; i++)
	{
		if (i<=5)
		{
			char bossPack[128], bossPackName[64];
			menuOptionsInfo.GetString(i, bossPack, sizeof(bossPack));
			menuDisplayNamesTrie.GetString(bossPack, bossPackName, sizeof(bossPackName));
			NativeVotes_AddItem(voteMenu, bossPack, bossPackName);
		}
	}
	
	delete menuDisplayNamesTrie;
	delete menuOptionsInfo;
	
	g_BossPackVoteStarted = true;
	if (g_BossPackVoteMapTimer != null)
	{
		delete g_BossPackVoteMapTimer;
	}
	
	if (g_BossPackVoteTimer != null)
	{
		delete g_BossPackVoteTimer;
	}
	
	NativeVotes_DisplayToAll(voteMenu, 20);

	Call_StartForward(g_OnBossPackVoteStartFwd);
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
				char defaultPack[128];
				g_BossProfilePackDefaultConVar.GetString(defaultPack, sizeof(defaultPack));
				g_BossProfilePackConVar.SetString(defaultPack);
				//CPrintToChatAll("%t%t", "SF2 Prefix", "SF2 Boss Pack No Vote");
			}
			else
			{
				char defaultPack[128];
				g_BossProfilePackDefaultConVar.GetString(defaultPack, sizeof(defaultPack));
				g_BossProfilePackConVar.SetString(defaultPack);
				NativeVotes_DisplayFail(menu, NativeVotesFail_Generic);
			}
			g_BossPackVoteStarted = false;
		}
		case MenuAction_VoteStart:
		{
			g_BossPackVoteStarted = true;
		}
		case MenuAction_VoteEnd:
		{
			g_BossPackVoteCompleted = true;
		
			char bossPack[64], bossPackName[64], display[120];
			NativeVotes_GetItem(menu, param1, bossPack, sizeof(bossPack), bossPackName, sizeof(bossPackName));
			
			g_BossProfilePackConVar.SetString(bossPack);
			
			CPrintToChatAll("%t%t", "SF2 Prefix", "SF2 Boss Pack Vote Successful", bossPackName);
			FormatEx(display,120,"%t","SF2 Boss Pack Vote Successful", bossPackName);
			NativeVotes_DisplayPass(menu, display);
		}
		case MenuAction_End:
		{
			g_BossPackVoteStarted = false;
			delete menu;
		}
	}
}

public Action Timer_StartBossPackVote(Handle timer)
{
	if (timer != g_BossPackVoteMapTimer)
	{
		return Plugin_Stop;
	}
	
	g_BossPackVoteTimer = CreateTimer(5.0, Timer_BossPackVoteLoop, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_BossPackVoteTimer, true);

	return Plugin_Handled;
}

public Action Timer_BossPackVoteLoop(Handle timer)
{
	if (timer != g_BossPackVoteTimer || g_BossPackVoteCompleted || g_BossPackVoteStarted) 
	{
		return Plugin_Stop;
	}
	
	if (!NativeVotes_IsVoteInProgress())
	{
		g_BossPackVoteTimer = null;
		InitiateBossPackVote(99);
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

bool IsProfileValid(const char[] profile)
{
	return view_as<bool>((GetBossProfileList().FindString(profile) != -1));
}

stock int GetProfileNum(const char[] profile, const char[] keyValue,int defaultValue=0)
{
	if (!IsProfileValid(profile))
	{
		return defaultValue;
	}
	
	g_Config.Rewind();
	g_Config.JumpToKey(profile);
	
	return g_Config.GetNum(keyValue, defaultValue);
}

stock float GetProfileFloat(const char[] profile, const char[] keyValue, float defaultValue=0.0)
{
	if (!IsProfileValid(profile))
	{
		return defaultValue;
	}
	
	g_Config.Rewind();
	g_Config.JumpToKey(profile);
	
	return g_Config.GetFloat(keyValue, defaultValue);
}

stock bool GetProfileVector(const char[] profile, const char[] keyValue, float buffer[3], const float defaultValue[3]=NULL_VECTOR)
{
	for (int i = 0; i < 3; i++) buffer[i] = defaultValue[i];
	
	if (!IsProfileValid(profile))
	{
		return false;
	}
	
	g_Config.Rewind();
	g_Config.JumpToKey(profile);
	
	g_Config.GetVector(keyValue, buffer, defaultValue);
	return true;
}

stock bool GetProfileColor(const char[] profile, 
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
	
	if (!IsProfileValid(profile))
	{
		return false;
	}
	
	g_Config.Rewind();
	g_Config.JumpToKey(profile);
	
	char sValue[64];
	g_Config.GetString(keyValue, sValue, sizeof(sValue));
	
	if (sValue[0] != '\0')
	{
		g_Config.GetColor(keyValue, r, g, b, a);
	}
	
	return true;
}

stock bool GetProfileString(const char[] profile, const char[] keyValue, char[] buffer,int bufferLen, const char[] defaultValue="")
{
	strcopy(buffer, bufferLen, defaultValue);
	
	if (!IsProfileValid(profile))
	{
		return false;
	}
	
	g_Config.Rewind();
	g_Config.JumpToKey(profile);
	
	g_Config.GetString(keyValue, buffer, bufferLen, defaultValue);
	return true;
}

// Code originally from FF2. Credits to the original authors Rainbolt Dash and FlaminSarge.
stock bool GetRandomStringFromProfile(const char[] profile, const char[] strKeyValue, char[] buffer,int bufferLen,int index = -1,int attackIndex = -1,int &result = 0)
{
	buffer[0] = '\0';
	result = 0;
	
	if (!IsProfileValid(profile))
	{
		return false;
	}
	
	g_Config.Rewind();
	if (!g_Config.JumpToKey(profile))
	{
		return false;
	}
	if (!g_Config.JumpToKey(strKeyValue))
	{
		return false;
	}
	
	char s[32], s2[PLATFORM_MAX_PATH], s3[3], s4[PLATFORM_MAX_PATH], s5[3];
	int i = 1;
	if (attackIndex != -1)
	{
		FormatEx(s3, sizeof(s3), "%d", attackIndex);
		FormatEx(s5, sizeof(s5), "%d", attackIndex);
		g_Config.GetString(s5, s4, sizeof(s4));
		if (s4[0] == '\0')
		{
			if (g_Config.JumpToKey(s3))
			{
				for (;;)
				{
					FormatEx(s, sizeof(s), "%d", i);
					g_Config.GetString(s, s2, sizeof(s2));
					if (s2[0] == '\0')
					{
						break;
					}

					i++;
				}
			}
			else
			{
				for (;;)
				{
					FormatEx(s, sizeof(s), "%d", i);
					g_Config.GetString(s, s2, sizeof(s2));
					if (s2[0] == '\0')
					{
						break;
					}
						
					i++;
				}
			}
		}
		else
		{
			for (;;)
			{
				FormatEx(s, sizeof(s), "%d", i);
				g_Config.GetString(s, s2, sizeof(s2));
				if (s2[0] == '\0')
				{
					break;
				}
					
				i++;
			}
		}
	}
	else
	{
		for (;;)
		{
			FormatEx(s, sizeof(s), "%d", i);
			g_Config.GetString(s, s2, sizeof(s2));
			if (s2[0] == '\0')
			{
				break;
			}
				
			i++;
		}
	}

	if (i == 1)
	{
		return false;
	}
	int randomReturn = GetRandomInt(1, i - 1);
	FormatEx(s, sizeof(s), "%d", index < 0 ? randomReturn : index);
	g_Config.GetString(s, buffer, bufferLen);
	result = randomReturn;
	return true;
}

/**
 *	Returns an array of strings of the profile names of every valid boss.
 */
ArrayList GetBossProfileList()
{
	return g_BossProfileList;
}

/**
 *	Returns an array of strings of the profile names of every valid boss that can be randomly selected.
 */
ArrayList GetSelectableBossProfileList()
{
	return g_SelectableBossProfileList;
}

ArrayList GetSelectableBoxingBossProfileList()
{
	return g_SelectableBoxingBossProfileList;
}

ArrayList GetSelectableAdminBossProfileList()
{
	return g_SelectableAdminBossProfileList;
}

ArrayList GetSelectableRenevantBossProfileList()
{
	return g_SelectableRenevantBossProfileList;
}

ArrayList GetSelectableRenevantBossAdminProfileList()
{
	return g_SelectableRenevantBossAdminProfileList;
}

bool GetRandomRenevantBossProfile(char[] sBuffer, int iBufferLen)
{
	if (g_SelectableRenevantBossProfileList.Length == 0)
	{
		return false;
	}

	g_SelectableRenevantBossProfileList.GetString(GetRandomInt(0, g_SelectableRenevantBossProfileList.Length - 1), sBuffer, iBufferLen);
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
	{
		g_hSelectableBossProfileQueueList = GetSelectableBossProfileList().Clone();
	}

	return g_hSelectableBossProfileQueueList;
}

void RemoveBossProfileFromQueueList(const char[] profile)
{
	int selectIndex = GetSelectableBossProfileQueueList().FindString(profile);
	if (selectIndex != -1)
	{
		GetSelectableBossProfileQueueList().Erase(selectIndex);
	}
}