#pragma semicolon 1
#pragma newdecls required

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserTauntKillAction < NextBotAction
{
	public SF2_ChaserTauntKillAction()
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_TauntKill");
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_OnResume, OnResume);
		}
		return view_as<SF2_ChaserTauntKillAction>(g_Factory.Create());
	}

	public static bool IsPossible(SF2_ChaserEntity actor)
	{
		ChaserBossProfile data = actor.Controller.GetProfileData();
		if (!data.GetAnimations().HasAnimationSection(g_SlenderAnimationsList[SF2BossAnimation_TauntKill]))
		{
			return false;
		}

		return true;
	}
}


static int OnStart(SF2_ChaserTauntKillAction action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	float rate = 1.0, duration = 0.0, cycle = 0.0;

	actor.PerformVoice(SF2BossSound_TauntKill);
	actor.KillTarget = CBaseEntity(-1);

	int sequence = actor.SelectProfileAnimation(g_SlenderAnimationsList[SF2BossAnimation_TauntKill], rate, duration, cycle);
	if (sequence != -1)
	{
		return action.SuspendFor(SF2_PlaySequenceAndWait(sequence, duration, rate, cycle));
	}

	SF2NPC_Chaser controller = actor.Controller;
	if (controller.IsValid())
	{
		ChaserBossProfile data = controller.GetProfileData();
		if (data.NormalSoundHook)
		{
			actor.NextVoiceTime = 0.0;
		}
	}

	return action.Done("I'm done taunting someone after I killed them.");
}

static int OnResume(SF2_ChaserTauntKillAction action, SF2_ChaserEntity actor, NextBotAction interruptingAction)
{
	SF2NPC_Chaser controller = actor.Controller;
	if (controller.IsValid())
	{
		ChaserBossProfile data = controller.GetProfileData();
		if (data.NormalSoundHook)
		{
			actor.NextVoiceTime = 0.0;
		}
	}

	return action.Done("I'm done taunting someone after I killed them.");
}
