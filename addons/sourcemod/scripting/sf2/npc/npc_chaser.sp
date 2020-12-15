#if defined _sf2_npc_chaser_included
 #endinput
#endif
#define _sf2_npc_chaser_included

static float g_flNPCStepSize[MAX_BOSSES];

static float g_flNPCWalkSpeed[MAX_BOSSES][Difficulty_Max];
static float g_flNPCAirSpeed[MAX_BOSSES][Difficulty_Max];

static float g_flNPCMaxWalkSpeed[MAX_BOSSES][Difficulty_Max];
static float g_flNPCMaxAirSpeed[MAX_BOSSES][Difficulty_Max];

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

static float g_flNPCAlertGracetime[MAX_BOSSES][Difficulty_Max];
static float g_flNPCAlertDuration[MAX_BOSSES][Difficulty_Max];
static float g_flNPCChaseDuration[MAX_BOSSES][Difficulty_Max];

static bool g_bNPCCloakEnabled[MAX_BOSSES];
static float g_flNPCCloakCooldown[MAX_BOSSES][Difficulty_Max];
static float g_flNPCCloakRange[MAX_BOSSES][Difficulty_Max];

static bool g_bNPCProjectileEnabled[MAX_BOSSES];
static float g_flIceballSlowdownDuration[MAX_BOSSES][Difficulty_Max];
static float g_flIceballSlowdownPercent[MAX_BOSSES][Difficulty_Max];
static float g_flNPCProjectileCooldownMin[MAX_BOSSES][Difficulty_Max];
static float g_flNPCProjectileCooldownMax[MAX_BOSSES][Difficulty_Max];
static float g_flNPCProjectileCooldown[MAX_BOSSES];
static float g_flNPCProjectileSpeed[MAX_BOSSES][Difficulty_Max];
static float g_flNPCProjectileDamage[MAX_BOSSES][Difficulty_Max];
static float g_flNPCProjectileRadius[MAX_BOSSES][Difficulty_Max];
static bool g_bNPCCriticalRockets[MAX_BOSSES];
static bool g_bNPCUseShootGesture[MAX_BOSSES];
static bool g_bNPCUseProjectileAmmo[MAX_BOSSES];
static int g_iNPCProjectileLoadedAmmo[MAX_BOSSES][Difficulty_Max];
static int g_iNPCProjectileAmmo[MAX_BOSSES];
static float g_flNPCProjectileReloadTime[MAX_BOSSES][Difficulty_Max];
static float g_flNPCProjectileTimeToReload[MAX_BOSSES];
static bool g_bNPCUseChargeUpProjectiles[MAX_BOSSES];
static float g_flNPCProjectileChargeUpTime[MAX_BOSSES][Difficulty_Max];
static int g_iNPCProjectileType[MAX_BOSSES];
static bool g_bNPCReloadingProjectiles[MAX_BOSSES];

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
static bool g_bNPCUsesChaseInitialAnimation[MAX_BOSSES] = { false, ... };
static bool g_bNPCUseFireAnimation[MAX_BOSSES] = { false, ... };
static bool g_bNPCUseStartFleeAnimation[MAX_BOSSES] = { false, ... };
static bool g_bNPCUsesHealAnimation[MAX_BOSSES] = { false, ... };
static float g_flNPCTimeUntilChaseAfterInitial[MAX_BOSSES];
static float g_flNPCCurrentAnimationSequencePlaybackRate[MAX_BOSSES] = { 1.0, ... };
static char g_sNPCurrentAnimationSequenceName[MAX_BOSSES][256];
static bool g_bNPCAlreadyAttacked[MAX_BOSSES];
static Handle g_hBossFailSafeTimer[MAX_BOSSES];

static char sCloakParticle[PLATFORM_MAX_PATH];

static char sBaseballModel[PLATFORM_MAX_PATH];
static char sJaratePlayerParticle[PLATFORM_MAX_PATH];
static char sMilkPlayerParticle[PLATFORM_MAX_PATH];
static char sGasPlayerParticle[PLATFORM_MAX_PATH];
static char sStunPlayerParticle[PLATFORM_MAX_PATH];
static char sElectricPlayerParticleRed[PLATFORM_MAX_PATH];
static char sElectricPlayerParticleBlue[PLATFORM_MAX_PATH];
static char sGestureShootAnim[PLATFORM_MAX_PATH];
static char sKeyModel[PLATFORM_MAX_PATH];

static bool g_bNPCStealingLife[MAX_BOSSES];
static Handle g_hNPCLifeStealTimer[MAX_BOSSES];

static bool g_bNPCTrapsEnabled[MAX_BOSSES];
static int g_iNPCTrapType[MAX_BOSSES];
static float g_flNPCNextTrapSpawn[MAX_BOSSES][Difficulty_Max];

//Special thanks to The Gaben
static bool g_bSlenderHasDamageParticleEffect[MAX_BOSSES];
static float g_flSlenderDamageClientSoundVolume[MAX_BOSSES];
static int g_iSlenderDamageClientSoundPitch[MAX_BOSSES];
static char sDamageEffectParticle[PLATFORM_MAX_PATH];
static char sDamageEffectSound[PLATFORM_MAX_PATH];

static bool g_bNPCAutoChaseEnabled[MAX_BOSSES] = { false, ... };
static bool g_bNPCInAutoChase[MAX_BOSSES];

bool g_bNPCChasesEndlessly[MAX_BOSSES] = { false, ... };

static float g_flNPCLaserTimer[MAX_BOSSES];

//KF2 Patriarch's Heal Logic
static bool g_bNPCCanSelfHeal[MAX_BOSSES] = { false, ... };
static bool g_bNPCRunningToHeal[MAX_BOSSES] = { false, ... };
static float g_flNPCFleeHealTimer[MAX_BOSSES];
static bool g_bNPCHealing[MAX_BOSSES] = { false, ... };
static bool g_bNPCSetHealDestination[MAX_BOSSES] = { false, ... };
static float g_flNPCStartSelfHealPercentage[MAX_BOSSES];
static float g_flNPCSelfHealPercentageOne[MAX_BOSSES];
static float g_flNPCSelfHealPercentageTwo[MAX_BOSSES];
static float g_flNPCSelfHealPercentageThree[MAX_BOSSES];
static int g_iNPCSelfHealStage[MAX_BOSSES];
static int g_iNPCHealCount[MAX_BOSSES];

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
	int CurrentAttackRepeat;
	int WeaponAttackIndex;
	bool BaseAttackLifeSteal;
	float BaseAttackLifeStealDuration;
	float BaseAttackProjectileDamage;
	float BaseAttackProjectileSpeed;
	float BaseAttackProjectileRadius;
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
	bool BaseAttackPullIn;
}

static int g_NPCBaseAttacksCount[MAX_BOSSES];
BaseAttackStructure g_NPCBaseAttacks[MAX_BOSSES][SF2_CHASER_BOSS_MAX_ATTACKS][Difficulty_Max];
static int g_iNPCCurrentAttackIndex[MAX_BOSSES];

const SF2NPC_Chaser SF2_INVALID_NPC_CHASER = view_as<SF2NPC_Chaser>(-1);


methodmap SF2NPC_Chaser < SF2NPC_BaseNPC
{
	property float WakeRadius
	{
		public get() { return NPCChaserGetWakeRadius(this.Index); }
	}
	
	property float StepSize
	{
		public get() { return NPCChaserGetStepSize(this.Index); }
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
		return NPCChaserGetTeleporter(this.Index,iTeleporterNumber);
	}
	
	public void SetTeleporter(int iTeleporterNumber,int iEntity)
	{
		NPCChaserSetTeleporter(this.Index,iTeleporterNumber,iEntity);
	}
	
	public float GetWalkSpeed(int difficulty)
	{
		return NPCChaserGetWalkSpeed(this.Index, difficulty);
	}

	public float GetAirSpeed(int difficulty)
	{
		return NPCChaserGetAirSpeed(this.Index, difficulty);
	}

	public float GetMaxWalkSpeed(int difficulty)
	{
		return NPCChaserGetMaxWalkSpeed(this.Index, difficulty);
	}

	public float GetMaxAirSpeed(int difficulty)
	{
		return NPCChaserGetMaxAirSpeed(this.Index, difficulty);
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
	g_bNPCUseFireAnimation[iNPCIndex] = false;
	g_bNPCUsesHealAnimation[iNPCIndex] = false;
	g_bNPCUseStartFleeAnimation[iNPCIndex] = false;
	g_bNPCUsesRageAnimation1[iNPCIndex] = false;
	g_bNPCUsesRageAnimation2[iNPCIndex] = false;
	g_bNPCUsesRageAnimation3[iNPCIndex] = false;
}

float NPCChaserGetWalkSpeed(int iNPCIndex,int iDifficulty)
{
	return g_flNPCWalkSpeed[iNPCIndex][iDifficulty];
}

float NPCChaserGetAirSpeed(int iNPCIndex,int iDifficulty)
{
	return g_flNPCAirSpeed[iNPCIndex][iDifficulty];
}

float NPCChaserGetMaxWalkSpeed(int iNPCIndex,int iDifficulty)
{
	return g_flNPCMaxWalkSpeed[iNPCIndex][iDifficulty];
}

float NPCChaserGetMaxAirSpeed(int iNPCIndex,int iDifficulty)
{
	return g_flNPCMaxAirSpeed[iNPCIndex][iDifficulty];
}

float NPCChaserGetWakeRadius(int iNPCIndex)
{
	return g_flNPCWakeRadius[iNPCIndex];
}

float NPCChaserGetStepSize(int iNPCIndex)
{
	return g_flNPCStepSize[iNPCIndex];
}

int NPCChaserGetAttackCount(int iNPCIndex)
{
	return g_NPCBaseAttacksCount[iNPCIndex];
}

int NPCChaserGetAttackType(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackType;
}

float NPCChaserGetAttackDamage(int iNPCIndex,int iAttackIndex,int iDifficulty)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][iDifficulty].BaseAttackDamage;
}

float NPCChaserGetAttackDamageVsProps(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackDamageVsProps;
}

float NPCChaserGetAttackDamageForce(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackDamageForce;
}
/*
float NPCChaserGetAttackLifeStealDuration(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackLifeStealDuration;
}
*/
bool NPCChaserGetAttackLifeStealState(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackLifeSteal;
}

float NPCChaserGetAttackProjectileDamage(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackProjectileDamage;
}

float NPCChaserGetAttackProjectileSpeed(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackProjectileSpeed;
}

bool NPCChaserGetAttackProjectileCrits(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackProjectileCrits;
}

float NPCChaserGetAttackProjectileIceSlowdownPercent(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackProjectileIceSlowdownPercent;
}

float NPCChaserGetAttackProjectileIceSlowdownDuration(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackProjectileIceSlowdownDuration;
}

int NPCChaserGetAttackBulletCount(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackBulletCount;
}

float NPCChaserGetAttackBulletDamage(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackBulletDamage;
}

float NPCChaserGetAttackBulletSpread(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackBulletSpread;
}

float NPCChaserGetAttackLaserDamage(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackLaserDamage;
}

float NPCChaserGetAttackLaserSize(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackLaserSize;
}

void NPCChaserGetAttackLaserColor(int iNPCIndex,int iAttackIndex,int iColor[3])
{
	iColor[0] = g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackLaserColor[0];
	iColor[1] = g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackLaserColor[1];
	iColor[2] = g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackLaserColor[2];
}

bool NPCChaserGetAttackLaserAttachmentState(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackLaserAttachment;
}

float NPCChaserGetAttackLaserDuration(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackLaserDuration;
}

bool NPCChaserGetAttackPullIn(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackPullIn;
}

int NPCChaserGetAttackDamageType(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackDamageType;
}

int NPCChaserGetAttackDisappear(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackDisappear;
}

int NPCChaserGetAttackRepeat(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackRepeat;
}

float NPCChaserGetAttackDamageDelay(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackDamageDelay;
}

float NPCChaserGetAttackRange(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackRange;
}

float NPCChaserGetAttackDuration(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackDuration;
}

float NPCChaserGetAttackSpread(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackSpread;
}

float NPCChaserGetAttackBeginRange(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackBeginRange;
}

float NPCChaserGetAttackBeginFOV(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackBeginFOV;
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

float NPCChaserGetAttackCooldown(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackCooldown;
}

float NPCChaserGetNextAttackTime(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][1].BaseAttackNextAttackTime;
}

bool NPCChaserIsStunEnabled(int iNPCIndex)
{
	return g_bNPCStunEnabled[iNPCIndex];
}

bool NPCChaserIsStunByFlashlightEnabled(int iNPCIndex)
{
	return g_bNPCStunFlashlightEnabled[iNPCIndex];
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
		SendDebugMessageToPlayers(DEBUG_BOSS_STUN,0,"Boss %i, new amount: %0.0f",iNPCIndex,NPCChaserGetStunHealth(iNPCIndex));
#endif
	}
}

float NPCChaserGetStunInitialHealth(int iNPCIndex)
{
	return g_flNPCStunInitialHealth[iNPCIndex];
}

float NPCChaserGetAlertGracetime(int iNPCIndex,int iDifficulty)
{
	return g_flNPCAlertGracetime[iNPCIndex][iDifficulty];
}

float NPCChaserGetAlertDuration(int iNPCIndex,int iDifficulty)
{
	return g_flNPCAlertDuration[iNPCIndex][iDifficulty];
}

float NPCChaserGetChaseDuration(int iNPCIndex,int iDifficulty)
{
	return g_flNPCChaseDuration[iNPCIndex][iDifficulty];
}

bool NPCChaserIsCloakEnabled(int iNPCIndex)
{
	return g_bNPCCloakEnabled[iNPCIndex];
}

float NPCChaserGetCloakCooldown(int iNPCIndex,int iDifficulty)
{
	return g_flNPCCloakCooldown[iNPCIndex][iDifficulty];
}

float NPCChaserGetCloakRange(int iNPCIndex,int iDifficulty)
{
	return g_flNPCCloakRange[iNPCIndex][iDifficulty];
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

float NPCChaserGetProjectileCooldownMin(int iNPCIndex,int iDifficulty)
{
	return g_flNPCProjectileCooldownMin[iNPCIndex][iDifficulty];
}

float NPCChaserGetProjectileCooldownMax(int iNPCIndex,int iDifficulty)
{
	return g_flNPCProjectileCooldownMax[iNPCIndex][iDifficulty];
}

float NPCChaserGetProjectileSpeed(int iNPCIndex,int iDifficulty)
{
	return g_flNPCProjectileSpeed[iNPCIndex][iDifficulty];
}

float NPCChaserGetProjectileDamage(int iNPCIndex,int iDifficulty)
{
	return g_flNPCProjectileDamage[iNPCIndex][iDifficulty];
}

float NPCChaserGetProjectileRadius(int iNPCIndex,int iDifficulty)
{
	return g_flNPCProjectileRadius[iNPCIndex][iDifficulty];
}

float NPCChaserGetIceballSlowdownDuration(int iNPCIndex,int iDifficulty)
{
	return g_flIceballSlowdownDuration[iNPCIndex][iDifficulty];
}

float NPCChaserGetIceballSlowdownPercent(int iNPCIndex,int iDifficulty)
{
	return g_flIceballSlowdownPercent[iNPCIndex][iDifficulty];
}

int NPCChaserGetLoadedProjectiles(int iNPCIndex,int iDifficulty)
{
	return g_iNPCProjectileLoadedAmmo[iNPCIndex][iDifficulty];
}

float NPCChaserGetProjectileReloadTime(int iNPCIndex,int iDifficulty)
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

float NPCChaserGetJarateDuration(int iNPCIndex,int iDifficulty)
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

float NPCChaserGetMilkDuration(int iNPCIndex,int iDifficulty)
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

float NPCChaserGetGasDuration(int iNPCIndex,int iDifficulty)
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

float NPCChaserGetMarkDuration(int iNPCIndex,int iDifficulty)
{
	return g_flNPCMarkDuration[iNPCIndex][iDifficulty];
}

bool NPCChaserIgnitePlayerOnHit(int iNPCIndex)
{
	return g_bNPCIgnitePlayerEnabled[iNPCIndex];
}

int NPCChaserGetIgniteAttackIndexes(int iNPCIndex)
{
	return g_iNPCIgniteAttackIndexes[iNPCIndex];
}

float NPCChaserGetIgniteDelay(int iNPCIndex,int iDifficulty)
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

float NPCChaserGetStunAttackDuration(int iNPCIndex,int iDifficulty)
{
	return g_flNPCStunAttackDuration[iNPCIndex][iDifficulty];
}

float NPCChaserGetStunAttackSlowdown(int iNPCIndex,int iDifficulty)
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

float NPCChaserGetBleedDuration(int iNPCIndex,int iDifficulty)
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

float NPCChaserGetElectricDuration(int iNPCIndex,int iDifficulty)
{
	return g_flNPCElectricDuration[iNPCIndex][iDifficulty];
}

float NPCChaserGetElectricSlowdown(int iNPCIndex,int iDifficulty)
{
	return g_flNPCElectricSlowdown[iNPCIndex][iDifficulty];
}

bool NPCChaserSmitePlayerOnHit(int iNPCIndex)
{
	return g_bNPCSmitePlayerEnabled[iNPCIndex];
}

int NPCChaserGetSmiteAttackIndexes(int iNPCIndex)
{
	return g_iNPCSmiteAttackIndexes[iNPCIndex];
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
/*
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

float NPCChaserGetShockwaveDrain(int iNPCIndex,int iDifficulty)
{
	return g_flNPCShockwaveDrain[iNPCIndex][iDifficulty];
}

float NPCChaserGetShockwaveForce(int iNPCIndex,int iDifficulty)
{
	return g_flNPCShockwaveForce[iNPCIndex][iDifficulty];
}

float NPCChaserGetShockwaveHeight(int iNPCIndex,int iDifficulty)
{
	return g_flNPCShockwaveHeight[iNPCIndex][iDifficulty];
}

float NPCChaserGetShockwaveRange(int iNPCIndex,int iDifficulty)
{
	return g_flNPCShockwaveRange[iNPCIndex][iDifficulty];
}

float NPCChaserGetShockwaveStunDuration(int iNPCIndex,int iDifficulty)
{
	return g_flNPCShockwaveStunDuration[iNPCIndex][iDifficulty];
}

float NPCChaserGetShockwaveStunSlowdown(int iNPCIndex,int iDifficulty)
{
	return g_flNPCShockwaveStunSlowdown[iNPCIndex][iDifficulty];
}
*/
int NPCChaserGetState(int iNPCIndex)
{
	return g_iNPCState[iNPCIndex];
}

void NPCChaserSetState(int iNPCIndex,int iState)
{
	g_iNPCState[iNPCIndex] = iState;
}

int NPCChaserOnSelectProfile(int iNPCIndex)
{
	// int iUniqueProfileIndex = NPCGetUniqueProfileIndex(iNPCIndex);

	SF2ChaserBossProfile profile = SF2ChaserBossProfile(NPCGetProfileIndex(iNPCIndex));

	g_flNPCWakeRadius[iNPCIndex] = profile.WakeRadius;
	g_flNPCStepSize[iNPCIndex] = profile.StepSize;
	
	for (int iDifficulty = 0; iDifficulty < Difficulty_Max; iDifficulty++)
	{
		g_flNPCWalkSpeed[iNPCIndex][iDifficulty] = profile.GetWalkSpeed(iDifficulty);
		g_flNPCAirSpeed[iNPCIndex][iDifficulty] = profile.GetAirSpeed(iDifficulty);
		
		g_flNPCMaxWalkSpeed[iNPCIndex][iDifficulty] = profile.GetMaxWalkSpeed(iDifficulty);
		g_flNPCMaxAirSpeed[iNPCIndex][iDifficulty] = profile.GetMaxAirSpeed(iDifficulty);
		
		g_flNPCAlertGracetime[iNPCIndex][iDifficulty] = profile.GetAlertStateGraceTime(iDifficulty);
		g_flNPCAlertDuration[iNPCIndex][iDifficulty] = profile.GetAlertStateDuration(iDifficulty);
		g_flNPCChaseDuration[iNPCIndex][iDifficulty] = profile.GetChaseStateDuration(iDifficulty);
		
		g_flNPCCloakCooldown[iNPCIndex][iDifficulty] = profile.GetCloakCooldown(iDifficulty);
		g_flNPCCloakRange[iNPCIndex][iDifficulty] = profile.GetCloakRange(iDifficulty);

		g_flNPCProjectileCooldownMin[iNPCIndex][iDifficulty] = profile.GetProjectileCooldownMin(iDifficulty);
		g_flNPCProjectileCooldownMax[iNPCIndex][iDifficulty] = profile.GetProjectileCooldownMax(iDifficulty);
		g_flNPCProjectileSpeed[iNPCIndex][iDifficulty] = profile.GetProjectileSpeed(iDifficulty);
		g_flNPCProjectileDamage[iNPCIndex][iDifficulty] = profile.GetProjectileDamage(iDifficulty);
		g_flNPCProjectileRadius[iNPCIndex][iDifficulty] = profile.GetProjectileRadius(iDifficulty);
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
	}
	
	g_NPCBaseAttacksCount[iNPCIndex] = profile.AttackCount;
	// Get attack data.
	for (int i = 0; i < g_NPCBaseAttacksCount[iNPCIndex]; i++)
	{
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackType = profile.GetAttackType(i);
		for (int iDiffAtk = 0; iDiffAtk < Difficulty_Max; iDiffAtk++)
		{
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackDamage = profile.GetAttackDamage(i, iDiffAtk);
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
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackCooldown = profile.GetAttackCooldown(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackDisappear = profile.ShouldDisappearAfterAttack(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackRepeat = profile.GetAttackRepeatCount(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackNextAttackTime = GetGameTime();
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLifeSteal = profile.CanAttackLifeSteal(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLifeStealDuration = profile.GetAttackLifeStealDuration(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackProjectileDamage = profile.GetAttackProjectileDamage(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackProjectileSpeed = profile.GetAttackProjectileSpeed(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackProjectileRadius = profile.GetAttackProjectileRadius(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackProjectileCrits = profile.AreAttackProjectilesCritBoosted(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackProjectileIceSlowdownPercent = profile.GetAttackProjectileIceSlowdownPercent(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackProjectileIceSlowdownDuration = profile.GetAttackProjectileIceSlowdownDuration(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackBulletCount = profile.GetAttackBulletCount(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackBulletDamage = profile.GetAttackBulletDamage(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackBulletSpread = profile.GetAttackBulletSpread(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserDamage = profile.GetAttackLaserDamage(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserSize = profile.GetAttackLaserSize(i);
		int iLaserColor[3];
		profile.GetAttackLaserColor(iLaserColor, i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserColor[0] = iLaserColor[0];
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserColor[1] = iLaserColor[1];
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserColor[2] = iLaserColor[2];
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserAttachment = profile.IsLaserOnAttachment(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserDuration = profile.GetAttackLaserDuration(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackPullIn = profile.CanAttackPullIn(i);
		g_NPCBaseAttacks[iNPCIndex][i][1].CurrentAttackRepeat = 0;
	}

	// Get stun data.
	g_bNPCStunEnabled[iNPCIndex] = profile.StunEnabled;
	g_flNPCStunDuration[iNPCIndex] = profile.StunDuration;
	g_flNPCStunCooldown[iNPCIndex] = profile.StunCooldown;
	g_bNPCStunFlashlightEnabled[iNPCIndex] = profile.StunByFlashlightEnabled;
	g_flNPCStunFlashlightDamage[iNPCIndex] = profile.StunFlashlightDamage;
	g_flNPCStunInitialHealth[iNPCIndex] = profile.StunHealth;
	
	//Get Key Data
	g_bNPCHasKeyDrop[iNPCIndex] = profile.HasKeyDrop;
	
	//Get Cloak Data
	g_bNPCCloakEnabled[iNPCIndex] = profile.CloakEnabled;
	
	float fStunHealthPerPlayer = profile.StunHealthPerPlayer;
	int count;
	for(int iClient;iClient<=MaxClients;iClient++)
		if(IsValidClient(iClient) && g_bPlayerEliminated[iClient])
			count++;
	fStunHealthPerPlayer *= float(count);
	g_flNPCStunInitialHealth[iNPCIndex] += fStunHealthPerPlayer;
	
	NPCChaserSetStunHealth(iNPCIndex, NPCChaserGetStunInitialHealth(iNPCIndex));
	
	NPCSetAddSpeed(iNPCIndex, -NPCGetAddSpeed(iNPCIndex));
	NPCSetAddMaxSpeed(iNPCIndex, -NPCGetAddMaxSpeed(iNPCIndex));
	NPCChaserSetAddStunHealth(iNPCIndex, -NPCChaserGetAddStunHealth(iNPCIndex));
	
	g_bNPCAlreadyAttacked[iNPCIndex] = false;
	g_bNPCVelocityCancel[iNPCIndex] = false;
	
	g_bNPCStealingLife[iNPCIndex] = false;
	g_hNPCLifeStealTimer[iNPCIndex] = INVALID_HANDLE;
	
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
	g_iNPCSmiteAttackIndexes[iNPCIndex] = profile.SmiteAttackIndexes;
	g_flNPCSmiteDamage[iNPCIndex] = profile.SmiteDamage;
	g_iNPCSmiteDamageType[iNPCIndex] = profile.SmiteDamageType;

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
	g_bNPCInAutoChase[iNPCIndex] = false;
	g_bAutoChasingLoudPlayer[iNPCIndex] = false;

	g_bNPCChasesEndlessly[iNPCIndex] = profile.ChasesEndlessly;
	
	g_flNPCLaserTimer[iNPCIndex] = GetGameTime();
	
	g_bNPCCanSelfHeal[iNPCIndex] = profile.SelfHealState;
	g_flNPCStartSelfHealPercentage[iNPCIndex] = profile.SelfHealStartPercentage;
	g_flNPCSelfHealPercentageOne[iNPCIndex] = profile.SelfHealPercentageOne;
	g_flNPCSelfHealPercentageTwo[iNPCIndex] = profile.SelfHealPercentageTwo;
	g_flNPCSelfHealPercentageThree[iNPCIndex] = profile.SelfHealPercentageThree;
	g_bNPCRunningToHeal[iNPCIndex] = false;
	g_bNPCHealing[iNPCIndex] = false;
	g_flNPCFleeHealTimer[iNPCIndex] = GetGameTime();
	g_iNPCSelfHealStage[iNPCIndex] = 0;
	g_iNPCHealCount[iNPCIndex] = 0;
	g_bNPCSetHealDestination[iNPCIndex] = false;
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
	g_flNPCStepSize[iNPCIndex] = 0.0;
	
	for (int iDifficulty = 0; iDifficulty < Difficulty_Max; iDifficulty++)
	{
		g_flNPCWalkSpeed[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCAirSpeed[iNPCIndex][iDifficulty] = 0.0;
		
		g_flNPCMaxWalkSpeed[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCMaxAirSpeed[iNPCIndex][iDifficulty] = 0.0;
		
		g_flNPCAlertGracetime[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCAlertDuration[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCChaseDuration[iNPCIndex][iDifficulty] = 0.0;
		
		g_flNPCCloakCooldown[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCCloakRange[iNPCIndex][iDifficulty] = 0.0;
		
		g_flNPCProjectileCooldownMin[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCProjectileCooldownMax[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCProjectileSpeed[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCProjectileDamage[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCProjectileRadius[iNPCIndex][iDifficulty] = 0.0;
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
	}
	
	// Clear attack data.
	for (int i = 0; i < SF2_CHASER_BOSS_MAX_ATTACKS; i++)
	{
		// Base attack data.
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackType = SF2BossAttackType_Invalid;
		for (int iDiffAtk = 0; iDiffAtk < Difficulty_Max; iDiffAtk++)
		{
			g_NPCBaseAttacks[iNPCIndex][i][iDiffAtk].BaseAttackDamage = 0.0;
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
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackCooldown = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackDisappear = 0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackRepeat = 0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackNextAttackTime = GetGameTime();
		g_NPCBaseAttacks[iNPCIndex][i][1].WeaponAttackIndex = 0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLifeSteal = false;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLifeStealDuration = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackProjectileDamage = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackProjectileSpeed = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackProjectileRadius = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackProjectileCrits = false;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackProjectileIceSlowdownPercent = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackProjectileIceSlowdownDuration = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackBulletCount = 0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackBulletDamage = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackBulletSpread = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserDamage = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserSize = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserColor[0] = 0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserColor[1] = 0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserColor[2] = 0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserAttachment = false;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackLaserDuration = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][1].BaseAttackPullIn = false;
		g_NPCBaseAttacks[iNPCIndex][i][1].CurrentAttackRepeat = 0;
	}
	
	g_bNPCStunEnabled[iNPCIndex] = false;
	g_bNPCAlreadyAttacked[iNPCIndex] = false;
	g_flNPCStunDuration[iNPCIndex] = 0.0;
	g_flNPCStunCooldown[iNPCIndex] = 0.0;
	g_bNPCStunFlashlightEnabled[iNPCIndex] = false;
	g_flNPCStunInitialHealth[iNPCIndex] = 0.0;
	g_flNPCStunAddHealth[iNPCIndex] = 0.0;
	
	g_bNPCCloakEnabled[iNPCIndex] = false;
	g_bNPCHasCloaked[iNPCIndex] = false;
	g_bNPCVelocityCancel[iNPCIndex] = false;
	g_bNPCStealingLife[iNPCIndex] = false;
	g_hNPCLifeStealTimer[iNPCIndex] = INVALID_HANDLE;
	
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
	g_iNPCSmiteAttackIndexes[iNPCIndex] = 0;
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
	g_bAutoChasingLoudPlayer[iNPCIndex] = false;

	g_bNPCChasesEndlessly[iNPCIndex] = false;

	NPCSetAddSpeed(iNPCIndex, -NPCGetAddSpeed(iNPCIndex));
	NPCSetAddMaxSpeed(iNPCIndex, -NPCGetAddMaxSpeed(iNPCIndex));
	NPCChaserSetAddStunHealth(iNPCIndex, -NPCChaserGetAddStunHealth(iNPCIndex));
	
	NPCChaserSetStunHealth(iNPCIndex, 0.0);
	
	g_iNPCState[iNPCIndex] = -1;
	
	g_flNPCLaserTimer[iNPCIndex] = GetGameTime();
	
	g_bNPCCanSelfHeal[iNPCIndex] = false;
	g_flNPCStartSelfHealPercentage[iNPCIndex] = 0.0;
	g_flNPCSelfHealPercentageOne[iNPCIndex] = 0.0;
	g_flNPCSelfHealPercentageTwo[iNPCIndex] = 0.0;
	g_flNPCSelfHealPercentageThree[iNPCIndex] = 0.0;
	g_bNPCRunningToHeal[iNPCIndex] = false;
	g_bNPCHealing[iNPCIndex] = false;
	g_flNPCFleeHealTimer[iNPCIndex] = GetGameTime();
	g_iNPCSelfHealStage[iNPCIndex] = 0;
	g_iNPCHealCount[iNPCIndex] = 0;
	g_bNPCSetHealDestination[iNPCIndex] = false;
}

static int g_iSlenderOldState[MAX_BOSSES];
static float g_flLastPos[MAX_BOSSES][3];
static float g_flLastStuckTime[MAX_BOSSES];

void Spawn_Chaser(int iBossIndex)
{
	g_hBossFailSafeTimer[iBossIndex] = INVALID_HANDLE;
	g_flLastStuckTime[iBossIndex] = 0.0;
	g_iSlenderOldState[iBossIndex] = STATE_IDLE;
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

stock bool IsTargetValidForSlender(int iTarget, bool bIncludeEliminated=false)
{
	if (!iTarget || !IsValidEntity(iTarget)) return false;
	
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
		g_hBossFailSafeTimer[iBossIndex] = INVALID_HANDLE;
		return Plugin_Stop;
	}
	
	if (timer != g_hBossFailSafeTimer[iBossIndex])
	{
		g_hBossFailSafeTimer[iBossIndex] = INVALID_HANDLE;
		return Plugin_Stop;
	}
	
	if (g_bNPCInAutoChase[iBossIndex])
	{
		g_hBossFailSafeTimer[iBossIndex] = INVALID_HANDLE;
		g_bNPCInAutoChase[iBossIndex] = false;
		return Plugin_Stop;
	}
	
	if (g_bAutoChasingLoudPlayer[iBossIndex] && g_iSlenderState[iBossIndex] != STATE_CHASE && g_iSlenderState[iBossIndex] != STATE_ATTACK && g_iSlenderState[iBossIndex] != STATE_STUN)
	{
		g_hBossFailSafeTimer[iBossIndex] = INVALID_HANDLE;
		g_bAutoChasingLoudPlayer[iBossIndex] = false;
		return Plugin_Stop;
	}
	
	if (!g_bSlenderChaseDeathPosition[iBossIndex])
	{
		g_hBossFailSafeTimer[iBossIndex] = INVALID_HANDLE;
		g_bSlenderGiveUp[iBossIndex] = true;
		return Plugin_Stop;
	}
	
	if (g_iSlenderState[iBossIndex] == STATE_CHASE || g_iSlenderState[iBossIndex] == STATE_ATTACK || g_iSlenderState[iBossIndex] == STATE_STUN)
	{
		g_hBossFailSafeTimer[iBossIndex] = INVALID_HANDLE;
		return Plugin_Stop;
	}

	g_bSlenderChaseDeathPosition[iBossIndex] = false;
	g_bSlenderGiveUp[iBossIndex] = true;
	g_hBossFailSafeTimer[iBossIndex] = INVALID_HANDLE;
	return Plugin_Continue;
}

public Action Timer_SlenderChaseBossThink(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;
	
	if (timer != g_hSlenderEntityThink[iBossIndex]) return Plugin_Stop;
	
	if (NPCGetFlags(iBossIndex) & SFF_MARKEDASFAKE) return Plugin_Stop;
	
	//CTFBaseBoss doesn't call CBaseCombatCharacter::UpdateLastKnownArea automaticly, manually call it so we can use SDK_GetLastKnownArea on the boss.
	SDK_UpdateLastKnownArea(slender);
	
	/*int iCurrentSequence = GetEntProp(slender, Prop_Send, "m_nSequence");
	if (iCurrentSequence != g_iNPCCurrentAnimationSequence[iBossIndex])
	{
#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_BOSS_ANIMATION, 0, "Boss %i, changed automaticly animation sequence old:%i new:%i (Fixing...)",iBossIndex, g_iNPCCurrentAnimationSequence[iBossIndex], iCurrentSequence);
#endif
		g_iNPCCurrentAnimationSequence[iBossIndex] = EntitySetAnimation(slender, "", g_bNPCCurrentAnimationSequenceIsLooped[iBossIndex], g_flNPCCurrentAnimationSequencePlaybackRate[iBossIndex], g_iNPCCurrentAnimationSequence[iBossIndex]);
	}*/
	
	/*float flPlaybackRate = GetEntPropFloat(slender, Prop_Send, "m_flPlaybackRate");
	if (flPlaybackRate != g_flNPCCurrentAnimationSequencePlaybackRate[iBossIndex])
	{
#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_BOSS_ANIMATION, 0, "Boss %i, changed automaticly playback rate old:%f new:%f (Fixing...)",iBossIndex, g_flNPCCurrentAnimationSequencePlaybackRate[iBossIndex], flPlaybackRate);
#endif
		SetEntPropFloat(slender, Prop_Send, "m_flPlaybackRate", g_flNPCCurrentAnimationSequencePlaybackRate[iBossIndex]);
	}*/
	
	float flMyPos[3], flMyEyeAng[3];
	float flBuffer[3];
	
	char sSlenderProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sSlenderProfile, sizeof(sSlenderProfile));
	
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flMyPos);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", flMyEyeAng);
	
	AddVectors(flMyEyeAng, g_flSlenderEyeAngOffset[iBossIndex], flMyEyeAng);
	for (int i = 0; i < 3; i++) flMyEyeAng[i] = AngleNormalize(flMyEyeAng[i]);
	
	int iDifficulty = GetConVarInt(g_cvDifficulty);
	
	float flOriginalSpeed;
	float flOriginalMaxSpeed;
	if (!g_bNPCUsesChaseInitialAnimation[iBossIndex] && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && !g_bNPCUsesHealAnimation[iBossIndex] && !g_bNPCUseStartFleeAnimation[iBossIndex])
	{
		if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S))
		{
			flOriginalSpeed = NPCGetSpeed(iBossIndex, iDifficulty) + NPCGetAddSpeed(iBossIndex);
			flOriginalMaxSpeed = NPCGetMaxSpeed(iBossIndex, iDifficulty) + NPCGetAddMaxSpeed(iBossIndex);
		}
		else
		{
			flOriginalSpeed = NPCGetSpeed(iBossIndex, iDifficulty) + NPCGetAddSpeed(iBossIndex);
			flOriginalMaxSpeed = NPCGetMaxSpeed(iBossIndex, iDifficulty) + NPCGetAddMaxSpeed(iBossIndex);
			if ((flOriginalSpeed < 520.0))
			{
				flOriginalSpeed = 520.0;
			}
			if (flOriginalMaxSpeed < 520.0)
			{
				flOriginalMaxSpeed = 520.0;
			}
		}
	}
	else
	{
		flOriginalSpeed = 0.0;
		flOriginalMaxSpeed = 0.0;
	}
	float flOriginalWalkSpeed = NPCChaserGetWalkSpeed(iBossIndex, iDifficulty);
	float flOriginalAirSpeed = NPCChaserGetAirSpeed(iBossIndex, iDifficulty);
	float flOriginalMaxWalkSpeed = NPCChaserGetMaxWalkSpeed(iBossIndex, iDifficulty);
	float flOriginalMaxAirSpeed = NPCChaserGetMaxAirSpeed(iBossIndex, iDifficulty);
	
	if (g_bProxySurvivalRageMode)
	{
		flOriginalSpeed *= 1.2;
		flOriginalWalkSpeed *= 1.2;
		flOriginalAirSpeed *= 1.2;
		flOriginalMaxSpeed *= 1.2;
		flOriginalMaxWalkSpeed *= 1.2;
		flOriginalMaxAirSpeed *= 1.2;
	}
	float flSpeed;
	float flMaxSpeed;
	if (!g_bNPCUsesChaseInitialAnimation[iBossIndex] && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && !g_bNPCUsesHealAnimation[iBossIndex] && !g_bNPCUseStartFleeAnimation[iBossIndex])
	{
		flSpeed = flOriginalSpeed;
		flMaxSpeed = flOriginalMaxSpeed;
	}
	else
	{
		flSpeed = 0.0;
		flMaxSpeed = 0.0;
	}
	if (g_flRoundDifficultyModifier > 1.0)
	{
		flSpeed = flOriginalSpeed + ((flOriginalSpeed * g_flRoundDifficultyModifier)/15) + (NPCGetAnger(iBossIndex) * g_flRoundDifficultyModifier);
		flMaxSpeed = flOriginalMaxSpeed + ((flOriginalMaxSpeed * g_flRoundDifficultyModifier)/20) + (NPCGetAnger(iBossIndex) * g_flRoundDifficultyModifier);
	}
	if (flSpeed < flOriginalSpeed) flSpeed = flOriginalSpeed;
	if (flSpeed > flMaxSpeed) flSpeed = flMaxSpeed;
	
	float flWalkSpeed = flOriginalWalkSpeed;
	float flMaxWalkSpeed = flOriginalMaxWalkSpeed;
	if (g_flRoundDifficultyModifier > 1.0)
	{
		flWalkSpeed = flOriginalWalkSpeed + ((flOriginalWalkSpeed * g_flRoundDifficultyModifier)/15) + (NPCGetAnger(iBossIndex) * g_flRoundDifficultyModifier);
		flMaxWalkSpeed = flOriginalMaxWalkSpeed + ((flOriginalMaxWalkSpeed * g_flRoundDifficultyModifier)/20) + (NPCGetAnger(iBossIndex) * g_flRoundDifficultyModifier);
	}
	if (flWalkSpeed < flOriginalWalkSpeed) flWalkSpeed = flOriginalWalkSpeed;
	if (flWalkSpeed > flMaxWalkSpeed) flWalkSpeed = flMaxWalkSpeed;
	
	float flAirSpeed = flOriginalAirSpeed;
	float flMaxAirSpeed = flOriginalMaxAirSpeed;
	if (g_flRoundDifficultyModifier > 1.0)
	{
		flAirSpeed = flOriginalAirSpeed + ((flOriginalAirSpeed * g_flRoundDifficultyModifier)/15) + (NPCGetAnger(iBossIndex) * g_flRoundDifficultyModifier);
		flMaxAirSpeed = flOriginalMaxAirSpeed + ((flOriginalMaxAirSpeed * g_flRoundDifficultyModifier)/20) + (NPCGetAnger(iBossIndex) * g_flRoundDifficultyModifier);
	}
	if (flAirSpeed < flOriginalAirSpeed) flAirSpeed = flOriginalAirSpeed;
	if (flAirSpeed > flMaxAirSpeed) flAirSpeed = flMaxAirSpeed;
	
	//It seems change air speed on difficulty level is a bad idea
	flAirSpeed = NPCChaserGetAirSpeed(iBossIndex, iDifficulty);
	
	if (PeopleCanSeeSlender(iBossIndex, _, false))
	{
		if (NPCHasAttribute(iBossIndex, "reduced speed on look"))
		{
			flSpeed *= NPCGetAttributeValue(iBossIndex, "reduced speed on look");
		}
		
		if (NPCHasAttribute(iBossIndex, "reduced walk speed on look"))
		{
			flWalkSpeed *= NPCGetAttributeValue(iBossIndex, "reduced walk speed on look");
		}
		
		if (NPCHasAttribute(iBossIndex, "reduced air speed on look"))
		{
			flAirSpeed *= NPCGetAttributeValue(iBossIndex, "reduced air speed on look");
		}
	}
	Action fAction = Plugin_Continue;
	float flForwardSpeed = flWalkSpeed;
	Call_StartForward(fOnBossGetWalkSpeed);
	Call_PushCell(iBossIndex);
	Call_PushFloatRef(flForwardSpeed);
	Call_Finish(fAction);
	if (fAction == Plugin_Changed)
		flWalkSpeed = flForwardSpeed;
	
	fAction = Plugin_Continue;
	flForwardSpeed = flSpeed;
	Call_StartForward(fOnBossGetSpeed);
	Call_PushCell(iBossIndex);
	Call_PushFloatRef(flForwardSpeed);
	Call_Finish(fAction);
	if (fAction == Plugin_Changed)
		flSpeed = flForwardSpeed;
	
	g_flSlenderCalculatedWalkSpeed[iBossIndex] = flWalkSpeed;
	if (!g_bNPCUsesChaseInitialAnimation[iBossIndex] && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && !g_bNPCUsesHealAnimation[iBossIndex] && !g_bNPCUseStartFleeAnimation[iBossIndex])
	{
		g_flSlenderCalculatedSpeed[iBossIndex] = flSpeed;
	}
	else
	{
		g_flSlenderCalculatedSpeed[iBossIndex] = 0.0;
	}
	g_flSlenderCalculatedAirSpeed[iBossIndex] = flAirSpeed;
	
	int iOldState = g_iSlenderState[iBossIndex];
	int iOldTarget = EntRefToEntIndex(g_iSlenderTarget[iBossIndex]);
	
	int iBestNewTarget = INVALID_ENT_REFERENCE;
	float flSearchRange = NPCGetSearchRadius(iBossIndex);
	float flBestNewTargetDist = flSearchRange;
	int iState = iOldState;
	
	bool bPlayerInFOV[MAXPLAYERS + 1];
	bool bPlayerNear[MAXPLAYERS + 1];
	bool bPlayerMadeNoise[MAXPLAYERS + 1];
	bool bPlayerInTrap[MAXPLAYERS + 1];
	float flPlayerDists[MAXPLAYERS + 1];
	bool bPlayerVisible[MAXPLAYERS + 1];
	
	bool bAttackEliminated = view_as<bool>(NPCGetFlags(iBossIndex) & SFF_ATTACKWAITERS);
	bool bStunEnabled = NPCChaserIsStunEnabled(iBossIndex);
	
	float flSlenderMins[3], flSlenderMaxs[3];
	GetEntPropVector(slender, Prop_Send, "m_vecMins", flSlenderMins);
	GetEntPropVector(slender, Prop_Send, "m_vecMaxs", flSlenderMaxs);
	
	float flTraceMins[3], flTraceMaxs[3];
	flTraceMins[0] = flSlenderMins[0];
	flTraceMins[1] = flSlenderMins[1];
	flTraceMins[2] = 0.0;
	flTraceMaxs[0] = flSlenderMaxs[0];
	flTraceMaxs[1] = flSlenderMaxs[1];
	flTraceMaxs[2] = 0.0;
	
	char strClass[32];
	
	bool bBuilding = false;
	if(iOldTarget > MaxClients)
	{
		GetEdictClassname(iOldTarget, strClass, sizeof(strClass));
		if(strcmp(strClass, "obj_sentrygun") == 0 && !GetEntProp(iOldTarget, Prop_Send, "m_bCarried"))
		{
			bBuilding = true;
		}
		if(strcmp(strClass, "obj_dispenser") == 0 && !GetEntProp(iOldTarget, Prop_Send, "m_bCarried"))
		{
			bBuilding = true;
		}
	}
	
	/*if (NPCHasAttribute(iBossIndex, "alert copies"))
	{
		if ((NPCGetFlags(iBossIndex) & SFF_COPIES))
		{
			for (int iBossCheck = 0; iBossCheck < MAX_BOSSES; iBossCheck++)
			{
				if (iBossCheck != iBossIndex && NPCGetUniqueID(iBossCheck) != -1 && (g_iSlenderCopyMaster[iBossIndex] == iBossCheck || g_iSlenderCopyMaster[iBossIndex] == g_iSlenderCopyMaster[iBossCheck]))
				{
					int iBossEnt = NPCGetEntIndex(iBossCheck);
					if (iBossEnt && iBossEnt != INVALID_ENT_REFERENCE && NPCHasAttribute(iBossCheck, "alert copies"))
					{
						NPCChaseAlerts(iBossIndex, iBossCheck);
					}
				}
			}
		}
	}*/
	
	// Gather data about the players around me and get the best new target, in case my old target is invalidated.
	// Fix for optimization
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsTargetValidForSlender(i, bAttackEliminated)) continue;
		
		float flTraceStartPos[3], flTraceEndPos[3];
		NPCGetEyePosition(iBossIndex, flTraceStartPos);
		GetClientEyePosition(i, flTraceEndPos);
		float flDist;
		
		if (i > MaxClients)
		{
			if(IsValidEntity(i))
			{
				GetEdictClassname(i, strClass, sizeof(strClass));
				if ((strcmp(strClass, "obj_sentrygun") == 0 || strcmp(strClass, "obj_dispenser") == 0) && !GetEntProp(i, Prop_Send, "m_bCarried"))
				{
					GetEntPropVector(i, Prop_Data, "m_vecAbsOrigin", flTraceEndPos);

					Handle hTrace = TR_TraceHullFilterEx(flTraceStartPos,
						flTraceEndPos,
						flTraceMins,
						flTraceMaxs,
						MASK_NPCSOLID,
						TraceRayBossVisibility,
						slender
					);
					
					bool bIsVisible = !TR_DidHit(hTrace);
					int iTraceHitEntity = TR_GetEntityIndex(hTrace);
					delete hTrace;
					
					if (!bIsVisible && iTraceHitEntity == i) bIsVisible = true;
					
					if (bIsVisible)
					{
						// FOV check.
						SubtractVectors(flTraceEndPos, flTraceStartPos, flBuffer);
						GetVectorAngles(flBuffer, flBuffer);
						
						if (FloatAbs(AngleDiff(flMyEyeAng[1], flBuffer[1])) > (NPCGetFOV(iBossIndex) * 0.5))
						{
							bIsVisible = false;
						}
					}

					if (bIsVisible)
					{
						bIsVisible = NPCShouldSeeEntity(iBossIndex, i);
					}

					if (bIsVisible)
					{
						flDist = GetVectorDistance(flTraceStartPos, flTraceEndPos);
						if (flDist < flBestNewTargetDist)
						{
							iBestNewTarget = i;
							flBestNewTargetDist = flDist;
							bBuilding = true;
							g_iSlenderInterruptConditions[iBossIndex] |= COND_SAWENEMY;
						}
					}
				}
			}
			continue;
		}
		
		Handle hTrace = TR_TraceHullFilterEx(flTraceStartPos,
			flTraceEndPos,
			flTraceMins,
			flTraceMaxs,
			MASK_NPCSOLID,
			TraceRayBossVisibility,
			slender);
		
		bool bIsVisible = !TR_DidHit(hTrace);
		int iTraceHitEntity = TR_GetEntityIndex(hTrace);
		delete hTrace;
		
		if (!bIsVisible && iTraceHitEntity == i) bIsVisible = true;
		
		if (bIsVisible)
		{
			bIsVisible = NPCShouldSeeEntity(iBossIndex, i);
		}
		
		bPlayerVisible[i] = bIsVisible;
		
		// Near radius check.
		if (bIsVisible &&
			GetVectorDistance(flTraceStartPos, flTraceEndPos) <= NPCChaserGetWakeRadius(iBossIndex))
		{
			bPlayerNear[i] = true;
		}
		if (bIsVisible && SF_SpecialRound(SPECIALROUND_BOO) && GetVectorDistance(flTraceEndPos, flTraceStartPos) < SPECIALROUND_BOO_DISTANCE)
			TF2_StunPlayer(i, SPECIALROUND_BOO_DURATION, _, TF_STUNFLAGS_GHOSTSCARE);
		
		// FOV check.
		SubtractVectors(flTraceEndPos, flTraceStartPos, flBuffer);
		GetVectorAngles(flBuffer, flBuffer);
		
		if (FloatAbs(AngleDiff(flMyEyeAng[1], flBuffer[1])) <= (NPCGetFOV(iBossIndex) * 0.5))
		{
			bPlayerInFOV[i] = true;
		}

		float flPriorityValue;
		if (!SF_IsRaidMap() && !SF_BossesChaseEndlessly() && !SF_IsProxyMap() && !SF_IsBoxingMap())
		{
			flPriorityValue = g_iPageMax > 0 ? (float(g_iPlayerPageCount[i]) / float(g_iPageMax)) : 0.0;
		}
		
		if ((TF2_GetPlayerClass(i) == TFClass_Medic || g_bPlayerHasRegenerationItem[i]) && !SF_IsBoxingMap()) flPriorityValue += 0.72;
		
		flDist = GetVectorDistance(flTraceStartPos, flTraceEndPos);
		flPlayerDists[i] = flDist;
		
		//Trap check
		if (g_bPlayerTrapped[i] && GetVectorDistance(flTraceStartPos, flTraceEndPos) <= flSearchRange)
		{
			if (iState != STATE_CHASE && iState != STATE_ATTACK && iState != STATE_STUN)
			{
				bPlayerInTrap[i] = true;
				g_bNPCInAutoChase[iBossIndex] = true;
			}
		}
		
		if (g_bNPCAutoChaseEnabled[iBossIndex])
		{
			if (g_iSlenderAutoChaseCount[iBossIndex] >= GetProfileNum(sSlenderProfile,"auto_chase_count", 30) && iState != STATE_CHASE && iState != STATE_ATTACK && iState != STATE_STUN)
			{
				bPlayerMadeNoise[i] = true;
				g_bNPCInAutoChase[iBossIndex] = true;
			}
		}
		
		if (!g_bNPCRunningToHeal[iBossIndex] && !g_bNPCHealing[iBossIndex] && ((bPlayerNear[i]) && iState != STATE_CHASE && iState != STATE_ALERT) || (bIsVisible && bPlayerInFOV[i]))
		{
			float flTargetPos[3];
			GetClientAbsOrigin(i, flTargetPos);
			
			if (flDist <= flSearchRange && !g_bAutoChasingLoudPlayer[iBossIndex])
			{
				// Subtract distance to increase priority.
				flDist -= (flDist * flPriorityValue);
				
				if (flDist < flBestNewTargetDist)
				{
					iBestNewTarget = i;
					flBestNewTargetDist = flDist;
					g_iSlenderInterruptConditions[iBossIndex] |= COND_SAWENEMY;
				}
				
				g_flSlenderLastFoundPlayer[iBossIndex][i] = GetGameTime();
				g_flSlenderLastFoundPlayerPos[iBossIndex][i][0] = flTargetPos[0];
				g_flSlenderLastFoundPlayerPos[iBossIndex][i][1] = flTargetPos[1];
				g_flSlenderLastFoundPlayerPos[iBossIndex][i][2] = flTargetPos[2];
			}
		}
		if ((bPlayerMadeNoise[i] || bPlayerInTrap[i]) && iState != STATE_CHASE && iState != STATE_STUN && iState != STATE_ATTACK)
		{
			if (NPCHasAttribute(iBossIndex, "ignore non-marked for chase") && bPlayerMadeNoise[i])
			{
				iBestNewTarget = i;
				iState = STATE_CHASE;
				g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
				g_flSlenderTimeUntilAlert[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
				g_bSlenderGiveUp[iBossIndex] = false;
				g_iSlenderTarget[iBossIndex] = EntIndexToEntRef(iBestNewTarget);
				g_bAutoChasingLoudPlayer[iBossIndex] = true;
				g_iSlenderAutoChaseCount[iBossIndex] = 0;
			}
			else if (bPlayerInTrap[i] || (!NPCHasAttribute(iBossIndex, "ignore non-marked for chase") && bPlayerMadeNoise[i]))
			{
				iBestNewTarget = i;
				iState = STATE_CHASE;
				g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
				g_flSlenderTimeUntilAlert[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
				g_bSlenderGiveUp[iBossIndex] = false;
				g_iSlenderTarget[iBossIndex] = EntIndexToEntRef(iBestNewTarget);
				g_bAutoChasingLoudPlayer[iBossIndex] = false;
			}
		}
	}
	
	if (g_bAutoChasingLoudPlayer[iBossIndex])
	{
		if (iState != STATE_CHASE && iState != STATE_ATTACK && iState != STATE_STUN)
		{
			g_bAutoChasingLoudPlayer[iBossIndex] = false;
			g_iSlenderSoundTarget[iBossIndex] = INVALID_ENT_REFERENCE;
		}
	}
	
	bool bInFlashlight = false;
	
	// Check to see if someone is facing at us with flashlight on. Only if I'm facing them too. BLINDNESS!
	// Set to also be chase_upon_look.
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsTargetValidForSlender(i, bAttackEliminated)) continue;
	
		if (!IsClientUsingFlashlight(i) || !bPlayerInFOV[i]) continue;
		
		float flTraceStartPos[3], flTraceEndPos[3];
		GetClientEyePosition(i, flTraceStartPos);
		NPCGetEyePosition(iBossIndex, flTraceEndPos);
		
		if (GetVectorDistance(flTraceStartPos, flTraceEndPos) <= SF2_FLASHLIGHT_LENGTH)
		{
			float flEyeAng[3], flRequiredAng[3];
			GetClientEyeAngles(i, flEyeAng);
			SubtractVectors(flTraceEndPos, flTraceStartPos, flRequiredAng);
			GetVectorAngles(flRequiredAng, flRequiredAng);
			
			if ((FloatAbs(AngleDiff(flEyeAng[0], flRequiredAng[0])) + FloatAbs(AngleDiff(flEyeAng[1], flRequiredAng[1]))) <= 45.0)
			{
				Handle hTrace = TR_TraceRayFilterEx(flTraceStartPos,
					flTraceEndPos,
					MASK_PLAYERSOLID,
					RayType_EndPoint,
					TraceRayBossVisibility,
					slender);
					
				bool bDidHit = TR_DidHit(hTrace);
				delete hTrace;
				
				if (!bDidHit)
				{
					bInFlashlight = true;
					break;
				}
			}
		}
	}
	
	// Damage us if we're in a flashlight.
	if (bInFlashlight)
	{
		if (bStunEnabled)
		{
			if (NPCChaserIsStunByFlashlightEnabled(iBossIndex) && !(SF_SpecialRound(SPECIALROUND_NIGHTVISION)) && !(GetConVarBool(g_cvNightvisionEnabled)))
			{
				if (NPCChaserGetStunHealth(iBossIndex) > 0)
				{
					NPCChaserAddStunHealth(iBossIndex, -NPCChaserGetStunFlashlightDamage(iBossIndex));
				}
			}
		}
	}
	
	// Process the target that we should have.
	int iTarget = iOldTarget;
	
	/*
	if (IsValidEdict(iBestNewTarget))
	{
		iTarget = iBestNewTarget;
		g_iSlenderTarget[iBossIndex] = EntIndexToEntRef(iBestNewTarget);
	}
	*/
	
	if (iTarget && iTarget != INVALID_ENT_REFERENCE)
	{
		if (!IsTargetValidForSlender(iTarget, bAttackEliminated))
		{
			// Clear our target; he's not valid anymore.
			iOldTarget = iTarget;
			iTarget = INVALID_ENT_REFERENCE;
			g_iSlenderTarget[iBossIndex] = INVALID_ENT_REFERENCE;
		}
	}
	else
	{
		// Clear our target; he's not valid anymore.
		iOldTarget = iTarget;
		iTarget = INVALID_ENT_REFERENCE;
		g_iSlenderTarget[iBossIndex] = INVALID_ENT_REFERENCE;
	}
	
	//We should never give up, but sometimes it happens.
	if(g_bSlenderGiveUp[iBossIndex])
	{
		//Damit our target is unreachable for some unexplained reasons, haaaaaaaaaaaa!
		if (!SF_IsRaidMap() || !SF_BossesChaseEndlessly() || !SF_IsProxyMap() || !g_bNPCChasesEndlessly[iBossIndex] || !SF_IsBoxingMap())
		{
			iState = STATE_IDLE;
			g_bSlenderGiveUp[iBossIndex] = false;
		}
		
		if(SF_IsRaidMap() && !(NPCGetFlags(iBossIndex) & SFF_NOTELEPORT))
			//RemoveSlender(iBossIndex);
			g_bSlenderGiveUp[iBossIndex] = false;
		if(SF_IsProxyMap() && !(NPCGetFlags(iBossIndex) & SFF_NOTELEPORT))
			//RemoveSlender(iBossIndex);
			g_bSlenderGiveUp[iBossIndex] = false;
		if(SF_IsBoxingMap() && !(NPCGetFlags(iBossIndex) & SFF_NOTELEPORT))
			//RemoveSlender(iBossIndex);
			g_bSlenderGiveUp[iBossIndex] = false;
		if((SF_BossesChaseEndlessly() || g_bNPCChasesEndlessly[iBossIndex]) && !(NPCGetFlags(iBossIndex) & SFF_NOTELEPORT))
			//RemoveSlender(iBossIndex);
			//Do not, ok?
			g_bSlenderGiveUp[iBossIndex] = false;
	}
	
	int iInterruptConditions = g_iSlenderInterruptConditions[iBossIndex];
	bool bDoChasePersistencyInit = false;
	
	if((SF_IsRaidMap() || (SF_BossesChaseEndlessly() || g_bNPCChasesEndlessly[iBossIndex]) || SF_IsProxyMap() || SF_IsBoxingMap()) && !g_bSlenderGiveUp[iBossIndex] && !bBuilding && !g_bNPCRunningToHeal[iBossIndex] && !g_bNPCHealing[iBossIndex])
	{
		if(!IsValidClient(iTarget) || (IsValidClient(iTarget) && g_bPlayerEliminated[iTarget]))
		{
			if(iState != STATE_CHASE && iState != STATE_ATTACK && iState != STATE_STUN)
			{
				Handle hArrayRaidTargets = CreateArray();
					
				for (int i = 1; i <= MaxClients; i++)
				{
					if (!IsClientInGame(i) ||
						!IsPlayerAlive(i) ||
						g_bPlayerEliminated[i] ||
						IsClientInGhostMode(i) ||
						DidClientEscape(i))
					{
						continue;
					}
					PushArrayCell(hArrayRaidTargets, i);
				}
				if(GetArraySize(hArrayRaidTargets)>0)
				{
					int iRaidTarget = GetArrayCell(hArrayRaidTargets,GetRandomInt(0, GetArraySize(hArrayRaidTargets) - 1));
					if(IsValidClient(iRaidTarget) && !g_bPlayerEliminated[iRaidTarget])
					{
						iBestNewTarget = iRaidTarget;
						g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
						iState = STATE_CHASE;
						iTarget = iBestNewTarget;
					}
				}
				
				delete hArrayRaidTargets;
			}
		}
		
	}
	// Process which state we should be in.
	switch (iState)
	{
		case STATE_IDLE, STATE_WANDER:
		{
			for (int i = 0;i < MAX_NPCTELEPORTER;i++)
			{
				if (NPCChaserGetTeleporter(iBossIndex,i) != INVALID_ENT_REFERENCE)
					NPCChaserSetTeleporter(iBossIndex,i,INVALID_ENT_REFERENCE);
			}
			if (iState == STATE_WANDER)
			{
				if (!g_hBossChaserPathLogic[iBossIndex].IsPathValid())
				{
					iState = STATE_IDLE;
				}
			}
			else
			{
				if ((NPCGetFlags(iBossIndex) & SFF_WANDERMOVE) && GetGameTime() >= g_flSlenderNextWanderPos[iBossIndex] && GetRandomFloat(0.0, 1.0) <= 0.25)
				{
					iState = STATE_WANDER;
				}
			}
			if (SF_SpecialRound(SPECIALROUND_BEACON) || g_bRenevantBeaconEffect)
			{
				if(!g_bSlenderInBacon[iBossIndex])
				{
					iState = STATE_ALERT;
					g_flSlenderTimeUntilIdle[iBossIndex] = GetGameTime() + NPCChaserGetAlertDuration(iBossIndex, iDifficulty);
					g_bSlenderInBacon[iBossIndex] = true;
				}
			}
			if (iInterruptConditions & COND_SAWENEMY)
			{
				if (g_bNPCAutoChaseEnabled[iBossIndex])
				{
					g_iSlenderAutoChaseCount[iBossIndex]++;
				}
				// I saw someone over here. Automatically put me into alert mode.
				iState = STATE_ALERT;
				g_flSlenderTimeUntilIdle[iBossIndex] = GetGameTime() + NPCChaserGetAlertDuration(iBossIndex, iDifficulty);
			}
			else if (iInterruptConditions & COND_HEARDSUSPICIOUSSOUND)
			{
				// Sound counts:
				// +1 will be added if it hears a footstep.
				// +2 will be added if the footstep is someone sprinting.
				// +5 will be added if the sound is from a player's weapon hitting an object or flashlight is heard..
				// +10 will be added if a voice command.
				//
				// Sound counts will be reset after the boss hears a sound after a certain amount of time.
				// The purpose of sound counts is to induce boss focusing on sounds suspicious entities are making.
				
				int iCount = 0;
				if (iInterruptConditions & COND_HEARDFOOTSTEP) iCount += 1;
				if (iInterruptConditions & COND_HEARDFOOTSTEPLOUD) iCount += 2;
				if (iInterruptConditions & COND_HEARDWEAPON) iCount += 5;
				if (iInterruptConditions & COND_HEARDVOICE) iCount += 10;
				if (iInterruptConditions & COND_HEARDFLASHLIGHT) iCount += 5;
				
				bool bDiscardMasterPos = view_as<bool>(GetGameTime() >= g_flSlenderTargetSoundDiscardMasterPosTime[iBossIndex]);
				
				if (GetVectorDistance(g_flSlenderTargetSoundTempPos[iBossIndex], g_flSlenderTargetSoundMasterPos[iBossIndex]) <= GetProfileFloat(sSlenderProfile, "search_sound_pos_dist_tolerance", 512.0) ||
					bDiscardMasterPos)
				{
					if (bDiscardMasterPos) g_iSlenderTargetSoundCount[iBossIndex] = 0;
					
					g_flSlenderTargetSoundDiscardMasterPosTime[iBossIndex] = GetGameTime() + GetProfileFloat(sSlenderProfile, "search_sound_pos_discard_time", 2.0);
					g_flSlenderTargetSoundMasterPos[iBossIndex][0] = g_flSlenderTargetSoundTempPos[iBossIndex][0];
					g_flSlenderTargetSoundMasterPos[iBossIndex][1] = g_flSlenderTargetSoundTempPos[iBossIndex][1];
					g_flSlenderTargetSoundMasterPos[iBossIndex][2] = g_flSlenderTargetSoundTempPos[iBossIndex][2];
					g_iSlenderTargetSoundCount[iBossIndex] += iCount;
				}
				if (g_iSlenderTargetSoundCount[iBossIndex] >= GetProfileNum(sSlenderProfile, "search_sound_count_until_alert", 4))
				{
					// Someone's making some noise over there! Time to investigate.
					g_bSlenderInvestigatingSound[iBossIndex] = true; // This is just so that our sound position would be the goal position.
					iState = STATE_ALERT;
					g_flSlenderTimeUntilIdle[iBossIndex] = GetGameTime() + NPCChaserGetAlertDuration(iBossIndex, iDifficulty);
				}
			}
			if (g_flSlenderNextTrapPlacement[iBossIndex] <= GetGameTime() && NPCChaserGetTrapState(iBossIndex))
			{
				Trap_SpawnTrap(flMyPos, flMyEyeAng, iBossIndex);
				g_flSlenderNextTrapPlacement[iBossIndex] = GetGameTime()+NPCChaserGetTrapSpawnTime(iBossIndex, iDifficulty);
			}
		}
		case STATE_ALERT:
		{
			if (iState == STATE_ALERT)
			{
				if (!g_hBossChaserPathLogic[iBossIndex].IsPathValid() && g_flSlenderCalculatedWalkSpeed[iBossIndex] > 0.0)
				{
					iState = STATE_IDLE;
				}
			}
			if (GetGameTime() >= g_flSlenderTimeUntilIdle[iBossIndex] && !g_bNPCHealing[iBossIndex] && !g_bNPCRunningToHeal[iBossIndex])
			{
				iState = STATE_IDLE;
			}
			else if (IsValidClient(iBestNewTarget))
			{
				if (GetGameTime() >= g_flSlenderTimeUntilChase[iBossIndex] || bPlayerNear[iBestNewTarget])
				{
					float flTraceStartPos[3], flTraceEndPos[3];
					NPCGetEyePosition(iBossIndex, flTraceStartPos);
					
					if (IsValidClient(iBestNewTarget)) GetClientEyePosition(iBestNewTarget, flTraceEndPos);
					else
					{
						float flTargetMins[3], flTargetMaxs[3];
						GetEntPropVector(iBestNewTarget, Prop_Send, "m_vecMins", flTargetMins);
						GetEntPropVector(iBestNewTarget, Prop_Send, "m_vecMaxs", flTargetMaxs);
						GetEntPropVector(iBestNewTarget, Prop_Data, "m_vecAbsOrigin", flTraceEndPos);
						for (int i = 0; i < 3; i++) flTraceEndPos[i] += ((flTargetMins[i] + flTargetMaxs[i]) / 2.0);
					}
					
					Handle hTrace = TR_TraceHullFilterEx(flTraceStartPos,
						flTraceEndPos,
						flTraceMins,
						flTraceMaxs,
						MASK_NPCSOLID,
						TraceRayBossVisibility,
						slender);
						
					bool bIsVisible = !TR_DidHit(hTrace);
					int iTraceHitEntity = TR_GetEntityIndex(hTrace);
					delete hTrace;
					
					if (!bIsVisible && iTraceHitEntity == iBestNewTarget) bIsVisible = true;
					
					if ((bPlayerNear[iBestNewTarget] || bPlayerInFOV[iBestNewTarget]) && bPlayerVisible[iBestNewTarget])
					{
						// AHAHAHAH! I GOT YOU NOW!
						iTarget = iBestNewTarget;
						g_iSlenderTarget[iBossIndex] = EntIndexToEntRef(iBestNewTarget);
						iState = STATE_CHASE;
					}
				}
				if (bPlayerInTrap[iBestNewTarget] || bPlayerMadeNoise[iBestNewTarget])
				{
					// AHAHAHAH! I GOT YOU NOW!
					iTarget = iBestNewTarget;
					g_iSlenderTarget[iBossIndex] = EntIndexToEntRef(iBestNewTarget);
					iState = STATE_CHASE;
				}
			}
			if ((iTarget > MaxClients && bBuilding))
			{
				iState = STATE_CHASE;
			}
			else
			{
				if (iInterruptConditions & COND_SAWENEMY)
				{
					if (IsValidClient(iBestNewTarget))
					{
						g_flSlenderGoalPos[iBossIndex][0] = g_flSlenderLastFoundPlayerPos[iBossIndex][iBestNewTarget][0];
						g_flSlenderGoalPos[iBossIndex][1] = g_flSlenderLastFoundPlayerPos[iBossIndex][iBestNewTarget][1];
						g_flSlenderGoalPos[iBossIndex][2] = g_flSlenderLastFoundPlayerPos[iBossIndex][iBestNewTarget][2];
					}
				}
				else if (iInterruptConditions & COND_HEARDSUSPICIOUSSOUND)
				{
					bool bDiscardMasterPos = view_as<bool>(GetGameTime() >= g_flSlenderTargetSoundDiscardMasterPosTime[iBossIndex]);
					
					if (GetVectorDistance(g_flSlenderTargetSoundTempPos[iBossIndex], g_flSlenderTargetSoundMasterPos[iBossIndex]) <= GetProfileFloat(sSlenderProfile, "search_sound_pos_dist_tolerance", 512.0) ||
						bDiscardMasterPos)
					{
						g_flSlenderTargetSoundDiscardMasterPosTime[iBossIndex] = GetGameTime() + GetProfileFloat(sSlenderProfile, "search_sound_pos_discard_time", 2.0);
						g_flSlenderTargetSoundMasterPos[iBossIndex][0] = g_flSlenderTargetSoundTempPos[iBossIndex][0];
						g_flSlenderTargetSoundMasterPos[iBossIndex][1] = g_flSlenderTargetSoundTempPos[iBossIndex][1];
						g_flSlenderTargetSoundMasterPos[iBossIndex][2] = g_flSlenderTargetSoundTempPos[iBossIndex][2];
						
						// We have to manually set the goal position here because the goal position will not be changed due to no change in state.
						g_flSlenderGoalPos[iBossIndex][0] = g_flSlenderTargetSoundMasterPos[iBossIndex][0];
						g_flSlenderGoalPos[iBossIndex][1] = g_flSlenderTargetSoundMasterPos[iBossIndex][1];
						g_flSlenderGoalPos[iBossIndex][2] = g_flSlenderTargetSoundMasterPos[iBossIndex][2];
						
						g_bSlenderInvestigatingSound[iBossIndex] = true;
					}
				}
				
				for (int iAttackIndex = 0; iAttackIndex < NPCChaserGetAttackCount(iBossIndex); iAttackIndex++)
				{
					if (NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_Ranged || NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_Projectile || NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_LaserBeam) continue;
					
					bool bBlockingProp = false;
					
					if (NPCGetFlags(iBossIndex) & SFF_ATTACKPROPS)
					{
						bBlockingProp = NPC_CanAttackProps(iBossIndex,NPCChaserGetAttackRange(iBossIndex, iAttackIndex), NPCChaserGetAttackSpread(iBossIndex, iAttackIndex));
					}
					
					if (bBlockingProp)
					{
						iState = STATE_ATTACK;
						NPCSetCurrentAttackIndex(iBossIndex, iAttackIndex);
						break;
					}
				}
			}
			if (g_flSlenderNextTrapPlacement[iBossIndex] <= GetGameTime() && NPCChaserGetTrapState(iBossIndex))
			{
				Trap_SpawnTrap(flMyPos, flMyEyeAng, iBossIndex);
				g_flSlenderNextTrapPlacement[iBossIndex] = GetGameTime()+NPCChaserGetTrapSpawnTime(iBossIndex, iDifficulty);
			}
		}
		case STATE_CHASE, STATE_ATTACK, STATE_STUN:
		{
			if (iState == STATE_CHASE)
			{
				if (IsValidEdict(iTarget))
				{
					float flTraceStartPos[3], flTraceEndPos[3];
					NPCGetEyePosition(iBossIndex, flTraceStartPos);
					if(NPCChaserIsCloakEnabled(iBossIndex))
					{
						float flCloakDist = GetVectorDistance(g_flSlenderGoalPos[iBossIndex], flMyPos);
						float flCloakRange;
						flCloakRange = NPCChaserGetCloakRange(iBossIndex, iDifficulty);
						if (flCloakDist <= flCloakRange && !g_bNPCHasCloaked[iBossIndex] && g_flSlenderNextCloakTime[iBossIndex] <= GetGameTime() && !g_bNPCUsesChaseInitialAnimation[iBossIndex])
						{
							//Time for a more cloaking aproach!
							SetEntityRenderMode(slender, RENDER_TRANSCOLOR);
							if (!g_bSlenderIsJarate[iBossIndex]) SetEntityRenderColor(slender, 255, 255, 255, 0);
							else SetEntityRenderColor(slender, 255, 255, 128, 75);
							g_bNPCHasCloaked[iBossIndex] = true;
							GetProfileString(sSlenderProfile, "cloak_particle", sCloakParticle, sizeof(sCloakParticle));
							if(!sCloakParticle[0])
							{
								sCloakParticle = "drg_cow_explosioncore_charged_blue";
							}
							SlenderCreateParticle(iBossIndex, sCloakParticle, 35.0);
							if(!g_sSlenderCloakOnSound[iBossIndex][0])
							{
								g_sSlenderCloakOnSound[iBossIndex] = DEFAULT_CLOAKONSOUND;
							}
							EmitSoundToAll(g_sSlenderCloakOnSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
						}
					}
					
					if(NPCChaserIsProjectileEnabled(iBossIndex))
					{
						if (NPCGetFlags(iBossIndex) & SFF_FAKE)
						{
							SlenderMarkAsFake(iBossIndex);
						}
						if (g_flNPCProjectileCooldown[iBossIndex] <= GetGameTime() && !NPCChaserUseProjectileAmmo(iBossIndex) && bPlayerVisible[iTarget] && !g_bNPCUsesChaseInitialAnimation[iBossIndex] && bPlayerInFOV[iTarget] && !g_bNPCHasCloaked[iBossIndex])
						{
							NPCChaserProjectileShoot(iBossIndex, slender, iTarget, sSlenderProfile, flMyPos);
						}
						else if (NPCChaserUseProjectileAmmo(iBossIndex))
						{
							if (g_flNPCProjectileCooldown[iBossIndex] <= GetGameTime() && bPlayerVisible[iTarget] && !g_bNPCUsesChaseInitialAnimation[iBossIndex] && bPlayerInFOV[iTarget] && !g_bNPCHasCloaked[iBossIndex] && (g_iNPCProjectileAmmo[iBossIndex] != 0))
							{
								NPCChaserProjectileShoot(iBossIndex, slender, iTarget, sSlenderProfile, flMyPos);
								g_iNPCProjectileAmmo[iBossIndex] = g_iNPCProjectileAmmo[iBossIndex] - 1;
							}
							if (g_iNPCProjectileAmmo[iBossIndex] == 0 && !g_bNPCReloadingProjectiles[iBossIndex])
							{
								g_flNPCProjectileTimeToReload[iBossIndex] = GetGameTime() + NPCChaserGetProjectileReloadTime(iBossIndex, iDifficulty);
								g_bNPCReloadingProjectiles[iBossIndex] = true;
							}
							if (g_flNPCProjectileTimeToReload[iBossIndex] <= GetGameTime() && g_iNPCProjectileAmmo[iBossIndex] == 0)
							{
								g_iNPCProjectileAmmo[iBossIndex] = NPCChaserGetLoadedProjectiles(iBossIndex, iDifficulty);
								g_bNPCReloadingProjectiles[iBossIndex] = false;
							}
						}
					}
					
					if (IsValidClient(iTarget))
					{
						GetClientEyePosition(iTarget, flTraceEndPos);
					}
					else
					{
						float flTargetMins[3], flTargetMaxs[3];
						GetEntPropVector(iTarget, Prop_Send, "m_vecMins", flTargetMins);
						GetEntPropVector(iTarget, Prop_Send, "m_vecMaxs", flTargetMaxs);
						GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", flTraceEndPos);
						for (int i = 0; i < 3; i++) flTraceEndPos[i] += ((flTargetMins[i] + flTargetMaxs[i]) / 2.0);
					}
					
					bool bIsDeathPosVisible = false;
					
					if (g_bSlenderChaseDeathPosition[iBossIndex])
					{
						Handle hTrace = TR_TraceRayFilterEx(flTraceStartPos,
							g_flSlenderChaseDeathPosition[iBossIndex],
							MASK_NPCSOLID,
							RayType_EndPoint,
							TraceRayBossVisibility,
							slender);
						bIsDeathPosVisible = !TR_DidHit(hTrace);
						delete hTrace;
					}
					
					if (iTarget <= MaxClients && !bPlayerVisible[iTarget] && !g_bNPCRunningToHeal[iBossIndex] && !g_bNPCHealing[iBossIndex])
					{
						if (GetGameTime() >= g_flSlenderTimeUntilAlert[iBossIndex] || g_bPlayerEliminated[iTarget])
						{
							iState = STATE_ALERT;
							g_flSlenderTimeUntilIdle[iBossIndex] = GetGameTime() + NPCChaserGetAlertDuration(iBossIndex, iDifficulty);
							if (NPCHasAttribute(iBossIndex, "chase target on scare"))
							{
								g_bNPCLostChasingScareVictim[iBossIndex] = true;
								g_bNPCChasingScareVictin[iBossIndex] = false;
							}
							if (NPCHasAttribute(iBossIndex, "alert copies"))
							{
								g_hNPCResetAlertCopyTimer[iBossIndex] = CreateTimer(3.0, Timer_SlenderResetAlertCopy, EntIndexToEntRef(iBossIndex));
								g_bNPCStopAlertingCopies[iBossIndex] = false;
							}
							g_iSlenderAutoChaseCount[iBossIndex] = 0;
							g_bAutoChasingLoudPlayer[iBossIndex] = false;
							g_bNPCInAutoChase[iBossIndex] = false;
						}
						else if (bIsDeathPosVisible || g_bPlayerEliminated[iTarget])
						{
							iState = STATE_IDLE;
							if (NPCHasAttribute(iBossIndex, "chase target on scare"))
							{
								g_bNPCLostChasingScareVictim[iBossIndex] = true;
								g_bNPCChasingScareVictin[iBossIndex] = false;
							}
							if (NPCHasAttribute(iBossIndex, "alert copies"))
							{
								g_hNPCResetAlertCopyTimer[iBossIndex] = CreateTimer(3.0, Timer_SlenderResetAlertCopy, EntIndexToEntRef(iBossIndex));
								g_bNPCStopAlertingCopies[iBossIndex] = false;
							}
							g_iSlenderAutoChaseCount[iBossIndex] = 0;
							g_bAutoChasingLoudPlayer[iBossIndex] = false;
							g_bNPCInAutoChase[iBossIndex] = false;
						}
						GetClientAbsOrigin(iTarget, g_flSlenderGoalPos[iBossIndex]);
					}
					else if ((iTarget > MaxClients || bPlayerVisible[iTarget]) && !g_bNPCRunningToHeal[iBossIndex] && !g_bNPCHealing[iBossIndex])
					{
						g_bSlenderChaseDeathPosition[iBossIndex] = false;	// We're not chasing a dead player after all! Reset.
					
						float flAttackDirection[3];
						if (IsValidClient(iTarget))
							GetClientAbsOrigin(iTarget, g_flSlenderGoalPos[iBossIndex]);
						else
							GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", g_flSlenderGoalPos[iBossIndex]);
						SubtractVectors(g_flSlenderGoalPos[iBossIndex], flMyPos, flAttackDirection);
						GetVectorAngles(flAttackDirection, flAttackDirection);
						
						float flAttackBeginRangeEx, flAttackBeginFOVEx;
						
						float hullcheckmins[3], hullcheckmaxs[3];
						if (NPCGetRaidHitbox(iBossIndex) == 1)
						{
							hullcheckmins = g_flSlenderDetectMins[iBossIndex];
							hullcheckmaxs = g_flSlenderDetectMaxs[iBossIndex];
						}
						else if (NPCGetRaidHitbox(iBossIndex) == 0)
						{
							hullcheckmins = HULL_HUMAN_MINS;
							hullcheckmaxs = HULL_HUMAN_MAXS;
						}
						float flMyNewPos[3];
						flMyNewPos[0] += (flMyPos[0] + hullcheckmaxs[0]);
						flMyNewPos[1] = flMyPos[1];
						flMyNewPos[2] = flMyPos[2];
						
						float flDist = GetVectorDistance(g_flSlenderGoalPos[iBossIndex], flMyNewPos);
						float flFov = (FloatAbs(AngleDiff(flAttackDirection[0], flMyEyeAng[0])) + FloatAbs(AngleDiff(flAttackDirection[1], flMyEyeAng[1])));
						if (NPCGetFlags(iBossIndex) & SFF_RANDOMATTACKS)
						{
							int iRandomAttackIndex = GetRandomInt(0, NPCChaserGetAttackCount(iBossIndex));
							int[] iAttackArray2 = new int[SF2_CHASER_BOSS_MAX_ATTACKS];
							char sIndexes[16];
							flAttackBeginRangeEx = NPCChaserGetAttackBeginRange(iBossIndex, iRandomAttackIndex);
							flAttackBeginFOVEx = NPCChaserGetAttackBeginFOV(iBossIndex, iRandomAttackIndex);
							if (flDist <= flAttackBeginRangeEx && flFov <= (flAttackBeginFOVEx / 2.0) && NPCChaserGetNextAttackTime(iBossIndex,iRandomAttackIndex) <= GetGameTime() && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && !g_bNPCUseStartFleeAnimation[iBossIndex] && !g_bNPCRunningToHeal[iBossIndex] && !g_bNPCHealing[iBossIndex] && (iDifficulty >= GetProfileAttackNum(sSlenderProfile, "attack_use_on_difficulty", 0, iRandomAttackIndex+1)))
							{
								// ENOUGH TALK! HAVE AT YOU!
								iState = STATE_ATTACK;
								NPCSetCurrentAttackIndex(iBossIndex, iRandomAttackIndex);
							}
							else if (iDifficulty < GetProfileAttackNum(sSlenderProfile, "attack_use_on_difficulty", 0, iRandomAttackIndex+1) || NPCChaserGetNextAttackTime(iBossIndex,iRandomAttackIndex) > GetGameTime())
							{
								for (int iAttackIndex2 = 0; iAttackIndex2 < NPCChaserGetAttackCount(iBossIndex); iAttackIndex2++)
								{
									if (iDifficulty >= GetProfileAttackNum(sSlenderProfile, "attack_use_on_difficulty", 0, iAttackIndex2+1) && NPCChaserGetNextAttackTime(iBossIndex,iRandomAttackIndex) <= GetGameTime())
									{
										iAttackArray2[iAttackIndex2] = iAttackIndex2;
										IntToString(iAttackIndex2, sIndexes, sizeof(sIndexes));
									}
								}
								int iNewRandomAttackIndex = GetRandomInt(0, StringToInt(sIndexes));
								flAttackBeginRangeEx = NPCChaserGetAttackBeginRange(iBossIndex, iAttackArray2[iNewRandomAttackIndex]);
								flAttackBeginFOVEx = NPCChaserGetAttackBeginFOV(iBossIndex, iAttackArray2[iNewRandomAttackIndex]);
								if (flDist <= flAttackBeginRangeEx && flFov <= (flAttackBeginFOVEx / 2.0) && NPCChaserGetNextAttackTime(iBossIndex,iAttackArray2[iNewRandomAttackIndex]) <= GetGameTime() && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && !g_bNPCUseStartFleeAnimation[iBossIndex] && !g_bNPCRunningToHeal[iBossIndex] && !g_bNPCHealing[iBossIndex])
								{
									// ENOUGH TALK! HAVE AT YOU!
									iState = STATE_ATTACK;
									NPCSetCurrentAttackIndex(iBossIndex, iAttackArray2[iNewRandomAttackIndex]);
								}
							}
						}
						else
						{
							for (int iAttackIndex = 0; iAttackIndex < NPCChaserGetAttackCount(iBossIndex); iAttackIndex++)
							{
								int[] iAttackArray2 = new int[SF2_CHASER_BOSS_MAX_ATTACKS];
								char sIndexes[16];
								flAttackBeginRangeEx = NPCChaserGetAttackBeginRange(iBossIndex, iAttackIndex);
								if (NPCGetRaidHitbox(iBossIndex) == 1 && flAttackBeginRangeEx != 0.0)
								{
									flAttackBeginRangeEx += g_flSlenderDetectMaxs[iBossIndex][0];
								}
								else if (NPCGetRaidHitbox(iBossIndex) == 0 && flAttackBeginRangeEx != 0.0)
								{
									flAttackBeginRangeEx += 13.0;
								}
								flAttackBeginFOVEx = NPCChaserGetAttackBeginFOV(iBossIndex, iAttackIndex);
								if (flDist <= flAttackBeginRangeEx && flFov <= (flAttackBeginFOVEx / 2.0) && NPCChaserGetNextAttackTime(iBossIndex,iAttackIndex) <= GetGameTime() && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && !g_bNPCUseStartFleeAnimation[iBossIndex] && !g_bNPCRunningToHeal[iBossIndex] && !g_bNPCHealing[iBossIndex] && (iDifficulty >= GetProfileAttackNum(sSlenderProfile, "attack_use_on_difficulty", 0, iAttackIndex+1)))
								{
									// ENOUGH TALK! HAVE AT YOU!
									iState = STATE_ATTACK;
									NPCSetCurrentAttackIndex(iBossIndex, iAttackIndex);
									break;
								}
								else if (iDifficulty < GetProfileAttackNum(sSlenderProfile, "attack_use_on_difficulty", 0, iAttackIndex+1) || NPCChaserGetNextAttackTime(iBossIndex,iAttackIndex) > GetGameTime())
								{
									for (int iAttackIndex2 = 0; iAttackIndex2 < NPCChaserGetAttackCount(iBossIndex); iAttackIndex2++)
									{
										if (iDifficulty >= GetProfileAttackNum(sSlenderProfile, "attack_use_on_difficulty", 0, iAttackIndex2+1) && NPCChaserGetNextAttackTime(iBossIndex,iAttackIndex) <= GetGameTime())
										{
											iAttackArray2[iAttackIndex2] = iAttackIndex2;
											IntToString(iAttackIndex2, sIndexes, sizeof(sIndexes));
										}
									}
									int iNewRandomAttackIndex = GetRandomInt(0, StringToInt(sIndexes));
									flAttackBeginRangeEx = NPCChaserGetAttackBeginRange(iBossIndex, iAttackArray2[iNewRandomAttackIndex]);
									flAttackBeginFOVEx = NPCChaserGetAttackBeginFOV(iBossIndex, iAttackArray2[iNewRandomAttackIndex]);
									if (flDist <= flAttackBeginRangeEx && flFov <= (flAttackBeginFOVEx / 2.0) && NPCChaserGetNextAttackTime(iBossIndex,iAttackArray2[iNewRandomAttackIndex]) <= GetGameTime() && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && !g_bNPCUseStartFleeAnimation[iBossIndex] && !g_bNPCRunningToHeal[iBossIndex] && !g_bNPCHealing[iBossIndex])
									{
										// ENOUGH TALK! HAVE AT YOU!
										iState = STATE_ATTACK;
										NPCSetCurrentAttackIndex(iBossIndex, iAttackArray2[iNewRandomAttackIndex]);
										break; //Break it.
									}
								}
							}
						}
					}
					if (iState == STATE_CHASE)
					{
						for (int iAttackIndex = 0; iAttackIndex < NPCChaserGetAttackCount(iBossIndex); iAttackIndex++)
						{
							if (NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_Ranged || NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_Projectile || NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_LaserBeam) continue;
							
							bool bBlockingProp = false;
							
							if (NPCGetFlags(iBossIndex) & SFF_ATTACKPROPS)
							{
								bBlockingProp = NPC_CanAttackProps(iBossIndex,NPCChaserGetAttackRange(iBossIndex, iAttackIndex), NPCChaserGetAttackSpread(iBossIndex, iAttackIndex));
							}
							
							if (bBlockingProp)
							{
								iState = STATE_ATTACK;
								NPCSetCurrentAttackIndex(iBossIndex, iAttackIndex);
								break;
							}
						}
					}
				}
				if (!IsValidEdict(iTarget) || (0 < iTarget <= MaxClients && DidClientEscape(iTarget)) && !g_bNPCRunningToHeal[iBossIndex] && !g_bNPCHealing[iBossIndex] && !g_bNPCUseStartFleeAnimation[iBossIndex])
				{
					if (g_hBossFailSafeTimer[iBossIndex] == INVALID_HANDLE)
						g_hBossFailSafeTimer[iBossIndex] = CreateTimer(1.0, Timer_DeathPosChaseStop, iBossIndex); //Setup a fail safe timer in case we can't finish our path.
					// Even if the target isn't valid anymore, see if I still have some ways to go on my current path,
					// because I shouldn't actually know that the target has died until I see it.
					if (!g_hBossChaserPathLogic[iBossIndex].IsPathValid())
					{
						iState = STATE_IDLE;
					}
				}
			}
			else if (iState == STATE_ATTACK)
			{
				if (!g_bSlenderAttacking[iBossIndex] || (g_flSlenderTimeUntilAttackEnd[iBossIndex] != -1.0 && g_flSlenderTimeUntilAttackEnd[iBossIndex] <= GetGameTime()))
				{
					if (g_flLastStuckTime[iBossIndex] != 0.0) g_flLastStuckTime[iBossIndex] = GetGameTime();
					g_flSlenderTimeUntilAttackEnd[iBossIndex] = -1.0;
					if (IsValidClient(iTarget))
					{
						g_bSlenderChaseDeathPosition[iBossIndex] = false;
						
						// Chase him again!
						g_bSlenderGiveUp[iBossIndex] = false;
						g_bSlenderAttacking[iBossIndex] = false;
						g_bNPCStealingLife[iBossIndex] = false;
						g_hSlenderAttackTimer[iBossIndex] = INVALID_HANDLE;
						g_hNPCLifeStealTimer[iBossIndex] = INVALID_HANDLE;
						g_hSlenderBackupAtkTimer[iBossIndex] = INVALID_HANDLE;
						g_bNPCAlreadyAttacked[iBossIndex] = false;
						g_bNPCUseFireAnimation[iBossIndex] = false;
						iState = STATE_CHASE;
					}
					else
					{
						// Target isn't valid anymore. We killed him, Mac!
						iState = STATE_ALERT;
						g_flSlenderTimeUntilIdle[iBossIndex] = GetGameTime() + NPCChaserGetAlertDuration(iBossIndex, iDifficulty);
						g_bSlenderAttacking[iBossIndex] = false;
						g_bNPCStealingLife[iBossIndex] = false;
						g_hSlenderAttackTimer[iBossIndex] = INVALID_HANDLE;
						g_hNPCLifeStealTimer[iBossIndex] = INVALID_HANDLE;
						g_hSlenderBackupAtkTimer[iBossIndex] = INVALID_HANDLE;
						g_bNPCAlreadyAttacked[iBossIndex] = false;
						g_bNPCUseFireAnimation[iBossIndex] = false;
						if (NPCHasAttribute(iBossIndex, "chase target on scare"))
						{
							g_bNPCLostChasingScareVictim[iBossIndex] = true;
							g_bNPCChasingScareVictin[iBossIndex] = false;
						}
						if (NPCHasAttribute(iBossIndex, "alert copies"))
						{
							g_hNPCResetAlertCopyTimer[iBossIndex] = CreateTimer(3.0, Timer_SlenderResetAlertCopy, EntIndexToEntRef(iBossIndex));
							g_bNPCStopAlertingCopies[iBossIndex] = false;
						}
					}
				}
			}
			else if (iState == STATE_STUN)
			{
				if (GetGameTime() >= g_flSlenderTimeUntilRecover[iBossIndex])
				{
					if (view_as<bool>(GetProfileNum(sSlenderProfile,"disappear_on_stun",0)))
					{
						RemoveSlender(iBossIndex);
					}
					if(NPCHasAttribute(iBossIndex, "add stun health on stun"))
					{
						float flValue = NPCGetAttributeValue(iBossIndex, "add stun health on stun");
						NPCChaserSetStunHealth(iBossIndex, NPCChaserGetStunInitialHealth(iBossIndex));
						NPCChaserSetAddStunHealth(iBossIndex, flValue);
						if (flValue > 0.0)
						{
							NPCChaserAddStunHealth(iBossIndex, NPCChaserGetAddStunHealth(iBossIndex));
						}
					}
					else
					{
						NPCChaserSetStunHealth(iBossIndex, NPCChaserGetStunInitialHealth(iBossIndex));
					}
					if(NPCHasAttribute(iBossIndex, "add speed on stun"))
					{
						float flValue = NPCGetAttributeValue(iBossIndex, "add speed on stun");
						if (flValue > 0.0)
						{
							NPCSetAddSpeed(iBossIndex, flValue);
						}
					}
					if(NPCHasAttribute(iBossIndex, "add max speed on stun"))
					{
						float flValue = NPCGetAttributeValue(iBossIndex, "add max speed on stun");
						if (flValue > 0.0)
						{
							NPCSetAddMaxSpeed(iBossIndex, flValue);
						}
					}
					g_flSlenderNextStunTime[iBossIndex] = GetGameTime()+NPCChaserGetStunCooldown(iBossIndex);
					if (IsValidClient(iTarget))
					{
						// Chase him again!
						iState = STATE_CHASE;
					}
					else
					{
						// WHAT DA FUUUUUUUUUUUQ. TARGET ISN'T VALID. AUSDHASUIHD
						iState = STATE_ALERT;
						g_flSlenderTimeUntilIdle[iBossIndex] = GetGameTime() + NPCChaserGetAlertDuration(iBossIndex, iDifficulty);
						if (NPCHasAttribute(iBossIndex, "chase target on scare"))
						{
							g_bNPCLostChasingScareVictim[iBossIndex] = true;
							g_bNPCChasingScareVictin[iBossIndex] = false;
						}
						if (NPCHasAttribute(iBossIndex, "alert copies"))
						{
							g_hNPCResetAlertCopyTimer[iBossIndex] = CreateTimer(3.0, Timer_SlenderResetAlertCopy, EntIndexToEntRef(iBossIndex));
							g_bNPCStopAlertingCopies[iBossIndex] = false;
						}
					}
				}
			}
		}
	}
	
	if (iState != STATE_STUN)
	{
		if (bStunEnabled)
		{
			if (NPCChaserGetStunHealth(iBossIndex) <= 0 && g_flSlenderNextStunTime[iBossIndex] <= GetGameTime())
			{
				if (iState != STATE_CHASE && iState != STATE_ATTACK)
				{
					// Sometimes players can stun the boss while it's not in chase mode. If that happens, we
					// need to set the persistency value to the chase initial value.
					bDoChasePersistencyInit = true;
				}
				iState = STATE_STUN;
				if (NPCChaseHasKeyDrop(iBossIndex))
				{
					if (SF_IsBoxingMap())
					{
						g_iSlenderBoxingBossKilled += 1;
						if ((g_iSlenderBoxingBossKilled == g_iSlenderBoxingBossCount) && !g_bSlenderBoxingBossIsKilled[iBossIndex]) NPC_DropKey(iBossIndex);
						g_bSlenderBoxingBossIsKilled[iBossIndex] = true;
					}
					else NPC_DropKey(iBossIndex);
				}
				g_bNPCUsesChaseInitialAnimation[iBossIndex] = false;
				g_bNPCUsesHealAnimation[iBossIndex] = false;
				g_bNPCUseStartFleeAnimation[iBossIndex] = false;
				g_bNPCHealing[iBossIndex] = false;
				g_bNPCRunningToHeal[iBossIndex] = false;
				if (SF_IsBoxingMap() && view_as<bool>(GetProfileNum(sSlenderProfile,"boxing_boss",0)))
				{
					for(int client = 1;client <=MaxClients;client ++)
					{
						if(IsValidClient(client) && !g_bPlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
						{
							char sPlayer[32];
							GetClientName(client, sPlayer, sizeof(sPlayer));
							char sBossName[SF2_MAX_NAME_LENGTH];
							GetProfileString(sSlenderProfile, "name", sBossName, sizeof(sBossName));
							if (!sBossName[0]) strcopy(sBossName, sizeof(sBossName), sSlenderProfile);
							CPrintToChatAll("{royalblue}%t{default}%t", "SF2 Prefix", "SF2 Boxing Win Message", sPlayer, sBossName);	
						}
					}
				}
			}
			if (SF_IsBoxingMap() && view_as<bool>(GetProfileNum(sSlenderProfile,"boxing_boss",0)))
			{
				if (!NPCChaserGetSelfHealState(iBossIndex))
				{
					float flPercent = NPCChaserGetStunInitialHealth(iBossIndex) > 0 ? (NPCChaserGetStunHealth(iBossIndex) / NPCChaserGetStunInitialHealth(iBossIndex)) : 0.0;
					if (flPercent < 0.75 && flPercent >= 0.5 && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsedRage1[iBossIndex])
					{
						if (iDifficulty != 2 && iDifficulty < 2)
						{
							SetConVarInt(g_cvDifficulty, Difficulty_Hard);
							CPrintToChatAll("The difficulty has been set to {orange}%t{default}.", "SF2 Hard Difficulty");
							for(int client = 1;client <=MaxClients;client ++)
							{
								if(IsValidClient(client) && !g_bPlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
								{
									TF2_AddCondition(client, TFCond_CritCola, 5.0 + GetProfileFloat(sSlenderProfile, "rage_timer", 0.0));
									EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
								}
							}
						}
						SlenderPerformVoice(iBossIndex, "sound_rage");
						NPCSetAddSpeed(iBossIndex, 12.5);
						NPCSetAddMaxSpeed(iBossIndex, 25.0);
						if(view_as<bool>(GetProfileNum(sSlenderProfile,"normal_sound_hook",0)))
						{
							char sRageSoundPath[PLATFORM_MAX_PATH];
							GetRandomStringFromProfile(sSlenderProfile, "sound_rage", sRageSoundPath, sizeof(sRageSoundPath));
							if (sRageSoundPath[0])
							{
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_alertofenemy", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chasingenemy", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_2", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_3", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_4", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_5", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_6", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_7", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_8", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_9", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_idle", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chaseenemyinitial", SNDCHAN_AUTO);
							}
						}
						g_bNPCUsedRage1[iBossIndex] = true;
						g_bNPCUsesRageAnimation1[iBossIndex] = true;
						flSpeed *= 0.0;
						NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
						g_hSlenderRage1Timer[iBossIndex] = CreateTimer(GetProfileFloat(sSlenderProfile, "rage_timer", 0.0), Timer_SlenderRageOneTimer, EntIndexToEntRef(slender));
						int ent = -1;
						while ((ent = FindEntityByClassname(ent, "logic_relay")) != -1)
						{
							char sName[64];
							GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
							if (StrEqual(sName, "sf2_logic_boss_rage_one", false))
							{
								AcceptEntityInput(ent, "Trigger");
								break;
							}
						}
						if (g_bSlenderAttacking[iBossIndex])
						{
							// Cancel attacking.
							g_bSlenderAttacking[iBossIndex] = false;
							g_bNPCStealingLife[iBossIndex] = false;
							g_hSlenderAttackTimer[iBossIndex] = INVALID_HANDLE;
							g_hNPCLifeStealTimer[iBossIndex] = INVALID_HANDLE;
							g_hSlenderBackupAtkTimer[iBossIndex] = INVALID_HANDLE;
							g_bNPCAlreadyAttacked[iBossIndex] = false;
							g_bNPCUseFireAnimation[iBossIndex] = false;
						}
					}
					else if (flPercent < 0.5 && flPercent >= 0.25 && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsedRage2[iBossIndex])
					{
						if (iDifficulty != 3 && iDifficulty < 3)
						{
							SetConVarInt(g_cvDifficulty, Difficulty_Insane);
							CPrintToChatAll("The difficulty has been set to {red}%t{default}.", "SF2 Insane Difficulty");
							for(int client = 1;client <=MaxClients;client ++)
							{
								if(IsValidClient(client) && !g_bPlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
								{
									int iBuff = GetRandomInt(1, 3);
									switch (iBuff)
									{
										case 1:
										{
											TF2_AddCondition(client, TFCond_CritCola, 5.0 + GetProfileFloat(sSlenderProfile, "rage_timer", 0.0));
											EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
										}
										case 2:
										{
											TF2_AddCondition(client, TFCond_HalloweenQuickHeal, 5.0 + GetProfileFloat(sSlenderProfile, "rage_timer", 0.0));
											EmitSoundToClient(client, UBER_ROLL, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
										}
										case 3:
										{
											TF2_AddCondition(client, TFCond_DefenseBuffed, 5.0 + GetProfileFloat(sSlenderProfile, "rage_timer", 0.0));
											EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
										}
									}
								}
							}
						}
						char sRageSound2Path[PLATFORM_MAX_PATH];
						GetRandomStringFromProfile(sSlenderProfile, "sound_rage_2", sRageSound2Path, sizeof(sRageSound2Path));
						if (sRageSound2Path[0]) SlenderPerformVoice(iBossIndex, "sound_rage_2");
						else SlenderPerformVoice(iBossIndex, "sound_rage");
						NPCSetAddSpeed(iBossIndex, 12.5);
						NPCSetAddMaxSpeed(iBossIndex, 25.0);
						if(view_as<bool>(GetProfileNum(sSlenderProfile,"normal_sound_hook",0)))
						{
							char sRageSoundPath[PLATFORM_MAX_PATH];
							GetRandomStringFromProfile(sSlenderProfile, "sound_rage", sRageSoundPath, sizeof(sRageSoundPath));
							if (sRageSoundPath[0])
							{
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_alertofenemy", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chasingenemy", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_2", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_3", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_4", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_5", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_6", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_7", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_8", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_9", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_idle", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chaseenemyinitial", SNDCHAN_AUTO);
							}
						}
						g_bNPCUsedRage2[iBossIndex] = true;
						g_bNPCUsesRageAnimation2[iBossIndex] = true;
						flSpeed *= 0.0;
						NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
						g_hSlenderRage2Timer[iBossIndex] = CreateTimer(GetProfileFloat(sSlenderProfile, "rage_timer", 0.0), Timer_SlenderRageTwoTimer, EntIndexToEntRef(slender));
						int ent = -1;
						while ((ent = FindEntityByClassname(ent, "logic_relay")) != -1)
						{
							char sName[64];
							GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
							if (StrEqual(sName, "sf2_logic_boss_rage_two", false))
							{
								AcceptEntityInput(ent, "Trigger");
								break;
							}
						}
						if (g_bSlenderAttacking[iBossIndex])
						{
							// Cancel attacking.
							g_bSlenderAttacking[iBossIndex] = false;
							g_bNPCStealingLife[iBossIndex] = false;
							g_hSlenderAttackTimer[iBossIndex] = INVALID_HANDLE;
							g_hNPCLifeStealTimer[iBossIndex] = INVALID_HANDLE;
							g_hSlenderBackupAtkTimer[iBossIndex] = INVALID_HANDLE;
							g_bNPCAlreadyAttacked[iBossIndex] = false;
							g_bNPCUseFireAnimation[iBossIndex] = false;
						}
					}
					else if (flPercent < 0.25 && !g_bNPCUsesRageAnimation3[iBossIndex] && !g_bNPCUsedRage3[iBossIndex])
					{
						if (iDifficulty != 4 && iDifficulty < 4)
						{
							SetConVarInt(g_cvDifficulty, Difficulty_Nightmare);
							CPrintToChatAll("The difficulty has been set to {valve}Nightmare{default}.");
							for(int client = 1;client <=MaxClients;client ++)
							{
								if(IsValidClient(client) && !g_bPlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
								{
									int iBuff = GetRandomInt(1, 4);
									switch (iBuff)
									{
										case 1:
										{
											TF2_AddCondition(client, TFCond_CritOnFirstBlood, 5.0 + GetProfileFloat(sSlenderProfile, "rage_timer", 0.0));
											EmitSoundToClient(client, CRIT_ROLL, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
										}
										case 2:
										{
											TF2_AddCondition(client, TFCond_HalloweenQuickHeal, 5.0 + GetProfileFloat(sSlenderProfile, "rage_timer", 0.0));
											EmitSoundToClient(client, UBER_ROLL, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
										}
										case 3:
										{
											TF2_AddCondition(client, TFCond_DefenseBuffed, 8.0 + GetProfileFloat(sSlenderProfile, "rage_timer", 0.0));
											EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
										}
										case 4:
										{
											TF2_RegeneratePlayer(client);
										}
									}
								}
							}
						}
						char sRageSound3Path[PLATFORM_MAX_PATH];
						GetRandomStringFromProfile(sSlenderProfile, "sound_rage_3", sRageSound3Path, sizeof(sRageSound3Path));
						if (sRageSound3Path[0]) SlenderPerformVoice(iBossIndex, "sound_rage_3");
						else SlenderPerformVoice(iBossIndex, "sound_rage");
						NPCSetAddSpeed(iBossIndex, 12.5);
						NPCSetAddMaxSpeed(iBossIndex, 25.0);
						if(view_as<bool>(GetProfileNum(sSlenderProfile,"normal_sound_hook",0)))
						{
							char sRageSoundPath[PLATFORM_MAX_PATH];
							GetRandomStringFromProfile(sSlenderProfile, "sound_rage", sRageSoundPath, sizeof(sRageSoundPath));
							if (sRageSoundPath[0])
							{
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_alertofenemy", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chasingenemy", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_2", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_3", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_4", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_5", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_6", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_7", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_8", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_9", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_idle", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chaseenemyinitial", SNDCHAN_AUTO);
							}
						}
						g_bNPCUsedRage3[iBossIndex] = true;
						g_bNPCUsesRageAnimation3[iBossIndex] = true;
						flSpeed *= 0.0;
						NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
						g_hSlenderRage3Timer[iBossIndex] = CreateTimer(GetProfileFloat(sSlenderProfile, "rage_timer", 0.0), Timer_SlenderRageThreeTimer, EntIndexToEntRef(slender));
						int ent = -1;
						while ((ent = FindEntityByClassname(ent, "logic_relay")) != -1)
						{
							char sName[64];
							GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
							if (StrEqual(sName, "sf2_logic_boss_rage_three", false))
							{
								AcceptEntityInput(ent, "Trigger");
								break;
							}
						}
						if (g_bSlenderAttacking[iBossIndex])
						{
							// Cancel attacking.
							g_bSlenderAttacking[iBossIndex] = false;
							g_bNPCStealingLife[iBossIndex] = false;
							g_hSlenderAttackTimer[iBossIndex] = INVALID_HANDLE;
							g_hNPCLifeStealTimer[iBossIndex] = INVALID_HANDLE;
							g_hSlenderBackupAtkTimer[iBossIndex] = INVALID_HANDLE;
							g_bNPCAlreadyAttacked[iBossIndex] = false;
							g_bNPCUseFireAnimation[iBossIndex] = false;
						}
					}
				}
				else
				{
					float flPercent = NPCChaserGetStunInitialHealth(iBossIndex) > 0 ? (NPCChaserGetStunHealth(iBossIndex) / NPCChaserGetStunInitialHealth(iBossIndex)) : 0.0;
					if (flPercent < NPCChaserGetStartSelfHealPercentage(iBossIndex) && g_iNPCSelfHealStage[iBossIndex] < 3)
					{
						if (g_bNPCRunningToHeal[iBossIndex] || g_bNPCHealing[iBossIndex])
						{
							iOldTarget = iTarget;
							iTarget = INVALID_ENT_REFERENCE;
							g_iSlenderTarget[iBossIndex] = INVALID_ENT_REFERENCE;
						}
						float flDelayTimer1 = GetProfileFloat(sSlenderProfile, "flee_delay_time", 0.0);
						float flDelayTimer2 = GetProfileFloat(sSlenderProfile, "flee_delay_time_two", flDelayTimer1);
						float flDelayTimer3 = GetProfileFloat(sSlenderProfile, "flee_delay_time_three", flDelayTimer2);
						if (g_bNPCRunningToHeal[iBossIndex] && !g_bNPCSetHealDestination[iBossIndex] && !g_bNPCHealing[iBossIndex])
						{
							float flMin = GetProfileFloat(sSlenderProfile, "heal_time_min", 3.0);
							float flMax = GetProfileFloat(sSlenderProfile, "heal_time_max", 4.5);
							g_flNPCFleeHealTimer[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);

							// We're allowed to move in wander mode. Get a new wandering position and create a path to follow.
							// If the position can't be reached, then just get to the closest area that we can get.
							float flWanderRangeMin = GetProfileFloat(sSlenderProfile, "heal_range_min", 600.0);
							float flWanderRangeMax = GetProfileFloat(sSlenderProfile, "heal_range_max", 1200.0);
							float flWanderRange = GetRandomFloat(flWanderRangeMin, flWanderRangeMax);
								
							float flFleePos[3];
							flFleePos[0] = 0.0;
							flFleePos[1] = GetRandomFloat(0.0, 360.0);
							flFleePos[2] = 0.0;
								
							GetAngleVectors(flFleePos, flFleePos, NULL_VECTOR, NULL_VECTOR);
							NormalizeVector(flFleePos, flFleePos);
							ScaleVector(flFleePos, flWanderRange);
							AddVectors(flFleePos, flMyPos, flFleePos);
								
							g_flSlenderGoalPos[iBossIndex][0] = flFleePos[0];
							g_flSlenderGoalPos[iBossIndex][1] = flFleePos[1];
							g_flSlenderGoalPos[iBossIndex][2] = flFleePos[2];
							
							if (!g_bNPCHasCloaked[iBossIndex] && !g_bNPCUsesChaseInitialAnimation[iBossIndex] && NPCChaserIsCloakEnabled(iBossIndex) && view_as<bool>(GetProfileNum(sSlenderProfile,"cloak_to_heal",0)))
							{
								//Time for a more cloaking aproach!
								SetEntityRenderMode(slender, RENDER_TRANSCOLOR);
								if (!g_bSlenderIsJarate[iBossIndex]) SetEntityRenderColor(slender, 255, 255, 255, 0);
								else SetEntityRenderColor(slender, 255, 255, 128, 75);
								g_bNPCHasCloaked[iBossIndex] = true;
								GetProfileString(sSlenderProfile, "cloak_particle", sCloakParticle, sizeof(sCloakParticle));
								if(!sCloakParticle[0])
								{
									sCloakParticle = "drg_cow_explosioncore_charged_blue";
								}
								SlenderCreateParticle(iBossIndex, sCloakParticle, 35.0);
								if(!g_sSlenderCloakOnSound[iBossIndex][0])
								{
									g_sSlenderCloakOnSound[iBossIndex] = DEFAULT_CLOAKONSOUND;
								}
								EmitSoundToAll(g_sSlenderCloakOnSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							}
							
							g_bNPCSetHealDestination[iBossIndex] = true;
						}
						if ((GetVectorDistance(g_flSlenderGoalPos[iBossIndex], flMyPos) < 125.0 || g_flNPCFleeHealTimer[iBossIndex] < GetGameTime()) && g_bNPCSetHealDestination[iBossIndex] && !g_bNPCHealing[iBossIndex])
						{
							if(g_bNPCHasCloaked[iBossIndex] && NPCChaserIsCloakEnabled(iBossIndex))
							{
								char sSlenderModel[PLATFORM_MAX_PATH];
								GetEntPropString(slender, Prop_Data, "m_ModelName", sSlenderModel, sizeof(sSlenderModel));

								SetEntityRenderMode(slender, RENDER_NORMAL);
								if (!g_bSlenderIsJarate[iBossIndex]) SetEntityRenderColor(slender, 255, 255, 255, 255);
								else SetEntityRenderColor(slender, 255, 255, 128, 255);

								g_bNPCHasCloaked[iBossIndex] = false;
								GetProfileString(sSlenderProfile, "cloak_particle", sCloakParticle, sizeof(sCloakParticle));
								if(!sCloakParticle[0])
								{
									sCloakParticle = "drg_cow_explosioncore_charged_blue";
								}
								SlenderCreateParticle(iBossIndex, sCloakParticle, 35.0);
								if(!g_sSlenderCloakOffSound[iBossIndex][0])
								{
									g_sSlenderCloakOffSound[iBossIndex] = DEFAULT_CLOAKOFFSOUND;
								}
								EmitSoundToAll(g_sSlenderCloakOffSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
								g_flSlenderNextCloakTime[iBossIndex] = GetGameTime()+NPCChaserGetCloakCooldown(iBossIndex, iDifficulty);
							}
							float flTimer = GetProfileFloat(sSlenderProfile, "heal_timer_animation", 0.0);
							g_iNPCHealCount[iBossIndex] = 0;
							g_bNPCUsesHealAnimation[iBossIndex] = true;
							g_bNPCRunningToHeal[iBossIndex] = false;
							flSpeed *= 0.0;
							g_hSlenderHealTimer[iBossIndex] = CreateTimer(flTimer, Timer_SlenderHealAnimationTimer, EntIndexToEntRef(slender));
							g_hSlenderHealDelayTimer[iBossIndex] = CreateTimer(GetProfileFloat(sSlenderProfile, "heal_timer", flTimer), Timer_SlenderHealDelayTimer, EntIndexToEntRef(slender));
							g_bNPCHealing[iBossIndex] = true;
							NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
						}
						if (!g_bNPCUseStartFleeAnimation[iBossIndex] && !g_bNPCRunningToHeal[iBossIndex] && !g_bNPCHealing[iBossIndex])
						{
							switch (g_iNPCSelfHealStage[iBossIndex])
							{
								case 0:
								{
									if (iDifficulty != 2 && iDifficulty < 2)
									{
										SetConVarInt(g_cvDifficulty, Difficulty_Hard);
										CPrintToChatAll("The difficulty has been set to {orange}%t{default}.", "SF2 Hard Difficulty");
										for(int client = 1;client <=MaxClients;client ++)
										{
											if(IsValidClient(client) && !g_bPlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
											{
												TF2_AddCondition(client, TFCond_CritCola, 5.0 + GetProfileFloat(sSlenderProfile, "heal_time_max", 4.5) + flDelayTimer1);
												EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
											}
										}
									}
									flSpeed *= 0.0;
									g_hSlenderStartFleeTimer[iBossIndex] = CreateTimer(flDelayTimer1, Timer_SlenderFleeAnimationTimer, EntIndexToEntRef(slender));
									g_iNPCHealCount[iBossIndex] = 0;
									SlenderPerformVoice(iBossIndex, "sound_rage");
									NPCSetAddSpeed(iBossIndex, 12.5);
									NPCSetAddMaxSpeed(iBossIndex, 25.0);
									if(view_as<bool>(GetProfileNum(sSlenderProfile,"normal_sound_hook",0)))
									{
										char sRageSoundPath[PLATFORM_MAX_PATH];
										GetRandomStringFromProfile(sSlenderProfile, "sound_rage", sRageSoundPath, sizeof(sRageSoundPath));
										if (sRageSoundPath[0])
										{
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_alertofenemy", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chasingenemy", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_2", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_3", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_4", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_5", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_6", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_7", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_8", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_9", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_idle", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chaseenemyinitial", SNDCHAN_AUTO);
										}
									}
									g_bNPCUseStartFleeAnimation[iBossIndex] = true;
									NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
								}
								case 1:
								{
									if (iDifficulty != 3 && iDifficulty < 3)
									{
										SetConVarInt(g_cvDifficulty, Difficulty_Insane);
										CPrintToChatAll("The difficulty has been set to {red}%t{default}.", "SF2 Insane Difficulty");
										for(int client = 1;client <=MaxClients;client ++)
										{
											if(IsValidClient(client) && !g_bPlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
											{
												int iBuff = GetRandomInt(1, 3);
												switch (iBuff)
												{
													case 1:
													{
														TF2_AddCondition(client, TFCond_CritCola, 5.0 + GetProfileFloat(sSlenderProfile, "heal_time_max", 4.5) + flDelayTimer2);
														EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
													}
													case 2:
													{
														TF2_AddCondition(client, TFCond_HalloweenQuickHeal, 5.0 + GetProfileFloat(sSlenderProfile, "heal_time_max", 4.5) + flDelayTimer2);
														EmitSoundToClient(client, UBER_ROLL, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
													}
													case 3:
													{
														TF2_AddCondition(client, TFCond_DefenseBuffed, 5.0 + GetProfileFloat(sSlenderProfile, "heal_time_max", 4.5) + flDelayTimer2);
														EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
													}
												}
											}
										}
									}
									flSpeed *= 0.0;
									g_hSlenderStartFleeTimer[iBossIndex] = CreateTimer(flDelayTimer2, Timer_SlenderFleeAnimationTimer, EntIndexToEntRef(slender));
									g_iNPCHealCount[iBossIndex] = 0;
									char sRageSound2Path[PLATFORM_MAX_PATH];
									GetRandomStringFromProfile(sSlenderProfile, "sound_rage_2", sRageSound2Path, sizeof(sRageSound2Path));
									if (sRageSound2Path[0]) SlenderPerformVoice(iBossIndex, "sound_rage_2");
									else SlenderPerformVoice(iBossIndex, "sound_rage");
									NPCSetAddSpeed(iBossIndex, 12.5);
									NPCSetAddMaxSpeed(iBossIndex, 25.0);
									if(view_as<bool>(GetProfileNum(sSlenderProfile,"normal_sound_hook",0)))
									{
										char sRageSoundPath[PLATFORM_MAX_PATH];
										GetRandomStringFromProfile(sSlenderProfile, "sound_rage", sRageSoundPath, sizeof(sRageSoundPath));
										if (sRageSoundPath[0])
										{
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_alertofenemy", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chasingenemy", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_2", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_3", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_4", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_5", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_6", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_7", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_8", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_9", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_idle", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chaseenemyinitial", SNDCHAN_AUTO);
										}
									}
									g_bNPCUseStartFleeAnimation[iBossIndex] = true;
									NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
								}
								case 2:
								{
									if (iDifficulty != 4 && iDifficulty < 4)
									{
										SetConVarInt(g_cvDifficulty, Difficulty_Nightmare);
										CPrintToChatAll("The difficulty has been set to {valve}Nightmare{default}.");
										for(int client = 1;client <=MaxClients;client ++)
										{
											if(IsValidClient(client) && !g_bPlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
											{
												int iBuff = GetRandomInt(1, 4);
												switch (iBuff)
												{
													case 1:
													{
														TF2_AddCondition(client, TFCond_CritOnFirstBlood, 5.0 + GetProfileFloat(sSlenderProfile, "heal_time_max", 4.5) + flDelayTimer3);
														EmitSoundToClient(client, CRIT_ROLL, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
													}
													case 2:
													{
														TF2_AddCondition(client, TFCond_HalloweenQuickHeal, 5.0 + GetProfileFloat(sSlenderProfile, "heal_time_max", 4.5) + flDelayTimer3);
														EmitSoundToClient(client, UBER_ROLL, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
													}
													case 3:
													{
														TF2_AddCondition(client, TFCond_DefenseBuffed, 8.0 + GetProfileFloat(sSlenderProfile, "heal_time_max", 4.5) + flDelayTimer3);
														EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
													}
													case 4:
													{
														TF2_RegeneratePlayer(client);
													}
												}
											}
										}
									}
									flSpeed *= 0.0;
									g_hSlenderStartFleeTimer[iBossIndex] = CreateTimer(flDelayTimer3, Timer_SlenderFleeAnimationTimer, EntIndexToEntRef(slender));
									g_iNPCHealCount[iBossIndex] = 0;
									char sRageSound3Path[PLATFORM_MAX_PATH];
									GetRandomStringFromProfile(sSlenderProfile, "sound_rage_3", sRageSound3Path, sizeof(sRageSound3Path));
									if (sRageSound3Path[0]) SlenderPerformVoice(iBossIndex, "sound_rage_3");
									else SlenderPerformVoice(iBossIndex, "sound_rage");
									NPCSetAddSpeed(iBossIndex, 12.5);
									NPCSetAddMaxSpeed(iBossIndex, 25.0);
									if(view_as<bool>(GetProfileNum(sSlenderProfile,"normal_sound_hook",0)))
									{
										char sRageSoundPath[PLATFORM_MAX_PATH];
										GetRandomStringFromProfile(sSlenderProfile, "sound_rage", sRageSoundPath, sizeof(sRageSoundPath));
										if (sRageSoundPath[0])
										{
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_alertofenemy", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chasingenemy", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_2", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_3", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_4", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_5", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_6", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_7", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_8", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_9", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_idle", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chaseenemyinitial", SNDCHAN_AUTO);
										}
									}
									g_bNPCUseStartFleeAnimation[iBossIndex] = true;
									NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
								}
							}
						}
						if (g_bSlenderAttacking[iBossIndex])
						{
							// Cancel attacking.
							g_bSlenderAttacking[iBossIndex] = false;
							g_bNPCStealingLife[iBossIndex] = false;
							g_hSlenderAttackTimer[iBossIndex] = INVALID_HANDLE;
							g_hNPCLifeStealTimer[iBossIndex] = INVALID_HANDLE;
							g_hSlenderBackupAtkTimer[iBossIndex] = INVALID_HANDLE;
							g_bNPCAlreadyAttacked[iBossIndex] = false;
							g_bNPCUseFireAnimation[iBossIndex] = false;
						}
					}
				}
			}
		}
	}
	
	if (!IsValidClient(iTarget) && g_bSlenderTeleportTargetIsCamping[iBossIndex] && g_iSlenderTeleportTarget[iBossIndex] != INVALID_ENT_REFERENCE) //We spawned, and our target is a camper kill him!
	{
		int iCampingTarget = EntRefToEntIndex(g_iSlenderTeleportTarget[iBossIndex]);
		if (MaxClients >= iCampingTarget > 0 && IsTargetValidForSlender(iCampingTarget))
		{
			g_iSlenderTarget[iBossIndex] = EntIndexToEntRef(iCampingTarget);
			iState = STATE_CHASE;
		}
		g_bSlenderTeleportTargetIsCamping[iBossIndex] = false;
	}

	if ((SF_IsRaidMap() || SF_IsProxyMap() || SF_IsBoxingMap() || SF_BossesChaseEndlessly() || g_bNPCChasesEndlessly[iBossIndex]) && iState != STATE_ATTACK && iState != STATE_STUN && IsValidClient(iTarget) && !g_bSlenderGiveUp[iBossIndex])
	{
		g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
		iState = STATE_CHASE;
	}
	if ((SF_IsRaidMap() || SF_IsBoxingMap()) && (g_bNPCRunningToHeal[iBossIndex] || g_bNPCHealing[iBossIndex]))
	{
		g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
		iState = STATE_CHASE;
	}
	if (NPCHasAttribute(iBossIndex, "chase target on scare") && iState != STATE_CHASE && iState != STATE_ATTACK && iState != STATE_STUN && IsValidClient(iTarget) && g_bPlayerScaredByBoss[iTarget][iBossIndex] && !g_bNPCChasingScareVictin[iBossIndex] && !g_bNPCLostChasingScareVictim[iBossIndex])
	{
		g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
		g_bNPCChasingScareVictin[iBossIndex] = true;
		g_bPlayerScaredByBoss[iTarget][iBossIndex] = false;
		iState = STATE_CHASE;
	}
	if (NPCHasAttribute(iBossIndex, "alert copies") && iState != STATE_CHASE && iState != STATE_ATTACK && iState != STATE_STUN && IsValidClient(iTarget) && !g_bNPCAlertedCopy[iBossIndex])
	{
		g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
		g_bNPCAlertedCopy[iBossIndex] = true;
		iState = STATE_CHASE;
	}
	if (IsValidClient(iBestNewTarget) && (bPlayerInTrap[iBestNewTarget] || bPlayerMadeNoise[iBestNewTarget]) && iState != STATE_CHASE && iState != STATE_ATTACK && iState != STATE_STUN)
	{
		g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
		g_flSlenderTimeUntilAlert[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
		iTarget = iBestNewTarget;
		g_iSlenderTarget[iBossIndex] = EntIndexToEntRef(iTarget);
		iState = STATE_CHASE;
	}
	// Finally, set our new state.
	g_iSlenderState[iBossIndex] = iState;
	
	if (iOldState != iState)
	{
		g_hBossChaserPathLogic[iBossIndex].ClearPath();
		
		switch (iState)
		{
			case STATE_IDLE, STATE_WANDER:
			{
				g_iSlenderTarget[iBossIndex] = INVALID_ENT_REFERENCE;
				g_flSlenderTimeUntilIdle[iBossIndex] = -1.0;
				g_flSlenderTimeUntilAlert[iBossIndex] = -1.0;
				g_flSlenderTimeUntilChase[iBossIndex] = -1.0;
				g_bSlenderChaseDeathPosition[iBossIndex] = false;
				g_bNPCLostChasingScareVictim[iBossIndex] = false;
				g_bNPCChasingScareVictin[iBossIndex] = false;
				
				if (iOldState != STATE_IDLE && iOldState != STATE_WANDER)
				{
					g_iSlenderTargetSoundCount[iBossIndex] = 0;
					g_bSlenderInvestigatingSound[iBossIndex] = false;
					g_flSlenderTargetSoundDiscardMasterPosTime[iBossIndex] = -1.0;
					
					g_flSlenderTimeUntilKill[iBossIndex] = GetGameTime() + NPCGetIdleLifetime(iBossIndex, iDifficulty);
				}
				
				if(g_bNPCHasCloaked[iBossIndex] && NPCChaserIsCloakEnabled(iBossIndex))
				{
					char sSlenderModel[PLATFORM_MAX_PATH];
					GetEntPropString(slender, Prop_Data, "m_ModelName", sSlenderModel, sizeof(sSlenderModel));

					SetEntityRenderMode(slender, RENDER_NORMAL);
					if (!g_bSlenderIsJarate[iBossIndex]) SetEntityRenderColor(slender, 255, 255, 255, 0);
					else SetEntityRenderColor(slender, 255, 255, 128, 75);

					g_bNPCHasCloaked[iBossIndex] = false;
					GetProfileString(sSlenderProfile, "cloak_particle", sCloakParticle, sizeof(sCloakParticle));
					if(!sCloakParticle[0])
					{
						sCloakParticle = "drg_cow_explosioncore_charged_blue";
					}
					SlenderCreateParticle(iBossIndex, sCloakParticle, 35.0);
					if(!g_sSlenderCloakOffSound[iBossIndex][0])
					{
						g_sSlenderCloakOffSound[iBossIndex] = DEFAULT_CLOAKOFFSOUND;
					}
					EmitSoundToAll(g_sSlenderCloakOffSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
					g_flSlenderNextCloakTime[iBossIndex] = GetGameTime()+NPCChaserGetCloakCooldown(iBossIndex, iDifficulty);
				}
				
				if (iState == STATE_WANDER)
				{
					// Force new wander position.
					g_flSlenderNextWanderPos[iBossIndex] = -1.0;
				}
			}
			
			case STATE_ALERT:
			{
				g_bSlenderGiveUp[iBossIndex] = false;
				
				g_bSlenderChaseDeathPosition[iBossIndex] = false;
				
				// Set our goal position.
				if (g_bSlenderInvestigatingSound[iBossIndex])
				{
					g_flSlenderGoalPos[iBossIndex][0] = g_flSlenderTargetSoundMasterPos[iBossIndex][0];
					g_flSlenderGoalPos[iBossIndex][1] = g_flSlenderTargetSoundMasterPos[iBossIndex][1];
					g_flSlenderGoalPos[iBossIndex][2] = g_flSlenderTargetSoundMasterPos[iBossIndex][2];
				}
				
				g_flSlenderTimeUntilIdle[iBossIndex] = GetGameTime() + NPCChaserGetAlertDuration(iBossIndex, iDifficulty);
				g_flSlenderTimeUntilAlert[iBossIndex] = -1.0;
				g_bNPCLostChasingScareVictim[iBossIndex] = false;
				g_flSlenderTimeUntilChase[iBossIndex] = GetGameTime() + NPCChaserGetAlertGracetime(iBossIndex, iDifficulty);
				
				if(g_bNPCHasCloaked[iBossIndex] && NPCChaserIsCloakEnabled(iBossIndex))
				{
					char sSlenderModel[PLATFORM_MAX_PATH];
					GetEntPropString(slender, Prop_Data, "m_ModelName", sSlenderModel, sizeof(sSlenderModel));

					SetEntityRenderMode(slender, RENDER_NORMAL);
					if (!g_bSlenderIsJarate[iBossIndex]) SetEntityRenderColor(slender, 255, 255, 255, 0);
					else SetEntityRenderColor(slender, 255, 255, 128, 75);

					g_bNPCHasCloaked[iBossIndex] = false;
					GetProfileString(sSlenderProfile, "cloak_particle", sCloakParticle, sizeof(sCloakParticle));
					if(!sCloakParticle[0])
					{
						sCloakParticle = "drg_cow_explosioncore_charged_blue";
					}
					SlenderCreateParticle(iBossIndex, sCloakParticle, 35.0);
					if(!g_sSlenderCloakOffSound[iBossIndex][0])
					{
						g_sSlenderCloakOffSound[iBossIndex] = DEFAULT_CLOAKOFFSOUND;
					}
					EmitSoundToAll(g_sSlenderCloakOffSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
					g_flSlenderNextCloakTime[iBossIndex] = GetGameTime()+NPCChaserGetCloakCooldown(iBossIndex, iDifficulty);
				}
			}
			case STATE_CHASE, STATE_ATTACK, STATE_STUN:
			{
				g_bSlenderInvestigatingSound[iBossIndex] = false;
				g_iSlenderTargetSoundCount[iBossIndex] = 0;
				
				if (iOldState != STATE_ATTACK && iOldState != STATE_CHASE && iOldState != STATE_STUN)
				{
					g_flSlenderTimeUntilIdle[iBossIndex] = -1.0;
					g_flSlenderTimeUntilAlert[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
					g_iSlenderAutoChaseCount[iBossIndex] = 0;
					g_flSlenderTimeUntilChase[iBossIndex] = -1.0;
					
					float flPersistencyTime = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_init", 5.0);
					if (flPersistencyTime >= 0.0)
					{
						g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + flPersistencyTime;
					}
				}
				
				if (iState == STATE_ATTACK)
				{
					if (g_bNPCUsesRageAnimation1[iBossIndex] || g_bNPCUsesRageAnimation2[iBossIndex] || g_bNPCUsesRageAnimation3[iBossIndex])
					{
						iState = iOldState;
					}
					else
					{
						g_bSlenderAttacking[iBossIndex] = true;
						int iAttackIndex = NPCGetCurrentAttackIndex(iBossIndex);
						if(NPCChaserGetAttackType(iBossIndex, iAttackIndex) != SF2BossAttackType_ExplosiveDance && NPCChaserGetAttackType(iBossIndex, iAttackIndex) != SF2BossAttackType_LaserBeam)
						{
							g_hSlenderAttackTimer[iBossIndex] = CreateTimer(NPCChaserGetAttackDamageDelay(iBossIndex, iAttackIndex), Timer_SlenderChaseBossAttack, EntIndexToEntRef(slender));
							g_bNPCAlreadyAttacked[iBossIndex] = false;
							NPCSetCurrentAttackRepeat(iBossIndex, iAttackIndex, 0);
							g_NPCBaseAttacks[iBossIndex][iAttackIndex][1].BaseAttackNextAttackTime = GetGameTime()+NPCChaserGetAttackCooldown(iBossIndex, iAttackIndex);
						}
						else if (NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_ExplosiveDance)
						{
							g_hSlenderAttackTimer[iBossIndex] = CreateTimer(NPCChaserGetAttackDamageDelay(iBossIndex, iAttackIndex), Timer_SlenderChaseBossExplosiveDance, EntIndexToEntRef(slender), TIMER_REPEAT);
							g_NPCBaseAttacks[iBossIndex][iAttackIndex][1].BaseAttackNextAttackTime = GetGameTime()+NPCChaserGetAttackCooldown(iBossIndex, iAttackIndex);
						}
						else if (NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_LaserBeam)
						{
							g_hSlenderAttackTimer[iBossIndex] = CreateTimer(NPCChaserGetAttackDamageDelay(iBossIndex, iAttackIndex), Timer_SlenderChaseBossAttackBeginLaser, EntIndexToEntRef(slender));
						}
						if(NPCChaserGetAttackLifeStealState(iBossIndex, iAttackIndex))
						{
							if (!g_bNPCStealingLife[iBossIndex])
							{
								g_hNPCLifeStealTimer[iBossIndex] = CreateTimer(0.5, Timer_SlenderStealLife, EntIndexToEntRef(slender), TIMER_REPEAT);
								g_bNPCStealingLife[iBossIndex] = true;
							}
						}
						
						g_flSlenderTimeUntilAttackEnd[iBossIndex] = GetGameTime()+NPCChaserGetAttackDuration(iBossIndex, iAttackIndex)+0.01;
						
						float flPersistencyTime = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_init_attack", -1.0);
						if (flPersistencyTime >= 0.0)
						{
							g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + flPersistencyTime;
						}
						
						flPersistencyTime = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_add_attack", 2.0);
						if (flPersistencyTime >= 0.0)
						{
							if (g_flSlenderTimeUntilNoPersistence[iBossIndex] < GetGameTime()) g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime();
							g_flSlenderTimeUntilNoPersistence[iBossIndex] += flPersistencyTime;
						}
						
						if(g_bNPCHasCloaked[iBossIndex] && NPCChaserIsCloakEnabled(iBossIndex))
						{
							char sSlenderModel[PLATFORM_MAX_PATH];
							GetEntPropString(slender, Prop_Data, "m_ModelName", sSlenderModel, sizeof(sSlenderModel));
							
							SetEntityRenderMode(slender, RENDER_NORMAL);
							if (!g_bSlenderIsJarate[iBossIndex]) SetEntityRenderColor(slender, 255, 255, 255, 0);
							else SetEntityRenderColor(slender, 255, 255, 128, 75);
							
							g_bNPCHasCloaked[iBossIndex] = false;
							GetProfileString(sSlenderProfile, "cloak_particle", sCloakParticle, sizeof(sCloakParticle));
							if(!sCloakParticle[0])
							{
								sCloakParticle = "drg_cow_explosioncore_charged_blue";
							}
							SlenderCreateParticle(iBossIndex, sCloakParticle, 35.0);
							if(!g_sSlenderCloakOffSound[iBossIndex][0])
							{
								g_sSlenderCloakOffSound[iBossIndex] = DEFAULT_CLOAKOFFSOUND;
							}
							EmitSoundToAll(g_sSlenderCloakOffSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							g_flSlenderNextCloakTime[iBossIndex] = GetGameTime()+NPCChaserGetCloakCooldown(iBossIndex, iDifficulty);
						}
						if(!view_as<bool>(GetProfileNum(sSlenderProfile,"multi_attack_sounds",0)))
						{
							SlenderPerformVoice(iBossIndex, "sound_attackenemy", iAttackIndex);
						}
						else
						{
							switch (iAttackIndex)
							{
								case 0: SlenderPerformVoice(iBossIndex, "sound_attackenemy", iAttackIndex);
								case 1: SlenderPerformVoice(iBossIndex, "sound_attackenemy_2", iAttackIndex);
								case 2: SlenderPerformVoice(iBossIndex, "sound_attackenemy_3", iAttackIndex);
								case 3: SlenderPerformVoice(iBossIndex, "sound_attackenemy_4", iAttackIndex);
								case 4: SlenderPerformVoice(iBossIndex, "sound_attackenemy_5", iAttackIndex);
								case 5: SlenderPerformVoice(iBossIndex, "sound_attackenemy_6", iAttackIndex);
								case 6: SlenderPerformVoice(iBossIndex, "sound_attackenemy_7", iAttackIndex);
								case 7: SlenderPerformVoice(iBossIndex, "sound_attackenemy_8", iAttackIndex);
								case 8: SlenderPerformVoice(iBossIndex, "sound_attackenemy_9", iAttackIndex);
							}
						}
						
						if (g_flLastStuckTime[iBossIndex] != 0.0) g_flLastStuckTime[iBossIndex] = GetGameTime();
					}
				}
				else if (iState == STATE_STUN)
				{
					if (g_bSlenderAttacking[iBossIndex])
					{
						// Cancel attacking.
						g_bSlenderAttacking[iBossIndex] = false;
						g_bNPCStealingLife[iBossIndex] = false;
						g_hSlenderAttackTimer[iBossIndex] = INVALID_HANDLE;
						g_hNPCLifeStealTimer[iBossIndex] = INVALID_HANDLE;
						g_hSlenderBackupAtkTimer[iBossIndex] = INVALID_HANDLE;
						g_bNPCAlreadyAttacked[iBossIndex] = false;
						g_bNPCUseFireAnimation[iBossIndex] = false;
					}
					
					if(g_bNPCHasCloaked[iBossIndex] && NPCChaserIsCloakEnabled(iBossIndex))
					{
						char sSlenderModel[PLATFORM_MAX_PATH];
						GetEntPropString(slender, Prop_Data, "m_ModelName", sSlenderModel, sizeof(sSlenderModel));

						SetEntityRenderMode(slender, RENDER_NORMAL);
						if (!g_bSlenderIsJarate[iBossIndex]) SetEntityRenderColor(slender, 255, 255, 255, 0);
						else SetEntityRenderColor(slender, 255, 255, 128, 75);

						g_bNPCHasCloaked[iBossIndex] = false;
						GetProfileString(sSlenderProfile, "cloak_particle", sCloakParticle, sizeof(sCloakParticle));
						if(!sCloakParticle[0])
						{
							sCloakParticle = "drg_cow_explosioncore_charged_blue";
						}
						SlenderCreateParticle(iBossIndex, sCloakParticle, 35.0);
						if(!g_sSlenderCloakOffSound[iBossIndex][0])
						{
							g_sSlenderCloakOffSound[iBossIndex] = DEFAULT_CLOAKOFFSOUND;
						}
						EmitSoundToAll(g_sSlenderCloakOffSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
						g_flSlenderNextCloakTime[iBossIndex] = GetGameTime()+NPCChaserGetCloakCooldown(iBossIndex, iDifficulty);
					}
					
					if (!bDoChasePersistencyInit)
					{
						float flPersistencyTime = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_init_stun", -1.0);
						if (flPersistencyTime >= 0.0)
						{
							g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + flPersistencyTime;
						}
						
						flPersistencyTime = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_add_stun", 2.0);
						if (flPersistencyTime >= 0.0)
						{
							if (g_flSlenderTimeUntilNoPersistence[iBossIndex] < GetGameTime()) g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime();
							g_flSlenderTimeUntilNoPersistence[iBossIndex] += flPersistencyTime;
						}
					}
					else
					{
						float flPersistencyTime = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_init", 5.0);
						if (flPersistencyTime >= 0.0)
						{
							g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + flPersistencyTime;
						}
					}
					
					g_flSlenderTimeUntilRecover[iBossIndex] = GetGameTime() + NPCChaserGetStunDuration(iBossIndex);
					
					// Sound handling. Ignore time check.
					SlenderPerformVoice(iBossIndex, "sound_stun");
					if(view_as<bool>(GetProfileNum(sSlenderProfile,"normal_sound_hook",0)))
					{
						char sStunSoundPath[PLATFORM_MAX_PATH];
						GetRandomStringFromProfile(sSlenderProfile, "sound_stun", sStunSoundPath, sizeof(sStunSoundPath));
						if (sStunSoundPath[0])
						{
							ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_alertofenemy", SNDCHAN_AUTO);
							ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chasingenemy", SNDCHAN_AUTO);
							ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy", SNDCHAN_AUTO);
							ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_2", SNDCHAN_AUTO);
							ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_3", SNDCHAN_AUTO);
							ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_4", SNDCHAN_AUTO);
							ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_5", SNDCHAN_AUTO);
							ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_6", SNDCHAN_AUTO);
							ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_7", SNDCHAN_AUTO);
							ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_8", SNDCHAN_AUTO);
							ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy_9", SNDCHAN_AUTO);
							ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_idle", SNDCHAN_AUTO);
							ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chaseenemyinitial", SNDCHAN_AUTO);
						}
					}
					
					if (g_flLastStuckTime[iBossIndex] != 0.0) g_flLastStuckTime[iBossIndex] = GetGameTime();
				}
				else
				{
					if (iOldState != STATE_ATTACK)
					{
						// Sound handling.
						SlenderPerformVoice(iBossIndex, "sound_chaseenemyinitial");
						if (view_as<bool>(GetProfileNum(sSlenderProfile,"use_chase_initial_animation",0)) && !g_bNPCUsesChaseInitialAnimation[iBossIndex])
						{
							g_bNPCUsesChaseInitialAnimation[iBossIndex] = true;
							flSpeed *= 0.0;
							NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
							g_hSlenderChaseInitialTimer[iBossIndex] = CreateTimer(GetProfileFloat(sSlenderProfile, "chase_initial_timer", 0.0), Timer_SlenderChaseInitialTimer, EntIndexToEntRef(slender));
						}
					}
				}
			}
		}
		NPCChaserSetState(iBossIndex, iState);
		// Call our forward.
		Call_StartForward(fOnBossChangeState);
		Call_PushCell(iBossIndex);
		Call_PushCell(iOldState);
		Call_PushCell(iState);
		Call_Finish();
	}
	
	if (iOldState != iState)
		NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
		
	if (view_as<bool>(GetProfileNum(sSlenderProfile,"old_animation_ai",0)))
	{
		float flSlenderVelocity;
		float flVelocity, flWalkVelocity, flGeneralVel;
		flSlenderVelocity = g_ILocomotion[iBossIndex].GetGroundSpeed();
		flGeneralVel = flSlenderVelocity;
		if (g_flSlenderCalculatedSpeed[iBossIndex] <= 0.0) flVelocity = 0.0;
		else flVelocity = (flGeneralVel + ((g_flSlenderCalculatedSpeed[iBossIndex] * g_flRoundDifficultyModifier)/15))/g_flSlenderCalculatedSpeed[iBossIndex];
		
		if (g_flSlenderCalculatedWalkSpeed[iBossIndex] <= 0.0) flWalkVelocity = 0.0;
		else flWalkVelocity = (flGeneralVel + ((g_flSlenderCalculatedWalkSpeed[iBossIndex] * g_flRoundDifficultyModifier)/15))/g_flSlenderCalculatedWalkSpeed[iBossIndex];
		if (g_ILocomotion[iBossIndex].IsOnGround())
		{
			if (iState == STATE_WANDER && (NPCGetFlags(iBossIndex) & SFF_WANDERMOVE) || iState == STATE_ALERT)
			{
				float flPlaybackSpeed = flWalkVelocity * g_flNPCCurrentAnimationSequencePlaybackRate[iBossIndex];
				if (flPlaybackSpeed > 12.0) flPlaybackSpeed = 12.0;
				if (flPlaybackSpeed < -4.0) flPlaybackSpeed = -4.0;
				SetEntPropFloat(slender, Prop_Send, "m_flPlaybackRate", flPlaybackSpeed);
			}
			if (iState == STATE_CHASE && !g_bNPCUsesChaseInitialAnimation[iBossIndex] && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && !g_bNPCUsesHealAnimation[iBossIndex] && !g_bNPCUseStartFleeAnimation[iBossIndex])
			{
				float flPlaybackSpeed = flVelocity * g_flNPCCurrentAnimationSequencePlaybackRate[iBossIndex];
				if (flPlaybackSpeed > 12.0) flPlaybackSpeed = 12.0;
				if (flPlaybackSpeed < -4.0) flPlaybackSpeed = -4.0;
				SetEntPropFloat(slender, Prop_Send, "m_flPlaybackRate", flPlaybackSpeed);
			}
		}
	}

	switch (iState)
	{
		case STATE_WANDER, STATE_ALERT, STATE_CHASE, STATE_ATTACK:
		{
			// These deal with movement, therefore we need to set our 
			// destination first. That is, if we don't have one. (nav mesh only)
			
			if (iState == STATE_WANDER)
			{
				if (GetGameTime() >= g_flSlenderNextWanderPos[iBossIndex])
				{
					float flMin = GetProfileFloat(sSlenderProfile, "search_wander_time_min", 3.0);
					float flMax = GetProfileFloat(sSlenderProfile, "search_wander_time_max", 4.5);
					g_flSlenderNextWanderPos[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
					
					if (NPCGetFlags(iBossIndex) & SFF_WANDERMOVE)
					{
						// We're allowed to move in wander mode. Get a new wandering position and create a path to follow.
						// If the position can't be reached, then just get to the closest area that we can get.
						float flWanderRangeMin = GetProfileFloat(sSlenderProfile, "search_wander_range_min", 400.0);
						float flWanderRangeMax = GetProfileFloat(sSlenderProfile, "search_wander_range_max", 1024.0);
						float flWanderRange = GetRandomFloat(flWanderRangeMin, flWanderRangeMax);
						
						float flWanderPos[3];
						flWanderPos[0] = 0.0;
						flWanderPos[1] = GetRandomFloat(0.0, 360.0);
						flWanderPos[2] = 0.0;
						
						GetAngleVectors(flWanderPos, flWanderPos, NULL_VECTOR, NULL_VECTOR);
						NormalizeVector(flWanderPos, flWanderPos);
						ScaleVector(flWanderPos, flWanderRange);
						AddVectors(flWanderPos, flMyPos, flWanderPos);
						
						g_flSlenderGoalPos[iBossIndex][0] = flWanderPos[0];
						g_flSlenderGoalPos[iBossIndex][1] = flWanderPos[1];
						g_flSlenderGoalPos[iBossIndex][2] = flWanderPos[2];
						
						g_flSlenderNextPathTime[iBossIndex] = -1.0; // We're not going to wander around too much, so no need for a time constraint.
					}
				}
			}
			else if (iState == STATE_ALERT)
			{
				if (iInterruptConditions & COND_SAWENEMY)
				{
					if (IsValidEntity(iBestNewTarget))
					{
						if ((iTarget > MaxClients && bBuilding) || (((bPlayerInFOV[iBestNewTarget] || bPlayerNear[iBestNewTarget]) && bPlayerVisible[iBestNewTarget]) || (bPlayerMadeNoise[iBestNewTarget] || bPlayerInTrap[iBestNewTarget])))
						{
							// Constantly update my path if I see him.
							if (GetGameTime() >= g_flSlenderNextPathTime[iBossIndex])
							{
								GetEntPropVector(iBestNewTarget, Prop_Data, "m_vecAbsOrigin", g_flSlenderGoalPos[iBossIndex]);
								g_flSlenderNextPathTime[iBossIndex] = GetGameTime()+0.4;
							}
						}
					}
				}
			}
			else if ((iState == STATE_CHASE || iState == STATE_ATTACK) && !g_bNPCRunningToHeal[iBossIndex] && !g_bNPCHealing[iBossIndex])
			{
				if (IsValidEntity(iBestNewTarget))
				{
					iOldTarget = iTarget;
					iTarget = iBestNewTarget;
					g_iSlenderTarget[iBossIndex] = EntIndexToEntRef(iBestNewTarget);
				}
				
				if (iTarget != INVALID_ENT_REFERENCE)
				{
					if (iOldTarget != iTarget)
					{
						// Brand new target! We need a path, and we need to reset our persistency, if needed.
						float flPersistencyTime = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_init_newtarget", -1.0);
						if (flPersistencyTime >= 0.0)
						{
							g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + flPersistencyTime;
						}
						
						flPersistencyTime = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_add_newtarget", 2.0);
						if (flPersistencyTime >= 0.0)
						{
							if (g_flSlenderTimeUntilNoPersistence[iBossIndex] < GetGameTime()) g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime();
							g_flSlenderTimeUntilNoPersistence[iBossIndex] += flPersistencyTime;
						}
					
						GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", g_flSlenderGoalPos[iBossIndex]);
					}
					else if ((iTarget > MaxClients && bBuilding) || ((bPlayerInFOV[iTarget] && bPlayerVisible[iTarget]) || GetGameTime() < g_flSlenderTimeUntilNoPersistence[iBossIndex]))
					{
						// Constantly update my path if I see him or if I'm still being persistent.
						GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", g_flSlenderGoalPos[iBossIndex]);
					}
				}
				if (NPCChaserGetTeleporter(iBossIndex,0) != INVALID_ENT_REFERENCE)
				{
					int iTeleporter = EntRefToEntIndex(NPCChaserGetTeleporter(iBossIndex,0));
					if (IsValidEntity(iTeleporter) && iTeleporter > MaxClients)
						GetEntPropVector(iTeleporter, Prop_Data, "m_vecAbsOrigin", g_flSlenderGoalPos[iBossIndex]);
				}
			}
			if ((iState == STATE_WANDER && (NPCGetFlags(iBossIndex) & SFF_WANDERMOVE) && g_flSlenderCalculatedWalkSpeed[iBossIndex] > 0.0)
				|| (iState == STATE_ALERT && g_flSlenderCalculatedWalkSpeed[iBossIndex] > 0.0)
				|| (iState == STATE_CHASE && g_flSlenderCalculatedSpeed[iBossIndex] > 0.0)
				|| (iState == STATE_ATTACK))
			{
				if (NavMesh_Exists() && g_flSlenderLastCalculPathTime[iBossIndex] <= GetGameTime())
				{
					bool bCompute = g_hBossChaserPathLogic[iBossIndex].ComputePathToPos(g_INextBot[iBossIndex].GetEntity(), g_flSlenderGoalPos[iBossIndex], SlenderChaseBossShortestPathCost, g_ILocomotion[iBossIndex], _, _);
					if (bCompute)
					{
						g_flSlenderLastCalculPathTime[iBossIndex] = GetGameTime()+0.3;
					}
					else
					{
						g_hBossChaserPathLogic[iBossIndex].ClearPath();
						g_bSlenderGiveUp[iBossIndex] = true;
					}
				}
			}
			if (iState == STATE_CHASE || iState == STATE_ATTACK)
			{
				if (IsValidClient(iTarget))
				{
#if defined DEBUG
					SendDebugMessageToPlayer(iTarget, DEBUG_BOSS_CHASE, 1, "g_flSlenderTimeUntilAlert[%d]: %f\ng_flSlenderTimeUntilNoPersistence[%d]: %f", iBossIndex, g_flSlenderTimeUntilAlert[iBossIndex] - GetGameTime(), iBossIndex, g_flSlenderTimeUntilNoPersistence[iBossIndex] - GetGameTime());
#endif
				
					if (bPlayerInFOV[iTarget] && bPlayerVisible[iTarget] && !g_bNPCUsesChaseInitialAnimation[iBossIndex])
					{
						float flDistRatio = flPlayerDists[iTarget] / NPCGetSearchRadius(iBossIndex);
						
						float flChaseDurationTimeAddMin = GetProfileFloat(sSlenderProfile, "search_chase_duration_add_visible_min", 0.025);
						float flChaseDurationTimeAddMax = GetProfileFloat(sSlenderProfile, "search_chase_duration_add_visible_max", 0.2);
						
						float flChaseDurationAdd = flChaseDurationTimeAddMax - ((flChaseDurationTimeAddMax - flChaseDurationTimeAddMin) * flDistRatio);
						
						if (flChaseDurationAdd > 0.0)
						{
							g_flSlenderTimeUntilAlert[iBossIndex] += flChaseDurationAdd;
							if (g_flSlenderTimeUntilAlert[iBossIndex] > (GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty)))
							{
								g_flSlenderTimeUntilAlert[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
							}
						}
						
						float flPersistencyTimeAddMin = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_add_visible_min", 0.05);
						float flPersistencyTimeAddMax = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_add_visible_max", 0.15);
						
						float flPersistencyTimeAdd = flPersistencyTimeAddMax - ((flPersistencyTimeAddMax - flPersistencyTimeAddMin) * flDistRatio);
						
						if (flPersistencyTimeAdd > 0.0)
						{
							if (g_flSlenderTimeUntilNoPersistence[iBossIndex] < GetGameTime()) g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime();
						
							g_flSlenderTimeUntilNoPersistence[iBossIndex] += flPersistencyTimeAdd;
							if (g_flSlenderTimeUntilNoPersistence[iBossIndex] > (GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty)))
							{
								g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
							}
						}
					}
				}
			}
		}
	}
	
	switch (iState)
	{
		case STATE_WANDER, STATE_ALERT:
		{
			SetEntPropFloat(slender, Prop_Data, "m_speed", g_flSlenderCalculatedWalkSpeed[iBossIndex]);
		}
		case STATE_CHASE:
		{
			SetEntPropFloat(slender, Prop_Data, "m_speed", g_flSlenderCalculatedSpeed[iBossIndex]);
			if (g_bSlenderAttacking[iBossIndex]) //Fix the rare attack while running bug
			{
				g_bSlenderAttacking[iBossIndex] = false;
				g_bNPCStealingLife[iBossIndex] = false;
				g_hSlenderAttackTimer[iBossIndex] = INVALID_HANDLE;
				g_hNPCLifeStealTimer[iBossIndex] = INVALID_HANDLE;
				g_hSlenderBackupAtkTimer[iBossIndex] = INVALID_HANDLE;
				g_bNPCAlreadyAttacked[iBossIndex] = false;
				g_bNPCUseFireAnimation[iBossIndex] = false;
			}
		}
	}
	
	// Sound handling.
	if(!view_as<bool>(GetProfileNum(sSlenderProfile,"normal_sound_hook",0)))
	{
		if (GetGameTime() >= g_flSlenderNextVoiceSound[iBossIndex])
		{
			switch (iState)
			{
				case STATE_IDLE, STATE_WANDER:
				{
					SlenderPerformVoice(iBossIndex, "sound_idle");
				}
				case STATE_ALERT:
				{
					SlenderPerformVoice(iBossIndex, "sound_alertofenemy");
				}
				case STATE_CHASE, STATE_ATTACK:
				{
					if (!g_bNPCRunningToHeal[iBossIndex] && !g_bNPCHealing[iBossIndex]) SlenderPerformVoice(iBossIndex, "sound_chasingenemy");
				}
			}
		}
	}
	else
	{
		if (GetGameTime() >= g_flSlenderNextVoiceSound[iBossIndex])
		{
			switch (iState)
			{
				case STATE_IDLE, STATE_WANDER:
				{
					SlenderPerformVoice(iBossIndex, "sound_idle");
				}
				case STATE_ALERT:
				{
					SlenderPerformVoice(iBossIndex, "sound_alertofenemy");
				}
				case STATE_CHASE, STATE_ATTACK:
				{
					if (!g_bNPCRunningToHeal[iBossIndex] && !g_bNPCHealing[iBossIndex]) SlenderPerformVoice(iBossIndex, "sound_chasingenemy");
				}
			}
		}
		switch (iState)
		{
			case STATE_IDLE, STATE_WANDER:
			{
				if (iOldState == STATE_ALERT || iOldState == STATE_CHASE || iOldState == STATE_ATTACK)
				{
					ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_alertofenemy", SNDCHAN_AUTO);
					ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chasingenemy", SNDCHAN_AUTO);
					SlenderPerformVoice(iBossIndex, "sound_idle");
				}
			}
			case STATE_ALERT:
			{
				if (iOldState == STATE_IDLE || iOldState == STATE_WANDER || iOldState == STATE_CHASE || iOldState == STATE_ATTACK)
				{
					ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_idle", SNDCHAN_AUTO);
					ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chasingenemy", SNDCHAN_AUTO);
					SlenderPerformVoice(iBossIndex, "sound_alertofenemy");
				}
			}
			case STATE_CHASE, STATE_ATTACK:
			{
				if (iOldState == STATE_ALERT || iOldState == STATE_IDLE || iOldState == STATE_WANDER)
				{
					char sSoundPath[PLATFORM_MAX_PATH];
					GetRandomStringFromProfile(sSlenderProfile, "sound_chaseenemyinitial", sSoundPath, sizeof(sSoundPath));
					if (!sSoundPath[0])
					{
						ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_alertofenemy", SNDCHAN_AUTO);
						ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_idle", SNDCHAN_AUTO);
						SlenderPerformVoice(iBossIndex, "sound_chasingenemy");
					}
					else if (sSoundPath[0])
					{
						ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_alertofenemy", SNDCHAN_AUTO);
						ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_idle", SNDCHAN_AUTO);
						ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chasingenemy", SNDCHAN_AUTO);
					}
				}
			}
		}
	}
	
	//Footstep handling.
	switch (iState)
	{
		case STATE_IDLE:
		{
			if (GetGameTime() >= g_flSlenderNextFootstepIdleSound[iBossIndex]) SlenderCastFootstep(iBossIndex, "sound_footsteps");
		}
		case STATE_WANDER, STATE_ALERT:
		{
			if (GetGameTime() >= g_flSlenderNextFootstepWalkSound[iBossIndex]) SlenderCastFootstep(iBossIndex, "sound_footsteps");
		}
		case STATE_CHASE:
		{
			if (GetGameTime() >= g_flSlenderNextFootstepRunSound[iBossIndex] && !g_bNPCUsesChaseInitialAnimation[iBossIndex] && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && !g_bNPCUsesHealAnimation[iBossIndex] && !g_bNPCUseStartFleeAnimation[iBossIndex])
				SlenderCastFootstep(iBossIndex, "sound_footsteps");
		}
		case STATE_STUN:
		{
			if (GetGameTime() >= g_flSlenderNextFootstepStunSound[iBossIndex]) SlenderCastFootstep(iBossIndex, "sound_footsteps");
		}
		case STATE_ATTACK:
		{
			if (GetGameTime() >= g_flSlenderNextFootstepAttackSound[iBossIndex]) SlenderCastFootstep(iBossIndex, "sound_footsteps");
		}
	}

	// Reset our interrupt conditions.
	g_iSlenderInterruptConditions[iBossIndex] = 0;

	return Plugin_Continue;
}

public Action Timer_DestroyProjectile(Handle timer, any entref)
{
	int iProjectile = EntRefToEntIndex(entref);
	if (iProjectile != INVALID_ENT_REFERENCE)
	{
		AcceptEntityInput(iProjectile, "Kill");
	}
	return Plugin_Continue;
}

public Action Hook_ManglerTouch(int entity,int iOther)
{
	int iDifficulty = GetConVarInt(g_cvDifficulty);
	int iRandomSound = GetRandomInt(0, 2);
	float flEntPos[3], flOtherPos[3];
	GetEntPropVector(iOther, Prop_Data, "m_vecAbsOrigin", flOtherPos);
	GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", flEntPos);
	switch (iRandomSound)
	{
		case 0: EmitSoundToAll(MANGLER_EXPLODE1, entity, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
		case 1: EmitSoundToAll(MANGLER_EXPLODE2, entity, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
		case 2: EmitSoundToAll(MANGLER_EXPLODE3, entity, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
	}
	if(iOther > 0 && iOther <= MaxClients)
	{
		int slender = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
		if(slender != INVALID_ENT_REFERENCE)
		{
			int iBossIndex = NPCGetFromEntIndex(slender);
			float flDistance = GetVectorDistance(flOtherPos, flEntPos);
			if (flDistance <= NPCChaserGetProjectileRadius(iBossIndex, iDifficulty))
			{
				SDKHooks_TakeDamage(iOther, slender, slender, NPCChaserGetProjectileDamage(iBossIndex, iDifficulty), DMG_SHOCK|DMG_ALWAYSGIB);
				if(TF2_IsPlayerInCondition(iOther, TFCond_Gas))
				{
					TF2_IgnitePlayer(iOther, iOther);
					TF2_RemoveCondition(iOther, TFCond_Gas);
				}
			}
		}
	}
	return Plugin_Handled;
}

public Action Hook_IceballTouch(int entity,int iOther)
{
	float flEntPos[3], flOtherPos[3];
	GetEntPropVector(iOther, Prop_Data, "m_vecAbsOrigin", flOtherPos);
	GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", flEntPos);
	StopSound(entity, SNDCHAN_AUTO, ROCKET_IMPACT);
	StopSound(entity, SNDCHAN_AUTO, ROCKET_IMPACT2);
	StopSound(entity, SNDCHAN_AUTO, ROCKET_IMPACT3);
	int slender = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
	if(slender != INVALID_ENT_REFERENCE)
	{
		int iBossIndex = NPCGetFromEntIndex(slender);
		if(!g_sSlenderFireballExplodeSound[iBossIndex][0] && iBossIndex != -1)
		{
			g_sSlenderFireballExplodeSound[iBossIndex] = FIREBALL_IMPACT;
		}
		EmitSoundToAll(g_sSlenderFireballExplodeSound[iBossIndex], entity, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
		CreateGeneralParticle(entity, "spell_batball_impact_blue", 2.5);
	}
	return Plugin_Handled;
}

public Action Hook_FireballTouch(int entity,int iOther)
{
	float flEntPos[3], flOtherPos[3];
	GetEntPropVector(iOther, Prop_Data, "m_vecAbsOrigin", flOtherPos);
	GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", flEntPos);
	StopSound(entity, SNDCHAN_AUTO, ROCKET_IMPACT);
	StopSound(entity, SNDCHAN_AUTO, ROCKET_IMPACT2);
	StopSound(entity, SNDCHAN_AUTO, ROCKET_IMPACT3);
	int slender = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
	if(slender != INVALID_ENT_REFERENCE)
	{
		int iBossIndex = NPCGetFromEntIndex(slender);
		if(!g_sSlenderFireballExplodeSound[iBossIndex][0])
		{
			g_sSlenderFireballExplodeSound[iBossIndex] = FIREBALL_IMPACT;
		}
		EmitSoundToAll(g_sSlenderFireballExplodeSound[iBossIndex], entity, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
		CreateGeneralParticle(entity, "bombinomicon_burningdebris", 2.5);
	}
	return Plugin_Handled;
}

public Action Hook_BaseballTouch(int entity,int iOther)
{
	int iDifficulty = GetConVarInt(g_cvDifficulty);
	float flEntPos[3], flOtherPos[3];
	GetEntPropVector(iOther, Prop_Data, "m_vecAbsOrigin", flOtherPos);
	GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", flEntPos);
	if(iOther > 0 && iOther <= MaxClients)
	{
		int slender = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
		if(slender != INVALID_ENT_REFERENCE)
		{
			int iBossIndex = NPCGetFromEntIndex(slender);
			SDKHooks_TakeDamage(iOther, slender, slender, NPCChaserGetProjectileDamage(iBossIndex, iDifficulty), 1048576);
		}
	}
	return Plugin_Handled;
}

int NPCChaserProjectileShoot(int iBossIndex, int slender, int iTarget, const char[] sSlenderProfile, float flMyPos[3], bool bUseCooldown = true)
{
	int iProjectileType = NPCChaserGetProjectileType(iBossIndex);
	int iDifficulty = GetConVarInt(g_cvDifficulty);
	int iProjectileEnt;
	float flShootDist = GetVectorDistance(g_flSlenderGoalPos[iBossIndex], flMyPos);
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	char sProjectileName[45];
	float flClientPos[3];
	float flSlenderPosition[3];
	NPCGetEyePosition(iBossIndex, flSlenderPosition);
	GetClientEyePosition(iTarget, flClientPos);
	switch (iProjectileType)
	{
		case SF2BossProjectileType_Grenade:
		{
			if (flShootDist < 600)
			{
				flClientPos[2] += 0;
			}
			else if (flShootDist > 600 && flShootDist < 1000)
			{
				flClientPos[2] += 60;
			}
			else if (flShootDist > 1000)
			{
				flClientPos[2] += 120;
			}
		}
		case SF2BossProjectileType_Arrow, SF2BossProjectileType_Baseball:
		{
			flClientPos[2] -= 0;
		}
		default:
		{
			flClientPos[2] -= 25;
		}
	}

	float flBasePos[3], flBaseAng[3];
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flBasePos);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", flBaseAng);

	float flEffectPos[3];
	float flEffectAng[3] = {0.0, 0.0, 0.0};
	
	int iRandomPosMin = GetProfileNum(sProfile, "projectile_pos_number_min", 1);
	int iRandomPosMax = GetProfileNum(sProfile, "projectile_pos_number_max", 1);
	
	if (iRandomPosMin == 1 && iRandomPosMax == 1)
	{
		KvGetVector(g_hConfig, "projectile_pos_offset", flEffectPos);
	}
	else
	{
		int iRandomProjectilePos = GetRandomInt(iRandomPosMin, iRandomPosMax);
		char sKeyName[PLATFORM_MAX_PATH];
		Format(sKeyName, sizeof(sKeyName), "projectile_pos_offset_%i", iRandomProjectilePos);
		KvGetVector(g_hConfig, sKeyName, flEffectPos);
	}

	VectorTransform(flEffectPos, flBasePos, flBaseAng, flEffectPos);
	AddVectors(flEffectAng, flBaseAng, flEffectAng);

	float flShootDirection[3], flShootAng[3];
	SubtractVectors(flClientPos, flEffectPos, flShootDirection);
	NormalizeVector(flShootDirection, flShootDirection);
	GetVectorAngles(flShootDirection, flShootAng);

	int iTeam = 3;

	float flMin = NPCChaserGetProjectileCooldownMin(iBossIndex, iDifficulty);
	float flMax = NPCChaserGetProjectileCooldownMax(iBossIndex, iDifficulty);
	
	switch(iProjectileType)
	{
		case SF2BossProjectileType_Fireball:		
		{
			//Ball: spell_fireball_small_red
			//Glow: spell_fireball_small_glow_red
			//Explode: bombinomicon_burningdebris
			sProjectileName = "tf_projectile_rocket";
			iProjectileEnt = CreateEntityByName(sProjectileName);
			if (iProjectileEnt != -1)
			{
				float flVelocity[3], flBufferProj[3];

				GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

				flVelocity[0] = flBufferProj[0]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
				flVelocity[1] = flBufferProj[1]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
				flVelocity[2] = flBufferProj[2]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
				AttachParticle(iProjectileEnt, "spell_fireball_small_red");
				AttachParticle(iProjectileEnt, "spell_fireball_small_glow_red");

				SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hOwnerEntity", slender);
				SetEntPropFloat(iProjectileEnt, Prop_Data, "m_flModelScale", 1.0);
				SetEntityRenderMode(iProjectileEnt, RENDER_TRANSCOLOR);
				SetEntityRenderColor(iProjectileEnt, 0, 0, 0, 0);
				SetEntDataFloat(iProjectileEnt, FindSendPropInfo("CTFProjectile_Rocket", "m_iDeflected") + 4, 0.1, true); // set damage to nothing
				SDKHook(iProjectileEnt, SDKHook_StartTouch, Hook_FireballTouch); //This is where the damage comes into play.

				SetEntProp(iProjectileEnt,    Prop_Send, "m_iTeamNum",     2, 1);

				DispatchSpawn(iProjectileEnt);
				ProjectileSetFlags(iProjectileEnt, PROJ_FIREBALL);

				if(NPCChaserUseShootGesture(iBossIndex) && bUseCooldown)
				{
					GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

					CBaseAnimating_PlayGesture(slender, sGestureShootAnim);
				}

				TeleportEntity(iProjectileEnt, flEffectPos, flShootAng, flVelocity);
				if(!g_sSlenderFireballShootSound[iBossIndex][0])
				{
					g_sSlenderFireballShootSound[iBossIndex] = FIREBALL_SHOOT;
				}
				EmitSoundToAll(g_sSlenderFireballShootSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
				if (bUseCooldown)
					g_flNPCProjectileCooldown[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
			}
		}
		case SF2BossProjectileType_Iceball:
		{
			//Ball: spell_fireball_small_blue
			//Glow: spell_fireball_small_glow_blue
			//Impact: spell_batball_impact_blue
			sProjectileName = "tf_projectile_rocket";
			iProjectileEnt = CreateEntityByName(sProjectileName);
			if (iProjectileEnt != -1)
			{
				float flVelocity[3], flBufferProj[3];

				GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

				flVelocity[0] = flBufferProj[0]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
				flVelocity[1] = flBufferProj[1]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
				flVelocity[2] = flBufferProj[2]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
				AttachParticle(iProjectileEnt, "spell_fireball_small_blue");
				AttachParticle(iProjectileEnt, "spell_fireball_small_glow_blue");

				SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hOwnerEntity", slender);
				SetEntPropFloat(iProjectileEnt, Prop_Data, "m_flModelScale", 1.0);
				SetEntityRenderMode(iProjectileEnt, RENDER_TRANSCOLOR);
				SetEntityRenderColor(iProjectileEnt, 0, 0, 0, 0);
				SetEntDataFloat(iProjectileEnt, FindSendPropInfo("CTFProjectile_Rocket", "m_iDeflected") + 4, 0.1, true); // set damage to nothing
				SDKHook(iProjectileEnt, SDKHook_StartTouch, Hook_IceballTouch); //This is where the damage comes into play.

				SetEntProp(iProjectileEnt,    Prop_Send, "m_iTeamNum",     iTeam, 1);

				DispatchSpawn(iProjectileEnt);
				ProjectileSetFlags(iProjectileEnt, PROJ_ICEBALL);

				if(NPCChaserUseShootGesture(iBossIndex) && bUseCooldown)
				{
					GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

					CBaseAnimating_PlayGesture(slender, sGestureShootAnim);
				}

				TeleportEntity(iProjectileEnt, flEffectPos, flShootAng, flVelocity);
				if(!g_sSlenderFireballShootSound[iBossIndex][0])
				{
					g_sSlenderFireballShootSound[iBossIndex] = FIREBALL_SHOOT;
				}
				EmitSoundToAll(g_sSlenderFireballShootSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
				if (bUseCooldown)
					g_flNPCProjectileCooldown[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
			}
		}
		case SF2BossProjectileType_Rocket:
		{
			sProjectileName = "tf_projectile_rocket";
			iProjectileEnt = CreateEntityByName(sProjectileName);
			if (iProjectileEnt != -1)
			{
				float flVelocity[3], flBufferProj[3];

				GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

				flVelocity[0] = flBufferProj[0]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
				flVelocity[1] = flBufferProj[1]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
				flVelocity[2] = flBufferProj[2]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);

				SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hOwnerEntity", slender);
				if (NPCChaserHasCriticalRockets(iBossIndex)) SetEntProp(iProjectileEnt,    Prop_Send, "m_bCritical", 1, 1);
				SetEntDataFloat(iProjectileEnt, FindSendPropInfo("CTFProjectile_Rocket", "m_iDeflected") + 4, NPCChaserGetProjectileDamage(iBossIndex, iDifficulty), true); // set damage
				ProjectileSetFlags(iProjectileEnt, PROJ_ROCKET);

				SetEntProp(iProjectileEnt,    Prop_Send, "m_iTeamNum",     iTeam, 1);

				DispatchSpawn(iProjectileEnt);

				if(NPCChaserUseShootGesture(iBossIndex) && bUseCooldown)
				{
					GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

					CBaseAnimating_PlayGesture(slender, sGestureShootAnim);
				}

				TeleportEntity(iProjectileEnt, flEffectPos, flShootAng, flVelocity);
				if(!g_sSlenderRocketShootSound[iBossIndex][0])
				{
					g_sSlenderRocketShootSound[iBossIndex] = ROCKET_SHOOT;
				}
				EmitSoundToAll(g_sSlenderRocketShootSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
				if (bUseCooldown)
					g_flNPCProjectileCooldown[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
			}
		}
		case SF2BossProjectileType_Grenade:
		{
			sProjectileName = "tf_point_weapon_mimic";
			if (flShootDist <= 2250)
			{
				iProjectileEnt = CreateEntityByName(sProjectileName);
				if (iProjectileEnt != -1)
				{
					float flVelocity[3], flBufferProj[3];

					GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

					flVelocity[0] = flBufferProj[0]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
					flVelocity[1] = flBufferProj[1]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
					flVelocity[2] = flBufferProj[2]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);

					SetEntPropFloat(iProjectileEnt, Prop_Data, "m_flDamage", NPCChaserGetProjectileDamage(iBossIndex, iDifficulty));
					SetEntPropFloat(iProjectileEnt, Prop_Data, "m_flSpeedMin", NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty));
					SetEntPropFloat(iProjectileEnt, Prop_Data, "m_flSpeedMax", NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty));
					SetEntPropFloat(iProjectileEnt, Prop_Data, "m_flSplashRadius", NPCChaserGetProjectileRadius(iBossIndex, iDifficulty));
					SetEntPropFloat(iProjectileEnt, Prop_Data, "m_flModelScale", 1.0);
					if (NPCChaserHasCriticalRockets(iBossIndex)) SetEntProp(iProjectileEnt, Prop_Data, "m_bCrits", 1, 1);
					SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hOwnerEntity", slender);

					DispatchSpawn(iProjectileEnt);
					DispatchKeyValueVector(iProjectileEnt, "origin", flEffectPos);
					DispatchKeyValueVector(iProjectileEnt, "angles", flShootAng);
					DispatchKeyValue(iProjectileEnt, "WeaponType", "1");
					DispatchKeyValue(iProjectileEnt, "ModelOverride", GRENADE_MODEL);
					ProjectileSetFlags(iProjectileEnt, PROJ_GRENADE);

					AcceptEntityInput(iProjectileEnt, "FireOnce");

					if(NPCChaserUseShootGesture(iBossIndex) && bUseCooldown)
					{
						GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

						CBaseAnimating_PlayGesture(slender, sGestureShootAnim);
					}

					TeleportEntity(iProjectileEnt, flEffectPos, flShootAng, flVelocity);
					CreateTimer(0.1, Timer_DestroyProjectile, EntIndexToEntRef(iProjectileEnt));
					if(!g_sSlenderGrenadeShootSound[iBossIndex][0])
					{
						g_sSlenderGrenadeShootSound[iBossIndex] = GRENADE_SHOOT;
					}
					EmitSoundToAll(g_sSlenderGrenadeShootSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
					if (bUseCooldown)
						g_flNPCProjectileCooldown[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
				}
			}
		}
		case SF2BossProjectileType_SentryRocket:
		{
			sProjectileName = "tf_projectile_sentryrocket";
			iProjectileEnt = CreateEntityByName(sProjectileName);
			if (iProjectileEnt != -1)
			{
				float flVelocity[3], flBufferProj[3];

				GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

				flVelocity[0] = flBufferProj[0]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
				flVelocity[1] = flBufferProj[1]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
				flVelocity[2] = flBufferProj[2]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);

				SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hOwnerEntity", slender);
				if (NPCChaserHasCriticalRockets(iBossIndex)) SetEntProp(iProjectileEnt,    Prop_Send, "m_bCritical", 1, 1);
				SetEntDataFloat(iProjectileEnt, FindSendPropInfo("CTFProjectile_SentryRocket", "m_iDeflected") + 4, NPCChaserGetProjectileDamage(iBossIndex, iDifficulty), true); // set damage
				ProjectileSetFlags(iProjectileEnt, PROJ_SENTRYROCKET);

				SetEntProp(iProjectileEnt,    Prop_Send, "m_iTeamNum",     iTeam, 1);

				DispatchSpawn(iProjectileEnt);

				if(NPCChaserUseShootGesture(iBossIndex) && bUseCooldown)
				{
					GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

					CBaseAnimating_PlayGesture(slender, sGestureShootAnim);
				}

				TeleportEntity(iProjectileEnt, flEffectPos, flShootAng, flVelocity);
				if(!g_sSlenderSentryRocketShootSound[iBossIndex][0])
				{
					g_sSlenderSentryRocketShootSound[iBossIndex] = SENTRYROCKET_SHOOT;
				}
				EmitSoundToAll(g_sSlenderSentryRocketShootSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
				if (bUseCooldown)
					g_flNPCProjectileCooldown[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
			}
		}
		case SF2BossProjectileType_Arrow:
		{
			sProjectileName = "tf_point_weapon_mimic";
			if (flShootDist <= 1250)
			{
				iProjectileEnt = CreateEntityByName(sProjectileName);
				if (iProjectileEnt != -1)
				{
					float flVelocity[3], flBufferProj[3];

					GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

					flVelocity[0] = flBufferProj[0]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
					flVelocity[1] = flBufferProj[1]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
					flVelocity[2] = flBufferProj[2]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);

					if (NPCChaserHasCriticalRockets(iBossIndex)) SetEntProp(iProjectileEnt,    Prop_Send, "m_bCrits", 1, 1);
					SetEntPropFloat(iProjectileEnt, Prop_Data, "m_flDamage", NPCChaserGetProjectileDamage(iBossIndex, iDifficulty));
					SetEntPropFloat(iProjectileEnt, Prop_Data, "m_flSpeedMin", NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty));
					SetEntPropFloat(iProjectileEnt, Prop_Data, "m_flSpeedMax", NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty));
					SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					ProjectileSetFlags(iProjectileEnt, PROJ_ARROW);

					DispatchSpawn(iProjectileEnt);
					DispatchKeyValueVector(iProjectileEnt, "origin", flEffectPos);
					DispatchKeyValueVector(iProjectileEnt, "angles", flShootAng);
					DispatchKeyValue(iProjectileEnt, "WeaponType", "2");

					AcceptEntityInput(iProjectileEnt, "FireOnce");

					if(NPCChaserUseShootGesture(iBossIndex) && bUseCooldown)
					{
						GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

						CBaseAnimating_PlayGesture(slender, sGestureShootAnim);
					}

					TeleportEntity(iProjectileEnt, flEffectPos, flShootAng, flVelocity);
					CreateTimer(0.1, Timer_DestroyProjectile, EntIndexToEntRef(iProjectileEnt));
					if(!g_sSlenderArrowShootSound[iBossIndex][0])
					{
						g_sSlenderArrowShootSound[iBossIndex] = ARROW_SHOOT;
					}
					EmitSoundToAll(g_sSlenderArrowShootSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
					if (bUseCooldown)
						g_flNPCProjectileCooldown[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
				}
			}
		}
		case SF2BossProjectileType_Mangler:
		{
			sProjectileName = "tf_projectile_energy_ball";
			iProjectileEnt = CreateEntityByName(sProjectileName);
			if (iProjectileEnt != -1)
			{
				float flVelocity[3], flBufferProj[3];

				GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

				flVelocity[0] = flBufferProj[0]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
				flVelocity[1] = flBufferProj[1]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
				flVelocity[2] = flBufferProj[2]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);

				SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hOwnerEntity", slender);
				SetEntProp(iProjectileEnt, Prop_Send, "m_CollisionGroup", 4);
				SetEntProp(iProjectileEnt,    Prop_Send, "m_iTeamNum",     5, 1);
				SetEntProp(iProjectileEnt, Prop_Data, "m_takedamage", 0);
				SetEntPropVector(iProjectileEnt, Prop_Send, "m_vecMins", view_as<float>( { 3.0, 3.0, 3.0 } ));
				SetEntPropVector(iProjectileEnt, Prop_Send, "m_vecMaxs", view_as<float>( { 3.0, 3.0, 3.0 } ));
				SDKHook(iProjectileEnt, SDKHook_StartTouch, Hook_ManglerTouch);
				ProjectileSetFlags(iProjectileEnt, PROJ_MANGLER);

				DispatchSpawn(iProjectileEnt);

				if(NPCChaserUseShootGesture(iBossIndex) && bUseCooldown)
				{
					GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

					CBaseAnimating_PlayGesture(slender, sGestureShootAnim);
				}

				TeleportEntity(iProjectileEnt, flEffectPos, flShootAng, flVelocity);
				if(!g_sSlenderManglerShootSound[iBossIndex][0])
				{
					g_sSlenderManglerShootSound[iBossIndex] = MANGLER_SHOOT;
				}
				EmitSoundToAll(g_sSlenderManglerShootSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
				if (bUseCooldown)
					g_flNPCProjectileCooldown[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
			}
		}
		case SF2BossProjectileType_Baseball:
		{
			sProjectileName = "tf_projectile_stun_ball";
			iProjectileEnt = CreateEntityByName(sProjectileName);
			if (iProjectileEnt != -1)
			{
				float flVelocity[3], flBufferProj[3];

				GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

				flVelocity[0] = flBufferProj[0]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
				flVelocity[1] = flBufferProj[1]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
				flVelocity[2] = flBufferProj[2]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
				GetProfileString(sSlenderProfile, "baseball_model", sBaseballModel, sizeof(sBaseballModel));
				int iModel;
				if (!sBaseballModel[0])
				{
					sBaseballModel = BASEBALL_MODEL;
					iModel = PrecacheModel(sBaseballModel, true);
				}
				else
				{
					iModel = PrecacheModel(sBaseballModel, true);
				}

				SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hOwnerEntity", slender);
				SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hThrower", slender);
				SetEntProp(iProjectileEnt, Prop_Send, "m_nModelIndexOverrides", iModel);
				ProjectileSetFlags(iProjectileEnt, PROJ_BASEBALL);

				SetEntProp(iProjectileEnt,    Prop_Send, "m_iTeamNum",     iTeam, 1);
				SDKHook(iProjectileEnt, SDKHook_StartTouch, Hook_BaseballTouch);

				DispatchSpawn(iProjectileEnt);

				if(NPCChaserUseShootGesture(iBossIndex) && bUseCooldown)
				{
					GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

					CBaseAnimating_PlayGesture(slender, sGestureShootAnim);
				}

				TeleportEntity(iProjectileEnt, flEffectPos, flShootAng, flVelocity);
				if(!g_sSlenderBaseballShootSound[iBossIndex][0])
				{
					g_sSlenderBaseballShootSound[iBossIndex] = BASEBALL_SHOOT;
				}
				EmitSoundToAll(g_sSlenderBaseballShootSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
				if (bUseCooldown)
					g_flNPCProjectileCooldown[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
			}
		}
	}
	return iProjectileEnt;
}


int NPCChaserProjectileAttackShoot(int iBossIndex, int slender, int iTarget, const char[] sSlenderProfile, const char[] sSectionName)
{
	int iAttackIndex = NPCGetCurrentAttackIndex(iBossIndex);
	int iProjectileType = GetProfileAttackNum(sSlenderProfile, "attack_projectiletype", 0, iAttackIndex+1);
	int iProjectileEnt;

	char sProjectileName[45];
	float flClientPos[3];
	float flSlenderPosition[3];
	NPCGetEyePosition(iBossIndex, flSlenderPosition);
	GetClientEyePosition(iTarget, flClientPos);

	float flBasePos[3], flBaseAng[3];
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flBasePos);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", flBaseAng);

	float flEffectPos[3];
	float flEffectAng[3] = {0.0, 0.0, 0.0};
	
	GetProfileAttackVector(sSlenderProfile, "attack_projectile_offset", flEffectPos, view_as<float>({0.0, 0.0, 0.0}), iAttackIndex+1);
	VectorTransform(flEffectPos, flBasePos, flBaseAng, flEffectPos);
	AddVectors(flEffectAng, flBaseAng, flEffectAng);

	float flShootDirection[3], flShootAng[3];
	SubtractVectors(flClientPos, flEffectPos, flShootDirection);
	NormalizeVector(flShootDirection, flShootDirection);
	GetVectorAngles(flShootDirection, flShootAng);

	int iTeam = 3;

	switch(iProjectileType)
	{
		case 0:		
		{
			sProjectileName = "tf_projectile_rocket";
			iProjectileEnt = CreateEntityByName(sProjectileName);
			if (iProjectileEnt != -1)
			{
				float flVelocity[3], flBufferProj[3];

				GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

				flVelocity[0] = flBufferProj[0]*NPCChaserGetAttackProjectileSpeed(iBossIndex, iAttackIndex);
				flVelocity[1] = flBufferProj[1]*NPCChaserGetAttackProjectileSpeed(iBossIndex, iAttackIndex);
				flVelocity[2] = flBufferProj[2]*NPCChaserGetAttackProjectileSpeed(iBossIndex, iAttackIndex);
				AttachParticle(iProjectileEnt, "spell_fireball_small_red");
				AttachParticle(iProjectileEnt, "spell_fireball_small_glow_red");

				SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hOwnerEntity", slender);
				SetEntPropFloat(iProjectileEnt, Prop_Data, "m_flModelScale", 1.0);
				SetEntityRenderMode(iProjectileEnt, RENDER_TRANSCOLOR);
				SetEntityRenderColor(iProjectileEnt, 0, 0, 0, 0);
				SetEntDataFloat(iProjectileEnt, FindSendPropInfo("CTFProjectile_Rocket", "m_iDeflected") + 4, 0.1, true); // set damage to nothing
				SDKHook(iProjectileEnt, SDKHook_StartTouch, Hook_FireballTouch); //This is where the damage comes into play.

				SetEntProp(iProjectileEnt,    Prop_Send, "m_iTeamNum",     2, 1);

				DispatchSpawn(iProjectileEnt);
				ProjectileSetFlags(iProjectileEnt, PROJ_FIREBALL);

				TeleportEntity(iProjectileEnt, flEffectPos, flShootAng, flVelocity);
				
				char sPath[PLATFORM_MAX_PATH];
				GetRandomStringFromProfile(sSlenderProfile, sSectionName, sPath, sizeof(sPath));
				
				if (sPath[0])
				{
					char sBuffer[512];
					strcopy(sBuffer, sizeof(sBuffer), sSectionName);
					StrCat(sBuffer, sizeof(sBuffer), "_volume");
					float flVolume = GetProfileFloat(sSlenderProfile, sBuffer, 1.0);
					strcopy(sBuffer, sizeof(sBuffer), sSectionName);
					StrCat(sBuffer, sizeof(sBuffer), "_channel");
					int iChannel = GetProfileNum(sSlenderProfile, sBuffer, SNDCHAN_WEAPON);
					strcopy(sBuffer, sizeof(sBuffer), sSectionName);
					StrCat(sBuffer, sizeof(sBuffer), "_level");
					int iLevel = GetProfileNum(sSlenderProfile, sBuffer, SNDLEVEL_SCREAMING);
					strcopy(sBuffer, sizeof(sBuffer), sSectionName);
					StrCat(sBuffer, sizeof(sBuffer), "_pitch");
					int iPitch = GetProfileNum(sSlenderProfile, sBuffer, 100);
					
					EmitSoundToAll(sPath, slender, iChannel, iLevel, _, flVolume, iPitch);
				}
			}
		}
		case 1:
		{
			sProjectileName = "tf_projectile_rocket";
			iProjectileEnt = CreateEntityByName(sProjectileName);
			if (iProjectileEnt != -1)
			{
				float flVelocity[3], flBufferProj[3];

				GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

				flVelocity[0] = flBufferProj[0]*NPCChaserGetAttackProjectileSpeed(iBossIndex, iAttackIndex);
				flVelocity[1] = flBufferProj[1]*NPCChaserGetAttackProjectileSpeed(iBossIndex, iAttackIndex);
				flVelocity[2] = flBufferProj[2]*NPCChaserGetAttackProjectileSpeed(iBossIndex, iAttackIndex);

				SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hOwnerEntity", slender);
				if (NPCChaserGetAttackProjectileCrits(iBossIndex, iAttackIndex)) SetEntProp(iProjectileEnt,    Prop_Send, "m_bCritical", 1, 1);
				SetEntDataFloat(iProjectileEnt, FindSendPropInfo("CTFProjectile_Rocket", "m_iDeflected") + 4, NPCChaserGetAttackProjectileDamage(iBossIndex, iAttackIndex), true); // set damage
				ProjectileSetFlags(iProjectileEnt, PROJ_ROCKET);

				SetEntProp(iProjectileEnt,    Prop_Send, "m_iTeamNum",     iTeam, 1);

				DispatchSpawn(iProjectileEnt);

				TeleportEntity(iProjectileEnt, flEffectPos, flShootAng, flVelocity);

				char sPath[PLATFORM_MAX_PATH];
				GetRandomStringFromProfile(sSlenderProfile, sSectionName, sPath, sizeof(sPath));
				
				if (sPath[0])
				{
					char sBuffer[512];
					strcopy(sBuffer, sizeof(sBuffer), sSectionName);
					StrCat(sBuffer, sizeof(sBuffer), "_volume");
					float flVolume = GetProfileFloat(sSlenderProfile, sBuffer, 1.0);
					strcopy(sBuffer, sizeof(sBuffer), sSectionName);
					StrCat(sBuffer, sizeof(sBuffer), "_channel");
					int iChannel = GetProfileNum(sSlenderProfile, sBuffer, SNDCHAN_WEAPON);
					strcopy(sBuffer, sizeof(sBuffer), sSectionName);
					StrCat(sBuffer, sizeof(sBuffer), "_level");
					int iLevel = GetProfileNum(sSlenderProfile, sBuffer, SNDLEVEL_SCREAMING);
					strcopy(sBuffer, sizeof(sBuffer), sSectionName);
					StrCat(sBuffer, sizeof(sBuffer), "_pitch");
					int iPitch = GetProfileNum(sSlenderProfile, sBuffer, 100);
					
					EmitSoundToAll(sPath, slender, iChannel, iLevel, _, flVolume, iPitch);
				}
			}
		}
		case 2:
		{
			sProjectileName = "tf_projectile_rocket";
			iProjectileEnt = CreateEntityByName(sProjectileName);
			if (iProjectileEnt != -1)
			{
				float flVelocity[3], flBufferProj[3];

				GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

				flVelocity[0] = flBufferProj[0]*NPCChaserGetAttackProjectileSpeed(iBossIndex, iAttackIndex);
				flVelocity[1] = flBufferProj[1]*NPCChaserGetAttackProjectileSpeed(iBossIndex, iAttackIndex);
				flVelocity[2] = flBufferProj[2]*NPCChaserGetAttackProjectileSpeed(iBossIndex, iAttackIndex);
				AttachParticle(iProjectileEnt, "spell_fireball_small_blue");
				AttachParticle(iProjectileEnt, "spell_fireball_small_glow_blue");

				SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hOwnerEntity", slender);
				SetEntPropFloat(iProjectileEnt, Prop_Data, "m_flModelScale", 1.0);
				SetEntityRenderMode(iProjectileEnt, RENDER_TRANSCOLOR);
				SetEntityRenderColor(iProjectileEnt, 0, 0, 0, 0);
				SetEntDataFloat(iProjectileEnt, FindSendPropInfo("CTFProjectile_Rocket", "m_iDeflected") + 4, 0.1, true); // set damage to nothing
				SDKHook(iProjectileEnt, SDKHook_StartTouch, Hook_IceballTouch); //This is where the damage comes into play.

				SetEntProp(iProjectileEnt,    Prop_Send, "m_iTeamNum",     2, 1);

				DispatchSpawn(iProjectileEnt);
				ProjectileSetFlags(iProjectileEnt, PROJ_ICEBALL_ATTACK);

				TeleportEntity(iProjectileEnt, flEffectPos, flShootAng, flVelocity);

				char sPath[PLATFORM_MAX_PATH];
				GetRandomStringFromProfile(sSlenderProfile, sSectionName, sPath, sizeof(sPath));
				
				if (sPath[0])
				{
					char sBuffer[512];
					strcopy(sBuffer, sizeof(sBuffer), sSectionName);
					StrCat(sBuffer, sizeof(sBuffer), "_volume");
					float flVolume = GetProfileFloat(sSlenderProfile, sBuffer, 1.0);
					strcopy(sBuffer, sizeof(sBuffer), sSectionName);
					StrCat(sBuffer, sizeof(sBuffer), "_channel");
					int iChannel = GetProfileNum(sSlenderProfile, sBuffer, SNDCHAN_WEAPON);
					strcopy(sBuffer, sizeof(sBuffer), sSectionName);
					StrCat(sBuffer, sizeof(sBuffer), "_level");
					int iLevel = GetProfileNum(sSlenderProfile, sBuffer, SNDLEVEL_SCREAMING);
					strcopy(sBuffer, sizeof(sBuffer), sSectionName);
					StrCat(sBuffer, sizeof(sBuffer), "_pitch");
					int iPitch = GetProfileNum(sSlenderProfile, sBuffer, 100);
					
					EmitSoundToAll(sPath, slender, iChannel, iLevel, _, flVolume, iPitch);
				}
			}
		}
	}
	return iProjectileEnt;
}

void NPCChaserUpdateBossAnimation(int iBossIndex, int iEnt, int iState, bool bSpawn = false)
{
	char sAnimation[256];
	float flPlaybackRate, flTempFootsteps;
	bool bAnimationFound = false;
	
	int iDifficulty = GetConVarInt(g_cvDifficulty);
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
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
						bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderIdleFootstepTime[iBossIndex]);
					}
					case Difficulty_Hard:
					{
						bool bAnimationFound2 = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderIdleFootstepTime[iBossIndex]);
						if (!bAnimationFound2 || strcmp(sAnimation,"") <= 0)
						{
							bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderIdleFootstepTime[iBossIndex]);
						}
						else
						{
							bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderIdleFootstepTime[iBossIndex]);
						}
					}
					case Difficulty_Insane:
					{
						bool bAnimationFound3 = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderIdleFootstepTime[iBossIndex]);
						if (!bAnimationFound3 || strcmp(sAnimation,"") <= 0)
						{
							bool bAnimationFound2 = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderIdleFootstepTime[iBossIndex]);
							if (!bAnimationFound2 || strcmp(sAnimation,"") <= 0)
							{
								bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderIdleFootstepTime[iBossIndex]);
							}
							else
							{
								bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderIdleFootstepTime[iBossIndex]);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderIdleFootstepTime[iBossIndex]);
						}
					}
					case Difficulty_Nightmare:
					{
						bool bAnimationFound4 = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderIdleFootstepTime[iBossIndex]);
						if (!bAnimationFound4 || strcmp(sAnimation,"") <= 0)
						{
							bool bAnimationFound3 = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderIdleFootstepTime[iBossIndex]);
							if (!bAnimationFound3 || strcmp(sAnimation,"") <= 0)
							{
								bool bAnimationFound2 = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderIdleFootstepTime[iBossIndex]);
								if (!bAnimationFound2 || strcmp(sAnimation,"") <= 0)
								{
									bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderIdleFootstepTime[iBossIndex]);
								}
								else
								{
									bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderIdleFootstepTime[iBossIndex]);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderIdleFootstepTime[iBossIndex]);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderIdleFootstepTime[iBossIndex]);
						}
					}
					case Difficulty_Apollyon:
					{
						bool bAnimationFound5 = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderIdleFootstepTime[iBossIndex]);
						if (!bAnimationFound5 || strcmp(sAnimation,"") <= 0)
						{
							bool bAnimationFound4 = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderIdleFootstepTime[iBossIndex]);
							if (!bAnimationFound4 || strcmp(sAnimation,"") <= 0)
							{
								bool bAnimationFound3 = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderIdleFootstepTime[iBossIndex]);
								if (!bAnimationFound3 || strcmp(sAnimation,"") <= 0)
								{
									bool bAnimationFound2 = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderIdleFootstepTime[iBossIndex]);
									if (bAnimationFound2 || strcmp(sAnimation,"") <= 0)
									{
										bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderIdleFootstepTime[iBossIndex]);
									}
									else
									{
										bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderIdleFootstepTime[iBossIndex]);
									}
								}
								else
								{
									bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderIdleFootstepTime[iBossIndex]);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderIdleFootstepTime[iBossIndex]);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderIdleFootstepTime[iBossIndex]);
						}
					}
				}
			}
			else
			{
				bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_SpawnAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, flTempFootsteps);
			}
		}
		case STATE_WANDER:
		{
			if (NPCGetFlags(iBossIndex) & SFF_WANDERMOVE)
			{
				switch (iDifficulty)
				{
					case Difficulty_Normal:
					{
						bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
					}
					case Difficulty_Hard:
					{
						bool bAnimationFound2 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						if (!bAnimationFound2 || strcmp(sAnimation,"") <= 0)
						{
							bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						}
						else
						{
							bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						}
					}
					case Difficulty_Insane:
					{
						bool bAnimationFound3 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						if (!bAnimationFound3 || strcmp(sAnimation,"") <= 0)
						{
							bool bAnimationFound2 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							if (!bAnimationFound2 || strcmp(sAnimation,"") <= 0)
							{
								bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							}
							else
							{
								bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						}
					}
					case Difficulty_Nightmare:
					{
						bool bAnimationFound4 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						if (!bAnimationFound4 || strcmp(sAnimation,"") <= 0)
						{
							bool bAnimationFound3 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							if (!bAnimationFound3 || strcmp(sAnimation,"") <= 0)
							{
								bool bAnimationFound2 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								if (!bAnimationFound2 || strcmp(sAnimation,"") <= 0)
								{
									bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								}
								else
								{
									bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						}
					}
					case Difficulty_Apollyon:
					{
						bool bAnimationFound5 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						if (!bAnimationFound5 || strcmp(sAnimation,"") <= 0)
						{
							bool bAnimationFound4 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							if (!bAnimationFound4 || strcmp(sAnimation,"") <= 0)
							{
								bool bAnimationFound3 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								if (!bAnimationFound3 || strcmp(sAnimation,"") <= 0)
								{
									bool bAnimationFound2 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
									if (!bAnimationFound2 || strcmp(sAnimation,"") <= 0)
									{
										bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex]);
									}
									else
									{
										bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
									}
								}
								else
								{
									bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						}
					}	
				}
			}
		}
		case STATE_ALERT:
		{
			if (view_as<bool>(GetProfileNum(sProfile,"use_alert_walking_animation",0)))
			{
				switch (iDifficulty)
				{
					case Difficulty_Normal:
					{
						bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
					}
					case Difficulty_Hard:
					{
						bool bAnimationFound2 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						if (!bAnimationFound2 || strcmp(sAnimation,"") <= 0)
						{
							bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						}
						else
						{
							bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						}
					}
					case Difficulty_Insane:
					{
						bool bAnimationFound3 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						if (!bAnimationFound3 || strcmp(sAnimation,"") <= 0)
						{
							bool bAnimationFound2 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							if (!bAnimationFound2 || strcmp(sAnimation,"") <= 0)
							{
								bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							}
							else
							{
								bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						}
					}
					case Difficulty_Nightmare:
					{
						bool bAnimationFound4 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						if (!bAnimationFound4 || strcmp(sAnimation,"") <= 0)
						{
							bool bAnimationFound3 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							if (!bAnimationFound3 || strcmp(sAnimation,"") <= 0)
							{
								bool bAnimationFound2 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								if (!bAnimationFound2 || strcmp(sAnimation,"") <= 0)
								{
									bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								}
								else
								{
									bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						}
					}
					case Difficulty_Apollyon:
					{
						bool bAnimationFound5 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						if (!bAnimationFound5 || strcmp(sAnimation,"") <= 0)
						{
							bool bAnimationFound4 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							if (!bAnimationFound4 || strcmp(sAnimation,"") <= 0)
							{
								bool bAnimationFound3 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								if (!bAnimationFound3 || strcmp(sAnimation,"") <= 0)
								{
									bool bAnimationFound2 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
									if (!bAnimationFound2 || strcmp(sAnimation,"") <= 0)
									{
										bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex]);
									}
									else
									{
										bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
									}
								}
								else
								{
									bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAlertAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
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
						bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
					}
					case Difficulty_Hard:
					{
						bool bAnimationFound2 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						if (!bAnimationFound2 || strcmp(sAnimation,"") <= 0)
						{
							bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						}
						else
						{
							bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						}
					}
					case Difficulty_Insane:
					{
						bool bAnimationFound3 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						if (!bAnimationFound3 || strcmp(sAnimation,"") <= 0)
						{
							bool bAnimationFound2 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							if (!bAnimationFound2 || strcmp(sAnimation,"") <= 0)
							{
								bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							}
							else
							{
								bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						}
					}
					case Difficulty_Nightmare:
					{
						bool bAnimationFound4 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						if (!bAnimationFound4 || strcmp(sAnimation,"") <= 0)
						{
							bool bAnimationFound3 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							if (!bAnimationFound3 || strcmp(sAnimation,"") <= 0)
							{
								bool bAnimationFound2 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								if (!bAnimationFound2 || strcmp(sAnimation,"") <= 0)
								{
									bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								}
								else
								{
									bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						}
					}
					case Difficulty_Apollyon:
					{
						bool bAnimationFound5 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						if (!bAnimationFound5 || strcmp(sAnimation,"") <= 0)
						{
							bool bAnimationFound4 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							if (!bAnimationFound4 || strcmp(sAnimation,"") <= 0)
							{
								bool bAnimationFound3 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								if (!bAnimationFound3 || strcmp(sAnimation,"") <= 0)
								{
									bool bAnimationFound2 = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
									if (!bAnimationFound2 || strcmp(sAnimation,"") <= 0)
									{
										bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderWalkFootstepTime[iBossIndex]);
									}
									else
									{
										bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderWalkFootstepTime[iBossIndex]);
									}
								}
								else
								{
									bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderWalkFootstepTime[iBossIndex]);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderWalkFootstepTime[iBossIndex]);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderWalkFootstepTime[iBossIndex]);
						}
					}	
				}
			}
		}
		case STATE_CHASE:
		{
			if (!g_bNPCUsesChaseInitialAnimation[iBossIndex] && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && !g_bNPCUsesHealAnimation[iBossIndex] && !g_bNPCUseStartFleeAnimation[iBossIndex])
			{
				switch (iDifficulty)
				{
					case Difficulty_Normal:
					{
						bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex]);
					}
					case Difficulty_Hard:
					{
						bool bAnimationFound2 = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex]);
						if (!bAnimationFound2 || strcmp(sAnimation,"") <= 0)
						{
							bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderRunFootstepTime[iBossIndex]);
						}
						else
						{
							bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex]);
						}
					}
					case Difficulty_Insane:
					{
						bool bAnimationFound3 = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex]);
						if (!bAnimationFound3 || strcmp(sAnimation,"") <= 0)
						{
							bool bAnimationFound2 = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderRunFootstepTime[iBossIndex]);
							if (!bAnimationFound2 || strcmp(sAnimation,"") <= 0)
							{
								bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderRunFootstepTime[iBossIndex]);
							}
							else
							{
								bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderRunFootstepTime[iBossIndex]);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex]);
						}
					}
					case Difficulty_Nightmare:
					{
						bool bAnimationFound4 = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex]);
						if (!bAnimationFound4 || strcmp(sAnimation,"") <= 0)
						{
							bool bAnimationFound3 = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderRunFootstepTime[iBossIndex]);
							if (!bAnimationFound3 || strcmp(sAnimation,"") <= 0)
							{
								bool bAnimationFound2 = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderRunFootstepTime[iBossIndex]);
								if (!bAnimationFound2 || strcmp(sAnimation,"") <= 0)
								{
									bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderRunFootstepTime[iBossIndex]);
								}
								else
								{
									bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderRunFootstepTime[iBossIndex]);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderRunFootstepTime[iBossIndex]);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex]);
						}
					}
					case Difficulty_Apollyon:
					{
						bool bAnimationFound5 = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex]);
						if (!bAnimationFound5 || strcmp(sAnimation,"") <= 0)
						{
							bool bAnimationFound4 = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderRunFootstepTime[iBossIndex]);
							if (!bAnimationFound4 || strcmp(sAnimation,"") <= 0)
							{
								bool bAnimationFound3 = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderRunFootstepTime[iBossIndex]);
								if (!bAnimationFound3 || strcmp(sAnimation,"") <= 0)
								{
									bool bAnimationFound2 = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderRunFootstepTime[iBossIndex]);
									if (!bAnimationFound2 || strcmp(sAnimation,"") <= 0)
									{
										bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderRunFootstepTime[iBossIndex]);
									}
									else
									{
										bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 2, _, g_flSlenderRunFootstepTime[iBossIndex]);
									}
								}
								else
								{
									bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 3, _, g_flSlenderRunFootstepTime[iBossIndex]);
								}
							}
							else
							{
								bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 4, _, g_flSlenderRunFootstepTime[iBossIndex]);
							}
						}
						else
						{
							bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, iDifficulty, _, g_flSlenderRunFootstepTime[iBossIndex]);
						}
					}	
				}
			}
			else if (g_bNPCUsesChaseInitialAnimation[iBossIndex])
			{
				bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_ChaseInitialAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, flTempFootsteps);
			}
			else if (g_bNPCUsesRageAnimation1[iBossIndex] || g_bNPCUsesRageAnimation2[iBossIndex] || g_bNPCUsesRageAnimation3[iBossIndex])
			{
				bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_RageAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, flTempFootsteps);
			}
		}
		case STATE_ATTACK:
		{
			if (!g_bNPCUseFireAnimation[iBossIndex])
			{
				bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_AttackAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, NPCGetCurrentAttackIndex(iBossIndex)+1, g_flSlenderAttackFootstepTime[iBossIndex]);
			}
			else
			{
				bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_ShootAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, NPCGetCurrentAttackIndex(iBossIndex)+1, g_flSlenderAttackFootstepTime[iBossIndex]);
			}
		}
		case STATE_STUN:
		{
			bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_StunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, g_flSlenderStunFootstepTime[iBossIndex]);
		}
	}
	switch (iState)
	{
		case STATE_IDLE, STATE_WANDER, STATE_ALERT, STATE_CHASE:
		{
			if (g_bNPCUseStartFleeAnimation[iBossIndex])
			{
				bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_FleeInitialAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, flTempFootsteps);
			}
			else if (g_bNPCUsesHealAnimation[iBossIndex])
			{
				bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_HealAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, 1, _, flTempFootsteps);
			}
		}
	}
	
	if (flPlaybackRate<-12.0) flPlaybackRate = -12.0;
	if (flPlaybackRate>12.0) flPlaybackRate = 12.0;

	if (bAnimationFound && strcmp(sAnimation,"") != 0)
	{
		Action action = Plugin_Continue;
		Call_StartForward(fOnBossAnimationUpdate);
		Call_PushCell(iBossIndex);
		Call_Finish(action);
		if (action != Plugin_Handled)
		{
			g_flNPCCurrentAnimationSequencePlaybackRate[iBossIndex] = flPlaybackRate;
			g_iNPCCurrentAnimationSequence[iBossIndex] = EntitySetAnimation(iEnt, sAnimation, flPlaybackRate);
			g_sNPCurrentAnimationSequenceName[iBossIndex] = sAnimation;
			EntitySetAnimation(iEnt, sAnimation, flPlaybackRate);//Fix an issue where an anim could start on the wrong frame.
			if (g_iNPCCurrentAnimationSequence[iBossIndex] <= -1)
			{
				g_iNPCCurrentAnimationSequence[iBossIndex] = 0;
				//SendDebugMessageToPlayers(DEBUG_BOSS_ANIMATION, 0, "INVALID ANIMATION %s", sAnimation);
			}
			bool bAnimationLoop = (iState == STATE_IDLE || iState == STATE_ALERT || (iState == STATE_CHASE && !g_bNPCUsesChaseInitialAnimation[iBossIndex] && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && !g_bNPCUseStartFleeAnimation[iBossIndex] && !g_bNPCUsesHealAnimation[iBossIndex]) || iState == STATE_WANDER);
			SetEntProp(iEnt, Prop_Data, "m_bSequenceLoops", bAnimationLoop);
		}
	}
}

public void SlenderChaseBossProcessMovement(int iBoss)
{
	int iBossIndex = NPCGetFromEntIndex(iBoss);
	if (iBossIndex == -1)
	{
		//Boss is invalid somehow, and the hook wasn't killed.
		SDKUnhook(iBoss, SDKHook_Think, SlenderChaseBossProcessMovement);
		return;
	}

	char sSlenderProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sSlenderProfile, sizeof(sSlenderProfile));
	
	float flMyPos[3], flMyEyeAng[3];
	GetEntPropVector(iBoss, Prop_Data, "m_vecAbsOrigin", flMyPos);
	GetEntPropVector(iBoss, Prop_Data, "m_angAbsRotation", flMyEyeAng);
	
	SDKCall(g_hSDKStudioFrameAdvance, iBoss);
	
	int iState = g_iSlenderState[iBossIndex];
	int iOldState = g_iSlenderOldState[iBossIndex];
	g_iSlenderOldState[iBossIndex] = iState;
	
	int iAttackIndex = NPCGetCurrentAttackIndex(iBossIndex);
	
	// Process angles.
	bool bChangeAngle = false;
	float vecPosToAt[3];
	if (iState != STATE_STUN)
	{
		int iTarget = EntRefToEntIndex(g_iSlenderTarget[iBossIndex]);
		
		if (NPCHasAttribute(iBossIndex, "always look at target"))
		{
			if (iTarget && iTarget != INVALID_ENT_REFERENCE)
			{
				bChangeAngle = true;
				GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", vecPosToAt);
			}
		}
		else
		{
			switch (iState)
			{
				case STATE_CHASE:
				{
					bool bCanSeeTarget = false;
					if (iTarget && iTarget != INVALID_ENT_REFERENCE)
					{
						float vecTargetPos[3], vecMyEyePos[3];
						NPCGetEyePosition(iBossIndex, vecMyEyePos);
						GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", vecTargetPos);
						vecTargetPos[2] += 18.0;
						if (GetVectorDistance(vecTargetPos, vecMyEyePos, false) <= 100.0)
						{
							TR_TraceRayFilter(vecMyEyePos, vecTargetPos, MASK_NPCSOLID, RayType_EndPoint, TraceRayDontHitCharacters, iBoss);
							bCanSeeTarget = !TR_DidHit();
						}
					}

					if (bCanSeeTarget)
					{
						bCanSeeTarget = NPCShouldSeeEntity(iBossIndex, iTarget);
					}
					
					if (NPCHasAttribute(iBossIndex, "always look at target while chasing") || bCanSeeTarget)
					{
						if (iTarget && iTarget != INVALID_ENT_REFERENCE)
						{
							bChangeAngle = true;
							GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", vecPosToAt);

						}
					}
					
					if (g_bNPCUsesChaseInitialAnimation[iBossIndex] || g_bNPCUsesRageAnimation1[iBossIndex] || g_bNPCUsesRageAnimation2[iBossIndex] || g_bNPCUsesRageAnimation3[iBossIndex] || g_bNPCUseStartFleeAnimation[iBossIndex])
					{
						if (iTarget && iTarget != INVALID_ENT_REFERENCE)
						{
							bChangeAngle = true;
							GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", vecPosToAt);
						}
					}
					if (!g_ILocomotion[iBossIndex].IsOnGround() || g_ILocomotion[iBossIndex].IsClimbingOrJumping())
					{
						if (iTarget && iTarget != INVALID_ENT_REFERENCE)
						{
							float vecTargetPos[3], vecMyEyePos[3];
							NPCGetEyePosition(iBossIndex, vecMyEyePos);
							GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", vecTargetPos);
							vecTargetPos[2] += 18.0;
							if (GetVectorDistance(vecTargetPos, vecMyEyePos, false) <= 400.0)
							{
								bChangeAngle = true;
								GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", vecPosToAt);
							}
						}
					}
				}
				case STATE_ATTACK:
				{
					if (NPCHasAttribute(iBossIndex, "always look at target while attacking") && GetProfileAttackNum(sSlenderProfile, "attack_ignore_always_looking", 0, iAttackIndex+1) == 0 && ((NPCChaserGetAttackType(iBossIndex, iAttackIndex) != SF2BossAttackType_Ranged || NPCChaserGetAttackType(iBossIndex, iAttackIndex) != SF2BossAttackType_Projectile || NPCChaserGetAttackType(iBossIndex, iAttackIndex) != SF2BossAttackType_LaserBeam)))
					{
						if (iTarget && iTarget != INVALID_ENT_REFERENCE)
						{
							bChangeAngle = true;
							GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", vecPosToAt);
						}
					}
					if (NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_Ranged || NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_Projectile || NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_LaserBeam)
					{
						if (iTarget && iTarget != INVALID_ENT_REFERENCE)
						{
							bChangeAngle = true;
							GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", vecPosToAt);
						}
					}
				}
			}
		}
	}
	
	if (bChangeAngle) g_ILocomotion[iBossIndex].FaceTowards(vecPosToAt);
	
	// Process our desired speed.
	bool bPFUpdate = false;
	switch (iState)
	{
		case STATE_WANDER:
		{
			if ((NPCGetFlags(iBossIndex) & SFF_WANDERMOVE))
			{
				bPFUpdate = true;
				g_ILocomotion[iBossIndex].Walk();
			}
		}
		case STATE_ALERT:
		{
			bPFUpdate = true;
			g_ILocomotion[iBossIndex].Walk();
		}
		case STATE_CHASE:
		{
			bPFUpdate = true;
			g_ILocomotion[iBossIndex].Run();
		}
	}
	if (bPFUpdate)
	{
		g_hBossChaserPathLogic[iBossIndex].Update(g_INextBot[iBossIndex], !bChangeAngle, TraceRayDontHitBosses);
	}
	else
		g_ILocomotion[iBossIndex].Stop();
	if (iState != iOldState)
	{
		g_INextBot[iBossIndex].Update();
	}

	if (!g_ILocomotion[iBossIndex].IsOnGround() && !g_ILocomotion[iBossIndex].IsClimbingOrJumping())
	{
		float hullcheckmins[3], hullcheckmaxs[3];
		if (NPCGetRaidHitbox(iBossIndex) == 1)
		{
			hullcheckmins = g_flSlenderDetectMins[iBossIndex];
			hullcheckmaxs = g_flSlenderDetectMaxs[iBossIndex];
		}
		else if (NPCGetRaidHitbox(iBossIndex) == 0)
		{
			hullcheckmins = HULL_HUMAN_MINS;
			hullcheckmaxs = HULL_HUMAN_MAXS;
		}
		hullcheckmins[0] -= 10.0;
		hullcheckmins[1] -= 10.0;
		
		hullcheckmaxs[0] += 10.0;
		hullcheckmaxs[1] += 10.0;
		
		hullcheckmins[2] += g_ILocomotion[iBossIndex].GetStepHeight();
		hullcheckmaxs[2] -= g_ILocomotion[iBossIndex].GetStepHeight();
		
		if (!g_bNPCVelocityCancel[iBossIndex] && IsSpaceOccupiedIgnorePlayers(flMyPos, hullcheckmins, hullcheckmaxs, iBoss))//The boss will start to merge with shits, cancel out velocity.
		{
			float vec3Origin[3];
			g_ILocomotion[iBossIndex].SetVelocity(vec3Origin);
			g_bNPCVelocityCancel[iBossIndex] = true;
		}
	}
	else
		g_bNPCVelocityCancel[iBossIndex] = false;
	
	if (iState != STATE_IDLE && iState != STATE_STUN && iState != STATE_ATTACK)
	{
		bool bRunUnstuck = (iState == STATE_CHASE && g_flSlenderCalculatedSpeed[iBossIndex] > 0.0);
		if (!bRunUnstuck) bRunUnstuck = (iState == STATE_ALERT && g_flSlenderCalculatedWalkSpeed[iBossIndex] > 0.0);
		if (!bRunUnstuck) bRunUnstuck = (iState == STATE_WANDER && (NPCGetFlags(iBossIndex) & SFF_WANDERMOVE) && g_flSlenderCalculatedWalkSpeed[iBossIndex] > 0.0);
		if (bRunUnstuck)
		{
			if (GetVectorDistance(flMyPos, g_flLastPos[iBossIndex], false) < 0.01 || g_ILocomotion[iBossIndex].IsStuck())
			{
				bool bBlockingProp = false;
				
				if (NPCGetFlags(iBossIndex) & SFF_ATTACKPROPS)
				{
					for (int iAttackIndex2 = 0; iAttackIndex2 < NPCChaserGetAttackCount(iBossIndex); iAttackIndex2++)
					{
						if (NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_Ranged || NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_Projectile || NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_LaserBeam) continue;
						bBlockingProp = NPC_CanAttackProps(iBossIndex,NPCChaserGetAttackRange(iBossIndex, iAttackIndex2), NPCChaserGetAttackSpread(iBossIndex, iAttackIndex2));
						if (bBlockingProp) break;
					}
				}
				
				if (!bBlockingProp)
				{
					if (g_flLastStuckTime[iBossIndex] == 0.0) g_flLastStuckTime[iBossIndex] = GetGameTime();
					
					if (g_flLastStuckTime[iBossIndex] <= GetGameTime()-1.0)
					{
						bool bPathResolved = false;
						float vecMovePos[3];
						g_hBossChaserPathLogic[iBossIndex].GetMovePosition(vecMovePos);
						
						if (SlenderChaseBoss_OnStuckResolvePath(iBoss, flMyPos, flMyEyeAng, vecMovePos, vecMovePos))
						{
							if (NPCGetRaidHitbox(iBossIndex) == 1)
							{
								if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, g_flSlenderDetectMins[iBossIndex], g_flSlenderDetectMaxs[iBossIndex], iBoss))
								{
									bPathResolved = true;
									TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
								}
								else
								{
									vecMovePos[2] += g_ILocomotion[iBossIndex].GetStepHeight();
									if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, g_flSlenderDetectMins[iBossIndex], g_flSlenderDetectMaxs[iBossIndex], iBoss))
									{
										bPathResolved = true;
										TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
									}
								}
							}
							else if (NPCGetRaidHitbox(iBossIndex) == 0)
							{
								if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
								{
									bPathResolved = true;
									TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
								}
								else
								{
									vecMovePos[2] += g_ILocomotion[iBossIndex].GetStepHeight();
									if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
									{
										bPathResolved = true;
										TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
									}
								}
							}
						}
						if (!bPathResolved)
						{
							g_hBossChaserPathLogic[iBossIndex].GetMovePosition(vecMovePos);
							if (NPCGetRaidHitbox(iBossIndex) == 1)
							{
								if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, g_flSlenderDetectMins[iBossIndex], g_flSlenderDetectMaxs[iBossIndex], iBoss))
								{
									bPathResolved = false;
									TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
								}
								else
								{
									vecMovePos[2] += g_ILocomotion[iBossIndex].GetStepHeight();
									if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, g_flSlenderDetectMins[iBossIndex], g_flSlenderDetectMaxs[iBossIndex], iBoss))
									{
										bPathResolved = true;
										TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
									}
									else
									{
										CNavArea area = NavMesh_GetNearestArea(flMyPos, _, 200.0);
										if (area == INVALID_NAV_AREA)
										{
											area = g_hBossChaserPathLogic[iBossIndex].GetMovePositionNavArea();
										}
										if (area != INVALID_NAV_AREA)
										{
											area.GetCenter(vecMovePos);
											if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, g_flSlenderDetectMins[iBossIndex], g_flSlenderDetectMaxs[iBossIndex], iBoss))
											{
												bPathResolved = false;
												TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
											}
											else
											{
												vecMovePos[2] += g_ILocomotion[iBossIndex].GetStepHeight();
												if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, g_flSlenderDetectMins[iBossIndex], g_flSlenderDetectMaxs[iBossIndex], iBoss))
												{
													bPathResolved = true;
													TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
												}
											}
										}
										if (!bPathResolved)
										{
											if (!SF_IsBoxingMap())
											{
												RemoveSlender(iBossIndex);//We are stuck there's no way out for us, unspawn, players are just going to abuse that we are stuck.
											}
											else
											{
												float flTeleportPos[3];
												ArrayList hRespawnPoint = new ArrayList();
												char sName[32];
												int ent = -1;
												while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
												{
													GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
													if (StrContains(sName, "sf2_boss_respawnpoint", false))
													{
														hRespawnPoint.Push(ent);
													}
												}
												ent = -1;
												if (hRespawnPoint.Length > 0) ent = hRespawnPoint.Get(GetRandomInt(0,hRespawnPoint.Length-1));
												
												delete hRespawnPoint;
												if (ent > MAX_BOSSES)
												{
													GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flTeleportPos);
													TeleportEntity(iBossIndex, flTeleportPos, NULL_VECTOR, NULL_VECTOR);
												}
												else
												{
													RemoveSlender(iBossIndex);
												}
											}
										}
									}
								}
							}
							else if (NPCGetRaidHitbox(iBossIndex) == 0)
							{
								if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
								{
									bPathResolved = false;
									TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
								}
								else
								{
									vecMovePos[2] += g_ILocomotion[iBossIndex].GetStepHeight();
									if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
									{
										bPathResolved = true;
										TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
									}
									else
									{
										CNavArea area = NavMesh_GetNearestArea(flMyPos, _, 200.0);
										if (area == INVALID_NAV_AREA)
										{
											area = g_hBossChaserPathLogic[iBossIndex].GetMovePositionNavArea();
										}
										if (area != INVALID_NAV_AREA)
										{
											area.GetCenter(vecMovePos);
											if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
											{
												bPathResolved = false;
												TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
											}
											else
											{
												vecMovePos[2] += g_ILocomotion[iBossIndex].GetStepHeight();
												if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
												{
													bPathResolved = true;
													TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
												}
											}
										}
										if (!bPathResolved)
										{
											if (!SF_IsBoxingMap())
											{
												RemoveSlender(iBossIndex);//We are stuck there's no way out for us, unspawn, players are just going to abuse that we are stuck.
											}
											else
											{
												float flTeleportPos[3];
												ArrayList hRespawnPoint = new ArrayList();
												char sName[32];
												int ent = -1;
												while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
												{
													GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
													if (StrContains(sName, "sf2_boss_respawnpoint", false))
													{
														hRespawnPoint.Push(ent);
													}
												}
												ent = -1;
												if (hRespawnPoint.Length > 0) ent = hRespawnPoint.Get(GetRandomInt(0,hRespawnPoint.Length-1));
												
												delete hRespawnPoint;
												if (ent > MAX_BOSSES)
												{
													GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flTeleportPos);
													TeleportEntity(iBossIndex, flTeleportPos, NULL_VECTOR, NULL_VECTOR);
												}
												else
												{
													RemoveSlender(iBossIndex);
												}
											}
										}
									}
								}
							}
						}
						if (bPathResolved)
						{
							g_flLastStuckTime[iBossIndex] = 0.0;
						}
					}
				}
			}
			else
			{
				g_flLastStuckTime[iBossIndex] = 0.0;
				g_flLastPos[iBossIndex] = flMyPos;
			}
		}
	}
	
	Address pStudioHdr = CBaseAnimating_GetModelPtr(iBoss);
	if (pStudioHdr != Address_Null)
	{
		int m_iMoveX = CBaseAnimating_LookupPoseParameter(iBoss, pStudioHdr, "move_x");
		int m_iMoveY = CBaseAnimating_LookupPoseParameter(iBoss, pStudioHdr, "move_y");
		
		float flGroundSpeed = g_ILocomotion[iBossIndex].GetGroundSpeed();
		if ( flGroundSpeed != 0.0 )
		{
			float vecForward[3], vecRight[3], vecUp[3], vecMotion[3];
			SDK_GetVectors(iBoss, vecForward, vecRight, vecUp);
			g_ILocomotion[iBossIndex].GetGroundMotionVector(vecMotion);
			
			if (m_iMoveX >= 0) CBaseAnimating_SetPoseParameter(iBoss, pStudioHdr, m_iMoveX, GetVectorDotProduct(vecMotion,vecForward));
			if (m_iMoveY >= 0) CBaseAnimating_SetPoseParameter(iBoss, pStudioHdr, m_iMoveY, GetVectorDotProduct(vecMotion,vecRight));
		}
		else
		{
			if (m_iMoveX >= 0) CBaseAnimating_SetPoseParameter(iBoss, pStudioHdr, m_iMoveX, 0.0);
			if (m_iMoveY >= 0) CBaseAnimating_SetPoseParameter(iBoss, pStudioHdr, m_iMoveY, 0.0);
		}
		
		if (m_iMoveX < 0 && m_iMoveY < 0) return;
		
		if (iState == STATE_CHASE || iState == STATE_ALERT || iState == STATE_WANDER)
		{
			float m_flGroundSpeed = GetEntPropFloat(iBoss, Prop_Data, "m_flGroundSpeed");
			if(m_flGroundSpeed != 0.0 && g_ILocomotion[iBossIndex].IsOnGround())
			{
				float flReturnValue = flGroundSpeed / m_flGroundSpeed;
				if (flReturnValue < -4.0) flReturnValue = -4.0;
				if (flReturnValue > 12.0) flReturnValue = 12.0;
				
				SetEntPropFloat(iBoss, Prop_Send, "m_flPlaybackRate", flReturnValue);
			}
		}
	}
	
	return;
}

//Note: This functions is really expensive you better call this function only if you really need it!
bool SlenderChaseBoss_OnStuckResolvePath(int slender, float flMyPos[3], float flMyAng[3], float flGoalPosition[3], float flReturn[3])
{
	//We are stuck, try to find a free pos to path on the right or left.
	int attemp = 1;
	while (attemp <= 2)
	{
		float yawMin, yawMax, yawInc;
		if (attemp == 1) //We will first try on the right
		{
			yawMin = 10.0;
			yawMax = 90.0;
			yawInc = 5.0;
		}
		else if (attemp == 2) //Then on the left
		{
			yawMin = -90.0;
			yawMax = -10.0;
			yawInc = 5.0;
		}
		//Note: Actually there's no right and left, it's just to give you an idea on how this will be done. 
		for(float y=yawMin; y<=yawMax; y+=yawInc)
		{
			flMyAng[1] += y;
			for(float r=30.0; r<=300.0; r+=10.0)
			{
				float flFreePos[3];
				GetPositionForward(flMyPos, flMyAng, flFreePos, r);

				// Perform a line of sight check to avoid spawning players in unreachable map locations.
				TR_TraceRayFilter(flMyPos, flFreePos, MASK_NPCSOLID, RayType_EndPoint, TraceRayDontHitPlayersOrEntity, slender);

				if(!TR_DidHit())
				{
					// Perform an other line of sight check to avoid moving in a area that can't reach the original goal!
					TR_TraceRayFilter(flFreePos, flGoalPosition, MASK_NPCSOLID, RayType_EndPoint, TraceRayDontHitPlayersOrEntity, slender);
					if(!TR_DidHit())
					{
						TR_TraceHullFilter(flMyPos, flFreePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, MASK_NPCSOLID, TraceRayDontHitPlayersOrEntity, slender);
					
						if(!TR_DidHit())
						{
							flReturn = flFreePos;
							flMyAng[1] -= y;
							return true;
						}
					}
					else
					{
						//This free position can't bring us to the goal position. Give up on this angle.
						break;
					}
				}
				else
				{
					// We hit something that breaks the line of sight. Give up on this angle.
					break;
				}
			}
			flMyAng[1] -= y;
		}
		attemp++;
	}
	return false;
}

public MRESReturn IsAbleToClimb(Address pThis, Handle hReturn)
{
	DHookSetReturn(hReturn, true);
	return MRES_Supercede;
}
public MRESReturn NextBotGroundLocomotion_GetGroundNormal(Address pThis, Handle hReturn, Handle hParams)
{
    DHookSetReturnVector(hReturn, view_as<float>( { 0.0, 0.0, 1.0 } ));
    return MRES_Supercede;
}
public MRESReturn GetGravity(Address pThis, Handle hReturn)
{
	//Force the gravity. 
	DHookSetReturn(hReturn, g_flGravity);
#if defined DEBUG
	ILocomotion BossLocomotion = view_as<ILocomotion>(pThis);
	INextBot BossNextBot = view_as<INextBot>(BossLocomotion.GetBot());
	int iBossIndex = NPCGetFromINextBot(BossNextBot);
	if (iBossIndex != -1)
		SendDebugMessageToPlayers(DEBUG_NEXTBOT, 0, "Nextbot (%i) GetGravity:%0.0f", iBossIndex, g_flGravity);
#endif
	return MRES_Supercede;
}
public MRESReturn GetAcceleration(Address pThis, Handle hReturn)
{
	ILocomotion BossLocomotion = view_as<ILocomotion>(pThis);
	INextBot BossNextBot = view_as<INextBot>(BossLocomotion.GetBot());
	int iBossIndex = NPCGetFromINextBot(BossNextBot);
	if (iBossIndex == -1)
	{
		return MRES_Ignored;
	}
	DHookSetReturn(hReturn, g_flSlenderAcceleration[iBossIndex]);
#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_NEXTBOT, 0, "Nextbot (%i) GetAcceleration:%0.0f", iBossIndex, g_flSlenderAcceleration[iBossIndex]);
#endif
	return MRES_Supercede;
}
public MRESReturn GetMaxDeceleration(Address pThis, Handle hReturn)
{
	ILocomotion BossLocomotion = view_as<ILocomotion>(pThis);
	INextBot BossNextBot = view_as<INextBot>(BossLocomotion.GetBot());
	int iBossIndex = NPCGetFromINextBot(BossNextBot);
	if (iBossIndex == -1)
	{
		return MRES_Ignored;
	}
	DHookSetReturn(hReturn, g_flSlenderAcceleration[iBossIndex]);
#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_NEXTBOT, 0, "Nextbot (%i) GetDeceleration:%0.0f", iBossIndex, g_flSlenderAcceleration[iBossIndex]);
#endif
	return MRES_Supercede;
}
public MRESReturn GetStepHeight(Address pThis, Handle hReturn)
{
	ILocomotion BossLocomotion = view_as<ILocomotion>(pThis);
	INextBot BossNextBot = view_as<INextBot>(BossLocomotion.GetBot());
	int iBossIndex = NPCGetFromINextBot(BossNextBot);
	if (iBossIndex == -1)
	{
		return MRES_Ignored;
	}
	DHookSetReturn(hReturn, NPCChaserGetStepSize(iBossIndex));
#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_NEXTBOT, 0, "Nextbot (%i) GetStepSize:%0.0f", iBossIndex, NPCChaserGetStepSize(iBossIndex));
#endif
	return MRES_Supercede;
}
public MRESReturn GetMaxJumpHeight(Address pThis, Handle hReturn)
{
	ILocomotion BossLocomotion = view_as<ILocomotion>(pThis);
	INextBot BossNextBot = view_as<INextBot>(BossLocomotion.GetBot());
	int iBossIndex = NPCGetFromINextBot(BossNextBot);
	if (iBossIndex == -1)
	{
		return MRES_Ignored;
	}
	DHookSetReturn(hReturn, 190.0);
#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_NEXTBOT, 0, "(Deprecated)Nextbot (%i) GetMaxJumpHeight:190", iBossIndex);
#endif
	return MRES_Supercede;
}
public MRESReturn GetSpeedLimit(Address pThis, Handle hReturn)
{
	ILocomotion BossLocomotion = view_as<ILocomotion>(pThis);
	INextBot BossNextBot = view_as<INextBot>(BossLocomotion.GetBot());
	int iBossIndex = NPCGetFromINextBot(BossNextBot);
	if (iBossIndex == -1)
	{
		return MRES_Ignored;
	}
	float flSpeedLimit;
	int iState = g_iSlenderState[iBossIndex];
	switch(iState)
	{
		case STATE_CHASE, STATE_ATTACK:
		{
			flSpeedLimit = NPCGetMaxSpeed(iBossIndex, GetConVarInt(g_cvDifficulty));
		}
		default:
		{
			flSpeedLimit = NPCChaserGetMaxWalkSpeed(iBossIndex, GetConVarInt(g_cvDifficulty));
		}
	}
	DHookSetReturn(hReturn, flSpeedLimit);
#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_NEXTBOT, 0, "Nextbot (%i) GetSpeedLimit:%0.0f", iBossIndex, flSpeedLimit);
#endif
	//PrintToChatAll("Speed limit:%0.0f",flSpeedLimit);
	return MRES_Supercede;
}
public MRESReturn ShouldCollideWith(Address pThis, Handle hReturn, Handle hParams)
{
	int iEntity = DHookGetParam(hParams, 1);
	if (IsValidEntity(iEntity))
	{
		char strClass[32];
		GetEdictClassname(iEntity, strClass, sizeof(strClass));
#if defined DEBUG
		ILocomotion BossLocomotion = view_as<ILocomotion>(pThis);
		INextBot BossNextBot = view_as<INextBot>(BossLocomotion.GetBot());
		int iBossIndex = NPCGetFromINextBot(BossNextBot);
		if (iBossIndex != -1)
		{
			SendDebugMessageToPlayers(DEBUG_NEXTBOT, 0, "Nextbot (%i) ShouldCollideWith:%s", iBossIndex, strClass);
		}
#endif
		if(StrEqual(strClass, "tf_zombie"))
		{
			DHookSetReturn(hReturn, false);
			return MRES_Supercede;
		}
		else if(StrEqual(strClass, "base_boss"))
		{
			DHookSetReturn(hReturn, false);
			return MRES_Supercede;
		}
		else if (StrEqual(strClass, "player"))
		{
			if (g_bPlayerProxy[iEntity] || IsClientInGhostMode(iEntity))
			{
				DHookSetReturn(hReturn, false);
				return MRES_Supercede;
			}
		}
	}
	return MRES_Ignored;
}
//IBody
public MRESReturn StartActivity(Address pThis, Handle hReturn, Handle hParams)
{
	DHookSetReturn(hReturn, true);
	return MRES_Supercede;
}

public MRESReturn GetSolidMask(Address pThis, Handle hReturn)
{
	DHookSetReturn(hReturn, 0x203400B);
	return MRES_Supercede;
}

public MRESReturn GetCurrencyValue(Address pThis, Handle hReturn, Handle hParams)
{
	DHookSetReturn(hReturn, 0);
	return MRES_Supercede;
}

public MRESReturn GetHullWidth(Address pThis, Handle hReturn, Handle hParams)
{
	IBody pBody = view_as<IBody>(pThis);
	INextBot pNextBot = view_as<INextBot>(pBody.GetBot());
	int iEntity = pNextBot.GetEntity();

	float vecMaxs[3];
	GetEntPropVector(iEntity, Prop_Send, "m_vecMaxs", vecMaxs);
	
	if(vecMaxs[1] > vecMaxs[0])
		DHookSetReturn(hReturn, vecMaxs[1] * 2);
	else
		DHookSetReturn(hReturn, vecMaxs[0] * 2);

	return MRES_Supercede;
}

public MRESReturn GetHullHeight(Address pThis, Handle hReturn, Handle hParams)
{
	IBody pBody = view_as<IBody>(pThis);
	INextBot pNextBot = view_as<INextBot>(pBody.GetBot());
	int iEntity = pNextBot.GetEntity();

	float vecMaxs[3];
	GetEntPropVector(iEntity, Prop_Send, "m_vecMaxs", vecMaxs);
	
	DHookSetReturn(hReturn, vecMaxs[2]);

	return MRES_Supercede;
}

public MRESReturn GetStandHullHeight(Address pThis, Handle hReturn, Handle hParams)
{
	IBody pBody = view_as<IBody>(pThis);
	INextBot pNextBot = view_as<INextBot>(pBody.GetBot());
	int iEntity = pNextBot.GetEntity();

	float vecMaxs[3];
	GetEntPropVector(iEntity, Prop_Send, "m_vecMaxs", vecMaxs);
	
	DHookSetReturn(hReturn, vecMaxs[2]);

	return MRES_Supercede;
}

public MRESReturn GetCrouchHullHeight(Address pThis, Handle hReturn, Handle hParams)
{
	IBody pBody = view_as<IBody>(pThis);
	INextBot pNextBot = view_as<INextBot>(pBody.GetBot());
	int iEntity = pNextBot.GetEntity();

	float vecMaxs[3];
	GetEntPropVector(iEntity, Prop_Send, "m_vecMaxs", vecMaxs);
	
	DHookSetReturn(hReturn, vecMaxs[2] / 2);

	return MRES_Supercede;
}

public MRESReturn GetHullMins(Address pThis, Handle hReturn, Handle hParams)
{
	IBody pBody = view_as<IBody>(pThis);
	INextBot pNextBot = view_as<INextBot>(pBody.GetBot());
	int iEntity = pNextBot.GetEntity();

	float vecMins[3];
	GetEntPropVector(iEntity, Prop_Send, "m_vecMins", vecMins);
	
	DHookSetReturnVector(hReturn, vecMins);

	return MRES_Supercede;
}

public MRESReturn GetHullMaxs(Address pThis, Handle hReturn, Handle hParams)
{
	IBody pBody = view_as<IBody>(pThis);
	INextBot pNextBot = view_as<INextBot>(pBody.GetBot());
	int iEntity = pNextBot.GetEntity();

	float vecMaxs[3];
	GetEntPropVector(iEntity, Prop_Send, "m_vecMaxs", vecMaxs);
	
	DHookSetReturnVector(hReturn, vecMaxs);

	return MRES_Supercede;
}


// Shortest-path cost function for NavMesh_BuildPath.
public int SlenderChaseBossShortestPathCost(CNavArea area, CNavArea fromArea, CNavLadder ladder, any pBotLocomotion)
{
	if (fromArea == INVALID_NAV_AREA || area == INVALID_NAV_AREA)
	{
		return 0;
	}
	else
	{
		NextBotGroundLocomotion botLocomotion = view_as<NextBotGroundLocomotion>(pBotLocomotion);
		int iDist;
		float flAreaCenter[3], flFromAreaCenter[3];
		area.GetCenter(flAreaCenter);
		fromArea.GetCenter(flFromAreaCenter);
		
		if (ladder != INVALID_NAV_LADDER)
		{
			iDist = RoundFloat(ladder.Length);
		}
		else
		{
			iDist = RoundFloat(GetVectorDistance(flAreaCenter, flFromAreaCenter));
		}
		
		int iCost = iDist + fromArea.CostSoFar;
		
		if (area.Attributes & NAV_MESH_CROUCH) iCost += 20;
		if (area.Attributes & NAV_MESH_JUMP) iCost += (5 * iDist);
		
		if ((flAreaCenter[2] - flFromAreaCenter[2]) > botLocomotion.GetStepHeight()) iCost += RoundToFloor(botLocomotion.GetStepHeight());
		
		int iReturn = iCost;

		if (iReturn > 2)
		{
			iReturn = 2;
		}

		return iReturn;
	}
}


public Action PerformSmiteBoss(int client, int target, any entref)
{
	if (!g_bEnabled) return;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	// define where the lightning strike ends
	float clientpos[3];
	GetClientAbsOrigin(target, clientpos);
	clientpos[2] -= 26; // increase y-axis by 26 to strike at player's chest instead of the ground
	
	// get random numbers for the x and y starting positions
	int randomx = GetRandomInt(-500, 500);
	int randomy = GetRandomInt(-500, 500);
	
	// define where the lightning strike starts
	float startpos[3];
	startpos[0] = clientpos[0] + randomx;
	startpos[1] = clientpos[1] + randomy;
	startpos[2] = clientpos[2] + 800;
	
	// define the color of the strike
	int color[4];
	color[0] = NPCChaserGetSmiteColorR(iBossIndex);
	color[1] = NPCChaserGetSmiteColorG(iBossIndex);
	color[2] = NPCChaserGetSmiteColorB(iBossIndex);
	color[3] = NPCChaserGetSmiteColorTrans(iBossIndex);
	if (color[0] < 0) color[0] = 0;
	if (color[1] < 0) color[1] = 0;
	if (color[2] < 0) color[2] = 0;
	if (color[3] < 0) color[3] = 0;
	if (color[0] > 255) color[0] = 255;
	if (color[1] > 255) color[1] = 255;
	if (color[2] > 255) color[2] = 255;
	if (color[3] > 255) color[3] = 255;
	
	// define the direction of the sparks
	float dir[3];
	
	TE_SetupBeamPoints(startpos, clientpos, g_LightningSprite, 0, 0, 0, 0.2, 20.0, 10.0, 0, 1.0, color, 3);
	TE_SendToAll();
	
	TE_SetupSparks(clientpos, dir, 5000, 1000);
	TE_SendToAll();
	
	TE_SetupEnergySplash(clientpos, dir, false);
	TE_SendToAll();
	
	TE_SetupSmoke(clientpos, g_SmokeSprite, 5.0, 10);
	TE_SendToAll();
	
	EmitAmbientSound(SOUND_THUNDER, startpos, client, SNDLEVEL_RAIDSIREN);

}

public Action Timer_SlenderResetAlertCopy(Handle timer, any entref)
{
	if (!g_bEnabled) return;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return;
	
	if (timer != g_hNPCResetAlertCopyTimer[iBossIndex]) return;

	g_bNPCAlertedCopy[iBossIndex] = false;
	PrintToChatAll("We resetted our copies");
	
}

public Action Timer_SlenderStopAlerts(Handle timer, any entref)
{
	if (!g_bEnabled) return;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return;
	
	if (timer != g_hNPCRegisterAlertingCopiesTimer[iBossIndex]) return;

	g_bNPCStopAlertingCopies[iBossIndex] = true;
	
}

public Action Timer_SlenderChaseInitialTimer(Handle timer, any entref)
{
	if (!g_bEnabled) return;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return;
	
	if (timer != g_hSlenderChaseInitialTimer[iBossIndex]) return;
	
	if (!g_bNPCUsesChaseInitialAnimation[iBossIndex]) return;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

	int iOldState = g_iSlenderState[iBossIndex];
	int iState = iOldState;

	int iDifficulty = GetConVarInt(g_cvDifficulty);
	
	float flOriginalSpeed;
	
	if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S))
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
	if (iState != STATE_ATTACK) NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
	
}

public Action Timer_SlenderRageOneTimer(Handle timer, any entref)
{
	if (!g_bEnabled) return;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return;
	
	if (timer != g_hSlenderRage1Timer[iBossIndex]) return;
	
	if (!g_bNPCUsesRageAnimation1[iBossIndex]) return;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

	int iOldState = g_iSlenderState[iBossIndex];
	int iState = iOldState;

	int iDifficulty = GetConVarInt(g_cvDifficulty);
	
	float flOriginalSpeed;
	
	if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S))
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
	if (iState != STATE_ATTACK) NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
	
}

public Action Timer_SlenderRageTwoTimer(Handle timer, any entref)
{
	if (!g_bEnabled) return;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return;
	
	if (timer != g_hSlenderRage2Timer[iBossIndex]) return;
	
	if (!g_bNPCUsesRageAnimation2[iBossIndex]) return;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

	int iOldState = g_iSlenderState[iBossIndex];
	int iState = iOldState;

	int iDifficulty = GetConVarInt(g_cvDifficulty);
	
	float flOriginalSpeed;
	
	if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S))
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
	if (iState != STATE_ATTACK) NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
	
}

public Action Timer_SlenderRageThreeTimer(Handle timer, any entref)
{
	if (!g_bEnabled) return;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return;
	
	if (timer != g_hSlenderRage3Timer[iBossIndex]) return;
	
	if (!g_bNPCUsesRageAnimation3[iBossIndex]) return;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

	int iOldState = g_iSlenderState[iBossIndex];
	int iState = iOldState;

	int iDifficulty = GetConVarInt(g_cvDifficulty);
	
	float flOriginalSpeed;
	
	if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S))
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
	if (iState != STATE_ATTACK) NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
	
}

public Action Timer_SlenderSpawnTimer(Handle timer, any entref)
{
	if (!g_bEnabled) return;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return;
	
	if (timer != g_hSlenderSpawnTimer[iBossIndex]) return;
	
	if (!g_bSlenderSpawning[iBossIndex]) return;

	g_bSlenderSpawning[iBossIndex] = false;
	g_flLastStuckTime[iBossIndex] = 0.0;
	g_hSlenderEntityThink[iBossIndex] = CreateTimer(BOSS_THINKRATE, Timer_SlenderChaseBossThink, EntIndexToEntRef(slender), TIMER_REPEAT);
	NPCChaserUpdateBossAnimation(iBossIndex, slender, STATE_IDLE);
}

public Action Timer_SlenderHealAnimationTimer(Handle timer, any entref)
{
	if (!g_bEnabled) return;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return;
	
	if (timer != g_hSlenderHealTimer[iBossIndex]) return;

	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

	int iOldState = g_iSlenderState[iBossIndex];
	int iState = iOldState;

	int iDifficulty = GetConVarInt(g_cvDifficulty);
	
	float flOriginalSpeed;
	
	if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S))
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
	g_bNPCUseStartFleeAnimation[iBossIndex] = false;
	g_bNPCUsesHealAnimation[iBossIndex] = false;
	g_bNPCHealing[iBossIndex] = false;
	g_flNPCFleeHealTimer[iBossIndex] = GetGameTime();
	g_iNPCHealCount[iBossIndex] = 0;
	g_iNPCSelfHealStage[iBossIndex]++;
	NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
	g_hSlenderHealDelayTimer[iBossIndex] = INVALID_HANDLE;
	g_hSlenderStartFleeTimer[iBossIndex] = INVALID_HANDLE;
	g_hSlenderHealTimer[iBossIndex] = INVALID_HANDLE;
}

public Action Timer_SlenderHealDelayTimer(Handle timer, any entref)
{
	if (!g_bEnabled) return;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;

	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return;
	
	if (timer != g_hSlenderHealDelayTimer[iBossIndex]) return;
	
	SlenderPerformVoice(iBossIndex, "sound_heal_self");
	
	g_iNPCHealCount[iBossIndex] = 0;

	g_hSlenderHealEventTimer[iBossIndex] = CreateTimer(0.05, Timer_SlenderHealEventTimer, EntIndexToEntRef(slender), TIMER_REPEAT);
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
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	float flCheckPercentage;
	switch(g_iNPCSelfHealStage[iBossIndex])
	{
		case 0: flCheckPercentage = NPCChaserGetSelfHealPercentageOne(iBossIndex) * NPCChaserGetStunInitialHealth(iBossIndex);
		case 1: flCheckPercentage = NPCChaserGetSelfHealPercentageTwo(iBossIndex) * NPCChaserGetStunInitialHealth(iBossIndex);
		case 2, 3: flCheckPercentage = NPCChaserGetSelfHealPercentageThree(iBossIndex) * NPCChaserGetStunInitialHealth(iBossIndex);
	}
	float flRegenHealth = flCheckPercentage/10.0;
	
	if (NPCChaserGetStunHealth(iBossIndex) + flRegenHealth < NPCChaserGetStunInitialHealth(iBossIndex))
	{
		NPCChaserAddStunHealth(iBossIndex, flRegenHealth);
		if (view_as<bool>(GetProfileNum(sProfile,"healthbar",0)))
		{
			UpdateHealthBar(iBossIndex);
		}
		g_iNPCHealCount[iBossIndex]++;
	}
	else
	{
		float flAddRemainHealth = NPCChaserGetStunInitialHealth(iBossIndex) - NPCChaserGetStunHealth(iBossIndex);
		NPCChaserAddStunHealth(iBossIndex, flAddRemainHealth);
		if (view_as<bool>(GetProfileNum(sProfile,"healthbar",0)))
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
	if (!g_bEnabled) return;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return;
	
	if (timer != g_hSlenderStartFleeTimer[iBossIndex]) return;
	
	if (!g_bNPCUseStartFleeAnimation[iBossIndex]) return;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

	int iOldState = g_iSlenderState[iBossIndex];
	int iState = iOldState;

	int iDifficulty = GetConVarInt(g_cvDifficulty);
	
	float flOriginalSpeed;
	
	if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S))
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
	NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
	
}

public Action Timer_SlenderStealLife(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;

	if (!g_bSlenderAttacking[iBossIndex]) return Plugin_Stop;
	
	if (timer != g_hNPCLifeStealTimer[iBossIndex]) return Plugin_Stop;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	int iDifficulty = GetConVarInt(g_cvDifficulty);
	
	int iAttackIndex = NPCGetCurrentAttackIndex(iBossIndex);
	float flDamage = NPCChaserGetAttackDamage(iBossIndex, iAttackIndex, iDifficulty);
	
	bool bAttackEliminated = view_as<bool>(NPCGetFlags(iBossIndex) & SFF_ATTACKWAITERS);

	float flTargetDist;
	Handle hTrace;
	
	float vecMyPos[3], flMyEyePos[3], vecMyEyeAng[3];
	NPCGetEyePosition(iBossIndex, flMyEyePos);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", vecMyEyeAng);
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", vecMyPos);

	float flAttackRange = NPCChaserGetAttackRange(iBossIndex, iAttackIndex);
	float flAttackFOV = NPCChaserGetAttackSpread(iBossIndex, iAttackIndex);
	float flAttackDamageForce = NPCChaserGetAttackDamageForce(iBossIndex, iAttackIndex);
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i) || !IsPlayerAlive(i) || IsClientInGhostMode(i)) continue;

		if (!bAttackEliminated && g_bPlayerEliminated[i]) continue;

		float flTargetPos[3], vecClientPos[3];
		GetClientEyePosition(i, flTargetPos);
		GetClientAbsOrigin(i, vecClientPos);

		hTrace = TR_TraceRayFilterEx(flMyEyePos,
			flTargetPos,
			MASK_NPCSOLID,
			RayType_EndPoint,
			TraceRayDontHitAnyEntity,
			slender);
				
		bool bTraceDidHit = TR_DidHit(hTrace);
		int iTraceHitEntity = TR_GetEntityIndex(hTrace);
		delete hTrace;
				
		if (bTraceDidHit && iTraceHitEntity != i)
		{
			float flTargetMins[3], flTargetMaxs[3];
			GetEntPropVector(i, Prop_Send, "m_vecMins", flTargetMins);
			GetEntPropVector(i, Prop_Send, "m_vecMaxs", flTargetMaxs);
			GetClientAbsOrigin(i, flTargetPos);
			for (int i2 = 0; i2 < 3; i2++) flTargetPos[i2] += ((flTargetMins[i2] + flTargetMaxs[i2]) / 2.0);

			hTrace = TR_TraceRayFilterEx(flMyEyePos,
				flTargetPos,
				MASK_NPCSOLID,
				RayType_EndPoint,
				TraceRayDontHitAnyEntity,
				slender);
						
			bTraceDidHit = TR_DidHit(hTrace);
			iTraceHitEntity = TR_GetEntityIndex(hTrace);
			delete hTrace;
		}
				
		if (!bTraceDidHit || iTraceHitEntity == i)
		{
			flTargetDist = GetVectorDistance(flTargetPos, flMyEyePos);

			if (flTargetDist <= flAttackRange)
			{
				float flDirection[3];
				SubtractVectors(flTargetPos, flMyEyePos, flDirection);
				GetVectorAngles(flDirection, flDirection);
						
				if (FloatAbs(AngleDiff(flDirection[1], vecMyEyeAng[1])) <= flAttackFOV)
				{
					GetAngleVectors(flDirection, flDirection, NULL_VECTOR, NULL_VECTOR);
					NormalizeVector(flDirection, flDirection);
					ScaleVector(flDirection, flAttackDamageForce);
					
					float flHealthRecover = flDamage * 2.0;
					NPCChaserAddStunHealth(iBossIndex, flHealthRecover);
					
					if (view_as<bool>(GetProfileNum(sProfile,"healthbar",0)))
					{
						UpdateHealthBar(iBossIndex);
					}
					SDKHooks_TakeDamage(i, slender, slender, flDamage * 0.25, 3, _, flDirection, flMyEyePos);
				}
			}
		}
	}
	delete hTrace;

	return Plugin_Continue;
}

public Action Timer_SlenderChaseBossAttack(Handle timer, any entref)
{
	if (!g_bEnabled) return;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return;
	
	int iDifficulty = GetConVarInt(g_cvDifficulty);
	
	if (timer != g_hSlenderAttackTimer[iBossIndex]) return;
	
	if (NPCGetFlags(iBossIndex) & SFF_FAKE)
	{
		SlenderMarkAsFake(iBossIndex);
		return;
	}
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	int iAttackIndex = NPCGetCurrentAttackIndex(iBossIndex);
	
	bool bAttackEliminated = view_as<bool>(NPCGetFlags(iBossIndex) & SFF_ATTACKWAITERS);
	
	float flDamage = NPCChaserGetAttackDamage(iBossIndex, iAttackIndex, iDifficulty);
	float flTinyDamage = flDamage * 0.5;
	float flDamageVsProps = NPCChaserGetAttackDamageVsProps(iBossIndex, iAttackIndex);
	int iDamageType = NPCChaserGetAttackDamageType(iBossIndex, iAttackIndex);
	
	// Damage all players within range.
	float vecMyPos[3], flMyEyePos[3], vecMyEyeAng[3], vecMyRot[3];
	NPCGetEyePosition(iBossIndex, flMyEyePos);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", vecMyEyeAng);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", vecMyRot);
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", vecMyPos);
	
	AddVectors(g_flSlenderEyePosOffset[iBossIndex], vecMyEyeAng, vecMyEyeAng);
	for (int i = 0; i < 3; i++) vecMyEyeAng[i] = AngleNormalize(vecMyEyeAng[i]);
	
	float flViewPunch[3];
	GetProfileVector(sProfile, "attack_punchvel", flViewPunch);
	
	float flTargetDist;
	Handle hTrace;
	
	float flAttackRange = NPCChaserGetAttackRange(iBossIndex, iAttackIndex);
	float flAttackFOV = NPCChaserGetAttackSpread(iBossIndex, iAttackIndex);
	float flAttackDamageForce = NPCChaserGetAttackDamageForce(iBossIndex, iAttackIndex);
	
	bool bHit = false;
	//bool bHeight = false;

	if (!g_bSlenderAttacking[iBossIndex]) return;
	if (view_as<bool>(GetProfileNum(sProfile,"use_chase_initial_animation",0)) && g_bNPCUsesChaseInitialAnimation[iBossIndex])
	{
		g_hSlenderChaseInitialTimer[iBossIndex] = CreateTimer(0.1, Timer_SlenderChaseInitialTimer, EntIndexToEntRef(slender));
	}

	if (NPCChaserGetAttackRepeat(iBossIndex, iAttackIndex) == 1)
	{
		g_hSlenderAttackTimer[iBossIndex] = CreateTimer(NPCChaserGetAttackDamageDelay(iBossIndex, iAttackIndex), Timer_SlenderChaseBossAttack, EntIndexToEntRef(slender));
		if (g_hSlenderBackupAtkTimer[iBossIndex] == INVALID_HANDLE && g_bNPCAlreadyAttacked[iBossIndex])
		{
			g_bSlenderAttacking[iBossIndex] = false;
			g_bNPCStealingLife[iBossIndex] = false;
			g_hSlenderAttackTimer[iBossIndex] = INVALID_HANDLE;
			g_hNPCLifeStealTimer[iBossIndex] = INVALID_HANDLE;
			g_hSlenderBackupAtkTimer[iBossIndex] = INVALID_HANDLE;
			g_bNPCAlreadyAttacked[iBossIndex] = false;
			g_bNPCUseFireAnimation[iBossIndex] = false;
			return;
		}
	}
	switch (NPCChaserGetAttackType(iBossIndex, iAttackIndex))
	{
		case SF2BossAttackType_Melee:
		{
			int prop = -1;
			while ((prop = FindEntityByClassname(prop, "prop_physics")) > MaxClients)
			{
				if (NPCAttackValidateTarget(iBossIndex, prop, flAttackRange, flAttackFOV))
				{
					bHit = true;
					SDKHooks_TakeDamage(prop, slender, slender, flDamageVsProps, iDamageType, _, _, flMyEyePos);
					float SpreadVel = 1800.0;
					float VertVel = 1300.0;
					float vel[3];
					GetAngleVectors(vecMyEyeAng, vel, NULL_VECTOR, NULL_VECTOR);
					ScaleVector(vel,SpreadVel);
					vel[2] = ((GetURandomFloat() + 0.1) * VertVel) * ((GetURandomFloat() + 0.1) * 2);
					TeleportEntity(prop, NULL_VECTOR, NULL_VECTOR, vel);
				}
			}
			
			prop = -1;
			while ((prop = FindEntityByClassname(prop, "prop_dynamic")) > MaxClients)
			{
				if (GetEntProp(prop, Prop_Data, "m_iHealth") > 0)
				{
					if (NPCAttackValidateTarget(iBossIndex, prop, flAttackRange, flAttackFOV))
					{
						bHit = true;
						SDKHooks_TakeDamage(prop, slender, slender, flDamageVsProps, iDamageType, _, _, flMyEyePos);
					}
				}
			}
			prop = -1;
			while ((prop = FindEntityByClassname(prop, "obj_*")) > MaxClients)
			{
				if (GetEntProp(prop, Prop_Data, "m_iHealth") > 0)
				{
					if (NPCAttackValidateTarget(iBossIndex, prop, flAttackRange, flAttackFOV))
					{
						bHit = true;
						SDKHooks_TakeDamage(prop, slender, slender, flDamageVsProps, iDamageType, _, _, flMyEyePos);
					}
				}
			}
			/*if (NPCChaserShockwaveOnAttack(iBossIndex))
			{
				char sIndexes[8];
				char sCurrentIndex[2];
				int iDamageIndexes = NPCChaserGetShockwaveAttackIndexes(iBossIndex);
				IntToString(iDamageIndexes, sIndexes, sizeof(sIndexes));
				IntToString(iAttackIndex+1, sCurrentIndex, sizeof(sCurrentIndex));
				char sNumber = sCurrentIndex[0];
				int iAttackNumber = 0;
				if (FindCharInString(sIndexes, sNumber) != -1)
				{
					iAttackNumber += iAttackIndex+1;
				}
				if (sIndexes[0] && sCurrentIndex[0] && iAttackNumber != -1)
				{
					int iIndexLength = strlen(sIndexes);
					int iCurrentAtkIndex = StringToInt(sCurrentIndex);
					if (iAttackNumber == iCurrentAtkIndex)
					{
						int iBeamColor[3], iHaloColor[3];
						int iColor1[4], iColor2[4];
						float flInner;
						flInner = (NPCChaserGetShockwaveRange(iBossIndex, iDifficulty)/2);
						int iDefaultColorBeam[3] = {128, 128, 128};
						int iDefaultColorHalo[3] = {255, 255, 255};
						
						GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", vecMyShockPos);
						vecMyShockPos[2] += 10;

						KvGetVector(g_hConfig, "shockwave_color_1", iBeamColor, iDefaultColorBeam);
						KvGetVector(g_hConfig, "shockwave_color_2", iHaloColor, iDefaultColorHalo);

						iColor1[0] = RoundFloat(iBeamColor[0]);
						iColor1[1] = RoundFloat(iBeamColor[1]);
						iColor1[2] = RoundFloat(iBeamColor[2]);
						iColor1[3] = KvGetNum(g_hConfig, "shockwave_alpha_1", 255);
	
						iColor2[0] = RoundFloat(iHaloColor[0]);
						iColor2[1] = RoundFloat(iHaloColor[1]);
						iColor2[2] = RoundFloat(iHaloColor[2]);
						iColor2[3] = KvGetNum(g_hConfig, "shockwave_alpha_2", 255);
						int iModelBeam, iModelHalo;
						if(!g_sSlenderShockwaveBeamSprite[iBossIndex][0])
						{
							iModelBeam = g_ShockwaveBeam;
						}
						else
						{
							iModelBeam = PrecacheModel(g_sSlenderShockwaveBeamSprite[iBossIndex], true);
						}
						if(!g_sSlenderShockwaveHaloSprite[iBossIndex][0])
						{
							iModelHalo = g_ShockwaveHalo;
						}
						else
						{
							iModelHalo = PrecacheModel(g_sSlenderShockwaveHaloSprite[iBossIndex], true);
						}
			
						TE_SetupBeamRingPoint(vecMyShockPos, 10.0, NPCChaserGetShockwaveRange(iBossIndex,iDifficulty), iModelBeam, iModelHalo, 0, 30, 0.2, 5.0, 0.0, iColor2, 15, 0); //Inner
						TE_SendToAll();

						TE_SetupBeamRingPoint(vecMyShockPos, 10.0, NPCChaserGetShockwaveRange(iBossIndex,iDifficulty), iModelBeam, iModelHalo, 0, 30, 0.3, 10.0, 0.0, iColor1, 15, 0); //Outer
						TE_SendToAll();
					}
				}
			}*/
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsClientInGame(i) || !IsPlayerAlive(i) || IsClientInGhostMode(i)) continue;
				
				if (!bAttackEliminated && g_bPlayerEliminated[i]) continue;
				
				float flTargetPos[3], vecClientPos[3];
				GetClientEyePosition(i, flTargetPos);
				GetClientAbsOrigin(i, vecClientPos);
				
				hTrace = TR_TraceRayFilterEx(flMyEyePos,
					flTargetPos,
					MASK_NPCSOLID,
					RayType_EndPoint,
					TraceRayDontHitAnyEntity,
					slender);
				
				bool bTraceDidHit = TR_DidHit(hTrace);
				int iTraceHitEntity = TR_GetEntityIndex(hTrace);
				delete hTrace;
				
				if (bTraceDidHit && iTraceHitEntity != i)
				{
					float flTargetMins[3], flTargetMaxs[3];
					GetEntPropVector(i, Prop_Send, "m_vecMins", flTargetMins);
					GetEntPropVector(i, Prop_Send, "m_vecMaxs", flTargetMaxs);
					GetClientAbsOrigin(i, flTargetPos);
					for (int i2 = 0; i2 < 3; i2++) flTargetPos[i2] += ((flTargetMins[i2] + flTargetMaxs[i2]) / 2.0);
					
					hTrace = TR_TraceRayFilterEx(flMyEyePos,
						flTargetPos,
						MASK_NPCSOLID,
						RayType_EndPoint,
						TraceRayDontHitAnyEntity,
						slender);
						
					bTraceDidHit = TR_DidHit(hTrace);
					iTraceHitEntity = TR_GetEntityIndex(hTrace);
					delete hTrace;
				}
				
				if (!bTraceDidHit || iTraceHitEntity == i)
				{
					flTargetDist = GetVectorDistance(flTargetPos, flMyEyePos);
					
					if (flTargetDist <= flAttackRange)
					{
						float flDirection[3];
						SubtractVectors(flTargetPos, flMyEyePos, flDirection);
						GetVectorAngles(flDirection, flDirection);
						
						if (FloatAbs(AngleDiff(flDirection[1], vecMyEyeAng[1])) <= flAttackFOV)
						{
							bHit = true;
							GetAngleVectors(flDirection, flDirection, NULL_VECTOR, NULL_VECTOR);
							NormalizeVector(flDirection, flDirection);
							ScaleVector(flDirection, flAttackDamageForce);
							
							//if (NPCChaserShockwaveOnAttack(iBossIndex) && (vecClientPos[2] <= NPCChaserGetShockwaveHeight(iBossIndex, iDifficulty)) && (flTargetDist <= NPCChaserGetShockwaveRange(iBossIndex, iDifficulty))) bHeight = true;
							
							if (SF_SpecialRound(SPECIALROUND_MULTIEFFECT) || g_bRenevantMultiEffect)
							{
								int iEffect = GetRandomInt(0, 6);
								switch (iEffect)
								{
									case 1:
									{
										TF2_MakeBleed(i, i, 4.0);
									}
									case 2:
									{
										TF2_IgnitePlayer(i, i);
									}
									case 3:
									{
										TF2_AddCondition(i, TFCond_Jarated, 4.0);
									}
									case 4:
									{
										TF2_AddCondition(i, TFCond_CritMmmph, 3.0);
									}
									case 5:
									{
										TF2_AddCondition(i, TFCond_Gas, 3.0);
									}
									case 6:
									{
										int iEffectRare = GetRandomInt(1, 30);
										switch (iEffectRare)
										{
											case 1,14,25,30:
											{
												int iNewHealth = GetEntProp(i, Prop_Send, "m_iHealth")+view_as<int>(flDamage);
												if (iNewHealth > 450) iNewHealth = 450;
												TF2_AddCondition(i, TFCond_MegaHeal, 2.0);
												SetEntProp(i, Prop_Send, "m_iHealth", iNewHealth);
												flDamage = 0.0;
											}
											case 7,27:
											{
												//It's over 9000!
												flDamage = 9001.0;
											}
											case 5,16,18,22,23,26:
											{
												ScaleVector(flDirection, 1200.0);
											}
										}
									}
								}
							}
							
							if(TF2_IsPlayerInCondition(i, TFCond_UberchargedCanteen) && TF2_IsPlayerInCondition(i, TFCond_CritOnFirstBlood) && TF2_IsPlayerInCondition(i, TFCond_UberBulletResist) && TF2_IsPlayerInCondition(i, TFCond_UberBlastResist) && TF2_IsPlayerInCondition(i, TFCond_UberFireResist) && TF2_IsPlayerInCondition(i, TFCond_MegaHeal)) //Remove Powerplay
							{
								TF2_RemoveCondition(i, TFCond_UberchargedCanteen);
								TF2_RemoveCondition(i, TFCond_CritOnFirstBlood);
								TF2_RemoveCondition(i, TFCond_UberBulletResist);
								TF2_RemoveCondition(i, TFCond_UberBlastResist);
								TF2_RemoveCondition(i, TFCond_UberFireResist);
								TF2_RemoveCondition(i, TFCond_MegaHeal);
								TF2_SetPlayerPowerPlay(i, false);
							}
							if (SF_SpecialRound(SPECIALROUND_TINYBOSSES))
							{
								Call_StartForward(fOnClientDamagedByBoss);
								Call_PushCell(i);
								Call_PushCell(iBossIndex);
								Call_PushCell(slender);
								Call_PushFloat(flTinyDamage);
								Call_PushCell(iDamageType);
								Call_Finish();
								float flCheckHealth = float(GetEntProp(i, Prop_Send, "m_iHealth"));
								if (NPCHasAttribute(iBossIndex, "death cam on low health") && GetClientTeam(i) != TFTeam_Blue)
								{
									float flCheckDamage = flTinyDamage;
									switch (iDamageType)
									{
										case 1048576, 1114112: flCheckDamage *= 3;
										case 1327104: flCheckDamage *= 1.35;
									}
									if (flCheckDamage > flCheckHealth)
									{
										ClientStartDeathCam(i, iBossIndex, vecMyPos);
									}
									else
									{
										if (NPCChaserGetAttackPullIn(iBossIndex, iAttackIndex))
										{
											float flNewClientPos[3];
											GetClientAbsOrigin(i, flNewClientPos);
											flNewClientPos[2] += 10.0;

											float flEffectAng[3] = {0.0, 0.0, 0.0};
											
											VectorTransform(flMyEyePos, vecMyPos, vecMyRot, flMyEyePos);
											AddVectors(flEffectAng, vecMyRot, flEffectAng);

											float flPullDirection[3], flPullAngle[3];
											SubtractVectors(flNewClientPos, flMyEyePos, flPullDirection);
											NormalizeVector(flPullDirection, flPullDirection);
											GetVectorAngles(flPullDirection, flPullAngle);
											ScaleVector(flPullAngle, 1200.0);
											flPullAngle[2] = 10.0;
											
											TeleportEntity(i, flNewClientPos, NULL_VECTOR, flPullAngle);
											
											SDKHooks_TakeDamage(i, slender, slender, flTinyDamage, iDamageType, _, flDirection, flMyEyePos);
										}
										else SDKHooks_TakeDamage(i, slender, slender, flTinyDamage, iDamageType, _, flDirection, flMyEyePos);
									}
								}
								else
								{
									if (NPCChaserGetAttackPullIn(iBossIndex, iAttackIndex))
									{
										float flNewClientPos[3];
										GetClientAbsOrigin(i, flNewClientPos);
										flNewClientPos[2] += 10.0;

										float flEffectAng[3] = {0.0, 0.0, 0.0};
											
										VectorTransform(flMyEyePos, vecMyPos, vecMyRot, flMyEyePos);
										AddVectors(flEffectAng, vecMyRot, flEffectAng);

										float flPullDirection[3], flPullAngle[3];
										SubtractVectors(flNewClientPos, flMyEyePos, flPullDirection);
										NormalizeVector(flPullDirection, flPullDirection);
										GetVectorAngles(flPullDirection, flPullAngle);
										ScaleVector(flPullAngle, 1200.0);
										flPullAngle[2] = 10.0;
											
										TeleportEntity(i, flNewClientPos, NULL_VECTOR, flPullAngle);
										
										SDKHooks_TakeDamage(i, slender, slender, flTinyDamage, iDamageType, _, flDirection, flMyEyePos);
									}
									else SDKHooks_TakeDamage(i, slender, slender, flTinyDamage, iDamageType, _, flDirection, flMyEyePos);
								}
							}
							else
							{
								Call_StartForward(fOnClientDamagedByBoss);
								Call_PushCell(i);
								Call_PushCell(iBossIndex);
								Call_PushCell(slender);
								Call_PushFloat(flDamage);
								Call_PushCell(iDamageType);
								Call_Finish();
								float flCheckHealth = float(GetEntProp(i, Prop_Send, "m_iHealth"));
								if (NPCHasAttribute(iBossIndex, "death cam on low health") && GetClientTeam(i) != TFTeam_Blue)
								{
									float flCheckDamage = flDamage;
									switch (iDamageType)
									{
										case 1048576, 1114112: flCheckDamage *= 3;
										case 1327104: flCheckDamage *= 1.35;
									}
									if (flCheckDamage > flCheckHealth)
									{
										ClientStartDeathCam(i, iBossIndex, vecMyPos);
									}
									else
									{
										if (NPCChaserGetAttackPullIn(iBossIndex, iAttackIndex))
										{
											float flNewClientPos[3];
											GetClientAbsOrigin(i, flNewClientPos);
											flNewClientPos[2] += 10.0;

											float flEffectAng[3] = {0.0, 0.0, 0.0};
											
											VectorTransform(flMyEyePos, vecMyPos, vecMyRot, flMyEyePos);
											AddVectors(flEffectAng, vecMyRot, flEffectAng);

											float flPullDirection[3], flPullAngle[3];
											SubtractVectors(flNewClientPos, flMyEyePos, flPullDirection);
											NormalizeVector(flPullDirection, flPullDirection);
											GetVectorAngles(flPullDirection, flPullAngle);
											ScaleVector(flPullAngle, 1200.0);
											flPullAngle[2] = 10.0;
											
											TeleportEntity(i, flNewClientPos, NULL_VECTOR, flPullAngle);
											
											SDKHooks_TakeDamage(i, slender, slender, flDamage, iDamageType|DMG_PREVENT_PHYSICS_FORCE, _, flDirection, flMyEyePos);
										}
										else SDKHooks_TakeDamage(i, slender, slender, flDamage, iDamageType, _, flDirection, flMyEyePos);
									}
								}
								else
								{
									if (NPCChaserGetAttackPullIn(iBossIndex, iAttackIndex))
									{
										float flNewClientPos[3];
										GetClientAbsOrigin(i, flNewClientPos);
										flNewClientPos[2] += 10.0;

										float flEffectAng[3] = {0.0, 0.0, 0.0};
											
										VectorTransform(flMyEyePos, vecMyPos, vecMyRot, flMyEyePos);
										AddVectors(flEffectAng, vecMyRot, flEffectAng);

										float flPullDirection[3], flPullAngle[3];
										SubtractVectors(flNewClientPos, flMyEyePos, flPullDirection);
										NormalizeVector(flPullDirection, flPullDirection);
										GetVectorAngles(flPullDirection, flPullAngle);
										ScaleVector(flPullAngle, 1200.0);
										flPullAngle[2] = 10.0;
										flPullAngle[1] -= flPullAngle[1] * 2.0;
										flPullAngle[0] -= flPullAngle[0] * 2.0;
											
										TeleportEntity(i, flNewClientPos, NULL_VECTOR, flPullAngle);
										
										SDKHooks_TakeDamage(i, slender, slender, flDamage, iDamageType|DMG_PREVENT_PHYSICS_FORCE, _, flDirection, flMyEyePos);
									}
									else SDKHooks_TakeDamage(i, slender, slender, flDamage, iDamageType, _, flDirection, flMyEyePos);
								}
							}
							ClientViewPunch(i, flViewPunch);
							
							if(TF2_IsPlayerInCondition(i, TFCond_Gas))
							{
								TF2_IgnitePlayer(i, i);
								TF2_RemoveCondition(i, TFCond_Gas);
							}
							if(TF2_IsPlayerInCondition(i, TFCond_Milked))
							{
								float flHealthRecover = flDamage * 0.35;
								NPCChaserAddStunHealth(iBossIndex, flHealthRecover);
								if (view_as<bool>(GetProfileNum(sProfile,"healthbar",0)))
								{
									UpdateHealthBar(iBossIndex);
								}
							}
							
							if (NPCHasAttribute(iBossIndex, "bleed player on hit"))
							{
								float flDuration = NPCGetAttributeValue(iBossIndex, "bleed player on hit");
								if (flDuration > 0.0)
								{
									TF2_MakeBleed(i, i, flDuration);
								}
							}
							if (NPCHasAttribute(iBossIndex, "ignite player on hit"))
							{
								TF2_IgnitePlayer(i, i);
							}
							if (NPCHasAttribute(iBossIndex, "stun player on hit"))
							{
								float flDuration = NPCGetAttributeValue(iBossIndex, "stun player on hit");
								float flSlowdown = NPCGetAttributeValue(iBossIndex, "stun player percentage");
								if (flDuration > 0.0 && flSlowdown > 0.0)
								{
									TF2_StunPlayer(i, flDuration, flSlowdown, TF_STUNFLAGS_SMALLBONK, i);
								}
							}
							if (NPCHasAttribute(iBossIndex, "jarate player on hit"))
							{
								float flDuration = NPCGetAttributeValue(iBossIndex, "jarate player on hit");
								if (flDuration > 0.0)
								{
									if(!NPCChaserJaratePlayerOnHit(iBossIndex))
									{
										TF2_AddCondition(i, TFCond_Jarated, flDuration);
									}
								}
							}
							if (NPCHasAttribute(iBossIndex, "milk player on hit"))
							{
								float flDuration = NPCGetAttributeValue(iBossIndex, "milk player on hit");
								if (flDuration > 0.0)
								{
									if(!NPCChaserMilkPlayerOnHit(iBossIndex))
									{
										TF2_AddCondition(i, TFCond_Milked, flDuration);
									}
								}
							}
							if (NPCHasAttribute(iBossIndex, "gas player on hit"))
							{
								float flDuration = NPCGetAttributeValue(iBossIndex, "gas player on hit");
								if (flDuration > 0.0)
								{
									if(!NPCChaserGasPlayerOnHit(iBossIndex))
									{
										TF2_AddCondition(i, TFCond_Gas, flDuration);
									}
								}
							}
							
							if (NPCChaserUseAdvancedDamageEffects(iBossIndex))
							{
								if (NPCChaserUseRandomAdvancedDamageEffects(iBossIndex))
								{
									char sIndexes[8];
									char sCurrentIndex[2];
									int iDamageIndexes = NPCChaserRandomEffectIndexes(iBossIndex);
									IntToString(iDamageIndexes, sIndexes, sizeof(sIndexes));
									IntToString(iAttackIndex+1, sCurrentIndex, sizeof(sCurrentIndex));
									char sNumber = sCurrentIndex[0];
									int iAttackNumber = 0;
									if (FindCharInString(sIndexes, sNumber) != -1)
									{
										iAttackNumber += iAttackIndex+1;
									}
									if (sIndexes[0] && sCurrentIndex[0] && iAttackNumber != -1)
									{
										int iCurrentAtkIndex = StringToInt(sCurrentIndex);
										if (iAttackNumber == iCurrentAtkIndex && NPCChaserRandomEffectDuration(iBossIndex, iDifficulty) > 0.0)
										{
											int iRandomEffect = GetRandomInt(0, 6);
											switch (iRandomEffect)
											{
												case 0: TF2_AddCondition(i, TFCond_Jarated, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty));
												case 1: TF2_AddCondition(i, TFCond_Milked, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty));
												case 2: TF2_AddCondition(i, TFCond_Gas, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty));
												case 3: TF2_AddCondition(i, TFCond_MarkedForDeath, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty));
												case 4: TF2_MakeBleed(i, i, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty));
												case 5: TF2_IgnitePlayer(i, i);
												case 6:
												{
													if (NPCChaserRandomEffectStunType(iBossIndex) == 1)
													{
														TF2_StunPlayer(i, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty), NPCChaserRandomEffectSlowdown(iBossIndex, iDifficulty), TF_STUNFLAG_SLOWDOWN, i);
													}
													if (NPCChaserRandomEffectStunType(iBossIndex) == 2)
													{
														TF2_StunPlayer(i, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty), NPCChaserRandomEffectSlowdown(iBossIndex, iDifficulty), TF_STUNFLAGS_SMALLBONK, i);
													}
													if (NPCChaserRandomEffectStunType(iBossIndex) == 3)
													{
														TF2_StunPlayer(i, NPCChaserRandomEffectDuration(iBossIndex, iDifficulty), NPCChaserRandomEffectSlowdown(iBossIndex, iDifficulty), TF_STUNFLAG_BONKSTUCK, i);
													}
												}
											}
										}
									}
								}
								if (NPCChaserJaratePlayerOnHit(iBossIndex))
								{
									char sIndexes[8];
									char sCurrentIndex[2];
									int iDamageIndexes = NPCChaserGetJarateAttackIndexes(iBossIndex);
									IntToString(iDamageIndexes, sIndexes, sizeof(sIndexes));
									IntToString(iAttackIndex+1, sCurrentIndex, sizeof(sCurrentIndex));
									char sNumber = sCurrentIndex[0];
									int iAttackNumber = 0;
									if (FindCharInString(sIndexes, sNumber) != -1)
									{
										iAttackNumber += iAttackIndex+1;
									}
									if (sIndexes[0] && sCurrentIndex[0] && iAttackNumber != -1)
									{
										int iCurrentAtkIndex = StringToInt(sCurrentIndex);
										if (iAttackNumber == iCurrentAtkIndex && NPCChaserGetJarateDuration(iBossIndex, iDifficulty) > 0.0)
										{
											GetProfileString(sProfile, "player_jarate_particle", sJaratePlayerParticle, sizeof(sJaratePlayerParticle));
											if(!sJaratePlayerParticle[0])
											{
												sJaratePlayerParticle = JARATE_PARTICLE;
											}
											if (NPCChaserAttachDamageParticle(iBossIndex))
											{
												SlenderCreateParticleAttach(iBossIndex, sJaratePlayerParticle, 35.0, i);
											}
											else
											{
												SlenderCreateParticle(iBossIndex, sJaratePlayerParticle, 35.0);
											}
											if(!g_sSlenderJarateHitSound[iBossIndex][0])
											{
												g_sSlenderJarateHitSound[iBossIndex] = JARATE_HITPLAYER;
											}
											EmitSoundToAll(g_sSlenderJarateHitSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
											TF2_AddCondition(i, TFCond_Jarated, NPCChaserGetJarateDuration(iBossIndex, iDifficulty));
										}
									}
								}
								if (NPCChaserMilkPlayerOnHit(iBossIndex))
								{
									char sIndexes[8];
									char sCurrentIndex[2];
									int iDamageIndexes = NPCChaserGetMilkAttackIndexes(iBossIndex);
									IntToString(iDamageIndexes, sIndexes, sizeof(sIndexes));
									IntToString(iAttackIndex+1, sCurrentIndex, sizeof(sCurrentIndex));
									char sNumber = sCurrentIndex[0];
									int iAttackNumber = 0;
									if (FindCharInString(sIndexes, sNumber) != -1)
									{
										iAttackNumber += iAttackIndex+1;
									}
									if (sIndexes[0] && sCurrentIndex[0] && iAttackNumber != -1)
									{
										int iCurrentAtkIndex = StringToInt(sCurrentIndex);
										if (iAttackNumber == iCurrentAtkIndex && NPCChaserGetMilkDuration(iBossIndex, iDifficulty) > 0.0)
										{
											GetProfileString(sProfile, "player_milk_particle", sMilkPlayerParticle, sizeof(sMilkPlayerParticle));
											if(!sMilkPlayerParticle[0])
											{
												sMilkPlayerParticle = MILK_PARTICLE;
											}
											if (NPCChaserAttachDamageParticle(iBossIndex))
											{
												SlenderCreateParticleAttach(iBossIndex, sMilkPlayerParticle, 35.0, i);
											}
											else
											{
												SlenderCreateParticle(iBossIndex, sMilkPlayerParticle, 55.0);
											}
											if(!g_sSlenderMilkHitSound[iBossIndex][0])
											{
												g_sSlenderMilkHitSound[iBossIndex] = JARATE_HITPLAYER;
											}
											EmitSoundToAll(g_sSlenderMilkHitSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
											TF2_AddCondition(i, TFCond_Milked, NPCChaserGetMilkDuration(iBossIndex, iDifficulty));
										}
									}
								}
								if (NPCChaserGasPlayerOnHit(iBossIndex))
								{
									char sIndexes[8];
									char sCurrentIndex[2];
									int iDamageIndexes = NPCChaserGetGasAttackIndexes(iBossIndex);
									IntToString(iDamageIndexes, sIndexes, sizeof(sIndexes));
									IntToString(iAttackIndex+1, sCurrentIndex, sizeof(sCurrentIndex));
									char sNumber = sCurrentIndex[0];
									int iAttackNumber = 0;
									if (FindCharInString(sIndexes, sNumber) != -1)
									{
										iAttackNumber += iAttackIndex+1;
									}
									if (sIndexes[0] && sCurrentIndex[0] && iAttackNumber != -1)
									{
										int iCurrentAtkIndex = StringToInt(sCurrentIndex);
										if (iAttackNumber == iCurrentAtkIndex && NPCChaserGetGasDuration(iBossIndex, iDifficulty) > 0.0)
										{
											GetProfileString(sProfile, "player_gas_particle", sGasPlayerParticle, sizeof(sGasPlayerParticle));
											if(!sGasPlayerParticle[0])
											{
												sGasPlayerParticle = GAS_PARTICLE;
											}
											if (NPCChaserAttachDamageParticle(iBossIndex))
											{
												SlenderCreateParticleAttach(iBossIndex, sGasPlayerParticle, 35.0, i);
											}
											else
											{
												SlenderCreateParticle(iBossIndex, sGasPlayerParticle, 55.0);
											}
											if(!g_sSlenderGasHitSound[iBossIndex][0])
											{
												g_sSlenderGasHitSound[iBossIndex] = JARATE_HITPLAYER;
											}
											EmitSoundToAll(g_sSlenderGasHitSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
											TF2_AddCondition(i, TFCond_Gas, NPCChaserGetGasDuration(iBossIndex, iDifficulty));
										}
									}
								}
								if (NPCChaserMarkPlayerOnHit(iBossIndex))
								{
									char sIndexes[8];
									char sCurrentIndex[2];
									int iDamageIndexes = NPCChaserGetMarkAttackIndexes(iBossIndex);
									IntToString(iDamageIndexes, sIndexes, sizeof(sIndexes));
									IntToString(iAttackIndex+1, sCurrentIndex, sizeof(sCurrentIndex));
									char sNumber = sCurrentIndex[0];
									int iAttackNumber = 0;
									if (FindCharInString(sIndexes, sNumber) != -1)
									{
										iAttackNumber += iAttackIndex+1;
									}
									if (sIndexes[0] && sCurrentIndex[0] && iAttackNumber != -1)
									{
										int iCurrentAtkIndex = StringToInt(sCurrentIndex);
										if (iAttackNumber == iCurrentAtkIndex && NPCChaserGetMarkDuration(iBossIndex, iDifficulty))
										{
											TF2_AddCondition(i, TFCond_MarkedForDeath, NPCChaserGetMarkDuration(iBossIndex, iDifficulty));
										}
									}
								}
								if (NPCChaserIgnitePlayerOnHit(iBossIndex))
								{
									char sIndexes[8];
									char sCurrentIndex[2];
									int iDamageIndexes = NPCChaserGetIgniteAttackIndexes(iBossIndex);
									IntToString(iDamageIndexes, sIndexes, sizeof(sIndexes));
									IntToString(iAttackIndex+1, sCurrentIndex, sizeof(sCurrentIndex));
									char sNumber = sCurrentIndex[0];
									int iAttackNumber = 0;
									if (FindCharInString(sIndexes, sNumber) != -1)
									{
										iAttackNumber += iAttackIndex+1;
									}
									if (sIndexes[0] && sCurrentIndex[0] && iAttackNumber != -1)
									{
										int iCurrentAtkIndex = StringToInt(sCurrentIndex);
										if (iAttackNumber == iCurrentAtkIndex && NPCChaserGetIgniteDelay(iBossIndex, iDifficulty) && g_hPlayerIgniteTimer[i] == INVALID_HANDLE)
										{
											g_hPlayerIgniteTimer[i] = CreateTimer(NPCChaserGetIgniteDelay(iBossIndex, iDifficulty), Timer_SlenderChaseBossAttackIgniteHit, EntIndexToEntRef(i));
											g_hPlayerResetIgnite[i] = INVALID_HANDLE;
										}
									}
								}
								if (NPCChaserStunPlayerOnHit(iBossIndex))
								{
									char sIndexes[8];
									char sCurrentIndex[2];
									int iDamageIndexes = NPCChaserGetStunAttackIndexes(iBossIndex);
									IntToString(iDamageIndexes, sIndexes, sizeof(sIndexes));
									IntToString(iAttackIndex+1, sCurrentIndex, sizeof(sCurrentIndex));
									char sNumber = sCurrentIndex[0];
									int iAttackNumber = 0;
									if (FindCharInString(sIndexes, sNumber) != -1)
									{
										iAttackNumber += iAttackIndex+1;
									}
									if (sIndexes[0] && sCurrentIndex[0] && iAttackNumber != -1)
									{
										int iCurrentAtkIndex = StringToInt(sCurrentIndex);
										if (iAttackNumber == iCurrentAtkIndex && NPCChaserGetStunAttackDuration(iBossIndex, iDifficulty) > 0.0)
										{
											GetProfileString(sProfile, "player_stun_particle", sStunPlayerParticle, sizeof(sStunPlayerParticle));
											if(!sStunPlayerParticle[0])
											{
												sStunPlayerParticle = STUN_PARTICLE;
											}
											if (NPCChaserAttachDamageParticle(iBossIndex))
											{
												SlenderCreateParticleAttach(iBossIndex, sStunPlayerParticle, 35.0, i);
											}
											else
											{
												SlenderCreateParticle(iBossIndex, sStunPlayerParticle, 55.0);
											}
											if(!g_sSlenderStunHitSound[iBossIndex][0])
											{
												g_sSlenderStunHitSound[iBossIndex] = JARATE_HITPLAYER;
											}
											EmitSoundToAll(g_sSlenderStunHitSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
											if (NPCChaserGetStunAttackType(iBossIndex) == 1)
											{
												TF2_StunPlayer(i, NPCChaserGetStunAttackDuration(iBossIndex, iDifficulty), NPCChaserGetStunAttackSlowdown(iBossIndex, iDifficulty), TF_STUNFLAG_SLOWDOWN, i);
											}
											if (NPCChaserGetStunAttackType(iBossIndex) == 2)
											{
												TF2_StunPlayer(i, NPCChaserGetStunAttackDuration(iBossIndex, iDifficulty), NPCChaserGetStunAttackSlowdown(iBossIndex, iDifficulty), TF_STUNFLAGS_SMALLBONK, i);
											}
											if (NPCChaserGetStunAttackType(iBossIndex) == 3)
											{
												TF2_StunPlayer(i, NPCChaserGetStunAttackDuration(iBossIndex, iDifficulty), NPCChaserGetStunAttackSlowdown(iBossIndex, iDifficulty), TF_STUNFLAG_BONKSTUCK, i);
											}
										}
									}
								}
								if (NPCChaserBleedPlayerOnHit(iBossIndex))
								{
									char sIndexes[8];
									char sCurrentIndex[2];
									int iDamageIndexes = NPCChaserGetBleedAttackIndexes(iBossIndex);
									IntToString(iDamageIndexes, sIndexes, sizeof(sIndexes));
									IntToString(iAttackIndex+1, sCurrentIndex, sizeof(sCurrentIndex));
									char sNumber = sCurrentIndex[0];
									int iAttackNumber = 0;
									if (FindCharInString(sIndexes, sNumber) != -1)
									{
										iAttackNumber += iAttackIndex+1;
									}
									if (sIndexes[0] && sCurrentIndex[0] && iAttackNumber != -1)
									{
										int iCurrentAtkIndex = StringToInt(sCurrentIndex);
										if (iAttackNumber == iCurrentAtkIndex && NPCChaserGetBleedDuration(iBossIndex, iDifficulty) > 0.0)
										{
											TF2_MakeBleed(i, i, NPCChaserGetBleedDuration(iBossIndex, iDifficulty));
										}
									}
								}
								if (NPCChaserElectricPlayerOnHit(iBossIndex))
								{
									char sIndexes[8];
									char sCurrentIndex[2];
									int iDamageIndexes = NPCChaserGetElectricAttackIndexes(iBossIndex);
									IntToString(iDamageIndexes, sIndexes, sizeof(sIndexes));
									IntToString(iAttackIndex+1, sCurrentIndex, sizeof(sCurrentIndex));
									char sNumber = sCurrentIndex[0];
									int iAttackNumber = 0;
									if (FindCharInString(sIndexes, sNumber) != -1)
									{
										iAttackNumber += iAttackIndex+1;
									}
									if (sIndexes[0] && sCurrentIndex[0] && iAttackNumber != -1)
									{
										int iCurrentAtkIndex = StringToInt(sCurrentIndex);
										if (iAttackNumber == iCurrentAtkIndex && NPCChaserGetElectricDuration(iBossIndex, iDifficulty) > 0.0)
										{
											GetProfileString(sProfile, "player_electric_red_particle", sElectricPlayerParticleRed, sizeof(sElectricPlayerParticleRed));
											GetProfileString(sProfile, "player_electric_blue_particle", sElectricPlayerParticleBlue, sizeof(sElectricPlayerParticleBlue));
											if(!sElectricPlayerParticleRed[0])
											{
												sElectricPlayerParticleRed = ELECTRIC_RED_PARTICLE;
											}
											if(!sElectricPlayerParticleBlue[0])
											{
												sElectricPlayerParticleBlue = ELECTRIC_BLUE_PARTICLE;
											}
											if (NPCChaserAttachDamageParticle(iBossIndex))
											{
												if (GetClientTeam(i) == TFTeam_Red)
												{
													SlenderCreateParticleAttach(iBossIndex, sElectricPlayerParticleRed, 35.0, i);
												}
												else if (GetClientTeam(i) == TFTeam_Blue)
												{
													SlenderCreateParticleAttach(iBossIndex, sElectricPlayerParticleBlue, 35.0, i);
												}
											}
											else
											{
												if (GetClientTeam(i) == TFTeam_Red)
												{
													SlenderCreateParticle(iBossIndex, sElectricPlayerParticleRed, 55.0);
												}
												else if (GetClientTeam(i) == TFTeam_Blue)
												{
													SlenderCreateParticle(iBossIndex, sElectricPlayerParticleBlue, 55.0);
												}
											}
											if (NPCChaserGetStunAttackType(iBossIndex) == 1)
											{
												TF2_StunPlayer(i, NPCChaserGetElectricDuration(iBossIndex, iDifficulty), NPCChaserGetElectricSlowdown(iBossIndex, iDifficulty), TF_STUNFLAG_SLOWDOWN, i);
											}
											if (NPCChaserGetStunAttackType(iBossIndex) == 2)
											{
												TF2_StunPlayer(i, NPCChaserGetElectricDuration(iBossIndex, iDifficulty), NPCChaserGetElectricSlowdown(iBossIndex, iDifficulty), TF_STUNFLAGS_SMALLBONK, i);
											}
											if (NPCChaserGetStunAttackType(iBossIndex) == 3)
											{
												TF2_StunPlayer(i, NPCChaserGetElectricDuration(iBossIndex, iDifficulty), NPCChaserGetElectricSlowdown(iBossIndex, iDifficulty), TF_STUNFLAG_BONKSTUCK, i);
											}
										}
									}
								}
								if (NPCChaserSmitePlayerOnHit(iBossIndex))
								{
									char sIndexes[8];
									char sCurrentIndex[2];
									int iDamageIndexes = NPCChaserGetSmiteAttackIndexes(iBossIndex);
									IntToString(iDamageIndexes, sIndexes, sizeof(sIndexes));
									IntToString(iAttackIndex+1, sCurrentIndex, sizeof(sCurrentIndex));
									char sNumber = sCurrentIndex[0];
									int iAttackNumber = 0;
									if (FindCharInString(sIndexes, sNumber) != -1)
									{
										iAttackNumber += iAttackIndex+1;
									}
									if (sIndexes[0] && sCurrentIndex[0] && iAttackNumber != -1)
									{
										int iCurrentAtkIndex = StringToInt(sCurrentIndex);
										if (iAttackNumber == iCurrentAtkIndex)
										{
											PerformSmiteBoss(iBossIndex, i, EntIndexToEntRef(slender));
											SDKHooks_TakeDamage(i, slender, slender, NPCChaserGetSmiteDamage(iBossIndex), NPCChaserGetSmiteDamageType(iBossIndex), _, flDirection, flMyEyePos);
											ClientViewPunch(i, flViewPunch);
											if(view_as<bool>(GetProfileNum(sProfile, "player_smite_message", 0)))
											{
												char sProfileName[SF2_MAX_PROFILE_NAME_LENGTH];
												NPCGetProfile(iBossIndex, sProfileName, sizeof(sProfileName));
												char sPlayer[32];
												GetClientName(i, sPlayer, sizeof(sPlayer));

												char sName[SF2_MAX_NAME_LENGTH];
												GetProfileString(sProfileName, "name", sName, sizeof(sName));
												if (!sName[0]) strcopy(sName, sizeof(sName), sProfileName);
												if (GetClientTeam(i) == 2) CPrintToChatAll("{royalblue}%t{default}%t", "SF2 Prefix", "SF2 Smote target", sName, sPlayer);	
											}
										}
									}
									/*if (NPCChaserShockwaveOnAttack(iBossIndex))
									{
										char sIndexes[8];
										char sCurrentIndex[2];
										int iDamageIndexes = NPCChaserGetShockwaveAttackIndexes(iBossIndex);
										IntToString(iDamageIndexes, sIndexes, sizeof(sIndexes));
										IntToString(iAttackIndex+1, sCurrentIndex, sizeof(sCurrentIndex));
										char sNumber = sCurrentIndex[0];
										int iAttackNumber = 0;
										if (FindCharInString(sIndexes, sNumber) != -1)
										{
											iAttackNumber += iAttackIndex+1;
										}
										if (sIndexes[0] && sCurrentIndex[0] && iAttackNumber != -1)
										{
											int iCurrentAtkIndex = StringToInt(sCurrentIndex);
											if (iAttackNumber == iCurrentAtkIndex)
											{
												if (bHeight)
												{
													float flPercentLife;
													flPercentLife = ClientGetFlashlightBatteryLife(i) - NPCChaserGetShockwaveDrain(iBossIndex, iDifficulty);
													if (flPercentLife < 0) flPercentLife = 0;
													ClientSetFlashlightBatteryLife(i, flPercentLife);
													if (NPCChaserGetShockwaveForce(iBossIndex, iDifficulty) > 0)
													{
														float flDirectionForce[3];
														
														MakeVectorFromPoints(vecClientPos, vecMyPos, flDirectionForce);

														NormalizeVector(flDirectionForce, flDirectionForce);
														
														ScaleVector(flDirectionForce, -NPCChaserGetShockwaveForce(iBossIndex, iDifficulty));

														TeleportEntity(i, NULL_VECTOR, NULL_VECTOR, flDirectionForce);
													}
													
													if (NPCChaserShockwaveStunEnabled(iBossIndex))
													{
														TF2_StunPlayer(i, NPCChaserGetShockwaveStunDuration(iBossIndex, iDifficulty), NPCChaserGetShockwaveStunSlowdown(iBossIndex, iDifficulty), TF_STUNFLAG_SLOWDOWN, i);
													}		
												}
											}
										}
									}*/
								}
							}
							if (NPCChaserDamageParticlesEnabled(iBossIndex))
							{
								GetProfileString(sProfile, "damage_effect_particle", sDamageEffectParticle, sizeof(sDamageEffectParticle));
								if(sDamageEffectParticle[0])
								{
									SlenderCreateParticleAttach(iBossIndex, sDamageEffectParticle, 35.0, i);
									GetProfileString(sProfile, "sound_damage_effect", sDamageEffectSound, sizeof(sDamageEffectSound));
									if(sDamageEffectSound[0])
									{
										EmitSoundToAll(sDamageEffectSound, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
									}
								}
							}
							
							// Add stress
							float flStressScalar = flDamage / 125.0;
							if (flStressScalar > 1.0) flStressScalar = 1.0;
							ClientAddStress(i, 0.33 * flStressScalar);
						}
					}
				}
			}
			char sSoundPath[PLATFORM_MAX_PATH];
			
			if (bHit)
			{
				// Fling it.
				int phys = CreateEntityByName("env_physexplosion");
				if (phys != -1)
				{
					TeleportEntity(phys, flMyEyePos, NULL_VECTOR, NULL_VECTOR);
					DispatchKeyValue(phys, "spawnflags", "1");
					DispatchKeyValueFloat(phys, "radius", flAttackRange);
					DispatchKeyValueFloat(phys, "magnitude", flAttackDamageForce);
					DispatchSpawn(phys);
					ActivateEntity(phys);
					AcceptEntityInput(phys, "Explode");
					AcceptEntityInput(phys, "Kill");
				}
				if(!view_as<bool>(GetProfileNum(sProfile,"multi_hit_sounds",0)))
				{
					GetRandomStringFromProfile(sProfile, "sound_hitenemy", sSoundPath, sizeof(sSoundPath));
					if (sSoundPath[0]) EmitSoundToAll(sSoundPath, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
				}
				else
				{
					int iAttackIndexNum = iAttackIndex+1;
					switch (iAttackIndexNum)
					{
						case 1:
						{
							GetRandomStringFromProfile(sProfile, "sound_hitenemy", sSoundPath, sizeof(sSoundPath));
							if (sSoundPath[0]) EmitSoundToAll(sSoundPath, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
						}
						case 2:
						{
							GetRandomStringFromProfile(sProfile, "sound_hitenemy_2", sSoundPath, sizeof(sSoundPath));
							if (sSoundPath[0]) EmitSoundToAll(sSoundPath, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
						}
						case 3:
						{
							GetRandomStringFromProfile(sProfile, "sound_hitenemy_3", sSoundPath, sizeof(sSoundPath));
							if (sSoundPath[0]) EmitSoundToAll(sSoundPath, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
						}
						case 4:
						{
							GetRandomStringFromProfile(sProfile, "sound_hitenemy_4", sSoundPath, sizeof(sSoundPath));
							if (sSoundPath[0]) EmitSoundToAll(sSoundPath, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
						}
						case 5:
						{
							GetRandomStringFromProfile(sProfile, "sound_hitenemy_5", sSoundPath, sizeof(sSoundPath));
							if (sSoundPath[0]) EmitSoundToAll(sSoundPath, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
						}
						case 6:
						{
							GetRandomStringFromProfile(sProfile, "sound_hitenemy_6", sSoundPath, sizeof(sSoundPath));
							if (sSoundPath[0]) EmitSoundToAll(sSoundPath, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
						}
						case 7:
						{
							GetRandomStringFromProfile(sProfile, "sound_hitenemy_7", sSoundPath, sizeof(sSoundPath));
							if (sSoundPath[0]) EmitSoundToAll(sSoundPath, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
						}
						case 8:
						{
							GetRandomStringFromProfile(sProfile, "sound_hitenemy_8", sSoundPath, sizeof(sSoundPath));
							if (sSoundPath[0]) EmitSoundToAll(sSoundPath, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
						}
						case 9:
						{
							GetRandomStringFromProfile(sProfile, "sound_hitenemy_9", sSoundPath, sizeof(sSoundPath));
							if (sSoundPath[0]) EmitSoundToAll(sSoundPath, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
						}
					}
				}
				
			}
			else
			{
				if(!view_as<bool>(GetProfileNum(sProfile,"multi_miss_sounds",0)))
				{
					GetRandomStringFromProfile(sProfile, "sound_missenemy", sSoundPath, sizeof(sSoundPath));
					if (sSoundPath[0]) EmitSoundToAll(sSoundPath, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
				}
				else
				{
					int iAttackIndexNum = iAttackIndex+1;
					switch (iAttackIndexNum)
					{
						case 1:
						{
							GetRandomStringFromProfile(sProfile, "sound_missenemy", sSoundPath, sizeof(sSoundPath));
							if (sSoundPath[0]) EmitSoundToAll(sSoundPath, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
						}
						case 2:
						{
							GetRandomStringFromProfile(sProfile, "sound_missenemy_2", sSoundPath, sizeof(sSoundPath));
							if (sSoundPath[0]) EmitSoundToAll(sSoundPath, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
						}
						case 3:
						{
							GetRandomStringFromProfile(sProfile, "sound_missenemy_3", sSoundPath, sizeof(sSoundPath));
							if (sSoundPath[0]) EmitSoundToAll(sSoundPath, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
						}
						case 4:
						{
							GetRandomStringFromProfile(sProfile, "sound_missenemy_4", sSoundPath, sizeof(sSoundPath));
							if (sSoundPath[0]) EmitSoundToAll(sSoundPath, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
						}
						case 5:
						{
							GetRandomStringFromProfile(sProfile, "sound_missenemy_5", sSoundPath, sizeof(sSoundPath));
							if (sSoundPath[0]) EmitSoundToAll(sSoundPath, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
						}
						case 6:
						{
							GetRandomStringFromProfile(sProfile, "sound_missenemy_6", sSoundPath, sizeof(sSoundPath));
							if (sSoundPath[0]) EmitSoundToAll(sSoundPath, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
						}
						case 7:
						{
							GetRandomStringFromProfile(sProfile, "sound_missenemy_7", sSoundPath, sizeof(sSoundPath));
							if (sSoundPath[0]) EmitSoundToAll(sSoundPath, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
						}
						case 8:
						{
							GetRandomStringFromProfile(sProfile, "sound_missenemy_8", sSoundPath, sizeof(sSoundPath));
							if (sSoundPath[0]) EmitSoundToAll(sSoundPath, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
						}
						case 9:
						{
							GetRandomStringFromProfile(sProfile, "sound_missenemy_9", sSoundPath, sizeof(sSoundPath));
							if (sSoundPath[0]) EmitSoundToAll(sSoundPath, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
						}
					}
				}
			}
		}
		case SF2BossAttackType_Ranged:
		{	
			//BULLETS ANYONE? Thx Pelipoika
			int iTarget = EntRefToEntIndex(g_iSlenderTarget[iBossIndex]);
			char sSoundPath[PLATFORM_MAX_PATH];
			float vecSpread = NPCChaserGetAttackBulletSpread(iBossIndex, iAttackIndex);
			GetRandomStringFromProfile(sProfile, "sound_bulletshoot", sSoundPath, sizeof(sSoundPath));
			if (sSoundPath[0]) EmitSoundToAll(sSoundPath, slender, SNDCHAN_WEAPON, SNDLEVEL_SCREAMING);

			float flEffectPos[3];
			float flClientPos[3];
			if (IsValidClient(iTarget))
			{
				GetClientEyePosition(iTarget, flClientPos);
				flClientPos[2] -= 20.0;
			}	
			float flBasePos[3], flBaseAng[3];
			float flEffectAng[3] = {0.0, 0.0, 0.0};
			GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flBasePos);
			GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", flBaseAng);
			GetProfileAttackVector(sProfile, "attack_bullet_offset", flEffectPos, view_as<float>({0.0, 0.0, 0.0}), iAttackIndex+1);
			VectorTransform(flEffectPos, flBasePos, flBaseAng, flEffectPos);
			AddVectors(flEffectAng, flBaseAng, flEffectAng);

			float flShootDirection[3], flShootAng[3];
			if (!IsValidClient(iTarget))
			{
				flShootAng[0] = vecMyEyeAng[0];
				flShootAng[1] = vecMyEyeAng[1];
				flShootAng[2] = vecMyEyeAng[2];
			}
			SubtractVectors(flClientPos, flEffectPos, flShootDirection);
			NormalizeVector(flShootDirection, flShootDirection);
			GetVectorAngles(flShootDirection, flShootAng);

			for (int i = 0; i < NPCChaserGetAttackBulletCount(iBossIndex, iAttackIndex); i++)
			{
				float x, y;
				x = GetRandomFloat( -0.5, 0.5 ) + GetRandomFloat( -0.5, 0.5 );
				y = GetRandomFloat( -0.5, 0.5 ) + GetRandomFloat( -0.5, 0.5 );

				float vecDirShooting[3], vecRight[3], vecUp[3];
				GetAngleVectors(flShootAng, vecDirShooting, vecRight, vecUp);

				float vecDir[3];
				vecDir[0] = vecDirShooting[0] + x * vecSpread * vecRight[0] + y * vecSpread * vecUp[0]; 
				vecDir[1] = vecDirShooting[1] + x * vecSpread * vecRight[1] + y * vecSpread * vecUp[1]; 
				vecDir[2] = vecDirShooting[2] + x * vecSpread * vecRight[2] + y * vecSpread * vecUp[2]; 
				NormalizeVector(vecDir, vecDir);

				float vecEnd[3];
				vecEnd[0] = flEffectPos[0] + vecDir[0] * 9001.0; 
				vecEnd[1] = flEffectPos[1] + vecDir[1] * 9001.0; 
				vecEnd[2] = flEffectPos[2] + vecDir[2] * 9001.0;
				
				// Fire a bullet (ignoring the shooter).
				Handle trace = TR_TraceRayFilterEx(flEffectPos, vecEnd, ( MASK_SOLID | CONTENTS_HITBOX ), RayType_EndPoint, TraceRayDontHitAnyEntity, slender);
				if ( TR_GetFraction(trace) < 1.0 )
				{
					// Verify we have an entity at the point of impact.
					if(TR_GetEntityIndex(trace) == -1)
					{
						delete trace;
						return;
					}
					
					float endpos[3];    TR_GetEndPosition(endpos, trace);
					
					if(TR_GetEntityIndex(trace) <= 0 || TR_GetEntityIndex(trace) > MaxClients)
					{
						float vecNormal[3];	TR_GetPlaneNormal(trace, vecNormal);
						GetVectorAngles(vecNormal, vecNormal);
						//CreateParticle("impact_concrete", endpos, vecNormal);
					}
					
					// Regular impact effects.
					char effect[PLATFORM_MAX_PATH], tracerEffect[PLATFORM_MAX_PATH];
					tracerEffect = "bullet_tracer02_blue";
					Format(effect, PLATFORM_MAX_PATH, "%s", tracerEffect);
					
					if (tracerEffect[0])
					{
						int tblidx = FindStringTable("ParticleEffectNames");
						if (tblidx == INVALID_STRING_TABLE) 
						{
							LogError("Could not find string table: ParticleEffectNames");
							return;
						}
						char tmp[256];
						int count = GetStringTableNumStrings(tblidx);
						int stridx = INVALID_STRING_INDEX;
						for (int i2 = 0; i2 < count; i2++)
						{
							ReadStringTable(tblidx, i2, tmp, sizeof(tmp));
							if (StrEqual(tmp, effect, false))
							{
								stridx = i2;
								break;
							}
						}
						if (stridx == INVALID_STRING_INDEX)
						{
							LogError("Could not find particle: %s", effect);
							return;
						}

						TE_Start("TFParticleEffect");
						TE_WriteFloat("m_vecOrigin[0]", flEffectPos[0]);
						TE_WriteFloat("m_vecOrigin[1]", flEffectPos[1]);
						TE_WriteFloat("m_vecOrigin[2]", flEffectPos[2]);
						TE_WriteNum("m_iParticleSystemIndex", stridx);
						TE_WriteNum("entindex", slender);
						TE_WriteNum("m_iAttachType", 2);
						TE_WriteNum("m_iAttachmentPointIndex", 0);
						TE_WriteNum("m_bResetParticles", false);    
						TE_WriteNum("m_bControlPoint1", 1);    
						TE_WriteNum("m_ControlPoint1.m_eParticleAttachment", 5);  
						TE_WriteFloat("m_ControlPoint1.m_vecOffset[0]", endpos[0]);
						TE_WriteFloat("m_ControlPoint1.m_vecOffset[1]", endpos[1]);
						TE_WriteFloat("m_ControlPoint1.m_vecOffset[2]", endpos[2]);
						TE_SendToAll();
					}
					
				//	TE_SetupBeamPoints(flEffectPos, endpos, g_iPathLaserModelIndex, g_iPathLaserModelIndex, 0, 30, 0.1, 0.1, 0.1, 5, 0.0, view_as<int>({255, 0, 255, 255}), 30);
				//	TE_SendToAll();
					
					SDKHooks_TakeDamage(TR_GetEntityIndex(trace), slender, slender, NPCChaserGetAttackBulletDamage(iBossIndex, iAttackIndex), DMG_BULLET, _, CalculateBulletDamageForce(vecDir, 1.0), endpos);
				}
				
				delete trace;
			}
		}
		case SF2BossAttackType_Projectile:
		{
			int iTarget = EntRefToEntIndex(g_iSlenderTarget[iBossIndex]);
			if (IsValidClient(iTarget) && IsClientInGame(iTarget) && IsPlayerAlive(iTarget) && !IsClientInGhostMode(iTarget))
			{
				if(!view_as<bool>(GetProfileNum(sProfile,"multi_shoot_projectile_sounds",0)))
				{
					NPCChaserProjectileAttackShoot(iBossIndex, slender, iTarget, sProfile, "sound_attackshootprojectile");
				}
				else
				{
					int iAttackIndexNum = iAttackIndex+1;
					switch (iAttackIndexNum)
					{
						case 1: NPCChaserProjectileAttackShoot(iBossIndex, slender, iTarget, sProfile, "sound_attackshootprojectile");
						case 2: NPCChaserProjectileAttackShoot(iBossIndex, slender, iTarget, sProfile, "sound_attackshootprojectile_2");
						case 3: NPCChaserProjectileAttackShoot(iBossIndex, slender, iTarget, sProfile, "sound_attackshootprojectile_3");
						case 4: NPCChaserProjectileAttackShoot(iBossIndex, slender, iTarget, sProfile, "sound_attackshootprojectile_4");
						case 5: NPCChaserProjectileAttackShoot(iBossIndex, slender, iTarget, sProfile, "sound_attackshootprojectile_5");
						case 6: NPCChaserProjectileAttackShoot(iBossIndex, slender, iTarget, sProfile, "sound_attackshootprojectile_6");
						case 7: NPCChaserProjectileAttackShoot(iBossIndex, slender, iTarget, sProfile, "sound_attackshootprojectile_7");
						case 8: NPCChaserProjectileAttackShoot(iBossIndex, slender, iTarget, sProfile, "sound_attackshootprojectile_8");
						case 9: NPCChaserProjectileAttackShoot(iBossIndex, slender, iTarget, sProfile, "sound_attackshootprojectile_9");
						case 10: NPCChaserProjectileAttackShoot(iBossIndex, slender, iTarget, sProfile, "sound_attackshootprojectile_10");
						case 11: NPCChaserProjectileAttackShoot(iBossIndex, slender, iTarget, sProfile, "sound_attackshootprojectile_11");
						case 12: NPCChaserProjectileAttackShoot(iBossIndex, slender, iTarget, sProfile, "sound_attackshootprojectile_12");
						case 13: NPCChaserProjectileAttackShoot(iBossIndex, slender, iTarget, sProfile, "sound_attackshootprojectile_13");
						case 14: NPCChaserProjectileAttackShoot(iBossIndex, slender, iTarget, sProfile, "sound_attackshootprojectile_14");
						case 15: NPCChaserProjectileAttackShoot(iBossIndex, slender, iTarget, sProfile, "sound_attackshootprojectile_15");
						case 16: NPCChaserProjectileAttackShoot(iBossIndex, slender, iTarget, sProfile, "sound_attackshootprojectile_16");
					}
				}
				if(view_as<bool>(GetProfileNum(sProfile,"use_shoot_animations",0)))
				{
					g_bNPCUseFireAnimation[iBossIndex] = true;
					int iState = g_iSlenderState[iBossIndex];
					NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
				}
			}
			else //Our target is unavailable, abort.
			{
				g_bSlenderAttacking[iBossIndex] = false;
				g_bNPCStealingLife[iBossIndex] = false;
				g_hSlenderAttackTimer[iBossIndex] = INVALID_HANDLE;
				g_hNPCLifeStealTimer[iBossIndex] = INVALID_HANDLE;
				g_hSlenderBackupAtkTimer[iBossIndex] = INVALID_HANDLE;
				g_bNPCAlreadyAttacked[iBossIndex] = false;
				g_bNPCUseFireAnimation[iBossIndex] = false;
			}
		}
	}
	if (NPCChaserGetAttackDisappear(iBossIndex, iAttackIndex) != 1 && NPCChaserGetAttackRepeat(iBossIndex, iAttackIndex) != 1)
	{
		g_hSlenderAttackTimer[iBossIndex] = CreateTimer(NPCChaserGetAttackDuration(iBossIndex, iAttackIndex)-NPCChaserGetAttackDamageDelay(iBossIndex, iAttackIndex), Timer_SlenderChaseBossAttackEnd, EntIndexToEntRef(slender));
	}
	if(NPCChaserGetAttackRepeat(iBossIndex, iAttackIndex) == 1 && !g_bNPCAlreadyAttacked[iBossIndex])
	{
		g_hSlenderBackupAtkTimer[iBossIndex] = CreateTimer(NPCChaserGetAttackDuration(iBossIndex, iAttackIndex)-NPCChaserGetAttackDamageDelay(iBossIndex, iAttackIndex), Timer_SlenderChaseBossAttackEndBackup, EntIndexToEntRef(slender));
		g_bNPCAlreadyAttacked[iBossIndex] = true;
	}
	if (NPCChaserGetAttackDisappear(iBossIndex, iAttackIndex) == 1)
	{
		RemoveSlender(iBossIndex);
		g_bSlenderAttacking[iBossIndex] = false;
		g_bNPCStealingLife[iBossIndex] = false;
		g_hSlenderAttackTimer[iBossIndex] = INVALID_HANDLE;
		g_hNPCLifeStealTimer[iBossIndex] = INVALID_HANDLE;
		g_hSlenderBackupAtkTimer[iBossIndex] = INVALID_HANDLE;
		g_bNPCAlreadyAttacked[iBossIndex] = false;
		g_bNPCUseFireAnimation[iBossIndex] = false;
	}
	delete hTrace;
	return;
}

float[] CalculateBulletDamageForce( const float vecBulletDir[3], float flScale )
{
	float vecForce[3]; vecForce = vecBulletDir;
	NormalizeVector( vecForce, vecForce );
	ScaleVector(vecForce, FindConVar("phys_pushscale").FloatValue);
	ScaleVector(vecForce, flScale);
	return vecForce;
}

public Action Timer_SlenderChaseBossAttackIgniteHit (Handle timer, any entref)
{
	if (!g_bEnabled) return;

	int player = EntRefToEntIndex(entref);
	if (!player || player == INVALID_ENT_REFERENCE) return;

	if (timer != g_hPlayerIgniteTimer[player]) return;
	
	TF2_IgnitePlayer(player, player);
	g_hPlayerResetIgnite[player] = CreateTimer(0.1, Timer_SlenderChaseBossResetIgnite, EntIndexToEntRef(player));
	
}

public Action Timer_SlenderChaseBossResetIgnite (Handle timer, any entref)
{
	if (!g_bEnabled) return;

	int player = EntRefToEntIndex(entref);
	if (!player || player == INVALID_ENT_REFERENCE) return;

	if (timer != g_hPlayerResetIgnite[player]) return;
	
	g_hPlayerIgniteTimer[player] = INVALID_HANDLE;
}

public Action Timer_SlenderChaseBossExplosiveDance (Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;

	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;
	
	if (timer != g_hSlenderAttackTimer[iBossIndex]) return Plugin_Stop;
	
	if (NPCGetFlags(iBossIndex) & SFF_FAKE)
	{
		SlenderMarkAsFake(iBossIndex);
		return Plugin_Stop;
	}
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

	// Damage all players within range.
	float vecMyPos[3], flMyEyePos[3], vecMyEyeAng[3];
	NPCGetEyePosition(iBossIndex, flMyEyePos);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", vecMyEyeAng);
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", vecMyPos);

	int iAttackIndex = NPCGetCurrentAttackIndex(iBossIndex);
	
	AddVectors(g_flSlenderEyePosOffset[iBossIndex], vecMyEyeAng, vecMyEyeAng);
	for (int i = 0; i < 3; i++) vecMyEyeAng[i] = AngleNormalize(vecMyEyeAng[i]);
	
	bool bAttackEliminated = view_as<bool>(NPCGetFlags(iBossIndex) & SFF_ATTACKWAITERS);
	
	if (!g_bSlenderAttacking[iBossIndex]) return Plugin_Stop;

	static int iExploded = 0;
	iExploded++;
	if (iExploded <= 35)
	{
		float flSlenderPosition[3], flexplosionPosition[3];
		GetEntPropVector(slender, Prop_Data, "m_vecOrigin", flSlenderPosition);
		flexplosionPosition[2] = flSlenderPosition[2];
		for (int e = 0; e < 5; e++)
		{
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsClientInGame(i) || !IsPlayerAlive(i) || IsClientInGhostMode(i)) continue;
				
				if (!bAttackEliminated && g_bPlayerEliminated[i]) continue;
					
				int explosivePower = CreateEntityByName("env_explosion");
				if (explosivePower != -1)
				{
					DispatchKeyValueFloat(explosivePower, "DamageForce", 180.0);
						
					SetEntProp(explosivePower, Prop_Data, "m_iMagnitude", 666, 4);
					SetEntProp(explosivePower, Prop_Data, "m_iRadiusOverride", 200, 4);
					SetEntPropEnt(explosivePower, Prop_Data, "m_hOwnerEntity", slender);

					DispatchSpawn(explosivePower);

					flexplosionPosition[0]=flSlenderPosition[0]+GetRandomInt(-350, 350);
					flexplosionPosition[1]=flSlenderPosition[1]+GetRandomInt(-350, 350);
							
					TeleportEntity(explosivePower, flexplosionPosition, NULL_VECTOR, NULL_VECTOR);
							
					AcceptEntityInput(explosivePower, "Explode");
					AcceptEntityInput(explosivePower, "kill");
					CreateTimer(0.1, Timer_DestroyExplosion, EntIndexToEntRef(explosivePower));
				}
			}
		}
	}
	else
	{
		g_hSlenderAttackTimer[iBossIndex] = CreateTimer(NPCChaserGetAttackDuration(iBossIndex, iAttackIndex)-NPCChaserGetAttackDamageDelay(iBossIndex, iAttackIndex), Timer_SlenderChaseBossAttackEnd, EntIndexToEntRef(slender));
		iExploded=0;
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action Timer_DestroyExplosion(Handle timer, any explosionRef)
{
	int explosion = EntRefToEntIndex(explosionRef);
	if (explosion != -1)
	{
		AcceptEntityInput(explosion, "Kill");
	}
	
	return Plugin_Continue;
}

public Action Timer_SlenderChaseBossAttackBeginLaser(Handle timer, any entref)
{
	if (!g_bEnabled) return;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;

	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return;
	
	if (timer != g_hSlenderAttackTimer[iBossIndex]) return;
	
	int iAttackIndex = NPCGetCurrentAttackIndex(iBossIndex);
	
	g_flNPCLaserTimer[iBossIndex] = GetGameTime() + NPCChaserGetAttackLaserDuration(iBossIndex, iAttackIndex);

	g_hSlenderLaserTimer[iBossIndex] = CreateTimer(0.1, Timer_SlenderChaseBossAttackLaser, EntIndexToEntRef(slender), TIMER_REPEAT);
	
	g_hSlenderAttackTimer[iBossIndex] = CreateTimer(NPCChaserGetAttackDuration(iBossIndex, iAttackIndex)-NPCChaserGetAttackDamageDelay(iBossIndex, iAttackIndex), Timer_SlenderChaseBossAttackEnd, EntIndexToEntRef(slender));
	
	g_NPCBaseAttacks[iBossIndex][iAttackIndex][1].BaseAttackNextAttackTime = GetGameTime()+NPCChaserGetAttackCooldown(iBossIndex, iAttackIndex);
}

public Action Timer_SlenderChaseBossAttackLaser(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;

	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;
	
	if (timer != g_hSlenderLaserTimer[iBossIndex]) return Plugin_Stop;
	
	if (GetGameTime() >= g_flNPCLaserTimer[iBossIndex]) return Plugin_Stop;
	
	if (NPCGetFlags(iBossIndex) & SFF_FAKE)
	{
		SlenderMarkAsFake(iBossIndex);
		return Plugin_Stop;
	}
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

	int iAttackIndex = NPCGetCurrentAttackIndex(iBossIndex);

	if (!g_bSlenderAttacking[iBossIndex]) return Plugin_Stop;
	
	int iTarget = EntRefToEntIndex(g_iSlenderTarget[iBossIndex]);
	if (IsValidClient(iTarget) && IsClientInGame(iTarget) && IsPlayerAlive(iTarget) && !IsClientInGhostMode(iTarget))
	{
		float flEffectPos[3];
		float flClientPos[3];
		
		GetClientEyePosition(iTarget, flClientPos);
		flClientPos[2] -= 20.0;
		
		float flBasePos[3], flBaseAng[3];
		float flEffectAng[3] = {0.0, 0.0, 0.0};
		GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flBasePos);
		GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", flBaseAng);
		GetProfileAttackVector(sProfile, "attack_laser_offset", flEffectPos, view_as<float>({0.0, 0.0, 0.0}), iAttackIndex+1);
		VectorTransform(flEffectPos, flBasePos, flBaseAng, flEffectPos);
		AddVectors(flEffectAng, flBaseAng, flEffectAng);

		float flShootDirection[3], flShootAng[3];
		if (!IsValidClient(iTarget))
		{
			flShootAng[0] = flBaseAng[0];
			flShootAng[1] = flBaseAng[1];
			flShootAng[2] = flBaseAng[2];
		}
		SubtractVectors(flClientPos, flEffectPos, flShootDirection);
		NormalizeVector(flShootDirection, flShootDirection);
		GetVectorAngles(flShootDirection, flShootAng);

		float vecDirShooting[3];
		GetAngleVectors(flShootAng, vecDirShooting, NULL_VECTOR, NULL_VECTOR);

		float vecDir[3];
		vecDir[0] = vecDirShooting[0]; 
		vecDir[1] = vecDirShooting[1]; 
		vecDir[2] = vecDirShooting[2]; 
		NormalizeVector(vecDir, vecDir);

		float vecEnd[3];
		vecEnd[0] = flEffectPos[0] + vecDir[0] * 9001.0; 
		vecEnd[1] = flEffectPos[1] + vecDir[1] * 9001.0; 
		vecEnd[2] = flEffectPos[2] + vecDir[2] * 9001.0;

		Handle trace = TR_TraceRayFilterEx(flEffectPos, vecEnd, ( MASK_SOLID | CONTENTS_HITBOX ), RayType_EndPoint, TraceRayDontHitAnyEntity, slender);
		if ( TR_GetFraction(trace) < 1.0 )
		{
			// Verify we have an entity at the point of impact.
			if(TR_GetEntityIndex(trace) == -1)
			{
				delete trace;
				return Plugin_Stop;
			}

			float endpos[3];    TR_GetEndPosition(endpos, trace);

			if(TR_GetEntityIndex(trace) <= 0 || TR_GetEntityIndex(trace) > MaxClients)
			{
				float vecNormal[3];	TR_GetPlaneNormal(trace, vecNormal);
				GetVectorAngles(vecNormal, vecNormal);
			}
			
			int iColor[3];
			NPCChaserGetAttackLaserColor(iBossIndex, iAttackIndex, iColor);
			int iColorReal[4];
			iColorReal[0] = iColor[0];
			iColorReal[1] = iColor[1];
			iColorReal[2] = iColor[2];
			iColorReal[3] = 255;
			
			if (NPCChaserGetAttackLaserAttachmentState(iBossIndex, iAttackIndex))
			{
				int iTargetEnt = CreateEntityByName("info_target");
				char sAttachment[PLATFORM_MAX_PATH];
				TeleportEntity(iTargetEnt, flBasePos, NULL_VECTOR, NULL_VECTOR);
				SetVariantString("!activator");
				AcceptEntityInput(iTargetEnt, "SetParent", slender);
				GetProfileAttackString(sProfile, "attack_laser_attachment_name", sAttachment, sizeof(sAttachment), "", iAttackIndex+1);
				if (sAttachment[0])
				{
					SetVariantString(sAttachment);
					AcceptEntityInput(iTargetEnt, "SetParentAttachment");
				}
				float flTargetEntPos[3];
				GetEntPropVector(iTargetEnt, Prop_Data, "m_vecAbsOrigin", flTargetEntPos);
				//flTargetEntPos[2] /= GetProfileAttackFloat(sProfile, "attack_laser_attachment_pos_offset", 2.0, iAttackIndex+1);
				TE_SetupBeamPoints(flTargetEntPos, flClientPos, g_ShockwaveBeam, g_ShockwaveHalo, 0, 30, 0.1, NPCChaserGetAttackLaserSize(iBossIndex, iAttackIndex), NPCChaserGetAttackLaserSize(iBossIndex, iAttackIndex), 5, GetProfileAttackFloat(sProfile, "attack_laser_noise", 1.0, iAttackIndex+1), iColorReal, 1);
				TE_SendToAll();
				CreateTimer(0.1, Timer_DestroyExplosion, EntIndexToEntRef(iTargetEnt));
			}
			else
			{
				TE_SetupBeamPoints(flEffectPos, flClientPos, g_ShockwaveBeam, g_ShockwaveHalo, 0, 30, 0.1, NPCChaserGetAttackLaserSize(iBossIndex, iAttackIndex), NPCChaserGetAttackLaserSize(iBossIndex, iAttackIndex), 5, GetProfileAttackFloat(sProfile, "attack_laser_noise", 1.0, iAttackIndex+1), iColorReal, 1);
				TE_SendToAll();
			}

			SDKHooks_TakeDamage(TR_GetEntityIndex(trace), slender, slender, NPCChaserGetAttackLaserDamage(iBossIndex, iAttackIndex), DMG_SHOCK|DMG_ALWAYSGIB, _, _, endpos);
		}

		delete trace;

	}
	return Plugin_Continue;
}

static bool NPCAttackValidateTarget(int iBossIndex,int iTarget, float flAttackRange, float flAttackFOV, bool bCheckBlock = false)
{
	int iBoss = NPCGetEntIndex(iBossIndex);
	
	float flMyEyePos[3], flMyEyeAng[3];
	NPCGetEyePosition(iBossIndex, flMyEyePos);
	if(iTarget>MaxClients)
	{
		//float flVecMaxs[3];
		flMyEyePos[2]+=30.0;
		//GetEntPropVector(g_iSlenderHitbox[iBossIndex], Prop_Data, "m_vecMaxs", flVecMaxs);
	}
	GetEntPropVector(iBoss, Prop_Data, "m_angAbsRotation", flMyEyeAng);
	AddVectors(g_flSlenderEyeAngOffset[iBossIndex], flMyEyeAng, flMyEyeAng);
	for (int i = 0; i < 3; i++) flMyEyeAng[i] = AngleNormalize(flMyEyeAng[i]);
	
	float flTargetPos[3], flTargetMins[3], flTargetMaxs[3];
	GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", flTargetPos);
	GetEntPropVector(iTarget, Prop_Send, "m_vecMins", flTargetMins);
	GetEntPropVector(iTarget, Prop_Send, "m_vecMaxs", flTargetMaxs);
	
	for (int i = 0; i < 3; i++)
	{
		flTargetPos[i] += (flTargetMins[i] + flTargetMaxs[i]) / 2.0;
	}
	
	float flTargetDist = GetVectorDistance(flTargetPos, flMyEyePos);
	if (flTargetDist <= flAttackRange)
	{
		float flDirection[3];
		SubtractVectors(g_flSlenderGoalPos[iBossIndex], flMyEyePos, flDirection);
		GetVectorAngles(flDirection, flDirection);
		
		if (FloatAbs(AngleDiff(flDirection[1], flMyEyeAng[1])) <= flAttackFOV / 2.0)
		{
			Handle hTrace = TR_TraceRayFilterEx(flMyEyePos,
				flTargetPos,
				MASK_NPCSOLID,
				RayType_EndPoint,
				TraceRayDontHitAnyEntity,
				iBoss);
				
			bool bTraceDidHit = TR_DidHit(hTrace);
			int iTraceHitEntity = TR_GetEntityIndex(hTrace);
			delete hTrace;
			
			if (!bTraceDidHit || iTraceHitEntity == iTarget)
			{
				if (bCheckBlock)
				{
					float flPos[3], flPosForward[3];
					GetEntPropVector(iBoss, Prop_Data, "m_vecAbsOrigin", flPos);
					GetPositionForward(flPos, flMyEyeAng, flPosForward, flTargetDist+50.0);
					if (NPCGetRaidHitbox(iBossIndex) == 1)
					{
						hTrace = TR_TraceHullFilterEx(flPos,
						flPosForward, 
						g_flSlenderDetectMins[iBossIndex], 
						g_flSlenderDetectMaxs[iBossIndex], 
						MASK_NPCSOLID, 
						TraceRayBossVisibility, 
						iBoss);
					}
					else if (NPCGetRaidHitbox(iBossIndex) == 0)
					{
						hTrace = TR_TraceHullFilterEx(flPos,
						flPosForward, 
						HULL_HUMAN_MINS, 
						HULL_HUMAN_MAXS, 
						MASK_NPCSOLID, 
						TraceRayBossVisibility, 
						iBoss);
					}
					iTraceHitEntity = TR_GetEntityIndex(hTrace);
					delete hTrace;
					
					if (iTraceHitEntity == iTarget)
					{
						return true;
					}
				}
				else
					return true;
			}
			delete hTrace;
		}
	}
	
	return false;
}
static bool NPCPropPhysicsAttack(int iBossIndex,int prop)
{
	char buffer[PLATFORM_MAX_PATH], sProfile[SF2_MAX_PROFILE_NAME_LENGTH], model[SF2_MAX_PROFILE_NAME_LENGTH], key[64];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	KvRewind(g_hConfig);
	KvJumpToKey(g_hConfig, sProfile);
	if(!IsValidEntity(prop))return false;
	GetEntPropString(prop, Prop_Data, "m_ModelName", model, sizeof(model));
	if (!KvJumpToKey(g_hConfig, "attack_props_physics_models")) return true;
	bool bFound=false;
	for(int i=1; ; i++)
	{
		IntToString(i, key, sizeof(key));
		KvGetString(g_hConfig, key, buffer, PLATFORM_MAX_PATH);
		if(!buffer[0])
		{
			break;
		}
		if(StrEqual(buffer,model))
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
	KvRewind(g_hConfig);
	KvJumpToKey(g_hConfig, sProfile);
	KvGetString(g_hConfig, "key_trigger", buffer, PLATFORM_MAX_PATH);
	if(!StrEqual(buffer,""))
	{
		float flMyPos[3], flVel[3];
		int iBoss = NPCGetEntIndex(iBossIndex);
		GetEntPropVector(iBoss, Prop_Data, "m_vecAbsOrigin", flMyPos);
		Format(buffer,PLATFORM_MAX_PATH,"sf2_key_%s",buffer);
		
		int TouchBox = CreateEntityByName("tf_halloween_pickup");
		//To do: allow the cfg maker to change the model.
		DispatchKeyValue(TouchBox,"targetname", buffer);
		//New Key model
		GetProfileString(sProfile, "key_model", sKeyModel, sizeof(sKeyModel));
		if(!sKeyModel[0])
		{
			DispatchKeyValue(TouchBox,"powerup_model", SF_KEYMODEL);
		}
		else
		{
			DispatchKeyValue(TouchBox,"powerup_model", sKeyModel);
		}
		DispatchKeyValue(TouchBox,"modelscale", "2.0");
		DispatchKeyValue(TouchBox,"pickup_sound","ui/itemcrate_smash_ultrarare_short.wav");
		DispatchKeyValue(TouchBox,"pickup_particle","utaunt_firework_teamcolor_red");
		DispatchKeyValue(TouchBox,"TeamNum","0");
		TeleportEntity(TouchBox, flMyPos, NULL_VECTOR, NULL_VECTOR);
		if(!sKeyModel[0])
		{
			SetEntityModel(TouchBox,SF_KEYMODEL);
		}
		else
		{
			SetEntityModel(TouchBox,sKeyModel);
		}
		SetEntProp(TouchBox, Prop_Data, "m_iEFlags", 12845056);
		DispatchSpawn(TouchBox);
		ActivateEntity(TouchBox);
		if(!sKeyModel[0])
		{
			SetEntityModel(TouchBox,SF_KEYMODEL);
		}
		else
		{
			SetEntityModel(TouchBox,sKeyModel);
		}
		
		int Key = CreateEntityByName("tf_halloween_pickup");
		//To do: allow the cfg maker to change the model.
		DispatchKeyValue(Key,"targetname", buffer);
		DispatchKeyValue(Key,"powerup_model", PAGE_MODEL);
		DispatchKeyValue(Key,"modelscale", "2.0");
		DispatchKeyValue(Key,"pickup_sound","ui/itemcrate_smash_ultrarare_short.wav");
		DispatchKeyValue(Key,"pickup_particle","utaunt_firework_teamcolor_red");
		DispatchKeyValue(Key,"TeamNum","0");
		TeleportEntity(Key, flMyPos, NULL_VECTOR, NULL_VECTOR);
		SetEntityModel(Key,PAGE_MODEL);
		SetEntProp(Key, Prop_Data, "m_iEFlags", 12845056);
		DispatchSpawn(Key);
		ActivateEntity(Key);
		
		SetEntityRenderMode(Key, RENDER_TRANSCOLOR);
		SetEntityRenderColor(Key, 0, 0, 0, 1);
		
		int glow = CreateEntityByName("tf_taunt_prop");
		//To do: allow the cfg maker to change the model.
		DispatchKeyValue(glow,"targetname", buffer);
		if(!sKeyModel[0])
		{
			DispatchKeyValue(glow,"powerup_model", SF_KEYMODEL);
		}
		else
		{
			DispatchKeyValue(glow,"powerup_model", sKeyModel);
		}
		TeleportEntity(glow, flMyPos, NULL_VECTOR, NULL_VECTOR);
		DispatchSpawn(glow);
		ActivateEntity(glow);
		if(!sKeyModel[0])
		{
			SetEntityModel(glow,SF_KEYMODEL);
		}
		else
		{
			SetEntityModel(glow,sKeyModel);
		}
		
		SetEntProp(glow, Prop_Send, "m_bGlowEnabled", 1);
		SetEntPropFloat(glow, Prop_Send, "m_flModelScale", 2.0);
		SetEntityRenderMode(glow, RENDER_TRANSCOLOR);
		SetEntityRenderColor(glow, 0, 0, 0, 1);
		
		SetVariantString("!activator");
		AcceptEntityInput(TouchBox, "SetParent", Key);
		
		SetVariantString("!activator");
		AcceptEntityInput(glow, "SetParent", Key);
		
		SetEntityModel(Key,PAGE_MODEL);
		SetEntityMoveType(Key, MOVETYPE_FLYGRAVITY);
		
		HookSingleEntityOutput(TouchBox,"OnRedPickup",KeyTrigger);
		
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
		if(flTimeLeft>60.0)
			flTimeLeft=30.0;
		else
			flTimeLeft=flTimeLeft-20.0;
		CreateTimer(flTimeLeft, CollectKey, EntIndexToEntRef(TouchBox));
	}
}
public void KeyTrigger(const char[] output, int caller, int activator, float delay)
{
	TriggerKey(caller);
}

public Action Hook_KeySetTransmit(int entity,int iOther)
{
	if(!IsValidClient(iOther)) return Plugin_Continue;
	
	if(g_bPlayerEliminated[iOther] && IsClientInGhostMode(iOther)) return Plugin_Continue;
	
	if(!g_bPlayerEliminated[iOther]) return Plugin_Continue;
	
	return Plugin_Handled;
}

public Action CollectKey(Handle timer, any entref)
{
	int ent = EntRefToEntIndex(entref);
	if (ent == INVALID_ENT_REFERENCE) return;
	char sClass[64];
	GetEntityNetClass(ent, sClass, sizeof(sClass));
	if (!StrEqual(sClass, "CHalloweenPickup")) return;
	
	TriggerKey(ent);
	return;
}
	
	
stock void TriggerKey(int caller)
{
	char targetName[PLATFORM_MAX_PATH];
	GetEntPropString(caller, Prop_Data, "m_iName", targetName, sizeof(targetName));
	
	int	ent = -1;
	while ((ent = FindEntityByClassname(ent, "tf_halloween_pickup")) != -1)
	{
		char sName[64];
		GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
		if (StrEqual(sName, targetName, false))
		{
			AcceptEntityInput(ent,"KillHierarchy");
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
		if (StrEqual(sName, targetName, false))
		{
			AcceptEntityInput(ent,"Trigger");
		}
	}
	ent = -1;
	while ((ent = FindEntityByClassname(ent, "func_door")) != -1)
	{
		char sName[64];
		GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
		if (StrEqual(sName, targetName, false))
		{
			AcceptEntityInput(ent,"Open");
		}
	}
	ent = -1;
	while ((ent = FindEntityByClassname(ent, "trigger_multiple")) != -1)
	{
		char sName[64];
		GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
		if (StrEqual(sName, targetName, false))
		{
			AcceptEntityInput(ent,"Enable");
		}
	}
	AcceptEntityInput(caller,"Kill");
	EmitSoundToAll("ui/itemcrate_smash_ultrarare_short.wav", caller, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
}
stock bool NPC_CanAttackProps(int iBossIndex,float flAttackRange,float flAttackFOV)
{
	int prop = -1;
	while ((prop = FindEntityByClassname(prop, "prop_physics")) > MaxClients)
	{
		if (NPCAttackValidateTarget(iBossIndex, prop, flAttackRange, flAttackFOV, true))
		{
			if(NPCPropPhysicsAttack(iBossIndex, prop))
			{
				return true;
			}
		}
	}
	prop = -1;
	while ((prop = FindEntityByClassname(prop, "prop_*")) > MaxClients)
	{
		if(GetEntProp(prop,Prop_Data,"m_iHealth") > 0)
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

static Action Timer_SlenderChaseBossAttackEnd(Handle timer, any entref)
{
	if (!g_bEnabled) return;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return;
	
	if (timer != g_hSlenderAttackTimer[iBossIndex]) return;
	
	g_bSlenderAttacking[iBossIndex] = false;
	g_bNPCStealingLife[iBossIndex] = false;
	g_hSlenderAttackTimer[iBossIndex] = INVALID_HANDLE;
	g_hNPCLifeStealTimer[iBossIndex] = INVALID_HANDLE;
	g_hSlenderBackupAtkTimer[iBossIndex] = INVALID_HANDLE;
	g_bNPCAlreadyAttacked[iBossIndex] = false;
	g_bNPCUseFireAnimation[iBossIndex] = false;
	g_hSlenderLaserTimer[iBossIndex] = INVALID_HANDLE;
}

static Action Timer_SlenderChaseBossAttackEndBackup(Handle timer, any entref)
{
	if (!g_bEnabled) return;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return;
	
	if (timer != g_hSlenderBackupAtkTimer[iBossIndex]) return;
	
	g_bSlenderAttacking[iBossIndex] = false;
	g_bNPCStealingLife[iBossIndex] = false;
	g_hSlenderAttackTimer[iBossIndex] = INVALID_HANDLE;
	g_hNPCLifeStealTimer[iBossIndex] = INVALID_HANDLE;
	g_hSlenderBackupAtkTimer[iBossIndex] = INVALID_HANDLE;
	g_bNPCAlreadyAttacked[iBossIndex] = false;
	g_bNPCUseFireAnimation[iBossIndex] = false;
	g_hSlenderLaserTimer[iBossIndex] = INVALID_HANDLE;
}