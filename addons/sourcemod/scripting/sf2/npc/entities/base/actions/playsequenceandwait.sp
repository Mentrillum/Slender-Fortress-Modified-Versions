#pragma semicolon 1

static NextBotActionFactory g_Factory;

methodmap SF2_PlaySequenceAndWait < NextBotAction
{
	public SF2_PlaySequenceAndWait(int sequence, float duration = 0.0, float rate = 1.0, float cycle = 0.0)
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("SF2_PlaySequenceAndWait");
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetCallback(NextBotActionCallbackType_OnSuspend, OnSuspend);
			g_Factory.BeginDataMapDesc()
				.DefineIntField("m_Sequence")
				.DefineFloatField("m_Duration")
				.DefineFloatField("m_Rate")
				.DefineFloatField("m_Cycle")
				.DefineFloatField("m_EndTime")
				.EndDataMapDesc();
		}

		SF2_PlaySequenceAndWait action = view_as<SF2_PlaySequenceAndWait>(g_Factory.Create());

		action.Sequence = sequence;
		action.Duration = duration;
		action.Rate = rate;
		action.Cycle = cycle;

		return action;
	}

	public static void SetupAPI()
	{
		CreateNative("SF2_PlaySequenceAndWaitAction.SF2_PlaySequenceAndWaitAction", Native_Create);
	}

	property int Sequence
	{
		public get()
		{
			return this.GetData("m_Sequence");
		}

		public set(int value)
		{
			this.SetData("m_Sequence", value);
		}
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

	property float Rate
	{
		public get()
		{
			return this.GetDataFloat("m_Rate");
		}

		public set(float value)
		{
			this.SetDataFloat("m_Rate", value);
		}
	}

	property float Cycle
	{
		public get()
		{
			return this.GetDataFloat("m_Cycle");
		}

		public set(float value)
		{
			this.SetDataFloat("m_Cycle", value);
		}
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

static int OnStart(SF2_PlaySequenceAndWait action, SF2_BaseBoss actor, NextBotAction priorAction)
{
	if (action.Sequence == -1)
	{
		return action.Done("Invalid sequence");
	}

	actor.ResetSequence(action.Sequence);
	actor.SetPropFloat(Prop_Send, "m_flCycle", action.Cycle);
	actor.SetPropFloat(Prop_Send, "m_flPlaybackRate", action.Rate);

	float duration = action.Duration;
	if (duration <= 0.0)
	{
		duration = actor.SequenceDuration(action.Sequence) / action.Rate;
		duration *= (1.0 - action.Cycle);
	}

	if (SF2_ChaserEntity(actor.index).IsValid())
	{
		SF2_ChaserEntity(actor.index).GroundSpeedOverride = true;
	}

	action.EndTime = GetGameTime() + duration;

	return action.Continue();
}

static int Update(SF2_PlaySequenceAndWait action, SF2_BaseBoss actor, float interval)
{
	if (GetGameTime() > action.EndTime)
	{
		if (SF2_ChaserEntity(actor.index).IsValid())
		{
			SF2_ChaserEntity(actor.index).GroundSpeedOverride = false;
		}
		return action.Done();
	}

	return action.Continue();
}

static int OnSuspend(SF2_PlaySequenceAndWait action, SF2_BaseBoss actor, NextBotAction interruptingAction)
{
	return action.Done();
}

static any Native_Create(Handle plugin, int numParams)
{
	int sequence = GetNativeCell(1);
	float duration = GetNativeCell(2);
	float rate = GetNativeCell(3);
	float cycle = GetNativeCell(4);

	return SF2_PlaySequenceAndWait(sequence, duration, rate, cycle);
}