#if defined _sf2_included
 #endinput
#endif
#define _sf2_included

// Some defines.
#define SF2_MAX_PROFILE_NAME_LENGTH 64
#define SF2_MAX_NAME_LENGTH 32

#define MAX_BOSSES 32
#define MAX_NPCTELEPORTER 5
#define MAX_NODES -1

// Difficulty modifiers.
#define DIFFICULTY_EASY 0.75
#define DIFFICULTY_NORMAL 1.0
#define DIFFICULTY_HARD 2.0
#define DIFFICULTY_INSANE 3.5
#define DIFFICULTY_NIGHTMARE 5.5

// Music system flags.
#define MUSICF_PAGES1PERCENT (1 << 0)
#define MUSICF_PAGES25PERCENT (1 << 1)
#define MUSICF_PAGES50PERCENT (1 << 2)
#define MUSICF_PAGES75PERCENT (1 << 3)
#define MUSICF_DEATH (1 << 4)
#define MUSICF_CHASE (1 << 5)
#define MUSICF_CHASEVISIBLE (1 << 6)
#define MUSICF_ALERT (1 << 7)
#define MUSICF_20DOLLARS (1 << 8)

// Special round enumerations.
enum
{
	SPECIALROUND_DOUBLETROUBLE = 1,
	SPECIALROUND_INSANEDIFFICULTY,
	SPECIALROUND_SINGLEPLAYER,
	SPECIALROUND_DOUBLEMAXPLAYERS,
	SPECIALROUND_LIGHTSOUT,
	SPECIALROUND_BEACON,
	SPECIALROUND_DOOMBOX,
	SPECIALROUND_NOGRACE,
	SPECIALROUND_2DOUBLE,
	SPECIALROUND_DOUBLEROULETTE,
	SPECIALROUND_NIGHTVISION,
	SPECIALROUND_INFINITEFLASHLIGHT,
	SPECIALROUND_DREAMFAKEBOSSES,
	SPECIALROUND_EYESONTHECLOACK,
	SPECIALROUND_NOPAGEBONUS,
	SPECIALROUND_DUCKS,
	SPECIALROUND_1UP,
	SPECIALROUND_NOULTRAVISION,
	SPECIALROUND_SUPRISE,
	SPECIALROUND_LASTRESORT,
	SPECIALROUND_ESCAPETICKETS,
	SPECIALROUND_REVOLUTION,
	SPECIALROUND_DISTORTION,
	SPECIALROUND_MULTIEFFECT,
	SPECIALROUND_BOO,
	SPECIALROUND_REALISM,
	SPECIALROUND_VOTE,
	SPECIALROUND_COFFEE,
	SPECIALROUND_PAGEDETECTOR,
	SPECIALROUND_GLITCHEDPAGE,
	SPECIALROUND_CLASSSCRAMBLE,
	SPECIALROUND_EARTHQUAKE,
	SPECIALROUND_MAXROUNDS
};

// Boss state enumerations.
enum
{
	STATE_IDLE = 0,
	STATE_WANDER,
	STATE_ALERT,
	STATE_CHASE,
	STATE_ATTACK,
	STATE_STUN,
	MAX_STATE
};

enum SoundType
{
	SoundType_None = 0,
	SoundType_Footstep,
	SoundType_Voice,
	SoundType_Weapon
};

enum
{
	Difficulty_Easy = 0,
	Difficulty_Normal,
	Difficulty_Hard,
	Difficulty_Insane,
	Difficulty_Nightmare,
	Difficulty_Max
};

enum
{
	Static_None = 0,
	Static_Increase,
	Static_Decrease
};

enum
{
	SF2BossType_Unknown = -1,
	SF2BossType_Static = 0,
	SF2BossType_Creeper,
	SF2BossType_Chaser,
	SF2BossType_AdvancedChaser,
	SF2BossType_MaxTypes
};

enum SF2RoundState
{
	SF2RoundState_Invalid = -1,
	SF2RoundState_Waiting = 0,		// waiting for players
	SF2RoundState_Intro,				// if intro is enabled, intro stage for RED
	SF2RoundState_Active,			// round is running for RED
	SF2RoundState_Escape,			// escape stage for RED
	SF2RoundState_Outro				// round win for a team, next round coming soon
};

// Boss flags.
#define SFF_SPAWNONCE (1 << 0)
#define SFF_NOTELEPORT (1 << 1)
#define SFF_FAKE (1 << 2)
#define SFF_MARKEDASFAKE (1 << 3)
#define SFF_ATTACKWAITERS (1 << 4)
#define SFF_HASSTATICSHAKE (1 << 5)
#define SFF_STATICONLOOK (1 << 6)
#define SFF_STATICONRADIUS (1 << 7)
#define SFF_PROXIES (1 << 8)
#define SFF_WANDERMOVE (1 << 9)
#define SFF_HASJUMPSCARE (1 << 10)
#define SFF_HASSIGHTSOUNDS (1 << 11)
#define SFF_HASSTATICLOOPLOCALSOUND (1 << 12)
#define SFF_HASVIEWSHAKE (1 << 13)
#define SFF_COPIES (1 << 14)
#define SFF_ATTACKPROPS (1 << 15)

// Interrup conditions.
#define COND_HEARDSUSPICIOUSSOUND (1 << 0)
#define COND_HEARDFOOTSTEP (1 << 1)
#define COND_HEARDFOOTSTEPLOUD (1 << 2)
#define COND_HEARDWEAPON (1 << 3)
#define COND_HEARDVOICE (1 << 4)
#define COND_CHASETARGETINVALIDATED (1 << 5)
#define COND_SAWENEMY (1 << 5)


forward SF2_OnBossAdded(iBossIndex);

forward SF2_OnBossSpawn(iBossIndex);

forward SF2_OnBossChangeState(iBossIndex, iOldState, iNewState);

forward Action:SF2_OnBossAnimationUpdate(iBossIndex);

forward Action:SF2_OnBossGetSpeed(client, &Float:flSpeed);

forward Action:SF2_OnBossGetWalkSpeed(client, &Float:flWalkSpeed);

forward SF2_OnBossRemoved(iBossIndex);

forward SF2_OnPagesSpawned();

forward SF2_OnClientCollectPage(pageEnt, client);

forward SF2_OnClientBlinked(client);

forward SF2_OnClientCaughtByBoss(client, iBossIndex);

forward Action:SF2_OnClientGiveQueuePoints(client, &iAddAmount);

forward SF2_OnClientActivateFlashlight(client);

forward SF2_OnClientDeactivateFlashlight(client);

forward SF2_OnClientBreakFlashlight(client);

forward SF2_OnClientEscape(client);

forward SF2_OnClientLooksAtBoss(client, iBossIndex);

forward SF2_OnClientLooksAwayFromBoss(client, iBossIndex);

forward SF2_OnClientStartDeathCam(client, iBossIndex);

forward SF2_OnClientEndDeathCam(client, iBossIndex);

forward Action:SF2_OnClientGetDefaultWalkSpeed(client, &Float:flDefault);

forward Action:SF2_OnClientGetDefaultSprintSpeed(client, &Float:flDefault);

forward Action:SF2_OnClientTakeDamage(victim, attacker, &Float:damage);

forward Action:SF2_OnGroupGiveQueuePoints(iGroupIndex, &iAddAmount);

forward SF2_OnClientDamagedByBoss(client, iBossIndex, inflictor, Float:flDamage, iDamageType);

forward SF2_OnClientSpawnedAsProxy(client);

/**
 * Returns a bool about the gamemode's state.
 *
 * @return				True if the gamemode is running, false if not.
 */
native bool:SF2_IsRunning();

/**
 * Returns the current state of the round.
 *
 * @return				Current state or the round.
 */
native SF2_GetRoundState();

/**
 * Returns the current difficulty of the round.
 *
 * @return				Integer of the difficulty.
 */
native SF2_GetCurrentDifficulty();

/**
 * Returns the current difficulty of the round.
 *
 * @param iDifficulty	Difficulty number.
 * @return				Modifier float value of the indicated difficulty number.
 */
native Float:SF2_GetDifficultyModifier(iDifficulty);

/**
 * Returns a bool indicating whether or not a special round is currently running.
 *
 * @return				True if a special round is running, false if not.
 */
native bool:SF2_IsSpecialRoundRunning();

/**
 * Returns the type of special round that is running.
 *
 * @return				Special round type.
 */
native SF2_GetSpecialRoundType();

/**
 * Returns a bool about the client's elimination state.
 *
 * @param client		Client index.
 * @return				True if the player is eliminated, false if not.
 */
native bool:SF2_IsClientEliminated(client);

/**
 * Returns a bool about the client's ghost mode state.
 *
 * @param client		Client index.
 * @return				True if the player is in Ghost Mode, false if not.
 */
native bool:SF2_IsClientInGhostMode(client);

/**
 * Returns a bool if the client is in a Player vs. Player zone or not.
 *
 * @param client		Client index.
 * @return				True if the player is in a PvP zone, false if not.
 */
native bool:SF2_IsClientInPvP(client);

/**
 * Tells whether if the client is a Proxy or not.
 *
 * @param client		Client index.
 * @return				True if the player is a Proxy, false if not.
 */
native bool:SF2_IsClientProxy(client);

/**
 * Tells whether or not the client is looking at the boss.
 *
 * @param client		Client index.
 * @param iBossIndex	Boss index.
 * @return				True if the player is a Proxy, false if not.
 */
native bool:SF2_IsClientLookingAtBoss(client, iBossIndex);

/**
 * Gives the amount of times the client has blinked in one life. This count will reset upon spawn.
 *
 * @param client		Client index.
 * @return				Number of times the client has blinked in one life.
 */
native SF2_GetClientBlinkCount(client);

/**
 * If the client is a Proxy, then this returns the boss index that the client is associated with.
 *
 * @param client		Client index.
 * @return				If the client is a proxy, then this will return a boss index, -1 if not.
 */
native SF2_GetClientProxyMaster(client);

/**
 * If the client is a Proxy, then this returns the amount of Control points the client has left.
 *
 * @param client		Client index.
 * @return				If the client is a proxy, then this will return the amount of Control Points out of 100, else 0.
 */
native SF2_GetClientProxyControlAmount(client);

/**
 * If the client is a Proxy, then this returns the rate which each Control point will drain for the client.
 *
 * @param client		Client index.
 * @return				If the client is a proxy, then this will return a boss index, -1 if not.
 */
native Float:SF2_GetClientProxyControlRate(client);

native bool:SF2_DidClientEscape(client);

native SF2_SetClientProxyMaster(client, iBossIndex);

native SF2_SetClientProxyControlAmount(client, iAmount);

native SF2_SetClientProxyControlRate(client, Float:flAmount);

native SF2_CollectAsPage(pageEnt, client);

native SF2_GetMaxBossCount();

native SF2_EntIndexToBossIndex(iEntIndex);

native SF2_BossIndexToEntIndex(iBossIndex);

native SF2_BossIndexToEntIndexEx(iBossIndex); //Don't use this function unless you know what it does!!!! Most will not!

native SF2_BossIDToBossIndex(iBossID);

native SF2_BossIndexToBossID(iBossID);

native SF2_GetBossName(iBossIndex, String:sBuffer[], iBufferLen);

native SF2_GetBossModelEntity(iBossIndex);

native SF2_GetBossTarget(iBossIndex);

native SF2_GetBossMaster(iBossIndex);

native SF2_GetBossState(iBossIndex);

native Float:SF2_GetBossFOV(iBossIndex);

native bool:SF2_IsBossProfileValid(const String:sProfile[]);

native SF2_GetBossProfileNum(const String:sProfile[], const String:sKey[], iDefaultValue=0);

native Float:SF2_GetBossProfileFloat(const String:sProfile[], const String:sKey[], Float:flDefaultValue=0.0);

native bool:SF2_GetBossProfileString(const String:sProfile[], const String:sKey[], String:sBuffer[], iBufferLen, const String:sDefaultValue[]="");

native bool:SF2_GetBossProfileVector(const String:sProfile[], const String:sKey[], Float:flBuffer[3], const Float:flDefaultValue[3]=NULL_VECTOR);

native bool:SF2_GetRandomStringFromBossProfile(const String:sProfile, const String:sKey[], String:sBuffer[], iBufferLen, iIndex=-1);

native bool:SF2_IsSurvivalMap();

public SharedPlugin:__pl_sf2 = 
{
	name = "sf2",
	file = "sf2.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};