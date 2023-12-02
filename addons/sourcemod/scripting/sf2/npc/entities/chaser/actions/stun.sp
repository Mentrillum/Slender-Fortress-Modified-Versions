#pragma semicolon 1

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

		action.Attacker = attacker.index;
		return action;
	}

	property int Attacker
	{
		public get()
		{
			return this.GetDataEnt("m_Attacker");
		}

		public set(int value)
		{
			this.SetDataEnt("m_Attacker", value);
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
	SF2NPC_BaseNPC baseController = view_as<SF2NPC_BaseNPC>(actor.Controller);
	SF2BossProfileData data;
	INextBot bot = actor.MyNextBotPointer();
	ILocomotion loco = bot.GetLocomotionInterface();
	data = baseController.GetProfileData();
	char animName[64];
	float rate = 1.0, duration = 0.0, cycle = 0.0;
	int difficulty = baseController.Difficulty;
	actor.IsAttemptingToMove = false;
	loco.Stop();

	if (actor.State == STATE_ATTACK)
	{
		actor.CancelAttack = true;
	}

	action.OldState = actor.State;

	actor.IsStunned = true;

	actor.PerformVoice(SF2BossSound_Stun);

	actor.EndCloak();

	if (data.AnimationData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_Stun], difficulty, animName, sizeof(animName), rate, duration, cycle))
	{
		int sequence = actor.SelectProfileAnimation(g_SlenderAnimationsList[SF2BossAnimation_Stun], rate, duration, cycle);
		if (sequence != -1)
		{
			return SF2_PlaySequenceAndWait(sequence, duration, rate, cycle);
		}
	}

	return NULL_ACTION;
}

static int OnStart(SF2_ChaserStunnedAction action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	SF2NPC_Chaser controller = actor.Controller;
	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	if (data.KeyDrop)
	{
		if (SF_IsBoxingMap() && data.DisappearOnStun && data.BoxingBoss && !g_SlenderBoxingBossIsKilled[controller.Index] && !view_as<SF2NPC_BaseNPC>(controller).GetProfileData().IsPvEBoss)
		{
			g_SlenderBoxingBossKilled++;
			if ((g_SlenderBoxingBossKilled == g_SlenderBoxingBossCount))
			{
				NPC_DropKey(controller.Index, data.KeyModel, data.KeyTrigger);
			}
			g_SlenderBoxingBossIsKilled[controller.Index] = true;
		}
		else
		{
			NPC_DropKey(controller.Index, data.KeyModel, data.KeyTrigger);
		}
	}

	actor.DropItem();

	actor.RemoveAllGestures();
	CBaseNPC_RemoveAllLayers(actor.index);

	actor.State = STATE_STUN;

	if (controller.HasAttribute(SF2Attribute_AddStunHealthOnStun))
	{
		actor.MaxStunHealth += controller.GetAttributeValue(SF2Attribute_AddStunHealthOnStun);
	}

	if (controller.HasAttribute(SF2Attribute_AddSpeedOnStun))
	{
		controller.SetAddSpeed(controller.GetAttributeValue(SF2Attribute_AddSpeedOnStun));
	}

	if (controller.HasAttribute(SF2Attribute_AddAccelerationOnStun))
	{
		controller.SetAddAcceleration(controller.GetAttributeValue(SF2Attribute_AddAccelerationOnStun));
	}

	Call_StartForward(g_OnBossStunnedFwd);
	Call_PushCell(actor.Controller.Index);
	Call_PushCell(action.Attacker);
	Call_Finish();

	return action.Continue();
}

static int Update(SF2_ChaserStunnedAction action, SF2_ChaserEntity actor, float interval)
{
	if (action.ActiveChild != NULL_ACTION)
	{
		return action.Continue();
	}

	if (actor.Controller.GetProfileData().DisappearOnStun)
	{
		actor.Controller.UnSpawn();
	}
	return action.Done("I am no longer stunned");
}

static int OnSuspend(SF2_ChaserStunnedAction action, SF2_ChaserEntity actor, NextBotAction interruptingAction)
{
	return action.Done();
}

static void OnEnd(SF2_ChaserStunnedAction action, SF2_ChaserEntity actor)
{
	actor.IsStunned = false;
	actor.StunHealth = actor.MaxStunHealth;
	if (actor.Controller.IsValid())
	{
		actor.NextStunTime = GetGameTime() + actor.Controller.GetProfileData().StunCooldown[actor.Controller.Difficulty];

		actor.UpdateMovementAnimation();
	}
	actor.WasStunned = true;
	actor.State = action.OldState;
}