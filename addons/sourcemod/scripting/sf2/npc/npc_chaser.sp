#if defined _sf2_npc_chaser_included
#endinput
#endif
#define _sf2_npc_chaser_included

#pragma semicolon 1

bool g_NpcOriginalVisibility[MAX_BOSSES];

static float g_NpcWalkSpeed[MAX_BOSSES][Difficulty_Max];
static float g_NpcMaxWalkSpeed[MAX_BOSSES][Difficulty_Max];

static float g_NpcWakeRadius[MAX_BOSSES];

static bool g_NpcHasStunEnabled[MAX_BOSSES];
static float g_NpcStunCooldown[MAX_BOSSES];
static bool g_NpcStunFlashlightEnabled[MAX_BOSSES];
static bool g_NpcHasKeyDrop[MAX_BOSSES];
static float g_NpcStunFlashlightDamage[MAX_BOSSES];
static float g_NpcStunInitialHealth[MAX_BOSSES];
static float g_NpcStunAddHealth[MAX_BOSSES];
static float g_NpcStunHealth[MAX_BOSSES];
static bool g_NpcChaseInitialOnStun[MAX_BOSSES];

static float g_NpcAlertGracetime[MAX_BOSSES][Difficulty_Max];
static float g_NpcAlertDuration[MAX_BOSSES][Difficulty_Max];
static float g_NpcChaseDuration[MAX_BOSSES][Difficulty_Max];

static bool g_NpcCloakEnabled[MAX_BOSSES];
static float g_NpcCloakCooldown[MAX_BOSSES][Difficulty_Max];
static float g_NpcCloakRange[MAX_BOSSES][Difficulty_Max];
static float g_NpcDecloakRange[MAX_BOSSES][Difficulty_Max];
static float g_NpcCloakDuration[MAX_BOSSES][Difficulty_Max];
float g_NpcNextDecloakTime[MAX_BOSSES];
static float g_NpcCloakSpeedMultiplier[MAX_BOSSES][Difficulty_Max];

static bool g_NpcChaseOnLook[MAX_BOSSES];
ArrayList g_NpcChaseOnLookTarget[MAX_BOSSES] = { null, ... };

static bool g_NpcHasProjectileEnabled[MAX_BOSSES];
static float g_IceballSlowdownDuration[MAX_BOSSES][Difficulty_Max];
static float g_IceballSlowdownPercent[MAX_BOSSES][Difficulty_Max];
static float g_NpcProjectileCooldownMin[MAX_BOSSES][Difficulty_Max];
static float g_NpcProjectileCooldownMax[MAX_BOSSES][Difficulty_Max];
float g_NpcProjectileCooldown[MAX_BOSSES];
static float g_NpcProjectileSpeed[MAX_BOSSES][Difficulty_Max];
static float g_NpcProjectileDamage[MAX_BOSSES][Difficulty_Max];
static float g_NpcProjectileRadius[MAX_BOSSES][Difficulty_Max];
static float g_NpcProjectileDeviation[MAX_BOSSES][Difficulty_Max];
static int g_NpcProjectileCount[MAX_BOSSES][Difficulty_Max];
static bool g_NpcHasCriticalRockets[MAX_BOSSES];
static bool g_NpcHasUseShootGesture[MAX_BOSSES];
static bool g_NpcHasUseProjectileAmmo[MAX_BOSSES];
static int g_NpcProjectileLoadedAmmo[MAX_BOSSES][Difficulty_Max];
int g_NpcProjectileAmmo[MAX_BOSSES];
static float g_NpcProjectileReloadTime[MAX_BOSSES][Difficulty_Max];
float g_NpcProjectileTimeToReload[MAX_BOSSES];
static bool g_NpcHasUseChargeUpProjectiles[MAX_BOSSES];
static float g_NpcProjectileChargeUpTime[MAX_BOSSES][Difficulty_Max];
static int g_NpcProjectileType[MAX_BOSSES];
bool g_NpcReloadingProjectiles[MAX_BOSSES];

bool g_NpcHasAlwaysLookAtTarget[MAX_BOSSES];
bool g_NpcHasAlwaysLookAtTargetWhileAttacking[MAX_BOSSES];
bool g_NpcHasAlwaysLookAtTargetWhileChasing[MAX_BOSSES];

static float g_NpcSearchWanderRangeMin[MAX_BOSSES][Difficulty_Max];
static float g_NpcSearchWanderRangeMax[MAX_BOSSES][Difficulty_Max];

//The advanced damage effects
static bool g_NpcHasUseAdvancedDamageEffects[MAX_BOSSES];
static bool g_NpcHasAdvancedDamageEffectsRandom[MAX_BOSSES];
static bool g_NpcHasAttachDamageParticle[MAX_BOSSES];

static int g_NpcRandomAttackIndexes[MAX_BOSSES];
static float g_NpcRandomDuration[MAX_BOSSES][Difficulty_Max];
static float g_NpcRandomSlowdown[MAX_BOSSES][Difficulty_Max];
static int g_NpcRandomStunType[MAX_BOSSES];

static bool g_NpcHasJaratePlayerEnabled[MAX_BOSSES];
static int g_NpcJarateAttackIndexes[MAX_BOSSES];
static float g_NpcJarateDuration[MAX_BOSSES][Difficulty_Max];
static bool g_NpcHasJaratePlayerBeamParticle[MAX_BOSSES];

static bool g_NpcHasMilkPlayerEnabled[MAX_BOSSES];
static int g_NpcMilkAttackIndexes[MAX_BOSSES];
static float g_NpcMilkDuration[MAX_BOSSES][Difficulty_Max];
static bool g_NpcHasMilkPlayerBeamParticle[MAX_BOSSES];

static bool g_NpcHasGasPlayerEnabled[MAX_BOSSES];
static int g_NpcGasAttackIndexes[MAX_BOSSES];
static float g_NpcGasDuration[MAX_BOSSES][Difficulty_Max];
static bool g_NpcHasGasPlayerBeamParticle[MAX_BOSSES];

static bool g_NpcHasMarkPlayerEnabled[MAX_BOSSES];
static int g_NpcMarkAttackIndexes[MAX_BOSSES];
static float g_NpcMarkDuration[MAX_BOSSES][Difficulty_Max];

static bool g_NpcHasSilentMarkPlayerEnabled[MAX_BOSSES];
static int g_NpcSilentMarkAttackIndexes[MAX_BOSSES];
static float g_NpcSilentMarkDuration[MAX_BOSSES][Difficulty_Max];

static bool g_NpcHasIgnitePlayerEnabled[MAX_BOSSES];
static int g_NpcIgniteAttackIndexes[MAX_BOSSES];
static float g_NpcIgniteDuration[MAX_BOSSES][Difficulty_Max];
static float g_NpcIgniteDelay[MAX_BOSSES][Difficulty_Max];

static bool g_NpcHasStunPlayerEnabled[MAX_BOSSES];
static int g_NpcStunAttackIndexes[MAX_BOSSES];
static float g_NpcStunAttackDuration[MAX_BOSSES][Difficulty_Max];
static float g_NpcStunAttackSlowdown[MAX_BOSSES][Difficulty_Max];
static int g_NpcStunAttackType[MAX_BOSSES];
static bool g_NpcHasStunPlayerBeamParticle[MAX_BOSSES];

static bool g_NpcHasBleedPlayerEnabled[MAX_BOSSES];
static int g_NpcBleedAttackIndexes[MAX_BOSSES];
static float g_NpcBleedDuration[MAX_BOSSES][Difficulty_Max];

static bool g_NpcHasElectricPlayerEnabled[MAX_BOSSES];
static int g_NpcElectricAttackIndexes[MAX_BOSSES];
static float g_NpcElectricDuration[MAX_BOSSES][Difficulty_Max];
static float g_NpcElectricSlowdown[MAX_BOSSES][Difficulty_Max];
static bool g_NpcHasElectricPlayerBeamParticle[MAX_BOSSES];

static bool g_NpcHasSmitePlayerEnabled[MAX_BOSSES];
static int g_NpcSmiteAttackIndexes[MAX_BOSSES];
static float g_NpcSmiteDamage[MAX_BOSSES];
static int g_NpcSmiteDamageType[MAX_BOSSES];
static int g_NpcSmiteColorR[MAX_BOSSES];
static int g_NpcSmiteColorG[MAX_BOSSES];
static int g_NpcSmiteColorB[MAX_BOSSES];
static int g_NpcSmiteTransparency[MAX_BOSSES];
static bool g_NpcHasSmiteMessage[MAX_BOSSES];

static bool g_NpcHasShockwaveEnabled[MAX_BOSSES];
static float g_NpcShockwaveHeight[MAX_BOSSES][Difficulty_Max];
static float g_NpcShockwaveRange[MAX_BOSSES][Difficulty_Max];
static float g_NpcShockwaveDrain[MAX_BOSSES][Difficulty_Max];
static float g_NpcShockwaveForce[MAX_BOSSES][Difficulty_Max];
static bool g_NpcHasShockwaveStunEnabled[MAX_BOSSES];
static float g_NpcShockwaveStunDuration[MAX_BOSSES][Difficulty_Max];
static float g_NpcShockwaveStunSlowdown[MAX_BOSSES][Difficulty_Max];
static int g_NpcShockwaveAttackIndexes[MAX_BOSSES];
static float g_NpcShockwaveWidth[MAX_BOSSES][2];
static float g_NpcShockwaveAmplitude[MAX_BOSSES];

static int g_NpcState[MAX_BOSSES] = { -1, ... };
static int g_NpcCurrentAnimationSequence[MAX_BOSSES] = { -1, ... };
static bool g_NpcHasCurrentAnimationSequenceIsLooped[MAX_BOSSES] = { false, ... };
bool g_NpcUsesChaseInitialAnimation[MAX_BOSSES] = { false, ... };
bool g_NpcUsesCloakStartAnimation[MAX_BOSSES] = { false, ... };
bool g_NpcUsesCloakEndAnimation[MAX_BOSSES] = { false, ... };
bool g_NpcUseFireAnimation[MAX_BOSSES] = { false, ... };
bool g_NpcUseStartFleeAnimation[MAX_BOSSES] = { false, ... };
bool g_NpcUsesHealAnimation[MAX_BOSSES] = { false, ... };
static float g_NpcTimeUntilChaseAfterInitial[MAX_BOSSES];
float g_NpcCurrentAnimationSequencePlaybackRate[MAX_BOSSES] = { 1.0, ... };
static char g_NpcCurrentAnimationSequenceName[MAX_BOSSES][256];
bool g_NpcAlreadyAttacked[MAX_BOSSES];

bool g_NpcCopyAlerted[MAX_BOSSES];

static bool g_NpcHasEarthquakeFootstepsEnabled[MAX_BOSSES];
static float g_NpcEarthquakeFootstepsAmplitude[MAX_BOSSES];
static float g_NpcEarthquakeFootstepsFrequency[MAX_BOSSES];
static float g_NpcEarthquakeFootstepsDuration[MAX_BOSSES];
static float g_NpcEarthquakeFootstepsRadius[MAX_BOSSES];
static bool g_NpcHasEarthquakeFootstepsAirShake[MAX_BOSSES];

static int g_NpcSoundCountToAlert[MAX_BOSSES][Difficulty_Max];
static bool g_NpcHasDisappearOnStun[MAX_BOSSES] = { false, ... };
static bool g_NpcHasDropItemOnStun[MAX_BOSSES];
static int g_NpcDropItemType[MAX_BOSSES];
static bool g_NpcHasIsBoxingBoss[MAX_BOSSES] = { false, ... };
static bool g_NpcHasNormalSoundHookEnabled[MAX_BOSSES] = { false, ... };
static bool g_NpcHasCloakToHealEnabled[MAX_BOSSES] = { false, ... };
static bool g_NpcHasCanUseChaseInitialAnimation[MAX_BOSSES] = { false, ... };
static bool g_NpcHasOldAnimationAIState[MAX_BOSSES] = { false, ... };
static bool g_NpcHasCanUseAlertWalkingAnimation[MAX_BOSSES] = { false, ... };

static bool g_NpcHasXenobladeBreakComboSystem[MAX_BOSSES];
static float g_NpcXenobladeBreakDuration[MAX_BOSSES];
static float g_NpcXenobladeToppleDuration[MAX_BOSSES];
static float g_NpcXenobladeToppleSlowdown[MAX_BOSSES];
static float g_NpcXenobladeDazeDuration[MAX_BOSSES];

static char jaratePlayerParticle[PLATFORM_MAX_PATH];
static char milkPlayerParticle[PLATFORM_MAX_PATH];
static char gasPlayerParticle[PLATFORM_MAX_PATH];
static char stunPlayerParticle[PLATFORM_MAX_PATH];
static char electricPlayerParticleRed[PLATFORM_MAX_PATH];
static char electricPlayerParticleBlue[PLATFORM_MAX_PATH];
static char keyModel[PLATFORM_MAX_PATH];

bool g_NpcStealingLife[MAX_BOSSES];
Handle g_NpcLifeStealTimer[MAX_BOSSES];

static Handle g_NpcInstantKillThink[MAX_BOSSES];

static bool g_NpcHasTrapsEnabled[MAX_BOSSES];
static int g_NpcTrapType[MAX_BOSSES];
static float g_NpcNextTrapSpawn[MAX_BOSSES][Difficulty_Max];

//Special thanks to The Gaben
bool g_SlenderHasDamageParticleEffect[MAX_BOSSES];
char damageEffectParticle[PLATFORM_MAX_PATH];
char damageEffectSound[PLATFORM_MAX_PATH];

static int g_NpcAutoChaseThreshold[MAX_BOSSES][Difficulty_Max];
static int g_NpcAutoChaseAddGeneral[MAX_BOSSES][Difficulty_Max];
static int g_NpcAutoChaseAddFootstep[MAX_BOSSES][Difficulty_Max];
static int g_NpcAutoChaseAddLoudFootstep[MAX_BOSSES][Difficulty_Max];
static int g_NpcAutoChaseAddVoice[MAX_BOSSES][Difficulty_Max];
static int g_NpcAutoChaseAddWeapon[MAX_BOSSES][Difficulty_Max];
static bool g_NpcHasAutoChaseSprinters[MAX_BOSSES] = { false, ... };
float g_NpcAutoChaseSprinterCooldown[MAX_BOSSES];

bool g_NpcInAutoChase[MAX_BOSSES];

float g_NpcLaserTimer[MAX_BOSSES];

//KF2 Patriarch's Heal Logic
static bool g_NpcHasCanSelfHeal[MAX_BOSSES] = { false, ... };
bool g_NpcIsRunningToHeal[MAX_BOSSES] = { false, ... };
float g_NpcFleeHealTimer[MAX_BOSSES];
bool g_NpcIsHealing[MAX_BOSSES] = { false, ... };
bool g_NpcSetHealDestination[MAX_BOSSES] = { false, ... };
static float g_NpcStartSelfHealPercentage[MAX_BOSSES];
static float g_NpcSelfHealPercentageOne[MAX_BOSSES];
static float g_NpcSelfHealPercentageTwo[MAX_BOSSES];
static float g_NpcSelfHealPercentageThree[MAX_BOSSES];
int g_NpcSelfHealStage[MAX_BOSSES];
int g_NpcHealCount[MAX_BOSSES];

//Boxing stuff
static int g_NpcBoxingCurrentDifficulty[MAX_BOSSES];
static int g_NpcBoxingRagePhase[MAX_BOSSES];

static bool g_NpcHasHasCrawling[MAX_BOSSES] = { false, ... };
bool g_NpcIsCrawling[MAX_BOSSES] = { false, ... };
bool g_NpcChangeToCrawl[MAX_BOSSES] = { false, ... };
static float g_NpcCrawlSpeedMultiplier[MAX_BOSSES][Difficulty_Max];
float g_NpcCrawlDetectMins[MAX_BOSSES][3];
float g_NpcCrawlDetectMaxs[MAX_BOSSES][3];

enum struct BaseAttackStructure
{
	int baseAttackType;
	float baseAttackDamage;
	float baseAttackDamageVsProps;
	float baseAttackDamageForce;
	int baseAttackDamageType;
	float baseAttackDamageDelay;
	float baseAttackRange;
	float baseAttackDuration;
	float baseAttackSpread;
	float baseAttackBeginRange;
	float baseAttackBeginFOV;
	float baseAttackCooldown;
	int baseAttackDisappear;
	int baseAttackRepeat;
	int baseAttackMaxRepeats;
	int currentAttackRepeat;
	int weaponAttackIndex;

	bool baseAttackLifeSteal;
	float baseAttackLifeStealDuration;

	float baseAttackProjectileDamage;
	float baseAttackProjectileSpeed;
	float baseAttackProjectileRadius;
	float baseAttackProjectileDeviation;
	int baseAttackProjectileCount;
	int baseAttackProjectileType;
	bool baseAttackProjectileCrits;
	float baseAttackProjectileIceSlowdownPercent;
	float baseAttackProjectileIceSlowdownDuration;

	int baseAttackBulletCount;
	float baseAttackBulletDamage;
	float baseAttackBulletSpread;

	float baseAttackNextAttackTime;

	float baseAttackLaserDamage;
	float baseAttackLaserSize;
	int baseAttackLaserColor[3];
	bool baseAttackLaserAttachment;
	float baseAttackLaserDuration;
	float baseAttackLaserNoise;

	bool baseAttackPullIn;

	bool baseAttackWhileRunning;
	float baseAttackRunSpeed;
	float baseAttackRunDuration;
	float baseAttackRunDelay;

	int baseAttackUseOnDifficulty;
	int baseAttackBlockOnDifficulty;

	int baseAttackExplosiveDanceRadius;

	int baseAttackWeaponTypeInt;
	bool baseAttackIgnoreAlwaysLooking;
	bool baseAttackGestures;
	bool baseAttackDeathCamOnLowHealth;
	float baseAttackUseOnHealth;
	float baseAttackBlockOnHealth;
	bool baseAttackDontInterruptChaseInitial;
}

int g_SlenderOldState[MAX_BOSSES];
float g_LastPos[MAX_BOSSES][3];

static int g_NpcBaseAttacksCount[MAX_BOSSES];
BaseAttackStructure g_NpcBaseAttacks[MAX_BOSSES][SF2_CHASER_BOSS_MAX_ATTACKS][Difficulty_Max];
static int g_NpcCurrentAttackIndex[MAX_BOSSES];
float g_NpcBaseAttackRunDurationTime[MAX_BOSSES][SF2_CHASER_BOSS_MAX_ATTACKS];
float g_NpcBaseAttackRunDelayTime[MAX_BOSSES][SF2_CHASER_BOSS_MAX_ATTACKS];

#include "sf2/npc/npc_chaser_mind.sp"
#include "sf2/npc/npc_chaser_attacks.sp"
#include "sf2/npc/npc_chaser_pathing.sp"
#include "sf2/npc/npc_chaser_projectiles.sp"
#include "sf2/npc/npc_creeper.sp"
#include "sf2/methodmaps.sp"

void NPCChaserInitialize()
{
	for (int npcIndex = 0; npcIndex < MAX_BOSSES; npcIndex++)
	{
		NPCChaserResetValues(npcIndex);
	}
}

void NPCChaserResetAnimationInfo(int npcIndex, int iSequence = 0)
{
	g_NpcCurrentAnimationSequence[npcIndex] = iSequence;
	g_NpcHasCurrentAnimationSequenceIsLooped[npcIndex] = false;
	g_NpcCurrentAnimationSequencePlaybackRate[npcIndex] = 1.0;
	g_NpcUsesChaseInitialAnimation[npcIndex] = false;
	g_NpcUsesCloakStartAnimation[npcIndex] = false;
	g_NpcUsesCloakEndAnimation[npcIndex] = false;
	g_NpcUseFireAnimation[npcIndex] = false;
	g_NpcUsesHealAnimation[npcIndex] = false;
	g_NpcUseStartFleeAnimation[npcIndex] = false;
	for (int i = 0; i < 3; i++)
	{
		g_NpcUsesRageAnimation[npcIndex][i] = false;
	}
}

float NPCChaserGetWalkSpeed(int npcIndex, int difficulty)
{
	return g_NpcWalkSpeed[npcIndex][difficulty];
}

float NPCChaserGetMaxWalkSpeed(int npcIndex, int difficulty)
{
	return g_NpcMaxWalkSpeed[npcIndex][difficulty];
}

float NPCChaserGetWakeRadius(int npcIndex)
{
	return g_NpcWakeRadius[npcIndex];
}

int NPCChaserGetAttackCount(int npcIndex)
{
	return g_NpcBaseAttacksCount[npcIndex];
}

int NPCChaserGetAttackType(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackType;
}

float NPCChaserGetAttackDamage(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackDamage;
}

float NPCChaserGetAttackDamageVsProps(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackDamageVsProps;
}

float NPCChaserGetAttackDamageForce(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackDamageForce;
}
/*
float NPCChaserGetAttackLifeStealDuration(int npcIndex,int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackLifeStealDuration;
}
*/
bool NPCChaserGetAttackLifeStealState(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackLifeSteal;
}

bool NPCChaserGetAttackWhileRunningState(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackWhileRunning;
}

float NPCChaserGetAttackRunSpeed(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackRunSpeed;
}

float NPCChaserGetAttackRunDuration(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackRunDuration;
}

float NPCChaserGetAttackRunDelay(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackRunDelay;
}

int NPCChaserGetAttackUseOnDifficulty(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackUseOnDifficulty;
}

int NPCChaserGetAttackBlockOnDifficulty(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackBlockOnDifficulty;
}

int NPCChaserGetAttackExplosiveDanceRadius(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackExplosiveDanceRadius;
}

int NPCChaserGetAttackWeaponTypeInt(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackWeaponTypeInt;
}

int NPCChaserGetAttackProjectileType(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackProjectileType;
}

float NPCChaserGetAttackProjectileDamage(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackProjectileDamage;
}

float NPCChaserGetAttackProjectileSpeed(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackProjectileSpeed;
}

float NPCChaserGetAttackProjectileRadius(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackProjectileRadius;
}

float NPCChaserGetAttackProjectileDeviation(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackProjectileDeviation;
}

int NPCChaserGetAttackProjectileCount(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackProjectileCount;
}

bool NPCChaserGetAttackProjectileCrits(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackProjectileCrits;
}

float NPCChaserGetAttackProjectileIceSlowdownPercent(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackProjectileIceSlowdownPercent;
}

float NPCChaserGetAttackProjectileIceSlowdownDuration(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackProjectileIceSlowdownDuration;
}

int NPCChaserGetAttackBulletCount(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackBulletCount;
}

float NPCChaserGetAttackBulletDamage(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackBulletDamage;
}

float NPCChaserGetAttackBulletSpread(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackBulletSpread;
}

float NPCChaserGetAttackLaserDamage(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackLaserDamage;
}

float NPCChaserGetAttackLaserSize(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackLaserSize;
}

void NPCChaserGetAttackLaserColor(int npcIndex, int attackIndex, int color[3])
{
	color[0] = g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackLaserColor[0];
	color[1] = g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackLaserColor[1];
	color[2] = g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackLaserColor[2];
}

bool NPCChaserGetAttackLaserAttachmentState(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackLaserAttachment;
}

float NPCChaserGetAttackLaserDuration(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackLaserDuration;
}

float NPCChaserGetAttackLaserNoise(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackLaserNoise;
}

bool NPCChaserGetAttackPullIn(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackPullIn;
}

int NPCChaserGetAttackDamageType(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackDamageType;
}

int NPCChaserGetAttackDisappear(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackDisappear;
}

int NPCChaserGetAttackRepeat(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackRepeat;
}

int NPCChaserGetMaxAttackRepeats(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackMaxRepeats;
}

bool NPCChaserGetAttackIgnoreAlwaysLooking(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackIgnoreAlwaysLooking;
}

float NPCChaserGetAttackDamageDelay(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackDamageDelay;
}

float NPCChaserGetAttackRange(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackRange;
}

float NPCChaserGetAttackDuration(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackDuration;
}

float NPCChaserGetAttackSpread(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackSpread;
}

float NPCChaserGetAttackBeginRange(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackBeginRange;
}

float NPCChaserGetAttackBeginFOV(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackBeginFOV;
}

bool NPCChaserGetAttackGestureState(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackGestures;
}

bool NPCChaserGetAttackDeathCamOnLowHealth(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackDeathCamOnLowHealth;
}

float NPCChaserGetAttackUseOnHealth(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackUseOnHealth;
}

float NPCChaserGetAttackBlockOnHealth(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackBlockOnHealth;
}

bool NPCChaserGetAttackInterruptChaseInitialState(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackDontInterruptChaseInitial;
}

void NPCSetCurrentAttackIndex(int npcIndex, int attackIndex)
{
	g_NpcCurrentAttackIndex[npcIndex] = attackIndex;
}

int NPCGetCurrentAttackIndex(int npcIndex)
{
	return g_NpcCurrentAttackIndex[npcIndex];
}

void NpcSetCurrentAttackRepeat(int npcIndex, int attackIndex, int value)
{
	g_NpcBaseAttacks[npcIndex][attackIndex][1].currentAttackRepeat = value;
}

int NpcGetCurrentAttackRepeat(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].currentAttackRepeat;
}

float NPCChaserGetAttackCooldown(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackCooldown;
}

float NPCChaserGetNextAttackTime(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackNextAttackTime;
}

void NPCChaserSetNextAttackTime(int npcIndex, int attackIndex, float value)
{
	g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackNextAttackTime = value;
}

bool NPCChaserIsStunEnabled(int npcIndex)
{
	return g_NpcHasStunEnabled[npcIndex];
}

bool NPCChaserIsStunByFlashlightEnabled(int npcIndex)
{
	return g_NpcStunFlashlightEnabled[npcIndex];
}

bool NPCChaserCanChaseInitialOnStun(int npcIndex)
{
	return g_NpcChaseInitialOnStun[npcIndex];
}

bool NPCChaseHasKeyDrop(int npcIndex)
{
	return g_NpcHasKeyDrop[npcIndex];
}

float NPCChaserGetStunFlashlightDamage(int npcIndex)
{
	return g_NpcStunFlashlightDamage[npcIndex];
}

float NPCChaserGetStunCooldown(int npcIndex)
{
	return g_NpcStunCooldown[npcIndex];
}

float NPCChaserGetStunHealth(int npcIndex)
{
	return g_NpcStunHealth[npcIndex];
}

void NPCChaserSetStunHealth(int npcIndex, float amount)
{
	g_NpcStunHealth[npcIndex] = amount;
}

void NPCChaserSetStunInitialHealth(int npcIndex, float amount)
{
	g_NpcStunInitialHealth[npcIndex] = amount;
}

float NPCChaserGetAddStunHealth(int npcIndex)
{
	return g_NpcStunAddHealth[npcIndex];
}

void NPCChaserSetAddStunHealth(int npcIndex, float amount)
{
	g_NpcStunAddHealth[npcIndex] += amount;
}

void NPCChaserAddStunHealth(int npcIndex, float amount)
{
	if (GetGameTime() >= g_SlenderNextStunTime[npcIndex])
	{
		NPCChaserSetStunHealth(npcIndex, NPCChaserGetStunHealth(npcIndex) + amount);
		#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_BOSS_STUN, 0, "Boss %i, new amount: %0.0f", npcIndex, NPCChaserGetStunHealth(npcIndex));
		#endif
	}
}

float NPCChaserGetStunInitialHealth(int npcIndex)
{
	return g_NpcStunInitialHealth[npcIndex];
}

float NPCChaserGetAlertGracetime(int npcIndex, int difficulty)
{
	return g_NpcAlertGracetime[npcIndex][difficulty];
}

float NPCChaserGetAlertDuration(int npcIndex, int difficulty)
{
	return g_NpcAlertDuration[npcIndex][difficulty];
}

float NPCChaserGetChaseDuration(int npcIndex, int difficulty)
{
	return g_NpcChaseDuration[npcIndex][difficulty];
}

float NPCChaserGetWanderRangeMin(int npcIndex, int difficulty)
{
	return g_NpcSearchWanderRangeMin[npcIndex][difficulty];
}

float NPCChaserGetWanderRangeMax(int npcIndex, int difficulty)
{
	return g_NpcSearchWanderRangeMax[npcIndex][difficulty];
}

bool NPCChaserIsCloakEnabled(int npcIndex)
{
	return g_NpcCloakEnabled[npcIndex];
}

bool NPCChaserIsCloaked(int npcIndex)
{
	return g_NpcHasCloaked[npcIndex];
}

float NPCChaserGetCloakCooldown(int npcIndex, int difficulty)
{
	return g_NpcCloakCooldown[npcIndex][difficulty];
}

float NPCChaserGetCloakRange(int npcIndex, int difficulty)
{
	return g_NpcCloakRange[npcIndex][difficulty];
}

float NPCChaserGetDecloakRange(int npcIndex, int difficulty)
{
	return g_NpcDecloakRange[npcIndex][difficulty];
}

float NPCChaserGetCloakDuration(int npcIndex, int difficulty)
{
	return g_NpcCloakDuration[npcIndex][difficulty];
}

float NPCChaserGetCloakSpeedMultiplier(int npcIndex, int difficulty)
{
	return g_NpcCloakSpeedMultiplier[npcIndex][difficulty];
}

bool NPCChaserIsProjectileEnabled(int npcIndex)
{
	return g_NpcHasProjectileEnabled[npcIndex];
}

bool NPCChaserHasCriticalRockets(int npcIndex)
{
	return g_NpcHasCriticalRockets[npcIndex];
}

bool NPCChaserUseShootGesture(int npcIndex)
{
	return g_NpcHasUseShootGesture[npcIndex];
}

bool NPCChaserUseProjectileAmmo(int npcIndex)
{
	return g_NpcHasUseProjectileAmmo[npcIndex];
}

int NPCChaserGetProjectileType(int npcIndex)
{
	return g_NpcProjectileType[npcIndex];
}

float NPCChaserGetProjectileCooldownMin(int npcIndex, int difficulty)
{
	return g_NpcProjectileCooldownMin[npcIndex][difficulty];
}

float NPCChaserGetProjectileCooldownMax(int npcIndex, int difficulty)
{
	return g_NpcProjectileCooldownMax[npcIndex][difficulty];
}

float NPCChaserGetProjectileSpeed(int npcIndex, int difficulty)
{
	return g_NpcProjectileSpeed[npcIndex][difficulty];
}

float NPCChaserGetProjectileDamage(int npcIndex, int difficulty)
{
	return g_NpcProjectileDamage[npcIndex][difficulty];
}

float NPCChaserGetProjectileRadius(int npcIndex, int difficulty)
{
	return g_NpcProjectileRadius[npcIndex][difficulty];
}

float NPCChaserGetProjectileDeviation(int npcIndex, int difficulty)
{
	return g_NpcProjectileDeviation[npcIndex][difficulty];
}

int NPCChaserGetProjectileCount(int npcIndex, int difficulty)
{
	return g_NpcProjectileCount[npcIndex][difficulty];
}

float NPCChaserGetIceballSlowdownDuration(int npcIndex, int difficulty)
{
	return g_IceballSlowdownDuration[npcIndex][difficulty];
}

float NPCChaserGetIceballSlowdownPercent(int npcIndex, int difficulty)
{
	return g_IceballSlowdownPercent[npcIndex][difficulty];
}

int NPCChaserGetLoadedProjectiles(int npcIndex, int difficulty)
{
	return g_NpcProjectileLoadedAmmo[npcIndex][difficulty];
}

float NPCChaserGetProjectileReloadTime(int npcIndex, int difficulty)
{
	return g_NpcProjectileReloadTime[npcIndex][difficulty];
}
/*
float NPCChaserGetProjectileChargeUpDuration(int npcIndex,int difficulty)
{
	return g_NpcProjectileChargeUpTime[npcIndex][difficulty];
}
*/

bool NPCChaserUseAdvancedDamageEffects(int npcIndex)
{
	return g_NpcHasUseAdvancedDamageEffects[npcIndex];
}

bool NPCChaserUseRandomAdvancedDamageEffects(int npcIndex)
{
	return g_NpcHasAdvancedDamageEffectsRandom[npcIndex];
}

bool NPCChaserAttachDamageParticle(int npcIndex)
{
	return g_NpcHasAttachDamageParticle[npcIndex];
}

int NPCChaserRandomEffectIndexes(int npcIndex)
{
	return g_NpcRandomAttackIndexes[npcIndex];
}

float NPCChaserRandomEffectDuration(int npcIndex, int difficulty)
{
	return g_NpcRandomDuration[npcIndex][difficulty];
}

float NPCChaserRandomEffectSlowdown(int npcIndex, int difficulty)
{
	return g_NpcRandomSlowdown[npcIndex][difficulty];
}

int NPCChaserRandomEffectStunType(int npcIndex)
{
	return g_NpcRandomStunType[npcIndex];
}

bool NPCChaserJaratePlayerOnHit(int npcIndex)
{
	return g_NpcHasJaratePlayerEnabled[npcIndex];
}

int NPCChaserGetJarateAttackIndexes(int npcIndex)
{
	return g_NpcJarateAttackIndexes[npcIndex];
}

float NPCChaserGetJarateDuration(int npcIndex, int difficulty)
{
	return g_NpcJarateDuration[npcIndex][difficulty];
}

bool NPCChaserGetJarateBeamParticle(int npcIndex)
{
	return g_NpcHasJaratePlayerBeamParticle[npcIndex];
}

bool NPCChaserMilkPlayerOnHit(int npcIndex)
{
	return g_NpcHasMilkPlayerEnabled[npcIndex];
}

int NPCChaserGetMilkAttackIndexes(int npcIndex)
{
	return g_NpcMilkAttackIndexes[npcIndex];
}

float NPCChaserGetMilkDuration(int npcIndex, int difficulty)
{
	return g_NpcMilkDuration[npcIndex][difficulty];
}

bool NPCChaserGetMilkBeamParticle(int npcIndex)
{
	return g_NpcHasMilkPlayerBeamParticle[npcIndex];
}

bool NPCChaserGasPlayerOnHit(int npcIndex)
{
	return g_NpcHasGasPlayerEnabled[npcIndex];
}

int NPCChaserGetGasAttackIndexes(int npcIndex)
{
	return g_NpcGasAttackIndexes[npcIndex];
}

float NPCChaserGetGasDuration(int npcIndex, int difficulty)
{
	return g_NpcGasDuration[npcIndex][difficulty];
}

bool NPCChaserGetGasBeamParticle(int npcIndex)
{
	return g_NpcHasGasPlayerBeamParticle[npcIndex];
}

bool NPCChaserMarkPlayerOnHit(int npcIndex)
{
	return g_NpcHasMarkPlayerEnabled[npcIndex];
}

int NPCChaserGetMarkAttackIndexes(int npcIndex)
{
	return g_NpcMarkAttackIndexes[npcIndex];
}

float NPCChaserGetMarkDuration(int npcIndex, int difficulty)
{
	return g_NpcMarkDuration[npcIndex][difficulty];
}

bool NPCChaserSilentMarkPlayerOnHit(int npcIndex)
{
	return g_NpcHasSilentMarkPlayerEnabled[npcIndex];
}

int NPCChaserGetSilentMarkAttackIndexes(int npcIndex)
{
	return g_NpcSilentMarkAttackIndexes[npcIndex];
}

float NPCChaserGetSilentMarkDuration(int npcIndex, int difficulty)
{
	return g_NpcSilentMarkDuration[npcIndex][difficulty];
}

bool NPCChaserIgnitePlayerOnHit(int npcIndex)
{
	return g_NpcHasIgnitePlayerEnabled[npcIndex];
}

int NPCChaserGetIgniteAttackIndexes(int npcIndex)
{
	return g_NpcIgniteAttackIndexes[npcIndex];
}

float NPCChaserGetIgniteDuration(int npcIndex, int difficulty)
{
	return g_NpcIgniteDuration[npcIndex][difficulty];
}

float NPCChaserGetIgniteDelay(int npcIndex, int difficulty)
{
	return g_NpcIgniteDelay[npcIndex][difficulty];
}

bool NPCChaserStunPlayerOnHit(int npcIndex)
{
	return g_NpcHasStunPlayerEnabled[npcIndex];
}

int NPCChaserGetStunAttackIndexes(int npcIndex)
{
	return g_NpcStunAttackIndexes[npcIndex];
}

float NPCChaserGetStunAttackDuration(int npcIndex, int difficulty)
{
	return g_NpcStunAttackDuration[npcIndex][difficulty];
}

float NPCChaserGetStunAttackSlowdown(int npcIndex, int difficulty)
{
	return g_NpcStunAttackSlowdown[npcIndex][difficulty];
}

int NPCChaserGetStunAttackType(int npcIndex)
{
	return g_NpcStunAttackType[npcIndex];
}

bool NPCChaserGetStunBeamParticle(int npcIndex)
{
	return g_NpcHasStunPlayerBeamParticle[npcIndex];
}

bool NPCChaserBleedPlayerOnHit(int npcIndex)
{
	return g_NpcHasBleedPlayerEnabled[npcIndex];
}

int NPCChaserGetBleedAttackIndexes(int npcIndex)
{
	return g_NpcBleedAttackIndexes[npcIndex];
}

float NPCChaserGetBleedDuration(int npcIndex, int difficulty)
{
	return g_NpcBleedDuration[npcIndex][difficulty];
}

bool NPCChaserElectricPlayerOnHit(int npcIndex)
{
	return g_NpcHasElectricPlayerEnabled[npcIndex];
}

int NPCChaserGetElectricAttackIndexes(int npcIndex)
{
	return g_NpcElectricAttackIndexes[npcIndex];
}

float NPCChaserGetElectricDuration(int npcIndex, int difficulty)
{
	return g_NpcElectricDuration[npcIndex][difficulty];
}

float NPCChaserGetElectricSlowdown(int npcIndex, int difficulty)
{
	return g_NpcElectricSlowdown[npcIndex][difficulty];
}

bool NPCChaserGetElectricBeamParticle(int npcIndex)
{
	return g_NpcHasElectricPlayerBeamParticle[npcIndex];
}

bool NPCChaserSmitePlayerOnHit(int npcIndex)
{
	return g_NpcHasSmitePlayerEnabled[npcIndex];
}

bool NPCChaserSmitePlayerMessage(int npcIndex)
{
	return g_NpcHasSmiteMessage[npcIndex];
}

int NPCChaserGetSmiteAttackIndexes(int npcIndex)
{
	return g_NpcSmiteAttackIndexes[npcIndex];
}

bool NPCChaserXenobladeSystemEnabled(int npcIndex)
{
	return g_NpcHasXenobladeBreakComboSystem[npcIndex];
}

float NPCChaserGetXenobladeBreakDuration(int npcIndex)
{
	return g_NpcXenobladeBreakDuration[npcIndex];
}

float NPCChaserGetXenobladeToppleDuration(int npcIndex)
{
	return g_NpcXenobladeToppleDuration[npcIndex];
}

float NPCChaserGetXenobladeToppleSlowdown(int npcIndex)
{
	return g_NpcXenobladeToppleSlowdown[npcIndex];
}

float NPCChaserGetXenobladeDazeDuration(int npcIndex)
{
	return g_NpcXenobladeDazeDuration[npcIndex];
}

float NPCChaserGetSmiteDamage(int npcIndex)
{
	return g_NpcSmiteDamage[npcIndex];
}

int NPCChaserGetSmiteDamageType(int npcIndex)
{
	return g_NpcSmiteDamageType[npcIndex];
}

int NPCChaserGetSmiteColorR(int npcIndex)
{
	return g_NpcSmiteColorR[npcIndex];
}

int NPCChaserGetSmiteColorG(int npcIndex)
{
	return g_NpcSmiteColorG[npcIndex];
}

int NPCChaserGetSmiteColorB(int npcIndex)
{
	return g_NpcSmiteColorB[npcIndex];
}

int NPCChaserGetSmiteColorTrans(int npcIndex)
{
	return g_NpcSmiteTransparency[npcIndex];
}

bool NPCChaserGetTrapState(int npcIndex)
{
	return g_NpcHasTrapsEnabled[npcIndex];
}

int NPCChaserGetTrapType(int npcIndex)
{
	return g_NpcTrapType[npcIndex];
}

float NPCChaserGetTrapSpawnTime(int npcIndex, int difficulty)
{
	return g_NpcNextTrapSpawn[npcIndex][difficulty];
}

bool NPCChaserDamageParticlesEnabled(int npcIndex)
{
	return g_SlenderHasDamageParticleEffect[npcIndex];
}

bool NPCChaserGetSelfHealState(int npcIndex)
{
	return g_NpcHasCanSelfHeal[npcIndex];
}

float NPCChaserGetStartSelfHealPercentage(int npcIndex)
{
	return g_NpcStartSelfHealPercentage[npcIndex];
}

float NPCChaserGetSelfHealPercentageOne(int npcIndex)
{
	return g_NpcSelfHealPercentageOne[npcIndex];
}

float NPCChaserGetSelfHealPercentageTwo(int npcIndex)
{
	return g_NpcSelfHealPercentageTwo[npcIndex];
}

float NPCChaserGetSelfHealPercentageThree(int npcIndex)
{
	return g_NpcSelfHealPercentageThree[npcIndex];
}

bool NPCChaserIsAutoChaseEnabled(int npcIndex)
{
	return g_SlenderHasAutoChaseEnabled[npcIndex];
}

int NPCChaserAutoChaseThreshold(int npcIndex, int difficulty)
{
	return g_NpcAutoChaseThreshold[npcIndex][difficulty];
}

int NPCChaserAutoChaseAddGeneral(int npcIndex, int difficulty)
{
	return g_NpcAutoChaseAddGeneral[npcIndex][difficulty];
}

int NPCChaserAutoChaseAddFootstep(int npcIndex, int difficulty)
{
	return g_NpcAutoChaseAddFootstep[npcIndex][difficulty];
}

int NPCChaserAutoChaseAddLoudFootstep(int npcIndex, int difficulty)
{
	return g_NpcAutoChaseAddLoudFootstep[npcIndex][difficulty];
}

int NPCChaserAutoChaseAddVoice(int npcIndex, int difficulty)
{
	return g_NpcAutoChaseAddVoice[npcIndex][difficulty];
}

int NPCChaserAutoChaseAddWeapon(int npcIndex, int difficulty)
{
	return g_NpcAutoChaseAddWeapon[npcIndex][difficulty];
}

bool NPCChaserCanAutoChaseSprinters(int npcIndex)
{
	return g_NpcHasAutoChaseSprinters[npcIndex];
}

bool NPCChaserShockwaveOnAttack(int npcIndex)
{
	return g_NpcHasShockwaveEnabled[npcIndex];
}

bool NPCChaserShockwaveStunEnabled(int npcIndex)
{
	return g_NpcHasShockwaveStunEnabled[npcIndex];
}

int NPCChaserGetShockwaveAttackIndexes(int npcIndex)
{
	return g_NpcShockwaveAttackIndexes[npcIndex];
}

float NPCChaserGetShockwaveDrain(int npcIndex, int difficulty)
{
	return g_NpcShockwaveDrain[npcIndex][difficulty];
}

float NPCChaserGetShockwaveForce(int npcIndex, int difficulty)
{
	return g_NpcShockwaveForce[npcIndex][difficulty];
}

float NPCChaserGetShockwaveHeight(int npcIndex, int difficulty)
{
	return g_NpcShockwaveHeight[npcIndex][difficulty];
}

float NPCChaserGetShockwaveRange(int npcIndex, int difficulty)
{
	return g_NpcShockwaveRange[npcIndex][difficulty];
}

float NPCChaserGetShockwaveStunDuration(int npcIndex, int difficulty)
{
	return g_NpcShockwaveStunDuration[npcIndex][difficulty];
}

float NPCChaserGetShockwaveStunSlowdown(int npcIndex, int difficulty)
{
	return g_NpcShockwaveStunSlowdown[npcIndex][difficulty];
}

float NPCChaserGetShockwaveWidth(int npcIndex, int iType)
{
	return g_NpcShockwaveWidth[npcIndex][iType];
}

float NPCChaserGetShockwaveAmplitude(int npcIndex)
{
	return g_NpcShockwaveAmplitude[npcIndex];
}

bool NPCChaserGetEarthquakeFootstepsState(int npcIndex)
{
	return g_NpcHasEarthquakeFootstepsEnabled[npcIndex];
}

float NPCChaserGetEarthquakeFootstepsAmplitude(int npcIndex)
{
	return g_NpcEarthquakeFootstepsAmplitude[npcIndex];
}

float NPCChaserGetEarthquakeFootstepsFrequency(int npcIndex)
{
	return g_NpcEarthquakeFootstepsFrequency[npcIndex];
}

float NPCChaserGetEarthquakeFootstepsDuration(int npcIndex)
{
	return g_NpcEarthquakeFootstepsDuration[npcIndex];
}

float NPCChaserGetEarthquakeFootstepsRadius(int npcIndex)
{
	return g_NpcEarthquakeFootstepsRadius[npcIndex];
}

bool NPCChaserGetEarthquakeFootstepsAirShakeState(int npcIndex)
{
	return g_NpcHasEarthquakeFootstepsAirShake[npcIndex];
}

int NPCChaserGetSoundCountToAlert(int npcIndex, int difficulty)
{
	return g_NpcSoundCountToAlert[npcIndex][difficulty];
}

bool NPCChaserCanDisappearOnStun(int npcIndex)
{
	return g_NpcHasDisappearOnStun[npcIndex];
}

bool NPCChaserCanDropItemOnStun(int npcIndex)
{
	return g_NpcHasDropItemOnStun[npcIndex];
}

int NPCChaserItemDropTypeStun(int npcIndex)
{
	return g_NpcDropItemType[npcIndex];
}

bool NPCChaserIsBoxingBoss(int npcIndex)
{
	return g_NpcHasIsBoxingBoss[npcIndex];
}

bool NPCChaserNormalSoundHookEnabled(int npcIndex)
{
	return g_NpcHasNormalSoundHookEnabled[npcIndex];
}

bool NPCChaserCanCloakToHeal(int npcIndex)
{
	return g_NpcHasCloakToHealEnabled[npcIndex];
}

bool NPCChaserCanUseChaseInitialAnimation(int npcIndex)
{
	return g_NpcHasCanUseChaseInitialAnimation[npcIndex];
}

bool NPCChaserOldAnimationAIEnabled(int npcIndex)
{
	return g_NpcHasOldAnimationAIState[npcIndex];
}

bool NPCChaserCanUseAlertWalkingAnimation(int npcIndex)
{
	return g_NpcHasCanUseAlertWalkingAnimation[npcIndex];
}

bool NPCChaserCanCrawl(int npcIndex)
{
	return g_NpcHasHasCrawling[npcIndex];
}

float NPCChaserGetCrawlSpeedMultiplier(int npcIndex, int difficulty)
{
	return g_NpcCrawlSpeedMultiplier[npcIndex][difficulty];
}

int NPCChaserGetState(int npcIndex)
{
	return g_NpcState[npcIndex];
}

void NPCChaserSetState(int npcIndex, int state)
{
	g_NpcState[npcIndex] = state;
}

int NPCChaserGetBoxingDifficulty(int npcIndex)
{
	return g_NpcBoxingCurrentDifficulty[npcIndex];
}

void NPCChaserSetBoxingDifficulty(int npcIndex, int value)
{
	g_NpcBoxingCurrentDifficulty[npcIndex] = value;
}

int NPCChaserGetBoxingRagePhase(int npcIndex)
{
	return g_NpcBoxingRagePhase[npcIndex];
}

void NPCChaserSetBoxingRagePhase(int npcIndex, int value)
{
	g_NpcBoxingRagePhase[npcIndex] = value;
}

bool NPCChaserCanChaseOnLook(int npcIndex)
{
	return g_NpcChaseOnLook[npcIndex];
}

void NPCChaserOnSelectProfile(int npcIndex, bool invincible)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(npcIndex, profile, sizeof(profile));

	g_NpcWakeRadius[npcIndex] = GetChaserProfileWakeRadius(profile);

	for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
	{
		g_NpcWalkSpeed[npcIndex][difficulty] = GetChaserProfileWalkSpeed(profile, difficulty);
		g_NpcMaxWalkSpeed[npcIndex][difficulty] = GetChaserProfileMaxWalkSpeed(profile, difficulty);

		g_NpcAlertGracetime[npcIndex][difficulty] = GetChaserProfileAlertGracetime(profile, difficulty);
		g_NpcAlertDuration[npcIndex][difficulty] = GetChaserProfileAlertDuration(profile, difficulty);
		g_NpcChaseDuration[npcIndex][difficulty] = GetChaserProfileChaseDuration(profile, difficulty);

		g_NpcSoundCountToAlert[npcIndex][difficulty] = GetChaserProfileSoundCountToAlert(profile, difficulty);

		g_NpcCloakCooldown[npcIndex][difficulty] = GetChaserProfileCloakCooldown(profile, difficulty);
		g_NpcCloakRange[npcIndex][difficulty] = GetChaserProfileCloakRange(profile, difficulty);
		g_NpcDecloakRange[npcIndex][difficulty] = GetChaserProfileDecloakRange(profile, difficulty);
		g_NpcCloakDuration[npcIndex][difficulty] = GetChaserProfileCloakDuration(profile, difficulty);
		g_NpcCloakSpeedMultiplier[npcIndex][difficulty] = GetChaserProfileCloakSpeedMultiplier(profile, difficulty);

		g_NpcProjectileCooldownMin[npcIndex][difficulty] = GetChaserProfileProjectileCooldownMin(profile, difficulty);
		g_NpcProjectileCooldownMax[npcIndex][difficulty] = GetChaserProfileProjectileCooldownMax(profile, difficulty);
		g_NpcProjectileSpeed[npcIndex][difficulty] = GetChaserProfileProjectileSpeed(profile, difficulty);
		g_NpcProjectileDamage[npcIndex][difficulty] = GetChaserProfileProjectileDamage(profile, difficulty);
		g_NpcProjectileRadius[npcIndex][difficulty] = GetChaserProfileProjectileRadius(profile, difficulty);
		g_NpcProjectileDeviation[npcIndex][difficulty] = GetChaserProfileProjectileDeviation(profile, difficulty);
		g_NpcProjectileCount[npcIndex][difficulty] = GetChaserProfileProjectileCount(profile, difficulty);
		g_IceballSlowdownDuration[npcIndex][difficulty] = GetChaserProfileIceballSlowdownDuration(profile, difficulty);
		g_IceballSlowdownPercent[npcIndex][difficulty] = GetChaserProfileIceballSlowdownPercent(profile, difficulty);
		g_NpcProjectileLoadedAmmo[npcIndex][difficulty] = GetChaserProfileProjectileLoadedAmmo(profile, difficulty);
		g_NpcProjectileReloadTime[npcIndex][difficulty] = GetChaserProfileProjectileAmmoReloadTime(profile, difficulty);
		g_NpcProjectileChargeUpTime[npcIndex][difficulty] = GetChaserProfileProjectileChargeUpTime(profile, difficulty);
		g_NpcProjectileAmmo[npcIndex] = g_NpcProjectileLoadedAmmo[npcIndex][difficulty];
		g_NpcProjectileTimeToReload[npcIndex] = g_NpcProjectileReloadTime[npcIndex][difficulty];

		g_NpcRandomDuration[npcIndex][difficulty] = GetChaserProfileRandomEffectDuration(profile, difficulty);
		g_NpcRandomSlowdown[npcIndex][difficulty] = GetChaserProfileRandomEffectSlowdown(profile, difficulty);
		g_NpcJarateDuration[npcIndex][difficulty] = GetChaserProfileJaratePlayerDuration(profile, difficulty);
		g_NpcMilkDuration[npcIndex][difficulty] = GetChaserProfileMilkPlayerDuration(profile, difficulty);
		g_NpcGasDuration[npcIndex][difficulty] = GetChaserProfileGasPlayerDuration(profile, difficulty);
		g_NpcMarkDuration[npcIndex][difficulty] = GetChaserProfileMarkPlayerDuration(profile, difficulty);
		g_NpcSilentMarkDuration[npcIndex][difficulty] = GetChaserProfileSilentMarkPlayerDuration(profile, difficulty);
		g_NpcIgniteDuration[npcIndex][difficulty] = GetChaserProfileIgnitePlayerDuration(profile, difficulty);
		g_NpcIgniteDelay[npcIndex][difficulty] = GetChaserProfileIgnitePlayerDelay(profile, difficulty);
		g_NpcStunAttackDuration[npcIndex][difficulty] = GetChaserProfileStunPlayerDuration(profile, difficulty);
		g_NpcStunAttackSlowdown[npcIndex][difficulty] = GetChaserProfileStunPlayerSlowdown(profile, difficulty);
		g_NpcBleedDuration[npcIndex][difficulty] = GetChaserProfileBleedPlayerDuration(profile, difficulty);
		g_NpcElectricDuration[npcIndex][difficulty] = GetChaserProfileEletricPlayerDuration(profile, difficulty);
		g_NpcElectricSlowdown[npcIndex][difficulty] = GetChaserProfileEletricPlayerSlowdown(profile, difficulty);

		g_NpcShockwaveDrain[npcIndex][difficulty] = GetChaserProfileShockwaveDrain(profile, difficulty);
		g_NpcShockwaveForce[npcIndex][difficulty] = GetChaserProfileShockwaveForce(profile, difficulty);
		g_NpcShockwaveHeight[npcIndex][difficulty] = GetChaserProfileShockwaveHeight(profile, difficulty);
		g_NpcShockwaveRange[npcIndex][difficulty] = GetChaserProfileShockwaveRange(profile, difficulty);
		g_NpcShockwaveStunDuration[npcIndex][difficulty] = GetChaserProfileShockwaveStunDuration(profile, difficulty);
		g_NpcShockwaveStunSlowdown[npcIndex][difficulty] = GetChaserProfileShockwaveStunSlowdown(profile, difficulty);

		g_NpcNextTrapSpawn[npcIndex][difficulty] = GetChaserProfileTrapSpawnCooldown(profile, difficulty);
		g_SlenderNextTrapPlacement[npcIndex] = GetGameTime() + g_NpcNextTrapSpawn[npcIndex][difficulty];

		g_NpcSearchWanderRangeMin[npcIndex][difficulty] = GetChaserProfileWanderRangeMin(profile, difficulty);
		g_NpcSearchWanderRangeMax[npcIndex][difficulty] = GetChaserProfileWanderRangeMax(profile, difficulty);

		g_NpcAutoChaseThreshold[npcIndex][difficulty] = GetChaserProfileAutoChaseCount(profile, difficulty);
		g_NpcAutoChaseAddGeneral[npcIndex][difficulty] = GetChaserProfileAutoChaseAddGeneral(profile, difficulty);
		g_NpcAutoChaseAddFootstep[npcIndex][difficulty] = GetChaserProfileAutoChaseAddFootstep(profile, difficulty);
		g_NpcAutoChaseAddLoudFootstep[npcIndex][difficulty] = GetChaserProfileAutoChaseAddLoudFootstep(profile, difficulty);
		g_NpcAutoChaseAddVoice[npcIndex][difficulty] = GetChaserProfileAutoChaseAddVoice(profile, difficulty);
		g_NpcAutoChaseAddWeapon[npcIndex][difficulty] = GetChaserProfileAutoChaseAddWeapon(profile, difficulty);
		g_NpcCrawlSpeedMultiplier[npcIndex][difficulty] = GetChaserProfileCrawlSpeedMultiplier(profile, difficulty);
	}

	g_NpcBaseAttacksCount[npcIndex] = GetChaserProfileAttackCount(profile);
	// Get attack data.
	for (int i = 0; i < g_NpcBaseAttacksCount[npcIndex]; i++)
	{
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackType = GetChaserProfileAttackType(profile, i);
		for (int diffAtk = 0; diffAtk < Difficulty_Max; diffAtk++)
		{
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackDamage = GetChaserProfileAttackDamage(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackRunSpeed = GetChaserProfileAttackRunSpeed(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackCooldown = GetChaserProfileAttackCooldown(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackProjectileDamage = GetChaserProfileAttackProjectileDamage(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackProjectileSpeed = GetChaserProfileAttackProjectileSpeed(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackProjectileRadius = GetChaserProfileAttackProjectileRadius(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackProjectileDeviation = GetChaserProfileAttackProjectileDeviation(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackProjectileCount = GetChaserProfileAttackProjectileCount(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackProjectileIceSlowdownPercent = GetChaserProfileAttackProjectileIceSlowPercent(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackProjectileIceSlowdownDuration = GetChaserProfileAttackProjectileIceSlowDuration(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackBulletCount = GetChaserProfileAttackBulletCount(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackBulletDamage = GetChaserProfileAttackBulletDamage(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackBulletSpread = GetChaserProfileAttackBulletSpread(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackLaserDamage = GetChaserProfileAttackLaserDamage(profile, i, diffAtk);

			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackDamageForce = GetChaserProfileAttackDamageForce(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackDamageType = GetChaserProfileAttackDamageType(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackDamageDelay = GetChaserProfileAttackDamageDelay(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackRange = GetChaserProfileAttackRange(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackDuration = GetChaserProfileAttackDuration(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackSpread = GetChaserProfileAttackSpread(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackBeginRange = GetChaserProfileAttackBeginRange(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackBeginFOV = GetChaserProfileAttackBeginFOV(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackDisappear = GetChaserProfileAttackDisappear(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackIgnoreAlwaysLooking = GetChaserProfileAttackIgnoreAlwaysLooking(profile, i, diffAtk);

			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackLifeSteal = GetChaserProfileAttackLifeStealState(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackLifeStealDuration = GetChaserProfileAttackLifeStealDuration(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackProjectileCrits = GetChaserProfileAttackCritProjectiles(profile, i, diffAtk);

			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackWhileRunning = GetChaserProfileAttackRunWhileAttackingState(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackRunDuration = GetChaserProfileAttackRunDuration(profile, i, diffAtk);
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackRunDelay = GetChaserProfileAttackRunDelay(profile, i, diffAtk);

			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackExplosiveDanceRadius = GetChaserProfileAttackExplosiveDanceRadius(profile, i, diffAtk);

			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackLaserDuration = GetChaserProfileAttackLaserDuration(profile, i, diffAtk);

			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackDontInterruptChaseInitial = GetChaserProfileAttackChaseInitialInterruptState(profile, i, diffAtk);
		}
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackDamageVsProps = GetChaserProfileAttackDamageVsProps(profile, i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackRepeat = GetChaserProfileAttackRepeat(profile, i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackMaxRepeats = GetChaserProfileMaxAttackRepeats(profile, i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackNextAttackTime = 0.0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackProjectileType = GetChaserProfileAttackProjectileType(profile, i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLaserSize = GetChaserProfileAttackLaserSize(profile, i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackUseOnDifficulty = GetChaserProfileAttackUseOnDifficulty(profile, i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackBlockOnDifficulty = GetChaserProfileAttackBlockOnDifficulty(profile, i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackWeaponTypeInt = GetChaserProfileAttackWeaponTypeInt(profile, i);

		int laserColor[3];
		GetChaserProfileAttackLaserColor(profile, i, laserColor);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLaserColor = laserColor;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLaserAttachment = GetChaserProfileEnableLaserAttachment(profile, i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLaserNoise = GetChaserProfileAttackLaserNoise(profile, i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackPullIn = GetChaserProfileAttackPullIn(profile, i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackGestures = GetChaserProfileAttackGesturesState(profile, i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackDeathCamOnLowHealth = GetChaserProfileAttackDeathCamLowHealth(profile, i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackUseOnHealth = GetChaserProfileAttackUseOnHealth(profile, i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackBlockOnHealth = GetChaserProfileAttackBlockOnHealth(profile, i);
		g_NpcBaseAttacks[npcIndex][i][1].currentAttackRepeat = 0;
	}

	// Get stun data.
	if (!invincible)
	{
		g_NpcHasStunEnabled[npcIndex] = GetChaserProfileStunState(profile);
	}
	else
	{
		g_NpcHasStunEnabled[npcIndex] = false;
	}
	g_NpcStunCooldown[npcIndex] = GetChaserProfileStunCooldown(profile);
	g_NpcStunFlashlightEnabled[npcIndex] = GetChaserProfileStunFlashlightState(profile);
	g_NpcStunFlashlightDamage[npcIndex] = GetChaserProfileStunFlashlightDamage(profile);
	g_NpcStunInitialHealth[npcIndex] = GetChaserProfileStunHealth(profile);
	g_NpcChaseInitialOnStun[npcIndex] = GetChaserProfileStunOnChaseInitial(profile);

	//Get key Data
	g_NpcHasKeyDrop[npcIndex] = GetChaserProfileKeyDrop(profile);

	//Get Cloak Data
	g_NpcCloakEnabled[npcIndex] = GetChaserProfileCloakState(profile);
	g_NpcNextDecloakTime[npcIndex] = -1.0;

	float stunHealthPerPlayer = GetChaserProfileStunHealthPerPlayer(profile);
	int count;
	for (int client; client <= MaxClients; client++)
	{
		SF2_BasePlayer player = SF2_BasePlayer(client);
		if (player.IsValid && player.IsEliminated)
		{
			count++;
		}
	}

	stunHealthPerPlayer *= float(count);
	g_NpcStunInitialHealth[npcIndex] += stunHealthPerPlayer;

	g_NpcHasAlwaysLookAtTarget[npcIndex] = NPCHasAttribute(npcIndex, SF2Attribute_AlwaysLookAtTarget);
	g_NpcHasAlwaysLookAtTargetWhileAttacking[npcIndex] = NPCHasAttribute(npcIndex, SF2Attribute_AlwaysLookAtTargetWhileAttacking);
	g_NpcHasAlwaysLookAtTargetWhileChasing[npcIndex] = NPCHasAttribute(npcIndex, SF2Attribute_AlwaysLookAtTargetWhileChasing);
	g_NpcIgnoreNonMarkedForChase[npcIndex] = NPCHasAttribute(npcIndex, SF2Attribute_IgnoreNonMarkedForChase);

	g_NpcChaseOnLook[npcIndex] = GetChaserProfileChaseOnLook(profile);
	if (g_NpcChaseOnLookTarget[npcIndex] == null && g_NpcChaseOnLook[npcIndex])
	{
		g_NpcChaseOnLookTarget[npcIndex] = new ArrayList();
	}

	NPCChaserSetStunHealth(npcIndex, NPCChaserGetStunInitialHealth(npcIndex));

	NPCSetAddSpeed(npcIndex, -NPCGetAddSpeed(npcIndex));
	NPCSetAddMaxSpeed(npcIndex, -NPCGetAddMaxSpeed(npcIndex));
	NPCSetAddAcceleration(npcIndex, -NPCGetAddAcceleration(npcIndex));
	NPCChaserSetAddStunHealth(npcIndex, -NPCChaserGetAddStunHealth(npcIndex));

	g_NpcHasEarthquakeFootstepsEnabled[npcIndex] = GetChaserProfileEarthquakeFootstepState(profile);
	g_NpcEarthquakeFootstepsAmplitude[npcIndex] = GetChaserProfileEarthquakeFootstepAmplitude(profile);
	g_NpcEarthquakeFootstepsFrequency[npcIndex] = GetChaserProfileEarthquakeFootstepFrequency(profile);
	g_NpcEarthquakeFootstepsDuration[npcIndex] = GetChaserProfileEarthquakeFootstepDuration(profile);
	g_NpcEarthquakeFootstepsRadius[npcIndex] = GetChaserProfileEarthquakeFootstepRadius(profile);
	g_NpcHasEarthquakeFootstepsAirShake[npcIndex] = GetChaserProfileEarthquakeFootstepAirShake(profile);

	g_NpcHasDisappearOnStun[npcIndex] = GetChaserProfileDisappearOnStun(profile);
	g_NpcHasDropItemOnStun[npcIndex] = GetChaserProfileStunItemDropState(profile);
	g_NpcDropItemType[npcIndex] = GetChaserProfileStunItemDropType(profile);
	g_NpcHasIsBoxingBoss[npcIndex] = GetChaserProfileBoxingState(profile);
	g_NpcHasNormalSoundHookEnabled[npcIndex] = GetChaserProfileNormalSoundHook(profile);
	g_NpcHasCloakToHealEnabled[npcIndex] = GetChaserProfileCloakToHeal(profile);
	g_NpcHasCanUseChaseInitialAnimation[npcIndex] = GetChaserProfileChaseInitialAnimationState(profile);
	g_NpcHasOldAnimationAIState[npcIndex] = GetChaserProfileOldAnimState(profile);
	g_NpcHasCanUseAlertWalkingAnimation[npcIndex] = GetChaserProfileAlertWalkingState(profile);
	g_NpcOriginalVisibility[npcIndex] = GetChaserProfileUnnerfedVisibility(profile);

	g_NpcHasHasCrawling[npcIndex] = GetChaserProfileCrawlState(profile);
	GetChaserProfileCrawlMins(profile, g_NpcCrawlDetectMins[npcIndex]);
	GetChaserProfileCrawlMaxs(profile, g_NpcCrawlDetectMaxs[npcIndex]);

	if (SF_SpecialRound(SPECIALROUND_TINYBOSSES))
	{
		g_NpcCrawlDetectMins[npcIndex][0] /= 2.0;
		g_NpcCrawlDetectMins[npcIndex][1] /= 2.0;
		g_NpcCrawlDetectMins[npcIndex][2] /= 2.0;
		g_NpcCrawlDetectMaxs[npcIndex][0] /= 2.0;
		g_NpcCrawlDetectMaxs[npcIndex][1] /= 2.0;
		g_NpcCrawlDetectMaxs[npcIndex][2] /= 2.0;
	}

	g_NpcAlreadyAttacked[npcIndex] = false;
	g_NpcVelocityCancel[npcIndex] = false;

	g_NpcStealingLife[npcIndex] = false;
	g_NpcLifeStealTimer[npcIndex] = null;

	g_NpcHasCloaked[npcIndex] = false;

	//Get Projectile Data
	g_NpcHasProjectileEnabled[npcIndex] = GetChaserProfileProjectileState(profile);
	g_NpcProjectileType[npcIndex] = GetChaserProfileProjectileType(profile);
	g_NpcHasCriticalRockets[npcIndex] = GetChaserProfileCriticalRockets(profile);
	g_NpcHasUseShootGesture[npcIndex] = GetChaserProfileGestureShoot(profile);
	g_NpcHasUseProjectileAmmo[npcIndex] = GetChaserProfileProjectileAmmoState(profile);
	g_NpcHasUseChargeUpProjectiles[npcIndex] = GetChaserProfileChargeUpProjectilesState(profile);
	g_NpcProjectileCooldown[npcIndex] = 0.0;
	g_NpcReloadingProjectiles[npcIndex] = false;

	g_NpcHasUseAdvancedDamageEffects[npcIndex] = GetChaserProfileEnableAdvancedDamageEffects(profile);
	g_NpcHasAdvancedDamageEffectsRandom[npcIndex] = GetChaserProfileEnableAdvancedDamageEffectsRandom(profile);
	g_NpcHasAttachDamageParticle[npcIndex] = GetChaserProfileEnableAdvancedDamageParticles(profile);
	g_NpcRandomAttackIndexes[npcIndex] = GetChaserProfileRandomAttackIndexes(profile);
	g_NpcRandomStunType[npcIndex] = GetChaserProfileRandomStunType(profile);
	g_NpcHasJaratePlayerEnabled[npcIndex] = GetChaserProfileJarateState(profile);
	g_NpcJarateAttackIndexes[npcIndex] = GetChaserProfileJarateAttackIndexes(profile);
	g_NpcHasJaratePlayerBeamParticle[npcIndex] = GetChaserProfileJarateBeamParticle(profile);
	g_NpcHasMilkPlayerEnabled[npcIndex] = GetChaserProfileMilkState(profile);
	g_NpcMilkAttackIndexes[npcIndex] = GetChaserProfileMilkAttackIndexes(profile);
	g_NpcHasMilkPlayerBeamParticle[npcIndex] = GetChaserProfileMilkBeamParticle(profile);
	g_NpcHasGasPlayerEnabled[npcIndex] = GetChaserProfileGasState(profile);
	g_NpcGasAttackIndexes[npcIndex] = GetChaserProfileGasAttackIndexes(profile);
	g_NpcHasGasPlayerBeamParticle[npcIndex] = GetChaserProfileGasBeamParticle(profile);
	g_NpcHasMarkPlayerEnabled[npcIndex] = GetChaserProfileMarkState(profile);
	g_NpcMarkAttackIndexes[npcIndex] = GetChaserProfileMarkAttackIndexes(profile);
	g_NpcHasSilentMarkPlayerEnabled[npcIndex] = GetChaserProfileSilentMarkState(profile);
	g_NpcSilentMarkAttackIndexes[npcIndex] = GetChaserProfileSilentMarkAttackIndexes(profile);
	g_NpcHasIgnitePlayerEnabled[npcIndex] = GetChaserProfileIgniteState(profile);
	g_NpcIgniteAttackIndexes[npcIndex] = GetChaserProfileIgniteAttackIndexes(profile);
	g_NpcHasStunPlayerEnabled[npcIndex] = GetChaserProfileStunAttackState(profile);
	g_NpcStunAttackIndexes[npcIndex] = GetChaserProfileStunAttackIndexes(profile);
	g_NpcStunAttackType[npcIndex] = GetChaserProfileStunDamageType(profile);
	g_NpcHasStunPlayerBeamParticle[npcIndex] = GetChaserProfileStunAttackBeamParticle(profile);
	g_NpcHasBleedPlayerEnabled[npcIndex] = GetChaserProfileBleedState(profile);
	g_NpcBleedAttackIndexes[npcIndex] = GetChaserProfileBleedAttackIndexes(profile);
	g_NpcHasElectricPlayerEnabled[npcIndex] = GetChaserProfileEletricAttackState(profile);
	g_NpcElectricAttackIndexes[npcIndex] = GetChaserProfileEletricAttackIndexes(profile);
	g_NpcHasElectricPlayerBeamParticle[npcIndex] = GetChaserProfileEletricBeamParticle(profile);
	g_NpcHasSmitePlayerEnabled[npcIndex] = GetChaserProfileSmiteState(profile);
	g_NpcHasSmiteMessage[npcIndex] = GetChaserProfileSmiteMessage(profile);
	g_NpcSmiteAttackIndexes[npcIndex] = GetChaserProfileSmiteAttackIndexes(profile);
	g_NpcSmiteDamage[npcIndex] = GetChaserProfileSmiteDamage(profile);
	g_NpcSmiteDamageType[npcIndex] = GetChaserProfileSmiteDamageType(profile);

	g_NpcHasXenobladeBreakComboSystem[npcIndex] = GetChaserProfileXenobladeCombo(profile);
	g_NpcXenobladeBreakDuration[npcIndex] = GetChaserProfileXenobladeBreakDuration(profile);
	g_NpcXenobladeToppleDuration[npcIndex] = GetChaserProfileXenobladeToppleDuration(profile);
	g_NpcXenobladeToppleSlowdown[npcIndex] = GetChaserProfileXenobladeToppleSlowdown(profile);
	g_NpcXenobladeDazeDuration[npcIndex] = GetChaserProfileXenobladeDazeDuration(profile);

	int smiteColor[4];
	GetChaserProfileSmiteColor(profile, smiteColor);

	g_NpcSmiteColorR[npcIndex] = smiteColor[0];
	g_NpcSmiteColorG[npcIndex] = smiteColor[1];
	g_NpcSmiteColorB[npcIndex] = smiteColor[2];
	g_NpcSmiteTransparency[npcIndex] = smiteColor[3];
	g_SlenderHasDamageParticleEffect[npcIndex] = GetChaserProfileDamageParticleState(profile);

	g_NpcHasShockwaveEnabled[npcIndex] = GetChaserProfileShockwaveState(profile);
	g_NpcHasShockwaveStunEnabled[npcIndex] = GetChaserProfileShockwaveStunState(profile);
	g_NpcShockwaveAttackIndexes[npcIndex] = GetChaserProfileShockwaveAttackIndexes(profile);
	g_NpcShockwaveWidth[npcIndex][0] = GetChaserProfileShockwaveWidth1(profile);
	g_NpcShockwaveWidth[npcIndex][1] = GetChaserProfileShockwaveWidth2(profile);
	g_NpcShockwaveAmplitude[npcIndex] = GetChaserProfileShockwaveAmplitude(profile);

	g_NpcHasTrapsEnabled[npcIndex] = GetChaserProfileTrapState(profile);
	g_NpcTrapType[npcIndex] = GetChaserProfileTrapType(profile);

	g_SlenderHasAutoChaseEnabled[npcIndex] = GetChaserProfileAutoChaseState(profile);
	g_NpcHasAutoChaseSprinters[npcIndex] = GetChaserProfileAutoChaseSprinterState(profile);
	g_NpcAutoChaseSprinterCooldown[npcIndex] = 0.0;
	g_NpcInAutoChase[npcIndex] = false;
	g_SlenderIsAutoChasingLoudPlayer[npcIndex] = false;

	g_SlenderChasesEndlessly[npcIndex] = GetChaserProfileEndlessChasingState(profile);

	g_NpcLaserTimer[npcIndex] = 0.0;

	g_NpcHasCanSelfHeal[npcIndex] = GetChaserProfileSelfHealState(profile);
	g_NpcStartSelfHealPercentage[npcIndex] = GetChaserProfileSelfHealStartPercentage(profile);
	g_NpcSelfHealPercentageOne[npcIndex] = GetChaserProfileSelfHealPercentageOne(profile);
	g_NpcSelfHealPercentageTwo[npcIndex] = GetChaserProfileSelfHealPercentageTwo(profile);
	g_NpcSelfHealPercentageThree[npcIndex] = GetChaserProfileSelfHealPercentageThree(profile);
	g_NpcIsRunningToHeal[npcIndex] = false;
	g_NpcIsHealing[npcIndex] = false;
	g_NpcFleeHealTimer[npcIndex] = 0.0;
	g_NpcSelfHealStage[npcIndex] = 0;
	g_NpcHealCount[npcIndex] = 0;
	g_NpcSetHealDestination[npcIndex] = false;

	g_NpcBoxingCurrentDifficulty[npcIndex] = 1;
	g_NpcBoxingRagePhase[npcIndex] = 0;

	g_NpcCopyAlerted[npcIndex] = false;
}

void NPCChaserOnRemoveProfile(int npcIndex)
{
	NPCChaserResetValues(npcIndex);
}

/**
 *	Resets all global variables on a specified NPC. Usually this should be done last upon removing a boss from the game.
 */
static void NPCChaserResetValues(int npcIndex)
{
	g_NpcWakeRadius[npcIndex] = 0.0;

	for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
	{
		g_NpcWalkSpeed[npcIndex][difficulty] = 0.0;
		g_NpcMaxWalkSpeed[npcIndex][difficulty] = 0.0;

		g_NpcAlertGracetime[npcIndex][difficulty] = 0.0;
		g_NpcAlertDuration[npcIndex][difficulty] = 0.0;
		g_NpcChaseDuration[npcIndex][difficulty] = 0.0;

		g_NpcSoundCountToAlert[npcIndex][difficulty] = 0;

		g_NpcCloakCooldown[npcIndex][difficulty] = 0.0;
		g_NpcCloakRange[npcIndex][difficulty] = 0.0;
		g_NpcDecloakRange[npcIndex][difficulty] = 0.0;
		g_NpcCloakDuration[npcIndex][difficulty] = 0.0;
		g_NpcCloakSpeedMultiplier[npcIndex][difficulty] = 0.0;

		g_NpcProjectileCooldownMin[npcIndex][difficulty] = 0.0;
		g_NpcProjectileCooldownMax[npcIndex][difficulty] = 0.0;
		g_NpcProjectileSpeed[npcIndex][difficulty] = 0.0;
		g_NpcProjectileDamage[npcIndex][difficulty] = 0.0;
		g_NpcProjectileRadius[npcIndex][difficulty] = 0.0;
		g_NpcProjectileDeviation[npcIndex][difficulty] = 0.0;
		g_NpcProjectileCount[npcIndex][difficulty] = 0;
		g_IceballSlowdownDuration[npcIndex][difficulty] = 0.0;
		g_IceballSlowdownPercent[npcIndex][difficulty] = 0.0;
		g_NpcProjectileLoadedAmmo[npcIndex][difficulty] = 0;
		g_NpcProjectileReloadTime[npcIndex][difficulty] = 0.0;
		g_NpcProjectileChargeUpTime[npcIndex][difficulty] = 0.0;

		g_NpcRandomDuration[npcIndex][difficulty] = 0.0;
		g_NpcRandomSlowdown[npcIndex][difficulty] = 0.0;
		g_NpcJarateDuration[npcIndex][difficulty] = 0.0;
		g_NpcMilkDuration[npcIndex][difficulty] = 0.0;
		g_NpcGasDuration[npcIndex][difficulty] = 0.0;
		g_NpcMarkDuration[npcIndex][difficulty] = 0.0;
		g_NpcSilentMarkDuration[npcIndex][difficulty] = 0.0;
		g_NpcIgniteDuration[npcIndex][difficulty] = 0.0;
		g_NpcIgniteDelay[npcIndex][difficulty] = 0.0;
		g_NpcStunAttackDuration[npcIndex][difficulty] = 0.0;
		g_NpcStunAttackSlowdown[npcIndex][difficulty] = 0.0;
		g_NpcBleedDuration[npcIndex][difficulty] = 0.0;
		g_NpcElectricDuration[npcIndex][difficulty] = 0.0;
		g_NpcElectricSlowdown[npcIndex][difficulty] = 0.0;

		g_NpcShockwaveDrain[npcIndex][difficulty] = 0.0;
		g_NpcShockwaveForce[npcIndex][difficulty] = 0.0;
		g_NpcShockwaveHeight[npcIndex][difficulty] = 0.0;
		g_NpcShockwaveRange[npcIndex][difficulty] = 0.0;
		g_NpcShockwaveStunDuration[npcIndex][difficulty] = 0.0;
		g_NpcShockwaveStunSlowdown[npcIndex][difficulty] = 0.0;

		g_NpcNextTrapSpawn[npcIndex][difficulty] = 0.0;
		g_SlenderNextTrapPlacement[npcIndex] = 0.0;

		g_NpcSearchWanderRangeMin[npcIndex][difficulty] = 0.0;
		g_NpcSearchWanderRangeMax[npcIndex][difficulty] = 0.0;

		g_NpcAutoChaseThreshold[npcIndex][difficulty] = 0;
		g_NpcAutoChaseAddGeneral[npcIndex][difficulty] = 0;
		g_NpcAutoChaseAddFootstep[npcIndex][difficulty] = 0;
		g_NpcAutoChaseAddLoudFootstep[npcIndex][difficulty] = 0;
		g_NpcAutoChaseAddVoice[npcIndex][difficulty] = 0;
		g_NpcAutoChaseAddWeapon[npcIndex][difficulty] = 0;

		g_NpcCrawlSpeedMultiplier[npcIndex][difficulty] = 0.0;
	}

	// Clear attack data.
	for (int i = 0; i < SF2_CHASER_BOSS_MAX_ATTACKS - 1; i++)
	{
		// Base attack data.
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackType = SF2BossAttackType_Invalid;
		for (int diffAtk = 0; diffAtk < Difficulty_Max; diffAtk++)
		{
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackDamage = 0.0;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackRunSpeed = 0.0;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackCooldown = 0.0;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackProjectileDamage = 0.0;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackProjectileSpeed = 0.0;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackProjectileRadius = 0.0;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackProjectileDeviation = 0.0;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackProjectileCount = 0;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackProjectileIceSlowdownPercent = 0.0;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackProjectileIceSlowdownDuration = 0.0;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackBulletCount = 0;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackBulletDamage = 0.0;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackBulletSpread = 0.0;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackLaserDamage = 0.0;

			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackDamageForce = 0.0;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackDamageType = 0;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackDamageDelay = 0.0;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackRange = 0.0;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackDuration = 0.0;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackSpread = 0.0;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackBeginRange = 0.0;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackBeginFOV = 0.0;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackDisappear = 0;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackIgnoreAlwaysLooking = false;

			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackLifeSteal = false;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackLifeStealDuration = 0.0;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackProjectileCrits = false;

			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackWhileRunning = false;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackRunDuration = 0.0;
			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackRunDelay = 0.0;

			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackExplosiveDanceRadius = 0;

			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackLaserDuration = 0.0;

			g_NpcBaseAttacks[npcIndex][i][diffAtk].baseAttackDontInterruptChaseInitial = false;
		}
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackDamageVsProps = 0.0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackRepeat = 0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackMaxRepeats = 0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackNextAttackTime = 0.0;
		g_NpcBaseAttacks[npcIndex][i][1].weaponAttackIndex = 0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackProjectileType = 0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLaserSize = 0.0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLaserColor[0] = 0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLaserColor[1] = 0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLaserColor[2] = 0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLaserAttachment = false;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLaserNoise = 0.0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackPullIn = false;
		g_NpcBaseAttacks[npcIndex][i][1].currentAttackRepeat = 0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackUseOnDifficulty = 0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackBlockOnDifficulty = 0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackWeaponTypeInt = 0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackGestures = false;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackDeathCamOnLowHealth = false;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackUseOnHealth = -1.0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackBlockOnHealth = -1.0;
	}

	g_NpcHasEarthquakeFootstepsEnabled[npcIndex] = false;
	g_NpcEarthquakeFootstepsAmplitude[npcIndex] = 0.0;
	g_NpcEarthquakeFootstepsFrequency[npcIndex] = 0.0;
	g_NpcEarthquakeFootstepsDuration[npcIndex] = 0.0;
	g_NpcEarthquakeFootstepsRadius[npcIndex] = 0.0;
	g_NpcHasEarthquakeFootstepsAirShake[npcIndex] = false;

	g_NpcHasDisappearOnStun[npcIndex] = false;
	g_NpcHasDropItemOnStun[npcIndex] = false;
	g_NpcDropItemType[npcIndex] = 0;
	g_NpcHasIsBoxingBoss[npcIndex] = false;
	g_NpcHasNormalSoundHookEnabled[npcIndex] = false;
	g_NpcHasCloakToHealEnabled[npcIndex] = false;
	g_NpcHasCanUseChaseInitialAnimation[npcIndex] = false;
	g_NpcHasOldAnimationAIState[npcIndex] = false;
	g_NpcHasCanUseAlertWalkingAnimation[npcIndex] = false;

	g_NpcHasHasCrawling[npcIndex] = false;
	g_NpcIsCrawling[npcIndex] = false;

	g_NpcHasStunEnabled[npcIndex] = false;
	g_NpcAlreadyAttacked[npcIndex] = false;
	g_NpcStunCooldown[npcIndex] = 0.0;
	g_NpcStunFlashlightEnabled[npcIndex] = false;
	g_NpcStunInitialHealth[npcIndex] = 0.0;
	g_NpcStunAddHealth[npcIndex] = 0.0;
	g_NpcChaseInitialOnStun[npcIndex] = false;
	g_NpcOriginalVisibility[npcIndex] = false;

	g_NpcCloakEnabled[npcIndex] = false;
	g_NpcNextDecloakTime[npcIndex] = -1.0;
	g_NpcHasCloaked[npcIndex] = false;
	g_NpcVelocityCancel[npcIndex] = false;
	g_NpcStealingLife[npcIndex] = false;
	g_NpcLifeStealTimer[npcIndex] = null;
	g_NpcChaseOnLook[npcIndex] = false;
	if (g_NpcChaseOnLookTarget[npcIndex] != null)
	{
		delete g_NpcChaseOnLookTarget[npcIndex];
		g_NpcChaseOnLookTarget[npcIndex] = null;
	}

	g_NpcHasAlwaysLookAtTarget[npcIndex] = false;
	g_NpcHasAlwaysLookAtTargetWhileAttacking[npcIndex] = false;
	g_NpcHasAlwaysLookAtTargetWhileChasing[npcIndex] = false;
	g_NpcIgnoreNonMarkedForChase[npcIndex] = false;

	g_NpcUsedRage1[npcIndex] = false;
	g_NpcUsedRage2[npcIndex] = false;
	g_NpcHasUsedRage3[npcIndex] = false;

	g_NpcHasProjectileEnabled[npcIndex] = false;
	g_NpcProjectileType[npcIndex] = SF2BossProjectileType_Invalid;
	g_NpcHasCriticalRockets[npcIndex] = false;
	g_NpcHasUseShootGesture[npcIndex] = false;
	g_NpcHasUseProjectileAmmo[npcIndex] = false;
	g_NpcHasUseChargeUpProjectiles[npcIndex] = false;
	g_NpcProjectileAmmo[npcIndex] = 0;
	g_NpcProjectileCooldown[npcIndex] = 0.0;
	g_NpcProjectileTimeToReload[npcIndex] = 0.0;
	g_NpcReloadingProjectiles[npcIndex] = false;

	g_NpcHasUseAdvancedDamageEffects[npcIndex] = false;
	g_NpcHasAdvancedDamageEffectsRandom[npcIndex] = false;
	g_NpcHasAttachDamageParticle[npcIndex] = false;
	g_NpcRandomAttackIndexes[npcIndex] = 0;
	g_NpcRandomStunType[npcIndex] = 0;
	g_NpcHasJaratePlayerEnabled[npcIndex] = false;
	g_NpcJarateAttackIndexes[npcIndex] = 0;
	g_NpcHasMilkPlayerEnabled[npcIndex] = false;
	g_NpcMilkAttackIndexes[npcIndex] = 0;
	g_NpcHasGasPlayerEnabled[npcIndex] = false;
	g_NpcGasAttackIndexes[npcIndex] = 0;
	g_NpcHasMarkPlayerEnabled[npcIndex] = false;
	g_NpcMarkAttackIndexes[npcIndex] = 0;
	g_NpcHasSilentMarkPlayerEnabled[npcIndex] = false;
	g_NpcSilentMarkAttackIndexes[npcIndex] = 0;
	g_NpcHasIgnitePlayerEnabled[npcIndex] = false;
	g_NpcIgniteAttackIndexes[npcIndex] = 0;
	g_NpcHasStunPlayerEnabled[npcIndex] = false;
	g_NpcStunAttackIndexes[npcIndex] = 0;
	g_NpcStunAttackType[npcIndex] = 0;
	g_NpcHasBleedPlayerEnabled[npcIndex] = false;
	g_NpcBleedAttackIndexes[npcIndex] = 0;
	g_NpcHasElectricPlayerEnabled[npcIndex] = false;
	g_NpcElectricAttackIndexes[npcIndex] = 0;
	g_NpcHasSmitePlayerEnabled[npcIndex] = false;
	g_NpcHasSmiteMessage[npcIndex] = false;
	g_NpcSmiteAttackIndexes[npcIndex] = 0;
	g_NpcHasXenobladeBreakComboSystem[npcIndex] = false;
	g_NpcXenobladeBreakDuration[npcIndex] = 0.0;
	g_NpcXenobladeToppleDuration[npcIndex] = 0.0;
	g_NpcXenobladeToppleSlowdown[npcIndex] = 0.0;
	g_NpcXenobladeDazeDuration[npcIndex] = 0.0;
	g_NpcSmiteDamage[npcIndex] = 0.0;
	g_NpcSmiteDamageType[npcIndex] = 0;
	g_NpcSmiteColorR[npcIndex] = 0;
	g_NpcSmiteColorG[npcIndex] = 0;
	g_NpcSmiteColorB[npcIndex] = 0;
	g_NpcSmiteTransparency[npcIndex] = 0;
	g_NpcHasShockwaveEnabled[npcIndex] = false;
	g_NpcHasShockwaveStunEnabled[npcIndex] = false;
	g_NpcShockwaveAttackIndexes[npcIndex] = 0;
	g_NpcShockwaveWidth[npcIndex][0] = 0.0;
	g_NpcShockwaveWidth[npcIndex][1] = 0.0;
	g_NpcShockwaveAmplitude[npcIndex] = 0.0;
	g_NpcTimeUntilChaseAfterInitial[npcIndex] = 0.0;
	g_SlenderHasDamageParticleEffect[npcIndex] = false;

	g_NpcHasTrapsEnabled[npcIndex] = false;
	g_NpcTrapType[npcIndex] = 0;

	g_SlenderHasAutoChaseEnabled[npcIndex] = false;
	g_NpcInAutoChase[npcIndex] = false;
	g_NpcHasAutoChaseSprinters[npcIndex] = false;
	g_NpcAutoChaseSprinterCooldown[npcIndex] = 0.0;
	g_SlenderIsAutoChasingLoudPlayer[npcIndex] = false;

	g_SlenderChasesEndlessly[npcIndex] = false;

	NPCSetAddSpeed(npcIndex, -NPCGetAddSpeed(npcIndex));
	NPCSetAddMaxSpeed(npcIndex, -NPCGetAddMaxSpeed(npcIndex));
	NPCSetAddAcceleration(npcIndex, -NPCGetAddAcceleration(npcIndex));
	NPCChaserSetAddStunHealth(npcIndex, -NPCChaserGetAddStunHealth(npcIndex));

	NPCChaserSetStunHealth(npcIndex, 0.0);

	g_NpcState[npcIndex] = -1;

	g_NpcLaserTimer[npcIndex] = 0.0;

	g_NpcHasCanSelfHeal[npcIndex] = false;
	g_NpcStartSelfHealPercentage[npcIndex] = 0.0;
	g_NpcSelfHealPercentageOne[npcIndex] = 0.0;
	g_NpcSelfHealPercentageTwo[npcIndex] = 0.0;
	g_NpcSelfHealPercentageThree[npcIndex] = 0.0;
	g_NpcIsRunningToHeal[npcIndex] = false;
	g_NpcIsHealing[npcIndex] = false;
	g_NpcFleeHealTimer[npcIndex] = 0.0;
	g_NpcSelfHealStage[npcIndex] = 0;
	g_NpcHealCount[npcIndex] = 0;
	g_NpcSetHealDestination[npcIndex] = false;

	g_NpcBoxingCurrentDifficulty[npcIndex] = 0;
	g_NpcBoxingRagePhase[npcIndex] = 0;

	g_NpcCopyAlerted[npcIndex] = false;
}

void Spawn_Chaser(int bossIndex)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	g_LastStuckTime[bossIndex] = 0.0;
	g_SlenderOldState[bossIndex] = STATE_IDLE;
	g_NpcCopyAlerted[bossIndex] = false;
	g_NpcNextDecloakTime[bossIndex] = -1.0;
	g_NpcIsCrawling[bossIndex] = false;
	g_NpcChangeToCrawl[bossIndex] = false;
	g_SlenderSoundPositionSetCooldown[bossIndex] = 0.0;

	NPCSetAddSpeed(bossIndex, -NPCGetAddSpeed(bossIndex));
	NPCSetAddMaxSpeed(bossIndex, -NPCGetAddMaxSpeed(bossIndex));
	NPCSetAddAcceleration(bossIndex, -NPCGetAddAcceleration(bossIndex));
	NPCChaserSetAddStunHealth(bossIndex, -NPCChaserGetAddStunHealth(bossIndex));

	g_NpcInstantKillThink[bossIndex] = CreateTimer(0.0, Timer_InstantKillThink, bossIndex, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);

	for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
	{
		g_SlenderNextWanderPos[bossIndex][difficulty] = GetGameTime() +
			GetRandomFloat(GetChaserProfileWanderEnterTimeMin(profile, difficulty), GetChaserProfileWanderEnterTimeMax(profile, difficulty));
	}

}

void Despawn_Chaser(int bossIndex)
{
	g_NpcInstantKillThink[bossIndex] = null;
}

static Action Timer_InstantKillThink(Handle timer, int bossIndex)
{
	if (NPCGetUniqueID(bossIndex) == -1)
	{
		return Plugin_Stop;
	}

	if (timer != g_NpcInstantKillThink[bossIndex])
	{
		return Plugin_Stop;
	}

	CBaseEntity boss = CBaseEntity(NPCGetEntIndex(bossIndex));
	if (!boss.IsValid())
	{
		return Plugin_Stop;
	}

	float radius = NPCGetInstantKillRadius(bossIndex);

	if (radius < 0.0)
	{
		return Plugin_Stop;
	}

	if (g_SlenderInDeathcam[bossIndex])
	{
		return Plugin_Continue;
	}

	if ((NPCGetFlags(bossIndex) & SFF_MARKEDASFAKE))
	{
		return Plugin_Continue;
	}

	float slenderPos[3];
	boss.GetAbsOrigin(slenderPos);

	bool attackWaiters = !!(NPCGetFlags(bossIndex) & SFF_ATTACKWAITERS);

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	int ref = EntRefToEntIndex(g_SlenderTarget[bossIndex]);
	if (!ref || ref == INVALID_ENT_REFERENCE)
	{
		return Plugin_Continue;
	}
	SF2_BasePlayer target = SF2_BasePlayer(ref);

	if (!target.IsValid || target.IsInDeathCam || target.IsInGhostMode || !target.IsAlive || target.IsProxy)
	{
		return Plugin_Continue;
	}

	if (!attackWaiters && target.IsEliminated)
	{
		return Plugin_Continue;
	}

	float myPos[3];

	target.GetAbsOrigin(myPos);
	myPos[2] += 35.0;
	slenderPos[2] += 35.0;

	if ((GetVectorSquareMagnitude(myPos, slenderPos) <= SquareFloat(radius) &&
		(GetGameTime() - g_SlenderLastKill[bossIndex]) >= NPCGetInstantKillCooldown(bossIndex, difficulty))
		&& !g_SlenderInDeathcam[bossIndex])
	{
		if (target.CanSeeSlender(bossIndex, false, _, !attackWaiters))
		{
			g_SlenderLastKill[bossIndex] = GetGameTime();
			slenderPos[2] -= 35.0;
			target.StartDeathCam(bossIndex, slenderPos);
		}
	}

	return Plugin_Continue;
}

//	So this is how the thought process of the bosses should go.
//	1. Search for enemy; either by sight or by sound.
//		- Any noticeable sounds should be investigated.
//		- Too many sounds will put me in alert mode.
//	2. Alert of an enemy; I saw something or I heard something unusual
//		- Go to the position where I last heard the sound.
//		- Keep on searching until I give up. Then drop back to idle mode.
//	3. Found an enemy! Give chase!
//		- Keep on chasing until enemy is killed or I give up.
//			- Keep a path in memory as long as I still have him in my sights.
//			- If I lose sight or I'm unable to traverse safely, find paths around obstacles and follow memorized path.
//			- If I reach the end of my path and I still don't see him and I still want to pursue him, keep on going in the direction I'm going.

bool IsTargetValidForSlender(SF2_BasePlayer target, bool includeEliminated = false)
{
	if (!target.IsValid)
	{
		return false;
	}

	if (target.IsValid)
	{
		if (!target.IsAlive ||
			target.IsInDeathCam ||
			(!includeEliminated && target.IsEliminated) ||
			target.IsInGhostMode ||
			target.HasEscaped)
		{
			return false;
		}
	}

	return true;
}

SF2_BasePlayer NPCChaserGetClosestPlayer(int slender)
{
	if (!g_Enabled)
	{
		return SF2_INVALID_PLAYER;
	}
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return SF2_INVALID_PLAYER;
	}

	int bossIndex = NPCGetFromEntIndex(slender);
	if (bossIndex == -1)
	{
		return SF2_INVALID_PLAYER;
	}

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	float position[3];
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", position);

	SF2_BasePlayer closestTarget = SF2_INVALID_PLAYER;
	float searchRadius = NPCGetSearchRadius(bossIndex, difficulty);

	for (int i = 1; i <= MaxClients; i++)
	{
		SF2_BasePlayer client = SF2_BasePlayer(i);
		if (!client.IsValid || client.IsInGhostMode || client.IsProxy || !client.IsAlive || client.IsEliminated)
		{
			continue;
		}

		float clientPos[3];
		client.GetAbsOrigin(clientPos);

		float distance = GetVectorSquareMagnitude(position, clientPos);

		if (distance < SquareFloat(searchRadius))
		{
			closestTarget = client;
			searchRadius = distance;
		}
	}

	if (closestTarget.IsValid)
	{
		return closestTarget;
	}

	return SF2_INVALID_PLAYER;
}

bool NPCGetWanderPosition(SF2NPC_Chaser boss)
{
	// We're allowed to move in wander mode. Get a new wandering position and create a path to follow.
	// If the position can't be reached, then just get to the closest area that we can get.
	int difficulty = GetLocalGlobalDifficulty(boss.Index);
	float myPos[3];
	boss.GetAbsOrigin(myPos);
	float wanderRangeMin = NPCChaserGetWanderRangeMin(boss.Index, difficulty);
	float wanderRangeMax = NPCChaserGetWanderRangeMax(boss.Index, difficulty);
	float wanderRange = GetRandomFloat(wanderRangeMin, wanderRangeMax);
	CBaseCombatCharacter npc = CBaseCombatCharacter(boss.EntIndex);
	CNavArea navArea = npc.GetLastKnownArea();
	SurroundingAreasCollector collector = TheNavMesh.CollectSurroundingAreas(navArea, wanderRange);
	int areaCount = collector.Count();
	ArrayList areaArray = new ArrayList(1, areaCount);
	int validAreaCount = 0;
	for (int i = 0; i < areaCount; i++)
	{
		if (collector.Get(i).HasAttributes(NAV_MESH_CROUCH))
		{
			continue;
		}
		areaArray.Set(validAreaCount, i);
		validAreaCount++;
	}

	if (areaArray.Length <= 0)
	{
		return false;
	}
	float wanderPos[3];
	CNavArea wanderArea = collector.Get(areaArray.Get(GetRandomInt(0, validAreaCount - 1)));
	if (wanderArea == NULL_AREA)
	{
		return false;
	}
	wanderArea.GetCenter(wanderPos);

	boss.SetGoalPos(wanderPos);

	g_SlenderNextPathTime[boss.Index] = -1.0; // We're not going to wander around too much, so no need for a time constraint.

	delete collector;
	delete areaArray;
	return true;
}

void NPCChaserUpdateBossAnimation(int bossIndex, int ent, int state, bool spawn = false)
{
	char animation[256];
	float playbackRate, tempFootsteps, cycle, footstepTime, tempDuration, duration;
	bool animationFound = false;
	int index;

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	SF2BossProfileMasterAnimationsData animData;
	GetBossProfileAnimationsData(profile, animData);

	bool clearLayers = GetChaserProfileClearLayersState(profile);

	switch (state)
	{
		case STATE_IDLE:
		{
			if (!spawn)
			{
				animationFound = animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_Idle], difficulty, animation, sizeof(animation), playbackRate, tempDuration, cycle, footstepTime, index);
			}
			else
			{
				animationFound = animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_Spawn], difficulty, animation, sizeof(animation), playbackRate, duration, cycle, tempFootsteps, index);
			}
		}
		case STATE_WANDER:
		{
			if (NPCGetFlags(bossIndex) & SFF_WANDERMOVE)
			{
				if (!g_NpcIsCrawling[bossIndex])
				{
					animationFound = animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_Walk], difficulty, animation, sizeof(animation), playbackRate, tempDuration, cycle, footstepTime, index);
				}
				else
				{
					animationFound = animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_CrawlWalk], difficulty, animation, sizeof(animation), playbackRate, tempDuration, cycle, footstepTime, index);
				}
			}
		}
		case STATE_ALERT:
		{
			if (!g_NpcIsCrawling[bossIndex])
			{
				if (NPCChaserCanUseAlertWalkingAnimation(bossIndex))
				{
					animationFound = animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_WalkAlert], difficulty, animation, sizeof(animation), playbackRate, tempDuration, cycle, footstepTime, index);
				}
				else
				{
					animationFound = animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_Walk], difficulty, animation, sizeof(animation), playbackRate, tempDuration, cycle, footstepTime, index);
				}
			}
			else
			{
				animationFound = animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_CrawlWalk], difficulty, animation, sizeof(animation), playbackRate, tempDuration, cycle, footstepTime, index);
			}
		}
		case STATE_CHASE:
		{
			if (!g_NpcUsesChaseInitialAnimation[bossIndex] &&
			!NPCIsRaging(bossIndex) &&
			!g_NpcUsesHealAnimation[bossIndex] && !g_NpcUseStartFleeAnimation[bossIndex] &&
			!g_NpcUsesCloakStartAnimation[bossIndex] && !g_NpcUsesCloakEndAnimation[bossIndex] && !g_NpcIsCrawling[bossIndex])
			{
				animationFound = animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_Run], difficulty, animation, sizeof(animation), playbackRate, tempDuration, cycle, footstepTime, index);
			}
			else if (g_NpcUsesChaseInitialAnimation[bossIndex])
			{
				animationFound = animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_ChaseInitial], difficulty, animation, sizeof(animation), playbackRate, duration, cycle, tempFootsteps, index);
			}
			else if (NPCIsRaging(bossIndex))
			{
				animationFound = animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_Rage], difficulty, animation, sizeof(animation), playbackRate, duration, cycle, tempFootsteps, index);
			}
			else if (g_NpcIsCrawling[bossIndex] && !g_NpcUsesChaseInitialAnimation[bossIndex] &&
			!g_NpcUsesCloakStartAnimation[bossIndex] && !g_NpcUsesCloakEndAnimation[bossIndex] &&
			!NPCIsRaging(bossIndex))
			{
				animationFound = animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_CrawlRun], difficulty, animation, sizeof(animation), playbackRate, tempDuration, cycle, footstepTime, index);
			}
		}
		case STATE_ATTACK:
		{
			if (!g_NpcUseFireAnimation[bossIndex])
			{
				animationFound = animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_Attack], difficulty, animation, sizeof(animation), playbackRate, tempDuration, cycle, footstepTime, index, NPCGetCurrentAttackIndex(bossIndex));
			}
			else
			{
				animationFound = animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_Shoot], difficulty, animation, sizeof(animation), playbackRate, tempDuration, cycle, footstepTime, index, NPCGetCurrentAttackIndex(bossIndex));
			}
		}
		case STATE_STUN:
		{
			animationFound = animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_Stun], difficulty, animation, sizeof(animation), playbackRate, duration, cycle, footstepTime, index);
		}
		case STATE_DEATHCAM:
		{
			animationFound = animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_DeathCam], difficulty, animation, sizeof(animation), playbackRate, tempDuration, cycle, tempFootsteps, index);
		}
	}

	if (NPCIsRaging(bossIndex))
	{
		animationFound = animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_Rage], difficulty, animation, sizeof(animation), playbackRate, duration, cycle, tempFootsteps, index);
	}
	else if (g_NpcUseStartFleeAnimation[bossIndex])
	{
		animationFound = animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_FleeInitial], difficulty, animation, sizeof(animation), playbackRate, duration, cycle, tempFootsteps, index);
	}
	else if (g_NpcUsesHealAnimation[bossIndex])
	{
		animationFound = animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_Heal], difficulty, animation, sizeof(animation), playbackRate, tempDuration, cycle, tempFootsteps, index);
	}

	if (playbackRate < -12.0)
	{
		playbackRate = -12.0;
	}
	if (playbackRate > 12.0)
	{
		playbackRate = 12.0;
	}

	if (animationFound && animation[0] != '\0')
	{
		Action action = Plugin_Continue;
		Call_StartForward(g_OnBossAnimationUpdateFwd);
		Call_PushCell(bossIndex);
		Call_Finish(action);
		if (action != Plugin_Handled)
		{
			g_SlenderFootstepTime[bossIndex] = footstepTime;
			g_SlenderAnimationDuration[bossIndex] = duration;
			g_NpcCurrentAnimationSequencePlaybackRate[bossIndex] = playbackRate;
			g_NpcCurrentAnimationSequence[bossIndex] = EntitySetAnimation(ent, animation, playbackRate, _, cycle);
			g_NpcCurrentAnimationSequenceName[bossIndex] = animation;
			EntitySetAnimation(ent, animation, playbackRate, _, cycle); //Fix an issue where an anim could start on the wrong frame.
			if (g_NpcCurrentAnimationSequence[bossIndex] <= -1)
			{
				g_NpcCurrentAnimationSequence[bossIndex] = 0;
			}
			bool animationLoop = (state == STATE_IDLE || state == STATE_ALERT ||
			(state == STATE_CHASE && !NPCIsRaging(bossIndex)
			&& !g_NpcUseStartFleeAnimation[bossIndex] && !g_NpcUsesHealAnimation[bossIndex] && !g_NpcUsesCloakStartAnimation[bossIndex] && !g_NpcUsesCloakEndAnimation[bossIndex])
			|| state == STATE_WANDER);
			if (state == STATE_ATTACK && NPCChaserGetAttackWhileRunningState(bossIndex, NPCGetCurrentAttackIndex(bossIndex), difficulty))
			{
				animationLoop = !!GetEntProp(ent, Prop_Data, "m_bSequenceLoops");
			}
			if (state == STATE_CHASE && g_NpcUsesChaseInitialAnimation[bossIndex])
			{
				animationLoop = !!GetEntProp(ent, Prop_Data, "m_bSequenceLoops");
			}
			SetEntProp(ent, Prop_Data, "m_bSequenceLoops", animationLoop);
		}
	}
	if (state == STATE_ATTACK && NPCChaserGetAttackGestureState(bossIndex, NPCGetCurrentAttackIndex(bossIndex)))
	{
		float gestureCycle;
		animationFound = animData.GetGesture(NPCGetCurrentAttackIndex(bossIndex), g_SlenderAnimationsList[SF2BossAnimation_Attack], difficulty, animation, sizeof(animation), playbackRate, cycle);
		if (animationFound && animation[0] != '\0')
		{
			CBaseCombatCharacter overlay = CBaseCombatCharacter(ent);
			int gesture = overlay.LookupSequence(animation);
			if (gesture != -1)
			{
				float gestureDuration = overlay.SequenceDuration(gesture);
				int layer = overlay.AddLayeredSequence(gesture, 1);
				overlay.SetLayerDuration(layer, gestureDuration);
				overlay.SetLayerPlaybackRate(layer, playbackRate);
				overlay.SetLayerCycle(layer, gestureCycle);
				overlay.SetLayerAutokill(layer, true);
			}
		}
	}
	if (!g_IsSlenderAttacking[bossIndex] && clearLayers)
	{
		CBaseNPC_RemoveAllLayers(ent);
	}
}

void SlenderAlertAllValidBosses(int bossIndex, int target = -1, int bestTarget = -1)
{
	int slender = NPCGetEntIndex(bossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return;
	}
	float myPos[3];
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", myPos);
	int difficulty = GetLocalGlobalDifficulty(bossIndex);
	if (NPCHasAttribute(bossIndex, SF2Attribute_AlertCopies))
	{
		for (int bossCheck = 0; bossCheck < MAX_BOSSES; bossCheck++)
		{
			if (NPCGetUniqueID(bossCheck) != -1 && !g_SlenderSpawning[bossCheck] &&
			g_SlenderState[bossCheck] != STATE_ATTACK && g_SlenderState[bossCheck] != STATE_STUN && g_SlenderState[bossCheck] != STATE_CHASE &&
			(g_SlenderCopyMaster[bossCheck] == bossIndex || g_SlenderCopyMaster[bossIndex] == bossCheck ||
			(g_SlenderCopyMaster[bossIndex] == g_SlenderCopyMaster[bossCheck] && g_SlenderCopyMaster[bossIndex] != -1 && g_SlenderCopyMaster[bossCheck] != -1)))
			{
				int bossEnt = NPCGetEntIndex(bossCheck);
				if (!bossEnt || bossEnt == INVALID_ENT_REFERENCE)
				{
					continue;
				}

				float copyPos[3];
				GetEntPropVector(bossEnt, Prop_Data, "m_vecAbsOrigin", copyPos);

				float dist1 = GetVectorSquareMagnitude(copyPos, myPos);

				if ((dist1 <= SquareFloat(NPCGetSearchRadius(bossCheck, difficulty)) || dist1 <= SquareFloat(NPCGetHearingRadius(bossCheck, difficulty))))
				{
					if (IsValidClient(target))
					{
						g_SlenderTarget[bossCheck] = EntIndexToEntRef(target);
						GetClientAbsOrigin(target, g_SlenderGoalPos[bossCheck]);
					}
					else if (IsValidClient(bestTarget))
					{
						g_SlenderTarget[bossCheck] = EntIndexToEntRef(bestTarget);
						GetClientAbsOrigin(bestTarget, g_SlenderGoalPos[bossCheck]);
					}
					g_SlenderState[bossCheck] = STATE_CHASE;
					NPCChaserUpdateBossAnimation(bossCheck, bossEnt, STATE_CHASE);
					g_NpcCopyAlerted[bossCheck] = true;
					g_SlenderTimeUntilNoPersistence[bossCheck] = GetGameTime() + NPCChaserGetChaseDuration(bossCheck, difficulty);
					g_SlenderTimeUntilAlert[bossCheck] = GetGameTime() + NPCChaserGetChaseDuration(bossCheck, difficulty);
					SlenderPerformVoice(bossCheck, _, SF2BossSound_ChaseInitial);
					if (NPCChaserCanUseChaseInitialAnimation(bossCheck) && !g_NpcUsesChaseInitialAnimation[bossCheck] && !SF_IsSlaughterRunMap())
					{
						int copySlender = NPCGetEntIndex(bossCheck);
						if (copySlender && copySlender != INVALID_ENT_REFERENCE && g_SlenderChaseInitialTimer[bossCheck] == null && (g_NpcChaseOnLookTarget[bossCheck] == null || g_NpcChaseOnLookTarget[bossCheck].Length <= 0))
						{
							CBaseNPC npc = TheNPCs.FindNPCByEntIndex(copySlender);
							g_NpcUsesChaseInitialAnimation[bossCheck] = true;
							if (npc != INVALID_NPC)
							{
								npc.flWalkSpeed = 0.0;
								npc.flRunSpeed = 0.0;
							}
							NPCChaserUpdateBossAnimation(bossCheck, copySlender, g_SlenderState[bossCheck]);
							char profile[SF2_MAX_PROFILE_NAME_LENGTH];
							NPCGetProfile(bossCheck, profile, sizeof(profile));
							g_SlenderChaseInitialTimer[bossCheck] = CreateTimer(g_SlenderAnimationDuration[bossCheck], Timer_SlenderChaseInitialTimer, EntIndexToEntRef(copySlender), TIMER_FLAG_NO_MAPCHANGE);
						}
					}
				}
			}
		}
	}
	if (NPCHasAttribute(bossIndex, SF2Attribute_AlertCompanions))
	{
		for (int bossCheck = 0; bossCheck < MAX_BOSSES; bossCheck++)
		{
			if (NPCGetUniqueID(bossCheck) != -1 && !g_SlenderSpawning[bossCheck] &&
			g_SlenderState[bossCheck] != STATE_ATTACK && g_SlenderState[bossCheck] != STATE_STUN && g_SlenderState[bossCheck] != STATE_CHASE &&
			(g_SlenderCompanionMaster[bossCheck] == bossIndex || g_SlenderCompanionMaster[bossIndex] == bossCheck ||
			((g_SlenderCompanionMaster[bossIndex] == g_SlenderCompanionMaster[bossCheck] && g_SlenderCompanionMaster[bossIndex] != -1 && g_SlenderCompanionMaster[bossCheck] != -1))))
			{
				int bossEnt = NPCGetEntIndex(bossCheck);
				if (!bossEnt || bossEnt == INVALID_ENT_REFERENCE)
				{
					continue;
				}

				float copyPos[3];
				GetEntPropVector(bossEnt, Prop_Data, "m_vecAbsOrigin", copyPos);

				float dist1 = GetVectorSquareMagnitude(copyPos, myPos);

				if (dist1 <= SquareFloat(NPCGetSearchRadius(bossCheck, difficulty)) || dist1 <= SquareFloat(NPCGetHearingRadius(bossCheck, difficulty)))
				{
					if (IsValidClient(target))
					{
						g_SlenderTarget[bossCheck] = EntIndexToEntRef(target);
						GetClientAbsOrigin(target, g_SlenderGoalPos[bossCheck]);
					}
					else if (IsValidClient(bestTarget))
					{
						g_SlenderTarget[bossCheck] = EntIndexToEntRef(bestTarget);
						GetClientAbsOrigin(bestTarget, g_SlenderGoalPos[bossCheck]);
					}
					g_SlenderState[bossCheck] = STATE_CHASE;
					NPCChaserUpdateBossAnimation(bossCheck, bossEnt, STATE_CHASE);
					g_NpcCopyAlerted[bossCheck] = true;
					g_SlenderTimeUntilNoPersistence[bossCheck] = GetGameTime() + NPCChaserGetChaseDuration(bossCheck, difficulty);
					g_SlenderTimeUntilAlert[bossCheck] = GetGameTime() + NPCChaserGetChaseDuration(bossCheck, difficulty);
					SlenderPerformVoice(bossCheck, _, SF2BossSound_ChaseInitial);
					if (NPCChaserCanUseChaseInitialAnimation(bossCheck) && !g_NpcUsesChaseInitialAnimation[bossCheck] && !SF_IsSlaughterRunMap())
					{
						int copySlender = NPCGetEntIndex(bossCheck);
						if (copySlender && copySlender != INVALID_ENT_REFERENCE && g_SlenderChaseInitialTimer[bossCheck] == null && (g_NpcChaseOnLookTarget[bossCheck] == null || g_NpcChaseOnLookTarget[bossCheck].Length <= 0))
						{
							CBaseNPC npc = TheNPCs.FindNPCByEntIndex(copySlender);
							g_NpcUsesChaseInitialAnimation[bossCheck] = true;
							if (npc != INVALID_NPC)
							{
								npc.flWalkSpeed = 0.0;
								npc.flRunSpeed = 0.0;
							}
							NPCChaserUpdateBossAnimation(bossCheck, copySlender, g_SlenderState[bossCheck]);
							char profile[SF2_MAX_PROFILE_NAME_LENGTH];
							NPCGetProfile(bossCheck, profile, sizeof(profile));
							g_SlenderChaseInitialTimer[bossCheck] = CreateTimer(g_SlenderAnimationDuration[bossCheck], Timer_SlenderChaseInitialTimer, EntIndexToEntRef(copySlender), TIMER_FLAG_NO_MAPCHANGE);
						}
					}
				}
			}
		}
	}
}

Action Timer_SlenderChaseInitialTimer(Handle timer, any entref)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	int bossIndex = NPCGetFromEntIndex(slender);
	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}

	if (timer != g_SlenderChaseInitialTimer[bossIndex])
	{
		return Plugin_Stop;
	}

	if (!g_NpcUsesChaseInitialAnimation[bossIndex])
	{
		return Plugin_Stop;
	}

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();

	int oldState = g_SlenderState[bossIndex];
	int state = oldState;

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	float originalSpeed;

	if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) && !g_Renevant90sEffect)
	{
		originalSpeed = NPCGetSpeed(bossIndex, difficulty) + NPCGetAddSpeed(bossIndex);
	}
	else
	{
		originalSpeed = NPCGetSpeed(bossIndex, difficulty) + NPCGetAddSpeed(bossIndex);
		if ((originalSpeed < 520.0))
		{
			originalSpeed = 520.0;
		}
	}
	float speed = originalSpeed;
	g_SlenderCalculatedSpeed[bossIndex] = speed;

	g_NpcUsesChaseInitialAnimation[bossIndex] = false;
	g_LastStuckTime[bossIndex] = 0.0;
	loco.ClearStuckStatus();
	if (state != STATE_ATTACK)
	{
		NPCChaserUpdateBossAnimation(bossIndex, slender, state);
	}
	g_SlenderChaseInitialTimer[bossIndex] = null;
	return Plugin_Stop;
}

Action Timer_SlenderRageOneTimer(Handle timer, any entref)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	int bossIndex = NPCGetFromEntIndex(slender);
	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}

	if (timer != g_SlenderRage1Timer[bossIndex])
	{
		return Plugin_Stop;
	}

	if (!g_NpcUsesRageAnimation[bossIndex][0])
	{
		return Plugin_Stop;
	}

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();

	int oldState = g_SlenderState[bossIndex];
	int state = oldState;

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	float originalSpeed;

	if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) && !g_Renevant90sEffect)
	{
		originalSpeed = NPCGetSpeed(bossIndex, difficulty) + NPCGetAddSpeed(bossIndex);
	}
	else
	{
		originalSpeed = NPCGetSpeed(bossIndex, difficulty) + NPCGetAddSpeed(bossIndex);
		if ((originalSpeed < 520.0))
		{
			originalSpeed = 520.0;
		}
	}
	float speed = originalSpeed;
	g_SlenderCalculatedSpeed[bossIndex] = speed;

	g_NpcUsesRageAnimation[bossIndex][0] = false;
	g_LastStuckTime[bossIndex] = 0.0;
	loco.ClearStuckStatus();
	if (state != STATE_ATTACK)
	{
		NPCChaserUpdateBossAnimation(bossIndex, slender, state);
	}
	return Plugin_Stop;
}

Action Timer_SlenderRageTwoTimer(Handle timer, any entref)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	int bossIndex = NPCGetFromEntIndex(slender);
	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}

	if (timer != g_SlenderRage2Timer[bossIndex])
	{
		return Plugin_Stop;
	}

	if (!g_NpcUsesRageAnimation[bossIndex][1])
	{
		return Plugin_Stop;
	}

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();

	int oldState = g_SlenderState[bossIndex];
	int state = oldState;

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	float originalSpeed;

	if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) && !g_Renevant90sEffect)
	{
		originalSpeed = NPCGetSpeed(bossIndex, difficulty) + NPCGetAddSpeed(bossIndex);
	}
	else
	{
		originalSpeed = NPCGetSpeed(bossIndex, difficulty) + NPCGetAddSpeed(bossIndex);
		if ((originalSpeed < 520.0))
		{
			originalSpeed = 520.0;
		}
	}
	float speed = originalSpeed;
	g_SlenderCalculatedSpeed[bossIndex] = speed;

	g_NpcUsesRageAnimation[bossIndex][1] = false;
	g_LastStuckTime[bossIndex] = 0.0;
	loco.ClearStuckStatus();
	if (state != STATE_ATTACK)
	{
		NPCChaserUpdateBossAnimation(bossIndex, slender, state);
	}
	return Plugin_Stop;
}

Action Timer_SlenderRageThreeTimer(Handle timer, any entref)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	int bossIndex = NPCGetFromEntIndex(slender);
	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}

	if (timer != g_SlenderRage3Timer[bossIndex])
	{
		return Plugin_Stop;
	}

	if (!g_NpcUsesRageAnimation[bossIndex][2])
	{
		return Plugin_Stop;
	}

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();

	int oldState = g_SlenderState[bossIndex];
	int state = oldState;

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	float originalSpeed;

	if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) && !g_Renevant90sEffect)
	{
		originalSpeed = NPCGetSpeed(bossIndex, difficulty) + NPCGetAddSpeed(bossIndex);
	}
	else
	{
		originalSpeed = NPCGetSpeed(bossIndex, difficulty) + NPCGetAddSpeed(bossIndex);
		if ((originalSpeed < 520.0))
		{
			originalSpeed = 520.0;
		}
	}
	float speed = originalSpeed;
	g_SlenderCalculatedSpeed[bossIndex] = speed;

	g_NpcUsesRageAnimation[bossIndex][2] = false;
	g_LastStuckTime[bossIndex] = 0.0;
	loco.ClearStuckStatus();
	if (state != STATE_ATTACK)
	{
		NPCChaserUpdateBossAnimation(bossIndex, slender, state);
	}
	return Plugin_Stop;
}

Action Timer_SlenderSpawnTimer(Handle timer, any entref)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	int bossIndex = NPCGetFromEntIndex(slender);
	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}

	if (timer != g_SlenderSpawnTimer[bossIndex])
	{
		return Plugin_Stop;
	}

	if (!g_SlenderSpawning[bossIndex])
	{
		return Plugin_Stop;
	}

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();

	SDKHook(slender, SDKHook_Think, SlenderChaseBossProcessMovement);
	g_SlenderEntityThink[bossIndex] = CreateTimer(BOSS_THINKRATE, Timer_SlenderChaseBossThink, entref, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	g_SlenderSpawning[bossIndex] = false;
	g_LastStuckTime[bossIndex] = 0.0;
	loco.ClearStuckStatus();
	NPCChaserUpdateBossAnimation(bossIndex, slender, STATE_IDLE);
	Call_StartForward(g_OnBossFinishSpawningFwd);
	Call_PushCell(bossIndex);
	Call_Finish();
	return Plugin_Stop;
}

Action Timer_SlenderHealAnimationTimer(Handle timer, any entref)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	int bossIndex = NPCGetFromEntIndex(slender);
	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}

	if (timer != g_SlenderHealTimer[bossIndex])
	{
		return Plugin_Stop;
	}

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();

	int oldState = g_SlenderState[bossIndex];
	int state = oldState;

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	float originalSpeed;

	if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) && !g_Renevant90sEffect)
	{
		originalSpeed = NPCGetSpeed(bossIndex, difficulty) + NPCGetAddSpeed(bossIndex);
	}
	else
	{
		originalSpeed = NPCGetSpeed(bossIndex, difficulty) + NPCGetAddSpeed(bossIndex);
		if ((originalSpeed < 520.0))
		{
			originalSpeed = 520.0;
		}
	}
	float speed = originalSpeed;
	g_SlenderCalculatedSpeed[bossIndex] = speed;

	g_NpcSetHealDestination[bossIndex] = false;
	g_NpcIsRunningToHeal[bossIndex] = false;
	g_LastStuckTime[bossIndex] = 0.0;
	loco.ClearStuckStatus();
	g_NpcUseStartFleeAnimation[bossIndex] = false;
	g_NpcUsesHealAnimation[bossIndex] = false;
	g_NpcIsHealing[bossIndex] = false;
	g_NpcFleeHealTimer[bossIndex] = GetGameTime();
	g_NpcHealCount[bossIndex] = 0;
	g_NpcSelfHealStage[bossIndex]++;
	NPCChaserUpdateBossAnimation(bossIndex, slender, state);
	g_SlenderHealDelayTimer[bossIndex] = null;
	g_SlenderStartFleeTimer[bossIndex] = null;
	g_SlenderHealTimer[bossIndex] = null;
	g_BossPathFollower[bossIndex].Invalidate();
	return Plugin_Stop;
}

Action Timer_SlenderHealDelayTimer(Handle timer, any entref)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	int bossIndex = NPCGetFromEntIndex(slender);
	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}

	if (timer != g_SlenderHealDelayTimer[bossIndex])
	{
		return Plugin_Stop;
	}

	SlenderPerformVoice(bossIndex, _, SF2BossSound_SelfHeal);

	g_NpcHealCount[bossIndex] = 0;

	g_SlenderHealEventTimer[bossIndex] = CreateTimer(0.05, Timer_SlenderHealEventTimer, EntIndexToEntRef(slender), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	return Plugin_Stop;
}

Action Timer_SlenderHealEventTimer(Handle timer, any entref)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	int bossIndex = NPCGetFromEntIndex(slender);
	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}

	if (timer != g_SlenderHealEventTimer[bossIndex])
	{
		return Plugin_Stop;
	}

	if (!g_NpcIsHealing[bossIndex])
	{
		return Plugin_Stop;
	}

	if (g_SlenderState[bossIndex] == STATE_STUN)
	{
		return Plugin_Stop;
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	float checkPercentage;
	switch (g_NpcSelfHealStage[bossIndex])
	{
		case 0:
		{
			checkPercentage = NPCChaserGetSelfHealPercentageOne(bossIndex) * NPCChaserGetStunInitialHealth(bossIndex);
		}
		case 1:
		{
			checkPercentage = NPCChaserGetSelfHealPercentageTwo(bossIndex) * NPCChaserGetStunInitialHealth(bossIndex);
		}
		case 2, 3:
		{
			checkPercentage = NPCChaserGetSelfHealPercentageThree(bossIndex) * NPCChaserGetStunInitialHealth(bossIndex);
		}
	}
	float regenHealth = checkPercentage / 10.0;

	if (NPCChaserGetStunHealth(bossIndex) + regenHealth < NPCChaserGetStunInitialHealth(bossIndex))
	{
		NPCChaserAddStunHealth(bossIndex, regenHealth);
		if (NPCGetHealthbarState(bossIndex))
		{
			UpdateHealthBar(bossIndex);
		}
		g_NpcHealCount[bossIndex]++;
	}
	else
	{
		float addRemainHealth = NPCChaserGetStunInitialHealth(bossIndex) - NPCChaserGetStunHealth(bossIndex);
		NPCChaserAddStunHealth(bossIndex, addRemainHealth);
		if (NPCGetHealthbarState(bossIndex))
		{
			UpdateHealthBar(bossIndex);
		}
		g_NpcIsHealing[bossIndex] = false;
		g_NpcHealCount[bossIndex] = 0;
		return Plugin_Stop;
	}

	if (g_NpcHealCount[bossIndex] >= 10)
	{
		g_NpcIsHealing[bossIndex] = false;
		g_NpcHealCount[bossIndex] = 0;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

Action Timer_SlenderFleeAnimationTimer(Handle timer, any entref)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	int bossIndex = NPCGetFromEntIndex(slender);
	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}

	if (timer != g_SlenderStartFleeTimer[bossIndex])
	{
		return Plugin_Stop;
	}

	if (!g_NpcUseStartFleeAnimation[bossIndex])
	{
		return Plugin_Stop;
	}

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();

	int oldState = g_SlenderState[bossIndex];
	int state = oldState;

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	float originalSpeed;

	if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) && !g_Renevant90sEffect)
	{
		originalSpeed = NPCGetSpeed(bossIndex, difficulty) + NPCGetAddSpeed(bossIndex);
	}
	else
	{
		originalSpeed = NPCGetSpeed(bossIndex, difficulty) + NPCGetAddSpeed(bossIndex);
		if ((originalSpeed < 520.0))
		{
			originalSpeed = 520.0;
		}
	}
	float speed = originalSpeed;
	g_SlenderCalculatedSpeed[bossIndex] = speed;
	g_SlenderTarget[bossIndex] = INVALID_ENT_REFERENCE;

	g_NpcUseStartFleeAnimation[bossIndex] = false;
	g_NpcIsRunningToHeal[bossIndex] = true;
	g_LastStuckTime[bossIndex] = 0.0;
	loco.ClearStuckStatus();
	NPCChaserUpdateBossAnimation(bossIndex, slender, state);

	return Plugin_Stop;
}

void SlenderDoDamageEffects(int bossIndex, int attackIndex, SF2_BasePlayer client)
{
	if (!client.IsValid)
	{
		return;
	}
	int difficulty = GetLocalGlobalDifficulty(bossIndex);
	int slender = NPCGetEntIndex(bossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return;
	}
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));
	float flMyEyePos[3];
	NPCGetEyePosition(bossIndex, flMyEyePos);

	if (NPCChaserUseRandomAdvancedDamageEffects(bossIndex))
	{
		char indexes[8], allowedIndexes[88], allowedIndexesList[33][3];
		char currentIndex[2];
		int damageIndexes = NPCChaserRandomEffectIndexes(bossIndex);
		GetChaserProfileRandomAttackIndexesString(profile, allowedIndexes, sizeof(allowedIndexes));
		FormatEx(indexes, sizeof(indexes), "%d", damageIndexes);
		FormatEx(currentIndex, sizeof(currentIndex), "%d", attackIndex + 1);

		int count = ExplodeString(allowedIndexes, " ", allowedIndexesList, 33, 3);
		if (count > 1)
		{
			for (int i = 0; i < count && i < NPCChaserGetAttackCount(bossIndex); i++)
			{
				int forIndex = StringToInt(allowedIndexesList[i]);
				if (forIndex == attackIndex + 1 && NPCChaserRandomEffectDuration(bossIndex, difficulty) > 0.0)
				{
					int randomEffect = GetRandomInt(0, 6);
					switch (randomEffect)
					{
						case 0:
						{
							client.ChangeCondition(TFCond_Jarated, _, NPCChaserRandomEffectDuration(bossIndex, difficulty));
						}
						case 1:
						{
							client.ChangeCondition(TFCond_Milked, _, NPCChaserRandomEffectDuration(bossIndex, difficulty));
						}
						case 2:
						{
							client.ChangeCondition(TFCond_Gas, _, NPCChaserRandomEffectDuration(bossIndex, difficulty));
						}
						case 3:
						{
							client.ChangeCondition(TFCond_MarkedForDeath, _, NPCChaserRandomEffectDuration(bossIndex, difficulty));
						}
						case 4:
						{
							if (!client.InCondition(TFCond_Bleeding))
							{
								client.Bleed(true, _, NPCChaserRandomEffectDuration(bossIndex, difficulty));
							}
						}
						case 5:
						{
							client.Ignite(true, _, NPCChaserRandomEffectDuration(bossIndex, difficulty));
						}
						case 6:
						{
							switch (NPCChaserRandomEffectStunType(bossIndex))
							{
								case 1:
								{
									client.Stun(NPCChaserRandomEffectDuration(bossIndex, difficulty), NPCChaserRandomEffectSlowdown(bossIndex, difficulty), TF_STUNFLAG_SLOWDOWN);
								}
								case 2:
								{
									client.Stun(NPCChaserRandomEffectDuration(bossIndex, difficulty), NPCChaserRandomEffectSlowdown(bossIndex, difficulty), TF_STUNFLAGS_LOSERSTATE);
								}
								case 3:
								{
									client.Stun(NPCChaserRandomEffectDuration(bossIndex, difficulty), NPCChaserRandomEffectSlowdown(bossIndex, difficulty), TF_STUNFLAG_BONKSTUCK|TF_STUNFLAG_NOSOUNDOREFFECT);
								}
								case 4:
								{
									client.Stun(NPCChaserRandomEffectDuration(bossIndex, difficulty), NPCChaserRandomEffectSlowdown(bossIndex, difficulty), TF_STUNFLAGS_GHOSTSCARE);
								}
							}
						}
					}
					break;
				}
			}
		}
		else //Legacy support
		{
			char number = currentIndex[0];
			int attackNumber = 0;
			if (FindCharInString(indexes, number) != -1)
			{
				attackNumber += attackIndex + 1;
			}
			if (indexes[0] != '\0' && currentIndex[0] != '\0' && attackNumber != -1)
			{
				int currentAtkIndex = StringToInt(currentIndex);
				if (attackNumber == currentAtkIndex && NPCChaserRandomEffectDuration(bossIndex, difficulty) > 0.0)
				{
					int randomEffect = GetRandomInt(0, 6);
					switch (randomEffect)
					{
						case 0:
						{
							client.ChangeCondition(TFCond_Jarated, _, NPCChaserRandomEffectDuration(bossIndex, difficulty));
						}
						case 1:
						{
							client.ChangeCondition(TFCond_Milked, _, NPCChaserRandomEffectDuration(bossIndex, difficulty));
						}
						case 2:
						{
							client.ChangeCondition(TFCond_Gas, _, NPCChaserRandomEffectDuration(bossIndex, difficulty));
						}
						case 3:
						{
							client.ChangeCondition(TFCond_MarkedForDeath, _, NPCChaserRandomEffectDuration(bossIndex, difficulty));
						}
						case 4:
						{
							if (!client.InCondition(TFCond_Bleeding))
							{
								client.Bleed(true, _, NPCChaserRandomEffectDuration(bossIndex, difficulty));
							}
						}
						case 5:
						{
							client.Ignite(true, _, NPCChaserRandomEffectDuration(bossIndex, difficulty));
						}
						case 6:
						{
							switch (NPCChaserRandomEffectStunType(bossIndex))
							{
								case 1:
								{
									client.Stun(NPCChaserRandomEffectDuration(bossIndex, difficulty), NPCChaserRandomEffectSlowdown(bossIndex, difficulty), TF_STUNFLAG_SLOWDOWN);
								}
								case 2:
								{
									client.Stun(NPCChaserRandomEffectDuration(bossIndex, difficulty), NPCChaserRandomEffectSlowdown(bossIndex, difficulty), TF_STUNFLAGS_LOSERSTATE);
								}
								case 3:
								{
									client.Stun(NPCChaserRandomEffectDuration(bossIndex, difficulty), NPCChaserRandomEffectSlowdown(bossIndex, difficulty), TF_STUNFLAG_BONKSTUCK|TF_STUNFLAG_NOSOUNDOREFFECT);
								}
								case 4:
								{
									client.Stun(NPCChaserRandomEffectDuration(bossIndex, difficulty), NPCChaserRandomEffectSlowdown(bossIndex, difficulty), TF_STUNFLAGS_GHOSTSCARE);
								}
							}
						}
					}
				}
			}
		}
	}
	if (NPCChaserJaratePlayerOnHit(bossIndex))
	{
		char indexes[8], allowedIndexes[88], allowedIndexesList[33][3];
		char currentIndex[2];
		int damageIndexes = NPCChaserGetJarateAttackIndexes(bossIndex);
		GetChaserProfileJarateAttackIndexesString(profile, allowedIndexes, sizeof(allowedIndexes));
		FormatEx(indexes, sizeof(indexes), "%d", damageIndexes);
		FormatEx(currentIndex, sizeof(currentIndex), "%d", attackIndex + 1);

		int count = ExplodeString(allowedIndexes, " ", allowedIndexesList, 33, 3);
		if (count > 1)
		{
			for (int i = 0; i < count && i < NPCChaserGetAttackCount(bossIndex); i++)
			{
				int forIndex = StringToInt(allowedIndexesList[i]);
				if (forIndex == attackIndex + 1 && NPCChaserGetJarateDuration(bossIndex, difficulty) > 0.0)
				{
					GetChaserProfileJarateParticle(profile, jaratePlayerParticle, sizeof(jaratePlayerParticle));
					if (jaratePlayerParticle[0] == '\0')
					{
						jaratePlayerParticle = JARATE_PARTICLE;
					}
					if (NPCChaserAttachDamageParticle(bossIndex))
					{
						if (NPCChaserGetJarateBeamParticle(bossIndex))
						{
							SlenderCreateParticleBeamClient(bossIndex, jaratePlayerParticle, 35.0, client);
						}
						else
						{
							SlenderCreateParticleAttach(bossIndex, jaratePlayerParticle, 35.0, client);
						}
					}
					else
					{
						SlenderCreateParticle(bossIndex, jaratePlayerParticle, 35.0);
					}
					if (g_SlenderJarateHitSound[bossIndex][0] != '\0') //No sound, what?
					{
						EmitSoundToAll(g_SlenderJarateHitSound[bossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
					}
					client.ChangeCondition(TFCond_Jarated, _, NPCChaserGetJarateDuration(bossIndex, difficulty));
					break;
				}
			}
		}
		else //Legacy support
		{
			char number = currentIndex[0];
			int attackNumber = 0;
			if (FindCharInString(indexes, number) != -1)
			{
				attackNumber += attackIndex + 1;
			}
			if (indexes[0] != '\0' && currentIndex[0] != '\0' && attackNumber != -1)
			{
				int currentAtkIndex = StringToInt(currentIndex);
				if (attackNumber == currentAtkIndex && NPCChaserGetJarateDuration(bossIndex, difficulty) > 0.0)
				{
					GetChaserProfileJarateParticle(profile, jaratePlayerParticle, sizeof(jaratePlayerParticle));
					if (jaratePlayerParticle[0] == '\0')
					{
						jaratePlayerParticle = JARATE_PARTICLE;
					}
					if (NPCChaserAttachDamageParticle(bossIndex))
					{
						if (NPCChaserGetJarateBeamParticle(bossIndex))
						{
							SlenderCreateParticleBeamClient(bossIndex, jaratePlayerParticle, 35.0, client);
						}
						else
						{
							SlenderCreateParticleAttach(bossIndex, jaratePlayerParticle, 35.0, client);
						}
					}
					else
					{
						SlenderCreateParticle(bossIndex, jaratePlayerParticle, 35.0);
					}
					if (g_SlenderJarateHitSound[bossIndex][0] != '\0') //No sound, what?
					{
						EmitSoundToAll(g_SlenderJarateHitSound[bossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
					}
					client.ChangeCondition(TFCond_Jarated, _, NPCChaserGetJarateDuration(bossIndex, difficulty));
				}
			}
		}
	}
	if (NPCChaserMilkPlayerOnHit(bossIndex))
	{
		char indexes[8], allowedIndexes[88], allowedIndexesList[33][3];
		char currentIndex[2];
		int damageIndexes = NPCChaserGetMilkAttackIndexes(bossIndex);
		GetChaserProfileMilkAttackIndexesString(profile, allowedIndexes, sizeof(allowedIndexes));
		FormatEx(indexes, sizeof(indexes), "%d", damageIndexes);
		FormatEx(currentIndex, sizeof(currentIndex), "%d", attackIndex + 1);

		int count = ExplodeString(allowedIndexes, " ", allowedIndexesList, 33, 3);
		if (count > 1)
		{
			for (int i = 0; i < count && i < NPCChaserGetAttackCount(bossIndex); i++)
			{
				int forIndex = StringToInt(allowedIndexesList[i]);
				if (forIndex == attackIndex + 1 && NPCChaserGetMilkDuration(bossIndex, difficulty) > 0.0)
				{
					GetChaserProfileMilkParticle(profile, milkPlayerParticle, sizeof(milkPlayerParticle));
					if (milkPlayerParticle[0] == '\0')
					{
						milkPlayerParticle = MILK_PARTICLE;
					}
					if (NPCChaserAttachDamageParticle(bossIndex))
					{
						if (NPCChaserGetMilkBeamParticle(bossIndex))
						{
							SlenderCreateParticleBeamClient(bossIndex, milkPlayerParticle, 35.0, client);
						}
						else
						{
							SlenderCreateParticleAttach(bossIndex, milkPlayerParticle, 35.0, client);
						}
					}
					else
					{
						SlenderCreateParticle(bossIndex, milkPlayerParticle, 55.0);
					}
					if (g_SlenderMilkHitSound[bossIndex][0] != '\0') //No sound, what?
					{
						EmitSoundToAll(g_SlenderMilkHitSound[bossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
					}
					client.ChangeCondition(TFCond_Milked, _, NPCChaserGetMilkDuration(bossIndex, difficulty));
					break;
				}
			}
		}
		else //Legacy support
		{
			char number = currentIndex[0];
			int attackNumber = 0;
			if (FindCharInString(indexes, number) != -1)
			{
				attackNumber += attackIndex + 1;
			}
			if (indexes[0] != '\0' && currentIndex[0] != '\0' && attackNumber != -1)
			{
				int currentAtkIndex = StringToInt(currentIndex);
				if (attackNumber == currentAtkIndex && NPCChaserGetMilkDuration(bossIndex, difficulty) > 0.0)
				{
					GetChaserProfileMilkParticle(profile, milkPlayerParticle, sizeof(milkPlayerParticle));
					if (milkPlayerParticle[0] == '\0')
					{
						milkPlayerParticle = MILK_PARTICLE;
					}
					if (NPCChaserAttachDamageParticle(bossIndex))
					{
						if (NPCChaserGetMilkBeamParticle(bossIndex))
						{
							SlenderCreateParticleBeamClient(bossIndex, milkPlayerParticle, 35.0, client);
						}
						else
						{
							SlenderCreateParticleAttach(bossIndex, milkPlayerParticle, 35.0, client);
						}
					}
					else
					{
						SlenderCreateParticle(bossIndex, milkPlayerParticle, 55.0);
					}
					if (g_SlenderMilkHitSound[bossIndex][0] != '\0') //No sound, what?
					{
						EmitSoundToAll(g_SlenderMilkHitSound[bossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
					}
					client.ChangeCondition(TFCond_Milked, _, NPCChaserGetMilkDuration(bossIndex, difficulty));
				}
			}
		}
	}
	if (NPCChaserGasPlayerOnHit(bossIndex))
	{
		char indexes[8], allowedIndexes[88], allowedIndexesList[33][3];
		char currentIndex[2];
		int damageIndexes = NPCChaserGetGasAttackIndexes(bossIndex);
		GetChaserProfileGasAttackIndexesString(profile, allowedIndexes, sizeof(allowedIndexes));
		FormatEx(indexes, sizeof(indexes), "%d", damageIndexes);
		FormatEx(currentIndex, sizeof(currentIndex), "%d", attackIndex + 1);

		int count = ExplodeString(allowedIndexes, " ", allowedIndexesList, 33, 3);
		if (count > 1)
		{
			for (int i = 0; i < count && i < NPCChaserGetAttackCount(bossIndex); i++)
			{
				int forIndex = StringToInt(allowedIndexesList[i]);
				if (forIndex == attackIndex + 1 && NPCChaserGetGasDuration(bossIndex, difficulty) > 0.0)
				{
					GetChaserProfileGasParticle(profile, gasPlayerParticle, sizeof(gasPlayerParticle));
					if (gasPlayerParticle[0] == '\0')
					{
						gasPlayerParticle = GAS_PARTICLE;
					}
					if (NPCChaserAttachDamageParticle(bossIndex))
					{
						if (NPCChaserGetGasBeamParticle(bossIndex))
						{
							SlenderCreateParticleBeamClient(bossIndex, gasPlayerParticle, 35.0, client);
						}
						else
						{
							SlenderCreateParticleAttach(bossIndex, gasPlayerParticle, 35.0, client);
						}
					}
					else
					{
						SlenderCreateParticle(bossIndex, gasPlayerParticle, 55.0);
					}
					if (g_SlenderGasHitSound[bossIndex][0] != '\0') //No sound, what?
					{
						EmitSoundToAll(g_SlenderGasHitSound[bossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
					}
					client.ChangeCondition(TFCond_Gas, _, NPCChaserGetGasDuration(bossIndex, difficulty));
					break;
				}
			}
		}
		else //Legacy support
		{
			char number = currentIndex[0];
			int attackNumber = 0;
			if (FindCharInString(indexes, number) != -1)
			{
				attackNumber += attackIndex + 1;
			}
			if (indexes[0] != '\0' && currentIndex[0] != '\0' && attackNumber != -1)
			{
				int currentAtkIndex = StringToInt(currentIndex);
				if (attackNumber == currentAtkIndex && NPCChaserGetGasDuration(bossIndex, difficulty) > 0.0)
				{
					GetChaserProfileGasParticle(profile, gasPlayerParticle, sizeof(gasPlayerParticle));
					if (gasPlayerParticle[0] == '\0')
					{
						gasPlayerParticle = GAS_PARTICLE;
					}
					if (NPCChaserAttachDamageParticle(bossIndex))
					{
						if (NPCChaserGetGasBeamParticle(bossIndex))
						{
							SlenderCreateParticleBeamClient(bossIndex, gasPlayerParticle, 35.0, client);
						}
						else
						{
							SlenderCreateParticleAttach(bossIndex, gasPlayerParticle, 35.0, client);
						}
					}
					else
					{
						SlenderCreateParticle(bossIndex, gasPlayerParticle, 55.0);
					}
					if (g_SlenderGasHitSound[bossIndex][0] != '\0') //No sound, what?
					{
						EmitSoundToAll(g_SlenderGasHitSound[bossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
					}
					client.ChangeCondition(TFCond_Gas, _, NPCChaserGetGasDuration(bossIndex, difficulty));
				}
			}
		}
	}
	if (NPCChaserMarkPlayerOnHit(bossIndex))
	{
		char indexes[8], allowedIndexes[88], allowedIndexesList[33][3];
		char currentIndex[2];
		int damageIndexes = NPCChaserGetMarkAttackIndexes(bossIndex);
		GetChaserProfileMarkAttackIndexesString(profile, allowedIndexes, sizeof(allowedIndexes));
		FormatEx(indexes, sizeof(indexes), "%d", damageIndexes);
		FormatEx(currentIndex, sizeof(currentIndex), "%d", attackIndex + 1);

		int count = ExplodeString(allowedIndexes, " ", allowedIndexesList, 33, 3);
		if (count > 1)
		{
			for (int i = 0; i < count && i < NPCChaserGetAttackCount(bossIndex); i++)
			{
				int forIndex = StringToInt(allowedIndexesList[i]);
				if (forIndex == attackIndex + 1 && NPCChaserGetMarkDuration(bossIndex, difficulty) > 0.0)
				{
					client.ChangeCondition(TFCond_MarkedForDeath, _, NPCChaserGetMarkDuration(bossIndex, difficulty));
					break;
				}
			}
		}
		else //Legacy support
		{
			char number = currentIndex[0];
			int attackNumber = 0;
			if (FindCharInString(indexes, number) != -1)
			{
				attackNumber += attackIndex + 1;
			}
			if (indexes[0] != '\0' && currentIndex[0] != '\0' && attackNumber != -1)
			{
				int currentAtkIndex = StringToInt(currentIndex);
				if (attackNumber == currentAtkIndex && NPCChaserGetMarkDuration(bossIndex, difficulty))
				{
					client.ChangeCondition(TFCond_MarkedForDeath, _, NPCChaserGetMarkDuration(bossIndex, difficulty));
				}
			}
		}
	}
	if (NPCChaserSilentMarkPlayerOnHit(bossIndex))
	{
		char indexes[8], allowedIndexes[88], allowedIndexesList[33][3];
		char currentIndex[2];
		int damageIndexes = NPCChaserGetSilentMarkAttackIndexes(bossIndex);
		GetChaserProfileSilentMarkAttackIndexesString(profile, allowedIndexes, sizeof(allowedIndexes));
		FormatEx(indexes, sizeof(indexes), "%d", damageIndexes);
		FormatEx(currentIndex, sizeof(currentIndex), "%d", attackIndex + 1);

		int count = ExplodeString(allowedIndexes, " ", allowedIndexesList, 33, 3);
		if (count > 1)
		{
			for (int i = 0; i < count && i < NPCChaserGetAttackCount(bossIndex); i++)
			{
				int forIndex = StringToInt(allowedIndexesList[i]);
				if (forIndex == attackIndex + 1 && NPCChaserGetSilentMarkDuration(bossIndex, difficulty) > 0.0)
				{
					client.ChangeCondition(TFCond_MarkedForDeathSilent, _, NPCChaserGetSilentMarkDuration(bossIndex, difficulty));
					break;
				}
			}
		}
		else //Legacy support
		{
			char number = currentIndex[0];
			int attackNumber = 0;
			if (FindCharInString(indexes, number) != -1)
			{
				attackNumber += attackIndex + 1;
			}
			if (indexes[0] != '\0' && currentIndex[0] != '\0' && attackNumber != -1)
			{
				int currentAtkIndex = StringToInt(currentIndex);
				if (attackNumber == currentAtkIndex && NPCChaserGetSilentMarkDuration(bossIndex, difficulty))
				{
					client.ChangeCondition(TFCond_MarkedForDeathSilent, _, NPCChaserGetSilentMarkDuration(bossIndex, difficulty));
				}
			}
		}
	}
	if (NPCChaserIgnitePlayerOnHit(bossIndex))
	{
		char indexes[8], allowedIndexes[88], allowedIndexesList[33][3];
		char currentIndex[2];
		int damageIndexes = NPCChaserGetIgniteAttackIndexes(bossIndex);
		GetChaserProfileIgniteAttackIndexesString(profile, allowedIndexes, sizeof(allowedIndexes));
		FormatEx(indexes, sizeof(indexes), "%d", damageIndexes);
		FormatEx(currentIndex, sizeof(currentIndex), "%d", attackIndex + 1);

		int count = ExplodeString(allowedIndexes, " ", allowedIndexesList, 33, 3);
		if (count > 1)
		{
			for (int i = 0; i < count && i < NPCChaserGetAttackCount(bossIndex); i++)
			{
				int forIndex = StringToInt(allowedIndexesList[i]);
				if (forIndex == attackIndex + 1 && NPCChaserGetIgniteDuration(bossIndex, difficulty))
				{
					g_PlayerIgniteDurationEffect[client.index] = NPCChaserGetIgniteDuration(bossIndex, difficulty);
					if (NPCChaserGetIgniteDelay(bossIndex, difficulty) > 0.0 && g_PlayerIgniteTimer[client.index] == null)
					{
						g_PlayerIgniteTimer[client.index] = CreateTimer(NPCChaserGetIgniteDelay(bossIndex, difficulty), Timer_SlenderChaseBossAttackIgniteHit, EntIndexToEntRef(client.index), TIMER_FLAG_NO_MAPCHANGE);
					}
					else
					{
						client.Ignite(true, _, g_PlayerIgniteDurationEffect[client.index]);
					}
					break;
				}
			}
		}
		else //Legacy support
		{
			char number = currentIndex[0];
			int attackNumber = 0;
			if (FindCharInString(indexes, number) != -1)
			{
				attackNumber += attackIndex + 1;
			}
			if (indexes[0] != '\0' && currentIndex[0] != '\0' && attackNumber != -1)
			{
				int currentAtkIndex = StringToInt(currentIndex);
				if (attackNumber == currentAtkIndex && NPCChaserGetIgniteDuration(bossIndex, difficulty))
				{
					g_PlayerIgniteDurationEffect[client.index] = NPCChaserGetIgniteDuration(bossIndex, difficulty);
					if (NPCChaserGetIgniteDelay(bossIndex, difficulty) > 0.0 && g_PlayerIgniteTimer[client.index] == null)
					{
						g_PlayerIgniteTimer[client.index] = CreateTimer(NPCChaserGetIgniteDelay(bossIndex, difficulty), Timer_SlenderChaseBossAttackIgniteHit, EntIndexToEntRef(client.index), TIMER_FLAG_NO_MAPCHANGE);
					}
					else
					{
						client.Ignite(true, _, g_PlayerIgniteDurationEffect[client.index]);
					}
				}
			}
		}
	}
	if (NPCChaserStunPlayerOnHit(bossIndex))
	{
		char indexes[8], allowedIndexes[88], allowedIndexesList[33][3];
		char currentIndex[2];
		int damageIndexes = NPCChaserGetStunAttackIndexes(bossIndex);
		FormatEx(indexes, sizeof(indexes), "%d", damageIndexes);
		FormatEx(currentIndex, sizeof(currentIndex), "%d", attackIndex + 1);
		GetChaserProfileStunAttackIndexesString(profile, allowedIndexes, sizeof(allowedIndexes));

		int count = ExplodeString(allowedIndexes, " ", allowedIndexesList, 33, 3);
		if (count > 1)
		{
			for (int i = 0; i < count && i < NPCChaserGetAttackCount(bossIndex); i++)
			{
				int forIndex = StringToInt(allowedIndexesList[i]);
				if (forIndex == attackIndex + 1 && NPCChaserGetStunAttackDuration(bossIndex, difficulty))
				{
					GetChaserProfileStunParticle(profile, stunPlayerParticle, sizeof(stunPlayerParticle));
					if (stunPlayerParticle[0] == '\0')
					{
						stunPlayerParticle = STUN_PARTICLE;
					}
					if (NPCChaserGetStunAttackType(bossIndex) != 4)
					{
						if (NPCChaserAttachDamageParticle(bossIndex))
						{
							if (NPCChaserGetStunBeamParticle(bossIndex))
							{
								SlenderCreateParticleBeamClient(bossIndex, stunPlayerParticle, 35.0, client);
							}
							else
							{
								SlenderCreateParticleAttach(bossIndex, stunPlayerParticle, 35.0, client);
							}
						}
						else
						{
							SlenderCreateParticle(bossIndex, stunPlayerParticle, 55.0);
						}
					}
					if (g_SlenderStunHitSound[bossIndex][0] != '\0' && NPCChaserGetStunAttackType(bossIndex) != 4) //No sound, what?
					{
						EmitSoundToAll(g_SlenderStunHitSound[bossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
					}
					switch (NPCChaserGetStunAttackType(bossIndex))
					{
						case 1:
						{
							client.Stun(NPCChaserGetStunAttackDuration(bossIndex, difficulty), NPCChaserGetStunAttackSlowdown(bossIndex, difficulty), TF_STUNFLAG_SLOWDOWN);
						}
						case 2:
						{
							client.Stun(NPCChaserGetStunAttackDuration(bossIndex, difficulty), NPCChaserGetStunAttackSlowdown(bossIndex, difficulty), TF_STUNFLAGS_LOSERSTATE);
						}
						case 3:
						{
							client.Stun(NPCChaserGetStunAttackDuration(bossIndex, difficulty), NPCChaserGetStunAttackSlowdown(bossIndex, difficulty), TF_STUNFLAG_BONKSTUCK|TF_STUNFLAG_NOSOUNDOREFFECT);
						}
						case 4:
						{
							client.Stun(NPCChaserGetStunAttackDuration(bossIndex, difficulty), NPCChaserGetStunAttackSlowdown(bossIndex, difficulty), TF_STUNFLAGS_GHOSTSCARE);
						}
					}
					break;
				}
			}
		}
		else //Legacy support
		{
			char number = currentIndex[0];
			int attackNumber = 0;
			if (FindCharInString(indexes, number) != -1)
			{
				attackNumber += attackIndex + 1;
			}
			if (indexes[0] != '\0' && currentIndex[0] != '\0' && attackNumber != -1)
			{
				int currentAtkIndex = StringToInt(currentIndex);
				if (attackNumber == currentAtkIndex && NPCChaserGetStunAttackDuration(bossIndex, difficulty) > 0.0)
				{
					GetChaserProfileStunParticle(profile, stunPlayerParticle, sizeof(stunPlayerParticle));
					if (stunPlayerParticle[0] == '\0')
					{
						stunPlayerParticle = STUN_PARTICLE;
					}
					if (NPCChaserGetStunAttackType(bossIndex) != 4)
					{
						if (NPCChaserAttachDamageParticle(bossIndex))
						{
							if (NPCChaserGetStunBeamParticle(bossIndex))
							{
								SlenderCreateParticleBeamClient(bossIndex, stunPlayerParticle, 35.0, client);
							}
							else
							{
								SlenderCreateParticleAttach(bossIndex, stunPlayerParticle, 35.0, client);
							}
						}
						else
						{
							SlenderCreateParticle(bossIndex, stunPlayerParticle, 55.0);
						}
					}
					if (g_SlenderStunHitSound[bossIndex][0] != '\0' && NPCChaserGetStunAttackType(bossIndex) != 4) //No sound, what?
					{
						EmitSoundToAll(g_SlenderStunHitSound[bossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
					}
					switch (NPCChaserGetStunAttackType(bossIndex))
					{
						case 1:
						{
							client.Stun(NPCChaserGetStunAttackDuration(bossIndex, difficulty), NPCChaserGetStunAttackSlowdown(bossIndex, difficulty), TF_STUNFLAG_SLOWDOWN);
						}
						case 2:
						{
							client.Stun(NPCChaserGetStunAttackDuration(bossIndex, difficulty), NPCChaserGetStunAttackSlowdown(bossIndex, difficulty), TF_STUNFLAGS_LOSERSTATE);
						}
						case 3:
						{
							client.Stun(NPCChaserGetStunAttackDuration(bossIndex, difficulty), NPCChaserGetStunAttackSlowdown(bossIndex, difficulty), TF_STUNFLAG_BONKSTUCK|TF_STUNFLAG_NOSOUNDOREFFECT);
						}
						case 4:
						{
							client.Stun(NPCChaserGetStunAttackDuration(bossIndex, difficulty), NPCChaserGetStunAttackSlowdown(bossIndex, difficulty), TF_STUNFLAGS_GHOSTSCARE);
						}
					}
				}
			}
		}
	}
	if (NPCChaserBleedPlayerOnHit(bossIndex))
	{
		char indexes[8], allowedIndexes[88], allowedIndexesList[33][3];
		char currentIndex[2];
		int damageIndexes = NPCChaserGetBleedAttackIndexes(bossIndex);
		FormatEx(indexes, sizeof(indexes), "%d", damageIndexes);
		FormatEx(currentIndex, sizeof(currentIndex), "%d", attackIndex + 1);
		GetChaserProfileBleedAttackIndexesString(profile, allowedIndexes, sizeof(allowedIndexes));

		int count = ExplodeString(allowedIndexes, " ", allowedIndexesList, 33, 3);
		if (count > 1)
		{
			for (int i = 0; i < count && i < NPCChaserGetAttackCount(bossIndex); i++)
			{
				int forIndex = StringToInt(allowedIndexesList[i]);
				if (forIndex == attackIndex + 1 && NPCChaserGetBleedDuration(bossIndex, difficulty))
				{
					if (!client.InCondition(TFCond_Bleeding))
					{
						client.Bleed(true, _, NPCChaserGetBleedDuration(bossIndex, difficulty));
						break;
					}
				}
			}
		}
		else //Legacy support
		{
			char number = currentIndex[0];
			int attackNumber = 0;
			if (FindCharInString(indexes, number) != -1)
			{
				attackNumber += attackIndex + 1;
			}
			if (indexes[0] != '\0' && currentIndex[0] != '\0' && attackNumber != -1)
			{
				int currentAtkIndex = StringToInt(currentIndex);
				if (attackNumber == currentAtkIndex && NPCChaserGetBleedDuration(bossIndex, difficulty) > 0.0)
				{
					if (!client.InCondition(TFCond_Bleeding))
					{
						client.Bleed(true, _, NPCChaserGetBleedDuration(bossIndex, difficulty));
					}
				}
			}
		}
	}
	if (NPCChaserElectricPlayerOnHit(bossIndex))
	{
		char indexes[8], allowedIndexes[88], allowedIndexesList[33][3];
		char currentIndex[2];
		int damageIndexes = NPCChaserGetElectricAttackIndexes(bossIndex);
		FormatEx(indexes, sizeof(indexes), "%d", damageIndexes);
		FormatEx(currentIndex, sizeof(currentIndex), "%d", attackIndex + 1);
		GetChaserProfileEletricAttackIndexesString(profile, allowedIndexes, sizeof(allowedIndexes));

		int count = ExplodeString(allowedIndexes, " ", allowedIndexesList, 33, 3);
		if (count > 1)
		{
			for (int i = 0; i < count && i < NPCChaserGetAttackCount(bossIndex); i++)
			{
				int forIndex = StringToInt(allowedIndexesList[i]);
				if (forIndex == attackIndex + 1 && NPCChaserGetElectricDuration(bossIndex, difficulty))
				{
					GetChaserProfileElectricRedParticle(profile, electricPlayerParticleRed, sizeof(electricPlayerParticleRed));
					GetChaserProfileElectricBlueParticle(profile, electricPlayerParticleBlue, sizeof(electricPlayerParticleBlue));
					if (electricPlayerParticleRed[0] == '\0')
					{
						electricPlayerParticleRed = ELECTRIC_RED_PARTICLE;
					}
					if (electricPlayerParticleBlue[0] == '\0')
					{
						electricPlayerParticleBlue = ELECTRIC_BLUE_PARTICLE;
					}
					if (NPCChaserAttachDamageParticle(bossIndex))
					{
						if (client.Team == TFTeam_Red)
						{
							if (NPCChaserGetElectricBeamParticle(bossIndex))
							{
								SlenderCreateParticleBeamClient(bossIndex, electricPlayerParticleRed, 35.0, client);
							}
							else
							{
								SlenderCreateParticleAttach(bossIndex, electricPlayerParticleRed, 35.0, client);
							}
						}
						else if (client.Team == TFTeam_Blue)
						{
							if (NPCChaserGetElectricBeamParticle(bossIndex))
							{
								SlenderCreateParticleBeamClient(bossIndex, electricPlayerParticleBlue, 35.0, client);
							}
							else
							{
								SlenderCreateParticleAttach(bossIndex, electricPlayerParticleBlue, 35.0, client);
							}
						}
					}
					else
					{
						if (client.Team == TFTeam_Red)
						{
							SlenderCreateParticle(bossIndex, electricPlayerParticleRed, 55.0);
						}
						else if (client.Team == TFTeam_Blue)
						{
							SlenderCreateParticle(bossIndex, electricPlayerParticleBlue, 55.0);
						}
					}
					switch (NPCChaserGetStunAttackType(bossIndex))
					{
						case 1:
						{
							client.Stun(NPCChaserGetElectricDuration(bossIndex, difficulty), NPCChaserGetElectricSlowdown(bossIndex, difficulty), TF_STUNFLAG_SLOWDOWN);
						}
						case 2:
						{
							client.Stun(NPCChaserGetElectricDuration(bossIndex, difficulty), NPCChaserGetElectricSlowdown(bossIndex, difficulty), TF_STUNFLAGS_LOSERSTATE);
						}
						case 3, 4:
						{
							client.Stun(NPCChaserGetElectricDuration(bossIndex, difficulty), NPCChaserGetElectricSlowdown(bossIndex, difficulty), TF_STUNFLAG_BONKSTUCK|TF_STUNFLAG_NOSOUNDOREFFECT);
						}
					}
					break;
				}
			}
		}
		else //Legacy support
		{
			char number = currentIndex[0];
			int attackNumber = 0;
			if (FindCharInString(indexes, number) != -1)
			{
				attackNumber += attackIndex + 1;
			}
			if (indexes[0] != '\0' && currentIndex[0] != '\0' && attackNumber != -1)
			{
				int currentAtkIndex = StringToInt(currentIndex);
				if (attackNumber == currentAtkIndex && NPCChaserGetElectricDuration(bossIndex, difficulty) > 0.0)
				{
					GetChaserProfileElectricRedParticle(profile, electricPlayerParticleRed, sizeof(electricPlayerParticleRed));
					GetChaserProfileElectricBlueParticle(profile, electricPlayerParticleBlue, sizeof(electricPlayerParticleBlue));
					if (electricPlayerParticleRed[0] == '\0')
					{
						electricPlayerParticleRed = ELECTRIC_RED_PARTICLE;
					}
					if (electricPlayerParticleBlue[0] == '\0')
					{
						electricPlayerParticleBlue = ELECTRIC_BLUE_PARTICLE;
					}
					if (NPCChaserAttachDamageParticle(bossIndex))
					{
						if (client.Team == TFTeam_Red)
						{
							if (NPCChaserGetElectricBeamParticle(bossIndex))
							{
								SlenderCreateParticleBeamClient(bossIndex, electricPlayerParticleRed, 35.0, client);
							}
							else
							{
								SlenderCreateParticleAttach(bossIndex, electricPlayerParticleRed, 35.0, client);
							}
						}
						else if (client.Team == TFTeam_Blue)
						{
							if (NPCChaserGetElectricBeamParticle(bossIndex))
							{
								SlenderCreateParticleBeamClient(bossIndex, electricPlayerParticleBlue, 35.0, client);
							}
							else
							{
								SlenderCreateParticleAttach(bossIndex, electricPlayerParticleBlue, 35.0, client);
							}
						}
					}
					else
					{
						if (client.Team == TFTeam_Red)
						{
							SlenderCreateParticle(bossIndex, electricPlayerParticleRed, 55.0);
						}
						else if (client.Team == TFTeam_Blue)
						{
							SlenderCreateParticle(bossIndex, electricPlayerParticleBlue, 55.0);
						}
					}
					switch (NPCChaserGetStunAttackType(bossIndex))
					{
						case 1:
						{
							client.Stun(NPCChaserGetElectricDuration(bossIndex, difficulty), NPCChaserGetElectricSlowdown(bossIndex, difficulty), TF_STUNFLAG_SLOWDOWN);
						}
						case 2:
						{
							client.Stun(NPCChaserGetElectricDuration(bossIndex, difficulty), NPCChaserGetElectricSlowdown(bossIndex, difficulty), TF_STUNFLAGS_LOSERSTATE);
						}
						case 3, 4:
						{
							client.Stun(NPCChaserGetElectricDuration(bossIndex, difficulty), NPCChaserGetElectricSlowdown(bossIndex, difficulty), TF_STUNFLAG_BONKSTUCK|TF_STUNFLAG_NOSOUNDOREFFECT);
						}
					}
				}
			}
		}
	}
	if (NPCChaserSmitePlayerOnHit(bossIndex))
	{
		char indexes[8], allowedIndexes[88], allowedIndexesList[33][3];
		char currentIndex[2];
		int damageIndexes = NPCChaserGetSmiteAttackIndexes(bossIndex);
		FormatEx(indexes, sizeof(indexes), "%d", damageIndexes);
		FormatEx(currentIndex, sizeof(currentIndex), "%d", attackIndex + 1);
		GetChaserProfileSmiteAttackIndexesString(profile, allowedIndexes, sizeof(allowedIndexes));

		int count = ExplodeString(allowedIndexes, " ", allowedIndexesList, 33, 3);
		if (count > 1)
		{
			for (int i = 0; i < count && i < NPCChaserGetAttackCount(bossIndex); i++)
			{
				int forIndex = StringToInt(allowedIndexesList[i]);
				if (forIndex == attackIndex + 1)
				{
					PerformSmiteBoss(bossIndex, client, EntIndexToEntRef(slender));
					client.TakeDamage(_, slender, slender, NPCChaserGetSmiteDamage(bossIndex), NPCChaserGetSmiteDamageType(bossIndex), _, view_as<float>( { 0.0, 0.0, 0.0 } ), flMyEyePos);
					if (NPCChaserSmitePlayerMessage(bossIndex))
					{
						char player[32];
						FormatEx(player, sizeof(player), "%N", client.index);

						char name[SF2_MAX_NAME_LENGTH];
						NPCGetBossName(bossIndex, name, sizeof(name));
						if (name[0] == '\0')
						{
							strcopy(name, sizeof(name), profile);
						}
						if (client.Team == TFTeam_Red)
						{
							CPrintToChatAll("{royalblue}%t {default}%t", "SF2 Prefix", "SF2 Smote target", name, player);
						}
					}
					break;
				}
			}
		}
		else //Legacy support
		{
			char number = currentIndex[0];
			int attackNumber = 0;
			if (FindCharInString(indexes, number) != -1)
			{
				attackNumber += attackIndex + 1;
			}
			if (indexes[0] != '\0' && currentIndex[0] != '\0' && attackNumber != -1)
			{
				int currentAtkIndex = StringToInt(currentIndex);
				if (attackNumber == currentAtkIndex)
				{
					PerformSmiteBoss(bossIndex, client, EntIndexToEntRef(slender));
					client.TakeDamage(_, slender, slender, NPCChaserGetSmiteDamage(bossIndex), NPCChaserGetSmiteDamageType(bossIndex), _, view_as<float>( { 0.0, 0.0, 0.0 } ), flMyEyePos);
					if (NPCChaserSmitePlayerMessage(bossIndex))
					{
						char player[32];
						FormatEx(player, sizeof(player), "%N", client.index);

						char name[SF2_MAX_NAME_LENGTH];
						NPCGetBossName(bossIndex, name, sizeof(name));
						if (name[0] == '\0')
						{
							strcopy(name, sizeof(name), profile);
						}
						if (client.Team == TFTeam_Red)
						{
							CPrintToChatAll("{royalblue}%t {default}%t", "SF2 Prefix", "SF2 Smote target", name, player);
						}
					}
				}
			}
		}
	}
}

void NPCClearAttackStats(int bossIndex, bool killTimers = false)
{
	if (!killTimers)
	{
		g_SlenderAttackTimer[bossIndex] = null;
		g_NpcLifeStealTimer[bossIndex] = null;
		g_SlenderBackupAtkTimer[bossIndex] = null;
	}
	else
	{
		if (g_SlenderAttackTimer[bossIndex] != null)
		{
			KillTimer(g_SlenderAttackTimer[bossIndex]);
		}
		if (g_NpcLifeStealTimer[bossIndex] != null)
		{
			KillTimer(g_NpcLifeStealTimer[bossIndex]);
		}
		if (g_SlenderBackupAtkTimer[bossIndex] != null)
		{
			KillTimer(g_SlenderBackupAtkTimer[bossIndex]);
		}
	}
	g_IsSlenderAttacking[bossIndex] = false;
	g_NpcStealingLife[bossIndex] = false;
	g_NpcAlreadyAttacked[bossIndex] = false;
	g_NpcUseFireAnimation[bossIndex] = false;
}

static bool NPCPropPhysicsAttack(int bossIndex, int prop)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH], model[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));
	ArrayList props = GetChaserProfileAttackPropModels(profile);
	if (props == null)
	{
		return false;
	}
	if (!IsValidEntity(prop))
	{
		return false;
	}
	GetEntPropString(prop, Prop_Data, "m_ModelName", model, sizeof(model));
	int arrayIndex = props.FindString(model);
	if (arrayIndex == -1)
	{
		return false;
	}
	return true;
}

void NPC_DropKey(int bossIndex)
{
	char buffer[PLATFORM_MAX_PATH], profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));
	GetChaserProfileKeyTrigger(profile, buffer, sizeof(buffer));
	if (buffer[0] != '\0')
	{
		float myPos[3], vel[3];
		int boss = NPCGetEntIndex(bossIndex);
		GetEntPropVector(boss, Prop_Data, "m_vecAbsOrigin", myPos);
		Format(buffer, PLATFORM_MAX_PATH, "sf2_key_%s", buffer);

		int touchBox = CreateEntityByName("tf_halloween_pickup");
		DispatchKeyValue(touchBox, "targetname", buffer);
		// New key model
		GetChaserProfileKeyModel(profile, keyModel, sizeof(keyModel));
		DispatchKeyValue(touchBox, "powerup_model", keyModel);
		DispatchKeyValue(touchBox, "modelscale", "2.0");
		DispatchKeyValue(touchBox, "pickup_sound", "ui/itemcrate_smash_ultrarare_short.wav");
		DispatchKeyValue(touchBox, "pickup_particle", "utaunt_firework_teamcolor_red");
		DispatchKeyValue(touchBox, "TeamNum", "0");
		TeleportEntity(touchBox, myPos, NULL_VECTOR, NULL_VECTOR);
		if (keyModel[0] == '\0')
		{
			SetEntityModel(touchBox, SF_KEYMODEL);
		}
		else
		{
			SetEntityModel(touchBox, keyModel);
		}
		SetEntProp(touchBox, Prop_Data, "m_iEFlags", 12845056);
		DispatchSpawn(touchBox);
		ActivateEntity(touchBox);
		if (keyModel[0] == '\0')
		{
			SetEntityModel(touchBox, SF_KEYMODEL);
		}
		else
		{
			SetEntityModel(touchBox, keyModel);
		}

		int key = CreateEntityByName("tf_halloween_pickup");
		DispatchKeyValue(key, "targetname", buffer);
		DispatchKeyValue(key, "powerup_model", PAGE_MODEL);
		DispatchKeyValue(key, "modelscale", "2.0");
		DispatchKeyValue(key, "pickup_sound", "ui/itemcrate_smash_ultrarare_short.wav");
		DispatchKeyValue(key, "pickup_particle", "utaunt_firework_teamcolor_red");
		DispatchKeyValue(key, "TeamNum", "0");
		TeleportEntity(key, myPos, NULL_VECTOR, NULL_VECTOR);
		SetEntityModel(key, PAGE_MODEL);
		SetEntProp(key, Prop_Data, "m_iEFlags", 12845056);
		DispatchSpawn(key);
		ActivateEntity(key);

		SetEntityRenderMode(key, RENDER_TRANSCOLOR);
		SetEntityRenderColor(key, 0, 0, 0, 1);

		int glow = CreateEntityByName("tf_taunt_prop");
		DispatchKeyValue(glow, "targetname", buffer);
		if (keyModel[0] == '\0')
		{
			DispatchKeyValue(glow, "powerup_model", SF_KEYMODEL);
		}
		else
		{
			DispatchKeyValue(glow, "powerup_model", keyModel);
		}
		TeleportEntity(glow, myPos, NULL_VECTOR, NULL_VECTOR);
		DispatchSpawn(glow);
		ActivateEntity(glow);
		if (keyModel[0] == '\0')
		{
			SetEntityModel(glow, SF_KEYMODEL);
		}
		else
		{
			SetEntityModel(glow, keyModel);
		}

		SetEntProp(glow, Prop_Send, "m_bGlowEnabled", 1);
		SetEntPropFloat(glow, Prop_Send, "m_flModelScale", 2.0);
		SetEntityRenderMode(glow, RENDER_TRANSCOLOR);
		SetEntityRenderColor(glow, 0, 0, 0, 1);

		SetVariantString("!activator");
		AcceptEntityInput(touchBox, "SetParent", key);

		SetVariantString("!activator");
		AcceptEntityInput(glow, "SetParent", key);

		SetEntityModel(key, PAGE_MODEL);
		SetEntityMoveType(key, MOVETYPE_FLYGRAVITY);

		HookSingleEntityOutput(touchBox, "OnRedPickup", KeyTrigger);

		vel[0] = GetRandomFloat(-300.0, 300.0);
		vel[1] = GetRandomFloat(-300.0, 300.0);
		vel[2] = GetRandomFloat(700.0, 900.0);

		SetEntProp(key, Prop_Data, "m_iEFlags", 12845056);

		TeleportEntity(key, myPos, NULL_VECTOR, vel);
		SetEntPropFloat(key, Prop_Send, "m_flModelScale", 2.0);
		SetEntProp(key, Prop_Data, "m_iEFlags", 12845056);
		SetEntProp(key, Prop_Data, "m_MoveCollide", 1);

		SDKHook(key, SDKHook_SetTransmit, Hook_KeySetTransmit);
		SDKHook(glow, SDKHook_SetTransmit, Hook_KeySetTransmit);
		SDKHook(touchBox, SDKHook_SetTransmit, Hook_KeySetTransmit);

		//The key can be stuck somewhere to prevent that, make an auto collect.
		float timeLeft = float(g_RoundTime);
		if (timeLeft > 60.0)
		{
			timeLeft = 30.0;
		}
		else
		{
			timeLeft = timeLeft - 20.0;
		}
		CreateTimer(timeLeft, CollectKey, EntIndexToEntRef(touchBox), TIMER_FLAG_NO_MAPCHANGE);
	}
}

void KeyTrigger(const char[] output, int caller, int activator, float delay)
{
	TriggerKey(caller);
}

Action Hook_KeySetTransmit(int entity, int other)
{
	if (!IsValidClient(other))
	{
		return Plugin_Continue;
	}

	if (g_PlayerEliminated[other] && IsClientInGhostMode(other))
	{
		return Plugin_Continue;
	}

	if (!g_PlayerEliminated[other])
	{
		return Plugin_Continue;
	}

	return Plugin_Handled;
}

Action CollectKey(Handle timer, any entref)
{
	int ent = EntRefToEntIndex(entref);
	if (ent == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}
	char class[64];
	GetEntityNetClass(ent, class, sizeof(class));
	if (strcmp(class, "CHalloweenPickup") != 0)
	{
		return Plugin_Stop;
	}

	TriggerKey(ent);
	return Plugin_Stop;
}

void TriggerKey(int caller)
{
	char targetName[PLATFORM_MAX_PATH];
	GetEntPropString(caller, Prop_Data, "m_iName", targetName, sizeof(targetName));

	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "tf_halloween_pickup")) != -1)
	{
		char name[64];
		GetEntPropString(ent, Prop_Data, "m_iName", name, sizeof(name));
		if (strcmp(name, targetName, false) == 0)
		{
			AcceptEntityInput(ent, "KillHierarchy");
		}
	}

	ReplaceString(targetName, sizeof(targetName), "sf2_key_", "", false);
	float myPos[3];
	GetEntPropVector(caller, Prop_Data, "m_vecAbsOrigin", myPos);
	TE_Particle(g_Particles[FireworksRED], myPos, myPos);
	TE_SendToAll();
	TE_Particle(g_Particles[FireworksBLU], myPos, myPos);
	TE_SendToAll();
	ent = -1;
	while ((ent = FindEntityByClassname(ent, "logic_relay")) != -1)
	{
		char name[64];
		GetEntPropString(ent, Prop_Data, "m_iName", name, sizeof(name));
		if (strcmp(name, targetName, false) == 0)
		{
			AcceptEntityInput(ent, "Trigger");
		}
	}
	ent = -1;
	while ((ent = FindEntityByClassname(ent, "func_door")) != -1)
	{
		char name[64];
		GetEntPropString(ent, Prop_Data, "m_iName", name, sizeof(name));
		if (strcmp(name, targetName, false) == 0)
		{
			AcceptEntityInput(ent, "Open");
		}
	}
	ent = -1;
	while ((ent = FindEntityByClassname(ent, "trigger_multiple")) != -1)
	{
		char name[64];
		GetEntPropString(ent, Prop_Data, "m_iName", name, sizeof(name));
		if (strcmp(name, targetName, false) == 0)
		{
			AcceptEntityInput(ent, "Enable");
		}
	}
	RemoveEntity(caller);
	EmitSoundToAll("ui/itemcrate_smash_ultrarare_short.wav", caller, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
}

bool NPC_CanAttackProps(int bossIndex, float flAttackRange, float flAttackFOV)
{
	int prop = -1;
	while ((prop = FindEntityByClassname(prop, "prop_physics")) > MaxClients)
	{
		if (NPCAttackValidateTarget(bossIndex, prop, flAttackRange, flAttackFOV, true))
		{
			if (NPCPropPhysicsAttack(bossIndex, prop))
			{
				return true;
			}
		}
	}
	prop = -1;
	while ((prop = FindEntityByClassname(prop, "prop_*")) > MaxClients)
	{
		if (GetEntProp(prop, Prop_Data, "m_iHealth") > 0)
		{
			if (NPCAttackValidateTarget(bossIndex, prop, flAttackRange, flAttackFOV, true))
			{
				return true;
			}
		}
	}
	prop = -1;
	while ((prop = FindEntityByClassname(prop, "obj_*")) > MaxClients)
	{
		if (NPCAttackValidateTarget(bossIndex, prop, flAttackRange, flAttackFOV, true))
		{
			return true;
		}
	}
	return false;
}