#pragma semicolon 1
#pragma newdecls required

void InitializePostureOnAlert()
{
	g_OnChaserUpdatePosturePFwd.AddFunction(null, OnChaserUpdatePosture);
}

static Action OnChaserUpdatePosture(SF2NPC_Chaser controller, char[] buffer, int bufferSize, SF2ChaserBossProfilePostureInfo posture)
{
	int difficulty = controller.Difficulty;

	SF2PostureConditionAlertInfo alertInfo;
	alertInfo = posture.AlertInfo;
	if (!alertInfo.Enabled[difficulty])
	{
		return Plugin_Continue;
	}

	SF2_ChaserEntity chaser = SF2_ChaserEntity(controller.EntIndex);
	if (chaser.IsValid() && chaser.State == STATE_ALERT)
	{
		strcopy(buffer, bufferSize, posture.Name);
		return Plugin_Changed;
	}

	return Plugin_Continue;
}