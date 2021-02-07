#if defined _sf2_profiles_included
 #endinput
#endif
#define _sf2_profiles_included

#define FILE_PROFILES "configs/sf2/profiles.cfg"
#define FILE_PROFILES_DIR "configs/sf2/profiles"
#define FILE_PROFILES_PACKS "configs/sf2/profiles_packs.cfg"
#define FILE_PROFILES_PACKS_DIR "configs/sf2/profiles/packs"
#define FILE_PROFILES_PACKS_ALT "configs/sf2/profiles/bosses"

static ArrayList g_hBossProfileList = null;
static ArrayList g_hSelectableBossProfileList = null;
static ArrayList g_hSelectableBoxingBossProfileList = null;
static ArrayList g_hSelectableRenevantBossProfileList = null;
static ArrayList g_hSelectableBossProfileQueueList = null;

static StringMap g_hBossProfileNames = null;
static ArrayList g_hBossProfileData = null;

ConVar g_cvBossProfilePack = null;
ConVar g_cvBossProfilePackDefault = null;

KeyValues g_hBossPackConfig = null;

ConVar g_cvBossPackEndOfMapVote;
ConVar g_cvBossPackVoteStartTime;
ConVar g_cvBossPackVoteStartRound;
ConVar g_cvBossPackVoteShuffle;

static bool g_bBossPackVoteEnabled = false;

static char MapbossPack[64];

methodmap SF2BaseBossProfile
{
	property int Index
	{
		public get() { return view_as<int>(this); }
	}
	
	property int UniqueProfileIndex
	{
		public get() { return GetBossProfileUniqueProfileIndex(this.Index); }
	}

	property int Skin
	{
		public get() { return GetBossProfileSkin(this.Index); }
	}
	
	property int SkinMax
	{
		public get() { return GetBossProfileSkinMax(this.Index); }
	}
	
	property int BodyGroups
	{
		public get() { return GetBossProfileBodyGroups(this.Index); }
	}
	
	property float ModelScale
	{
		public get() { return GetBossProfileModelScale(this.Index); }
	}
	
	property int Type
	{
		public get() { return GetBossProfileType(this.Index); }
	}
	
	property int Flags
	{
		public get() { return GetBossProfileFlags(this.Index); }
	}
	
	property int UseRaidHitbox
	{
		public get() { return GetBossProfileRaidHitbox(this.Index); }
	}
	
	property int OutlineColorR
	{
		public get() { return GetBossProfileOutlineColorR(this.Index); }
	}
	
	property int OutlineColorG
	{
		public get() { return GetBossProfileOutlineColorG(this.Index); }
	}
	
	property int OutlineColorB
	{
		public get() { return GetBossProfileOutlineColorB(this.Index); }
	}
	
	property int OutlineTransparency
	{
		public get() { return GetBossProfileOutlineTransparency(this.Index); }
	}

	property float FOV
	{
		public get() { return GetBossProfileFOV(this.Index); }
	}
	
	property float TurnRate
	{
		public get() { return GetBossProfileTurnRate(this.Index); }
	}
	
	property float AngerStart
	{
		public get() { return GetBossProfileAngerStart(this.Index); }
	}
	
	property float AngerAddOnPageGrab
	{
		public get() { return GetBossProfileAngerAddOnPageGrab(this.Index); }
	}
	
	property float AngerAddOnPageGrabTimeDiff
	{
		public get() { return GetBossProfileAngerPageGrabTimeDiff(this.Index); }
	}
	
	property float InstantKillRadius
	{
		public get() { return GetBossProfileInstantKillRadius(this.Index); }
	}
	
	property float ScareRadius
	{
		public get() { return GetBossProfileScareRadius(this.Index); }
	}
	
	property float ScareCooldown
	{
		public get() { return GetBossProfileScareCooldown(this.Index); }
	}
	
	property int TeleportType
	{
		public get() { return GetBossProfileTeleportType(this.Index); }
	}
	
	public float GetSpeed(int difficulty)
	{
		return GetBossProfileSpeed(this.Index, difficulty);
	}
	
	public float GetMaxSpeed(int difficulty)
	{
		return GetBossProfileMaxSpeed(this.Index, difficulty);
	}
	
	public void GetEyePositionOffset(float buffer[3])
	{
		GetBossProfileEyePositionOffset(this.Index, buffer);
	}
	
	public void GetEyeAngleOffset(float buffer[3])
	{
		GetBossProfileEyeAngleOffset(this.Index, buffer);
	}

}

#include "sf2/profiles/profile_chaser.sp"

enum
{
	BossProfileData_UniqueProfileIndex,
	BossProfileData_Type,
	BossProfileData_ModelScale,
	BossProfileData_Health,
	BossProfileData_Skin,
	BossProfileData_SkinMax,
	BossProfileData_Body,
	BossProfileData_Flags,
	BossProfileData_UseRaidHitbox,
	
	BossProfileData_SpeedEasy,
	BossProfileData_SpeedNormal,
	BossProfileData_SpeedHard,
	BossProfileData_SpeedInsane,
	BossProfileData_SpeedNightmare,
	BossProfileData_SpeedApollyon,

	BossProfileData_MaxSpeedEasy,
	BossProfileData_MaxSpeedNormal,
	BossProfileData_MaxSpeedHard,
	BossProfileData_MaxSpeedInsane,
	BossProfileData_MaxSpeedNightmare,
	BossProfileData_MaxSpeedApollyon,
	
	BossProfileData_IdleLifetimeEasy,
	BossProfileData_IdleLifetimeNormal,
	BossProfileData_IdleLifetimeHard,
	BossProfileData_IdleLifetimeInsane,
	BossProfileData_IdleLifetimeNightmare,
	BossProfileData_IdleLifetimeApollyon,

	BossProfileData_SearchRange,
	BossProfileData_SearchRangeEasy,
	BossProfileData_SearchRangeHard,
	BossProfileData_SearchRangeInsane,
	BossProfileData_SearchRangeNightmare,
	BossProfileData_SearchRangeApollyon,

	BossProfileData_SearchSoundRange,
	BossProfileData_SearchSoundRangeEasy,
	BossProfileData_SearchSoundRangeHard,
	BossProfileData_SearchSoundRangeInsane,
	BossProfileData_SearchSoundRangeNightmare,
	BossProfileData_SearchSoundRangeApollyon,
	
	BossProfileData_FieldOfView,
	BossProfileData_TurnRate,
	BossProfileData_EyePosOffsetX,
	BossProfileData_EyePosOffsetY,
	BossProfileData_EyePosOffsetZ,
	BossProfileData_EyeAngOffsetX,
	BossProfileData_EyeAngOffsetY,
	BossProfileData_EyeAngOffsetZ,
	BossProfileData_AngerStart,
	BossProfileData_AngerAddOnPageGrab,
	BossProfileData_AngerPageGrabTimeDiffReq,
	BossProfileData_InstantKillRadius,
	
	BossProfileData_EnableCustomizableOutlines,
	BossProfileData_OutlineColorR,
	BossProfileData_OutlineColorG,
	BossProfileData_OutlineColorB,
	BossProfileData_OutlineColorTrans,
	
	BossProfileData_ScareRadius,
	BossProfileData_ScareCooldown,

	BossProfileData_StaticRadiusEasy,
	BossProfileData_StaticRadiusNormal,
	BossProfileData_StaticRadiusHard,
	BossProfileData_StaticRadiusInsane,
	BossProfileData_StaticRadiusNightmare,
	BossProfileData_StaticRadiusApollyon,

	BossProfileData_TeleportRangeMinEasy,
	BossProfileData_TeleportRangeMinNormal,
	BossProfileData_TeleportRangeMinHard,
	BossProfileData_TeleportRangeMinInsane,
	BossProfileData_TeleportRangeMinNightmare,
	BossProfileData_TeleportRangeMinApollyon,

	BossProfileData_TeleportRangeMaxEasy,
	BossProfileData_TeleportRangeMaxNormal,
	BossProfileData_TeleportRangeMaxHard,
	BossProfileData_TeleportRangeMaxInsane,
	BossProfileData_TeleportRangeMaxNightmare,
	BossProfileData_TeleportRangeMaxApollyon,

	BossProfileData_TeleportTimeMinEasy,
	BossProfileData_TeleportTimeMinNormal,
	BossProfileData_TeleportTimeMinHard,
	BossProfileData_TeleportTimeMinInsane,
	BossProfileData_TeleportTimeMinNightmare,
	BossProfileData_TeleportTimeMinApollyon,
	
	BossProfileData_TeleportTimeMaxEasy,
	BossProfileData_TeleportTimeMaxNormal,
	BossProfileData_TeleportTimeMaxHard,
	BossProfileData_TeleportTimeMaxInsane,
	BossProfileData_TeleportTimeMaxNightmare,
	BossProfileData_TeleportTimeMaxApollyon,

	BossProfileData_JumpscareDistanceEasy,
	BossProfileData_JumpscareDistanceNormal,
	BossProfileData_JumpscareDistanceHard,
	BossProfileData_JumpscareDistanceInsane,
	BossProfileData_JumpscareDistanceNightmare,
	BossProfileData_JumpscareDistanceApollyon,

	BossProfileData_JumpscareDurationEasy,
	BossProfileData_JumpscareDurationNormal,
	BossProfileData_JumpscareDurationHard,
	BossProfileData_JumpscareDurationInsane,
	BossProfileData_JumpscareDurationNightmare,
	BossProfileData_JumpscareDurationApollyon,

	BossProfileData_JumpscareCooldownEasy,
	BossProfileData_JumpscareCooldownNormal,
	BossProfileData_JumpscareCooldownHard,
	BossProfileData_JumpscareCooldownInsane,
	BossProfileData_JumpscareCooldownNightmare,
	BossProfileData_JumpscareCooldownApollyon,

	BossProfileData_TeleportType,
	BossProfileData_MaxStats
};

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
	KvRewind(g_hBossPackConfig);
	if(!KvJumpToKey(g_hBossPackConfig, "packs"))
		return Plugin_Handled;
	if(!KvJumpToKey(g_hBossPackConfig, MapbossPack))
		return Plugin_Handled;
	char bossPackName[64];
	KvGetString(g_hBossPackConfig, "name", bossPackName, sizeof(bossPackName), MapbossPack);
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
	
	KvRewind(g_hBossPackConfig);
	if(!KvJumpToKey(g_hBossPackConfig, "packs"))
		return Plugin_Handled;
	if(!KvJumpToKey(g_hBossPackConfig, nextpack))
		return Plugin_Handled;
	char bossPackName[64];
	KvGetString(g_hBossPackConfig, "name", bossPackName, sizeof(bossPackName), nextpack);
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
		g_hBossProfileList = null;
	}
	
	if (g_hSelectableBossProfileList != null)
	{
		delete g_hSelectableBossProfileList;
		g_hSelectableBossProfileList = null;
	}
	
	if (g_hSelectableBoxingBossProfileList != null)
	{
		delete g_hSelectableBoxingBossProfileList;
		g_hSelectableBoxingBossProfileList = null;
	}
	
	if (g_hSelectableRenevantBossProfileList != null)
	{
		delete g_hSelectableRenevantBossProfileList;
		g_hSelectableRenevantBossProfileList = null;
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
		g_hConfig = null;
	}
	
	if (g_hBossPackConfig != null)
	{
		delete g_hBossPackConfig;
		g_hBossPackConfig = null;
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
	
	if (g_hSelectableBoxingBossProfileList == null)
	{
		g_hSelectableBoxingBossProfileList = new ArrayList(SF2_MAX_PROFILE_NAME_LENGTH);
	}
	
	if (g_hSelectableRenevantBossProfileList == null)
	{
		g_hSelectableRenevantBossProfileList = new ArrayList(SF2_MAX_PROFILE_NAME_LENGTH);
	}
	
	if (g_hSelectableBossProfileQueueList != null)
	{
		delete g_hSelectableBossProfileQueueList;
	}
	
	char configPath[PLATFORM_MAX_PATH];
	
	// First load from configs/sf2/profiles.cfg
	BuildPath(Path_SM, configPath, sizeof(configPath), FILE_PROFILES);
	LoadProfilesFromFile(configPath);
	
	// Then, load profiles individually from configs/sf2/profiles directory.
	LoadProfilesFromDirectory(FILE_PROFILES_DIR);

	BuildPath(Path_SM, configPath, sizeof(configPath), FILE_PROFILES_PACKS);
	FileToKeyValues(g_hBossPackConfig, configPath);
	
	g_bBossPackVoteEnabled = true;
	
	// Try loading boss packs, if they're set to load.
	KvRewind(g_hBossPackConfig);
	if (KvJumpToKey(g_hBossPackConfig, "packs"))
	{
		if (KvGotoFirstSubKey(g_hBossPackConfig))
		{
			int endVoteItemCount = 0;
		
			g_cvBossProfilePack.GetString(MapbossPack, sizeof(MapbossPack));
			
			bool voteBossPackLoaded = false;
			
			do
			{
				char bossPackName[128];
				KvGetSectionName(g_hBossPackConfig, bossPackName, sizeof(bossPackName));
				
				bool autoLoad = view_as<bool>(KvGetNum(g_hBossPackConfig, "autoload"));
				
				if (autoLoad || (MapbossPack[0] != '\0' && strcmp(MapbossPack, bossPackName) == 0))
				{
					char packConfigFile[PLATFORM_MAX_PATH];
					KvGetString(g_hBossPackConfig, "file", packConfigFile, sizeof(packConfigFile));
					
					char packConfigFilePath[PLATFORM_MAX_PATH];
					FormatEx(packConfigFilePath, sizeof(packConfigFilePath), "%s/%s", FILE_PROFILES_PACKS_DIR, packConfigFile);
					
					BuildPath(Path_SM, configPath, sizeof(configPath), packConfigFilePath);

					if (DirExists(configPath))
					{
						FormatEx(packConfigFilePath, sizeof(packConfigFilePath), "%s/%s", FILE_PROFILES_PACKS_DIR, packConfigFile);
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
			while (KvGotoNextKey(g_hBossPackConfig));
			
			KvGoBack(g_hBossPackConfig);
			
			if (!voteBossPackLoaded)
			{
				g_cvBossProfilePackDefault.GetString(MapbossPack, sizeof(MapbossPack));
				if (MapbossPack[0] != '\0')
				{
					if (KvJumpToKey(g_hBossPackConfig, MapbossPack))
					{
						char packConfigFile[PLATFORM_MAX_PATH];
						KvGetString(g_hBossPackConfig, "file", packConfigFile, sizeof(packConfigFile));
						
						char packConfigFilePath[PLATFORM_MAX_PATH];
						FormatEx(packConfigFilePath, sizeof(packConfigFilePath), "%s/%s", FILE_PROFILES_PACKS_DIR, packConfigFile);
						
						BuildPath(Path_SM, configPath, sizeof(configPath), packConfigFilePath);

						if (DirExists(configPath))
						{
							FormatEx(packConfigFilePath, sizeof(packConfigFilePath), "%s/%s", FILE_PROFILES_PACKS_DIR, packConfigFile);
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
				KvGetSectionName(kv, sProfile, sizeof(sProfile));
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
			while (KvGotoNextKey(kv));
			
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

	KvGetSectionName(kv, profileName, profileNameLen);

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
	if (!soundPath[0])
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

/**
 *	Loads a profile in the current KeyValues position in kv.
 */
static bool LoadBossProfile(KeyValues kv, const char[] sProfile, char[] sLoadFailReasonBuffer, int iLoadFailReasonBufferLen)
{
	int iBossType = KvGetNum(kv, "type", SF2BossType_Unknown);
	if (iBossType == SF2BossType_Unknown || iBossType >= SF2BossType_MaxTypes) 
	{
		FormatEx(sLoadFailReasonBuffer, iLoadFailReasonBufferLen, "boss type is unknown!");
		return false;
	}
	
	float flBossModelScale = KvGetFloat(kv, "model_scale", 1.0);
	if (flBossModelScale <= 0.0)
	{
		FormatEx(sLoadFailReasonBuffer, iLoadFailReasonBufferLen, "model_scale must be a value greater than 0!");
		return false;
	}
	
	int iBossHealth = KvGetNum(kv, "health", 30000);
	if (iBossHealth < 1)
	{
		FormatEx(sLoadFailReasonBuffer, iLoadFailReasonBufferLen, "health must be a value that is at least 1!");
		return false;
	}
	
	int iBossSkin = KvGetNum(kv, "skin", 0);
	if (iBossSkin < 0)
	{
		FormatEx(sLoadFailReasonBuffer, iLoadFailReasonBufferLen, "skin must be a value that is at least 0!");
		return false;
	}
	
	int iBossSkinMax = KvGetNum(kv, "skin_max", 0);
	if (iBossSkinMax < 0)
	{
		FormatEx(sLoadFailReasonBuffer, iLoadFailReasonBufferLen, "skin_max must be a value that is at least 0!");
		return false;
	}
	
	int iBossBodyGroups = KvGetNum(kv, "body");
	if (iBossBodyGroups < 0)
	{
		FormatEx(sLoadFailReasonBuffer, iLoadFailReasonBufferLen, "body must be a value that is at least 0!");
		return false;
	}
	
	int iUseRaidHitbox = KvGetNum(kv, "use_raid_hitbox");
	if (iUseRaidHitbox < 0)
	{
		iUseRaidHitbox = 0;
	}
	else if (iUseRaidHitbox > 1)
	{
		iUseRaidHitbox = 1;
	}

	float flBossAngerStart = KvGetFloat(kv, "anger_start", 1.0);
	if (flBossAngerStart < 0.0)
	{
		FormatEx(sLoadFailReasonBuffer, iLoadFailReasonBufferLen, "anger_start must be a value that is at least 0!");
		return false;
	}
	
	float flBossInstantKillRadius = KvGetFloat(kv, "kill_radius");
	if (flBossInstantKillRadius < 0.0)
	{
		FormatEx(sLoadFailReasonBuffer, iLoadFailReasonBufferLen, "kill_radius must be a value that is at least 0!");
		return false;
	}
	
	float flBossScareRadius = KvGetFloat(kv, "scare_radius");
	if (flBossScareRadius < 0.0)
	{
		FormatEx(sLoadFailReasonBuffer, iLoadFailReasonBufferLen, "scare_radius must be a value that is at least 0!");
		return false;
	}
	
	int iBossTeleportType = KvGetNum(kv, "teleport_type");
	if (iBossTeleportType < 0)
	{
		FormatEx(sLoadFailReasonBuffer, iLoadFailReasonBufferLen, "unknown teleport type!");
		return false;
	}
	
	FormatEx(sLoadFailReasonBuffer, iLoadFailReasonBufferLen, "unknown!");
	
	float flBossFOV = KvGetFloat(kv, "fov", 90.0);
	if (flBossFOV < 0.0)
	{
		flBossFOV = 0.0;
	}
	else if (flBossFOV > 360.0)
	{
		flBossFOV = 360.0;
	}
	
	float flBossMaxTurnRate = KvGetFloat(kv, "turnrate", 90.0);
	if (flBossMaxTurnRate < 0.0)
	{
		flBossMaxTurnRate = 0.0;
	}
	
	float flBossScareCooldown = KvGetFloat(kv, "scare_cooldown");
	if (flBossScareCooldown < 0.0)
	{
		// clamp value 
		flBossScareCooldown = 0.0;
	}
	
	float flBossAngerAddOnPageGrab = KvGetFloat(kv, "anger_add_on_page_grab", -1.0);
	if (flBossAngerAddOnPageGrab < 0.0)
	{
		flBossAngerAddOnPageGrab = KvGetFloat(kv, "anger_page_add", -1.0);		// backwards compatibility
		if (flBossAngerAddOnPageGrab < 0.0)
		{
			flBossAngerAddOnPageGrab = 0.0;
		}
	}
	
	float flBossAngerPageGrabTimeDiffReq = KvGetFloat(kv, "anger_req_page_grab_time_diff", -1.0);
	if (flBossAngerPageGrabTimeDiffReq < 0.0)
	{
		flBossAngerPageGrabTimeDiffReq = KvGetFloat(kv, "anger_page_time_diff", -1.0);		// backwards compatibility
		if (flBossAngerPageGrabTimeDiffReq < 0.0)
		{
			flBossAngerPageGrabTimeDiffReq = 0.0;
		}
	}
	
	float flBossSearchRadius = KvGetFloat(kv, "search_range", 1024.0);
	float flBossSearchRadiusEasy = KvGetFloat(kv, "search_range_easy", flBossSearchRadius);
	float flBossSearchRadiusHard = KvGetFloat(kv, "search_range_hard", flBossSearchRadius);
	float flBossSearchRadiusInsane = KvGetFloat(kv, "search_range_insane", flBossSearchRadiusHard);
	float flBossSearchRadiusNightmare = KvGetFloat(kv, "search_range_nightmare", flBossSearchRadiusInsane);
	float flBossSearchRadiusApollyon = KvGetFloat(kv, "search_range_apollyon", flBossSearchRadiusNightmare);

	float flBossSearchSoundRadius = KvGetFloat(kv, "search_sound_range", 1024.0);
	float flBossSearchSoundRadiusEasy = KvGetFloat(kv, "search_sound_range_easy", flBossSearchSoundRadius);
	float flBossSearchSoundRadiusHard = KvGetFloat(kv, "search_sound_range_hard", flBossSearchSoundRadius);
	float flBossSearchSoundRadiusInsane = KvGetFloat(kv, "search_sound_range_insane", flBossSearchSoundRadiusHard);
	float flBossSearchSoundRadiusNightmare = KvGetFloat(kv, "search_sound_range_nightmare", flBossSearchSoundRadiusInsane);
	float flBossSearchSoundRadiusApollyon = KvGetFloat(kv, "search_sound_range_apollyon", flBossSearchSoundRadiusNightmare);

	float flBossTeleportRangeMin = KvGetFloat(kv, "teleport_range_min", 325.0);
	float flBossTeleportRangeMinEasy = KvGetFloat(kv, "teleport_range_min_easy", flBossTeleportRangeMin);
	float flBossTeleportRangeMinHard = KvGetFloat(kv, "teleport_range_min_hard", flBossTeleportRangeMin);
	float flBossTeleportRangeMinInsane = KvGetFloat(kv, "teleport_range_min_insane", flBossTeleportRangeMinHard);
	float flBossTeleportRangeMinNightmare = KvGetFloat(kv, "teleport_range_min_nightmare", flBossTeleportRangeMinInsane);
	float flBossTeleportRangeMinApollyon = KvGetFloat(kv, "teleport_range_min_apollyon", flBossTeleportRangeMinNightmare);

	float flBossTeleportRangeMax = KvGetFloat(kv, "teleport_range_max", 1024.0);
	float flBossTeleportRangeMaxEasy = KvGetFloat(kv, "teleport_range_max_easy", flBossTeleportRangeMax);
	float flBossTeleportRangeMaxHard = KvGetFloat(kv, "teleport_range_max_hard", flBossTeleportRangeMax);
	float flBossTeleportRangeMaxInsane = KvGetFloat(kv, "teleport_range_max_insane", flBossTeleportRangeMaxHard);
	float flBossTeleportRangeMaxNightmare = KvGetFloat(kv, "teleport_range_max_nightmare", flBossTeleportRangeMaxInsane);
	float flBossTeleportRangeMaxApollyon = KvGetFloat(kv, "teleport_range_max_apollyon", flBossTeleportRangeMaxNightmare);

	float flBossTeleportTimeMin = KvGetFloat(kv, "teleport_time_min", 5.0);
	float flBossTeleportTimeMinEasy = KvGetFloat(kv, "teleport_time_min_easy", flBossTeleportTimeMin);
	float flBossTeleportTimeMinHard = KvGetFloat(kv, "teleport_time_min_hard", flBossTeleportTimeMin);
	float flBossTeleportTimeMinInsane = KvGetFloat(kv, "teleport_time_min_insane", flBossTeleportTimeMinHard);
	float flBossTeleportTimeMinNightmare = KvGetFloat(kv, "teleport_time_min_nightmare", flBossTeleportTimeMinInsane);
	float flBossTeleportTimeMinApollyon = KvGetFloat(kv, "teleport_time_min_apollyon", flBossTeleportTimeMinNightmare);

	float flBossTeleportTimeMax = KvGetFloat(kv, "teleport_time_max", 9.0);
	float flBossTeleportTimeMaxEasy = KvGetFloat(kv, "teleport_time_max_easy", flBossTeleportTimeMax);
	float flBossTeleportTimeMaxHard = KvGetFloat(kv, "teleport_time_max_hard", flBossTeleportTimeMax);
	float flBossTeleportTimeMaxInsane = KvGetFloat(kv, "teleport_time_max_insane", flBossTeleportTimeMaxHard);
	float flBossTeleportTimeMaxNightmare = KvGetFloat(kv, "teleport_time_max_nightmare", flBossTeleportTimeMaxInsane);
	float flBossTeleportTimeMaxApollyon = KvGetFloat(kv, "teleport_time_max_apollyon", flBossTeleportTimeMaxNightmare);

	float flBossJumpscareDistance = KvGetFloat(kv, "jumpscare_distance");
	float flBossJumpscareDistanceEasy = KvGetFloat(kv, "jumpscare_distance_easy", flBossJumpscareDistance);
	float flBossJumpscareDistanceHard = KvGetFloat(kv, "jumpscare_distance_hard", flBossJumpscareDistance);
	float flBossJumpscareDistanceInsane = KvGetFloat(kv, "jumpscare_distance_insane", flBossJumpscareDistanceHard);
	float flBossJumpscareDistanceNightmare = KvGetFloat(kv, "jumpscare_distance_nightmare", flBossJumpscareDistanceInsane);
	float flBossJumpscareDistanceApollyon = KvGetFloat(kv, "jumpscare_distance_apollyon", flBossJumpscareDistanceNightmare);

	float flBossJumpscareDuration = KvGetFloat(kv, "jumpscare_duration");
	float flBossJumpscareDurationEasy = KvGetFloat(kv, "jumpscare_duration_easy", flBossJumpscareDistance);
	float flBossJumpscareDurationHard = KvGetFloat(kv, "jumpscare_duration_hard", flBossJumpscareDistance);
	float flBossJumpscareDurationInsane = KvGetFloat(kv, "jumpscare_duration_insane", flBossJumpscareDurationHard);
	float flBossJumpscareDurationNightmare = KvGetFloat(kv, "jumpscare_duration_nightmare", flBossJumpscareDurationInsane);
	float flBossJumpscareDurationApollyon = KvGetFloat(kv, "jumpscare_duration_apollyon", flBossJumpscareDurationNightmare);

	float flBossJumpscareCooldown = KvGetFloat(kv, "jumpscare_cooldown");
	float flBossJumpscareCooldownEasy = KvGetFloat(kv, "jumpscare_cooldown_easy", flBossJumpscareCooldown);
	float flBossJumpscareCooldownHard = KvGetFloat(kv, "jumpscare_cooldown_hard", flBossJumpscareCooldown);
	float flBossJumpscareCooldownInsane = KvGetFloat(kv, "jumpscare_cooldown_insane", flBossJumpscareCooldownHard);
	float flBossJumpscareCooldownNightmare = KvGetFloat(kv, "jumpscare_cooldown_nightmare", flBossJumpscareCooldownInsane);
	float flBossJumpscareCooldownApollyon = KvGetFloat(kv, "jumpscare_cooldown_apollyon", flBossJumpscareCooldownNightmare);

	/*Deprecated stuff*/
	if (KvGetFloat(kv, "jump_cooldown", 0.0) != 0.0)
	{
		PrintToServer("\"jump_cooldown\" is marked as deprecated, please remove it from the profile.");
	}
	
	float flBossDefaultSpeed = KvGetFloat(kv, "speed", 150.0);
	float flBossSpeedEasy = KvGetFloat(kv, "speed_easy", flBossDefaultSpeed);
	float flBossSpeedHard = KvGetFloat(kv, "speed_hard", flBossDefaultSpeed);
	float flBossSpeedInsane = KvGetFloat(kv, "speed_insane", flBossSpeedHard);
	float flBossSpeedNightmare = KvGetFloat(kv, "speed_nightmare", flBossSpeedInsane);
	float flBossSpeedApollyon = KvGetFloat(kv, "speed_apollyon", flBossSpeedNightmare);
	
	float flBossDefaultMaxSpeed = KvGetFloat(kv, "speed_max", 150.0);
	float flBossMaxSpeedEasy = KvGetFloat(kv, "speed_max_easy", flBossDefaultMaxSpeed);
	float flBossMaxSpeedHard = KvGetFloat(kv, "speed_max_hard", flBossDefaultMaxSpeed);
	float flBossMaxSpeedInsane = KvGetFloat(kv, "speed_max_insane", flBossMaxSpeedHard);
	float flBossMaxSpeedNightmare = KvGetFloat(kv, "speed_max_nightmare", flBossMaxSpeedInsane);
	float flBossMaxSpeedApollyon = KvGetFloat(kv, "speed_max_apollyon", flBossMaxSpeedNightmare);
	
	float flBossDefaultIdleLifetime = KvGetFloat(kv, "idle_lifetime", 10.0);
	float flBossIdleLifetimeEasy = KvGetFloat(kv, "idle_lifetime_easy", flBossDefaultIdleLifetime);
	float flBossIdleLifetimeHard = KvGetFloat(kv, "idle_lifetime_hard", flBossDefaultIdleLifetime);
	float flBossIdleLifetimeInsane = KvGetFloat(kv, "idle_lifetime_insane", flBossIdleLifetimeHard);
	float flBossIdleLifetimeNightmare = KvGetFloat(kv, "idle_lifetime_nightmare", flBossIdleLifetimeInsane);
	float flBossIdleLifetimeApollyon = KvGetFloat(kv, "idle_lifetime_apollyon", flBossIdleLifetimeNightmare);
	
	bool bUseCustomOutlines = view_as<bool>(KvGetNum(kv, "customizable_outlines"));
	int iOutlineColorR = KvGetNum(kv, "outline_color_r", 255);
	int iOutlineColorG = KvGetNum(kv, "outline_color_g", 255);
	int iOutlineColorB = KvGetNum(kv, "outline_color_b", 255);
	int iOutlineColorTrans = KvGetNum(kv, "outline_color_transparency", 255);

	float flStaticRadius = KvGetFloat(kv, "static_radius", 0.0);
	float flStaticRadiusEasy = KvGetFloat(kv, "static_radius_easy", flStaticRadius);
	float flStaticRadiusHard = KvGetFloat(kv, "static_radius_hard", flStaticRadius);
	float flStaticRadiusInsane = KvGetFloat(kv, "static_radius_insane", flStaticRadiusHard);
	float flStaticRadiusNightmare = KvGetFloat(kv, "static_radius_nightmare", flStaticRadiusInsane);
	float flStaticRadiusApollyon = KvGetFloat(kv, "static_radius_apollyon", flStaticRadiusNightmare);

	float flBossEyePosOffset[3];
	KvGetVector(kv, "eye_pos", flBossEyePosOffset);
	
	float flBossEyeAngOffset[3];
	KvGetVector(kv, "eye_ang_offset", flBossEyeAngOffset);

	// Parse through flags.
	int iBossFlags = 0;
	if (KvGetNum(kv, "static_shake")) iBossFlags |= SFF_HASSTATICSHAKE;
	if (KvGetNum(kv, "static_on_look")) iBossFlags |= SFF_STATICONLOOK;
	if (KvGetNum(kv, "static_on_radius")) iBossFlags |= SFF_STATICONRADIUS;
	if (KvGetNum(kv, "proxies")) iBossFlags |= SFF_PROXIES;
	if (KvGetNum(kv, "jumpscare")) iBossFlags |= SFF_HASJUMPSCARE;
	if (KvGetNum(kv, "sound_sight_enabled")) iBossFlags |= SFF_HASSIGHTSOUNDS;
	if (KvGetNum(kv, "sound_static_loop_local_enabled")) iBossFlags |= SFF_HASSTATICLOOPLOCALSOUND;
	if (KvGetNum(kv, "view_shake", 1)) iBossFlags |= SFF_HASVIEWSHAKE;
	if (KvGetNum(kv, "copy")) iBossFlags |= SFF_COPIES;
	if (KvGetNum(kv, "wander_move", 1)) iBossFlags |= SFF_WANDERMOVE;
	if (KvGetNum(kv, "attack_props", 0)) iBossFlags |= SFF_ATTACKPROPS;
	if (KvGetNum(kv, "attack_weaponsenable", 0)) iBossFlags |= SFF_WEAPONKILLS;
	if (KvGetNum(kv, "kill_weaponsenable", 0)) iBossFlags |= SFF_WEAPONKILLSONRADIUS;
	if (KvGetNum(kv, "random_attacks", 0)) iBossFlags |= SFF_RANDOMATTACKS;
	
	// Try validating unique profile type.
	// The unique profile index specifies the location of a boss's type-specific data in another array.

	int iUniqueProfileIndex = -1;
	
	switch (iBossType)
	{
		case SF2BossType_Chaser:
		{
			if (!LoadChaserBossProfile(kv, sProfile, iUniqueProfileIndex, sLoadFailReasonBuffer))
			{
				return false;
			}
		}
	}
	
	// Add the section to our config.
	KvRewind(g_hConfig);
	KvJumpToKey(g_hConfig, sProfile, true);
	KvCopySubkeys(kv, g_hConfig);
	
	bool createNewBoss = false;
	int iIndex = GetBossProfileList().FindString(sProfile);
	if (iIndex == -1)
	{
		createNewBoss = true;
	}
	
	// Add to/Modify our array.
	// Cache values into g_hBossProfileData, because traversing a KeyValues object is expensive.

	if (createNewBoss)
	{
		iIndex = g_hBossProfileData.Push(-1);
		g_hBossProfileNames.SetValue(sProfile, iIndex);
		
		// Add to the boss list since it's not there already.
		GetBossProfileList().PushString(sProfile);
	}

	SetArrayCell(g_hBossProfileData, iIndex, iUniqueProfileIndex, BossProfileData_UniqueProfileIndex);
	SetArrayCell(g_hBossProfileData, iIndex, iBossType, BossProfileData_Type);
	SetArrayCell(g_hBossProfileData, iIndex, flBossModelScale, BossProfileData_ModelScale);
	SetArrayCell(g_hBossProfileData, iIndex, iBossHealth, BossProfileData_Health);
	SetArrayCell(g_hBossProfileData, iIndex, iBossSkin, BossProfileData_Skin);
	SetArrayCell(g_hBossProfileData, iIndex, iBossSkinMax, BossProfileData_SkinMax);
	SetArrayCell(g_hBossProfileData, iIndex, iBossBodyGroups, BossProfileData_Body);
	SetArrayCell(g_hBossProfileData, iIndex, iUseRaidHitbox, BossProfileData_UseRaidHitbox);
	
	SetArrayCell(g_hBossProfileData, iIndex, iBossFlags, BossProfileData_Flags);
	
	SetArrayCell(g_hBossProfileData, iIndex, flBossDefaultSpeed, BossProfileData_SpeedNormal);
	SetArrayCell(g_hBossProfileData, iIndex, flBossSpeedEasy, BossProfileData_SpeedEasy);
	SetArrayCell(g_hBossProfileData, iIndex, flBossSpeedHard, BossProfileData_SpeedHard);
	SetArrayCell(g_hBossProfileData, iIndex, flBossSpeedInsane, BossProfileData_SpeedInsane);
	SetArrayCell(g_hBossProfileData, iIndex, flBossSpeedNightmare, BossProfileData_SpeedNightmare);
	SetArrayCell(g_hBossProfileData, iIndex, flBossSpeedApollyon, BossProfileData_SpeedApollyon);
	
	SetArrayCell(g_hBossProfileData, iIndex, flBossDefaultMaxSpeed, BossProfileData_MaxSpeedNormal);
	SetArrayCell(g_hBossProfileData, iIndex, flBossMaxSpeedEasy, BossProfileData_MaxSpeedEasy);
	SetArrayCell(g_hBossProfileData, iIndex, flBossMaxSpeedHard, BossProfileData_MaxSpeedHard);
	SetArrayCell(g_hBossProfileData, iIndex, flBossMaxSpeedInsane, BossProfileData_MaxSpeedInsane);
	SetArrayCell(g_hBossProfileData, iIndex, flBossMaxSpeedNightmare, BossProfileData_MaxSpeedNightmare);
	SetArrayCell(g_hBossProfileData, iIndex, flBossMaxSpeedApollyon, BossProfileData_MaxSpeedApollyon);

	SetArrayCell(g_hBossProfileData, iIndex, flBossDefaultIdleLifetime, BossProfileData_IdleLifetimeNormal);
	SetArrayCell(g_hBossProfileData, iIndex, flBossIdleLifetimeEasy, BossProfileData_IdleLifetimeEasy);
	SetArrayCell(g_hBossProfileData, iIndex, flBossIdleLifetimeHard, BossProfileData_IdleLifetimeHard);
	SetArrayCell(g_hBossProfileData, iIndex, flBossIdleLifetimeInsane, BossProfileData_IdleLifetimeInsane);
	SetArrayCell(g_hBossProfileData, iIndex, flBossIdleLifetimeNightmare, BossProfileData_IdleLifetimeNightmare);
	SetArrayCell(g_hBossProfileData, iIndex, flBossIdleLifetimeApollyon, BossProfileData_IdleLifetimeApollyon);
	
	SetArrayCell(g_hBossProfileData, iIndex, flBossEyePosOffset[0], BossProfileData_EyePosOffsetX);
	SetArrayCell(g_hBossProfileData, iIndex, flBossEyePosOffset[1], BossProfileData_EyePosOffsetY);
	SetArrayCell(g_hBossProfileData, iIndex, flBossEyePosOffset[2], BossProfileData_EyePosOffsetZ);
	
	SetArrayCell(g_hBossProfileData, iIndex, flBossEyeAngOffset[0], BossProfileData_EyeAngOffsetX);
	SetArrayCell(g_hBossProfileData, iIndex, flBossEyeAngOffset[1], BossProfileData_EyeAngOffsetY);
	SetArrayCell(g_hBossProfileData, iIndex, flBossEyeAngOffset[2], BossProfileData_EyeAngOffsetZ);
	
	SetArrayCell(g_hBossProfileData, iIndex, flBossAngerStart, BossProfileData_AngerStart);
	SetArrayCell(g_hBossProfileData, iIndex, flBossAngerAddOnPageGrab, BossProfileData_AngerAddOnPageGrab);
	SetArrayCell(g_hBossProfileData, iIndex, flBossAngerPageGrabTimeDiffReq, BossProfileData_AngerPageGrabTimeDiffReq);
	
	SetArrayCell(g_hBossProfileData, iIndex, flBossInstantKillRadius, BossProfileData_InstantKillRadius);
	
	SetArrayCell(g_hBossProfileData, iIndex, flBossScareRadius, BossProfileData_ScareRadius);
	SetArrayCell(g_hBossProfileData, iIndex, flBossScareCooldown, BossProfileData_ScareCooldown);
	
	SetArrayCell(g_hBossProfileData, iIndex, iBossTeleportType, BossProfileData_TeleportType);
	
	SetArrayCell(g_hBossProfileData, iIndex, bUseCustomOutlines, BossProfileData_EnableCustomizableOutlines);
	SetArrayCell(g_hBossProfileData, iIndex, iOutlineColorR, BossProfileData_OutlineColorR);
	SetArrayCell(g_hBossProfileData, iIndex, iOutlineColorG, BossProfileData_OutlineColorG);
	SetArrayCell(g_hBossProfileData, iIndex, iOutlineColorB, BossProfileData_OutlineColorB);
	SetArrayCell(g_hBossProfileData, iIndex, iOutlineColorTrans, BossProfileData_OutlineColorTrans);

	SetArrayCell(g_hBossProfileData, iIndex, flStaticRadius, BossProfileData_StaticRadiusNormal);
	SetArrayCell(g_hBossProfileData, iIndex, flStaticRadiusEasy, BossProfileData_StaticRadiusEasy);
	SetArrayCell(g_hBossProfileData, iIndex, flStaticRadiusHard, BossProfileData_StaticRadiusHard);
	SetArrayCell(g_hBossProfileData, iIndex, flStaticRadiusInsane, BossProfileData_StaticRadiusInsane);
	SetArrayCell(g_hBossProfileData, iIndex, flStaticRadiusNightmare, BossProfileData_StaticRadiusNightmare);
	SetArrayCell(g_hBossProfileData, iIndex, flStaticRadiusApollyon, BossProfileData_StaticRadiusApollyon);

	SetArrayCell(g_hBossProfileData, iIndex, flBossTeleportTimeMin, BossProfileData_TeleportTimeMinNormal);
	SetArrayCell(g_hBossProfileData, iIndex, flBossTeleportTimeMinEasy, BossProfileData_TeleportTimeMinEasy);
	SetArrayCell(g_hBossProfileData, iIndex, flBossTeleportTimeMinHard, BossProfileData_TeleportTimeMinHard);
	SetArrayCell(g_hBossProfileData, iIndex, flBossTeleportTimeMinInsane, BossProfileData_TeleportTimeMinInsane);
	SetArrayCell(g_hBossProfileData, iIndex, flBossTeleportTimeMinNightmare, BossProfileData_TeleportTimeMinNightmare);
	SetArrayCell(g_hBossProfileData, iIndex, flBossTeleportTimeMinApollyon, BossProfileData_TeleportTimeMinApollyon);

	SetArrayCell(g_hBossProfileData, iIndex, flBossTeleportTimeMax, BossProfileData_TeleportTimeMaxNormal);
	SetArrayCell(g_hBossProfileData, iIndex, flBossTeleportTimeMaxEasy, BossProfileData_TeleportTimeMaxEasy);
	SetArrayCell(g_hBossProfileData, iIndex, flBossTeleportTimeMaxHard, BossProfileData_TeleportTimeMaxHard);
	SetArrayCell(g_hBossProfileData, iIndex, flBossTeleportTimeMaxInsane, BossProfileData_TeleportTimeMaxInsane);
	SetArrayCell(g_hBossProfileData, iIndex, flBossTeleportTimeMaxNightmare, BossProfileData_TeleportTimeMaxNightmare);
	SetArrayCell(g_hBossProfileData, iIndex, flBossTeleportTimeMaxApollyon, BossProfileData_TeleportTimeMaxApollyon);

	SetArrayCell(g_hBossProfileData, iIndex, flBossTeleportRangeMin, BossProfileData_TeleportRangeMinNormal);
	SetArrayCell(g_hBossProfileData, iIndex, flBossTeleportRangeMinEasy, BossProfileData_TeleportRangeMinEasy);
	SetArrayCell(g_hBossProfileData, iIndex, flBossTeleportRangeMinHard, BossProfileData_TeleportRangeMinHard);
	SetArrayCell(g_hBossProfileData, iIndex, flBossTeleportRangeMinInsane, BossProfileData_TeleportRangeMinInsane);
	SetArrayCell(g_hBossProfileData, iIndex, flBossTeleportRangeMinNightmare, BossProfileData_TeleportRangeMinNightmare);
	SetArrayCell(g_hBossProfileData, iIndex, flBossTeleportRangeMinApollyon, BossProfileData_TeleportRangeMinApollyon);

	SetArrayCell(g_hBossProfileData, iIndex, flBossTeleportRangeMax, BossProfileData_TeleportRangeMaxNormal);
	SetArrayCell(g_hBossProfileData, iIndex, flBossTeleportRangeMaxEasy, BossProfileData_TeleportRangeMaxEasy);
	SetArrayCell(g_hBossProfileData, iIndex, flBossTeleportRangeMaxHard, BossProfileData_TeleportRangeMaxHard);
	SetArrayCell(g_hBossProfileData, iIndex, flBossTeleportRangeMaxInsane, BossProfileData_TeleportRangeMaxInsane);
	SetArrayCell(g_hBossProfileData, iIndex, flBossTeleportRangeMaxNightmare, BossProfileData_TeleportRangeMaxNightmare);
	SetArrayCell(g_hBossProfileData, iIndex, flBossTeleportRangeMaxApollyon, BossProfileData_TeleportRangeMaxApollyon);

	SetArrayCell(g_hBossProfileData, iIndex, flBossJumpscareDistance, BossProfileData_JumpscareDistanceNormal);
	SetArrayCell(g_hBossProfileData, iIndex, flBossJumpscareDistanceEasy, BossProfileData_JumpscareDistanceEasy);
	SetArrayCell(g_hBossProfileData, iIndex, flBossJumpscareDistanceHard, BossProfileData_JumpscareDistanceHard);
	SetArrayCell(g_hBossProfileData, iIndex, flBossJumpscareDistanceInsane, BossProfileData_JumpscareDistanceInsane);
	SetArrayCell(g_hBossProfileData, iIndex, flBossJumpscareDistanceNightmare, BossProfileData_JumpscareDistanceNightmare);
	SetArrayCell(g_hBossProfileData, iIndex, flBossJumpscareDistanceApollyon, BossProfileData_JumpscareDistanceApollyon);

	SetArrayCell(g_hBossProfileData, iIndex, flBossJumpscareDuration, BossProfileData_JumpscareDurationNormal);
	SetArrayCell(g_hBossProfileData, iIndex, flBossJumpscareDurationEasy, BossProfileData_JumpscareDurationEasy);
	SetArrayCell(g_hBossProfileData, iIndex, flBossJumpscareDurationHard, BossProfileData_JumpscareDurationHard);
	SetArrayCell(g_hBossProfileData, iIndex, flBossJumpscareDurationInsane, BossProfileData_JumpscareDurationInsane);
	SetArrayCell(g_hBossProfileData, iIndex, flBossJumpscareDurationNightmare, BossProfileData_JumpscareDurationNightmare);
	SetArrayCell(g_hBossProfileData, iIndex, flBossJumpscareDurationApollyon, BossProfileData_JumpscareDurationApollyon);

	SetArrayCell(g_hBossProfileData, iIndex, flBossJumpscareCooldown, BossProfileData_JumpscareCooldownNormal);
	SetArrayCell(g_hBossProfileData, iIndex, flBossJumpscareCooldownEasy, BossProfileData_JumpscareCooldownEasy);
	SetArrayCell(g_hBossProfileData, iIndex, flBossJumpscareCooldownHard, BossProfileData_JumpscareCooldownHard);
	SetArrayCell(g_hBossProfileData, iIndex, flBossJumpscareCooldownInsane, BossProfileData_JumpscareCooldownInsane);
	SetArrayCell(g_hBossProfileData, iIndex, flBossJumpscareCooldownNightmare, BossProfileData_JumpscareCooldownNightmare);
	SetArrayCell(g_hBossProfileData, iIndex, flBossJumpscareCooldownApollyon, BossProfileData_JumpscareCooldownApollyon);

	SetArrayCell(g_hBossProfileData, iIndex, flBossSearchRadius, BossProfileData_SearchRange);
	SetArrayCell(g_hBossProfileData, iIndex, flBossSearchRadiusEasy, BossProfileData_SearchRangeEasy);
	SetArrayCell(g_hBossProfileData, iIndex, flBossSearchRadiusHard, BossProfileData_SearchRangeHard);
	SetArrayCell(g_hBossProfileData, iIndex, flBossSearchRadiusInsane, BossProfileData_SearchRangeInsane);
	SetArrayCell(g_hBossProfileData, iIndex, flBossSearchRadiusNightmare, BossProfileData_SearchRangeNightmare);
	SetArrayCell(g_hBossProfileData, iIndex, flBossSearchRadiusApollyon, BossProfileData_SearchRangeApollyon);

	SetArrayCell(g_hBossProfileData, iIndex, flBossSearchSoundRadius, BossProfileData_SearchSoundRange);
	SetArrayCell(g_hBossProfileData, iIndex, flBossSearchSoundRadiusEasy, BossProfileData_SearchSoundRangeEasy);
	SetArrayCell(g_hBossProfileData, iIndex, flBossSearchSoundRadiusHard, BossProfileData_SearchSoundRangeHard);
	SetArrayCell(g_hBossProfileData, iIndex, flBossSearchSoundRadiusInsane, BossProfileData_SearchSoundRangeInsane);
	SetArrayCell(g_hBossProfileData, iIndex, flBossSearchSoundRadiusNightmare, BossProfileData_SearchSoundRangeNightmare);
	SetArrayCell(g_hBossProfileData, iIndex, flBossSearchSoundRadiusApollyon, BossProfileData_SearchSoundRangeApollyon);

	SetArrayCell(g_hBossProfileData, iIndex, flBossFOV, BossProfileData_FieldOfView);
	SetArrayCell(g_hBossProfileData, iIndex, flBossMaxTurnRate, BossProfileData_TurnRate);
	
	char sCOn[PLATFORM_MAX_PATH], sCOff[PLATFORM_MAX_PATH], sJ[PLATFORM_MAX_PATH], sM[PLATFORM_MAX_PATH], sG[PLATFORM_MAX_PATH], sS[PLATFORM_MAX_PATH], sFE[PLATFORM_MAX_PATH], sFS[PLATFORM_MAX_PATH], sFIS[PLATFORM_MAX_PATH], sRE[PLATFORM_MAX_PATH], sRS[PLATFORM_MAX_PATH], sEngineSound[PLATFORM_MAX_PATH], sGrenadeShoot[PLATFORM_MAX_PATH], sSentryrocketShoot[PLATFORM_MAX_PATH], sArrowShoot[PLATFORM_MAX_PATH], sManglerShoot[PLATFORM_MAX_PATH], sBaseballShoot[PLATFORM_MAX_PATH], sSpawnParticleSound[PLATFORM_MAX_PATH], sDespawnParticleSound[PLATFORM_MAX_PATH];
	KvGetString(kv, "cloak_on_sound", sCOn, sizeof(sCOn));
	KvGetString(kv, "cloak_off_sound", sCOff, sizeof(sCOff));
	KvGetString(kv, "player_jarate_sound", sJ, sizeof(sJ));
	KvGetString(kv, "player_milk_sound", sM, sizeof(sM));
	KvGetString(kv, "player_gas_sound", sG, sizeof(sG));
	KvGetString(kv, "player_stun_sound", sS, sizeof(sS));
	KvGetString(kv, "fire_explode_sound", sFE, sizeof(sFE));
	KvGetString(kv, "fire_shoot_sound", sFS, sizeof(sFS));
	KvGetString(kv, "fire_iceball_slow_sound", sFIS, sizeof(sFIS));
	KvGetString(kv, "rocket_explode_sound", sRE, sizeof(sRE));
	KvGetString(kv, "rocket_shoot_sound", sRS, sizeof(sRS));
	KvGetString(kv, "grenade_shoot_sound", sGrenadeShoot, sizeof(sGrenadeShoot));
	KvGetString(kv, "sentryrocket_shoot_sound", sSentryrocketShoot, sizeof(sSentryrocketShoot));
	KvGetString(kv, "arrow_shoot_sound", sArrowShoot, sizeof(sArrowShoot));
	KvGetString(kv, "mangler_shoot_sound", sManglerShoot, sizeof(sManglerShoot));
	KvGetString(kv, "baseball_shoot_sound", sBaseballShoot, sizeof(sBaseballShoot));
	KvGetString(kv, "engine_sound", sEngineSound, sizeof(sEngineSound));
	KvGetString(kv, "tp_effect_spawn_sound", sSpawnParticleSound, sizeof(sSpawnParticleSound));
	KvGetString(kv, "tp_effect_despawn_sound", sDespawnParticleSound, sizeof(sDespawnParticleSound));

	TryPrecacheBossProfileSoundPath(sCOn);
	TryPrecacheBossProfileSoundPath(sCOff);
	TryPrecacheBossProfileSoundPath(sJ);
	TryPrecacheBossProfileSoundPath(sM);
	TryPrecacheBossProfileSoundPath(sG);
	TryPrecacheBossProfileSoundPath(sS);
	TryPrecacheBossProfileSoundPath(sFE);
	TryPrecacheBossProfileSoundPath(sFS);
	TryPrecacheBossProfileSoundPath(sFIS);
	TryPrecacheBossProfileSoundPath(sRE);
	TryPrecacheBossProfileSoundPath(sRS);
	TryPrecacheBossProfileSoundPath(sGrenadeShoot);
	TryPrecacheBossProfileSoundPath(sSentryrocketShoot);
	TryPrecacheBossProfileSoundPath(sArrowShoot);
	TryPrecacheBossProfileSoundPath(sManglerShoot);
	TryPrecacheBossProfileSoundPath(sBaseballShoot);
	TryPrecacheBossProfileSoundPath(sEngineSound);
	TryPrecacheBossProfileSoundPath(sSpawnParticleSound);
	TryPrecacheBossProfileSoundPath(sDespawnParticleSound);
	
	if (view_as<bool>(KvGetNum(kv, "enable_random_selection", 1)))
	{
		if (GetSelectableBossProfileList().FindString(sProfile) == -1)
		{
			// Add to the selectable boss list if it isn't there already.
			GetSelectableBossProfileList().PushString(sProfile);
		}
	}
	else
	{
		int selectIndex = GetSelectableBossProfileList().FindString(sProfile);
		if (selectIndex != -1)
		{
			GetSelectableBossProfileList().Erase(selectIndex);
		}	
	}
	
	if (view_as<bool>(KvGetNum(kv, "enable_random_selection_boxing", 0)))
	{
		if (GetSelectableBoxingBossProfileList().FindString(sProfile) == -1)
		{
			// Add to the selectable boss list if it isn't there already.
			GetSelectableBoxingBossProfileList().PushString(sProfile);
		}
	}
	else
	{
		int selectIndex = GetSelectableBoxingBossProfileList().FindString(sProfile);
		if (selectIndex != -1)
		{
			GetSelectableBoxingBossProfileList().Erase(selectIndex);
		}
	}
	
	if (view_as<bool>(KvGetNum(kv, "enable_random_selection_renevant", 0)))
	{
		if (GetSelectableRenevantBossProfileList().FindString(sProfile) == -1)
		{
			// Add to the selectable boss list if it isn't there already.
			GetSelectableRenevantBossProfileList().PushString(sProfile);
		}
	}
	else
	{
		int selectIndex = GetSelectableRenevantBossProfileList().FindString(sProfile);
		if (selectIndex != -1)
		{
			GetSelectableRenevantBossProfileList().Erase(selectIndex);
		}
	}
	
	if (KvGotoFirstSubKey(kv)) //Special thanks to Fire for modifying the code for download errors.
	{
		char s2[64], s3[64], s4[PLATFORM_MAX_PATH], s5[PLATFORM_MAX_PATH];
		
		do
		{
			KvGetSectionName(kv, s2, sizeof(s2));
			
			if (!StrContains(s2, "sound_"))
			{
				for (int i = 1;; i++)
				{
					FormatEx(s3, sizeof(s3), "%d", i);
					KvGetString(kv, s3, s4, sizeof(s4));
					if (!s4[0]) break;

					TryPrecacheBossProfileSoundPath(s4);
				}
			}
			else if (strcmp(s2, "download") == 0)
			{
				for (int i = 1;; i++)
				{
					FormatEx(s3, sizeof(s3), "%d", i);
					KvGetString(kv, s3, s4, sizeof(s4));
					if (!s4[0]) break;
					
					if(FileExists(s4) || FileExists(s4, true))
					{
						AddFileToDownloadsTable(s4);
					}
					else
					{
						LogSF2Message("File %s does not exist, please fix this download or remove it from the array.", s4);
					}
				}
			}
			else if (strcmp(s2, "mod_precache") == 0)
			{
				for (int i = 1;; i++)
				{
					FormatEx(s3, sizeof(s3), "%d", i);
					KvGetString(kv, s3, s4, sizeof(s4));
					if (!s4[0]) break;
					
					if(!PrecacheModel(s4, true))
					{
						LogSF2Message("File %s failed to be precached, likely does not exist.", s4);
					}
				}
			}
			else if (strcmp(s2, "mat_download") == 0)
			{	
				for (int i = 1;; i++)
				{
					FormatEx(s3, sizeof(s3), "%d", i);
					KvGetString(kv, s3, s4, sizeof(s4));
					if (!s4[0]) break;
					
					FormatEx(s5, sizeof(s5), "%s.vtf", s4);
					if(FileExists(s5) || FileExists(s5, true))
					{
						AddFileToDownloadsTable(s5);
					}
					else
					{
						LogSF2Message("File %s does not exist, please fix this download or remove it from the array.", s5);
					}

					FormatEx(s5, sizeof(s5), "%s.vmt", s4);
					if(FileExists(s5) || FileExists(s5, true))
					{
						AddFileToDownloadsTable(s5);
					}
					else
					{
						LogSF2Message("File %s does not exist, please fix this download or remove it from the array.", s5);
					}
				}
			}
			else if (strcmp(s2, "mod_download") == 0)
			{
				static const char extensions[][] = { ".mdl", ".phy", ".dx80.vtx", ".dx90.vtx", ".sw.vtx", ".vvd" };
				
				for (int i = 1;; i++)
				{
					FormatEx(s3, sizeof(s3), "%d", i);
					KvGetString(kv, s3, s4, sizeof(s4));
					if (!s4[0]) break;
					
					for (int is = 0; is < sizeof(extensions); is++)
					{
						FormatEx(s5, sizeof(s5), "%s%s", s4, extensions[is]);
						if(FileExists(s5) || FileExists(s5, true))
						{
							AddFileToDownloadsTable(s5);
						}
						else
						{
							LogSF2Message("File %s does not exist, please fix this download or remove it from the array.", s5);
						}
					}
				}
			}
		}
		while (KvGotoNextKey(kv));
		
		KvGoBack(kv);
	}
	
	return true;
}

Handle g_hBossPackVoteMapTimer;
Handle g_hBossPackVoteTimer;
static bool g_bBossPackVoteCompleted;
static bool g_bBossPackVoteStarted;

void InitializeBossPackVotes()
{
	g_hBossPackVoteMapTimer = INVALID_HANDLE;
	g_hBossPackVoteTimer = INVALID_HANDLE;
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
					g_hBossPackVoteTimer = CreateTimer(5.0, Timer_BossPackVoteLoop, _, TIMER_REPEAT);
				}
			}
			else
			{
				if (g_hBossPackVoteMapTimer != INVALID_HANDLE)
				{
					delete g_hBossPackVoteMapTimer;
					g_hBossPackVoteMapTimer = INVALID_HANDLE;
				}
				
				if (g_hBossPackVoteMapTimer == INVALID_HANDLE) g_hBossPackVoteMapTimer = CreateTimer(float(time - startTime), Timer_StartBossPackVote);
			}
		}
	}
}

void CheckRoundLimitForBossPackVote(int roundCount)
{
	if (!g_cvBossPackEndOfMapVote.BoolValue || !g_bBossPackVoteEnabled || g_bBossPackVoteStarted || g_bBossPackVoteCompleted) return;
	
	if (g_cvMaxRounds == INVALID_HANDLE) return;
	
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
				g_hBossPackVoteTimer = CreateTimer(5.0, Timer_BossPackVoteLoop, _, TIMER_REPEAT);
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
	if (g_hBossPackConfig == INVALID_HANDLE) return;
	
	KvRewind(g_hBossPackConfig);
	if (!KvJumpToKey(g_hBossPackConfig, "packs")) return;
	if (!KvGotoFirstSubKey(g_hBossPackConfig)) return;
	Handle voteMenu = NativeVotes_Create(Menu_BossPackVote, NativeVotesType_Custom_Mult);
	NativeVotes_SetInitiator(voteMenu, Initiator);
	char Tittle[255];
	FormatEx(Tittle,255,"%t%t","SF2 Prefix","SF2 Boss Pack Vote Menu Title");
	NativeVotes_SetDetails(voteMenu,Tittle);
	Handle menuDisplayNamesTrie = CreateTrie();
	Handle menuOptionsInfo = CreateArray(128);
	
	do
	{
		if (!view_as<bool>(KvGetNum(g_hBossPackConfig, "autoload")) && view_as<bool>(KvGetNum(g_hBossPackConfig, "show_in_vote", 1)))
		{
			
			char bossPack[128];
			KvGetSectionName(g_hBossPackConfig, bossPack, sizeof(bossPack));
			if(strcmp(bossPack,MapbossPack) != 0)
			{
				char bossPackName[64];
				KvGetString(g_hBossPackConfig, "name", bossPackName, sizeof(bossPackName), bossPack);
				
				SetTrieString(menuDisplayNamesTrie, bossPack, bossPackName);
				PushArrayString(menuOptionsInfo, bossPack);
			}
		}
	}
	while (KvGotoNextKey(g_hBossPackConfig));
	
	if (GetArraySize(menuOptionsInfo) == 0)
	{
		delete menuDisplayNamesTrie;
		delete menuOptionsInfo;
		delete voteMenu;
		return;
	}
	
	if (g_cvBossPackVoteShuffle.BoolValue)
	{
		SortADTArray(menuOptionsInfo, Sort_Random, Sort_String);
	}
	
	for (int i = 0; i < GetArraySize(menuOptionsInfo); i++)
	{
		if(i<=5)
		{
			char bossPack[128], bossPackName[64];
			GetArrayString(menuOptionsInfo, i, bossPack, sizeof(bossPack));
			GetTrieString(menuDisplayNamesTrie, bossPack, bossPackName, sizeof(bossPackName));
			NativeVotes_AddItem(voteMenu, bossPack, bossPackName);
		}
	}
	
	delete menuDisplayNamesTrie;
	delete menuOptionsInfo;
	
	g_bBossPackVoteStarted = true;
	if (g_hBossPackVoteMapTimer != INVALID_HANDLE)
	{
		delete g_hBossPackVoteMapTimer;
		g_hBossPackVoteMapTimer = INVALID_HANDLE;
	}
	
	if (g_hBossPackVoteTimer != INVALID_HANDLE)
	{
		delete g_hBossPackVoteTimer;
		g_hBossPackVoteTimer = INVALID_HANDLE;
	}
	
	NativeVotes_DisplayToAll(voteMenu, 20);
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
	if (timer != g_hBossPackVoteMapTimer) return;
	
	g_hBossPackVoteTimer = CreateTimer(5.0, Timer_BossPackVoteLoop, _, TIMER_REPEAT);
	TriggerTimer(g_hBossPackVoteTimer, true);
}

public Action Timer_BossPackVoteLoop(Handle timer)
{
	if (timer != g_hBossPackVoteTimer || g_bBossPackVoteCompleted || g_bBossPackVoteStarted) 
		return Plugin_Stop;
	
	if (!NativeVotes_IsVoteInProgress())
	{
		g_hBossPackVoteTimer = INVALID_HANDLE;
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
	
	KvRewind(g_hConfig);
	KvJumpToKey(g_hConfig, sProfile);
	
	return KvGetNum(g_hConfig, keyValue, defaultValue);
}

stock float GetProfileFloat(const char[] sProfile, const char[] keyValue, float defaultValue=0.0)
{
	if (!IsProfileValid(sProfile)) return defaultValue;
	
	KvRewind(g_hConfig);
	KvJumpToKey(g_hConfig, sProfile);
	
	return KvGetFloat(g_hConfig, keyValue, defaultValue);
}

stock bool GetProfileVector(const char[] sProfile, const char[] keyValue, float buffer[3], const float defaultValue[3]=NULL_VECTOR)
{
	for (int i = 0; i < 3; i++) buffer[i] = defaultValue[i];
	
	if (!IsProfileValid(sProfile)) return false;
	
	KvRewind(g_hConfig);
	KvJumpToKey(g_hConfig, sProfile);
	
	KvGetVector(g_hConfig, keyValue, buffer, defaultValue);
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
	
	KvRewind(g_hConfig);
	KvJumpToKey(g_hConfig, sProfile);
	
	char sValue[64];
	KvGetString(g_hConfig, keyValue, sValue, sizeof(sValue));
	
	if (sValue[0] != '\0')
	{
		KvGetColor(g_hConfig, keyValue, r, g, b, a);
	}
	
	return true;
}

stock bool GetProfileString(const char[] sProfile, const char[] keyValue, char[] buffer,int bufferlen, const char[] defaultValue="")
{
	strcopy(buffer, bufferlen, defaultValue);
	
	if (!IsProfileValid(sProfile)) return false;
	
	KvRewind(g_hConfig);
	KvJumpToKey(g_hConfig, sProfile);
	
	KvGetString(g_hConfig, keyValue, buffer, bufferlen, defaultValue);
	return true;
}

int GetBossProfileIndexFromName(const char[] sProfile)
{
	int iReturn = -1;
	GetTrieValue(g_hBossProfileNames, sProfile, iReturn);
	return iReturn;
}

int GetBossProfileUniqueProfileIndex(int iProfileIndex)
{
	return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_UniqueProfileIndex);
}

int GetBossProfileSkin(int iProfileIndex)
{
	return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_Skin);
}

int GetBossProfileSkinMax(int iProfileIndex)
{
	return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_SkinMax);
}

int GetBossProfileBodyGroups(int iProfileIndex)
{
	return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_Body);
}

int GetBossProfileRaidHitbox(int iProfileIndex)
{
	return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_UseRaidHitbox);
}

float GetBossProfileModelScale(int iProfileIndex)
{
	return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_ModelScale));
}

int GetBossProfileHealth(int iProfileIndex)
{
	return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_Health);
}

int GetBossProfileType(int iProfileIndex)
{
	return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_Type);
}

int GetBossProfileFlags(int iProfileIndex)
{
	return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_Flags);
}

float GetBossProfileSpeed(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_SpeedEasy);
		case Difficulty_Hard: return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_SpeedHard);
		case Difficulty_Insane: return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_SpeedInsane);
		case Difficulty_Nightmare: return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_SpeedNightmare);
		case Difficulty_Apollyon: return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_SpeedApollyon);
	}
	
	return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_SpeedNormal);
}

float GetBossProfileMaxSpeed(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_MaxSpeedEasy);
		case Difficulty_Hard: return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_MaxSpeedHard);
		case Difficulty_Insane: return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_MaxSpeedInsane);
		case Difficulty_Nightmare: return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_MaxSpeedNightmare);
		case Difficulty_Apollyon: return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_MaxSpeedApollyon);
	}
	
	return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_MaxSpeedNormal);
}

float GetBossProfileIdleLifetime(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_IdleLifetimeEasy);
		case Difficulty_Hard: return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_IdleLifetimeHard);
		case Difficulty_Insane: return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_IdleLifetimeInsane);
		case Difficulty_Nightmare: return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_IdleLifetimeNightmare);
		case Difficulty_Apollyon: return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_IdleLifetimeApollyon);
	}
	
	return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_IdleLifetimeNormal);
}

float GetBossProfileStaticRadius(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_StaticRadiusEasy));
		case Difficulty_Hard: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_StaticRadiusHard));
		case Difficulty_Insane: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_StaticRadiusInsane));
		case Difficulty_Nightmare: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_StaticRadiusNightmare));
		case Difficulty_Apollyon: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_StaticRadiusApollyon));
	}
	
	return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_StaticRadiusNormal));
}

float GetBossProfileSearchRadius(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_SearchRangeEasy));
		case Difficulty_Hard: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_SearchRangeHard));
		case Difficulty_Insane: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_SearchRangeInsane));
		case Difficulty_Nightmare: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_SearchRangeNightmare));
		case Difficulty_Apollyon: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_SearchRangeApollyon));
	}
	
	return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_SearchRange));
}

float GetBossProfileHearRadius(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_SearchSoundRangeEasy));
		case Difficulty_Hard: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_SearchSoundRangeHard));
		case Difficulty_Insane: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_SearchSoundRangeInsane));
		case Difficulty_Nightmare: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_SearchSoundRangeNightmare));
		case Difficulty_Apollyon: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_SearchSoundRangeApollyon));
	}
	
	return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_SearchSoundRange));
}

float GetBossProfileTeleportTimeMin(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TeleportTimeMinEasy));
		case Difficulty_Hard: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TeleportTimeMinHard));
		case Difficulty_Insane: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TeleportTimeMinInsane));
		case Difficulty_Nightmare: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TeleportTimeMinNightmare));
		case Difficulty_Apollyon: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TeleportTimeMinApollyon));
	}
	
	return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TeleportTimeMinNormal));
}

float GetBossProfileTeleportTimeMax(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TeleportTimeMaxEasy));
		case Difficulty_Hard: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TeleportTimeMaxHard));
		case Difficulty_Insane: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TeleportTimeMaxInsane));
		case Difficulty_Nightmare: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TeleportTimeMaxNightmare));
		case Difficulty_Apollyon: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TeleportTimeMaxApollyon));
	}
	
	return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TeleportTimeMaxNormal));
}

float GetBossProfileTeleportRangeMin(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TeleportRangeMinEasy));
		case Difficulty_Hard: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TeleportRangeMinHard));
		case Difficulty_Insane: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TeleportRangeMinInsane));
		case Difficulty_Nightmare: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TeleportRangeMinNightmare));
		case Difficulty_Apollyon: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TeleportRangeMinApollyon));
	}
	
	return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TeleportRangeMinNormal));
}

float GetBossProfileTeleportRangeMax(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TeleportRangeMaxEasy));
		case Difficulty_Hard: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TeleportRangeMaxHard));
		case Difficulty_Insane: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TeleportRangeMaxInsane));
		case Difficulty_Nightmare: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TeleportRangeMaxNightmare));
		case Difficulty_Apollyon: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TeleportRangeMaxApollyon));
	}
	
	return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TeleportRangeMaxNormal));
}

float GetBossProfileJumpscareDistance(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_JumpscareDistanceEasy));
		case Difficulty_Hard: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_JumpscareDistanceHard));
		case Difficulty_Insane: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_JumpscareDistanceInsane));
		case Difficulty_Nightmare: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_JumpscareDistanceNightmare));
		case Difficulty_Apollyon: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_JumpscareDistanceApollyon));
	}
	
	return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_JumpscareDistanceNormal));
}

float GetBossProfileJumpscareDuration(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_JumpscareDurationEasy));
		case Difficulty_Hard: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_JumpscareDurationHard));
		case Difficulty_Insane: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_JumpscareDurationInsane));
		case Difficulty_Nightmare: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_JumpscareDurationNightmare));
		case Difficulty_Apollyon: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_JumpscareDurationApollyon));
	}
	
	return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_JumpscareDurationNormal));
}

float GetBossProfileJumpscareCooldown(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_JumpscareCooldownEasy));
		case Difficulty_Hard: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_JumpscareCooldownHard));
		case Difficulty_Insane: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_JumpscareCooldownInsane));
		case Difficulty_Nightmare: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_JumpscareCooldownNightmare));
		case Difficulty_Apollyon: return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_JumpscareCooldownApollyon));
	}
	
	return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_JumpscareCooldownNormal));
}

float GetBossProfileFOV(int iProfileIndex)
{
	return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_FieldOfView));
}

float GetBossProfileTurnRate(int iProfileIndex)
{
	return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TurnRate));
}

void GetBossProfileEyePositionOffset(int iProfileIndex, float buffer[3])
{
	buffer[0] = view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_EyePosOffsetX));
	buffer[1] = view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_EyePosOffsetY));
	buffer[2] = view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_EyePosOffsetZ));
}

void GetBossProfileEyeAngleOffset(int iProfileIndex, float buffer[3])
{
	buffer[0] = view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_EyeAngOffsetX));
	buffer[1] = view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_EyeAngOffsetY));
	buffer[2] = view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_EyeAngOffsetZ));
}

float GetBossProfileAngerStart(int iProfileIndex)
{
	return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_AngerStart));
}

float GetBossProfileAngerAddOnPageGrab(int iProfileIndex)
{
	return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_AngerAddOnPageGrab));
}

float GetBossProfileAngerPageGrabTimeDiff(int iProfileIndex)
{
	return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_AngerPageGrabTimeDiffReq));
}

float GetBossProfileInstantKillRadius(int iProfileIndex)
{
	return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_InstantKillRadius));
}

float GetBossProfileScareRadius(int iProfileIndex)
{
	return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_ScareRadius));
}

float GetBossProfileScareCooldown(int iProfileIndex)
{
	return view_as<float>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_ScareCooldown));
}

int GetBossProfileTeleportType(int iProfileIndex)
{
	return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_TeleportType);
}

bool GetBossProfileCustomOutlinesState(int iProfileIndex)
{
	return view_as<bool>(GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_EnableCustomizableOutlines));
}

int GetBossProfileOutlineColorR(int iProfileIndex)
{
	return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_OutlineColorR);
}

int GetBossProfileOutlineColorG(int iProfileIndex)
{
	return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_OutlineColorG);
}

int GetBossProfileOutlineColorB(int iProfileIndex)
{
	return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_OutlineColorB);
}

int GetBossProfileOutlineTransparency(int iProfileIndex)
{
	return GetArrayCell(g_hBossProfileData, iProfileIndex, BossProfileData_OutlineColorTrans);
}

// Code originally from FF2. Credits to the original authors Rainbolt Dash and FlaminSarge.
stock bool GetRandomStringFromProfile(const char[] sProfile, const char[] strKeyValue, char[] buffer,int bufferlen,int index = -1,int iAttackIndex = -1)
{
	buffer[0] = '\0';
	
	if (!IsProfileValid(sProfile)) return false;
	
	KvRewind(g_hConfig);
	if (!KvJumpToKey(g_hConfig, sProfile)) return false;
	if (!KvJumpToKey(g_hConfig, strKeyValue)) return false;
	
	char s[32], s2[PLATFORM_MAX_PATH], s3[3], s4[PLATFORM_MAX_PATH], s5[3];
	int i = 1;
	if (iAttackIndex != -1)
	{
		FormatEx(s3, sizeof(s3), "%d", iAttackIndex);
		FormatEx(s5, sizeof(s5), "%d", iAttackIndex);
		KvGetString(g_hConfig, s5, s4, sizeof(s4));
		if (!s4[0])
		{
			KvJumpToKey(g_hConfig, s3, true);
			for (;;)
			{
				FormatEx(s, sizeof(s), "%d", i);
				KvGetString(g_hConfig, s, s2, sizeof(s2));
				if (!s2[0]) break;

				i++;
			}
		}
		else
		{
			for (;;)
			{
				FormatEx(s, sizeof(s), "%d", i);
				KvGetString(g_hConfig, s, s2, sizeof(s2));
				if (!s2[0]) break;
					
				i++;
			}
		}
	}
	else
	{
		for (;;)
		{
			FormatEx(s, sizeof(s), "%d", i);
			KvGetString(g_hConfig, s, s2, sizeof(s2));
			if (!s2[0]) break;
				
			i++;
		}
	}

	if (i == 1) return false;
	FormatEx(s, sizeof(s), "%d", index < 0 ? GetRandomInt(1, i - 1) : index);
	KvGetString(g_hConfig, s, buffer, bufferlen);
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

ArrayList GetSelectableRenevantBossProfileList()
{
	return g_hSelectableRenevantBossProfileList;
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