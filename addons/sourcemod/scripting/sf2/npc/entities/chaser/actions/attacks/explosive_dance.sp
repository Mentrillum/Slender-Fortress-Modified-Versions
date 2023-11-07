#pragma semicolon 1

static char g_ExplosionSounds[][] =
{
	")weapons/explode1.wav",
	")weapons/explode2.wav",
	")weapons/explode3.wav"
};

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserAttackAction_ExplosiveDance < NextBotAction
{
	public SF2_ChaserAttackAction_ExplosiveDance(int attackIndex, const char[] attackName, float damageDelay)
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_AttackExplosiveDance");
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetEventCallback(EventResponderType_OnAnimationEvent, OnAnimationEvent);
			g_Factory.BeginDataMapDesc()
				.DefineIntField("m_AttackIndex")
				.DefineStringField("m_AttackName")
				.DefineFloatField("m_NextDamageTime")
				.DefineIntField("m_ExplosionCount")
				.EndDataMapDesc();
		}
		SF2_ChaserAttackAction_ExplosiveDance action = view_as<SF2_ChaserAttackAction_ExplosiveDance>(g_Factory.Create());

		action.NextDamageTime = damageDelay;
		action.AttackIndex = attackIndex;
		action.SetAttackName(attackName);
		action.ExplosionCount = 0;

		return action;
	}

	public static void Initialize()
	{
		g_OnChaserGetAttackActionPFwd.AddFunction(null, OnChaserGetAttackAction);
		g_OnGamemodeStartPFwd.AddFunction(null, OnGamemodeStart);
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

	property int ExplosionCount
	{
		public get()
		{
			return this.GetData("m_ExplosionCount");
		}

		public set(int value)
		{
			this.SetData("m_ExplosionCount", value);
		}
	}
}

static void OnGamemodeStart()
{
	for (int i = 0; i < sizeof(g_ExplosionSounds); i++)
	{
		PrecacheSound(g_ExplosionSounds[i], true);
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

	if (attackData.Type != SF2BossAttackType_ExplosiveDance)
	{
		return Plugin_Continue;
	}

	result = SF2_ChaserAttackAction_ExplosiveDance(attackData.Index, attackData.Name, attackData.DamageDelay[difficulty] + GetGameTime());
	return Plugin_Changed;
}

static int OnStart(SF2_ChaserAttackAction_ExplosiveDance action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	return action.Continue();
}

static int Update(SF2_ChaserAttackAction_ExplosiveDance action, SF2_ChaserEntity actor, float interval)
{
	if (action.Parent == NULL_ACTION)
	{
		return action.Done("No longer explosion dancing");
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

	float gameTime = GetGameTime();

	if (action.NextDamageTime >= 0.0 && gameTime > action.NextDamageTime && attackData.EventNumber == -1)
	{
		DoExplosion(action, actor);
	}
	return action.Continue();
}

static void DoExplosion(SF2_ChaserAttackAction_ExplosiveDance action, SF2_ChaserEntity actor)
{
	SF2NPC_Chaser controller = actor.Controller;

	int difficulty = controller.Difficulty;

	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	SF2ChaserBossProfileAttackData attackData;
	data.GetAttack(action.GetAttackName(), attackData);
	float damage = attackData.Damage[difficulty];
	float radius = attackData.ExplosiveDanceRadius[difficulty];
	if (SF_SpecialRound(SPECIALROUND_TINYBOSSES))
	{
		damage *= 0.5;
	}

	float worldPos[3], myEyeAng[3];
	actor.WorldSpaceCenter(worldPos);
	actor.GetAbsAngles(myEyeAng);

	action.ExplosionCount++;
	if (action.ExplosionCount > 35)
	{
		action.NextDamageTime = -1.0;
		return;
	}

	float explosionPos[3];

	explosionPos = worldPos;
	explosionPos[0] = worldPos[0] + GetRandomFloat(-350.0, 350.0);
	explosionPos[1] = worldPos[1] + GetRandomFloat(-350.0, 350.0);
	Explode(explosionPos, damage, radius, actor.index);
	EmitSoundToAll(g_ExplosionSounds[GetRandomInt(0, sizeof(g_ExplosionSounds) - 1)], actor.index, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);

	action.NextDamageTime = GetGameTime() + 0.13;
}

static void OnAnimationEvent(SF2_ChaserAttackAction_ExplosiveDance action, SF2_ChaserEntity actor, int event)
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
		DoExplosion(action, actor);
	}
}