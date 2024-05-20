#pragma semicolon 1

void InitializePostureOnCloak()
{
	g_OnChaserUpdatePosturePFwd.AddFunction(null, OnChaserUpdatePosture);
}

static Action OnChaserUpdatePosture(SF2NPC_Chaser controller, char[] buffer, int bufferSize)
{
	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	StringMap postures = data.Postures;
	if (postures == null)
	{
		return Plugin_Continue;
	}

	SF2ChaserBossProfilePostureInfo postureInfo;
	StringMapSnapshot snapshot = postures.Snapshot();
	for (int i = 0; i < snapshot.Length; i++)
	{
		if (!data.GetPostureFromIndex(i, postureInfo))
		{
			continue;
		}

		int difficulty = controller.Difficulty;

		SF2PostureConditionCloakInfo cloakInfo;
		cloakInfo = postureInfo.CloakInfo;
		if (!cloakInfo.Enabled[difficulty])
		{
			continue;
		}

		SF2_ChaserEntity chaser = SF2_ChaserEntity(controller.EntIndex);
		if (chaser.IsValid() && chaser.HasCloaked)
		{
			strcopy(buffer, bufferSize, postureInfo.Name);
			delete snapshot;
			return Plugin_Changed;
		}
	}

	delete snapshot;
	return Plugin_Continue;
}