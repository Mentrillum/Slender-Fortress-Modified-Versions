#pragma semicolon 1
#pragma newdecls required

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserStunnedAction < NextBotAction
{
	public SF2_ChaserStunnedAction(CBaseEntity attacker = view_as<CBaseEntity>(-1))
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_Stunned");
			g_Factory.SetCallback(NextBotActionCallbackType_InitialContainedAction, InitialContainedAction);
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetCallback(NextBotActionCallbackType_OnSuspend, OnSuspend);
			g_Factory.SetCallback(NextBotActionCallbackType_OnEnd, OnEnd);
			g_Factory.BeginDataMapDesc()
				.DefineEntityField("m_Attacker")
				.DefineIntField("m_OldState")
				.EndDataMapDesc();
		}
		SF2_ChaserStunnedAction action = view_as<SF2_ChaserStunnedAction>(g_Factory.Create());

		action.Attacker = attacker;
		return action;
	}

	property CBaseEntity Attacker
	{
		public get()
		{
			return CBaseEntity(EntRefToEntIndex(this.GetDataEnt("m_Attacker")));
		}

		public set(CBaseEntity value)
		{
			this.SetDataEnt("m_Attacker", EnsureEntRef(value.index));
		}
	}

	property int OldState
	{
		public get()
		{
			return this.GetData("m_OldState");
		}

		public set(int value)
		{
			this.SetData("m_OldState", value);
		}
	}
}

static NextBotAction InitialContainedAction(SF2_ChaserStunnedAction action, SF2_ChaserEntity actor)
{
	INextBot bot = actor.MyNextBotPointer();
	ILocomotion loco = bot.GetLocomotionInterface();
	actor.IsAttemptingToMove = false;
	loco.Stop();

	if (actor.State == STATE_ATTACK)
	{
		actor.CancelAttack = true;
	}

	action.OldState = actor.State;
	actor.PreviousState = actor.State;

	actor.IsStunned = true;

	actor.PerformVoice(SF2BossSound_Stun);

	actor.EndCloak();
	char posture[64];
	actor.GetPosture(posture, sizeof(posture));

	ChaserBossProfile data = actor.Controller.GetProfileData();
	if (data.GetAnimations().HasAnimationSection(g_SlenderAnimationsList[SF2BossAnimation_Stun]))
	{
		return SF2_PlaySequenceAndWaitEx(g_SlenderAnimationsList[SF2BossAnimation_Stun]);
	}

	return NULL_ACTION;
}

static int OnStart(SF2_ChaserStunnedAction action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	SF2NPC_Chaser controller = actor.Controller;
	ChaserBossProfile data = controller.GetProfileData();
	ChaserBossProfileChaseData chaseData = data.GetChaseBehavior();
	ChaserBossProfileStunData stunData = data.GetStunBehavior();
	int difficulty = controller.Difficulty;

	if (stunData.GetOnStartEffects() != null)
	{
		float pos[3], ang[3];
		actor.GetAbsOrigin(pos);
		actor.GetAbsAngles(ang);
		SlenderSpawnEffects(stunData.GetOnStartEffects(), controller.Index, false, pos, ang, _, _, false);
	}

	if (stunData.GetOnStartInputs() != null)
	{
		stunData.GetOnStartInputs().AcceptInputs(actor.index, action.Attacker.index, action.Attacker.index);
	}

	if (stunData.KeyDrop)
	{
		char model[PLATFORM_MAX_PATH], trigger[64];
		stunData.GetKeyModel(model, sizeof(model));
		stunData.GetKeyTrigger(trigger, sizeof(trigger));
		if (SF_IsBoxingMap() && stunData.ShouldDisappear(difficulty) && data.BoxingBoss && !g_SlenderBoxingBossIsKilled[controller.Index] && data.IsPvEBoss)
		{
			g_SlenderBoxingBossKilled++;
			if ((g_SlenderBoxingBossKilled == g_SlenderBoxingBossCount))
			{
				NPC_DropKey(controller.Index, model, trigger);
			}
			g_SlenderBoxingBossIsKilled[controller.Index] = true;
		}
		else
		{
			NPC_DropKey(controller.Index, model, trigger);
		}
	}

	actor.DropItem();

	actor.RemoveAllGestures();
	CBaseNPC_RemoveAllLayers(actor.index);

	if (actor.State == STATE_CHASE)
	{
		actor.CurrentChaseDuration += chaseData.GetDurationAddOnStunned(difficulty);
		if (actor.CurrentChaseDuration > chaseData.GetMaxChaseDuration(difficulty))
		{
			actor.CurrentChaseDuration = chaseData.GetMaxChaseDuration(difficulty);
		}
	}

	actor.State = STATE_STUN;

	if (controller.HasAttribute(SF2Attribute_AddStunHealthOnStun))
	{
		actor.MaxStunHealth += controller.GetAttributeValue(SF2Attribute_AddStunHealthOnStun);
	}
	else
	{
		actor.MaxStunHealth += stunData.GetAddHealthPerStun(difficulty);
	}

	if (controller.HasAttribute(SF2Attribute_AddSpeedOnStun))
	{
		controller.SetAddSpeed(controller.GetAttributeValue(SF2Attribute_AddSpeedOnStun));
	}
	else
	{
		controller.SetAddSpeed(stunData.GetAddRunSpeed(difficulty));
	}

	if (controller.HasAttribute(SF2Attribute_AddAccelerationOnStun))
	{
		controller.SetAddAcceleration(controller.GetAttributeValue(SF2Attribute_AddAccelerationOnStun));
	}
	else
	{
		controller.SetAddAcceleration(stunData.GetAddAcceleration(difficulty));
	}

	actor.GroundSpeedOverride = true;

	Call_StartForward(g_OnBossStunnedFwd);
	Call_PushCell(actor.Controller.Index);
	Call_PushCell(action.Attacker.index);
	Call_Finish();

	return action.Continue();
}

static int Update(SF2_ChaserStunnedAction action, SF2_ChaserEntity actor, float interval)
{
	if (action.ActiveChild != NULL_ACTION)
	{
		return action.Continue();
	}

	if (actor.Controller.GetProfileData().GetStunBehavior().ShouldDisappear(actor.Controller.Difficulty))
	{
		actor.Controller.UnSpawn(true);
	}
	return action.Done("I am no longer stunned");
}

static int OnSuspend(SF2_ChaserStunnedAction action, SF2_ChaserEntity actor, NextBotAction interruptingAction)
{
	return action.Done();
}

static void OnEnd(SF2_ChaserStunnedAction action, SF2_ChaserEntity actor)
{
	SF2NPC_Chaser controller = actor.Controller;

	if (!controller.IsValid())
	{
		return;
	}

	ChaserBossProfile data = controller.GetProfileData();
	ChaserBossProfileStunData stunData = data.GetStunBehavior();

	if (stunData.GetOnEndEffects() != null)
	{
		float pos[3], ang[3];
		actor.GetAbsOrigin(pos);
		actor.GetAbsAngles(ang);
		SlenderSpawnEffects(stunData.GetOnEndEffects(), controller.Index, false, pos, ang, _, _, false);
	}

	if (stunData.GetOnEndInputs() != null)
	{
		stunData.GetOnEndInputs().AcceptInputs(actor.index, action.Attacker.index, action.Attacker.index);
	}

	actor.IsStunned = false;
	actor.GroundSpeedOverride = false;
	actor.StunHealth = actor.MaxStunHealth;

	actor.NextStunTime = GetGameTime() + stunData.GetCooldown(actor.Controller.Difficulty);

	actor.UpdateMovementAnimation();

	actor.WasStunned = true;
	actor.State = action.OldState;

	if (actor.State == STATE_IDLE && action.Attacker.IsValid())
	{
		float pos[3];
		action.Attacker.GetAbsOrigin(pos);
		actor.SetAlertTriggerPositionEx(pos);
		actor.QueueForAlertState = true;
	}
}