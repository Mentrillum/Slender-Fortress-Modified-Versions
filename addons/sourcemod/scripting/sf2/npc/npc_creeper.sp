#if defined _sf2_npc_creeper_included
#endinput
#endif
#define _sf2_npc_creeper_included

#pragma semicolon 1

static float g_NpcStatueIdleLifetime[MAX_BOSSES][Difficulty_Max];
static SF2StatueBossProfileData g_StatueProfileData[MAX_BOSSES];

SF2StatueBossProfileData NPCStatueGetProfileData(int npcIndex)
{
	return g_StatueProfileData[npcIndex];
}

void NPCStatueSetProfileData(int npcIndex, SF2StatueBossProfileData value)
{
	g_StatueProfileData[npcIndex] = value;
}

float NPCStatueGetIdleLifetime(int npcIndex, int difficulty)
{
	return g_NpcStatueIdleLifetime[npcIndex][difficulty];
}

void NPCStatueOnSelectProfile(int npcIndex)
{
	SF2NPC_Statue statue = SF2NPC_Statue(npcIndex);
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(npcIndex, profile, sizeof(profile));
	g_StatueBossProfileData.GetArray(profile, g_StatueProfileData[npcIndex], sizeof(g_StatueProfileData[]));
	for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
	{
		g_NpcStatueIdleLifetime[npcIndex][difficulty] = g_StatueProfileData[npcIndex].IdleLifeTime[difficulty];
	}

	statue.SetAffectedBySight(true);
}

SF2_StatueEntity Spawn_Statue(SF2NPC_BaseNPC controller, const float pos[3], const float ang[3])
{
	g_SlenderStatueIdleLifeTime[controller.Index] = GetGameTime() + g_NpcStatueIdleLifetime[controller.Index][controller.Difficulty];
	return SF2_StatueEntity.Create(controller, pos, ang);
}

void Despawn_Statue(SF2NPC_Statue controller, CBaseEntity bossEnt)
{
	SF2StatueBossProfileData data;
	data = controller.GetProfileData();
	// Stop all possible looping sounds.
	SF2BossProfileSoundInfo soundInfo;
	soundInfo = data.MoveSounds;
	soundInfo.StopAllSounds(bossEnt.index);
}

void NPCStatue_InitializeAPI()
{
	CreateNative("SF2_GetStatueProfileFromBossIndex", Native_GetProfileData);
	CreateNative("SF2_GetStatueProfileFromName", Native_GetProfileDataEx);

	SF2_StatueEntity.SetupAPI();
}

static any Native_GetProfileData(Handle plugin, int numParams)
{
	SF2NPC_Statue controller = SF2NPC_Statue(GetNativeCell(1));
	if (!controller.IsValid())
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid boss index %d", controller.Index);
	}

	SF2StatueBossProfileData data;
	data = controller.GetProfileData();
	SetNativeArray(2, data, sizeof(data));
	return 0;
}

static any Native_GetProfileDataEx(Handle plugin, int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, sizeof(profile));
	SF2StatueBossProfileData data;
	if (!g_StatueBossProfileData.GetArray(profile, data, sizeof(data)))
	{
		return false;
	}

	SetNativeArray(2, data, sizeof(data));
	return true;
}
