#pragma semicolon 1
// This is for detecting attacks

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserAttackLayerAction < NextBotAction
{
	public SF2_ChaserAttackLayerAction()
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_AttackLayer");
			g_Factory.SetCallback(NextBotActionCallbackType_InitialContainedAction, InitialContainedAction);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.BeginDataMapDesc()
				.EndDataMapDesc();
		}
		return view_as<SF2_ChaserAttackLayerAction>(g_Factory.Create());
	}
}

static NextBotAction InitialContainedAction(SF2_ChaserAttackLayerAction action, SF2_ChaserEntity actor)
{
	return SF2_ChaserChaseLayerAction();
}

static int Update(SF2_ChaserAttackLayerAction action, SF2_ChaserEntity actor)
{
	CBaseEntity target = actor.Target;
	if (!actor.IsAttacking && target.IsValid())
	{
		if (actor.IsLOSClearFromTarget(target))
		{
			NextBotAction attackAction = actor.GetAttackAction(target);
			if (attackAction != NULL_ACTION)
			{
				actor.EndCloak();
				return action.SuspendFor(attackAction, "Time to die!");
			}
		}
	}
	return action.Continue();
}