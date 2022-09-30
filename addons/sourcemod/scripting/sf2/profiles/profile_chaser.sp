#if defined _sf2_profiles_chaser
 #endinput
#endif

#define _sf2_profiles_chaser

#pragma semicolon 1

StringMap g_ChaserBossProfileData;

enum
{
	ChaserAnimation_IdleAnimations = 0, //Array that contains all the idle animations
	ChaserAnimation_WalkAnimations, //Array that contains all the walk animations
	ChaserAnimation_WalkAlertAnimations, //Array that contains all the alert walk animations
	ChaserAnimation_AttackAnimations, //Array that contains all the attack animations (working on attack index)
	ChaserAnimation_ShootAnimations, //Array that contains all the attack animations after we shoot something
	ChaserAnimation_RunAnimations, //Array that contains all the run animations
	ChaserAnimation_RunAltAnimations, //Array that contains all the alternate run animations
	ChaserAnimation_StunAnimations, //Array that contains all the stun animations
	ChaserAnimation_ChaseInitialAnimations, //Array that contains all the chase initial animations
	ChaserAnimation_RageAnimations, //Array that contains all the rage animations, used for Boxing Maps
	ChaserAnimation_DeathAnimations, //Array that contains all the death animations
	ChaserAnimation_JumpAnimations, //Array that contains all the jump animations
	ChaserAnimation_SpawnAnimations, //Array that contains all the spawn animations
	ChaserAnimation_FleeInitialAnimations, //Array that contains all the flee initial animations
	ChaserAnimation_HealAnimations, //Array that contains all the self healing animations
	ChaserAnimation_DeathcamAnimations, //Array that contains all the deathcam animations
	ChaserAnimation_CloakStartAnimations, //Array that contains all the cloak start animations
	ChaserAnimation_CloakEndAnimations, //Array that contains all the cloak end animations
	ChaserAnimation_CrawlWalkAnimations, //Array that contains all the crawl walking animations
	ChaserANimation_CrawlRunAnimations, //Array that contains all the crawl running animations
	ChaserANimation_CrawlAltRunAnimations, //Array that contains all the crawl running animations
	ChaserAnimation_MaxAnimations
};

#include "sf2/profiles/profile_chaser_precache.sp"

void InitializeChaserProfiles()
{
	g_ChaserBossProfileData = new StringMap();
}

void UnloadChaserBossProfile(const char[] profile)
{
	char tempProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	if (!g_ChaserBossProfileData.GetString(profile, tempProfile, sizeof(tempProfile)) || tempProfile[0] == '\0')
	{
		return;
	}

	SF2ChaserBossProfileData chaserProfileData;
	g_ChaserBossProfileData.GetArray(profile, chaserProfileData, sizeof(chaserProfileData));

	chaserProfileData.Destroy();

	g_ChaserBossProfileData.Remove(profile);
}

static SF2ChaserBossProfileData g_CachedProfileData;

bool GetChaserProfileEndlessChasingState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ChasesEndlessly;
}

bool GetChaserProfileAutoChaseState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.AutoChaseEnabled;
}

bool GetChaserProfileAutoChaseSprinterState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.AutoChaseSprinters;
}

int GetChaserProfileAutoChaseCount(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.AutoChaseCount[difficulty];
}

int GetChaserProfileAutoChaseAddGeneral(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.AutoChaseAdd[difficulty];
}

int GetChaserProfileAutoChaseAddFootstep(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.AutoChaseAddFootstep[difficulty];
}

int GetChaserProfileAutoChaseAddVoice(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.AutoChaseAddVoice[difficulty];
}

int GetChaserProfileAutoChaseAddWeapon(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.AutoChaseAddWeapon[difficulty];
}

float GetChaserProfileWalkSpeed(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.WalkSpeed[difficulty];
}

float GetChaserProfileMaxWalkSpeed(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.MaxWalkSpeed[difficulty];
}

float GetChaserProfileAlertGracetime(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.AlertGracetime[difficulty];
}

float GetChaserProfileAlertDuration(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.AlertDuration[difficulty];
}

float GetChaserProfileChaseDuration(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ChaseDuration[difficulty];
}

float GetChaserProfileChaseDurationAddVisibleMin(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ChaseDurationAddVisibleMin;
}

float GetChaserProfileChaseDurationAddVisibleMax(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ChaseDurationAddVisibleMax;
}

float GetChaserProfileSoundPosDiscardTime(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.SoundPosDiscardTime;
}

float GetChaserProfileSoundPosDistanceTolerance(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.SoundPosDistanceTolerance;
}

float GetChaserProfileChasePersistencyTimeInit(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ChasePersistencyTimeInit;
}

float GetChaserProfileChaseAttackPersistencyTimeInit(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ChaseAttackPersistencyTimeInit;
}

float GetChaserProfileChaseAttackPersistencyTimeAdd(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ChaseAttackPersistencyTimeAdd;
}

float GetChaserProfileChaseNewTargetPersistencyTimeInit(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ChaseNewTargetPersistencyTimeInit;
}

float GetChaserProfileChaseNewTargetPersistencyTimeAdd(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ChaseNewTargetPersistencyTimeAdd;
}

float GetChaserProfileChasePersistencyAddVisibleMin(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ChasePersistencyAddVisibleMin;
}

float GetChaserProfileChasePersistencyAddVisibleMax(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ChasePersistencyAddVisibleMax;
}

float GetChaserProfileChaseStunPersistencyTimeInit(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ChaseStunPersistencyTimeInit;
}

float GetChaserProfileChaseStunPersistencyTimeAdd(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ChaseStunPersistencyTimeAdd;
}

float GetChaserProfileWanderRangeMin(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.WanderRangeMin[difficulty];
}

float GetChaserProfileWanderRangeMax(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.WanderRangeMax[difficulty];
}

float GetChaserProfileWanderTimeMin(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.WanderTimeMin[difficulty];
}

float GetChaserProfileWanderTimeMax(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.WanderTimeMax[difficulty];
}

float GetChaserProfileProjectileCooldownMin(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProjectileCooldownMin[difficulty];
}

float GetChaserProfileProjectileCooldownMax(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProjectileCooldownMax[difficulty];
}

float GetChaserProfileIceballSlowdownDuration(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.IceballSlowDuration[difficulty];
}

float GetChaserProfileIceballSlowdownPercent(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.IceballSlowPercent[difficulty];
}

float GetChaserProfileProjectileSpeed(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProjectileSpeed[difficulty];
}

float GetChaserProfileProjectileDamage(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProjectileDamage[difficulty];
}

float GetChaserProfileProjectileRadius(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProjectileRadius[difficulty];
}

float GetChaserProfileProjectileDeviation(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProjectileDeviation[difficulty];
}

int GetChaserProfileProjectileCount(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProjectileCount[difficulty];
}

float GetChaserProfileRandomEffectDuration(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.RandomEffectDuration[difficulty];
}

float GetChaserProfileRandomEffectSlowdown(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.RandomEffectSlowdown[difficulty];
}

float GetChaserProfileJaratePlayerDuration(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.JarateDuration[difficulty];
}

float GetChaserProfileMilkPlayerDuration(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.MilkDuration[difficulty];
}

float GetChaserProfileGasPlayerDuration(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.GasDuration[difficulty];
}

float GetChaserProfileMarkPlayerDuration(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.MarkDuration[difficulty];
}

float GetChaserProfileSilentMarkPlayerDuration(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.SilentMarkDuration[difficulty];
}

float GetChaserProfileIgnitePlayerDelay(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.IgniteDelay[difficulty];
}

float GetChaserProfileStunPlayerDuration(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.StunEffectDuration[difficulty];
}

float GetChaserProfileStunPlayerSlowdown(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.StunEffectSlowdown[difficulty];
}

float GetChaserProfileBleedPlayerDuration(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.BleedDuration[difficulty];
}

float GetChaserProfileEletricPlayerDuration(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ElectricDuration[difficulty];
}

float GetChaserProfileEletricPlayerSlowdown(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ElectricSlowdown[difficulty];
}

float GetChaserProfileWakeRadius(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.WakeRadius;
}

int GetChaserProfileAttackCount(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.Attacks.Length;
}

ArrayList GetChaserProfileAttackPropModels(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.AttackPropModels;
}

int GetChaserProfileRandomAttackIndexes(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.RandomEffectIndexes;
}

int GetChaserProfileRandomAttackIndexesString(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.RandomEffectIndexesString);
}

int GetChaserProfileRandomStunType(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.RandomEffectStunType;
}

int GetChaserProfileJarateAttackIndexes(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.JarateIndexes;
}

int GetChaserProfileJarateAttackIndexesString(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.JarateIndexesString);
}

int GetChaserProfileMilkAttackIndexes(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.MilkIndexes;
}

int GetChaserProfileMilkAttackIndexesString(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.MilkIndexesString);
}

int GetChaserProfileGasAttackIndexes(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.GasIndexes;
}

int GetChaserProfileGasAttackIndexesString(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.GasIndexesString);
}

int GetChaserProfileMarkAttackIndexes(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.MarkIndexes;
}

int GetChaserProfileMarkAttackIndexesString(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.MarkIndexesString);
}

int GetChaserProfileSilentMarkAttackIndexes(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.SilentMarkIndexes;
}

int GetChaserProfileSilentMarkAttackIndexesString(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.SilentMarkIndexesString);
}

int GetChaserProfileIgniteAttackIndexes(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.IgniteIndexes;
}

int GetChaserProfileIgniteAttackIndexesString(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.IgniteIndexesString);
}

int GetChaserProfileStunAttackIndexes(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.StunEffectIndexes;
}

int GetChaserProfileStunAttackIndexesString(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.StunEffectIndexesString);
}

int GetChaserProfileStunDamageType(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.StunEffectType;
}

int GetChaserProfileBleedAttackIndexes(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.BleedIndexes;
}

int GetChaserProfileBleedAttackIndexesString(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.BleedIndexesString);
}

int GetChaserProfileEletricAttackIndexes(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ElectricIndexes;
}

int GetChaserProfileEletricAttackIndexesString(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.ElectricIndexesString);
}

int GetChaserProfileSmiteAttackIndexes(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.SmiteIndexes;
}

int GetChaserProfileSmiteAttackIndexesString(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.SmiteIndexesString);
}

int GetChaserProfileSmiteDamageType(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.SmiteDamageType;
}

void GetChaserProfileSmiteColor(const char[] profile, int buffer[4])
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	buffer = g_CachedProfileData.SmiteColor;
}

float GetChaserProfileSmiteDamage(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.SmiteDamage;
}

int GetChaserProfileAttackType(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::Type);
}

void GetChaserProfileAttackPunchVelocity(const char[] profile, int attackIndex, float buffer[3])
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	buffer = attackData.PunchVelocity;
}

bool GetChaserProfileAttackDisappear(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return false;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::Disappear);
}

int GetChaserProfileAttackRepeat(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::Repeat);
}

int GetChaserProfileMaxAttackRepeats(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::MaxRepeats);
}

ArrayList GetChaserProfileAttackRepeatTimers(const char[] profile, int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return null;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	return attackData.RepeatTimers;
}

bool GetChaserProfileAttackIgnoreAlwaysLooking(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return false;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::IgnoreAlwaysLooking);
}

int GetChaserProfileAttackWeaponTypeInt(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::WeaponInt);
}

int GetChaserProfileAttackWeaponTypeString(const char[] profile, int attackIndex, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	return strcopy(buffer, bufferlen, attackData.WeaponString);
}

float GetChaserProfileAttackDamage(const char[] profile,int attackIndex,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	return attackData.Damage[difficulty];
}

float GetChaserProfileAttackLifeStealDuration(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::LifeStealDuration);
}

float GetChaserProfileAttackProjectileDamage(const char[] profile,int attackIndex,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	return attackData.ProjectileDamage[difficulty];
}

float GetChaserProfileAttackProjectileSpeed(const char[] profile,int attackIndex,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	return attackData.ProjectileSpeed[difficulty];
}

float GetChaserProfileAttackProjectileRadius(const char[] profile,int attackIndex,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	return attackData.ProjectileRadius[difficulty];
}

float GetChaserProfileAttackProjectileDeviation(const char[] profile,int attackIndex,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	return attackData.ProjectileDeviation[difficulty];
}

int GetChaserProfileAttackProjectileCount(const char[] profile,int attackIndex,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	return attackData.ProjectileCount[difficulty];
}

bool GetChaserProfileAttackCritProjectiles(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return false;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::CritProjectiles);
}

int GetChaserProfileAttackProjectileType(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::ProjectileType);
}

void GetChaserProfileAttackProjectileOffset(const char[] profile, int attackIndex, float buffer[3])
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	buffer = attackData.ProjectileOffset;
}

float GetChaserProfileAttackProjectileIceSlowPercent(const char[] profile,int attackIndex,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	return attackData.IceballSlowdownPercent[difficulty];
}

float GetChaserProfileAttackProjectileIceSlowDuration(const char[] profile,int attackIndex,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	return attackData.IceballSlowdownDuration[difficulty];
}

int GetChaserProfileAttackFireballTrail(const char[] profile, int attackIndex, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	return strcopy(buffer, bufferlen, attackData.FireballTrail);
}

int GetChaserProfileAttackIceballTrail(const char[] profile, int attackIndex, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	return strcopy(buffer, bufferlen, attackData.IceballTrail);
}

int GetChaserProfileAttackRocketModel(const char[] profile, int attackIndex, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	return strcopy(buffer, bufferlen, attackData.RocketModel);
}

int GetChaserProfileAttackBulletCount(const char[] profile,int attackIndex,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	return attackData.BulletCount[difficulty];
}

float GetChaserProfileAttackBulletDamage(const char[] profile,int attackIndex,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	return attackData.BulletDamage[difficulty];
}

float GetChaserProfileAttackBulletSpread(const char[] profile,int attackIndex,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	return attackData.BulletSpread[difficulty];
}

int GetChaserProfileAttackBulletTrace(const char[] profile, int attackIndex, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	return strcopy(buffer, bufferlen, attackData.BulletTrace);
}

void GetChaserProfileAttackBulletOffset(const char[] profile, int attackIndex, float buffer[3])
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	buffer = attackData.BulletOffset;
}

float GetChaserProfileAttackLaserDamage(const char[] profile,int attackIndex,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	return attackData.LaserDamage[difficulty];
}

float GetChaserProfileAttackLaserSize(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::LaserSize);
}

void GetChaserProfileAttackLaserColor(const char[] profile, int attackIndex, int buffer[3])
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	buffer = attackData.LaserColor;
}

bool GetChaserProfileEnableLaserAttachment(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return false;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::LaserAttachment);
}

float GetChaserProfileAttackLaserDuration(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::LaserDuration);
}

float GetChaserProfileAttackLaserNoise(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::LaserDuration);
}

int GetChaserProfileAttackLaserAttachmentName(const char[] profile, int attackIndex, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	return strcopy(buffer, bufferlen, attackData.LaserAttachmentName);
}

void GetChaserProfileAttackLaserOffset(const char[] profile, int attackIndex, float buffer[3])
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	buffer = attackData.LaserOffset;
}

bool GetChaserProfileAttackPullIn(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return false;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::PullIn);
}

float GetChaserProfileAttackDamageVsProps(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::DamageVsProps);
}

float GetChaserProfileAttackDamageForce(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::DamageForce);
}

int GetChaserProfileAttackDamageType(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::DamageType);
}

float GetChaserProfileAttackDamageDelay(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::DamageDelay);
}

float GetChaserProfileAttackRange(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::Range);
}

float GetChaserProfileAttackDuration(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::Duration);
}

float GetChaserProfileAttackSpread(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::Spread);
}

float GetChaserProfileAttackBeginRange(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::BeginRange);
}

float GetChaserProfileAttackBeginFOV(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::BeginFOV);
}

float GetChaserProfileAttackCooldown(const char[] profile,int attackIndex,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	return attackData.Cooldown[difficulty];
}

bool GetChaserProfileAttackLifeStealState(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return false;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::LifeSteal);
}

bool GetChaserProfileAttackRunWhileAttackingState(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return false;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::AttackWhileRunning);
}

float GetChaserProfileAttackRunSpeed(const char[] profile,int attackIndex,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	SF2ChaserBossProfileAttackData attackData;
	g_CachedProfileData.Attacks.GetArray(attackIndex, attackData, sizeof(attackData));
	return attackData.RunSpeed[difficulty];
}

float GetChaserProfileAttackRunDuration(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::RunDuration);
}

float GetChaserProfileAttackRunDelay(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::RunDelay);
}

int GetChaserProfileAttackUseOnDifficulty(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::UseOnDifficulty);
}

int GetChaserProfileAttackBlockOnDifficulty(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::BlockOnDifficulty);
}

int GetChaserProfileAttackExplosiveDanceRadius(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::ExplosiveDanceRadius);
}

bool GetChaserProfileAttackGesturesState(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return false;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::Gestures);
}

bool GetChaserProfileAttackDeathCamLowHealth(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return false;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::DeathCamLowHealth);
}

bool GetChaserProfileAttackChaseInitialInterruptState(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return false;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::DontInterruptChaseInitial);
}

float GetChaserProfileAttackUseOnHealth(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::UseOnHealth);
}

float GetChaserProfileAttackBlockOnHealth(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::BlockOnHealth);
}

bool GetChaserProfileAttackCancelLOSState(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return false;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::CancelLos);
}

float GetChaserProfileAttackCancelDistance(const char[] profile,int attackIndex)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	if (g_CachedProfileData.Attacks.Length <= attackIndex)
	{
		return 0.0;
	}
	return g_CachedProfileData.Attacks.Get(attackIndex, SF2ChaserBossProfileAttackData::CancelDistance);
}

bool GetChaserProfileEnableAdvancedDamageEffects(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.AdvancedDamageEffects;
}

bool GetChaserProfileEnableAdvancedDamageEffectsRandom(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.RandomAdvancedDamageEffects;
}

bool GetChaserProfileEnableAdvancedDamageParticles(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.AdvancedDamageEffectParticles;
}

bool GetChaserProfileJarateState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.JarateEffects;
}

bool GetChaserProfileJarateBeamParticle(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.JarateBeamParticle;
}

int GetChaserProfileJarateParticle(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.JarateParticle);
}

bool GetChaserProfileMilkState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.MilkEffects;
}

bool GetChaserProfileMilkBeamParticle(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.MilkBeamParaticle;
}

int GetChaserProfileMilkParticle(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.MilkParticle);
}

bool GetChaserProfileGasState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.GasEffects;
}

bool GetChaserProfileGasBeamParticle(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.GasBeamParticle;
}

int GetChaserProfileGasParticle(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.GasParticle);
}

bool GetChaserProfileMarkState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.MarkEffects;
}

bool GetChaserProfileSilentMarkState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.SilentMarkEffects;
}

bool GetChaserProfileIgniteState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.IgniteEffects;
}

bool GetChaserProfileStunAttackState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.StunEffects;
}

bool GetChaserProfileStunAttackBeamParticle(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.StunEffectBeamParticle;
}

int GetChaserProfileStunParticle(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.StunParticle);
}

bool GetChaserProfileBleedState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.BleedEffects;
}

bool GetChaserProfileEletricAttackState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ElectricEffects;
}

bool GetChaserProfileEletricBeamParticle(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ElectricBeamParticle;
}

int GetChaserProfileElectricRedParticle(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.ElectricParticleRed);
}

int GetChaserProfileElectricBlueParticle(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.ElectricParticleBlue);
}

bool GetChaserProfileSmiteState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.SmiteEffects;
}

bool GetChaserProfileSmiteMessage(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.SmiteMessage;
}

bool GetChaserProfileXenobladeCombo(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.XenobladeCombo;
}

float GetChaserProfileXenobladeBreakDuration(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.XenobladeDuration;
}

float GetChaserProfileXenobladeToppleDuration(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.XenobladeToppleDuration;
}

float GetChaserProfileXenobladeToppleSlowdown(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.XenobladeToppleSlowdown;
}

float GetChaserProfileXenobladeDazeDuration(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.XenobladeDazeDuration;
}

bool GetChaserProfileCloakState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.CanCloak;
}

bool GetChaserProfileProjectileState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProjectilesEnabled;
}

bool GetChaserProfileCriticalRockets(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.CriticalProjectiles;
}

bool GetChaserProfileGestureShoot(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ShootGestures;
}

int GetChaserProfileShootGestureName(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.ShootGestureName);
}

bool GetChaserProfileShootAnimationsState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ShootAnimations;
}

bool GetChaserProfileProjectileAmmoState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProjectileClips;
}

bool GetChaserProfileChargeUpProjectilesState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ChargeUpProjectiles;
}

int GetChaserProfileRandomProjectilePosMin(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProjectileRandomPosMin;
}

int GetChaserProfileRandomProjectilePosMax(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProjectileRandomPosMax;
}

int GetChaserProfileBaseballModel(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.BaseballModel);
}

ArrayList GetChaserProfileProjectilePositionsArray(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProjectilePosOffsets;
}

int GetChaserProfileProjectileType(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProjectileType;
}

int GetChaserProfileProjectileLoadedAmmo(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProjectileClipSize[difficulty];
}

float GetChaserProfileProjectileAmmoReloadTime(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProjectileReloadTime[difficulty];
}

float GetChaserProfileProjectileChargeUpTime(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProjectileChargeUp[difficulty];
}

bool GetChaserProfileDamageParticleState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.DamageParticles;
}

int GetChaserProfileDamageParticleName(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.DamageParticleName);
}

bool GetChaserProfileDamageParticleBeamState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.DamageParticleBeam;
}

int GetChaserProfileDamageParticleSound(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.DamageParticleSound);
}

bool GetChaserProfileStunState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.StunEnabled;
}

float GetChaserProfileStunCooldown(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.StunCooldown;
}

bool GetChaserProfileStunFlashlightState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.FlashlightStun;
}

float GetChaserProfileStunFlashlightDamage(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.FlashlightDamage;
}

bool GetChaserProfileStunOnChaseInitial(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ChaseInitialOnStun;
}

ArrayList GetChaserProfileDamageResistances(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.DamageResistances;
}

float GetChaserProfileStunHealth(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.StunHealth;
}

float GetChaserProfileStunHealthPerPlayer(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.StunHealthPerPlayer;
}

float GetChaserProfileStunHealthPerClass(const char[] profile, int index)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.StunHealthPerClass[index];
}

bool GetChaserProfileKeyDrop(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.KeyDrop;
}

int GetChaserProfileKeyModel(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.KeyModel);
}

int GetChaserProfileKeyTrigger(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.KeyTrigger);
}

bool GetChaserProfileDisappearOnStun(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.DisappearOnStun;
}

bool GetChaserProfileStunItemDropState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ItemDropOnStun;
}

int GetChaserProfileStunItemDropType(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.StunItemDropType;
}

bool GetChaserProfileBoxingState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.BoxingBoss;
}

bool GetChaserProfileNormalSoundHook(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.NormalSoundHook;
}

bool GetChaserProfileChaseOnLook(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ChaseOnLook;
}

bool GetChaserProfileEarthquakeFootstepState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.EarthquakeFootsteps;
}

float GetChaserProfileEarthquakeFootstepAmplitude(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.EarthquakeFootstepAmplitude;
}

float GetChaserProfileEarthquakeFootstepFrequency(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.EarthquakeFootstepFrequency;
}

float GetChaserProfileEarthquakeFootstepDuration(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.EarthquakeFootstepDuration;
}

float GetChaserProfileEarthquakeFootstepRadius(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.EarthquakeFootstepRadius;
}

bool GetChaserProfileEarthquakeFootstepAirShake(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.EarthquakeFootstepAirShake;
}

int GetChaserProfileSoundCountToAlert(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.SoundCountToAlert;
}

float GetChaserProfileCloakCooldown(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.CloakCooldown[difficulty];
}

float GetChaserProfileCloakRange(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.CloakRange[difficulty];
}

float GetChaserProfileDecloakRange(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.DecloakRange[difficulty];
}

float GetChaserProfileCloakDuration(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.CloakDuration[difficulty];
}

float GetChaserProfileCloakSpeedMultiplier(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.CloakSpeedMultiplier[difficulty];
}

bool GetChaserProfileCloakToHeal(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.CloakToHeal;
}

int GetChaserProfileCloakParticle(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.CloakParticle);
}

void GetChaserProfileCloakRenderColor(const char[] profile, int buffer[4])
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	buffer =  g_CachedProfileData.CloakRenderColor;
}

int GetChaserProfileCloakRenderMode(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.CloakRenderMode;
}

bool GetChaserProfileChaseInitialAnimationState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ChaseInitialAnimations;
}

bool GetChaserProfileSpawnAnimationState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.SpawnAnimationsEnabled;
}

bool GetChaserProfileOldAnimState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.OldAnimationAI;
}

bool GetChaserProfileAlertWalkingState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.AlertWalkingAnimation;
}

bool GetChaserProfileUnnerfedVisibility(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.UnnerfedVisibility;
}

bool GetChaserProfileClearLayersState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ClearLayersOnAnimUpdate;
}

float GetChaserProfileHealAnimTimer(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.HealAnimationTimer;
}

float GetChaserProfileHealFunctionTimer(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.HealFunctionTimer;
}

float GetChaserProfileHealRangeMin(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.HealRangeMin;
}

float GetChaserProfileHealRangeMax(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.HealRangeMax;
}

float GetChaserProfileHealTimeMin(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.HealTimeMin;
}

float GetChaserProfileHealTimeMax(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.HealTimeMax;
}

float GetChaserProfileAfterburnMultiplier(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.AfterburnMultiplier;
}

float GetChaserProfileBackstabDamageScale(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.BackstabDamageScale;
}

bool GetChaserProfileShockwaveState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.Shockwaves;
}

float GetChaserProfileShockwaveHeight(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ShockwaveHeight[difficulty];
}

float GetChaserProfileShockwaveRange(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ShockwaveRange[difficulty];
}

float GetChaserProfileShockwaveDrain(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ShockwaveDrain[difficulty];
}

float GetChaserProfileShockwaveForce(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ShockwaveForce[difficulty];
}

bool GetChaserProfileShockwaveStunState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ShockwaveStun;
}

float GetChaserProfileShockwaveStunDuration(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ShockwaveStunDuration[difficulty];
}

float GetChaserProfileShockwaveStunSlowdown(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ShockwaveStunSlowdown[difficulty];
}

int GetChaserProfileShockwaveAttackIndexes(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ShockwaveIndexes;
}

int GetChaserProfileShockwaveAttackIndexesString(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.ShockwaveIndexesString);
}

float GetChaserProfileShockwaveWidth1(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ShockwaveWidths[0];
}

float GetChaserProfileShockwaveWidth2(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ShockwaveWidths[1];
}

float GetChaserProfileShockwaveAmplitude(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ShockwaveAmplitude;
}

void GetChaserProfileShockwaveColor1(const char[] profile, int buffer[3])
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	buffer = g_CachedProfileData.ShockwaveColor1;
}

void GetChaserProfileShockwaveColor2(const char[] profile, int buffer[3])
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	buffer = g_CachedProfileData.ShockwaveColor2;
}

int GetChaserProfileShockwaveAlpha1(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ShockwaveAlpha1;
}

int GetChaserProfileShockwaveAlpha2(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ShockwaveAlpha2;
}

int GetBossProfileShockwaveBeamSprite(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.ShockwaveBeamSprite);
}

int GetBossProfileShockwaveHaloSprite(const char[] profile, char[] buffer, int bufferlen)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.ShockwaveHaloSprite);
}

int GetBossProfileShockwaveBeamModel(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ShockwaveBeamModel;
}

int GetBossProfileShockwaveHaloModel(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ShockwaveHaloModel;
}

bool GetChaserProfileTrapState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.Traps;
}

int GetChaserProfileTrapType(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.TrapType;
}

float GetChaserProfileTrapSpawnCooldown(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.TrapCooldown[difficulty];
}

bool GetChaserProfileCrawlState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.Crawling;
}

float GetChaserProfileCrawlSpeedMultiplier(const char[] profile,int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.CrawlSpeedMultiplier[difficulty];
}

void GetChaserProfileCrawlMins(const char[] profile, float buffer[3])
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	buffer = g_CachedProfileData.CrawlDetectMins;
}

void GetChaserProfileCrawlMaxs(const char[] profile, float buffer[3])
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	buffer = g_CachedProfileData.CrawlDetectMaxs;
}

bool GetChaserProfileSelfHealState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.SelfHeal;
}

float GetChaserProfileSelfHealStartPercentage(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.SelfHealPercentageStart;
}

float GetChaserProfileSelfHealPercentageOne(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.SelfHealRecover[0];
}

float GetChaserProfileSelfHealPercentageTwo(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.SelfHealRecover[1];
}

float GetChaserProfileSelfHealPercentageThree(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.SelfHealRecover[2];
}

void GetChaserProfileIdleSounds(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.IdleSounds;
}

void GetChaserProfileAlertSounds(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.AlertSounds;
}

void GetChaserProfileChasingSounds(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.ChasingSounds;
}

void GetChaserProfileChaseInitialSounds(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.ChaseInitialSounds;
}

void GetChaserProfileStunSounds(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.StunnedSounds;
}

void GetChaserProfileAttackKilledSounds(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.AttackKilledSounds;
}

void GetChaserProfileAttackKilledAllSounds(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.AttackKilledAllSounds;
}

void GetChaserProfileAttackKilledClientSounds(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.AttackKilledClientSounds;
}

void GetChaserProfileRageAllSounds(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.RageAllSounds;
}

void GetChaserProfileRageTwoSounds(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.RageTwoSounds;
}

void GetChaserProfileRageThreeSounds(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.RageThreeSounds;
}

void GetChaserProfileSelfHealSounds(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.SelfHealSounds;
}

void GetChaserProfileFootstepSounds(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.FootstepSounds;
}

ArrayList GetChaserProfileAttackSounds(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.AttackSounds;
}

ArrayList GetChaserProfileHitSounds(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.HitSounds;
}

ArrayList GetChaserProfileMissSounds(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.MissSounds;
}

ArrayList GetChaserProfileBulletShootSounds(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.BulletShootSounds;
}

ArrayList GetChaserProfileProjectileShootSounds(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProjectileShootSounds;
}

void GetChaserProfileChaseMusics(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.ChaseMusics;
}

void GetChaserProfileChaseVisibleMusics(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.ChaseVisibleMusics;
}

void GetChaserProfileAlertMusics(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.AlertMusics;
}

void GetChaserProfileIdleMusics(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.IdleMusics;
}

void GetChaserProfileTwentyDollarMusics(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.TwentyDollarsMusics;
}

int GetProfileAttackNum(const char[] profile, const char[] keyValue,int defaultValue=0, const int attackIndex)
{
	if (!IsProfileValid(profile))
	{
		return defaultValue;
	}

	char key[4];
	g_Config.Rewind();
	g_Config.JumpToKey(profile);
	g_Config.JumpToKey("attacks");
	FormatEx(key, sizeof(key), "%d", attackIndex);
	g_Config.JumpToKey(key);
	return g_Config.GetNum(keyValue, defaultValue);
}

float GetProfileAttackFloat(const char[] profile, const char[] keyValue,float defaultValue=0.0, const int attackIndex)
{
	if (!IsProfileValid(profile))
	{
		return defaultValue;
	}

	char key[4];
	g_Config.Rewind();
	g_Config.JumpToKey(profile);
	g_Config.JumpToKey("attacks");
	FormatEx(key, sizeof(key), "%d", attackIndex);
	g_Config.JumpToKey(key);
	return g_Config.GetFloat(keyValue, defaultValue);
}

bool GetProfileAttackString(const char[] profile, const char[] keyValue, char[] buffer, int length, const char[] defaultValue = "", const int attackIndex)
{
	if (!IsProfileValid(profile))
	{
		return false;
	}

	char key[4];
	g_Config.Rewind();
	g_Config.JumpToKey(profile);
	g_Config.JumpToKey("attacks");
	FormatEx(key, sizeof(key), "%d", attackIndex);
	g_Config.JumpToKey(key);
	g_Config.GetString(keyValue, buffer, length, defaultValue);
	return true;
}

bool GetProfileAttackVector(const char[] profile, const char[] keyValue, float buffer[3], const float defaultValue[3]=NULL_VECTOR, const int attackIndex)
{
	for (int i = 0; i < 3; i++)
	{
		buffer[i] = defaultValue[i];
	}

	if (!IsProfileValid(profile))
	{
		return false;
	}

	char key[4];
	g_Config.Rewind();
	g_Config.JumpToKey(profile);
	g_Config.JumpToKey("attacks");
	FormatEx(key, sizeof(key), "%d", attackIndex);
	g_Config.JumpToKey(key);
	g_Config.GetVector(keyValue, buffer, defaultValue);
	return true;
}