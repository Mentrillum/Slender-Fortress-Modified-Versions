#pragma semicolon 1
#pragma newdecls required

static NextBotActionFactory g_Factory;

methodmap SF2_StatueIdleAction < NextBotAction
{
	public SF2_StatueIdleAction()
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Statue_Idle");
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
		}
		return view_as<SF2_StatueIdleAction>(g_Factory.Create());
	}
}

static int OnStart(SF2_StatueIdleAction action, SF2_StatueEntity actor, NextBotAction priorAction)
{
	actor.State = STATE_IDLE;
	return action.Continue();
}

static int Update(SF2_StatueIdleAction action, SF2_StatueEntity actor)
{
	CBaseEntity target = actor.Target;
	if (actor.LastKillTime > GetGameTime())
	{
		return action.Continue();
	}

	if (target.IsValid())
	{
		return action.ChangeTo(SF2_StatueChaseAction(), "I sense someone, lock onto them!");
	}
	actor.IsMoving = false;
	return action.Continue();
}