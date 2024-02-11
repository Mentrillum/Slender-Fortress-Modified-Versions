#pragma semicolon 1

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserDespawnAction < NextBotAction
{
	public SF2_ChaserDespawnAction()
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_Despawn");
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_OnResume, OnResume);
			g_Factory.SetCallback(NextBotActionCallbackType_OnEnd, OnEnd);
		}
		return view_as<SF2_ChaserDespawnAction>(g_Factory.Create());
	}
}

static int OnStart(SF2_ChaserDespawnAction action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	actor.State = STATE_IDLE;

	actor.PerformVoice(SF2BossSound_Despawn);

	float rate = 1.0, duration = 0.0, cycle = 0.0;
	int sequence = actor.SelectProfileAnimation(g_SlenderAnimationsList[SF2BossAnimation_Despawn], rate, duration, cycle);
	if (sequence != -1)
	{
		return action.SuspendFor(SF2_PlaySequenceAndWait(sequence, duration, rate, cycle));
	}

	return action.Done();
}

static int OnResume(SF2_ChaserDespawnAction action, SF2_ChaserEntity actor, NextBotAction interruptingAction)
{
	return action.Done("I am done despawning");
}

static void OnEnd(SF2_ChaserSpawnAction action, SF2_ChaserEntity actor)
{
	RemoveEntity(actor.index);
}