#pragma semicolon 1

void InitializePostureWithinRange()
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

	float gameTime = GetGameTime();

	SF2ChaserBossProfilePostureInfo postureInfo;
	StringMapSnapshot snapshot = postures.Snapshot();
	for (int i = 0; i < snapshot.Length; i++)
	{
		if (!data.GetPostureFromIndex(i, postureInfo))
		{
			continue;
		}

		int difficulty = controller.Difficulty;

		SF2PostureConditionWithinRangeInfo rangeInfo;
		rangeInfo = postureInfo.RangeInfo;
		if (!rangeInfo.Enabled[difficulty])
		{
			continue;
		}

		if (rangeInfo.CurrentCooldown > gameTime)
		{
			continue;
		}

		SF2_ChaserEntity chaser = SF2_ChaserEntity(controller.EntIndex);
		if (!chaser.IsValid() || chaser.State != STATE_CHASE)
		{
			continue;
		}

		if (chaser.MyNextBotPointer().GetLocomotionInterface().GetGroundSpeed() < 0.01)
		{
			continue;
		}

		CBaseEntity target = chaser.Target;
		if (!target.IsValid())
		{
			continue;
		}

		float range = controller.Path.GetLength() - controller.Path.GetCursorPosition();

		if (range > rangeInfo.MinRange[difficulty] && range < rangeInfo.MaxRange[difficulty])
		{
			strcopy(buffer, bufferSize, postureInfo.Name);
			delete snapshot;
			return Plugin_Changed;
		}
		else
		{
			rangeInfo.CurrentCooldown = gameTime + rangeInfo.Cooldown[difficulty];
		}
	}

	delete snapshot;
	return Plugin_Continue;
}