#if defined _sf2_profiles_statue
	#endinput
#endif

#define _sf2_profiles_statue

#pragma semicolon 1
#pragma newdecls required

methodmap StatueBossProfile < BaseBossProfile
{
	public void GetAverageDistanceModel(int difficulty, char[] buffer, int bufferSize)
	{
		this.GetDifficultyString("model_averagedist", difficulty, buffer, bufferSize);
		ReplaceString(buffer, bufferSize, "\\", "/", false);
	}

	public void GetCloseDistanceModel(int difficulty, char[] buffer, int bufferSize)
	{
		this.GetDifficultyString("model_closedist", difficulty, buffer, bufferSize);
		ReplaceString(buffer, bufferSize, "\\", "/", false);
	}

	public float GetMaxModelChangeDistance(int difficulty)
	{
		return this.GetDifficultyFloat("model_change_dist_max", difficulty, 1024.0);
	}

	public float GetChaseDuration(int difficulty)
	{
		return this.GetDifficultyFloat("chase_duration", difficulty, 5.0);
	}

	public float GetChaseDurationAddMaxRange(int difficulty)
	{
		return this.GetDifficultyFloat("chase_duration_add_max_range", difficulty, 1024.0);
	}

	public float GetChaseDurationAddVisibilityMin(int difficulty)
	{
		return this.GetDifficultyFloat("chase_duration_add_visible_min", difficulty, 0.025);
	}

	public float GetChaseDurationAddVisibilityMax(int difficulty)
	{
		return this.GetDifficultyFloat("chase_duration_add_visible_max", difficulty, 0.15);
	}

	public ProfileSound GetMoveSounds()
	{
		return view_as<ProfileSound>(this.GetSection("sound_move"));
	}

	public ProfileSound GetSingleMoveSounds()
	{
		return view_as<ProfileSound>(this.GetSection("sound_move_single"));
	}

	public void Precache()
	{
		if (this.GetMoveSounds() != null)
		{
			this.GetMoveSounds().Precache();
		}

		if (this.GetSingleMoveSounds() != null)
		{
			this.GetSingleMoveSounds().SetDefaultCooldownMin(0.125);
			this.GetSingleMoveSounds().SetDefaultCooldownMax(0.125);
			this.GetSingleMoveSounds().Precache();
		}

		char path[PLATFORM_MAX_PATH];
		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.GetAverageDistanceModel(i, path, sizeof(path));
			if (path[0] != '\0')
			{
				PrecacheModel2(path, _, _, g_FileCheckConVar.BoolValue);
			}

			this.GetCloseDistanceModel(i, path, sizeof(path));
			if (path[0] != '\0')
			{
				PrecacheModel2(path, _, _, g_FileCheckConVar.BoolValue);
			}
		}
	}
}

/*bool LoadStatueBossProfile(KeyValues kv, const char[] profile, char[] loadFailReasonBuffer, int loadFailReasonBufferLen, SF2BossProfileData baseData)
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

	ArrayList validSections = new ArrayList(ByteCountToCells(128));

	if (kv.GotoFirstSubKey())
	{
		char s2[64];

		do
		{
			kv.GetSectionName(s2, sizeof(s2));

			if (validSections.FindString(s2) != -1)
			{
				continue;
			}

			validSections.PushString(s2);

			if (!StrContains(s2, "sound_"))
			{
				profileData.SortSoundSections(kv, s2, g_FileCheckConVar.BoolValue);
			}
		}
		while (kv.GotoNextKey());

		kv.GoBack();
	}

	delete validSections;

	profileData.PostLoad();

	g_StatueBossProfileData.SetArray(profile, profileData, sizeof(profileData));

	return true;
}*/
