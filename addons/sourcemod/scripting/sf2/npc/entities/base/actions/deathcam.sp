#pragma semicolon 1

static NextBotActionFactory g_Factory;

methodmap SF2_DeathCamAction < NextBotAction
{
	public SF2_DeathCamAction()
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("SF2_Deathcam");
			g_Factory.SetCallback(NextBotActionCallbackType_InitialContainedAction, InitialContainedAction);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetCallback(NextBotActionCallbackType_OnEnd, OnEnd);
			g_Factory.SetEventCallback(EventResponderType_OnOtherKilled, OnOtherKilled);
		}
		return view_as<SF2_DeathCamAction>(g_Factory.Create());
	}
}

static NextBotAction InitialContainedAction(SF2_DeathCamAction action, SF2_BaseBoss actor)
{
	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(actor.index);
	npc.flWalkSpeed = 0.0;
	npc.flRunSpeed = 0.0;
	actor.IsKillingSomeone = true;
	float duration = 0.0, rate = 1.0, cycle = 0.0;
	SF2NPC_BaseNPC controller = actor.Controller;
	SF2BossProfileData data;
	data = controller.GetProfileData();
	SF2BossProfileSoundInfo info;
	info = data.LocalDeathCamSounds;
	info.EmitSound(_, actor.index);

	int sequence = actor.SelectProfileAnimation(g_SlenderAnimationsList[SF2BossAnimation_DeathCam], rate, duration, cycle);
	if (sequence != -1)
	{
		if (SF2_ChaserEntity(actor.index).IsValid())
		{
			SF2_ChaserEntity(actor.index).GroundSpeedOverride = true;
		}
		return SF2_PlaySequenceAndWait(sequence, duration, rate, cycle);
	}

	return NULL_ACTION;
}

static int Update(SF2_DeathCamAction action, SF2_BaseBoss actor, NextBotAction priorAction)
{
	if (!actor.KillTarget.IsValid())
	{
		return action.Done();
	}

	SF2_BasePlayer player = SF2_BasePlayer(actor.KillTarget.index);
	if (!player.IsValid || !player.IsAlive || player.IsInGhostMode)
	{
		return action.Done();
	}

	return action.Continue();
}

static void OnEnd(SF2_DeathCamAction action, SF2_BaseBoss actor)
{
	if (SF2_ChaserEntity(actor.index).IsValid())
	{
		SF2_ChaserEntity(actor.index).GroundSpeedOverride = false;
	}

	actor.IsKillingSomeone = false;
}

static void OnOtherKilled(SF2_DeathCamAction action, SF2_BaseBoss actor, CBaseCombatCharacter victim, CBaseEntity attacker, CBaseEntity inflictor, float damage, int damagetype)
{
	if (actor.KillTarget.index == victim.index)
	{
		actor.KillTarget = CBaseEntity(-1);
	}
}