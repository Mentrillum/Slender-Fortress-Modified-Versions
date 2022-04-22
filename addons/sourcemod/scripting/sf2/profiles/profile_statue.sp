#if defined _sf2_profiles_statue
	#endinput
#endif

#define _sf2_profiles_statue

StringMap g_hStatueProfileNames;
ArrayList g_hStatueProfileData;

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
	g_hStatueProfileNames = new StringMap();
	g_hStatueProfileData = new ArrayList(StatueProfileData_MaxStats);
}

void ClearStatueProfiles()
{
	g_hStatueProfileNames.Clear();
	g_hStatueProfileData.Clear();
}

public bool LoadStatueBossProfile(KeyValues kv, const char[] sProfile, int& iUniqueProfileIndex, char[] sLoadFailReasonBuffer)
{
	sLoadFailReasonBuffer[0] = '\0';

	iUniqueProfileIndex = g_hStatueProfileData.Push(-1);
	g_hStatueProfileNames.SetValue(sProfile, iUniqueProfileIndex);

	float flChaseDuration = kv.GetFloat("statue_chase_duration", 5.0);
	float flChaseDurationEasy = kv.GetFloat("statue_chase_duration_easy", flChaseDuration);
	float flChaseDurationHard = kv.GetFloat("statue_chase_duration_hard", flChaseDuration);
	float flChaseDurationInsane = kv.GetFloat("statue_chase_duration_insane", flChaseDurationHard);
	float flChaseDurationNightmare = kv.GetFloat("statue_chase_duration_nightmare", flChaseDurationInsane);
	float flChaseDurationApollyon = kv.GetFloat("statue_chase_duration_apollyon", flChaseDurationNightmare);

	float flChaseDurationAddVisMin = kv.GetFloat("statue_chase_duration_add_visible_min", 0.025);
	float flChaseDurationAddVisMinEasy = kv.GetFloat("statue_chase_duration_add_visible_min_easy", flChaseDurationAddVisMin);
	float flChaseDurationAddVisMinHard = kv.GetFloat("statue_chase_duration_add_visible_min_hard", flChaseDurationAddVisMin);
	float flChaseDurationAddVisMinInsane = kv.GetFloat("statue_chase_duration_add_visible_min_insane", flChaseDurationAddVisMinHard);
	float flChaseDurationAddVisMinNightmare = kv.GetFloat("statue_chase_duration_add_visible_min_nightmare", flChaseDurationAddVisMinInsane);
	float flChaseDurationAddVisMinApollyon = kv.GetFloat("statue_chase_duration_add_visible_min_apollyon", flChaseDurationAddVisMinNightmare);

	float flChaseDurationAddVisMax = kv.GetFloat("statue_chase_duration_add_visible_max", 0.15);
	float flChaseDurationAddVisMaxEasy = kv.GetFloat("statue_chase_duration_add_visible_max_easy", flChaseDurationAddVisMax);
	float flChaseDurationAddVisMaxHard = kv.GetFloat("statue_chase_duration_add_visible_max_hard", flChaseDurationAddVisMax);
	float flChaseDurationAddVisMaxInsane = kv.GetFloat("statue_chase_duration_add_visible_max_insane", flChaseDurationAddVisMaxHard);
	float flChaseDurationAddVisMaxNightmare = kv.GetFloat("statue_chase_duration_add_visible_max_nightmare", flChaseDurationAddVisMaxInsane);
	float flChaseDurationAddVisMaxApollyon = kv.GetFloat("statue_chase_duration_add_visible_max_apollyon", flChaseDurationAddVisMaxNightmare);

	g_hStatueProfileData.Set(iUniqueProfileIndex, flChaseDuration, StatueProfileData_ChaseDurationNormal);
	g_hStatueProfileData.Set(iUniqueProfileIndex, flChaseDurationEasy, StatueProfileData_ChaseDurationEasy);
	g_hStatueProfileData.Set(iUniqueProfileIndex, flChaseDurationHard, StatueProfileData_ChaseDurationHard);
	g_hStatueProfileData.Set(iUniqueProfileIndex, flChaseDurationInsane, StatueProfileData_ChaseDurationInsane);
	g_hStatueProfileData.Set(iUniqueProfileIndex, flChaseDurationNightmare, StatueProfileData_ChaseDurationNightmare);
	g_hStatueProfileData.Set(iUniqueProfileIndex, flChaseDurationApollyon, StatueProfileData_ChaseDurationApollyon);

	g_hStatueProfileData.Set(iUniqueProfileIndex, flChaseDurationAddVisMin, StatueProfileData_ChaseDurationAddVisibilityMinNormal);
	g_hStatueProfileData.Set(iUniqueProfileIndex, flChaseDurationAddVisMinEasy, StatueProfileData_ChaseDurationAddVisibilityMinEasy);
	g_hStatueProfileData.Set(iUniqueProfileIndex, flChaseDurationAddVisMinHard, StatueProfileData_ChaseDurationAddVisibilityMinHard);
	g_hStatueProfileData.Set(iUniqueProfileIndex, flChaseDurationAddVisMinInsane, StatueProfileData_ChaseDurationAddVisibilityMinInsane);
	g_hStatueProfileData.Set(iUniqueProfileIndex, flChaseDurationAddVisMinNightmare, StatueProfileData_ChaseDurationAddVisibilityMinNightmare);
	g_hStatueProfileData.Set(iUniqueProfileIndex, flChaseDurationAddVisMinApollyon, StatueProfileData_ChaseDurationAddVisibilityMinApollyon);

	g_hStatueProfileData.Set(iUniqueProfileIndex, flChaseDurationAddVisMax, StatueProfileData_ChaseDurationAddVisibilityMaxNormal);
	g_hStatueProfileData.Set(iUniqueProfileIndex, flChaseDurationAddVisMaxEasy, StatueProfileData_ChaseDurationAddVisibilityMaxEasy);
	g_hStatueProfileData.Set(iUniqueProfileIndex, flChaseDurationAddVisMaxHard, StatueProfileData_ChaseDurationAddVisibilityMaxHard);
	g_hStatueProfileData.Set(iUniqueProfileIndex, flChaseDurationAddVisMaxInsane, StatueProfileData_ChaseDurationAddVisibilityMaxInsane);
	g_hStatueProfileData.Set(iUniqueProfileIndex, flChaseDurationAddVisMaxNightmare, StatueProfileData_ChaseDurationAddVisibilityMaxNightmare);
	g_hStatueProfileData.Set(iUniqueProfileIndex, flChaseDurationAddVisMaxApollyon, StatueProfileData_ChaseDurationAddVisibilityMaxApollyon);

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
		return GetStatueBossProfileChaseDuration(this.UniqueProfileIndex, difficulty);
	}

	public float GetChaseDurationAddVisibilityMin(int difficulty)
	{
		return GetStatueBossProfileAddChaseDurationMin(this.UniqueProfileIndex, difficulty);
	}

	public float GetChaseDurationAddVisibilityMax(int difficulty)
	{
		return GetStatueBossProfileAddChaseDurationMax(this.UniqueProfileIndex, difficulty);
	}
}

float GetStatueBossProfileChaseDuration(int iStatueProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hStatueProfileData.Get(iStatueProfileIndex, StatueProfileData_ChaseDurationEasy);
		case Difficulty_Hard: return g_hStatueProfileData.Get(iStatueProfileIndex, StatueProfileData_ChaseDurationHard);
		case Difficulty_Insane: return g_hStatueProfileData.Get(iStatueProfileIndex, StatueProfileData_ChaseDurationInsane);
		case Difficulty_Nightmare: return g_hStatueProfileData.Get(iStatueProfileIndex, StatueProfileData_ChaseDurationNightmare);
		case Difficulty_Apollyon: return g_hStatueProfileData.Get(iStatueProfileIndex, StatueProfileData_ChaseDurationApollyon);
	}

	return g_hStatueProfileData.Get(iStatueProfileIndex, StatueProfileData_ChaseDurationNormal);
}

float GetStatueBossProfileAddChaseDurationMin(int iStatueProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hStatueProfileData.Get(iStatueProfileIndex, StatueProfileData_ChaseDurationAddVisibilityMinEasy);
		case Difficulty_Hard: return g_hStatueProfileData.Get(iStatueProfileIndex, StatueProfileData_ChaseDurationAddVisibilityMinHard);
		case Difficulty_Insane: return g_hStatueProfileData.Get(iStatueProfileIndex, StatueProfileData_ChaseDurationAddVisibilityMinInsane);
		case Difficulty_Nightmare: return g_hStatueProfileData.Get(iStatueProfileIndex, StatueProfileData_ChaseDurationAddVisibilityMinNightmare);
		case Difficulty_Apollyon: return g_hStatueProfileData.Get(iStatueProfileIndex, StatueProfileData_ChaseDurationAddVisibilityMinApollyon);
	}

	return g_hStatueProfileData.Get(iStatueProfileIndex, StatueProfileData_ChaseDurationAddVisibilityMinNormal);
}

float GetStatueBossProfileAddChaseDurationMax(int iStatueProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hStatueProfileData.Get(iStatueProfileIndex, StatueProfileData_ChaseDurationAddVisibilityMaxEasy);
		case Difficulty_Hard: return g_hStatueProfileData.Get(iStatueProfileIndex, StatueProfileData_ChaseDurationAddVisibilityMaxHard);
		case Difficulty_Insane: return g_hStatueProfileData.Get(iStatueProfileIndex, StatueProfileData_ChaseDurationAddVisibilityMaxInsane);
		case Difficulty_Nightmare: return g_hStatueProfileData.Get(iStatueProfileIndex, StatueProfileData_ChaseDurationAddVisibilityMaxNightmare);
		case Difficulty_Apollyon: return g_hStatueProfileData.Get(iStatueProfileIndex, StatueProfileData_ChaseDurationAddVisibilityMaxApollyon);
	}

	return g_hStatueProfileData.Get(iStatueProfileIndex, StatueProfileData_ChaseDurationAddVisibilityMaxNormal);
}