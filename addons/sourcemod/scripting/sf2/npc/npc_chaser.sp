#if defined _sf2_npc_chaser_included
#endinput
#endif
#define _sf2_npc_chaser_included

static float g_NpcWalkSpeed[MAX_BOSSES][Difficulty_Max];
static float g_NpcMaxWalkSpeed[MAX_BOSSES][Difficulty_Max];

static float g_NpcWakeRadius[MAX_BOSSES];

static bool g_NpcHasStunEnabled[MAX_BOSSES];
static float g_NpcStunDuration[MAX_BOSSES];
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
ArrayList g_NpcChaseOnLookTarget[MAX_BOSSES];

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
static int g_NpcTeleporter[MAX_BOSSES][MAX_NPCTELEPORTER];
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
static char g_sNPCurrentAnimationSequenceName[MAX_BOSSES][256];
bool g_NpcAlreadyAttacked[MAX_BOSSES];

bool g_NpcCopyAlerted[MAX_BOSSES];

static bool g_NpcHasEarthquakeFootstepsEnabled[MAX_BOSSES];
static float g_NpcEarthquakeFootstepsAmplitude[MAX_BOSSES];
static float g_NpcEarthquakeFootstepsFrequency[MAX_BOSSES];
static float g_NpcEarthquakeFootstepsDuration[MAX_BOSSES];
static float g_NpcEarthquakeFootstepsRadius[MAX_BOSSES];
static bool g_NpcHasEarthquakeFootstepsAirShake[MAX_BOSSES];

static int g_NpcSoundCountToAlert[MAX_BOSSES];
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

static bool g_NpcHasTrapsEnabled[MAX_BOSSES];
static int g_NpcTrapType[MAX_BOSSES];
static float g_NpcNextTrapSpawn[MAX_BOSSES][Difficulty_Max];

//Special thanks to The Gaben
bool g_SlenderHasDamageParticleEffect[MAX_BOSSES];
float g_SlenderDamageClientSoundVolume[MAX_BOSSES];
int g_SlenderDamageClientSoundPitch[MAX_BOSSES];
char damageEffectParticle[PLATFORM_MAX_PATH];
char damageEffectSound[PLATFORM_MAX_PATH];

static int g_NpcAutoChaseThreshold[MAX_BOSSES][Difficulty_Max];
static int g_NpcAutoChaseAddGeneral[MAX_BOSSES][Difficulty_Max];
static int g_NpcAutoChaseAddFootstep[MAX_BOSSES][Difficulty_Max];
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

static bool g_NpcHasUsesMultiAttackSounds[MAX_BOSSES] = { false, ... };
static bool g_NpcHasUsesMultiHitSounds[MAX_BOSSES] = { false, ... };
static bool g_NpcHasUsesMultiMissSounds[MAX_BOSSES] = { false, ... };

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

public void NPCChaserSetTeleporter(int bossIndex, int iTeleporterNumber, int entity)
{
	g_NpcTeleporter[bossIndex][iTeleporterNumber] = entity;
}

public int NPCChaserGetTeleporter(int bossIndex, int iTeleporterNumber)
{
	return g_NpcTeleporter[bossIndex][iTeleporterNumber];
}

public void NPCChaserInitialize()
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
	g_NpcUsesRageAnimation1[npcIndex] = false;
	g_NpcUsesRageAnimation2[npcIndex] = false;
	g_NpcUsesRageAnimation3[npcIndex] = false;
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

float NPCChaserGetAttackDamageForce(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackDamageForce;
}
/*
float NPCChaserGetAttackLifeStealDuration(int npcIndex,int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackLifeStealDuration;
}
*/
bool NPCChaserGetAttackLifeStealState(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackLifeSteal;
}

bool NPCChaserGetAttackWhileRunningState(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackWhileRunning;
}

float NPCChaserGetAttackRunSpeed(int npcIndex, int attackIndex, int difficulty)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][difficulty].baseAttackRunSpeed;
}

float NPCChaserGetAttackRunDuration(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackRunDuration;
}

float NPCChaserGetAttackRunDelay(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackRunDelay;
}

int NPCChaserGetAttackUseOnDifficulty(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackUseOnDifficulty;
}

int NPCChaserGetAttackBlockOnDifficulty(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackBlockOnDifficulty;
}

int NPCChaserGetAttackExplosiveDanceRadius(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackExplosiveDanceRadius;
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

bool NPCChaserGetAttackProjectileCrits(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackProjectileCrits;
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

float NPCChaserGetAttackLaserDuration(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackLaserDuration;
}

float NPCChaserGetAttackLaserNoise(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackLaserNoise;
}

bool NPCChaserGetAttackPullIn(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackPullIn;
}

int NPCChaserGetAttackDamageType(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackDamageType;
}

int NPCChaserGetAttackDisappear(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackDisappear;
}

int NPCChaserGetAttackRepeat(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackRepeat;
}

int NPCChaserGetMaxAttackRepeats(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackMaxRepeats;
}

bool NPCChaserGetAttackIgnoreAlwaysLooking(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackIgnoreAlwaysLooking;
}

float NPCChaserGetAttackDamageDelay(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackDamageDelay;
}

float NPCChaserGetAttackRange(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackRange;
}

float NPCChaserGetAttackDuration(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackDuration;
}

float NPCChaserGetAttackSpread(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackSpread;
}

float NPCChaserGetAttackBeginRange(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackBeginRange;
}

float NPCChaserGetAttackBeginFOV(int npcIndex, int attackIndex)
{
	return g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackBeginFOV;
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

int NPCSetCurrentAttackIndex(int npcIndex, int attackIndex)
{
	g_NpcCurrentAttackIndex[npcIndex] = attackIndex;
}

int NPCGetCurrentAttackIndex(int npcIndex)
{
	return g_NpcCurrentAttackIndex[npcIndex];
}

int NpcSetCurrentAttackRepeat(int npcIndex, int attackIndex, int iValue)
{
	g_NpcBaseAttacks[npcIndex][attackIndex][1].currentAttackRepeat = iValue;
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

float NPCChaserSetNextAttackTime(int npcIndex, int attackIndex, float flValue)
{
	g_NpcBaseAttacks[npcIndex][attackIndex][1].baseAttackNextAttackTime = flValue;
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

float NPCChaserGetStunDuration(int npcIndex)
{
	return g_NpcStunDuration[npcIndex];
}

float NPCChaserGetStunCooldown(int npcIndex)
{
	return g_NpcStunCooldown[npcIndex];
}

float NPCChaserGetStunHealth(int npcIndex)
{
	return g_NpcStunHealth[npcIndex];
}

void NPCChaserSetStunHealth(int npcIndex, float flAmount)
{
	g_NpcStunHealth[npcIndex] = flAmount;
}

void NPCChaserSetStunInitialHealth(int npcIndex, float flAmount)
{
	g_NpcStunInitialHealth[npcIndex] = flAmount;
}

float NPCChaserGetAddStunHealth(int npcIndex)
{
	return g_NpcStunAddHealth[npcIndex];
}

void NPCChaserSetAddStunHealth(int npcIndex, float flAmount)
{
	g_NpcStunAddHealth[npcIndex] += flAmount;
}

void NPCChaserAddStunHealth(int npcIndex, float flAmount)
{
	if (GetGameTime() >= g_SlenderNextStunTime[npcIndex])
	{
		NPCChaserSetStunHealth(npcIndex, NPCChaserGetStunHealth(npcIndex) + flAmount);
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

int NPCChaserGetSoundCountToAlert(int npcIndex)
{
	return g_NpcSoundCountToAlert[npcIndex];
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

bool NPCChaserHasMultiAttackSounds(int npcIndex)
{
	return g_NpcHasUsesMultiAttackSounds[npcIndex];
}

bool NPCChaserHasMultiHitSounds(int npcIndex)
{
	return g_NpcHasUsesMultiHitSounds[npcIndex];
}

bool NPCChaserHasMultiMissSounds(int npcIndex)
{
	return g_NpcHasUsesMultiMissSounds[npcIndex];
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

void NPCChaserSetBoxingDifficulty(int npcIndex, int iValue)
{
	g_NpcBoxingCurrentDifficulty[npcIndex] = iValue;
}

int NPCChaserGetBoxingRagePhase(int npcIndex)
{
	return g_NpcBoxingRagePhase[npcIndex];
}

void NPCChaserSetBoxingRagePhase(int npcIndex, int iValue)
{
	g_NpcBoxingRagePhase[npcIndex] = iValue;
}

bool NPCChaserCanChaseOnLook(int npcIndex)
{
	return g_NpcChaseOnLook[npcIndex];
}

int NPCChaserOnSelectProfile(int npcIndex, bool bInvincible)
{
	SF2ChaserBossProfile profile = SF2ChaserBossProfile(NPCGetProfileIndex(npcIndex));
	char npcProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(npcIndex, npcProfile, sizeof(npcProfile));
	
	g_NpcWakeRadius[npcIndex] = profile.WakeRadius;

	for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
	{
		g_NpcWalkSpeed[npcIndex][difficulty] = profile.GetWalkSpeed(difficulty);
		g_NpcMaxWalkSpeed[npcIndex][difficulty] = profile.GetMaxWalkSpeed(difficulty);

		g_NpcAlertGracetime[npcIndex][difficulty] = profile.GetAlertStateGraceTime(difficulty);
		g_NpcAlertDuration[npcIndex][difficulty] = profile.GetAlertStateDuration(difficulty);
		g_NpcChaseDuration[npcIndex][difficulty] = profile.GetChaseStateDuration(difficulty);
		
		g_NpcCloakCooldown[npcIndex][difficulty] = profile.GetCloakCooldown(difficulty);
		g_NpcCloakRange[npcIndex][difficulty] = profile.GetCloakRange(difficulty);
		g_NpcDecloakRange[npcIndex][difficulty] = profile.GetDecloakRange(difficulty);
		g_NpcCloakDuration[npcIndex][difficulty] = profile.GetCloakDuration(difficulty);
		g_NpcCloakSpeedMultiplier[npcIndex][difficulty] = profile.GetCloakSpeedMultiplier(difficulty);
		
		g_NpcProjectileCooldownMin[npcIndex][difficulty] = profile.GetProjectileCooldownMin(difficulty);
		g_NpcProjectileCooldownMax[npcIndex][difficulty] = profile.GetProjectileCooldownMax(difficulty);
		g_NpcProjectileSpeed[npcIndex][difficulty] = profile.GetProjectileSpeed(difficulty);
		g_NpcProjectileDamage[npcIndex][difficulty] = profile.GetProjectileDamage(difficulty);
		g_NpcProjectileRadius[npcIndex][difficulty] = profile.GetProjectileRadius(difficulty);
		g_NpcProjectileDeviation[npcIndex][difficulty] = profile.GetProjectileDeviation(difficulty);
		g_NpcProjectileCount[npcIndex][difficulty] = profile.GetProjectileCount(difficulty);
		g_IceballSlowdownDuration[npcIndex][difficulty] = profile.GetIceballSlowdownDuration(difficulty);
		g_IceballSlowdownPercent[npcIndex][difficulty] = profile.GetIceballSlowdownPercent(difficulty);
		g_NpcProjectileLoadedAmmo[npcIndex][difficulty] = profile.GetProjectileLoadedAmmo(difficulty);
		g_NpcProjectileReloadTime[npcIndex][difficulty] = profile.GetProjectileReloadTime(difficulty);
		g_NpcProjectileChargeUpTime[npcIndex][difficulty] = profile.GetProjectileChargeUpTime(difficulty);
		g_NpcProjectileAmmo[npcIndex] = g_NpcProjectileLoadedAmmo[npcIndex][difficulty];
		g_NpcProjectileTimeToReload[npcIndex] = g_NpcProjectileReloadTime[npcIndex][difficulty];
		
		g_NpcRandomDuration[npcIndex][difficulty] = profile.GetRandomDuration(difficulty);
		g_NpcRandomSlowdown[npcIndex][difficulty] = profile.GetRandomSlowdown(difficulty);
		g_NpcJarateDuration[npcIndex][difficulty] = profile.GetJarateDuration(difficulty);
		g_NpcMilkDuration[npcIndex][difficulty] = profile.GetMilkDuration(difficulty);
		g_NpcGasDuration[npcIndex][difficulty] = profile.GetGasDuration(difficulty);
		g_NpcMarkDuration[npcIndex][difficulty] = profile.GetMarkDuration(difficulty);
		g_NpcIgniteDelay[npcIndex][difficulty] = profile.GetIgniteDelay(difficulty);
		g_NpcStunAttackDuration[npcIndex][difficulty] = profile.GetStunAttackDuration(difficulty);
		g_NpcStunAttackSlowdown[npcIndex][difficulty] = profile.GetStunAttackSlowdown(difficulty);
		g_NpcBleedDuration[npcIndex][difficulty] = profile.GetBleedDuration(difficulty);
		g_NpcElectricDuration[npcIndex][difficulty] = profile.GetElectricDuration(difficulty);
		g_NpcElectricSlowdown[npcIndex][difficulty] = profile.GetElectricSlowdown(difficulty);
		
		g_NpcShockwaveDrain[npcIndex][difficulty] = profile.GetShockwaveDrain(difficulty);
		g_NpcShockwaveForce[npcIndex][difficulty] = profile.GetShockwaveForce(difficulty);
		g_NpcShockwaveHeight[npcIndex][difficulty] = profile.GetShockwaveHeight(difficulty);
		g_NpcShockwaveRange[npcIndex][difficulty] = profile.GetShockwaveRange(difficulty);
		g_NpcShockwaveStunDuration[npcIndex][difficulty] = profile.GetShockwaveStunDuration(difficulty);
		g_NpcShockwaveStunSlowdown[npcIndex][difficulty] = profile.GetShockwaveStunSlowdown(difficulty);
		
		g_NpcNextTrapSpawn[npcIndex][difficulty] = profile.GetTrapCooldown(difficulty);
		g_SlenderNextTrapPlacement[npcIndex] = GetGameTime() + g_NpcNextTrapSpawn[npcIndex][difficulty];
		
		g_NpcSearchWanderRangeMin[npcIndex][difficulty] = profile.GetWanderRangeMin(difficulty);
		g_NpcSearchWanderRangeMax[npcIndex][difficulty] = profile.GetWanderRangeMax(difficulty);
		
		g_NpcAutoChaseThreshold[npcIndex][difficulty] = profile.AutoChaseThreshold(difficulty);
		g_NpcAutoChaseAddGeneral[npcIndex][difficulty] = profile.AutoChaseAddGeneral(difficulty);
		g_NpcAutoChaseAddFootstep[npcIndex][difficulty] = profile.AutoChaseAddFootstep(difficulty);
		g_NpcAutoChaseAddVoice[npcIndex][difficulty] = profile.AutoChaseAddVoice(difficulty);
		g_NpcAutoChaseAddWeapon[npcIndex][difficulty] = profile.AutoChaseAddWeapon(difficulty);
		g_NpcCrawlSpeedMultiplier[npcIndex][difficulty] = profile.GetCrawlingSpeedMultiplier(difficulty);
	}
	
	g_NpcBaseAttacksCount[npcIndex] = profile.AttackCount;
	// Get attack data.
	for (int i = 0; i < g_NpcBaseAttacksCount[npcIndex]; i++)
	{
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackType = profile.GetAttackType(i);
		for (int iDiffAtk = 0; iDiffAtk < Difficulty_Max; iDiffAtk++)
		{
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackDamage = profile.GetAttackDamage(i, iDiffAtk);
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackRunSpeed = profile.GetAttackRunSpeed(i, iDiffAtk);
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackCooldown = profile.GetAttackCooldown(i, iDiffAtk);
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackProjectileDamage = profile.GetAttackProjectileDamage(i, iDiffAtk);
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackProjectileSpeed = profile.GetAttackProjectileSpeed(i, iDiffAtk);
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackProjectileRadius = profile.GetAttackProjectileRadius(i, iDiffAtk);
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackProjectileDeviation = profile.GetAttackProjectileDeviation(i, iDiffAtk);
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackProjectileCount = profile.GetAttackProjectileCount(i, iDiffAtk);
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackProjectileIceSlowdownPercent = profile.GetAttackProjectileIceSlowdownPercent(i, iDiffAtk);
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackProjectileIceSlowdownDuration = profile.GetAttackProjectileIceSlowdownDuration(i, iDiffAtk);
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackBulletCount = profile.GetAttackBulletCount(i, iDiffAtk);
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackBulletDamage = profile.GetAttackBulletDamage(i, iDiffAtk);
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackBulletSpread = profile.GetAttackBulletSpread(i, iDiffAtk);
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackLaserDamage = profile.GetAttackLaserDamage(i, iDiffAtk);
		}
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackDamageVsProps = profile.GetAttackDamageVsProps(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackDamageForce = profile.GetAttackDamageForce(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackDamageType = profile.GetAttackDamageType(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackDamageDelay = profile.GetAttackDamageDelay(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackRange = profile.GetAttackRange(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackDuration = profile.GetAttackDuration(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackSpread = profile.GetAttackSpread(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackBeginRange = profile.GetAttackBeginRange(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackBeginFOV = profile.GetAttackBeginFOV(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackDisappear = profile.ShouldDisappearAfterAttack(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackRepeat = profile.GetAttackRepeatCount(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackMaxRepeats = profile.GetMaxAttackRepeats(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackNextAttackTime = 0.0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackIgnoreAlwaysLooking = profile.GetAttackIgnoreAlwaysLooking(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLifeSteal = profile.CanAttackLifeSteal(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLifeStealDuration = profile.GetAttackLifeStealDuration(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackProjectileCrits = profile.AreAttackProjectilesCritBoosted(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackProjectileType = profile.GetAttackProjectileType(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLaserSize = profile.GetAttackLaserSize(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackWhileRunning = profile.CanRunWhileAttacking(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackRunDuration = profile.GetAttackRunDuration(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackRunDelay = profile.GetAttackRunDelay(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackUseOnDifficulty = profile.GetAttackUseOnDifficulty(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackBlockOnDifficulty = profile.GetAttackBlockOnDifficulty(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackExplosiveDanceRadius = profile.GetAttackExplosiveDanceRadius(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackWeaponTypeInt = profile.GetAttackWeaponTypeInt(i);
		
		int iLaserColor[3];
		profile.GetAttackLaserColor(iLaserColor, i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLaserColor[0] = iLaserColor[0];
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLaserColor[1] = iLaserColor[1];
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLaserColor[2] = iLaserColor[2];
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLaserAttachment = profile.IsLaserOnAttachment(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLaserDuration = profile.GetAttackLaserDuration(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLaserNoise = profile.GetAttackLaserNoise(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackPullIn = profile.CanAttackPullIn(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackGestures = profile.HasAttackGestures(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackDeathCamOnLowHealth = profile.AttackDeathCamOnLowHealth(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackUseOnHealth = profile.GetAttackUseOnHealth(i);
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackBlockOnHealth = profile.GetAttackBlockOnHealth(i);
		g_NpcBaseAttacks[npcIndex][i][1].currentAttackRepeat = 0;
	}
	
	// Get stun data.
	if (!bInvincible)
	{
		g_NpcHasStunEnabled[npcIndex] = profile.StunEnabled;
	}
	else
	{
		g_NpcHasStunEnabled[npcIndex] = false;
	}
	g_NpcStunDuration[npcIndex] = profile.StunDuration;
	g_NpcStunCooldown[npcIndex] = profile.StunCooldown;
	g_NpcStunFlashlightEnabled[npcIndex] = profile.StunByFlashlightEnabled;
	g_NpcStunFlashlightDamage[npcIndex] = profile.StunFlashlightDamage;
	g_NpcStunInitialHealth[npcIndex] = profile.StunHealth;
	g_NpcChaseInitialOnStun[npcIndex] = profile.ChaseInitialOnStun;
	
	//Get key Data
	g_NpcHasKeyDrop[npcIndex] = profile.HasKeyDrop;
	
	//Get Cloak Data
	g_NpcCloakEnabled[npcIndex] = profile.CloakEnabled;
	g_NpcNextDecloakTime[npcIndex] = -1.0;
	
	float stunHealthPerPlayer = profile.StunHealthPerPlayer;
	int count;
	for (int client; client <= MaxClients; client++)
	{
		if (IsValidClient(client) && g_PlayerEliminated[client])
		{
			count++;
		}
	}
	
	stunHealthPerPlayer *= float(count);
	g_NpcStunInitialHealth[npcIndex] += stunHealthPerPlayer;

	g_NpcHasAlwaysLookAtTarget[npcIndex] = NPCHasAttribute(npcIndex, "always look at target");
	g_NpcHasAlwaysLookAtTargetWhileAttacking[npcIndex] = NPCHasAttribute(npcIndex, "always look at target while attacking");
	g_NpcHasAlwaysLookAtTargetWhileChasing[npcIndex] = NPCHasAttribute(npcIndex, "always look at target while chasing");
	g_NpcIgnoreNonMarkedForChase[npcIndex] = NPCHasAttribute(npcIndex, "ignore non-marked for chase");

	g_NpcChaseOnLook[npcIndex] = profile.CanChaseOnLook;
	if (g_NpcChaseOnLookTarget[npcIndex] == null)
	{
		g_NpcChaseOnLookTarget[npcIndex] = new ArrayList();
	}
	
	NPCChaserSetStunHealth(npcIndex, NPCChaserGetStunInitialHealth(npcIndex));
	
	NPCSetAddSpeed(npcIndex, -NPCGetAddSpeed(npcIndex));
	NPCSetAddMaxSpeed(npcIndex, -NPCGetAddMaxSpeed(npcIndex));
	NPCSetAddAcceleration(npcIndex, -NPCGetAddAcceleration(npcIndex));
	NPCChaserSetAddStunHealth(npcIndex, -NPCChaserGetAddStunHealth(npcIndex));

	g_NpcHasEarthquakeFootstepsEnabled[npcIndex] = profile.EarthquakeFootstepsEnabled;
	g_NpcEarthquakeFootstepsAmplitude[npcIndex] = profile.EarthquakeFootstepsAmplitude;
	g_NpcEarthquakeFootstepsFrequency[npcIndex] = profile.EarthquakeFootstepsFrequency;
	g_NpcEarthquakeFootstepsDuration[npcIndex] = profile.EarthquakeFootstepsDuration;
	g_NpcEarthquakeFootstepsRadius[npcIndex] = profile.EarthquakeFootstepsRadius;
	g_NpcHasEarthquakeFootstepsAirShake[npcIndex] = profile.EarthquakeFootstepsAirShake;
	
	g_NpcSoundCountToAlert[npcIndex] = profile.SoundCountToAlert;
	g_NpcHasDisappearOnStun[npcIndex] = profile.CanDisappearOnStun;
	g_NpcHasDropItemOnStun[npcIndex] = profile.DropItemOnStun;
	g_NpcDropItemType[npcIndex] = profile.DropItemType;
	g_NpcHasIsBoxingBoss[npcIndex] = profile.IsBoxingBoss;
	g_NpcHasNormalSoundHookEnabled[npcIndex] = profile.NormalSoundHook;
	g_NpcHasCloakToHealEnabled[npcIndex] = profile.CanCloakToHeal;
	g_NpcHasCanUseChaseInitialAnimation[npcIndex] = profile.UseChaseInitialAnimation;
	g_NpcHasOldAnimationAIState[npcIndex] = profile.HasOldAnimationAI;
	g_NpcHasCanUseAlertWalkingAnimation[npcIndex] = profile.UseAlertWalkingAnimation;
	g_SlenderDifficultyAnimations[npcIndex] = profile.DifficultyAffectsAnimations;

	g_NpcHasUsesMultiAttackSounds[npcIndex] = profile.MultiAttackSounds;
	g_NpcHasUsesMultiHitSounds[npcIndex] = profile.MultiHitSounds;
	g_NpcHasUsesMultiMissSounds[npcIndex] = profile.MultiMissSounds;

	g_NpcHasHasCrawling[npcIndex] = profile.IsCrawlingEnabled;
	g_NpcIsCrawling[npcIndex] = false;
	g_NpcChangeToCrawl[npcIndex] = false;
	GetProfileVector(npcProfile, "crawl_detect_mins", g_NpcCrawlDetectMins[npcIndex], view_as<float>( {0.0, 0.0, 0.0} ));
	GetProfileVector(npcProfile, "crawl_detect_maxs", g_NpcCrawlDetectMaxs[npcIndex], view_as<float>( {0.0, 0.0, 0.0} ));

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
	g_NpcHasProjectileEnabled[npcIndex] = profile.ProjectileEnabled;
	g_NpcProjectileType[npcIndex] = profile.ProjectileType;
	g_NpcHasCriticalRockets[npcIndex] = profile.HasCriticalRockets;
	g_NpcHasUseShootGesture[npcIndex] = profile.UseShootGesture;
	g_NpcHasUseProjectileAmmo[npcIndex] = profile.ProjectileUsesAmmo;
	g_NpcHasUseChargeUpProjectiles[npcIndex] = profile.ChargeUpProjectiles;
	g_NpcProjectileCooldown[npcIndex] = 0.0;
	g_NpcReloadingProjectiles[npcIndex] = false;
	
	g_NpcHasUseAdvancedDamageEffects[npcIndex] = profile.AdvancedDamageEffectsEnabled;
	g_NpcHasAdvancedDamageEffectsRandom[npcIndex] = profile.AdvancedDamageEffectsRandom;
	g_NpcHasAttachDamageParticle[npcIndex] = profile.AttachDamageEffectsParticle;
	g_NpcRandomAttackIndexes[npcIndex] = profile.RandomAttackIndexes;
	g_NpcRandomStunType[npcIndex] = profile.RandomAttackStunType;
	g_NpcHasJaratePlayerEnabled[npcIndex] = profile.JaratePlayerOnHit;
	g_NpcJarateAttackIndexes[npcIndex] = profile.JarateAttackIndexes;
	g_NpcHasJaratePlayerBeamParticle[npcIndex] = profile.JaratePlayerBeamParticle;
	g_NpcHasMilkPlayerEnabled[npcIndex] = profile.MilkPlayerOnHit;
	g_NpcMilkAttackIndexes[npcIndex] = profile.MilkAttackIndexes;
	g_NpcHasMilkPlayerBeamParticle[npcIndex] = profile.MilkPlayerBeamParticle;
	g_NpcHasGasPlayerEnabled[npcIndex] = profile.GasPlayerOnHit;
	g_NpcGasAttackIndexes[npcIndex] = profile.GasAttackIndexes;
	g_NpcHasGasPlayerBeamParticle[npcIndex] = profile.GasPlayerBeamParticle;
	g_NpcHasMarkPlayerEnabled[npcIndex] = profile.MarkPlayerOnHit;
	g_NpcMarkAttackIndexes[npcIndex] = profile.MarkAttackIndexes;
	g_NpcSilentMarkAttackIndexes[npcIndex] = profile.SilentMarkAttackIndexes;
	g_NpcHasIgnitePlayerEnabled[npcIndex] = profile.IgnitePlayerOnHit;
	g_NpcIgniteAttackIndexes[npcIndex] = profile.IgniteAttackIndexes;
	g_NpcHasStunPlayerEnabled[npcIndex] = profile.StunPlayerOnHit;
	g_NpcStunAttackIndexes[npcIndex] = profile.StunAttackIndexes;
	g_NpcStunAttackType[npcIndex] = profile.StunAttackType;
	g_NpcHasStunPlayerBeamParticle[npcIndex] = profile.StunPlayerBeamParticle;
	g_NpcHasBleedPlayerEnabled[npcIndex] = profile.BleedPlayerOnHit;
	g_NpcBleedAttackIndexes[npcIndex] = profile.BleedAttackIndexes;
	g_NpcHasElectricPlayerEnabled[npcIndex] = profile.ElectricPlayerOnHit;
	g_NpcElectricAttackIndexes[npcIndex] = profile.ElectricAttackIndexes;
	g_NpcHasElectricPlayerBeamParticle[npcIndex] = profile.ElectricPlayerBeamParticle;
	g_NpcHasSmitePlayerEnabled[npcIndex] = profile.SmitePlayerOnHit;
	g_NpcHasSmiteMessage[npcIndex] = profile.SmiteMessage;
	g_NpcSmiteAttackIndexes[npcIndex] = profile.SmiteAttackIndexes;
	g_NpcSmiteDamage[npcIndex] = profile.SmiteDamage;
	g_NpcSmiteDamageType[npcIndex] = profile.SmiteDamageType;

	g_NpcHasXenobladeBreakComboSystem[npcIndex] = profile.XenobladeCombo;
	g_NpcXenobladeBreakDuration[npcIndex] = profile.XenobladeBreakDuration;
	g_NpcXenobladeToppleDuration[npcIndex] = profile.XenobladeToppleDuration;
	g_NpcXenobladeToppleSlowdown[npcIndex] = profile.XenobladeToppleSlowdown;
	g_NpcXenobladeDazeDuration[npcIndex] = profile.XenobladeDazeDuration;
	
	int smiteColor[4];
	profile.GetSmiteColor(smiteColor);
	
	g_NpcSmiteColorR[npcIndex] = smiteColor[0];
	g_NpcSmiteColorG[npcIndex] = smiteColor[1];
	g_NpcSmiteColorB[npcIndex] = smiteColor[2];
	g_NpcSmiteTransparency[npcIndex] = smiteColor[3];
	g_SlenderHasDamageParticleEffect[npcIndex] = profile.HasDamageParticles;
	g_SlenderDamageClientSoundVolume[npcIndex] = profile.DamageParticleVolume;
	g_SlenderDamageClientSoundPitch[npcIndex] = profile.DamageParticlePitch;
	
	g_NpcHasShockwaveEnabled[npcIndex] = profile.HasShockwaves;
	g_NpcHasShockwaveStunEnabled[npcIndex] = profile.ShockwaveStunEnabled;
	g_NpcShockwaveAttackIndexes[npcIndex] = profile.ShockwaveAttackIndexes;
	g_NpcShockwaveWidth[npcIndex][0] = profile.ShockwaveWidth1;
	g_NpcShockwaveWidth[npcIndex][1] = profile.ShockwaveWidth2;
	g_NpcShockwaveAmplitude[npcIndex] = profile.ShockwaveAmplitude;
	
	g_NpcHasTrapsEnabled[npcIndex] = profile.HasTraps;
	g_NpcTrapType[npcIndex] = profile.TrapType;
	
	g_SlenderHasAutoChaseEnabled[npcIndex] = profile.AutoChaseEnabled;
	g_NpcHasAutoChaseSprinters[npcIndex] = profile.AutoChaseSprinters;
	g_NpcAutoChaseSprinterCooldown[npcIndex] = 0.0;
	g_NpcInAutoChase[npcIndex] = false;
	g_SlenderIsAutoChasingLoudPlayer[npcIndex] = false;
	
	g_SlenderChasesEndlessly[npcIndex] = profile.ChasesEndlessly;
	
	g_NpcLaserTimer[npcIndex] = 0.0;
	
	g_NpcHasCanSelfHeal[npcIndex] = profile.SelfHealState;
	g_NpcStartSelfHealPercentage[npcIndex] = profile.SelfHealStartPercentage;
	g_NpcSelfHealPercentageOne[npcIndex] = profile.SelfHealPercentageOne;
	g_NpcSelfHealPercentageTwo[npcIndex] = profile.SelfHealPercentageTwo;
	g_NpcSelfHealPercentageThree[npcIndex] = profile.SelfHealPercentageThree;
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
		g_NpcAutoChaseAddVoice[npcIndex][difficulty] = 0;
		g_NpcAutoChaseAddWeapon[npcIndex][difficulty] = 0;

		g_NpcCrawlSpeedMultiplier[npcIndex][difficulty] = 0.0;
	}
	
	// Clear attack data.
	for (int i = 0; i < SF2_CHASER_BOSS_MAX_ATTACKS - 1; i++)
	{
		// Base attack data.
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackType = SF2BossAttackType_Invalid;
		for (int iDiffAtk = 0; iDiffAtk < Difficulty_Max; iDiffAtk++)
		{
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackDamage = 0.0;
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackRunSpeed = 0.0;
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackCooldown = 0.0;
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackProjectileDamage = 0.0;
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackProjectileSpeed = 0.0;
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackProjectileRadius = 0.0;
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackProjectileDeviation = 0.0;
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackProjectileCount = 0;
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackProjectileIceSlowdownPercent = 0.0;
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackProjectileIceSlowdownDuration = 0.0;
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackBulletCount = 0;
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackBulletDamage = 0.0;
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackBulletSpread = 0.0;
			g_NpcBaseAttacks[npcIndex][i][iDiffAtk].baseAttackLaserDamage = 0.0;
		}
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackDamageVsProps = 0.0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackDamageForce = 0.0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackDamageType = 0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackDamageDelay = 0.0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackRange = 0.0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackDuration = 0.0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackSpread = 0.0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackBeginRange = 0.0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackBeginFOV = 0.0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackDisappear = 0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackRepeat = 0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackMaxRepeats = 0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackNextAttackTime = 0.0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackIgnoreAlwaysLooking = false;
		g_NpcBaseAttacks[npcIndex][i][1].weaponAttackIndex = 0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLifeSteal = false;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLifeStealDuration = 0.0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackProjectileCrits = false;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackProjectileType = 0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLaserSize = 0.0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLaserColor[0] = 0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLaserColor[1] = 0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLaserColor[2] = 0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLaserAttachment = false;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLaserDuration = 0.0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackLaserNoise = 0.0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackPullIn = false;
		g_NpcBaseAttacks[npcIndex][i][1].currentAttackRepeat = 0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackWhileRunning = false;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackRunDuration = 0.0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackRunDelay = 0.0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackUseOnDifficulty = 0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackBlockOnDifficulty = 0;
		g_NpcBaseAttacks[npcIndex][i][1].baseAttackExplosiveDanceRadius = 0;
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
	
	g_NpcSoundCountToAlert[npcIndex] = 0;
	g_NpcHasDisappearOnStun[npcIndex] = false;
	g_NpcHasDropItemOnStun[npcIndex] = false;
	g_NpcDropItemType[npcIndex] = 0;
	g_NpcHasIsBoxingBoss[npcIndex] = false;
	g_NpcHasNormalSoundHookEnabled[npcIndex] = false;
	g_NpcHasCloakToHealEnabled[npcIndex] = false;
	g_NpcHasCanUseChaseInitialAnimation[npcIndex] = false;
	g_NpcHasOldAnimationAIState[npcIndex] = false;
	g_NpcHasCanUseAlertWalkingAnimation[npcIndex] = false;

	g_NpcHasUsesMultiAttackSounds[npcIndex] = false;
	g_NpcHasUsesMultiHitSounds[npcIndex] = false;
	g_NpcHasUsesMultiMissSounds[npcIndex] = false;

	g_NpcHasHasCrawling[npcIndex] = false;
	g_NpcIsCrawling[npcIndex] = false;
	
	g_NpcHasStunEnabled[npcIndex] = false;
	g_NpcAlreadyAttacked[npcIndex] = false;
	g_NpcStunDuration[npcIndex] = 0.0;
	g_NpcStunCooldown[npcIndex] = 0.0;
	g_NpcStunFlashlightEnabled[npcIndex] = false;
	g_NpcStunInitialHealth[npcIndex] = 0.0;
	g_NpcStunAddHealth[npcIndex] = 0.0;
	g_NpcChaseInitialOnStun[npcIndex] = false;
	g_SlenderDifficultyAnimations[npcIndex] = false;
	
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
	g_SlenderDamageClientSoundVolume[npcIndex] = 0.0;
	g_SlenderDamageClientSoundPitch[npcIndex] = 0;
	
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
	g_LastStuckTime[bossIndex] = 0.0;
	g_SlenderOldState[bossIndex] = STATE_IDLE;
	g_NpcCopyAlerted[bossIndex] = false;
	g_NpcNextDecloakTime[bossIndex] = -1.0;
	g_NpcIsCrawling[bossIndex] = false;
	g_NpcChangeToCrawl[bossIndex] = false;
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

stock bool IsTargetValidForSlender(int target, bool bIncludeEliminated = false)
{
	if (!target || !IsValidClient(target))
	{
		return false;
	}
	
	if (IsValidClient(target))
	{
		if (!IsClientInGame(target) || 
			!IsPlayerAlive(target) || 
			IsClientInDeathCam(target) || 
			(!bIncludeEliminated && g_PlayerEliminated[target]) || 
			IsClientInGhostMode(target) || 
			DidClientEscape(target))
		{
			return false;
		}
	}
	
	return true;
}

public int NPCChaserGetClosestPlayer(int slender)
{
	if (!g_Enabled)
	{
		return -1;
	}
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return -1;
	}

	int bossIndex = NPCGetFromEntIndex(slender);
	if (bossIndex == -1)
	{
		return -1;
	}

	int difficulty = GetLocalGlobalDifficulty(bossIndex);
	
	float position[3];
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", position);
	
	int closestTarget = -1;
	float searchRadius = NPCGetSearchRadius(bossIndex, difficulty);
	
	for (int i = 0; i <= MaxClients; i++)
	{
		if (!IsValidClient(i) || !IsClientInGame(i) || IsClientInGhostMode(i) || g_PlayerProxy[i] || !IsPlayerAlive(i) || g_PlayerEliminated[i])
		{
			continue;
		}
		
		float clientPos[3];
		GetClientAbsOrigin(i, clientPos);
		
		float distance = GetVectorSquareMagnitude(position, clientPos);
		
		if (distance < SquareFloat(searchRadius))
		{
			closestTarget = i;
			searchRadius = distance;
		}
	}
	
	if (IsValidClient(closestTarget))
	{
		return closestTarget;
	}
	
	return -1;
}

void NPCChaserUpdateBossAnimation(int bossIndex, int ent, int state, bool spawn = false)
{
	char animation[256];
	float playbackRate, tempFootsteps, cycle;
	bool animationFound = false;

	int difficulty = GetLocalGlobalDifficulty(bossIndex);
	
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	bool clearLayers = view_as<bool>(GetProfileNum(profile, "animation_clear_layers_on_update", 1));
	
	switch (state)
	{
		case STATE_IDLE:
		{
			if (!spawn)
			{
				switch (difficulty)
				{
					case Difficulty_Normal:
					{
						animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_IdleAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderIdleFootstepTime[bossIndex], cycle);
					}
					case Difficulty_Hard:
					{
						bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_IdleAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderIdleFootstepTime[bossIndex], cycle);
						if (!animationFound2 || strcmp(animation, "") <= 0)
						{
							animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_IdleAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderIdleFootstepTime[bossIndex], cycle);
						}
						else
						{
							animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_IdleAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderIdleFootstepTime[bossIndex], cycle);
						}
					}
					case Difficulty_Insane:
					{
						bool animationFound3 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_IdleAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderIdleFootstepTime[bossIndex], cycle);
						if (!animationFound3 || strcmp(animation, "") <= 0)
						{
							bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_IdleAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderIdleFootstepTime[bossIndex], cycle);
							if (!animationFound2 || strcmp(animation, "") <= 0)
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_IdleAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderIdleFootstepTime[bossIndex], cycle);
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_IdleAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderIdleFootstepTime[bossIndex], cycle);
							}
						}
						else
						{
							animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_IdleAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderIdleFootstepTime[bossIndex], cycle);
						}
					}
					case Difficulty_Nightmare:
					{
						bool animationFound4 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_IdleAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderIdleFootstepTime[bossIndex], cycle);
						if (!animationFound4 || strcmp(animation, "") <= 0)
						{
							bool animationFound3 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_IdleAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderIdleFootstepTime[bossIndex], cycle);
							if (!animationFound3 || strcmp(animation, "") <= 0)
							{
								bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_IdleAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderIdleFootstepTime[bossIndex], cycle);
								if (!animationFound2 || strcmp(animation, "") <= 0)
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_IdleAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderIdleFootstepTime[bossIndex], cycle);
								}
								else
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_IdleAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderIdleFootstepTime[bossIndex], cycle);
								}
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_IdleAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderIdleFootstepTime[bossIndex], cycle);
							}
						}
						else
						{
							animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_IdleAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderIdleFootstepTime[bossIndex], cycle);
						}
					}
					case Difficulty_Apollyon:
					{
						bool animationFound5 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_IdleAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderIdleFootstepTime[bossIndex], cycle);
						if (!animationFound5 || strcmp(animation, "") <= 0)
						{
							bool animationFound4 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_IdleAnimations, animation, sizeof(animation), playbackRate, 4, _, g_SlenderIdleFootstepTime[bossIndex], cycle);
							if (!animationFound4 || strcmp(animation, "") <= 0)
							{
								bool animationFound3 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_IdleAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderIdleFootstepTime[bossIndex], cycle);
								if (!animationFound3 || strcmp(animation, "") <= 0)
								{
									bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_IdleAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderIdleFootstepTime[bossIndex], cycle);
									if (animationFound2 || strcmp(animation, "") <= 0)
									{
										animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_IdleAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderIdleFootstepTime[bossIndex], cycle);
									}
									else
									{
										animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_IdleAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderIdleFootstepTime[bossIndex], cycle);
									}
								}
								else
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_IdleAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderIdleFootstepTime[bossIndex], cycle);
								}
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_IdleAnimations, animation, sizeof(animation), playbackRate, 4, _, g_SlenderIdleFootstepTime[bossIndex], cycle);
							}
						}
						else
						{
							animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_IdleAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderIdleFootstepTime[bossIndex], cycle);
						}
					}
				}
			}
			else
			{
				animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_SpawnAnimations, animation, sizeof(animation), playbackRate, 1, _, tempFootsteps, cycle);
			}
		}
		case STATE_WANDER:
		{
			if (NPCGetFlags(bossIndex) & SFF_WANDERMOVE)
			{
				if (!g_NpcIsCrawling[bossIndex])
				{
					switch (difficulty)
					{
						case Difficulty_Normal:
						{
							animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
						}
						case Difficulty_Hard:
						{
							bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							if (!animationFound2 || strcmp(animation, "") <= 0)
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							}
						}
						case Difficulty_Insane:
						{
							bool animationFound3 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							if (!animationFound3 || strcmp(animation, "") <= 0)
							{
								bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
								if (!animationFound2 || strcmp(animation, "") <= 0)
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
								}
								else
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
								}
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							}
						}
						case Difficulty_Nightmare:
						{
							bool animationFound4 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							if (!animationFound4 || strcmp(animation, "") <= 0)
							{
								bool animationFound3 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
								if (!animationFound3 || strcmp(animation, "") <= 0)
								{
									bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
									if (!animationFound2 || strcmp(animation, "") <= 0)
									{
										animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
									}
									else
									{
										animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
									}
								}
								else
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
								}
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							}
						}
						case Difficulty_Apollyon:
						{
							bool animationFound5 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							if (!animationFound5 || strcmp(animation, "") <= 0)
							{
								bool animationFound4 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 4, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
								if (!animationFound4 || strcmp(animation, "") <= 0)
								{
									bool animationFound3 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
									if (!animationFound3 || strcmp(animation, "") <= 0)
									{
										bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
										if (!animationFound2 || strcmp(animation, "") <= 0)
										{
											animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
										}
										else
										{
											animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
										}
									}
									else
									{
										animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
									}
								}
								else
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 4, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
								}
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							}
						}
					}
				}
				else
				{
					switch (difficulty)
					{
						case Difficulty_Normal:
						{
							animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
						}
						case Difficulty_Hard:
						{
							bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							if (!animationFound2 || strcmp(animation, "") <= 0)
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							}
						}
						case Difficulty_Insane:
						{
							bool animationFound3 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							if (!animationFound3 || strcmp(animation, "") <= 0)
							{
								bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
								if (!animationFound2 || strcmp(animation, "") <= 0)
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
								}
								else
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
								}
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							}
						}
						case Difficulty_Nightmare:
						{
							bool animationFound4 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							if (!animationFound4 || strcmp(animation, "") <= 0)
							{
								bool animationFound3 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
								if (!animationFound3 || strcmp(animation, "") <= 0)
								{
									bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
									if (!animationFound2 || strcmp(animation, "") <= 0)
									{
										animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
									}
									else
									{
										animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
									}
								}
								else
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
								}
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							}
						}
						case Difficulty_Apollyon:
						{
							bool animationFound5 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							if (!animationFound5 || strcmp(animation, "") <= 0)
							{
								bool animationFound4 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 4, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
								if (!animationFound4 || strcmp(animation, "") <= 0)
								{
									bool animationFound3 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
									if (!animationFound3 || strcmp(animation, "") <= 0)
									{
										bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
										if (!animationFound2 || strcmp(animation, "") <= 0)
										{
											animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
										}
										else
										{
											animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
										}
									}
									else
									{
										animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
									}
								}
								else
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 4, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
								}
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							}
						}
					}
				}
			}
		}
		case STATE_ALERT:
		{
			if (!g_NpcIsCrawling[bossIndex])
			{
				if (NPCChaserCanUseAlertWalkingAnimation(bossIndex))
				{
					switch (difficulty)
					{
						case Difficulty_Normal:
						{
							animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAlertAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
						}
						case Difficulty_Hard:
						{
							bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAlertAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							if (!animationFound2 || strcmp(animation, "") <= 0)
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAlertAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAlertAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							}
						}
						case Difficulty_Insane:
						{
							bool animationFound3 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAlertAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							if (!animationFound3 || strcmp(animation, "") <= 0)
							{
								bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAlertAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
								if (!animationFound2 || strcmp(animation, "") <= 0)
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAlertAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
								}
								else
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAlertAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
								}
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAlertAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							}
						}
						case Difficulty_Nightmare:
						{
							bool animationFound4 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAlertAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							if (!animationFound4 || strcmp(animation, "") <= 0)
							{
								bool animationFound3 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAlertAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
								if (!animationFound3 || strcmp(animation, "") <= 0)
								{
									bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAlertAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
									if (!animationFound2 || strcmp(animation, "") <= 0)
									{
										animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAlertAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
									}
									else
									{
										animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAlertAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
									}
								}
								else
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAlertAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
								}
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAlertAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							}
						}
						case Difficulty_Apollyon:
						{
							bool animationFound5 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAlertAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							if (!animationFound5 || strcmp(animation, "") <= 0)
							{
								bool animationFound4 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAlertAnimations, animation, sizeof(animation), playbackRate, 4, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
								if (!animationFound4 || strcmp(animation, "") <= 0)
								{
									bool animationFound3 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAlertAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
									if (!animationFound3 || strcmp(animation, "") <= 0)
									{
										bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAlertAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
										if (!animationFound2 || strcmp(animation, "") <= 0)
										{
											animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAlertAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
										}
										else
										{
											animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAlertAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
										}
									}
									else
									{
										animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAlertAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
									}
								}
								else
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAlertAnimations, animation, sizeof(animation), playbackRate, 4, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
								}
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAlertAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex], cycle);
							}
						}
					}
				}
				else
				{
					switch (difficulty)
					{
						case Difficulty_Normal:
						{
							animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex]);
						}
						case Difficulty_Hard:
						{
							bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex]);
							if (!animationFound2 || strcmp(animation, "") <= 0)
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderWalkFootstepTime[bossIndex]);
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex]);
							}
						}
						case Difficulty_Insane:
						{
							bool animationFound3 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex]);
							if (!animationFound3 || strcmp(animation, "") <= 0)
							{
								bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex]);
								if (!animationFound2 || strcmp(animation, "") <= 0)
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderWalkFootstepTime[bossIndex]);
								}
								else
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex]);
								}
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex]);
							}
						}
						case Difficulty_Nightmare:
						{
							bool animationFound4 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex]);
							if (!animationFound4 || strcmp(animation, "") <= 0)
							{
								bool animationFound3 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderWalkFootstepTime[bossIndex]);
								if (!animationFound3 || strcmp(animation, "") <= 0)
								{
									bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex]);
									if (!animationFound2 || strcmp(animation, "") <= 0)
									{
										animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderWalkFootstepTime[bossIndex]);
									}
									else
									{
										animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex]);
									}
								}
								else
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderWalkFootstepTime[bossIndex]);
								}
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex]);
							}
						}
						case Difficulty_Apollyon:
						{
							bool animationFound5 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex]);
							if (!animationFound5 || strcmp(animation, "") <= 0)
							{
								bool animationFound4 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 4, _, g_SlenderWalkFootstepTime[bossIndex]);
								if (!animationFound4 || strcmp(animation, "") <= 0)
								{
									bool animationFound3 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderWalkFootstepTime[bossIndex]);
									if (!animationFound3 || strcmp(animation, "") <= 0)
									{
										bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex]);
										if (!animationFound2 || strcmp(animation, "") <= 0)
										{
											animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderWalkFootstepTime[bossIndex]);
										}
										else
										{
											animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex]);
										}
									}
									else
									{
										animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderWalkFootstepTime[bossIndex]);
									}
								}
								else
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, 4, _, g_SlenderWalkFootstepTime[bossIndex]);
								}
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_WalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex]);
							}
						}
					}
				}
			}
			else
			{
				switch (difficulty)
				{
					case Difficulty_Normal:
					{
						animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex]);
					}
					case Difficulty_Hard:
					{
						bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex]);
						if (!animationFound2 || strcmp(animation, "") <= 0)
						{
							animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderWalkFootstepTime[bossIndex]);
						}
						else
						{
							animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex]);
						}
					}
					case Difficulty_Insane:
					{
						bool animationFound3 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex]);
						if (!animationFound3 || strcmp(animation, "") <= 0)
						{
							bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex]);
							if (!animationFound2 || strcmp(animation, "") <= 0)
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderWalkFootstepTime[bossIndex]);
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex]);
							}
						}
						else
						{
							animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex]);
						}
					}
					case Difficulty_Nightmare:
					{
						bool animationFound4 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex]);
						if (!animationFound4 || strcmp(animation, "") <= 0)
						{
							bool animationFound3 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderWalkFootstepTime[bossIndex]);
							if (!animationFound3 || strcmp(animation, "") <= 0)
							{
								bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex]);
								if (!animationFound2 || strcmp(animation, "") <= 0)
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderWalkFootstepTime[bossIndex]);
								}
								else
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex]);
								}
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderWalkFootstepTime[bossIndex]);
							}
						}
						else
						{
							animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex]);
						}
					}
					case Difficulty_Apollyon:
					{
						bool animationFound5 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex]);
						if (!animationFound5 || strcmp(animation, "") <= 0)
						{
							bool animationFound4 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 4, _, g_SlenderWalkFootstepTime[bossIndex]);
							if (!animationFound4 || strcmp(animation, "") <= 0)
							{
								bool animationFound3 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderWalkFootstepTime[bossIndex]);
								if (!animationFound3 || strcmp(animation, "") <= 0)
								{
									bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex]);
									if (!animationFound2 || strcmp(animation, "") <= 0)
									{
										animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderWalkFootstepTime[bossIndex]);
									}
									else
									{
										animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderWalkFootstepTime[bossIndex]);
									}
								}
								else
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderWalkFootstepTime[bossIndex]);
								}
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, 4, _, g_SlenderWalkFootstepTime[bossIndex]);
							}
						}
						else
						{
							animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CrawlWalkAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderWalkFootstepTime[bossIndex]);
						}
					}
				}
			}
		}
		case STATE_CHASE:
		{
			if (!g_NpcUsesChaseInitialAnimation[bossIndex] && 
			!g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex] && 
			!g_NpcUsesHealAnimation[bossIndex] && !g_NpcUseStartFleeAnimation[bossIndex] && 
			!g_NpcUsesCloakStartAnimation[bossIndex] && !g_NpcUsesCloakEndAnimation[bossIndex] && !g_NpcIsCrawling[bossIndex])
			{
				switch (difficulty)
				{
					case Difficulty_Normal:
					{
						animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RunAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderRunFootstepTime[bossIndex], cycle);
					}
					case Difficulty_Hard:
					{
						bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RunAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderRunFootstepTime[bossIndex], cycle);
						if (!animationFound2 || strcmp(animation, "") <= 0)
						{
							animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RunAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderRunFootstepTime[bossIndex], cycle);
						}
						else
						{
							animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RunAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderRunFootstepTime[bossIndex], cycle);
						}
					}
					case Difficulty_Insane:
					{
						bool animationFound3 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RunAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderRunFootstepTime[bossIndex], cycle);
						if (!animationFound3 || strcmp(animation, "") <= 0)
						{
							bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RunAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderRunFootstepTime[bossIndex], cycle);
							if (!animationFound2 || strcmp(animation, "") <= 0)
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RunAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderRunFootstepTime[bossIndex], cycle);
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RunAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderRunFootstepTime[bossIndex], cycle);
							}
						}
						else
						{
							animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RunAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderRunFootstepTime[bossIndex], cycle);
						}
					}
					case Difficulty_Nightmare:
					{
						bool animationFound4 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RunAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderRunFootstepTime[bossIndex], cycle);
						if (!animationFound4 || strcmp(animation, "") <= 0)
						{
							bool animationFound3 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RunAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderRunFootstepTime[bossIndex], cycle);
							if (!animationFound3 || strcmp(animation, "") <= 0)
							{
								bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RunAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderRunFootstepTime[bossIndex], cycle);
								if (!animationFound2 || strcmp(animation, "") <= 0)
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RunAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderRunFootstepTime[bossIndex], cycle);
								}
								else
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RunAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderRunFootstepTime[bossIndex], cycle);
								}
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RunAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderRunFootstepTime[bossIndex], cycle);
							}
						}
						else
						{
							animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RunAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderRunFootstepTime[bossIndex], cycle);
						}
					}
					case Difficulty_Apollyon:
					{
						bool animationFound5 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RunAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderRunFootstepTime[bossIndex], cycle);
						if (!animationFound5 || strcmp(animation, "") <= 0)
						{
							bool animationFound4 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RunAnimations, animation, sizeof(animation), playbackRate, 4, _, g_SlenderRunFootstepTime[bossIndex], cycle);
							if (!animationFound4 || strcmp(animation, "") <= 0)
							{
								bool animationFound3 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RunAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderRunFootstepTime[bossIndex], cycle);
								if (!animationFound3 || strcmp(animation, "") <= 0)
								{
									bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RunAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderRunFootstepTime[bossIndex], cycle);
									if (!animationFound2 || strcmp(animation, "") <= 0)
									{
										animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RunAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderRunFootstepTime[bossIndex], cycle);
									}
									else
									{
										animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RunAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderRunFootstepTime[bossIndex], cycle);
									}
								}
								else
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RunAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderRunFootstepTime[bossIndex], cycle);
								}
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RunAnimations, animation, sizeof(animation), playbackRate, 4, _, g_SlenderRunFootstepTime[bossIndex], cycle);
							}
						}
						else
						{
							animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RunAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderRunFootstepTime[bossIndex], cycle);
						}
					}
				}
			}
			else if (g_NpcUsesChaseInitialAnimation[bossIndex])
			{
				animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_ChaseInitialAnimations, animation, sizeof(animation), playbackRate, 1, _, tempFootsteps, cycle);
			}
			else if (g_NpcUsesRageAnimation1[bossIndex] || g_NpcUsesRageAnimation2[bossIndex] || g_NpcUsesRageAnimation3[bossIndex])
			{
				animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_RageAnimations, animation, sizeof(animation), playbackRate, 1, _, tempFootsteps, cycle);
			}
			else if (g_NpcUsesCloakStartAnimation[bossIndex])
			{
				animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CloakStartAnimations, animation, sizeof(animation), playbackRate, 1, _, tempFootsteps, cycle);
			}
			else if (g_NpcUsesCloakEndAnimation[bossIndex])
			{
				animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_CloakEndAnimations, animation, sizeof(animation), playbackRate, 1, _, tempFootsteps, cycle);
			}
			else if (g_NpcIsCrawling[bossIndex] && !g_NpcUsesChaseInitialAnimation[bossIndex] && 
			!g_NpcUsesCloakStartAnimation[bossIndex] && !g_NpcUsesCloakEndAnimation[bossIndex] &&
			!g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex])
			{
				switch (difficulty)
				{
					case Difficulty_Normal:
					{
						animationFound = GetProfileAnimation(bossIndex, profile, ChaserANimation_CrawlRunAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderRunFootstepTime[bossIndex], cycle);
					}
					case Difficulty_Hard:
					{
						bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserANimation_CrawlRunAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderRunFootstepTime[bossIndex], cycle);
						if (!animationFound2 || strcmp(animation, "") <= 0)
						{
							animationFound = GetProfileAnimation(bossIndex, profile, ChaserANimation_CrawlRunAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderRunFootstepTime[bossIndex], cycle);
						}
						else
						{
							animationFound = GetProfileAnimation(bossIndex, profile, ChaserANimation_CrawlRunAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderRunFootstepTime[bossIndex], cycle);
						}
					}
					case Difficulty_Insane:
					{
						bool animationFound3 = GetProfileAnimation(bossIndex, profile, ChaserANimation_CrawlRunAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderRunFootstepTime[bossIndex], cycle);
						if (!animationFound3 || strcmp(animation, "") <= 0)
						{
							bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserANimation_CrawlRunAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderRunFootstepTime[bossIndex], cycle);
							if (!animationFound2 || strcmp(animation, "") <= 0)
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserANimation_CrawlRunAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderRunFootstepTime[bossIndex], cycle);
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserANimation_CrawlRunAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderRunFootstepTime[bossIndex], cycle);
							}
						}
						else
						{
							animationFound = GetProfileAnimation(bossIndex, profile, ChaserANimation_CrawlRunAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderRunFootstepTime[bossIndex], cycle);
						}
					}
					case Difficulty_Nightmare:
					{
						bool animationFound4 = GetProfileAnimation(bossIndex, profile, ChaserANimation_CrawlRunAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderRunFootstepTime[bossIndex], cycle);
						if (!animationFound4 || strcmp(animation, "") <= 0)
						{
							bool animationFound3 = GetProfileAnimation(bossIndex, profile, ChaserANimation_CrawlRunAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderRunFootstepTime[bossIndex], cycle);
							if (!animationFound3 || strcmp(animation, "") <= 0)
							{
								bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserANimation_CrawlRunAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderRunFootstepTime[bossIndex], cycle);
								if (!animationFound2 || strcmp(animation, "") <= 0)
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserANimation_CrawlRunAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderRunFootstepTime[bossIndex], cycle);
								}
								else
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserANimation_CrawlRunAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderRunFootstepTime[bossIndex], cycle);
								}
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserANimation_CrawlRunAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderRunFootstepTime[bossIndex], cycle);
							}
						}
						else
						{
							animationFound = GetProfileAnimation(bossIndex, profile, ChaserANimation_CrawlRunAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderRunFootstepTime[bossIndex], cycle);
						}
					}
					case Difficulty_Apollyon:
					{
						bool animationFound5 = GetProfileAnimation(bossIndex, profile, ChaserANimation_CrawlRunAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderRunFootstepTime[bossIndex], cycle);
						if (!animationFound5 || strcmp(animation, "") <= 0)
						{
							bool animationFound4 = GetProfileAnimation(bossIndex, profile, ChaserANimation_CrawlRunAnimations, animation, sizeof(animation), playbackRate, 4, _, g_SlenderRunFootstepTime[bossIndex], cycle);
							if (!animationFound4 || strcmp(animation, "") <= 0)
							{
								bool animationFound3 = GetProfileAnimation(bossIndex, profile, ChaserANimation_CrawlRunAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderRunFootstepTime[bossIndex], cycle);
								if (!animationFound3 || strcmp(animation, "") <= 0)
								{
									bool animationFound2 = GetProfileAnimation(bossIndex, profile, ChaserANimation_CrawlRunAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderRunFootstepTime[bossIndex], cycle);
									if (!animationFound2 || strcmp(animation, "") <= 0)
									{
										animationFound = GetProfileAnimation(bossIndex, profile, ChaserANimation_CrawlRunAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderRunFootstepTime[bossIndex], cycle);
									}
									else
									{
										animationFound = GetProfileAnimation(bossIndex, profile, ChaserANimation_CrawlRunAnimations, animation, sizeof(animation), playbackRate, 2, _, g_SlenderRunFootstepTime[bossIndex], cycle);
									}
								}
								else
								{
									animationFound = GetProfileAnimation(bossIndex, profile, ChaserANimation_CrawlRunAnimations, animation, sizeof(animation), playbackRate, 3, _, g_SlenderRunFootstepTime[bossIndex], cycle);
								}
							}
							else
							{
								animationFound = GetProfileAnimation(bossIndex, profile, ChaserANimation_CrawlRunAnimations, animation, sizeof(animation), playbackRate, 4, _, g_SlenderRunFootstepTime[bossIndex], cycle);
							}
						}
						else
						{
							animationFound = GetProfileAnimation(bossIndex, profile, ChaserANimation_CrawlRunAnimations, animation, sizeof(animation), playbackRate, difficulty, _, g_SlenderRunFootstepTime[bossIndex], cycle);
						}
					}
				}
			}
		}
		case STATE_ATTACK:
		{
			if (!g_NpcUseFireAnimation[bossIndex])
			{
				animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_AttackAnimations, animation, sizeof(animation), playbackRate, 1, NPCGetCurrentAttackIndex(bossIndex) + 1, g_SlenderAttackFootstepTime[bossIndex], cycle);
			}
			else
			{
				animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_ShootAnimations, animation, sizeof(animation), playbackRate, 1, NPCGetCurrentAttackIndex(bossIndex) + 1, g_SlenderAttackFootstepTime[bossIndex], cycle);
			}
		}
		case STATE_STUN:
		{
			animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_StunAnimations, animation, sizeof(animation), playbackRate, 1, _, g_SlenderStunFootstepTime[bossIndex], cycle);
		}
		case STATE_DEATHCAM:
		{
			animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_DeathcamAnimations, animation, sizeof(animation), playbackRate, 1, _, tempFootsteps, cycle);
		}
	}
	switch (state)
	{
		case STATE_IDLE, STATE_WANDER, STATE_ALERT, STATE_CHASE:
		{
			if (g_NpcUseStartFleeAnimation[bossIndex])
			{
				animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_FleeInitialAnimations, animation, sizeof(animation), playbackRate, 1, _, tempFootsteps, cycle);
			}
			else if (g_NpcUsesHealAnimation[bossIndex])
			{
				animationFound = GetProfileAnimation(bossIndex, profile, ChaserAnimation_HealAnimations, animation, sizeof(animation), playbackRate, 1, _, tempFootsteps, cycle);
			}
		}
	}
	
	if (playbackRate < -12.0)
	{
		playbackRate = -12.0;
	}
	if (playbackRate > 12.0)
	{
		playbackRate = 12.0;
	}
	
	if (animationFound && strcmp(animation, "") != 0)
	{
		Action action = Plugin_Continue;
		Call_StartForward(g_OnBossAnimationUpdateFwd);
		Call_PushCell(bossIndex);
		Call_Finish(action);
		if (action != Plugin_Handled)
		{
			g_NpcCurrentAnimationSequencePlaybackRate[bossIndex] = playbackRate;
			g_NpcCurrentAnimationSequence[bossIndex] = EntitySetAnimation(ent, animation, playbackRate, _, cycle);
			g_sNPCurrentAnimationSequenceName[bossIndex] = animation;
			EntitySetAnimation(ent, animation, playbackRate, _, cycle); //Fix an issue where an anim could start on the wrong frame.
			if (g_NpcCurrentAnimationSequence[bossIndex] <= -1)
			{
				g_NpcCurrentAnimationSequence[bossIndex] = 0;
				//SendDebugMessageToPlayers(DEBUG_BOSS_ANIMATION, 0, "INVALID ANIMATION %s", animation);
			}
			bool bAnimationLoop = (state == STATE_IDLE || state == STATE_ALERT || 
			(state == STATE_CHASE && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex] && !g_NpcUseStartFleeAnimation[bossIndex] && !g_NpcUsesHealAnimation[bossIndex] && !g_NpcUsesCloakStartAnimation[bossIndex] && !g_NpcUsesCloakEndAnimation[bossIndex]) 
			|| state == STATE_WANDER);
			if (state == STATE_ATTACK && NPCChaserGetAttackWhileRunningState(bossIndex, NPCGetCurrentAttackIndex(bossIndex)))
			{
				bAnimationLoop = view_as<bool>(GetProfileAttackNum(profile, "attack_override_loop", GetEntProp(ent, Prop_Data, "m_bSequenceLoops"), NPCGetCurrentAttackIndex(bossIndex)));
			}
			if (state == STATE_CHASE && g_NpcUsesChaseInitialAnimation[bossIndex])
			{
				bAnimationLoop = view_as<bool>(GetProfileNum(profile, "chase_initial_override_loop", GetEntProp(ent, Prop_Data, "m_bSequenceLoops")));
			}
			SetEntProp(ent, Prop_Data, "m_bSequenceLoops", bAnimationLoop);
		}
	}
	if (state == STATE_ATTACK && NPCChaserGetAttackGestureState(bossIndex, NPCGetCurrentAttackIndex(bossIndex)))
	{
		float gestureCycle, duration;
		animationFound = GetProfileGesture(bossIndex, profile, ChaserAnimation_AttackAnimations, animation, sizeof(animation), playbackRate, cycle, NPCGetCurrentAttackIndex(bossIndex) + 1);
		if (animationFound && strcmp(animation, "") != 0)
		{
			CBaseCombatCharacter overlay = CBaseCombatCharacter(ent);
			int gesture = overlay.LookupSequence(animation);
			if (gesture != -1)
			{
				duration = overlay.SequenceDuration(gesture);
				int layer = overlay.AddLayeredSequence(gesture, 1);
				overlay.SetLayerDuration(layer, duration);
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

stock void SlenderAlertAllValidBosses(int bossIndex, int target = -1, int bestTarget = -1)
{
	int slender = NPCGetEntIndex(bossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return;
	}
	float myPos[3];
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", myPos);
	int difficulty = GetLocalGlobalDifficulty(bossIndex);
	if (NPCHasAttribute(bossIndex, "alert copies"))
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
					SlenderPerformVoice(bossCheck, "sound_chaseenemyinitial", _, NPCChaserNormalSoundHookEnabled(bossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
					if (NPCChaserCanUseChaseInitialAnimation(bossCheck) && !g_NpcUsesChaseInitialAnimation[bossCheck] && !SF_IsSlaughterRunMap())
					{
						int copySlender = NPCGetEntIndex(bossCheck);
						if (copySlender && copySlender != INVALID_ENT_REFERENCE && g_SlenderChaseInitialTimer[bossCheck] == null && g_NpcChaseOnLookTarget[bossCheck].Length <= 0)
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
							g_SlenderChaseInitialTimer[bossCheck] = CreateTimer(GetProfileFloat(profile, "chase_initial_timer", 0.0), Timer_SlenderChaseInitialTimer, EntIndexToEntRef(copySlender), TIMER_FLAG_NO_MAPCHANGE);
						}
					}
				}
			}
		}
	}
	if (NPCHasAttribute(bossIndex, "alert companions"))
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
					SlenderPerformVoice(bossCheck, "sound_chaseenemyinitial", _, NPCChaserNormalSoundHookEnabled(bossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
					if (NPCChaserCanUseChaseInitialAnimation(bossCheck) && !g_NpcUsesChaseInitialAnimation[bossCheck] && !SF_IsSlaughterRunMap())
					{
						int copySlender = NPCGetEntIndex(bossCheck);
						if (copySlender && copySlender != INVALID_ENT_REFERENCE && g_SlenderChaseInitialTimer[bossCheck] == null && g_NpcChaseOnLookTarget[bossCheck].Length <= 0)
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
							g_SlenderChaseInitialTimer[bossCheck] = CreateTimer(GetProfileFloat(profile, "chase_initial_timer", 0.0), Timer_SlenderChaseInitialTimer, EntIndexToEntRef(copySlender), TIMER_FLAG_NO_MAPCHANGE);
						}
					}
				}
			}
		}
	}
}

public Action Timer_SlenderChaseInitialTimer(Handle timer, any entref)
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
	//if (NPCChaserNormalSoundHookEnabled(bossIndex)) g_SlenderNextVoiceSound[bossIndex] = 0.0;
	return Plugin_Stop;
}

public Action Timer_SlenderRageOneTimer(Handle timer, any entref)
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
	
	if (!g_NpcUsesRageAnimation1[bossIndex])
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
	
	g_NpcUsesRageAnimation1[bossIndex] = false;
	g_LastStuckTime[bossIndex] = 0.0;
	loco.ClearStuckStatus();
	if (state != STATE_ATTACK)
	{
		NPCChaserUpdateBossAnimation(bossIndex, slender, state);
	}
	return Plugin_Stop;
}

public Action Timer_SlenderRageTwoTimer(Handle timer, any entref)
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
	
	if (!g_NpcUsesRageAnimation2[bossIndex])
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
	
	g_NpcUsesRageAnimation2[bossIndex] = false;
	g_LastStuckTime[bossIndex] = 0.0;
	loco.ClearStuckStatus();
	if (state != STATE_ATTACK)
	{
		NPCChaserUpdateBossAnimation(bossIndex, slender, state);
	}
	return Plugin_Stop;
}

public Action Timer_SlenderRageThreeTimer(Handle timer, any entref)
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
	
	if (!g_NpcUsesRageAnimation3[bossIndex])
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
	
	g_NpcUsesRageAnimation3[bossIndex] = false;
	g_LastStuckTime[bossIndex] = 0.0;
	loco.ClearStuckStatus();
	if (state != STATE_ATTACK)
	{
		NPCChaserUpdateBossAnimation(bossIndex, slender, state);
	}
	return Plugin_Stop;
}

public Action Timer_SlenderSpawnTimer(Handle timer, any entref)
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
	g_SlenderSpawning[bossIndex] = false;
	g_LastStuckTime[bossIndex] = 0.0;
	loco.ClearStuckStatus();
	g_SlenderEntityThink[bossIndex] = CreateTimer(BOSS_THINKRATE, Timer_SlenderChaseBossThink, EntIndexToEntRef(slender), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	NPCChaserUpdateBossAnimation(bossIndex, slender, STATE_IDLE);
	return Plugin_Stop;
}

public Action Timer_SlenderHealAnimationTimer(Handle timer, any entref)
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
	return Plugin_Stop;
}

public Action Timer_SlenderHealDelayTimer(Handle timer, any entref)
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
	
	SlenderPerformVoice(bossIndex, "sound_heal_self", _, NPCChaserNormalSoundHookEnabled(bossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
	
	g_NpcHealCount[bossIndex] = 0;
	
	g_SlenderHealEventTimer[bossIndex] = CreateTimer(0.05, Timer_SlenderHealEventTimer, EntIndexToEntRef(slender), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	return Plugin_Stop;
}

public Action Timer_SlenderHealEventTimer(Handle timer, any entref)
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

public Action Timer_SlenderFleeAnimationTimer(Handle timer, any entref)
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
public MRESReturn ShouldCollideWith(Address thisAddress, DHookReturn returnHandle, DHookParam params)
{
	int entity = params.Get(1);
	if (IsValidEntity(entity))
	{
		char class[32];
		GetEdictClassname(entity, class, sizeof(class));
		if (strcmp(class, "tf_zombie") == 0)
		{
			returnHandle.Value = false;
			return MRES_Supercede;
		}
		else if (strcmp(class, "base_boss") == 0)
		{
			returnHandle.Value = false;
			return MRES_Supercede;
		}
		else if (strcmp(class, "base_npc") == 0)
		{
			returnHandle.Value = false;
			return MRES_Supercede;
		}
		else if (strcmp(class, "player") == 0)
		{
			if (g_PlayerProxy[entity] || IsClientInGhostMode(entity) || IsClientInDeathCam(entity) || GetClientTeam(entity) == TFTeam_Blue || IsClientInDeathCam(entity))
			{
				returnHandle.Value = false;
				return MRES_Supercede;
			}
		}
		else if (IsEntityAProjectile(entity))
		{
			returnHandle.Value = false;
			return MRES_Supercede;
		}
	}
	return MRES_Ignored;
}

public MRESReturn CBaseAnimating_HandleAnimEvent(int thisInt, DHookParam params)
{
	int bossIndex = NPCGetFromEntIndex(thisInt);
	int event = params.GetObjectVar(1, 0, ObjectValueType_Int);
	if (event > 0 && NPCGetUniqueID(bossIndex) != -1)
	{
		char keyValue[256];
		FormatEx(keyValue, sizeof(keyValue), "sound_footsteps_event_%i", event);
		SlenderCastFootstepAnimEvent(bossIndex, keyValue);
		FormatEx(keyValue, sizeof(keyValue), "sound_event_%i", event);
		SlenderCastAnimEvent(bossIndex, keyValue);
	}
}

public MRESReturn Hook_BossUpdateTransmitState(int bossEntity, DHookReturn hookReturn)
{
    if (!g_Enabled || !IsValidEntity(bossEntity) || NPCGetFromEntIndex(bossEntity) == -1)
    {
        return MRES_Ignored;
    }

    hookReturn.Value = SetEntityTransmitState(bossEntity, FL_EDICT_ALWAYS);
    return MRES_Supercede;
}

public MRESReturn Hook_BossUpdateHitboxTransmitState(int bossEntity, DHookReturn hookReturn)
{
    if (!g_Enabled || !IsValidEntity(bossEntity))
    {
        return MRES_Ignored;
    }

    hookReturn.Value = SetEntityTransmitState(bossEntity, FL_EDICT_DONTSEND);
    return MRES_Supercede;
}

void SlenderDoDamageEffects(int bossIndex, int attackIndex, int client)
{
	if (!IsValidClient(client))
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
		GetProfileString(profile, "player_random_attack_indexes", allowedIndexes, sizeof(allowedIndexes), "1");
		FormatEx(indexes, sizeof(indexes), "%d", damageIndexes);
		FormatEx(currentIndex, sizeof(currentIndex), "%d", attackIndex + 1);

		int count = ExplodeString(allowedIndexes, " ", allowedIndexesList, 33, 3);
		if (count > 1)
		{
			for (int i = 0; i < count && i < NPCChaserGetAttackCount(bossIndex); i++)
			{
				int forIndex = StringToInt(allowedIndexesList[i]);
				if (forIndex == attackIndex + 1 && NPCChaserRandomEffectDuration(bossIndex, difficulty) > 0.0 && IsValidClient(client))
				{
					int randomEffect = GetRandomInt(0, 6);
					switch (randomEffect)
					{
						case 0:
						{
							TF2_AddCondition(client, TFCond_Jarated, NPCChaserRandomEffectDuration(bossIndex, difficulty));
						}
						case 1:
						{
							TF2_AddCondition(client, TFCond_Milked, NPCChaserRandomEffectDuration(bossIndex, difficulty));
						}
						case 2:
						{
							TF2_AddCondition(client, TFCond_Gas, NPCChaserRandomEffectDuration(bossIndex, difficulty));
						}
						case 3:
						{
							TF2_AddCondition(client, TFCond_MarkedForDeath, NPCChaserRandomEffectDuration(bossIndex, difficulty));
						}
						case 4:
						{
							if (!TF2_IsPlayerInCondition(client, TFCond_Bleeding))
							{
								TF2_MakeBleed(client, client, NPCChaserRandomEffectDuration(bossIndex, difficulty));
							}
						}
						case 5:
						{
							TF2_IgnitePlayer(client, client);
						}
						case 6:
						{
							switch (NPCChaserRandomEffectStunType(bossIndex))
							{
								case 1:
								{
									TF2_StunPlayer(client, NPCChaserRandomEffectDuration(bossIndex, difficulty), NPCChaserRandomEffectSlowdown(bossIndex, difficulty), TF_STUNFLAG_SLOWDOWN);
								}
								case 2:
								{
									TF2_StunPlayer(client, NPCChaserRandomEffectDuration(bossIndex, difficulty), NPCChaserRandomEffectSlowdown(bossIndex, difficulty), TF_STUNFLAGS_LOSERSTATE);
								}
								case 3:
								{
									TF2_StunPlayer(client, NPCChaserRandomEffectDuration(bossIndex, difficulty), NPCChaserRandomEffectSlowdown(bossIndex, difficulty), TF_STUNFLAG_BONKSTUCK|TF_STUNFLAG_NOSOUNDOREFFECT);
								}
								case 4:
								{
									TF2_StunPlayer(client, NPCChaserRandomEffectDuration(bossIndex, difficulty), NPCChaserRandomEffectSlowdown(bossIndex, difficulty), TF_STUNFLAGS_GHOSTSCARE);
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
				if (attackNumber == currentAtkIndex && NPCChaserRandomEffectDuration(bossIndex, difficulty) > 0.0 && IsValidClient(client))
				{
					int randomEffect = GetRandomInt(0, 6);
					switch (randomEffect)
					{
						case 0:
						{
							TF2_AddCondition(client, TFCond_Jarated, NPCChaserRandomEffectDuration(bossIndex, difficulty));
						}
						case 1:
						{
							TF2_AddCondition(client, TFCond_Milked, NPCChaserRandomEffectDuration(bossIndex, difficulty));
						}
						case 2:
						{
							TF2_AddCondition(client, TFCond_Gas, NPCChaserRandomEffectDuration(bossIndex, difficulty));
						}
						case 3:
						{
							TF2_AddCondition(client, TFCond_MarkedForDeath, NPCChaserRandomEffectDuration(bossIndex, difficulty));
						}
						case 4:
						{
							if (!TF2_IsPlayerInCondition(client, TFCond_Bleeding))
							{
								TF2_MakeBleed(client, client, NPCChaserRandomEffectDuration(bossIndex, difficulty));
							}
						}
						case 5:
						{
							TF2_IgnitePlayer(client, client);
						}
						case 6:
						{
							switch (NPCChaserRandomEffectStunType(bossIndex))
							{
								case 1:
								{
									TF2_StunPlayer(client, NPCChaserRandomEffectDuration(bossIndex, difficulty), NPCChaserRandomEffectSlowdown(bossIndex, difficulty), TF_STUNFLAG_SLOWDOWN);
								}
								case 2:
								{
									TF2_StunPlayer(client, NPCChaserRandomEffectDuration(bossIndex, difficulty), NPCChaserRandomEffectSlowdown(bossIndex, difficulty), TF_STUNFLAGS_LOSERSTATE);
								}
								case 3:
								{
									TF2_StunPlayer(client, NPCChaserRandomEffectDuration(bossIndex, difficulty), NPCChaserRandomEffectSlowdown(bossIndex, difficulty), TF_STUNFLAG_BONKSTUCK|TF_STUNFLAG_NOSOUNDOREFFECT);
								}
								case 4:
								{
									TF2_StunPlayer(client, NPCChaserRandomEffectDuration(bossIndex, difficulty), NPCChaserRandomEffectSlowdown(bossIndex, difficulty), TF_STUNFLAGS_GHOSTSCARE);
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
		GetProfileString(profile, "player_jarate_attack_indexs", allowedIndexes, sizeof(allowedIndexes), "1");
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
					GetProfileString(profile, "player_jarate_particle", jaratePlayerParticle, sizeof(jaratePlayerParticle), JARATE_PARTICLE);
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
					if (IsValidClient(client))
					{
						TF2_AddCondition(client, TFCond_Jarated, NPCChaserGetJarateDuration(bossIndex, difficulty));
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
				if (attackNumber == currentAtkIndex && NPCChaserGetJarateDuration(bossIndex, difficulty) > 0.0)
				{
					GetProfileString(profile, "player_jarate_particle", jaratePlayerParticle, sizeof(jaratePlayerParticle), JARATE_PARTICLE);
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
					if (IsValidClient(client))
					{
						TF2_AddCondition(client, TFCond_Jarated, NPCChaserGetJarateDuration(bossIndex, difficulty));
					}
				}
			}
		}
	}
	if (NPCChaserMilkPlayerOnHit(bossIndex))
	{
		char indexes[8], allowedIndexes[88], allowedIndexesList[33][3];
		char currentIndex[2];
		int damageIndexes = NPCChaserGetMilkAttackIndexes(bossIndex);
		GetProfileString(profile, "player_milk_attack_indexs", allowedIndexes, sizeof(allowedIndexes), "1");
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
					GetProfileString(profile, "player_milk_particle", milkPlayerParticle, sizeof(milkPlayerParticle), MILK_PARTICLE);
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
					if (IsValidClient(client))
					{
						TF2_AddCondition(client, TFCond_Milked, NPCChaserGetMilkDuration(bossIndex, difficulty));
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
				if (attackNumber == currentAtkIndex && NPCChaserGetMilkDuration(bossIndex, difficulty) > 0.0)
				{
					GetProfileString(profile, "player_milk_particle", milkPlayerParticle, sizeof(milkPlayerParticle), MILK_PARTICLE);
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
					if (IsValidClient(client))
					{
						TF2_AddCondition(client, TFCond_Milked, NPCChaserGetMilkDuration(bossIndex, difficulty));
					}
				}
			}
		}
	}
	if (NPCChaserGasPlayerOnHit(bossIndex))
	{
		char indexes[8], allowedIndexes[88], allowedIndexesList[33][3];
		char currentIndex[2];
		int damageIndexes = NPCChaserGetGasAttackIndexes(bossIndex);
		GetProfileString(profile, "player_gas_attack_indexs", allowedIndexes, sizeof(allowedIndexes), "1");
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
					GetProfileString(profile, "player_gas_particle", gasPlayerParticle, sizeof(gasPlayerParticle), GAS_PARTICLE);
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
					if (IsValidClient(client))
					{
						TF2_AddCondition(client, TFCond_Gas, NPCChaserGetGasDuration(bossIndex, difficulty));
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
				if (attackNumber == currentAtkIndex && NPCChaserGetGasDuration(bossIndex, difficulty) > 0.0)
				{
					GetProfileString(profile, "player_gas_particle", gasPlayerParticle, sizeof(gasPlayerParticle), GAS_PARTICLE);
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
					if (IsValidClient(client))
					{
						TF2_AddCondition(client, TFCond_Gas, NPCChaserGetGasDuration(bossIndex, difficulty));
					}
				}
			}
		}
	}
	if (NPCChaserMarkPlayerOnHit(bossIndex))
	{
		char indexes[8], allowedIndexes[88], allowedIndexesList[33][3];
		char currentIndex[2];
		int damageIndexes = NPCChaserGetMarkAttackIndexes(bossIndex);
		GetProfileString(profile, "player_mark_attack_indexs", allowedIndexes, sizeof(allowedIndexes), "1");
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
					if (IsValidClient(client))
					{
						TF2_AddCondition(client, TFCond_MarkedForDeath, NPCChaserGetMarkDuration(bossIndex, difficulty));
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
				if (attackNumber == currentAtkIndex && NPCChaserGetMarkDuration(bossIndex, difficulty))
				{
					if (IsValidClient(client))
					{
						TF2_AddCondition(client, TFCond_MarkedForDeath, NPCChaserGetMarkDuration(bossIndex, difficulty));
					}
				}
			}
		}
	}
	if (NPCChaserSilentMarkPlayerOnHit(bossIndex))
	{
		char indexes[8], allowedIndexes[88], allowedIndexesList[33][3];
		char currentIndex[2];
		int damageIndexes = NPCChaserGetSilentMarkAttackIndexes(bossIndex);
		GetProfileString(profile, "player_silent_mark_attack_indexs", allowedIndexes, sizeof(allowedIndexes), "1");
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
					if (IsValidClient(client))
					{
						TF2_AddCondition(client, TFCond_MarkedForDeathSilent, NPCChaserGetSilentMarkDuration(bossIndex, difficulty));
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
				if (attackNumber == currentAtkIndex && NPCChaserGetSilentMarkDuration(bossIndex, difficulty))
				{
					if (IsValidClient(client))
					{
						TF2_AddCondition(client, TFCond_MarkedForDeathSilent, NPCChaserGetSilentMarkDuration(bossIndex, difficulty));
					}
				}
			}
		}
	}
	if (NPCChaserIgnitePlayerOnHit(bossIndex))
	{
		char indexes[8], allowedIndexes[88], allowedIndexesList[33][3];
		char currentIndex[2];
		int damageIndexes = NPCChaserGetIgniteAttackIndexes(bossIndex);
		GetProfileString(profile, "player_ignite_attack_indexs", allowedIndexes, sizeof(allowedIndexes), "1");
		FormatEx(indexes, sizeof(indexes), "%d", damageIndexes);
		FormatEx(currentIndex, sizeof(currentIndex), "%d", attackIndex + 1);

		int count = ExplodeString(allowedIndexes, " ", allowedIndexesList, 33, 3);
		if (count > 1)
		{
			for (int i = 0; i < count && i < NPCChaserGetAttackCount(bossIndex); i++)
			{
				int forIndex = StringToInt(allowedIndexesList[i]);
				if (forIndex == attackIndex + 1 && NPCChaserGetIgniteDelay(bossIndex, difficulty) && IsValidClient(client) && g_PlayerIgniteTimer[client] == null)
				{
					g_PlayerIgniteTimer[client] = CreateTimer(NPCChaserGetIgniteDelay(bossIndex, difficulty), Timer_SlenderChaseBossAttackIgniteHit, EntIndexToEntRef(client), TIMER_FLAG_NO_MAPCHANGE);
					g_PlayerResetIgnite[client] = null;
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
				if (attackNumber == currentAtkIndex && NPCChaserGetIgniteDelay(bossIndex, difficulty) && IsValidClient(client) && g_PlayerIgniteTimer[client] == null)
				{
					g_PlayerIgniteTimer[client] = CreateTimer(NPCChaserGetIgniteDelay(bossIndex, difficulty), Timer_SlenderChaseBossAttackIgniteHit, EntIndexToEntRef(client), TIMER_FLAG_NO_MAPCHANGE);
					g_PlayerResetIgnite[client] = null;
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
		GetProfileString(profile, "player_stun_attack_indexs", allowedIndexes, sizeof(allowedIndexes), "1");

		int count = ExplodeString(allowedIndexes, " ", allowedIndexesList, 33, 3);
		if (count > 1)
		{
			for (int i = 0; i < count && i < NPCChaserGetAttackCount(bossIndex); i++)
			{
				int forIndex = StringToInt(allowedIndexesList[i]);
				if (forIndex == attackIndex + 1 && NPCChaserGetStunAttackDuration(bossIndex, difficulty))
				{
					GetProfileString(profile, "player_stun_particle", stunPlayerParticle, sizeof(stunPlayerParticle), STUN_PARTICLE);
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
					if (IsValidClient(client))
					{
						switch (NPCChaserGetStunAttackType(bossIndex))
						{
							case 1:
							{
								TF2_StunPlayer(client, NPCChaserGetStunAttackDuration(bossIndex, difficulty), NPCChaserGetStunAttackSlowdown(bossIndex, difficulty), TF_STUNFLAG_SLOWDOWN);
							}
							case 2:
							{
								TF2_StunPlayer(client, NPCChaserGetStunAttackDuration(bossIndex, difficulty), NPCChaserGetStunAttackSlowdown(bossIndex, difficulty), TF_STUNFLAGS_LOSERSTATE);
							}
							case 3:
							{
								TF2_StunPlayer(client, NPCChaserGetStunAttackDuration(bossIndex, difficulty), NPCChaserGetStunAttackSlowdown(bossIndex, difficulty), TF_STUNFLAG_BONKSTUCK|TF_STUNFLAG_NOSOUNDOREFFECT);
							}
							case 4:
							{
								TF2_StunPlayer(client, NPCChaserGetStunAttackDuration(bossIndex, difficulty), NPCChaserGetStunAttackSlowdown(bossIndex, difficulty), TF_STUNFLAGS_GHOSTSCARE);
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
				if (attackNumber == currentAtkIndex && NPCChaserGetStunAttackDuration(bossIndex, difficulty) > 0.0)
				{
					GetProfileString(profile, "player_stun_particle", stunPlayerParticle, sizeof(stunPlayerParticle), STUN_PARTICLE);
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
					if (IsValidClient(client))
					{
						switch (NPCChaserGetStunAttackType(bossIndex))
						{
							case 1:
							{
								TF2_StunPlayer(client, NPCChaserGetStunAttackDuration(bossIndex, difficulty), NPCChaserGetStunAttackSlowdown(bossIndex, difficulty), TF_STUNFLAG_SLOWDOWN);
							}
							case 2:
							{
								TF2_StunPlayer(client, NPCChaserGetStunAttackDuration(bossIndex, difficulty), NPCChaserGetStunAttackSlowdown(bossIndex, difficulty), TF_STUNFLAGS_LOSERSTATE);
							}
							case 3:
							{
								TF2_StunPlayer(client, NPCChaserGetStunAttackDuration(bossIndex, difficulty), NPCChaserGetStunAttackSlowdown(bossIndex, difficulty), TF_STUNFLAG_BONKSTUCK|TF_STUNFLAG_NOSOUNDOREFFECT);
							}
							case 4:
							{
								TF2_StunPlayer(client, NPCChaserGetStunAttackDuration(bossIndex, difficulty), NPCChaserGetStunAttackSlowdown(bossIndex, difficulty), TF_STUNFLAGS_GHOSTSCARE);
							}
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
		GetProfileString(profile, "player_bleed_attack_indexs", allowedIndexes, sizeof(allowedIndexes), "1");

		int count = ExplodeString(allowedIndexes, " ", allowedIndexesList, 33, 3);
		if (count > 1)
		{
			for (int i = 0; i < count && i < NPCChaserGetAttackCount(bossIndex); i++)
			{
				int forIndex = StringToInt(allowedIndexesList[i]);
				if (forIndex == attackIndex + 1 && NPCChaserGetBleedDuration(bossIndex, difficulty) && IsValidClient(client))
				{
					if (!TF2_IsPlayerInCondition(client, TFCond_Bleeding))
					{
						TF2_MakeBleed(client, client, NPCChaserGetBleedDuration(bossIndex, difficulty));
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
				if (attackNumber == currentAtkIndex && NPCChaserGetBleedDuration(bossIndex, difficulty) > 0.0 && IsValidClient(client))
				{
					if (!TF2_IsPlayerInCondition(client, TFCond_Bleeding))
					{
						TF2_MakeBleed(client, client, NPCChaserGetBleedDuration(bossIndex, difficulty));
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
		GetProfileString(profile, "player_electrocute_attack_indexs", allowedIndexes, sizeof(allowedIndexes), "1");

		int count = ExplodeString(allowedIndexes, " ", allowedIndexesList, 33, 3);
		if (count > 1)
		{
			for (int i = 0; i < count && i < NPCChaserGetAttackCount(bossIndex); i++)
			{
				int forIndex = StringToInt(allowedIndexesList[i]);
				if (forIndex == attackIndex + 1 && NPCChaserGetElectricDuration(bossIndex, difficulty))
				{
					GetProfileString(profile, "player_electric_red_particle", electricPlayerParticleRed, sizeof(electricPlayerParticleRed), ELECTRIC_RED_PARTICLE);
					GetProfileString(profile, "player_electric_blue_particle", electricPlayerParticleBlue, sizeof(electricPlayerParticleBlue), ELECTRIC_BLUE_PARTICLE);
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
						if (GetClientTeam(client) == TFTeam_Red)
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
						else if (GetClientTeam(client) == TFTeam_Blue)
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
						if (GetClientTeam(client) == TFTeam_Red)
						{
							SlenderCreateParticle(bossIndex, electricPlayerParticleRed, 55.0);
						}
						else if (GetClientTeam(client) == TFTeam_Blue)
						{
							SlenderCreateParticle(bossIndex, electricPlayerParticleBlue, 55.0);
						}
					}
					if (IsValidClient(client))
					{
						switch (NPCChaserGetStunAttackType(bossIndex))
						{
							case 1:
							{
								TF2_StunPlayer(client, NPCChaserGetElectricDuration(bossIndex, difficulty), NPCChaserGetElectricSlowdown(bossIndex, difficulty), TF_STUNFLAG_SLOWDOWN);
							}
							case 2:
							{
								TF2_StunPlayer(client, NPCChaserGetElectricDuration(bossIndex, difficulty), NPCChaserGetElectricSlowdown(bossIndex, difficulty), TF_STUNFLAGS_LOSERSTATE);
							}
							case 3, 4:
							{
								TF2_StunPlayer(client, NPCChaserGetElectricDuration(bossIndex, difficulty), NPCChaserGetElectricSlowdown(bossIndex, difficulty), TF_STUNFLAG_BONKSTUCK|TF_STUNFLAG_NOSOUNDOREFFECT);
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
				if (attackNumber == currentAtkIndex && NPCChaserGetElectricDuration(bossIndex, difficulty) > 0.0)
				{
					GetProfileString(profile, "player_electric_red_particle", electricPlayerParticleRed, sizeof(electricPlayerParticleRed), ELECTRIC_RED_PARTICLE);
					GetProfileString(profile, "player_electric_blue_particle", electricPlayerParticleBlue, sizeof(electricPlayerParticleBlue), ELECTRIC_BLUE_PARTICLE);
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
						if (GetClientTeam(client) == TFTeam_Red)
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
						else if (GetClientTeam(client) == TFTeam_Blue)
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
						if (GetClientTeam(client) == TFTeam_Red)
						{
							SlenderCreateParticle(bossIndex, electricPlayerParticleRed, 55.0);
						}
						else if (GetClientTeam(client) == TFTeam_Blue)
						{
							SlenderCreateParticle(bossIndex, electricPlayerParticleBlue, 55.0);
						}
					}
					if (IsValidClient(client))
					{
						switch (NPCChaserGetStunAttackType(bossIndex))
						{
							case 1:
							{
								TF2_StunPlayer(client, NPCChaserGetElectricDuration(bossIndex, difficulty), NPCChaserGetElectricSlowdown(bossIndex, difficulty), TF_STUNFLAG_SLOWDOWN);
							}
							case 2:
							{
								TF2_StunPlayer(client, NPCChaserGetElectricDuration(bossIndex, difficulty), NPCChaserGetElectricSlowdown(bossIndex, difficulty), TF_STUNFLAGS_LOSERSTATE);
							}
							case 3, 4:
							{
								TF2_StunPlayer(client, NPCChaserGetElectricDuration(bossIndex, difficulty), NPCChaserGetElectricSlowdown(bossIndex, difficulty), TF_STUNFLAG_BONKSTUCK|TF_STUNFLAG_NOSOUNDOREFFECT);
							}
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
		GetProfileString(profile, "player_smite_attack_indexs", allowedIndexes, sizeof(allowedIndexes), "1");

		int count = ExplodeString(allowedIndexes, " ", allowedIndexesList, 33, 3);
		if (count > 1)
		{
			for (int i = 0; i < count && i < NPCChaserGetAttackCount(bossIndex); i++)
			{
				int forIndex = StringToInt(allowedIndexesList[i]);
				if (forIndex == attackIndex + 1)
				{
					PerformSmiteBoss(bossIndex, client, EntIndexToEntRef(slender));
					SDKHooks_TakeDamage(client, slender, slender, NPCChaserGetSmiteDamage(bossIndex), NPCChaserGetSmiteDamageType(bossIndex), _, view_as<float>( { 0.0, 0.0, 0.0 } ), flMyEyePos);
					if (IsValidClient(client))
					{
						ClientViewPunch(client, view_as<float>( { 0.0, 0.0, 0.0 } ));
						if (NPCChaserSmitePlayerMessage(bossIndex))
						{
							char player[32];
							FormatEx(player, sizeof(player), "%N", client);
							
							char name[SF2_MAX_NAME_LENGTH];
							NPCGetBossName(bossIndex, name, sizeof(name));
							if (name[0] == '\0')
							{
								strcopy(name, sizeof(name), profile);
							}
							if (GetClientTeam(client) == 2)
							{
								CPrintToChatAll("{royalblue}%t{default}%t", "SF2 Prefix", "SF2 Smote target", name, player);
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
				if (attackNumber == currentAtkIndex)
				{
					PerformSmiteBoss(bossIndex, client, EntIndexToEntRef(slender));
					SDKHooks_TakeDamage(client, slender, slender, NPCChaserGetSmiteDamage(bossIndex), NPCChaserGetSmiteDamageType(bossIndex), _, view_as<float>( { 0.0, 0.0, 0.0 } ), flMyEyePos);
					if (IsValidClient(client))
					{
						ClientViewPunch(client, view_as<float>( { 0.0, 0.0, 0.0 } ));
						if (NPCChaserSmitePlayerMessage(bossIndex))
						{
							char player[32];
							FormatEx(player, sizeof(player), "%N", client);
							
							char name[SF2_MAX_NAME_LENGTH];
							NPCGetBossName(bossIndex, name, sizeof(name));
							if (name[0] == '\0')
							{
								strcopy(name, sizeof(name), profile);
							}
							if (GetClientTeam(client) == 2)
							{
								CPrintToChatAll("{royalblue}%t{default}%t", "SF2 Prefix", "SF2 Smote target", name, player);
							}
						}
					}
				}
			}
		}
	}
}

static bool NPCPropPhysicsAttack(int bossIndex, int prop)
{
	char buffer[PLATFORM_MAX_PATH], profile[SF2_MAX_PROFILE_NAME_LENGTH], model[SF2_MAX_PROFILE_NAME_LENGTH], key[64];
	NPCGetProfile(bossIndex, profile, sizeof(profile));
	g_Config.Rewind();
	g_Config.JumpToKey(profile);
	if (!IsValidEntity(prop))
	{
		return false;
	}
	GetEntPropString(prop, Prop_Data, "m_ModelName", model, sizeof(model));
	if (!g_Config.JumpToKey("attack_props_physics_models"))
	{
		return true;
	}
	bool bFound = false;
	for (int i = 1; ; i++)
	{
		FormatEx(key, sizeof(key), "%d", i);
		g_Config.GetString(key, buffer, PLATFORM_MAX_PATH);
		if (buffer[0] == '\0')
		{
			break;
		}
		if (strcmp(buffer, model) == 0)
		{
			bFound = true;
			break;
		}
	}
	return bFound;
}
stock void NPC_DropKey(int bossIndex)
{
	char buffer[PLATFORM_MAX_PATH], profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));
	g_Config.Rewind();
	g_Config.JumpToKey(profile);
	g_Config.GetString("key_trigger", buffer, PLATFORM_MAX_PATH);
	if (buffer[0] != '\0')
	{
		float myPos[3], vel[3];
		int boss = NPCGetEntIndex(bossIndex);
		GetEntPropVector(boss, Prop_Data, "m_vecAbsOrigin", myPos);
		Format(buffer, PLATFORM_MAX_PATH, "sf2_key_%s", buffer);
		
		int touchBox = CreateEntityByName("tf_halloween_pickup");
		//To do: allow the cfg maker to change the model.
		DispatchKeyValue(touchBox, "targetname", buffer);
		//New key model
		GetProfileString(profile, "key_model", keyModel, sizeof(keyModel));
		if (keyModel[0] == '\0')
		{
			DispatchKeyValue(touchBox, "powerup_model", SF_KEYMODEL);
		}
		else
		{
			DispatchKeyValue(touchBox, "powerup_model", keyModel);
		}
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
		//To do: allow the cfg maker to change the model.
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
		//To do: allow the cfg maker to change the model.
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
public void KeyTrigger(const char[] output, int caller, int activator, float delay)
{
	TriggerKey(caller);
}

public Action Hook_KeySetTransmit(int entity, int iOther)
{
	if (!IsValidClient(iOther))
	{
		return Plugin_Continue;
	}
	
	if (g_PlayerEliminated[iOther] && IsClientInGhostMode(iOther))
	{
		return Plugin_Continue;
	}
	
	if (!g_PlayerEliminated[iOther])
	{
		return Plugin_Continue;
	}
	
	return Plugin_Handled;
}

public Action CollectKey(Handle timer, any entref)
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


stock void TriggerKey(int caller)
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
stock bool NPC_CanAttackProps(int bossIndex, float flAttackRange, float flAttackFOV)
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
stock void CBaseNPC_OnStuck(NextBotAction action, int actor)
{
	return;
}