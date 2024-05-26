#if defined _sf2_profiles_chaser
 #endinput
#endif

#define _sf2_profiles_chaser

#pragma semicolon 1

StringMap g_ChaserBossProfileData;

#include "profile_chaser_precache.sp"

void InitializeChaserProfiles()
{
	g_ChaserBossProfileData = new StringMap();
}

void UnloadChaserBossProfile(const char[] profile)
{
	SF2ChaserBossProfileData chaserProfileData;
	if (!g_ChaserBossProfileData.GetArray(profile, chaserProfileData, sizeof(chaserProfileData)))
	{
		return;
	}

	chaserProfileData.Destroy();

	g_ChaserBossProfileData.Remove(profile);
}

static SF2ChaserBossProfileData g_CachedProfileData;

float GetChaserProfileDeathHealth(const char[] profile, int difficulty)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.DeathData.Health[difficulty];
}

bool GetChaserProfileBoxingState(const char[] profile)
{
	g_ChaserBossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.BoxingBoss;
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

int GetProfileAttackNum(const char[] profile, const char[] keyValue, int defaultValue=0, const int attackIndex)
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