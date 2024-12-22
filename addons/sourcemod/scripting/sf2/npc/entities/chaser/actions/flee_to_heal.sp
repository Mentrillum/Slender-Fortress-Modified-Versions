#pragma semicolon 1
#pragma newdecls required

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserFleeToHealAction < NextBotAction
{
	public SF2_ChaserFleeToHealAction()
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_FleeToHeal");
			g_Factory.SetCallback(NextBotActionCallbackType_InitialContainedAction, InitialContainedAction);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetEventCallback(EventResponderType_OnMoveToSuccess, OnMoveToSuccess);
			g_Factory.SetEventCallback(EventResponderType_OnMoveToFailure, OnMoveToFailure);
			g_Factory.BeginDataMapDesc()
				.DefineFloatField("m_FleeTime")
				.DefineFloatField("m_HealTime")
				.DefineFloatField("m_HealDuration")
				.DefineBoolField("m_HasPath")
				.DefineBoolField("m_IsHealing")
				.DefineBoolField("m_PlayedAnimation")
				.DefineFloatField("m_HealAnimationDuration")
				.DefineBoolField("m_PlayedSound")
				.EndDataMapDesc();
		}
		return view_as<SF2_ChaserFleeToHealAction>(g_Factory.Create());
	}

	property float FleeTime
	{
		public get()
		{
			return this.GetDataFloat("m_FleeTime");
		}

		public set(float value)
		{
			this.SetDataFloat("m_FleeTime", value);
		}
	}

	property float HealTime
	{
		public get()
		{
			return this.GetDataFloat("m_HealTime");
		}

		public set(float value)
		{
			this.SetDataFloat("m_HealTime", value);
		}
	}

	property float HealDuration
	{
		public get()
		{
			return this.GetDataFloat("m_HealDuration");
		}

		public set(float value)
		{
			this.SetDataFloat("m_HealDuration", value);
		}
	}

	property bool HasPath
	{
		public get()
		{
			return this.GetData("m_HasPath") != 0;
		}

		public set(bool value)
		{
			this.SetData("m_HasPath", value);
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

	property bool PlayedAnimation
	{
		public get()
		{
			return this.GetData("m_PlayedAnimation") != 0;
		}

		public set(bool value)
		{
			this.SetData("m_PlayedAnimation", value);
		}
	}

	property float HealAnimationDuration
	{
		public get()
		{
			return this.GetDataFloat("m_HealAnimationDuration");
		}

		public set(float value)
		{
			this.SetDataFloat("m_HealAnimationDuration", value);
		}
	}

	property bool PlayedSound
	{
		public get()
		{
			return this.GetData("m_PlayedSound") != 0;
		}

		public set(bool value)
		{
			this.SetData("m_PlayedSound", value);
		}
	}
}

static NextBotAction InitialContainedAction(SF2_ChaserFleeToHealAction action, SF2_ChaserEntity actor)
{
	SF2NPC_Chaser controller = actor.Controller;
	ChaserBossProfile data = controller.GetProfileDataEx();
	char name[64];
	data.GetRages().GetSectionNameFromIndex(actor.RageIndex, name, sizeof(name));
	ChaserBossProfileRageData rageData = view_as<ChaserBossProfileRageData>(data.GetRages().GetSection(name));
	action.HealDuration = rageData.HealDuration;
	action.HealTime = rageData.HealDelay;
	char animName[64];
	float rate = 1.0, duration = 0.0, cycle = 0.0;
	int difficulty = controller.Difficulty;
	action.IsHealing = false;
	action.HasPath = false;
	action.FleeTime = GetRandomFloat(5.0, 10.0);
	ProfileAnimation section = rageData.GetAnimations().GetAnimation("start");
	if (section != null)
	{
		section.GetAnimationName(difficulty, animName, sizeof(animName));
		rate = section.GetAnimationPlaybackRate(difficulty);
		duration = section.GetDuration(difficulty);
		cycle = section.GetAnimationCycle(difficulty);
		int sequence = LookupProfileAnimation(actor.index, animName);
		if (sequence != -1)
		{
			return SF2_PlaySequenceAndWait(sequence, duration, rate, cycle);
		}
	}

	return NULL_ACTION;
}

static int Update(SF2_ChaserFleeToHealAction action, SF2_ChaserEntity actor, float interval)
{
	if (action.ActiveChild != NULL_ACTION)
	{
		return action.Continue();
	}

	INextBot bot = actor.MyNextBotPointer();
	ILocomotion loco = bot.GetLocomotionInterface();
	SF2NPC_Chaser controller = actor.Controller;
	ChaserBossProfile data = controller.GetProfileDataEx();
	char name[64];
	data.GetRages().GetSectionNameFromIndex(actor.RageIndex, name, sizeof(name));
	ChaserBossProfileRageData rageData = view_as<ChaserBossProfileRageData>(data.GetRages().GetSection(name));
	PathFollower path = controller.Path;
	int difficulty = controller.Difficulty;
	float gameTime = GetGameTime();

	if (!action.IsHealing && !action.HasPath)
	{
		actor.IsRunningAway = true;
		if (rageData.HealCloak)
		{
			actor.StartCloak();
		}
		CNavArea area = actor.GetLastKnownArea();
		SurroundingAreasCollector collector = TheNavMesh.CollectSurroundingAreas(area, GetRandomFloat(rageData.FleeMinRange, rageData.FleeMaxRange));
		int areaCount = collector.Count();
		ArrayList areaArray = new ArrayList(1, areaCount);
		int validAreaCount = 0;
		for (int i = 0; i < areaCount; i++)
		{
			float navPos[3], myPos[3];
			collector.Get(i).GetCenter(navPos);
			actor.GetAbsOrigin(myPos);
			if (GetVectorSquareMagnitude(navPos, myPos) <= Pow(256.0, 2.0))
			{
				continue;
			}
			areaArray.Set(validAreaCount, i);
			validAreaCount++;
		}

		if (validAreaCount > 0)
		{
			float wanderPos[3];
			CNavArea wanderArea = collector.Get(areaArray.Get(GetRandomInt(0, validAreaCount - 1)));

			if (wanderArea != NULL_AREA)
			{
				wanderArea.GetCenter(wanderPos);

				path.ComputeToPos(bot, wanderPos);

				action.HasPath = true;
			}
		}

		delete collector;
		delete areaArray;
	}

	if (!path.IsValid())
	{
		loco.Stop();
		actor.IsAttemptingToMove = false;
	}
	else
	{
		path.Update(bot);
		actor.IsAttemptingToMove = true;
	}

	if (action.IsHealing)
	{
		if (!action.PlayedAnimation)
		{
			char animName[64];
			float rate = 1.0, cycle = 0.0;
			ProfileAnimation section = rageData.GetAnimations().GetAnimation("healing");
			if (section != null)
			{
				section.GetAnimationName(difficulty, animName, sizeof(animName));
				action.HealAnimationDuration = section.GetDuration(difficulty);
				rate = section.GetAnimationPlaybackRate(difficulty);
				cycle = section.GetAnimationCycle(difficulty);
				int sequence = LookupProfileAnimation(actor.index, animName);
				if (sequence != -1)
				{
					action.HealAnimationDuration = actor.SequenceDuration(sequence) / rate;
					action.HealAnimationDuration *= (1.0 - cycle);
					actor.ResetSequence(sequence);
					actor.SetPropFloat(Prop_Send, "m_flCycle", cycle);
					actor.SetPropFloat(Prop_Send, "m_flPlaybackRate", rate);
				}
			}
			action.HealAnimationDuration += gameTime;
			action.PlayedAnimation = true;
		}

		action.HealTime -= GetGameFrameTime();
		if (action.HealTime <= 0.0 && action.HealDuration > 0.0)
		{
			if (!action.PlayedSound)
			{
				actor.PerformVoiceEx(_, _, rageData.GetHealSounds(), true);
				action.PlayedSound = true;
			}
			float amount = actor.MaxHealth * rageData.HealAmount;
			if (!data.GetDeathBehavior().IsEnabled(difficulty))
			{
				amount = actor.MaxStunHealth * rageData.HealAmount;
			}
			float increase = LerpFloats(0.0, amount, GetGameFrameTime() * (1.0 / rageData.HealDuration));
			if (data.GetDeathBehavior().IsEnabled(difficulty))
			{
				actor.SetProp(Prop_Data, "m_iHealth", RoundToFloor(increase + actor.GetProp(Prop_Data, "m_iHealth")));
				if (float(actor.GetProp(Prop_Data, "m_iHealth")) > actor.MaxHealth)
				{
					actor.SetProp(Prop_Data, "m_iHealth", RoundToFloor(actor.MaxHealth));
				}
			}
			else
			{
				actor.StunHealth += increase;
				if (actor.StunHealth > actor.MaxStunHealth)
				{
					actor.StunHealth = actor.MaxStunHealth;
				}
			}
			if (data.Healthbar)
			{
				UpdateHealthBar(controller.Index);
				SetHealthBarColor(true);
			}
			action.HealDuration -= GetGameFrameTime();
		}

		if (action.HealAnimationDuration < gameTime)
		{
			actor.IsSelfHealing = false;
			SetHealthBarColor(false);
			return action.Done();
		}
	}

	if (!action.IsHealing)
	{
		action.FleeTime -= GetGameFrameTime();
		if (action.FleeTime <= 0.0)
		{
			path.Invalidate();
			actor.EndCloak();
			actor.IsRunningAway = false;
			action.IsHealing = true;
			actor.IsSelfHealing = true;
		}
	}

	return action.Continue();
}

static void OnMoveToSuccess(SF2_ChaserFleeToHealAction action, SF2_ChaserEntity actor, Path path)
{
	actor.EndCloak();
	actor.IsRunningAway = false;
	action.IsHealing = true;
	actor.IsSelfHealing = true;
}

static void OnMoveToFailure(SF2_ChaserFleeToHealAction action, SF2_ChaserEntity actor, Path path, MoveToFailureType reason)
{
	actor.EndCloak();
	actor.IsRunningAway = false;
	action.IsHealing = true;
	actor.IsSelfHealing = true;
}
