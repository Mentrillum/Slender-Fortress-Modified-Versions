#if defined _sf2_included
 #endinput
#endif
#define _sf2_included

#define PLUGIN_VERSION "1.7.5.05 M"
#define PLUGIN_VERSION_DISPLAY "1.7.5.05 M"

// Some defines.
#define SF2_MAX_PROFILE_NAME_LENGTH 64
#define SF2_MAX_NAME_LENGTH 32

#define MAX_BOSSES 64
#define MAX_NPCTELEPORTER 5
#define MAX_NODES -1
#define MAX_TRAPS 64
#define MAX_CLASSES 9

// Difficulty modifiers.
#define DIFFICULTYMODIFIER_EASY 0.75
#define DIFFICULTYMODIFIER_NORMAL 1.0
#define DIFFICULTYMODIFIER_HARD 1.1
#define DIFFICULTYMODIFIER_INSANE 1.35
#define DIFFICULTYMODIFIER_NIGHTMARE 1.75
#define DIFFICULTYMODIFIER_APOLLYON 5.5
#define DIFFICULTYMODIFIER_RESTARTSESSION 14.0

// Music system flags.
#define MUSICF_PAGES1PERCENT (1 << 0)
#define MUSICF_PAGES25PERCENT (1 << 1)
#define MUSICF_PAGES50PERCENT (1 << 2)
#define MUSICF_PAGES75PERCENT (1 << 3)
#define MUSICF_DEATH (1 << 4)
#define MUSICF_CHASE (1 << 5)
#define MUSICF_CHASEVISIBLE (1 << 6)
#define MUSICF_ALERT (1 << 7)
#define MUSICF_IDLE (1 << 8)

// Special round enumerations.
enum
{
	SPECIALROUND_DOUBLETROUBLE = 1,
	SPECIALROUND_INSANEDIFFICULTY,
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
	SPECIALROUND_VOTE,
	SPECIALROUND_COFFEE,
	SPECIALROUND_PAGEDETECTOR,
	SPECIALROUND_CLASSSCRAMBLE,
	SPECIALROUND_2DOOM,
	SPECIALROUND_PAGEREWARDS,
	SPECIALROUND_TINYBOSSES,
	SPECIALROUND_RUNNINGINTHE90S,
	SPECIALROUND_TRIPLEBOSSES,
	SPECIALROUND_MODBOSSES,
	SPECIALROUND_BOSSROULETTE,
	SPECIALROUND_THANATOPHOBIA,
	SPECIALROUND_WALLHAX,
	SPECIALROUND_SINGLEPLAYER,
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
	STATE_DEATHCAM,
	MAX_STATE
};

enum SoundType
{
	SoundType_None = 0,
	SoundType_Footstep,
	SoundType_QuietFootstep,
	SoundType_LoudFootstep,
	SoundType_Voice,
	SoundType_Weapon,
	SoundType_Flashlight,
	SoundType_Max
};

enum
{
	Difficulty_Easy = 0,
	Difficulty_Normal,
	Difficulty_Hard,
	Difficulty_Insane,
	Difficulty_Nightmare,
	Difficulty_Apollyon,
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
	SF2BossType_Statue,
	SF2BossType_Chaser,
	SF2BossType_AdvancedChaser,
	SF2BossType_MaxTypes
};

enum
{
	SF2BossSound_None = 0,
	SF2BossSound_Idle,
	SF2BossSound_Alert,
	SF2BossSound_Chasing,
	SF2BossSound_ChaseInitial,
	SF2BossSound_Stun = 5,
	SF2BossSound_Attack,
	SF2BossSound_AttackKilled,
	SF2BossSound_RageAll,
	SF2BossSound_RageTwo,
	SF2BossSound_RageThree = 10,
	SF2BossSound_SelfHeal,
	SF2BossSound_MaxSounds
};

enum
{
	SF2BossAnimation_Idle = 0,
	SF2BossAnimation_Walk,
	SF2BossAnimation_WalkAlert,
	SF2BossAnimation_Attack,
	SF2BossAnimation_Shoot,
	SF2BossAnimation_Run = 5,
	SF2BossAnimation_Stun,
	SF2BossAnimation_ChaseInitial,
	SF2BossAnimation_Rage,
	SF2BossAnimation_Spawn,
	SF2BossAnimation_FleeInitial = 10,
	SF2BossAnimation_Heal,
	SF2BossAnimation_DeathCam,
	SF2BossAnimation_CrawlWalk,
	SF2BossAnimation_CrawlRun,
	SF2BossAnimation_MaxAnimations = 15
}

enum SF2RoundState
{
	SF2RoundState_Invalid = -1,
	SF2RoundState_Waiting = 0,		// waiting for players
	SF2RoundState_Intro,				// if intro is enabled, intro stage for RED
	SF2RoundState_Grace,			// round is in grace period for RED
	SF2RoundState_Active,			// round is running for RED
	SF2RoundState_Escape,			// escape stage for RED
	SF2RoundState_Outro				// round win for a team, next round coming soon
};

enum
{
	SF2Attribute_ReducedSpeedOnLook = 0,
	SF2Attribute_ReducedWalkSpeedOnLook,
	SF2Attribute_AddStunHealhOnStun,
	SF2Attribute_AlwaysLookAtTarget,
	SF2Attribute_AlwaysLookAtTargetWhileChasing,
	SF2Attribute_AlwaysLookAtTargetWhileAttacking = 5,
	SF2Attribute_BleedPlayerOnHit,
	SF2Attribute_IgnitePlayerOnHit,
	SF2Attribute_StunPlayerOnHit,
	SF2Attribute_StunPlayerPercentage,
	SF2Attribute_JaratePlayerOnHit = 10,
	SF2Attribute_MilkPlayerOnHit,
	SF2Attribute_GasPlayerOnHit,
	SF2Attribute_IgnitePlayerOnScare,
	SF2Attribute_MarkPlayerForDeathOnScare,
	SF2Attribute_SilentMarkPlayerForDeathOnScare = 15,
	SF2Attribute_IgnitePlayerOnDeath,
	SF2Attribute_AddSpeedOnStun,
	SF2Attribute_AddMaxSpeedOnStun,
	SF2Attribute_DeathCamOnLowHealth,
	SF2Attribute_AlertCopies = 20,
	SF2Attribute_AlertCompanions,
	SF2Attribute_BlockWalkSpeedUnderDifficulty,
	SF2Attribute_ChaseTargetOnScare,
	SF2Attribute_IgnoreNonMarkedForChase,
	SF2Attribute_ReducedAccelerationOnLook = 25,
	SF2Attribute_AddAccelerationOnStun,
	SF2Attribute_Max
};

char g_SlenderVoiceList[SF2BossSound_MaxSounds][] =
{
	"sound_none", // Placeholder
	"sound_idle",
	"sound_alertofenemy",
	"sound_chasingenemy",
	"sound_chaseenemyinitial",
	"sound_stun",
	"sound_attackenemy",
	"sound_attack_killed",
	"sound_rage",
	"sound_rage_2",
	"sound_rage_3",
	"sound_heal_self"
};

char g_AttributesList[SF2Attribute_Max][] =
{
	"reduced speed on look",
	"reduced walk speed on look",
	"add stun health on stun",
	"always look at target",
	"always look at target while chasing",
	"always look at target while attacking",
	"bleed player on hit",
	"ignite player on hit",
	"stun player on hit",
	"stun player percentage",
	"jarate player on hit",
	"milk player on hit",
	"gas player on hit",
	"ignite player on scare",
	"mark player for death on scare",
	"silent mark player for death on scare",
	"ignite player on death",
	"add speed on stun",
	"add max speed on stun",
	"death cam on low health",
	"alert copies",
	"alert companions",
	"block walk speed under difficulty",
	"chase target on scare",
	"ignore non-marked for chase",
	"reduced acceleration on look",
	"add acceleration on stun"
};

enum ParticleAttachment
{
	PATTACH_ABSORIGIN = 0,			// Create at absorigin, but don't follow
	PATTACH_ABSORIGIN_FOLLOW,		// Create at absorigin, and update to follow the entity
	PATTACH_CUSTOMORIGIN,			// Create at a custom origin, but don't follow
	PATTACH_POINT,					// Create on attachment point, but don't follow
	PATTACH_POINT_FOLLOW,			// Create on attachment point, and update to follow the entity
	PATTACH_WORLDORIGIN,			// Used for control points that don't attach to an entity
	PATTACH_ROOTBONE_FOLLOW,		// Create at the root bone of the entity, and update to follow
	MAX_PATTACH_TYPES,
};

#include <sf2/defines>
#include <sf2/profiles/profiles>

// Boss flags.
#define SFF_SPAWNONCE (1 << 0)
#define SFF_NOTELEPORT (1 << 1)
#define SFF_FAKE (1 << 2)
#define SFF_MARKEDASFAKE (1 << 3)
#define SFF_ATTACKWAITERS (1 << 4)
#define SFF_STATICONLOOK (1 << 5)
#define SFF_STATICONRADIUS (1 << 6)
#define SFF_PROXIES (1 << 7)
#define SFF_WANDERMOVE (1 << 8)
#define SFF_HASJUMPSCARE (1 << 9)
#define SFF_HASSIGHTSOUNDS (1 << 10)
#define SFF_HASSTATICLOOPLOCALSOUND (1 << 11)
#define SFF_HASVIEWSHAKE (1 << 12)
#define SFF_COPIES (1 << 13)
#define SFF_ATTACKPROPS (1 << 14)
#define SFF_WEAPONKILLS (1 << 15)
#define SFF_WEAPONKILLSONRADIUS (1 << 16)

// Interrup conditions.
#define COND_HEARDSUSPICIOUSSOUND (1 << 0)
#define COND_HEARDFOOTSTEP (1 << 1)
#define COND_HEARDFOOTSTEPQUIET (1 << 2)
#define COND_HEARDFOOTSTEPLOUD (1 << 3)
#define COND_HEARDWEAPON (1 << 4)
#define COND_HEARDVOICE (1 << 5)
#define COND_CHASETARGETINVALIDATED (1 << 6)
#define COND_SAWENEMY (1 << 7)
#define COND_HEARDFLASHLIGHT (1 << 8)

// Projectile flags.
#define PROJ_FIREBALL (1 << 0)
#define PROJ_ICEBALL (1 << 1)
#define PROJ_ROCKET (1 << 2)
#define PROJ_SENTRYROCKET (1 << 3)
#define PROJ_GRENADE (1 << 4)
#define PROJ_ARROW (1 << 5)
#define PROJ_MANGLER (1 << 6)
#define PROJ_BASEBALL (1 << 7)
#define PROJ_FIREBALL_ATTACK (1 << 8)
#define PROJ_ICEBALL_ATTACK (1 << 9)

/**
 * Called after a boss profile is successfully loaded.
 *
 * @param profile      Profile name
 */
forward void SF2_OnBossProfileLoaded(const char[] profile);

/**
 * Called before a boss profile is unloaded.
 *
 * @param profile     Profile name
 */
forward void SF2_OnBossProfileUnloaded(const char[] profile);

/**
 * Called when a boss is added into the game.
 *
 * @param bossIndex	The index of the newly created boss.
 */
forward void SF2_OnBossAdded(int bossIndex);

/**
 * Called when the boss spawns into the map.
 *
 * @param bossIndex	Boss index.
 */
forward void SF2_OnBossSpawn(int bossIndex);

/**
 * Called when the boss despawns from the map.
 *
 * @param bossIndex	Boss index.
 */
forward void SF2_OnBossDespawn(int bossIndex);

/**
 * Called when the boss changes states. Currently only used for Chaser bosses.
 *
 * @param bossIndex	Boss index.
 * @param oldState		The old state.
 * @param newState		The new state.
 */
forward void SF2_OnBossChangeState(int bossIndex, int oldState, int newState);

/**
 * Called when the boss updates its animation.
 *
 * @param bossIndex	Boss index.
 * @return				If Plugin_Handled, animation change will be blocked.
 */
forward Action SF2_OnBossAnimationUpdate(int bossIndex);

/**
 * Called to determine the boss's run speed.
 *
 * @param bossIndex	Boss index.
 * @param speed		The boss's run speed.
 * @return				If Plugin_Changed, speed is used as the boss's run speed.
 */
forward Action SF2_OnBossGetSpeed(int bossIndex, float &speed);

/**
 * Called to determine the boss's walk speed.
 *
 * @param bossIndex	Boss index.
 * @param walkSpeed		The boss's walk speed.
 * @return				If Plugin_Changed, speed is used as the boss's walk speed.
 */
forward Action SF2_OnBossGetWalkSpeed(int bossIndex, float &walkSpeed);

/**
 * Called after the boss has determined it can hear the entity.
 *
 * @param bossIndex	Boss index.
 * @param entity		Entity index.
 * @param soundType			The type of sound to check.
 * @return				Returning a value other than Plugin_Continue will block hearing to the entity.
 */
forward Action SF2_OnBossHearEntity(int bossIndex, int entity, SoundType soundType);

/**
 * Called after the boss has determined it can see the entity.
 *
 * @param bossIndex	Boss index.
 * @param entity		Entity index.
 * @return				Returning a value other than Plugin_Continue will block vision to the entity.
 */
forward Action SF2_OnBossSeeEntity(int bossIndex, int entity);

/**
 * Called when a boss is removed from the game.
 *
 * @param bossIndex	The index of the boss to be removed.
 */
forward void SF2_OnBossRemoved(int bossIndex);

/**
 * Called when the boss gets stun by a player.
 *
 * @param bossIndex	Boss index.
 * @param client		The client who stunned the boss, will return -1 if the stun was a flashlight stun.
 */
forward void SF2_OnBossStunned(int bossIndex, int client);

/**
 * Called when the boss cloaks.
 *
 * @param bossIndex	Boss index.
 */
forward void SF2_OnBossCloaked(int bossIndex);

/**
 * Called when the boss decloaks
 *
 * @param bossIndex	Boss index.
 */
forward void SF2_OnBossDecloaked(int bossIndex);

/**
 * Called when the boss finishes their spawn animation
 *
 * @param bossIndex	Boss index.
 */
forward void SF2_OnBossFinishSpawning(int bossIndex);

/**
 * Called when the boss finishes validating all attack indexes.
 *
 * @param bossIndex	Boss index.
 * @param attackArray ArrayList containing all valid attacks
 */
forward void SF2_OnBossPreAttack(int bossIndex, ArrayList attackArray);

/**
 * Called when the boss finishes an attack yet not exiting it's attack state.
 *
 * @param bossIndex	Boss index.
 * @param attackIndex Current attack index.
 */
forward void SF2_OnBossAttacked(int bossIndex, int attackIndex);

/**
 * Called when pages have spawned into the map.
 */
forward void SF2_OnPagesSpawned();

/**
 * Called when the round state changes.
 *
 * @param oldState		Old state.
 * @param newState		New state.
 */
forward void SF2_OnRoundStateChange(SF2RoundState oldState, SF2RoundState newState);

/**
 * Called when a player collects a page.
 *
 * @param pageEnt	The entity index of the page.
 * @param client	Client index.
 */
forward void SF2_OnClientCollectPage(int pageEnt, int client);

/**
 * Called when a player blinks.
 *
 * @param client	Client index.
 */
forward void SF2_OnClientBlink(int client);

/**
 * Called when a player gets scared from a boss.
 *
 * @param client		Client index.
 * @param bossIndex	Boss index.
 */
forward void SF2_OnClientScare(int client, int bossIndex);

/**
 * Called when the player gets caught by a boss, either from too much static, being within
 * a boss's kill radius, or dies from too much camping. This is also called for fake bosses.
 *
 * @param client		Client index.
 * @param bossIndex	Boss index.
 */
forward void SF2_OnClientCaughtByBoss(int client, int bossIndex);

/**
 * Called when giving queue points to the player at the end of the round.
 *
 * @param client		Client index.
 * @param addAmount	The amount of queue points to give.
 * @return				If Plugin_Changed, addAmount will be used as the amount to give.
 */
forward Action SF2_OnClientGiveQueuePoints(int client, int &addAmount);

/**
 * Called when the player turns on their flashlight.
 *
 * @param client		Client index.
 */
forward void SF2_OnClientActivateFlashlight(int client);

/**
 * Called when the player turns off their flashlight.
 *
 * @param client		Client index.
 */
forward void SF2_OnClientDeactivateFlashlight(int client);

/**
 * Called when the player breaks their flashlight.
 *
 * @param client		Client index.
 */
forward void SF2_OnClientBreakFlashlight(int client);

/**
 * Called when the player starts sprinting.
 *
 * @param client		Client index.
 */
forward void SF2_OnClientStartSprinting(int client);

/**
 * Called when the player stops sprinting.
 *
 * @param client		Client index.
 */
forward void SF2_OnClientStopSprinting(int client);

/**
 * Called when the player escapes from the map.
 *
 * @param client		Client index.
 */
forward void SF2_OnClientEscape(int client);

/**
 * Called when the player looks at the boss.
 *
 * @param client		Client index.
 * @param bossIndex	Boss the client is looking at.
 */
forward void SF2_OnClientLooksAtBoss(int client, int bossIndex);

/**
 * Called when the player looks away from the boss.
 *
 * @param client		Client index.
 * @param bossIndex	Boss the client is no longer looking at.
 */
forward void SF2_OnClientLooksAwayFromBoss(int client, int bossIndex);

/**
 * Called when the player gets caught in a boss's deathcam.
 *
 * @param client		Client index.
 * @param bossIndex	Boss index.
 */
forward void SF2_OnClientStartDeathCam(int client, int bossIndex);

/**
 * Called when the player gets exits a boss's deathcam.
 *
 * @param client		Client index.
 * @param bossIndex	Boss index.
 */
forward void SF2_OnClientEndDeathCam(int client, int bossIndex);

/**
 * Called to determine a player's default walk speed.
 *
 * @param client		Client index.
 * @param defaultFloat		The default walk speed.
 * @return				If Plugin_Changed, defaultFloat is used as player's default walk speed.
 */
forward Action SF2_OnClientGetDefaultWalkSpeed(int client, float &defaultFloat);

/**
 * Called to determine a player's default sprint speed.
 *
 * @param client		Client index.
 * @param defaultFloat		The default sprint speed.
 * @return				If Plugin_Changed, defaultFloat is used as player's default sprint speed.
 */
forward Action SF2_OnClientGetDefaultSprintSpeed(int client, float &defaultFloat);

/**
 * Called when a player gets damaged.
 *
 * @param victim		The player who got damaged.
 * @param attacker		The damage source.
 * @param inflictor		Similar damage source for attacker.
 * @param damage		The amount of damage to take.
 * @return				If Plugin_Changed, damage is overrided.
 */
forward Action SF2_OnClientTakeDamage(int victim, int &attacker, int &inflictor, float &damage);

/**
 * Called when giving queue points to the group at the end of the round.
 *
 * @param groupIndex		Group index.
 * @param addAmount		The amount of queue points to give.
 * @return					If Plugin_Changed, addAmount will be used as the amount to give.
 */
forward Action SF2_OnGroupGiveQueuePoints(int groupIndex, int &addAmount);

/**
 * Called when a player gets damaged by the boss.
 *
 * @param client		The player who got damaged.
 * @param bossIndex	Boss that damaged the player.
 * @param inflictor		The inflictor of the damage.
 * @param damage		The amount of damage taken.
 * @param damageType	The damage type.
 */
forward void SF2_OnClientDamagedByBoss(int client, int bossIndex, int inflictor, float damage, int damageType);

/**
 * Called when a player spawns as a proxy.
 */
forward void SF2_OnClientSpawnedAsProxy(int client);

/**
 * Called whenever the Renevant gamemode triggers a new wave.
 *
 * @param wave		The wave number that got triggered.
 */
forward void SF2_OnRenevantWaveTrigger(int wave);

/**
 * Called whenever the boss pack vote starts
 */
forward void SF2_OnBossPackVoteStart();

/**
 * Called whenever the difficulty changes
 *
 * @param difficulty	The new difficulty changed into.
 * @param difficulty	The old difficulty before it was changed.
 */
forward void SF2_OnDifficultyChanged(int difficulty, int oldDifficulty);

/**
 * Called when a player is choosen to play
 *
 * @param client	Client index.
 * @return		If Plugin_Handled, player is blocked from playing.
 */
forward Action SF2_OnClientEnterGame(int client);

/**
 * Called when a player is choosen to play
 *
 * @param groupIndex	Group index.
 * @return		If Plugin_Handled, group is blocked from playing.
 */
forward Action SF2_OnGroupEnterGame(int groupIndex);

/**
 * Called whenever everything SF2 related is initialized
 */
forward void SF2_OnEverythingLoaded();

/**
 * Returns the global variable g_Config.
 *
 * @return				g_Config.
 */
native KeyValues SF2_GetConfig();

/**
 * Returns a bool about the gamemode's state.
 *
 * @return				True if the gamemode is running, false if not.
 */
native bool SF2_IsRunning();

/**
 * Returns the current state of the round.
 *
 * @return				Current state of the round.
 */
native SF2RoundState SF2_GetRoundState();

/**
 * Returns whether or not the round is in grace period.
 *
 * @return				True if in grace period, false otherise.
 */
native bool SF2_IsRoundInGracePeriod();

/**
 * Returns the current difficulty of the round.
 *
 * @return				Integer of the difficulty.
 */
native int SF2_GetCurrentDifficulty();

/**
 * Returns the current difficulty of the round.
 *
 * @param difficulty	Difficulty number.
 * @return				Modifier float value of the indicated difficulty number.
 */
native float SF2_GetDifficultyModifier(int difficulty);

/**
 * Returns a bool indicating whether or not a special round is currently running.
 *
 * @return				True if a special round is running, false if not.
 */
native bool SF2_IsSpecialRoundRunning();

/**
 * Returns the type of special round that is running.
 *
 * @return				Special round type.
 */
native int SF2_GetSpecialRoundType();

/**
 * Returns if a certain special round is running
 *
 * @return				Special round type.
 */
native int SF2_IsInSpecialRound(int specialRound);

/**
 * Returns the current group a player is in.
 *
 * @param client	Client index.
 * @return		Group index the player is in, -1 otherwise.
 */
native int SF2_GetClientGroup(int client);

/**
 * Returns the amount of a queue points a player has.
 *
 * @param client	Client index.
 * @return		Amount of queue points.
 */
native int SF2_GetClientQueuePoints(int client);

/**
 * Returns the amount of a queue points a player has.
 *
 * @param client	Client index.
 * @param amount	Amount of queue points.
 */
native void SF2_SetClientQueuePoints(int client, int amount);

/**
 * Returns a bool about the client's elimination state.
 *
 * @param client		Client index.
 * @return				True if the player is eliminated, false if not.
 */
native bool SF2_IsClientEliminated(int client);

/**
 * Returns a bool about the client's ghost mode state.
 *
 * @param client		Client index.
 * @return				True if the player is in Ghost Mode, false if not.
 */
native bool SF2_IsClientInGhostMode(int client);

/**
 * Returns a bool if the client is in a Player vs. Player zone or not.
 *
 * @param client		Client index.
 * @return				True if the player is in a PvP zone, false if not.
 */
native bool SF2_IsClientInPvP(int client);

/**
 * Tells whether if the client is a Proxy or not.
 *
 * @param client		Client index.
 * @return				True if the player is a Proxy, false if not.
 */
native bool SF2_IsClientProxy(int client);

/**
 * Tells whether or not the client is looking at the boss.
 *
 * @param client		Client index.
 * @param bossIndex	Boss index.
 * @return				True if the player is looking at a boss, false if not.
 */
native bool SF2_IsClientLookingAtBoss(int client, int bossIndex);

/**
 * Gives the amount of times the client has blinked in one life. This count will reset upon spawn.
 *
 * @param client		Client index.
 * @return				Number of times the client has blinked in one life.
 */
native int SF2_GetClientBlinkCount(int client);

/**
 * Returns whether or not the client is in a blink state (visibility obscured).
 *
 * @param client		Client index.
 * @return				True if blinking, false otherwise.
 */
native bool SF2_IsClientBlinking(int client);

/**
 * Returns the value of the client's blink meter.
 * @param client		Client index.
 * @return				Blink meter, a value between 0 and 1.
 */
native float SF2_GetClientBlinkMeter(int client);

/**
 * Sets the value of the client's blink meter.
 * @param client		Client index.
 * @param amount		Blink meter, a value between 0 and 1.
 */
native void SF2_SetClientBlinkMeter(int client, float amount);

/**
 * If the client is a Proxy, then this returns the boss index that the client is associated with.
 *
 * @param client		Client index.
 * @return				If the client is a proxy, then this will return a boss index, -1 if not.
 */
native int SF2_GetClientProxyMaster(int client);

/**
 * If the client is a Proxy, then this sets the boss index that the client is associated with.
 *
 * @param client		Client index.
 * @param bossIndex	Boss index.
 */
native void SF2_SetClientProxyMaster(int client, int bossIndex);

/**
 * If the client is a Proxy, then this returns the amount of Control points the client has left.
 *
 * @param client		Client index.
 * @return				If the client is a proxy, then this will return the amount of Control Points out of 100, else 0.
 */
native int SF2_GetClientProxyControlAmount(int client);

/**
 * If the client is a Proxy, then this sets the amount of Control points the client has left.
 *
 * @param client		Client index.
 * @param amount		The amount of Control points. Must be between 0-100.
 */
native void SF2_SetClientProxyControlAmount(int client, int amount);

/**
 * If the client is a Proxy, then this returns the interval which each Control point will drain for the client.
 *
 * @param client		Client index.
 * @return				If the client is a proxy, then this will return a boss index, -1 if not.
 */
native float SF2_GetClientProxyControlRate(int client);

/**
 * If the client is a Proxy, then this sets the interval which each Control point will drain for the client.
 *
 * @param client		Client index.
 * @param interval	Interval to subtract one Control point from the client.
 */
native float SF2_SetClientProxyControlRate(int client, float interval);

/**
 * Tells whether or not the client escaped from the map.
 *
 * @param client		Client index.
 * @return				True if the client escaped, false otherwise.
 */
native bool SF2_DidClientEscape(int client);

/**
 * Forces a client to escape.
 *
 * @param client		Client index.
 */
native void SF2_ForceClientEscape(int client);

/**
 * Returns the amount of flashlight the client has.
 *
 * @param client		Client index.
 * @return				Percentage of battery life.
 */
native float SF2_GetClientFlashlightBatteryLife(int client);

/**
 * Sets the amount of flashlight the client has. The value should be between 0 and 1.
 *
 * @param client		Client index.
 * @param batteryLife	The amount of battery life.
 */
native void SF2_SetClientFlashlightBatteryLife(int client, float batteryLife);

/**
 * Returns whether or not the player is using their flashlight.
 *
 * @param client		Client index.
 * @return				True if using flashlight, false otherwise.
 */
native bool SF2_IsClientUsingFlashlight(int client);

/**
 * Returns the amount of sprint points the client has.
 *
 * @param client	Client index.
 * @return			Sprint points.
 */
native int SF2_GetClientSprintPoints(int client);

/**
 * Sets the amount of sprint points the client has. The value should be between 0 and 100.
 *
 * @param client			Client index.
 * @param sprintPoints		Sprint points.
 */
native int SF2_SetClientSprintPoints(int client, int sprintPoints);

/**
 * Returns whether or not the client wants to sprint.
 *
 * @param client			Client index.
 * @return					True if wants to sprint, false otherwise.
 */
native bool SF2_IsClientSprinting(int client);

/**
 * Sets the sprint state for a client.
 *
 * @param client			Client index.
 * @param sprint			True if the player should sprint, false if otherwise.
 */
native bool SF2_SetClientSprintState(int client, bool sprint);

/**
 * Returns whether or not the client is actually in sprint state.
 *
 * @param client			Client index.
 * @return					True if in sprint state, false otherwise.
 */
native bool SF2_IsClientReallySprinting(int client);

/**
 * Returns whether or not the client is caught in a trap.
 *
 * @param client			Client index.
 * @return					True if trapped, false otherwise.
 */
native bool SF2_IsClientTrapped(int client);

/**
 * Returns whether or not the client is in a death cam.
 *
 * @param client			Client index.
 * @return					True in in a death cam, false otherwise.
 */
native bool SF2_IsClientInDeathCam(int client);

/**
 * Returns whether or not a proxy can be spawned, returns a teleport position or spawn point if defined and the result is true, works well with SF2_ClientForceProxy.
 *
 * @param client		Client index.
 * @param bossIndex	Boss index.
 * @param teleportPos	Position to return
 * @param spawnPoint	Spawn point to return, defaults to -1.
 */
native bool SF2_ClientSpawnProxy(int client, int bossIndex, float teleportPos[3], int &spawnPoint = -1);

/**
 * Spawns a player as a proxy at a given position or spawn point.
 *
 * @param client		Client index.
 * @param bossIndex	Boss index.
 * @param teleportPos	Position to return
 * @param spawnPoint	Spawn point to return, defaults to -1.
 */
native bool SF2_ClientForceProxy(int client, int bossIndex, const float teleportPos[3], int spawnPoint);

/**
 * Collects the given entity as a page.
 *
 * @param pageEnt		Entity index.
 * @param client		Client index.
 */
native void SF2_CollectAsPage(int pageEnt, int client);

/**
 * Returns the maximum boss count.
 *
 * @return	Maximum boss count.
 */
native int SF2_GetMaxBossCount();

/**
 * Converts the entity index into a boss index.
 *
 * @param entIndex		Entity index.
 * @return				Boss index, or -1 if entity index is not a boss.
 */
native int SF2_EntIndexToBossIndex(int entIndex);

/**
 * Returns the entity index of a boss using EntRefToEntIndex().
 *
 * @param bossIndex	Boss index.
 * @return				Entity index, or -1 if the boss has not spawned.
 */
native int SF2_BossIndexToEntIndex(int bossIndex);

/**
 * Returns the entity index of a boss using NPCGetEntIndex() rather than EntRefToEntIndex().
 *
 * @param bossIndex	Boss index.
 * @return				Entity index, or -1 if the boss has not spawned.
 */
native int SF2_BossIndexToEntIndexEx(int bossIndex);

/**
 * Converts a boss unique ID to a boss index.
 *
 * @param bossID		Unique id.
 * @return				Boss index, or -1 if no boss has the unique id.
 */
native int SF2_BossIDToBossIndex(int bossID);

/**
 * Returns the unique ID of a boss. A unique ID to a boss index is the equivalent of an entity reference to an entity index.
 *
 * @param bossIndex		Boss index.
 * @return					Unique id.
 */
native int SF2_BossIndexToBossID(int bossIndex);

/**
 * Updates the boss animation based on the defined state
 *
 * @param bossIndex			Boss index.
 * @param ent				Entity index.
 * @param state				State.
 * @param spawn				Determines if the boss should use a spawn animation.
*/
native void SF2_UpdateBossAnimation(int bossIndex, int ent, int state, bool spawn = false);

/**
 * Forces a boss to jump at a position.
 *
 * @param nextbotLocomotion		Boss' ground locomotion (Requires to use CBaseNPC natives).
 * @param startPos				The position the boss is at.
 * @param endPos				Where the boss should jump to.
*/
native void SF2_ForceBossJump(NextBotGroundLocomotion nextbotLocomotion, float startPos[3], float endPos[3]);

/**
 * Adds a boss into the game.
 *
 * @param profile			Name of profile.
 * @param flags				Additional flags to add to the boss.
 * @param spawnCompanions	Add companions of the boss.
 * @param playSpawnSound	Play spawn sound.
 * @return					Boss index, or -1 if failed.
 */
native int SF2_AddBoss(const char[] profile, int flags=0, bool spawnCompanions=true, bool playSpawnSound=true);

/**
 * Removes a boss from the game.
 *
 * @param bossIndex	Boss index.
 */
native void SF2_RemoveBoss(int bossIndex);

/**
 * Despawns a boss.
 *
 * @param bossIndex	Boss index.
 */
native void SF2_DespawnBoss(int bossIndex);

/**
 * Retrieves the profile name of the boss.
 *
 * @param bossIndex		Boss index.
 * @param buffer			Buffer to store the profile name.
 * @param bufferLen		Max length of buffer.
 */
native void SF2_GetBossName(int bossIndex, char[] buffer, int bufferLen);

/**
 * Returns the type of the boss. See the SF2BossType enumeration for possible values.
 *
 * @param bossIndex		Boss index.
 * @return					Entity index.
 */
native int SF2_GetBossType(int bossIndex);

/**
 * Returns the flags of the boss.
 *
 * @param bossIndex		Boss index.
 * @return					Flags.
 */
native int SF2_GetBossFlags(int bossIndex);

/**
 * Sets the flags of the boss.
 *
 * @param bossIndex		Boss index.
 * @param flags				Flags.
 */
native void SF2_SetBossFlags(int bossIndex, int flags);

/**
 * Spawns the boss into the map.
 *
 * @param bossIndex		Boss index.
 */
native void SF2_SpawnBoss(int bossIndex, const float position[3]);

/**
 * Checks to see if the boss is using their spawn animation.
 *
 * @param bossIndex		Boss index.
 * @return				Spawning state
 */
native bool SF2_IsBossSpawning(int bossIndex);

/**
 * Returns the entity index of the boss's model.
 *
 * @param bossIndex		Boss index.
 * @return					Entity index.
 */
native int SF2_GetBossModelEntity(int bossIndex);

/**
 * Returns the boss's current target.
 *
 * @param bossIndex		Boss index.
 * @return					Entity index.
 */
native int SF2_GetBossTarget(int bossIndex);

/**
 * If the boss is in a chase state, sets the target for the boss.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex		Boss index.
 * @param client			The new target.
 */
native void SF2_SetBossTarget(int bossIndex, int client);

/**
 * Returns the boss's default path follower.
 *
 * @param bossIndex		Boss index.
 * @return					Path Follower.
 */
native PathFollower SF2_GetBossPathFollower(int bossIndex);

/**
 * If the boss is a copy, this returns the boss that this copy is associated with.
 *
 * @param bossIndex		Boss index.
 * @return					Boss index of master boss.
 */
native int SF2_GetBossMaster(int bossIndex);

/**
 * Returns the boss's idle lifetime.
 *
 * @param bossIndex		Boss index.
 * @param difficulty	The difficulty index.
 * @return					The boss's default idle lifetime
 */
native float SF2_GetBossIdleLifetime(int bossIndex, int difficulty);

/**
 * Returns the boss's current state.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex		Boss index.
 * @return					The boss's state.
 */
native int SF2_GetBossState(int bossIndex);

/**
 * Sets the boss's current state.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex		Boss index.
 */
native void SF2_SetBossState(int bossIndex, int state);

/**
 * Returns the boss's eye position in the world. Used for visibility checks.
 *
 * @param bossIndex		Boss index.
 * @param eyePos			Buffer to store result.
 */
native void SF2_GetBossEyePosition(int bossIndex, float eyePos[3]);

/**
 * Returns the boss's eye position offset. This is a local offset vector.
 *
 * @param bossIndex		Boss index.
 * @param eyePosOffset		Buffer to store result.
 */
native void SF2_GetBossEyePositionOffset(int bossIndex, float eyePosOffset[3]);

/**
 * Returns the boss's field of view.
 *
 * @param bossIndex		Boss index.
 * @return					Field of view.
 */
native float SF2_GetBossFOV(int bossIndex);

/**
 * If the boss is in a chase state, returns the time which the boss's persistency on the target ends.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex		Boss index.
 * @return					Time where persistency ends.
 */
native float SF2_GetBossTimeUntilNoPersistence(int bossIndex);

/**
 * If the boss is in a chase state, sets the time which the boss's persistency on the target ends.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex		Boss index.
 * @param time				Time where persistency ends.
 */
native void SF2_SetBossTimeUntilNoPersistence(int bossIndex, float time);

/**
 * If the boss is in an alert state, returns the time which the boss should revert to idle state.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex		Boss index.
 * @return					Time where chase state should revert to idle state.
 */
native float SF2_GetBossTimeUntilIdle(int bossIndex);

/**
 * If the boss is in an alert state, sets the time which the boss should revert to idle state.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex		Boss index.
 * @param time				Time where chase state should revert to idle state.
 */
native void SF2_SetBossTimeUntilIdle(int bossIndex, float time);

/**
 * If the boss is in a chase state, returns the time which the boss should revert to alert state.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex		Boss index.
 * @return					Time where chase state should revert to alert state.
 */
native float SF2_GetBossTimeUntilAlert(int bossIndex);

/**
 * If the boss is in a chase state, sets the time which the boss should revert to alert state.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex		Boss index.
 * @param time				Time where chase state should revert to alert state.
 */
native void SF2_SetBossTimeUntilAlert(int bossIndex, float time);

/**
 * Returns whether or not the boss is stunnable.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex		Boss index.
 * @return					True if stunnable, false otherwise.
 */
native bool SF2_IsBossStunnable(int bossIndex);

/**
 * Returns whether or not the boss is stunnable by flashlight.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex		Boss index.
 * @return					True if stunnable by flashlight, false otherwise.
 */
native bool SF2_IsBossStunnableByFlashlight(int bossIndex);

/**
 * Returns whether or not the boss is cloaked.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex		Boss index.
 * @return					True if cloaked, false otherwise.
 */
native bool SF2_IsBossCloaked(int bossIndex);

/**
 * Returns the amount of health the boss has before stun.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex		Boss index.
 * @return					The health amount.
 */
native float SF2_GetBossStunHealth(int bossIndex);

/**
 * Sets the amount of health the boss has before stun.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex		Boss index.
 * @param health			The health amount.
 */
native void SF2_SetBossStunHealth(int bossIndex, float health);

/**
 * Returns the time where the boss is not under stun cooldown.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex		Boss index.
 * @return					Time when boss is not under stun cooldown.
 */
native float SF2_GetBossNextStunTime(int bossIndex);

/**
 * Sets the time where the boss is not under stun cooldown.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex		Boss index.
 * @param time				Time when boss is not under stun cooldown.
 */
native float SF2_SetBossNextStunTime(int bossIndex, float time);

/**
 * Forces the boss to stop chasing.
 *
 * Only used with Chaser bosses.
 *
 * Note: If the boss is set to chase endlessly then this will not do anything.
 *
 * @param bossIndex		Boss index.
 */
native void SF2_ForceBossGiveUp(int bossIndex);

/**
 * Gets the current goal position of the boss.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex		Boss index.
 * @param position			Buffer to store position.
 */
native void SF2_GetBossGoalPosition(int bossIndex, float position[3]);

/**
 * Returns whether or not the boss is able to hear the player given sound type.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex		Boss index.
 * @param client			Client index.
 * @param soundType			The type of sound to check.
 * @return					True if boss can hear, false otherwise.
 */
native bool SF2_CanBossHearClient(int bossIndex, int client, SoundType soundType);

/**
 * Creates a sound hint for the boss to follow.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex		Boss index.
 * @param soundType			The type of sound hint to create.
 * @param position			The position of the sound.
 * @param difficulty		The difficulty.
 */
native void SF2_CreateBossSoundHint(int bossIndex, SoundType soundType, const float position[3], int difficulty);

/**
 * Returns if the given profile is loaded or not.
 *
 * @param profile		Profile name.
 * @return				True if loaded, false otherwise.
 */
native bool SF2_IsBossProfileValid(const char[] profile);

/**
 * Retrieves an integer keyvalue from the profile.
 *
 * @param profile			Profile name.
 * @param key				Name of the key.
 * @param defaultValue		Fallback value.
 * @return					The value, or defaultValue if the key doesn't exist.
 */
native int SF2_GetBossProfileNum(const char[] profile, const char[] key, int defaultValue=0);

/**
 * Retrieves a float keyvalue from the profile.
 *
 * @param profile			Profile name.
 * @param key				Name of the key.
 * @param defaultValue	Fallback value.
 * @return					The value, or defaultValue if the key doesn't exist.
 */
native float SF2_GetBossProfileFloat(const char[] profile, const char[] key, float defaultValue=0.0);

/**
 * Retrieves a string keyvalue from the profile.
 *
 * @param profile			Profile name.
 * @param key				Name of the key.
 * @param buffer			Buffer to store the value.
 * @param bufferLen		Max length of buffer.
 * @param defaultValue		Fallback value.
 * @return					True if key exists; false otherwise. If false, buffer is set to defaultValue.
 */
native bool SF2_GetBossProfileString(const char[] profile, const char[] key, char[] buffer, int bufferLen, const char[] defaultValue="");

/**
 * Retrieves a vector keyvalue from the profile.
 *
 * @param profile			Profile name.
 * @param key				Name of the key.
 * @param buffer			Buffer to store the value.
 * @param defaultValue	Fallback value.
 * @return					True if key exists; false otherwise. If false, buffer is set to defaultValue.
 */
native bool SF2_GetBossProfileVector(const char[] profile, const char[] key, float buffer[3], const float defaultValue[3]=NULL_VECTOR);

/**
 * Retrieves integer difficulty keyvalues from the profile.
 *
 * @param kv				KeyValues
 * @param baseKeyName		Name of the base key.
 * @param buffer			Values to store the key values in
 * @param defaultValues		Fallback values
 * @return					The value, or defaultValue if the key doesn't exist.
 */
native void SF2_GetBossProfileDifficultyNumValues(KeyValues kv, const char[] baseKeyName, int buffer[Difficulty_Max], const int defaultValues[Difficulty_Max] = { 0, ... })

/**
 * Retrieves bool difficulty keyvalues from the profile.
 *
 * @param kv				KeyValues
 * @param baseKeyName		Name of the base key.
 * @param buffer			Values to store the key values in
 * @param defaultValues		Fallback values
 * @return					The value, or defaultValue if the key doesn't exist.
 */
native void SF2_GetBossProfileDifficultyBoolValues(KeyValues kv, const char[] baseKeyName, bool buffer[Difficulty_Max], const bool defaultValues[Difficulty_Max] = { false, ... })

/**
 * Retrieves float difficulty keyvalues from the profile.
 *
 * @param kv				KeyValues
 * @param baseKeyName		Name of the base key.
 * @param buffer			Values to store the key values in
 * @param defaultValues		Fallback values
 * @return					The value, or defaultValue if the key doesn't exist.
 */
native void SF2_GetBossProfileDifficultyFloatValues(KeyValues kv, const char[] baseKeyName, float buffer[Difficulty_Max], const float defaultValues[Difficulty_Max] = { 0.0, ... })

/**
 * Retrieves an integer keyvalue from the profile.
 *
 * @param profile			Profile name.
 * @param key				Name of the key.
 * @param defaultValue		Fallback value.
 * @param attackIndex		Attack Index to use.
 * @return					The value, or defaultValue if the key doesn't exist.
 */
native int SF2_GetBossAttackProfileNum(const char[] profile, const char[] key, int defaultValue=0, const int attackIndex);

/**
 * Retrieves a float keyvalue from the profile.
 *
 * @param profile			Profile name.
 * @param key				Name of the key.
 * @param defaultValue	Fallback value.
 * @param attackIndex		Attack Index to use.
 * @return					The value, or defaultValue if the key doesn't exist.
 */
native float SF2_GetBossAttackProfileFloat(const char[] profile, const char[] key, float defaultValue=0.0, const int attackIndex);

/**
 * Retrieves a string keyvalue from the profile.
 *
 * @param profile			Profile name.
 * @param key				Name of the key.
 * @param buffer			Buffer to store the value.
 * @param bufferLen		Max length of buffer.
 * @param defaultValue		Fallback value.
 * @param attackIndex		Attack Index to use.
 * @return					True if key exists; false otherwise. If false, buffer is set to defaultValue.
 */
native bool SF2_GetBossAttackProfileString(const char[] profile, const char[] key, char[] buffer, int bufferLen, const char[] defaultValue="", const int attackIndex);

/**
 * Retrieves a vector keyvalue from the profile.
 *
 * @param profile			Profile name.
 * @param key				Name of the key.
 * @param buffer			Buffer to store the value.
 * @param defaultValue	Fallback value.
 * @param attackIndex		Attack Index to use.
 * @return					True if key exists; false otherwise. If false, buffer is set to defaultValue.
 */
native bool SF2_GetBossAttackProfileVector(const char[] profile, const char[] key, float buffer[3], const float defaultValue[3]=NULL_VECTOR, const int attackIndex);

/**
 * Retrieves a random string keyvalue from a section within the profile.
 *
 * Example: In a profile, a valid section would look like this:
 *
 * "profile"
 * {
 *   "section"
 *   {
 *     "1"   "item1"
 *     "2"   "item2"
 *   }
 * }
 *
 * This function will randomly choose a string value within "section" if key = "section".
 *
 * @param profile			Profile name.
 * @param key				Name of the key. Must be a section.
 * @param buffer			Buffer to store the value.
 * @param bufferLen		Max length of buffer.
 * @param index			Mainly used for attack indexes, selects a random sound from an array that is index.
 * @return					True if profile exists and key is set; false otherwise.
 */
native bool SF2_GetRandomStringFromBossProfile(const char[] profile, const char[] key, char[] buffer, int bufferLen, int index=-1);

/**
 * Returns an attribute name if one exists
 * @param bossIndex	Boss index.
 * @param attribute	Name of attribute in enum.
*/
native bool SF2_GetBossAttributeName(int bossIndex, int attribute);

/**
 * Returns the value of an attribute.
 * @param bossIndex	Boss index.
 * @param attribute	Name of attribute in enum.
 * @param defaultValue	Default value of attribute.
*/
native float SF2_GetBossAttributeValue(int bossIndex, int attribute);

/**
 * Returns the projectile type a boss uses.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex	Boss index.
*/
native int SF2_GetBossProjectileType(int bossIndex);

/**
 * Returns the current attack index of the boss.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex	Boss index.
 * @return Attack index.
*/
native int SF2_GetBossCurrentAttackIndex(int bossIndex);

/**
 * Sets the boss' current attack index.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex	Boss index.
 * @param attackIndex New attack index.
*/
native int SF2_SetBossCurrentAttackIndex(int bossIndex, int attackIndex);

/**
 * Returns all available attack indexes of the boss
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex	Boss index.
*/
native int SF2_GetBossMaxAttackIndexes(int bossIndex);

/**
 * Returns the boss' current run duration time
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex	Boss index.
 * @param attackIndex Attack index.
 * @return Attack run duration time.
*/
native float SF2_GetBossAttackRunDurationTime(int bossIndex, int attackIndex);

/**
 * Sets the boss' current run duration time
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex	Boss index.
 * @param attackIndex Attack index.
 * @param newTime New attack run duration time.
*/
native void SF2_SetBossAttackRunDurationTime(int bossIndex, int attackIndex, float newTime);

/**
 * Returns the boss' current run duration time
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex	Boss index.
 * @param attackIndex Attack index.
 * @return Attack run delay time.
*/
native float SF2_GetBossAttackRunDelayTime(int bossIndex, int attackIndex);

/**
 * Sets the boss' current run delay time
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex	Boss index.
 * @param attackIndex Attack index.
 * @param newTime New attack run delay time.
*/
native void SF2_SetBossAttackRunDelayTime(int bossIndex, int attackIndex, float newTime);

/**
 * Returns the damage type of a set attack index.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex	Boss index.
 * @param attackIndex	Attack index.
*/
native int SF2_GetBossAttackIndexDamageType(int bossIndex, int attackIndex);

/**
 * Returns the damage of a set attack index.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex	Boss index.
 * @param attackIndex	Attack index.
 * @param difficulty	The difficulty.
*/
native float SF2_GetBossAttackIndexDamage(int bossIndex, int attackIndex, int difficulty);

/**
 * Returns the spread of a set attack index
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex	Boss index.
 * @param attackIndex	Attack index.
 * @param difficulty	The difficulty.
*/
native float SF2_GetBossAttackIndexSpread(int bossIndex, int attackIndex);

/**
 * Returns the range of a set attack index
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex	Boss index.
 * @param attackIndex	Attack index.
 * @param difficulty	The difficulty.
*/
native float SF2_GetBossAttackIndexRange(int bossIndex, int attackIndex);

/**
 * Returns the attack type of a set attack index.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex	Boss index.
 * @param attackIndex	Attack index.
*/
native int SF2_GetBossAttackIndexType(int bossIndex, int attackIndex);

/**
 * Returns the teleport think timer in Handle form
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex	Boss index.
*/
native Handle SF2_GetBossTeleportThinkTimer(int bossIndex);

/**
 * Sets the teleport think timer and destroys the old think timer
 *
 * @param bossIndex	Boss index.
 * @param timer		New timer (Can also be null).
*/
native void SF2_SetBossTeleportThinkTimer(int bossIndex, Handle timer);

/**
 * Returns the boss' teleport target
 *
 * @param bossIndex	Boss index.
 * @param difficulty	The difficulty index.
 * @return		Teleport entity index.
*/
native int SF2_GetBossTeleportTarget(int bossIndex);

/**
 * Returns the boss think timer in Handle form
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex	Boss index.
 * @return		Handle timer.
*/
native Handle SF2_GetBossThinkTimer(int bossIndex);

/**
 * Sets the boss think timer and destroys the old think timer
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex	Boss index.
 * @param timer		New timer (Can also be null).
*/
native void SF2_SetBossThinkTimer(int bossIndex, Handle timer);

/**
 * Unhooks the boss' current pre-think hook function. Use this sparingly. (Or don't)
 *
 * @param bossIndex Boss index.
 */
native void SF2_UnhookBossThinkHook(int bossIndex);

/**
 * Forcefully makes the boss perform a voice based on pre-defined voices
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex	Boss index.
 * @param attackIndex	Optional index that looks mainly for attack sounds in sub sections
 * @param soundType		Type of sound the boss should perform
*/
native void SF2_PerformBossVoice(int bossIndex, const int attackIndex = -1, int soundType = -1);

/**
 * Returns the StringMap variable containing every precached base boss profile
 *
 * @return		StringMap containing all base boss profile datas
*/
native StringMap SF2_GetBossProfileData();

/**
 * Returns the StringMap variable containing every precached chaser boss profile
 *
 * @return		StringMap containing all chaser boss profile datas
*/
native StringMap SF2_GetChaserBossProfileData();

/**
 * Returns the StringMap variable containing every precached statue boss profile
 *
 * @return		StringMap containing all statue boss profile datas
*/
native StringMap SF2_GetStatueBossProfileData();

/**
 * Returns the distance of 2 vectors without utilizing the square root function and converting the values properly.
 *
 * @param vec1	Position 1.
 * @param vec2	Position 2.
*/
native float SF2_GetVectorSquareMagnitude(const float vec1[3], const float vec2[3]);

/**
 * Starts a boss pack vote
 *
 * @param initiator	Whoever started the vote, keep above 33 for non-clients
*/
native void SF2_InitiateBossPackVote(int initiator);

/**
 * Returns the flags of the projectile.
 *
 * @param projectile		Entity index.
 * @return					Flags.
 */
native int SF2_GetProjectileFlags(int projectile);

/**
 * Sets the flags of the projectile.
 *
 * @param projectile		Entity index.
 * @param flags				Flags.
 */
native void SF2_SetProjectileFlags(int projectile, int flags);

/**
 * Returns if current map is a survival map or not.
 *
 * @return	True if current map is a survival map; false otherwise.
 */
native bool SF2_IsSurvivalMap();

/**
 * Returns if current map is a Boxing map or not.
 *
 * @return	True if Boxing map, false otherwise.
 */
native bool SF2_IsBoxingMap();

/**
 * Returns if current map is a Raid map or not.
 *
 * @return	True if Raid map, false otherwise.
 */
native bool SF2_IsRaidMap();

/**
 * Returns if current map is a Proxy map or not.
 *
 * @return	True if Proxy map, false otherwise.
 */
native bool SF2_IsProxyMap();

/**
 * Returns if current map is a Renevant map or not.
 *
 * @return	True if Renevant map, false otherwise.
 */
native bool SF2_IsRenevantMap();

/**
 * Returns if current map is a Slaughter Run map or not.
 *
 * @return	True if Slaughter Run map, false otherwise.
 */
native bool SF2_IsSlaughterRunMap();

public SharedPlugin __pl_sf2 =
{
	name = "sf2",
	file = "sf2.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};
