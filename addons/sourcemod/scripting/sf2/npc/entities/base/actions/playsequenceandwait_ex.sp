#pragma semicolon 1
#pragma newdecls required

static NextBotActionFactory g_Factory;

methodmap SF2_PlaySequenceAndWaitEx < NextBotAction
{
	public SF2_PlaySequenceAndWaitEx(const char[] section, const char[] preDefinedName = "", ProfileMasterAnimations animations = null)
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("SF2_PlaySequenceAndWaitEx");
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetCallback(NextBotActionCallbackType_OnSuspend, OnSuspend);
			g_Factory.SetCallback(NextBotActionCallbackType_OnEnd, OnEnd);
			g_Factory.BeginDataMapDesc()
				.DefineIntField("m_Animations")
				.DefineStringField("m_Section")
				.DefineStringField("m_PreDefinedName")
				.DefineFloatField("m_EndTime")
				.EndDataMapDesc();
		}

		SF2_PlaySequenceAndWaitEx action = view_as<SF2_PlaySequenceAndWaitEx>(g_Factory.Create());

		action.Animations = animations;
		action.SetSection(section);
		action.SetPreDefinedName(preDefinedName);

		return action;
	}

	property ProfileMasterAnimations Animations
	{
		public get()
		{
			return this.GetData("m_Animations");
		}

		public set(ProfileMasterAnimations value)
		{
			this.SetData("m_Animations", value);
		}
	}

	public char[] GetSection()
	{
		char name[128];
		this.GetDataString("m_Section", name, sizeof(name));
		return name;
	}

	public void SetSection(const char[] name)
	{
		this.SetDataString("m_Section", name);
	}

	public char[] GetPreDefinedName()
	{
		char name[128];
		this.GetDataString("m_PreDefinedName", name, sizeof(name));
		return name;
	}

	public void SetPreDefinedName(const char[] name)
	{
		this.SetDataString("m_PreDefinedName", name);
	}

	property float EndTime
	{
		public get()
		{
			return this.GetDataFloat("m_EndTime");
		}

		public set(float value)
		{
			this.SetDataFloat("m_EndTime", value);
		}
	}
}

static int OnStart(SF2_PlaySequenceAndWaitEx action, SF2_BaseBoss actor, NextBotAction priorAction)
{
	float duration = 0.0, cycle = 0.0, rate = 1.0;
	int sequence = -1;
	ProfileMasterAnimations animations = action.Animations;
	if (!actor.ResetProfileAnimation(action.GetSection(), .preDefinedName = animations == null ? action.GetPreDefinedName() : "", .sequence = sequence, .duration = duration, .rate = rate, .cycle = cycle, .animations = animations))
	{
		return action.Done("Invalid section");
	}

	if (duration <= 0.0)
	{
		duration = actor.SequenceDuration(sequence) / rate;
		duration *= (1.0 - cycle);
	}

	if (SF2_ChaserEntity(actor.index).IsValid())
	{
		SF2_ChaserEntity(actor.index).GroundSpeedOverride = true;
	}

	action.EndTime = GetGameTime() + duration;

	return action.Continue();
}

static int Update(SF2_PlaySequenceAndWaitEx action, SF2_BaseBoss actor, float interval)
{
	if (GetGameTime() > action.EndTime)
	{
		return action.Done();
	}

	return action.Continue();
}

static int OnSuspend(SF2_PlaySequenceAndWaitEx action, SF2_BaseBoss actor, NextBotAction interruptingAction)
{
	return action.Done();
}

static void OnEnd(SF2_PlaySequenceAndWaitEx action, SF2_ChaserEntity actor)
{
	if (SF2_ChaserEntity(actor.index).IsValid())
	{
		SF2_ChaserEntity(actor.index).GroundSpeedOverride = false;
	}
}