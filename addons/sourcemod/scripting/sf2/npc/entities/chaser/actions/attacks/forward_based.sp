#pragma semicolon 1
#pragma newdecls required

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserAttackAction_ForwardBased < NextBotAction
{
	public SF2_ChaserAttackAction_ForwardBased(const char[] attackName, ChaserBossProfileBaseAttack data, float damageDelay)
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_AttackForward");
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetEventCallback(EventResponderType_OnAnimationEvent, OnAnimationEvent);
			g_Factory.BeginDataMapDesc()
				.DefineStringField("m_AttackName")
				.DefineIntField("m_ProfileData")
				.DefineFloatField("m_NextDamageTime")
				.DefineIntField("m_RepeatIndex")
				.EndDataMapDesc();
		}
		SF2_ChaserAttackAction_ForwardBased action = view_as<SF2_ChaserAttackAction_ForwardBased>(g_Factory.Create());

		action.NextDamageTime = damageDelay;
		action.SetAttackName(attackName);
		action.ProfileData = data;

		return action;
	}

	public static void Initialize()
	{
		g_OnChaserGetAttackActionPFwd.AddFunction(null, OnChaserGetAttackAction);
	}

	public char[] GetAttackName()
	{
		char name[128];
		this.GetDataString("m_AttackName", name, sizeof(name));
		return name;
	}

	public void SetAttackName(const char[] name)
	{
		this.SetDataString("m_AttackName", name);
	}

	property ChaserBossProfileBaseAttack ProfileData
	{
		public get()
		{
			return this.GetData("m_ProfileData");
		}

		public set(ChaserBossProfileBaseAttack value)
		{
			this.SetData("m_ProfileData", value);
		}
	}

	property float NextDamageTime
	{
		public get()
		{
			return this.GetDataFloat("m_NextDamageTime");
		}

		public set(float value)
		{
			this.SetDataFloat("m_NextDamageTime", value);
		}
	}

	property int RepeatIndex
	{
		public get()
		{
			return this.GetData("m_RepeatIndex");
		}

		public set(int value)
		{
			this.SetData("m_RepeatIndex", value);
		}
	}
}

static Action OnChaserGetAttackAction(SF2_ChaserEntity chaser, const char[] attackName, NextBotAction &result)
{
	if (result != NULL_ACTION)
	{
		return Plugin_Continue;
	}

	ChaserBossProfile data = chaser.Controller.GetProfileData();
	ChaserBossProfileBaseAttack attackData = data.GetAttack(attackName);
	int difficulty = chaser.Controller.Difficulty;

	if (attackData.Type >= SF2BossAttackType_Melee && attackData.Type <= SF2BossAttackType_Tongue)
	{
		return Plugin_Continue;
	}

	result = SF2_ChaserAttackAction_ForwardBased(attackName, attackData, attackData.GetDelay(difficulty) + GetGameTime());
	return Plugin_Changed;
}

static int Update(SF2_ChaserAttackAction_ForwardBased action, SF2_ChaserEntity actor, float interval)
{
	if (action.Parent == NULL_ACTION)
	{
		return action.Done("No longer forward attacking");
	}

	if (actor.CancelAttack)
	{
		return action.Done();
	}

	SF2NPC_Chaser controller = actor.Controller;
	ChaserBossProfileBaseAttack attackData = action.ProfileData;
	int difficulty = controller.Difficulty;

	float gameTime = GetGameTime();
	if (action.NextDamageTime >= 0.0 && gameTime > action.NextDamageTime && attackData.GetEventNumber(difficulty) == -1)
	{
		RegisterForward(actor);

		int repeatState = attackData.GetRepeatState(difficulty);
		if (repeatState > 0)
		{
			switch (repeatState)
			{
				case 1:
				{
					action.NextDamageTime = gameTime + attackData.GetDelay(difficulty);
				}
				case 2:
				{
					if (attackData.GetRepeatTimer(difficulty, action.RepeatIndex) < 0.0)
					{
						action.NextDamageTime = -1.0;
					}
					else
					{
						action.NextDamageTime = attackData.GetRepeatTimer(difficulty, action.RepeatIndex) + gameTime;
						action.RepeatIndex++;
					}
				}
			}
		}
		else
		{
			action.NextDamageTime = -1.0;
		}
	}
	return action.Continue();
}

static void RegisterForward(SF2_ChaserEntity actor)
{
	Call_StartForward(g_OnBossAttackedFwd);
	Call_PushCell(actor.Controller.Index);
	Call_PushCell(actor.AttackIndex);
	Call_Finish();
}

static void OnAnimationEvent(SF2_ChaserAttackAction_ForwardBased action, SF2_ChaserEntity actor, int event)
{
	if (event == 0)
	{
		return;
	}

	SF2NPC_Chaser controller = actor.Controller;
	ChaserBossProfileBaseAttack attackData = action.ProfileData;

	if (event == attackData.GetEventNumber(controller.Difficulty))
	{
		RegisterForward(actor);
	}
}
