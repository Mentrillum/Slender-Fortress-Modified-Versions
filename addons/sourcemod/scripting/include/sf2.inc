#if defined _sf2_included
 #endinput
#endif
#define _sf2_included

#include <cbasenpc>
#include <cbasenpc/util>
#include <cbasenpc/matrix>

#define PLUGIN_VERSION "1.8.0 M Alpha 2"
#define PLUGIN_VERSION_DISPLAY "1.8.0 M Alpha 2"

// Some defines.
#define SF2_MAX_PROFILE_NAME_LENGTH 64
#define SF2_MAX_NAME_LENGTH 32

#define MAX_BOSSES 64
#define MAX_NPCTELEPORTER 5
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
	SPECIALROUND_SILENTSLENDER,
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
	SPECIALROUND_PAGEREWARDS,
	SPECIALROUND_TINYBOSSES,
	SPECIALROUND_RUNNINGINTHE90S,
	SPECIALROUND_TRIPLEBOSSES,
	SPECIALROUND_MODBOSSES,
	SPECIALROUND_BOSSROULETTE,
	SPECIALROUND_THANATOPHOBIA,
	SPECIALROUND_WALLHAX,
	SPECIALROUND_SINGLEPLAYER,
	SPECIALROUND_BEATBOX,
	SPECIALROUND_MAXROUNDS
};

// Boss state enumerations.
enum
{
	STATE_IDLE = 0,
	STATE_ALERT,
	STATE_CHASE,
	STATE_ATTACK,
	STATE_STUN,
	STATE_DEATHCAM,
	STATE_DEATH,
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
	Difficulty_Easy = 0, // Also called the none difficulty
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
	SF2BossSound_Death,
	SF2BossSound_TauntKill,
	SF2BossSound_Smell,
	SF2BossSound_AttackBegin,
	SF2BossSound_AttackEnd,
	SF2BossSound_MaxSounds
};

enum
{
	SF2BossAnimation_Idle = 0,
	SF2BossAnimation_Walk,
	SF2BossAnimation_Attack,
	SF2BossAnimation_Run,
	SF2BossAnimation_Stun,
	SF2BossAnimation_ChaseInitial = 5,
	SF2BossAnimation_Rage,
	SF2BossAnimation_Spawn,
	SF2BossAnimation_FleeInitial,
	SF2BossAnimation_Heal,
	SF2BossAnimation_DeathCam = 10,
	SF2BossAnimation_Death,
	SF2BossAnimation_TauntKill,
	SF2BossAnimation_Smell,
	SF2BossAnimation_AttackBegin,
	SF2BossAnimation_AttackEnd = 15,
	SF2BossAnimation_MaxAnimations
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
	SF2Attribute_AddStunHealthOnStun,
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
	SF2Attribute_DeathCamOnLowHealth,
	SF2Attribute_AlertCopies,
	SF2Attribute_AlertCompanions = 20,
	SF2Attribute_BlockWalkSpeedUnderDifficulty,
	SF2Attribute_ChaseTargetOnScare,
	SF2Attribute_IgnoreNonMarkedForChase,
	SF2Attribute_ReducedAccelerationOnLook,
	SF2Attribute_AddAccelerationOnStun = 25,
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
	"sound_death",
	"sound_taunt_kill",
	"sound_smell",
	"sound_attack_begin",
	"sound_attack_end"
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

enum SF2NPCMoveTypes
{
	SF2NPCMoveType_Walk = 0,
	SF2NPCMoveType_Run,
	SF2NPCMoveType_Attack,
	SF2NPCMoveType_Max
}

#include <sf2/stocks>
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
#define SFF_NOCOPIES (1 << 13)
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
#define COND_ALERT_TRIGGER (1 << 9)
#define COND_NEWENEMY (1 << 10)
#define COND_ENEMYNEAR (1 << 11)
#define COND_ENEMYVISIBLE (1 << 12)
#define COND_ENEMYRECHASE (1 << 13)
#define COND_DEBUG (1 << 14)

/**
 * Called after a boss profile is successfully loaded.
 *
 * @param profile		Profile name
 * @param kv			Key Values
 */
forward void SF2_OnBossProfileLoaded(const char[] profile, KeyValues kv);

/**
 * Called before a boss profile is unloaded.
 *
 * @param profile		Profile name
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
 * Called each time a boss update its animation.
 *
 * @param bossIndex		Boss index.
 * @param animation		The animation name used.
 * @return 				If Plugin_Handled will not update the boss animation.
 */
forward Action SF2_OnBossAnimationUpdate(int bossIndex, const char[] animation);

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
 * @param bossIndex		Boss index.
 * @param client		The client who stunned the boss, will return -1 if the stun was a flashlight stun.
 */
forward void SF2_OnBossStunned(int bossIndex, int client);

/**
 * Called when the boss gets killed..
 *
 * @param bossIndex		Boss index.
 * @param attacker		The attacker who killed the boss.
 */
forward void SF2_OnBossKilled(int bossIndex, int attacker);

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

#pragma deprecated Use custom boss attacks.
forward void SF2_OnBossAttacked(int bossIndex, int attackIndex);

/**
 * Called when the boss finishes validating all attack indexes.
 *
 * @param bossIndex	Boss index.
 * @param attackArray ArrayList containing all valid attacks
 */
forward void SF2_OnBossPreAttack(int bossIndex, ArrayList attackArray);

/**
 * Called just before a chaser boss takes damage.
 *
 * @param chaser			Chaser entity
 * @param attacker			Attacker entity
 * @param inflictor			Inflictor entity
 * @param damage			Damage about to be taken
 * @return					Returning Plugin_Stop will invalidate any damage taken by the boss.
 */
forward Action SF2_OnBossPreTakeDamage(SF2_ChaserBossEntity chaser, CBaseEntity attacker, CBaseEntity inflictor, float damage);

/**
 * Called whenever a chaser boss registers a player uses a flashlight for flashight stunning.
 *
 * @param chaser			Chaser entity
 * @param player			Player using the flashlight
 * @return					Returning Plugin_Stop will invalidate any flashlight damage taken by the boss from the specified player.
 */
forward Action SF2_OnBossPreFlashlightDamage(SF2_ChaserBossEntity chaser, SF2_Player player);


/**
 * Called whenever a chaser boss gets a command string "suspend for action" using INextBotEventResponder.OnCommandString()
 *
 * @param chaser			Chaser entity
 * @param action			Action to use
 * @return					Returning anything not Plugin_Continue will make the boss use the specified action and suspend for that
 */
forward Action SF2_OnChaserBossGetSuspendAction(SF2_ChaserBossEntity chaser, NextBotAction &action);

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
 * Called right before the player dies in a death cam
 *
 * @param client		Client index.
 * @param bossIndex		Boss index.
 */
forward void SF2_OnClientPreKillDeathCam(int client, int bossIndex);

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
 * Called whenever the difficulty vote finishes
 *
 * @param list 		ArrayList containing all valid attacks
 */
forward void SF2_OnDifficultyVoteFinished(ArrayList list, bool isRunOff);

/**
 * Called when a Chaser boss is determining if it's allowed to use the custom attack.
 *
 * @param chaser			Chaser entity
 * @param attackName		Attack name
 * @param data				Attack data
 * @param target			The target entity that the boss is trying to use this attack on
 * @return					Returning a value other than Plugin_Continue will block the boss from using
 * 							the attack.
 */
forward Action SF2_OnIsBossCustomAttackPossible(SF2_ChaserBossEntity chaser, const char[] attackName, SF2ChaserBossProfileAttackData data, CBaseEntity target);

/**
 * Called when the Chaser boss has selected the custom attack and is requesting a
 * NextBotAction to handle the attack logic.
 *
 * @param chaser			Chaser entity
 * @param attackName		Attack name
 * @param data				Attack data
 * @param target			The target entity to use the attack on
 * @param action			Parameter to fill with the NextBotAction
 * @return					Return a value other than Plugin_Continue to use `action`
 */
forward Action SF2_OnBossGetCustomAttackAction(SF2_ChaserBossEntity chaser, const char[] attackName, SF2ChaserBossProfileAttackData data, CBaseEntity target, NextBotAction &action);

/**
 * Fires each time a boss starts an attack.
 *
 * @param chaser			Chaser entity
 * @param attackName		Attack name
 */
forward void SF2_OnChaserBossStartAttack(SF2_ChaserBossEntity chaser, const char[] attackName);

/**
 * Fires after a boss has ended an attack.
 *
 * @param chaser			Chaser entity
 * @param attackName		Attack name
 */
forward void SF2_OnChaserBossEndAttack(SF2_ChaserBossEntity chaser, const char[] attackName);

/**
 * Called whenever the gamemode picks a custom boss. Use this for creating entities.
 *
 * @param boss		The chosen boss
 * @param pos		The selected position the boss will spawn on
 * @param ang		The selected angle the boss will spawn on
 */
forward void SF2_OnSelectedPvEBoss(const char[] boss, const float pos[3], const float ang[3]);

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
 * Returns the current difficulty on the boss. This is only useful for boxing/PvE bosses.
 * If the boss is not a PvE/boxing boss, then this will return the current gamemode difficulty.
 *
 * @param bossIndex		Boss index.
 * @return				Integer of the difficulty.
 */
native int SF2_GetBossDifficulty(int bossIndex);

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
 * Returns whether or not the client is valid for SF2.
 *
 * @param client		Client index.
 * @return				True if the player is valid, false if not.
 */
native bool SF2_IsValidClient(int client);

/**
 * Returns whether or not the client is crit boosted for SF2.
 *
 * @param client		Client index.
 * @return				True if the player is crit boosted, false if not.
 */
native bool SF2_IsClientCritBoosted(int client);

/**
 * Returns whether or not the client is mini crit boosted for SF2.
 *
 * @param client		Client index.
 * @return				True if the player is mini crit boosted, false if not.
 */
native bool SF2_IsClientMiniCritBoosted(int client);

/**
 * Returns whether or not the client is ubercharged for SF2.
 *
 * @param client		Client index.
 * @return				True if the player is ubercharged, false if not.
 */
native bool SF2_IsClientUbercharged(int client);

/**
 * Returns whether or not the client is in a kart for SF2.
 *
 * @param client		Client index.
 * @return				True if the player is in a kart, false if not.
 */
native bool SF2_IsClientInKart(int client);

/**
 * Returns whether or not the client is in a specific condition for SF2.
 *
 * @param client		Client index.
 * @param condition		Condition to check.
 * @return				True if the player is in a condition, false if not.
 */
native bool SF2_IsClientInCondition(int client, TFCond condition);

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
 * Returns a bool if the client is in a Player vs. Environment zone or not.
 *
 * @param client		Client index.
 * @return				True if the player is in a PvE zone, false if not.
 */
native bool SF2_IsClientInPvE(int client);

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
 * Forces a client to be in a deathcam from a boss.
 *
 * @param client			Client index.
 * @param bossIndex			Boss index.
 * @param vecLookPos		The position the player should look at.
 * @param antiCamp			Whether the player was camping or not.
 */
native void SF2_ClientStartDeathCam(int client, int bossIndex, const float lookPos[3], bool antiCamp = false);

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
 * Returns the empty page spawn points not occupied by a page in ArrayList form.
 */
native ArrayList SF2_GetEmptyPageSpawnPoints();

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

#pragma deprecated Use SF2ChaserBossProfileAttackData.StunEnabled[Difficulty_Max] instead.
native bool SF2_IsBossStunnable(int bossIndex);

#pragma deprecated Use SF2ChaserBossProfileAttackData.StunFlashlight[Difficulty_Max] instead.
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
 * Gets the current goal position of the boss.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex		Boss index.
 * @param position			Buffer to store position.
 */
native void SF2_GetBossGoalPosition(int bossIndex, float position[3]);

/**
 * Returns if the given profile is loaded or not.
 *
 * @param profile		Profile name.
 * @return				True if loaded, false otherwise.
 */
native bool SF2_IsBossProfileValid(const char[] profile);

#pragma deprecated Use SF2BossProfileData instead.
native int SF2_GetBossProfileNum(const char[] profile, const char[] key, int defaultValue=0);

#pragma deprecated Use SF2BossProfileData instead.
native float SF2_GetBossProfileFloat(const char[] profile, const char[] key, float defaultValue=0.0);

#pragma deprecated Use SF2BossProfileData instead.
native bool SF2_GetBossProfileString(const char[] profile, const char[] key, char[] buffer, int bufferLen, const char[] defaultValue="");

#pragma deprecated Use SF2BossProfileData instead.
native bool SF2_GetBossProfileVector(const char[] profile, const char[] key, float buffer[3], const float defaultValue[3]=NULL_VECTOR);

#pragma deprecated Use SF2ChaserBossProfileData.Attacks instead.
native int SF2_GetBossAttackProfileNum(const char[] profile, const char[] key, int defaultValue=0, const int attackIndex);

#pragma deprecated Use SF2ChaserBossProfileData.Attacks instead.
native float SF2_GetBossAttackProfileFloat(const char[] profile, const char[] key, float defaultValue=0.0, const int attackIndex);

#pragma deprecated Use SF2ChaserBossProfileData.Attacks instead.
native bool SF2_GetBossAttackProfileString(const char[] profile, const char[] key, char[] buffer, int bufferLen, const char[] defaultValue="", const int attackIndex);

#pragma deprecated Use SF2ChaserBossProfileData.Attacks instead.
native bool SF2_GetBossAttackProfileVector(const char[] profile, const char[] key, float buffer[3], const float defaultValue[3]=NULL_VECTOR, const int attackIndex);

#pragma deprecated Use SF2BossProfileData instead.
native bool SF2_GetRandomStringFromBossProfile(const char[] profile, const char[] key, char[] buffer, int bufferLen, int index=-1);

#pragma deprecated Use SF2BossProfileData instead.
native bool SF2_GetBossAttributeName(int bossIndex, int attribute);

#pragma deprecated Use SF2BossProfileData instead.
native float SF2_GetBossAttributeValue(int bossIndex, int attribute);

#pragma deprecated Use SF2_ChaserBossEntity.GetAttackName instead.
native int SF2_GetBossCurrentAttackIndex(int bossIndex);

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
 * Spawns boss effects based on the list of effects used.
 * Note this will not spawn the extra effects like the festive lights and the disco ball
 * Only use this best for spawning in temporary effects.
 * Note the array of effects must be an ArrayList that contains SF2BossProfileBaseEffectInfo.
 *
 * @param effects			The array of effects
 * @param bossIndex			Boss to use
 * @param overridePos		Override the spawn position of the effects
 * @param overrideAng		Override the spawn angles of the effects
 * @param output			The ArrayList that will contain all of the outputted entities as entity references
 * @param entityOverride	If not INVALID_ENT_REFERENCE will attach all particles to the desired entity
 */
native void SF2_SpawnBossEffects(ArrayList effects, int bossIndex, float overridePos[3] = NULL_VECTOR, float overrideAng[3] = NULL_VECTOR, ArrayList &output = null, int entityOverride = INVALID_ENT_REFERENCE);

/**
 *	Translates an activity name string into an Activity.
 *
 *	@param sActivity
 *	@return					Activity, or ACT_INVALID if not found.
 */
native Activity SF2_TranslateProfileActivityFromName(const char[] activity);

/**
 *	Given an activity or sequence, translates into a sequence index.
 *
 *	@param iEntity			Entity index
 *	@param sAnimation		Activity/sequence string
 *	@return					Sequence index, or -1 if not found.
 */
native int SF2_LookupProfileAnimation(int entity, const char[] animation);

/**
 * Returns the profile data found on a boss index, note this is the basic profile data, I.E. what all bosses use
 *
 * @param bossIndex		Boss index.
 * @param data			Data to be stored in. Note this takes in SF2BossProfileData
 */
native void SF2_GetProfileFromBossIndex(int bossIndex, any data[sizeof(SF2BossProfileData)]);

/**
 * Returns the chaser profile data found on a boss index.
 *
 * @param bossIndex		Boss index.
 * @param data			Data to be stored in. Note this takes in SF2ChaserBossProfileData
 */
native void SF2_GetChaserProfileFromBossIndex(int bossIndex, any data[sizeof(SF2ChaserBossProfileData)]);

/**
 * Returns the statue profile data found on a boss index.
 *
 * @param bossIndex		Boss index.
 * @param data			Data to be stored in. Note this takes in SF2StatueBossProfileData
 */
native void SF2_GetStatueProfileFromBossIndex(int bossIndex, any data[sizeof(SF2StatueBossProfileData)]);

/**
 * Returns the profile data found from a profile name, note this is the basic profile data, I.E. what all bosses use
 *
 * @param profile		Profile name.
 * @param data			Data to be stored in. Note this takes in SF2BossProfileData
 */
native bool SF2_GetProfileFromName(const char[] profile, any data[sizeof(SF2BossProfileData)]);

/**
 * Returns the chaser profile data found from a profile name.
 *
 * @param profile		Profile name.
 * @param data			Data to be stored in. Note this takes in SF2ChaserBossProfileData
 */
native bool SF2_GetChaserProfileFromName(const char[] profile, any data[sizeof(SF2ChaserBossProfileData)]);

/**
 * Returns the statue profile data found from a profile name.
 *
 * @param profile		Profile name.
 * @param data			Data to be stored in. Note this takes in SF2StatueBossProfileData
 */
native bool SF2_GetStatueProfileFromName(const char[] profile, any data[sizeof(SF2ChaserBossProfileData)]);

/**
 * Forces a boss to enter in the chase state and immediately go after the target.
 * If the boss is already chasing a target, then the target will be queued up for it to be auto chased.
 *
 * @param bossIndex		Boss index.
 * @param target		Entity to use.
 * @param value			Force chase state
 */
native void SF2_SetEntityForceChaseState(int bossIndex, CBaseEntity target, bool value);

/**
 * Methodmap responsible for all boss entities.
*/
methodmap SF2_BaseBossEntity < CBaseCombatCharacter
{
	/**
	 * Whether or not the entity is actually a base boss
	 */
	property bool IsValid
	{
		public native get();
	}

	/**
	 *	Gets the controller index that owns this entity.
	 */
	property int Controller
	{
		public native get();
	}

	/**
	 *	Gets the target entity index.
	 */
	property CBaseEntity Target
	{
		public native get();
	}

	/**
	 *	The current state of the boss.
	 */
	property int State
	{
		public native get();
	}

	/**
	 *	Time left in its current chase. Note that this does not always tick down
	 *	at a steady rate.
	 */
	property float CurrentChaseDuration
	{
		public native get();
		public native set(float value);
	}

	/**
	 * If set will override the chase duration next time the boss goes into the chase state.
	 * This value will reset to 0 once the boss enters the chase state.
	 */
	property float InitialChaseDuration
	{
		public native get();
		public native set(float value);
	}

	/**
	 *	Gets the boss's eye position.
	 *
	 *	@param buffer     Buffer to store position
	 */
	public native void EyePosition(float buffer[3]);

	/**
	 *	Gets the boss's profile name
	 *
	 *	@param buffer		Buffer to name
	 *  @param bufferLen	Size of buffer
	 */
	public native void GetProfileName(char[] buffer, int bufferLen);

	/**
	 * Gets the boss's name
	 *
	 * @param buffer		Buffer to name
	 * @param bufferLen		Size of buffer
	 */
	public native void GetName(char[] buffer, int bufferLen);

	/**
	 *	Attempts to cast an entity to be this entity.
	 *
	 *	@param entity     Entity to use
	 */
	public SF2_BaseBossEntity(int entity)
	{
		return view_as<SF2_BaseBossEntity>(entity);
	}

	/**
	 * Gets the boss's profile data.
	 *
	 * @param data		Data to be stored in. Note this takes in SF2BossProfileData
	 */
	public native void ProfileData(any data[sizeof(SF2BossProfileData)]);

	/**
	 * Plays an animation on the boss from a specific animation section, even custom ones.
	 *
	 * @param animType			Animation section to search in.
	 * @param preDefinedIndex	Optional animation index to use.
	 * @param preDefinedName	Optional animation name to use.
	 * @param duration			Optional animation duration return.
	 */
	public native void ResetProfileAnimation(const char[] animType, int preDefinedIndex = -1, const char[] preDefinedName = "", float &duration = 0.0)
}

/**
 * The methodmap designed for statue bosses.
 */
methodmap SF2_StatueBossEntity < SF2_BaseBossEntity
{
	/**
	 * Whether or not the entity is actually a statue boss
	 */
	property bool IsValid
	{
		public native get();
	}

	/**
	 * Returns whether or not the statue is moving.
	 */
	property bool IsMoving
	{
		public native get();
	}

	/**
	 * Gets the time since the statue killed someone.
	 */
	property float LastKillTime
	{
		public native get();
	}

	/**
	 * Gets the boss's profile data.
	 *
	 * @param data		Data to be stored in. Note this takes in SF2StatueBossProfileData
	 */
	public native void ProfileData(any data[sizeof(SF2StatueBossProfileData)]);

	/**
	 *	Attempts to cast an entity to be this entity.
	 *
	 *	@param entity     Entity to use
	 */
	public SF2_StatueBossEntity(int entity)
	{
		return view_as<SF2_StatueBossEntity>(entity);
	}
}

methodmap SF2_ChaserBossEntity < SF2_BaseBossEntity
{
	/**
	 * Whether or not the entity is actually a chaser boss
	 */
	property bool IsValid
	{
		public native get();
	}

	/**
	 *	Attempts to cast an entity to be this entity.
	 *
	 *	@param entity     Entity to use
	 */
	public SF2_ChaserBossEntity(int entity)
	{
		return view_as<SF2_ChaserBossEntity>(entity);
	}

	/**
	 *	Whether or not the boss is attempting to move somewhere else.
	 */
	property bool IsAttemptingToMove
	{
		public native get();
	}

	/**
	 *	Whether or not the boss is attacking.
	 */
	property bool IsAttacking
	{
		public native get();
	}

	/**
	 *	Whether or not the boss is stunned or not.
	 */
	property bool IsStunned
	{
		public native get();
	}

	/**
	 *	The current stun health.
	 */
	property int StunHealth
	{
		public native get();
	}

	/**
	 *	The maximum stun health the boss spawns with.
	 */
	property int MaxStunHealth
	{
		public native get();
	}

	/**
	 *	Whether or not stun health can be subtracted from the boss. This is
	 *	affected by several factors including: if stunning is enabled or
	 *	stun cooldown has elapsed.
	 */
	property bool CanBeStunned
	{
		public native get();
	}

	/**
	 *	Whether or not the boss can take damage. This is mainly useful if the
	 *	boss is performing an attack that makes them invulnerable or are currently
	 *	in a rage state.
	 */
	property bool CanTakeDamage
	{
		public native get();
	}

	/**
	 *	Whether or not the boss is currently raging.
	 */
	property bool IsRaging
	{
		public native get();
	}

	/**
	 *	Whether or not the boss is currently running away to go heal.
	 */
	property bool IsRunningAway
	{
		public native get();
	}

	/**
	 *	Whether or not the boss is currently trying to self heal.
	 */
	property bool IsSelfHealing
	{
		public native get();
	}

	/**
	 * Gets the boss's profile data.
	 *
	 * @param data		Data to be stored in. Note this takes in SF2ChaserBossProfileData
	 */
	public native void ProfileData(any data[sizeof(SF2ChaserBossProfileData)]);

	/**
	 * Forces the boss to perform a voice. Note custom sound sections will not work.
	 *
	 * @param soundType		Sound type.
	 * @param attackName	Optional attack name to search for.
	 * @return				Whether or not the boss performed a voice.
	 */
	public native bool PerformVoice(int soundType = -1, const char[] attackName = "")

	/**
	 *	Gets the default posture of the boss. The default posture of a boss
	 *	is named "default".
	 *
	 *	@param buffer		Buffer to store string
	 *	@param bufferSize	Size of buffer
	 *	@return				Number of characters written to buffer
	 */
	public native int GetDefaultPosture(char[] buffer, int bufferSize);

	/**
	 *	Sets the default posture of the boss.
	 *
	 *	@param buffer	Posture to set to
	 *	@return			True if successful, false otherwise
	 */
	public native void SetDefaultPosture(const char[] buffer);

	/**
	 *	Gets the current attack name of the boss.
	 *
	 *	@param buffer		Buffer to store string
	 *	@param bufferSize	Size of buffer
	 *	@return				Number of characters written to buffer
	 */
	public native int GetAttackName(char[] buffer, int bufferSize);

	/**
	 *	Gets the current attack index of the boss.
	 */
	property int AttackIndex
	{
		public native get();
	}

	/**
	 *	Gets the time which the attack can be used again
	 *
	 *	@param attackName		Attack name
	 *	@return					Timestamp
	 */
	public native float GetNextAttackTime(const char[] attackName);

	/**
	 *	Sets the time which the attack can be used again
	 *
	 *	@param attackName		Attack name
	 *	@param time				Timestamp
	 */
	public native void SetNextAttackTime(const char[] attackName, float time);

	/**
	 * Drops a medkit/ammo pack depending on how the boss is configured
	 *
	 * @param death		Whether or not to use the death state's item drop state
	 */
	public native void DropItem(bool death = false)

	/**
	 * Checks if an attack is possible the default way
	 * This only includes FOV and range checks
	 * Difficulty checks and health checks are not included by default
	 * Note that cooldown checks are already handled in SF2_ChaserEntity.GetAttackAction
	 * And visibility checks are already handled in SF2_ChaserAttackLayerAction
	 * You would use this primarily in SF2_OnIsBossCustomAttackPossible
	 *
	 * @param attackName			Name of the attack
	 * @param includeDifficulties	Whether or not to include the difficulty checks
	 * @param includeHealth			Whether or not to include target health checks
	 * @return						Whether or not the attack is possible with the distance and FOV checks
	 */
	public bool IsAttackPossibleDefault(const char[] attackName, bool includeDifficulties = false, bool includeHealth = false)
	{
		if (!this.Target.IsValid())
		{
			return false;
		}

		int controller = this.Controller;
		int difficulty = SF2_GetBossDifficulty(controller);

		INextBot bot = this.MyNextBotPointer();
		SF2ChaserBossProfileData data;
		this.ProfileData(data);
		SF2ChaserBossProfileAttackData attackData;
		data.GetAttack(attackName, attackData);
		float eyePos[3], targetPos[3], direction[3], eyeAng[3];
		this.GetAbsAngles(eyeAng);
		SF2_GetBossEyePosition(controller, eyePos);
		this.Target.GetAbsOrigin(targetPos);
		SubtractVectors(targetPos, eyePos, direction);
		GetVectorAngles(direction, direction);
		direction[2] = 180.0;

		float distance = bot.GetRangeSquaredTo(this.Target.index);
		float fov = FloatAbs(AngleDiff(direction[1], eyeAng[1]));

		if (distance > Pow(attackData.BeginRange[difficulty], 2.0))
		{
			return false;
		}

		if (fov > attackData.BeginFOV[difficulty])
		{
			return false;
		}

		if (includeDifficulties)
		{
			if (difficulty < attackData.UseOnDifficulty)
			{
				return false;
			}

			if (difficulty >= attackData.BlockOnDifficulty)
			{
				return false;
			}
		}

		if (includeHealth)
		{
			float health = float(this.Target.GetProp(Prop_Send, "m_iHealth"));
			if (attackData.UseOnHealth != -1.0 && health < attackData.UseOnHealth)
			{
				return false;
			}
			if (attackData.BlockOnHealth != -1.0 && health >= attackData.BlockOnHealth)
			{
				return false;
			}
		}
		return true;
	}
}

/**
 * An action that plays a given sequence on the actor. This action exits when the
 * duration has elapsed.
 */
methodmap SF2_PlaySequenceAndWaitAction < NextBotAction
{
	/**
	 * @param sequence		Sequence index
	 * @param duration 		How long the action should last. If 0.0, then this will be the sequence's
	 * 						duration.
	 * @param rate			Playback rate
	 * @param cycle			Start cycle value, from 0.0 to 1.0
	 */
	public native SF2_PlaySequenceAndWaitAction(int sequence, float duration = 0.0, float rate = 1.0, float cycle = 0.0);
}

/**
 * Interface to SF2_BasePlayer
 */
methodmap SF2_Player < CBaseCombatCharacter
{
	/**
	 *	Attempts to cast a client to be this entity.
	 *
	 *	@param client     Client to use
	 */
	public SF2_Player(int client)
	{
		if (client <= 0)
		{
			return view_as<SF2_Player>(-1);
		}
		return view_as<SF2_Player>(client);
	}

	property int UserID
	{
		public native get();
	}

	/**
	 * Returns true if the client index is > 0 and <= MaxClients, and if the client is in game.
	 */
	property bool IsValid
	{
		public native get();
	}

	/**
	 * Alias of IsPlayerAlive()
	 */
	property bool IsAlive
	{
		public native get();
	}

	/**
	 * Alias of IsClientInGame()
	 * Use this over IsClientInGame() though as it has extra optimizations
	 */
	property bool IsInGame
	{
		public native get();
	}

	/**
	 * Alias of IsFakeClient()
	 */
	property bool IsBot
	{
		public native get();
	}

	/**
	 * Alias of IsClientSourceTV()
	 */
	property bool IsSourceTV
	{
		public native get();
	}

	/**
	 * Alias of IsClientReplay()
	 */
	property bool IsReplay
	{
		public native get();
	}

	/**
	 * Whether or not the client is in third person mode
	 */
	property bool InThirdPerson
	{
		public native get();
	}

	/**
	 * Alias of GetClientButtons()
	 */
	property int Buttons
	{
		public native get();
	}

	/**
	 * Whether or not the client is moving
	 */
	public native bool IsMoving();

	/**
	 * Gets/Sets the client's health
	 */
	property int Health
	{
		public native get();

		public native set(int value);
	}

	/**
	 * Gets the client's max health
	 */
	property int MaxHealth
	{
		public native get();
	}

	/**
	 * Whether or not the client is trying to duck
	 */
	property bool Ducking
	{
		public native get();
	}

	/**
	 * Whether or not the client is currently ducked
	 */
	property bool Ducked
	{
		public native get();
	}

	/**
	 * Alias of GetEntDataEnt2()
	 */
	public native int GetDataEnt(int offset);

	/**
	 * Alias of TF2_GetPlayerClass()
	 */
	property TFClassType Class
	{
		public native get();
	}

	/**
	 * Alias of GetClientTeam()
	 */
	property int Team
	{
		public native get();
	}

	/**
	 * Whether or not the client has a regenerating item like the Cozy Camper
	 */
	property bool HasRegenItem
	{
		public native get();

		public native set(bool state);
	}

	/**
	 * Alias of TF2_IsPlayerInCondition()
	 * Use this over TF2_IsPlayerInCondition() though as it has extra optimizations
	 *
	 * @param condition		Condition type
	 */
	public native bool InCondition(TFCond condition);

	/**
	 * Alias of both TF2_RemoveCondition() and TF2_AddCondition()
	 *
	 * @param condition		Condition type
	 * @param remove		Whether or not the condition should be removed
	 * @param duration		How long the condition will last
	 * @param inflictor		Inflictor of the condition
	 */
	public native bool ChangeCondition(TFCond condition, bool remove = false, float duration = -1.0, int inflictor = 0);

	/**
	 * Whether or not the client is crit boosted
	 */
	public native bool IsCritBoosted();

	/**
	 * Whether or not the client is mini crit boosted
	 */
	public native bool IsMiniCritBoosted();

	/**
	 * Alias of TF2_IgnitePlayer()
	 *
	 * @param self		Whether or not the attacker should be the player itself
	 * @param attacker	Attacker index, this doesn't need to be set if self is true
	 * @param duration	How long the afterburn should last
	 */
	public native void Ignite(bool self = false, int attacker = 0, float duration = 10.0);

	/**
	 * Alias of TF2_MakeBleed()
	 *
	 * @param self		Whether or not the attacker should be the player itself
	 * @param attacker	Attacker index, this doesn't need to be set if self is true
	 * @param duration	How long the bleed should last
	 */
	public native void Bleed(bool self = false, int attacker = 0, float duration = 5.0);

	/**
	 * Alias of TF2_StunPlayer()
	 *
	 * @param duration		How long the stun should last
	 * @param slowdown		The multiplier to the player's speed in which they'll be slowed for
	 * @param stunFlags		The flags of the stun
	 * @param attacker		Attacker index
	 */
	public native void Stun(float duration, float slowdown = 0.0, int stunflags, int attacker = 0);

	/**
	 * Alias of TF2_RegeneratePlayer()
	 */
	public native void Regenerate();

	/**
	 * Alias of TF2_SetPlayerClass()
	 *
	 * @param classType		New class
	 * @param weapons		Ignored/Unused
	 * @param persistent	Whether or not the class change should remain after death
	 */
	public native void SetClass(TFClassType classType, bool weapons = true, bool persistent = true);

	/**
	 * Alias of GetClientEyePosition()
	 *
	 * @param vector		Destination to store the eye position
	 */
	public native void GetEyePosition(float vector[3]);

	/**
	 * Alias of GetClientEyeAngles()
	 *
	 * @param vector		Destination to store the eye angles
	 */
	public native void GetEyeAngles(float vector[3]);

	/**
	 * Alias of GetEntDataVector()
	 *
	 * @param offset		Offset to use
	 * @param buffer		Vector to store the data in
	 */
	public native void GetDataVector(int offset, float buffer[3]);

	/**
	 * Alias of SetEntDataVector()
	 *
	 * @param offset		Offset to use
	 * @param buffer		Vector to set
	 * @param state			Whether or not the state should be sent over the network
	 */
	public native void SetDataVector(int offset, const float buffer[3], bool state = false);

	/**
	 * Returns the player's distance from an entity
	 * Note this does not use the square root method
	 *
	 * @param ent	Entity to check
	 */
	public native float GetDistanceFromEntity(int ent);

	/**
	 * Alias of GetPlayerWeaponSlot()
	 *
	 * @param slot		Weapon slot
	 */
	public native int GetWeaponSlot(int slot);

	/**
	 * Switches the player's weapon slot to a specified index
	 *
	 * @param slot		Weapon slot
	 */
	public native void SwitchToWeaponSlot(int slot);

	/**
	 * Alias of TF2_RemoveWeaponSlot()
	 *
	 * @param slot		Weapon slot
	 */
	public native void RemoveWeaponSlot(int slot);

	/**
	 * Shakes the player's screen
	 *
	 * @param amp		Amplitude
	 * @param duration	Duration of the screen shake
	 * @param freq		Frequency
	 */
	public native void ScreenShake(float amp, float duration, float freq);

	/**
	 * Flings the client's camera in a specific direction
	 *
	 * @param punchVel		Direction/Strength
	 */
	public native void ViewPunch(const float punchVel[3]);

	/**
	 * Alias of SDKHooks_TakeDamage()
	 *
	 * @param self				Self damage
	 * @param inflictor			Inflictor index, don't need to set if self is true
	 * @param attacker			Attacker index, don't need to set if self is true
	 * @param damage			Damage to take
	 * @param damageType		Type of damage
	 * @param weapon			Weapon index
	 * @param damageForce		Velocity of damage force
	 * @param damagePosition	Origin of damage
	 * @param bypassHooks		Whether or not to bypass SDK hooks on OnTakeDamage
	 */
	public native void TakeDamage(bool self = false, int inflictor = 0, int attacker = 0, float damage, int damageType = 0, int weapon = -1,
		const float damageForce[3] = NULL_VECTOR, const float damagePosition[3] = NULL_VECTOR, bool bypassHooks = true);

	/**
	 * Alias of TF2_RespawnPlayer()
	 */
	public native void Respawn();

	/**
	 * Updates the player's listening flags which determine if a player can hear the voice chat from a player
	 *
	 * @param reset		Resets all flags
	 */
	public native void UpdateListeningFlags(bool reset = false);

	/**
	 * Determines if the player is actually is a valid class, is in RED or BLU, and if the player is not coaching
	 */
	property bool IsParticipating
	{
		public native get();
	}

	/**
	 * Alias of GetClientName()
	 *
	 * @param name		Buffer to store the client's name.
	 * @param length	Maximum length of string buffer
	 */
	public native bool GetName(char[] name, int length);

	/**
	 * Gets/Sets the last buttons the player pressed
	 */
	property int LastButtons
	{
		public native get();

		public native set(int value);
	}

	/**
	 * Makes the player's speed fade to a specific color
	 */
	public native void ScreenFade(int duration, int time, int flags, int r, int g, int b, int a);

	/**
	 * Whether or not the player is eliminated from the game
	 */
	property bool IsEliminated
	{
		public native get();

		public native set(bool state);
	}

	/**
	 * Whether or not the player is in ghost mode
	*/
	property bool IsInGhostMode
	{
		public native get();
	}

	/**
	 * Sets the player's ghost mode state
	 *
	 * @param state		New ghost mode state
	 */
	public native void SetGhostState(bool state);

	/**
	 * Whether or not the player is a proxy
	 */
	property bool IsProxy
	{
		public native get();

		public native set(bool state);
	}

	/**
	 * Gets/Sets the player's proxy control points
	 */
	property int ProxyControl
	{
		public native get();

		public native set(int value);
	}

	/**
	 * Gets/Sets the player's proxy master as a boss index
	 */
	property int ProxyMaster
	{
		public native get();

		public native set(int value);
	}

	/**
	 * Whether or not the player is in a PvP arena
	 */
	property bool IsInPvP
	{
		public native get();
	}

	/**
	 * Whether or not the player is in a PvE arena
	 */
	property bool IsInPvE
	{
		public native get();
	}

	/**
	 * Whether or not the player is in a death cam
	 */
	property bool IsInDeathCam
	{
		public native get();
	}

	/**
	 * Starts a death cam for a boss
	 *
	 * @param bossIndex			Boss index to use
	 * @param lookPos			What position the player should look at
	 * @param antiCamp			Whether or not this was an anticamping death, only useful for public death cams
	 */
	public native void StartDeathCam(int bossIndex, const float lookPos[3], bool antiCamp = false);

	/**
	 * Whether or not the player has escaped
	 */
	property bool HasEscaped
	{
		public native get();
	}

	/**
	 * Makes the player escape. Note this will not teleport the player to a escape point
	 */
	public native void Escape();

	/**
	 * Teleports the player to an escape point
	 */
	public native void TeleportToEscapePoint();

	/**
	 * Makes the player escape and teleports them to an escape point
	 */
	public native void ForceEscape();

	/**
	 * Whether or not the player is using a flashlight
	 */
	property bool UsingFlashlight
	{
		public native get();
	}

	/**
	 * Toggles the player's flashlight state
	 */
	public native void HandleFlashlight();

	/**
	 * Gets/Sets the player's flashlight battery life
	 */
	property float FlashlightBatteryLife
	{
		public native get();

		public native set(float value);
	}

	/**
	 * Resets the player's flashlight
	 */
	public native void ResetFlashlight();

	/**
	 * Returns the player's next flashlight input time
	 */
	public native float GetFlashlightNextInputTime();

	/**
	 * Whether or not the player is sprinting. Note this only checks if the player is pressing the sprint button
	 */
	property bool IsSprinting
	{
		public native get();
	}

	/**
	 * Whether or not the player is really sprinting.
	 * This does consider if the player is on the ground and is actually moving
	 */
	property bool IsReallySprinting
	{
		public native get();
	}

	/**
	 * Toggles the player's sprint state
	 */
	public native void HandleSprint(bool sprint);

	/**
	 * Gets/sets the player's stamina
	 */
	property float Stamina
	{
		public native get();

		public native set(float value);
	}

	/**
	 * Sets the stamina's next recharge time
	 *
	 * @param time			Amount of time it will take for the stamina to continue to recharge
	 * @param checkTime		Whether or not to check if the current recharge time is greater than the
	 * 						inputted recharge time
	 */
	public native void SetStaminaRechargeTime(float time, bool checkTime = true);

	/**
	 * Whether or not the player's blink HUD element is showing
	 */
	property bool HasStartedBlinking
	{
		public native get();
	}

	/**
	 * Whether or not the player is currently blinking
	 */
	property bool IsBlinking
	{
		public native get();
	}

	/**
	 * Whether or not the player is continuing to stay blinked
	 */
	public native bool IsHoldingBlink();

	/**
	 * Sets the player's blink state
	 *
	 * @param value		Blink state
	 */
	public native void SetHoldingBlink(bool value);

	/**
	 * Gets/Sets the player's blink meter from 0.0 to 1.0
	 */
	property float BlinkMeter
	{
		public native get();

		public native set(float amount);
	}

	/**
	 * Returns how many times the player blinked
	 */
	property int BlinkCount
	{
		public native get();
	}

	/**
	 * Makes the player blink
	 */
	public native void Blink();

	/**
	 * Makes the player start the peeking. This puts the player in third person
	 */
	public native bool StartPeeking();

	/**
	 * Makes the player end the peeking state. This simply puts the player back in first person
	 */
	public native void EndPeeking();

	/**
	 * Gets/Sets the amount of pages the player has collected
	 */
	property int PageCount
	{
		public native get();

		public native set(int amount);
	}

	/**
	 * Shows a hint to the player if the player has it enabled
	 *
	 * @param hint		Hint index
	 */
	public native void ShowHint(int hint);

	/**
	 * Gets/Sets the player's trap state
	 */
	property bool IsTrapped
	{
		public native get();

		public native set(bool state);
	}

	/**
	 * Gets/Sets the player's times they need to jump to not be trapped anymore
	 */
	property int TrapCount
	{
		public native get();

		public native set(int amount);
	}

	/**
	 * Gets/Sets the player's latched state if they're latched onto a boss's rope/tongue ability
	 */
	property bool IsLatched
	{
		public native get();

		public native set(bool state);
	}

	/**
	 * Gets/Sets the player's times they need to jump to not be latched by a boss anymore
	 */
	property int LatchCount
	{
		public native get();

		public native set(int amount);
	}

	/**
	 * Gets/Sets the player's latcher based on which boss is latching them with a boss's rope/tongue ability
	 */
	property int Latcher
	{
		public native get();

		public native set(int value);
	}

	/**
	 * Updates the player's music state
	 *
	 * @param initialize		Unknown????? Nobody knows what this actually does.
	 */
	public native void UpdateMusicSystem(bool initialize = false);

	/**
	 * Whether or not the player has a glow active
	 */
	property bool HasConstantGlow
	{
		public native get();
	}

	/**
	 * Sets the player's play state based on if they're in RED
	 *
	 * @param state			State to be in
	 * @param enablePlay	Whether or not the player is actively playing. Only set this if you know what you're doing
	 */
	public native void SetPlayState(bool state, bool enablePlay = true);

	/**
	 * Whether or not the player can see a boss
	 *
	 * @param bossIndex			Boss to check
	 * @param checkFOV			Considers if the boss is in the player's FOV
	 * @param checkBlink		Considers if the player is blinking
	 * @param checkEliminated	Considers if the player is eliminated
	 */
	public native bool CanSeeSlender(int bossIndex, bool checkFOV = true, bool checkBlink = false, bool checkEliminated = true);

	/**
	 * Sets the player's AFK time based on a set number of conditions
	 *
	 * @param reset		Whether or not the AFK time should be reset to the default AFK time
	 */
	public native void SetAFKTime(bool reset = true);

	/**
	 * Sets the player's AFK state
	 */
	public native void SetAFKState();

	/**
	 * Checks to make sure if the player is AFK or not, if they are the game puts the player in a AFK state
	 */
	public native void CheckAFKTime();

	/**
	 * Returns if the player should be immediately chased by a boss
	 *
	 * @param bossIndex		Boss to check
	 */
	public native bool ShouldBeForceChased(int bossIndex);

	/**
	 * Sets the player's state to be immediately chased by a boss
	 *
	 * @param bossIndex		Boss to use
	 * @param value			State
	 */
	public native void SetForceChaseState(int bossIndex, bool value);

	/**
	 * Checks if a player is looking at a boss
	 *
	 * @param bossIndex			Boss to check
	 */
	public native bool IsLookingAtBoss(int bossIndex);
}

/**
 * Interface to SF2_ProjectileBase
 *
 * Useful for creating custom projectiles, see sf2/entities/projectiles to see how projectiles are created
 */
methodmap SF2_Projectile_Base < CBaseAnimating
{
	/**
	 * Initializes a projectile's stats
	 *
	 * @param type			Projectile type
	 * @param owner			Owner entity
	 * @param pos			Spawn position
	 * @param ang			Spawn angles
	 * @param speed			Speed of the projectile
	 * @param damage		Damage of the projectile
	 * @param blastRadius	If configured to explode, the blast radius of the projectile
	 * @param isCrits		Whether or not to use the crit damage type
	 * @param trail			Trail material name
	 * @param explosion		Explosion particle
	 * @param impactSound	Impact/explosion sound
	 * @param model			Model name
	 * @param attackWaiters	Whether or not the BLU team should be hurt
	 */
	public native void Initialize(const int type = SF2BossProjectileType_Custom,
								const CBaseEntity owner,
								const float pos[3],
								const float ang[3],
								const float speed,
								const float damage,
								const float blastRadius,
								const bool isCrits,
								const char[] trail,
								const char[] explosion,
								const char[] impactSound,
								const char[] model,
								const bool attackWaiters = false);

	/**
	 * Triggers a explosion on the projectile and removes it
	 */
	public native void DoExplosion();

	/**
	 *	Attempts to cast an entity to be this entity.
	 *
	 *	@param entity     Entity to use
	 */
	public SF2_Projectile_Base(int entity)
	{
		return view_as<SF2_Projectile_Base>(entity);
	}
}

/**
 * The methodmap for arrow projectiles
 */
methodmap SF2_Projectile_Arrow < SF2_Projectile_Base
{
	/**
	 * Creates a arrow projectile.
	 *
	 * @param owner			Owner entity
	 * @param pos			Spawn position
	 * @param ang			Spawn angles
	 * @param speed			Speed of the projectile
	 * @param damage		Damage of the projectile
	 * @param isCrits		Whether or not to use the crit damage type
	 * @param trail			Trail material name
	 * @param impactSound	Impact sound when it hits a player
	 * @param model			Model name
	 * @param attackWaiters	Whether or not the BLU team should be hurt
	 * @return				Projectile entity
	 */
	public static native SF2_Projectile_Arrow Create(
		const CBaseEntity owner,
		const float pos[3],
		const float ang[3],
		const float speed,
		const float damage,
		const bool isCrits,
		const char[] trail,
		const char[] impactSound,
		const char[] model,
		const bool attackWaiters = false);

	/**
	 *	Attempts to cast an entity to be this entity.
	 *
	 *	@param entity     Entity to use
	 */
	public SF2_Projectile_Arrow(int entity)
	{
		return view_as<SF2_Projectile_Arrow>(entity);
	}
}

/**
 * The methodmap for baseball projectiles
 */
methodmap SF2_Projectile_Baseball < SF2_Projectile_Base
{
	/**
	 * Creates a baseball projectile.
	 *
	 * @param owner			Owner entity
	 * @param pos			Spawn position
	 * @param ang			Spawn angles
	 * @param speed			Speed of the projectile
	 * @param damage		Damage of the projectile
	 * @param isCrits		Whether or not to use the crit damage type
	 * @param model			Model name
	 * @param attackWaiters	Whether or not the BLU team should be hurt
	 * @return				Projectile entity
	 */
	public static native SF2_Projectile_Baseball Create(
		const CBaseEntity owner,
		const float pos[3],
		const float ang[3],
		const float speed,
		const float damage,
		const bool isCrits,
		const char[] model,
		const bool attackWaiters = false);

	/**
	 *	Attempts to cast an entity to be this entity.
	 *
	 *	@param entity     Entity to use
	 */
	public SF2_Projectile_Baseball(int entity)
	{
		return view_as<SF2_Projectile_Baseball>(entity);
	}
}

/**
 * The methodmap for cow mangler projectiles
 */
methodmap SF2_Projectile_CowMangler < SF2_Projectile_Base
{
	/**
	 * Creates a cow mangler projectile.
	 *
	 * @param owner			Owner entity
	 * @param pos			Spawn position
	 * @param ang			Spawn angles
	 * @param speed			Speed of the projectile
	 * @param damage		Damage of the projectile
	 * @param blastRadius	The blast radius of the projectile
	 * @param attackWaiters	Whether or not the BLU team should be hurt
	 * @return				Projectile entity
	 */
	public static native SF2_Projectile_CowMangler Create(
		const CBaseEntity owner,
		const float pos[3],
		const float ang[3],
		const float speed,
		const float damage,
		const float blastRadius,
		const bool attackWaiters = false);

	/**
	 *	Attempts to cast an entity to be this entity.
	 *
	 *	@param entity     Entity to use
	 */
	public SF2_Projectile_CowMangler(int entity)
	{
		return view_as<SF2_Projectile_CowMangler>(entity);
	}
}

/**
 * The methodmap for fireball projectiles
 */
methodmap SF2_Projectile_Fireball < SF2_Projectile_Base
{
	/**
	 * Creates a fireball projectile.
	 *
	 * @param owner			Owner entity
	 * @param pos			Spawn position
	 * @param ang			Spawn angles
	 * @param speed			Speed of the projectile
	 * @param damage		Damage of the projectile
	 * @param blastRadius	The blast radius of the projectile
	 * @param impactSound	Impact sound when it hits a player
	 * @param trail			Trail material name
	 * @param attackWaiters	Whether or not the BLU team should be hurt
	 * @return				Projectile entity
	 */
	public static native SF2_Projectile_Fireball Create(
		const CBaseEntity owner,
		const float pos[3],
		const float ang[3],
		const float speed,
		const float damage,
		const float blastRadius,
		const char[] impactSound,
		const char[] trail,
		const bool attackWaiters = false);

	/**
	 *	Attempts to cast an entity to be this entity.
	 *
	 *	@param entity     Entity to use
	 */
	public SF2_Projectile_Fireball(int entity)
	{
		return view_as<SF2_Projectile_Fireball>(entity);
	}
}

/**
 * The methodmap for grenade projectiles
 */
methodmap SF2_Projectile_Grenade < SF2_Projectile_Base
{
	/**
	 * Creates a grenade projectile.
	 *
	 * @param owner			Owner entity
	 * @param pos			Spawn position
	 * @param ang			Spawn angles
	 * @param speed			Speed of the projectile
	 * @param damage		Damage of the projectile
	 * @param blastRadius	The blast radius of the projectile
	 * @param isCrits		Whether or not to use the crit damage type
	 * @param trail			Trail material name
	 * @param explosion		Explosion particle
	 * @param impactSound	Impact/explosion sound
	 * @param model			Model name
	 * @param attackWaiters	Whether or not the BLU team should be hurt
	 * @return				Projectile entity
	 */
	public static native SF2_Projectile_Grenade Create(
		const CBaseEntity owner,
		const float pos[3],
		const float ang[3],
		const float speed,
		const float damage,
		const float blastRadius,
		const bool isCrits,
		const char[] trail,
		const char[] explosion,
		const char[] impactSound,
		const char[] model,
		const bool attackWaiters = false);

	/**
	 *	Attempts to cast an entity to be this entity.
	 *
	 *	@param entity     Entity to use
	 */
	public SF2_Projectile_Grenade(int entity)
	{
		return view_as<SF2_Projectile_Grenade>(entity);
	}
}

/**
 * The methodmap for iceball projectiles
 */
methodmap SF2_Projectile_Iceball < SF2_Projectile_Base
{
	/**
	 * Creates a iceball projectile.
	 *
	 * @param owner				Owner entity
	 * @param pos				Spawn position
	 * @param ang				Spawn angles
	 * @param speed				Speed of the projectile
	 * @param damage			Damage of the projectile
	 * @param blastRadius		The blast radius of the projectile
	 * @param impactSound		Impact sound when it hits a player
	 * @param trail				Trail material name
	 * @param slowDuration		How long the slowdown effect lasts
	 * @param slowMultiplier	The speed multiplier of the slowdown effect
	 * @param freezeSound		The sound that plays when a player gets slowed down
	 * @param attackWaiters		Whether or not the BLU team should be hurt
	 * @return					Projectile entity
	 */
	public static native SF2_Projectile_Iceball Create(
		const CBaseEntity owner,
		const float pos[3],
		const float ang[3],
		const float speed,
		const float damage,
		const float blastRadius,
		const char[] impactSound,
		const char[] trail,
		const float slowDuration,
		const float slowMultiplier,
		const char[] freezeSound,
		const bool attackWaiters = false);

	/**
	 *	Attempts to cast an entity to be this entity.
	 *
	 *	@param entity     Entity to use
	 */
	public SF2_Projectile_Iceball(int entity)
	{
		return view_as<SF2_Projectile_Iceball>(entity);
	}
}

/**
 * The methodmap for rocket projectiles
 */
methodmap SF2_Projectile_Rocket < SF2_Projectile_Base
{
	/**
	 * Creates a rocket projectile.
	 *
	 * @param owner			Owner entity
	 * @param pos			Spawn position
	 * @param ang			Spawn angles
	 * @param speed			Speed of the projectile
	 * @param damage		Damage of the projectile
	 * @param blastRadius	The blast radius of the projectile
	 * @param isCrits		Whether or not to use the crit damage type
	 * @param trail			Trail material name
	 * @param explosion		Explosion particle
	 * @param impactSound	Impact/explosion sound
	 * @param model			Model name
	 * @param attackWaiters	Whether or not the BLU team should be hurt
	 * @return				Projectile entity
	 */
	public static native SF2_Projectile_Rocket Create(
		const CBaseEntity owner,
		const float pos[3],
		const float ang[3],
		const float speed,
		const float damage,
		const float blastRadius,
		const bool isCrits,
		const char[] trail,
		const char[] explosion,
		const char[] impactSound,
		const char[] model,
		const bool attackWaiters = false);

	/**
	 *	Attempts to cast an entity to be this entity.
	 *
	 *	@param entity     Entity to use
	 */
	public SF2_Projectile_Rocket(int entity)
	{
		return view_as<SF2_Projectile_Rocket>(entity);
	}
}

/**
 * The methodmap for sentry rocket projectiles
 */
methodmap SF2_Projectile_SentryRocket < SF2_Projectile_Base
{
	/**
	 * Creates a sentry rocket projectile.
	 *
	 * @param owner			Owner entity
	 * @param pos			Spawn position
	 * @param ang			Spawn angles
	 * @param speed			Speed of the projectile
	 * @param damage		Damage of the projectile
	 * @param blastRadius	The blast radius of the projectile
	 * @param isCrits		Whether or not to use the crit damage type
	 * @param attackWaiters	Whether or not the BLU team should be hurt
	 * @return				Projectile entity
	 */
	public static native SF2_Projectile_SentryRocket Create(
		const CBaseEntity owner,
		const float pos[3],
		const float ang[3],
		const float speed,
		const float damage,
		const float blastRadius,
		const bool isCrits,
		const bool attackWaiters = false);

	/**
	 *	Attempts to cast an entity to be this entity.
	 *
	 *	@param entity     Entity to use
	 */
	public SF2_Projectile_SentryRocket(int entity)
	{
		return view_as<SF2_Projectile_SentryRocket>(entity);
	}
}

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
 * Adds a boss to the pool of PvE bosses. Note this takes entity names
 *
 * @param bossName	Boss entity name
 */
native void SF2_RegisterPvEBoss(char[] bossName);

/**
 * Removes a boss from the pool of PvE bosses. Note this takes entity names
 * You MUST call this whenever your boss sub plugin ends or the gamemode will spawn an invalid entity
 *
 * @param bossName	Boss entity name
 */
native void SF2_UnregisterPvEBoss(char[] bossName);

/**
 * Adds a boss onto the PvE boss list. This is required when you spawn your bosses in.
 *
 * @param bossEnt		Entity to add
 */
native void SF2_AddPvEBoss(int bossEnt);

/**
 * Removes a boss from the PvE boss list. This is required when your boss dies.
 *
 * @param bossEnt		Entity to remove
 */
native void SF2_KillPvEBoss(int bossEnt);

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
