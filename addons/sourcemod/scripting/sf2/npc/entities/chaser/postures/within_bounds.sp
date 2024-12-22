#pragma semicolon 1
#pragma newdecls required

methodmap ChaserBossPostureCondition_WithinBounds < ChaserBossPostureCondition
{
	public void GetMins(int difficulty, float buffer[3])
	{
		this.GetDifficultyVector("mins", difficulty, buffer);
	}

	public void GetMaxs(int difficulty, float buffer[3])
	{
		this.GetDifficultyVector("maxs", difficulty, buffer);
	}
}

void InitializePostureWithinBounds()
{
	g_OnChaserUpdatePosturePFwd.AddFunction(null, OnChaserUpdatePosture);
}

static Action OnChaserUpdatePosture(SF2NPC_Chaser controller, char[] buffer, int bufferSize)
{
	SF2_ChaserEntity chaser = SF2_ChaserEntity(controller.EntIndex);
	if (!chaser.IsValid())
	{
		return Plugin_Continue;
	}

	int difficulty = controller.Difficulty;

	ChaserBossProfile data = controller.GetProfileDataEx();
	ProfileObject obj = data.GetSection("postures");
	if (obj == null)
	{
		return Plugin_Continue;
	}

	for (int i = 0; i < obj.SectionLength; i++)
	{
		ProfileObject posture = data.GetPostureFromIndex(i);
		if (posture == null)
		{
			continue;
		}

		ProfileObject conditions = posture.GetSection("conditions");
		if (conditions == null || conditions.SectionLength == 0)
		{
			continue;
		}

		for (int j = 0; j < conditions.SectionLength; j++)
		{
			char name[64];
			conditions.GetSectionNameFromIndex(j, name, sizeof(name));
			if (strcmp(name, "within_bounds") != 0)
			{
				continue;
			}

			ChaserBossPostureCondition_WithinBounds condition = view_as<ChaserBossPostureCondition_WithinBounds>(conditions.GetSection(name));
			if (condition == null || !condition.GetEnabled(difficulty))
			{
				continue;
			}

			float mins[3], maxs[3], myPos[3];
			condition.GetMins(difficulty, mins);
			condition.GetMaxs(difficulty, maxs);
			chaser.GetAbsOrigin(myPos);
			if (IsSpaceOccupiedIgnorePlayersAndEnts(myPos, mins, maxs, chaser.index))
			{
				posture.GetSectionName(name, sizeof(name));
				strcopy(buffer, bufferSize, name);
				return Plugin_Changed;
			}
		}
	}

	return Plugin_Continue;
}