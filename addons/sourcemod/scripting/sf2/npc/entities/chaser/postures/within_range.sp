#pragma semicolon 1
#pragma newdecls required

methodmap ChaserBossPostureCondition_WithinRange < ChaserBossPostureCondition
{
	public float GetMinRange(int difficulty)
	{
		return this.GetDifficultyFloat("min_range", difficulty, 0.0);
	}

	public float GetMaxRange(int difficulty)
	{
		return this.GetDifficultyFloat("max_range", difficulty, 512.0);
	}

	public float GetCooldown(int difficulty)
	{
		return this.GetDifficultyFloat("cooldown", difficulty, 1.0);
	}

	property float CurrentCooldown
	{
		public get()
		{
			float value = 0.0;
			this.GetValue("__current_cooldown", value);
			return value;
		}

		public set(float value)
		{
			this.SetValue("__current_cooldown", value);
		}
	}
}

void InitializePostureWithinRange()
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
	float gameTime = GetGameTime();

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
			if (strcmp(name, "within_range") != 0)
			{
				continue;
			}

			ChaserBossPostureCondition_WithinRange condition = view_as<ChaserBossPostureCondition_WithinRange>(conditions.GetSection(name));
			if (condition == null || !condition.GetEnabled(difficulty))
			{
				continue;
			}

			if (condition.CurrentCooldown > gameTime)
			{
				continue;
			}

			if (chaser.State != STATE_CHASE)
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

			if (range > condition.GetMinRange(difficulty) && range < condition.GetMaxRange(difficulty))
			{
				posture.GetSectionName(name, sizeof(name));
				strcopy(buffer, bufferSize, name);
				return Plugin_Changed;
			}
			else
			{
				condition.CurrentCooldown = gameTime + condition.GetCooldown(difficulty);
			}
		}
	}

	return Plugin_Continue;
}