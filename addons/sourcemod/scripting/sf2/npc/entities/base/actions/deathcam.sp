#pragma semicolon 1
#pragma newdecls required

static NextBotActionFactory g_Factory;

methodmap SF2_DeathCamAction < NextBotAction
{
	public SF2_DeathCamAction()
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("SF2_Deathcam");
			g_Factory.BeginDataMapDesc()
				.DefineFloatField("m_Duration")
				.EndDataMapDesc();
			g_Factory.SetCallback(NextBotActionCallbackType_InitialContainedAction, InitialContainedAction);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetCallback(NextBotActionCallbackType_OnEnd, OnEnd);
			g_Factory.SetEventCallback(EventResponderType_OnOtherKilled, OnOtherKilled);
		}
		return view_as<SF2_DeathCamAction>(g_Factory.Create());
	}

	property float Duration
	{
		public get()
		{
			return this.GetDataFloat("m_Duration");
		}

		public set(float value)
		{
			this.SetDataFloat("m_Duration", value);
		}
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
	int difficulty = controller.Difficulty;
	SF2BossProfileData data;
	data = controller.GetProfileData();
	SF2BossProfileSoundInfo info;
	info = data.LocalDeathCamSounds;
	info.EmitSound(_, actor.index);
	SF2BossProfileDeathCamData deathCamData;
	deathCamData = data.DeathCamData;
	SF2BossProfileMasterAnimationsData animations;
	animations = deathCamData.Animations;
	char animation[64];
	if (!animations.GetAnimation("start", difficulty, animation, sizeof(animation), rate, duration, cycle))
	{
		animations = data.AnimationData;
		if (!animations.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_DeathCam], difficulty, animation, sizeof(animation), rate, duration, cycle))
		{
			return NULL_ACTION;
		}
	}

	int sequence = actor.LookupSequence(animation);
	if (sequence == -1)
	{
		return NULL_ACTION;
	}

	if (duration <= 0.0)
	{
		duration = actor.SequenceDuration(sequence) / rate;
		duration *= (1.0 - cycle);
	}
	action.Duration = duration;
	return SF2_PlaySequenceAndWait(sequence, duration, rate, cycle);
}

static int Update(SF2_DeathCamAction action, SF2_BaseBoss actor, float interval)
{
	if (actor.FullDeathCamDuration)
	{
		action.Duration -= interval;
		if (action.Duration > 0.0)
		{
			return action.Continue();
		}
	}

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
	actor.MyNextBotPointer().GetLocomotionInterface().ClearStuckStatus();
	actor.IsKillingSomeone = false;
	actor.FullDeathCamDuration = false;
	if (!actor.Controller.IsValid())
	{
		return;
	}
	SF2NPC_BaseNPC controller = actor.Controller;
	SF2BossProfileData data;
	data = controller.GetProfileData();
	SF2BossProfileDeathCamData deathCamData;
	deathCamData = data.DeathCamData;
	if (deathCamData.StopSounds)
	{
		SF2BossProfileSoundInfo soundInfo;
		soundInfo = data.LocalDeathCamSounds;
		soundInfo.StopAllSounds(actor.index);
	}
}

static void OnOtherKilled(SF2_DeathCamAction action, SF2_BaseBoss actor, CBaseCombatCharacter victim, CBaseEntity attacker, CBaseEntity inflictor, float damage, int damagetype)
{
	if (actor.KillTarget.index == victim.index)
	{
		actor.KillTarget = CBaseEntity(-1);
	}
}