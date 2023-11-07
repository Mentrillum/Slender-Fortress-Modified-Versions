#if defined _sf2_profiles_statue
	#endinput
#endif

#define _sf2_profiles_statue

#pragma semicolon 1

StringMap g_StatueBossProfileData;

void InitializeStatueProfiles()
{
	g_StatueBossProfileData = new StringMap();
}

void UnloadStatueBossProfile(const char[] profile)
{
	SF2StatueBossProfileData statueProfileData;
	if (!g_StatueBossProfileData.GetArray(profile, statueProfileData, sizeof(statueProfileData)))
	{
		return;
	}

	statueProfileData.Destroy();

	g_StatueBossProfileData.Remove(profile);
}

bool LoadStatueBossProfile(KeyValues kv, const char[] profile, char[] loadFailReasonBuffer, int loadFailReasonBufferLen, SF2BossProfileData baseData)
{
	SF2StatueBossProfileData profileData;
	profileData.Init();

	strcopy(loadFailReasonBuffer, loadFailReasonBufferLen, "");

	profileData.ModelsAverageDist = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
	profileData.ModelsCloseDist = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
	SetProfileDifficultyStringArrayValues(kv, "model_averagedist", profileData.ModelsAverageDist, true);
	SetProfileDifficultyStringArrayValues(kv, "model_closedist", profileData.ModelsCloseDist, true);
	char modelName[PLATFORM_MAX_PATH];
	for (int i = 0; i < profileData.ModelsAverageDist.Length; i++)
	{
		profileData.ModelsAverageDist.GetString(i, modelName, sizeof(modelName));
		if (modelName[0] != '\0' && strcmp(modelName, "models/", true) != 0 && strcmp(modelName, "models\\", true) != 0)
		{
			PrecacheModel2(modelName, _, _, g_FileCheckConVar.BoolValue);
		}
	}
	for (int i = 0; i < profileData.ModelsCloseDist.Length; i++)
	{
		profileData.ModelsCloseDist.GetString(i, modelName, sizeof(modelName));
		if (modelName[0] != '\0' && strcmp(modelName, "models/", true) != 0 && strcmp(modelName, "models\\", true) != 0)
		{
			PrecacheModel2(modelName, _, _, g_FileCheckConVar.BoolValue);
		}
	}

	GetProfileDifficultyFloatValues(kv, "chase_duration", profileData.ChaseDuration, profileData.ChaseDuration);
	for (int i = 0; i < Difficulty_Max; i++)
	{
		profileData.ChaseDurationAddMaxRange[i] = baseData.SearchRange[i];
	}
	GetProfileDifficultyFloatValues(kv, "chase_duration_add_max_range", profileData.ChaseDurationAddMaxRange, profileData.ChaseDurationAddMaxRange);
	GetProfileDifficultyFloatValues(kv, "chase_duration_add_visible_min", profileData.ChaseDurationAddVisibilityMin, profileData.ChaseDurationAddVisibilityMin);
	GetProfileDifficultyFloatValues(kv, "chase_duration_add_visible_max", profileData.ChaseDurationAddVisibilityMax, profileData.ChaseDurationAddVisibilityMax);
	GetProfileDifficultyFloatValues(kv, "model_change_dist_max", profileData.ModelChangeDistanceMax, profileData.ModelChangeDistanceMax);

	GetProfileDifficultyFloatValues(kv, "idle_lifetime", profileData.IdleLifeTime, profileData.IdleLifeTime);

	if (kv.GotoFirstSubKey())
	{
		char s2[64];

		do
		{
			kv.GetSectionName(s2, sizeof(s2));

			if (!StrContains(s2, "sound_"))
			{
				profileData.SortSoundSections(kv, s2, g_FileCheckConVar.BoolValue);
			}
		}
		while (kv.GotoNextKey());

		kv.GoBack();
	}

	profileData.PostLoad();

	g_StatueBossProfileData.SetArray(profile, profileData, sizeof(profileData));

	return true;
}
