#pragma semicolon 1
#pragma newdecls required

methodmap BossProfileSentryTrap < BossProfileBaseTrap
{
	public int GetLevel(int difficulty)
	{
		int val = this.GetDifficultyInt("level", difficulty, 0);
		if (val < 0)
		{
			val = 0;
		}
		if (val > 3)
		{
			val = 3;
		}
		return val;
	}

	public int GetHealth(int difficulty)
	{
		int def = 100;
		switch (this.GetLevel(difficulty))
		{
			case 0:
			{
				def = 100;
			}

			case 1:
			{
				def = 150;
			}

			case 2:
			{
				def = 180;
			}

			case 3:
			{
				def = 216;
			}
		}
		return this.GetDifficultyInt("health", difficulty, def);
	}
}

static CEntityFactory g_Factory;

methodmap SF2_SentryTrap < CBaseCombatCharacter
{
	public SF2_SentryTrap(int entity)
	{
		return view_as<SF2_SentryTrap>(entity);
	}

	public bool IsValid()
	{
		if (!CBaseCombatCharacter(this.index).IsValid())
		{
			return false;
		}

		return CEntityFactory.GetFactoryOfEntity(this.index) == g_Factory;
	}

	public static void Initialize()
	{
		g_Factory = new CEntityFactory("sf2_trap_sentry", OnCreate, OnRemove);
		g_Factory.DeriveFromClass("obj_sentrygun");
		g_Factory.BeginDataMapDesc()
			.DefineIntField("m_Type")
			.DefineStringField("m_Name")
			.DefineIntField("m_BossUniqueID")
			.DefineFloatField("m_TimeUntilRemove")
			.DefineIntField("m_OldState")
		.EndDataMapDesc();
		g_Factory.Install();
	}

	property SF2BossTrapType Type
	{
		public get()
		{
			return view_as<SF2BossTrapType>(this.GetProp(Prop_Data, "m_Type"));
		}

		public set(SF2BossTrapType value)
		{
			this.SetProp(Prop_Data, "m_Type", value);
		}
	}

	public char[] GetName()
	{
		char name[64];
		this.GetPropString(Prop_Data, "m_Name", name, sizeof(name));
		return name;
	}

	public void SetName(const char[] name)
	{
		this.SetPropString(Prop_Data, "m_Name", name);
	}

	property SF2NPC_Chaser Controller
	{
		public get()
		{
			return SF2NPC_Chaser(NPCGetFromUniqueID(this.GetProp(Prop_Data, "m_BossUniqueID")));
		}

		public set(SF2NPC_Chaser value)
		{
			this.SetProp(Prop_Data, "m_BossUniqueID", value.UniqueID);
		}
	}

	property float TimeUntilRemove
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_TimeUntilRemove");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_TimeUntilRemove", value);
		}
	}

	property int Health
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_iHealth");
		}

		public set(int value)
		{
			this.SetProp(Prop_Data, "m_iHealth", value);
		}
	}

	property int MaxHealth
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_iMaxHealth");
		}

		public set(int value)
		{
			this.SetProp(Prop_Data, "m_iMaxHealth", value);
		}
	}

	property int State
	{
		public get()
		{
			return this.GetProp(Prop_Send, "m_iState");
		}

		public set(int value)
		{
			this.SetProp(Prop_Send, "m_iState", value);
		}
	}

	property int OldState
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_OldState");
		}

		public set(int value)
		{
			this.SetProp(Prop_Data, "m_OldState", value);
		}
	}
}

static void OnCreate(SF2_SentryTrap entity)
{
	g_TrapEntityCount++;
	CreateTimer(0.1, Timer_Think, EntIndexToEntRef(entity.index), TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
}

static void OnRemove(SF2_SentryTrap entity)
{
	g_TrapEntityCount--;
}

static Action Timer_Think(Handle timer, int ref)
{
	int entity = EntRefToEntIndex(ref);
	if (!entity || entity == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	float gameTime = GetGameTime();
	SF2_SentryTrap trap = SF2_SentryTrap(entity);
	SF2NPC_Chaser controller = trap.Controller;
	int difficulty = controller.Difficulty;
	if (trap.TimeUntilRemove < gameTime || !controller.IsValid())
	{
		SDKHooks_TakeDamage(trap.index, 0, 0, trap.Health * 4.0);
		return Plugin_Stop;
	}

	if (trap.OldState != trap.State && trap.State == 3)
	{
		BossProfileSentryTrap data = view_as<BossProfileSentryTrap>(controller.GetProfileData().GetTrapData().GetTrapFromName(trap.GetName()));
		SetVariantInt(data.GetHealth(difficulty));
		trap.AcceptInput("SetHealth");
	}

	trap.OldState = trap.State;
	return Plugin_Continue;
}