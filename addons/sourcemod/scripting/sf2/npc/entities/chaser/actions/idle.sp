#pragma semicolon 1

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserIdleAction < NextBotAction
{
	public SF2_ChaserIdleAction()
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_Idle");
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.BeginDataMapDesc()
				.DefineBoolField("m_InitialState")
				.DefineFloatField("m_NextWanderTime")
				.DefineFloatField("m_NextTurnTime")
				.DefineVectorField("m_LookPos")
				.EndDataMapDesc();
		}
		return view_as<SF2_ChaserIdleAction>(g_Factory.Create());
	}

	property bool InitialState
	{
		public get()
		{
			return this.GetData("m_InitialState") != 0;
		}

		public set(bool value)
		{
			this.SetData("m_InitialState", value);
		}
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
}

static int OnStart(SF2_ChaserIdleAction action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	INextBot bot = actor.MyNextBotPointer();
	SF2NPC_Chaser controller = actor.Controller;
	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	int difficulty = controller.Difficulty;
	float gameTime = GetGameTime();

	action.NextTurnTime = gameTime + GetRandomFloat(data.IdleData.TurnMinTime[difficulty], data.IdleData.TurnMaxTime[difficulty]);
	action.NextWanderTime = gameTime + GetRandomFloat(data.WanderEnterTimeMin[difficulty], data.WanderEnterTimeMax[difficulty]);
	action.InitialState = true;

	bot.GetLocomotionInterface().Stop();

	actor.MovementType = SF2NPCMoveType_Walk;
	actor.IsAttemptingToMove = false;
	actor.UpdateMovementAnimation();

	for (int i = 0; i < MAX_NPCTELEPORTER; i++)
	{
		if (actor.Controller.GetTeleporter(i) != INVALID_ENT_REFERENCE)
		{
			actor.Controller.SetTeleporter(i, INVALID_ENT_REFERENCE);
		}
	}

	if (!actor.HasSmelled)
	{
		actor.SmellCooldown = gameTime + GetRandomFloat(data.SmellData.CooldownMin[difficulty], data.SmellData.CooldownMax[difficulty]);
	}
	else
	{
		actor.SmellCooldown = gameTime + GetRandomFloat(data.SmellData.CooldownAfterStateMin[difficulty], data.SmellData.CooldownAfterStateMax[difficulty]);
	}

	g_SlenderTimeUntilKill[controller.Index] = GetGameTime() + NPCGetIdleLifetime(controller.Index, difficulty);

	return action.Continue();
}

static int Update(SF2_ChaserIdleAction action, SF2_ChaserEntity actor, float interval)
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
	int interruptConditions = actor.InterruptConditions;
	CBaseEntity target = actor.Target;

	PathFollower path = controller.Path;

	if (data.ChaseOnLookData.Enabled[difficulty] && controller.ChaseOnLookTargets.Length > 0)
	{
		SF2_BasePlayer lookTarget = SF2_BasePlayer(controller.ChaseOnLookTargets.Get(0));
		if (lookTarget.IsValid && !lookTarget.IsEliminated && lookTarget.IsAlive && !lookTarget.IsInGhostMode && !lookTarget.HasEscaped)
		{
			actor.Target = lookTarget;
			actor.OldTarget = lookTarget;
			actor.State = STATE_CHASE;
			path.Invalidate();
			if (data.NormalSoundHook)
			{
				actor.NextVoiceTime = 0.0;
			}
			return action.ChangeTo(SF2_ChaserChaseAction(), "Someone has looked at me, GET THEM!");
		}
	}

	if (target.IsValid())
	{
		if (SF_IsRaidMap() || SF_BossesChaseEndlessly() || SF_IsProxyMap() || SF_IsBoxingMap() || SF_IsSlaughterRunMap() || data.ChasesEndlessly ||
			view_as<SF2NPC_BaseNPC>(controller).GetProfileData().IsPvEBoss)
		{
			actor.State = STATE_CHASE;
			path.Invalidate();
			if (data.NormalSoundHook)
			{
				actor.NextVoiceTime = 0.0;
			}
			return action.ChangeTo(SF2_ChaserChaseAction(), "We must endless chase, GET THEM!");
		}

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
		else if ((interruptConditions & COND_SAWENEMY) != 0)
		{
			float pos[3];
			target.GetAbsOrigin(pos);
			actor.State = STATE_ALERT;
			path.Invalidate();
			if (data.NormalSoundHook)
			{
				actor.NextVoiceTime = 0.0;
			}
			return action.ChangeTo(SF2_ChaserAlertAction(pos, data.AlertData.RunOnSuspect[difficulty]), "I saw someone!");
		}
	}

	SF2_BasePlayer alertTarget = actor.AlertTriggerTarget;
	if ((interruptConditions & COND_ALERT_TRIGGER) != 0 && alertTarget.IsValid)
	{
		float pos[3];
		actor.GetAlertTriggerPosition(alertTarget, pos);

		actor.State = STATE_ALERT;
		path.Invalidate();
		if (data.NormalSoundHook)
		{
			actor.NextVoiceTime = 0.0;
		}
		return action.ChangeTo(SF2_ChaserAlertAction(pos, data.AlertData.RunOnSuspect[difficulty]), "Someone made noise, let's go!");
	}
	else if ((interruptConditions & COND_ALERT_TRIGGER_POS) != 0 || actor.QueueForAlertState)
	{
		float pos[3];
		actor.GetAlertTriggerPositionEx(pos);

		actor.State = STATE_ALERT;
		path.Invalidate();
		if (data.NormalSoundHook)
		{
			actor.NextVoiceTime = 0.0;
		}
		actor.QueueForAlertState = false;
		return action.ChangeTo(SF2_ChaserAlertAction(pos, data.AlertData.RunOnSuspect[difficulty]), "We got a sound hint, let's go!");
	}

	if ((interruptConditions & COND_DEBUG) != 0)
	{
		float pos[3];
		actor.GetForceWanderPosition(pos);

		actor.State = STATE_ALERT;
		path.Invalidate();
		if (data.NormalSoundHook)
		{
			actor.NextVoiceTime = 0.0;
		}
		return action.ChangeTo(SF2_ChaserAlertAction(pos, data.AlertData.RunOnWander[difficulty]), "An admin told me to go here!");
	}

	if (actor.FollowedCompanionAlert || actor.AlertWithBoss)
	{
		float pos[3];
		actor.GetForceWanderPosition(pos);
		if (actor.AlertWithBoss)
		{
			actor.AlertWithBoss = false;
		}
		if (!IsNullVector(pos))
		{
			actor.State = STATE_ALERT;
			path.Invalidate();
			if (data.NormalSoundHook)
			{
				actor.NextVoiceTime = 0.0;
			}
			return action.ChangeTo(SF2_ChaserAlertAction(pos, data.AlertData.RunOnWander[difficulty]), "One of my mates found something!");
		}
	}

	if (data.SmellData.Enabled[difficulty] && actor.SmellCooldown <= gameTime && actor.SmellPlayerList != null)
	{
		if (actor.SmellPlayerList.Length >= data.SmellData.PlayerCount[difficulty])
		{
			actor.State = STATE_ALERT;
			path.Invalidate();
			return action.ChangeTo(SF2_ChaserSmellAction(), "That smelly smell, it is, smelly.");
		}
	}

	bool isAbleToWander = data.CanWander[difficulty];
	bool canWalk = true;
	if (controller.HasAttribute(SF2Attribute_BlockWalkSpeedUnderDifficulty))
	{
		int value = RoundToNearest(controller.GetAttributeValue(SF2Attribute_BlockWalkSpeedUnderDifficulty));
		if (difficulty < value)
		{
			isAbleToWander = false;
			canWalk = false;
		}
	}

	if (actor.DebugShouldGoToPos && canWalk)
	{
		float debugPos[3];
		actor.GetForceWanderPosition(debugPos);
		path.Invalidate();
		float min = data.WanderTimeMin[difficulty];
		float max = data.WanderTimeMax[difficulty];

		action.NextWanderTime = gameTime + GetRandomFloat(min, max);
		path.ComputeToPos(bot, debugPos);
		actor.DebugShouldGoToPos = false;
	}

	if ((SF_SpecialRound(SPECIALROUND_BEACON) || g_RenevantBeaconEffect) && !actor.WasInBacon)
	{
		SF2_BasePlayer player = actor.GetClosestPlayer();
		if (player.IsValid)
		{
			float pos[3];
			player.GetAbsOrigin(pos);
			actor.State = STATE_ALERT;
			path.Invalidate();
			if (data.NormalSoundHook)
			{
				actor.NextVoiceTime = 0.0;
			}
			actor.WasInBacon = true;
			return action.ChangeTo(SF2_ChaserAlertAction(pos, data.AlertData.RunOnSuspect[difficulty]), "What is this smell of bacon?");
		}
	}

	if (isAbleToWander)
	{
		if (gameTime >= action.NextWanderTime && GetRandomFloat(0.0, 1.0) <= 0.25)
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

					path.ComputeToPos(bot, wanderPos);
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
		if (data.IdleData.TurnEnabled[difficulty])
		{
			if (!action.InitialState)
			{
				float lookPos[3];
				action.GetLookPosition(lookPos);
				loco.FaceTowards(lookPos);
			}
			if (action.NextTurnTime <= 0.0)
			{
				action.NextTurnTime = gameTime + GetRandomFloat(data.IdleData.TurnMinTime[difficulty], data.IdleData.TurnMaxTime[difficulty]);
			}
		}
	}

	if (data.IdleData.TurnEnabled[difficulty] && action.NextTurnTime > 0.0 && action.NextTurnTime <= gameTime)
	{
		float myPos[3], myAng[3];
		actor.GetAbsOrigin(myPos);
		actor.GetAbsAngles(myAng);
		myAng[1] += GetRandomFloat(-data.IdleData.TurnAngle[difficulty], data.IdleData.TurnAngle[difficulty]);
		float lookAt[3];
		lookAt[0] = 50.0;
		VectorTransform(lookAt, myPos, myAng, lookAt);
		action.SetLookPosition(lookAt);
		action.NextTurnTime = gameTime + GetRandomFloat(data.IdleData.TurnMinTime[difficulty], data.IdleData.TurnMaxTime[difficulty]);
		action.InitialState = false;
	}

	if (gameTime >= actor.NextVoiceTime)
	{
		actor.PerformVoice(SF2BossSound_Idle);
	}

	return action.Continue();
}