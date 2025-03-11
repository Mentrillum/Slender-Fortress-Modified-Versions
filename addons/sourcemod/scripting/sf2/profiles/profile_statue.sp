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
