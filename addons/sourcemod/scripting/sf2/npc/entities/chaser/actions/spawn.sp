#pragma semicolon 1
#pragma newdecls required

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserSpawnAction < NextBotAction
{
	public SF2_ChaserSpawnAction()
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_Spawn");
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_OnResume, OnResume);
			g_Factory.SetCallback(NextBotActionCallbackType_OnEnd, OnEnd);
		}
		return view_as<SF2_ChaserSpawnAction>(g_Factory.Create());
	}
}

static int OnStart(SF2_ChaserSpawnAction action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	actor.State = STATE_IDLE;
	actor.IsSpawning = true;

	float rate = 1.0, duration = 0.0, cycle = 0.0;
	if (actor.GetOverrideSpawnAnimation()[0] != '\0')
	{
		int sequence = LookupProfileAnimation(actor.index, actor.GetOverrideSpawnAnimation());
		if (sequence != -1)
		{
			rate = actor.GetPropFloat(Prop_Data, "m_OverrideSpawnAnimationRate");
			duration = actor.GetPropFloat(Prop_Data, "m_OverrideSpawnAnimationDuration");
			return action.SuspendFor(SF2_PlaySequenceAndWait(sequence, duration, rate, cycle));
		}
	}

	int sequence = actor.SelectProfileAnimation(g_SlenderAnimationsList[SF2BossAnimation_Spawn], rate, duration, cycle);
	if (sequence != -1)
	{
		return action.SuspendFor(SF2_PlaySequenceAndWait(sequence, duration, rate, cycle));
	}

	return action.ChangeTo(SF2_ChaserIdleAction());
}

static int OnResume(SF2_ChaserSpawnAction action, SF2_ChaserEntity actor, NextBotAction interruptingAction)
{
	return action.ChangeTo(SF2_ChaserIdleAction());
}

static void OnEnd(SF2_ChaserSpawnAction action, SF2_ChaserEntity actor)
{
	Call_StartForward(g_OnBossFinishSpawningFwd);
	Call_PushCell(actor.Controller);
	Call_Finish();
}