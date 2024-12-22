#if defined _sf2_npc_creeper_included
#endinput
#endif
#define _sf2_npc_creeper_included

#pragma semicolon 1
#pragma newdecls required

void NPCStatueOnSelectProfile(int npcIndex)
{
	SF2NPC_Statue statue = SF2NPC_Statue(npcIndex);

	statue.SetAffectedBySight(true);
}

SF2_StatueEntity Spawn_Statue(SF2NPC_BaseNPC controller, const float pos[3], const float ang[3])
{
	g_SlenderStatueIdleLifeTime[controller.Index] = GetGameTime() + view_as<SF2NPC_Statue>(controller).GetProfileDataEx().GetIdleLifeTime(controller.Difficulty);
	return SF2_StatueEntity.Create(controller, pos, ang);
}

void Despawn_Statue(SF2NPC_Statue controller, CBaseEntity bossEnt)
{
	StatueBossProfile data = controller.GetProfileDataEx();
	// Stop all possible looping sounds.
	for (int i = 0; i < Difficulty_Max; i++)
	{
		data.GetMoveSounds().StopAllSounds(bossEnt.index, i);
	}
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

	return controller.GetProfileDataEx();
}

static any Native_GetProfileDataEx(Handle plugin, int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, sizeof(profile));
	return view_as<StatueBossProfile>(GetBossProfile(profile));
}
