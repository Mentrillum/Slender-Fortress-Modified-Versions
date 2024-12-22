#pragma semicolon 1
#pragma newdecls required

static NextBotActionFactory g_Factory;

methodmap SF2_PlaySequenceAndWaitEx < NextBotAction
{
	public SF2_PlaySequenceAndWaitEx(char[] section)
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("SF2_PlaySequenceAndWaitEx");
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetCallback(NextBotActionCallbackType_OnSuspend, OnSuspend);
			g_Factory.SetCallback(NextBotActionCallbackType_OnEnd, OnEnd);
			g_Factory.BeginDataMapDesc()
				.DefineStringField("m_Section")
				.DefineFloatField("m_EndTime")
				.EndDataMapDesc();
		}

		SF2_PlaySequenceAndWaitEx action = view_as<SF2_PlaySequenceAndWaitEx>(g_Factory.Create());

		action.SetSection(section);

		return action;
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
	if (!actor.ResetProfileAnimation(action.GetSection(), .sequence = sequence, .duration = duration, .rate = rate, .cycle = cycle))
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