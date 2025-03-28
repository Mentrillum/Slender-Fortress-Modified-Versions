#pragma semicolon 1
#pragma newdecls required

static CEntityFactory g_Factory;

enum SF2BossTrapType
{
	SF2BossTrap_Invalid = -1,
	SF2BossTrap_BearTrap = 0,
	SF2BossTrap_Explosive = 1,
	SF2BossTrap_Sentry = 2,
	SF2BossTrap_Custom,
	SF2BossTrap_Max
};

methodmap BossProfileBaseTrap < ProfileObject
{
	public SF2BossTrapType GetTrapType()
	{
		char type[64];
		this.GetString("type", type, sizeof(type));

		if (strcmp(type, "bear_trap", false) == 0)
		{
			return SF2BossTrap_BearTrap;
		}
		else if (strcmp(type, "explosive_trap", false) == 0)
		{
			return SF2BossTrap_Explosive;
		}
		else if (strcmp(type, "sentry", false) == 0)
		{
			return SF2BossTrap_Sentry;
		}

		return SF2BossTrap_Invalid;
	}

	public float GetWeight(int difficulty)
	{
		return this.GetDifficultyFloat("weight", difficulty, 1.0);
	}

	public float GetTimeUntilRemoved(int difficulty)
	{
		return this.GetDifficultyFloat("time_until_removed", difficulty, 30.0);
	}

	public void GetModel(int difficulty, char[] buffer, int bufferSize)
	{
		this.GetDifficultyString("model", difficulty, buffer, bufferSize);
		ReplaceString(buffer, bufferSize, "\\", "/", false);
	}

	public ProfileSound GetSpawnSounds()
	{
		ProfileObject obj = this.GetSection("sounds");
		if (obj != null)
		{
			return view_as<ProfileSound>(obj.GetSection("spawn"));
		}
		return null;
	}

	public float GetDamage(int difficulty)
	{
		float def = 10.0;
		switch (this.GetTrapType())
		{
			case SF2BossTrap_BearTrap:
			{
				def = 10.0;
			}

			case SF2BossTrap_Explosive:
			{
				def = 50.0;
			}

			case SF2BossTrap_Sentry:
			{
				def = 8.0;
			}
		}

		return this.GetDifficultyFloat("damage", difficulty, def);
	}

	public KeyMap_Array GetDamageEffects()
	{
		return this.GetArray("apply_conditions");
	}

	public void ApplyDamageEffects(CBaseCombatCharacter player, int difficulty, CBaseAnimating trap = view_as<CBaseAnimating>(-1), SF2NPC_Chaser parentController = SF2_INVALID_NPC_CHASER)
	{
		if (this.GetDamageEffects() == null)
		{
			return;
		}

		if (!player.IsValid())
		{
			return;
		}

		for (int i = 0; i < this.GetDamageEffects().Length; i++)
		{
			KeyMap obj = this.GetDamageEffects().GetSection(i);
			if (obj == null)
			{
				continue;
			}
			BossProfileDamageEffect effect = view_as<BossProfileDamageEffect>(obj);
			effect.Apply(player, difficulty, trap, parentController);
		}
	}

	public void Precache()
	{
		this.ConvertSectionsSectionToArray("apply_conditions");

		char path[PLATFORM_MAX_PATH];
		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.GetModel(i, path, sizeof(path));
			if (path[0] != '\0')
			{
				PrecacheModel2(path, _, _, g_FileCheckConVar.BoolValue);
			}
		}

		if (this.GetSpawnSounds() != null)
		{
			this.GetSpawnSounds().Precache();
		}

		if (this.GetDamageEffects() != null)
		{
			for (int i = 0; i < this.GetDamageEffects().Length; i++)
			{
				BossProfileDamageEffect effect = view_as<BossProfileDamageEffect>(this.GetDamageEffects().GetSection(i));
				if (effect != null)
				{
					effect.Precache();
				}
			}
		}

		switch (this.GetTrapType())
		{
			case SF2BossTrap_BearTrap:
			{
				view_as<BossProfileBearTrap>(this).Precache();
			}
		}
	}
}

methodmap SF2_BaseTrap < CBaseAnimating
{
	public SF2_BaseTrap(int entity)
	{
		return view_as<SF2_BaseTrap>(entity);
	}

	public bool IsValid()
	{
		if (!CBaseAnimating(this.index).IsValid())
		{
			return false;
		}

		return CEntityFactory.GetFactoryOfEntity(this.index) == g_Factory;
	}

	public static void Initialize()
	{
		g_Factory = new CEntityFactory("sf2_trap_base", OnCreate, OnRemove);
		g_Factory.IsAbstract = true;
		g_Factory.DeriveFromClass("prop_dynamic_override");
		g_Factory.BeginDataMapDesc()
			.DefineIntField("m_Type")
			.DefineStringField("m_Name")
			.DefineIntField("m_BossUniqueID")
			.DefineFloatField("m_TimeUntilRemove")
		.EndDataMapDesc();
		g_Factory.Install();
	}

	public static CEntityFactory GetFactory()
	{
		return g_Factory;
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
}

static void OnCreate(SF2_BaseTrap entity)
{
	g_TrapEntityCount++;
	CreateTimer(0.1, Timer_Think, EntIndexToEntRef(entity.index), TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
}

static void OnRemove(SF2_BaseTrap entity)
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
	SF2_BaseTrap trap = SF2_BaseTrap(entity);
	if (trap.TimeUntilRemove < gameTime || !trap.Controller.IsValid())
	{
		RemoveEntity(trap.index);
		return Plugin_Stop;
	}
	return Plugin_Continue;
}