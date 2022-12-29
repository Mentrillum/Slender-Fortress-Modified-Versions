
enum struct SF2StatueBossProfileData
{
	ArrayList ModelsAverageDist;
	ArrayList ModelsCloseDist;

	float ChaseDuration[Difficulty_Max];
	float ChaseDurationAddVisibilityMin[Difficulty_Max];
	float ChaseDurationAddVisibilityMax[Difficulty_Max];

	float IdleLifeTime[Difficulty_Max];
	float ModelChangeDistanceMax[Difficulty_Max];

	SF2BossProfileSoundInfo MoveSounds;
	SF2BossProfileSoundInfo SingleMoveSounds;

	void Init()
	{
		this.ModelsAverageDist = null;
		this.ModelsCloseDist = null;

		this.MoveSounds.Init();
		this.SingleMoveSounds.Init();
		for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
		{
			this.ChaseDuration[difficulty] = difficulty > 0 ? this.ChaseDuration[difficulty - 1] : 5.0;
			this.ChaseDurationAddVisibilityMin[difficulty] = difficulty > 0 ? this.ChaseDurationAddVisibilityMin[difficulty - 1] : 0.025;
			this.ChaseDurationAddVisibilityMax[difficulty] = difficulty > 0 ? this.ChaseDurationAddVisibilityMax[difficulty - 1] : 0.15;
			this.ModelChangeDistanceMax[difficulty] = difficulty > 0 ? this.ModelChangeDistanceMax[difficulty - 1] : 1024.0;

			this.IdleLifeTime[difficulty] = difficulty > 0 ? this.IdleLifeTime[difficulty - 1] : 3.0;
		}
	}

	void PostLoad()
	{
		this.MoveSounds.PostLoad();
		this.SingleMoveSounds.PostLoad();
	}

	void Destroy()
	{
		if (this.ModelsAverageDist != null)
		{
			delete this.ModelsAverageDist;
		}
		if (this.ModelsCloseDist != null)
		{
			delete this.ModelsCloseDist;
		}
		this.MoveSounds.Destroy();
		this.SingleMoveSounds.Destroy();
	}

	void SortSoundSections(KeyValues kv, const char[] sectionName, bool checkFile)
	{
		if (strcmp(sectionName, "sound_move") == 0)
		{
			this.MoveSounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, "sound_move_single") == 0)
		{
			this.SingleMoveSounds.Load(kv, checkFile);
		}
	}
}
