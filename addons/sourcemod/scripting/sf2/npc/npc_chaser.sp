#if defined _sf2_npc_chaser_included
#endinput
#endif
#define _sf2_npc_chaser_included

static float g_flNPCWalkSpeed[MAX_BOSSES][Difficulty_Max];
static float g_flNPCMaxWalkSpeed[MAX_BOSSES][Difficulty_Max];

static float g_flNPCWakeRadius[MAX_BOSSES];

static bool g_bNPCStunEnabled[MAX_BOSSES];
static float g_flNPCStunDuration[MAX_BOSSES];
static float g_flNPCStunCooldown[MAX_BOSSES];
static bool g_bNPCStunFlashlightEnabled[MAX_BOSSES];
static bool g_bNPCHasKeyDrop[MAX_BOSSES];
static float g_flNPCStunFlashlightDamage[MAX_BOSSES];
static float g_flNPCStunInitialHealth[MAX_BOSSES];
static float g_flNPCStunAddHealth[MAX_BOSSES];
static float g_flNPCStunHealth[MAX_BOSSES];
static bool g_bNPCChaseInitialOnStun[MAX_BOSSES];

static float g_flNPCAlertGracetime[MAX_BOSSES][Difficulty_Max];
static float g_flNPCAlertDuration[MAX_BOSSES][Difficulty_Max];
static float g_flNPCChaseDuration[MAX_BOSSES][Difficulty_Max];

static bool g_bNPCCloakEnabled[MAX_BOSSES];
static float g_flNPCCloakCooldown[MAX_BOSSES][Difficulty_Max];
static float g_flNPCCloakRange[MAX_BOSSES][Difficulty_Max];
static float g_flNPCDecloakRange[MAX_BOSSES][Difficulty_Max];
static float g_flNPCCloakDuration[MAX_BOSSES][Difficulty_Max];
float g_flNPCNextDecloakTime[MAX_BOSSES];
static float g_flNPCCloakSpeedMultiplier[MAX_BOSSES][Difficulty_Max];

static bool g_bNPCProjectileEnabled[MAX_BOSSES];
static float g_flIceballSlowdownDuration[MAX_BOSSES][Difficulty_Max];
static float g_flIceballSlowdownPercent[MAX_BOSSES][Difficulty_Max];
static float g_flNPCProjectileCooldownMin[MAX_BOSSES][Difficulty_Max];
static float g_flNPCProjectileCooldownMax[MAX_BOSSES][Difficulty_Max];
float g_flNPCProjectileCooldown[MAX_BOSSES];
static float g_flNPCProjectileSpeed[MAX_BOSSES][Difficulty_Max];
static float g_flNPCProjectileDamage[MAX_BOSSES][Difficulty_Max];
static float g_flNPCProjectileRadius[MAX_BOSSES][Difficulty_Max];
static float g_flNPCProjectileDeviation[MAX_BOSSES][Difficulty_Max];
static int g_iNPCProjectileCount[MAX_BOSSES][Difficulty_Max];
static bool g_bNPCCriticalRockets[MAX_BOSSES];
static bool g_bNPCUseShootGesture[MAX_BOSSES];
static bool g_bNPCUseProjectileAmmo[MAX_BOSSES];
static int g_iNPCProjectileLoadedAmmo[MAX_BOSSES][Difficulty_Max];
int g_iNPCProjectileAmmo[MAX_BOSSES];
static float g_flNPCProjectileReloadTime[MAX_BOSSES][Difficulty_Max];
float g_flNPCProjectileTimeToReload[MAX_BOSSES];
static bool g_bNPCUseChargeUpProjectiles[MAX_BOSSES];
static float g_flNPCProjectileChargeUpTime[MAX_BOSSES][Difficulty_Max];
static int g_iNPCProjectileType[MAX_BOSSES];
bool g_bNPCReloadingProjectiles[MAX_BOSSES];

bool g_bNPCAlwaysLookAtTarget[MAX_BOSSES];
bool g_bNPCAlwaysLookAtTargetWhileAttacking[MAX_BOSSES];
bool g_bNPCAlwaysLookAtTargetWhileChasing[MAX_BOSSES];

static float g_flNPCSearchWanderRangeMin[MAX_BOSSES][Difficulty_Max];
static float g_flNPCSearchWanderRangeMax[MAX_BOSSES][Difficulty_Max];

//The advanced damage effects
static bool g_bNPCUseAdvancedDamageEffects[MAX_BOSSES];
static bool g_bNPCAdvancedDamageEffectsRandom[MAX_BOSSES];
static bool g_bNPCAttachDamageParticle[MAX_BOSSES];

static int g_iNPCRandomAttackIndexes[MAX_BOSSES];
static float g_flNPCRandomDuration[MAX_BOSSES][Difficulty_Max];
static float g_flNPCRandomSlowdown[MAX_BOSSES][Difficulty_Max];
static int g_iNPCRandomStunType[MAX_BOSSES];

static bool g_bNPCJaratePlayerEnabled[MAX_BOSSES];
static int g_iNPCJarateAttackIndexes[MAX_BOSSES];
static float g_flNPCJarateDuration[MAX_BOSSES][Difficulty_Max];

static bool g_bNPCMilkPlayerEnabled[MAX_BOSSES];
static int g_iNPCMilkAttackIndexes[MAX_BOSSES];
static float g_flNPCMilkDuration[MAX_BOSSES][Difficulty_Max];

static bool g_bNPCGasPlayerEnabled[MAX_BOSSES];
static int g_iNPCGasAttackIndexes[MAX_BOSSES];
static float g_flNPCGasDuration[MAX_BOSSES][Difficulty_Max];

static bool g_bNPCMarkPlayerEnabled[MAX_BOSSES];
static int g_iNPCMarkAttackIndexes[MAX_BOSSES];
static float g_flNPCMarkDuration[MAX_BOSSES][Difficulty_Max];

static bool g_bNPCSilentMarkPlayerEnabled[MAX_BOSSES];
static int g_iNPCSilentMarkAttackIndexes[MAX_BOSSES];
static float g_flNPCSilentMarkDuration[MAX_BOSSES][Difficulty_Max];

static bool g_bNPCIgnitePlayerEnabled[MAX_BOSSES];
static int g_iNPCIgniteAttackIndexes[MAX_BOSSES];
static float g_flNPCIgniteDelay[MAX_BOSSES][Difficulty_Max];

static bool g_bNPCStunPlayerEnabled[MAX_BOSSES];
static int g_iNPCStunAttackIndexes[MAX_BOSSES];
static float g_flNPCStunAttackDuration[MAX_BOSSES][Difficulty_Max];
static float g_flNPCStunAttackSlowdown[MAX_BOSSES][Difficulty_Max];
static int g_iNPCStunAttackType[MAX_BOSSES];

static bool g_bNPCBleedPlayerEnabled[MAX_BOSSES];
static int g_iNPCBleedAttackIndexes[MAX_BOSSES];
static float g_flNPCBleedDuration[MAX_BOSSES][Difficulty_Max];

static bool g_bNPCElectricPlayerEnabled[MAX_BOSSES];
static int g_iNPCElectricAttackIndexes[MAX_BOSSES];
static float g_flNPCElectricDuration[MAX_BOSSES][Difficulty_Max];
static float g_flNPCElectricSlowdown[MAX_BOSSES][Difficulty_Max];

static bool g_bNPCSmitePlayerEnabled[MAX_BOSSES];
static int g_iNPCSmiteAttackIndexes[MAX_BOSSES];
static float g_flNPCSmiteDamage[MAX_BOSSES];
static int g_iNPCSmiteDamageType[MAX_BOSSES];
static int g_iNPCSmiteColorR[MAX_BOSSES];
static int g_iNPCSmiteColorG[MAX_BOSSES];
static int g_iNPCSmiteColorB[MAX_BOSSES];
static int g_iNPCSmiteTransparency[MAX_BOSSES];
static bool g_bNPCSmiteMessage[MAX_BOSSES];

static bool g_bNPCShockwaveEnabled[MAX_BOSSES];
static float g_flNPCShockwaveHeight[MAX_BOSSES][Difficulty_Max];
static float g_flNPCShockwaveRange[MAX_BOSSES][Difficulty_Max];
static float g_flNPCShockwaveDrain[MAX_BOSSES][Difficulty_Max];
static float g_flNPCShockwaveForce[MAX_BOSSES][Difficulty_Max];
static bool g_bNPCShockwaveStunEnabled[MAX_BOSSES];
static float g_flNPCShockwaveStunDuration[MAX_BOSSES][Difficulty_Max];
static float g_flNPCShockwaveStunSlowdown[MAX_BOSSES][Difficulty_Max];
static int g_iNPCShockwaveAttackIndexes[MAX_BOSSES];

static int g_iNPCState[MAX_BOSSES] = { -1, ... };
static int g_iNPCTeleporter[MAX_BOSSES][MAX_NPCTELEPORTER];
static int g_iNPCCurrentAnimationSequence[MAX_BOSSES] = { -1, ... };
static bool g_bNPCCurrentAnimationSequenceIsLooped[MAX_BOSSES] = { false, ... };
bool g_bNPCUsesChaseInitialAnimation[MAX_BOSSES] = { false, ... };
bool g_bNPCUsesCloakStartAnimation[MAX_BOSSES] = { false, ... };
bool g_bNPCUsesCloakEndAnimation[MAX_BOSSES] = { false, ... };
bool g_bNPCUseFireAnimation[MAX_BOSSES] = { false, ... };
bool g_bNPCUseStartFleeAnimation[MAX_BOSSES] = { false, ... };
bool g_bNPCUsesHealAnimation[MAX_BOSSES] = { false, ... };
static float g_flNPCTimeUntilChaseAfterInitial[MAX_BOSSES];
float g_flNPCCurrentAnimationSequencePlaybackRate[MAX_BOSSES] = { 1.0, ... };
static char g_sNPCurrentAnimationSequenceName[MAX_BOSSES][256];
bool g_bNPCAlreadyAttacked[MAX_BOSSES];
Handle g_hBossFailSafeTimer[MAX_BOSSES];

bool g_bNPCCopyAlerted[MAX_BOSSES];

static bool g_bNPCEarthquakeFootstepsEnabled[MAX_BOSSES];
static float g_flNPCEarthquakeFootstepsAmplitude[MAX_BOSSES];
static float g_flNPCEarthquakeFootstepsFrequency[MAX_BOSSES];
static float g_flNPCEarthquakeFootstepsDuration[MAX_BOSSES];
static float g_flNPCEarthquakeFootstepsRadius[MAX_BOSSES];
static bool g_bNPCEarthquakeFootstepsAirShake[MAX_BOSSES];

static int g_iNPCSoundCountToAlert[MAX_BOSSES];
static bool g_bNPCDisappearOnStun[MAX_BOSSES] = { false, ... };
static bool g_bNPCDropItemOnStun[MAX_BOSSES];
static int g_iNPCDropItemType[MAX_BOSSES];
static bool g_bNPCIsBoxingBoss[MAX_BOSSES] = { false, ... };
static bool g_bNPCNormalSoundHookEnabled[MAX_BOSSES] = { false, ... };
static bool g_bNPCCloakToHealEnabled[MAX_BOSSES] = { false, ... };
static bool g_bNPCCanUseChaseInitialAnimation[MAX_BOSSES] = { false, ... };
static bool g_bNPCOldAnimationAIState[MAX_BOSSES] = { false, ... };
static bool g_bNPCCanUseAlertWalkingAnimation[MAX_BOSSES] = { false, ... };

static bool g_bNPCXenobladeBreakComboSystem[MAX_BOSSES];
static float g_flNPCXenobladeBreakDuration[MAX_BOSSES];
static float g_flNPCXenobladeToppleDuration[MAX_BOSSES];
static float g_flNPCXenobladeToppleSlowdown[MAX_BOSSES];
static float g_flNPCXenobladeDazeDuration[MAX_BOSSES];

static char sJaratePlayerParticle[PLATFORM_MAX_PATH];
static char sMilkPlayerParticle[PLATFORM_MAX_PATH];
static char sGasPlayerParticle[PLATFORM_MAX_PATH];
static char sStunPlayerParticle[PLATFORM_MAX_PATH];
static char sElectricPlayerParticleRed[PLATFORM_MAX_PATH];
static char sElectricPlayerParticleBlue[PLATFORM_MAX_PATH];
static char sKeyModel[PLATFORM_MAX_PATH];

bool g_bNPCStealingLife[MAX_BOSSES];
Handle g_hNPCLifeStealTimer[MAX_BOSSES];

static bool g_bNPCTrapsEnabled[MAX_BOSSES];
static int g_iNPCTrapType[MAX_BOSSES];
static float g_flNPCNextTrapSpawn[MAX_BOSSES][Difficulty_Max];

//Special thanks to The Gaben
bool g_bSlenderHasDamageParticleEffect[MAX_BOSSES];
float g_flSlenderDamageClientSoundVolume[MAX_BOSSES];
int g_iSlenderDamageClientSoundPitch[MAX_BOSSES];
char sDamageEffectParticle[PLATFORM_MAX_PATH];
char sDamageEffectSound[PLATFORM_MAX_PATH];

static bool g_bNPCAutoChaseEnabled[MAX_BOSSES] = { false, ... };
static int g_iNPCAutoChaseThreshold[MAX_BOSSES][Difficulty_Max];
static int g_iNPCAutoChaseAddGeneral[MAX_BOSSES][Difficulty_Max];
static int g_iNPCAutoChaseAddFootstep[MAX_BOSSES][Difficulty_Max];
static int g_iNPCAutoChaseAddVoice[MAX_BOSSES][Difficulty_Max];
static int g_iNPCAutoChaseAddWeapon[MAX_BOSSES][Difficulty_Max];
static bool g_bNPCAutoChaseSprinters[MAX_BOSSES] = { false, ... };
float g_flNPCAutoChaseSprinterCooldown[MAX_BOSSES];

bool g_bNPCInAutoChase[MAX_BOSSES];

bool g_bNPCChasesEndlessly[MAX_BOSSES] = { false, ... };

float g_flNPCLaserTimer[MAX_BOSSES];

//KF2 Patriarch's Heal Logic
static bool g_bNPCCanSelfHeal[MAX_BOSSES] = { false, ... };
bool g_bNPCRunningToHeal[MAX_BOSSES] = { false, ... };
float g_flNPCFleeHealTimer[MAX_BOSSES];
bool g_bNPCHealing[MAX_BOSSES] = { false, ... };
bool g_bNPCSetHealDestination[MAX_BOSSES] = { false, ... };
static float g_flNPCStartSelfHealPercentage[MAX_BOSSES];
static float g_flNPCSelfHealPercentageOne[MAX_BOSSES];
static float g_flNPCSelfHealPercentageTwo[MAX_BOSSES];
static float g_flNPCSelfHealPercentageThree[MAX_BOSSES];
int g_iNPCSelfHealStage[MAX_BOSSES];
int g_iNPCHealCount[MAX_BOSSES];

//Boxing stuff
static int g_iNPCBoxingCurrentDifficulty[MAX_BOSSES];
static int g_iNPCBoxingRagePhase[MAX_BOSSES];

static bool g_bNPCUsesMultiAttackSounds[MAX_BOSSES] = { false, ... };
static bool g_bNPCUsesMultiHitSounds[MAX_BOSSES] = { false, ... };
static bool g_bNPCUsesMultiMissSounds[MAX_BOSSES] = { false, ... };

static bool g_bNPCHasCrawling[MAX_BOSSES] = { false, ... };
bool g_bNPCIsCrawling[MAX_BOSSES] = { false, ... };
bool g_bNPCChangeToCrawl[MAX_BOSSES] = { false, ... };
static float g_flNPCCrawlSpeedMultiplier[MAX_BOSSES][Difficulty_Max];
float g_flNPCCrawlDetectMins[MAX_BOSSES][3];
float g_flNPCCrawlDetectMaxs[MAX_BOSSES][3];

enum struct BaseAttackStructure
{
	int BaseAttackType;
	float BaseAttackDamage;
	float BaseAttackDamageVsProps;
	float BaseAttackDamageForce;
	int BaseAttackDamageType;
	float BaseAttackDamageDelay;
	float BaseAttackRange;
	float BaseAttackDuration;
	float BaseAttackSpread;
	float BaseAttackBeginRange;
	float BaseAttackBeginFOV;
	float BaseAttackCooldown;
	int BaseAttackDisappear;
	int BaseAttackRepeat;
	int BaseAttackMaxRepeats;
	int CurrentAttackRepeat;
	int WeaponAttackIndex;
	bool BaseAttackLifeSteal;
	float BaseAttackLifeStealDuration;
	float BaseAttackProjectileDamage;
	float BaseAttackProjectileSpeed;
	float BaseAttackProjectileRadius;
	float BaseAttackProjectileDeviation;
	int BaseAttackProjectileCount;
	int BaseAttackProjectileType;
	bool BaseAttackProjectileCrits;
	float BaseAttackProjectileIceSlowdownPercent;
	float BaseAttackProjectileIceSlowdownDuration;
	int BaseAttackBulletCount;
	float BaseAttackBulletDamage;
	float BaseAttackBulletSpread;
	float BaseAttackNextAttackTime;
	float BaseAttackLaserDamage;
	float BaseAttackLaserSize;
	int BaseAttackLaserColor[3];
	bool BaseAttackLaserAttachment;
	float BaseAttackLaserDuration;
	float BaseAttackLaserNoise;
	bool BaseAttackPullIn;
	bool BaseAttackWhileRunning;
	float BaseAttackRunSpeed;
	float BaseAttackRunDuration;
	float BaseAttackRunDelay;
	int BaseAttackUseOnDifficulty;
	int BaseAttackBlockOnDifficulty;
	int BaseAttackExplosiveDanceRadius;
	int BaseAttackWeaponTypeInt;
	bool BaseAttackIgnoreAlwaysLooking;
	bool BaseAttackGestures;
}

int g_iSlenderOldState[MAX_BOSSES];
float g_flLastPos[MAX_BOSSES][3];

static int g_NPCBaseAttacksCount[MAX_BOSSES];
BaseAttackStructure g_NPCBaseAttacks[MAX_BOSSES][SF2_CHASER_BOSS_MAX_ATTACKS][Difficulty_Max];
static int g_iNPCCurrentAttackIndex[MAX_BOSSES];
float g_flNPCBaseAttackRunDurationTime[MAX_BOSSES][SF2_CHASER_BOSS_MAX_ATTACKS];
float g_flNPCBaseAttackRunDelayTime[MAX_BOSSES][SF2_CHASER_BOSS_MAX_ATTACKS];

const SF2NPC_Chaser SF2_INVALID_NPC_CHASER = view_as<SF2NPC_Chaser>(-1);

methodmap SF2NPC_Chaser < SF2NPC_BaseNPC
{
	property float WakeRadius
	{
		public get() { return NPCChaserGetWakeRadius(this.Index); }
	}

	property bool StunEnabled
	{
		public get() { return NPCChaserIsStunEnabled(this.Index); }
	}
	
	property bool StunByFlashlightEnabled
	{
		public get() { return NPCChaserIsStunByFlashlightEnabled(this.Index); }
	}
	
	property float StunFlashlightDamage
	{
		public get() { return NPCChaserGetStunFlashlightDamage(this.Index); }
	}
	
	property float StunDuration
	{
		public get() { return NPCChaserGetStunDuration(this.Index); }
	}
	
	property float StunCooldown
	{
		public get() { return NPCChaserGetStunCooldown(this.Index); }
	}
	
	property float StunHealth
	{
		public get() { return NPCChaserGetStunHealth(this.Index); }
		public set(float amount) { NPCChaserSetStunHealth(this.Index, amount); }
	}
	
	property float StunInitialHealth
	{
		public get() { return NPCChaserGetStunInitialHealth(this.Index); }
		public set(float amount) { NPCChaserSetStunInitialHealth(this.Index, amount); }
	}
	
	property bool HasDamageParticles
	{
		public get() { return NPCChaserDamageParticlesEnabled(this.Index); }
	}
	
	property bool UseShootGesture
	{
		public get() { return NPCChaserUseShootGesture(this.Index); }
	}
	
	property bool CloakEnabled
	{
		public get() { return NPCChaserIsCloakEnabled(this.Index); }
	}
	
	public float GetCloakCooldown(int difficulty)
	{
		return NPCChaserGetCloakCooldown(this.Index, difficulty);
	}
	
	public float GetCloakRange(int difficulty)
	{
		return NPCChaserGetCloakRange(this.Index, difficulty);
	}
	
	property bool HasKeyDrop
	{
		public get() { return NPCChaseHasKeyDrop(this.Index); }
	}
	
	property bool ProjectileEnabled
	{
		public get() { return NPCChaserIsProjectileEnabled(this.Index); }
	}
	
	property bool ProjectileUsesAmmo
	{
		public get() { return NPCChaserUseProjectileAmmo(this.Index); }
	}
	
	property int ProjectileType
	{
		public get() { return NPCChaserGetProjectileType(this.Index); }
	}
	
	public float GetProjectileCooldownMin(int difficulty)
	{
		return NPCChaserGetProjectileCooldownMin(this.Index, difficulty);
	}
	
	public float GetProjectileCooldownMax(int difficulty)
	{
		return NPCChaserGetProjectileCooldownMax(this.Index, difficulty);
	}
	
	public float GetProjectileSpeed(int difficulty)
	{
		return NPCChaserGetProjectileSpeed(this.Index, difficulty);
	}
	
	public float GetProjectileDamage(int difficulty)
	{
		return NPCChaserGetProjectileDamage(this.Index, difficulty);
	}
	
	public float GetProjectileRadius(int difficulty)
	{
		return NPCChaserGetProjectileRadius(this.Index, difficulty);
	}
	
	public float GetProjectileReloadTime(int difficulty)
	{
		return NPCChaserGetProjectileReloadTime(this.Index, difficulty);
	}
	
	property bool AdvancedDamageEffectsEnabled
	{
		public get() { return NPCChaserUseAdvancedDamageEffects(this.Index); }
	}
	
	property bool AttachDamageEffectsParticle
	{
		public get() { return NPCChaserAttachDamageParticle(this.Index); }
	}
	
	property bool JaratePlayerOnHit
	{
		public get() { return NPCChaserJaratePlayerOnHit(this.Index); }
	}
	
	public float GetJarateDuration(int difficulty)
	{
		return NPCChaserGetJarateDuration(this.Index, difficulty);
	}
	
	property bool MilkPlayerOnHit
	{
		public get() { return NPCChaserMilkPlayerOnHit(this.Index); }
	}
	
	public float GetMilkDuration(int difficulty)
	{
		return NPCChaserGetMilkDuration(this.Index, difficulty);
	}
	
	property bool GasPlayerOnHit
	{
		public get() { return NPCChaserGasPlayerOnHit(this.Index); }
	}
	
	public float GetGasDuration(int difficulty)
	{
		return NPCChaserGetGasDuration(this.Index, difficulty);
	}
	
	property bool MarkPlayerOnHit
	{
		public get() { return NPCChaserMarkPlayerOnHit(this.Index); }
	}
	
	public float GetMarkDuration(int difficulty)
	{
		return NPCChaserGetMarkDuration(this.Index, difficulty);
	}
	
	property bool IgnitePlayerOnHit
	{
		public get() { return NPCChaserIgnitePlayerOnHit(this.Index); }
	}
	
	public float GetIgniteDelay(int difficulty)
	{
		return NPCChaserGetIgniteDelay(this.Index, difficulty);
	}
	
	property bool StunPlayerOnHit
	{
		public get() { return NPCChaserStunPlayerOnHit(this.Index); }
	}
	
	public float GetStunAttackDuration(int difficulty)
	{
		return NPCChaserGetStunAttackDuration(this.Index, difficulty);
	}
	
	public float GetStunAttackSlowdown(int difficulty)
	{
		return NPCChaserGetStunAttackSlowdown(this.Index, difficulty);
	}
	
	property bool BleedPlayerOnHit
	{
		public get() { return NPCChaserBleedPlayerOnHit(this.Index); }
	}
	
	public float GetBleedDuration(int difficulty)
	{
		return NPCChaserGetBleedDuration(this.Index, difficulty);
	}
	
	property bool ElectricPlayerOnHit
	{
		public get() { return NPCChaserElectricPlayerOnHit(this.Index); }
	}
	
	public float GetElectricDuration(int difficulty)
	{
		return NPCChaserGetElectricDuration(this.Index, difficulty);
	}
	
	public float GetElectricSlowdown(int difficulty)
	{
		return NPCChaserGetElectricSlowdown(this.Index, difficulty);
	}
	
	property bool SmitePlayerOnHit
	{
		public get() { return NPCChaserSmitePlayerOnHit(this.Index); }
	}
	
	property int State
	{
		public get() { return NPCChaserGetState(this.Index); }
		public set(int state) { NPCChaserSetState(this.Index, state); }
	}
	
	property bool HasTraps
	{
		public get() { return NPCChaserGetTrapState(this.Index); }
	}
	
	property int TrapType
	{
		public get() { return NPCChaserGetTrapType(this.Index); }
	}
	
	public float GetTrapCooldown(int difficulty)
	{
		return NPCChaserGetTrapSpawnTime(this.Index, difficulty);
	}
	
	property bool HasCriticalRockets
	{
		public get() { return NPCChaserHasCriticalRockets(this.Index); }
	}
	
	public int GetTeleporter(int iTeleporterNumber)
	{
		return NPCChaserGetTeleporter(this.Index, iTeleporterNumber);
	}
	
	public void SetTeleporter(int iTeleporterNumber, int iEntity)
	{
		NPCChaserSetTeleporter(this.Index, iTeleporterNumber, iEntity);
	}
	
	public float GetWalkSpeed(int difficulty)
	{
		return NPCChaserGetWalkSpeed(this.Index, difficulty);
	}
	
	public float GetMaxWalkSpeed(int difficulty)
	{
		return NPCChaserGetMaxWalkSpeed(this.Index, difficulty);
	}
	
	public void AddStunHealth(float amount)
	{
		NPCChaserAddStunHealth(this.Index, amount);
	}
	
	property bool AutoChaseEnabled
	{
		public get() { return g_bNPCAutoChaseEnabled[this.Index]; }
		public set(bool autoChase) { g_bNPCAutoChaseEnabled[this.Index] = autoChase; }
	}
	
	property bool ChasesEndlessly
	{
		public get() { return g_bNPCChasesEndlessly[this.Index]; }
		public set(bool chaseEndlessly) { g_bNPCChasesEndlessly[this.Index] = chaseEndlessly; }
	}
	
	public SF2NPC_Chaser(int index)
	{
		return view_as<SF2NPC_Chaser>(SF2NPC_BaseNPC(index));
	}
}

#include "sf2/npc/npc_chaser_mind.sp"
#include "sf2/npc/npc_chaser_attacks.sp"
#include "sf2/npc/npc_chaser_pathing.sp"
#include "sf2/npc/npc_chaser_projectiles.sp"

public void NPCChaserSetTeleporter(int iBossIndex, int iTeleporterNumber, int iEntity)
{
	g_iNPCTeleporter[iBossIndex][iTeleporterNumber] = iEntity;
}

public int NPCChaserGetTeleporter(int iBossIndex, int iTeleporterNumber)
{
	return g_iNPCTeleporter[iBossIndex][iTeleporterNumber];
}

public void NPCChaserInitialize()
{
	for (int iNPCIndex = 0; iNPCIndex < MAX_BOSSES; iNPCIndex++)
	{
		NPCChaserResetValues(iNPCIndex);
	}
}

void NPCChaserResetAnimationInfo(int iNPCIndex, int iSequence = 0)
{
	g_iNPCCurrentAnimationSequence[iNPCIndex] = iSequence;
	g_bNPCCurrentAnimationSequenceIsLooped[iNPCIndex] = false;
	g_flNPCCurrentAnimationSequencePlaybackRate[iNPCIndex] = 1.0;
	g_bNPCUsesChaseInitialAnimation[iNPCIndex] = false;
	g_bNPCUsesCloakStartAnimation[iNPCIndex] = false;
	g_bNPCUsesCloakEndAnimation[iNPCIndex] = false;
	g_bNPCUseFireAnimation[iNPCIndex] = false;
	g_bNPCUsesHealAnimation[iNPCIndex] = false;
	g_bNPCUseStartFleeAnimation[iNPCIndex] = false;
	g_bNPCUsesRageAnimation1[iNPCIndex] = false;
	g_bNPCUsesRageAnimation2[iNPCIndex] = false;
	g_bNPCUsesRageAnimation3[iNPCIndex] = false;
}

float NPCChaserGetWalkSpeed(int iNPCIndex, int iDifficulty)
{
	return g_flNPCWalkSpeed[iNPCIndex][iDifficulty];
}

float NPCChaserGetMaxWalkSpeed(int iNPCIndex, int iDifficulty)
{
	return g_flNPCMaxWalkSpeed[iNPCIndex][iDifficulty];
}

float NPCChaserGetWakeRadius(int iNPCIndex)
{
	return g_flNPCWakeRadius[iNPCIndex];
}

int NPCChaserGetAttackCount(int iNPCIndex)
{
	return g_NPCBaseAttacksCount[iNPCIndex];
}

int NPCChaserGetAttackType(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackType;
}

float NPCChaserGetAttackDamage(int iNPCIndex, int iAttackIndex, int iDifficulty)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][iDifficulty].BaseAttackDamage;
}

float NPCChaserGetAttackDamageVsProps(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackDamageVsProps;
}

float NPCChaserGetAttackDamageForce(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackDamageForce;
}
/*
float NPCChaserGetAttackLifeStealDuration(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackLifeStealDuration;
}
*/
bool NPCChaserGetAttackLifeStealState(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackLifeSteal;
}

bool NPCChaserGetAttackWhileRunningState(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackWhileRunning;
}

float NPCChaserGetAttackRunSpeed(int iNPCIndex, int iAttackIndex, int iDifficulty)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][iDifficulty].BaseAttackRunSpeed;
}

float NPCChaserGetAttackRunDuration(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackRunDuration;
}

float NPCChaserGetAttackRunDelay(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackRunDelay;
}

int NPCChaserGetAttackUseOnDifficulty(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackUseOnDifficulty;
}

int NPCChaserGetAttackBlockOnDifficulty(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackBlockOnDifficulty;
}

int NPCChaserGetAttackExplosiveDanceRadius(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackExplosiveDanceRadius;
}

int NPCChaserGetAttackWeaponTypeInt(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackWeaponTypeInt;
}

int NPCChaserGetAttackProjectileType(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackProjectileType;
}

float NPCChaserGetAttackProjectileDamage(int iNPCIndex, int iAttackIndex, int iDifficulty)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][iDifficulty].BaseAttackProjectileDamage;
}

float NPCChaserGetAttackProjectileSpeed(int iNPCIndex, int iAttackIndex, int iDifficulty)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][iDifficulty].BaseAttackProjectileSpeed;
}

float NPCChaserGetAttackProjectileRadius(int iNPCIndex, int iAttackIndex, int iDifficulty)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][iDifficulty].BaseAttackProjectileRadius;
}

float NPCChaserGetAttackProjectileDeviation(int iNPCIndex, int iAttackIndex, int iDifficulty)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][iDifficulty].BaseAttackProjectileDeviation;
}

int NPCChaserGetAttackProjectileCount(int iNPCIndex, int iAttackIndex, int iDifficulty)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][iDifficulty].BaseAttackProjectileCount;
}

bool NPCChaserGetAttackProjectileCrits(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackProjectileCrits;
}

float NPCChaserGetAttackProjectileIceSlowdownPercent(int iNPCIndex, int iAttackIndex, int iDifficulty)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][iDifficulty].BaseAttackProjectileIceSlowdownPercent;
}

float NPCChaserGetAttackProjectileIceSlowdownDuration(int iNPCIndex, int iAttackIndex, int iDifficulty)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][iDifficulty].BaseAttackProjectileIceSlowdownDuration;
}

int NPCChaserGetAttackBulletCount(int iNPCIndex, int iAttackIndex, int iDifficulty)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][iDifficulty].BaseAttackBulletCount;
}

float NPCChaserGetAttackBulletDamage(int iNPCIndex, int iAttackIndex, int iDifficulty)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][iDifficulty].BaseAttackBulletDamage;
}

float NPCChaserGetAttackBulletSpread(int iNPCIndex, int iAttackIndex, int iDifficulty)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][iDifficulty].BaseAttackBulletSpread;
}

float NPCChaserGetAttackLaserDamage(int iNPCIndex, int iAttackIndex, int iDifficulty)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][iDifficulty].BaseAttackLaserDamage;
}

float NPCChaserGetAttackLaserSize(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackLaserSize;
}

void NPCChaserGetAttackLaserColor(int iNPCIndex, int iAttackIndex, int iColor[3])
{
	iColor[0] = g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackLaserColor[0];
	iColor[1] = g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackLaserColor[1];
	iColor[2] = g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackLaserColor[2];
}

bool NPCChaserGetAttackLaserAttachmentState(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackLaserAttachment;
}

float NPCChaserGetAttackLaserDuration(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackLaserDuration;
}

float NPCChaserGetAttackLaserNoise(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackLaserNoise;
}

bool NPCChaserGetAttackPullIn(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackPullIn;
}

int NPCChaserGetAttackDamageType(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackDamageType;
}

int NPCChaserGetAttackDisappear(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackDisappear;
}

int NPCChaserGetAttackRepeat(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackRepeat;
}

int NPCChaserGetMaxAttackRepeats(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackMaxRepeats;
}

bool NPCChaserGetAttackIgnoreAlwaysLooking(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackIgnoreAlwaysLooking;
}

float NPCChaserGetAttackDamageDelay(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackDamageDelay;
}

float NPCChaserGetAttackRange(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackRange;
}

float NPCChaserGetAttackDuration(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackDuration;
}

float NPCChaserGetAttackSpread(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackSpread;
}

float NPCChaserGetAttackBeginRange(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackBeginRange;
}

float NPCChaserGetAttackBeginFOV(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackBeginFOV;
}

bool NPCChaserGetAttackGestureState(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackGestures;
}

int NPCSetCurrentAttackIndex(int iNPCIndex, int iAttackIndex)
{
	g_iNPCCurrentAttackIndex[iNPCIndex] = iAttackIndex;
}

int NPCGetCurrentAttackIndex(int iNPCIndex)
{
	return g_iNPCCurrentAttackIndex[iNPCIndex];
}

int NPCSetCurrentAttackRepeat(int iNPCIndex, int iAttackIndex, int iValue)
{
	g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].CurrentAttackRepeat = iValue;
}

int NPCGetCurrentAttackRepeat(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].CurrentAttackRepeat;
}

float NPCChaserGetAttackCooldown(int iNPCIndex, int iAttackIndex, int iDifficulty)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][iDifficulty].BaseAttackCooldown;
}

float NPCChaserGetNextAttackTime(int iNPCIndex, int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackNextAttackTime;
}

float NPCChaserSetNextAttackTime(int iNPCIndex, int iAttackIndex, float flValue)
{
	g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackNextAttackTime = flValue;
}

bool NPCChaserIsStunEnabled(int iNPCIndex)
{
	return g_bNPCStunEnabled[iNPCIndex];
}

bool NPCChaserIsStunByFlashlightEnabled(int iNPCIndex)
{
	return g_bNPCStunFlashlightEnabled[iNPCIndex];
}

bool NPCChaserCanChaseInitialOnStun(int iNPCIndex)
{
	return g_bNPCChaseInitialOnStun[iNPCIndex];
}

bool NPCChaseHasKeyDrop(int iNPCIndex)
{
	return g_bNPCHasKeyDrop[iNPCIndex];
}

float NPCChaserGetStunFlashlightDamage(int iNPCIndex)
{
	return g_flNPCStunFlashlightDamage[iNPCIndex];
}

float NPCChaserGetStunDuration(int iNPCIndex)
{
	return g_flNPCStunDuration[iNPCIndex];
}

float NPCChaserGetStunCooldown(int iNPCIndex)
{
	return g_flNPCStunCooldown[iNPCIndex];
}

float NPCChaserGetStunHealth(int iNPCIndex)
{
	return g_flNPCStunHealth[iNPCIndex];
}

void NPCChaserSetStunHealth(int iNPCIndex, float flAmount)
{
	g_flNPCStunHealth[iNPCIndex] = flAmount;
}

void NPCChaserSetStunInitialHealth(int iNPCIndex, float flAmount)
{
	g_flNPCStunInitialHealth[iNPCIndex] = flAmount;
}

float NPCChaserGetAddStunHealth(int iNPCIndex)
{
	return g_flNPCStunAddHealth[iNPCIndex];
}

void NPCChaserSetAddStunHealth(int iNPCIndex, float flAmount)
{
	g_flNPCStunAddHealth[iNPCIndex] += flAmount;
}

void NPCChaserAddStunHealth(int iNPCIndex, float flAmount)
{
	if (GetGameTime() >= g_flSlenderNextStunTime[iNPCIndex])
	{
		NPCChaserSetStunHealth(iNPCIndex, NPCChaserGetStunHealth(iNPCIndex) + flAmount);
		#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_BOSS_STUN, 0, "Boss %i, new amount: %0.0f", iNPCIndex, NPCChaserGetStunHealth(iNPCIndex));
		#endif
	}
}

float NPCChaserGetStunInitialHealth(int iNPCIndex)
{
	return g_flNPCStunInitialHealth[iNPCIndex];
}

float NPCChaserGetAlertGracetime(int iNPCIndex, int iDifficulty)
{
	return g_flNPCAlertGracetime[iNPCIndex][iDifficulty];
}

float NPCChaserGetAlertDuration(int iNPCIndex, int iDifficulty)
{
	return g_flNPCAlertDuration[iNPCIndex][iDifficulty];
}

float NPCChaserGetChaseDuration(int iNPCIndex, int iDifficulty)
{
	return g_flNPCChaseDuration[iNPCIndex][iDifficulty];
}

float NPCChaserGetWanderRangeMin(int iNPCIndex, int iDifficulty)
{
	return g_flNPCSearchWanderRangeMin[iNPCIndex][iDifficulty];
}

float NPCChaserGetWanderRangeMax(int iNPCIndex, int iDifficulty)
{
	return g_flNPCSearchWanderRangeMax[iNPCIndex][iDifficulty];
}

bool NPCChaserIsCloakEnabled(int iNPCIndex)
{
	return g_bNPCCloakEnabled[iNPCIndex];
}

bool NPCChaserIsCloaked(int iNPCIndex)
{
	return g_bNPCHasCloaked[iNPCIndex];
}

float NPCChaserGetCloakCooldown(int iNPCIndex, int iDifficulty)
{
	return g_flNPCCloakCooldown[iNPCIndex][iDifficulty];
}

float NPCChaserGetCloakRange(int iNPCIndex, int iDifficulty)
{
	return g_flNPCCloakRange[iNPCIndex][iDifficulty];
}

float NPCChaserGetDecloakRange(int iNPCIndex, int iDifficulty)
{
	return g_flNPCDecloakRange[iNPCIndex][iDifficulty];
}

float NPCChaserGetCloakDuration(int iNPCIndex, int iDifficulty)
{
	return g_flNPCCloakDuration[iNPCIndex][iDifficulty];
}

float NPCChaserGetCloakSpeedMultiplier(int iNPCIndex, int iDifficulty)
{
	return g_flNPCCloakSpeedMultiplier[iNPCIndex][iDifficulty];
}

bool NPCChaserIsProjectileEnabled(int iNPCIndex)
{
	return g_bNPCProjectileEnabled[iNPCIndex];
}

bool NPCChaserHasCriticalRockets(int iNPCIndex)
{
	return g_bNPCCriticalRockets[iNPCIndex];
}

bool NPCChaserUseShootGesture(int iNPCIndex)
{
	return g_bNPCUseShootGesture[iNPCIndex];
}

bool NPCChaserUseProjectileAmmo(int iNPCIndex)
{
	return g_bNPCUseProjectileAmmo[iNPCIndex];
}

int NPCChaserGetProjectileType(int iNPCIndex)
{
	return g_iNPCProjectileType[iNPCIndex];
}

float NPCChaserGetProjectileCooldownMin(int iNPCIndex, int iDifficulty)
{
	return g_flNPCProjectileCooldownMin[iNPCIndex][iDifficulty];
}

float NPCChaserGetProjectileCooldownMax(int iNPCIndex, int iDifficulty)
{
	return g_flNPCProjectileCooldownMax[iNPCIndex][iDifficulty];
}

float NPCChaserGetProjectileSpeed(int iNPCIndex, int iDifficulty)
{
	return g_flNPCProjectileSpeed[iNPCIndex][iDifficulty];
}

float NPCChaserGetProjectileDamage(int iNPCIndex, int iDifficulty)
{
	return g_flNPCProjectileDamage[iNPCIndex][iDifficulty];
}

float NPCChaserGetProjectileRadius(int iNPCIndex, int iDifficulty)
{
	return g_flNPCProjectileRadius[iNPCIndex][iDifficulty];
}

float NPCChaserGetProjectileDeviation(int iNPCIndex, int iDifficulty)
{
	return g_flNPCProjectileDeviation[iNPCIndex][iDifficulty];
}

int NPCChaserGetProjectileCount(int iNPCIndex, int iDifficulty)
{
	return g_iNPCProjectileCount[iNPCIndex][iDifficulty];
}

float NPCChaserGetIceballSlowdownDuration(int iNPCIndex, int iDifficulty)
{
	return g_flIceballSlowdownDuration[iNPCIndex][iDifficulty];
}

float NPCChaserGetIceballSlowdownPercent(int iNPCIndex, int iDifficulty)
{
	return g_flIceballSlowdownPercent[iNPCIndex][iDifficulty];
}

int NPCChaserGetLoadedProjectiles(int iNPCIndex, int iDifficulty)
{
	return g_iNPCProjectileLoadedAmmo[iNPCIndex][iDifficulty];
}

float NPCChaserGetProjectileReloadTime(int iNPCIndex, int iDifficulty)
{
	return g_flNPCProjectileReloadTime[iNPCIndex][iDifficulty];
}
/*
float NPCChaserGetProjectileChargeUpDuration(int iNPCIndex,int iDifficulty)
{
	return g_flNPCProjectileChargeUpTime[iNPCIndex][iDifficulty];
}
*/

bool NPCChaserUseAdvancedDamageEffects(int iNPCIndex)
{
	return g_bNPCUseAdvancedDamageEffects[iNPCIndex];
}

bool NPCChaserUseRandomAdvancedDamageEffects(int iNPCIndex)
{
	return g_bNPCAdvancedDamageEffectsRandom[iNPCIndex];
}

bool NPCChaserAttachDamageParticle(int iNPCIndex)
{
	return g_bNPCAttachDamageParticle[iNPCIndex];
}

int NPCChaserRandomEffectIndexes(int iNPCIndex)
{
	return g_iNPCRandomAttackIndexes[iNPCIndex];
}

float NPCChaserRandomEffectDuration(int iNPCIndex, int iDifficulty)
{
	return g_flNPCRandomDuration[iNPCIndex][iDifficulty];
}

float NPCChaserRandomEffectSlowdown(int iNPCIndex, int iDifficulty)
{
	return g_flNPCRandomSlowdown[iNPCIndex][iDifficulty];
}

int NPCChaserRandomEffectStunType(int iNPCIndex)
{
	return g_iNPCRandomStunType[iNPCIndex];
}

bool NPCChaserJaratePlayerOnHit(int iNPCIndex)
{
	return g_bNPCJaratePlayerEnabled[iNPCIndex];
}

int NPCChaserGetJarateAttackIndexes(int iNPCIndex)
{
	return g_iNPCJarateAttackIndexes[iNPCIndex];
}

float NPCChaserGetJarateDuration(int iNPCIndex, int iDifficulty)
{
	return g_flNPCJarateDuration[iNPCIndex][iDifficulty];
}

bool NPCChaserMilkPlayerOnHit(int iNPCIndex)
{
	return g_bNPCMilkPlayerEnabled[iNPCIndex];
}

int NPCChaserGetMilkAttackIndexes(int iNPCIndex)
{
	return g_iNPCMilkAttackIndexes[iNPCIndex];
}

float NPCChaserGetMilkDuration(int iNPCIndex, int iDifficulty)
{
	return g_flNPCMilkDuration[iNPCIndex][iDifficulty];
}

bool NPCChaserGasPlayerOnHit(int iNPCIndex)
{
	return g_bNPCGasPlayerEnabled[iNPCIndex];
}

int NPCChaserGetGasAttackIndexes(int iNPCIndex)
{
	return g_iNPCGasAttackIndexes[iNPCIndex];
}

float NPCChaserGetGasDuration(int iNPCIndex, int iDifficulty)
{
	return g_flNPCGasDuration[iNPCIndex][iDifficulty];
}

bool NPCChaserMarkPlayerOnHit(int iNPCIndex)
{
	return g_bNPCMarkPlayerEnabled[iNPCIndex];
}

int NPCChaserGetMarkAttackIndexes(int iNPCIndex)
{
	return g_iNPCMarkAttackIndexes[iNPCIndex];
}

float NPCChaserGetMarkDuration(int iNPCIndex, int iDifficulty)
{
	return g_flNPCMarkDuration[iNPCIndex][iDifficulty];
}

bool NPCChaserSilentMarkPlayerOnHit(int iNPCIndex)
{
	return g_bNPCSilentMarkPlayerEnabled[iNPCIndex];
}

int NPCChaserGetSilentMarkAttackIndexes(int iNPCIndex)
{
	return g_iNPCSilentMarkAttackIndexes[iNPCIndex];
}

float NPCChaserGetSilentMarkDuration(int iNPCIndex, int iDifficulty)
{
	return g_flNPCSilentMarkDuration[iNPCIndex][iDifficulty];
}

bool NPCChaserIgnitePlayerOnHit(int iNPCIndex)
{
	return g_bNPCIgnitePlayerEnabled[iNPCIndex];
}

int NPCChaserGetIgniteAttackIndexes(int iNPCIndex)
{
	return g_iNPCIgniteAttackIndexes[iNPCIndex];
}

float NPCChaserGetIgniteDelay(int iNPCIndex, int iDifficulty)
{
	return g_flNPCIgniteDelay[iNPCIndex][iDifficulty];
}

bool NPCChaserStunPlayerOnHit(int iNPCIndex)
{
	return g_bNPCStunPlayerEnabled[iNPCIndex];
}

int NPCChaserGetStunAttackIndexes(int iNPCIndex)
{
	return g_iNPCStunAttackIndexes[iNPCIndex];
}

float NPCChaserGetStunAttackDuration(int iNPCIndex, int iDifficulty)
{
	return g_flNPCStunAttackDuration[iNPCIndex][iDifficulty];
}

float NPCChaserGetStunAttackSlowdown(int iNPCIndex, int iDifficulty)
{
	return g_flNPCStunAttackSlowdown[iNPCIndex][iDifficulty];
}

int NPCChaserGetStunAttackType(int iNPCIndex)
{
	return g_iNPCStunAttackType[iNPCIndex];
}

bool NPCChaserBleedPlayerOnHit(int iNPCIndex)
{
	return g_bNPCBleedPlayerEnabled[iNPCIndex];
}

int NPCChaserGetBleedAttackIndexes(int iNPCIndex)
{
	return g_iNPCBleedAttackIndexes[iNPCIndex];
}

float NPCChaserGetBleedDuration(int iNPCIndex, int iDifficulty)
{
	return g_flNPCBleedDuration[iNPCIndex][iDifficulty];
}

bool NPCChaserElectricPlayerOnHit(int iNPCIndex)
{
	return g_bNPCElectricPlayerEnabled[iNPCIndex];
}

int NPCChaserGetElectricAttackIndexes(int iNPCIndex)
{
	return g_iNPCElectricAttackIndexes[iNPCIndex];
}

float NPCChaserGetElectricDuration(int iNPCIndex, int iDifficulty)
{
	return g_flNPCElectricDuration[iNPCIndex][iDifficulty];
}

float NPCChaserGetElectricSlowdown(int iNPCIndex, int iDifficulty)
{
	return g_flNPCElectricSlowdown[iNPCIndex][iDifficulty];
}

bool NPCChaserSmitePlayerOnHit(int iNPCIndex)
{
	return g_bNPCSmitePlayerEnabled[iNPCIndex];
}

bool NPCChaserSmitePlayerMessage(int iNPCIndex)
{
	return g_bNPCSmiteMessage[iNPCIndex];
}

int NPCChaserGetSmiteAttackIndexes(int iNPCIndex)
{
	return g_iNPCSmiteAttackIndexes[iNPCIndex];
}

bool NPCChaserXenobladeSystemEnabled(int iNPCIndex)
{
	return g_bNPCXenobladeBreakComboSystem[iNPCIndex];
}

float NPCChaserGetXenobladeBreakDuration(int iNPCIndex)
{
	return g_flNPCXenobladeBreakDuration[iNPCIndex];
}

float NPCChaserGetXenobladeToppleDuration(int iNPCIndex)
{
	return g_flNPCXenobladeToppleDuration[iNPCIndex];
}

float NPCChaserGetXenobladeToppleSlowdown(int iNPCIndex)
{
	return g_flNPCXenobladeToppleSlowdown[iNPCIndex];
}

float NPCChaserGetXenobladeDazeDuration(int iNPCIndex)
{
	return g_flNPCXenobladeDazeDuration[iNPCIndex];
}

float NPCChaserGetSmiteDamage(int iNPCIndex)
{
	return g_flNPCSmiteDamage[iNPCIndex];
}

int NPCChaserGetSmiteDamageType(int iNPCIndex)
{
	return g_iNPCSmiteDamageType[iNPCIndex];
}

int NPCChaserGetSmiteColorR(int iNPCIndex)
{
	return g_iNPCSmiteColorR[iNPCIndex];
}

int NPCChaserGetSmiteColorG(int iNPCIndex)
{
	return g_iNPCSmiteColorG[iNPCIndex];
}

int NPCChaserGetSmiteColorB(int iNPCIndex)
{
	return g_iNPCSmiteColorB[iNPCIndex];
}

int NPCChaserGetSmiteColorTrans(int iNPCIndex)
{
	return g_iNPCSmiteTransparency[iNPCIndex];
}

bool NPCChaserGetTrapState(int iNPCIndex)
{
	return g_bNPCTrapsEnabled[iNPCIndex];
}

int NPCChaserGetTrapType(int iNPCIndex)
{
	return g_iNPCTrapType[iNPCIndex];
}

float NPCChaserGetTrapSpawnTime(int iNPCIndex, int iDifficulty)
{
	return g_flNPCNextTrapSpawn[iNPCIndex][iDifficulty];
}

bool NPCChaserDamageParticlesEnabled(int iNPCIndex)
{
	return g_bSlenderHasDamageParticleEffect[iNPCIndex];
}

bool NPCChaserGetSelfHealState(int iNPCIndex)
{
	return g_bNPCCanSelfHeal[iNPCIndex];
}

float NPCChaserGetStartSelfHealPercentage(int iNPCIndex)
{
	return g_flNPCStartSelfHealPercentage[iNPCIndex];
}

float NPCChaserGetSelfHealPercentageOne(int iNPCIndex)
{
	return g_flNPCSelfHealPercentageOne[iNPCIndex];
}

float NPCChaserGetSelfHealPercentageTwo(int iNPCIndex)
{
	return g_flNPCSelfHealPercentageTwo[iNPCIndex];
}

float NPCChaserGetSelfHealPercentageThree(int iNPCIndex)
{
	return g_flNPCSelfHealPercentageThree[iNPCIndex];
}

bool NPCChaserIsAutoChaseEnabled(int iNPCIndex)
{
	return g_bNPCAutoChaseEnabled[iNPCIndex];
}

int NPCChaserAutoChaseThreshold(int iNPCIndex, int iDifficulty)
{
	return g_iNPCAutoChaseThreshold[iNPCIndex][iDifficulty];
}

int NPCChaserAutoChaseAddGeneral(int iNPCIndex, int iDifficulty)
{
	return g_iNPCAutoChaseAddGeneral[iNPCIndex][iDifficulty];
}

int NPCChaserAutoChaseAddFootstep(int iNPCIndex, int iDifficulty)
{
	return g_iNPCAutoChaseAddFootstep[iNPCIndex][iDifficulty];
}

int NPCChaserAutoChaseAddVoice(int iNPCIndex, int iDifficulty)
{
	return g_iNPCAutoChaseAddVoice[iNPCIndex][iDifficulty];
}

int NPCChaserAutoChaseAddWeapon(int iNPCIndex, int iDifficulty)
{
	return g_iNPCAutoChaseAddWeapon[iNPCIndex][iDifficulty];
}

bool NPCChaserCanAutoChaseSprinters(int iNPCIndex)
{
	return g_bNPCAutoChaseSprinters[iNPCIndex];
}

bool NPCChaserShockwaveOnAttack(int iNPCIndex)
{
	return g_bNPCShockwaveEnabled[iNPCIndex];
}

bool NPCChaserShockwaveStunEnabled(int iNPCIndex)
{
	return g_bNPCShockwaveStunEnabled[iNPCIndex];
}

int NPCChaserGetShockwaveAttackIndexes(int iNPCIndex)
{
	return g_iNPCShockwaveAttackIndexes[iNPCIndex];
}

float NPCChaserGetShockwaveDrain(int iNPCIndex, int iDifficulty)
{
	return g_flNPCShockwaveDrain[iNPCIndex][iDifficulty];
}

float NPCChaserGetShockwaveForce(int iNPCIndex, int iDifficulty)
{
	return g_flNPCShockwaveForce[iNPCIndex][iDifficulty];
}

float NPCChaserGetShockwaveHeight(int iNPCIndex, int iDifficulty)
{
	return g_flNPCShockwaveHeight[iNPCIndex][iDifficulty];
}

float NPCChaserGetShockwaveRange(int iNPCIndex, int iDifficulty)
{
	return g_flNPCShockwaveRange[iNPCIndex][iDifficulty];
}

float NPCChaserGetShockwaveStunDuration(int iNPCIndex, int iDifficulty)
{
	return g_flNPCShockwaveStunDuration[iNPCIndex][iDifficulty];
}

float NPCChaserGetShockwaveStunSlowdown(int iNPCIndex, int iDifficulty)
{
	return g_flNPCShockwaveStunSlowdown[iNPCIndex][iDifficulty];
}

bool NPCChaserGetEarthquakeFootstepsState(int iNPCIndex)
{
	return g_bNPCEarthquakeFootstepsEnabled[iNPCIndex];
}

float NPCChaserGetEarthquakeFootstepsAmplitude(int iNPCIndex)
{
	return g_flNPCEarthquakeFootstepsAmplitude[iNPCIndex];
}

float NPCChaserGetEarthquakeFootstepsFrequency(int iNPCIndex)
{
	return g_flNPCEarthquakeFootstepsFrequency[iNPCIndex];
}

float NPCChaserGetEarthquakeFootstepsDuration(int iNPCIndex)
{
	return g_flNPCEarthquakeFootstepsDuration[iNPCIndex];
}

float NPCChaserGetEarthquakeFootstepsRadius(int iNPCIndex)
{
	return g_flNPCEarthquakeFootstepsRadius[iNPCIndex];
}

bool NPCChaserGetEarthquakeFootstepsAirShakeState(int iNPCIndex)
{
	return g_bNPCEarthquakeFootstepsAirShake[iNPCIndex];
}

int NPCChaserGetSoundCountToAlert(int iNPCIndex)
{
	return g_iNPCSoundCountToAlert[iNPCIndex];
}

bool NPCChaserCanDisappearOnStun(int iNPCIndex)
{
	return g_bNPCDisappearOnStun[iNPCIndex];
}

bool NPCChaserCanDropItemOnStun(int iNPCIndex)
{
	return g_bNPCDropItemOnStun[iNPCIndex];
}

int NPCChaserItemDropTypeStun(int iNPCIndex)
{
	return g_iNPCDropItemType[iNPCIndex];
}

bool NPCChaserIsBoxingBoss(int iNPCIndex)
{
	return g_bNPCIsBoxingBoss[iNPCIndex];
}

bool NPCChaserNormalSoundHookEnabled(int iNPCIndex)
{
	return g_bNPCNormalSoundHookEnabled[iNPCIndex];
}

bool NPCChaserCanCloakToHeal(int iNPCIndex)
{
	return g_bNPCCloakToHealEnabled[iNPCIndex];
}

bool NPCChaserCanUseChaseInitialAnimation(int iNPCIndex)
{
	return g_bNPCCanUseChaseInitialAnimation[iNPCIndex];
}

bool NPCChaserOldAnimationAIEnabled(int iNPCIndex)
{
	return g_bNPCOldAnimationAIState[iNPCIndex];
}

bool NPCChaserCanUseAlertWalkingAnimation(int iNPCIndex)
{
	return g_bNPCCanUseAlertWalkingAnimation[iNPCIndex];
}

bool NPCChaserHasMultiAttackSounds(int iNPCIndex)
{
	return g_bNPCUsesMultiAttackSounds[iNPCIndex];
}

bool NPCChaserHasMultiHitSounds(int iNPCIndex)
{
	return g_bNPCUsesMultiHitSounds[iNPCIndex];
}

bool NPCChaserHasMultiMissSounds(int iNPCIndex)
{
	return g_bNPCUsesMultiMissSounds[iNPCIndex];
}

bool NPCChaserCanCrawl(int iNPCIndex)
{
	return g_bNPCHasCrawling[iNPCIndex];
}

float NPCChaserGetCrawlSpeedMultiplier(int iNPCIndex, int iDifficulty)
{
	return g_flNPCCrawlSpeedMultiplier[iNPCIndex][iDifficulty];
}

int NPCChaserGetState(int iNPCIndex)
{
	return g_iNPCState[iNPCIndex];
}

void NPCChaserSetState(int iNPCIndex, int iState)
{
	g_iNPCState[iNPCIndex] = iState;
}

int NPCChaserGetBoxingDifficulty(int iNPCIndex)
{
	return g_iNPCBoxingCurrentDifficulty[iNPCIndex];
}

void NPCChaserSetBoxingDifficulty(int iNPCIndex, int iValue)
{
	g_iNPCBoxingCurrentDifficulty[iNPCIndex] = iValue;
}

int NPCChaserGetBoxingRagePhase(int iNPCIndex)
{
	return g_iNPCBoxingRagePhase[iNPCIndex];
}

void NPCChaserSetBoxingRagePhase(int iNPCIndex, int iValue)
{
	g_iNPCBoxingRagePhase[iNPCIndex] = iValue;
}

int NPCChaserOnSelectProfile(int iNPCIndex, bool bInvincible)
{
	SF2ChaserBossProfile profile = SF2ChaserBossProfile(NPCGetProfileIndex(iNPCIndex));
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iNPCIndex, sProfile, sizeof(sProfile));
	
	g_flNPCWakeRadius[iNPCIndex] = profile.WakeRadius;

	for (int iDifficulty = 0; iDifficulty < Difficulty_Max; iDifficulty++)
	{
		g_flNPCWalkSpeed[iNPCIndex][iDifficulty] = profile.GetWalkSpeed(iDifficulty);
		g_flNPCMaxWalkSpeed[iNPCIndex][iDifficulty] = profile.GetMaxWalkSpeed(iDifficulty);

		g_flNPCAlertGracetime[iNPCIndex][iDifficulty] = profile.GetAlertStateGraceTime(iDifficulty);
		g_flNPCAlertDuration[iNPCIndex][iDifficulty] = profile.GetAlertStateDuration(iDifficulty);
		g_flNPCChaseDuration[iNPCIndex][iDifficulty] = profile.GetChaseStateDuration(iDifficulty);
		
		g_flNPCCloakCooldown[iNPCIndex][iDifficulty] = profile.GetCloakCooldown(iDifficulty);
		g_flNPCCloakRange[iNPCIndex][iDifficulty] = profile.GetCloakRange(iDifficulty);
		g_flNPCDecloakRange[iNPCIndex][iDifficulty] = profile.GetDecloakRange(iDifficulty);
		g_flNPCCloakDuration[iNPCIndex][iDifficulty] = profile.GetCloakDuration(iDifficulty);
		g_flNPCCloakSpeedMultiplier[iNPCIndex][iDifficulty] = profile.GetCloakSpeedMultiplier(iDifficulty);
		
		g_flNPCProjectileCooldownMin[iNPCIndex][iDifficulty] = profile.GetProjectileCooldownMin(iDifficulty);
		g_flNPCProjectileCooldownMax[iNPCIndex][iDifficulty] = profile.GetProjectileCooldownMax(iDifficulty);
		g_flNPCProjectileSpeed[iNPCIndex][iDifficulty] = profile.GetProjectileSpeed(iDifficulty);
		g_flNPCProjectileDamage[iNPCIndex][iDifficulty] = profile.GetProjectileDamage(iDifficulty);
		g_flNPCProjectileRadius[iNPCIndex][iDifficulty] = profile.GetProjectileRadius(iDifficulty);
		g_flNPCProjectileDeviation[iNPCIndex][iDifficulty] = profile.GetProjectileDeviation(iDifficulty);
		g_iNPCProjectileCount[iNPCIndex][iDifficulty] = profile.GetProjectileCount(iDifficulty);
		g_flIceballSlowdownDuration[iNPCIndex][iDifficulty] = profile.GetIceballSlowdownDuration(iDifficulty);
		g_flIceballSlowdownPercent[iNPCIndex][iDifficulty] = profile.GetIceballSlowdownPercent(iDifficulty);
		g_iNPCProjectileLoadedAmmo[iNPCIndex][iDifficulty] = profile.GetProjectileLoadedAmmo(iDifficulty);
		g_flNPCProjectileReloadTime[iNPCIndex][iDifficulty] = profile.GetProjectileReloadTime(iDifficulty);
		g_flNPCProjectileChargeUpTime[iNPCIndex][iDifficulty] = profile.GetProjectileChargeUpTime(iDifficulty);
		g_iNPCProjectileAmmo[iNPCIndex] = g_iNPCProjectileLoadedAmmo[iNPCIndex][iDifficulty];
		g_flNPCProjectileTimeToReload[iNPCIndex] = g_flNPCProjectileReloadTime[iNPCIndex][iDifficulty];
		
		g_flNPCRandomDuration[iNPCIndex][iDifficulty] = profile.GetRandomDuration(iDifficulty);
		g_flNPCRandomSlowdown[iNPCIndex][iDifficulty] = profile.GetRandomSlowdown(iDifficulty);
		g_flNPCJarateDuration[iNPCIndex][iDifficulty] = profile.GetJarateDuration(iDifficulty);
		g_flNPCMilkDuration[iNPCIndex][iDifficulty] = profile.GetMilkDuration(iDifficulty);
		g_flNPCGasDuration[iNPCIndex][iDifficulty] = profile.GetGasDuration(iDifficulty);
		g_flNPCMarkDuration[iNPCIndex][iDifficulty] = profile.GetMarkDuration(iDifficulty);
		g_flNPCIgniteDelay[iNPCIndex][iDifficulty] = profile.GetIgniteDelay(iDifficulty);
		g_flNPCStunAttackDuration[iNPCIndex][iDifficulty] = profile.GetStunAttackDuration(iDifficulty);
		g_flNPCStunAttackSlowdown[iNPCIndex][iDifficulty] = profile.GetStunAttackSlowdown(iDifficulty);
		g_flNPCBleedDuration[iNPCIndex][iDifficulty] = profile.GetBleedDuration(iDifficulty);
		g_flNPCElectricDuration[iNPCIndex][iDifficulty] = profile.GetElectricDuration(iDifficulty);
		g_flNPCElectricSlowdown[iNPCIndex][iDifficulty] = profile.GetElectricSlowdown(iDifficulty);
		
		g_flNPCShockwaveDrain[iNPCIndex][iDifficulty] = profile.GetShockwaveDrain(iDifficulty);
		g_flNPCShockwaveForce[iNPCIndex][iDifficulty] = profile.GetShockwaveForce(iDifficulty);
		g_flNPCShockwaveHeight[iNPCIndex][iDifficulty] = profile.GetShockwaveHeight(iDifficulty);
		g_flNPCShockwaveRange[iNPCIndex][iDifficulty] = profile.GetShockwaveRange(iDifficulty);
		g_flNPCShockwaveStunDuration[iNPCIndex][iDifficulty] = profile.GetShockwaveStunDuration(iDifficulty);
		g_flNPCShockwaveStunSlowdown[iNPCIndex][iDifficulty] = profile.GetShockwaveStunSlowdown(iDifficulty);
		
		g_flNPCNextTrapSpawn[iNPCIndex][iDifficulty] = profile.GetTrapCooldown(iDifficulty);
		g_flSlenderNextTrapPlacement[iNPCIndex] = GetGameTime() + g_flNPCNextTrapSpawn[iNPCIndex][iDifficulty];
		
		g_flNPCSearchWanderRangeMin[iNPCIndex][iDifficulty] = profile.GetWanderRangeMin(iDifficulty);
		g_flNPCSearchWanderRangeMax[iNPCIndex][iDifficulty] = profile.GetWanderRangeMax(iDifficulty);
		
		g_iNPCAutoChaseThreshold[iNPCIndex][iDifficulty] = profile.AutoChaseThreshold(iDifficulty);
		g_iNPCAutoChaseAddGeneral[iNPCIndex][iDifficulty] = profile.AutoChaseAddGeneral(iDifficulty);
		g_iNPCAutoChaseAddFootstep[iNPCIndex][iDifficulty] = profile.AutoChaseAddFootstep(iDifficulty);
		g_iNPCAutoChaseAddVoice[iNPCIndex][iDifficulty] = profile.AutoChaseAddVoice(iDifficulty);
		g_iNPCAutoChaseAddWeapon[iNPCIndex][iDifficulty] = profile.AutoChaseAddWeapon(iDifficulty);
		g_flNPCCrawlSpeedMultiplier[iNPCIndex][iDifficulty] = profile.GetCrawlingSpeedMultiplier(iDifficulty);
	}
	
	g_NPCBaseAttacksCount[iNPCIndex] = profile.AttackCount;
	// Get attack data.
	for (int i = 0; i < g_NPCBaseAttacksCount[iNPCIndex]; i++)
	{
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackType = profile.GetAttackType(i);
		for (int iDiffAtk = 0; iDiffAtk < Difficulty_Max; iDiffAtk++)
		{
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackDamage = profile.GetAttackDamage(i, iDiffAtk);
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackRunSpeed = profile.GetAttackRunSpeed(i, iDiffAtk);
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackCooldown = profile.GetAttackCooldown(i, iDiffAtk);
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackProjectileDamage = profile.GetAttackProjectileDamage(i, iDiffAtk);
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackProjectileSpeed = profile.GetAttackProjectileSpeed(i, iDiffAtk);
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackProjectileRadius = profile.GetAttackProjectileRadius(i, iDiffAtk);
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackProjectileDeviation = profile.GetAttackProjectileDeviation(i, iDiffAtk);
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackProjectileCount = profile.GetAttackProjectileCount(i, iDiffAtk);
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackProjectileIceSlowdownPercent = profile.GetAttackProjectileIceSlowdownPercent(i, iDiffAtk);
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackProjectileIceSlowdownDuration = profile.GetAttackProjectileIceSlowdownDuration(i, iDiffAtk);
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackBulletCount = profile.GetAttackBulletCount(i, iDiffAtk);
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackBulletDamage = profile.GetAttackBulletDamage(i, iDiffAtk);
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackBulletSpread = profile.GetAttackBulletSpread(i, iDiffAtk);
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackLaserDamage = profile.GetAttackLaserDamage(i, iDiffAtk);
		}
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackDamageVsProps = profile.GetAttackDamageVsProps(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackDamageForce = profile.GetAttackDamageForce(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackDamageType = profile.GetAttackDamageType(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackDamageDelay = profile.GetAttackDamageDelay(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackRange = profile.GetAttackRange(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackDuration = profile.GetAttackDuration(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackSpread = profile.GetAttackSpread(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackBeginRange = profile.GetAttackBeginRange(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackBeginFOV = profile.GetAttackBeginFOV(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackDisappear = profile.ShouldDisappearAfterAttack(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackRepeat = profile.GetAttackRepeatCount(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackMaxRepeats = profile.GetMaxAttackRepeats(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackNextAttackTime = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackIgnoreAlwaysLooking = profile.GetAttackIgnoreAlwaysLooking(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLifeSteal = profile.CanAttackLifeSteal(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLifeStealDuration = profile.GetAttackLifeStealDuration(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackProjectileCrits = profile.AreAttackProjectilesCritBoosted(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackProjectileType = profile.GetAttackProjectileType(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserSize = profile.GetAttackLaserSize(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackWhileRunning = profile.CanRunWhileAttacking(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackRunDuration = profile.GetAttackRunDuration(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackRunDelay = profile.GetAttackRunDelay(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackUseOnDifficulty = profile.GetAttackUseOnDifficulty(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackBlockOnDifficulty = profile.GetAttackBlockOnDifficulty(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackExplosiveDanceRadius = profile.GetAttackExplosiveDanceRadius(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackWeaponTypeInt = profile.GetAttackWeaponTypeInt(i);
		
		int iLaserColor[3];
		profile.GetAttackLaserColor(iLaserColor, i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserColor[0] = iLaserColor[0];
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserColor[1] = iLaserColor[1];
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserColor[2] = iLaserColor[2];
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserAttachment = profile.IsLaserOnAttachment(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserDuration = profile.GetAttackLaserDuration(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserNoise = profile.GetAttackLaserNoise(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackPullIn = profile.CanAttackPullIn(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackGestures = profile.HasAttackGestures(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].CurrentAttackRepeat = 0;
	}
	
	// Get stun data.
	if (!bInvincible) g_bNPCStunEnabled[iNPCIndex] = profile.StunEnabled;
	else g_bNPCStunEnabled[iNPCIndex] = false;
	g_flNPCStunDuration[iNPCIndex] = profile.StunDuration;
	g_flNPCStunCooldown[iNPCIndex] = profile.StunCooldown;
	g_bNPCStunFlashlightEnabled[iNPCIndex] = profile.StunByFlashlightEnabled;
	g_flNPCStunFlashlightDamage[iNPCIndex] = profile.StunFlashlightDamage;
	g_flNPCStunInitialHealth[iNPCIndex] = profile.StunHealth;
	g_bNPCChaseInitialOnStun[iNPCIndex] = profile.ChaseInitialOnStun;
	
	//Get Key Data
	g_bNPCHasKeyDrop[iNPCIndex] = profile.HasKeyDrop;
	
	//Get Cloak Data
	g_bNPCCloakEnabled[iNPCIndex] = profile.CloakEnabled;
	g_flNPCNextDecloakTime[iNPCIndex] = -1.0;
	
	float fStunHealthPerPlayer = profile.StunHealthPerPlayer;
	int count;
	for (int iClient; iClient <= MaxClients; iClient++)
	if (IsValidClient(iClient) && g_bPlayerEliminated[iClient])
		count++;
	fStunHealthPerPlayer *= float(count);
	g_flNPCStunInitialHealth[iNPCIndex] += fStunHealthPerPlayer;

	g_bNPCAlwaysLookAtTarget[iNPCIndex] = NPCHasAttribute(iNPCIndex, "always look at target");
	g_bNPCAlwaysLookAtTargetWhileAttacking[iNPCIndex] = NPCHasAttribute(iNPCIndex, "always look at target while attacking");
	g_bNPCAlwaysLookAtTargetWhileChasing[iNPCIndex] = NPCHasAttribute(iNPCIndex, "always look at target while chasing");
	
	NPCChaserSetStunHealth(iNPCIndex, NPCChaserGetStunInitialHealth(iNPCIndex));
	
	NPCSetAddSpeed(iNPCIndex, -NPCGetAddSpeed(iNPCIndex));
	NPCSetAddMaxSpeed(iNPCIndex, -NPCGetAddMaxSpeed(iNPCIndex));
	NPCSetAddAcceleration(iNPCIndex, -NPCGetAddAcceleration(iNPCIndex));
	NPCChaserSetAddStunHealth(iNPCIndex, -NPCChaserGetAddStunHealth(iNPCIndex));

	g_bNPCEarthquakeFootstepsEnabled[iNPCIndex] = profile.EarthquakeFootstepsEnabled;
	g_flNPCEarthquakeFootstepsAmplitude[iNPCIndex] = profile.EarthquakeFootstepsAmplitude;
	g_flNPCEarthquakeFootstepsFrequency[iNPCIndex] = profile.EarthquakeFootstepsFrequency;
	g_flNPCEarthquakeFootstepsDuration[iNPCIndex] = profile.EarthquakeFootstepsDuration;
	g_flNPCEarthquakeFootstepsRadius[iNPCIndex] = profile.EarthquakeFootstepsRadius;
	g_bNPCEarthquakeFootstepsAirShake[iNPCIndex] = profile.EarthquakeFootstepsAirShake;
	
	g_iNPCSoundCountToAlert[iNPCIndex] = profile.SoundCountToAlert;
	g_bNPCDisappearOnStun[iNPCIndex] = profile.CanDisappearOnStun;
	g_bNPCDropItemOnStun[iNPCIndex] = profile.DropItemOnStun;
	g_iNPCDropItemType[iNPCIndex] = profile.DropItemType;
	g_bNPCIsBoxingBoss[iNPCIndex] = profile.IsBoxingBoss;
	g_bNPCNormalSoundHookEnabled[iNPCIndex] = profile.NormalSoundHook;
	g_bNPCCloakToHealEnabled[iNPCIndex] = profile.CanCloakToHeal;
	g_bNPCCanUseChaseInitialAnimation[iNPCIndex] = profile.UseChaseInitialAnimation;
	g_bNPCOldAnimationAIState[iNPCIndex] = profile.HasOldAnimationAI;
	g_bNPCCanUseAlertWalkingAnimation[iNPCIndex] = profile.UseAlertWalkingAnimation;
	g_bSlenderDifficultyAnimations[iNPCIndex] = profile.DifficultyAffectsAnimations;

	g_bNPCUsesMultiAttackSounds[iNPCIndex] = profile.MultiAttackSounds;
	g_bNPCUsesMultiHitSounds[iNPCIndex] = profile.MultiHitSounds;
	g_bNPCUsesMultiMissSounds[iNPCIndex] = profile.MultiMissSounds;

	g_bNPCHasCrawling[iNPCIndex] = profile.IsCrawlingEnabled;
	g_bNPCIsCrawling[iNPCIndex] = false;
	g_bNPCChangeToCrawl[iNPCIndex] = false;
	GetProfileVector(sProfile, "crawl_detect_mins", g_flNPCCrawlDetectMins[iNPCIndex], view_as<float>( {0.0, 0.0, 0.0} ));
	GetProfileVector(sProfile, "crawl_detect_maxs", g_flNPCCrawlDetectMaxs[iNPCIndex], view_as<float>( {0.0, 0.0, 0.0} ));

	if (SF_SpecialRound(SPECIALROUND_TINYBOSSES))
	{
		g_flNPCCrawlDetectMins[iNPCIndex][0] /= 2.0;
		g_flNPCCrawlDetectMins[iNPCIndex][1] /= 2.0;
		g_flNPCCrawlDetectMins[iNPCIndex][2] /= 2.0;
		g_flNPCCrawlDetectMaxs[iNPCIndex][0] /= 2.0;
		g_flNPCCrawlDetectMaxs[iNPCIndex][1] /= 2.0;
		g_flNPCCrawlDetectMaxs[iNPCIndex][2] /= 2.0;
	}
	
	g_bNPCAlreadyAttacked[iNPCIndex] = false;
	g_bNPCVelocityCancel[iNPCIndex] = false;
	
	g_bNPCStealingLife[iNPCIndex] = false;
	g_hNPCLifeStealTimer[iNPCIndex] = null;
	
	g_bNPCHasCloaked[iNPCIndex] = false;
	
	//Get Projectile Data
	g_bNPCProjectileEnabled[iNPCIndex] = profile.ProjectileEnabled;
	g_iNPCProjectileType[iNPCIndex] = profile.ProjectileType;
	g_bNPCCriticalRockets[iNPCIndex] = profile.HasCriticalRockets;
	g_bNPCUseShootGesture[iNPCIndex] = profile.UseShootGesture;
	g_bNPCUseProjectileAmmo[iNPCIndex] = profile.ProjectileUsesAmmo;
	g_bNPCUseChargeUpProjectiles[iNPCIndex] = profile.ChargeUpProjectiles;
	g_flNPCProjectileCooldown[iNPCIndex] = 0.0;
	g_bNPCReloadingProjectiles[iNPCIndex] = false;
	
	g_bNPCUseAdvancedDamageEffects[iNPCIndex] = profile.AdvancedDamageEffectsEnabled;
	g_bNPCAdvancedDamageEffectsRandom[iNPCIndex] = profile.AdvancedDamageEffectsRandom;
	g_bNPCAttachDamageParticle[iNPCIndex] = profile.AttachDamageEffectsParticle;
	g_iNPCRandomAttackIndexes[iNPCIndex] = profile.RandomAttackIndexes;
	g_iNPCRandomStunType[iNPCIndex] = profile.RandomAttackStunType;
	g_bNPCJaratePlayerEnabled[iNPCIndex] = profile.JaratePlayerOnHit;
	g_iNPCJarateAttackIndexes[iNPCIndex] = profile.JarateAttackIndexes;
	g_bNPCMilkPlayerEnabled[iNPCIndex] = profile.MilkPlayerOnHit;
	g_iNPCMilkAttackIndexes[iNPCIndex] = profile.MilkAttackIndexes;
	g_bNPCGasPlayerEnabled[iNPCIndex] = profile.GasPlayerOnHit;
	g_iNPCGasAttackIndexes[iNPCIndex] = profile.GasAttackIndexes;
	g_bNPCMarkPlayerEnabled[iNPCIndex] = profile.MarkPlayerOnHit;
	g_iNPCMarkAttackIndexes[iNPCIndex] = profile.MarkAttackIndexes;
	g_iNPCSilentMarkAttackIndexes[iNPCIndex] = profile.SilentMarkAttackIndexes;
	g_bNPCIgnitePlayerEnabled[iNPCIndex] = profile.IgnitePlayerOnHit;
	g_iNPCIgniteAttackIndexes[iNPCIndex] = profile.IgniteAttackIndexes;
	g_bNPCStunPlayerEnabled[iNPCIndex] = profile.StunPlayerOnHit;
	g_iNPCStunAttackIndexes[iNPCIndex] = profile.StunAttackIndexes;
	g_iNPCStunAttackType[iNPCIndex] = profile.StunAttackType;
	g_bNPCBleedPlayerEnabled[iNPCIndex] = profile.BleedPlayerOnHit;
	g_iNPCBleedAttackIndexes[iNPCIndex] = profile.BleedAttackIndexes;
	g_bNPCElectricPlayerEnabled[iNPCIndex] = profile.ElectricPlayerOnHit;
	g_iNPCElectricAttackIndexes[iNPCIndex] = profile.ElectricAttackIndexes;
	g_bNPCSmitePlayerEnabled[iNPCIndex] = profile.SmitePlayerOnHit;
	g_bNPCSmiteMessage[iNPCIndex] = profile.SmiteMessage;
	g_iNPCSmiteAttackIndexes[iNPCIndex] = profile.SmiteAttackIndexes;
	g_flNPCSmiteDamage[iNPCIndex] = profile.SmiteDamage;
	g_iNPCSmiteDamageType[iNPCIndex] = profile.SmiteDamageType;

	g_bNPCXenobladeBreakComboSystem[iNPCIndex] = profile.XenobladeCombo;
	g_flNPCXenobladeBreakDuration[iNPCIndex] = profile.XenobladeBreakDuration;
	g_flNPCXenobladeToppleDuration[iNPCIndex] = profile.XenobladeToppleDuration;
	g_flNPCXenobladeToppleSlowdown[iNPCIndex] = profile.XenobladeToppleSlowdown;
	g_flNPCXenobladeDazeDuration[iNPCIndex] = profile.XenobladeDazeDuration;
	
	int smiteColor[4];
	profile.GetSmiteColor(smiteColor);
	
	g_iNPCSmiteColorR[iNPCIndex] = smiteColor[0];
	g_iNPCSmiteColorG[iNPCIndex] = smiteColor[1];
	g_iNPCSmiteColorB[iNPCIndex] = smiteColor[2];
	g_iNPCSmiteTransparency[iNPCIndex] = smiteColor[3];
	g_bSlenderHasDamageParticleEffect[iNPCIndex] = profile.HasDamageParticles;
	g_flSlenderDamageClientSoundVolume[iNPCIndex] = profile.DamageParticleVolume;
	g_iSlenderDamageClientSoundPitch[iNPCIndex] = profile.DamageParticlePitch;
	
	g_bNPCShockwaveEnabled[iNPCIndex] = profile.HasShockwaves;
	g_bNPCShockwaveStunEnabled[iNPCIndex] = profile.ShockwaveStunEnabled;
	g_iNPCShockwaveAttackIndexes[iNPCIndex] = profile.ShockwaveAttackIndexes;
	
	g_bNPCTrapsEnabled[iNPCIndex] = profile.HasTraps;
	g_iNPCTrapType[iNPCIndex] = profile.TrapType;
	
	g_bNPCAutoChaseEnabled[iNPCIndex] = profile.AutoChaseEnabled;
	g_bNPCAutoChaseSprinters[iNPCIndex] = profile.AutoChaseSprinters;
	g_flNPCAutoChaseSprinterCooldown[iNPCIndex] = 0.0;
	g_bNPCInAutoChase[iNPCIndex] = false;
	g_bAutoChasingLoudPlayer[iNPCIndex] = false;
	
	g_bNPCChasesEndlessly[iNPCIndex] = profile.ChasesEndlessly;
	
	g_flNPCLaserTimer[iNPCIndex] = 0.0;
	
	g_bNPCCanSelfHeal[iNPCIndex] = profile.SelfHealState;
	g_flNPCStartSelfHealPercentage[iNPCIndex] = profile.SelfHealStartPercentage;
	g_flNPCSelfHealPercentageOne[iNPCIndex] = profile.SelfHealPercentageOne;
	g_flNPCSelfHealPercentageTwo[iNPCIndex] = profile.SelfHealPercentageTwo;
	g_flNPCSelfHealPercentageThree[iNPCIndex] = profile.SelfHealPercentageThree;
	g_bNPCRunningToHeal[iNPCIndex] = false;
	g_bNPCHealing[iNPCIndex] = false;
	g_flNPCFleeHealTimer[iNPCIndex] = 0.0;
	g_iNPCSelfHealStage[iNPCIndex] = 0;
	g_iNPCHealCount[iNPCIndex] = 0;
	g_bNPCSetHealDestination[iNPCIndex] = false;

	g_iNPCBoxingCurrentDifficulty[iNPCIndex] = 1;
	g_iNPCBoxingRagePhase[iNPCIndex] = 0;
	
	g_bNPCCopyAlerted[iNPCIndex] = false;
}

void NPCChaserOnRemoveProfile(int iNPCIndex)
{
	NPCChaserResetValues(iNPCIndex);
}

/**
 *	Resets all global variables on a specified NPC. Usually this should be done last upon removing a boss from the game.
 */
static void NPCChaserResetValues(int iNPCIndex)
{
	g_flNPCWakeRadius[iNPCIndex] = 0.0;
	
	for (int iDifficulty = 0; iDifficulty < Difficulty_Max; iDifficulty++)
	{
		g_flNPCWalkSpeed[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCMaxWalkSpeed[iNPCIndex][iDifficulty] = 0.0;

		g_flNPCAlertGracetime[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCAlertDuration[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCChaseDuration[iNPCIndex][iDifficulty] = 0.0;
		
		g_flNPCCloakCooldown[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCCloakRange[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCDecloakRange[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCCloakDuration[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCCloakSpeedMultiplier[iNPCIndex][iDifficulty] = 0.0;
		
		g_flNPCProjectileCooldownMin[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCProjectileCooldownMax[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCProjectileSpeed[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCProjectileDamage[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCProjectileRadius[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCProjectileDeviation[iNPCIndex][iDifficulty] = 0.0;
		g_iNPCProjectileCount[iNPCIndex][iDifficulty] = 0;
		g_flIceballSlowdownDuration[iNPCIndex][iDifficulty] = 0.0;
		g_flIceballSlowdownPercent[iNPCIndex][iDifficulty] = 0.0;
		g_iNPCProjectileLoadedAmmo[iNPCIndex][iDifficulty] = 0;
		g_flNPCProjectileReloadTime[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCProjectileChargeUpTime[iNPCIndex][iDifficulty] = 0.0;
		
		g_flNPCRandomDuration[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCRandomSlowdown[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCJarateDuration[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCMilkDuration[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCGasDuration[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCMarkDuration[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCIgniteDelay[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCStunAttackDuration[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCStunAttackSlowdown[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCBleedDuration[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCElectricDuration[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCElectricSlowdown[iNPCIndex][iDifficulty] = 0.0;
		
		g_flNPCShockwaveDrain[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCShockwaveForce[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCShockwaveHeight[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCShockwaveRange[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCShockwaveStunDuration[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCShockwaveStunSlowdown[iNPCIndex][iDifficulty] = 0.0;
		
		g_flNPCNextTrapSpawn[iNPCIndex][iDifficulty] = 0.0;
		g_flSlenderNextTrapPlacement[iNPCIndex] = 0.0;
		
		g_flNPCSearchWanderRangeMin[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCSearchWanderRangeMax[iNPCIndex][iDifficulty] = 0.0;
		
		g_iNPCAutoChaseThreshold[iNPCIndex][iDifficulty] = 0;
		g_iNPCAutoChaseAddGeneral[iNPCIndex][iDifficulty] = 0;
		g_iNPCAutoChaseAddFootstep[iNPCIndex][iDifficulty] = 0;
		g_iNPCAutoChaseAddVoice[iNPCIndex][iDifficulty] = 0;
		g_iNPCAutoChaseAddWeapon[iNPCIndex][iDifficulty] = 0;

		g_flNPCCrawlSpeedMultiplier[iNPCIndex][iDifficulty] = 0.0;
	}
	
	// Clear attack data.
	for (int i = 0; i < SF2_CHASER_BOSS_MAX_ATTACKS - 1; i++)
	{
		// Base attack data.
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackType = SF2BossAttackType_Invalid;
		for (int iDiffAtk = 0; iDiffAtk < Difficulty_Max; iDiffAtk++)
		{
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackDamage = 0.0;
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackRunSpeed = 0.0;
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackCooldown = 0.0;
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackProjectileDamage = 0.0;
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackProjectileSpeed = 0.0;
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackProjectileRadius = 0.0;
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackProjectileDeviation = 0.0;
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackProjectileCount = 0;
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackProjectileIceSlowdownPercent = 0.0;
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackProjectileIceSlowdownDuration = 0.0;
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackBulletCount = 0;
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackBulletDamage = 0.0;
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackBulletSpread = 0.0;
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackLaserDamage = 0.0;
		}
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackDamageVsProps = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackDamageForce = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackDamageType = 0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackDamageDelay = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackRange = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackDuration = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackSpread = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackBeginRange = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackBeginFOV = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackDisappear = 0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackRepeat = 0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackMaxRepeats = 0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackNextAttackTime = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackIgnoreAlwaysLooking = false;
		g_NPCBaseAttacks[iNPCIndex][i][1].WeaponAttackIndex = 0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLifeSteal = false;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLifeStealDuration = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackProjectileCrits = false;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackProjectileType = 0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserSize = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserColor[0] = 0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserColor[1] = 0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserColor[2] = 0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserAttachment = false;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserDuration = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserNoise = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackPullIn = false;
		g_NPCBaseAttacks[iNPCIndex][i][1].CurrentAttackRepeat = 0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackWhileRunning = false;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackRunDuration = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackRunDelay = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackUseOnDifficulty = 0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackBlockOnDifficulty = 0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackExplosiveDanceRadius = 0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackWeaponTypeInt = 0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackGestures = false;
	}

	g_bNPCEarthquakeFootstepsEnabled[iNPCIndex] = false;
	g_flNPCEarthquakeFootstepsAmplitude[iNPCIndex] = 0.0;
	g_flNPCEarthquakeFootstepsFrequency[iNPCIndex] = 0.0;
	g_flNPCEarthquakeFootstepsDuration[iNPCIndex] = 0.0;
	g_flNPCEarthquakeFootstepsRadius[iNPCIndex] = 0.0;
	g_bNPCEarthquakeFootstepsAirShake[iNPCIndex] = false;
	
	g_iNPCSoundCountToAlert[iNPCIndex] = 0;
	g_bNPCDisappearOnStun[iNPCIndex] = false;
	g_bNPCDropItemOnStun[iNPCIndex] = false;
	g_iNPCDropItemType[iNPCIndex] = 0;
	g_bNPCIsBoxingBoss[iNPCIndex] = false;
	g_bNPCNormalSoundHookEnabled[iNPCIndex] = false;
	g_bNPCCloakToHealEnabled[iNPCIndex] = false;
	g_bNPCCanUseChaseInitialAnimation[iNPCIndex] = false;
	g_bNPCOldAnimationAIState[iNPCIndex] = false;
	g_bNPCCanUseAlertWalkingAnimation[iNPCIndex] = false;

	g_bNPCUsesMultiAttackSounds[iNPCIndex] = false;
	g_bNPCUsesMultiHitSounds[iNPCIndex] = false;
	g_bNPCUsesMultiMissSounds[iNPCIndex] = false;

	g_bNPCHasCrawling[iNPCIndex] = false;
	g_bNPCIsCrawling[iNPCIndex] = false;
	
	g_bNPCStunEnabled[iNPCIndex] = false;
	g_bNPCAlreadyAttacked[iNPCIndex] = false;
	g_flNPCStunDuration[iNPCIndex] = 0.0;
	g_flNPCStunCooldown[iNPCIndex] = 0.0;
	g_bNPCStunFlashlightEnabled[iNPCIndex] = false;
	g_flNPCStunInitialHealth[iNPCIndex] = 0.0;
	g_flNPCStunAddHealth[iNPCIndex] = 0.0;
	g_bNPCChaseInitialOnStun[iNPCIndex] = false;
	g_bSlenderDifficultyAnimations[iNPCIndex] = false;
	
	g_bNPCCloakEnabled[iNPCIndex] = false;
	g_flNPCNextDecloakTime[iNPCIndex] = -1.0;
	g_bNPCHasCloaked[iNPCIndex] = false;
	g_bNPCVelocityCancel[iNPCIndex] = false;
	g_bNPCStealingLife[iNPCIndex] = false;
	g_hNPCLifeStealTimer[iNPCIndex] = null;
	g_hBossFailSafeTimer[iNPCIndex] = null;

	g_bNPCAlwaysLookAtTarget[iNPCIndex] = false;
	g_bNPCAlwaysLookAtTargetWhileAttacking[iNPCIndex] = false;
	g_bNPCAlwaysLookAtTargetWhileChasing[iNPCIndex] = false;
	
	g_bNPCUsedRage1[iNPCIndex] = false;
	g_bNPCUsedRage2[iNPCIndex] = false;
	g_bNPCUsedRage3[iNPCIndex] = false;
	
	g_bNPCProjectileEnabled[iNPCIndex] = false;
	g_iNPCProjectileType[iNPCIndex] = SF2BossProjectileType_Invalid;
	g_bNPCCriticalRockets[iNPCIndex] = false;
	g_bNPCUseShootGesture[iNPCIndex] = false;
	g_bNPCUseProjectileAmmo[iNPCIndex] = false;
	g_bNPCUseChargeUpProjectiles[iNPCIndex] = false;
	g_iNPCProjectileAmmo[iNPCIndex] = 0;
	g_flNPCProjectileCooldown[iNPCIndex] = 0.0;
	g_flNPCProjectileTimeToReload[iNPCIndex] = 0.0;
	g_bNPCReloadingProjectiles[iNPCIndex] = false;
	
	g_bNPCUseAdvancedDamageEffects[iNPCIndex] = false;
	g_bNPCAdvancedDamageEffectsRandom[iNPCIndex] = false;
	g_bNPCAttachDamageParticle[iNPCIndex] = false;
	g_iNPCRandomAttackIndexes[iNPCIndex] = 0;
	g_iNPCRandomStunType[iNPCIndex] = 0;
	g_bNPCJaratePlayerEnabled[iNPCIndex] = false;
	g_iNPCJarateAttackIndexes[iNPCIndex] = 0;
	g_bNPCMilkPlayerEnabled[iNPCIndex] = false;
	g_iNPCMilkAttackIndexes[iNPCIndex] = 0;
	g_bNPCGasPlayerEnabled[iNPCIndex] = false;
	g_iNPCGasAttackIndexes[iNPCIndex] = 0;
	g_bNPCMarkPlayerEnabled[iNPCIndex] = false;
	g_iNPCMarkAttackIndexes[iNPCIndex] = 0;
	g_iNPCSilentMarkAttackIndexes[iNPCIndex] = 0;
	g_bNPCIgnitePlayerEnabled[iNPCIndex] = false;
	g_iNPCIgniteAttackIndexes[iNPCIndex] = 0;
	g_bNPCStunPlayerEnabled[iNPCIndex] = false;
	g_iNPCStunAttackIndexes[iNPCIndex] = 0;
	g_iNPCStunAttackType[iNPCIndex] = 0;
	g_bNPCBleedPlayerEnabled[iNPCIndex] = false;
	g_iNPCBleedAttackIndexes[iNPCIndex] = 0;
	g_bNPCElectricPlayerEnabled[iNPCIndex] = false;
	g_iNPCElectricAttackIndexes[iNPCIndex] = 0;
	g_bNPCSmitePlayerEnabled[iNPCIndex] = false;
	g_bNPCSmiteMessage[iNPCIndex] = false;
	g_iNPCSmiteAttackIndexes[iNPCIndex] = 0;
	g_bNPCXenobladeBreakComboSystem[iNPCIndex] = false;
	g_flNPCXenobladeBreakDuration[iNPCIndex] = 0.0;
	g_flNPCXenobladeToppleDuration[iNPCIndex] = 0.0;
	g_flNPCXenobladeToppleSlowdown[iNPCIndex] = 0.0;
	g_flNPCXenobladeDazeDuration[iNPCIndex] = 0.0;
	g_flNPCSmiteDamage[iNPCIndex] = 0.0;
	g_iNPCSmiteDamageType[iNPCIndex] = 0;
	g_iNPCSmiteColorR[iNPCIndex] = 0;
	g_iNPCSmiteColorG[iNPCIndex] = 0;
	g_iNPCSmiteColorB[iNPCIndex] = 0;
	g_iNPCSmiteTransparency[iNPCIndex] = 0;
	g_bNPCShockwaveEnabled[iNPCIndex] = false;
	g_bNPCShockwaveStunEnabled[iNPCIndex] = false;
	g_iNPCShockwaveAttackIndexes[iNPCIndex] = 0;
	g_flNPCTimeUntilChaseAfterInitial[iNPCIndex] = 0.0;
	g_bSlenderHasDamageParticleEffect[iNPCIndex] = false;
	g_flSlenderDamageClientSoundVolume[iNPCIndex] = 0.0;
	g_iSlenderDamageClientSoundPitch[iNPCIndex] = 0;
	
	g_bNPCTrapsEnabled[iNPCIndex] = false;
	g_iNPCTrapType[iNPCIndex] = 0;
	
	g_bNPCAutoChaseEnabled[iNPCIndex] = false;
	g_bNPCInAutoChase[iNPCIndex] = false;
	g_bNPCAutoChaseSprinters[iNPCIndex] = false;
	g_flNPCAutoChaseSprinterCooldown[iNPCIndex] = 0.0;
	g_bAutoChasingLoudPlayer[iNPCIndex] = false;
	
	g_bNPCChasesEndlessly[iNPCIndex] = false;
	
	NPCSetAddSpeed(iNPCIndex, -NPCGetAddSpeed(iNPCIndex));
	NPCSetAddMaxSpeed(iNPCIndex, -NPCGetAddMaxSpeed(iNPCIndex));
	NPCSetAddAcceleration(iNPCIndex, -NPCGetAddAcceleration(iNPCIndex));
	NPCChaserSetAddStunHealth(iNPCIndex, -NPCChaserGetAddStunHealth(iNPCIndex));
	
	NPCChaserSetStunHealth(iNPCIndex, 0.0);
	
	g_iNPCState[iNPCIndex] = -1;
	
	g_flNPCLaserTimer[iNPCIndex] = 0.0;
	
	g_bNPCCanSelfHeal[iNPCIndex] = false;
	g_flNPCStartSelfHealPercentage[iNPCIndex] = 0.0;
	g_flNPCSelfHealPercentageOne[iNPCIndex] = 0.0;
	g_flNPCSelfHealPercentageTwo[iNPCIndex] = 0.0;
	g_flNPCSelfHealPercentageThree[iNPCIndex] = 0.0;
	g_bNPCRunningToHeal[iNPCIndex] = false;
	g_bNPCHealing[iNPCIndex] = false;
	g_flNPCFleeHealTimer[iNPCIndex] = 0.0;
	g_iNPCSelfHealStage[iNPCIndex] = 0;
	g_iNPCHealCount[iNPCIndex] = 0;
	g_bNPCSetHealDestination[iNPCIndex] = false;

	g_iNPCBoxingCurrentDifficulty[iNPCIndex] = 0;
	g_iNPCBoxingRagePhase[iNPCIndex] = 0;
	
	g_bNPCCopyAlerted[iNPCIndex] = false;
}

void Spawn_Chaser(int iBossIndex)
{
	g_hBossFailSafeTimer[iBossIndex] = null;
	g_flLastStuckTime[iBossIndex] = 0.0;
	g_iSlenderOldState[iBossIndex] = STATE_IDLE;
	g_bNPCCopyAlerted[iBossIndex] = false;
	g_flNPCNextDecloakTime[iBossIndex] = -1.0;
	g_bNPCIsCrawling[iBossIndex] = false;
	g_bNPCChangeToCrawl[iBossIndex] = false;
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

stock bool IsTargetValidForSlender(int iTarget, bool bIncludeEliminated = false)
{
	if (!iTarget || !IsValidClient(iTarget)) return false;
	
	if (IsValidClient(iTarget))
	{
		if (!IsClientInGame(iTarget) || 
			!IsPlayerAlive(iTarget) || 
			IsClientInDeathCam(iTarget) || 
			(!bIncludeEliminated && g_bPlayerEliminated[iTarget]) || 
			IsClientInGhostMode(iTarget) || 
			DidClientEscape(iTarget)) return false;
	}
	
	return true;
}

public Action Timer_DeathPosChaseStop(Handle timer, int iBossIndex)
{
	if (!g_bEnabled)
	{
		g_hBossFailSafeTimer[iBossIndex] = null;
		return Plugin_Stop;
	}
	
	if (timer != g_hBossFailSafeTimer[iBossIndex])
	{
		g_hBossFailSafeTimer[iBossIndex] = null;
		return Plugin_Stop;
	}
	
	if (g_bNPCInAutoChase[iBossIndex])
	{
		g_hBossFailSafeTimer[iBossIndex] = null;
		g_bNPCInAutoChase[iBossIndex] = false;
		g_flNPCAutoChaseSprinterCooldown[iBossIndex] = NPCChaserGetAlertDuration(iBossIndex, g_cvDifficulty.IntValue);
		return Plugin_Stop;
	}
	
	if (g_bAutoChasingLoudPlayer[iBossIndex] && g_iSlenderState[iBossIndex] != STATE_CHASE && g_iSlenderState[iBossIndex] != STATE_ATTACK && g_iSlenderState[iBossIndex] != STATE_STUN)
	{
		g_hBossFailSafeTimer[iBossIndex] = null;
		g_bAutoChasingLoudPlayer[iBossIndex] = false;
		return Plugin_Stop;
	}
	
	if (!g_bSlenderChaseDeathPosition[iBossIndex])
	{
		g_hBossFailSafeTimer[iBossIndex] = null;
		g_bSlenderGiveUp[iBossIndex] = true;
		return Plugin_Stop;
	}
	
	if (g_iSlenderState[iBossIndex] == STATE_CHASE || g_iSlenderState[iBossIndex] == STATE_ATTACK || g_iSlenderState[iBossIndex] == STATE_STUN)
	{
		g_hBossFailSafeTimer[iBossIndex] = null;
		return Plugin_Stop;
	}
	
	g_bSlenderChaseDeathPosition[iBossIndex] = false;
	g_bSlenderGiveUp[iBossIndex] = true;
	g_hBossFailSafeTimer[iBossIndex] = null;
	return Plugin_Stop;
}

public int NPCChaserGetClosestPlayer(int iSlender)
{
	if (!g_bEnabled) return -1;
	if (!iSlender || iSlender == INVALID_ENT_REFERENCE) return -1;

	int iBossIndex = NPCGetFromEntIndex(iSlender);
	if (iBossIndex == -1) return -1;

	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
	
	float flPosition[3];
	GetEntPropVector(iSlender, Prop_Data, "m_vecAbsOrigin", flPosition);
	
	int iClosestTarget = -1;
	float flSearchRadius = NPCGetSearchRadius(iBossIndex, iDifficulty);
	
	for (int i = 0; i <= MaxClients; i++)
	{
		if (!IsValidClient(i) || !IsClientInGame(i) || IsClientInGhostMode(i) || g_bPlayerProxy[i] || !IsPlayerAlive(i) || g_bPlayerEliminated[i])continue;
		
		float flClientPos[3];
		GetClientAbsOrigin(i, flClientPos);
		
		float flDistance = GetVectorSquareMagnitude(flPosition, flClientPos);
		
		if (flDistance < SquareFloat(flSearchRadius))
		{
			iClosestTarget = i;
			flSearchRadius = flDistance;
		}
	}
	
	if (IsValidClient(iClosestTarget)) return iClosestTarget;
	
	return -1;
}

void NPCChaserUpdateBossAnimation(int iBossIndex, int iEnt, int iState, bool bSpawn = false)
{
	char sAnimation[256];
	float flPlaybackRate, flTempFootsteps, flCycle;
	bool bAnimationFound = false;

	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	bool bClearLayers = view_as<bool>(GetProfileNum(sProfile, "animation_clear_layers_on_update", 1));
	
	switch (iState)
	{
		case STATE_IDLE:
		{
			if (!bSpawn)
			{
				switch (iDifficulty)
				{
					case Difficulty_Normal:
					{
						bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
					}
					case Difficulty_Hard:
					{
						bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
						if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
						{
							bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
						}
						else
						{
							bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
						}
					}
					case Difficulty_Insane:
					{
						bool bAnimationFound3 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
						if (!bAnimationFound3 || strcmp(sAnimation, "") <= 0)
						{
							bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
							if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
						}
					}
					case Difficulty_Nightmare:
					{
						bool bAnimationFound4 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
						if (!bAnimationFound4 || strcmp(sAnimation, "") <= 0)
						{
							bool bAnimationFound3 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
							if (!bAnimationFound3 || strcmp(sAnimation, "") <= 0)
							{
								bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
								if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
								}
								else
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
						}
					}
					case Difficulty_Apollyon:
					{
						bool bAnimationFound5 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
						if (!bAnimationFound5 || strcmp(sAnimation, "") <= 0)
						{
							bool bAnimationFound4 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
							if (!bAnimationFound4 || strcmp(sAnimation, "") <= 0)
							{
								bool bAnimationFound3 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
								if (!bAnimationFound3 || strcmp(sAnimation, "") <= 0)
								{
									bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
									if (bAnimationFound2 || strcmp(sAnimation, "") <= 0)
									{
										bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
									}
									else
									{
										bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
									}
								}
								else
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
						}
					}
				}
			}
			else
			{
				bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_SpawnAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, flTempFootsteps, flCycle);
			}
		}
		case STATE_WANDER:
		{
			if (NPCGetFlags(iBossIndex) & SFF_WANDERMOVE)
			{
				if (!g_bNPCIsCrawling[iBossIndex])
				{
					switch (iDifficulty)
					{
						case Difficulty_Normal:
						{
							bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
						}
						case Difficulty_Hard:
						{
							bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							}
						}
						case Difficulty_Insane:
						{
							bool bAnimationFound3 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							if (!bAnimationFound3 || strcmp(sAnimation, "") <= 0)
							{
								bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
								if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
								}
								else
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							}
						}
						case Difficulty_Nightmare:
						{
							bool bAnimationFound4 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							if (!bAnimationFound4 || strcmp(sAnimation, "") <= 0)
							{
								bool bAnimationFound3 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
								if (!bAnimationFound3 || strcmp(sAnimation, "") <= 0)
								{
									bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
									if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
									{
										bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
									}
									else
									{
										bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
									}
								}
								else
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							}
						}
						case Difficulty_Apollyon:
						{
							bool bAnimationFound5 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							if (!bAnimationFound5 || strcmp(sAnimation, "") <= 0)
							{
								bool bAnimationFound4 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
								if (!bAnimationFound4 || strcmp(sAnimation, "") <= 0)
								{
									bool bAnimationFound3 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
									if (!bAnimationFound3 || strcmp(sAnimation, "") <= 0)
									{
										bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
										if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
										{
											bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
										}
										else
										{
											bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
										}
									}
									else
									{
										bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
									}
								}
								else
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							}
						}
					}
				}
				else
				{
					switch (iDifficulty)
					{
						case Difficulty_Normal:
						{
							bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
						}
						case Difficulty_Hard:
						{
							bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							}
						}
						case Difficulty_Insane:
						{
							bool bAnimationFound3 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							if (!bAnimationFound3 || strcmp(sAnimation, "") <= 0)
							{
								bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
								if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
								}
								else
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							}
						}
						case Difficulty_Nightmare:
						{
							bool bAnimationFound4 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							if (!bAnimationFound4 || strcmp(sAnimation, "") <= 0)
							{
								bool bAnimationFound3 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
								if (!bAnimationFound3 || strcmp(sAnimation, "") <= 0)
								{
									bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
									if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
									{
										bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
									}
									else
									{
										bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
									}
								}
								else
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							}
						}
						case Difficulty_Apollyon:
						{
							bool bAnimationFound5 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							if (!bAnimationFound5 || strcmp(sAnimation, "") <= 0)
							{
								bool bAnimationFound4 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
								if (!bAnimationFound4 || strcmp(sAnimation, "") <= 0)
								{
									bool bAnimationFound3 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
									if (!bAnimationFound3 || strcmp(sAnimation, "") <= 0)
									{
										bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
										if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
										{
											bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
										}
										else
										{
											bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
										}
									}
									else
									{
										bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
									}
								}
								else
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							}
						}
					}
				}
			}
		}
		case STATE_ALERT:
		{
			if (!g_bNPCIsCrawling[iBossIndex])
			{
				if (NPCChaserCanUseAlertWalkingAnimation(iBossIndex))
				{
					switch (iDifficulty)
					{
						case Difficulty_Normal:
						{
							bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
						}
						case Difficulty_Hard:
						{
							bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							}
						}
						case Difficulty_Insane:
						{
							bool bAnimationFound3 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							if (!bAnimationFound3 || strcmp(sAnimation, "") <= 0)
							{
								bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
								if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
								}
								else
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							}
						}
						case Difficulty_Nightmare:
						{
							bool bAnimationFound4 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							if (!bAnimationFound4 || strcmp(sAnimation, "") <= 0)
							{
								bool bAnimationFound3 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
								if (!bAnimationFound3 || strcmp(sAnimation, "") <= 0)
								{
									bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
									if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
									{
										bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
									}
									else
									{
										bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
									}
								}
								else
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							}
						}
						case Difficulty_Apollyon:
						{
							bool bAnimationFound5 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							if (!bAnimationFound5 || strcmp(sAnimation, "") <= 0)
							{
								bool bAnimationFound4 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
								if (!bAnimationFound4 || strcmp(sAnimation, "") <= 0)
								{
									bool bAnimationFound3 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
									if (!bAnimationFound3 || strcmp(sAnimation, "") <= 0)
									{
										bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
										if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
										{
											bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
										}
										else
										{
											bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
										}
									}
									else
									{
										bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
									}
								}
								else
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex], flCycle);
							}
						}
					}
				}
				else
				{
					switch (iDifficulty)
					{
						case Difficulty_Normal:
						{
							bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						}
						case Difficulty_Hard:
						{
							bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							}
						}
						case Difficulty_Insane:
						{
							bool bAnimationFound3 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							if (!bAnimationFound3 || strcmp(sAnimation, "") <= 0)
							{
								bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								}
								else
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							}
						}
						case Difficulty_Nightmare:
						{
							bool bAnimationFound4 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							if (!bAnimationFound4 || strcmp(sAnimation, "") <= 0)
							{
								bool bAnimationFound3 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								if (!bAnimationFound3 || strcmp(sAnimation, "") <= 0)
								{
									bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
									if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
									{
										bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex]);
									}
									else
									{
										bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
									}
								}
								else
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							}
						}
						case Difficulty_Apollyon:
						{
							bool bAnimationFound5 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							if (!bAnimationFound5 || strcmp(sAnimation, "") <= 0)
							{
								bool bAnimationFound4 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								if (!bAnimationFound4 || strcmp(sAnimation, "") <= 0)
								{
									bool bAnimationFound3 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex]);
									if (!bAnimationFound3 || strcmp(sAnimation, "") <= 0)
									{
										bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
										if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
										{
											bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex]);
										}
										else
										{
											bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
										}
									}
									else
									{
										bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex]);
									}
								}
								else
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							}
						}
					}
				}
			}
			else
			{
				switch (iDifficulty)
				{
					case Difficulty_Normal:
					{
						bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
					}
					case Difficulty_Hard:
					{
						bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
						{
							bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						}
						else
						{
							bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						}
					}
					case Difficulty_Insane:
					{
						bool bAnimationFound3 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						if (!bAnimationFound3 || strcmp(sAnimation, "") <= 0)
						{
							bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						}
					}
					case Difficulty_Nightmare:
					{
						bool bAnimationFound4 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						if (!bAnimationFound4 || strcmp(sAnimation, "") <= 0)
						{
							bool bAnimationFound3 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							if (!bAnimationFound3 || strcmp(sAnimation, "") <= 0)
							{
								bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								}
								else
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						}
					}
					case Difficulty_Apollyon:
					{
						bool bAnimationFound5 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						if (!bAnimationFound5 || strcmp(sAnimation, "") <= 0)
						{
							bool bAnimationFound4 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							if (!bAnimationFound4 || strcmp(sAnimation, "") <= 0)
							{
								bool bAnimationFound3 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								if (!bAnimationFound3 || strcmp(sAnimation, "") <= 0)
								{
									bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
									if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
									{
										bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex]);
									}
									else
									{
										bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
									}
								}
								else
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CrawlWalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						}
					}
				}
			}
		}
		case STATE_CHASE:
		{
			if (!g_bNPCUsesChaseInitialAnimation[iBossIndex] && 
			!g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && 
			!g_bNPCUsesHealAnimation[iBossIndex] && !g_bNPCUseStartFleeAnimation[iBossIndex] && 
			!g_bNPCUsesCloakStartAnimation[iBossIndex] && !g_bNPCUsesCloakEndAnimation[iBossIndex] && !g_bNPCIsCrawling[iBossIndex])
			{
				switch (iDifficulty)
				{
					case Difficulty_Normal:
					{
						bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
					}
					case Difficulty_Hard:
					{
						bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
						if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
						{
							bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
						}
						else
						{
							bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
						}
					}
					case Difficulty_Insane:
					{
						bool bAnimationFound3 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
						if (!bAnimationFound3 || strcmp(sAnimation, "") <= 0)
						{
							bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
							if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
						}
					}
					case Difficulty_Nightmare:
					{
						bool bAnimationFound4 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
						if (!bAnimationFound4 || strcmp(sAnimation, "") <= 0)
						{
							bool bAnimationFound3 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
							if (!bAnimationFound3 || strcmp(sAnimation, "") <= 0)
							{
								bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
								if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
								}
								else
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
						}
					}
					case Difficulty_Apollyon:
					{
						bool bAnimationFound5 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
						if (!bAnimationFound5 || strcmp(sAnimation, "") <= 0)
						{
							bool bAnimationFound4 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
							if (!bAnimationFound4 || strcmp(sAnimation, "") <= 0)
							{
								bool bAnimationFound3 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
								if (!bAnimationFound3 || strcmp(sAnimation, "") <= 0)
								{
									bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
									if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
									{
										bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
									}
									else
									{
										bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
									}
								}
								else
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
						}
					}
				}
			}
			else if (g_bNPCUsesChaseInitialAnimation[iBossIndex])
			{
				bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_ChaseInitialAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, flTempFootsteps, flCycle);
			}
			else if (g_bNPCUsesRageAnimation1[iBossIndex] || g_bNPCUsesRageAnimation2[iBossIndex] || g_bNPCUsesRageAnimation3[iBossIndex])
			{
				bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_RageAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, flTempFootsteps, flCycle);
			}
			else if (g_bNPCUsesCloakStartAnimation[iBossIndex])
			{
				bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CloakStartAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, flTempFootsteps, flCycle);
			}
			else if (g_bNPCUsesCloakEndAnimation[iBossIndex])
			{
				bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_CloakEndAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, flTempFootsteps, flCycle);
			}
			else if (g_bNPCIsCrawling[iBossIndex] && !g_bNPCUsesChaseInitialAnimation[iBossIndex] && 
			!g_bNPCUsesCloakStartAnimation[iBossIndex] && !g_bNPCUsesCloakEndAnimation[iBossIndex] &&
			!g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
			{
				switch (iDifficulty)
				{
					case Difficulty_Normal:
					{
						bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserANimation_CrawlRunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
					}
					case Difficulty_Hard:
					{
						bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserANimation_CrawlRunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
						if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
						{
							bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserANimation_CrawlRunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
						}
						else
						{
							bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserANimation_CrawlRunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
						}
					}
					case Difficulty_Insane:
					{
						bool bAnimationFound3 = GetProfileAnimation(iBossIndex, sProfile, ChaserANimation_CrawlRunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
						if (!bAnimationFound3 || strcmp(sAnimation, "") <= 0)
						{
							bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserANimation_CrawlRunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
							if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserANimation_CrawlRunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserANimation_CrawlRunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserANimation_CrawlRunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
						}
					}
					case Difficulty_Nightmare:
					{
						bool bAnimationFound4 = GetProfileAnimation(iBossIndex, sProfile, ChaserANimation_CrawlRunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
						if (!bAnimationFound4 || strcmp(sAnimation, "") <= 0)
						{
							bool bAnimationFound3 = GetProfileAnimation(iBossIndex, sProfile, ChaserANimation_CrawlRunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
							if (!bAnimationFound3 || strcmp(sAnimation, "") <= 0)
							{
								bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserANimation_CrawlRunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
								if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserANimation_CrawlRunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
								}
								else
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserANimation_CrawlRunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserANimation_CrawlRunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserANimation_CrawlRunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
						}
					}
					case Difficulty_Apollyon:
					{
						bool bAnimationFound5 = GetProfileAnimation(iBossIndex, sProfile, ChaserANimation_CrawlRunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
						if (!bAnimationFound5 || strcmp(sAnimation, "") <= 0)
						{
							bool bAnimationFound4 = GetProfileAnimation(iBossIndex, sProfile, ChaserANimation_CrawlRunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
							if (!bAnimationFound4 || strcmp(sAnimation, "") <= 0)
							{
								bool bAnimationFound3 = GetProfileAnimation(iBossIndex, sProfile, ChaserANimation_CrawlRunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
								if (!bAnimationFound3 || strcmp(sAnimation, "") <= 0)
								{
									bool bAnimationFound2 = GetProfileAnimation(iBossIndex, sProfile, ChaserANimation_CrawlRunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
									if (!bAnimationFound2 || strcmp(sAnimation, "") <= 0)
									{
										bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserANimation_CrawlRunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
									}
									else
									{
										bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserANimation_CrawlRunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
									}
								}
								else
								{
									bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserANimation_CrawlRunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserANimation_CrawlRunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserANimation_CrawlRunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex], flCycle);
						}
					}
				}
			}
		}
		case STATE_ATTACK:
		{
			if (!g_bNPCUseFireAnimation[iBossIndex])
			{
				bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_AttackAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, NPCGetCurrentAttackIndex(iBossIndex) + 1, g_flSlenderAttackFootstepTime[iBossIndex], flCycle);
			}
			else
			{
				bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_ShootAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, NPCGetCurrentAttackIndex(iBossIndex) + 1, g_flSlenderAttackFootstepTime[iBossIndex], flCycle);
			}
		}
		case STATE_STUN:
		{
			bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_StunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderStunFootstepTime[iBossIndex], flCycle);
		}
		case STATE_DEATHCAM:
		{
			bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_DeathcamAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, flTempFootsteps, flCycle);
		}
	}
	switch (iState)
	{
		case STATE_IDLE, STATE_WANDER, STATE_ALERT, STATE_CHASE:
		{
			if (g_bNPCUseStartFleeAnimation[iBossIndex])
			{
				bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_FleeInitialAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, flTempFootsteps, flCycle);
			}
			else if (g_bNPCUsesHealAnimation[iBossIndex])
			{
				bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_HealAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, flTempFootsteps, flCycle);
			}
		}
	}
	
	if (flPlaybackRate < -12.0) flPlaybackRate = -12.0;
	if (flPlaybackRate > 12.0) flPlaybackRate = 12.0;
	
	if (bAnimationFound && strcmp(sAnimation, "") != 0)
	{
		Action action = Plugin_Continue;
		Call_StartForward(fOnBossAnimationUpdate);
		Call_PushCell(iBossIndex);
		Call_Finish(action);
		if (action != Plugin_Handled)
		{
			g_flNPCCurrentAnimationSequencePlaybackRate[iBossIndex] = flPlaybackRate;
			g_iNPCCurrentAnimationSequence[iBossIndex] = EntitySetAnimation(iEnt, sAnimation, flPlaybackRate, _, flCycle);
			g_sNPCurrentAnimationSequenceName[iBossIndex] = sAnimation;
			EntitySetAnimation(iEnt, sAnimation, flPlaybackRate, _, flCycle); //Fix an issue where an anim could start on the wrong frame.
			if (g_iNPCCurrentAnimationSequence[iBossIndex] <= -1)
			{
				g_iNPCCurrentAnimationSequence[iBossIndex] = 0;
				//SendDebugMessageToPlayers(DEBUG_BOSS_ANIMATION, 0, "INVALID ANIMATION %s", sAnimation);
			}
			bool bAnimationLoop = (iState == STATE_IDLE || iState == STATE_ALERT || 
			(iState == STATE_CHASE && !g_bNPCUsesChaseInitialAnimation[iBossIndex] && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && !g_bNPCUseStartFleeAnimation[iBossIndex] && !g_bNPCUsesHealAnimation[iBossIndex] && !g_bNPCUsesCloakStartAnimation[iBossIndex] && !g_bNPCUsesCloakEndAnimation[iBossIndex]) 
			|| iState == STATE_WANDER
			|| (iState == STATE_ATTACK && NPCChaserGetAttackWhileRunningState(iBossIndex, NPCGetCurrentAttackIndex(iBossIndex))));
			SetEntProp(iEnt, Prop_Data, "m_bSequenceLoops", bAnimationLoop);
		}
	}
	if (iState == STATE_ATTACK && NPCChaserGetAttackGestureState(iBossIndex, NPCGetCurrentAttackIndex(iBossIndex)))
	{
		float flGestureCycle, flDuration;
		bAnimationFound = GetProfileGesture(iBossIndex, sProfile, ChaserAnimation_AttackAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, flCycle, NPCGetCurrentAttackIndex(iBossIndex) + 1);
		if (bAnimationFound && strcmp(sAnimation, "") != 0)
		{
			CBaseCombatCharacter overlay = CBaseCombatCharacter(iEnt);
			int iGesture = overlay.LookupSequence(sAnimation);
			if (iGesture != -1)
			{
				flDuration = overlay.SequenceDuration(iGesture);
				int iLayer = overlay.AddLayeredSequence(iGesture, 1);
				overlay.SetLayerDuration(iLayer, flDuration);
				overlay.SetLayerPlaybackRate(iLayer, flPlaybackRate);
				overlay.SetLayerCycle(iLayer, flGestureCycle);
				overlay.SetLayerAutokill(iLayer, true);
			}
		}
	}
	if (!g_bSlenderAttacking[iBossIndex] && bClearLayers)
	{
		CBaseNPC_RemoveAllLayers(iEnt);
	}
}

public Action Timer_SlenderChaseInitialTimer(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;
	
	if (timer != g_hSlenderChaseInitialTimer[iBossIndex]) return Plugin_Stop;
	
	if (!g_bNPCUsesChaseInitialAnimation[iBossIndex]) return Plugin_Stop;

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();

	int iOldState = g_iSlenderState[iBossIndex];
	int iState = iOldState;
	
	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
	
	float flOriginalSpeed;
	
	if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) && !g_bRenevant90sEffect)
	{
		flOriginalSpeed = NPCGetSpeed(iBossIndex, iDifficulty) + NPCGetAddSpeed(iBossIndex);
	}
	else
	{
		flOriginalSpeed = NPCGetSpeed(iBossIndex, iDifficulty) + NPCGetAddSpeed(iBossIndex);
		if ((flOriginalSpeed < 520.0))
		{
			flOriginalSpeed = 520.0;
		}
	}
	float flSpeed = flOriginalSpeed;
	g_flSlenderCalculatedSpeed[iBossIndex] = flSpeed;
	
	g_bNPCUsesChaseInitialAnimation[iBossIndex] = false;
	g_flLastStuckTime[iBossIndex] = 0.0;
	loco.ClearStuckStatus();
	if (iState != STATE_ATTACK) NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
	g_hSlenderChaseInitialTimer[iBossIndex] = null;
	return Plugin_Stop;
}

public Action Timer_SlenderRageOneTimer(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;
	
	if (timer != g_hSlenderRage1Timer[iBossIndex]) return Plugin_Stop;
	
	if (!g_bNPCUsesRageAnimation1[iBossIndex]) return Plugin_Stop;

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();
	
	int iOldState = g_iSlenderState[iBossIndex];
	int iState = iOldState;
	
	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
	
	float flOriginalSpeed;
	
	if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) && !g_bRenevant90sEffect)
	{
		flOriginalSpeed = NPCGetSpeed(iBossIndex, iDifficulty) + NPCGetAddSpeed(iBossIndex);
	}
	else
	{
		flOriginalSpeed = NPCGetSpeed(iBossIndex, iDifficulty) + NPCGetAddSpeed(iBossIndex);
		if ((flOriginalSpeed < 520.0))
		{
			flOriginalSpeed = 520.0;
		}
	}
	float flSpeed = flOriginalSpeed;
	g_flSlenderCalculatedSpeed[iBossIndex] = flSpeed;
	
	g_bNPCUsesRageAnimation1[iBossIndex] = false;
	g_flLastStuckTime[iBossIndex] = 0.0;
	loco.ClearStuckStatus();
	if (iState != STATE_ATTACK) NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
	return Plugin_Stop;
}

public Action Timer_SlenderRageTwoTimer(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;
	
	if (timer != g_hSlenderRage2Timer[iBossIndex]) return Plugin_Stop;
	
	if (!g_bNPCUsesRageAnimation2[iBossIndex]) return Plugin_Stop;

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();
	
	int iOldState = g_iSlenderState[iBossIndex];
	int iState = iOldState;
	
	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
	
	float flOriginalSpeed;
	
	if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) && !g_bRenevant90sEffect)
	{
		flOriginalSpeed = NPCGetSpeed(iBossIndex, iDifficulty) + NPCGetAddSpeed(iBossIndex);
	}
	else
	{
		flOriginalSpeed = NPCGetSpeed(iBossIndex, iDifficulty) + NPCGetAddSpeed(iBossIndex);
		if ((flOriginalSpeed < 520.0))
		{
			flOriginalSpeed = 520.0;
		}
	}
	float flSpeed = flOriginalSpeed;
	g_flSlenderCalculatedSpeed[iBossIndex] = flSpeed;
	
	g_bNPCUsesRageAnimation2[iBossIndex] = false;
	g_flLastStuckTime[iBossIndex] = 0.0;
	loco.ClearStuckStatus();
	if (iState != STATE_ATTACK) NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
	return Plugin_Stop;
}

public Action Timer_SlenderRageThreeTimer(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;
	
	if (timer != g_hSlenderRage3Timer[iBossIndex]) return Plugin_Stop;
	
	if (!g_bNPCUsesRageAnimation3[iBossIndex]) return Plugin_Stop;

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();
	
	int iOldState = g_iSlenderState[iBossIndex];
	int iState = iOldState;
	
	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
	
	float flOriginalSpeed;
	
	if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) && !g_bRenevant90sEffect)
	{
		flOriginalSpeed = NPCGetSpeed(iBossIndex, iDifficulty) + NPCGetAddSpeed(iBossIndex);
	}
	else
	{
		flOriginalSpeed = NPCGetSpeed(iBossIndex, iDifficulty) + NPCGetAddSpeed(iBossIndex);
		if ((flOriginalSpeed < 520.0))
		{
			flOriginalSpeed = 520.0;
		}
	}
	float flSpeed = flOriginalSpeed;
	g_flSlenderCalculatedSpeed[iBossIndex] = flSpeed;
	
	g_bNPCUsesRageAnimation3[iBossIndex] = false;
	g_flLastStuckTime[iBossIndex] = 0.0;
	loco.ClearStuckStatus();
	if (iState != STATE_ATTACK) NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
	return Plugin_Stop;
}

public Action Timer_SlenderSpawnTimer(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;
	
	if (timer != g_hSlenderSpawnTimer[iBossIndex]) return Plugin_Stop;
	
	if (!g_bSlenderSpawning[iBossIndex]) return Plugin_Stop;

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();

	SDKHook(slender, SDKHook_Think, SlenderChaseBossProcessMovement);
	g_bSlenderSpawning[iBossIndex] = false;
	g_flLastStuckTime[iBossIndex] = 0.0;
	loco.ClearStuckStatus();
	g_hSlenderEntityThink[iBossIndex] = CreateTimer(BOSS_THINKRATE, Timer_SlenderChaseBossThink, EntIndexToEntRef(slender), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	NPCChaserUpdateBossAnimation(iBossIndex, slender, STATE_IDLE);
	return Plugin_Stop;
}

public Action Timer_SlenderHealAnimationTimer(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;
	
	if (timer != g_hSlenderHealTimer[iBossIndex]) return Plugin_Stop;

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();
	
	int iOldState = g_iSlenderState[iBossIndex];
	int iState = iOldState;
	
	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
	
	float flOriginalSpeed;
	
	if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) && !g_bRenevant90sEffect)
	{
		flOriginalSpeed = NPCGetSpeed(iBossIndex, iDifficulty) + NPCGetAddSpeed(iBossIndex);
	}
	else
	{
		flOriginalSpeed = NPCGetSpeed(iBossIndex, iDifficulty) + NPCGetAddSpeed(iBossIndex);
		if ((flOriginalSpeed < 520.0))
		{
			flOriginalSpeed = 520.0;
		}
	}
	float flSpeed = flOriginalSpeed;
	g_flSlenderCalculatedSpeed[iBossIndex] = flSpeed;
	
	g_bNPCSetHealDestination[iBossIndex] = false;
	g_bNPCRunningToHeal[iBossIndex] = false;
	g_flLastStuckTime[iBossIndex] = 0.0;
	loco.ClearStuckStatus();
	g_bNPCUseStartFleeAnimation[iBossIndex] = false;
	g_bNPCUsesHealAnimation[iBossIndex] = false;
	g_bNPCHealing[iBossIndex] = false;
	g_flNPCFleeHealTimer[iBossIndex] = GetGameTime();
	g_iNPCHealCount[iBossIndex] = 0;
	g_iNPCSelfHealStage[iBossIndex]++;
	NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
	g_hSlenderHealDelayTimer[iBossIndex] = null;
	g_hSlenderStartFleeTimer[iBossIndex] = null;
	g_hSlenderHealTimer[iBossIndex] = null;
	return Plugin_Stop;
}

public Action Timer_SlenderHealDelayTimer(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;
	
	if (timer != g_hSlenderHealDelayTimer[iBossIndex]) return Plugin_Stop;
	
	SlenderPerformVoice(iBossIndex, "sound_heal_self");
	
	g_iNPCHealCount[iBossIndex] = 0;
	
	g_hSlenderHealEventTimer[iBossIndex] = CreateTimer(0.05, Timer_SlenderHealEventTimer, EntIndexToEntRef(slender), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	return Plugin_Stop;
}

public Action Timer_SlenderHealEventTimer(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;
	
	if (timer != g_hSlenderHealEventTimer[iBossIndex]) return Plugin_Stop;
	
	if (!g_bNPCHealing[iBossIndex]) return Plugin_Stop;

	if (g_iSlenderState[iBossIndex] == STATE_STUN) return Plugin_Stop;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	float flCheckPercentage;
	switch (g_iNPCSelfHealStage[iBossIndex])
	{
		case 0:flCheckPercentage = NPCChaserGetSelfHealPercentageOne(iBossIndex) * NPCChaserGetStunInitialHealth(iBossIndex);
		case 1:flCheckPercentage = NPCChaserGetSelfHealPercentageTwo(iBossIndex) * NPCChaserGetStunInitialHealth(iBossIndex);
		case 2, 3:flCheckPercentage = NPCChaserGetSelfHealPercentageThree(iBossIndex) * NPCChaserGetStunInitialHealth(iBossIndex);
	}
	float flRegenHealth = flCheckPercentage / 10.0;
	
	if (NPCChaserGetStunHealth(iBossIndex) + flRegenHealth < NPCChaserGetStunInitialHealth(iBossIndex))
	{
		NPCChaserAddStunHealth(iBossIndex, flRegenHealth);
		if (NPCGetHealthbarState(iBossIndex))
		{
			UpdateHealthBar(iBossIndex);
		}
		g_iNPCHealCount[iBossIndex]++;
	}
	else
	{
		float flAddRemainHealth = NPCChaserGetStunInitialHealth(iBossIndex) - NPCChaserGetStunHealth(iBossIndex);
		NPCChaserAddStunHealth(iBossIndex, flAddRemainHealth);
		if (NPCGetHealthbarState(iBossIndex))
		{
			UpdateHealthBar(iBossIndex);
		}
		g_bNPCHealing[iBossIndex] = false;
		g_iNPCHealCount[iBossIndex] = 0;
		return Plugin_Stop;
	}
	
	if (g_iNPCHealCount[iBossIndex] >= 10)
	{
		g_bNPCHealing[iBossIndex] = false;
		g_iNPCHealCount[iBossIndex] = 0;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

public Action Timer_SlenderFleeAnimationTimer(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;
	
	if (timer != g_hSlenderStartFleeTimer[iBossIndex]) return Plugin_Stop;
	
	if (!g_bNPCUseStartFleeAnimation[iBossIndex]) return Plugin_Stop;

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();
	
	int iOldState = g_iSlenderState[iBossIndex];
	int iState = iOldState;
	
	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
	
	float flOriginalSpeed;
	
	if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) && !g_bRenevant90sEffect)
	{
		flOriginalSpeed = NPCGetSpeed(iBossIndex, iDifficulty) + NPCGetAddSpeed(iBossIndex);
	}
	else
	{
		flOriginalSpeed = NPCGetSpeed(iBossIndex, iDifficulty) + NPCGetAddSpeed(iBossIndex);
		if ((flOriginalSpeed < 520.0))
		{
			flOriginalSpeed = 520.0;
		}
	}
	float flSpeed = flOriginalSpeed;
	g_flSlenderCalculatedSpeed[iBossIndex] = flSpeed;
	g_iSlenderTarget[iBossIndex] = INVALID_ENT_REFERENCE;
	
	g_bNPCUseStartFleeAnimation[iBossIndex] = false;
	g_bNPCRunningToHeal[iBossIndex] = true;
	g_flLastStuckTime[iBossIndex] = 0.0;
	loco.ClearStuckStatus();
	NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
	
	return Plugin_Stop;
}
public MRESReturn ShouldCollideWith(Address pThis, Handle hReturn, Handle hParams)
{
	int iEntity = DHookGetParam(hParams, 1);
	if (IsValidEntity(iEntity))
	{
		char strClass[32];
		GetEdictClassname(iEntity, strClass, sizeof(strClass));
		if (strcmp(strClass, "tf_zombie") == 0)
		{
			DHookSetReturn(hReturn, false);
			return MRES_Supercede;
		}
		else if (strcmp(strClass, "base_boss") == 0)
		{
			DHookSetReturn(hReturn, false);
			return MRES_Supercede;
		}
		else if (strcmp(strClass, "base_npc") == 0)
		{
			DHookSetReturn(hReturn, false);
			return MRES_Supercede;
		}
		else if (strcmp(strClass, "player") == 0)
		{
			if (g_bPlayerProxy[iEntity] || IsClientInGhostMode(iEntity) || IsClientInDeathCam(iEntity))
			{
				DHookSetReturn(hReturn, false);
				return MRES_Supercede;
			}
		}
		else if (IsEntityAProjectile(iEntity))
		{
			DHookSetReturn(hReturn, false);
			return MRES_Supercede;
		}
	}
	return MRES_Ignored;
}

public MRESReturn CBaseAnimating_HandleAnimEvent(int pThis, Handle hParams)
{
	int iBossIndex = NPCGetFromEntIndex(pThis);
	int event = DHookGetParamObjectPtrVar(hParams, 1, 0, ObjectValueType_Int);
	if(event > 0 && NPCGetUniqueID(iBossIndex) != -1)	//Footstep
	{
		char sKeyValue[256];
		FormatEx(sKeyValue, sizeof(sKeyValue), "sound_footsteps_event_%i", event);
		SlenderCastFootstepAnimEvent(iBossIndex, sKeyValue);
	}
}

public MRESReturn Hook_BossUpdateTransmitState(int iBossEntity, DHookReturn hookReturn)
{
    if (!g_bEnabled || !IsValidEntity(iBossEntity) || NPCGetFromEntIndex(iBossEntity) == -1)
    {
        return MRES_Ignored;
    }

    hookReturn.Value = SetEntityTransmitState(iBossEntity, FL_EDICT_ALWAYS);
    return MRES_Supercede;
}

void SlenderDoDamageEffects(int iBossIndex, int iAttackIndex, int iClient)
{
	if (!IsValidClient(iClient)) return;
	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
	int slender = NPCGetEntIndex(iBossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	float flMyEyePos[3];
	NPCGetEyePosition(iBossIndex, flMyEyePos);

	if (NPCChaserUseRandomAdvancedDamageEffects(iBossIndex))
	{
		char sIndexes[8], sAllowedIndexes[88], sAllowedIndexesList[33][3];
		char sCurrentIndex[2];
		int iDamageIndexes = NPCChaserRandomEffectIndexes(iBossIndex);
		GetProfileString(sProfile, "player_random_attack_indexes", sAllowedIndexes, sizeof(sAllowedIndexes), "1");
		FormatEx(sIndexes, sizeof(sIndexes), "%d", iDamageIndexes);
		FormatEx(sCurrentIndex, sizeof(sCurrentIndex), "%d", iAttackIndex + 1);

		int iCount = ExplodeString(sAllowedIndexes, " ", sAllowedIndexesList, 33, 3);
		if (iCount > 1)
		{
			for (int iIndex = 0; iIndex < iCount && iIndex < NPCChaserGetAttackCount(iBossIndex); iIndex++)
			{
				int iForIndex = StringToInt(sAllowedIndexesList[iIndex]);
				if (iForIndex == iAttackIndex + 1 && NPCChaserRandomEffectDuration(iBossIndex, iDifficulty) > 0.0)
				{
					int iRandomEffect = GetRandomInt(0, 6);
					switch (iRandomEffect)
					{
						case 0: TF2_AddCondition(iClient, TFCond_Jarated, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty));
						case 1: TF2_AddCondition(iClient, TFCond_Milked, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty));
						case 2: TF2_AddCondition(iClient, TFCond_Gas, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty));
						case 3: TF2_AddCondition(iClient, TFCond_MarkedForDeath, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty));
						case 4: if (!TF2_IsPlayerInCondition(iClient, TFCond_Bleeding)) TF2_MakeBleed(iClient, iClient, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty));
						case 5: TF2_IgnitePlayer(iClient, iClient);
						case 6:
						{
							switch (NPCChaserRandomEffectStunType(iBossIndex))
							{
								case 1: TF2_StunPlayer(iClient, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty), NPCChaserRandomEffectSlowdown(iBossIndex, iDifficulty), TF_STUNFLAG_SLOWDOWN);
								case 2: TF2_StunPlayer(iClient, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty), NPCChaserRandomEffectSlowdown(iBossIndex, iDifficulty), TF_STUNFLAGS_LOSERSTATE);
								case 3: TF2_StunPlayer(iClient, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty), NPCChaserRandomEffectSlowdown(iBossIndex, iDifficulty), TF_STUNFLAG_BONKSTUCK|TF_STUNFLAG_NOSOUNDOREFFECT);
								case 4: TF2_StunPlayer(iClient, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty), NPCChaserRandomEffectSlowdown(iBossIndex, iDifficulty), TF_STUNFLAGS_GHOSTSCARE);
							}
						}
					}
					break;
				}
			}
		}
		else //Legacy support
		{
			char sNumber = sCurrentIndex[0];
			int iAttackNumber = 0;
			if (FindCharInString(sIndexes, sNumber) != -1)
			{
				iAttackNumber += iAttackIndex + 1;
			}
			if (sIndexes[0] != '\0' && sCurrentIndex[0] != '\0' && iAttackNumber != -1)
			{
				int iCurrentAtkIndex = StringToInt(sCurrentIndex);
				if (iAttackNumber == iCurrentAtkIndex && NPCChaserRandomEffectDuration(iBossIndex, iDifficulty) > 0.0)
				{
					int iRandomEffect = GetRandomInt(0, 6);
					switch (iRandomEffect)
					{
						case 0: TF2_AddCondition(iClient, TFCond_Jarated, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty));
						case 1: TF2_AddCondition(iClient, TFCond_Milked, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty));
						case 2: TF2_AddCondition(iClient, TFCond_Gas, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty));
						case 3: TF2_AddCondition(iClient, TFCond_MarkedForDeath, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty));
						case 4: if (!TF2_IsPlayerInCondition(iClient, TFCond_Bleeding)) TF2_MakeBleed(iClient, iClient, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty));
						case 5: TF2_IgnitePlayer(iClient, iClient);
						case 6:
						{
							switch (NPCChaserRandomEffectStunType(iBossIndex))
							{
								case 1: TF2_StunPlayer(iClient, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty), NPCChaserRandomEffectSlowdown(iBossIndex, iDifficulty), TF_STUNFLAG_SLOWDOWN);
								case 2: TF2_StunPlayer(iClient, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty), NPCChaserRandomEffectSlowdown(iBossIndex, iDifficulty), TF_STUNFLAGS_LOSERSTATE);
								case 3: TF2_StunPlayer(iClient, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty), NPCChaserRandomEffectSlowdown(iBossIndex, iDifficulty), TF_STUNFLAG_BONKSTUCK|TF_STUNFLAG_NOSOUNDOREFFECT);
								case 4: TF2_StunPlayer(iClient, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty), NPCChaserRandomEffectSlowdown(iBossIndex, iDifficulty), TF_STUNFLAGS_GHOSTSCARE);
							}
						}
					}
				}
			}
		}
	}
	if (NPCChaserJaratePlayerOnHit(iBossIndex))
	{
		char sIndexes[8], sAllowedIndexes[88], sAllowedIndexesList[33][3];
		char sCurrentIndex[2];
		int iDamageIndexes = NPCChaserGetJarateAttackIndexes(iBossIndex);
		GetProfileString(sProfile, "player_jarate_attack_indexs", sAllowedIndexes, sizeof(sAllowedIndexes), "1");
		FormatEx(sIndexes, sizeof(sIndexes), "%d", iDamageIndexes);
		FormatEx(sCurrentIndex, sizeof(sCurrentIndex), "%d", iAttackIndex + 1);
		
		int iCount = ExplodeString(sAllowedIndexes, " ", sAllowedIndexesList, 33, 3);
		if (iCount > 1)
		{
			for (int iIndex = 0; iIndex < iCount && iIndex < NPCChaserGetAttackCount(iBossIndex); iIndex++)
			{
				int iForIndex = StringToInt(sAllowedIndexesList[iIndex]);
				if (iForIndex == iAttackIndex + 1 && NPCChaserGetJarateDuration(iBossIndex, iDifficulty) > 0.0)
				{
					GetProfileString(sProfile, "player_jarate_particle", sJaratePlayerParticle, sizeof(sJaratePlayerParticle));
					if (sJaratePlayerParticle[0] == '\0')
					{
						sJaratePlayerParticle = JARATE_PARTICLE;
					}
					if (NPCChaserAttachDamageParticle(iBossIndex))
					{
						SlenderCreateParticleAttach(iBossIndex, sJaratePlayerParticle, 35.0, iClient);
					}
					else
					{
						SlenderCreateParticle(iBossIndex, sJaratePlayerParticle, 35.0);
					}
					if (g_sSlenderJarateHitSound[iBossIndex][0] != '\0') //No sound, what?
						EmitSoundToAll(g_sSlenderJarateHitSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
					TF2_AddCondition(iClient, TFCond_Jarated, NPCChaserGetJarateDuration(iBossIndex, iDifficulty));
					break;
				}
			}
		}
		else //Legacy support
		{
			char sNumber = sCurrentIndex[0];
			int iAttackNumber = 0;
			if (FindCharInString(sIndexes, sNumber) != -1)
			{
				iAttackNumber += iAttackIndex + 1;
			}
			if (sIndexes[0] != '\0' && sCurrentIndex[0] != '\0' && iAttackNumber != -1)
			{
				int iCurrentAtkIndex = StringToInt(sCurrentIndex);
				if (iAttackNumber == iCurrentAtkIndex && NPCChaserGetJarateDuration(iBossIndex, iDifficulty) > 0.0)
				{
					GetProfileString(sProfile, "player_jarate_particle", sJaratePlayerParticle, sizeof(sJaratePlayerParticle));
					if (sJaratePlayerParticle[0] == '\0')
					{
						sJaratePlayerParticle = JARATE_PARTICLE;
					}
					if (NPCChaserAttachDamageParticle(iBossIndex))
					{
						SlenderCreateParticleAttach(iBossIndex, sJaratePlayerParticle, 35.0, iClient);
					}
					else
					{
						SlenderCreateParticle(iBossIndex, sJaratePlayerParticle, 35.0);
					}
					if (g_sSlenderJarateHitSound[iBossIndex][0] != '\0') //No sound, what?
						EmitSoundToAll(g_sSlenderJarateHitSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
					TF2_AddCondition(iClient, TFCond_Jarated, NPCChaserGetJarateDuration(iBossIndex, iDifficulty));
				}
			}
		}
	}
	if (NPCChaserMilkPlayerOnHit(iBossIndex))
	{
		char sIndexes[8], sAllowedIndexes[88], sAllowedIndexesList[33][3];
		char sCurrentIndex[2];
		int iDamageIndexes = NPCChaserGetMilkAttackIndexes(iBossIndex);
		GetProfileString(sProfile, "player_milk_attack_indexs", sAllowedIndexes, sizeof(sAllowedIndexes), "1");
		FormatEx(sIndexes, sizeof(sIndexes), "%d", iDamageIndexes);
		FormatEx(sCurrentIndex, sizeof(sCurrentIndex), "%d", iAttackIndex + 1);

		int iCount = ExplodeString(sAllowedIndexes, " ", sAllowedIndexesList, 33, 3);
		if (iCount > 1)
		{
			for (int iIndex = 0; iIndex < iCount && iIndex < NPCChaserGetAttackCount(iBossIndex); iIndex++)
			{
				int iForIndex = StringToInt(sAllowedIndexesList[iIndex]);
				if (iForIndex == iAttackIndex + 1 && NPCChaserGetMilkDuration(iBossIndex, iDifficulty) > 0.0)
				{
					GetProfileString(sProfile, "player_milk_particle", sMilkPlayerParticle, sizeof(sMilkPlayerParticle));
					if (sMilkPlayerParticle[0] == '\0')
					{
						sMilkPlayerParticle = MILK_PARTICLE;
					}
					if (NPCChaserAttachDamageParticle(iBossIndex))
					{
						SlenderCreateParticleAttach(iBossIndex, sMilkPlayerParticle, 35.0, iClient);
					}
					else
					{
						SlenderCreateParticle(iBossIndex, sMilkPlayerParticle, 55.0);
					}
					if (g_sSlenderMilkHitSound[iBossIndex][0] != '\0') //No sound, what?
						EmitSoundToAll(g_sSlenderMilkHitSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
					TF2_AddCondition(iClient, TFCond_Milked, NPCChaserGetMilkDuration(iBossIndex, iDifficulty));
					break;
				}
			}
		}
		else //Legacy support
		{
			char sNumber = sCurrentIndex[0];
			int iAttackNumber = 0;
			if (FindCharInString(sIndexes, sNumber) != -1)
			{
				iAttackNumber += iAttackIndex + 1;
			}
			if (sIndexes[0] != '\0' && sCurrentIndex[0] != '\0' && iAttackNumber != -1)
			{
				int iCurrentAtkIndex = StringToInt(sCurrentIndex);
				if (iAttackNumber == iCurrentAtkIndex && NPCChaserGetMilkDuration(iBossIndex, iDifficulty) > 0.0)
				{
					GetProfileString(sProfile, "player_milk_particle", sMilkPlayerParticle, sizeof(sMilkPlayerParticle));
					if (sMilkPlayerParticle[0] == '\0')
					{
						sMilkPlayerParticle = MILK_PARTICLE;
					}
					if (NPCChaserAttachDamageParticle(iBossIndex))
					{
						SlenderCreateParticleAttach(iBossIndex, sMilkPlayerParticle, 35.0, iClient);
					}
					else
					{
						SlenderCreateParticle(iBossIndex, sMilkPlayerParticle, 55.0);
					}
					if (g_sSlenderMilkHitSound[iBossIndex][0] != '\0') //No sound, what?
						EmitSoundToAll(g_sSlenderMilkHitSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
					TF2_AddCondition(iClient, TFCond_Milked, NPCChaserGetMilkDuration(iBossIndex, iDifficulty));
				}
			}
		}
	}
	if (NPCChaserGasPlayerOnHit(iBossIndex))
	{
		char sIndexes[8], sAllowedIndexes[88], sAllowedIndexesList[33][3];
		char sCurrentIndex[2];
		int iDamageIndexes = NPCChaserGetGasAttackIndexes(iBossIndex);
		GetProfileString(sProfile, "player_gas_attack_indexs", sAllowedIndexes, sizeof(sAllowedIndexes), "1");
		FormatEx(sIndexes, sizeof(sIndexes), "%d", iDamageIndexes);
		FormatEx(sCurrentIndex, sizeof(sCurrentIndex), "%d", iAttackIndex + 1);

		int iCount = ExplodeString(sAllowedIndexes, " ", sAllowedIndexesList, 33, 3);
		if (iCount > 1)
		{
			for (int iIndex = 0; iIndex < iCount && iIndex < NPCChaserGetAttackCount(iBossIndex); iIndex++)
			{
				int iForIndex = StringToInt(sAllowedIndexesList[iIndex]);
				if (iForIndex == iAttackIndex + 1 && NPCChaserGetGasDuration(iBossIndex, iDifficulty) > 0.0)
				{
					GetProfileString(sProfile, "player_gas_particle", sGasPlayerParticle, sizeof(sGasPlayerParticle));
					if (sGasPlayerParticle[0] == '\0')
					{
						sGasPlayerParticle = GAS_PARTICLE;
					}
					if (NPCChaserAttachDamageParticle(iBossIndex))
					{
						SlenderCreateParticleAttach(iBossIndex, sGasPlayerParticle, 35.0, iClient);
					}
					else
					{
						SlenderCreateParticle(iBossIndex, sGasPlayerParticle, 55.0);
					}
					if (g_sSlenderGasHitSound[iBossIndex][0] != '\0') //No sound, what?
						EmitSoundToAll(g_sSlenderGasHitSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
					TF2_AddCondition(iClient, TFCond_Gas, NPCChaserGetGasDuration(iBossIndex, iDifficulty));
					break;
				}
			}
		}
		else //Legacy support
		{
			char sNumber = sCurrentIndex[0];
			int iAttackNumber = 0;
			if (FindCharInString(sIndexes, sNumber) != -1)
			{
				iAttackNumber += iAttackIndex + 1;
			}
			if (sIndexes[0] != '\0' && sCurrentIndex[0] != '\0' && iAttackNumber != -1)
			{
				int iCurrentAtkIndex = StringToInt(sCurrentIndex);
				if (iAttackNumber == iCurrentAtkIndex && NPCChaserGetGasDuration(iBossIndex, iDifficulty) > 0.0)
				{
					GetProfileString(sProfile, "player_gas_particle", sGasPlayerParticle, sizeof(sGasPlayerParticle));
					if (sGasPlayerParticle[0] == '\0')
					{
						sGasPlayerParticle = GAS_PARTICLE;
					}
					if (NPCChaserAttachDamageParticle(iBossIndex))
					{
						SlenderCreateParticleAttach(iBossIndex, sGasPlayerParticle, 35.0, iClient);
					}
					else
					{
						SlenderCreateParticle(iBossIndex, sGasPlayerParticle, 55.0);
					}
					if (g_sSlenderGasHitSound[iBossIndex][0] != '\0') //No sound, what?
						EmitSoundToAll(g_sSlenderGasHitSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
					TF2_AddCondition(iClient, TFCond_Gas, NPCChaserGetGasDuration(iBossIndex, iDifficulty));
				}
			}
		}
	}
	if (NPCChaserMarkPlayerOnHit(iBossIndex))
	{
		char sIndexes[8], sAllowedIndexes[88], sAllowedIndexesList[33][3];
		char sCurrentIndex[2];
		int iDamageIndexes = NPCChaserGetMarkAttackIndexes(iBossIndex);
		GetProfileString(sProfile, "player_mark_attack_indexs", sAllowedIndexes, sizeof(sAllowedIndexes), "1");
		FormatEx(sIndexes, sizeof(sIndexes), "%d", iDamageIndexes);
		FormatEx(sCurrentIndex, sizeof(sCurrentIndex), "%d", iAttackIndex + 1);

		int iCount = ExplodeString(sAllowedIndexes, " ", sAllowedIndexesList, 33, 3);
		if (iCount > 1)
		{
			for (int iIndex = 0; iIndex < iCount && iIndex < NPCChaserGetAttackCount(iBossIndex); iIndex++)
			{
				int iForIndex = StringToInt(sAllowedIndexesList[iIndex]);
				if (iForIndex == iAttackIndex + 1 && NPCChaserGetMarkDuration(iBossIndex, iDifficulty) > 0.0)
				{
					TF2_AddCondition(iClient, TFCond_MarkedForDeath, NPCChaserGetMarkDuration(iBossIndex, iDifficulty));
					break;
				}
			}
		}
		else //Legacy support
		{
			char sNumber = sCurrentIndex[0];
			int iAttackNumber = 0;
			if (FindCharInString(sIndexes, sNumber) != -1)
			{
				iAttackNumber += iAttackIndex + 1;
			}
			if (sIndexes[0] != '\0' && sCurrentIndex[0] != '\0' && iAttackNumber != -1)
			{
				int iCurrentAtkIndex = StringToInt(sCurrentIndex);
				if (iAttackNumber == iCurrentAtkIndex && NPCChaserGetMarkDuration(iBossIndex, iDifficulty))
				{
					TF2_AddCondition(iClient, TFCond_MarkedForDeath, NPCChaserGetMarkDuration(iBossIndex, iDifficulty));
				}
			}
		}
	}
	if (NPCChaserSilentMarkPlayerOnHit(iBossIndex))
	{
		char sIndexes[8], sAllowedIndexes[88], sAllowedIndexesList[33][3];
		char sCurrentIndex[2];
		int iDamageIndexes = NPCChaserGetSilentMarkAttackIndexes(iBossIndex);
		GetProfileString(sProfile, "player_silent_mark_attack_indexs", sAllowedIndexes, sizeof(sAllowedIndexes), "1");
		FormatEx(sIndexes, sizeof(sIndexes), "%d", iDamageIndexes);
		FormatEx(sCurrentIndex, sizeof(sCurrentIndex), "%d", iAttackIndex + 1);

		int iCount = ExplodeString(sAllowedIndexes, " ", sAllowedIndexesList, 33, 3);
		if (iCount > 1)
		{
			for (int iIndex = 0; iIndex < iCount && iIndex < NPCChaserGetAttackCount(iBossIndex); iIndex++)
			{
				int iForIndex = StringToInt(sAllowedIndexesList[iIndex]);
				if (iForIndex == iAttackIndex + 1 && NPCChaserGetSilentMarkDuration(iBossIndex, iDifficulty) > 0.0)
				{
					TF2_AddCondition(iClient, TFCond_MarkedForDeathSilent, NPCChaserGetSilentMarkDuration(iBossIndex, iDifficulty));
					break;
				}
			}
		}
		else //Legacy support
		{
			char sNumber = sCurrentIndex[0];
			int iAttackNumber = 0;
			if (FindCharInString(sIndexes, sNumber) != -1)
			{
				iAttackNumber += iAttackIndex + 1;
			}
			if (sIndexes[0] != '\0' && sCurrentIndex[0] != '\0' && iAttackNumber != -1)
			{
				int iCurrentAtkIndex = StringToInt(sCurrentIndex);
				if (iAttackNumber == iCurrentAtkIndex && NPCChaserGetSilentMarkDuration(iBossIndex, iDifficulty))
				{
					TF2_AddCondition(iClient, TFCond_MarkedForDeathSilent, NPCChaserGetSilentMarkDuration(iBossIndex, iDifficulty));
				}
			}
		}
	}
	if (NPCChaserIgnitePlayerOnHit(iBossIndex))
	{
		char sIndexes[8], sAllowedIndexes[88], sAllowedIndexesList[33][3];
		char sCurrentIndex[2];
		int iDamageIndexes = NPCChaserGetIgniteAttackIndexes(iBossIndex);
		GetProfileString(sProfile, "player_ignite_attack_indexs", sAllowedIndexes, sizeof(sAllowedIndexes), "1");
		FormatEx(sIndexes, sizeof(sIndexes), "%d", iDamageIndexes);
		FormatEx(sCurrentIndex, sizeof(sCurrentIndex), "%d", iAttackIndex + 1);

		int iCount = ExplodeString(sAllowedIndexes, " ", sAllowedIndexesList, 33, 3);
		if (iCount > 1)
		{
			for (int iIndex = 0; iIndex < iCount && iIndex < NPCChaserGetAttackCount(iBossIndex); iIndex++)
			{
				int iForIndex = StringToInt(sAllowedIndexesList[iIndex]);
				if (iForIndex == iAttackIndex + 1 && NPCChaserGetIgniteDelay(iBossIndex, iDifficulty) && g_hPlayerIgniteTimer[iClient] == null)
				{
					g_hPlayerIgniteTimer[iClient] = CreateTimer(NPCChaserGetIgniteDelay(iBossIndex, iDifficulty), Timer_SlenderChaseBossAttackIgniteHit, EntIndexToEntRef(iClient), TIMER_FLAG_NO_MAPCHANGE);
					g_hPlayerResetIgnite[iClient] = null;
					break;
				}
			}
		}
		else //Legacy support
		{
			char sNumber = sCurrentIndex[0];
			int iAttackNumber = 0;
			if (FindCharInString(sIndexes, sNumber) != -1)
			{
				iAttackNumber += iAttackIndex + 1;
			}
			if (sIndexes[0] != '\0' && sCurrentIndex[0] != '\0' && iAttackNumber != -1)
			{
				int iCurrentAtkIndex = StringToInt(sCurrentIndex);
				if (iAttackNumber == iCurrentAtkIndex && NPCChaserGetIgniteDelay(iBossIndex, iDifficulty) && g_hPlayerIgniteTimer[iClient] == null)
				{
					g_hPlayerIgniteTimer[iClient] = CreateTimer(NPCChaserGetIgniteDelay(iBossIndex, iDifficulty), Timer_SlenderChaseBossAttackIgniteHit, EntIndexToEntRef(iClient), TIMER_FLAG_NO_MAPCHANGE);
					g_hPlayerResetIgnite[iClient] = null;
				}
			}
		}
	}
	if (NPCChaserStunPlayerOnHit(iBossIndex))
	{
		char sIndexes[8], sAllowedIndexes[88], sAllowedIndexesList[33][3];
		char sCurrentIndex[2];
		int iDamageIndexes = NPCChaserGetStunAttackIndexes(iBossIndex);
		FormatEx(sIndexes, sizeof(sIndexes), "%d", iDamageIndexes);
		FormatEx(sCurrentIndex, sizeof(sCurrentIndex), "%d", iAttackIndex + 1);
		GetProfileString(sProfile, "player_stun_attack_indexs", sAllowedIndexes, sizeof(sAllowedIndexes), "1");

		int iCount = ExplodeString(sAllowedIndexes, " ", sAllowedIndexesList, 33, 3);
		if (iCount > 1)
		{
			for (int iIndex = 0; iIndex < iCount && iIndex < NPCChaserGetAttackCount(iBossIndex); iIndex++)
			{
				int iForIndex = StringToInt(sAllowedIndexesList[iIndex]);
				if (iForIndex == iAttackIndex + 1 && NPCChaserGetStunAttackDuration(iBossIndex, iDifficulty))
				{
					GetProfileString(sProfile, "player_stun_particle", sStunPlayerParticle, sizeof(sStunPlayerParticle));
					if (sStunPlayerParticle[0] == '\0')
					{
						sStunPlayerParticle = STUN_PARTICLE;
					}
					if (NPCChaserGetStunAttackType(iBossIndex) != 4)
					{
						if (NPCChaserAttachDamageParticle(iBossIndex))
						{
							SlenderCreateParticleAttach(iBossIndex, sStunPlayerParticle, 35.0, iClient);
						}
						else
						{
							SlenderCreateParticle(iBossIndex, sStunPlayerParticle, 55.0);
						}
					}
					if (g_sSlenderStunHitSound[iBossIndex][0] != '\0' && NPCChaserGetStunAttackType(iBossIndex) != 4) //No sound, what?
						EmitSoundToAll(g_sSlenderStunHitSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
					switch (NPCChaserGetStunAttackType(iBossIndex))
					{
						case 1: TF2_StunPlayer(iClient, NPCChaserGetStunAttackDuration(iBossIndex, iDifficulty), NPCChaserGetStunAttackSlowdown(iBossIndex, iDifficulty), TF_STUNFLAG_SLOWDOWN);
						case 2: TF2_StunPlayer(iClient, NPCChaserGetStunAttackDuration(iBossIndex, iDifficulty), NPCChaserGetStunAttackSlowdown(iBossIndex, iDifficulty), TF_STUNFLAGS_LOSERSTATE);
						case 3: TF2_StunPlayer(iClient, NPCChaserGetStunAttackDuration(iBossIndex, iDifficulty), NPCChaserGetStunAttackSlowdown(iBossIndex, iDifficulty), TF_STUNFLAG_BONKSTUCK|TF_STUNFLAG_NOSOUNDOREFFECT);
						case 4: TF2_StunPlayer(iClient, NPCChaserGetStunAttackDuration(iBossIndex, iDifficulty), NPCChaserGetStunAttackSlowdown(iBossIndex, iDifficulty), TF_STUNFLAGS_GHOSTSCARE);
					}
					break;
				}
			}
		}
		else //Legacy support
		{
			char sNumber = sCurrentIndex[0];
			int iAttackNumber = 0;
			if (FindCharInString(sIndexes, sNumber) != -1)
			{
				iAttackNumber += iAttackIndex + 1;
			}
			if (sIndexes[0] != '\0' && sCurrentIndex[0] != '\0' && iAttackNumber != -1)
			{
				int iCurrentAtkIndex = StringToInt(sCurrentIndex);
				if (iAttackNumber == iCurrentAtkIndex && NPCChaserGetStunAttackDuration(iBossIndex, iDifficulty) > 0.0)
				{
					GetProfileString(sProfile, "player_stun_particle", sStunPlayerParticle, sizeof(sStunPlayerParticle));
					if (sStunPlayerParticle[0] == '\0')
					{
						sStunPlayerParticle = STUN_PARTICLE;
					}
					if (NPCChaserGetStunAttackType(iBossIndex) != 4)
					{
						if (NPCChaserAttachDamageParticle(iBossIndex))
						{
							SlenderCreateParticleAttach(iBossIndex, sStunPlayerParticle, 35.0, iClient);
						}
						else
						{
							SlenderCreateParticle(iBossIndex, sStunPlayerParticle, 55.0);
						}
					}
					if (g_sSlenderStunHitSound[iBossIndex][0] != '\0' && NPCChaserGetStunAttackType(iBossIndex) != 4) //No sound, what?
						EmitSoundToAll(g_sSlenderStunHitSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
					switch (NPCChaserGetStunAttackType(iBossIndex))
					{
						case 1: TF2_StunPlayer(iClient, NPCChaserGetStunAttackDuration(iBossIndex, iDifficulty), NPCChaserGetStunAttackSlowdown(iBossIndex, iDifficulty), TF_STUNFLAG_SLOWDOWN);
						case 2: TF2_StunPlayer(iClient, NPCChaserGetStunAttackDuration(iBossIndex, iDifficulty), NPCChaserGetStunAttackSlowdown(iBossIndex, iDifficulty), TF_STUNFLAGS_LOSERSTATE);
						case 3: TF2_StunPlayer(iClient, NPCChaserGetStunAttackDuration(iBossIndex, iDifficulty), NPCChaserGetStunAttackSlowdown(iBossIndex, iDifficulty), TF_STUNFLAG_BONKSTUCK|TF_STUNFLAG_NOSOUNDOREFFECT);
						case 4: TF2_StunPlayer(iClient, NPCChaserGetStunAttackDuration(iBossIndex, iDifficulty), NPCChaserGetStunAttackSlowdown(iBossIndex, iDifficulty), TF_STUNFLAGS_GHOSTSCARE);
					}
				}
			}
		}
	}
	if (NPCChaserBleedPlayerOnHit(iBossIndex))
	{
		char sIndexes[8], sAllowedIndexes[88], sAllowedIndexesList[33][3];
		char sCurrentIndex[2];
		int iDamageIndexes = NPCChaserGetBleedAttackIndexes(iBossIndex);
		FormatEx(sIndexes, sizeof(sIndexes), "%d", iDamageIndexes);
		FormatEx(sCurrentIndex, sizeof(sCurrentIndex), "%d", iAttackIndex + 1);
		GetProfileString(sProfile, "player_bleed_attack_indexs", sAllowedIndexes, sizeof(sAllowedIndexes), "1");

		int iCount = ExplodeString(sAllowedIndexes, " ", sAllowedIndexesList, 33, 3);
		if (iCount > 1)
		{
			for (int iIndex = 0; iIndex < iCount && iIndex < NPCChaserGetAttackCount(iBossIndex); iIndex++)
			{
				int iForIndex = StringToInt(sAllowedIndexesList[iIndex]);
				if (iForIndex == iAttackIndex + 1 && NPCChaserGetBleedDuration(iBossIndex, iDifficulty))
				{
					if (!TF2_IsPlayerInCondition(iClient, TFCond_Bleeding))
					{
						TF2_MakeBleed(iClient, iClient, NPCChaserGetBleedDuration(iBossIndex, iDifficulty));
						break;
					}
				}
			}
		}
		else //Legacy support
		{
			char sNumber = sCurrentIndex[0];
			int iAttackNumber = 0;
			if (FindCharInString(sIndexes, sNumber) != -1)
			{
				iAttackNumber += iAttackIndex + 1;
			}
			if (sIndexes[0] != '\0' && sCurrentIndex[0] != '\0' && iAttackNumber != -1)
			{
				int iCurrentAtkIndex = StringToInt(sCurrentIndex);
				if (iAttackNumber == iCurrentAtkIndex && NPCChaserGetBleedDuration(iBossIndex, iDifficulty) > 0.0)
				{
					if (!TF2_IsPlayerInCondition(iClient, TFCond_Bleeding))
					{
						TF2_MakeBleed(iClient, iClient, NPCChaserGetBleedDuration(iBossIndex, iDifficulty));
					}
				}
			}
		}
	}
	if (NPCChaserElectricPlayerOnHit(iBossIndex))
	{
		char sIndexes[8], sAllowedIndexes[88], sAllowedIndexesList[33][3];
		char sCurrentIndex[2];
		int iDamageIndexes = NPCChaserGetElectricAttackIndexes(iBossIndex);
		FormatEx(sIndexes, sizeof(sIndexes), "%d", iDamageIndexes);
		FormatEx(sCurrentIndex, sizeof(sCurrentIndex), "%d", iAttackIndex + 1);
		GetProfileString(sProfile, "player_electrocute_attack_indexs", sAllowedIndexes, sizeof(sAllowedIndexes), "1");

		int iCount = ExplodeString(sAllowedIndexes, " ", sAllowedIndexesList, 33, 3);
		if (iCount > 1)
		{
			for (int iIndex = 0; iIndex < iCount && iIndex < NPCChaserGetAttackCount(iBossIndex); iIndex++)
			{
				int iForIndex = StringToInt(sAllowedIndexesList[iIndex]);
				if (iForIndex == iAttackIndex + 1 && NPCChaserGetElectricDuration(iBossIndex, iDifficulty))
				{
					GetProfileString(sProfile, "player_electric_red_particle", sElectricPlayerParticleRed, sizeof(sElectricPlayerParticleRed));
					GetProfileString(sProfile, "player_electric_blue_particle", sElectricPlayerParticleBlue, sizeof(sElectricPlayerParticleBlue));
					if (sElectricPlayerParticleRed[0] == '\0')
					{
						sElectricPlayerParticleRed = ELECTRIC_RED_PARTICLE;
					}
					if (sElectricPlayerParticleBlue[0] == '\0')
					{
						sElectricPlayerParticleBlue = ELECTRIC_BLUE_PARTICLE;
					}
					if (NPCChaserAttachDamageParticle(iBossIndex))
					{
						if (GetClientTeam(iClient) == TFTeam_Red)
						{
							SlenderCreateParticleAttach(iBossIndex, sElectricPlayerParticleRed, 35.0, iClient);
						}
						else if (GetClientTeam(iClient) == TFTeam_Blue)
						{
							SlenderCreateParticleAttach(iBossIndex, sElectricPlayerParticleBlue, 35.0, iClient);
						}
					}
					else
					{
						if (GetClientTeam(iClient) == TFTeam_Red)
						{
							SlenderCreateParticle(iBossIndex, sElectricPlayerParticleRed, 55.0);
						}
						else if (GetClientTeam(iClient) == TFTeam_Blue)
						{
							SlenderCreateParticle(iBossIndex, sElectricPlayerParticleBlue, 55.0);
						}
					}
					switch (NPCChaserGetStunAttackType(iBossIndex))
					{
						case 1: TF2_StunPlayer(iClient, NPCChaserGetElectricDuration(iBossIndex, iDifficulty), NPCChaserGetElectricSlowdown(iBossIndex, iDifficulty), TF_STUNFLAG_SLOWDOWN);
						case 2: TF2_StunPlayer(iClient, NPCChaserGetElectricDuration(iBossIndex, iDifficulty), NPCChaserGetElectricSlowdown(iBossIndex, iDifficulty), TF_STUNFLAGS_LOSERSTATE);
						case 3, 4: TF2_StunPlayer(iClient, NPCChaserGetElectricDuration(iBossIndex, iDifficulty), NPCChaserGetElectricSlowdown(iBossIndex, iDifficulty), TF_STUNFLAG_BONKSTUCK|TF_STUNFLAG_NOSOUNDOREFFECT);
					}
					break;
				}
			}
		}
		else //Legacy support
		{
			char sNumber = sCurrentIndex[0];
			int iAttackNumber = 0;
			if (FindCharInString(sIndexes, sNumber) != -1)
			{
				iAttackNumber += iAttackIndex + 1;
			}
			if (sIndexes[0] != '\0' && sCurrentIndex[0] != '\0' && iAttackNumber != -1)
			{
				int iCurrentAtkIndex = StringToInt(sCurrentIndex);
				if (iAttackNumber == iCurrentAtkIndex && NPCChaserGetElectricDuration(iBossIndex, iDifficulty) > 0.0)
				{
					GetProfileString(sProfile, "player_electric_red_particle", sElectricPlayerParticleRed, sizeof(sElectricPlayerParticleRed));
					GetProfileString(sProfile, "player_electric_blue_particle", sElectricPlayerParticleBlue, sizeof(sElectricPlayerParticleBlue));
					if (sElectricPlayerParticleRed[0] == '\0')
					{
						sElectricPlayerParticleRed = ELECTRIC_RED_PARTICLE;
					}
					if (sElectricPlayerParticleBlue[0] == '\0')
					{
						sElectricPlayerParticleBlue = ELECTRIC_BLUE_PARTICLE;
					}
					if (NPCChaserAttachDamageParticle(iBossIndex))
					{
						if (GetClientTeam(iClient) == TFTeam_Red)
						{
							SlenderCreateParticleAttach(iBossIndex, sElectricPlayerParticleRed, 35.0, iClient);
						}
						else if (GetClientTeam(iClient) == TFTeam_Blue)
						{
							SlenderCreateParticleAttach(iBossIndex, sElectricPlayerParticleBlue, 35.0, iClient);
						}
					}
					else
					{
						if (GetClientTeam(iClient) == TFTeam_Red)
						{
							SlenderCreateParticle(iBossIndex, sElectricPlayerParticleRed, 55.0);
						}
						else if (GetClientTeam(iClient) == TFTeam_Blue)
						{
							SlenderCreateParticle(iBossIndex, sElectricPlayerParticleBlue, 55.0);
						}
					}
					switch (NPCChaserGetStunAttackType(iBossIndex))
					{
						case 1: TF2_StunPlayer(iClient, NPCChaserGetElectricDuration(iBossIndex, iDifficulty), NPCChaserGetElectricSlowdown(iBossIndex, iDifficulty), TF_STUNFLAG_SLOWDOWN);
						case 2: TF2_StunPlayer(iClient, NPCChaserGetElectricDuration(iBossIndex, iDifficulty), NPCChaserGetElectricSlowdown(iBossIndex, iDifficulty), TF_STUNFLAGS_LOSERSTATE);
						case 3, 4: TF2_StunPlayer(iClient, NPCChaserGetElectricDuration(iBossIndex, iDifficulty), NPCChaserGetElectricSlowdown(iBossIndex, iDifficulty), TF_STUNFLAG_BONKSTUCK|TF_STUNFLAG_NOSOUNDOREFFECT);
					}
				}
			}
		}
	}
	if (NPCChaserSmitePlayerOnHit(iBossIndex))
	{
		char sIndexes[8], sAllowedIndexes[88], sAllowedIndexesList[33][3];
		char sCurrentIndex[2];
		int iDamageIndexes = NPCChaserGetSmiteAttackIndexes(iBossIndex);
		FormatEx(sIndexes, sizeof(sIndexes), "%d", iDamageIndexes);
		FormatEx(sCurrentIndex, sizeof(sCurrentIndex), "%d", iAttackIndex + 1);
		GetProfileString(sProfile, "player_smite_attack_indexs", sAllowedIndexes, sizeof(sAllowedIndexes), "1");

		int iCount = ExplodeString(sAllowedIndexes, " ", sAllowedIndexesList, 33, 3);
		if (iCount > 1)
		{
			for (int iIndex = 0; iIndex < iCount && iIndex < NPCChaserGetAttackCount(iBossIndex); iIndex++)
			{
				int iForIndex = StringToInt(sAllowedIndexesList[iIndex]);
				if (iForIndex == iAttackIndex + 1)
				{
					PerformSmiteBoss(iBossIndex, iClient, EntIndexToEntRef(slender));
					SDKHooks_TakeDamage(iClient, slender, slender, NPCChaserGetSmiteDamage(iBossIndex), NPCChaserGetSmiteDamageType(iBossIndex), _, view_as<float>( { 0.0, 0.0, 0.0 } ), flMyEyePos);
					ClientViewPunch(iClient, view_as<float>( { 0.0, 0.0, 0.0 } ));
					if (NPCChaserSmitePlayerMessage(iBossIndex))
					{
						char sPlayer[32];
						FormatEx(sPlayer, sizeof(sPlayer), "%N", iClient);
						
						char sName[SF2_MAX_NAME_LENGTH];
						NPCGetBossName(iBossIndex, sName, sizeof(sName));
						if (sName[0] == '\0') strcopy(sName, sizeof(sName), sProfile);
						if (GetClientTeam(iClient) == 2) CPrintToChatAll("{royalblue}%t{default}%t", "SF2 Prefix", "SF2 Smote target", sName, sPlayer);
					}
					break;
				}
			}
		}
		else //Legacy support
		{
			char sNumber = sCurrentIndex[0];
			int iAttackNumber = 0;
			if (FindCharInString(sIndexes, sNumber) != -1)
			{
				iAttackNumber += iAttackIndex + 1;
			}
			if (sIndexes[0] != '\0' && sCurrentIndex[0] != '\0' && iAttackNumber != -1)
			{
				int iCurrentAtkIndex = StringToInt(sCurrentIndex);
				if (iAttackNumber == iCurrentAtkIndex)
				{
					PerformSmiteBoss(iBossIndex, iClient, EntIndexToEntRef(slender));
					SDKHooks_TakeDamage(iClient, slender, slender, NPCChaserGetSmiteDamage(iBossIndex), NPCChaserGetSmiteDamageType(iBossIndex), _, view_as<float>( { 0.0, 0.0, 0.0 } ), flMyEyePos);
					ClientViewPunch(iClient, view_as<float>( { 0.0, 0.0, 0.0 } ));
					if (NPCChaserSmitePlayerMessage(iBossIndex))
					{
						char sPlayer[32];
						FormatEx(sPlayer, sizeof(sPlayer), "%N", iClient);
						
						char sName[SF2_MAX_NAME_LENGTH];
						NPCGetBossName(iBossIndex, sName, sizeof(sName));
						if (sName[0] == '\0') strcopy(sName, sizeof(sName), sProfile);
						if (GetClientTeam(iClient) == 2) CPrintToChatAll("{royalblue}%t{default}%t", "SF2 Prefix", "SF2 Smote target", sName, sPlayer);
					}
				}
			}
		}
	}
}

static bool NPCPropPhysicsAttack(int iBossIndex, int prop)
{
	char buffer[PLATFORM_MAX_PATH], sProfile[SF2_MAX_PROFILE_NAME_LENGTH], model[SF2_MAX_PROFILE_NAME_LENGTH], key[64];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	g_hConfig.Rewind();
	g_hConfig.JumpToKey(sProfile);
	if (!IsValidEntity(prop))return false;
	GetEntPropString(prop, Prop_Data, "m_ModelName", model, sizeof(model));
	if (!g_hConfig.JumpToKey("attack_props_physics_models"))return true;
	bool bFound = false;
	for (int i = 1; ; i++)
	{
		FormatEx(key, sizeof(key), "%d", i);
		g_hConfig.GetString(key, buffer, PLATFORM_MAX_PATH);
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
stock void NPC_DropKey(int iBossIndex)
{
	char buffer[PLATFORM_MAX_PATH], sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	g_hConfig.Rewind();
	g_hConfig.JumpToKey(sProfile);
	g_hConfig.GetString("key_trigger", buffer, PLATFORM_MAX_PATH);
	if (buffer[0] != '\0')
	{
		float flMyPos[3], flVel[3];
		int iBoss = NPCGetEntIndex(iBossIndex);
		GetEntPropVector(iBoss, Prop_Data, "m_vecAbsOrigin", flMyPos);
		Format(buffer, PLATFORM_MAX_PATH, "sf2_key_%s", buffer);
		
		int TouchBox = CreateEntityByName("tf_halloween_pickup");
		//To do: allow the cfg maker to change the model.
		DispatchKeyValue(TouchBox, "targetname", buffer);
		//New Key model
		GetProfileString(sProfile, "key_model", sKeyModel, sizeof(sKeyModel));
		if (sKeyModel[0] == '\0')
		{
			DispatchKeyValue(TouchBox, "powerup_model", SF_KEYMODEL);
		}
		else
		{
			DispatchKeyValue(TouchBox, "powerup_model", sKeyModel);
		}
		DispatchKeyValue(TouchBox, "modelscale", "2.0");
		DispatchKeyValue(TouchBox, "pickup_sound", "ui/itemcrate_smash_ultrarare_short.wav");
		DispatchKeyValue(TouchBox, "pickup_particle", "utaunt_firework_teamcolor_red");
		DispatchKeyValue(TouchBox, "TeamNum", "0");
		TeleportEntity(TouchBox, flMyPos, NULL_VECTOR, NULL_VECTOR);
		if (sKeyModel[0] == '\0')
		{
			SetEntityModel(TouchBox, SF_KEYMODEL);
		}
		else
		{
			SetEntityModel(TouchBox, sKeyModel);
		}
		SetEntProp(TouchBox, Prop_Data, "m_iEFlags", 12845056);
		DispatchSpawn(TouchBox);
		ActivateEntity(TouchBox);
		if (sKeyModel[0] == '\0')
		{
			SetEntityModel(TouchBox, SF_KEYMODEL);
		}
		else
		{
			SetEntityModel(TouchBox, sKeyModel);
		}
		
		int Key = CreateEntityByName("tf_halloween_pickup");
		//To do: allow the cfg maker to change the model.
		DispatchKeyValue(Key, "targetname", buffer);
		DispatchKeyValue(Key, "powerup_model", PAGE_MODEL);
		DispatchKeyValue(Key, "modelscale", "2.0");
		DispatchKeyValue(Key, "pickup_sound", "ui/itemcrate_smash_ultrarare_short.wav");
		DispatchKeyValue(Key, "pickup_particle", "utaunt_firework_teamcolor_red");
		DispatchKeyValue(Key, "TeamNum", "0");
		TeleportEntity(Key, flMyPos, NULL_VECTOR, NULL_VECTOR);
		SetEntityModel(Key, PAGE_MODEL);
		SetEntProp(Key, Prop_Data, "m_iEFlags", 12845056);
		DispatchSpawn(Key);
		ActivateEntity(Key);
		
		SetEntityRenderMode(Key, RENDER_TRANSCOLOR);
		SetEntityRenderColor(Key, 0, 0, 0, 1);
		
		int glow = CreateEntityByName("tf_taunt_prop");
		//To do: allow the cfg maker to change the model.
		DispatchKeyValue(glow, "targetname", buffer);
		if (sKeyModel[0] == '\0')
		{
			DispatchKeyValue(glow, "powerup_model", SF_KEYMODEL);
		}
		else
		{
			DispatchKeyValue(glow, "powerup_model", sKeyModel);
		}
		TeleportEntity(glow, flMyPos, NULL_VECTOR, NULL_VECTOR);
		DispatchSpawn(glow);
		ActivateEntity(glow);
		if (sKeyModel[0] == '\0')
		{
			SetEntityModel(glow, SF_KEYMODEL);
		}
		else
		{
			SetEntityModel(glow, sKeyModel);
		}
		
		SetEntProp(glow, Prop_Send, "m_bGlowEnabled", 1);
		SetEntPropFloat(glow, Prop_Send, "m_flModelScale", 2.0);
		SetEntityRenderMode(glow, RENDER_TRANSCOLOR);
		SetEntityRenderColor(glow, 0, 0, 0, 1);
		
		SetVariantString("!activator");
		AcceptEntityInput(TouchBox, "SetParent", Key);
		
		SetVariantString("!activator");
		AcceptEntityInput(glow, "SetParent", Key);
		
		SetEntityModel(Key, PAGE_MODEL);
		SetEntityMoveType(Key, MOVETYPE_FLYGRAVITY);
		
		HookSingleEntityOutput(TouchBox, "OnRedPickup", KeyTrigger);
		
		flVel[0] = GetRandomFloat(-300.0, 300.0);
		flVel[1] = GetRandomFloat(-300.0, 300.0);
		flVel[2] = GetRandomFloat(700.0, 900.0);
		
		SetEntProp(Key, Prop_Data, "m_iEFlags", 12845056);
		
		TeleportEntity(Key, flMyPos, NULL_VECTOR, flVel);
		SetEntPropFloat(Key, Prop_Send, "m_flModelScale", 2.0);
		SetEntProp(Key, Prop_Data, "m_iEFlags", 12845056);
		SetEntProp(Key, Prop_Data, "m_MoveCollide", 1);
		
		SDKHook(Key, SDKHook_SetTransmit, Hook_KeySetTransmit);
		SDKHook(glow, SDKHook_SetTransmit, Hook_KeySetTransmit);
		SDKHook(TouchBox, SDKHook_SetTransmit, Hook_KeySetTransmit);
		
		//The key can be stuck somewhere to prevent that, make an auto collect.
		float flTimeLeft = float(g_iRoundTime);
		if (flTimeLeft > 60.0)
			flTimeLeft = 30.0;
		else
			flTimeLeft = flTimeLeft - 20.0;
		CreateTimer(flTimeLeft, CollectKey, EntIndexToEntRef(TouchBox), TIMER_FLAG_NO_MAPCHANGE);
	}
}
public void KeyTrigger(const char[] output, int caller, int activator, float delay)
{
	TriggerKey(caller);
}

public Action Hook_KeySetTransmit(int entity, int iOther)
{
	if (!IsValidClient(iOther))return Plugin_Continue;
	
	if (g_bPlayerEliminated[iOther] && IsClientInGhostMode(iOther))return Plugin_Continue;
	
	if (!g_bPlayerEliminated[iOther])return Plugin_Continue;
	
	return Plugin_Handled;
}

public Action CollectKey(Handle timer, any entref)
{
	int ent = EntRefToEntIndex(entref);
	if (ent == INVALID_ENT_REFERENCE)return Plugin_Stop;
	char sClass[64];
	GetEntityNetClass(ent, sClass, sizeof(sClass));
	if (strcmp(sClass, "CHalloweenPickup") != 0)return Plugin_Stop;
	
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
		char sName[64];
		GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
		if (strcmp(sName, targetName, false) == 0)
		{
			AcceptEntityInput(ent, "KillHierarchy");
		}
	}
	
	ReplaceString(targetName, sizeof(targetName), "sf2_key_", "", false);
	float flMyPos[3];
	GetEntPropVector(caller, Prop_Data, "m_vecAbsOrigin", flMyPos);
	TE_Particle(g_iParticle[FireworksRED], flMyPos, flMyPos);
	TE_SendToAll();
	TE_Particle(g_iParticle[FireworksBLU], flMyPos, flMyPos);
	TE_SendToAll();
	ent = -1;
	while ((ent = FindEntityByClassname(ent, "logic_relay")) != -1)
	{
		char sName[64];
		GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
		if (strcmp(sName, targetName, false) == 0)
		{
			AcceptEntityInput(ent, "Trigger");
		}
	}
	ent = -1;
	while ((ent = FindEntityByClassname(ent, "func_door")) != -1)
	{
		char sName[64];
		GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
		if (strcmp(sName, targetName, false) == 0)
		{
			AcceptEntityInput(ent, "Open");
		}
	}
	ent = -1;
	while ((ent = FindEntityByClassname(ent, "trigger_multiple")) != -1)
	{
		char sName[64];
		GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
		if (strcmp(sName, targetName, false) == 0)
		{
			AcceptEntityInput(ent, "Enable");
		}
	}
	RemoveEntity(caller);
	EmitSoundToAll("ui/itemcrate_smash_ultrarare_short.wav", caller, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
}
stock bool NPC_CanAttackProps(int iBossIndex, float flAttackRange, float flAttackFOV)
{
	int prop = -1;
	while ((prop = FindEntityByClassname(prop, "prop_physics")) > MaxClients)
	{
		if (NPCAttackValidateTarget(iBossIndex, prop, flAttackRange, flAttackFOV, true))
		{
			if (NPCPropPhysicsAttack(iBossIndex, prop))
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
			if (NPCAttackValidateTarget(iBossIndex, prop, flAttackRange, flAttackFOV, true))
			{
				return true;
			}
		}
	}
	prop = -1;
	while ((prop = FindEntityByClassname(prop, "obj_*")) > MaxClients)
	{
		if (NPCAttackValidateTarget(iBossIndex, prop, flAttackRange, flAttackFOV, true))
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
