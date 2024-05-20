#pragma semicolon 1

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserBeatBoxFreezeAction < NextBotAction
{
	public SF2_ChaserBeatBoxFreezeAction(bool wasMoving)
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_BeatboxFreeze");
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetCallback(NextBotActionCallbackType_OnEnd, OnEnd);
			g_Factory.BeginDataMapDesc()
				.DefineFloatField("m_EndDelay")
				.DefineBoolField("m_WasMoving")
				.EndDataMapDesc();
		}
		SF2_ChaserBeatBoxFreezeAction action = view_as<SF2_ChaserBeatBoxFreezeAction>(g_Factory.Create());
		action.WasMoving = wasMoving;
		return action;
	}

	property float EndDelay
	{
		public get()
		{
			return this.GetDataFloat("m_EndDelay");
		}

		public set(float value)
		{
			this.SetDataFloat("m_EndDelay", value);
		}
	}

	property bool WasMoving
	{
		public get()
		{
			return this.GetData("m_WasMoving") != 0;
		}

		public set(bool value)
		{
			this.SetData("m_WasMoving", value);
		}
	}
}

static int OnStart(SF2_ChaserBeatBoxFreezeAction action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	INextBot bot = actor.MyNextBotPointer();
	actor.IsAttemptingToMove = false;
	if (action.WasMoving)
	{
		actor.UpdateMovementAnimation();
	}

	bot.GetLocomotionInterface().Stop();

	action.EndDelay = GetGameTime() + 0.5;

	return action.Continue();
}

static int Update(SF2_ChaserBeatBoxFreezeAction action, SF2_ChaserEntity actor, float interval)
{
	float gameTime = GetGameTime();
	if (IsBeatBoxBeating())
	{
		action.EndDelay = gameTime + 0.5;
	}

	if (action.EndDelay < gameTime)
	{
		return action.Done("I'm done being frozen from Beatbox.");
	}

	return action.Continue();
}

static void OnEnd(SF2_ChaserBeatBoxFreezeAction action, SF2_ChaserEntity actor)
{
	actor.IsAttemptingToMove = action.WasMoving;
	actor.UpdateMovementAnimation();
}