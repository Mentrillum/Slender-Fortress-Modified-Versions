#pragma semicolon 1
#pragma newdecls required

void InitializePostureWithinBounds()
{
	g_OnChaserUpdatePosturePFwd.AddFunction(null, OnChaserUpdatePosture);
}

static Action OnChaserUpdatePosture(SF2NPC_Chaser controller, char[] buffer, int bufferSize, SF2ChaserBossProfilePostureInfo posture)
{
	SF2PostureConditionWithinBoundsInfo boundsInfo;
	boundsInfo = posture.BoundsInfo;
	if (!boundsInfo.Enabled)
	{
		return Plugin_Continue;
	}

	SF2_ChaserEntity chaser = SF2_ChaserEntity(controller.EntIndex);
	if (!chaser.IsValid())
	{
		return Plugin_Continue;
	}
	float myPos[3];
	chaser.GetAbsOrigin(myPos);
	if (IsSpaceOccupiedIgnorePlayersAndNPCs(myPos, boundsInfo.Mins, boundsInfo.Maxs, chaser.index, _, false))
	{
		strcopy(buffer, bufferSize, posture.Name);
		return Plugin_Changed;
	}

	return Plugin_Continue;
}