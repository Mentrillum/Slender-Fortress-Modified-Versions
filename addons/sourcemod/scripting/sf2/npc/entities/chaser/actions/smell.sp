#pragma semicolon 1

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserSmellAction < NextBotAction
{
	public SF2_ChaserSmellAction()
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_Smell");
			g_Factory.SetCallback(NextBotActionCallbackType_InitialContainedAction, InitialContainedAction);
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetCallback(NextBotActionCallbackType_OnSuspend, OnSuspend);
			g_Factory.SetCallback(NextBotActionCallbackType_OnEnd, OnEnd);
		}
		return view_as<SF2_ChaserSmellAction>(g_Factory.Create());
	}

	public static bool IsPossible(SF2_ChaserEntity actor)
	{
		SF2NPC_BaseNPC baseController = view_as<SF2NPC_BaseNPC>(actor.Controller);
		SF2BossProfileData data;
		data = baseController.GetProfileData();
		if (!data.AnimationData.HasAnimationSection(g_SlenderAnimationsList[SF2BossAnimation_Smell]))
		{
			return false;
		}

		return true;
	}
}

static NextBotAction InitialContainedAction(SF2_ChaserSmellAction action, SF2_ChaserEntity actor)
{
	SF2NPC_BaseNPC baseController = view_as<SF2NPC_BaseNPC>(actor.Controller);
	SF2BossProfileData data;
	data = baseController.GetProfileData();
	char animName[64];
	float rate = 1.0, duration = 0.0, cycle = 0.0;
	int difficulty = baseController.Difficulty;
	actor.IsAttemptingToMove = false;

	actor.PerformVoice(SF2BossSound_Smell);

	if (data.AnimationData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_Smell], difficulty, animName, sizeof(animName), rate, duration, cycle))
	{
		int sequence = actor.SelectProfileAnimation(g_SlenderAnimationsList[SF2BossAnimation_Smell], rate, duration, cycle);
		if (sequence != -1)
		{
			return SF2_PlaySequenceAndWait(sequence, duration, rate, cycle);
		}
	}

	return NULL_ACTION;
}

static int OnStart(SF2_ChaserSmellAction action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	actor.IsAllowedToDespawn = false;

	return action.Continue();
}

static int Update(SF2_ChaserSmellAction action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	SF2NPC_Chaser controller = actor.Controller;
	int difficulty = controller.Difficulty;
	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	PathFollower path = controller.Path;
	g_SlenderTimeUntilKill[controller.Index] = GetGameTime() + NPCGetIdleLifetime(controller.Index, difficulty);
	if (action.ActiveChild == NULL_ACTION)
	{
		float bestDistance = Pow(data.SmellData.SmellRange[difficulty], 2.0);
		bool found = false;
		float pos[3], myPos[3], bestPos[3];
		actor.GetAbsOrigin(myPos);

		CBaseEntity target = CBaseEntity(-1);
		for (int i = 0; i < actor.SmellPlayerList.Length; i++)
		{
			SF2_BasePlayer player = SF2_BasePlayer(actor.SmellPlayerList.Get(i));
			if (!player.IsValid)
			{
				continue;
			}
			player.GetAbsOrigin(pos);
			float distance = GetVectorSquareMagnitude(pos, myPos);
			if (distance <= bestDistance)
			{
				found = true;
				bestDistance = distance;
				bestPos = pos;
				target = CBaseEntity(player.index);
			}
		}
		if (found)
		{
			if (!data.SmellData.ShouldChase[difficulty])
			{
				actor.State = STATE_ALERT;
				path.Invalidate();
				if (data.NormalSoundHook)
				{
					actor.NextVoiceTime = 0.0;
				}
				return action.ChangeTo(SF2_ChaserAlertAction(bestPos, data.AlertData.RunOnSuspect[difficulty]), "I smelled someone, what is it?");
			}
			else
			{
				actor.Target = target;
				SF2_BasePlayer player = SF2_BasePlayer(target.index);
				player.SetForceChaseState(controller, true);
				actor.State = STATE_CHASE;
				path.Invalidate();
				if (data.NormalSoundHook)
				{
					actor.NextVoiceTime = 0.0;
				}
				return action.ChangeTo(SF2_ChaserChaseAction(), "I smelled someone and I need to chase them, GO GO GO!");
			}
		}
		actor.State = STATE_IDLE;
		return action.ChangeTo(SF2_ChaserIdleAction(), "Sniffers found nothing, go back to idle.");
	}

	int interruptConditions = actor.InterruptConditions;

	ILocomotion loco = actor.MyNextBotPointer().GetLocomotionInterface();
	loco.Stop();

	CBaseEntity target = actor.Target;
	if (target.IsValid())
	{
		if ((interruptConditions & COND_SAWENEMY) != 0)
		{
			float pos[3];
			target.GetAbsOrigin(pos);
			actor.State = STATE_ALERT;
			path.Invalidate();
			if (data.NormalSoundHook)
			{
				actor.NextVoiceTime = 0.0;
			}
			return action.ChangeTo(SF2_ChaserAlertAction(pos, data.AlertData.RunOnSuspect[difficulty]), "Abort abort, I saw someone!");
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
		return action.ChangeTo(SF2_ChaserAlertAction(pos, data.AlertData.RunOnSuspect[difficulty]), "Stop! I heard someone!");
	}
	else if ((interruptConditions & COND_ALERT_TRIGGER_POS) != 0)
	{
		float pos[3];
		actor.GetAlertTriggerPositionEx(pos);

		actor.State = STATE_ALERT;
		path.Invalidate();
		if (data.NormalSoundHook)
		{
			actor.NextVoiceTime = 0.0;
		}
		return action.ChangeTo(SF2_ChaserAlertAction(pos, data.AlertData.RunOnSuspect[difficulty]), "Stop! I got a sound hint!");
	}

	return action.Continue();
}

static int OnSuspend(SF2_ChaserSmellAction action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	return action.Done();
}

static void OnEnd(SF2_ChaserSmellAction action, SF2_ChaserEntity actor)
{
	actor.IsAllowedToDespawn = true;
	actor.HasSmelled = true;
}