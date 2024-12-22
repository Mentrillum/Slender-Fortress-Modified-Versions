#pragma semicolon 1
#pragma newdecls required

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserChaseInitialAction < NextBotAction
{
	public SF2_ChaserChaseInitialAction()
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_ChaseInitial");
			g_Factory.SetCallback(NextBotActionCallbackType_InitialContainedAction, InitialContainedAction);
			//g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetCallback(NextBotActionCallbackType_OnSuspend, OnSuspend);
			g_Factory.SetCallback(NextBotActionCallbackType_OnEnd, OnEnd);
		}
		return view_as<SF2_ChaserChaseInitialAction>(g_Factory.Create());
	}

	public static bool IsPossible(SF2_ChaserEntity actor)
	{
		if (SF_IsSlaughterRunMap())
		{
			return false;
		}

		ChaserBossProfile data = actor.Controller.GetProfileDataEx();
		if (!data.GetAnimations().HasAnimationSection(g_SlenderAnimationsList[SF2BossAnimation_ChaseInitial]))
		{
			return false;
		}

		return true;
	}
}

static NextBotAction InitialContainedAction(SF2_ChaserChaseInitialAction action, SF2_ChaserEntity actor)
{
	SF2NPC_Chaser controller = actor.Controller;
	ChaserBossProfile data = controller.GetProfileDataEx();
	actor.IsInChaseInitial = true;

	ProfileAnimation section = data.GetAnimations().GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_ChaseInitial]);
	if (section != null)
	{
		return SF2_PlaySequenceAndWaitEx(g_SlenderAnimationsList[SF2BossAnimation_ChaseInitial]);
	}

	return NULL_ACTION;
}

static int Update(SF2_ChaserChaseInitialAction action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	if (action.ActiveChild == NULL_ACTION)
	{
		return action.Done("Sequence action finished");
	}

	ILocomotion loco = actor.MyNextBotPointer().GetLocomotionInterface();
	loco.Stop();

	CBaseEntity target = actor.Target;
	if (target.IsValid())
	{
		float pos[3];
		target.GetAbsOrigin(pos);
		loco.FaceTowards(pos);
	}

	return action.Continue();
}

static int OnSuspend(SF2_ChaserChaseInitialAction action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	return action.Done();
}

static void OnEnd(SF2_ChaserChaseInitialAction action, SF2_ChaserEntity actor)
{
	actor.IsInChaseInitial = false;
}