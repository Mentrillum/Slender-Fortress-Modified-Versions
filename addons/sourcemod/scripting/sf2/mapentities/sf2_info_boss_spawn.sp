// sf2_info_boss_spawn

static const char g_EntityClassname[] = "sf2_info_boss_spawn"; // The custom classname of the entity. Should be prefixed with "sf2_"

static CEntityFactory g_EntityFactory;

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2BossSpawnEntity < SF2SpawnPointBaseEntity
{
	public SF2BossSpawnEntity(int entIndex) { return view_as<SF2BossSpawnEntity>(SF2SpawnPointBaseEntity(entIndex)); }

	public bool IsValid()
	{
		if (!CBaseEntity(this.index).IsValid())
		{
			return false;
		}

		return CEntityFactory.GetFactoryOfEntity(this.index) == g_EntityFactory;
	}

	public void GetBossProfile(char[] sBuffer, int iBufferLen)
	{
		this.GetPropString(Prop_Data, "sf2_szBossProfile", sBuffer, iBufferLen);
	}

	public void SetBossProfile(const char[] sBuffer)
	{
		this.SetPropString(Prop_Data, "sf2_szBossProfile", sBuffer);
	}

	property int MaxBosses
	{
		public get() { return this.GetProp(Prop_Data, "sf2_iMaxBosses"); }
		public set(int value) { this.SetProp(Prop_Data, "sf2_iMaxBosses", value); }
	}

	public void Spawn()
	{
		char targetProfile[SF2_MAX_PROFILE_NAME_LENGTH];
		this.GetBossProfile(targetProfile, sizeof(targetProfile));
		if (targetProfile[0] == '\0')
		{
			PrintToServer("%s tried to spawn with blank profile", g_EntityClassname);
			return;
		}

		char profile[SF2_MAX_PROFILE_NAME_LENGTH];

		float pos[3]; float ang[3];
		this.GetAbsOrigin(pos);
		this.GetAbsAngles(ang);

		int count = 0;
		int maxCount = this.MaxBosses;

		for (int bossIndex = 0; bossIndex < MAX_BOSSES && count < maxCount; bossIndex++)
		{
			if (!NPCIsValid(bossIndex))
			{
				continue;
			}

			NPCGetProfile(bossIndex, profile, sizeof(profile));
			if (strcmp(profile, targetProfile) == 0)
			{
				SpawnSlender(view_as<SF2NPC_BaseNPC>(bossIndex), pos);
				count++;

				int bossEntIndex = NPCGetEntIndex(bossIndex);
				if (IsValidEntity(bossEntIndex))
				{
					TeleportEntity(bossEntIndex, NULL_VECTOR, ang, NULL_VECTOR);
					this.FireOutput("OnSpawn", bossEntIndex);
				}
			}
		}
	}

	public static void Initialize()
	{
		Initialize();
	}
}

static void Initialize()
{
	g_EntityFactory = new CEntityFactory(g_EntityClassname, OnCreated, OnRemoved);
	g_EntityFactory.DeriveFromFactory(SF2BossSpawnEntity.GetBaseFactory());
	g_EntityFactory.BeginDataMapDesc()
		.DefineStringField("sf2_szBossProfile", _, "profile")
		.DefineIntField("sf2_iMaxBosses", _, "max")
		.DefineInputFunc("Spawn", InputFuncValueType_Void, InputSpawn)
		.DefineInputFunc("SetBossProfile", InputFuncValueType_String, InputSetBossProfile)
		.EndDataMapDesc();
	g_EntityFactory.Install();
}

static void OnCreated(int entity)
{
	SF2BossSpawnEntity thisEnt = SF2BossSpawnEntity(entity);
	thisEnt.SetBossProfile("");
	thisEnt.MaxBosses = 1;
}

static void OnRemoved(int entity)
{
}

static void InputSpawn(int entity, int activator, int caller)
{
	SF2BossSpawnEntity thisEnt = SF2BossSpawnEntity(entity);
	thisEnt.Spawn();
}

static void InputSetBossProfile(int entity, int activator, int caller, const char[] value)
{
	SF2BossSpawnEntity(entity).SetBossProfile(value);
}