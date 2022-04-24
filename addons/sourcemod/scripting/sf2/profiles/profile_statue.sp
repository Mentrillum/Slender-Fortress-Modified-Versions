#if defined _sf2_profiles_statue
	#endinput
#endif

#define _sf2_profiles_statue

StringMap g_StatueProfileNames;
ArrayList g_StatueProfileData;

enum
{
	StatueProfileData_ChaseDurationEasy,
	StatueProfileData_ChaseDurationNormal,
	StatueProfileData_ChaseDurationHard,
	StatueProfileData_ChaseDurationInsane,
	StatueProfileData_ChaseDurationNightmare,
	StatueProfileData_ChaseDurationApollyon,

	StatueProfileData_ChaseDurationAddVisibilityMinEasy,
	StatueProfileData_ChaseDurationAddVisibilityMinNormal,
	StatueProfileData_ChaseDurationAddVisibilityMinHard,
	StatueProfileData_ChaseDurationAddVisibilityMinInsane,
	StatueProfileData_ChaseDurationAddVisibilityMinNightmare,
	StatueProfileData_ChaseDurationAddVisibilityMinApollyon,

	StatueProfileData_ChaseDurationAddVisibilityMaxEasy,
	StatueProfileData_ChaseDurationAddVisibilityMaxNormal,
	StatueProfileData_ChaseDurationAddVisibilityMaxHard,
	StatueProfileData_ChaseDurationAddVisibilityMaxInsane,
	StatueProfileData_ChaseDurationAddVisibilityMaxNightmare,
	StatueProfileData_ChaseDurationAddVisibilityMaxApollyon,

	StatueProfileData_MaxStats
}

void InitializeStatueProfiles()
{
	g_StatueProfileNames = new StringMap();
	g_StatueProfileData = new ArrayList(StatueProfileData_MaxStats);
}

void ClearStatueProfiles()
{
	g_StatueProfileNames.Clear();
	g_StatueProfileData.Clear();
}

public bool LoadStatueBossProfile(KeyValues kv, const char[] profile, int& uniqueProfileIndex, char[] loadFailReasonBuffer)
{
	loadFailReasonBuffer[0] = '\0';

	uniqueProfileIndex = g_StatueProfileData.Push(-1);
	g_StatueProfileNames.SetValue(profile, uniqueProfileIndex);

	float chaseDuration = kv.GetFloat("statue_chase_duration", 5.0);
	float chaseDurationEasy = kv.GetFloat("statue_chase_duration_easy", chaseDuration);
	float chaseDurationHard = kv.GetFloat("statue_chase_duration_hard", chaseDuration);
	float chaseDurationInsane = kv.GetFloat("statue_chase_duration_insane", chaseDurationHard);
	float chaseDurationNightmare = kv.GetFloat("statue_chase_duration_nightmare", chaseDurationInsane);
	float chaseDurationApollyon = kv.GetFloat("statue_chase_duration_apollyon", chaseDurationNightmare);

	float chaseDurationAddVisMin = kv.GetFloat("statue_chase_duration_add_visible_min", 0.025);
	float chaseDurationAddVisMinEasy = kv.GetFloat("statue_chase_duration_add_visible_min_easy", chaseDurationAddVisMin);
	float chaseDurationAddVisMinHard = kv.GetFloat("statue_chase_duration_add_visible_min_hard", chaseDurationAddVisMin);
	float chaseDurationAddVisMinInsane = kv.GetFloat("statue_chase_duration_add_visible_min_insane", chaseDurationAddVisMinHard);
	float chaseDurationAddVisMinNightmare = kv.GetFloat("statue_chase_duration_add_visible_min_nightmare", chaseDurationAddVisMinInsane);
	float chaseDurationAddVisMinApollyon = kv.GetFloat("statue_chase_duration_add_visible_min_apollyon", chaseDurationAddVisMinNightmare);

	float chaseDurationAddVisMax = kv.GetFloat("statue_chase_duration_add_visible_max", 0.15);
	float chaseDurationAddVisMaxEasy = kv.GetFloat("statue_chase_duration_add_visible_max_easy", chaseDurationAddVisMax);
	float chaseDurationAddVisMaxHard = kv.GetFloat("statue_chase_duration_add_visible_max_hard", chaseDurationAddVisMax);
	float chaseDurationAddVisMaxInsane = kv.GetFloat("statue_chase_duration_add_visible_max_insane", chaseDurationAddVisMaxHard);
	float chaseDurationAddVisMaxNightmare = kv.GetFloat("statue_chase_duration_add_visible_max_nightmare", chaseDurationAddVisMaxInsane);
	float chaseDurationAddVisMaxApollyon = kv.GetFloat("statue_chase_duration_add_visible_max_apollyon", chaseDurationAddVisMaxNightmare);

	g_StatueProfileData.Set(uniqueProfileIndex, chaseDuration, StatueProfileData_ChaseDurationNormal);
	g_StatueProfileData.Set(uniqueProfileIndex, chaseDurationEasy, StatueProfileData_ChaseDurationEasy);
	g_StatueProfileData.Set(uniqueProfileIndex, chaseDurationHard, StatueProfileData_ChaseDurationHard);
	g_StatueProfileData.Set(uniqueProfileIndex, chaseDurationInsane, StatueProfileData_ChaseDurationInsane);
	g_StatueProfileData.Set(uniqueProfileIndex, chaseDurationNightmare, StatueProfileData_ChaseDurationNightmare);
	g_StatueProfileData.Set(uniqueProfileIndex, chaseDurationApollyon, StatueProfileData_ChaseDurationApollyon);

	g_StatueProfileData.Set(uniqueProfileIndex, chaseDurationAddVisMin, StatueProfileData_ChaseDurationAddVisibilityMinNormal);
	g_StatueProfileData.Set(uniqueProfileIndex, chaseDurationAddVisMinEasy, StatueProfileData_ChaseDurationAddVisibilityMinEasy);
	g_StatueProfileData.Set(uniqueProfileIndex, chaseDurationAddVisMinHard, StatueProfileData_ChaseDurationAddVisibilityMinHard);
	g_StatueProfileData.Set(uniqueProfileIndex, chaseDurationAddVisMinInsane, StatueProfileData_ChaseDurationAddVisibilityMinInsane);
	g_StatueProfileData.Set(uniqueProfileIndex, chaseDurationAddVisMinNightmare, StatueProfileData_ChaseDurationAddVisibilityMinNightmare);
	g_StatueProfileData.Set(uniqueProfileIndex, chaseDurationAddVisMinApollyon, StatueProfileData_ChaseDurationAddVisibilityMinApollyon);

	g_StatueProfileData.Set(uniqueProfileIndex, chaseDurationAddVisMax, StatueProfileData_ChaseDurationAddVisibilityMaxNormal);
	g_StatueProfileData.Set(uniqueProfileIndex, chaseDurationAddVisMaxEasy, StatueProfileData_ChaseDurationAddVisibilityMaxEasy);
	g_StatueProfileData.Set(uniqueProfileIndex, chaseDurationAddVisMaxHard, StatueProfileData_ChaseDurationAddVisibilityMaxHard);
	g_StatueProfileData.Set(uniqueProfileIndex, chaseDurationAddVisMaxInsane, StatueProfileData_ChaseDurationAddVisibilityMaxInsane);
	g_StatueProfileData.Set(uniqueProfileIndex, chaseDurationAddVisMaxNightmare, StatueProfileData_ChaseDurationAddVisibilityMaxNightmare);
	g_StatueProfileData.Set(uniqueProfileIndex, chaseDurationAddVisMaxApollyon, StatueProfileData_ChaseDurationAddVisibilityMaxApollyon);

	return true;
}

methodmap SF2StatueBossProfile < SF2BaseBossProfile
{

	public SF2StatueBossProfile(int profileIndex)
	{
		return view_as<SF2StatueBossProfile>(profileIndex);
	}

	public float GetChaseDuration(int difficulty)
	{
		return GetStatueBossProfileChaseDuration(this.uniqueProfileIndex, difficulty);
	}

	public float GetChaseDurationAddVisibilityMin(int difficulty)
	{
		return GetStatueBossProfileAddChaseDurationMin(this.uniqueProfileIndex, difficulty);
	}

	public float GetChaseDurationAddVisibilityMax(int difficulty)
	{
		return GetStatueBossProfileAddChaseDurationMax(this.uniqueProfileIndex, difficulty);
	}
}

float GetStatueBossProfileChaseDuration(int statueProfileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_StatueProfileData.Get(statueProfileIndex, StatueProfileData_ChaseDurationEasy);
		case Difficulty_Hard: return g_StatueProfileData.Get(statueProfileIndex, StatueProfileData_ChaseDurationHard);
		case Difficulty_Insane: return g_StatueProfileData.Get(statueProfileIndex, StatueProfileData_ChaseDurationInsane);
		case Difficulty_Nightmare: return g_StatueProfileData.Get(statueProfileIndex, StatueProfileData_ChaseDurationNightmare);
		case Difficulty_Apollyon: return g_StatueProfileData.Get(statueProfileIndex, StatueProfileData_ChaseDurationApollyon);
	}

	return g_StatueProfileData.Get(statueProfileIndex, StatueProfileData_ChaseDurationNormal);
}

float GetStatueBossProfileAddChaseDurationMin(int statueProfileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_StatueProfileData.Get(statueProfileIndex, StatueProfileData_ChaseDurationAddVisibilityMinEasy);
		case Difficulty_Hard: return g_StatueProfileData.Get(statueProfileIndex, StatueProfileData_ChaseDurationAddVisibilityMinHard);
		case Difficulty_Insane: return g_StatueProfileData.Get(statueProfileIndex, StatueProfileData_ChaseDurationAddVisibilityMinInsane);
		case Difficulty_Nightmare: return g_StatueProfileData.Get(statueProfileIndex, StatueProfileData_ChaseDurationAddVisibilityMinNightmare);
		case Difficulty_Apollyon: return g_StatueProfileData.Get(statueProfileIndex, StatueProfileData_ChaseDurationAddVisibilityMinApollyon);
	}

	return g_StatueProfileData.Get(statueProfileIndex, StatueProfileData_ChaseDurationAddVisibilityMinNormal);
}

float GetStatueBossProfileAddChaseDurationMax(int statueProfileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_StatueProfileData.Get(statueProfileIndex, StatueProfileData_ChaseDurationAddVisibilityMaxEasy);
		case Difficulty_Hard: return g_StatueProfileData.Get(statueProfileIndex, StatueProfileData_ChaseDurationAddVisibilityMaxHard);
		case Difficulty_Insane: return g_StatueProfileData.Get(statueProfileIndex, StatueProfileData_ChaseDurationAddVisibilityMaxInsane);
		case Difficulty_Nightmare: return g_StatueProfileData.Get(statueProfileIndex, StatueProfileData_ChaseDurationAddVisibilityMaxNightmare);
		case Difficulty_Apollyon: return g_StatueProfileData.Get(statueProfileIndex, StatueProfileData_ChaseDurationAddVisibilityMaxApollyon);
	}

	return g_StatueProfileData.Get(statueProfileIndex, StatueProfileData_ChaseDurationAddVisibilityMaxNormal);
}