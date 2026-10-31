#pragma semicolon 1
#pragma newdecls required

void InitializePostureRunningAway()
{
	g_OnChaserUpdatePosturePFwd.AddFunction(null, OnChaserUpdatePosture);
}

static Action OnChaserUpdatePosture(SF2NPC_Chaser controller, char[] buffer, int bufferSize, SF2ChaserBossProfilePostureInfo posture)
{
	SF2PostureConditionRunAwayInfo runAwayInfo;
	runAwayInfo = posture.RunAwayInfo;
	if (!runAwayInfo.Enabled)
	{
		return Plugin_Continue;
	}

	SF2_ChaserEntity chaser = SF2_ChaserEntity(controller.EntIndex);
	if (chaser.IsValid() && chaser.IsRunningAway)
	{
		strcopy(buffer, bufferSize, posture.Name);
		return Plugin_Changed;
	}

	return Plugin_Continue;
}