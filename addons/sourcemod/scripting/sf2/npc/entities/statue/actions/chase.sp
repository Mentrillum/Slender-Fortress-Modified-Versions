#pragma semicolon 1
#pragma newdecls required

static NextBotActionFactory g_Factory;

methodmap SF2_StatueChaseAction < NextBotAction
{
	public SF2_StatueChaseAction()
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Statue_Chase");
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetCallback(NextBotActionCallbackType_OnEnd, OnEnd);
		}
		return view_as<SF2_StatueChaseAction>(g_Factory.Create());
	}
}

static int OnStart(SF2_StatueChaseAction action, SF2_StatueEntity actor, NextBotAction priorAction)
{
	SF2NPC_Statue controller = actor.Controller;
	int difficulty = controller.Difficulty;
	StatueBossProfile data = controller.GetProfileData();
	actor.CurrentChaseDuration = data.GetChaseDuration(difficulty);
	if (actor.InitialChaseDuration > 0.0)
	{
		actor.CurrentChaseDuration = actor.InitialChaseDuration;
		actor.InitialChaseDuration = 0.0;
	}

	actor.State = STATE_CHASE;
	return action.Continue();
}

static int Update(SF2_StatueChaseAction action, SF2_StatueEntity actor)
{
	if (actor.CurrentChaseDuration <= 0.0)
	{
		actor.Target = CBaseEntity(-1);
		actor.OldTarget = CBaseEntity(INVALID_ENT_REFERENCE);
		return action.ChangeTo(SF2_StatueIdleAction(), "Oh he got away...");
	}

	CBaseEntity target = actor.Target;
	if (!target.IsValid())
	{
		return action.ChangeTo(SF2_StatueIdleAction(), "No target? No problem, idle.");
	}

	float gameTime = GetGameTime();

	if (actor.LastKillTime > gameTime)
	{
		return action.Continue();
	}

	SF2NPC_Statue controller = actor.Controller;
	StatueBossProfile data = controller.GetProfileData();
	bool attackEliminated = (controller.Flags & SFF_ATTACKWAITERS) != 0;
	int difficulty = controller.Difficulty;
	INextBot bot = actor.MyNextBotPointer();
	PathFollower path = controller.Path;
	ILocomotion loco = bot.GetLocomotionInterface();
	float myPos[3];
	actor.GetAbsOrigin(myPos);

	actor.IsMoving = !controller.CanBeSeen(true, true, !attackEliminated) && actor.LastKillTime <= gameTime;

	SF2_BasePlayer player = SF2_BasePlayer(target.index);
	if (player.IsValid && player.HasEscaped)
	{
		return action.ChangeTo(SF2_StatueIdleAction(), "Our target escaped, that is no good!");
	}

	if (player.IsValid && player.ShouldBeForceChased(controller))
	{
		player.SetForceChaseState(controller, false);
	}

	bool visible = (actor.InterruptConditions & COND_ENEMYVISIBLE) != 0;

	if (visible)
	{
		float maxRange = data.GetChaseDurationAddMaxRange(difficulty);
		if (maxRange > 0.0 && player.IsValid && player.CanSeeSlender(controller.Index, false, _, !attackEliminated))
		{
			float distanceRatio = bot.GetRangeTo(player.index) / maxRange;
			if (distanceRatio < 1.0)
			{
				float durationTimeAddMin = data.GetChaseDurationAddVisibilityMin(difficulty);
				float durationTimeAddMax = data.GetChaseDurationAddVisibilityMax(difficulty);
				float durationAdd = durationTimeAddMin + ((durationTimeAddMax - durationTimeAddMin) * distanceRatio);

				actor.CurrentChaseDuration += durationAdd * GetGameFrameTime();
				if (actor.CurrentChaseDuration > data.GetChaseDuration(difficulty))
				{
					actor.CurrentChaseDuration = data.GetChaseDuration(difficulty);
				}
			}
		}
		else
		{
			actor.CurrentChaseDuration -= GetGameFrameTime();
		}
	}
	else
	{
		actor.CurrentChaseDuration -= GetGameFrameTime();
	}

	if (SF_IsRaidMap() || SF_BossesChaseEndlessly() || SF_IsProxyMap() || SF_IsBoxingMap() || SF_IsSlaughterRunMap())
	{
		actor.CurrentChaseDuration = data.GetChaseDuration(difficulty);
	}

	bool tooClose = target.IsValid() &&
		visible &&
		bot.GetRangeSquaredTo(target.index) <= 32.0;

	if ((tooClose || !actor.IsMoving) && path.IsValid())
	{
		path.Invalidate();
	}
	else
	{
		int pathTo = target.index;
		if (actor.Teleporters.Length > 0)
		{
			pathTo = actor.Teleporters.Get(0);
		}

		if (path.GetAge() > 0.3 || (path.IsValid() && (path.GetLength() - path.GetCursorPosition()) < 256.0))
		{
			path.ComputeToTarget(bot, pathTo);
		}
	}

	if (!path.IsValid())
	{
		loco.Stop();
	}
	else
	{
		path.Update(bot);
	}

	if (actor.IsMoving)
	{
		g_SlenderStatueIdleLifeTime[controller.Index] = gameTime + data.GetIdleLifeTime(difficulty);

		if (bot.GetRangeSquaredTo(target.index) <= Pow(data.GetInstantKillRadius(difficulty), 2.0) && visible)
		{
			if (controller.Flags & SFF_FAKE)
			{
				controller.MarkAsFake();
				return action.Done("Faker");
			}
			else
			{
				actor.LastKillTime = gameTime + data.GetInstantKillCooldown(difficulty);
				player.StartDeathCam(controller.Index, myPos);
			}
		}
	}
	return action.Continue();
}

static void OnEnd(SF2_StatueChaseAction action, SF2_StatueEntity actor)
{
	if (actor.Teleporters != null)
	{
		actor.Teleporters.Clear();
	}
}