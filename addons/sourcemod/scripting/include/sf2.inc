#if defined _sf2_included
 #endinput
#endif
#define _sf2_included

#include <cbasenpc>
#include <cbasenpc/util>
#include <cbasenpc/matrix>

#define PLUGIN_VERSION "1.8.0 M Alpha 3 Indev 4-9-2025"
#define PLUGIN_VERSION_DISPLAY "1.8.0 M Alpha 3 Indev 4-9-2025"

// Some defines.
#define SF2_MAX_PROFILE_NAME_LENGTH 64
#define SF2_MAX_NAME_LENGTH 32

#define MAX_BOSSES 64
#define MAX_NPCTELEPORTER 5
#define MAX_TRAPS 32
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
	SF2BossSound_Smell = 10,
	SF2BossSound_AttackBegin,
	SF2BossSound_AttackEnd,
	SF2BossSound_SelfHeal,
	SF2BossSound_RageAll,
	SF2BossSound_RageTwo = 15,
	SF2BossSound_RageThree,
	SF2BossSound_Despawn,
	SF2BossSound_Hurt,
	SF2BossSound_Jump,
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
	SF2BossAnimation_ProjectileShoot,
	SF2BossAnimation_Despawn,
	SF2BossAnimation_Jump,
	SF2BossAnimation_Air,
	SF2BossAnimation_Land,
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

stock char g_SlenderVoiceList[SF2BossSound_MaxSounds][] =
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
	"sound_attack_end",
	"sound_heal_self",
	"sound_rage",
	"sound_rage_2",
	"sound_rage_3",
	"sound_despawn",
	"sound_hurt",
	"sound_jump"
};

stock char g_SlenderAnimationsList[SF2BossAnimation_MaxAnimations][] =
{
	"idle",
	"walk",
	"attack",
	"run",
	"stun",
	"chaseinitial",
	"rage",
	"spawn",
	"fleestart",
	"heal",
	"deathcam",
	"death",
	"tauntkill",
	"smell",
	"attack_begin",
	"attack_end",
	"shoot",
	"despawn",
	"jump",
	"air",
	"land"
};

stock char g_AttributesList[SF2Attribute_Max][] =
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

enum RenevantWave
{
	RenevantWave_Normal = 0,
	RenevantWave_IncreaseDifficulty,
	RenevantWave_MultiEffect,
	RenevantWave_BaconSpray,
	RenevantWave_DoubleTrouble,
	RenevantWave_DoomBox,
	RenevantWave_90s,
	RenevantWave_MarkForDeath,
	RenevantWave_SingleBoss,
	RenevantWave_AdminBoss,
	RenevantWave_WallHax,
	RenevantWave_Max
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
#define SFF_HASSTATICSHAKE (1 << 17)

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
#define COND_ALERT_TRIGGER_POS (1 << 15)
#define COND_ENEMYVISIBLE_NOGLASS (1 << 16)

/**
 * Called after a boss profile is successfully loaded.
 *
 * @param profile		Profile name
 * @param kv			Key Values
 */
forward void SF2_OnBossProfileLoaded(const char[] profile, SF2_BaseBossProfile data);

/**
 * Called before a boss profile is unloaded.
 *
 * @param profile		Profile name
 */
forward void SF2_OnBossProfileUnloaded(const char[] profile, SF2_BaseBossProfile data);

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
 * @param bossIndex		Boss index.
 * @param speed			The boss's run speed.
 * @return				If Plugin_Changed, speed is used as the boss's run speed.
 */
forward Action SF2_OnBossGetSpeed(int bossIndex, float &speed);

/**
 * Called to determine the boss's walk speed.
 *
 * @param bossIndex		Boss index.
 * @param walkSpeed		The boss's walk speed.
 * @return				If Plugin_Changed, speed is used as the boss's walk speed.
 */
forward Action SF2_OnBossGetWalkSpeed(int bossIndex, float &walkSpeed);

/**
 * Called after the boss has determined it can hear the entity.
 *
 * @param bossIndex		Boss index.
 * @param entity		Entity index.
 * @param soundType		The type of sound to check.
 * @return				Returning a value other than Plugin_Continue will block hearing to the entity.
 */
forward Action SF2_OnBossHearEntity(int bossIndex, int entity, SoundType soundType);

/**
 * Called after the boss has determined it can see the entity.
 *
 * @param bossIndex		Boss index.
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
 * @param bossIndex			Boss index.
 * @param attackArray		ArrayList containing all valid attack indexes.
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
 * @param bossIndex		Boss index.
 */
forward void SF2_OnClientScare(int client, int bossIndex);

/**
 * Called when the player gets caught by a boss, either from too much static, being within
 * a boss's kill radius, or dies from too much camping. This is also called for fake bosses.
 *
 * @param client		Client index.
 * @param bossIndex		Boss index.
 */
forward void SF2_OnClientCaughtByBoss(int client, int bossIndex);

/**
 * Called when giving queue points to the player at the end of the round.
 *
 * @param client		Client index.
 * @param addAmount		The amount of queue points to give.
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
 * @param bossIndex		Boss the client is looking at.
 */
forward void SF2_OnClientLooksAtBoss(int client, int bossIndex);

/**
 * Called when the player looks away from the boss.
 *
 * @param client		Client index.
 * @param bossIndex		Boss the client is no longer looking at.
 */
forward void SF2_OnClientLooksAwayFromBoss(int client, int bossIndex);

/**
 * Called when the player gets caught in a boss's deathcam.
 *
 * @param client		Client index.
 * @param bossIndex		Boss index.
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
 * @param bossIndex		Boss index.
 * @param antiCamp		Whether the client died due to the anti camping timer.
 */
forward void SF2_OnClientEndDeathCam(int client, int bossIndex, bool antiCamp);

/**
 * Called to determine a player's default walk speed.
 *
 * @param client			Client index.
 * @param defaultFloat		The default walk speed.
 * @return					If Plugin_Changed, defaultFloat is used as player's default walk speed.
 */
forward Action SF2_OnClientGetDefaultWalkSpeed(int client, float &defaultFloat);

/**
 * Called to determine a player's default sprint speed.
 *
 * @param client			Client index.
 * @param defaultFloat		The default sprint speed.
 * @return					If Plugin_Changed, defaultFloat is used as player's default sprint speed.
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
 * @param addAmount			The amount of queue points to give.
 * @return					If Plugin_Changed, addAmount will be used as the amount to give.
 */
forward Action SF2_OnGroupGiveQueuePoints(int groupIndex, int &addAmount);

/**
 * Called when a player gets damaged by the boss.
 *
 * @param client		The player who got damaged.
 * @param bossIndex		Boss that damaged the player.
 * @param inflictor		The inflictor of the damage.
 * @param damage		The amount of damage taken.
 * @param damageType	The damage type.
 */
forward void SF2_OnClientDamagedByBoss(int client, int bossIndex, int inflictor, float damage, int damageType);

/**
 * Called when a player spawns as a proxy.
 *
 * @param client	The player who spawned as a proxy
 */
forward void SF2_OnClientSpawnedAsProxy(int client);

/**
 * Called when a player enters a PvP arena
 *
 * @param client	The player who entered the PvP arena
 */
forward void SF2_OnClientEnterPvP(int client);

/**
 * Called when a player exits a PvP arena
 *
 * @param client	The player who exits the PvP arena
 */
forward void SF2_OnClientExitPvP(int client);

/**
 * Called when a player enters a PvE arena
 *
 * @param client	The player who entered the PvE arena
 */
forward void SF2_OnClientEnterPvE(int client);

/**
 * Called when a player exits a PvE arena
 *
 * @param client	The player who exits the PvE arena
 */
forward void SF2_OnClientExitPvE(int client);

/**
 * Called whenever the Renevant gamemode triggers a new wave.
 *
 * @param wave		The wave number that got triggered.
 * @param condition	The wave condition used.
 */
forward void SF2_OnRenevantWaveTrigger(int wave, RenevantWave condition);

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
 * @return			If Plugin_Handled, player is blocked from playing.
 */
forward Action SF2_OnClientEnterGame(int client);

/**
 * Called when a player is choosen to play
 *
 * @param groupIndex	Group index.
 * @return				If Plugin_Handled, group is blocked from playing.
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
forward Action SF2_OnIsBossCustomAttackPossible(SF2_ChaserBossEntity chaser, const char[] attackName, SF2_ChaserBossProfileBaseAttack data, CBaseEntity target);

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
forward Action SF2_OnBossGetCustomAttackAction(SF2_ChaserBossEntity chaser, const char[] attackName, SF2_ChaserBossProfileBaseAttack data, CBaseEntity target, NextBotAction &action);

/**
 * Called when a projectile from SF2 has touched another entity successfully and has either exploded or dealt damage.
 *
 * @param projectile		Projectile entity
 * @param other				Entity the projectile touched
 */
forward void SF2_OnProjectileTouch(SF2_Projectile_Base projectile, CBaseEntity other);

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
 * Retrieves name of the current boss pack
 *
 * @param buffer			Buffer to store the pack name.
 * @param bufferLen		Max length of buffer.
 *
 * @return				Number of bytes copied
 */
native int SF2_GetCurrentBossPack(char[] buffer, int bufferLen);

/**
 * Returns the current group a player is in.
 *
 * @param client	Client index.
 * @return			Group index the player is in, -1 otherwise.
 */
native int SF2_GetClientGroup(int client);

/**
 * Returns the amount of a queue points a player has.
 *
 * @param client	Client index.
 * @return			Amount of queue points.
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

#if defined _tf2_included
/**
 * Returns whether or not the client is in a specific condition for SF2.
 *
 * @param client		Client index.
 * @param condition		Condition to check.
 * @return				True if the player is in a condition, false if not.
 */
native bool SF2_IsClientInCondition(int client, TFCond condition);
#endif

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
 * @param bossIndex		Boss index.
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
 * @param bossIndex		Boss index.
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
 * @param interval		Interval to subtract one Control point from the client.
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
 * @param bossIndex		Boss index.
 * @param teleportPos	Position to return
 * @param spawnPoint	Spawn point to return, defaults to -1.
 */
native bool SF2_ClientSpawnProxy(int client, int bossIndex, float teleportPos[3], int &spawnPoint = -1);

/**
 * Spawns a player as a proxy at a given position or spawn point.
 *
 * @param client		Client index.
 * @param bossIndex		Boss index.
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
 * @param bossIndex		Boss index.
 * @return				Entity index, or -1 if the boss has not spawned.
 */
native int SF2_BossIndexToEntIndex(int bossIndex);

/**
 * Returns the entity index of a boss using NPCGetEntIndex() rather than EntRefToEntIndex().
 *
 * @param bossIndex		Boss index.
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
 * @return				Unique ID.
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
native int SF2_AddBoss(const char[] profile, int flags = 0, bool spawnCompanions = true, bool playSpawnSound = true);

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
 * @param bossIndex			Boss index.
 * @param buffer			Buffer to store the profile name.
 * @param bufferLen			Max length of buffer.
 */
native void SF2_GetBossName(int bossIndex, char[] buffer, int bufferLen);

/**
 * Returns the type of the boss. See the SF2BossType enumeration for possible values.
 *
 * @param bossIndex			Boss index.
 * @return					Entity index.
 */
native int SF2_GetBossType(int bossIndex);

/**
 * Returns the flags of the boss.
 *
 * @param bossIndex			Boss index.
 * @return					Flags.
 */
native int SF2_GetBossFlags(int bossIndex);

/**
 * Sets the flags of the boss.
 *
 * @param bossIndex			Boss index.
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
 * @param bossIndex			Boss index.
 * @return					Entity index.
 */
native int SF2_GetBossModelEntity(int bossIndex);

/**
 * Returns the boss's current target.
 *
 * @param bossIndex			Boss index.
 * @return					Entity index.
 */
native int SF2_GetBossTarget(int bossIndex);

/**
 * If the boss is in a chase state, sets the target for the boss.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex			Boss index.
 * @param client			The new target.
 */
native void SF2_SetBossTarget(int bossIndex, int client);

#if defined _CBASENPC_EXTENSION_INC_
/**
 * Returns the boss's default path follower.
 *
 * @param bossIndex			Boss index.
 * @return					Path Follower.
 */
native PathFollower SF2_GetBossPathFollower(int bossIndex);
#endif

/**
 * If the boss is a copy, this returns the boss that this copy is associated with.
 *
 * @param bossIndex			Boss index.
 * @return					Boss index of master boss.
 */
native int SF2_GetBossMaster(int bossIndex);

/**
 * Returns the boss's idle lifetime.
 *
 * @param bossIndex			Boss index.
 * @param difficulty		The difficulty index.
 * @return					The boss's default idle lifetime
 */
native float SF2_GetBossIdleLifetime(int bossIndex, int difficulty);

/**
 * Returns the boss's current state.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex			Boss index.
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
 * @param bossIndex			Boss index.
 * @param eyePos			Buffer to store result.
 */
native void SF2_GetBossEyePosition(int bossIndex, float eyePos[3]);

/**
 * Returns the boss's eye position offset. This is a local offset vector.
 *
 * @param bossIndex			Boss index.
 * @param eyePosOffset		Buffer to store result.
 */
native void SF2_GetBossEyePositionOffset(int bossIndex, float eyePosOffset[3]);

#pragma deprecated Use SF2_ChaserBossProfile instead.
native bool SF2_IsBossStunnable(int bossIndex);

#pragma deprecated Use SF2_ChaserBossProfile instead.
native bool SF2_IsBossStunnableByFlashlight(int bossIndex);

/**
 * Returns whether or not the boss is cloaked.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex			Boss index.
 * @return					True if cloaked, false otherwise.
 */
native bool SF2_IsBossCloaked(int bossIndex);

/**
 * Returns the amount of health the boss has before stun.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex			Boss index.
 * @return					The health amount.
 */
native float SF2_GetBossStunHealth(int bossIndex);

/**
 * Sets the amount of health the boss has before stun.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex			Boss index.
 * @param health			The health amount.
 */
native void SF2_SetBossStunHealth(int bossIndex, float health);

/**
 * Gets the current goal position of the boss.
 *
 * Only used with Chaser bosses.
 *
 * @param bossIndex			Boss index.
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

#pragma deprecated Use SF2_BaseBossProfile instead.
native int SF2_GetBossProfileNum(const char[] profile, const char[] key, int defaultValue = 0);

#pragma deprecated Use SF2_BaseBossProfile instead.
native float SF2_GetBossProfileFloat(const char[] profile, const char[] key, float defaultValue = 0.0);

#pragma deprecated Use SF2_BaseBossProfile instead.
native bool SF2_GetBossProfileString(const char[] profile, const char[] key, char[] buffer, int bufferLen, const char[] defaultValue = "");

#pragma deprecated Use SF2_BaseBossProfile instead.
native bool SF2_GetBossProfileVector(const char[] profile, const char[] key, float buffer[3], const float defaultValue[3] = NULL_VECTOR);

#pragma deprecated Use SF2_ChaserBossProfileBaseAttack instead.
native int SF2_GetBossAttackProfileNum(const char[] profile, const char[] key, int defaultValue = 0, const int attackIndex);

#pragma deprecated Use SF2_ChaserBossProfileBaseAttack instead.
native float SF2_GetBossAttackProfileFloat(const char[] profile, const char[] key, float defaultValue = 0.0, const int attackIndex);

#pragma deprecated Use SF2_ChaserBossProfileBaseAttack instead.
native bool SF2_GetBossAttackProfileString(const char[] profile, const char[] key, char[] buffer, int bufferLen, const char[] defaultValue = "", const int attackIndex);

#pragma deprecated Use SF2_ChaserBossProfileBaseAttack instead.
native bool SF2_GetBossAttackProfileVector(const char[] profile, const char[] key, float buffer[3], const float defaultValue[3] = NULL_VECTOR, const int attackIndex);

#pragma deprecated Use SF2_BaseBossProfile instead.
native bool SF2_GetRandomStringFromBossProfile(const char[] profile, const char[] key, char[] buffer, int bufferLen, int index = -1);

#pragma deprecated Use SF2_BaseBossProfile instead.
native bool SF2_GetBossAttributeName(int bossIndex, int attribute);

#pragma deprecated Use SF2_BaseBossProfile instead.
native float SF2_GetBossAttributeValue(int bossIndex, int attribute);

#pragma deprecated Use SF2_ChaserBossEntity.AttackIndex instead.
native int SF2_GetBossCurrentAttackIndex(int bossIndex);

#pragma deprecated Use SF2_ChaserBossProfileBaseAttack instead.
native int SF2_GetBossAttackIndexType(int bossIndex, int attackIndex);

#pragma deprecated This no longer does anything.
native float SF2_GetBossTimeUntilNoPersistence(int bossIndex);

#pragma deprecated This no longer does anything.
native void SF2_SetBossTimeUntilNoPersistence(int bossIndex, float time);

#pragma deprecated Use SF2_BaseBossEntity.CurrentChaseDuration instead.
native float SF2_GetBossTimeUntilAlert(int bossIndex);

#pragma deprecated Use SF2_BaseBossEntity.CurrentChaseDuration instead.
native void SF2_SetBossTimeUntilAlert(int bossIndex, float time);

#pragma deprecated Use SF2_ChaserBossEntity.PerformVoice instead.
native void SF2_PerformBossVoice(int bossIndex, const int attackIndex = -1, int soundType = -1);

#pragma deprecated Use SF2_ChaserBossEntity.CreateSoundHint instead.
native void SF2_CreateBossSoundHint(int bossIndex, SoundType soundType, const float position[3], int difficulty);

#pragma deprecated Use SF2_ChaserBossProfileBaseAttack instead.
native float SF2_GetBossAttackIndexDamage(int bossIndex, int attackIndex, int difficulty);

#pragma deprecated Use SF2_ChaserBossProfileBaseAttack instead.
native int SF2_GetBossAttackIndexDamageType(int bossIndex, int attackIndex);

#pragma deprecated Use SF2_BaseBossEntity.ResetProfileAnimation instead.
native void SF2_UpdateBossAnimation(int bossIndex, int ent, int state, bool spawn = false);

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
 * @param bossIndex		Boss index.
 * @param difficulty	The difficulty index.
 * @return				Teleport entity index.
*/
native int SF2_GetBossTeleportTarget(int bossIndex);

/**
 * Spawns boss effects based on the list of effects used.
 * Note this will not spawn the extra effects like the festive lights and the disco ball
 * Only use this best for spawning in temporary effects.
 *
 * @param effects			The effects section to use
 * @param bossIndex			Boss to use
 * @param overridePos		Override the spawn position of the effects
 * @param overrideAng		Override the spawn angles of the effects
 * @param output			The ArrayList that will contain all of the outputted entities as entity references
 * @param entityOverride	If not INVALID_ENT_REFERENCE will attach all particles to the desired entity
 */
native void SF2_SpawnBossEffects(SF2_ProfileEffectMaster effects, int bossIndex, float overridePos[3] = NULL_VECTOR, float overrideAng[3] = NULL_VECTOR, ArrayList &output = null, int entityOverride = INVALID_ENT_REFERENCE);

/**
 * Returns if a boss can be seen by any player
 *
 * @param bossIndex			Boss to use
 * @param checkFOV			Use player FOV to check if the boss can be seen
 * @param checkBlink		Use player blink to check if the boss can be seen
 * @param checkEliminated	Include/exclude eliminated players
 */
native bool SF2_CanBossBeSeen(int bossIndex, bool checkFOV = true, bool checkBlink = false, bool checkEliminated = true);

/**
 *	Translates an activity name string into an Activity.
 *
 *	@param activity
 *	@return					Activity, or ACT_INVALID if not found.
 */
native Activity SF2_TranslateProfileActivityFromName(const char[] activity);

/**
 *	Given an activity or sequence, translates into a sequence index.
 *
 *	@param entity			Entity index
 *	@param animation		Activity/sequence string
 *	@return					Sequence index, or -1 if not found.
 */
native int SF2_LookupProfileAnimation(int entity, const char[] animation);

/**
 * Returns the profile data found on a boss index
 *
 * @param bossIndex		Boss index.
 * @return				Stored profile data, or null if it doesn't exist
 */
native SF2_BaseBossProfile SF2_GetProfileFromBossIndex(int bossIndex);

/**
 * Returns the chaser profile data found on a boss index.
 *
 * @param bossIndex		Boss index.
 * @return				Stored profile data, or null if it doesn't exist
 */
native SF2_ChaserBossProfile SF2_GetChaserProfileFromBossIndex(int bossIndex);

/**
 * Returns the statue profile data found on a boss index.
 *
 * @param bossIndex		Boss index.
 * @return				Stored profile data, or null if it doesn't exist
 */
native SF2_StatueBossProfile SF2_GetStatueProfileFromBossIndex(int bossIndex);

/**
 * Returns the profile data found from a profile name
 *
 * @param profile		Profile name.
 * @return				Stored profile data, or null if it doesn't exist
 */
native SF2_BaseBossProfile SF2_GetProfileFromName(const char[] profile);

/**
 * Returns the chaser profile data found from a profile name.
 *
 * @param profile		Profile name.
 * @return				Stored profile data, or null if it doesn't exist
 */
native SF2_ChaserBossProfile SF2_GetChaserProfileFromName(const char[] profile);

/**
 * Returns the statue profile data found from a profile name.
 *
 * @param profile		Profile name.
 * @return				Stored profile data, or null if it doesn't exist
 */
native SF2_StatueBossProfile SF2_GetStatueProfileFromName(const char[] profile);

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
	 *	Gets the controller methodmap that owns this entity.
	 */
	property SF2_BaseBossController ControllerEx
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
	 * Determines if the boss is currently in a public death cam.
	 */
	property bool IsKillingSomeone
	{
		public native get();
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
	 * Prevents any animation from being played
	 */
	property bool LockAnimations
	{
		public native get();
		public native set(bool value);
	}

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
	 * @return		Stored profile data, or null if it doesn't exist
	 */
	public native SF2_BaseBossProfile ProfileData();

	/**
	 * Plays an animation on the boss from a specific animation section, even custom ones. Note this is limited to the main "animations" section.
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
	 *	Gets the controller methodmap that owns this entity.
	 */
	property SF2_StatueBossController Controller
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
	 * @return		Stored profile data, or null if it doesn't exist
	 */
	public native SF2_StatueBossProfile ProfileData();

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
	 *	Gets the controller methodmap that owns this entity.
	 */
	property SF2_ChaserBossController Controller
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
	 * @return		Stored profile data, or null if it doesn't exist
	 */
	public native SF2_ChaserBossProfile ProfileData();

	/**
	 * Forces the boss to perform a voice. Note custom sound sections will not work.
	 *
	 * @param soundType		Sound type.
	 * @param attackName	Optional attack name to search for.
	 * @return				Whether or not the boss performed a voice.
	 */
	public native bool PerformVoice(int soundType = -1, const char[] attackName = "");

	/**
	 * Forces the boss to perform a voice using a custom sound section.
	 *
	 * @param soundInfo		Sound data to use.
	 * @return				Whether or not the boss performed a voice.
	 */
	public native bool PerformCustomVoice(SF2_ProfileSound soundInfo);

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
	 *	@param buffer			Posture to set to
	 *	@param updateAnimations	Optional bool to determine if the animations should update upon setting the posture.
	 *	@return					True if successful, false otherwise
	 */
	public native bool SetDefaultPosture(const char[] buffer, bool updateAnimations = true);

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
	public native void DropItem(bool death = false);

	/**
	 * Forces a boss to be alert at a specific position.
	 *
	 * @param position		Position the boss should be alerted to.
	 */
	public native void CreateSoundHint(float position[3]);

	/**
	 *	Enables/Disables the ability for bosses to utilize their ground movement as their speed.
	 *	Only use this for situations where the boss does not constantly path towards someone.
	 */
	property bool GroundSpeedOverride
	{
		public native get();
		public native set(bool value);
	}

	/**
	 * Sets/returns the boss's current movement type
	 */
	property SF2NPCMoveTypes MovementType
	{
		public native get();
		public native set(SF2NPCMoveTypes value);
	}

	/**
	 * Prevents the plugin from setting the MovementType
	 * Note that any attempts to set MovementType via a sub plugin will work as normal
	 */
	property bool LockMovementType
	{
		public native get();
		public native set(bool value);
	}

	/**
	 * Checks if an attack is possible the default way
	 * This only includes FOV and range checks
	 * Difficulty checks and health checks are not included by default
	 * Note that cooldown checks are already handled in SF2_ChaserEntity.GetAttackAction
	 * And visibility checks are already handled in SF2_ChaserAttackLayerAction
	 * You would use this primarily in SF2_OnIsBossCustomAttackPossible
	 *
	 * @param attack			Attack data to use
	 * @param includeDifficulties	Whether or not to include the difficulty checks
	 * @param includeHealth			Whether or not to include target health checks
	 * @return						Whether or not the attack is possible with the distance and FOV checks
	 */
	public bool IsAttackPossibleDefault(SF2_ChaserBossProfileBaseAttack attackData, bool includeDifficulties = false, bool includeHealth = false)
	{
		if (!this.Target.IsValid())
		{
			return false;
		}

		SF2_ChaserBossController controller = this.Controller;
		int difficulty = controller.Difficulty;

		INextBot bot = this.MyNextBotPointer();
		float eyePos[3], targetPos[3], direction[3], eyeAng[3];
		this.GetAbsAngles(eyeAng);
		SF2_GetBossEyePosition(controller.Index, eyePos);
		this.Target.GetAbsOrigin(targetPos);
		SubtractVectors(targetPos, eyePos, direction);
		GetVectorAngles(direction, direction);
		direction[2] = 180.0;

		float distance = bot.GetRangeSquaredTo(this.Target.index);
		float fov = FloatAbs(AngleDiff(direction[1], eyeAng[1]));

		if (distance > Pow(attackData.GetBeginRange(difficulty), 2.0))
		{
			return false;
		}

		if (fov > attackData.GetBeginFOV(difficulty))
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
			if (attackData.CanUseOnHealth(difficulty) != -1.0 && health < attackData.CanUseOnHealth(difficulty))
			{
				return false;
			}

			if (attackData.CanBlockOnHealth(difficulty) != -1.0 && health >= attackData.CanBlockOnHealth(difficulty))
			{
				return false;
			}
		}
		return true;
	}
}

/**
 * An object that contains data from a profile.
 */
methodmap SF2_ProfileObject < Handle
{
	/**
	 * Retrieve the parent section of this object.
	 */
	property SF2_ProfileObject Parent
	{
		public native get();
	}

	/**
	 * Retrieve the number of keys (not sections) that exist in this object.
	 */
	property int KeyLength
	{
		public native get();
	}

	/**
	 * Retrieve the number of sections (not keys) that exist in this object.
	 */
	property int SectionLength
	{
		public native get();
	}

	/**
	 * Retrieves the object's name
	 *
	 * @param buffer			String buffer
	 * @param bufferSize		Size of string buffer
	 */
	public native void GetSectionName(char[] buffer, int bufferSize);

	/**
	 * Retrieves a key's name from a specified index.
	 *
	 * @param index				Index to use
	 * @param buffer			String buffer
	 * @param bufferSize		Size of string buffer
	 * @return					True on success, false otherwise
	 */
	public native bool GetKeyNameFromIndex(int index, char[] buffer, int bufferSize);

	/**
	 * Retrieves a section's name from a specified index.
	 *
	 * @param index				Index to use
	 * @param buffer			String buffer
	 * @param bufferSize		Size of string buffer
	 * @return					True on success, false otherwise
	 */
	public native bool GetSectionNameFromIndex(int index, char[] buffer, int bufferSize);

	/**
	 * Retrieves an integer value from the given key.
	 *
	 * @param key				Key name
	 * @param defaultValue		Value to return as a fallback
	 * @return					Value stored at key
	 */
	public native int GetInt(const char[] key, int defaultValue = 0);

	/**
	 * Sets an integer value with the given key.
	 *
	 * @param key				Key name
	 * @param value				Value to set
	 */
	public native void SetInt(const char[] key, int value);

	/**
	 * Retrieves a boolean value from the given key.
	 *
	 * @param key              Key name
	 * @param defaultValue     Value to return as a fallback
	 * @return                 Value stored at key
	 */
	public native bool GetBool(const char[] key, bool defaultValue = false);

	/**
	 * Sets an boolean value with the given key.
	 *
	 * @param key				Key name
	 * @param value				Value to set
	 */
	public native void SetBool(const char[] key, bool value);

	/**
	 * Retrieves a float value from the given key.
	 *
	 * @param key              Key name
	 * @param defaultValue     Value to return as a fallback
	 * @return                 Value stored at key
	 */
	public native float GetFloat(const char[] key, float defaultValue = 0.0);

	/**
	 * Sets an bool value with the given key.
	 *
	 * @param key				Key name
	 * @param value				Value to set
	 */
	public native void SetFloat(const char[] key, float value);

	/**
	 * Retrieves a section from the given key.
	 *
	 * @param key              Key name
	 * @param defaultValue     Value to return as a fallback
	 * @return                 Value stored at key
	 */
	public native SF2_ProfileObject GetSection(const char[] key, SF2_ProfileObject defaultValue = view_as<SF2_ProfileObject>(INVALID_HANDLE));

	/**
	 * Retrieves an array from the given key.
	 *
	 * @param key              Key name
	 * @param defaultValue     Value to return as a fallback
	 * @return                 Value stored at key
	 */
	public native SF2_ProfileArray GetArray(const char[] key, SF2_ProfileArray defaultValue = view_as<SF2_ProfileArray>(INVALID_HANDLE));

	/**
	 * Retrieves a string value from the given key.
	 *
	 * @param key              Key name
	 * @param buffer           String buffer
	 * @param bufferSize       Size of string buffer
	 * @param defaultValue     Value to return as a fallback
	 * @return                 Number of chars copied to buffer, excluding null terminator
	 */
	public native void GetString(const char[] key, char[] buffer, int bufferSize, const char[] defaultValue = "");

	/**
	 * Sets an string value with the given key.
	 *
	 * @param key				Key name
	 * @param value				Value to set
	 */
	public native void SetString(const char[] key, const char[] value);

	/**
	 * Retrieves a Vector value from the given key.
	 *
	 * @param key              Key name
	 * @param buffer           Vector buffer
	 * @param defaultValue     Value to return as a fallback
	 */
	public native void GetVector(const char[] key, float buffer[3], const float defaultValue[3] = { 0.0, 0.0, 0.0 });

	/**
	 * Sets an Vector value with the given key.
	 *
	 * @param key				Key name
	 * @param value				Value to set
	 */
	public native void SetVector(const char[] key, float value[3]);

	/**
	 * Retrieves a Color value from the given key.
	 *
	 * @param key              Key name
	 * @param buffer           Color buffer
	 * @param defaultValue     Value to return as a fallback
	 */
	public native void GetColor(const char[] key, int buffer[4], const int defaultValue[4] = { 0, 0, 0, 0 });

	/**
	 * Sets an Color value with the given key.
	 *
	 * @param key				Key name
	 * @param value				Value to set
	 */
	public native void SetColor(const char[] key, int value[4]);

	/**
	 * Retrieves an integer value from the given difficulty key.
	 *
	 * @param key              Key name
	 * @param difficulty       Difficulty value
	 * @param defaultValue     Value to return as a fallback
	 * @return                 Value stored at key
	 */
	public native int GetDifficultyInt(const char[] key, int difficulty, int defaultValue = 0);

	/**
	 * Sets an integer value with the given difficulty key.
	 *
	 * @param key				Key name
	 * @param difficulty		Difficulty value
	 * @param value				Value to set
	 */
	public native void SetDifficultyInt(const char[] key, int difficulty, int value);

	/**
	 * Retrieves a boolean value from the given difficulty key.
	 *
	 * @param key              Key name
	 * @param difficulty       Difficulty value
	 * @param defaultValue     Value to return as a fallback
	 * @return                 Value stored at key
	 */
	public native bool GetDifficultyBool(const char[] key, int difficulty, bool defaultValue = false);

	/**
	 * Sets an boolean value with the given difficulty key.
	 *
	 * @param key				Key name
	 * @param difficulty		Difficulty value
	 * @param value				Value to set
	 */
	public native void SetDifficultyBool(const char[] key, int difficulty, bool value);

	/**
	 * Retrieves a float value from the given difficulty key.
	 *
	 * @param key              Key name
	 * @param difficulty       Difficulty value
	 * @param defaultValue     Value to return as a fallback
	 * @return                 Value stored at key
	 */
	public native float GetDifficultyFloat(const char[] key, int difficulty, float defaultValue = 0.0);

	/**
	 * Sets an float value with the given difficulty key.
	 *
	 * @param key				Key name
	 * @param difficulty		Difficulty value
	 * @param value				Value to set
	 */
	public native void SetDifficultyFloat(const char[] key, int difficulty, int value);

	/**
	 * Retrieves a section from the given difficulty key.
	 *
	 * @param key              Key name
	 * @param difficulty       Difficulty value
	 * @param defaultValue     Value to return as a fallback
	 * @return                 Value stored at key
	 */
	public native SF2_ProfileObject GetDifficultySection(const char[] key, int difficulty, SF2_ProfileObject defaultValue = view_as<SF2_ProfileObject>(INVALID_HANDLE));

	/**
	 * Retrieves a string value from the given difficulty key.
	 *
	 * @param key              Key name
	 * @param difficulty       Difficulty value
	 * @param buffer           String buffer
	 * @param bufferSize       Size of string buffer
	 * @param defaultValue     Value to return as a fallback
	 */
	public native void GetDifficultyString(const char[] key, int difficulty, char[] buffer, int bufferSize, const char[] defaultValue = "");

	/**
	 * Sets an string value with the given difficulty key.
	 *
	 * @param key				Key name
	 * @param difficulty		Difficulty value
	 * @param value				Value to set
	 */
	public native void SetDifficultyString(const char[] key, int difficulty, const char[] value);

	/**
	 * Retrieves a Vector value from the given difficulty key.
	 *
	 * @param key              Key name
	 * @param difficulty       Difficulty value
	 * @param buffer           Float buffer
	 * @param defaultValue     Value to return as a fallback
	 */
	public native void GetDifficultyVector(const char[] key, int difficulty, float buffer[3], const float defaultValue[3] = { 0.0, 0.0, 0.0 });

	/**
	 * Sets an Vector value with the given difficulty key.
	 *
	 * @param key				Key name
	 * @param difficulty		Difficulty value
	 * @param value				Value to set
	 */
	public native void SetDifficultyVector(const char[] key, int difficulty, float value[3]);

	/**
	 * Retrieves a Color value from the given difficulty key.
	 *
	 * @param key              Key name
	 * @param difficulty       Difficulty value
	 * @param buffer           Float buffer
	 * @param defaultValue     Value to return as a fallback
	 */
	public native void GetDifficultyColor(const char[] key, int difficulty, int buffer[4], const int defaultValue[4] = { 0, 0, 0, 0 });

	/**
	 * Sets an Color value with the given difficulty key.
	 *
	 * @param key				Key name
	 * @param difficulty		Difficulty value
	 * @param value				Value to set
	 */
	public native void SetDifficultyColor(const char[] key, int difficulty, int value[4]);

	/**
	 * Helper function that converts a string index map to a string array.
	 *
	 * @param key     Key name
	 */
	public native void ConvertValuesSectionToArray(const char[] key);

	/**
	 * Helper function that converts an object index map to a string array.
	 *
	 * @param key     Key name
	 */
	public native void ConvertSectionsSectionToArray(const char[] key);
}

methodmap SF2_ProfileArray < Handle
{
	/**
	 * Retrieve the size of the array.
	 */
	property int Length
	{
		public native get();
	}

	/**
	 * Retrieves an integer value from the given key.
	 *
	 * @param index            Index number
	 * @param defaultValue     Value to return as a fallback
	 * @return                 Value stored at key
	 */
	public native int GetInt(int index, int defaultValue = 0);

	/**
	 * Retrieves a boolean value from the given key.
	 *
	 * @param index            Index number
	 * @param defaultValue     Value to return as a fallback
	 * @return                 Value stored at key
	 */
	public native bool GetBool(int index, bool defaultValue = false);

	/**
	 * Retrieves a float value from the given key.
	 *
	 * @param index            Index number
	 * @param defaultValue     Value to return as a fallback
	 * @return                 Value stored at key
	 */
	public native float GetFloat(int index, float defaultValue = 0.0);

	/**
	 * Retrieves a section from the given key.
	 *
	 * @param index            Index number
	 * @param defaultValue     Value to return as a fallback
	 * @return                 Value stored at key
	 */
	public native SF2_ProfileObject GetSection(int index, SF2_ProfileObject defaultValue = view_as<SF2_ProfileObject>(INVALID_HANDLE));

	/**
	 * Retrieves a string value from the given key.
	 *
	 * @param index            Index number
	 * @param buffer           String buffer
	 * @param bufferSize       Size of string buffer
	 * @param defaultValue     Value to return as a fallback
	 */
	public native void GetString(int index, char[] buffer, int bufferSize, const char[] defaultValue = "");
}

/**
 * Profile object that stores sound data of an animation.
 */
methodmap SF2_ProfileSound < SF2_ProfileObject
{
	/**
	 * Returns the sound paths this object uses.
	 */
	property SF2_ProfileArray Paths
	{
		public native get();
	}

	/**
	 * Sets the default channel value of this sound object.
	 *
	 * @param channel	Sound channel
	 */
	public native void SetDefaultChannel(int channel);

	/**
	 * Sets the default level value of this sound object.
	 *
	 * @param level		Sound level
	 */
	public native void SetDefaultLevel(int level);

	/**
	 * Sets the default flags value of this sound object.
	 *
	 * @param flags		Sound flags
	 */
	public native void SetDefaultFlags(int flags);

	/**
	 * Sets the default minimum cooldown value of this sound object.
	 *
	 * @param cooldown		Sound cooldown
	 */
	public native void SetDefaultCooldownMin(float cooldown);

	/**
	 * Sets the default maximum cooldown value of this sound object.
	 *
	 * @param cooldown		Sound cooldown
	 */
	public native void SetDefaultCooldownMax(float cooldown);

	/**
	 * Gets the channel.
	 *
	 * @param difficulty     Difficulty value
	 * @return               Sound channel
	 */
	public native int GetChannel(int difficulty);

	/**
	 * Gets the volume.
	 *
	 * @param difficulty     Difficulty value
	 * @return               Sound volume
	 */
	public native float GetVolume(int difficulty);

	/**
	 * Gets the flags.
	 *
	 * @param difficulty     Difficulty value
	 * @return               Sound flags
	 */
	public native int GetFlags(int difficulty);

	/**
	 * Gets the level.
	 *
	 * @param difficulty     Difficulty value
	 * @return               Sound level
	 */
	public native int GetLevel(int difficulty);

	/**
	 * Gets the pitch.
	 *
	 * @param difficulty     Difficulty value
	 * @return               Sound pitch
	 */
	public native int GetPitch(int difficulty);

	/**
	 * Gets the minimum cooldown.
	 *
	 * @param difficulty     Difficulty value
	 * @return               Sound min cooldown
	 */
	public native float GetCooldownMin(int difficulty);

	/**
	 * Gets the maximum cooldown.
	 *
	 * @param difficulty     Difficulty value
	 * @return               Sound max cooldown
	 */
	public native float GetCooldownMax(int difficulty);

	/**
	 * Precaches all sounds and adds to downloads.
	 */
	public native void Precache();

	/**
	 * Helper function that calls EmitSoundToAll with the parameters given by this
	 * object.
	 *
	 * @param entIndex       Entity index to emit sound from
	 * @param difficulty     Difficulty value
	 */
	public native void EmitToAll(int entIndex = SOUND_FROM_PLAYER, int difficulty = Difficulty_Normal);

	/**
	 * Helper function that calls EmitSoundToClient with the parameters given by this
	 * object.
	 *
	 * @param client         Client index
	 * @param entIndex       Entity index to emit sound from
	 * @param difficulty     Difficulty value
	 */
	public native void EmitToClient(int client, int entIndex = SOUND_FROM_PLAYER, int difficulty = Difficulty_Normal);

	/**
	 * Stops all sounds in this section from playing.
	 *
	 * @param entity		Entity index to stop the sounds from
	 */
	public native void StopAllSounds(int entity);
}

/**
 * Profile object that stores data of an animation.
 * Note this covers 1 animation index, not the whole animations section or an animation named section like "idle".
 * Use this over SF2_ProfileMasterAnimation if you're for sure you're gonna only use 1 animation only.
 */
methodmap SF2_ProfileAnimation < SF2_ProfileObject
{
	/**
	 * Retrieves a sequence or activity name.
	 *
	 * @param difficulty     Difficulty value
	 * @param buffer         String buffer to store the animation name
	 * @param bufferSize     Size of buffer
	 */
	public native void GetAnimationName(int difficulty, char[] buffer, int bufferSize);

	/**
	 * Retrieves a gesture sequence or activity name.
	 *
	 * @param difficulty     Difficulty value
	 * @param buffer         String buffer to store the gesture name
	 * @param bufferSize     Size of buffer
	 */
	public native void GetGestureName(int difficulty, char[] buffer, int bufferSize);

	/**
	 * Gets the playback rate of the animation.
	 *
	 * @param difficulty     Difficulty value
	 * @return               Playback rate
	 */
	public native float GetAnimationPlaybackRate(int difficulty);

	/**
	 * Gets the playback rate of the gesture.
	 *
	 * @param difficulty     Difficulty value
	 * @return               Playback rate
	 */
	public native float GetGesturePlaybackRate(int difficulty);

	/**
	 * Gets the duration of the animation.
	 *
	 * @param difficulty     Difficulty value
	 * @return               Duration
	 */
	public native float GetDuration(int difficulty);

	/**
	 * Gets the starting cycle value of the animation.
	 *
	 * @param difficulty     Difficulty value
	 * @return               Cycle
	 */
	public native float GetAnimationCycle(int difficulty);

	/**
	 * Gets the starting cycle value of the gesture.
	 *
	 * @param difficulty     Difficulty value
	 * @return               Cycle
	 */
	public native float GetGestureCycle(int difficulty);

	/**
	 * Plays an animation on the entity using the parameters provided by the object.
	 *
	 * @param entIndex       Entity index to play on
	 * @param difficulty     Difficulty value
	 * @param loops          Whether the animation should loop or not
	 * @return               True if successful, false otherwise.
	 */
	public native bool PlayAnimation(int entIndex, int difficulty, bool loops = false);

	/**
	 * Plays an gesture/layered animation on the entity using the parameters provided by the object.
	 *
	 * @note                 Layered animations can only be used on entities derived from CBaseAnimatingOverlay.
	 * @param entIndex       Entity index to play on
	 * @param difficulty     Difficulty value
	 * @param loops          Whether the animation should loop or not
	 * @param layer          Value to store the layer ID of the animation.
	 * @return               True if successful, false otherwise.
	 */
	public native bool PlayGesture(int entIndex, int difficulty, bool loops = false, int& layer = -1);
}

/**
 * Profile object that stores all animation sections
 * Note this covers the "animations" section.
 */
methodmap SF2_ProfileMasterAnimation < SF2_ProfileObject
{
	/**
	 * Returns if an animation section exists
	 *
	 * @param animType			Animation section to search for
	 */
	public native bool HasAnimationSection(const char[] animType);

	/**
	 * Returns an animation index section based off of the given animation section name
	 *
	 * @param animType			Animation section to search for
	 * @param preDefinedIndex	If greater than -1 will pick a specified animation in the animation section based off the order in the config
	 * @param preDefinedName	If not an empty string will pick a specified animation in the animation section based off the animation section name
	 * @param index				Value to store the animation index in.
	 * @return					Animation indexed section or null if the section does not exist
	 */
	public native SF2_ProfileAnimation GetAnimation(const char[] animType, int preDefinedIndex = -1, const char[] preDefinedName = "", int& index = -1);
}

/**
 * A section that defines the properties of an entity or other special effect.
 */
methodmap SF2_ProfileEffect < SF2_ProfileObject
{
	/**
	 * The effect type.
	 */
	property EffectType Type
	{
		public native get();
	}

	/**
	 * Precaches all assets and adds them to the downloads.
	 */
	public native void Precache();
}

/**
 * A section that contains `SF2_ProfileEffect` objects meant to be spawned
 * together.
 */
methodmap SF2_ProfileEffectMaster < SF2_ProfileObject
{
	/**
	 * Precaches all assets and adds them to the downloads.
	 */
	public native void Precache();

	/**
	 * Spawns boss effects based on the list of effects used.
	 * Note this will not spawn the extra effects like the festive lights and the disco ball
	 * Only use this best for spawning in temporary effects.
	 *
	 * @param bossIndex			Boss to use
	 * @param overridePos		Override the spawn position of the effects
	 * @param overrideAng		Override the spawn angles of the effects
	 * @param output			The ArrayList that will contain all of the outputted entities as entity references
	 * @param entityOverride	If not INVALID_ENT_REFERENCE will attach all particles to the desired entity
	 */
	public native void Spawn(int bossIndex, float overridePos[3] = NULL_VECTOR, float overrideAng[3] = NULL_VECTOR, ArrayList &output = null, int entityOverride = INVALID_ENT_REFERENCE);
}

methodmap SF2_BaseBossProfile < SF2_ProfileObject
{
	/**
	 * The boss type.
	 */
	property int Type
	{
		public native get();
	}

	/**
	 * Determines if the boss is for the PvE arenas.
	 */
	property bool IsPvEBoss
	{
		public native get();
	}
}

methodmap SF2_StatueBossProfile < SF2_BaseBossProfile
{

}

methodmap SF2_ChaserBossProfile < SF2_BaseBossProfile
{
	/**
	 * Gets the amount of attacks stored in the Chaser boss profile.
	 *
	 * @return         Amount of attacks
	 * @error          Profile data is null or is not a Chaser boss profile
	 */
	public native int GetAttackCount();

	/**
	 * Gets a Chaser boss profile's attack data with the given name.
	 *
	 * @param name     Attack name
	 * @return         The attack data, or null if it doesn't exist
	 * @error          Profile data is null or is not a Chaser boss profile
	 */
	public native SF2_ChaserBossProfileBaseAttack GetAttack(const char[] name);

	/**
	 * Gets a Chaser boss profile's attack data with the given index.
	 *
	 * @param index     Attack index
	 * @return          The attack data, or null if it doesn't exist
	 * @error           Profile data is null or is not a Chaser boss profile
	 */
	public native SF2_ChaserBossProfileBaseAttack GetAttackFromIndex(int index);
}

methodmap SF2_ChaserBossProfileBaseAttack < SF2_ProfileObject
{
	/**
	 * The type of the attack.
	 */
	property int Type
	{
		public native get();
	}

	/**
	 * How long to wait after starting the attack to damage targets.
	 *
	 * @param difficulty     Difficulty value
	 * @return               Time to delay
	 */
	public native float GetDamageDelay(int difficulty);

	/**
	 * The range of the attack, in Hammer units.
	 *
	 * @param difficulty     Difficulty value
	 * @return               Range of attack
	 */
	public native float GetRange(int difficulty);

	/**
	 * How much damage to inflict to players.
	 *
	 * @param difficulty     Difficulty value
	 * @return               Damage of attack
	 */
	public native float GetDamage(int difficulty);

	/**
	 * The bitflag type value of the damage.
	 *
	 * @param difficulty     Difficulty value
	 * @return               Bitflags
	 */
	public native int GetDamageType(int difficulty);

	/**
	 * How much damage force to inflict to players.
	 *
	 * @param difficulty     Difficulty value
	 * @return               Damage force of attack
	 */
	public native float GetDamageForce(int difficulty);

	/**
	 * How much viewpunch to inflict on players that get hit by the attack.
	 *
	 * @param difficulty     Difficulty value
	 * @param viewPunch      Vector buffer to store punch angles
	 */
	public native void GetViewPunchAngles(int difficulty, float viewPunch[3]);

	/**
	 * How long the attack should last.
	 *
	 * @param difficulty     Difficulty value
	 * @return               Time
	 */
	public native float GetDuration(int difficulty);

	/**
	 * How wide the attack is, in degrees.
	 *
	 * @param difficulty     Difficulty value
	 * @return               FOV of attack
	 */
	public native float GetFOV(int difficulty);

	/**
	 * The maximum distance where the boss should use the attack.
	 *
	 * @param difficulty     Difficulty value
	 * @return               Range of atack
	 */
	public native float GetBeginRange(int difficulty);

	/**
	 * How much the player must be within this FOV should the boss use the attack.
	 *
	 * @param difficulty     Difficulty value
	 * @return               FOV of attack
	 */
	public native float GetBeginFOV(int difficulty);

	/**
	 * How long to wait until the boss can use this attack again.
	 *
	 * @param difficulty     Difficulty value
	 * @return               Cooldown of attack
	 */
	public native float GetCooldown(int difficulty);

	/**
	 * Determines what the minimum difficulty must be for this attack to be used on
	 * Anything lower than this threshold blocks the attack.
	 */
	property int UseOnDifficulty
	{
		public native get();
	}

	/**
	 * Determines what the maximum difficulty must not be for this attack to be used
	 * Anything higher than this threshold blocks the attack.
	 */
	property int BlockOnDifficulty
	{
		public native get();
	}

	/**
	 * Determines how much health the target must have at maximum for this attack to be used.
	 * Anything higher than this threshold blocks the attack.
	 *
	 * @param difficulty		Difficulty value
	 * @return					Maximum health threshold
	 */
	public native float CanUseOnHealth(int difficulty);

	/**
	 * Determines how much health the target must have at minimum for this attack to be used.
	 * Anything lower than this threshold blocks the attack.
	 *
	 * @param difficulty		Difficulty value
	 * @return					Minimum health threshold
	 */
	public native float CanBlockOnHealth(int difficulty);

	/**
	 * The animation's event index that'll be used for an attack to fire.
	 *
	 * @param difficulty		Difficulty value
	 * @return					Animation event index
	 */
	public native int GetEventNumber(int difficulty);
}

/**
 * The data of an attack with type `SF2BossAttackType_Custom`.
 */
methodmap SF2_ChaserBossProfileCustomAttack < SF2_ChaserBossProfileBaseAttack
{
	/**
	 * An identifier string of the custom attack.
	 *
	 * @param buffer         Buffer to store the string
	 * @param bufferSize     Size of buffer
	 */
	public native void GetSubType(char[] buffer, int bufferSize);

	/**
	 * Gets if the attack matches the given subtype string.
	 *
	 * @param subType     String to check
	 * @return            True if attack's subtype matches, false if not.
	 */
	public native bool IsSubType(const char[] subType);
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
 * Interface to SF2NPC_BaseNPC
 */
const SF2_BaseBossController SF2_INVALID_BASE_CONTROLLER = view_as<SF2_BaseBossController>(-1);
methodmap SF2_BaseBossController
{
	/**
	 *	Casts an boss index to this methodmap
	 *
	 *	@param index	Boss index to use
	 *	@return			Casted controller
	 */
	public SF2_BaseBossController(int index)
	{
		return view_as<SF2_BaseBossController>(index);
	}

	/**
	 * Returns if the boss controller is valid
	 */
	public native bool IsValid();

	/**
	 * Returns the boss index this controller is associated with
	 */
	property int Index
	{
		public native get();
	}

	/**
	 * Returns the boss's PathFollower variable
	 * Requires CBaseNPC to be included in the sub plugin
	 */
	#if defined _CBASENPC_EXTENSION_INC_
	property PathFollower Path
	{
		public native get();
	}
	#endif

	/**
	 * Returns the boss's unique ID
	 */
	property int UniqueID
	{
		public native get();
	}

	/**
	 * Returns a controller when given an unique ID
	 *
	 * @param uniqueID	Unique ID, cannot be negative
	 */
	public static native SF2_BaseBossController FromUniqueID(int uniqueID);

	/**
	 * Returns a controller when given an entity index
	 *
	 * @param entity	Entity index
	 */
	public static native SF2_BaseBossController FromEntity(int entity);

	/**
	 * Returns the boss's entity reference or INVALID_ENT_REFERENCE if the boss is not on the map
	 */
	property int EntRef
	{
		public native get();
	}

	/**
	 * Returns the boss's entity index
	 */
	property int EntIndex
	{
		public native get();
	}

	/**
	 * Returns the boss's profile data
	 */
	public native SF2_BaseBossProfile GetProfileData();

	/**
	 * Gets/Sets the current difficulty by default
	 * If the map is a boxing map or the boss is a PvE boss, this Gets/Sets the boss's local difficulty
	 */
	property int Difficulty
	{
		public native get();
		public native set(int value);
	}

	/**
	 * Gets/Sets the boss's flags
	 */
	property int Flags
	{
		public native get();
		public native set(int value);
	}

	/**
	 * Gets/Sets the boss's copy master
	 */
	property SF2_BaseBossController CopyMaster
	{
		public native get();
		public native set(SF2_BaseBossController value);
	}

	/**
	 * Returns if the boss is a copy or not
	 */
	property bool IsCopy
	{
		public native get();
	}

	/**
	 * Gets/Sets the boss's companion master
	 */
	property SF2_BaseBossController CompanionMaster
	{
		public native get();
		public native set(SF2_BaseBossController value);
	}

	/**
	 * Returns the boss's queued teleporter it should go to as an entity reference
	 * The max teleporters the boss can use is 5 defined by MAX_NPCTELEPORTER
	 *
	 * @param teleporterNumber	Index to search
	 */
	public native int GetTeleporter(int teleporterNumber);

	/**
	 * Sets the boss's queued teleporter via an entity reference
	 * Use INVALID_ENT_REFERENCE to clear a boss's queued teleporter
	 * The max teleporters the boss can use is 5 defined by MAX_NPCTELEPORTER
	 *
	 * @param teleporterNumber	Index to use
	 * @param ref				Teleporter entity reference
	 * @error					Entity is not a trigger_teleporter or INVALID_ENT_REFERENCE
	 */
	public native void SetTeleporter(int teleporterNumber, int ref);

	/**
	 * Spawns the boss on a set position
	 *
	 * @param pos	Position
	 */
	public native void Spawn(float pos[3]);

	/**
	 * Despawns the boss
	 *
	 * @param instant		Some bosses have despawn animation, this determines if the boss shouldn't use the despawn animations
	 */
	public native void UnSpawn(bool instant = false);

	/**
	 * Despawns the boss and removes it from the game
	 */
	public native void Remove();

	/**
	 * Returns if the boss is able to despawn
	 */
	property bool CanDespawn
	{
		public native get();
	}

	/**
	 * Marks the boss as a fake boss even if the boss is not a fake boss
	 */
	public native void MarkAsFake();

	/**
	 * Gets the boss's profile name
	 *
	 * @param buffer		Buffer to store the boss's profile name
	 * @param bufferLen		Maximum length of string buffer
	 */
	public native void GetProfile(char[] buffer, int bufferLen);

	/**
	 * Sets the boss's profile name
	 *
	 * @param profileName	New profile name
	 */
	public native void SetProfile(const char[] profileName);

	/**
	 * Returns the boss's current added run speed
	 */
	public native float GetAddSpeed();

	/**
	 * Returns the boss's current added run speed that doesn't reset when the boss despawn
	 */
	public native float GetPersistentAddSpeed();

	/**
	 * Adds onto the boss's current added run speed
	 *
	 * @param value		Value
	 */
	public native void SetAddSpeed(float value);

	/**
	 * Adds onto the boss's current added run speed that doesn't reset when the boss despawn
	 *
	 * @param value		Value
	 */
	public native void SetPersistentAddSpeed(float value);

	/**
	 * Returns the boss's current added walk speed that doesn't reset when the boss despawn
	 */
	public native float GetPersistentAddWalkSpeed();

	/**
	 * Adds onto the boss's current added walk speed that doesn't reset when the boss despawn
	 *
	 * @param value		Value
	 */
	public native void SetPersistentAddWalkSpeed(float value);

	/**
	 * Returns the boss's current added acceleration
	 */
	public native float GetAddAcceleration();

	/**
	 * Returns the boss's current added acceleration that doesn't reset when the boss despawn
	 */
	public native float GetPersistentAddAcceleration();

	/**
	 * Adds onto the boss's current added acceleration
	 *
	 * @param value		Value
	 */
	public native void SetAddAcceleration(float value);

	/**
	 * Adds onto the boss's current added acceleration that doesn't reset when the boss despawn
	 *
	 * @param value		Value
	 */
	public native void SetPersistentAddAcceleration(float value);

	/**
	 * Determines if any player can see the boss
	 *
	 * @param fov				Determines if player FOV should be considered
	 * @param blink				Determines if player blink states should be considered
	 * @param checkEliminated	Determines if eliminated players should be considered
	 */
	public native bool CanBeSeen(bool fov = true, bool blink = false, bool checkEliminated = true);

	/**
	 * Determines if a specified player can see the boss
	 *
	 * @param client			Client to check
	 * @param fov				Determines if player FOV should be considered
	 * @param blink				Determines if player blink states should be considered
	 * @param checkEliminated	Determines if eliminated players should be considered
	 */
	public native bool PlayerCanSee(int client, bool fov = true, bool blink = false, bool checkEliminated = false);

	/**
	 * Returns if the boss should force a player to start blinking when they look at this boss
	 */
	public native bool IsAffectedBySight();

	/**
	 * Sets if a player should start blinking when looking at this boss
	 *
	 * @param state		State
	 */
	public native void SetAffectedBySight(bool state);
}

/**
 * Interface to SF2NPC_Chaser
 */
const SF2_ChaserBossController SF2_INVALID_CHASER_CONTROLLER = view_as<SF2_ChaserBossController>(-1);
methodmap SF2_ChaserBossController < SF2_BaseBossController
{
	/**
	 *	Casts an boss index to this methodmap
	 *
	 *	@param index	Boss index to use
	 */
	public SF2_ChaserBossController(int index)
	{
		return view_as<SF2_ChaserBossController>(SF2_BaseBossController(index));
	}

	/**
	 * Returns the boss's profile data as an SF2_ChaserBossProfile
	 */
	public native SF2_ChaserBossProfile ProfileData();

	/**
	 * Returns the boss's current on spawned death health
	 *
	 * @param difficulty	Difficulty to check
	 */
	public native float GetDeathHealth(int difficulty);

	/**
	 * Sets the boss's current on spawned death health
	 *
	 * @param difficulty	Difficulty to check
	 */
	public native void SetDeathHealth(int difficulty, float amount);

	/**
	 * Returns the boss's current added stun health
	 */
	public native float GetAddStunHealth();

	/**
	 * Adds onto the boss's current added stun health
	 *
	 * @param value		Value
	 */
	public native void SetAddStunHealth(float value);

	/**
	 * Returns an ArrayList of targets that looked at the boss if it is meant to auto chase targets upon looking
	 */
	property ArrayList ChaseOnLookTargets
	{
		public native get();
	}
}

/**
 * Interface to SF2NPC_Statue
 */
const SF2_StatueBossController SF2_INVALID_STATUE_CONTROLLER = view_as<SF2_StatueBossController>(-1);
methodmap SF2_StatueBossController < SF2_BaseBossController
{
	/**
	 *	Casts an boss index to this methodmap
	 *
	 *	@param index	Boss index to use
	 */
	public SF2_StatueBossController(int index)
	{
		return view_as<SF2_StatueBossController>(SF2_BaseBossController(index));
	}

	/**
	 * Returns the boss's profile data as an SF2_StatueBossProfile
	 */
	public native SF2_StatueBossProfile ProfileData();
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
	 * Use this over IsClientInGame() as it has extra optimizations
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

	#if defined _tf2_included
	/**
	 * Alias of TF2_GetPlayerClass()
	 */
	property TFClassType Class
	{
		public native get();
	}
	#endif

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

	#if defined _tf2_included
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
	#endif

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

	#if defined _tf2_included
	/**
	 * Alias of TF2_SetPlayerClass()
	 *
	 * @param classType		New class
	 * @param weapons		Ignored/Unused
	 * @param persistent	Whether or not the class change should remain after death
	 */
	public native void SetClass(TFClassType classType, bool weapons = true, bool persistent = true);
	#endif

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
	 * Gets/Sets the player's stamina
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
	 * Whether or not the entity is actually a arrow
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
	 * Whether or not the entity is actually a baseball
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
	 * Whether or not the entity is actually a cow mangler projectile
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
	 * Whether or not the entity is actually a fireball
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
	 * Whether or not the entity is actually a grenade
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
	 * Whether or not the entity is actually a iceball
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
	 * Whether or not the entity is actually a rocket
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
	 * Whether or not the entity is actually a sentry rocket
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
 * Returns the array list of the current active bosses, this list only contains entity references.
 *
 * @return	List of active PvE bosses or null if no bosses are active.
 */
native ArrayList SF2_GetActivePvEBosses();

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

#if !defined REQUIRE_PLUGIN
public void __pl_sf2_SetNTVOptional()
{
	// sf2/methodmaps.sp
	MarkNativeAsOptional("SF2_BaseBossController.IsValid");
	MarkNativeAsOptional("SF2_BaseBossController.Index.get");
	MarkNativeAsOptional("SF2_BaseBossController.Path.get");
	MarkNativeAsOptional("SF2_BaseBossController.UniqueID.get");
	MarkNativeAsOptional("SF2_BaseBossController.FromUniqueID");
	MarkNativeAsOptional("SF2_BaseBossController.FromEntity");
	MarkNativeAsOptional("SF2_BaseBossController.EntRef.get");
	MarkNativeAsOptional("SF2_BaseBossController.EntIndex.get");
	MarkNativeAsOptional("SF2_BaseBossController.ProfileData");
	MarkNativeAsOptional("SF2_BaseBossController.Difficulty.get");
	MarkNativeAsOptional("SF2_BaseBossController.Difficulty.set");
	MarkNativeAsOptional("SF2_BaseBossController.Flags.get");
	MarkNativeAsOptional("SF2_BaseBossController.Flags.set");
	MarkNativeAsOptional("SF2_BaseBossController.CopyMaster.get");
	MarkNativeAsOptional("SF2_BaseBossController.CopyMaster.set");
	MarkNativeAsOptional("SF2_BaseBossController.IsCopy.get");
	MarkNativeAsOptional("SF2_BaseBossController.CompanionMaster.get");
	MarkNativeAsOptional("SF2_BaseBossController.CompanionMaster.set");
	MarkNativeAsOptional("SF2_BaseBossController.GetTeleporter");
	MarkNativeAsOptional("SF2_BaseBossController.SetTeleporter");
	MarkNativeAsOptional("SF2_BaseBossController.Spawn");
	MarkNativeAsOptional("SF2_BaseBossController.UnSpawn");
	MarkNativeAsOptional("SF2_BaseBossController.Remove");
	MarkNativeAsOptional("SF2_BaseBossController.CanDespawn.get");
	MarkNativeAsOptional("SF2_BaseBossController.MarkAsFake");
	MarkNativeAsOptional("SF2_BaseBossController.GetProfile");
	MarkNativeAsOptional("SF2_BaseBossController.SetProfile");
	MarkNativeAsOptional("SF2_BaseBossController.GetAddSpeed");
	MarkNativeAsOptional("SF2_BaseBossController.GetPersistentAddSpeed");
	MarkNativeAsOptional("SF2_BaseBossController.SetAddSpeed");
	MarkNativeAsOptional("SF2_BaseBossController.SetPersistentAddSpeed");
	MarkNativeAsOptional("SF2_BaseBossController.GetPersistentAddWalkSpeed");
	MarkNativeAsOptional("SF2_BaseBossController.SetPersistentAddWalkSpeed");
	MarkNativeAsOptional("SF2_BaseBossController.GetAddAcceleration");
	MarkNativeAsOptional("SF2_BaseBossController.GetPersistentAddAcceleration");
	MarkNativeAsOptional("SF2_BaseBossController.SetAddAcceleration");
	MarkNativeAsOptional("SF2_BaseBossController.SetPersistentAddAcceleration");
	MarkNativeAsOptional("SF2_BaseBossController.CanBeSeen");
	MarkNativeAsOptional("SF2_BaseBossController.PlayerCanSee");
	MarkNativeAsOptional("SF2_BaseBossController.IsAffectedBySight");
	MarkNativeAsOptional("SF2_BaseBossController.SetAffectedBySight");

	MarkNativeAsOptional("SF2_Player.UserID.get");
	MarkNativeAsOptional("SF2_Player.IsValid.get");
	MarkNativeAsOptional("SF2_Player.IsAlive.get");
	MarkNativeAsOptional("SF2_Player.IsInGame.get");
	MarkNativeAsOptional("SF2_Player.IsBot.get");
	MarkNativeAsOptional("SF2_Player.IsSourceTV.get");
	MarkNativeAsOptional("SF2_Player.IsReplay.get");
	MarkNativeAsOptional("SF2_Player.InThirdPerson.get");
	MarkNativeAsOptional("SF2_Player.Buttons.get");
	MarkNativeAsOptional("SF2_Player.IsMoving");
	MarkNativeAsOptional("SF2_Player.Health.get");
	MarkNativeAsOptional("SF2_Player.MaxHealth.get");
	MarkNativeAsOptional("SF2_Player.Ducking.get");
	MarkNativeAsOptional("SF2_Player.Ducked.get");
	MarkNativeAsOptional("SF2_Player.GetDataEnt");
	MarkNativeAsOptional("SF2_Player.Class.get");
	MarkNativeAsOptional("SF2_Player.Team.get");
	MarkNativeAsOptional("SF2_Player.HasRegenItem.get");
	MarkNativeAsOptional("SF2_Player.HasRegenItem.set");
	MarkNativeAsOptional("SF2_Player.InCondition");
	MarkNativeAsOptional("SF2_Player.ChangeCondition");
	MarkNativeAsOptional("SF2_Player.IsCritBoosted");
	MarkNativeAsOptional("SF2_Player.IsMiniCritBoosted");
	MarkNativeAsOptional("SF2_Player.Ignite");
	MarkNativeAsOptional("SF2_Player.Bleed");
	MarkNativeAsOptional("SF2_Player.Stun");
	MarkNativeAsOptional("SF2_Player.Regenerate");
	MarkNativeAsOptional("SF2_Player.SetClass");
	MarkNativeAsOptional("SF2_Player.GetEyePosition");
	MarkNativeAsOptional("SF2_Player.GetEyeAngles");
	MarkNativeAsOptional("SF2_Player.GetDataVector");
	MarkNativeAsOptional("SF2_Player.SetDataVector");
	MarkNativeAsOptional("SF2_Player.GetDistanceFromEntity");
	MarkNativeAsOptional("SF2_Player.GetWeaponSlot");
	MarkNativeAsOptional("SF2_Player.SwitchToWeaponSlot");
	MarkNativeAsOptional("SF2_Player.RemoveWeaponSlot");
	MarkNativeAsOptional("SF2_Player.ScreenShake");
	MarkNativeAsOptional("SF2_Player.ViewPunch");
	MarkNativeAsOptional("SF2_Player.TakeDamage");
	MarkNativeAsOptional("SF2_Player.Respawn");
	MarkNativeAsOptional("SF2_Player.UpdateListeningFlags");
	MarkNativeAsOptional("SF2_Player.IsParticipating.get");
	MarkNativeAsOptional("SF2_Player.GetName");
	MarkNativeAsOptional("SF2_Player.LastButtons.get");
	MarkNativeAsOptional("SF2_Player.LastButtons.set");
	MarkNativeAsOptional("SF2_Player.ScreenFade");
	MarkNativeAsOptional("SF2_Player.IsEliminated.get");
	MarkNativeAsOptional("SF2_Player.IsEliminated.set");
	MarkNativeAsOptional("SF2_Player.IsInGhostMode.get");
	MarkNativeAsOptional("SF2_Player.SetGhostState");
	MarkNativeAsOptional("SF2_Player.IsProxy.get");
	MarkNativeAsOptional("SF2_Player.IsProxy.set");
	MarkNativeAsOptional("SF2_Player.ProxyControl.get");
	MarkNativeAsOptional("SF2_Player.ProxyControl.set");
	MarkNativeAsOptional("SF2_Player.ProxyMaster.get");
	MarkNativeAsOptional("SF2_Player.ProxyMaster.set");
	MarkNativeAsOptional("SF2_Player.IsInPvP.get");
	MarkNativeAsOptional("SF2_Player.IsInPvE.get");
	MarkNativeAsOptional("SF2_Player.IsInDeathCam.get");
	MarkNativeAsOptional("SF2_Player.StartDeathCam");
	MarkNativeAsOptional("SF2_Player.HasEscaped.get");
	MarkNativeAsOptional("SF2_Player.Escape");
	MarkNativeAsOptional("SF2_Player.TeleportToEscapePoint");
	MarkNativeAsOptional("SF2_Player.ForceEscape");
	MarkNativeAsOptional("SF2_Player.UsingFlashlight.get");
	MarkNativeAsOptional("SF2_Player.HandleFlashlight");
	MarkNativeAsOptional("SF2_Player.FlashlightBatteryLife.get");
	MarkNativeAsOptional("SF2_Player.FlashlightBatteryLife.set");
	MarkNativeAsOptional("SF2_Player.ResetFlashlight");
	MarkNativeAsOptional("SF2_Player.GetFlashlightNextInputTime");
	MarkNativeAsOptional("SF2_Player.IsSprinting.get");
	MarkNativeAsOptional("SF2_Player.IsReallySprinting.get");
	MarkNativeAsOptional("SF2_Player.HandleSprint");
	MarkNativeAsOptional("SF2_Player.Stamina.get");
	MarkNativeAsOptional("SF2_Player.Stamina.set");
	MarkNativeAsOptional("SF2_Player.SetStaminaRechargeTime");
	MarkNativeAsOptional("SF2_Player.HasStartedBlinking.get");
	MarkNativeAsOptional("SF2_Player.IsBlinking.get");
	MarkNativeAsOptional("SF2_Player.IsHoldingBlink");
	MarkNativeAsOptional("SF2_Player.SetHoldingBlink");
	MarkNativeAsOptional("SF2_Player.BlinkMeter.get");
	MarkNativeAsOptional("SF2_Player.BlinkMeter.set");
	MarkNativeAsOptional("SF2_Player.BlinkCount.get");
	MarkNativeAsOptional("SF2_Player.Blink");
	MarkNativeAsOptional("SF2_Player.StartPeeking");
	MarkNativeAsOptional("SF2_Player.EndPeeking");
	MarkNativeAsOptional("SF2_Player.PageCount.get");
	MarkNativeAsOptional("SF2_Player.PageCount.set");
	MarkNativeAsOptional("SF2_Player.ShowHint");
	MarkNativeAsOptional("SF2_Player.IsTrapped.get");
	MarkNativeAsOptional("SF2_Player.IsTrapped.set");
	MarkNativeAsOptional("SF2_Player.TrapCount.get");
	MarkNativeAsOptional("SF2_Player.TrapCount.set");
	MarkNativeAsOptional("SF2_Player.IsLatched.get");
	MarkNativeAsOptional("SF2_Player.IsLatched.set");
	MarkNativeAsOptional("SF2_Player.LatchCount.get");
	MarkNativeAsOptional("SF2_Player.LatchCount.set");
	MarkNativeAsOptional("SF2_Player.Latcher.get");
	MarkNativeAsOptional("SF2_Player.Latcher.set");
	MarkNativeAsOptional("SF2_Player.HasConstantGlow.get");
	MarkNativeAsOptional("SF2_Player.SetPlayState");
	MarkNativeAsOptional("SF2_Player.CanSeeSlender");
	MarkNativeAsOptional("SF2_Player.SetAFKTime");
	MarkNativeAsOptional("SF2_Player.SetAFKState");
	MarkNativeAsOptional("SF2_Player.CheckAFKTime");
	MarkNativeAsOptional("SF2_Player.ShouldBeForceChased");
	MarkNativeAsOptional("SF2_Player.SetForceChaseState");
	MarkNativeAsOptional("SF2_Player.IsLookingAtBoss");

	MarkNativeAsOptional("SF2_ChaserBossController.ProfileData");
	MarkNativeAsOptional("SF2_ChaserBossController.GetDeathHealth");
	MarkNativeAsOptional("SF2_ChaserBossController.SetDeathHealth");
	MarkNativeAsOptional("SF2_ChaserBossController.GetAddStunHealth");
	MarkNativeAsOptional("SF2_ChaserBossController.SetAddStunHealth");
	MarkNativeAsOptional("SF2_ChaserBossController.ChaseOnLookTargets");

	MarkNativeAsOptional("SF2_StatueBossController.ProfileData");

	// sf2/npc.sp
	MarkNativeAsOptional("SF2_GetMaxBossCount");
	MarkNativeAsOptional("SF2_EntIndexToBossIndex");
	MarkNativeAsOptional("SF2_BossIndexToEntIndex");
	MarkNativeAsOptional("SF2_BossIndexToEntIndexEx");
	MarkNativeAsOptional("SF2_BossIDToBossIndex");
	MarkNativeAsOptional("SF2_BossIndexToBossID");

	MarkNativeAsOptional("SF2_AddBoss");
	MarkNativeAsOptional("SF2_RemoveBoss");

	MarkNativeAsOptional("SF2_GetBossName");
	MarkNativeAsOptional("SF2_GetBossType");

	MarkNativeAsOptional("SF2_GetBossFlags");
	MarkNativeAsOptional("SF2_SetBossFlags");

	MarkNativeAsOptional("SF2_SpawnBoss");
	MarkNativeAsOptional("SF2_IsBossSpawning");
	MarkNativeAsOptional("SF2_DespawnBoss");

	MarkNativeAsOptional("SF2_GetBossPathFollower");
	MarkNativeAsOptional("SF2_GetBossMaster");
	MarkNativeAsOptional("SF2_GetBossIdleLifetime");
	MarkNativeAsOptional("SF2_GetBossState");
	MarkNativeAsOptional("SF2_SetBossState");

	MarkNativeAsOptional("SF2_GetBossEyePosition");
	MarkNativeAsOptional("SF2_GetBossEyePositionOffset");

	MarkNativeAsOptional("SF2_GetBossTeleportThinkTimer");
	MarkNativeAsOptional("SF2_SetBossTeleportThinkTimer");
	MarkNativeAsOptional("SF2_GetBossTeleportTarget");

	MarkNativeAsOptional("SF2_GetBossGoalPosition");

	MarkNativeAsOptional("SF2_GetBossTimeUntilNoPersistence");
	MarkNativeAsOptional("SF2_SetBossTimeUntilNoPersistence");
	MarkNativeAsOptional("SF2_GetBossTimeUntilAlert");
	MarkNativeAsOptional("SF2_SetBossTimeUntilAlert");

	MarkNativeAsOptional("SF2_GetProfileFromBossIndex");
	MarkNativeAsOptional("SF2_GetProfileFromName");

	MarkNativeAsOptional("SF2_SpawnBossEffects");

	MarkNativeAsOptional("SF2_CanBossBeSeen");

	// sf2/profiles.sp
	MarkNativeAsOptional("SF2_IsBossProfileValid");
	MarkNativeAsOptional("SF2_GetBossProfileNum");
	MarkNativeAsOptional("SF2_GetBossProfileFloat");
	MarkNativeAsOptional("SF2_GetBossProfileString");
	MarkNativeAsOptional("SF2_GetBossProfileVector");
	MarkNativeAsOptional("SF2_GetBossAttackProfileNum");
	MarkNativeAsOptional("SF2_GetBossAttackProfileFloat");
	MarkNativeAsOptional("SF2_GetBossAttackProfileString");
	MarkNativeAsOptional("SF2_GetBossAttackProfileVector");
	MarkNativeAsOptional("SF2_GetRandomStringFromBossProfile");
	MarkNativeAsOptional("SF2_GetBossAttributeName");
	MarkNativeAsOptional("SF2_GetBossAttributeValue");

	MarkNativeAsOptional("SF2_TranslateProfileActivityFromName");
	MarkNativeAsOptional("SF2_LookupProfileAnimation");

	// sf2/pve.sp
	MarkNativeAsOptional("SF2_IsClientInPvE");
	MarkNativeAsOptional("SF2_RegisterPvEBoss");
	MarkNativeAsOptional("SF2_SetOverridePvEMusic");
	MarkNativeAsOptional("SF2_UnregisterPvEBoss");
	MarkNativeAsOptional("SF2_AddPvEBoss");
	MarkNativeAsOptional("SF2_KillPvEBoss");
	MarkNativeAsOptional("SF2_GetActivePvEBosses");

	// pvp.sp
	MarkNativeAsOptional("SF2_IsClientInPvP");

	// specialround.sp
	MarkNativeAsOptional("SF2_IsSpecialRoundRunning");
	MarkNativeAsOptional("SF2_GetSpecialRoundType");

	// client/sprint.sp
	MarkNativeAsOptional("SF2_GetClientSprintPoints");
	MarkNativeAsOptional("SF2_SetClientSprintPoints");

	MarkNativeAsOptional("SF2_IsClientSprinting");
	MarkNativeAsOptional("SF2_IsClientReallySprinting");
	MarkNativeAsOptional("SF2_SetClientSprintState");

	// entities/sf2_base_projectile.sp
	MarkNativeAsOptional("SF2_Projectile_Base.Initialize");
	MarkNativeAsOptional("SF2_Projectile_Base.DoExplosion");

	// entities/projectiles/sf2_arrow_projectile.sp
	MarkNativeAsOptional("SF2_Projectile_Arrow.Create");
	MarkNativeAsOptional("SF2_projectile_Arrow.IsValid.get");

	// entities/projectiles/sf2_baseball_projectile.sp
	MarkNativeAsOptional("SF2_Projectile_Baseball.Create");
	MarkNativeAsOptional("SF2_Projectile_Baseball.IsValid.get");

	// entities/projectiles/sf2_cow_mangler_projectile.sp
	MarkNativeAsOptional("SF2_Projectile_CowMangler.Create");
	MarkNativeAsOptional("SF2_Projectile_CowMangler.IsValid.get");

	// entities/projectiles/sf2_fireball_projectile.sp
	MarkNativeAsOptional("SF2_Projectile_Fireball.Create");
	MarkNativeAsOptional("SF2_Projectile_Fireball.IsValid.get");

	// entities/projectiles/sf2_grenade_projectile.sp
	MarkNativeAsOptional("SF2_Projectile_Grenade.Create");
	MarkNativeAsOptional("SF2_Projectile_Grenade.IsValid.get");

	// entities/projectiles/sf2_iceball_projectile.sp
	MarkNativeAsOptional("SF2_Projectile_Iceball.Create");
	MarkNativeAsOptional("SF2_Projectile_Iceball.IsValid.get");

	// entities/projectiles/sf2_rocket_projectile.sp
	MarkNativeAsOptional("SF2_Projectile_Rocket.Create");
	MarkNativeAsOptional("SF2_Projectile_Rocket.IsValid.get");

	// entities/projectiles/sf2_sentry_rocket_projectile.sp
	MarkNativeAsOptional("SF2_Projectile_SentryRocket.Create");
	MarkNativeAsOptional("SF2_Projectile_SentryRocket.IsValid.get");

	// extras/natives.sp
	MarkNativeAsOptional("SF2_IsRunning");
	MarkNativeAsOptional("SF2_GetRoundState");
	MarkNativeAsOptional("SF2_IsRoundInGracePeriod");
	MarkNativeAsOptional("SF2_GetCurrentDifficulty");
	MarkNativeAsOptional("SF2_GetBossDifficulty");
	MarkNativeAsOptional("SF2_GetDifficultyModifier");
	MarkNativeAsOptional("SF2_IsInSpecialRound");
	MarkNativeAsOptional("SF2_GetCurrentBossPack");

	MarkNativeAsOptional("SF2_GetClientGroup");
	MarkNativeAsOptional("SF2_GetClientQueuePoints");
	MarkNativeAsOptional("SF2_SetClientQueuePoints");

	MarkNativeAsOptional("SF2_IsValidClient");
	MarkNativeAsOptional("SF2_IsClientCritBoosted");
	MarkNativeAsOptional("SF2_IsClientMiniCritBoosted");
	MarkNativeAsOptional("SF2_IsClientUbercharged");
	MarkNativeAsOptional("SF2_IsClientInKart");
	MarkNativeAsOptional("SF2_IsClientInCondition");
	MarkNativeAsOptional("SF2_IsClientEliminated");
	MarkNativeAsOptional("SF2_IsClientInGhostMode");
	MarkNativeAsOptional("SF2_IsClientProxy");

	MarkNativeAsOptional("SF2_GetClientBlinkCount");
	MarkNativeAsOptional("SF2_IsClientBlinking");
	MarkNativeAsOptional("SF2_GetClientBlinkMeter");
	MarkNativeAsOptional("SF2_SetClientBlinkMeter");

	MarkNativeAsOptional("SF2_GetClientProxyMaster");
	MarkNativeAsOptional("SF2_GetClientProxyControlAmount");
	MarkNativeAsOptional("SF2_GetClientProxyControlRate");
	MarkNativeAsOptional("SF2_SetClientProxyMaster");
	MarkNativeAsOptional("SF2_SetClientProxyControlAmount");
	MarkNativeAsOptional("SF2_SetClientProxyControlRate");

	MarkNativeAsOptional("SF2_IsClientLookingAtBoss");
	MarkNativeAsOptional("SF2_DidClientEscape");
	MarkNativeAsOptional("SF2_ForceClientEscape");

	MarkNativeAsOptional("SF2_GetClientFlashlightBatteryLife");
	MarkNativeAsOptional("SF2_SetClientFlashlightBatteryLife");
	MarkNativeAsOptional("SF2_IsClientUsingFlashlight");

	MarkNativeAsOptional("SF2_IsClientTrapped");
	MarkNativeAsOptional("SF2_IsClientInDeathCam");
	MarkNativeAsOptional("SF2_ClientStartDeathCam");

	MarkNativeAsOptional("SF2_ClientSpawnProxy");
	MarkNativeAsOptional("SF2_ClientForceProxy");

	MarkNativeAsOptional("SF2_CollectAsPage");
	MarkNativeAsOptional("SF2_GetEmptyPageSpawnPoints");

	MarkNativeAsOptional("SF2_ForceBossJump");

	MarkNativeAsOptional("SF2_GetBossModelEntity");

	MarkNativeAsOptional("SF2_GetBossTarget");
	MarkNativeAsOptional("SF2_SetBossTarget");

	MarkNativeAsOptional("SF2_IsBossStunnable");
	MarkNativeAsOptional("SF2_IsBossStunnableByFlashlight");
	MarkNativeAsOptional("SF2_IsBossCloaked");
	MarkNativeAsOptional("SF2_GetBossStunHealth");
	MarkNativeAsOptional("SF2_SetBossStunHealth");

	MarkNativeAsOptional("SF2_GetVectorSquareMagnitude");
	MarkNativeAsOptional("SF2_InitiateBossPackVote");
	MarkNativeAsOptional("SF2_IsSurvivalMap");
	MarkNativeAsOptional("SF2_IsBoxingMap");
	MarkNativeAsOptional("SF2_IsRaidMap");
	MarkNativeAsOptional("SF2_IsProxyMap");
	MarkNativeAsOptional("SF2_IsSlaughterRunMap");

	// gamemodes/renevant.sp
	MarkNativeAsOptional("SF2_IsRenevantMap");

	// npc/npc_chaser.sp
	MarkNativeAsOptional("SF2_GetBossCurrentAttackIndex");
	MarkNativeAsOptional("SF2_GetBossAttackIndexType");
	MarkNativeAsOptional("SF2_GetBossAttackIndexDamage");
	MarkNativeAsOptional("SF2_UpdateBossAnimation");
	MarkNativeAsOptional("SF2_GetBossAttackIndexDamageType");

	MarkNativeAsOptional("SF2_PerformBossVoice");
	MarkNativeAsOptional("SF2_CreateBossSoundHint");

	MarkNativeAsOptional("SF2_GetChaserProfileFromBossIndex");
	MarkNativeAsOptional("SF2_GetChaserProfileFromName");
	MarkNativeAsOptional("SF2_SetEntityForceChaseState");

	// npc/npc_creeper.sp
	MarkNativeAsOptional("SF2_GetStatueProfileFromBossIndex");
	MarkNativeAsOptional("SF2_GetStatueProfileFromName");

	// npc/entities/base/entity.sp
	MarkNativeAsOptional("SF2_BaseBossEntity.IsValid.get");
	MarkNativeAsOptional("SF2_BaseBossEntity.Controller.get");
	MarkNativeAsOptional("SF2_BaseBossEntity.ControllerEx.get");
	MarkNativeAsOptional("SF2_BaseBossEntity.Target.get");
	MarkNativeAsOptional("SF2_BaseBossEntity.State.get");
	MarkNativeAsOptional("SF2_BaseBossEntity.CurrentChaseDuration.get");
	MarkNativeAsOptional("SF2_BaseBossEntity.CurrentChaseDuration.set");
	MarkNativeAsOptional("SF2_BaseBossEntity.InitialChaseDuration.get");
	MarkNativeAsOptional("SF2_BaseBossEntity.InitialChaseDuration.set");
	MarkNativeAsOptional("SF2_BaseBossEntity.IsKillingSomeone.get");
	MarkNativeAsOptional("SF2_BaseBossEntity.EyePosition");
	MarkNativeAsOptional("SF2_BaseBossEntity.GetProfileName");
	MarkNativeAsOptional("SF2_BaseBossEntity.GetName");
	MarkNativeAsOptional("SF2_BaseBossEntity.LockAnimations.get");
	MarkNativeAsOptional("SF2_BaseBossEntity.LockAnimations.set");
	MarkNativeAsOptional("SF2_BaseBossEntity.ProfileData");
	MarkNativeAsOptional("SF2_BaseBossEntity.ResetProfileAnimation");

	// npc/entities/base/actions/playsequenceandwait.sp
	MarkNativeAsOptional("SF2_PlaySequenceAndWaitAction.SF2_PlaySequenceAndWaitAction");

	// npc/entities/chaser/entity.sp
	MarkNativeAsOptional("SF2_ChaserBossEntity.IsValid.get");
	MarkNativeAsOptional("SF2_ChaserBossEntity.Controller.get");
	MarkNativeAsOptional("SF2_ChaserBossEntity.IsAttemptingToMove.get");
	MarkNativeAsOptional("SF2_ChaserBossEntity.IsAttacking.get");
	MarkNativeAsOptional("SF2_ChaserBossEntity.IsStunned.get");
	MarkNativeAsOptional("SF2_ChaserBossEntity.StunHealth.get");
	MarkNativeAsOptional("SF2_ChaserBossEntity.MaxStunHealth.get");
	MarkNativeAsOptional("SF2_ChaserBossEntity.CanBeStunned.get");
	MarkNativeAsOptional("SF2_ChaserBossEntity.CanTakeDamage.get");
	MarkNativeAsOptional("SF2_ChaserBossEntity.IsRaging.get");
	MarkNativeAsOptional("SF2_ChaserBossEntity.IsRunningAway.get");
	MarkNativeAsOptional("SF2_ChaserBossEntity.IsSelfHealing.get");
	MarkNativeAsOptional("SF2_ChaserBossEntity.ProfileData");
	MarkNativeAsOptional("SF2_ChaserBossEntity.PerformVoice");
	MarkNativeAsOptional("SF2_ChaserBossEntity.PerformCustomVoice");
	MarkNativeAsOptional("SF2_ChaserBossEntity.GetDefaultPosture");
	MarkNativeAsOptional("SF2_ChaserBossEntity.SetDefaultPosture");
	MarkNativeAsOptional("SF2_ChaserBossEntity.GetAttackName");
	MarkNativeAsOptional("SF2_ChaserBossEntity.AttackIndex.get");
	MarkNativeAsOptional("SF2_ChaserBossEntity.GetNextAttackTime");
	MarkNativeAsOptional("SF2_ChaserBossEntity.SetNextAttackTime");
	MarkNativeAsOptional("SF2_ChaserBossEntity.DropItem");
	MarkNativeAsOptional("SF2_ChaserBossEntity.CreateSoundHint");
	MarkNativeAsOptional("SF2_ChaserBossEntity.GroundSpeedOverride.get");
	MarkNativeAsOptional("SF2_ChaserBossEntity.GroundSpeedOverride.set");
	MarkNativeAsOptional("SF2_ChaserBossEntity.MovementType.get");
	MarkNativeAsOptional("SF2_ChaserBossEntity.MovementType.set");
	MarkNativeAsOptional("SF2_ChaserBossEntity.LockMovementType.get");
	MarkNativeAsOptional("SF2_ChaserBossEntity.LockMovementType.set");

	// npc/entities/statue/entity.sp
	MarkNativeAsOptional("SF2_StatueBossEntity.IsValid.get");
	MarkNativeAsOptional("SF2_StatueBossEntity.Controller.get");
	MarkNativeAsOptional("SF2_StatueBossEntity.IsMoving.get");
	MarkNativeAsOptional("SF2_StatueBossEntity.LastKillTime.get");
	MarkNativeAsOptional("SF2_StatueBossEntity.ProfileData");

	MarkNativeAsOptional("SF2_ProfileObject.Parent.get");
	MarkNativeAsOptional("SF2_ProfileObject.KeyLength.get");
	MarkNativeAsOptional("SF2_ProfileObject.SectionLength.get");
	MarkNativeAsOptional("SF2_ProfileObject.GetSectionName");
	MarkNativeAsOptional("SF2_ProfileObject.GetKeyNameFromIndex");
	MarkNativeAsOptional("SF2_ProfileObject.GetSectionNameFromIndex");
	MarkNativeAsOptional("SF2_ProfileObject.GetInt");
	MarkNativeAsOptional("SF2_ProfileObject.SetInt");
	MarkNativeAsOptional("SF2_ProfileObject.GetBool");
	MarkNativeAsOptional("SF2_ProfileObject.SetBool");
	MarkNativeAsOptional("SF2_ProfileObject.GetFloat");
	MarkNativeAsOptional("SF2_ProfileObject.SetFloat");
	MarkNativeAsOptional("SF2_ProfileObject.GetSection");
	MarkNativeAsOptional("SF2_ProfileObject.GetArray");
	MarkNativeAsOptional("SF2_ProfileObject.GetString");
	MarkNativeAsOptional("SF2_ProfileObject.SetString");
	MarkNativeAsOptional("SF2_ProfileObject.GetVector");
	MarkNativeAsOptional("SF2_ProfileObject.SetVector");
	MarkNativeAsOptional("SF2_ProfileObject.GetColor");
	MarkNativeAsOptional("SF2_ProfileObject.SetColor");
	MarkNativeAsOptional("SF2_ProfileObject.GetDifficultyInt");
	MarkNativeAsOptional("SF2_ProfileObject.SetDifficultyInt");
	MarkNativeAsOptional("SF2_ProfileObject.GetDifficultyBool");
	MarkNativeAsOptional("SF2_ProfileObject.SetDifficultyBool");
	MarkNativeAsOptional("SF2_ProfileObject.GetDifficultyFloat");
	MarkNativeAsOptional("SF2_ProfileObject.SetDifficultyFloat");
	MarkNativeAsOptional("SF2_ProfileObject.GetDifficultySection");
	MarkNativeAsOptional("SF2_ProfileObject.GetDifficultyString");
	MarkNativeAsOptional("SF2_ProfileObject.SetDifficultyString");
	MarkNativeAsOptional("SF2_ProfileObject.GetDifficultyVector");
	MarkNativeAsOptional("SF2_ProfileObject.SetDifficultyVector");
	MarkNativeAsOptional("SF2_ProfileObject.GetDifficultyColor");
	MarkNativeAsOptional("SF2_ProfileObject.SetDifficultyColor");
	MarkNativeAsOptional("SF2_ProfileObject.ConvertValuesSectionToArray");
	MarkNativeAsOptional("SF2_ProfileObject.ConvertSectionsSectionToArray");

	MarkNativeAsOptional("SF2_ProfileArray.Length.get");
	MarkNativeAsOptional("SF2_ProfileArray.GetInt");
	MarkNativeAsOptional("SF2_ProfileArray.GetBool");
	MarkNativeAsOptional("SF2_ProfileArray.GetFloat");
	MarkNativeAsOptional("SF2_ProfileArray.GetSection");
	MarkNativeAsOptional("SF2_ProfileArray.GetString");

	MarkNativeAsOptional("SF2_ProfileSound.Paths.get");
	MarkNativeAsOptional("SF2_ProfileSound.SetDefaultChannel");
	MarkNativeAsOptional("SF2_ProfileSound.SetDefaultLevel");
	MarkNativeAsOptional("SF2_ProfileSound.SetDefaultFlags");
	MarkNativeAsOptional("SF2_ProfileSound.SetDefaultCooldownMin");
	MarkNativeAsOptional("SF2_ProfileSound.SetDefaultCooldownMax");
	MarkNativeAsOptional("SF2_ProfileSound.GetChannel");
	MarkNativeAsOptional("SF2_ProfileSound.GetVolume");
	MarkNativeAsOptional("SF2_ProfileSound.GetFlags");
	MarkNativeAsOptional("SF2_ProfileSound.GetLevel");
	MarkNativeAsOptional("SF2_ProfileSound.GetPitch");
	MarkNativeAsOptional("SF2_ProfileSound.GetCooldownMin");
	MarkNativeAsOptional("SF2_ProfileSound.GetCooldownMax");
	MarkNativeAsOptional("SF2_ProfileSound.Precache");
	MarkNativeAsOptional("SF2_ProfileSound.EmitToAll");
	MarkNativeAsOptional("SF2_ProfileSound.EmitToClient");
	MarkNativeAsOptional("SF2_ProfileSound.StopAllSounds");

	MarkNativeAsOptional("SF2_ProfileAnimation.GetAnimationName");
	MarkNativeAsOptional("SF2_ProfileAnimation.GetGestureName");
	MarkNativeAsOptional("SF2_ProfileAnimation.GetAnimationPlaybackRate");
	MarkNativeAsOptional("SF2_ProfileAnimation.GetGesturePlaybackRate");
	MarkNativeAsOptional("SF2_ProfileAnimation.GetDuration");
	MarkNativeAsOptional("SF2_ProfileAnimation.GetAnimationCycle");
	MarkNativeAsOptional("SF2_ProfileAnimation.GetGestureCycle");
	MarkNativeAsOptional("SF2_ProfileAnimation.PlayAnimation");
	MarkNativeAsOptional("SF2_ProfileAnimation.PlayGesture");

	MarkNativeAsOptional("SF2_ProfileMasterAnimation.HasAnimationSection");
	MarkNativeAsOptional("SF2_ProfileMasterAnimation.GetAnimation");

	MarkNativeAsOptional("SF2_ProfileEffect.Type.get");
	MarkNativeAsOptional("SF2_ProfileEffect.Precache");

	MarkNativeAsOptional("SF2_ProfileEffectMaster.Precache");
	MarkNativeAsOptional("SF2_ProfileEffectMaster.Spawn");

	MarkNativeAsOptional("SF2_BaseBossProfile.Type.get");
	MarkNativeAsOptional("SF2_BaseBossProfile.IsPvEBoss.get");

	MarkNativeAsOptional("SF2_ChaserBossProfile.GetAttackCount");
	MarkNativeAsOptional("SF2_ChaserBossProfile.GetAttack");
	MarkNativeAsOptional("SF2_ChaserBossProfile.GetAttackFromIndex");

	MarkNativeAsOptional("SF2_ChaserBossProfileBaseAttack.Type.get");
	MarkNativeAsOptional("SF2_ChaserBossProfileBaseAttack.GetDamageDelay");
	MarkNativeAsOptional("SF2_ChaserBossProfileBaseAttack.GetRange");
	MarkNativeAsOptional("SF2_ChaserBossProfileBaseAttack.GetDamage");
	MarkNativeAsOptional("SF2_ChaserBossProfileBaseAttack.GetDamageType");
	MarkNativeAsOptional("SF2_ChaserBossProfileBaseAttack.GetDamageForce");
	MarkNativeAsOptional("SF2_ChaserBossProfileBaseAttack.GetViewPunchAngles");
	MarkNativeAsOptional("SF2_ChaserBossProfileBaseAttack.GetDuration");
	MarkNativeAsOptional("SF2_ChaserBossProfileBaseAttack.GetFOV");
	MarkNativeAsOptional("SF2_ChaserBossProfileBaseAttack.GetBeginRange");
	MarkNativeAsOptional("SF2_ChaserBossProfileBaseAttack.GetBeginFOV");
	MarkNativeAsOptional("SF2_ChaserBossProfileBaseAttack.GetCooldown");
	MarkNativeAsOptional("SF2_ChaserBossProfileBaseAttack.UseOnDifficulty.get");
	MarkNativeAsOptional("SF2_ChaserBossProfileBaseAttack.BlockOnDifficulty.get");
	MarkNativeAsOptional("SF2_ChaserBossProfileBaseAttack.CanUseOnHealth");
	MarkNativeAsOptional("SF2_ChaserBossProfileBaseAttack.CanBlockOnHealth");
	MarkNativeAsOptional("SF2_ChaserBossProfileBaseAttack.GetEventNumber");

	MarkNativeAsOptional("SF2_ChaserBossProfileCustomAttack.GetSubType");
	MarkNativeAsOptional("SF2_ChaserBossProfileCustomAttack.IsSubType");
}
#endif