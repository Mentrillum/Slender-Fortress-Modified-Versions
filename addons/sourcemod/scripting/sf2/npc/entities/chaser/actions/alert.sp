#pragma semicolon 1

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserAlertAction < NextBotAction
{
	public SF2_ChaserAlertAction(const float pos[3] = NULL_VECTOR, bool shouldRun = false)
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_Alert");
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetCallback(NextBotActionCallbackType_OnSuspend, OnSuspend);
			g_Factory.SetCallback(NextBotActionCallbackType_OnEnd, OnEnd);
			g_Factory.SetCallback(NextBotActionCallbackType_OnResume, OnResume);
			g_Factory.SetEventCallback(EventResponderType_OnMoveToSuccess, OnMoveToSuccess);
			g_Factory.SetEventCallback(EventResponderType_OnMoveToFailure, OnMoveToFailure);
			g_Factory.BeginDataMapDesc()
				.DefineBoolField("m_InitialState")
				.DefineFloatField("m_EndTime")
				.DefineBoolField("m_IsGoalPosSet")
				.DefineVectorField("m_GoalPos")
				.DefineFloatField("m_NextWanderTime")
				.DefineFloatField("m_NextTurnTime")
				.DefineVectorField("m_LookPos")
				.DefineBoolField("m_HasReachedAlertPosition")
				.DefineFloatField("m_TimeUntilChase")
				.DefineBoolField("m_IsRunning")
				.EndDataMapDesc();
		}

		SF2_ChaserAlertAction action = view_as<SF2_ChaserAlertAction>(g_Factory.Create());

		if (!IsNullVector(pos))
		{
			action.SetGoalPosition(pos);
		}

		action.HasReachedAlertPosition = false;
		action.IsRunning = shouldRun;

		return action;
	}

	property bool InitialState
	{
		public get()
		{
			return this.GetData("m_InitialState");
		}

		public set(bool value)
		{
			this.SetData("m_InitialState", value);
		}
	}

	property float EndTime
	{
		public get()
		{
			return this.GetDataFloat("m_EndTime");
		}

		public set(float value)
		{
			this.SetDataFloat("m_EndTime", value);
		}
	}

	property bool IsGoalPosSet
	{
		public get()
		{
			return this.GetData("m_IsGoalPosSet") != 0;
		}

		public set(bool value)
		{
			this.SetData("m_IsGoalPosSet", value);
		}
	}

	public void GetGoalPosition(float pos[3])
	{
		this.GetDataVector("m_GoalPos", pos);
	}

	public void SetGoalPosition(const float pos[3])
	{
		this.IsGoalPosSet = true;
		this.SetDataVector("m_GoalPos", pos);
	}

	property float NextWanderTime
	{
		public get()
		{
			return this.GetDataFloat("m_NextWanderTime");
		}

		public set(float value)
		{
			this.SetDataFloat("m_NextWanderTime", value);
		}
	}

	property float NextTurnTime
	{
		public get()
		{
			return this.GetDataFloat("m_NextTurnTime");
		}

		public set(float value)
		{
			this.SetDataFloat("m_NextTurnTime", value);
		}
	}

	public void GetLookPosition(float pos[3])
	{
		this.GetDataVector("m_LookPos", pos);
	}

	public void SetLookPosition(const float pos[3])
	{
		this.SetDataVector("m_LookPos", pos);
	}

	property bool HasReachedAlertPosition
	{
		public get()
		{
			return this.GetData("m_HasReachedAlertPosition") != 0;
		}

		public set(bool value)
		{
			this.SetData("m_HasReachedAlertPosition", value);
		}
	}

	property float TimeUntilChase
	{
		public get()
		{
			return this.GetDataFloat("m_TimeUntilChase");
		}

		public set(float value)
		{
			this.SetDataFloat("m_TimeUntilChase", value);
		}
	}

	property bool IsRunning
	{
		public get()
		{
			return this.GetData("m_IsRunning") != 0;
		}

		public set(bool value)
		{
			this.SetData("m_IsRunning", value);
		}
	}
}

static int OnStart(SF2_ChaserAlertAction action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	SF2NPC_Chaser controller = actor.Controller;
	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	int difficulty = controller.Difficulty;
	float gameTime = GetGameTime();
	if (!action.IsRunning)
	{
		actor.MovementType = SF2NPCMoveType_Walk;
	}
	else
	{
		actor.MovementType = SF2NPCMoveType_Run;
	}

	action.EndTime = gameTime + data.AlertData.Duration[difficulty];
	action.TimeUntilChase = gameTime + data.AlertData.GraceTime[difficulty];
	action.InitialState = true;

	if (data.AlertOnAlertInfo.OnChangeState[difficulty])
	{
		actor.ForceAlertOtherBosses();
	}

	actor.UpdateMovementAnimation();

	float goalPos[3];
	if (action.IsGoalPosSet)
	{
		action.GetGoalPosition(goalPos);
	}
	else
	{
		actor.GetAbsOrigin(goalPos);
	}

	UpdateAlertPosition(action, actor, goalPos, action.IsRunning);

	actor.AlertWithBoss = false;

	return action.Continue();
}

static int Update(SF2_ChaserAlertAction action, SF2_ChaserEntity actor, float interval)
{
	SF2NPC_Chaser controller = actor.Controller;
	if (!controller.IsValid())
	{
		return action.Continue();
	}

	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	SF2BossProfileData originalData;
	originalData = view_as<SF2NPC_BaseNPC>(controller).GetProfileData();

	if (!originalData.IsPvEBoss && IsBeatBoxBeating(2))
	{
		return action.SuspendFor(SF2_ChaserBeatBoxFreezeAction(actor.IsAttemptingToMove));
	}
	INextBot bot = actor.MyNextBotPointer();
	ILocomotion loco = bot.GetLocomotionInterface();
	int difficulty = controller.Difficulty;
	float gameTime = GetGameTime();
	CBaseEntity target = actor.Target;
	int interruptConditions = actor.InterruptConditions;

	PathFollower path = controller.Path;

	if (data.ChaseOnLookData.Enabled[difficulty] && controller.ChaseOnLookTargets.Length > 0)
	{
		SF2_BasePlayer lookTarget = controller.ChaseOnLookTargets.Get(0);
		if (lookTarget.IsValid && !lookTarget.IsEliminated && lookTarget.IsAlive && !lookTarget.IsInGhostMode && !lookTarget.HasEscaped)
		{
			actor.Target = lookTarget;
			actor.State = STATE_CHASE;
			path.Invalidate();
			if (data.NormalSoundHook)
			{
				actor.NextVoiceTime = 0.0;
			}
			return action.ChangeTo(SF2_ChaserChaseAction(), "Someone has looked at me, GET THEM!");
		}
	}

	if (gameTime >= action.EndTime)
	{
		actor.State = STATE_IDLE;
		path.Invalidate();
		if (data.NormalSoundHook)
		{
			actor.NextVoiceTime = 0.0;
		}
		if (actor.FollowedCompanionAlert && actor.Controller.IsValid())
		{
			actor.FollowCooldownAlert = GetGameTime() + data.AlertOnAlertInfo.FollowCooldown[difficulty];
			actor.FollowedCompanionAlert = false;
		}
		actor.AlertWithBoss = false;
		return action.ChangeTo(SF2_ChaserIdleAction(), "Huh nothing around here, back to idling.");
	}

	if (target.IsValid())
	{
		if ((interruptConditions & COND_ENEMYRECHASE) != 0)
		{
			actor.State = STATE_CHASE;
			path.Invalidate();
			if (data.NormalSoundHook)
			{
				actor.NextVoiceTime = 0.0;
			}
			return action.ChangeTo(SF2_ChaserChaseAction(), "Wait hold up, someone needs rechasing. GET THEM!");
		}
		else if ((interruptConditions & COND_ENEMYNEAR) != 0)
		{
			actor.State = STATE_CHASE;
			path.Invalidate();
			if (data.NormalSoundHook)
			{
				actor.NextVoiceTime = 0.0;
			}
			return action.ChangeTo(SF2_ChaserChaseAction(), "Someone is too close, get them!");
		}
	}

	if (target.IsValid() && ((interruptConditions & COND_SAWENEMY) != 0))
	{
		if (gameTime >= action.TimeUntilChase)
		{
			path.Invalidate();
			actor.State = STATE_CHASE;
			if (data.NormalSoundHook)
			{
				actor.NextVoiceTime = 0.0;
			}
			return action.ChangeTo(SF2_ChaserChaseAction(), "I've got a target, get them!");
		}
	}
	else if ((interruptConditions & COND_ALERT_TRIGGER) != 0)
	{
		SF2_BasePlayer alertTarget = actor.AlertTriggerTarget;
		if (alertTarget.IsValid && !alertTarget.IsEliminated && alertTarget.IsAlive && !alertTarget.HasEscaped)
		{
			float pos[3];
			actor.GetAlertTriggerPosition(alertTarget, pos);

			UpdateAlertPosition(action, actor, pos, data.AlertData.RunOnSuspect[difficulty]);
		}
	}
	else if ((interruptConditions & COND_ALERT_TRIGGER_POS) != 0 || actor.QueueForAlertState)
	{
		float pos[3];
		actor.GetAlertTriggerPositionEx(pos);

		UpdateAlertPosition(action, actor, pos, data.AlertData.RunOnSuspect[difficulty]);
		actor.QueueForAlertState = false;
	}

	if ((interruptConditions & COND_DEBUG) != 0)
	{
		float pos[3];
		actor.GetForceWanderPosition(pos);

		UpdateAlertPosition(action, actor, pos, data.AlertData.RunOnWander[difficulty]);
	}

	bool isAbleToWander = action.HasReachedAlertPosition && data.CanWander[difficulty];
	if (controller.HasAttribute(SF2Attribute_BlockWalkSpeedUnderDifficulty))
	{
		int value = RoundToNearest(controller.GetAttributeValue(SF2Attribute_BlockWalkSpeedUnderDifficulty));
		if (difficulty < value)
		{
			isAbleToWander = false;
		}
	}

	if (isAbleToWander)
	{
		if (gameTime >= action.NextWanderTime)
		{
			float min = data.WanderTimeMin[difficulty];
			float max = data.WanderTimeMax[difficulty];

			action.NextWanderTime = gameTime + GetRandomFloat(min, max);

			float rangeMin = data.WanderRangeMin[difficulty];
			float rangeMax = data.WanderRangeMax[difficulty];
			float range = GetRandomFloat(rangeMin, rangeMax);

			CNavArea area = actor.GetLastKnownArea();
			SurroundingAreasCollector collector = TheNavMesh.CollectSurroundingAreas(area, range);
			int areaCount = collector.Count();
			ArrayList areaArray = new ArrayList(1, areaCount);
			int validAreaCount = 0;
			for (int i = 0; i < areaCount; i++)
			{
				if (collector.Get(i).HasAttributes(NAV_MESH_CROUCH))
				{
					continue;
				}
				if (collector.Get(i).GetCostSoFar() < rangeMin)
				{
					continue;
				}
				areaArray.Set(validAreaCount, i);
				validAreaCount++;
			}

			if (validAreaCount > 0)
			{
				float wanderPos[3];
				CNavArea wanderArea = collector.Get(areaArray.Get(GetRandomInt(0, validAreaCount - 1)));

				if (wanderArea != NULL_AREA)
				{
					wanderArea.GetCenter(wanderPos);

					UpdateAlertPosition(action, actor, wanderPos, data.AlertData.RunOnWander[difficulty]);
				}
			}

			delete collector;
			delete areaArray;
		}
	}

	if (!path.IsValid())
	{
		loco.Stop();
		actor.IsAttemptingToMove = false;
	}
	else
	{
		path.Update(bot);
		actor.IsAttemptingToMove = true;
	}

	if (actor.IsAttemptingToMove)
	{
		action.NextTurnTime = -1.0;
	}
	else
	{
		if (data.AlertData.TurnEnabled[difficulty])
		{
			if (!action.InitialState)
			{
				float lookPos[3];
				action.GetLookPosition(lookPos);
				loco.FaceTowards(lookPos);
			}
			if (action.NextTurnTime <= 0.0)
			{
				action.NextTurnTime = gameTime + GetRandomFloat(data.AlertData.TurnMinTime[difficulty], data.AlertData.TurnMaxTime[difficulty]);
			}
		}
	}

	if (data.AlertData.TurnEnabled[difficulty] && action.NextTurnTime > 0.0 && action.NextTurnTime <= gameTime)
	{
		float myPos[3], myAng[3];
		actor.GetAbsOrigin(myPos);
		actor.GetAbsAngles(myAng);
		myAng[1] += GetRandomFloat(-data.AlertData.TurnAngle[difficulty], data.AlertData.TurnAngle[difficulty]);
		float lookAt[3];
		lookAt[0] = 50.0;
		VectorTransform(lookAt, myPos, myAng, lookAt);
		action.SetLookPosition(lookAt);
		action.NextTurnTime = gameTime + GetRandomFloat(data.AlertData.TurnMinTime[difficulty], data.AlertData.TurnMaxTime[difficulty]);
		action.InitialState = false;
	}

	if (gameTime >= actor.NextVoiceTime)
	{
		actor.PerformVoice(SF2BossSound_Alert);
	}

	return action.Continue();
}

static void UpdateAlertPosition(SF2_ChaserAlertAction action, SF2_ChaserEntity actor, const float newGoalPos[3], bool shouldRun)
{
	SF2NPC_Chaser controller = actor.Controller;
	int difficulty = controller.Difficulty;
	if (controller.HasAttribute(SF2Attribute_BlockWalkSpeedUnderDifficulty))
	{
		int value = RoundToNearest(controller.GetAttributeValue(SF2Attribute_BlockWalkSpeedUnderDifficulty));
		if (difficulty < value)
		{
			return;
		}
	}

	INextBot bot = actor.MyNextBotPointer();
	PathFollower path = actor.Controller.Path;

	action.SetGoalPosition(newGoalPos);

	path.ComputeToPos(bot, newGoalPos);
	action.HasReachedAlertPosition = false;

	if (!action.IsRunning)
	{
		if (shouldRun)
		{
			actor.MovementType = SF2NPCMoveType_Run;
			action.IsRunning = true;
		}
		else
		{
			actor.MovementType = SF2NPCMoveType_Walk;
		}
	}
}

static void OnSuspend(SF2_ChaserAlertAction action, SF2_ChaserEntity actor, NextBotAction interruptingAction)
{
	actor.MyNextBotPointer().GetLocomotionInterface().Stop();
	actor.IsAttemptingToMove = false;
}

static void OnEnd(SF2_ChaserAlertAction action, SF2_ChaserEntity actor)
{
	actor.AlertTriggerTarget = SF2_INVALID_PLAYER;
	for (int clientIndex = 1; clientIndex <= MaxClients; clientIndex++)
	{
		SF2_BasePlayer client = SF2_BasePlayer(clientIndex);
		if (client.IsValid && !client.IsEliminated && !client.HasEscaped)
		{
			actor.SetAlertTriggerCount(client, 0);
			actor.SetAlertSoundTriggerCooldown(client, 2.0);
		}
	}
}

static void OnResume(SF2_ChaserAlertAction action, SF2_ChaserEntity actor, NextBotAction interruptingAction)
{
	actor.UpdateMovementAnimation();
}

static void OnReachedAlertPosition(SF2_ChaserAlertAction action, SF2_ChaserEntity actor)
{
	SF2NPC_Chaser controller = actor.Controller;
	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	int difficulty = controller.Difficulty;
	float gameTime = GetGameTime();

	action.NextTurnTime = gameTime + GetRandomFloat(data.AlertData.TurnMinTime[difficulty], data.AlertData.TurnMaxTime[difficulty]);
	action.NextWanderTime = gameTime + GetRandomFloat(data.WanderEnterTimeMin[difficulty], data.WanderEnterTimeMax[difficulty]);
}

static void OnMoveToSuccess(SF2_ChaserAlertAction action, SF2_ChaserEntity actor, Path path)
{
	if (!action.HasReachedAlertPosition)
	{
		OnReachedAlertPosition(action, actor);
	}
	action.HasReachedAlertPosition = true;
	action.IsRunning = false;
}

static void OnMoveToFailure(SF2_ChaserAlertAction action, SF2_ChaserEntity actor, Path path, MoveToFailureType reason)
{
	if (!action.HasReachedAlertPosition)
	{
		OnReachedAlertPosition(action, actor);
	}
	action.HasReachedAlertPosition = true;
	action.IsRunning = false;
}
