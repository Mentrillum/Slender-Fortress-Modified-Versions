#pragma semicolon 1

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserRageAction < NextBotAction
{
	public SF2_ChaserRageAction()
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_Rage");
			g_Factory.SetCallback(NextBotActionCallbackType_InitialContainedAction, InitialContainedAction);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetCallback(NextBotActionCallbackType_OnEnd, OnEnd);
			g_Factory.BeginDataMapDesc()
				.DefineBoolField("m_HasRaged")
				.DefineBoolField("m_IsHealing")
				.EndDataMapDesc();
		}
		return view_as<SF2_ChaserRageAction>(g_Factory.Create());
	}

	property bool HasRaged
	{
		public get()
		{
			return this.GetData("m_HasRaged") != 0;
		}

		public set(bool value)
		{
			this.SetData("m_HasRaged", value);
		}
	}

	property bool IsHealing
	{
		public get()
		{
			return this.GetData("m_IsHealing") != 0;
		}

		public set(bool value)
		{
			this.SetData("m_IsHealing", value);
		}
	}
}

static NextBotAction InitialContainedAction(SF2_ChaserRageAction action, SF2_ChaserEntity actor)
{
	actor.RageIndex++;
	SF2NPC_Chaser controller = actor.Controller;
	SF2ChaserBossProfileData data;
	INextBot bot = actor.MyNextBotPointer();
	ILocomotion loco = bot.GetLocomotionInterface();
	data = controller.GetProfileData();
	SF2ChaserRageInfo rageInfo;
	data.Rages.GetArray(actor.RageIndex, rageInfo, sizeof(rageInfo));
	char animName[64];
	float rate = 1.0, duration = 0.0, cycle = 0.0;
	int difficulty = controller.Difficulty;
	actor.IsAttemptingToMove = false;
	loco.Stop();
	controller.Path.Invalidate();

	actor.IsRaging = true;

	actor.OverrideInvincible = rageInfo.Invincible;

	actor.PerformVoiceEx(_, _, rageInfo.StartSounds, true);

	actor.EndCloak();

	if (actor.State == STATE_ATTACK)
	{
		actor.CancelAttack = true;
	}

	if (rageInfo.IsHealing)
	{
		SetHealthBarColor(true);
		action.IsHealing = true;
		actor.IsGoingToHeal = true;
		return SF2_ChaserFleeToHealAction();
	}

	if (rageInfo.Animations.GetAnimation("start", difficulty, animName, sizeof(animName), rate, duration, cycle))
	{
		int sequence = LookupProfileAnimation(actor.index, animName);
		if (sequence != -1)
		{
			return SF2_PlaySequenceAndWait(sequence, duration, rate, cycle);
		}
	}

	return NULL_ACTION;
}

static int Update(SF2_ChaserRageAction action, SF2_ChaserEntity actor, float interval)
{
	if (action.ActiveChild != NULL_ACTION)
	{
		if (!action.IsHealing)
		{
			CBaseEntity target = actor.Target;
			if (target.IsValid())
			{
				float pos[3];
				target.GetAbsOrigin(pos);
				actor.MyNextBotPointer().GetLocomotionInterface().FaceTowards(pos);
			}
		}
		return action.Continue();
	}

	return action.Done("I am no longer raging");
}

static void OnEnd(SF2_ChaserRageAction action, SF2_ChaserEntity actor)
{
	actor.IsRaging = false;
	actor.OverrideInvincible = false;
	actor.IsGoingToHeal = false;
	if (actor.Controller.IsValid())
	{
		SF2ChaserBossProfileData data;
		data = actor.Controller.GetProfileData();
		SF2ChaserRageInfo rageInfo;
		data.Rages.GetArray(actor.RageIndex, rageInfo, sizeof(rageInfo));
		if (rageInfo.IncreaseDifficulty)
		{
			actor.Controller.Difficulty += 1;
			if (actor.Controller.Difficulty > Difficulty_Apollyon)
			{
				actor.Controller.Difficulty = Difficulty_Apollyon;
			}
		}
		actor.UpdateMovementAnimation();
	}
}
