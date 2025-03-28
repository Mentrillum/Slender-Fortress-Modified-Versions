#if defined _sf2_profiles_included
 #endinput
#endif
#define _sf2_profiles_included

#pragma semicolon 1
#pragma newdecls required

#define FILE_PROFILES_DIR "configs/sf2/profiles"
#define FILE_PROFILES_PACKS "configs/sf2/profiles_packs.cfg"
#define FILE_PROFILES_PACKS_DIR "configs/sf2/profiles/packs"

#define FILE_PROFILES_DIR_DATA "data/sf2/profiles"
#define FILE_PROFILES_PACKS_DATA "data/sf2/profiles_packs.cfg"
#define FILE_PROFILES_PACKS_DIR_DATA "data/sf2/profiles/packs"

ArrayList g_BossProfileList = null;
static ArrayList g_SelectableBossProfileList = null;
static ArrayList g_SelectableAdminBossProfileList = null;
static ArrayList g_SelectableRenevantBossAdminProfileList = null;
static ArrayList g_SelectableBossProfileQueueList = null;

StringMap g_BossProfileData = null;

ConVar g_BossProfilePackConVar = null;
ConVar g_BossProfilePackDefaultConVar = null;

KeyValues g_BossPackConfig = null;

ConVar g_BossPackEndOfMapVoteConVar;
ConVar g_BossPackVoteStartTimeConVar;
ConVar g_BossPackVoteStartRoundConVar;
ConVar g_BossPackVoteShuffleConVar;
ConVar g_MaxCorePackBosses;

static bool g_BossPackVoteEnabled = false;

static StringMap g_Activities;

static char mapBossPack[64];

GlobalForward g_OnBossProfileLoadedFwd;
static GlobalForward g_OnBossProfileUnloadedFwd;

#include "profiles/keymap.sp"
#include "profiles/objects.sp"
#include "profiles/profiles_boss_functions.sp"
#include "profiles/profile_chaser.sp"
#include "profiles/profile_statue.sp"

void SetupBossProfileNatives()
{
	CreateNative("SF2_IsBossProfileValid", Native_IsBossProfileValid);
	CreateNative("SF2_GetBossProfileNum", Native_GetBossProfileNum);
	CreateNative("SF2_GetBossProfileFloat", Native_GetBossProfileFloat);
	CreateNative("SF2_GetBossProfileString", Native_GetBossProfileString);
	CreateNative("SF2_GetBossProfileVector", Native_GetBossProfileVector);
	CreateNative("SF2_GetBossAttackProfileNum", Native_GetBossAttackProfileNum);
	CreateNative("SF2_GetBossAttackProfileFloat", Native_GetBossAttackProfileFloat);
	CreateNative("SF2_GetBossAttackProfileString", Native_GetBossAttackProfileString);
	CreateNative("SF2_GetBossAttackProfileVector", Native_GetBossAttackProfileVector);
	CreateNative("SF2_GetRandomStringFromBossProfile", Native_GetRandomStringFromBossProfile);
	CreateNative("SF2_GetBossAttributeName", Native_GetBossAttributeName);
	CreateNative("SF2_GetBossAttributeValue", Native_GetBossAttributeValue);

	CreateNative("SF2_TranslateProfileActivityFromName", Native_TranslateProfileActivityFromName);
	CreateNative("SF2_LookupProfileAnimation", Native_LookupProfileAnimation);

	CreateNative("SF2_BaseBossProfile.Type.get", Native_GetType);
	CreateNative("SF2_BaseBossProfile.IsPvEBoss.get", Native_GetIsPvEBoss);

	SetupProfileObjectNatives();
	ProfileChaser_InititalizeAPI();
}

void InitializeBossProfiles()
{
	g_BossProfileList = new ArrayList(ByteCountToCells(SF2_MAX_PROFILE_NAME_LENGTH));
	g_BossProfileData = new StringMap();

	g_Activities = new StringMap();

	g_OnBossProfileLoadedFwd = new GlobalForward("SF2_OnBossProfileLoaded", ET_Ignore, Param_String, Param_Cell);
	g_OnBossProfileUnloadedFwd = new GlobalForward("SF2_OnBossProfileUnloaded", ET_Ignore, Param_String, Param_Cell);

	AddProfileActivities();

	g_BossProfilePackConVar = CreateConVar("sf2_boss_profile_pack", "", "The boss pack referenced in profiles_packs.cfg that should be loaded.", FCVAR_NOTIFY | FCVAR_DONTRECORD);
	g_BossProfilePackDefaultConVar = CreateConVar("sf2_boss_profile_pack_default", "", "If the boss pack defined in sf2_boss_profile_pack is blank or could not be loaded, this pack will be used instead.", FCVAR_NOTIFY);
	g_BossPackEndOfMapVoteConVar = CreateConVar("sf2_boss_profile_pack_endvote", "0", "Enables/Disables a boss pack vote at the end of the map.");
	g_BossPackVoteStartTimeConVar = CreateConVar("sf2_boss_profile_pack_endvote_start", "4", "Specifies when to start the vote based on time remaining on the map, in minutes.", FCVAR_NOTIFY);
	g_BossPackVoteStartRoundConVar = CreateConVar("sf2_boss_profile_pack_endvote_startround", "2", "Specifies when to start the vote based on rounds remaining on the map.", FCVAR_NOTIFY);
	g_BossPackVoteShuffleConVar = CreateConVar("sf2_boss_profile_pack_endvote_shuffle", "0", "Shuffles the menu options of boss pack endvotes if enabled.");

	g_MaxCorePackBosses = CreateConVar("sf2_max_core_pack_bosses", "-1", "Determines how many bosses can load randomly from the core pack, if set to less than 0 will keep this feature off. Note that companion bosses will still load if needed.");
}

static void AddProfileActivities()
{
	// Movement activities
	g_Activities.SetValue("ACT_COMBAT_IDLE", ACT_COMBAT_IDLE);
	g_Activities.SetValue("ACT_IDLE", ACT_IDLE);
	g_Activities.SetValue("ACT_IDLE_STIMULATED", ACT_IDLE_STIMULATED);
	g_Activities.SetValue("ACT_IDLE_AGITATED", ACT_IDLE_AGITATED);
	g_Activities.SetValue("ACT_IDLE_ANGRY", ACT_IDLE_ANGRY);
	g_Activities.SetValue("ACT_IDLE_RELAXED", ACT_IDLE_RELAXED);
	g_Activities.SetValue("ACT_IDLE_AIM_STIMULATED", ACT_IDLE_AIM_STIMULATED);
	g_Activities.SetValue("ACT_IDLE_AIM_AGITATED", ACT_IDLE_AIM_AGITATED);
	g_Activities.SetValue("ACT_IDLE_AIM_RELAXED", ACT_IDLE_AIM_RELAXED);
	g_Activities.SetValue("ACT_CROUCH", ACT_CROUCH); // act of crouching down
	g_Activities.SetValue("ACT_CROUCHIDLE", ACT_CROUCHIDLE);
	g_Activities.SetValue("ACT_CROUCHIDLE_STIMULATED", ACT_CROUCHIDLE_STIMULATED);
	g_Activities.SetValue("ACT_CROUCHIDLE_AIM_STIMULATED", ACT_CROUCHIDLE_AIM_STIMULATED);
	g_Activities.SetValue("ACT_CROUCHIDLE_AGITATED", ACT_CROUCHIDLE_AGITATED);
	g_Activities.SetValue("ACT_STAND", ACT_STAND); // standing up from crouch
	g_Activities.SetValue("ACT_MP_STAND_PRIMARY", ACT_MP_STAND_PRIMARY);
	g_Activities.SetValue("ACT_MP_STAND_SECONDARY", ACT_MP_STAND_SECONDARY);
	g_Activities.SetValue("ACT_MP_STAND_MELEE", ACT_MP_STAND_MELEE);
	g_Activities.SetValue("ACT_MP_STAND_SECONDARY2", ACT_MP_STAND_SECONDARY2);
	g_Activities.SetValue("ACT_MP_STAND_ITEM1", ACT_MP_STAND_ITEM1);
	g_Activities.SetValue("ACT_MP_STAND_ITEM2", ACT_MP_STAND_ITEM2);
	g_Activities.SetValue("ACT_MP_CROUCH_PRIMARY", ACT_MP_CROUCH_PRIMARY);
	g_Activities.SetValue("ACT_MP_CROUCH_SECONDARY", ACT_MP_CROUCH_SECONDARY);
	g_Activities.SetValue("ACT_MP_CROUCH_MELEE", ACT_MP_CROUCH_MELEE);
	g_Activities.SetValue("ACT_MP_CROUCH_SECONDARY2", ACT_MP_CROUCH_SECONDARY2);
	g_Activities.SetValue("ACT_MP_CROUCH_ITEM1", ACT_MP_CROUCH_ITEM1);
	g_Activities.SetValue("ACT_MP_CROUCH_ITEM2", ACT_MP_CROUCH_ITEM2);
	g_Activities.SetValue("ACT_WALK", ACT_WALK);
	g_Activities.SetValue("ACT_WALK_STIMULATED", ACT_WALK_STIMULATED);
	g_Activities.SetValue("ACT_WALK_AGITATED", ACT_WALK_AGITATED);
	g_Activities.SetValue("ACT_WALK_ANGRY", ACT_WALK_ANGRY);
	g_Activities.SetValue("ACT_WALK_RELAXED", ACT_WALK_RELAXED);
	g_Activities.SetValue("ACT_WALK_AIM_STIMULATED", ACT_WALK_AIM_STIMULATED);
	g_Activities.SetValue("ACT_WALK_AIM_AGITATED", ACT_WALK_AIM_AGITATED);
	g_Activities.SetValue("ACT_WALK_CROUCH", ACT_WALK_CROUCH);
	g_Activities.SetValue("ACT_WALK_CROUCH_AIM", ACT_WALK_CROUCH_AIM);
	g_Activities.SetValue("ACT_MP_WALK_PRIMARY", ACT_MP_WALK_PRIMARY);
	g_Activities.SetValue("ACT_MP_WALK_SECONDARY", ACT_MP_WALK_SECONDARY);
	g_Activities.SetValue("ACT_MP_WALK_MELEE", ACT_MP_WALK_MELEE);
	g_Activities.SetValue("ACT_MP_WALK_SECONDARY2", ACT_MP_WALK_SECONDARY2);
	g_Activities.SetValue("ACT_MP_WALK_ITEM1", ACT_MP_WALK_ITEM1);
	g_Activities.SetValue("ACT_MP_WALK_ITEM2", ACT_MP_WALK_ITEM2);
	g_Activities.SetValue("ACT_RUN", ACT_RUN);
	g_Activities.SetValue("ACT_RUN_STIMULATED", ACT_RUN_STIMULATED);
	g_Activities.SetValue("ACT_RUN_AGITATED", ACT_RUN_AGITATED);
	g_Activities.SetValue("ACT_RUN_RELAXED", ACT_RUN_RELAXED);
	g_Activities.SetValue("ACT_RUN_AIM_STIMULATED", ACT_RUN_AIM_STIMULATED);
	g_Activities.SetValue("ACT_RUN_AIM_AGITATED", ACT_RUN_AIM_AGITATED);
	g_Activities.SetValue("ACT_RUN_AIM_RELAXED", ACT_RUN_AIM_RELAXED);
	g_Activities.SetValue("ACT_RUN_CROUCH", ACT_RUN_CROUCH);
	g_Activities.SetValue("ACT_RUN_CROUCH_AIM", ACT_RUN_CROUCH_AIM);
	g_Activities.SetValue("ACT_MP_RUN_PRIMARY", ACT_MP_RUN_PRIMARY);
	g_Activities.SetValue("ACT_MP_RUN_SECONDARY", ACT_MP_RUN_SECONDARY);
	g_Activities.SetValue("ACT_MP_RUN_MELEE", ACT_MP_RUN_MELEE);
	g_Activities.SetValue("ACT_MP_RUN_SECONDARY2", ACT_MP_RUN_SECONDARY2);
	g_Activities.SetValue("ACT_MP_RUN_ITEM1", ACT_MP_RUN_ITEM1);
	g_Activities.SetValue("ACT_MP_RUN_ITEM2", ACT_MP_RUN_ITEM2);
	g_Activities.SetValue("ACT_JUMP", ACT_JUMP);
	g_Activities.SetValue("ACT_FLY", ACT_FLY);
	g_Activities.SetValue("ACT_LAND", ACT_LAND);
	g_Activities.SetValue("ACT_LEAP", ACT_LEAP);
	g_Activities.SetValue("ACT_CLIMB_UP", ACT_CLIMB_UP);
	g_Activities.SetValue("ACT_CLIMB_DOWN", ACT_CLIMB_DOWN);
	g_Activities.SetValue("ACT_CLIMB_DISMOUNT", ACT_CLIMB_DISMOUNT);

	// Attack activities
	g_Activities.SetValue("ACT_MELEE_ATTACK1", ACT_MELEE_ATTACK1);
	g_Activities.SetValue("ACT_MELEE_ATTACK2", ACT_MELEE_ATTACK2);
	g_Activities.SetValue("ACT_GESTURE_MELEE_ATTACK1", ACT_GESTURE_MELEE_ATTACK1);
	g_Activities.SetValue("ACT_GESTURE_MELEE_ATTACK2", ACT_GESTURE_MELEE_ATTACK2);
	g_Activities.SetValue("ACT_MELEE_ATTACK_SWING_GESTURE", ACT_MELEE_ATTACK_SWING_GESTURE);
	g_Activities.SetValue("ACT_RANGE_ATTACK1", ACT_RANGE_ATTACK1);
	g_Activities.SetValue("ACT_RANGE_ATTACK2", ACT_RANGE_ATTACK2);
	g_Activities.SetValue("ACT_GESTURE_RANGE_ATTACK1", ACT_GESTURE_RANGE_ATTACK1);
	g_Activities.SetValue("ACT_GESTURE_RANGE_ATTACK2", ACT_GESTURE_RANGE_ATTACK2);
	g_Activities.SetValue("ACT_RANGE_ATTACK1_LOW", ACT_RANGE_ATTACK1_LOW);
	g_Activities.SetValue("ACT_RANGE_ATTACK2_LOW", ACT_RANGE_ATTACK2_LOW);
	g_Activities.SetValue("ACT_GESTURE_RANGE_ATTACK1_LOW", ACT_GESTURE_RANGE_ATTACK1_LOW);
	g_Activities.SetValue("ACT_GESTURE_RANGE_ATTACK2_LOW", ACT_GESTURE_RANGE_ATTACK2_LOW);
	g_Activities.SetValue("ACT_SPECIAL_ATTACK1", ACT_SPECIAL_ATTACK1);
	g_Activities.SetValue("ACT_SPECIAL_ATTACK2", ACT_SPECIAL_ATTACK2);
	g_Activities.SetValue("ACT_RANGE_ATTACK_THROW", ACT_RANGE_ATTACK_THROW);
	g_Activities.SetValue("ACT_GESTURE_RANGE_ATTACK_THROW", ACT_GESTURE_RANGE_ATTACK_THROW);
	g_Activities.SetValue("ACT_RELOAD", ACT_RELOAD);
	g_Activities.SetValue("ACT_RELOAD_LOW", ACT_RELOAD_LOW);
	g_Activities.SetValue("ACT_RELOAD_START", ACT_RELOAD_START);
	g_Activities.SetValue("ACT_RELOAD_FINISH", ACT_RELOAD_FINISH);
	g_Activities.SetValue("ACT_GESTURE_RELOAD", ACT_GESTURE_RELOAD);
	g_Activities.SetValue("ACT_MP_ATTACK_STAND_MELEE", ACT_MP_ATTACK_STAND_MELEE);
	g_Activities.SetValue("ACT_MP_ATTACK_CROUCH_MELEE", ACT_MP_ATTACK_CROUCH_MELEE);
	g_Activities.SetValue("ACT_MP_ATTACK_SWIM_MELEE", ACT_MP_ATTACK_SWIM_MELEE);
	g_Activities.SetValue("ACT_MP_ATTACK_AIRWALK_MELEE", ACT_MP_ATTACK_AIRWALK_MELEE);

	// Flinch activities
	g_Activities.SetValue("ACT_SMALL_FLINCH", ACT_SMALL_FLINCH);
	g_Activities.SetValue("ACT_GESTURE_SMALL_FLINCH", ACT_GESTURE_SMALL_FLINCH);
	g_Activities.SetValue("ACT_BIG_FLINCH", ACT_BIG_FLINCH);
	g_Activities.SetValue("ACT_GESTURE_BIG_FLINCH", ACT_GESTURE_BIG_FLINCH);
	g_Activities.SetValue("ACT_GESTURE_FLINCH_BLAST", ACT_GESTURE_FLINCH_BLAST);
	g_Activities.SetValue("ACT_FLINCH_HEAD", ACT_FLINCH_HEAD);
	g_Activities.SetValue("ACT_GESTURE_FLINCH_HEAD", ACT_GESTURE_FLINCH_HEAD);
	g_Activities.SetValue("ACT_FLINCH_CHEST", ACT_FLINCH_CHEST);
	g_Activities.SetValue("ACT_GESTURE_FLINCH_CHEST", ACT_GESTURE_FLINCH_CHEST);
	g_Activities.SetValue("ACT_FLINCH_STOMACH", ACT_FLINCH_STOMACH);
	g_Activities.SetValue("ACT_GESTURE_FLINCH_STOMACH", ACT_GESTURE_FLINCH_STOMACH);
	g_Activities.SetValue("ACT_FLINCH_LEFTARM", ACT_FLINCH_LEFTARM);
	g_Activities.SetValue("ACT_GESTURE_FLINCH_LEFTARM", ACT_GESTURE_FLINCH_LEFTARM);
	g_Activities.SetValue("ACT_FLINCH_RIGHTARM", ACT_FLINCH_RIGHTARM);
	g_Activities.SetValue("ACT_GESTURE_FLINCH_RIGHTARM", ACT_GESTURE_FLINCH_RIGHTARM);
	g_Activities.SetValue("ACT_FLINCH_LEFTLEG", ACT_FLINCH_LEFTLEG);
	g_Activities.SetValue("ACT_GESTURE_FLINCH_LEFTLEG", ACT_GESTURE_FLINCH_LEFTLEG);
	g_Activities.SetValue("ACT_FLINCH_RIGHTLEG", ACT_FLINCH_RIGHTLEG);
	g_Activities.SetValue("ACT_GESTURE_FLINCH_RIGHTLEG", ACT_GESTURE_FLINCH_RIGHTLEG);

	// Death activities
	g_Activities.SetValue("ACT_DIESIMPLE", ACT_DIESIMPLE);
	g_Activities.SetValue("ACT_DIE_HEADSHOT", ACT_DIE_HEADSHOT);
	g_Activities.SetValue("ACT_DIE_CHESTSHOT", ACT_DIE_CHESTSHOT);
	g_Activities.SetValue("ACT_DIE_GUTSHOT", ACT_DIE_GUTSHOT);
	g_Activities.SetValue("ACT_DIE_BACKSHOT", ACT_DIE_BACKSHOT);

	// Rage activites
	g_Activities.SetValue("ACT_BUSY_QUEUE", ACT_BUSY_QUEUE);

	// Flee starting activities
	g_Activities.SetValue("ACT_SIGNAL1", ACT_SIGNAL1);
	g_Activities.SetValue("ACT_SIGNAL2", ACT_SIGNAL2);
	g_Activities.SetValue("ACT_SIGNAL3", ACT_SIGNAL3);

	// Heal activities
	g_Activities.SetValue("ACT_USE", ACT_USE);
	g_Activities.SetValue("ACT_BUSY_QUEUE", ACT_BUSY_QUEUE);
	g_Activities.SetValue("ACT_SHIELD_UP", ACT_SHIELD_UP);
	g_Activities.SetValue("ACT_SHIELD_UP_IDLE", ACT_SHIELD_UP_IDLE);
	g_Activities.SetValue("ACT_CROUCHING_SHIELD_UP", ACT_CROUCHING_SHIELD_UP);
	g_Activities.SetValue("ACT_CROUCHING_SHIELD_UP_IDLE", ACT_CROUCHING_SHIELD_UP_IDLE);

	// Misc activities
	g_Activities.SetValue("ACT_TRANSITION", ACT_TRANSITION); // Spawn animation
	g_Activities.SetValue("ACT_DISARM", ACT_DISARM); // Spawn animation
	g_Activities.SetValue("ACT_BUSY_STAND", ACT_BUSY_STAND); // Detected animation
	g_Activities.SetValue("ACT_VICTORY_DANCE", ACT_VICTORY_DANCE); // Taunt kill animation
	g_Activities.SetValue("ACT_MP_GESTURE_VC_HANDMOUTH_MELEE", ACT_MP_GESTURE_VC_HANDMOUTH_MELEE);
	g_Activities.SetValue("ACT_MP_GESTURE_VC_FINGERPOINT_MELEE", ACT_MP_GESTURE_VC_FINGERPOINT_MELEE);
	g_Activities.SetValue("ACT_MP_GESTURE_VC_FISTPUMP_MELEE", ACT_MP_GESTURE_VC_FISTPUMP_MELEE);
	g_Activities.SetValue("ACT_MP_GESTURE_VC_THUMBSUP_MELEE", ACT_MP_GESTURE_VC_THUMBSUP_MELEE);
	g_Activities.SetValue("ACT_MP_GESTURE_VC_NODYES_MELEE", ACT_MP_GESTURE_VC_NODYES_MELEE);
	g_Activities.SetValue("ACT_MP_GESTURE_VC_NODNO_MELEE", ACT_MP_GESTURE_VC_NODNO_MELEE);
}

Activity TranslateProfileActivityFromName(const char[] activityName)
{
	Activity activity;
	if (g_Activities.GetValue(activityName, activity))
	{
		return activity;
	}

	return ACT_INVALID;
}

int LookupProfileAnimation(int entity, const char[] animName)
{
	CBaseAnimating animator = CBaseAnimating(entity);
	if (animName[0] == '\0')
	{
		return -1;
	}

	int sequence = -1;
	Activity activity = TranslateProfileActivityFromName(animName);
	if (activity != ACT_INVALID)
	{
		sequence = animator.SelectWeightedSequence(activity);
	}
	else
	{
		sequence = animator.LookupSequence(animName);
	}

	return sequence;
}

int GetMaxProfileDifficultySuffixSize()
{
	return 11;
}

void GetCurrentBossPack(char[] bossPackName, int length)
{
	g_BossPackConfig.Rewind();
	if (!g_BossPackConfig.JumpToKey("packs"))
	{
		return;
	}
	if (!g_BossPackConfig.JumpToKey(mapBossPack))
	{
		return;
	}
	g_BossPackConfig.GetString("name", bossPackName, length, mapBossPack);
	if (bossPackName[0] == '\0')
	{
		FormatEx(bossPackName, length, "Core Pack");
	}
}

/*
Command
*/
Action Command_Pack(int client,int args)
{
	if (!g_BossPackEndOfMapVoteConVar.BoolValue || !g_BossPackVoteEnabled)
	{
		CPrintToChat(client, "{royalblue}%t {default}%t", "SF2 Prefix", "SF2 Disabled Boss Pack");
		return Plugin_Handled;
	}
	char bossPackName[64];
	GetCurrentBossPack(bossPackName, sizeof(bossPackName));
	CPrintToChat(client, "{royalblue}%t {default}%t", "SF2 Prefix", "SF2 Current Boss Pack", bossPackName);
	return Plugin_Handled;
}

Action Command_NextPack(int client,int args)
{
	if (!g_BossPackEndOfMapVoteConVar.BoolValue || !g_BossPackVoteEnabled)
	{
		CPrintToChat(client, "{royalblue}%t {default}%t", "SF2 Prefix", "SF2 Disabled Boss Pack");
		return Plugin_Handled;
	}

	char nextpack[128];
	g_BossProfilePackConVar.GetString(nextpack, sizeof(nextpack));

	if (strcmp(nextpack, "") == 0)
	{
		CPrintToChat(client,"{royalblue}%t {lightblue}%t.","SF2 Prefix","Pending Vote");
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
		FormatEx(bossPackName, sizeof(bossPackName), "Core Pack");
	}
	CPrintToChat(client, "{royalblue}%t {default}%t", "SF2 Prefix", "SF2 Boss Pack Next", bossPackName);
	return Plugin_Handled;
}

void BossProfilesOnMapEnd()
{
	ClearBossProfiles();
}

BaseBossProfile GetBossProfile(const char[] profile)
{
	BaseBossProfile data = null;
	if (g_BossProfileData.GetValue(profile, data))
	{
		return data;
	}

	return null;
}

void UnloadBossProfile(const char[] profile)
{
	if (!IsProfileValid(profile))
	{
		return;
	}

	LogSF2Message("Unloading %s...", profile);

	BaseBossProfile profileData;
	g_BossProfileData.GetValue(profile, profileData);

	Call_StartForward(g_OnBossProfileUnloadedFwd);
	Call_PushString(profile);
	Call_PushCell(profileData);
	Call_Finish();

	int index = g_BossProfileList.FindString(profile);
	if (index != -1)
	{
		g_BossProfileList.Erase(index);
	}

	index = g_SelectableBossProfileList.FindString(profile);
	if (index != -1)
	{
		g_SelectableBossProfileList.Erase(index);
	}

	index = g_SelectableAdminBossProfileList.FindString(profile);
	if (index != -1)
	{
		g_SelectableAdminBossProfileList.Erase(index);
	}

	index = g_SelectableRenevantBossAdminProfileList.FindString(profile);
	if (index != -1)
	{
		g_SelectableRenevantBossAdminProfileList.Erase(index);
	}

	if (profileData.IsPvEBoss)
	{
		UnregisterPvESlenderBoss(profile);
	}

	CleanupKeyMap(profileData);

	g_BossProfileData.Remove(profile);
}

/**
 *	Clears all data and memory currently in use by all boss profiles.
 */
void ClearBossProfiles()
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	if (g_BossProfileList == null)
	{
		return;
	}

	for (int i = 0; i < g_BossProfileList.Length; i++)
	{
		g_BossProfileList.GetString(i, profile, sizeof(profile));

		if (!IsProfileValid(profile))
		{
			continue;
		}

		UnloadBossProfile(profile);
		i--;
	}

	if (g_SelectableBossProfileList != null)
	{
		delete g_SelectableBossProfileList;
	}

	if (g_SelectableAdminBossProfileList != null)
	{
		delete g_SelectableAdminBossProfileList;
	}

	if (g_SelectableRenevantBossAdminProfileList != null)
	{
		delete g_SelectableRenevantBossAdminProfileList;
	}

	g_BossProfileList.Clear();
	g_BossProfileData.Clear();
}

void ReloadBossProfiles()
{
	if (g_BossPackConfig != null)
	{
		delete g_BossPackConfig;
	}

	Profiler profiler = new Profiler();
	profiler.Start();

	// Clear and reload the lists.
	ClearBossProfiles();

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

	if (g_SelectableRenevantBossAdminProfileList == null)
	{
		g_SelectableRenevantBossAdminProfileList = new ArrayList(SF2_MAX_PROFILE_NAME_LENGTH);
	}

	if (g_SelectableBossProfileQueueList != null)
	{
		delete g_SelectableBossProfileQueueList;
	}

	char configPath[PLATFORM_MAX_PATH];

	// Only load profiles individually from configs/sf2/profiles or data/sf2/profiles directory.
	if (!g_UseAlternateConfigDirectoryConVar.BoolValue)
	{
		LoadProfilesFromDirectory(FILE_PROFILES_DIR, g_MaxCorePackBosses.IntValue);
	}
	else
	{
		LoadProfilesFromDirectory(FILE_PROFILES_DIR_DATA, g_MaxCorePackBosses.IntValue);
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

				bool autoLoad = g_BossPackConfig.GetNum("autoload") != 0;

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
						int maxLoadedBosses = -1;
						if (g_BossPackConfig.JumpToKey("shuffler"))
						{
							maxLoadedBosses = g_BossPackConfig.GetNum("max", maxLoadedBosses);
						}
						LoadProfilesFromDirectory(packConfigFilePath, maxLoadedBosses);
					}

					if (!voteBossPackLoaded)
					{
						if (!autoLoad && strcmp(mapBossPack, bossPackName) == 0)
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
							int maxLoadedBosses = -1;
							if (g_BossPackConfig.JumpToKey("shuffler"))
							{
								maxLoadedBosses = g_BossPackConfig.GetNum("max", maxLoadedBosses);
							}
							LoadProfilesFromDirectory(packConfigFilePath, maxLoadedBosses);
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
	g_SelectableBossProfileQueueList = g_SelectableBossProfileList.Clone();

	g_BossProfilePackConVar.SetString("");

	profiler.Stop();
	LogSF2Message("Time to take to load all boss configs: %f", profiler.Time);

	delete profiler;
}

/**
 * Loads a profile from the specified file.
 */
static bool LoadProfileFile(const char[] profilePath, char[] profileName, int profileNameLen, char[] errorReason, int errorReasonLen, bool lookIntoLoads = false, const char[] originalDir)
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

	BaseBossProfile profileData = view_as<BaseBossProfile>(KeyValuesToKeyMap(kv));

	delete kv;

	bool selectable = true;
	if (profileData.GetMapSelectionBlacklist() != null)
	{
		char currentMap[128];
		GetCurrentMap(currentMap, sizeof(currentMap));

		for (int i = 0; i < profileData.GetMapSelectionBlacklist().KeyLength; i++)
		{
			char key[64], map[128];
			profileData.GetMapSelectionBlacklist().GetKeyNameFromIndex(i, key, sizeof(key));
			profileData.GetMapSelectionBlacklist().GetString(key, map, sizeof(map));

			if (StrContains(currentMap, map, false) != -1)
			{
				selectable = false;
			}
		}
	}

	if (profileData.GetModeSelectionBlacklist() != null)
	{
		if (selectable && SF_IsBoxingMap() && profileData.GetModeSelectionBlacklist().GetBool("boxing", false))
		{
			selectable = false;
		}

		if (selectable && SF_IsProxyMap() && profileData.GetModeSelectionBlacklist().GetBool("proxy", false))
		{
			selectable = false;
		}

		if (selectable && SF_IsRaidMap() && profileData.GetModeSelectionBlacklist().GetBool("raid", false))
		{
			selectable = false;
		}

		if (selectable && SF_IsRenevantMap() && profileData.GetModeSelectionBlacklist().GetBool("renevant", false))
		{
			selectable = false;
		}

		if (selectable && SF_IsSlaughterRunMap() && profileData.GetModeSelectionBlacklist().GetBool("slaughter_run", false))
		{
			selectable = false;
		}

		if (selectable && SF_IsSurvivalMap() && profileData.GetModeSelectionBlacklist().GetBool("survival", false))
		{
			selectable = false;
		}
	}

	char path[PLATFORM_MAX_PATH];

	if (lookIntoLoads)
	{
		bool skip = true;
		if (selectable)
		{
			skip = false;
		}

		if (profileData.GetBool("admin_only", false))
		{
			skip = false;
		}

		if (profileData.GetBool("enable_random_selection_renevant_admin", false))
		{
			skip = false;
		}

		if (profileData.GetBool("is_pve", false) && profileData.GetBool("pve_selectable", true))
		{
			skip = false;
		}

		if (profileData.GetBool("always_load", false))
		{
			skip = false;
		}

		ProfileObject pve = profileData.GetSection("pve");
		if (pve != null && pve.GetBool("selectable", true))
		{
			skip = false;
		}

		if (skip)
		{
			FormatEx(errorReason, errorReasonLen, "is not selectable, skipping!");
			CleanupKeyMap(profileData);
			return false;
		}
	}

	if (profileData.Type <= SF2BossType_Unknown || profileData.Type >= SF2BossType_MaxTypes)
	{
		FormatEx(errorReason, errorReasonLen, "boss type is unknown!");
		return false;
	}

	for (int i = 0; i < Difficulty_Max; i++)
	{
		profileData.GetModel(i, path, sizeof(path));
		if (path[0] == '\0')
		{
			FormatEx(errorReason, errorReasonLen, "model cannot be blank!");
			CleanupKeyMap(profileData);
			return false;
		}
	}

	UnloadBossProfile(profileName);

	profileData.Precache();

	g_BossProfileData.SetValue(profileName, profileData);

	int index = g_BossProfileList.FindString(profileName);
	if (index == -1)
	{
		g_BossProfileList.PushString(profileName);
	}

	if (profileData.IsPvEBoss)
	{
		selectable = false;
		if (profileData.GetPvEData().IsSelectable)
		{
			RegisterPvESlenderBoss(profileName);
		}
	}

	if (selectable)
	{
		if (profileData.GetBool("enable_random_selection", true))
		{
			if (GetSelectableBossProfileList().FindString(profileName) == -1)
			{
				// Add to the selectable boss list if it isn't there already.
				GetSelectableBossProfileList().PushString(profileName);
			}
		}

		if (profileData.GetBool("admin_only", false))
		{
			if (GetSelectableAdminBossProfileList().FindString(profileName) == -1)
			{
				// Add to the selectable boss list if it isn't there already.
				GetSelectableAdminBossProfileList().PushString(profileName);
			}
		}

		if (profileData.GetBool("enable_random_selection_renevant_admin", false))
		{
			if (GetSelectableRenevantBossAdminProfileList().FindString(profileName) == -1)
			{
				// Add to the selectable boss list if it isn't there already.
				GetSelectableRenevantBossAdminProfileList().PushString(profileName);
			}
		}
	}

	Call_StartForward(g_OnBossProfileLoadedFwd);
	Call_PushString(profileName);
	Call_PushCell(profileData);
	Call_Finish();

	return true;
}

static void LoadProfilesFromDirectory(const char[] relDirPath, int maxLoadedBosses = -1)
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

	ArrayList directories = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));

	while (directory.GetNext(fileName, sizeof(fileName), fileType))
	{
		if (fileType == FileType_Directory)
		{
			continue;
		}

		FormatEx(filePath, sizeof(filePath), "%s/%s", relDirPath, fileName);
		BuildPath(Path_SM, filePath, sizeof(filePath), filePath);

		directories.PushString(filePath);
	}

	delete directory;

	ArrayList alwaysLoad;

	if (maxLoadedBosses > 0)
	{
		alwaysLoad = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));

		for (int i = 0; i < directories.Length; i++)
		{
			directories.GetString(i, filePath, sizeof(filePath));

			if (FileExists(filePath))
			{
				KeyValues kv = new KeyValues("root");
				if (FileToKeyValues(kv, filePath) && kv.GetNum("always_load", false) != 0)
				{
					int index = directories.FindString(filePath);
					if (index != -1)
					{
						directories.Erase(index);
					}
					alwaysLoad.PushString(filePath);
					i--;
				}

				delete kv;
			}
		}
	}

	if (alwaysLoad != null)
	{
		for (int i = 0; i < alwaysLoad.Length; i++)
		{
			alwaysLoad.GetString(i, filePath, sizeof(filePath));

			if (!LoadProfileFile(filePath, profileName, sizeof(profileName), errorReason, sizeof(errorReason), maxLoadedBosses > 0, dirPath))
			{
				LogSF2Message("(ALWAYS LOAD) %s...FAILED (reason: %s)", filePath, errorReason);
			}
			else
			{
				LogSF2Message("(ALWAYS LOAD) %s...", profileName, filePath);
			}
		}

		delete alwaysLoad;
	}

	if (maxLoadedBosses > 0)
	{
		directories.Sort(Sort_Random, Sort_String);
	}

	for (int i = 0; i < directories.Length; i++)
	{
		if (maxLoadedBosses > 0 && count == maxLoadedBosses)
		{
			break;
		}

		directories.GetString(i, filePath, sizeof(filePath));

		if (!LoadProfileFile(filePath, profileName, sizeof(profileName), errorReason, sizeof(errorReason), maxLoadedBosses > 0, dirPath))
		{
			LogSF2Message("%s...FAILED (reason: %s)", filePath, errorReason);
		}
		else
		{
			LogSF2Message("%s...", profileName, filePath);
			count++;
		}
	}

	delete directories;

	LogSF2Message("Loaded %d boss profile(s) from directory %s!", count, relDirPath);
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
	if (initiator < 33) //A admin called the command, it's probably for a good reason
	{
		g_BossPackVoteCompleted = false;
	}
	if (g_BossPackVoteStarted || g_BossPackVoteCompleted || NativeVotes_IsVoteInProgress())
	{

	}
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
	FormatEx(title, 255, "%t%t", "SF2 Prefix", "SF2 Boss Pack Vote Menu Title");
	NativeVotes_SetDetails(voteMenu, title);
	StringMap menuDisplayNamesTrie = new StringMap();
	ArrayList menuOptionsInfo = new ArrayList(128);
	int voteIndex = 0;
	bool incrementReached = false;

	do
	{
		if (g_BossPackConfig.GetNum("autoload", false) == 0 && g_BossPackConfig.GetNum("show_in_vote", true) != 0)
		{
			char bossPack[128];
			g_BossPackConfig.GetSectionName(bossPack, sizeof(bossPack));
			if (strcmp(bossPack,mapBossPack) != 0)
			{
				char bossPackName[64];
				g_BossPackConfig.GetString("name", bossPackName, sizeof(bossPackName), bossPack);

				menuDisplayNamesTrie.SetString(bossPack, bossPackName);
				menuOptionsInfo.PushString(bossPack);
				if (!incrementReached)
				{
					voteIndex++;
				}
			}
			else
			{
				incrementReached = true;
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

	ArrayList menuOptionsInfoOrder = menuOptionsInfo.Clone();

	if (voteIndex == menuOptionsInfoOrder.Length)
	{
		voteIndex = 0;
	}

	if (g_BossPackVoteShuffleConVar.BoolValue)
	{
		menuOptionsInfo.Sort(Sort_Random, Sort_String);
	}

	int loopLength = 5;
	bool incrementPack = false;
	for (int i = 0; i < menuOptionsInfo.Length; i++)
	{
		if (i <= loopLength)
		{
			char bossPack[128], bossPackName[64];
			if (i == 0 && !incrementPack)
			{
				menuOptionsInfoOrder.GetString(voteIndex, bossPack, sizeof(bossPack));
				int packIndex = menuOptionsInfo.FindString(bossPack);
				if (packIndex != -1)
				{
					menuOptionsInfo.Erase(packIndex);
					i--;
					loopLength--;
					incrementPack = true;
				}
			}
			else
			{
				menuOptionsInfo.GetString(i, bossPack, sizeof(bossPack));
			}
			menuDisplayNamesTrie.GetString(bossPack, bossPackName, sizeof(bossPackName));
			NativeVotes_AddItem(voteMenu, bossPack, bossPackName);
		}
	}

	delete menuDisplayNamesTrie;
	delete menuOptionsInfo;
	delete menuOptionsInfoOrder;

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

static int Menu_BossPackVote(Handle menu, MenuAction action,int param1,int param2)
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
	return 0;
}

static Action Timer_StartBossPackVote(Handle timer)
{
	if (timer != g_BossPackVoteMapTimer)
	{
		return Plugin_Stop;
	}

	g_BossPackVoteTimer = CreateTimer(5.0, Timer_BossPackVoteLoop, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_BossPackVoteTimer, true);

	return Plugin_Handled;
}

static Action Timer_BossPackVoteLoop(Handle timer)
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
	return GetBossProfileList().FindString(profile) != -1;
}

int GetProfileNum(const char[] profile, const char[] keyValue, int defaultValue = 0)
{
	if (!IsProfileValid(profile))
	{
		return defaultValue;
	}

	return GetBossProfile(profile).GetInt(keyValue, defaultValue);
}

float GetProfileFloat(const char[] profile, const char[] keyValue, float defaultValue = 0.0)
{
	if (!IsProfileValid(profile))
	{
		return defaultValue;
	}

	return GetBossProfile(profile).GetFloat(keyValue, defaultValue);
}

bool GetProfileVector(const char[] profile, const char[] keyValue, float buffer[3], const float defaultValue[3] = NULL_VECTOR)
{
	for (int i = 0; i < 3; i++)
	{
		buffer[i] = defaultValue[i];
	}

	if (!IsProfileValid(profile))
	{
		return false;
	}

	GetBossProfile(profile).GetVector(keyValue, buffer, defaultValue);
	return true;
}

bool GetProfileString(const char[] profile, const char[] keyValue, char[] buffer, int bufferLen, const char[] defaultValue = "")
{
	strcopy(buffer, bufferLen, defaultValue);

	if (!IsProfileValid(profile))
	{
		return false;
	}

	GetBossProfile(profile).GetString(keyValue, buffer, bufferLen, defaultValue);
	return true;
}

// Code originally from FF2. Credits to the original authors Rainbolt Dash and FlaminSarge.
bool GetRandomStringFromProfile(const char[] profile, const char[] keyValue, char[] buffer, int bufferLen, int index = -1, int attackIndex = -1, int &result = 0)
{
	buffer[0] = '\0';
	result = 0;

	if (!IsProfileValid(profile))
	{
		return false;
	}

	BaseBossProfile profileData = GetBossProfile(profile);
	ProfileObject section = profileData.GetSection(keyValue);
	if (section == null)
	{
		return false;
	}
	ProfileObject selectedSection = null;

	char s[32], s2[PLATFORM_MAX_PATH], s3[64];
	int i = 1;
	if (attackIndex != -1)
	{
		FormatEx(s3, sizeof(s3), "%d", attackIndex);
		ProfileObject attack = section.GetSection(s3);
		if (attack == null)
		{
			selectedSection = attack;
			for (;;)
			{
				FormatEx(s, sizeof(s), "%d", i);
				attack.GetString(s, s2, sizeof(s2));
				if (s2[0] == '\0')
				{
					break;
				}

				i++;
			}
		}
		else
		{
			selectedSection = section;
			for (;;)
			{
				FormatEx(s, sizeof(s), "%d", i);
				section.GetString(s, s2, sizeof(s2));
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
		selectedSection = section;
		for (;;)
		{
			FormatEx(s, sizeof(s), "%d", i);
			section.GetString(s, s2, sizeof(s2));
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
	selectedSection.GetString(s, buffer, bufferLen);
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

ArrayList GetSelectableAdminBossProfileList()
{
	return g_SelectableAdminBossProfileList;
}

ArrayList GetSelectableRenevantBossAdminProfileList()
{
	return g_SelectableRenevantBossAdminProfileList;
}

/**
 * Returns an array of boss that didn't play in game yet.
 */
ArrayList GetSelectableBossProfileQueueList()
{
	if (g_SelectableBossProfileQueueList.Length <= 0) //If every boss were selected at least once, refill the list.
	{
		delete g_SelectableBossProfileQueueList;
		g_SelectableBossProfileQueueList = GetSelectableBossProfileList().Clone();
	}

	if (g_SelectableBossProfileQueueList == null)
	{
		g_SelectableBossProfileQueueList = GetSelectableBossProfileList().Clone();
	}

	return g_SelectableBossProfileQueueList;
}

void RemoveBossProfileFromQueueList(const char[] profile)
{
	int selectIndex = GetSelectableBossProfileQueueList().FindString(profile);
	if (selectIndex != -1)
	{
		GetSelectableBossProfileQueueList().Erase(selectIndex);
	}
}

static any Native_TranslateProfileActivityFromName(Handle plugin, int numParams)
{
	char activityName[64];
	GetNativeString(1, activityName, sizeof(activityName));
	return TranslateProfileActivityFromName(activityName);
}

static any Native_LookupProfileAnimation(Handle plugin, int numParams)
{
	char animationName[64];
	GetNativeString(2, animationName, sizeof(animationName));
	return LookupProfileAnimation(GetNativeCell(1), animationName);
}

static any Native_IsBossProfileValid(Handle plugin, int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, SF2_MAX_PROFILE_NAME_LENGTH);

	return IsProfileValid(profile);
}

static any Native_GetBossProfileNum(Handle plugin, int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, SF2_MAX_PROFILE_NAME_LENGTH);

	char keyValue[256];
	GetNativeString(2, keyValue, sizeof(keyValue));

	return GetProfileNum(profile, keyValue, GetNativeCell(3));
}

static any Native_GetBossProfileFloat(Handle plugin, int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, SF2_MAX_PROFILE_NAME_LENGTH);

	char keyValue[256];
	GetNativeString(2, keyValue, sizeof(keyValue));

	return GetProfileFloat(profile, keyValue, GetNativeCell(3));
}

static any Native_GetBossProfileString(Handle plugin, int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, SF2_MAX_PROFILE_NAME_LENGTH);

	char keyValue[256];
	GetNativeString(2, keyValue, sizeof(keyValue));

	int resultLen = GetNativeCell(4);
	char[] result = new char[resultLen];

	char defaultValue[512];
	GetNativeString(5, defaultValue, sizeof(defaultValue));

	bool success = GetProfileString(profile, keyValue, result, resultLen, defaultValue);

	SetNativeString(3, result, resultLen);
	return success;
}

static any Native_GetBossProfileVector(Handle plugin, int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, SF2_MAX_PROFILE_NAME_LENGTH);

	char keyValue[256];
	GetNativeString(2, keyValue, sizeof(keyValue));

	float result[3];
	float defaultValue[3];
	GetNativeArray(4, defaultValue, 3);

	bool success = GetProfileVector(profile, keyValue, result, defaultValue);

	SetNativeArray(3, result, 3);
	return success;
}

static any Native_GetBossAttackProfileNum(Handle plugin, int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, SF2_MAX_PROFILE_NAME_LENGTH);

	char keyValue[256];
	GetNativeString(2, keyValue, sizeof(keyValue));

	return GetProfileAttackNum(profile, keyValue, GetNativeCell(3), GetNativeCell(4));
}

static any Native_GetBossAttackProfileFloat(Handle plugin, int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, SF2_MAX_PROFILE_NAME_LENGTH);

	char keyValue[256];
	GetNativeString(2, keyValue, sizeof(keyValue));

	return GetProfileAttackFloat(profile, keyValue, GetNativeCell(3), GetNativeCell(4));
}

static any Native_GetBossAttackProfileString(Handle plugin, int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, SF2_MAX_PROFILE_NAME_LENGTH);

	char keyValue[256];
	GetNativeString(2, keyValue, sizeof(keyValue));

	int resultLen = GetNativeCell(4);
	char[] result = new char[resultLen];

	char defaultValue[512];
	GetNativeString(5, defaultValue, sizeof(defaultValue));

	bool success = GetProfileAttackString(profile, keyValue, result, resultLen, defaultValue, GetNativeCell(6));

	SetNativeString(3, result, resultLen);
	return success;
}

static any Native_GetBossAttackProfileVector(Handle plugin, int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, SF2_MAX_PROFILE_NAME_LENGTH);

	char keyValue[256];
	GetNativeString(2, keyValue, sizeof(keyValue));

	float result[3];
	float defaultValue[3];
	GetNativeArray(4, defaultValue, 3);

	bool success = GetProfileAttackVector(profile, keyValue, result, defaultValue, GetNativeCell(5));

	SetNativeArray(3, result, 3);
	return success;
}

static any Native_GetRandomStringFromBossProfile(Handle plugin, int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, SF2_MAX_PROFILE_NAME_LENGTH);

	char keyValue[256];
	GetNativeString(2, keyValue, sizeof(keyValue));

	int bufferLen = GetNativeCell(4);
	char[] buffer = new char[bufferLen];

	int index = GetNativeCell(5);

	bool success = GetRandomStringFromProfile(profile, keyValue, buffer, bufferLen, index);
	SetNativeString(3, buffer, bufferLen);
	return success;
}

static any Native_GetBossAttributeName(Handle plugin, int numParams)
{
	int attributeIndex = GetNativeCell(2);

	bool success = NPCHasAttribute(GetNativeCell(1), attributeIndex);
	return success;
}

static any Native_GetBossAttributeValue(Handle plugin, int numParams)
{
	int attributeIndex = GetNativeCell(2);

	if (!NPCHasAttribute(GetNativeCell(1), attributeIndex))
	{
		return 0.0;
	}
	return NPCGetAttributeValue(GetNativeCell(1), attributeIndex);
}

static any Native_GetType(Handle plugin, int numParams)
{
	BaseBossProfile profileData = GetNativeCell(1);
	if (profileData == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", profileData);
	}

	return profileData.Type;
}

static any Native_GetIsPvEBoss(Handle plugin, int numParams)
{
	BaseBossProfile profileData = GetNativeCell(1);
	if (profileData == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", profileData);
	}

	return profileData.IsPvEBoss;
}