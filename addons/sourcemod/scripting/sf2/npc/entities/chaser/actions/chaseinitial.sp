#pragma semicolon 1

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

		SF2NPC_BaseNPC baseController = view_as<SF2NPC_BaseNPC>(actor.Controller);
		SF2BossProfileData data;
		data = baseController.GetProfileData();
		if (!data.AnimationData.HasAnimationSection(g_SlenderAnimationsList[SF2BossAnimation_ChaseInitial]))
		{
			return false;
		}

		return true;
	}
}

static NextBotAction InitialContainedAction(SF2_ChaserChaseInitialAction action, SF2_ChaserEntity actor)
{
	SF2NPC_BaseNPC baseController = view_as<SF2NPC_BaseNPC>(actor.Controller);
	SF2BossProfileData data;
	data = baseController.GetProfileData();
	char animName[64];
	float rate = 1.0, duration = 0.0, cycle = 0.0;
	int difficulty = baseController.Difficulty;
	actor.IsInChaseInitial = true;

	if (data.AnimationData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_ChaseInitial], difficulty, animName, sizeof(animName), rate, duration, cycle))
	{
		int sequence = LookupProfileAnimation(actor.index, animName);
		if (sequence != -1)
		{
			return SF2_PlaySequenceAndWait(sequence, duration, rate, cycle);
		}
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