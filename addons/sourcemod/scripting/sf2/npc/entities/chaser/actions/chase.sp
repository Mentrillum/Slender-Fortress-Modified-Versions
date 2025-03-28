#pragma semicolon 1
#pragma newdecls required

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserChaseAction < NextBotAction
{
	public SF2_ChaserChaseAction()
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_Chase");
			g_Factory.SetCallback(NextBotActionCallbackType_InitialContainedAction, InitialContainedAction);
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetCallback(NextBotActionCallbackType_OnResume, OnResume);
			g_Factory.SetCallback(NextBotActionCallbackType_OnEnd, OnEnd);
		}
		return view_as<SF2_ChaserChaseAction>(g_Factory.Create());
	}
}

static NextBotAction InitialContainedAction(SF2_ChaserChaseAction action, SF2_ChaserEntity actor)
{
	return SF2_ChaserAttackLayerAction();
}

static int OnStart(SF2_ChaserChaseAction action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	actor.PerformVoice(SF2BossSound_ChaseInitial);
	actor.MaintainTarget = true;

	SF2NPC_Chaser controller = actor.Controller;
	int difficulty = controller.Difficulty;
	CBaseEntity target = actor.Target;
	if (!target.IsValid())
	{
		actor.State = STATE_IDLE;
		return action.ChangeTo(SF2_ChaserIdleAction(), "My target is no longer valid!");
	}

	ChaserBossProfile data = controller.GetProfileData();
	ChaserBossProfileChaseData chaseData = data.GetChaseBehavior();

	actor.CurrentChaseDuration = chaseData.GetMaxChaseDuration(difficulty);

	if (actor.InitialChaseDuration > 0.0)
	{
		actor.CurrentChaseDuration = actor.InitialChaseDuration;
		actor.InitialChaseDuration = 0.0;
	}

	if (chaseData.GetChaseTogetherData().IsEnabled(difficulty) && chaseData.GetChaseTogetherData().ShouldStartOnStateChange(difficulty))
	{
		actor.ForceChaseOtherBosses();
	}

	actor.AlertWithBoss = false;

	return action.Continue();
}

static int Update(SF2_ChaserChaseAction action, SF2_ChaserEntity actor)
{
	SF2NPC_Chaser controller = actor.Controller;
	if (!controller.IsValid())
	{
		return action.Continue();
	}

	ChaserBossProfile data = controller.GetProfileData();
	ChaserBossProfileAlertData alertData = data.GetAlertBehavior();
	ChaserBossProfileChaseData chaseData = data.GetChaseBehavior();

	if (!data.IsPvEBoss && IsBeatBoxBeating(2) && actor.State != STATE_ATTACK && !actor.IsInChaseInitial)
	{
		return action.SuspendFor(SF2_ChaserBeatBoxFreezeAction(actor.IsAttemptingToMove));
	}

	CBaseEntity target = actor.Target;
	float gameTime = GetGameTime();
	int difficulty = controller.Difficulty;
	INextBot bot = actor.MyNextBotPointer();
	int interruptConditions = actor.InterruptConditions;

	if (target.IsValid())
	{
		actor.ProcessCloak(target);

		if (ShouldClientBeForceChased(controller, target))
		{
			SetClientForceChaseState(controller, target, false);
		}
		if (IsValidClient(target.index))
		{
			actor.SetAutoChaseCount(SF2_BasePlayer(target.index), 0);
		}

		if (!actor.IsAttacking)
		{
			if (actor.CurrentChaseDuration <= 0.0)
			{
				actor.State = STATE_ALERT;
				return action.ChangeTo(SF2_ChaserAlertAction(_, alertData.ShouldRunOnSuspect(difficulty)), "Oh he got away...");
			}
		}

		actor.RegisterProjectiles();

		SF2_BasePlayer player = SF2_BasePlayer(target.index);
		if (!data.IsPvEBoss && player.IsValid && player.HasEscaped)
		{
			actor.State = STATE_IDLE;
			return action.ChangeTo(SF2_ChaserIdleAction(), "Our target escaped, that is no good!");
		}

		if ((interruptConditions & COND_SAWENEMY) != 0 || (interruptConditions & COND_ENEMYVISIBLE) != 0)
		{
			float maxRange = chaseData.GetDurationTargetRange(difficulty);
			float distanceRatio = bot.GetRangeTo(player.index) / maxRange;
			if (maxRange > 0.0 && distanceRatio < 1.0)
			{
				float addNear = chaseData.GetDurationAddVisibleTargetNear(difficulty);
				float addFar = chaseData.GetDurationAddVisibleTargetFar(difficulty);
				float durationAdd = addNear + ((addFar - addNear) * distanceRatio);

				actor.CurrentChaseDuration += durationAdd * GetGameFrameTime();
				if (actor.CurrentChaseDuration > chaseData.GetMaxChaseDuration(difficulty))
				{
					actor.CurrentChaseDuration = chaseData.GetMaxChaseDuration(difficulty);
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
		if (!actor.IsAttacking)
		{
			if (actor.KillTarget.IsValid())
			{
				return action.SuspendFor(SF2_ChaserTauntKillAction(), "Let's taunt the kill victim cause funny.");
			}
			actor.State = STATE_IDLE;
			return action.ChangeTo(SF2_ChaserIdleAction(), "No valid target? No problem!");
		}
	}

	if (data.GetChaseOnLookData().IsEnabled(difficulty) && controller.ChaseOnLookTargets.FindValue(target.index) != -1)
	{
		actor.CurrentChaseDuration = chaseData.GetMaxChaseDuration(difficulty);
	}

	if (gameTime >= actor.NextVoiceTime && !actor.IsAttacking)
	{
		actor.PerformVoice(SF2BossSound_Chasing);
	}

	#if defined DEBUG
	SendDebugMessageToPlayer(target.index, DEBUG_BOSS_CHASE, 1, "actor[%i].CurrentChaseDuration: %f", actor.index, actor.CurrentChaseDuration);
	#endif

	return action.Continue();
}

static void OnResume(SF2_ChaserChaseAction action, SF2_ChaserEntity actor)
{
	if (actor.WasStunned)
	{
		SF2NPC_Chaser controller = actor.Controller;
		if (controller.IsValid())
		{
			if (controller.GetProfileData().GetStunBehavior().CanChaseInitialOnEnd(controller.Difficulty))
			{
				actor.PerformVoice(SF2BossSound_ChaseInitial);
			}
		}
	}
}

static void OnEnd(SF2_ChaserChaseAction action, SF2_ChaserEntity actor)
{
	if (!actor.Controller.IsValid())
	{
		return;
	}
	SF2NPC_Chaser controller = actor.Controller;
	ChaserBossProfile data = controller.GetProfileData();
	actor.EndCloak();
	PathFollower path = actor.Controller.Path;
	float gameTime = GetGameTime();
	if (path.IsValid())
	{
		path.Invalidate();
	}
	actor.MaintainTarget = false;
	actor.HasSmelled = false;
	int difficulty = actor.Controller.Difficulty;
	if (actor.FollowedCompanionChase)
	{
		actor.FollowCooldownChase = GetGameTime() + data.GetChaseBehavior().GetChaseTogetherData().GetFollowCooldown(difficulty);
	}
	if (actor.Teleporters != null)
	{
		actor.Teleporters.Clear();
	}

	float cooldown = data.GetAutoChaseData().GetCooldownAfterChase(difficulty);
	if (cooldown > 0.0)
	{
		float nextTime = gameTime + cooldown;
		for (int i = 1; i <= MaxClients; i++)
		{
			SF2_BasePlayer client = SF2_BasePlayer(i);
			if (!client.IsValid)
			{
				continue;
			}

			if (nextTime > actor.GetAutoChaseCooldown(client))
			{
				actor.SetAutoChaseCooldown(client, gameTime + cooldown);
			}
		}

		for (int i = 1; i < GetMaxEntities(); i++)
		{
			if (!IsValidEntity(i))
			{
				continue;
			}

			SetTargetMarkState(controller, CBaseEntity(i), false);
		}
	}
}