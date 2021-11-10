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
#define MAX_TRAPS 64

// Difficulty modifiers.
#define DIFFICULTY_EASY 0.75
#define DIFFICULTY_NORMAL 1.0
#define DIFFICULTY_HARD 1.25
#define DIFFICULTY_INSANE 1.75
#define DIFFICULTY_NIGHTMARE 3.0
#define DIFFICULTY_APOLLYON 5.5
#define DIFFICULTY_RESTARTSESSION 14.0

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
	SPECIALROUND_CLASSSCRAMBLE,
	SPECIALROUND_2DOOM,
	SPECIALROUND_PAGEREWARDS,
	SPECIALROUND_TINYBOSSES,
	SPECIALROUND_RUNNINGINTHE90S,
	SPECIALROUND_TRIPLEBOSSES,
	SPECIALROUND_20DOLLARS,
	SPECIALROUND_MODBOSSES,
	SPECIALROUND_BOSSROULETTE,
	SPECIALROUND_THANATOPHOBIA,
	SPECIALROUND_DEBUGMODE,
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
	SoundType_Voice,
	SoundType_Weapon,
	SoundType_Flashlight,
	SoundType_NIL
};

enum
{
	Difficulty_Easy = 0,
	Difficulty_Normal,
	Difficulty_Hard,
	Difficulty_Insane,
	Difficulty_Nightmare,
	Difficulty_Apollyon,
	Difficulty_Unusued, //DO NOT TOUCH
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
#define SFF_WEAPONKILLS (1 << 16)
#define SFF_WEAPONKILLSONRADIUS (1 << 17)
#define SFF_RANDOMATTACKS (1 << 18)

// Interrup conditions.
#define COND_HEARDSUSPICIOUSSOUND (1 << 0)
#define COND_HEARDFOOTSTEP (1 << 1)
#define COND_HEARDFOOTSTEPLOUD (1 << 2)
#define COND_HEARDWEAPON (1 << 3)
#define COND_HEARDVOICE (1 << 4)
#define COND_CHASETARGETINVALIDATED (1 << 5)
#define COND_SAWENEMY (1 << 5)
#define COND_HEARDFLASHLIGHT (1 << 6)

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
 * Called when a boss is added into the game.
 *
 * @param iBossIndex	The index of the newly created boss.
 */
forward void SF2_OnBossAdded(int iBossIndex);

/**
 * Called when the boss spawns into the map.
 *
 * @param iBossIndex	Boss index.
 */
forward void SF2_OnBossSpawn(int iBossIndex);

/**
 * Called when the boss despawns from the map.
 *
 * @param iBossIndex	Boss index.
 */
forward void SF2_OnBossDespawn(int iBossIndex);

/**
 * Called when the boss changes states. Currently only used for Chaser bosses.
 *
 * @param iBossIndex	Boss index.
 * @param iOldState		The old state.
 * @param iNewState		The new state.
 */
forward void SF2_OnBossChangeState(int iBossIndex, int iOldState, int iNewState);

/**
 * Called when the boss updates its animation.
 *
 * @param iBossIndex	Boss index. 
 * @return				If Plugin_Handled, animation change will be blocked.
 */
forward Action SF2_OnBossAnimationUpdate(int iBossIndex);

/**
 * Called to determine the boss's run speed.
 *
 * @param iBossIndex	Boss index.
 * @param flSpeed		The boss's run speed.
 * @return				If Plugin_Changed, flSpeed is used as the boss's run speed.
 */
forward Action SF2_OnBossGetSpeed(int iBossIndex, float &flSpeed);

/**
 * Called to determine the boss's walk speed.
 *
 * @param iBossIndex	Boss index.
 * @param flSpeed		The boss's walk speed.
 * @return				If Plugin_Changed, flSpeed is used as the boss's walk speed.
 */
forward Action SF2_OnBossGetWalkSpeed(int iBossIndex, float &flWalkSpeed);

/**
 * Called after the boss has determined it can hear the entity.
 *
 * @param iBossIndex	Boss index.
 * @param entity		Entity index.
 * @return				Returning a value other than Plugin_Continue will block hearing to the entity.
 */
forward Action SF2_OnBossHearEntity(int iBossIndex, int entity);

/**
 * Called after the boss has determined it can see the entity.
 *
 * @param iBossIndex	Boss index.
 * @param entity		Entity index.
 * @return				Returning a value other than Plugin_Continue will block vision to the entity.
 */
forward Action SF2_OnBossSeeEntity(int iBossIndex, int entity);

/**
 * Called when a boss is removed from the game.
 *
 * @param iBossIndex	The index of the boss to be removed.
 */
forward void SF2_OnBossRemoved(int iBossIndex);

/**
 * Called when the boss gets stun by a player.
 *
 * @param iBossIndex	Boss index.
 * @param iClient		The client who stunned the boss, will return -1 if the stun was a flashlight stun.
 */
forward void SF2_OnBossStunned(int iBossIndex, int iClient);

/**
 * Called when pages have spawned into the map.
 */
forward void SF2_OnPagesSpawned();

/**
 * Called when the round state changes.
 * 
 * @param iOldState		Old state.
 * @param iNewState		New state.
 */
forward void SF2_OnRoundStateChange(SF2RoundState iOldState, SF2RoundState iNewState);

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
 * @param iBossIndex	Boss index.
 */
forward void SF2_OnClientScare(int client, int iBossIndex);

/**
 * Called when the player gets caught by a boss, either from too much static, being within
 * a boss's kill radius, or dies from too much camping. This is also called for fake bosses.
 *
 * @param client		Client index.
 * @param iBossIndex	Boss index.
 */
forward void SF2_OnClientCaughtByBoss(int client, int iBossIndex);

/**
 * Called when giving queue points to the player at the end of the round.
 *
 * @param client		Client index.
 * @param iAddAmount	The amount of queue points to give.
 * @return				If Plugin_Changed, iAddAmount will be used as the amount to give.
 */
forward Action SF2_OnClientGiveQueuePoints(int client, int &iAddAmount);

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
 * @param iBossIndex	Boss the client is looking at.
 */
forward void SF2_OnClientLooksAtBoss(int client, int iBossIndex);

/**
 * Called when the player looks away from the boss.
 *
 * @param client		Client index.
 * @param iBossIndex	Boss the client is no longer looking at.
 */
forward void SF2_OnClientLooksAwayFromBoss(int client, int iBossIndex);

/**
 * Called when the player gets caught in a boss's deathcam.
 *
 * @param client		Client index.
 * @param iBossIndex	Boss index.
 */
forward void SF2_OnClientStartDeathCam(int client, int iBossIndex);

/**
 * Called when the player gets exits a boss's deathcam.
 *
 * @param client		Client index.
 * @param iBossIndex	Boss index.
 */
forward void SF2_OnClientEndDeathCam(int client, int iBossIndex);

/**
 * Called to determine a player's default walk speed.
 *
 * @param client		Client index.
 * @param flDefault		The default walk speed.
 * @return				If Plugin_Changed, flDefault is used as player's default walk speed.
 */
forward Action SF2_OnClientGetDefaultWalkSpeed(int client, float &flDefault);

/**
 * Called to determine a player's default sprint speed.
 *
 * @param client		Client index.
 * @param flDefault		The default sprint speed.
 * @return				If Plugin_Changed, flDefault is used as player's default sprint speed.
 */
forward Action SF2_OnClientGetDefaultSprintSpeed(int client, float &flDefault);

/**
 * Called when a player gets damaged.
 *
 * @param victim		The player who got damaged.
 * @param attacker		The damage source.
 * @param damage		The amount of damage to take.
 * @return				If Plugin_Changed, damage is overrided.
 */
forward Action SF2_OnClientTakeDamage(int victim, int attacker, float &damage);

/**
 * Called when giving queue points to the group at the end of the round.
 *
 * @param iGroupIndex		Group index.
 * @param iAddAmount		The amount of queue points to give.
 * @return					If Plugin_Changed, iAddAmount will be used as the amount to give.
 */
forward Action SF2_OnGroupGiveQueuePoints(int iGroupIndex, int &iAddAmount);

/**
 * Called when a player gets damaged by the boss.
 *
 * @param client		The player who got damaged.
 * @param iBossIndex	Boss that damaged the player.
 * @param inflictor		The inflictor of the damage.
 * @param flDamage		The amount of damage taken.
 * @param iDamageType	The damage type.
 */
forward void SF2_OnClientDamagedByBoss(int client, int iBossIndex, int inflictor, float flDamage, int iDamageType);

/**
 * Called when a player spawns as a proxy.
 */
forward void SF2_OnClientSpawnedAsProxy(int client);

/**
 * Called whenever the Renevant gamemode triggers a new wave.
 */
forward void SF2_OnRenevantWaveTrigger(int iWave);

/**
 * Called whenever the boss pack vote starts
 */
forward void SF2_OnBossPackVoteStart();

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
 * @param iDifficulty	Difficulty number.
 * @return				Modifier float value of the indicated difficulty number.
 */
native float SF2_GetDifficultyModifier(int iDifficulty);

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
 * @param iBossIndex	Boss index.
 * @return				True if the player is looking at a boss, false if not.
 */
native bool SF2_IsClientLookingAtBoss(int client, int iBossIndex);

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
 * @param iBossIndex	Boss index.
 */
native void SF2_SetClientProxyMaster(int client, int iBossIndex);

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
 * @param iAmount		The amount of Control points. Must be between 0-100.
 */
native void SF2_SetClientProxyControlAmount(int client, int iAmount);

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
 * @param flInterval	Interval to subtract one Control point from the client.
 */
native float SF2_SetClientProxyControlRate(int client, float flInterval);

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
 * Returns whether or not a proxy can be spawned, returns a teleport position or spawn point if defined and the result is true, works well with SF2_ClientForceProxy.
 *
 * @param iClient		Client index.
 * @param iBossIndex	Boss index.
 * @param flTeleportPos	Position to return
 * @param iSpawnPoint	Spawn point to return, defaults to -1.
 */
native bool SF2_ClientSpawnProxy(int iClient, int iBossIndex, float flTeleportPos[3], int &iSpawnPoint = -1);

/**
 * Spawns a player as a proxy at a given position or spawn point.
 *
 * @param iClient		Client index.
 * @param iBossIndex	Boss index.
 * @param flTeleportPos	Position to return
 * @param iSpawnPoint	Spawn point to return, defaults to -1.
 */
native bool SF2_ClientForceProxy(int iClient, int iBossIndex, const float flTeleportPos[3], int iSpawnPoint);

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
 * @param iEntIndex		Entity index.
 * @return				Boss index, or -1 if entity index is not a boss.
 */
native int SF2_EntIndexToBossIndex(int iEntIndex);

/**
 * Returns the entity index of a boss using EntRefToEntIndex().
 *
 * @param iBossIndex	Boss index.
 * @return				Entity index, or -1 if the boss has not spawned.
 */
native int SF2_BossIndexToEntIndex(int iBossIndex);


/**
 * Returns the entity index of a boss using NPCGetEntIndex() rather than EntRefToEntIndex().
 *
 * @param iBossIndex	Boss index.
 * @return				Entity index, or -1 if the boss has not spawned.
 */
native int SF2_BossIndexToEntIndexEx(int iBossIndex);

/**
 * Converts a boss unique ID to a boss index.
 *
 * @param iBossID		Unique id.
 * @return				Boss index, or -1 if no boss has the unique id.
 */
native int SF2_BossIDToBossIndex(int iBossID);

/**
 * Returns the unique ID of a boss. A unique ID to a boss index is the equivalent of an entity reference to an entity index.
 *
 * @param iBossIndex		Boss index.
 * @return					Unique id.
 */
native int SF2_BossIndexToBossID(int iBossIndex);

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
 * @param iBossIndex	Boss index.
 */
native void SF2_RemoveBoss(int iBossIndex);

/**
 * Retrieves the profile name of the boss.
 *
 * @param iBossIndex		Boss index.
 * @param sBuffer			Buffer to store the profile name.
 * @param iBufferLen		Max length of sBuffer.
 */
native void SF2_GetBossName(int iBossIndex, char[] sBuffer, int iBufferLen);

/**
 * Returns the type of the boss. See the SF2BossType enumeration for possible values.
 *
 * @param iBossIndex		Boss index.
 * @return					Entity index.
 */
native int SF2_GetBossType(int iBossIndex);

/**
 * Returns the flags of the boss.
 *
 * @param iBossIndex		Boss index.
 * @return					Flags.
 */
native int SF2_GetBossFlags(int iBossIndex);

/**
 * Sets the flags of the boss.
 *
 * @param iBossIndex		Boss index.
 * @param flags				Flags.
 */
native void SF2_SetBossFlags(int iBossIndex, int flags);

/**
 * Spawns the boss into the map.
 *
 * @param iBossIndex		Boss index.
 */
native void SF2_SpawnBoss(int iBossIndex, const float position[3]);

/**
 * Despawns the boss from the map.
 *
 * @param iBossIndex		Boss index.
 */
native void SF2_DespawnBoss(int iBossIndex);

/**
 * Returns the entity index of the boss's model.
 *
 * @param iBossIndex		Boss index.
 * @return					Entity index.
 */
native int SF2_GetBossModelEntity(int iBossIndex);

/**
 * Returns the boss's current target.
 *
 * @param iBossIndex		Boss index.
 * @return					Entity index.
 */
native int SF2_GetBossTarget(int iBossIndex);

/**
 * If the boss is a copy, this returns the boss that this copy is associated with.
 *
 * @param iBossIndex		Boss index.
 * @return					Boss index of master boss.
 */
native int SF2_GetBossMaster(int iBossIndex);

/**
 * Returns the boss's current state.
 *
 * Only used with Chaser bosses.
 *
 * @param iBossIndex		Boss index.
 * @return					The boss's state.
 */
native int SF2_GetBossState(int iBossIndex);

/**
 * Returns the boss's eye position in the world. Used for visibility checks.
 *
 * @param iBossIndex		Boss index.
 * @param eyePos			Buffer to store result.
 */
native void SF2_GetBossEyePosition(int iBossIndex, float eyePos[3]);

/**
 * Returns the boss's eye position offset. This is a local offset vector.
 *
 * @param iBossIndex		Boss index.
 * @param eyePosOffset		Buffer to store result.
 */
native void SF2_GetBossEyePositionOffset(int iBossIndex, float eyePosOffset[3]);

/**
 * Returns the boss's field of view.
 *
 * @param iBossIndex		Boss index.
 * @return					Field of view.
 */
native float SF2_GetBossFOV(int iBossIndex);

/**
 * If the boss is in a chase state, returns the time which the boss's persistency on the target ends.
 * 
 * Only used with Chaser bosses.
 *
 * @param iBossIndex		Boss index.
 * @return					Time where persistency ends.
 */
native float SF2_GetBossTimeUntilNoPersistence(int iBossIndex);

/**
 * If the boss is in a chase state, sets the time which the boss's persistency on the target ends.
 * 
 * Only used with Chaser bosses.
 *
 * @param iBossIndex		Boss index.
 * @param time				Time where persistency ends.
 */
native void SF2_SetBossTimeUntilNoPersistence(int iBossIndex, float time);

/**
 * If the boss is in an alert state, returns the time which the boss should revert to idle state.
 * 
 * Only used with Chaser bosses.
 *
 * @param iBossIndex		Boss index.
 * @return					Time where chase state should revert to idle state.
 */
native float SF2_GetBossTimeUntilIdle(int iBossIndex);

/**
 * If the boss is in an alert state, sets the time which the boss should revert to idle state.
 * 
 * Only used with Chaser bosses.
 *
 * @param iBossIndex		Boss index.
 * @param time				Time where chase state should revert to idle state.
 */
native void SF2_SetBossTimeUntilIdle(int iBossIndex, float time);

/**
 * If the boss is in a chase state, returns the time which the boss should revert to alert state.
 * 
 * Only used with Chaser bosses.
 *
 * @param iBossIndex		Boss index.
 * @return					Time where chase state should revert to alert state.
 */
native float SF2_GetBossTimeUntilAlert(int iBossIndex);

/**
 * If the boss is in a chase state, sets the time which the boss should revert to alert state.
 * 
 * Only used with Chaser bosses.
 *
 * @param iBossIndex		Boss index.
 * @param time				Time where chase state should revert to alert state.
 */
native void SF2_SetBossTimeUntilAlert(int iBossIndex, float time);

/**
 * Returns whether or not the boss is stunnable.
 *
 * Only used with Chaser bosses.
 *
 * @param iBossIndex		Boss index.
 * @return					True if stunnable, false otherwise.
 */
native bool SF2_IsBossStunnable(int iBossIndex);

/**
 * Returns whether or not the boss is stunnable by flashlight.
 *
 * Only used with Chaser bosses.
 *
 * @param iBossIndex		Boss index.
 * @return					True if stunnable by flashlight, false otherwise.
 */
native bool SF2_IsBossStunnableByFlashlight(int iBossIndex);

/**
 * Returns whether or not the boss is cloaked.
 *
 * Only used with Chaser bosses.
 *
 * @param iBossIndex		Boss index.
 * @return					True if cloaked, false otherwise.
 */
native bool SF2_IsBossCloaked(int iBossIndex);

/**
 * Returns the amount of health the boss has before stun.
 *
 * Only used with Chaser bosses.
 *
 * @param iBossIndex		Boss index.
 * @return					The health amount.
 */
native float SF2_GetBossStunHealth(int iBossIndex);

/**
 * Sets the amount of health the boss has before stun.
 *
 * Only used with Chaser bosses.
 *
 * @param iBossIndex		Boss index.
 * @param health			The health amount.
 */
native void SF2_SetBossStunHealth(int iBossIndex, float health);

/**
 * Returns the time where the boss is not under stun cooldown.
 * 
 * Only used with Chaser bosses.
 *
 * @param iBossIndex		Boss index.
 * @return					Time when boss is not under stun cooldown.
 */
native float SF2_GetBossNextStunTime(int iBossIndex);

/**
 * Sets the time where the boss is not under stun cooldown.
 * 
 * Only used with Chaser bosses.
 *
 * @param iBossIndex		Boss index.
 * @param time				Time when boss is not under stun cooldown.
 */
native float SF2_SetBossNextStunTime(int iBossIndex, float time);

/**
 * Forces the boss to stop chasing.
 *
 * Only used with Chaser bosses.
 *
 * Note: If the boss is set to chase endlessly then this will not do anything.
 *
 * @param iBossIndex		Boss index.
 */
native void SF2_ForceBossGiveUp(int iBossIndex);

/**
 * Gets the current goal position of the boss.
 *
 * Only used with Chaser bosses.
 *
 * @param iBossIndex		Boss index.
 * @param position			Buffer to store position.
 */
native void SF2_GetBossGoalPosition(int iBossIndex, float position[3]);

/**
 * Returns whether or not the boss is able to hear the player given sound type.
 *
 * Only used with Chaser bosses.
 *
 * @param iBossIndex		Boss index.
 * @param client			Client index.
 * @param soundType			The type of sound to check.
 * @return					True if boss can hear, false otherwise.
 */
native bool SF2_CanBossHearClient(int iBossIndex, int client, SoundType soundType);

/**
 * Creates a sound hint for the boss to follow.
 *
 * Only used with Chaser bosses.
 *
 * @param iBossIndex		Boss index.
 * @param soundType			The type of sound hint to create.
 * @param position			The position of the sound.
 * @param iDifficulty		The difficulty.
 */
native void SF2_CreateBossSoundHint(int iBossIndex, SoundType soundType, const float position[3], int iDifficulty);

/**
 * Returns if the given profile is loaded or not.
 *
 * @param sProfile		Profile name.
 * @return				True if loaded, false otherwise.
 */
native bool SF2_IsBossProfileValid(const char[] sProfile);

/**
 * Retrieves an integer keyvalue from the profile.
 *
 * @param sProfile			Profile name.
 * @param sKey				Name of the key.
 * @param iDefaultValue		Fallback value.
 * @return					The value, or iDefaultValue if the key doesn't exist.
 */
native int SF2_GetBossProfileNum(const char[] sProfile, const char[] sKey, int iDefaultValue=0);

/**
 * Retrieves a float keyvalue from the profile.
 *
 * @param sProfile			Profile name.
 * @param sKey				Name of the key.
 * @param flDefaultValue	Fallback value.
 * @return					The value, or flDefaultValue if the key doesn't exist.
 */
native float SF2_GetBossProfileFloat(const char[] sProfile, const char[] sKey, float flDefaultValue=0.0);

/**
 * Retrieves a string keyvalue from the profile.
 *
 * @param sProfile			Profile name.
 * @param sKey				Name of the key.
 * @param sBuffer			Buffer to store the value.
 * @param iBufferLen		Max length of sBuffer.
 * @param sDefaultValue		Fallback value.
 * @return					True if key exists; false otherwise. If false, sBuffer is set to sDefaultValue.
 */
native bool SF2_GetBossProfileString(const char[] sProfile, const char[] sKey, char[] sBuffer, int iBufferLen, const char[] sDefaultValue="");

/**
 * Retrieves a vector keyvalue from the profile.
 *
 * @param sProfile			Profile name.
 * @param sKey				Name of the key.
 * @param flBuffer			Buffer to store the value.
 * @param flDefaultValue	Fallback value.
 * @return					True if key exists; false otherwise. If false, sBuffer is set to sDefaultValue.
 */
native bool SF2_GetBossProfileVector(const char[] sProfile, const char[] sKey, float flBuffer[3], const float flDefaultValue[3]=NULL_VECTOR);

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
 * This function will randomly choose a string value within "section" if sKey = "section".
 * 
 * @param sProfile			Profile name.
 * @param sKey				Name of the key. Must be a section.
 * @param sBuffer			Buffer to store the value.
 * @param iBufferLen		Max length of sBuffer.
 * @param iIndex			Mainly used for attack indexes, selects a random sound from an array that is iIndex.
 * @return					True if profile exists and key is set; false otherwise.
 */
native bool SF2_GetRandomStringFromBossProfile(const char[] sProfile, const char[] sKey, char[] sBuffer, int iBufferLen, int iIndex=-1);

/**
 * Returns an attribute name if one exists
 * @param iBossIndex	Boss index.
 * @param sAttribute	Name of attribute.
*/
native bool SF2_GetBossAttributeName(int iBossIndex, const char[] sAttribute);

/**
 * Returns the value of an attribute.
 * @param iBossIndex	Boss index.
 * @param sAttribute	Name of attribute.
 * @param flDefaultValue	Default value of attribute.
*/
native float SF2_GetBossAttributeValue(int iBossIndex, const char[] sAttribute, float flDefaultValue = 0.0);

/**
 * Returns the projectile type a boss uses.
 *
 * Only used with Chaser bosses.
 *
 * @param iBossIndex	Boss index.
*/
native int SF2_GetBossProjectileType(int iBossIndex);

/**
 * Returns the current attack index of the boss.
 *
 * Only used with Chaser bosses.
 *
 * @param iBossIndex	Boss index.
*/
native int SF2_GetBossCurrentAttackIndex(int iBossIndex);

/**
 * Returns the damage type of a set attack index.
 *
 * Only used with Chaser bosses.
 *
 * @param iBossIndex	Boss index.
 * @param iAttackIndex	Attack index.
*/
native int SF2_GetBossAttackIndexDamageType(int iBossIndex, int iAttackIndex);

/**
 * Returns the damage of a set attack index.
 *
 * Only used with Chaser bosses.
 *
 * @param iBossIndex	Boss index.
 * @param iAttackIndex	Attack index.
 * @param iDifficulty	The difficulty.
*/
native float SF2_GetBossAttackIndexDamage(int iBossIndex, int iAttackIndex, int iDifficulty);

/**
 * Returns the attack type of a set attack index.
 *
 * Only used with Chaser bosses.
 *
 * @param iBossIndex	Boss index.
 * @param iAttackIndex	Attack index.
*/
native int SF2_GetBossAttackIndexType(int iBossIndex, int iAttackIndex);

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
 * @param iInitiator	Whoever started the vote, keep above 33 for non-clients
*/
native void SF2_InitiateBossPackVote(int iInitiator);

/**
 * Returns the flags of the projectile.
 *
 * @param iProjectile		Entity index.
 * @return					Flags.
 */
native int SF2_GetProjectileFlags(int iProjectile);

/**
 * Sets the flags of the projectile.
 *
 * @param iProjectile		Entity index.
 * @param flags				Flags.
 */
native void SF2_SetProjectileFlags(int iProjectile, int flags);

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
