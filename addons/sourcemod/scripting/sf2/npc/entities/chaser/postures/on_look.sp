#pragma semicolon 1
#pragma newdecls required

void InitializePostureOnLook()
{
	g_OnChaserUpdatePosturePFwd.AddFunction(null, OnChaserUpdatePosture);
}

static Action OnChaserUpdatePosture(SF2NPC_Chaser controller, char[] buffer, int bufferSize, SF2ChaserBossProfilePostureInfo posture)
{
	int difficulty = controller.Difficulty;

	SF2PostureConditionLookAtInfo lookAtInfo;
	lookAtInfo = posture.LookAtInfo;
	if (!lookAtInfo.Enabled[difficulty])
	{
		return Plugin_Continue;
	}

	if (controller.CanBeSeen(_, true))
	{
		strcopy(buffer, bufferSize, posture.Name);
		return Plugin_Changed;
	}

	return Plugin_Continue;
}