#pragma semicolon 1

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserChaseLayerAction < NextBotAction
{
	public SF2_ChaserChaseLayerAction()
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_ChaseLayer");
			g_Factory.SetCallback(NextBotActionCallbackType_InitialContainedAction, InitialContainedAction);
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetCallback(NextBotActionCallbackType_OnSuspend, OnSuspend);
			g_Factory.SetCallback(NextBotActionCallbackType_OnResume, OnResume);
		}
		return view_as<SF2_ChaserChaseLayerAction>(g_Factory.Create());
	}
}

static NextBotAction InitialContainedAction(SF2_ChaserChaseLayerAction action, SF2_ChaserEntity actor)
{
	return NULL_ACTION;
}

static int OnStart(SF2_ChaserChaseLayerAction action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	actor.MovementType = SF2NPCMoveType_Run;
	actor.UpdateMovementAnimation();

	if (SF2_ChaserChaseInitialAction.IsPossible(actor))
	{
		return action.SuspendFor(SF2_ChaserChaseInitialAction());
	}
	return action.Continue();
}

static int Update(SF2_ChaserChaseLayerAction action, SF2_ChaserEntity actor, float interval)
{
	SF2NPC_Chaser controller = actor.Controller;
	int interrputConditions = actor.InterruptConditions;
	INextBot bot = actor.MyNextBotPointer();
	CBaseEntity target = actor.Target;

	PathFollower path = controller.Path;
	ILocomotion loco = bot.GetLocomotionInterface();

	bool tooClose = target.IsValid() &&
		(interrputConditions & COND_ENEMYVISIBLE) != 0 &&
		bot.IsRangeLessThan(target.index, 8.0);

	if (tooClose && path.IsValid())
	{
		path.Invalidate();
	}
	else if (target.IsValid())
	{
		float pos[3];
		target.GetAbsOrigin(pos);
		if (actor.Teleporters.Length > 0)
		{
			CBaseEntity(actor.Teleporters.Get(0)).GetAbsOrigin(pos);
		}

		if (!bot.IsRangeLessThanEx(pos, 8.0))
		{
			if ((interrputConditions & COND_NEWENEMY) != 0 || path.GetAge() > 0.3 || (path.IsValid() && (path.GetLength() - path.GetCursorPosition()) < 256.0))
			{
				path.ComputeToPos(bot, pos);
			}
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

	return action.Continue();
}

static void OnSuspend(SF2_ChaserChaseLayerAction action, SF2_ChaserEntity actor, NextBotAction interruptingAction)
{
	actor.MyNextBotPointer().GetLocomotionInterface().Stop();
	actor.IsAttemptingToMove = false;
}

static int OnResume(SF2_ChaserChaseLayerAction action, SF2_ChaserEntity actor, NextBotAction interruptingAction)
{
	actor.MovementType = SF2NPCMoveType_Run;
	actor.UpdateMovementAnimation();
	if (actor.WasStunned)
	{
		SF2NPC_Chaser controller = actor.Controller;
		if (controller.IsValid())
		{
			if (controller.GetProfileData().StunData.ChaseInitialOnEnd[controller.Difficulty] && SF2_ChaserChaseInitialAction.IsPossible(actor))
			{
				return action.SuspendFor(SF2_ChaserChaseInitialAction());
			}
		}
	}
	return action.Continue();
}
