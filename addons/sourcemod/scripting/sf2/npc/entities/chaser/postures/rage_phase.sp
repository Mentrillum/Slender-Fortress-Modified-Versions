#pragma semicolon 1
#pragma newdecls required

methodmap ChaserBossPostureCondition_RagePhase < ChaserBossPostureCondition
{
	public bool IsPhaseValid(const char[] buffer)
	{
		char phases[1024];
		this.GetString("phases", phases, sizeof(phases));
		char phase[64][64];
		int maxLength = ExplodeString(phases, " ", phase, sizeof(phase), sizeof(phase));
		for (int i = 0; i < maxLength; i++)
		{
			if (strcmp(buffer, phase[i]) == 0)
			{
				return true;
			}
		}
		return false;
	}
}

void InitializePostureRagePhase()
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
			if (strcmp(name, "in_phases") != 0)
			{
				continue;
			}

			ChaserBossPostureCondition_RagePhase condition = view_as<ChaserBossPostureCondition_RagePhase>(conditions.GetSection(name));
			if (condition == null || !condition.GetEnabled(difficulty))
			{
				continue;
			}

			if (chaser.RageIndex == -1)
			{
				continue;
			}

			data.GetRages().GetSectionNameFromIndex(chaser.RageIndex, name, sizeof(name));
			if (condition.IsPhaseValid(name))
			{
				posture.GetSectionName(name, sizeof(name));
				strcopy(buffer, bufferSize, name);
				return Plugin_Changed;
			}
		}
	}

	return Plugin_Continue;
}