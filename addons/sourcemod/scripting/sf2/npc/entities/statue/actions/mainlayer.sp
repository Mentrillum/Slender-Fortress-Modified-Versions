#pragma semicolon 1
#pragma newdecls required

static NextBotActionFactory g_Factory;

methodmap SF2_StatueBaseAction < NextBotAction
{
	public SF2_StatueBaseAction()
	{
		return view_as<SF2_StatueBaseAction>(g_Factory.Create());
	}

	public static NextBotActionFactory GetFactory()
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Statue_Main");
			g_Factory.SetCallback(NextBotActionCallbackType_InitialContainedAction, InitialContainedAction);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.BeginDataMapDesc()
				.DefineFloatField("m_LastStuckTime")
				.DefineVectorField("m_LastPos")
				.DefineVectorField("m_UnstuckPos")
				.EndDataMapDesc();
		}
		return g_Factory;
	}

	property float LastStuckTime
	{
		public get()
		{
			return this.GetDataFloat("m_LastStuckTime");
		}

		public set(float value)
		{
			this.SetDataFloat("m_LastStuckTime", value);
		}
	}

	public void GetLastPos(float pos[3])
	{
		this.GetDataVector("m_LastPos", pos);
	}

	public void SetLastPos(const float pos[3])
	{
		this.SetDataVector("m_LastPos", pos);
	}

	public void GetUnstuckPos(float pos[3])
	{
		this.GetDataVector("m_UnstuckPos", pos);
	}

	public void SetUnstuckPos(const float pos[3])
	{
		this.SetDataVector("m_UnstuckPos", pos);
	}
}

static NextBotAction InitialContainedAction(SF2_StatueBaseAction action, SF2_StatueEntity actor)
{
	return SF2_StatueIdleAction();
}

static int Update(SF2_StatueBaseAction action, SF2_StatueEntity actor, float interval)
{
	SF2NPC_Statue controller = actor.Controller;
	if (controller.IsValid() && (controller.Flags & SFF_MARKEDASFAKE) != 0)
	{
		return action.Done("I'm a faker");
	}

	StatueBossProfile data = controller.GetProfileData();
	CBaseEntity target = actor.Target;
	float myPos[3];
	actor.GetAbsOrigin(myPos);
	int difficulty = controller.Difficulty;
	float gameTime = GetGameTime();

	if (actor.LastKillTime > GetGameTime())
	{
		actor.IsMoving = false;
	}

	if (actor.IsMoving)
	{
		if (actor.NextMoveTime <= gameTime)
		{
			data.GetSingleMoveSounds().EmitSound(_, actor.index, .difficulty = difficulty);
			actor.NextMoveTime = gameTime + GetRandomFloat(data.GetSingleMoveSounds().GetCooldownMin(difficulty), data.GetSingleMoveSounds().GetCooldownMax(difficulty));
		}

		data.GetMoveSounds().EmitSound(_, actor.index, .difficulty = difficulty);

		if (target.IsValid())
		{
			float targetPos[3];
			target.GetAbsOrigin(targetPos);

			float distance = GetVectorSquareMagnitude(targetPos, myPos);
			float maxRange = Pow(data.GetMaxModelChangeDistance(difficulty), 2.0);
			char model[PLATFORM_MAX_PATH];
			if (distance < maxRange * 0.33)
			{
				data.GetCloseDistanceModel(difficulty, model, sizeof(model));
			}
			else if (distance < maxRange * 0.66)
			{
				data.GetAverageDistanceModel(difficulty, model, sizeof(model));
			}
			else
			{
				data.GetModel(difficulty, model, sizeof(model));
			}

			if (model[0] == '\0' || strcmp(model, "models/") == 0)
			{
				data.GetModel(difficulty, model, sizeof(model));
			}

			actor.SetModel(model);
		}
	}
	else
	{
		data.GetMoveSounds().StopAllSounds(actor.index, difficulty);
	}

	if (actor.IsKillingSomeone)
	{
		return action.SuspendFor(SF2_DeathCamAction());
	}

	UnstuckCheck(action, actor);

	return action.Continue();
}

static void UnstuckCheck(SF2_StatueBaseAction action, SF2_StatueEntity actor)
{
	INextBot bot = actor.MyNextBotPointer();
	ILocomotion loco = bot.GetLocomotionInterface();
	SF2NPC_Statue controller = actor.Controller;
	PathFollower path = controller.Path;
	float gameTime = GetGameTime();

	if (!path.IsValid() || !actor.IsMoving || loco.GetDesiredSpeed() <= 0.0)
	{
		action.LastStuckTime = gameTime;
		return;
	}

	float lastPos[3], myPos[3];
	action.GetLastPos(lastPos);
	actor.GetAbsOrigin(myPos);

	if (bot.IsRangeLessThanEx(lastPos, 0.13) || loco.GetGroundSpeed() <= 0.1)
	{
		if (action.LastStuckTime > gameTime - 0.75)
		{
			return;
		}
		float destination[3];
		if (!NPCFindUnstuckPosition(actor, lastPos, destination))
		{
			controller.UnSpawn(true);
			return;
		}
		action.LastStuckTime = gameTime + 0.75;
		actor.Teleport(destination, NULL_VECTOR, NULL_VECTOR);
	}
	else
	{
		loco.GetFeet(lastPos);
		action.SetLastPos(lastPos);
		action.LastStuckTime += 0.03;
		if (action.LastStuckTime > gameTime)
		{
			action.LastStuckTime = gameTime;
		}
	}
}
