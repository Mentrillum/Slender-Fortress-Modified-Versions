#pragma semicolon 1
#pragma newdecls required

void InitializePostureWithinRange()
{
	g_OnChaserUpdatePosturePFwd.AddFunction(null, OnChaserUpdatePosture);
}

static Action OnChaserUpdatePosture(SF2NPC_Chaser controller, char[] buffer, int bufferSize, SF2ChaserBossProfilePostureInfo posture)
{
	float gameTime = GetGameTime();
	int difficulty = controller.Difficulty;

	SF2PostureConditionWithinRangeInfo rangeInfo;
	rangeInfo = posture.RangeInfo;
	if (!rangeInfo.Enabled[difficulty])
	{
		return Plugin_Continue;
	}

	if (rangeInfo.CurrentCooldown > gameTime)
	{
		return Plugin_Continue;
	}

	SF2_ChaserEntity chaser = SF2_ChaserEntity(controller.EntIndex);
	if (!chaser.IsValid() || chaser.State != STATE_CHASE)
	{
		return Plugin_Continue;
	}

	if (chaser.MyNextBotPointer().GetLocomotionInterface().GetGroundSpeed() < 0.01)
	{
		return Plugin_Continue;
	}

	CBaseEntity target = chaser.Target;
	if (!target.IsValid())
	{
		return Plugin_Continue;
	}

	float range = controller.Path.GetLength() - controller.Path.GetCursorPosition();

	if (range > rangeInfo.MinRange[difficulty] && range < rangeInfo.MaxRange[difficulty])
	{
		strcopy(buffer, bufferSize, posture.Name);
		return Plugin_Changed;
	}
	else
	{
		rangeInfo.CurrentCooldown = gameTime + rangeInfo.Cooldown[difficulty];
	}

	return Plugin_Continue;
}