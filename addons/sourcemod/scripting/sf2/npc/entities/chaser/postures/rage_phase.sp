#pragma semicolon 1
#pragma newdecls required

void InitializePostureRagePhase()
{
	g_OnChaserUpdatePosturePFwd.AddFunction(null, OnChaserUpdatePosture);
}

static Action OnChaserUpdatePosture(SF2NPC_Chaser controller, char[] buffer, int bufferSize, SF2ChaserBossProfilePostureInfo posture)
{
	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	SF2PostureConditionRagePhase ragePhaseInfo;
	ragePhaseInfo = posture.RagePhaseInfo;
	if (!ragePhaseInfo.Enabled)
	{
		return Plugin_Continue;
	}

	SF2_ChaserEntity chaser = SF2_ChaserEntity(controller.EntIndex);
	if (!chaser.IsValid() || chaser.RageIndex == -1)
	{
		return Plugin_Continue;
	}

	SF2ChaserRageInfo rageInfo;
	data.Rages.GetArray(chaser.RageIndex, rageInfo, sizeof(rageInfo));
	int index = ragePhaseInfo.Names.FindString(rageInfo.Name);

	if (index != -1)
	{
		strcopy(buffer, bufferSize, posture.Name);
		return Plugin_Changed;
	}

	return Plugin_Continue;
}