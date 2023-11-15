#pragma semicolon 1

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserAttackAction_ForwardBased < NextBotAction
{
	public SF2_ChaserAttackAction_ForwardBased(int attackIndex, const char[] attackName, float damageDelay)
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_AttackForward");
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetEventCallback(EventResponderType_OnAnimationEvent, OnAnimationEvent);
			g_Factory.BeginDataMapDesc()
				.DefineIntField("m_AttackIndex")
				.DefineStringField("m_AttackName")
				.DefineFloatField("m_NextDamageTime")
				.DefineIntField("m_RepeatIndex")
				.EndDataMapDesc();
		}
		SF2_ChaserAttackAction_ForwardBased action = view_as<SF2_ChaserAttackAction_ForwardBased>(g_Factory.Create());

		action.NextDamageTime = damageDelay;
		action.AttackIndex = attackIndex;
		action.SetAttackName(attackName);

		return action;
	}

	property int AttackIndex
	{
		public get()
		{
			return this.GetData("m_AttackIndex");
		}

		public set(int value)
		{
			this.SetData("m_AttackIndex", value);
		}
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

	SF2ChaserBossProfileData data;
	data = chaser.Controller.GetProfileData();
	SF2ChaserBossProfileAttackData attackData;
	data.GetAttack(attackName, attackData);
	int difficulty = chaser.Controller.Difficulty;

	if (attackData.Type >= SF2BossAttackType_Melee && attackData.Type <= SF2BossAttackType_Tongue)
	{
		return Plugin_Continue;
	}

	result = SF2_ChaserAttackAction_ForwardBased(attackData.Index, attackData.Name, attackData.DamageDelay[difficulty] + GetGameTime());
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
	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	SF2ChaserBossProfileAttackData attackData;
	data.GetAttack(action.GetAttackName(), attackData);
	int difficulty = controller.Difficulty;

	float gameTime = GetGameTime();
	if (action.NextDamageTime >= 0.0 && gameTime > action.NextDamageTime && attackData.EventNumber == -1)
	{
		RegisterForward(action, actor);

		int repeatState = attackData.Repeat;
		if (repeatState > 0)
		{
			switch (repeatState)
			{
				case 1:
				{
					action.NextDamageTime = gameTime + attackData.DamageDelay[difficulty];
				}
				case 2:
				{
					if (action.RepeatIndex >= attackData.RepeatTimers.Length)
					{
						action.NextDamageTime = -1.0;
					}
					else
					{
						float next = attackData.RepeatTimers.Get(action.RepeatIndex);
						action.NextDamageTime = next + gameTime;
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

static void RegisterForward(SF2_ChaserAttackAction_ForwardBased action, SF2_ChaserEntity actor)
{
	Call_StartForward(g_OnBossAttackedFwd);
	Call_PushCell(actor.Controller.Index);
	Call_PushCell(action.AttackIndex);
	Call_Finish();
}

static void OnAnimationEvent(SF2_ChaserAttackAction_ForwardBased action, SF2_ChaserEntity actor, int event)
{
	if (event == 0)
	{
		return;
	}

	SF2NPC_Chaser controller = actor.Controller;
	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	SF2ChaserBossProfileAttackData attackData;
	data.GetAttack(action.GetAttackName(), attackData);

	if (event == attackData.EventNumber)
	{
		RegisterForward(action, actor);
	}
}
