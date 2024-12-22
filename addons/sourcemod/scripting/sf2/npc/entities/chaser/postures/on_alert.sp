#pragma semicolon 1
#pragma newdecls required

void InitializePostureOnAlert()
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
			if (strcmp(name, "on_alert") != 0)
			{
				continue;
			}

			ChaserBossPostureCondition condition = view_as<ChaserBossPostureCondition>(conditions.GetSection(name));
			if (condition == null || !condition.GetEnabled(difficulty))
			{
				continue;
			}

			if (chaser.State == STATE_ALERT)
			{
				posture.GetSectionName(name, sizeof(name));
				strcopy(buffer, bufferSize, name);
				return Plugin_Changed;
			}
		}
	}

	return Plugin_Continue;
}