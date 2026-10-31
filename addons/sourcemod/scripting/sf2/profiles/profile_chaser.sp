#if defined _sf2_profiles_chaser
 #endinput
#endif

#define _sf2_profiles_chaser

#pragma semicolon 1
#pragma newdecls required

methodmap ChaserBossProfile < BaseBossProfile
{
	public int GetAttackCount()
	{
		KeyMap_Array arr = this.GetArray("__chaser_attack_names");
		if (arr == null)
		{
			return -1;
		}

		return arr.Length;
	}

	public void GetAttackName(int index, char[] buffer, int bufferSize)
	{
		KeyMap_Array arr = this.GetArray("__chaser_attack_names");
		if (arr == null)
		{
			return;
		}

		arr.GetString(index, buffer, bufferSize);
	}

	public ChaserBossProfileBaseAttack GetAttack(const char[] name)
	{
		ProfileObject obj = this.GetSection("attacks");
		if (obj == null)
		{
			return null;
		}

		return view_as<ChaserBossProfileBaseAttack>(obj.GetSection(name));
	}

	public ChaserBossProfileBaseAttack GetAttackFromIndex(int index)
	{
		char name[256];
		this.GetAttackName(index, name, sizeof(name));
		return this.GetAttack(name);
	}

	public ProfileMusic GetIdleMusics()
	{
		return view_as<ProfileMusic>(this.GetSection("sound_idle_music"));
	}

	public ProfileMusic GetAlertMusics()
	{
		return view_as<ProfileMusic>(this.GetSection("sound_alert_music"));
	}

	public ProfileMusic GetChaseMusics()
	{
		return view_as<ProfileMusic>(this.GetSection("sound_chase_music"));
	}

	public ProfileMusic GetVisibleIdleMusics()
	{
		return view_as<ProfileMusic>(this.GetSection("sound_idle_visible"));
	}

	public ProfileMusic GetVisibleAlertMusics()
	{
		return view_as<ProfileMusic>(this.GetSection("sound_alert_visible"));
	}

	public ProfileMusic GetVisibleChaseMusics()
	{
		return view_as<ProfileMusic>(this.GetSection("sound_chase_visible"));
	}

	public void Precache()
	{
		ProfileObject obj = this.GetSection("attacks");
		if (obj != null)
		{
			KeyMap_Array attackNames = new KeyMap_Array(Key_Type_Value);
			this.SetSection("__chaser_attack_names", attackNames);
			this.SetType("__chaser_attack_names", Key_Type_Section);
			attackNames.Parent = this;

			for (int i = 0; i < obj.SectionLength; i++)
			{
				char name[64];
				obj.GetSectionNameFromIndex(i, name, sizeof(name));

				ChaserBossProfileBaseAttack attack = view_as<ChaserBossProfileBaseAttack>(obj.GetSection(name));
				if (attack != null)
				{
					attackNames.PushString(name);
				}
			}
		}

		if (this.GetIdleMusics() != null)
		{
			this.GetIdleMusics().Precache();
		}

		if (this.GetAlertMusics() != null)
		{
			this.GetAlertMusics().Precache();
		}

		if (this.GetChaseMusics() != null)
		{
			this.GetChaseMusics().Precache();
		}

		if (this.GetVisibleIdleMusics() != null)
		{
			this.GetVisibleIdleMusics().Precache();
		}

		if (this.GetVisibleAlertMusics() != null)
		{
			this.GetVisibleAlertMusics().Precache();
		}

		if (this.GetVisibleChaseMusics() != null)
		{
			this.GetVisibleChaseMusics().Precache();
		}
	}
}

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

int GetProfileAttackNum(const char[] profile, const char[] keyValue, int defaultValue = 0, const int attackIndex)
{
	if (!IsProfileValid(profile))
	{
		return defaultValue;
	}

	ChaserBossProfile profileData = view_as<ChaserBossProfile>(GetBossProfile(profile));
	if (profileData.GetSection("attacks") == null)
	{
		return defaultValue;
	}

	ChaserBossProfileBaseAttack attack = profileData.GetAttackFromIndex(attackIndex);
	return attack.GetInt(keyValue, defaultValue);
}

float GetProfileAttackFloat(const char[] profile, const char[] keyValue, float defaultValue = 0.0, const int attackIndex)
{
	if (!IsProfileValid(profile))
	{
		return defaultValue;
	}

	ChaserBossProfile profileData = view_as<ChaserBossProfile>(GetBossProfile(profile));
	if (profileData.GetSection("attacks") == null)
	{
		return defaultValue;
	}

	ChaserBossProfileBaseAttack attack = profileData.GetAttackFromIndex(attackIndex);
	return attack.GetFloat(keyValue, defaultValue);
}

bool GetProfileAttackString(const char[] profile, const char[] keyValue, char[] buffer, int length, const char[] defaultValue = "", const int attackIndex)
{
	strcopy(buffer, length, defaultValue);

	if (!IsProfileValid(profile))
	{
		return false;
	}

	ChaserBossProfile profileData = view_as<ChaserBossProfile>(GetBossProfile(profile));
	if (profileData.GetSection("attacks") == null)
	{
		return false;
	}

	ChaserBossProfileBaseAttack attack = profileData.GetAttackFromIndex(attackIndex);
	attack.GetString(keyValue, buffer, length, defaultValue);

	return true;
}

bool GetProfileAttackVector(const char[] profile, const char[] keyValue, float buffer[3], const float defaultValue[3] = NULL_VECTOR, const int attackIndex)
{
	for (int i = 0; i < 3; i++)
	{
		buffer[i] = defaultValue[i];
	}

	if (!IsProfileValid(profile))
	{
		return false;
	}

	ChaserBossProfile profileData = view_as<ChaserBossProfile>(GetBossProfile(profile));
	if (profileData.GetSection("attacks") == null)
	{
		return false;
	}

	ChaserBossProfileBaseAttack attack = profileData.GetAttackFromIndex(attackIndex);
	attack.GetVector(keyValue, buffer, defaultValue);

	return true;
}

void ProfileChaser_InititalizeAPI()
{
	CreateNative("SF2_ChaserBossProfile.GetAttackCount", Native_GetAttackCount);
	CreateNative("SF2_ChaserBossProfile.GetAttack", Native_GetAttack);
	CreateNative("SF2_ChaserBossProfile.GetAttackFromIndex", Native_GetAttackFromIndex);
}

static any Native_GetAttackCount(Handle plugin, int numParams)
{
	ChaserBossProfile profileData = GetNativeCell(1);
	if (profileData == null || profileData.Type != SF2BossType_Chaser)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid Chaser boss profile handle %x", profileData);
	}

	return profileData.GetAttackCount();
}

static any Native_GetAttack(Handle plugin, int numParams)
{
	ChaserBossProfile profileData = GetNativeCell(1);
	if (profileData == null || profileData.Type != SF2BossType_Chaser)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid Chaser boss profile handle %x", profileData);
	}

	char attackName[256];
	GetNativeString(2, attackName, sizeof(attackName));

	return profileData.GetAttack(attackName);
}

static any Native_GetAttackFromIndex(Handle plugin, int numParams)
{
	ChaserBossProfile profileData = GetNativeCell(1);
	if (profileData == null || profileData.Type != SF2BossType_Chaser)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid Chaser boss profile handle %x", profileData);
	}

	int attackIndex = GetNativeCell(2);

	return profileData.GetAttackFromIndex(attackIndex);
}